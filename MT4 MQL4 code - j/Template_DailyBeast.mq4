//+------------------------------------------------------------------+
//|                                          Template_DailyBeast.mq4 |
//|                                Copyright 2018, Caissia Financial |
//|                                          https://www.caissia.com |
//+------------------------------------------------------------------+

#property copyright "Copyright 2018, Caissia Financial"
#property link      "https://www.caissia.com"

#include <WinUser32.mqh>

#import "user32.dll"
   int      PostMessageA(int hWnd,int Msg,int wParam,int lParam);
   int      GetWindow(int hWnd,int uCmd);
   int      GetParent(int hWnd);
   void     keybd_event(int bVk,int bScan,int dwFlags,int dwExtraInfo);
#import

#define VK_RETURN 13                                                                            // ENTER key
#define VK_ESCAPE 27                                                                            // ESC key
            
int start()
   {  
    bool ChildWChange = true;
    int intParent = GetParent( WindowHandle( Symbol(), Period() ) );
    int intChild = GetWindow( intParent, 0 );    
    int tI = 16;                                                                                 // 16 = DailyBeast Template

    while(ChildWChange)                                                                          //changes sub-windows
         {
          intChild = GetWindow(intChild, 2);   

          if (intChild > 0)   
             { 
              if (intChild != intParent)   PostMessageA( intChild, WM_COMMAND, 34800 + tI, 0 );
             }
          else ChildWChange = false;   
         }

    PostMessageA( intParent, WM_COMMAND, 34800 + tI, 0 );                                        // changes parent window

    keybd_event(13,0,0,0);  keybd_event(13,0,2,0);                                               // ENTER....In case of popup
    keybd_event(13,0,0,0);  keybd_event(13,0,2,0);                                               // ENTER....In case of popup   
    keybd_event(27,0,0,0);  keybd_event(27,0,2,0);                                               // ESCAPE...In case of popup
  
    GlobalVariableSet("TemplateN",tI);
    Sleep(100);
         
    return(0);
   }
 

