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
