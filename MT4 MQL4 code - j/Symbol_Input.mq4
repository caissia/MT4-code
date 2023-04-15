//+------------------------------------------------------------------+
//|                                                  Symbol_Input.mq4|
//|                           Copyright 2014, SilverSurfer Financial |
//|                                     https://www.SilverSurfer.com |
//+------------------------------------------------------------------+

#property copyright "Copyright 2014, SilverSurfer Financial"
#property link      "https://www.SilverSurfer.com"
#property show_inputs      //input currency pair

#import "user32.dll"
   void  keybd_event(int bVk,int bScan,int dwFlags,int dwExtraInfo);
#import

extern int CurrencyPairN = 0;

#define VK_A 65
#define VK_B 66
#define VK_C 67
#define VK_D 68
#define VK_E 69
#define VK_F 70
#define VK_G 71
#define VK_H 72
#define VK_J 74
#define VK_N 78
#define VK_P 80
#define VK_R 82
#define VK_S 83
#define VK_U 85
#define VK_Y 89
#define VK_Z 90

#define VK_BACK      8     //Backspace
#define VK_RETURN   13     //Enter
#define VK_ESCAPE   27     //Esc
#define VK_SPACE    32     //Spacebar

string LL;
int i, sI, eN, L1, L2, L3, L4, L5, L6;


void start()
{     
   SetupSymbol();
   //Sleep(20);
   
   SendSymbol();
   //Sleep(20);
}

int SetupSymbol()
{
   int sI = CurrencyPairN;
   if (sI < 0 || sI > 23) {return;}    //ends script due to incorrect user input
   
   string SymbolArray[23] = {"EURNZD", "GBPJPY", "GBPAUD", "GBPCAD", "GBPUSD", "EURJPY", "EURAUD", "GBPCHF", "EURCAD", "AUDJPY", "EURUSD", "CADJPY", "USDCAD", "NZDJPY", "AUDUSD", "CHFJPY", "USDCHF", "NZDUSD", "USDJPY", "CADCHF", "AUDCHF", "AUDCAD", "EURGBP", "EURCHF"};
   //Alert(sI," ",SymbolArray[sI]); Sleep(1000);
   string CurrencyPair = SymbolArray[sI];
    
   LL = StringSubstr(CurrencyPair, 0, 1);       EventNumber();     L1 = eN;
   LL = StringSubstr(CurrencyPair, 1, 1);       EventNumber();     L2 = eN;
   LL = StringSubstr(CurrencyPair, 2, 1);       EventNumber();     L3 = eN;
   LL = StringSubstr(CurrencyPair, 3, 1);       EventNumber();     L4 = eN;
   LL = StringSubstr(CurrencyPair, 4, 1);       EventNumber();     L5 = eN;
   LL = StringSubstr(CurrencyPair, 5, 1);       EventNumber();     L6 = eN;
   
   //Alert (L1," ",L2," ",L3," ",L4," ",L5," ",L6);  Sleep(5000); // check if correct pair
   
   GlobalVariableSet("SymbolN",sI);
   return;
}

int SendSymbol()
{  
   if (sI <0 || sI > 23) {return;}    //ends script due to incorrect user input
   
   keybd_event(27,0,0,0);  keybd_event(27,0,2,0);  // Esc
   keybd_event(32,0,0,0);  keybd_event(32,0,2,0);  // Spacebar
   
   while (i<20)
   {     
      keybd_event(8,0,0,0);  keybd_event(8,0,2,0); // Backspace...clears any data
      i++;
   }
  
   keybd_event(L1,0,0,0);  keybd_event(L1,0,2,0);  // 1st letter of Symbol
   keybd_event(L2,0,0,0);  keybd_event(L2,0,2,0);  // 2nd letter of Symbol
   keybd_event(L3,0,0,0);  keybd_event(L3,0,2,0);  // 3rd letter of Symbol
   keybd_event(L4,0,0,0);  keybd_event(L4,0,2,0);  // 4th letter of Symbol
   keybd_event(L5,0,0,0);  keybd_event(L5,0,2,0);  // 5th letter of Symbol
   keybd_event(L6,0,0,0);  keybd_event(L6,0,2,0);  // 6th letter of Symbol
   keybd_event(13,0,0,0);  keybd_event(13,0,2,0);  // Enter
   
   keybd_event(13,0,0,0);  keybd_event(13,0,2,0);  // Enter....In case of popup
   keybd_event(13,0,0,0);  keybd_event(13,0,2,0);  // Enter....In case of popup
   keybd_event(13,0,0,0);  keybd_event(13,0,2,0);  // Enter....In case of popup
   keybd_event(27,0,0,0);  keybd_event(27,0,2,0);  // Esc......In case of popup
   
   return;
}

int EventNumber()
{   
         if (LL == "A")  {eN = 65;}
         if (LL == "B")  {eN = 66;}
         if (LL == "C")  {eN = 67;}
         if (LL == "D")  {eN = 68;}
         if (LL == "E")  {eN = 69;}
         if (LL == "F")  {eN = 70;}
         if (LL == "G")  {eN = 71;}
         if (LL == "H")  {eN = 72;}
         if (LL == "J")  {eN = 74;}
         if (LL == "N")  {eN = 78;}
         if (LL == "P")  {eN = 80;}
         if (LL == "R")  {eN = 82;}
         if (LL == "S")  {eN = 83;}
         if (LL == "U")  {eN = 85;}
         if (LL == "Y")  {eN = 89;}
         if (LL == "Z")  {eN = 90;}
         //Alert (LL," ",eN); Sleep(1000); //check correct assignments
         return(eN);
}

