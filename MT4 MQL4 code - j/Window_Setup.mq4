//+------------------------------------------------------------------+
//|                                                 Window_Setup.mq4 |
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
   void  keybd_event(int bVk,int bScan,int dwFlags,int dwExtraInfo);
   void  mouse_event(int dwFlags,int& dx,int& dy,int dwData,int dwExtraInfo);
   int   PostMessageA(int hWnd, int Msg, int wParam, int lParam);
   int   GetWindow(int hWnd,int uCmd);
   int   GetParent(int hWnd);
#import

#define MOUSEEVENTF_MOVE      0x0001   // mouse move
#define MOUSEEVENTF_LEFTDOWN  0x0002   // left button down
#define MOUSEEVENTF_LEFTUP    0x0004   // left button up

#define WM_COMMAND            0x0111

#define VK_BACK               8        //BACKSPACE key
#define VK_RETURN             13       //ENTER     key
#define VK_ESCAPE             27       //ESC       key
#define VK_SPACE              32       //SPACEBAR


void start()
{  
   SetupChartWindows();
   Sleep(20);
}

int SetupChartWindows()
{
   int i, x, y;

   i = 0;   
   x = 1908;
   y = 1002;

   SetCursorPos(x,y);
   while (i<=20) // scroll to last window
   {
      i++;      
      mouse_event(MOUSEEVENTF_LEFTDOWN,0,0,0,0);
      mouse_event(MOUSEEVENTF_LEFTUP,0,0,0,0);
      //Sleep(160); //observe movement
   }

   i = 0;   
   x = 1862;
   y = 1002;

   SetCursorPos(x,y);
   while (i<32) // click on windows from right to left
   {
      i++;      
      mouse_event(MOUSEEVENTF_MOVE,-20,0,0,0);
      mouse_event(MOUSEEVENTF_LEFTDOWN,0,0,0,0);
      mouse_event(MOUSEEVENTF_LEFTUP,0,0,0,0);
      //Sleep(160); //observe movement
   }

   i = 0;   
   x = 1882;
   y = 1002;

   SetCursorPos(x,y);
   while (i<=20) // scroll to first window
   {
      i++;      
      mouse_event(MOUSEEVENTF_LEFTDOWN,0,0,0,0);
      mouse_event(MOUSEEVENTF_LEFTUP,0,0,0,0);
      //Sleep(160); //observe movement
   }

   i = 0;   
   x = 1862;
   y = 1002;

   SetCursorPos(x,y);
   while (i<32) // click on windows from right to left
   {
      i++;      
      mouse_event(MOUSEEVENTF_MOVE,-20,0,0,0);
      mouse_event(MOUSEEVENTF_LEFTDOWN,0,0,0,0);
      mouse_event(MOUSEEVENTF_LEFTUP,0,0,0,0);
      //Sleep(160); //observe movement
   }
   return(0);
}