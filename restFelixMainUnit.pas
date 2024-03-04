unit restFelixMainUnit;

interface

uses
  Winapi.Messages, System.SysUtils, System.Variants, System.JSON,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.AppEvnts, Vcl.StdCtrls, IdHTTPWebBrokerBridge, Web.HTTPApp,
  DataModule, Vcl.ExtCtrls, ServerIntf,
  Spring.Container, Spring.Services, Vcl.ComCtrls, System.StrUtils,
  Vcl.Imaging.pngimage, Vcl.Menus, FireDAC.Comp.Client;

type
  TrstFelixMain = class(TForm)
    ButtonStart: TButton;
    ButtonStop: TButton;
    Label1: TLabel;
    ApplicationEvents: TApplicationEvents;
    btnTestFunc: TButton;
    MemoLog: TRichEdit;
    Label3: TLabel;
    Label4: TLabel;
    cmbCompName: TComboBox;
    GMSLogo: TImage;
    ButtonMemoClear: TButton;
    MainMenu: TMainMenu;
    Men1: TMenuItem;
    Men2: TMenuItem;
    LabelPortNumber: TLabel;
    LabelIsHttps: TLabel;
    UserInfo1: TMenuItem;
    Label2: TLabel;
    Datenbankverbindungenneueinlesen1: TMenuItem;
    TrayIcon: TTrayIcon;
    TimerStartServer: TTimer;
    Indexberprfung1: TMenuItem;
    TimerTerminateThread: TTimer;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure ApplicationEventsIdle(Sender: TObject; var Done: Boolean);
    procedure ButtonStartClick(Sender: TObject);
    procedure ButtonStopClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnTestFuncClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ButtonMemoClearClick(Sender: TObject);
    procedure Men2Click(Sender: TObject);
    procedure UserInfo1Click(Sender: TObject);
    procedure Datenbankverbindungenneueinlesen1Click(Sender: TObject);
    procedure ApplicationEventsMinimize(Sender: TObject);
    procedure TrayIconDblClick(Sender: TObject);
    procedure TimerStartServerTimer(Sender: TObject);
    procedure Indexberprfung1Click(Sender: TObject);
    procedure TimerTerminateThreadTimer(Sender: TObject);
  private
//    FServer: TIdHTTPWebBrokerBridge;
//    logging: IRestLogger;
    FCheck: IRestChecker;

    procedure startServer(isHTTP: Boolean);
    function beforStopServer: integer;
    procedure HaendleButton;
    { Private-Deklarationen }
  public
    { Public-Deklarationen }

    procedure MyExceptionHandler(Sender: TObject; E: Exception);
    // procedure WriteToColorLog(pLogStr: string; pStatus: TLogMessageTypes);

  end;

  TThreadWork = class(TThread)
  private
    FDatabaseNames: TStrings;
  public
    Work: Boolean;
    dfays: boolean;
    property DataBaseNames: TStrings write FDatabaseNames;
  protected
    procedure Execute; override;
  end;

var
  rstFelixMain: TrstFelixMain;
  trwork: TThreadWork;

implementation

{$R *.dfm}


uses
  IdSSLOpenSSL,
  Winapi.Windows, Winapi.ShellApi, Datasnap.DSSession, ServerMethodsUnit, SettingsUnit,
  enmploy_contr, IniFiles, user_data, TempModul, logging;

const
  PasswordTags: array [0 .. 1] of string = ('Password="', 'Pass="');

procedure TrstFelixMain.Men2Click(Sender: TObject);
var
  ASettings: TSettingForm;
begin
  ASettings := TSettingForm.Create(self);
  ASettings.Show;
end;

procedure TrstFelixMain.MyExceptionHandler(Sender: TObject; E: Exception);
begin
  Log.WriteToLog('ExceptionHandler', 0, E.Message, lmtError);
end;

procedure TrstFelixMain.ApplicationEventsIdle(Sender: TObject;
  var Done: Boolean);
begin
  //
end;

procedure TrstFelixMain.btnTestFuncClick(Sender: TObject);
var
  companyName: string;
  aConnection: TFDConnection;
begin
  try
    try
      if cmbCompName.Text = '' then
      begin
        showMessage('Bitte zuerst eine Firma auswählen');
      end
      else
      begin
        aConnection := TFDConnection.Create(nil);
        aConnection.ConnectionDefName := cmbCompName.Text;
        aConnection.Connected := true;
        begin
          Log.WriteToLog('Admin', 0, 'Test der Datenbankverbindung: ' + cmbCompName.Text + ': Verbunden');
          MemoLog.Lines.Add(DateToStr(Date) + ' ' + TimeToStr(Time) + ' ' + cmbCompName.Text +
            ': Test der Datenbankverbindung: ' + cmbCompName.Text + ': Verbunden');
        end;
      end;
    except
      on E: Exception do
      begin
        Log.WriteToLog('Admin', 0, 'Test der Datenbankverbindung: ' + cmbCompName.Text + ': ' + E.Message,
          lmtError);
      end;
    end;
  finally
    if aConnection.Connected then
      aConnection.Connected := FALSE;
    aConnection.Free;
  end;
