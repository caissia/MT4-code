//+------------------------------------------------------------------+
//|                                                Template_Next.mq4 |
//|                           Copyright 2014, SilverSurfer Financial |
//|                                     https://www.SilverSurfer.com |
//+------------------------------------------------------------------+
// This toggles the following templates: Quicksilver, Triple, Wave

#property copyright "Copyright 2014, SilverSurfer Financial"
#property link      "https://www.SilverSurfer.com"
//#property show_inputs

#include <WinUser32.mqh>

#import "user32.dll"
   int      PostMessageA(int hWnd,int Msg,int wParam,int lParam);
   int      GetWindow(int hWnd,int uCmd);
   int      GetParent(int hWnd);
   void     keybd_event(int bVk,int bScan,int dwFlags,int dwExtraInfo);
#import

#define VK_RETURN 13                     //ENTER key
#define VK_ESCAPE 27                     //ESC key

int start()
{  
   int intParent = GetParent( WindowHandle( Symbol(), Period() ) );   

   int tI = GlobalVariableGet("TemplateN");

   if (tI != 0 && tI != 3 && tI != 14) 
      {
       tI = 0;
      }
   else if (tI == 0)
      {
       tI = 3;
      }
   else if (tI == 3)
      {
       tI = 14;
      }
   else if (tI == 14)
      {
       tI = 0;
      }

      PostMessageA( intParent, WM_COMMAND, 34800 + tI, 0 );

      keybd_event(13,0,0,0);  keybd_event(13,0,2,0);  // ENTER....In case of popup
      keybd_event(13,0,0,0);  keybd_event(13,0,2,0);  // ENTER....In case of popup   
      keybd_event(27,0,0,0);  keybd_event(27,0,2,0);  // ESCAPE...In case of popup

      GlobalVariableSet("TemplateN",tI);
      Sleep(100);

   return(0);
}