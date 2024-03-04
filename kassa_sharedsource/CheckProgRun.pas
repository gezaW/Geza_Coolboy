// Datum der Erstellung       : 09.08.1999
// Ersteller                  : Neuhold Günther
// Datum letzter Änderung     : 15.10.2015
// Bearbeiter letzter Änderung:  Neuhold
// Art der letzten Änderung   :  Allgemein gemacht und nicht auf ein Programm bezogen
//
// Beschreibung der Unit:
//	Prüft ob das Programm schon läuft
//  Über die Mutex-Prüfung wird verhindert, daß eine weitere Instanz des
//  Prgrammes gestartet wird.
//
// Änderungen:

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
	if GetLastError = ERROR_ALREADY_EXISTS then begin   // Anwendung läuft bereits
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

//	if GetLastError = ERROR_ALREADY_EXISTS then begin   // Anwendung läuft bereits
//		 MessageDlg(rscCheckProgRun1, mtInformation, [mbOK], 0);
//		 Halt;
//	end;


finalization   // ... und Schluß
	if mHandle <> 0 then CloseHandle(mHandle)
end.
