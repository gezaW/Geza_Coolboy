// Datum der Erstellung       : 09.08.1999
// Ersteller                  : Neuhold G�nther
// Datum letzter �nderung     : 15.10.2015
// Bearbeiter letzter �nderung:  Neuhold
// Art der letzten �nderung   :  Allgemein gemacht und nicht auf ein Programm bezogen
//
// Beschreibung der Unit:
//	Pr�ft ob das Programm schon l�uft
//  �ber die Mutex-Pr�fung wird verhindert, da� eine weitere Instanz des
//  Prgrammes gestartet wird.
//
// �nderungen:

unit CheckProgRun;

interface

implementation
uses Windows, Dialogs, SysUtils, Forms;

var
	mHandle: THandle;    // Mutexhandle
  h    : HWnd;
  PrgName : String;

Initialization

  PrgName := Application.Title;

//	mHandle := CreateMutex(nil,True,'TouchLager');
	mHandle := CreateMutex(nil,True,PWideChar(PrgName));
	if GetLastError = ERROR_ALREADY_EXISTS then begin   // Anwendung l�uft bereits
     h := 0;
     repeat
       h := FindWindowEx(0,h,'TApplication',PWideChar(PrgName))
     until h <> Application.handle;
     if h <> 0 then begin
        Windows.ShowWindow(h, SW_ShowNormal);
        Windows.SetForegroundWindow(h);
     end;
		 Halt;
	end;

//	if GetLastError = ERROR_ALREADY_EXISTS then begin   // Anwendung l�uft bereits
//		 MessageDlg(rscCheckProgRun1, mtInformation, [mbOK], 0);
//		 Halt;
//	end;


finalization   // ... und Schlu�
	if mHandle <> 0 then CloseHandle(mHandle)
end.
