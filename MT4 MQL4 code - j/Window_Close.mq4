//+------------------------------------------------------------------+
//|                                                 Window_Close.mq4 |
//|                           Copyright 2014, SilverSurfer Financial |
//|                                     https://www.SilverSurfer.com |
//+------------------------------------------------------------------+

#property copyright "Copyright 2014, SilverSurfer Financial"
#property link      "https://www.SilverSurfer.com"
 // close all sub-windows except for focus window
 
#include <WinUser32.mqh>

#import "user32.dll"
// int      PostMessageA(int hWnd,int Msg,int wParam,int lParam);
   int      GetWindow(int hWnd,int uCmd);
   int      GetParent(int hWnd);
#import

#define WM_CLOSE                       0x0010
                   
int start()
{      
   bool ChildWChange = true;   
   int intParent = GetParent( WindowHandle( Symbol(), Period() ) );   
   int intChild = GetWindow( intParent, GW_HWNDFIRST );  
     
   if ( intChild > 0 )   
   {
      if ( intChild != intParent )   PostMessageA( intChild, WM_CLOSE, 0, 0 );
   }
   else      ChildWChange = false;   
   
   while( ChildWChange )
   {
      intChild = GetWindow( intChild, GW_HWNDNEXT );   
   
      if ( intChild > 0 )   
      { 
         if ( intChild != intParent )   PostMessageA( intChild, WM_CLOSE, 0, 0 );
      }
      else   ChildWChange = false;   
   }
   
   // Now do the current window
   //PostMessageA( intParent, WM_CLOSE, 0, 0 );
return;
}



