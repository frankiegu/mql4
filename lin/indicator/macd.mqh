//+------------------------------------------------------------------+
//|                                                         macd.mqh |
//|                                                          linbirg |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "linbirg"
#property link "https://www.mql5.com"
#property strict

// #include "indicator_grp.mqh"
#include "abstract_indicator.mqh"

// input double MACDOpenLevel = 6;
// input double MACDCloseLevel = 5;
// input int CheckPeriod = 24;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
// bool CheckForGold(double MacdCurrent, double MacdPrevious, double SignalCurrent, double SignalPrevious)
// {
//   if (MacdCurrent > SignalCurrent && MacdPrevious < SignalPrevious)
//   {
//     if (MathAbs(MacdCurrent) > (MACDOpenLevel * Point))
//     {
//       //Print("检测到金叉");
//       return true;
//     }

//     Print("金叉不满足开仓的高度");
//   }

//   return false;
// }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
// bool CheckForDeath(double MacdCurrent, double MacdPrevious, double SignalCurrent, double SignalPrevious)
// {
//   if (MacdCurrent < SignalCurrent && MacdPrevious > SignalPrevious)
//   {
//     if (MathAbs(MacdCurrent) > (MACDOpenLevel * Point))
//     {
//       //Print("检测到死叉");
//       return true;
//     }
//     Print("死叉不满足开仓的高度");
//   }

//   return false;
// }

// //检查一小时内是否有0轴下的金叉
// bool CheckForGoldInHour()
// {
//   double MacdCurrent, MacdPre, SignalCurrent, SignalPre;
//   for (int i = 0; i < CheckPeriod; i++)
//   {
//     MacdCurrent = iMACD(NULL, 0, MATrendPeriodFast, MATrendPeriod, 9, PRICE_CLOSE, MODE_MAIN, i);
//     MacdPre = iMACD(NULL, 0, MATrendPeriodFast, MATrendPeriod, 9, PRICE_CLOSE, MODE_MAIN, i + 1);
//     SignalCurrent = iMACD(NULL, 0, MATrendPeriodFast, MATrendPeriod, 9, PRICE_CLOSE, MODE_SIGNAL, i);
//     SignalPre = iMACD(NULL, 0, MATrendPeriodFast, MATrendPeriod, 9, PRICE_CLOSE, MODE_SIGNAL, i + 1);

//     //在0轴下的金叉
//     if (CheckForGold(MacdCurrent, MacdPre, SignalCurrent, SignalPre) && MacdCurrent < 0)
//     {
//       Print("在0轴下的金叉");
//       return true;
//     }
//   }

//   return false;
// }

// //+------------------------------------------------------------------+
// //|                                                                  |
// //+------------------------------------------------------------------+
// bool CheckForDeathInHour()
// {
//   double MacdCurrent, MacdPre, SignalCurrent, SignalPre;
//   for (int i = 0; i < CheckPeriod; i++)
//   {
//     MacdCurrent = iMACD(NULL, 0, MATrendPeriodFast, MATrendPeriod, 9, PRICE_CLOSE, MODE_MAIN, i);
//     MacdPre = iMACD(NULL, 0, MATrendPeriodFast, MATrendPeriod, 9, PRICE_CLOSE, MODE_MAIN, i + 1);
//     SignalCurrent = iMACD(NULL, 0, MATrendPeriodFast, MATrendPeriod, 9, PRICE_CLOSE, MODE_SIGNAL, i);
//     SignalPre = iMACD(NULL, 0, MATrendPeriodFast, MATrendPeriod, 9, PRICE_CLOSE, MODE_SIGNAL, i + 1);

//     //在0轴上的死叉
//     if (CheckForDeath(MacdCurrent, MacdPre, SignalCurrent, SignalPre) && MacdCurrent > 0)
//     {
//       Print("在0轴上的死叉");
//       return true;
//     }
//   }

//   return false;
// }

// bool isDeath(int i, int timeframe)
// {
//   double MacdCurrent = iMACD(NULL, timeframe, MATrendPeriodFast, MATrendPeriod, 9, PRICE_CLOSE, MODE_MAIN, i);
//   double MacdPre = iMACD(NULL, timeframe, MATrendPeriodFast, MATrendPeriod, 9, PRICE_CLOSE, MODE_MAIN, i + 1);
//   double SignalCurrent = iMACD(NULL, timeframe, MATrendPeriodFast, MATrendPeriod, 9, PRICE_CLOSE, MODE_SIGNAL, i);
//   double SignalPre = iMACD(NULL, timeframe, MATrendPeriodFast, MATrendPeriod, 9, PRICE_CLOSE, MODE_SIGNAL, i + 1);

//   return CheckForDeath(MacdCurrent, MacdPre, SignalCurrent, SignalPre);
// }

