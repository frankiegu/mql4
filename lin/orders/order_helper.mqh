/**
 * 
 * 后续改造会删除全局函数，都改为类函数。
*/

class OrderHelper
{
private:
  int m_PeriodBreaksOfWeek;
  int m_PeriodBreaks;

public:
  OrderHelper(/* args */);
  ~OrderHelper();

public:
  int maxLostHistoryOrders();
  double maxLostAmount();

  bool select_his_order_by_index(int pos);
  bool select_his_latest_order();
  bool select_trade_by_index(int pos);
  bool select_trade_latest_order();

  int get_curr_orders();
  int get_curr_long_orders();
  int get_curr_short_orders();

  double get_latest_open_price();
  double get_latest_stop();

  void close_all_long_orders();
  void close_all_short_orders();

  bool is_hisorder_pass_a_week();
  bool is_hisorder_pass(int num_periods);
  bool is_hisorder_pass_a_break();

  // 根据持仓方向计算收益
  double calc_profit_at(double price);
  double calc_profit_at_by_direct(double price);
  double calc_profit_stop_lost_btw_middle();

  bool modify_stop_lost_for_short(double stop_lost);
  bool modify_stop_lost_for_long(double stop_lost);

private:
  bool modify_stop_lost(double stopLost);
};

OrderHelper::OrderHelper(/* args */)
{
  m_PeriodBreaksOfWeek = 672; //672*15=1week;改为停3天不交易。
  m_PeriodBreaks = 16;
}

OrderHelper::~OrderHelper()
{
}

bool OrderHelper::is_hisorder_pass(int num_periods)
{
  // OrderPrint();
  Print("is_hisorder_pass:Time[0]:" + Time[0] + " OrderCloseTime:" + OrderCloseTime() + " ticket:" + OrderTicket());
  return Time[0] >= OrderCloseTime() + num_periods * PeriodSeconds(PERIOD_M15);
}

bool OrderHelper::is_hisorder_pass_a_week()
{
  // return Time[0] >= OrderCloseTime() + m_PeriodBreaksOfWeek * PeriodSeconds();
  return is_hisorder_pass(m_PeriodBreaksOfWeek);
}

bool OrderHelper::is_hisorder_pass_a_break()
{
  return is_hisorder_pass(m_PeriodBreaks);
}

//pos: 0表示最近的订单。
bool OrderHelper::select_trade_by_index(int pos)
{
  if (!OrderSelect(OrdersTotal() - 1 - pos, SELECT_BY_POS, MODE_TRADES))
    return false;

  if (OrderSymbol() != Symbol())
    return false;

  // 只看买单和卖单，对于限价单等值是> OP_SELL的不考虑
  if (OrderType() > OP_SELL)
    return false;

  return true;
}

//pos: 0表示最近的订单。
// @deprecated replaced by select_trade_by_index
// bool SelectTradeOrderByPos(int pos)
// {
//   if (!OrderSelect(OrdersTotal() - 1 - pos, SELECT_BY_POS, MODE_TRADES))
//     return false;

//   if (OrderSymbol() != Symbol())
//     return false;

//   // 只看买单和卖单，对于限价单等值是> OP_SELL的不考虑
//   if (OrderType() > OP_SELL)
//     return false;
//   return true;
// }

//pos: 0表示最近的订单。
bool OrderHelper::select_his_order_by_index(int pos)
{
  if (!OrderSelect(OrdersHistoryTotal() - 1 - pos, SELECT_BY_POS, MODE_HISTORY))
    return false;

  if (OrderSymbol() != Symbol())
    return false;

  // 只看买单和卖单，对于限价单等值是> OP_SELL的不考虑
  if (OrderType() > OP_SELL)
    return false;

  return true;
}

//pos: 0表示最近的订单。
// bool SelectHistoryOrderByPos(int pos)
// {
//   if (!OrderSelect(OrdersHistoryTotal() - 1 - pos, SELECT_BY_POS, MODE_HISTORY))
//     return false;

//   if (OrderSymbol() != Symbol())
//     return false;

