//+------------------------------------------------------------------+
//|                                               TimeFrame-Next.mq4 |
//|                           Copyright 2014, SilverSurfer Financial |
//|                                     https://www.SilverSurfer.com |
//+------------------------------------------------------------------+

#property copyright "Copyright 2014, SilverSurfer Financial"
#property link      "https://www.SilverSurfer.com"

#include <WinUser32.mqh>

#import     "user32.dll"
   int      PostMessageA(int hWnd,int Msg,int wParam,int lParam);
   int      GetWindow(int hWnd,int uCmd);
   int      GetParent(int hWnd);
   void     keybd_event(int bVk,int bScan,int dwFlags,int dwExtraInfo);
#import

#define VK_RETURN 13                   //ENTER key
#define VK_ESCAPE 27                   //ESC key

int start()
{
   int intParent = GetParent( WindowHandle( Symbol(), Period() ) );   
   int fI = 0;          // time frame period
   int tF = 0;          // time frame number
   
//+------------------------------------------------------------------+
//|                       Next - TimeFrame                           |
//+------------------------------------------------------------------+

   fI = GlobalVariableGet("TimeFrameN");
   if (fI == 0)   {fI = PERIOD_H4;}       //check if GlobalVariable was reset to 0
      
   switch(fI)
   {
      case PERIOD_M1:   fI = PERIOD_M5;      tF = 33138;  break;
      case PERIOD_M5:   fI = PERIOD_M15;     tF = 33139;  break;
      case PERIOD_M15:  fI = PERIOD_M30;     tF = 33140;  break;      
      case PERIOD_M30:  fI = PERIOD_H1;      tF = 35400;  break;
      case PERIOD_H1:   fI = PERIOD_H4;      tF = 33136;  break;
      case PERIOD_H4:   fI = PERIOD_D1;      tF = 33134;  break;
      case PERIOD_D1:   fI = PERIOD_W1;      tF = 33141;  break;
      case PERIOD_W1:   fI = PERIOD_MN1;     tF = 33334;  break;
      case PERIOD_MN1:  fI = PERIOD_M1;      tF = 33137;  break;
   }  
   
   PostMessageA( intParent, 0x0111, tF, 0);
   
   keybd_event(13,0,0,0);  keybd_event(13,0,2,0);  // ENTER....In case of popup
   keybd_event(13,0,0,0);  keybd_event(13,0,2,0);  // ENTER....In case of popup   
   keybd_event(27,0,0,0);  keybd_event(27,0,2,0);  // ESCAPE...In case of popup
   
   GlobalVariableSet("TimeFrameN",fI);
   Sleep (100);
   
   return;
}