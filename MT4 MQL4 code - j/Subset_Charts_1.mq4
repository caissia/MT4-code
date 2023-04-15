//+------------------------------------------------------------------+
//|                                                Subset_Charts.mq4 |
//|                           Copyright 2014, SilverSurfer Financial |
//|                                     https://www.SilverSurfer.com |
//+------------------------------------------------------------------+

#property copyright "Copyright 2014, SilverSurfer Financial"
#property link      "https://www.SilverSurfer.com"
#property show_inputs   //all the currency pairs in subset are opened = 20 subwindows
                        //user sets template to be used on all charts to be opened

#include <WinUser32.mqh>

#import "user32.dll"
   int   GetParent(int hWnd);
   bool  SetCursorPos(int X, int Y);
   int   GetWindow(int hWnd,int uCmd);
   int   GetAncestor(int hWnd, int gaFlags); 
   int   GetDlgItem(int hDlg, int nIDDlgItem);
   int   PostMessageA(int hWnd, int Msg, int wParam, int lParam);
   int   SendMessageA(int hWnd, int Msg, int wParam, int lParam);
   void  mouse_event(int dwFlags,int& dx,int& dy,int dwData,int dwExtraInfo);
#import

#define MOUSEEVENTF_MOVE      0x0001 // mouse move
#define MOUSEEVENTF_LEFTDOWN  0x0002 // left button down
#define MOUSEEVENTF_LEFTUP    0x0004 // left button up
#define WM_COMMAND            0x0111
#define WM_KEYDOWN            0x0100
#define VK_HOME               0x0024
#define VK_DOWN               0x0028

#define WM_MDINEXT            548

extern int TemplateNumber = 1;   // preset to Triple Threat template
extern bool Monthly = false;     // get timeframe
extern bool Weekly = false;
extern bool Daily = false; 
extern bool H4 = false;
extern bool H1 = false;

int tF = 0;

void start()
{
   int i = 0; 
   
   string SymbolArray[19] = {"AUDJPY", "AUDUSD", "CADJPY", "CHFJPY", "EURAUD", "EURCAD", "EURGBP", "EURJPY", "EURNZD", "EURUSD", "GBPAUD", "GBPCAD", "GBPCHF", "GBPJPY", "GBPUSD", "NZDJPY", "NZDUSD", "USDCAD", "USDCHF", "USDJPY"};

   TimeFrameP();
   Sleep (20);
   
   while(i < 20)
   {
      ChartWindow(SymbolArray[i]);  //creates as many windows as there are in the array
      Sleep(125);
      
      SetupTemplate();              //setup the template for all the new charts
      Sleep(125);
      
      SetupTimeFrame();             //setup timeframe for all the new charts
      Sleep(125);
      
      i++;
      
      if (i == 20) {PlaySound("bell.wav");}
   }
   Sleep(20);
   
   CloseFirstWindow();              //delete window that executed the script
   Sleep(20);
   
   SetupScroll();                   //setup scrolling from left to right
   Sleep(20);
   
   GlobalVariableSet("TemplateN",TemplateNumber);
}

int ChartWindow(string SymbolName)
{
   int hFile, SymbolsTotal, hTerminal, hWnd;

   hFile = FileOpenHistory("symbols.sel", FILE_BIN|FILE_READ);
   if(hFile < 0) return(-1);

   SymbolsTotal = (FileSize(hFile) - 4) / 128;
   FileSeek(hFile, 4, SEEK_SET);

   hTerminal = GetAncestor(WindowHandle(Symbol(), Period()), 2);

   hWnd = GetDlgItem(hTerminal, 0xE81C);
   hWnd = GetDlgItem(hWnd, 0x50);
   hWnd = GetDlgItem(hWnd, 0x8A71);

   PostMessageA(hWnd, WM_KEYDOWN, VK_HOME, 0);
   
   for(int i = 0; i < SymbolsTotal; i++)
   {
      if(FileReadString(hFile, 12) == SymbolName)
      {
         PostMessageA(hTerminal, WM_COMMAND, 33160, 0);
         return(0);
      }
      PostMessageA(hWnd, WM_KEYDOWN, VK_DOWN, 0);
      FileSeek(hFile, 116, SEEK_CUR);
   }

   FileClose(hFile);
   
   return(-1);
}

void SetupTemplate()
{
   int intParent = GetParent( WindowHandle( Symbol(), Period() ) );
   int intChild = GetWindow( intParent, 0 );
 
   PostMessageA( intChild, WM_COMMAND, 34800 + TemplateNumber, 0 );
   
   Sleep (125);
   return;
}

void SetupTimeFrame()
{
   bool ChildWChange = true;   
   int intParent = GetParent( WindowHandle( Symbol(), Period() ) );   
   int intChild = GetWindow( intParent, 0 );  
    
   PostMessageA(intChild, 0x0111, tF, 0);
   
   keybd_event(13,0,0,0);  keybd_event(13,0,2,0);  // ENTER....In case of popup
   keybd_event(13,0,0,0);  keybd_event(13,0,2,0);  // ENTER....In case of popup   
   keybd_event(27,0,0,0);  keybd_event(27,0,2,0);  // ESCAPE...In case of popup
   
   Sleep (125);
   return;
}


int TimeFrameP()
{
   int tI;
          
   if (Monthly == true)    {tI = PERIOD_MN1;}
   if (Weekly == true)     {tI = PERIOD_W1;}
   if (Daily == true)      {tI = PERIOD_D1;}
   if (H4 == true)         {tI = PERIOD_H4;}
   if (H1 == true)         {tI = PERIOD_H1;}

   switch(tI)
   {
      case PERIOD_MN1:  tF = 33334;  break;
      case PERIOD_W1:   tF = 33141;  break;
      case PERIOD_D1:   tF = 33134;  break;
      case PERIOD_H4:   tF = 33136;  break;
      case PERIOD_H1:   tF = 35400;  break;
   }
   
   GlobalVariableSet("TimeFrameN",tI);
   return(tF);
}


void CloseFirstWindow()
{
   int intParent = GetParent( WindowHandle( Symbol(), Period() ) );   
   
   PostMessageA( intParent, WM_CLOSE, 0, 0 );   

}

int SetupScroll()
{
   int i, x, y;
   
   i = 0;
   x = 1270;
   y = 740;
   
   SetCursorPos(x,y);
   
   while (i<40) // scroll all the way to the right
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
   
   while (i<36) // click on windows from right to left
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
   
   while (i<40) // scroll all the way to the right
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
   
   while (i<36) // click on windows from right to left
   {
      i++;      
      mouse_event(MOUSEEVENTF_MOVE,-20,0,0,0);
      mouse_event(MOUSEEVENTF_LEFTDOWN,0,0,0,0);
      mouse_event(MOUSEEVENTF_LEFTUP,0,0,0,0);
      //Sleep(250); //observe movement
   }

   return(0);
}