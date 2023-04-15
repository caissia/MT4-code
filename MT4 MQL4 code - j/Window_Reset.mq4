//+------------------------------------------------------------------+
//|                                                 Window_Reset.mq4 |
//|                           Copyright 2014, SilverSurfer Financial |
//|                                     https://www.SilverSurfer.com |
//+------------------------------------------------------------------+

#property copyright "Copyright 2014, SilverSurfer Financial"
#property link      "https://www.SilverSurfer.com"

   //Setup chart window to start from the first template, period, symbol
   //also setup scrolling chart windows from left to right
   
#include <WinUser32.mqh>
 
#import "user32.dll"
   bool  SetCursorPos(int X, int Y);
   void  keybd_event (int bVk,int bScan,int dwFlags,int dwExtraInfo);
   void  mouse_event (int dwFlags,int& dx,int& dy,int dwData,int dwExtraInfo);
   int   PostMessageA(int hWnd, int Msg, int wParam, int lParam);
   int   GetWindow   (int hWnd,int uCmd);
   int   GetParent   (int hWnd);
#import

#define MOUSEEVENTF_MOVE               0x0001 // mouse move
#define MOUSEEVENTF_LEFTDOWN           0x0002 // left button down
#define MOUSEEVENTF_LEFTUP             0x0004 // left button up

#define WM_COMMAND                     0x0111

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

#define VK_BACK 8       //BACKSPACE key
#define VK_RETURN 13    //ENTER     key
#define VK_ESCAPE 27    //ESC       key
#define VK_SPACE 32     //SPACEBAR

int eN;                 //GlobalVariable for symbol change
string LL;              //GlobalVariable for symbol change

void start()
{   
   SetupSymbol();
   Sleep(20);
   
   SetupPeriod();
   Sleep(20);
   
   SetupTemplate();
   Sleep(20);

   SetupChartWindows();
   return;
}

int SetupSymbol()
{ 
   string CurrencyPair = "EURNZD";
   
   LL = StringSubstr(CurrencyPair, 0, 1);       EventNumber();     int L1 = eN;
   LL = StringSubstr(CurrencyPair, 1, 1);       EventNumber();     int L2 = eN;
   LL = StringSubstr(CurrencyPair, 2, 1);       EventNumber();     int L3 = eN;
   LL = StringSubstr(CurrencyPair, 3, 1);       EventNumber();     int L4 = eN;
   LL = StringSubstr(CurrencyPair, 4, 1);       EventNumber();     int L5 = eN;
   LL = StringSubstr(CurrencyPair, 5, 1);       EventNumber();     int L6 = eN;
   
   //Alert (L1," ",L2," ",L3," ",L4," ",L5," ",L6);  Sleep(5000); // check if correct pair
   
   keybd_event(32,0,0,0);  keybd_event(32,0,2,0);  // Spacebar
      
      int i = 0;
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
   keybd_event(13,0,0,0);  keybd_event(13,0,2,0);  // ENTER
   
   //Sleep(10);                                      // In case of popup
   
   keybd_event(13,0,0,0);  keybd_event(13,0,2,0);  // Enter....In case of popup
   keybd_event(13,0,0,0);  keybd_event(13,0,2,0);  // Enter....In case of popup
   keybd_event(13,0,0,0);  keybd_event(13,0,2,0);  // Enter....In case of popup
   keybd_event(27,0,0,0);  keybd_event(27,0,2,0);  // Esc......In case of popup
   
   GlobalVariableSet("SymbolN",0);  // 0 = EURNZD, the first currency pair of the complete set
   GlobalVariableSet("Subset",0);   // 0 = AUDJPY, the first currency pair of the subset
   Sleep (20);
   
   return(0);
}

int SetupPeriod()
{   
   int intParent = GetParent( WindowHandle( Symbol(), Period() ) );
   int intChild = GetWindow( intParent, 0 );
   
   int fI = PERIOD_D1;  
   int tF = 33134;                                 // time frame number for Daily chart
    
   PostMessageA( intChild, 0x0111, tF, 0);
   
   keybd_event(13,0,0,0);  keybd_event(13,0,2,0);  // Enter....In case of popup
   keybd_event(13,0,0,0);  keybd_event(13,0,2,0);  // Enter....In case of popup
   keybd_event(27,0,0,0);  keybd_event(27,0,2,0);  // Esc......In case of popup
   
   GlobalVariableSet("TimeFrameN",fI);             // sets TimeFrameN to Daily chart
   Sleep (20);
   
   return(0);
}

int SetupTemplate()
{
   int intParent = GetParent( WindowHandle( Symbol(), Period() ) );
   int intChild = GetWindow( intParent, 0 );
   int tI = 0;
 
   PostMessageA(intChild, WM_COMMAND, 34800 + tI, 0);    // sets first template
   
   GlobalVariableSet("TemplateN",tI);                    // sets first template
   Sleep (20);
   return(0);
}

int SetupChartWindows()
{
   int i, x, y;
   
   i = 0;
   x = 1270;
   y = 740;
   
   SetCursorPos(x,y);
   
   while (i<40)
   {
      i++;      
      mouse_event(MOUSEEVENTF_LEFTDOWN,0,0,0,0);
      mouse_event(MOUSEEVENTF_LEFTUP,0,0,0,0);
      //Sleep(250); //observe movement
   }

   i = 0;   
   x = 1240;
   y = 740;
   
   SetCursorPos(x,y);
   
   while (i<36)
   {
      i++;      
      mouse_event(MOUSEEVENTF_MOVE,-20,0,0,0);
      mouse_event(MOUSEEVENTF_LEFTDOWN,0,0,0,0);
      mouse_event(MOUSEEVENTF_LEFTUP,0,0,0,0);
      //Sleep(250); //observe movement
   }

   i = 0;
   x = 1255;
   y = 740;
   
   SetCursorPos(x,y);
   
   while (i<40)
   {
      i++;      
      mouse_event(MOUSEEVENTF_LEFTDOWN,0,0,0,0);
      mouse_event(MOUSEEVENTF_LEFTUP,0,0,0,0);
      //Sleep(250); //observe movement
   }

   i = 0;   
   x = 1240;
   y = 740;
   
   SetCursorPos(x,y);
   
   while (i<36)
   {
      i++;      
      mouse_event(MOUSEEVENTF_MOVE,-20,0,0,0);
      mouse_event(MOUSEEVENTF_LEFTDOWN,0,0,0,0);
      mouse_event(MOUSEEVENTF_LEFTUP,0,0,0,0);
      //Sleep(250); //observe movement
   }

   return(0);
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
         
         //Alert (LL," ",eN); Sleep(2000); //check correct assignments
         return(eN);
}