//+------------------------------------------------------------------+
//|                                                Window_Scroll.mq4 |
//|                           Copyright 2014, SilverSurfer Financial |
//|                                     https://www.SilverSurfer.com |
//+------------------------------------------------------------------+

#property copyright "Copyright 2014, SilverSurfer Financial"
#property link      "https://www.SilverSurfer.com"

// moves to next chart window

#include <WinUser32.mqh>

#import "user32.dll"
   int      GetParent(int hWnd);
   int      SendMessageA(int hWnd, int Msg, int wParam, int lParam);
#import

#define WM_MDINEXT         548
           
int start()
{  

      int gP = GetParent(GetParent(WindowHandle(Symbol(), Period())));
      SendMessageA(gP, WM_MDINEXT, 0, 0); 
      
      return;
      
}