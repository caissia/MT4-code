//+------------------------------------------------------------------+
//|                                            Clone_ChartWindow.mq4 |
//|                           Copyright 2014, SilverSurfer Financial |
//|                                     https://www.SilverSurfer.com |
//+------------------------------------------------------------------+

#property copyright "Copyright 2014, SilverSurfer Financial"
#property link      "https://www.SilverSurfer.com"
//clone the chart window including Period, Symbol, and Template

#import "user32.dll"
   void  keybd_event(int bVk,int bScan,int dwFlags,int dwExtraInfo);
   int   GetAncestor(int hWnd, int gaFlags);
   int   PostMessageA(int hWnd, int Msg, int wParam, int lParam);
   int   SendMessageA(int hWnd, int Msg, int wParam, int lParam);
   int   GetWindow(int hWnd,int uCmd);
   int   GetParent(int hWnd);
   int   GetDlgItem(int hDlg, int nIDDlgItem); 
#import

#define WM_COMMAND                     0x0111
#define KEYEVENTF_EXTENDEDKEY          0x0001
#define KEYEVENTF_KEYUP                0x0002
#define WM_KEYDOWN                     0x0100
#define VK_HOME                        0x0024
#define VK_DOWN                        0x0028
#define WM_MDINEXT                     0x0224

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
   SetupWindow(Symbol());
   Sleep(1000);
   
   SetupSymbol();
   Sleep(20);
   
   SetupPeriod();
   Sleep(20);
   
   SetupTemplate();
   Sleep(20);

   ActivateParentW();
   return;
}

int SetupWindow(string SymbolName)
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

int SetupSymbol()
{ 
   string CurrencyPair = Symbol();
   
   LL = StringSubstr(CurrencyPair, 0, 1);       EventNumber();     int L1 = eN;
   LL = StringSubstr(CurrencyPair, 1, 1);       EventNumber();     int L2 = eN;
   LL = StringSubstr(CurrencyPair, 2, 1);       EventNumber();     int L3 = eN;
   LL = StringSubstr(CurrencyPair, 3, 1);       EventNumber();     int L4 = eN;
   LL = StringSubstr(CurrencyPair, 4, 1);       EventNumber();     int L5 = eN;
   LL = StringSubstr(CurrencyPair, 5, 1);       EventNumber();     int L6 = eN;
   
   //Alert (L1," ",L2," ",L3," ",L4," ",L5," ",L6);  Sleep(5000); // check if correct pair
   
   keybd_event(32,0,0,0);  keybd_event(32,0,2,0);  // Spacebar
   keybd_event(L1,0,0,0);  keybd_event(L1,0,2,0);  // 1st letter of Symbol
   keybd_event(L2,0,0,0);  keybd_event(L2,0,2,0);  // 2nd letter of Symbol
   keybd_event(L3,0,0,0);  keybd_event(L3,0,2,0);  // 3rd letter of Symbol
   keybd_event(L4,0,0,0);  keybd_event(L4,0,2,0);  // 4th letter of Symbol
   keybd_event(L5,0,0,0);  keybd_event(L5,0,2,0);  // 5th letter of Symbol
   keybd_event(L6,0,0,0);  keybd_event(L6,0,2,0);  // 6th letter of Symbol
   keybd_event(13,0,0,0);  keybd_event(13,0,2,0);  // ENTER
   
   Sleep (20);
   return(0);
}

int SetupPeriod()
{   
   int intParent = GetParent( WindowHandle( Symbol(), Period() ) );
   int intChild = GetWindow( intParent, 0 );
     
   int fI = Period();   // time frame from original chart
   int tF = 0;          // time frame number
    
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
    
   PostMessageA( intChild, 0x0111, tF, 0);
   
   Sleep (20);
   return(0);
}

int SetupTemplate()
{
   int intParent = GetParent( WindowHandle( Symbol(), Period() ) );
   int intChild = GetWindow( intParent, 0 );
   int tI = GlobalVariableGet("TemplateN");   // template index/number 
 
   PostMessageA( intChild, WM_COMMAND, 34800 + tI, 0 );
   
   Sleep (20);
   return(0);
}

int ActivateParentW()
{
      int gP = GetParent(GetParent(WindowHandle(Symbol(), Period())));
      SendMessageA(gP, WM_MDINEXT, 0, 0); 
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