end;


procedure TrstFelixMain.ButtonMemoClearClick(Sender: TObject);
begin
  ShellExecute(0, 'open', PChar(Log.FLogPath), '', '', SW_Normal);
  // MemoLog.Clear;
end;

procedure TrstFelixMain.ButtonStartClick(Sender: TObject);
begin
  startServer(true);
end;

procedure TerminateThreads;
begin
  if TDSSessionManager.Instance <> nil then
    TDSSessionManager.Instance.TerminateAllSessions;
end;

procedure TrstFelixMain.ButtonStopClick(Sender: TObject);
begin
  if beforStopServer = 1 then
    DM.StopServer;
  HaendleButton;
end;

procedure TrstFelixMain.Datenbankverbindungenneueinlesen1Click(
  Sender: TObject);
begin
  if beforStopServer = 1 then
    DM.StopServer;
  HaendleButton;
  DM.readConnections;
  DM.startServer;
  HaendleButton;
end;

procedure TrstFelixMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if beforStopServer = 1 then
    CanClose := true
  else
    CanClose := FALSE;
end;

procedure TrstFelixMain.FormCreate(Sender: TObject);
begin
  { Set up a hint message and the animation interval. }
  TrayIcon.Hint := 'GMS Rest Felix Server';
  TrayIcon.AnimateInterval := 200;

  { Set up a hint balloon. }
  TrayIcon.BalloonTitle := 'Restoring the window.';
  TrayIcon.BalloonHint := 'Double click the system tray icon to restore the window.';
  TrayIcon.BalloonFlags := bfInfo;

  Application.OnException := MyExceptionHandler;
  TimerStartServer.Enabled := true;
  ApplicationEventsMinimize(Nil);
end;

