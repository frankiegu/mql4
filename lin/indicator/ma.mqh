//+------------------------------------------------------------------+
//|                                                           ma.mqh |
//|                                                          linbirg |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "linbirg"
#property link      "https://www.mql5.com"
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

bool isMaUp(int ma_period,double minMAUpStep,int period_count)
{
   double Ma0,Ma1,Ma2;
   //均뿯纽뿯厽뿯劽뿯殽뿯붿慢붿뿯暽뿯施뿯厽两个
   Ma0=iMA(NULL,ma_period,period_count,0,MODE_LWMA,PRICE_CLOSE,0);
   Ma1=iMA(NULL,ma_period,period_count,0,MODE_LWMA,PRICE_CLOSE,1);
   Ma2=iMA(NULL,ma_period,period_count,0,MODE_LWMA,PRICE_CLOSE,2);

   bool isUp = false;

   if(Ma0>Ma1)
   {
      if((Ma0-Ma1)>minMAUpStep*Point)
      {
         //Print("isMaUp:Ma0-Ma1   ",(Ma0-Ma1)/Point,"  step  ",minMAUpStep,"   Period   ",ma_period,"  count ",period_count);
         isUp = true;
         return isUp;
      }
      if(Ma1>Ma2&&(Ma0-Ma2)>1.5*minMAUpStep*Point)
      {
            //Print("isMaUp:Ma0-Ma2   ",(Ma0-Ma2)/Point,"  step  ",minMAUpStep,"   Period   ",ma_period,"  count ",period_count);
            isUp = true;
            return isUp;
      }
   }

   return isUp;
}

bool isMaDown(int ma_period,double minMaDownStep,int period_count)
{
   double Ma0,Ma1,Ma2;
   //均뿯纽뿯厽뿯劽뿯殽뿯붿慢붿뿯暽뿯施뿯厽两个
   Ma0=iMA(NULL,ma_period,period_count,0,MODE_LWMA,PRICE_CLOSE,0);
   Ma1=iMA(NULL,ma_period,period_count,0,MODE_LWMA,PRICE_CLOSE,1);
   Ma2=iMA(NULL,ma_period,period_count,0,MODE_LWMA,PRICE_CLOSE,2);

   bool isDown = false;


   if(Ma0<Ma1)
   {
      if((Ma1-Ma0)>minMaDownStep*Point)
      {
         isDown = true;
         //Print("isMaDown: Ma1-Ma0  ",(Ma1-Ma0)/Point,"   step  ",minMaDownStep,"   Period   ",ma_period,"  count ",period_count);

         return isDown;
      }
      if(Ma2>Ma1&&(Ma2-Ma0)>1.5*minMaDownStep*Point)
      {
            //Print("isMaDown:Ma2-Ma0 ",(Ma2-Ma0)/Point,"  step  ",minMaDownStep,"   Period   ",ma_period,"  count ",period_count);
            isDown = true;
            return isDown;
      }
   }

   return isDown;
}


//H4 开뿯亽붿뿯붿看13붿26,60三根均뿯纽뿯施向一뿯붿。
bool isMa4HUpForOpen()
{
   return isMaUp(PERIOD_H4,MAOpenLevel,MATrendPeriodFast/2)&&isMaUp(PERIOD_H4,MAOpenLevel,MATrendPeriodFast);//&&isMaUp(Timeframes,MAOpenLevel,MATrendPeriod);
}


bool isMa4HDownForOpen()
{
   return isMaDown(PERIOD_H4,MAOpenLevel,MATrendPeriodFast/2)&&isMaDown(PERIOD_H4,MAOpenLevel,MATrendPeriodFast);//&&isMaDown(Timeframes,MAOpenLevel,MATrendPeriod);
}

bool isMa4HUpForClose()
{
   return isMaUp(PERIOD_H4,MACloseLevel,MATrendPeriodFast);
}

bool isMa4HDownForClose()
{
   return isMaDown(PERIOD_H4,MACloseLevel,MATrendPeriodFast);
}


bool isFarAway(int ma_timeframe,int ma_period_count)
{
   double ma = iMA(NULL,ma_timeframe,ma_period_count,0,MODE_LWMA,PRICE_CLOSE,0);
   double open = iOpen(NULL,ma_timeframe,0);
   double close = iClose(NULL,ma_timeframe,0);

   if(open>ma&&close>ma&&close>open)return true;

   if(open<ma&&close<ma&&close<open)return true;

   return false;
}

bool isApproaching(int ma_timeframe,int ma_period_count)
{
   double ma = iMA(NULL,ma_timeframe,ma_period_count,0,MODE_LWMA,PRICE_CLOSE,0);
   double open = iOpen(NULL,ma_timeframe,0);
   double close = iClose(NULL,ma_timeframe,0);

   if(open>ma&&close>ma&&close<open)return true;

   if(open<ma&&close<ma&&close>open)return true;

   return false;
}

/**
*开뿯皽뿯亽在均뿯纽붿近delta个Point即뿯箽在붿近
*/
bool isNearBy(int ma_timeframe,int ma_period_count,int delta)
{
   double ma = iMA(NULL,ma_timeframe,ma_period_count,0,MODE_LWMA,PRICE_CLOSE,0);
   double open = iOpen(NULL,ma_timeframe,0);



   if(MathAbs(ma-open)<delta*Point)
   {
      //Print("isNearBy:true ma_period_count   ",ma_period_count,"  ma_timeframe   ",ma_timeframe,"  MathAbs(ma-open)/Point  ",MathAbs(ma-open)/Point);
      return true;
   }

   return false;
}

// 붿过判뿯施两条均뿯纽뿯皽뿯嶽值来判뿯施是否存在붿붿붿뿯悽。
bool isConsolidation(int ma_timeframe,int ma_period_one,int ma_period_other, int ravistor)
{
   double Ma,MaDB;
   //int count = 0;

   Ma=iMA(NULL,ma_timeframe,ma_period_one,0,MODE_LWMA,PRICE_CLOSE,0);
   MaDB=iMA(NULL,ma_timeframe,ma_period_other,0,MODE_LWMA,PRICE_CLOSE,0);

   //Print("isConsolidation:delta:",MathAbs(Ma-MaDB)/Point,"  Ma ",Ma,"   MaDB  ",MaDB,"   ma_timeframe   ",ma_timeframe,"  ma_period_one  ",ma_period_one,"  ma_period_other   ",ma_period_other);

   if(MathAbs(Ma-MaDB)>=ravistor*Point)return false;

   return true;
}