//   // 只看买单和卖单，对于限价单等值是> OP_SELL的不考虑
//   if (OrderType() > OP_SELL)
//     return false;

//   return true;
// }

// 获取历史订单的最大连续亏损数
int OrderHelper::maxLostHistoryOrders()
{
  int orders = OrdersHistoryTotal(); // 历史订单总数
  int losses = 0;                    // 最大连续亏损数

  for (int i = 0; i < orders; i++)
  {
    /*if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==false)
      {
         Print("Error in history!");
         break;
      }
      if(OrderSymbol()!=Symbol() || OrderType()>OP_SELL)
        continue;
       */
    if (select_his_order_by_index(i))
    {
      if (OrderProfit() > 0)
        break;
      if (OrderProfit() < 0)
        losses++;
    }
  }

  Print("maxLostHistoryOrders:", losses);

  return losses;
}

// 获取历史订单的最大连续亏损数
// int maxLostHistoryOrders()
// {
//   int orders = OrdersHistoryTotal(); // 历史订单总数
//   int losses = 0;                    // 最大连续亏损数

//   for (int i = 0; i < orders; i++)
//   {
//     /*if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==false)
//       {
//          Print("Error in history!");
//          break;
//       }
//       if(OrderSymbol()!=Symbol() || OrderType()>OP_SELL)
//         continue;
//        */
//     if (SelectHistoryOrderByPos(i))
//     {
//       if (OrderProfit() > 0)
//         break;
//       if (OrderProfit() < 0)
//         losses++;
//     }
//   }

//   Print("maxLostHistoryOrders:", losses);

//   return losses;
// }

// 获计算总收益，如果总收益为正，取0.为负，去绝对值。
double OrderHelper::maxLostAmount()
{
  int orders = OrdersHistoryTotal();
  double losses_amount = 0;

  for (int i = 0; i < orders; i++)
  {
    // if (SelectHistoryOrderByPos(i))
    if (select_his_order_by_index(i))
    {
      //if(OrderProfit()>0) losses_amount += OrderProfit();
      //if(OrderProfit()<0) losses_amount -= OrderProfit();
      losses_amount += OrderProfit();
    }
  }
  if (losses_amount >= 0)
  {
    losses_amount = 0;
  }
  else
  {
    losses_amount = -losses_amount;
  }
  Print("losses_amount:", losses_amount);
  return losses_amount;
}

bool OrderHelper::modify_stop_lost(double stopLost)
{
  if (OrderModify(OrderTicket(), OrderOpenPrice(), stopLost, OrderTakeProfit(), 0, Green))
  {
    // Print("ModifyStopLoss:修改止损成功 ticket ", OrderTicket(), " new stoplost  ", OrderStopLoss());
    OrderPrint();
    return true;
  }
  else
  {
    Print("ModifyStopLoss:修改止损失败  ticket   ", OrderTicket());
    return false;
  }
}

bool OrderHelper::modify_stop_lost_for_long(double stop_lost)
{
  Print("modify_stop_lost_for_long:尝试修改止损值为", stop_lost);
  if (OrderStopLoss() < stop_lost)
    return modify_stop_lost(stop_lost);

  return false;
}

bool OrderHelper::modify_stop_lost_for_short(double stop_lost)
{
  if (OrderStopLoss() == 0)
    return modify_stop_lost(stop_lost);

  if (OrderStopLoss() > stop_lost)
    return modify_stop_lost(stop_lost);

  return false;
}

double OrderHelper::calc_profit_at(double price)
{
  return (price - OrderOpenPrice()) * OrderLots() * 100000;
}

// 根据持仓方向计算收益
double OrderHelper::calc_profit_at_by_direct(double price)
{
  int sign = 1;

  if (OrderType() == OP_SELL)
    sign = -1;

  return sign * calc_profit_at(price);
}

double OrderHelper::calc_profit_stop_lost_btw_middle()
{
  //double denominator = Close[0]-OrderOpenPrice();
  //double numerator = OrderStopLoss()-OrderOpenPrice();

  //if(denominator <= 0)return 0;

  //return (numerator/denominator)*OrderProfit();

  // int sign = 1;

  // if (OrderType() == OP_SELL)
  //   sign = -1;

  // return sign * calc_profit_at(OrderStopLoss());
  return calc_profit_at_by_direct(OrderStopLoss());
}

