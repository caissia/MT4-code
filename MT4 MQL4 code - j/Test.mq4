//+------------------------------------------------------------------+
//|                                                    Swing_Data.mq4|
//|                           Copyright 2014, SilverSurfer Financial |
//|                                     https://www.SilverSurfer.com |
//+------------------------------------------------------------------+

#property copyright "Copyright 2014, SilverSurfer Financial"
#property link      "https://www.SilverSurfer.com"

//---- indicator settings
#property indicator_chart_window
#property indicator_buffers 0
#property indicator_color1 FireBrick   // color of down arrow
#property indicator_color2 Green       // color of up arrow

//---- input parameters
extern int MA_Type = 1;
extern int MA_Period = 8;
extern int Min_Difference = 25;
int i;
int decimals;
double AdjDiff;
double maHigh[];
double maLow[];
double PosDiff[];
double NegDiff[];
double HighDiff[];
double LowDiff[];
double AdjHigh[];
double AdjLow[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function |
//+------------------------------------------------------------------+
int init()
  {
   //---- arrays
   /*
   SetIndexBuffer(0, HighDiff);
   SetIndexStyle(0, DRAW_ARROW, EMPTY);
   SetIndexArrow(0, 225);
   SetIndexBuffer(1, LowDiff);
   SetIndexStyle(1, DRAW_ARROW, EMPTY);
   SetIndexArrow(1, 226);
   */
   return(0);
  }
//+-------------------------------+
//| script program start function |
//+------------------------------------------------------------------+
int start()
  {
  
   //find index of bar shown at leftmost side of screen
   i = Bars - IndicatorCounted() - 1;
   if( i > 1000 )
       i = 1000;
 
   //Alert (i);
   //Sleep (10000);

   decimals = Digits();
   
   if (decimals == 3)
       AdjDiff = 0.50;
   if (decimals == 5)
       AdjDiff = 0.0050;
   
   while (i >= 0)
     {
      maHigh[i] =iMA(NULL,0,MA_Period,1,MA_Type,2,i);
      maLow[i]  = iMA(NULL,0,MA_Period,1,MA_Type,3,i);
 
 Alert(maHigh[i]);
 Sleep(1000);
      PosDiff[i] = High[i] - maHigh[i];
      NegDiff[i] = Low[i]  - maLow[i];
      
      if (PosDiff[i] >= Min_Difference)
        {
         HighDiff[i] = High[i] - maHigh[i];
         AdjHigh[i]  = High[i] + decimals;
        }
      if (NegDiff[i] <= Min_Difference)
        {
         LowDiff[i]  = Low[i]  - maLow[i];
         AdjLow[i]   = Low[i]  - decimals;
        }
      ObjectCreate ("High-EMA"+i,OBJ_TEXT,0,Time[i],AdjHigh[i]);
      ObjectSetText("High-EMA"+i,DoubleToStr(HighDiff[i],Digits),8,"Arial",C'255,255,155');
      ObjectCreate ("Low-EMA"+i,OBJ_TEXT,0,Time[i],AdjLow[i]);
      ObjectSetText("Low-EMA"+i,DoubleToStr(LowDiff[i],Digits),8,"Arial",C'255,255,155');
      i--;
     }
return(0);
}
//+------------------------------------------------------------------+