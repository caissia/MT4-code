//+------------------------------------------------------------------+
//|                                                Subset_Charts.mq4 |
//|                           Copyright 2014, SilverSurfer Financial |
//|                                     https://www.SilverSurfer.com |
//+------------------------------------------------------------------+

#property copyright "Copyright 2014, SilverSurfer Financial"
#property link      "https://www.SilverSurfer.com"
#property show_inputs   //all the currency pairs in are opened = 24 subwindows
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
int i, eN, L1, L2, L3, L4, L5, L6;

extern int TemplateNumber = 0;   // preset to eQuest template
extern bool Monthly = false;     // get timeframe
extern bool Weekly = false;
extern bool Daily = true; 
extern bool H4 = false;
extern bool H1 = false;

int tF = 0;

void start()
{
   string SymbolArray[23] = {
                              "EURAUD", 
                              "GBPAUD", 
                              "AUDCAD", 
                              "EURCAD",  
                              "GBPCAD", 
                              "USDCAD", 
                              "AUDCHF", 
                              "CADCHF", 
                              "EURCHF", 
                              "GBPCHF",  
                              "USDCHF", 
                              "EURGBP", 
                              "AUDJPY", 
                              "CADJPY", 
                              "CHFJPY", 
                              "EURJPY", 
                              "GBPJPY", 
                              "NZDJPY",
                              "USDJPY", 
                              "EURNZD", 
                              "AUDUSD", 
                              "EURUSD", 
                              "GBPUSD", 
                              "NZDUSD"                           
                                       };

   TimeFrameP();
   //Sleep (20);
   
   while(i < 20)
   {
      ChartWindow();                // creates as many windows as there are in the array
      Sleep(400);

      SetupTemplate();              // setup the template for all the new charts
      Sleep(400);

      SetupTimeFrame();             // setup timeframe for all the new charts
      Sleep(400);

      SetupSymbol(SymbolArray[i]);  // setup the characters to send for the symbol
      Sleep(400);

      SendSymbol();                 // keyboard input of symbol
      Sleep(400);
      
      i++;

      if (i == 20) {PlaySound("bell.wav");}
   }
   
   CloseFirstWindow();              //delete window that executed the script
   Sleep(200);
   
   SetupScroll();                   //setup scrolling from left to right
   Sleep(200);
   
   GlobalVariableSet("TemplateN",TemplateNumber);
}


int ChartWindow()
{
         int hTerminal = GetAncestor(WindowHandle(Symbol(), Period()), 2);
         PostMessageA(hTerminal, WM_COMMAND, 33160, 0);
         return(0);
}


void SetupTemplate()
{
   int intParent = GetParent( WindowHandle( Symbol(), Period() ) );
   int intChild = GetWindow( intParent, 0 );
 
   PostMessageA( intChild, WM_COMMAND, 34800 + TemplateNumber, 0 );
   
   //Sleep (125);
   return;
}


void SetupTimeFrame()
{
   bool ChildWChange = true;   
   int intParent = GetParent( WindowHandle( Symbol(), Period() ) );   
   int intChild = GetWindow( intParent, 0 );  
    
   PostMessageA(intChild, 0x0111, tF, 0);
   
   //keybd_event(13,0,0,0);  keybd_event(13,0,2,0);  // ENTER....In case of popup
   //keybd_event(13,0,0,0);  keybd_event(13,0,2,0);  // ENTER....In case of popup   
   //keybd_event(27,0,0,0);  keybd_event(27,0,2,0);  // ESCAPE...In case of popup
   
   //Sleep (125);
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


void SetupSymbol(string SymbolName)
{  
   string CurrencyPair = SymbolName;
    
   LL = StringSubstr(CurrencyPair, 0, 1);       EventNumber();     L1 = eN;
   LL = StringSubstr(CurrencyPair, 1, 1);       EventNumber();     L2 = eN;
   LL = StringSubstr(CurrencyPair, 2, 1);       EventNumber();     L3 = eN;
   LL = StringSubstr(CurrencyPair, 3, 1);       EventNumber();     L4 = eN;
   LL = StringSubstr(CurrencyPair, 4, 1);       EventNumber();     L5 = eN;
   LL = StringSubstr(CurrencyPair, 5, 1);       EventNumber();     L6 = eN;
   
   //Alert (L1," ",L2," ",L3," ",L4," ",L5," ",L6);  //Sleep(5000); // check if correct pair
   return;
}


void SendSymbol()
{  
   int s = 0;
   
   keybd_event(27,0,0,0);  keybd_event(27,0,2,0);  // Esc
   keybd_event(32,0,0,0);  keybd_event(32,0,2,0);  // Spacebar
/*
   while (s<20) // not needed since these are new charts
   {     
      keybd_event(8,0,0,0);  keybd_event(8,0,2,0); // Backspace...clears any data
      s++;
   }
*/
   keybd_event(L1,0,0,0);  keybd_event(L1,0,2,0);  // 1st letter of Symbol
   keybd_event(L2,0,0,0);  keybd_event(L2,0,2,0);  // 2nd letter of Symbol
   keybd_event(L3,0,0,0);  keybd_event(L3,0,2,0);  // 3rd letter of Symbol
   keybd_event(L4,0,0,0);  keybd_event(L4,0,2,0);  // 4th letter of Symbol
   keybd_event(L5,0,0,0);  keybd_event(L5,0,2,0);  // 5th letter of Symbol
   keybd_event(L6,0,0,0);  keybd_event(L6,0,2,0);  // 6th letter of Symbol
   keybd_event(13,0,0,0);  keybd_event(13,0,2,0);  // Enter
   
   //keybd_event(13,0,0,0);  keybd_event(13,0,2,0);  // Enter....In case of popup
   //keybd_event(13,0,0,0);  keybd_event(13,0,2,0);  // Enter....In case of popup
   //keybd_event(13,0,0,0);  keybd_event(13,0,2,0);  // Enter....In case of popup
   //keybd_event(27,0,0,0);  keybd_event(27,0,2,0);  // Esc......In case of popup
   
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
         //Alert (LL," ",eN); //Sleep(1000); //check correct assignments
         return(eN);
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