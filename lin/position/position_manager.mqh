//+------------------------------------------------------------------+
//|                                              PositionManager.mqh |
//|                                                          linbirg |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "linbirg"
#property link "https://www.mql5.com"
#property strict
//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
// #define MacrosHello   "Hello, world!"
// #define MacrosYear    2010
//+------------------------------------------------------------------+
//| DLL imports                                                      |
//+------------------------------------------------------------------+
// #import "user32.dll"
//   int      SendMessageA(int hWnd,int Msg,int wParam,int lParam);
// #import "my_expert.dll"
//   int      ExpertRecalculate(int wParam,int lParam);
// #import
//+------------------------------------------------------------------+
//| EX5 imports                                                      |
//+------------------------------------------------------------------+
// #import "stdlib.ex5"
//   string ErrorDescription(int error_code);
// #import
//+------------------------------------------------------------------+

//Changelog.2015.10.02 增加如果连续亏损太多则一个礼拜不开仓的逻辑

#include "../orders/order_helper.mqh"

// input double MaximumRisk = 0.08;
// input int DecreaseFactor = 4;

// //下单手数的最小单位，即小数点后面几位小数.number of digits after point
// input int digits = 2;

// input double Lots = 0.03;

// input int MaxContinueLoss = 1;
// input int PeriodBreaks = 16;

// input int MaxLossCountForBreakWeek = 4;
// input int PeriodBreaksOfWeek = 672; //672*15=1week

// double LotsOptimized()
// {
//     double lot = Lots;

//     //--- select lot size
//     lot = NormalizeDouble(AccountFreeMargin() * MaximumRisk / 1000.0, digits);

//     lot = DecreaseLots(lot);
//     Print("LotsOptimized:Decreased lots ", lot);

//     if (lot < 0.01)
//         lot = 0.01;
//     return (lot);
// }

// double DecreaseLots(double lots)
// {
//     return DecreaseLotsAsc(lots);
// }

// //如果赢利会增加开仓数量
// double DecreaseLotsDesc(double lots)
// {
//     double decreatedLots = lots;
//     int losses = 0;

//     if (DecreaseFactor <= 0)
//         return decreatedLots;

//     losses = maxLostHistoryOrders();
//     if (losses > 1)
//     {
//         decreatedLots = decreatedLots - decreatedLots * (losses % DecreaseFactor) / DecreaseFactor;
//         decreatedLots = NormalizeDouble(decreatedLots, digits);
//     }

//     return decreatedLots;
// }

// /**
//    函数逻辑是：如果连续亏损，则增加开仓数量。赢利之后减少开仓数量。
//    该函数是基于连续盈利次数很少的事实。行情总是在大涨或大跌之后进入震荡。震荡之后趋势开始明显。
// */
// double DecreaseLotsAsc(double lots)
// {
//     //double decreatedLots = lots;
//     int losses = 0;

//     if (DecreaseFactor <= 0)
//         return lots;

//     losses = maxLostHistoryOrders();

//     double mid = losses % DecreaseFactor + 1; //

//     lots = lots * mid / DecreaseFactor;
//     lots = NormalizeDouble(lots, digits);

//     return lots;
// }

// bool is_order_pass_a_week()
// {
//     //Print("next week for open  ",TimeToStr(OrderCloseTime()+PeriodBreaksOfWeek*PeriodSeconds()));
//     return Time[0] >= OrderCloseTime() + PeriodBreaksOfWeek * PeriodSeconds();
// }

// //检查上一笔是否亏损，如果亏损，一段时间内不再开仓。
// bool isLastLostAndPassed()
// {
//     int losses = maxLostHistoryOrders();
//     if (losses < MaxContinueLoss)
//     {
//         Print("isLastLostAndPassed:maxLostHistoryOrders:", maxLostHistoryOrders());
//         return true; //如果连续亏损订单少于2笔，可以下单。
//     }

//     if (losses >= MaxLossCountForBreakWeek)
//     {
//         for (int i = 0; i < OrdersHistoryTotal(); i++)
//         {
//             if (SelectHistoryOrderByPos(i))
//             {
//                 //
//                 if (OrderProfit() < 0)
//                 {
//                     if (is_order_pass_a_week())
//                     {
//                         Print("isLastLostAndPassed:亏损订单已经过去一周");
//                         return true;
//                     }
//                     else
//                     {
//                         Print("isLastLostAndPassed:连续亏损次数太多，1个星期不再开仓");
//                         return false;
//                     }
//                 }
//             }
//         }

//         Print("isLastLostAndPassed:连续亏损次数太多，1个星期不再开仓");
//         return false;
//     }

