//+------------------------------------------------------------------+
//|                                                TimeFrame_All.mq4 |
//|                           Copyright 2014, SilverSurfer Financial |
//|                                     https://www.SilverSurfer.com |
//+------------------------------------------------------------------+

#property copyright "Copyright 2014, SilverSurfer Financial"
#property link      "https://www.SilverSurfer.com"
#property show_inputs      //User time frame input changes all opened charts

#import "user32.dll"
   int      PostMessageA(int hWnd,int Msg,int wParam,int lParam);
   int      GetWindow(int hWnd,int uCmd);
   int      GetParent(int hWnd);
   void     keybd_event(int bVk,int bScan,int dwFlags,int dwExtraInfo);
#import

extern bool M1 = false;
extern bool M5 = false;
extern bool M15 = false;
extern bool M30 = false;
extern bool H1 = false;
extern bool H4 = false;
extern bool D1 = false;
extern bool W1 = false;
extern bool MN1 = false;

#define VK_RETURN 13       //ENTER key
#define VK_ESCAPE 27       //ESC key

   int fI, tF;
                   
int start()
{      
   bool ChildWChange = true;   
   int intParent = GetParent( WindowHandle( Symbol(), Period() ) );   
   int intChild = GetWindow( intParent, 0 );  
   
   TimeFrameP();
    
   switch(fI)
   {
      case PERIOD_M1:   tF = 33137;  break;
      case PERIOD_M5:   tF = 33138;  break;
      case PERIOD_M15:  tF = 33139;  break;
      case PERIOD_M30:  tF = 33140;  break;
      case PERIOD_H1:   tF = 35400;  break;
      case PERIOD_H4:   tF = 33136;  break;
      case PERIOD_D1:   tF = 33134;  break;
      case PERIOD_W1:   tF = 33141;  break;
      case PERIOD_MN1:  tF = 33334;  break;
   } 
   
   while(ChildWChange)
   {
      intChild = GetWindow(intChild, 2);   
   
      if (intChild > 0)   
      { 
         if (intChild != intParent)   PostMessageA(intChild, 0x0111, tF, 0);
      }
      else ChildWChange = false;   
   }
   
   // Now do the current window
   PostMessageA(intParent, 0x0111, tF, 0);
   
   keybd_event(13,0,0,0);  keybd_event(13,0,2,0);  // ENTER....In case of popup
   keybd_event(13,0,0,0);  keybd_event(13,0,2,0);  // ENTER....In case of popup   
   keybd_event(27,0,0,0);  keybd_event(27,0,2,0);  // ESCAPE...In case of popup
    
   GlobalVariableSet("TimeFrameN",fI);
   Sleep(100);
   
   return;
}

int TimeFrameP()
{
         fI = GlobalVariableGet("TimeFrameN");     // time frame period
         if (fI == 0)      {fI = PERIOD_D1;}       //check if GlobalVariable was reset to 0
            
         if (M1 == true)   {fI = PERIOD_M1;}
         if (M5 == true)   {fI = PERIOD_M5;}
         if (M15 == true)  {fI = PERIOD_M15;}
         if (M30 == true)  {fI = PERIOD_M30;}
         if (H1 == true)   {fI = PERIOD_H1;}
         if (H4 == true)   {fI = PERIOD_H4;}
         if (D1 == true)   {fI = PERIOD_D1;}
         if (W1 == true)   {fI = PERIOD_W1;}
         if (MN1 == true)  {fI = PERIOD_MN1;}

         return(fI);
}


