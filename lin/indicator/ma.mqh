//+------------------------------------------------------------------+
//|                                                           ma.mqh |
//|                                                          linbirg |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "linbirg"
#property link "https://www.mql5.com"
#property strict

#include "indicator_grp.mqh"
#include "abstract_indicator.mqh"

/**
 * 
 * 均线指标
*/
class MA : public Abstractindicator
{
    private:
      // int m_timeframe;
      int m_maPeriods;
      int m_maDelta; // 前后均值的最小差值，如果太小，认为均线没变化。

    public:
      MA(/* args */);
      ~MA();

    public:
      void setMaPeriods(int periods) { m_maPeriods = periods; };
      void setTimeFrame(int frame) { m_frame = frame; };

      int getMaPeriods() { return m_maPeriods; };
      int getFrame() { return m_frame; };

      void setMaDelta(int delta) { m_maDelta = delta; };
      int getMaDelta() { return m_maDelta; };

    public:
      // bool is_long();
      // bool is_short();
      // bool is_flat();
      // void calc();
      void do_calc(int shift);

    public:
      bool is_down(); // 重构s2l-macd
      bool is_up();
      bool is_near_by();  //在均线附近
      bool is_far_away(); //在远离均线
      bool is_consolidation();
};

MA::MA(/* args */)
{
      setBufferSize(1000);
      setMaDelta(5);
}

MA::~MA()
{
}

// void MA::calc()
// {
//       datetime now = iTime(NULL, m_frame, 0);
//       int count = (now - m_start_time) / (60 * m_frame);

//       for (int i = 0; i < count; i++)
//       {
//             double ma = iMA(NULL, m_timeframe, m_maPeriods, 0, MODE_LWMA, PRICE_CLOSE, 0);
//             m_indicator.append(ma);
//       }
//       m_start_time = now;
// }

void MA::do_calc(int shift)
{
      double ma = iMA(NULL, m_frame, m_maPeriods, 0, MODE_LWMA, PRICE_CLOSE, shift);
      m_indicator.append(ma);
}

bool MA::is_down()
{
      double Ma0 = iMA(NULL, getFrame(), getMaPeriods(), 0, MODE_LWMA, PRICE_CLOSE, 0);
      double Ma1 = iMA(NULL, getFrame(), getMaPeriods(), 0, MODE_LWMA, PRICE_CLOSE, 1);
      double Ma2 = iMA(NULL, getFrame(), getMaPeriods(), 0, MODE_LWMA, PRICE_CLOSE, 2);

      bool isDown = false;

      if (Ma0 >= Ma1)
            return false;

      if ((Ma1 - Ma0) > m_maDelta * Point)
            return true;

      if (Ma2 > Ma1 && (Ma2 - Ma0) > 1.5 * m_maDelta * Point)
      {
            return true;
      }

      return false;
}

bool MA::is_up()
{
      double Ma0 = iMA(NULL, getFrame(), getMaPeriods(), 0, MODE_LWMA, PRICE_CLOSE, 0);
      double Ma1 = iMA(NULL, getFrame(), getMaPeriods(), 0, MODE_LWMA, PRICE_CLOSE, 1);
      double Ma2 = iMA(NULL, getFrame(), getMaPeriods(), 0, MODE_LWMA, PRICE_CLOSE, 2);

      if (Ma0 <= Ma1)
            return false;

      if ((Ma0 - Ma1) > m_maDelta * Point)
            return true;

      if (Ma1 > Ma2 && (Ma0 - Ma2) > 1.5 * m_maDelta * Point)
            return true;

      return false;
}

bool MA::is_near_by()
{
      double ma = iMA(NULL, getFrame(), getMaPeriods(), 0, MODE_LWMA, PRICE_CLOSE, 0);
      double open = iOpen(NULL, getFrame(), 0);

      if (MathAbs(ma - open) < getMaDelta() * Point)
      {
            return true;
      }

      return false;
}

bool MA::is_far_away()
{
      double ma = iMA(NULL, getFrame(), getMaPeriods(), 0, MODE_LWMA, PRICE_CLOSE, 0);
      double open = iOpen(NULL, getFrame(), 0);
      double close = iClose(NULL, getFrame(), 0);

      if (open > ma && close > ma && close > open)
            return true;

      if (open < ma && close < ma && close < open)
            return true;

      return false;
}
/**
 * 
 * 判断从第i个行情之前的一段时间内存在盘整行情
 * 盘整行情的定义：行情波动不大
*/
bool MA::is_consolidation()
{

      double macd, ma;
      double maArr[], delta[];
      double total, avg;
      int count, j;
      int CheckPeriod = 24;

      ArrayResize(maArr, 2 * CheckPeriod);
      ArrayResize(delta, 2 * CheckPeriod);

      for (j = 0; j < 2 * CheckPeriod; j++)
      {
            ma = iMA(NULL, getFrame(), getMaPeriods(), 0, MODE_EMA, PRICE_CLOSE, j);
            maArr[j] = ma;
      }
      total = 0;
      for (j = 0; j < 2 * CheckPeriod; j++)
      {
            total += maArr[j];
      }

      avg = total / (2 * CheckPeriod);
      //Print("hasConsolidation: ma avg:",avg);
      for (j = 0; j < 2 * CheckPeriod; j++)
      {
            delta[j] = avg - maArr[j];
      }

      count = 0;
      for (j = 0; j < 2 * CheckPeriod; j++)
      {
            if (MathAbs(delta[j]) <= (10 * getMaDelta() * Point))
            {
                  count = count + 1;
                  Print("count:", count);
                  if (count >= CheckPeriod)
                  {
                        Print("hasConsolidation:存在盘整行情");
                        return true;
                  }
            }
            else
                  count = 0;
      }

      return false;
}