// bool isGold(int i, int timeframe)
// {
//   double MacdCurrent = iMACD(NULL, timeframe, MATrendPeriodFast, MATrendPeriod, 9, PRICE_CLOSE, MODE_MAIN, i);
//   double MacdPre = iMACD(NULL, timeframe, MATrendPeriodFast, MATrendPeriod, 9, PRICE_CLOSE, MODE_MAIN, i + 1);
//   double SignalCurrent = iMACD(NULL, timeframe, MATrendPeriodFast, MATrendPeriod, 9, PRICE_CLOSE, MODE_SIGNAL, i);
//   double SignalPre = iMACD(NULL, timeframe, MATrendPeriodFast, MATrendPeriod, 9, PRICE_CLOSE, MODE_SIGNAL, i + 1);

//   return CheckForGold(MacdCurrent, MacdPre, SignalCurrent, SignalPre);
// }

// bool isBelowZero(int i, int timeframe)
// {
//   double MacdCurrent = iMACD(NULL, timeframe, MATrendPeriodFast, MATrendPeriod, 9, PRICE_CLOSE, MODE_MAIN, i);
//   if (MacdCurrent < 0 && MathAbs(MacdCurrent) > (MACDOpenLevel * Point))
//   {
//     Print("isBelowZero:第", i, "位置的macd在0轴之下");
//     return true;
//   }
//   return false;
// }

// bool isAboveZero(int i, int timeframe)
// {
//   double MacdCurrent = iMACD(NULL, timeframe, MATrendPeriodFast, MATrendPeriod, 9, PRICE_CLOSE, MODE_MAIN, i);
//   if (MacdCurrent > 0 && MathAbs(MacdCurrent) > (MACDOpenLevel * Point))
//   {
//     Print("isBelowZero:第", i, "位置的macd在0轴之上");
//     return true;
//   }
//   return false;
// }

// //最大查看bar的数目
// int MAX_COUNT = 500;
// int findFirstDeath(int timeframe)
// {
//   for (int i = 0; i < MAX_COUNT; i++)
//   {
//     if (isDeath(i, timeframe))
//       return i;
//   }

//   return MAX_COUNT; //如果i=300表示没有找到。应该不会有这么久还没有死叉的情况
// }

// int findFirstGold(int timeframe)
// {
//   for (int i = 0; i < MAX_COUNT; i++)
//   {
//     if (isGold(i, timeframe))
//       return i;
//   }

//   return MAX_COUNT; //如果i=300表示没有找到。应该不会有这么久还没有金叉的情况
// }

// bool isFirstGold(int timeframe)
// {
//   return findFirstGold(timeframe) < findFirstDeath(timeframe);
// }

// bool isFirstDeath(int timeframe)
// {
//   return findFirstDeath(timeframe) < findFirstGold(timeframe);
// }

// //如果第一个是金叉并且金叉在0轴之下
// bool isMacdLong(int timeframe)
// {
//   if (isFirstGold(timeframe))
//   {
//     int i = findFirstGold(timeframe);
//     Print("isMacdShort:第一个为金叉，位置在", i, "  timeframe  ", timeframe);
//     return isBelowZero(i, timeframe);
//   }
//   Print("isMacdShort:macd不是看多");
//   return false;
// }

// //如果第一个是死叉并且死叉在0轴之上
// bool isMacdShort(int timeframe)
// {
//   if (isFirstDeath(timeframe))
//   {
//     int i = findFirstDeath(timeframe);
//     Print("isMacdShort:第一个为死叉，位置在", i, "  timeframe  ", timeframe);
//     return isAboveZero(i, timeframe);
//   }
//   Print("isMacdShort:macd不是看空");
//   return false;
// }

class Macd : public Abstractindicator
{
protected:
  int m_frame;
  int m_fast_ema_period;
  int m_slow_ema_period;
  int m_signal_period;

  int m_macdDelta; // macd必须大于一定高度才算有效。

  int MAX_COUNT;

public:
  Macd(/* args */);
  ~Macd();

public:
  void setFrame(int frame) { m_frame = frame; };
  int getFrame() { return m_frame; };

  void setFastEmaPeriod(int period) { m_fast_ema_period = period; };
  int getFastEmaPeriod() { return m_fast_ema_period; };

  void setSlowEmaPeriod(int period) { m_slow_ema_period = period; };
  int getSlowEmaPeriod() { return m_slow_ema_period; };

  void setSignalPeriod(int period) { m_signal_period = period; };
  int getSignalPeriod() { return m_signal_period; };

  void setMacdDelta(int delta) { m_macdDelta = delta; };
  int getMacdDelta() { return m_macdDelta; };

public:
  // Abstractindicator的虚函数实现
  void do_calc(int shift);

public:
  // 重构macd，部分与Abstractindicator同名的函数实现了重载。
  bool is_long();  // ->isMacdLong
  bool is_short(); // ->isMacdShort

