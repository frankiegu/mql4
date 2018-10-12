//+------------------------------------------------------------------+
//|                                                         util.mqh |
//|                                                          linbirg |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "linbirg"
#property link "https://www.mql5.com"
#property strict

// 常量定义，小于该值的数被认为0；准备废弃
// @deprecated
double const epshi = 0.00001;
bool doubleEqual(double one, double other)
{
    if (MathAbs(one - other) < epshi)
        return true;
    return false;
}

// 判断是否是周五的最后15分钟
bool isFridayLastFifteen()
{
    Print("isFridayLastFifteen:DayOfweek   ", DayOfWeek(), "   Time[0]  ", TimeToStr(Time[0], TIME_SECONDS), "   TimeHour  ", TimeHour(Time[0]), "   TimeMinute  ", TimeMinute(Time[0]));
    if (DayOfWeek() != 5)
    {
        return false;
    }

    if (TimeHour(Time[0]) < 23 || TimeMinute(Time[0]) < 45)
    {
        return false;
    }

    Print("isFridayLastFifteen:it is 23:45 Friday now");
    return true;
}

/**
 * 
 * 工具类
*/
class Util
{
  private:
    double m_epsilon;

  public:
    Util(/* args */);
    ~Util();

  public:
    double sum_to(const double &data[], int from, int to);
    void abs(double &dist[], const double &src[], int size);
    void copy(double &dist[], const double &src[], int size);
    bool double_equal(double one, double other);
};

Util::Util(/* args */)
{
    m_epsilon = 0.00000001;
}

Util::~Util()
{
}

/**
 * sum(from <= i < to)
*/
double Util::sum_to(const double &data[], int from, int to)
{
    double total = 0;

    for (int i = from; i < to; i++)
    {
        total += data[i];
    }

    return total;
}

void Util::abs(double &dist[], const double &src[], int size)
{
    for (int i = 0; i < size; i++)
    {
        dist[i] = MathAbs(src[i]);
    }
}

void Util::copy(double &dist[], const double &src[], int size)
{
    ArrayResize(dist, size);
    ArrayCopy(dist, src);
}

bool Util::double_equal(double one, double other)
{
    if (MathAbs(one - other) < m_epsilon)
        return true;
    return false;
}