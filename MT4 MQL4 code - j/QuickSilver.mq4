//+------------------------------------------------------------------+
//|                                                   QuickSilver.mq4|
//|                           Copyright 2014, SilverSurfer Financial |
//|                                     https://www.SilverSurfer.com |
//+------------------------------------------------------------------+

#property copyright "Copyright 2014, SilverSurfer Financial"
#property link      "https://www.SilverSurfer.com"

//---- indicator settings
#property indicator_chart_window
#property indicator_buffers 3
#property indicator_color1 SkyBlue           // color of High  Price EMA
#property indicator_color2 CornflowerBlue    // color of Low   Price EMA
#property indicator_color3 SkyBlue           // color of Close Price EMA

//---- input parameters
extern int  MA_Type    = 1;
extern int  MA_Period  = 8;
extern int  Min_Dist   = 25;
extern bool pips       = false;
extern bool dnarrows   = true;
extern bool uparrows   = true;

/*

  MA_Type = ENUM_MA_METHOD
   0 = simple moving average
   1 = exponential ma
   2 = smoothed ma
   3 = linear-weighted average
   
  ENUM_APPLIED_PRICE
   0 = close price
   1 = open price
   2 = high price
   3 = low price
   4 = median price (high + low)/2
   5 = typical price (high + low + close)/3
   6 = weighted close price (high + low + close + close)/4

*/

//---- variables & arrays
int i;
int decimals;
int xfactor;

int indexH;     // local max value between StartIndex and EndIndex
int indexL;
int StartIndexH;
int EndIndexH;
int StartIndexL;
int EndIndexL;
double mIndex[];

double AdjDiff1;
double AdjDiff2;
double AdjHigh1;
double AdjHigh2;
double AdjLow1;
double AdjLow2;

double nHighDiff;
double nLowDiff;
double pHighDiff;
double pLowDiff;

double maHighN;
double maLowN;

double maHigh[];
double maLow[];
double maClose[];

double HighDiff[];
double LowDiff[];

//string High1;  //corresponds to maHigh
//string HL2;    //corresponds to HL/2
//string Low1;   //corresponds to maLow

//------------------------------------------------------------------
int init()
  {
    i = 10000;
    while (i >= 0)
     {
      ObjectDelete("("+indexH+")"+" High - h_EMA");
      ObjectDelete("("+indexL+")"+" Low - l_EMA");
      ObjectDelete("("+i+")"+" High - h_EMA");
      ObjectDelete("("+i+")"+" Low - l_EMA");
      ObjectDelete("("+i+")"+" ArrowDown");
      ObjectDelete("("+i+")"+" ArrowUp");
      i--;
     }
     
    SetIndexBuffer(0, maHigh);
    SetIndexBuffer(1, maClose);
    SetIndexBuffer(2, maLow);
    
    SetIndexStyle (0,DRAW_LINE,STYLE_DASHDOTDOT);
    SetIndexStyle (1,DRAW_LINE,STYLE_DASHDOTDOT);
    SetIndexStyle (2,DRAW_LINE,STYLE_DASHDOTDOT);

    SetIndexLabel(0,"QuickSilver: High");
    SetIndexLabel(1,"QuickSilver: Median");
    SetIndexLabel(2,"QuickSilver: Low");

    return(0);
   }

//------------------------------------------------------------------  
int deinit()
   {
    i = 10000;
    while (i >= 0)
     {
      ObjectDelete("("+i+")"+" High - h_EMA");
      ObjectDelete("("+i+")"+" Low - l_EMA");
      ObjectDelete("("+i+")"+" ArrowDown");
      ObjectDelete("("+i+")"+" ArrowUp");
      i--;
     }
    //ObjectsDeleteAll();
    return(0);
   }