//     for (int i = OrdersHistoryTotal() - 1; i >= 0; i--)
//     {
//         if (!OrderSelect(i, SELECT_BY_POS, MODE_HISTORY))
//         {
//             break;
//         }

//         if (OrderSymbol() != Symbol())
//             continue;
//         if (OrderProfit() < 0)
//         {
//             Print("isLastLostAndPassed:上笔订单亏损");
//             //OrderPrint();
//             Print("PeriodSeconds:", PeriodSeconds(), " Period:", Period());
//             Print("OrderCloseTime:", TimeToStr(OrderCloseTime(), TIME_DATE | TIME_SECONDS), " next open time after:", TimeToStr(OrderCloseTime() + PeriodBreaks * PeriodSeconds(), TIME_DATE | TIME_SECONDS));
//             if (Time[0] >= OrderCloseTime() + PeriodBreaks * PeriodSeconds())
//             {
//                 Print("isLastLostAndPassed:亏损订单已经过去很久,可以开仓.");
//                 return true;
//             }
//             else
//             {
//                 Print("isLastLostAndPassed:亏损订单距离当前很近，不再开仓.");
//                 break;
//             }
//         }
//     }

//     return false;
// }

// bool isLongPosition()
// {
//     return OrdersBuyOrSell() == OP_BUY;
// }

// bool isShortPosition()
// {
//     return OrdersBuyOrSell() == OP_SELL;
// }

/**
 * 持仓管理类
 * 
*/
class PositionManager
{
  private:
    double m_default_lots;
    double m_maximumRisk;
    int m_decreaseFactor;
    double m_take_pofit;
    int m_digits;
    datetime m_openTime;

    int m_max_break_losses;

    OrderHelper m_orderHelper;

  public:
    PositionManager(/* args */);
    ~PositionManager();

  public:
    void open_long();
    void open_short();
    int get_curr_orders();
    int get_curr_long_positions();
    int get_curr_short_positions();

    void close_all_long_positions();
    void close_all_short_positions();

  public:
    bool is_last_lost_and_passed();
    bool is_current_opened();
    bool is_hisorder_pass_break();

  private:
    bool has_hisorder_loss_and_pass_a_week();
    bool has_hisorder_loss_and_pass_break();

  private:
    double get_optimized_lots();
    double calc_decreased_lots_by_asc(double lots);
    void open_order(bool isBuy);
    bool has_enough_margin();
    double get_lots_by_atr();
};

PositionManager::PositionManager(/* args */)
{
    m_default_lots = 0.03;
    m_take_pofit = 20000; // 默认止盈点数。基本不止盈。
    m_digits = 2;
    // m_openTime = __DATETIME__;
    m_openTime = Time[0];
    m_maximumRisk = 0.04;
    m_decreaseFactor = 8;

    m_max_break_losses = 2;
}

PositionManager::~PositionManager()
{
}

bool PositionManager::has_enough_margin()
{
    // AccountFreeMargin必须大于最小的开仓手数所需保证金。
    return AccountFreeMargin() > 1000 * 0.01;
}

double PositionManager::get_optimized_lots()
{
    double lot = m_default_lots;

    //--- select lot size
    lot = NormalizeDouble(AccountFreeMargin() * m_maximumRisk / 1000.0, m_digits);

    lot = calc_decreased_lots_by_asc(lot);
    Print("LotsOptimized:Decreased lots ", lot);

    if (lot < 0.01)
        lot = 0.01;

    return lot;
}

/**
   函数逻辑是：如果连续亏损，则增加开仓数量。赢利之后减少开仓数量。
   该函数是基于连续盈利次数很少的事实。行情总是在大涨或大跌之后进入震荡。震荡之后趋势开始明显。
*/
double PositionManager::calc_decreased_lots_by_asc(double lots)
{
    //double decreatedLots = lots;
    int losses = 0;

    if (m_decreaseFactor <= 0)
        return lots;

    losses = m_orderHelper.maxLostHistoryOrders();

    double mid = losses % m_decreaseFactor + 1; //

    lots = lots * mid / m_decreaseFactor;
    lots = NormalizeDouble(lots, m_digits);

    return lots;
}

/**
 * 根据波动大小来调整开仓大小。（待调试）
*/
double PositionManager::get_lots_by_atr()
{
    double atr15 = iATR(NULL, PERIOD_M15, 60, 0);
    double lot = NormalizeDouble(AccountFreeMargin() * m_maximumRisk / ((atr15 / Point) * 10), m_digits);
    if (lot < 0.01)
        lot = 0.01;

    return lot;
}