  bool is_up();
  bool is_down();

  int find_first_gold();
  int find_first_death();

protected:
  bool is_gold(int index);
  bool is_death(int index);
  bool is_above_zero(int i);
  bool is_below_zero(int i);
  bool CheckForGold(double macd, double macdPre, double signal, double signalPre);
  bool CheckForDeath(double macd, double macdPre, double signal, double signalPre);

  bool is_first_gold() { return find_first_gold() < find_first_death(); };

  bool is_first_death() { return find_first_gold() < find_first_death(); };
};

Macd::Macd(/* args */)
{
  setFrame(PERIOD_M15);
  setFastEmaPeriod(26);
  setSlowEmaPeriod(60);
  setSignalPeriod(9);

  setMacdDelta(6);
  MAX_COUNT = 500;
}

Macd::~Macd()
{
}

void Macd::do_calc(int shift)
{
  double macd = iMACD(NULL, getFrame(), getFastEmaPeriod(), getSlowEmaPeriod(), getSignalPeriod(), PRICE_CLOSE, MODE_MAIN, shift);
  m_indicator.append(macd);
}

bool Macd::is_long()
{
  if (is_first_gold())
  {
    int i = find_first_gold();
    return is_below_zero(i);
  }

  return false;
}

bool Macd::is_short()
{
  if (is_first_death())
  {
    int i = find_first_death();
    return is_above_zero(i);
  }

  return false;
}

int Macd::find_first_gold()
{
  for (int i = 0; i < MAX_COUNT; i++)
  {
    if (is_gold(i))
      return i;
  }

  return MAX_COUNT;
}

int Macd::find_first_death()
{
  for (int i = 0; i < MAX_COUNT; i++)
  {
    if (is_death(i))
      return i;
  }

  return MAX_COUNT;
}

bool Macd::CheckForGold(double macd, double macdPre, double signal, double signalPre)
{
  if (macd > signal && macdPre < signalPre)
  {
    if (MathAbs(macd) > (getMacdDelta() * Point))
    {
      //Print("检测到金叉");
      return true;
    }

    Print("金叉不满足开仓的高度。");
  }

  return false;
}

bool Macd::CheckForDeath(double macd, double macdPre, double signal, double signalPre)
{
  if (macd < signal && macdPre > signalPre)
  {
    if (MathAbs(macd) > (getMacdDelta() * Point))
    {
      //Print("检测到死叉");
      return true;
    }
    Print("死叉不满足开仓的高度.");
  }

  return false;
}

/**
 * 判断指定位置是否为金叉。
*/
bool Macd::is_gold(int index)
{
  double MacdCurrent = iMACD(NULL, getFrame(), getFastEmaPeriod(), getSlowEmaPeriod(), getSignalPeriod(), PRICE_CLOSE, MODE_MAIN, index);
  double MacdPre = iMACD(NULL, getFrame(), getFastEmaPeriod(), getSlowEmaPeriod(), getSignalPeriod(), PRICE_CLOSE, MODE_MAIN, index + 1);
  double SignalCurrent = iMACD(NULL, getFrame(), getFastEmaPeriod(), getSlowEmaPeriod(), getSignalPeriod(), PRICE_CLOSE, MODE_SIGNAL, index);
  double SignalPre = iMACD(NULL, getFrame(), getFastEmaPeriod(), getSlowEmaPeriod(), getSignalPeriod(), PRICE_CLOSE, MODE_SIGNAL, index + 1);

  return CheckForGold(MacdCurrent, MacdPre, SignalCurrent, SignalPre);
}

/**
 * 
 * 判断是否为死叉。
*/
bool Macd::is_death(int index)
{
  double MacdCurrent = iMACD(NULL, getFrame(), getFastEmaPeriod(), getSlowEmaPeriod(), getSignalPeriod(), PRICE_CLOSE, MODE_MAIN, index);
  double MacdPre = iMACD(NULL, getFrame(), getFastEmaPeriod(), getSlowEmaPeriod(), getSignalPeriod(), PRICE_CLOSE, MODE_MAIN, index + 1);
  double SignalCurrent = iMACD(NULL, getFrame(), getFastEmaPeriod(), getSlowEmaPeriod(), getSignalPeriod(), PRICE_CLOSE, MODE_SIGNAL, index);
  double SignalPre = iMACD(NULL, getFrame(), getFastEmaPeriod(), getSlowEmaPeriod(), getSignalPeriod(), PRICE_CLOSE, MODE_SIGNAL, index + 1);

  return CheckForDeath(MacdCurrent, MacdPre, SignalCurrent, SignalPre);
}