class DoubleMA : public Abstractindicator
{
    private:
      MA m_fast;
      MA m_slow;
      int m_timeframe;

      double m_ravistor; // 用于判断两条线的间隔

    public:
      DoubleMA(/* args */);
      ~DoubleMA();

    public:
      void setTimeFrame(int frame);
      void setBufferSize(int size);

      void setRavistor(int ravistor) { m_ravistor = ravistor; };
      int getRavistor() { return m_ravistor; };

    public:
      void do_calc(int shift);

    public:
      bool is_long();
      bool is_short();
      string format_to_str();

    public:
      // 重构原macd的代码
      bool is_consolidation();
      bool is_ma_up();
      bool is_ma_down();

      bool is_near_by_slow() { return m_slow.is_near_by(); };
      bool is_near_by_fast() { return m_fast.is_near_by(); };
      bool is_far_away_slow() { return m_slow.is_far_away(); };
      bool is_far_away_fast() { return m_fast.is_far_away(); };
};

DoubleMA::DoubleMA(/* args */)
{
      setTimeFrame(PERIOD_M15);
      m_fast.setMaPeriods(20);
      m_slow.setMaPeriods(60);
      m_ravistor = 20; // 默认两条均线相距太近，任务是震荡行情。
}

DoubleMA::~DoubleMA()
{
}

void DoubleMA::setTimeFrame(int frame)
{
      Abstractindicator::setTimeFrame(frame);
      m_fast.setTimeFrame(frame);
      m_slow.setTimeFrame(frame);
}

void DoubleMA::setBufferSize(int size)
{
      m_fast.setBufferSize(size);
      m_slow.setBufferSize(size);
}

void DoubleMA::do_calc(int shift)
{
      m_fast.do_calc(shift);
      m_slow.do_calc(shift);
}

bool DoubleMA::is_long()
{
      return m_fast.is_long() && m_slow.is_long();
}

bool DoubleMA::is_short()
{
      return m_fast.is_short() && m_slow.is_short();
}

string DoubleMA::format_to_str()
{
      return "ma:" +
             " frame:" + m_frame +
             " fast:is_long:" + m_fast.is_long() +
             " is_short:" + m_fast.is_short() +
             " slow:is_long:" + m_slow.is_long() +
             " is_short:" + m_slow.is_short();
}

bool DoubleMA::is_consolidation()
{
      if (!m_fast.is_consolidation())
            return false;

      double Ma = iMA(NULL, m_fast.getFrame(), m_fast.getMaPeriods(), 0, MODE_LWMA, PRICE_CLOSE, 0);
      double MaDB = iMA(NULL, m_slow.getFrame(), m_slow.getMaPeriods(), 0, MODE_LWMA, PRICE_CLOSE, 0);
      if (MathAbs(Ma - MaDB) >= m_ravistor * Point)
            return false;

      return true;
}

bool DoubleMA::is_ma_up()
{
      return m_slow.is_up();
}

bool DoubleMA::is_ma_down()
{
      return m_slow.is_down();
}

class DoubleMA5M : public DoubleMA
{
    private:
      /* data */
    public:
      DoubleMA5M(/* args */);
      ~DoubleMA5M();
};

DoubleMA5M::DoubleMA5M(/* args */)
{
      setTimeFrame(PERIOD_M5);
}

DoubleMA5M::~DoubleMA5M()
{
}

class DoubleMA15M : public DoubleMA
{
    private:
      /* data */
    public:
      DoubleMA15M(/* args */);
      ~DoubleMA15M();
};

DoubleMA15M::DoubleMA15M(/* args */)
{
}

DoubleMA15M::~DoubleMA15M()
{
}

class DoubleMa1H : public DoubleMA
{
    private:
      /* data */
    public:
      DoubleMa1H(/* args */);
      ~DoubleMa1H();
};

DoubleMa1H::DoubleMa1H(/* args */)
{
      setTimeFrame(PERIOD_H1);
}

DoubleMa1H::~DoubleMa1H()
{
}

class DoubleMA4H : public DoubleMA
{
    private:
      /* data */
    public:
      DoubleMA4H(/* args */);
      ~DoubleMA4H();
};

DoubleMA4H::DoubleMA4H(/* args */)
{
      setTimeFrame(PERIOD_H4);
      setRavistor(80);
}

DoubleMA4H::~DoubleMA4H()
{
}

class DoubleMA1D : public DoubleMA
{
    private:
      /* data */
    public:
      DoubleMA1D(/* args */);
      ~DoubleMA1D();
};

DoubleMA1D::DoubleMA1D(/* args */)
{
      setTimeFrame(PERIOD_D1);
      setRavistor(100);
}

DoubleMA1D::~DoubleMA1D()
{
}

class DoubleMA1W : public DoubleMA
{
    private:
      /* data */
    public:
      DoubleMA1W(/* args */);
      ~DoubleMA1W();
};

DoubleMA1W::DoubleMA1W(/* args */)
{
      setTimeFrame(PERIOD_W1);
}

DoubleMA1W::~DoubleMA1W()
{
}

class DoubleMA1MN : public DoubleMA
{
    private:
      /* data */
    public:
      DoubleMA1MN(/* args */);
      ~DoubleMA1MN();
};

DoubleMA1MN::DoubleMA1MN(/* args */)
{
      setTimeFrame(PERIOD_MN1);
      setBufferSize(100);
}

DoubleMA1MN::~DoubleMA1MN()
{
}