procedure TrstFelixMain.FormShow(Sender: TObject);
  function GetVersion: string;
  var
    VerInfoSize: DWORD;
    VerInfo: Pointer;
    VerValueSize: DWORD;
    VerValue: PVSFixedFileInfo;
    Dummy: DWORD;
  begin
    VerInfoSize := GetFileVersionInfoSize(PChar(ParamStr(0)), Dummy);
    GetMem(VerInfo, VerInfoSize);
    GetFileVersionInfo(PChar(ParamStr(0)), 0, VerInfoSize, VerInfo);
    VerQueryValue(VerInfo, '\', Pointer(VerValue), VerValueSize);
    with VerValue^ do
    begin
      Result := IntToStr(dwFileVersionMS shr 16);
      Result := Result + '.' + IntToStr(dwFileVersionMS and $FFFF);
      Result := Result + '.' + IntToStr(dwFileVersionLS shr 16);
      Result := Result + '.' + IntToStr(dwFileVersionLS and $FFFF);
    end;
    FreeMem(VerInfo, VerInfoSize);
  end;

begin

  caption := 'GMS Felix - RestServer V' + GetVersion;
end;

procedure TrstFelixMain.HaendleButton;
begin
  ButtonStart.Enabled := not DM.IsServerActive;
  ButtonStop.Enabled := DM.IsServerActive;
end;

procedure TrstFelixMain.Indexberprfung1Click(Sender: TObject);
var
  aDataM: TTM;
  aDo: Boolean;
  APath: string;
  aIni: TIniFile;
begin
  try
    APath := 'restFelix.ini';
    var I := 0;
    while (I < 6) and NOT Fileexists(ExpandFileName(ExtractFilePath(ParamStr(0)) +
      APath)) do
    begin
      APath := '..\' + APath;
      inc(I);
    end;
    aIni := TIniFile.Create(ExpandFileName(ExtractFilePath(ParamStr(0)) + APath));



    aDataM := TTM.Create(nil);
    for var aDatabaseName in cmbCompName.Items do
    begin
      // Index Überprüfung nur in Felix Datenbanken
      if aIni.ReadInteger(aDatabaseName,'IsCashDesk',0) = 0 then
      begin
        try
          aDataM.MainConnection.Close;
          aDataM.MainConnection.Params.CLear;
          aDataM.MainConnection.ConnectionDefName := aDatabaseName;
          aDataM.MainConnection.Connected := true;
          aDo := true;
        except
          aDo := FALSE;
        end;
        if aDo then
        begin
          aDataM.CheckIndice('ARTIKEL', 'ARTIKELID', 'ARTIKEL_IDX1');
          aDataM.CheckIndice('ARTIKEL', 'LOCATIONID', 'ARTIKEL_IDX2');
          aDataM.CheckIndice('JOURNALARCHIV', 'DATUM', 'JOURNALARCHIV_IDX1');
          aDataM.CheckIndice('JOURNALARCHIV', 'ARTIKELID', 'JOURNALARCHIV_IDX2');
          aDataM.CheckIndice('JOURNALARCHIV', 'JOURNALTYP', 'JOURNALARCHIV_IDX3');
          aDataM.CheckIndice('JOURNAL', 'DATUM', 'JOURNAL_IDX1');
          aDataM.CheckIndice('JOURNAL', 'ARTIKELID', 'JOURNAL_IDX2');
          aDataM.CheckIndice('JOURNAL', 'JOURNALTYP', 'JOURNAL_IDX3');
          aDataM.CheckIndice('JOURNAL', 'LOCATIONID', 'JOURNAL_UID1');
          aDataM.CheckIndice('KELLNER', 'KELLNERID', 'KELLNER_IDX1');
          aDataM.CheckIndice('KELLNER', 'LOCATIONID', 'KELLNER_IDX2');
          aDataM.CheckIndice('HOTEL_SIGNATURE', 'RESERVID', 'HOTEL_SIGNATURE_IDX1');
          aDataM.CheckIndice('KASSENJOURNAL', 'TEXT', 'KASSENJOURNAL_TEXT1');
          aDataM.CheckIndice('KASSENJOURNAL', 'BETRAG', 'KASSENJOURNAL_BETRAG1');
          aDataM.CheckIndice('JOURNALARCHIV', 'JOURNALARCHIVID', 'JOURNALARCHIV_JID1');
          aDataM.CheckIndice('JOURNALARCHIV', 'LOCATIONID', 'JOURNALARCHIV_UID1');
          aDataM.CheckIndice('RECHNUNG', 'VONDATUM', 'RECHNUNG_IDX_VDAT');
          aDataM.CheckIndice('GAESTESTAMM', 'UPDATED_AT', 'GAESTESTAMM_UPDATED_AT');
        end;
      end;
    end;
  finally
    FreeAndNil(aIni);
    FreeAndNil(aDataM);
  end;
end;

procedure TrstFelixMain.startServer(isHTTP: Boolean);
begin
  try
    DM.startServer;
    HaendleButton;
    LabelPortNumber.caption := IntToStr(DM.ServerPort);
    if DM.IsHTTPS then
    begin
      LabelIsHttps.caption := 'TRUE';
    end
    else
    begin
      LabelIsHttps.caption := 'FALSE';
    end;
    if DM.IsServerActive then
      Log.WriteToLog('Admin', 0, 'Server neustart um: ' + DateTimeToStr(now));
  except
    on E: Exception do
    begin
      Log.WriteToLog('Admin', 0, '<TrstFelixMain> startServer: ' + E.Message, lmtError);
    end;
  end;
end;

procedure TrstFelixMain.TimerStartServerTimer(Sender: TObject);
begin
  if not DM.IsServerActive then
  begin
    startServer(FALSE);
  end
  else
    TimerStartServer.Enabled := FALSE;
end;

procedure TrstFelixMain.TimerTerminateThreadTimer(Sender: TObject);
begin
  if not trwork.Work then
  begin
    TimerTerminateThread.Enabled := FALSE;
    trwork.DoTerminate;
  end;
end;

procedure TrstFelixMain.TrayIconDblClick(Sender: TObject);
begin
  TrayIcon.Visible := FALSE;
  Show();
  WindowState := wsNormal;
  Application.BringToFront();
end;

procedure TrstFelixMain.UserInfo1Click(Sender: TObject);
var
  aEmplcontr: Temployee_control;
  aUser: TFormUserData;
begin
  aEmplcontr := Temployee_control.Create(nil);
  if aEmplcontr.ShowModal = 1337 then
  begin
    aUser := TFormUserData.Create(nil);
    aUser.Show;
  end;
end;

// ******************************************************************************
// Schreibt einen String in RichEdit Text und ins Logfile
// ******************************************************************************
//procedure TrstFelixMain.WriteToColorLog(pLogStr: string;
//  pStatus: TLogMessageTypes);
//var
//  p1, p2, i, j: integer;
//  pFontColor: Tcolor;
//begin
//  // Passwort Daten nicht speichern  #
//  try
//    try
//      for i := 0 to High(PasswordTags) do
//      begin
//        if ContainsText(pLogStr, PasswordTags[i]) then
//        begin
//          p1 := Pos(PasswordTags[i], pLogStr, 1);
//          p1 := p1 + Length(PasswordTags[i]);
//          p2 := Pos('"', pLogStr, p1);
//          for j := p1 to p2 - 1 do
//          begin
//            pLogStr[j] := '*';
//          end;
//        end;
//      end;
//
//      case pStatus of
//        lmtInfo:
//          pFontColor := clgreen;
//        lmtWarning:
//          pFontColor := clYellow;
//        lmtError:
//          pFontColor := clred;
//        lmtFatalError:
//          pFontColor := clred;
//        lmtDebug:
//          pFontColor := clblue;
//        lmtTrace:
//          pFontColor := clPurple;
//      end;
//      try
//        if not(pStatus = lmtDebug) then
//          logging.WriteToLog(DM.FUserCompanyName + ': ' + pLogStr, pStatus);
//      except
//        on E: Exception do
//        begin
//          // showMessage('Fehler bei WriteToColorLog: '+e.Message);
//        end;
//      end;
//      try
//        // MemoLog.SelAttributes.Color := pFontColor;
//        // MemoLog.Lines.Add(DateToStr(Date) + ' ' + TimeToStr(Time) + ' ' + DM.FUserCompanyName+': '+pLogStr);
//      except
//        on E: Exception do
//        begin
//          // showMessage('Fehler bei WriteToColorLog: '+e.Message);
//        end;
//      end;
//
//    except
//      on E: Exception do
//      begin
//        logging.WriteToLog(DM.FUserCompanyName + ': ' + pLogStr, pStatus);
//      end;
//    end;
//
//  finally
//    MemoLog.SelAttributes.Color := clblack;
//  end;
//end;

procedure TrstFelixMain.ApplicationEventsMinimize(Sender: TObject);
begin
  Hide();
  WindowState := wsMinimized;

  TrayIcon.Visible := true;
  TrayIcon.Animate := true;
  TrayIcon.ShowBalloonHint;
end;

function TrstFelixMain.beforStopServer: integer;
begin
  with Application do
    Result := MessageBox('Achtung!!' + #10#13 +
      'Sie sind im Begriff den Server zu schließen!' + #10#13 +
      'Das wird zu gravierenden Fehlern bei den clients führen.' + #10#13 +
      'Bitte stellen sie sicher das diese alle beendet sind!' + #10#13 +
      'Wenn der Server jetzt heruntergefahren werden soll drücken Sie OK',
      'WARNUNG SERVER SCHLIESSEN', MB_OKCANCEL);
end;

{ TThreadWork }

procedure TThreadWork.Execute;
var
  aDataM: TTM;
  aDo: Boolean;
begin
  inherited;
  Work := true;
  try
    try
      aDataM := TTM.Create(nil);
      for var aDatabaseName in FDatabaseNames do
      begin
        if Terminated then
          break;
        try
          aDataM.MainConnection.Close;
          aDataM.MainConnection.Params.CLear;
          aDataM.MainConnection.ConnectionDefName := aDatabaseName;
          aDataM.MainConnection.Connected := true;
          aDo := true;
        except
          aDo := FALSE;
        end;
        if aDo then
        begin
          aDataM.CheckIndice('ARTIKEL', 'ARTIKELID', 'ARTIKEL_IDX1');
          aDataM.CheckIndice('JOURNALARCHIV', 'DATUM', 'JOURNALARCHIV_IDX1');
          aDataM.CheckIndice('JOURNALARCHIV', 'ARTIKELID', 'JOURNALARCHIV_IDX2');
          aDataM.CheckIndice('JOURNALARCHIV', 'JOURNALTYP', 'JOURNALARCHIV_IDX3');
          aDataM.CheckIndice('JOURNAL', 'DATUM', 'JOURNAL_IDX1');
          aDataM.CheckIndice('JOURNAL', 'ARTIKELID', 'JOURNAL_IDX2');
          aDataM.CheckIndice('JOURNAL', 'JOURNALTYP', 'JOURNAL_IDX3');
          aDataM.CheckIndice('KELLNER', 'KELLNERID', 'KELLNER_IDX1');
          aDataM.CheckIndice('HOTEL_SIGNATURE', 'RESERVID', 'HOTEL_SIGNATURE_IDX1');
        end;
      end;
    except
      //
    end;
  finally
    FreeAndNil(aDataM);
    FreeAndNil(FDatabaseNames);
    DoTerminate;
    Work := FALSE;
  end;
end;

end.