bool Macd::is_below_zero(int i)
{
  double MacdCurrent = iMACD(NULL, getFrame(), getFastEmaPeriod(), getSlowEmaPeriod(), getSignalPeriod(), PRICE_CLOSE, MODE_MAIN, i);
  if (MacdCurrent < 0 && MathAbs(MacdCurrent) > (getMacdDelta() * Point))
    return true;

  return false;
}

bool Macd::is_above_zero(int i)
{
  double MacdCurrent = iMACD(NULL, getFrame(), getFastEmaPeriod(), getSlowEmaPeriod(), getSignalPeriod(), PRICE_CLOSE, MODE_MAIN, i);
  if (MacdCurrent > 0 && MathAbs(MacdCurrent) > (getMacdDelta() * Point))
    return true;

  return false;
}

bool Macd::is_up()
{
  double Macd0 = iMACD(NULL, getFrame(), getFastEmaPeriod(), getSlowEmaPeriod(), getSignalPeriod(), PRICE_CLOSE, MODE_MAIN, 0);
  double Macd1 = iMACD(NULL, getFrame(), getFastEmaPeriod(), getSlowEmaPeriod(), getSignalPeriod(), PRICE_CLOSE, MODE_MAIN, 1);
  double Macd2 = iMACD(NULL, getFrame(), getFastEmaPeriod(), getSlowEmaPeriod(), getSignalPeriod(), PRICE_CLOSE, MODE_MAIN, 2);

  double Signal0 = iMACD(NULL, getFrame(), getFastEmaPeriod(), getSlowEmaPeriod(), getSignalPeriod(), PRICE_CLOSE, MODE_SIGNAL, 0);
  double Signal1 = iMACD(NULL, getFrame(), getFastEmaPeriod(), getSlowEmaPeriod(), getSignalPeriod(), PRICE_CLOSE, MODE_SIGNAL, 1);
  double Signal2 = iMACD(NULL, getFrame(), getFastEmaPeriod(), getSlowEmaPeriod(), getSignalPeriod(), PRICE_CLOSE, MODE_SIGNAL, 2);

  if (Macd1 >= Macd0 || Macd2 >= Macd1 || Signal1 >= Signal0 || Signal2 >= Signal1)
  {
    Print("isLong:macd或者signal不是向上");
    return false;
  }

  //取差值的均值
  double MACDAVGLevel = (Macd0 + Macd1 + Macd2 - Signal0 - Signal1 - Signal2) / 3;
  if (MACDAVGLevel < getMacdDelta() * Point)
  {
    Print("isLong:macd高于Signal的量太小");
    Print("isLong:相差", MACDAVGLevel / Point, "个Point");
    return false;
  }

  return true;
}

bool Macd::is_down()
{
  double Macd0 = iMACD(NULL, getFrame(), getFastEmaPeriod(), getSlowEmaPeriod(), getSignalPeriod(), PRICE_CLOSE, MODE_MAIN, 0);
  double Macd1 = iMACD(NULL, getFrame(), getFastEmaPeriod(), getSlowEmaPeriod(), getSignalPeriod(), PRICE_CLOSE, MODE_MAIN, 1);
  double Macd2 = iMACD(NULL, getFrame(), getFastEmaPeriod(), getSlowEmaPeriod(), getSignalPeriod(), PRICE_CLOSE, MODE_MAIN, 2);

  double Signal0 = iMACD(NULL, getFrame(), getFastEmaPeriod(), getSlowEmaPeriod(), getSignalPeriod(), PRICE_CLOSE, MODE_SIGNAL, 0);
  double Signal1 = iMACD(NULL, getFrame(), getFastEmaPeriod(), getSlowEmaPeriod(), getSignalPeriod(), PRICE_CLOSE, MODE_SIGNAL, 1);
  double Signal2 = iMACD(NULL, getFrame(), getFastEmaPeriod(), getSlowEmaPeriod(), getSignalPeriod(), PRICE_CLOSE, MODE_SIGNAL, 2);

  if (Macd0 >= Macd1 || Macd1 >= Macd2 || Signal0 >= Signal1 || Signal1 >= Signal2)
  {
    // Print("isShort:macd或者signal不是向下");
    return false;
  }

  double MACDAVGLevel = (Signal0 + Signal1 + Signal2 - Macd0 - Macd1 - Macd2) / 3;

  if (MACDAVGLevel < getMacdDelta() * Point)
  {
    // Print("isShort:macd低于信号的量不够。");
    // Print("isShort:相差", MACDAVGLevel / Point, "个Point");
    return false;
  }

  return true;
}

class Macd4H : public Macd
{
private:
  /* data */
public:
  Macd4H(/* args */);
  ~Macd4H();
};

Macd4H::Macd4H(/* args */)
{
  setFrame(PERIOD_H4);
}

Macd4H::~Macd4H()
{
}