//+------------------------------------------------------------------+
//| Calculate open positions                                         |
//+------------------------------------------------------------------+
// int CalculateCurrentOrders()
// {
//   int buys = 0, sells = 0;
//   //---
//   for (int i = 0; i < OrdersTotal(); i++)
//   {
//     if (SelectTradeOrderByPos(i))
//     {
//       if (OrderType() == OP_BUY)
//         buys++;
//       if (OrderType() == OP_SELL)
//         sells++;
//     }
//   }
//   //--- return orders volume
//   if (buys > 0)
//     return (buys);
//   else
//     return (-sells);
// }

int OrderHelper::get_curr_long_orders()
{
  int buys = 0;
  //---
  for (int i = 0; i < OrdersTotal(); i++)
  {
    if (select_trade_by_index(i) && (OrderType() == OP_BUY))
    {
      buys++;
    }
  }
  return buys;
}

int OrderHelper::get_curr_short_orders()
{
  int sells = 0;
  //---
  for (int i = 0; i < OrdersTotal(); i++)
  {
    if (select_trade_by_index(i) && (OrderType() == OP_SELL))
    {
      sells++;
    }
  }
  return sells;
}

int OrderHelper::get_curr_orders()
{
  return get_curr_long_orders() + get_curr_short_orders();
}

void OrderHelper::close_all_long_orders()
{
  int cnt;

  for (cnt = 0; cnt < OrdersTotal(); cnt++)
  {
    if (select_trade_by_index(0) && (OrderType() == OP_BUY))
    {
      if (OrderClose(OrderTicket(), OrderLots(), Bid, 3, Violet))
      {
        // closeTime = Time[0];
        Print("OrderClose:已经平仓.   closeTime   ", TimeToString(Time[0], TIME_DATE | TIME_SECONDS));
        cnt--;
      }
      else
      {
        Print("close_all_long_orders:OrderClose error ", GetLastError());
      }
    }
  }
}

void OrderHelper::close_all_short_orders()
{
  int cnt;

  for (cnt = 0; cnt < OrdersTotal(); cnt++)
  {
    if (select_trade_by_index(0) && (OrderType() == OP_SELL))
    {
      if (OrderClose(OrderTicket(), OrderLots(), Ask, 3, Violet))
      {
        // closeTime = Time[0];
        Print("OrderClose:已经平仓.   closeTime   ", TimeToString(Time[0], TIME_DATE | TIME_SECONDS));
        cnt--;
      }
      else
      {
        Print("close_all_short_orders:OrderClose error ", GetLastError());
      }
    }
  }
}

//判断当前的所有订单是多头还是空头。
// int OrdersBuyOrSell()
// {
//   int orders = CalculateCurrentOrders();
//   if (orders > 0)
//     return OP_BUY;

//   if (orders < 0)
//     return OP_SELL;

//   return -1; //表示不多也不空。
// }

bool OrderHelper::select_his_latest_order()
{
  for (int i = 0; i < OrdersHistoryTotal(); i++)
  {
    if (select_his_order_by_index(i))
    {
      return true;
    }
  }

  return false;
}

bool OrderHelper::select_trade_latest_order()
{
  for (int i = 0; i < OrdersTotal(); i++)
  {
    if (select_trade_by_index(i))
    {
      return true;
    }
  }

  return false;
}

// 获取最新订单的开仓价格
// 返回负值，表示选择失败。
double OrderHelper::get_latest_open_price()
{
  if (!select_trade_latest_order())
  {
    Print("get_latest_open_price:选择最新订单失败！");
    return -1; //返回负值，表示选择失败。
  }

  OrderPrint();

  return OrderOpenPrice();
}

// 获取订单的止损位
double OrderHelper::get_latest_stop()
{
  if (!select_trade_latest_order())
  {
    Print("get_latest_stop:选择最新订单失败！");
    return -1; //返回负值，表示选择失败。
  }

  OrderPrint();

  return OrderStopLoss();
}