//------------------------------------------------------------------
int start()
  {
   //i = WindowBarsPerChart();
   i = Bars - IndicatorCounted() - 1;

   ArrayResize (HighDiff,i);
   ArrayResize (LowDiff,i);
   
   decimals = Digits();
   
   if (decimals == 3)
      {
       AdjDiff1 = 0.9;
       AdjDiff2 = 0.5;
       xfactor = 100;
      }
   if (decimals == 5)
      {
       AdjDiff1 = 0.0090;
       AdjDiff2 = 0.0050;
       xfactor  = 10000;
      }
      
   while (i >= 0)
    {
//current
      maHigh[i]  = iMA(NULL,0,MA_Period,0,MA_Type,2,i);
      maClose[i] = iMA(NULL,0,MA_Period,0,MA_Type,4,i);
      maLow[i]   = iMA(NULL,0,MA_Period,0,MA_Type,3,i);
      
// next
      maHighN = iMA(NULL,0,MA_Period,0,MA_Type,2,i-1);
      maLowN  = iMA(NULL,0,MA_Period,0,MA_Type,3,i-1);
      
// current
      HighDiff[i]  = NormalizeDouble ((High[i] - maHigh[i]) * xfactor,1);
      LowDiff[i]   = NormalizeDouble ((Low[i]  - maLow[i])  * xfactor,1);
      
// previous
      pHighDiff = NormalizeDouble ((High[i+1] - maHigh[i+1]) * xfactor,1);
      pLowDiff  = NormalizeDouble ((Low [i+1] - maLow[i+1])  * xfactor,1);
      
// next
      nHighDiff = NormalizeDouble ((High[i-1] - maHighN) * xfactor,1);
      nLowDiff  = NormalizeDouble ((Low [i-1] - maLowN)  * xfactor,1);
      
// pips & arrows listed for all sessions
/*
          ObjectCreate ("("+i+")"+" High - h_EMA",OBJ_TEXT,0,Time[i],High[i] + AdjDiff1);
          ObjectSetText("("+i+")"+" High - h_EMA",DoubleToStr((High[i] - maHigh[i]) * xfactor,1),8,"Arial",C'255,255,155');

          //ObjectCreate ("("+i+")"+" ArrowDown",OBJ_ARROW_DOWN,0,Time[i],High[i] + AdjDiff2);
          //ObjectSet("("+i+")"+" ArrowDown",OBJPROP_COLOR,Yellow);
                    
          ObjectCreate ("("+i+")"+" Low - l_EMA",OBJ_TEXT,0,Time[i],Low[i] - (AdjDiff1 * 0.8));
          ObjectSetText("("+i+")"+" Low - l_EMA",DoubleToStr((Low[i] - maLow[i]) * xfactor,1),8,"Arial",C'255,255,155'); 

          //ObjectCreate ("("+i+")"+" ArrowUp",OBJ_ARROW_UP,0,Time[i],Low[i] - (AdjDiff2 * 0.8));
          //ObjectSet("("+i+")"+" ArrowUp",OBJPROP_COLOR,Yellow);
*/
//------------------------------------------------------------------
      //if (HighDiff[i] > Min_Dist && pHighDiff < Min_Dist)
      if (pHighDiff < Min_Dist && HighDiff[i] > Min_Dist)
       {
        StartIndexH = i;
       }
      //if (HighDiff[i] > Min_Dist && nHighDiff < Min_Dist)
      if (pHighDiff > Min_Dist && HighDiff[i] < Min_Dist)
       {
        EndIndexH = i;
        ArrayResize (mIndex,StartIndexH-EndIndexH+1);
        ArrayCopy(mIndex,HighDiff,0,EndIndexH,StartIndexH-EndIndexH+1);
        indexH = ArrayMaximum(mIndex,0); // local max value between StartIndex and EndIndex
        indexH = EndIndexH + indexH;

        AdjHigh1  = High[indexH] + AdjDiff1;
        AdjHigh2  = High[indexH] + AdjDiff2;
         
        if (pips == true)
         {
          ObjectCreate ("("+indexH+")"+" High - h_EMA",OBJ_TEXT,0,Time[indexH],AdjHigh1);
          ObjectSetText("("+indexH+")"+" High - h_EMA",DoubleToStr((High[indexH] - maHigh[indexH]) * xfactor,1),8,"Arial",C'255,255,155');
         }
        if (dnarrows == true)
         {
          ObjectCreate ("("+indexH+")"+" ArrowDown",OBJ_ARROW_DOWN,0,Time[indexH],AdjHigh2);
          ObjectSet("("+indexH+")"+" ArrowDown",OBJPROP_COLOR,Yellow);
         }
       }
//------------------------------------------------------------------
      //if (LowDiff[i] < -Min_Dist && pLowDiff > -Min_Dist)
      if (pLowDiff > -Min_Dist && LowDiff[i] < -Min_Dist)
       {
        StartIndexL = i;
       }
      //if (LowDiff[i] < -Min_Dist && nLowDiff > -Min_Dist)
      if (pLowDiff < -Min_Dist && LowDiff[i] > -Min_Dist)
       {
        EndIndexL = i;
        ArrayResize (mIndex,StartIndexL-EndIndexL+1);
        ArrayCopy(mIndex,LowDiff,0,EndIndexL,StartIndexL-EndIndexL+1);
        indexL = ArrayMinimum(mIndex,0); // local min value between StartIndex and EndIndex
        indexL = EndIndexL + indexL;

        AdjLow1  = Low[indexL] - (AdjDiff1);
        AdjLow2  = Low[indexL] - (AdjDiff2);

        if (pips == true)
         {
          ObjectCreate ("("+indexL+")"+" Low - l_EMA",OBJ_TEXT,0,Time[indexL],AdjLow1);
          ObjectSetText("("+indexL+")"+" Low - l_EMA",DoubleToStr((Low[indexL] - maLow[indexL]) * xfactor,1),8,"Arial",C'255,255,155');
         }
        if (uparrows == true)
         {
          ObjectCreate ("("+indexL+")"+" ArrowUp",OBJ_ARROW_UP,0,Time[indexL],AdjLow2);
          ObjectSet("("+indexL+")"+" ArrowUp",OBJPROP_COLOR,Yellow);
         }
       }
      i--;
     }
return(0);
}