/**
 * 只支持买单或者卖单
 * 
*/
void PositionManager::open_order(bool isBuy)
{
    int buy_or_sell = OP_BUY;
    double price = Ask;
    int flag = 1;
    color order_col = Green;
    if (!isBuy)
    {
        buy_or_sell = OP_SELL;
        price = Bid;
        flag = -1;
        order_col = Red;
    }

    RefreshRates();
    int ticket = OrderSend(Symbol(), buy_or_sell, get_optimized_lots(), price, 5, 0, price + flag * m_take_pofit * Point, "linbirg strategy", 16384, 0, order_col);
    if (ticket > 0)
    {
        if (OrderSelect(ticket, SELECT_BY_TICKET, MODE_TRADES))
        {
            Print("BUY order opened : ", OrderOpenPrice());
            m_openTime = Time[0];
            return;
        }
    }

    Print("Error opening BUY order : ", GetLastError());
}

bool PositionManager::is_current_opened()
{
    Print("Time[0]:" + Time[0] + " m_openTime:" + m_openTime);
    return Time[0] <= m_openTime;
}

void PositionManager::open_long()
{
    if (!has_enough_margin())
    {
        Print("可用保证金不足. Free Margin = ", AccountFreeMargin());
        return;
    }

    if (is_current_opened())
    {
        Print("open_long：当前周期已经开过仓。");
        return;
    }

    open_order(true);
}

void PositionManager::open_short()
{
    if (!has_enough_margin())
    {
        Print("可用保证金不足. Free Margin = ", AccountFreeMargin());
        return;
    }

    if (is_current_opened())
    {
        Print("open_short：当前周期已经开过仓。");
        return;
    }
    open_order(false);
}

int PositionManager::get_curr_orders()
{
    return m_orderHelper.get_curr_orders();
}

int PositionManager::get_curr_long_positions()
{
    return m_orderHelper.get_curr_long_orders();
}

int PositionManager::get_curr_short_positions()
{
    return m_orderHelper.get_curr_short_orders();
}

void PositionManager::close_all_long_positions()
{
    m_orderHelper.close_all_long_orders();
}

void PositionManager::close_all_short_positions()
{
    m_orderHelper.close_all_short_orders();
}

bool PositionManager::has_hisorder_loss_and_pass_a_week()
{
    for (int i = 0; i < OrdersHistoryTotal(); i++)
    {
        if (m_orderHelper.select_his_order_by_index(i))
        {
            //
            if (OrderProfit() < 0)
            {
                if (m_orderHelper.is_hisorder_pass_a_week())
                {
                    Print("has_hisorder_loss_and_pass_a_week:亏损订单已经过去一周");
                    return true;
                }

                Print("has_hisorder_loss_and_pass_a_week:亏损订单没有过去一周。");
                return false;
            }
        }
        // else
        // {
        //     Print("has_hisorder_loss_and_pass_a_week：选择历史订单失败。");
        //     // return false;
        //     continue;
        // }
    }

    return true; // 没有订单，或者没有亏损订单，或者亏损订单都过去一周。
}

/**
 * 历史订单过去一段时间（4H）
*/
bool PositionManager::is_hisorder_pass_break()
{
    int cnt = OrdersHistoryTotal();

    if (cnt <= 0)
    {
        Print("is_hisorder_pass_break:没有历史订单。");
        return true;
    }

    if (!m_orderHelper.select_his_latest_order())
    {
        Print("is_hisorder_pass_break:无法选中或者可能没有历史订单。");
        return true;
    }

    return m_orderHelper.is_hisorder_pass_a_break();
}

bool PositionManager::has_hisorder_loss_and_pass_break()
{
    for (int i = OrdersHistoryTotal() - 1; i >= 0; i--)
    {
        if (!OrderSelect(i, SELECT_BY_POS, MODE_HISTORY))
        {
            Print("has_hisorder_loss_and_pass_break：选择历史订单失败。");
            return false;
        }

        if (OrderSymbol() != Symbol())
            continue;
        if (OrderProfit() < 0)
        {
            if (m_orderHelper.is_hisorder_pass_a_break())
            {
                Print("has_hisorder_loss_and_pass_break:亏损订单已经过去很久,可以开仓.");
                return true;
            }

            Print("has_hisorder_loss_and_pass_break:亏损订单距离当前很近，不再开仓.");
            return false;
        }
    }

    return true; // 没有历史订单、或者没有亏损订单，返回true。
}

bool PositionManager::is_last_lost_and_passed()
{
    int losses = m_orderHelper.maxLostHistoryOrders();

    if (losses == 0)
    {
        Print("is_last_lost_and_passed:上笔订单没有亏损，可以开仓.");
        return true;
    }

    if (losses >= m_max_break_losses)
    {
        // 连续亏损次数太多，暂停一周。一周后才能开仓。
        return has_hisorder_loss_and_pass_a_week();
    }

    return has_hisorder_loss_and_pass_break();
}
