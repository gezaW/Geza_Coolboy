// ######################
// Code-Site-Logging-Tool
// ######################

// Vorgehensweise zum Einbinden in eine Unit:
// ##########################################

//
// 1. eine Instanz von TDataLog erzeugen
// ----------------------------------------------
//    (Deklaration:) FMSLogging: TDataLog;
//    FMSLogging := dmlog.TDataLog.Create(self);
//
// Hinweis:
// Es können mehrere Instanzen dieser Unit in einem Projekt erzeugt werden.

// 2. Gleich nach der obigen Zeile die Einstellungen setzen
// --------------------------------------------------------
//    fmslogging.SetProperties
//    (
//      true, // LogFile auf Active setzen, sonst wird nichts gesendet
//      false, // LiveViewer inactive setzen
//      'FMS', // Name der Logfile (ohne Datum, ohne Endung)
//      extractfilepath(application.ExeName), // Speicher-Pfad der Logfiles
//      '', // LogFileServer // wenn CodeSite lokal '', sonst Hostname (zB 'server1')
//      false, // SendMailOnError
//      false, // SendScreenshotOnError (wenn SendMailOnError active)
//      '', // SMTPHost (wenn SendMailOnError active)
//      25, // SMTPPort (wenn SendMailOnError active)

//      '', // SMTPSender (wenn SendMailOnError active)
//      '' // SMTPRecipients (wenn SendMailOnError active)
//    );

// 3. Text an das Logging-Tool senden
// ----------------------------------
//    FMSLogging.FelixCodeSite.Send('Test');



unit DMLog;

interface

uses
  SysUtils, Classes, CodeSiteLogging, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdExplicitTLSClientServerBase, IdMessageClient,
  IdSMTPBase, IdSMTP, IdMessage, windows; // dialogs;

type

  PTimeOfDayInfo = ^TTimeOfDayInfo; 

  TTimeOfDayInfo = record
    todElapsedt: DWORD;
    todMSecs: DWord; 
    todHours: DWord; 
    todMins: DWord; 
    todSecs: DWord; 
    todHunds: DWord; 
    todTimeZone: LongInt; 
    todTInterval: DWord; 
    todDay: DWord; 
    todMonth: DWord; 
    todYear: DWord; 
    todWeekday: DWord; 
  end;

  TDataLog = class(TDataModule)
    FelixCodeSite: TCodeSiteLogger;
    FelixDest: TCodeSiteDestination;
    IdSMTPFelix: TIdSMTP;
    IdMessageFelix: TIdMessage;
    procedure FelixCodeSiteSendMsg(Sender: TObject; MsgData: TCodeSiteMsgData;
      var Handled: Boolean);
    procedure DataModuleDestroy(Sender: TObject);
   // procedure DataModuleCreate(Sender: TObject; pLogFileIsActive, pViewerIsActive : Boolean;
     //pLogFileName, pLogFileFilePath, pLogfileServer : STring; pSendMailOnError, pSendScreenShotOnError:Boolean;
    //pSMTPHost:String; pSMTPPort:Integer; pSMTPSender, pSMTPRecipients:String);

  private
    FLogfileFilePath: String;
    FViewerIsActive: Boolean;
    FLogfileIsActive: Boolean;
    FLogfileFileName: String;
    FCodeSiteIsEnabled: Boolean;
    FSMTPPort: Integer;
    FSMTPHost: String;
    FSMTPSender: String;
    FSMTPRecipients: String;
    FSendScreenShotOnError: Boolean;
    FSendMailOnError: Boolean;
    FLogfileServer: string;
    FSMTPPass: String;
    FSMTPUser: String;
    FSMTPAuth: Boolean;
    procedure SetLogfileFilePath(const Value: String);
    procedure SetLogfileIsActive(const Value: Boolean);
    procedure SetViewerIsActive(const Value: Boolean);
    procedure SetLogfileFileName(const Value: String);
    procedure SetCodeSiteIsEnabled(const Value: Boolean);
    procedure SendMail(aSubject:String; aText:String);
    procedure SetSMTPHost(const Value: String);
    procedure SetSMTPPort(const Value: Integer);
    procedure SetSMTPSender(const Value: String);
    procedure SetSMTPRecipients(const Value: String);
    procedure SetSendScreenShotOnError(const Value: Boolean);
    procedure SetSendMailOnError(const Value: Boolean);
    procedure SetLogfileServer(const Value: string);
    function GetServerDateTime:TDateTime;
    procedure SetSMTPAuth(const Value: Boolean);
    procedure SetSMTPPass(const Value: String);
    procedure SetSMTPUser(const Value: String);
    { Private-Deklarationen }
  public
    property CodeSiteIsEnabled:Boolean read FCodeSiteIsEnabled write SetCodeSiteIsEnabled;
    property LogfileServer:string read FLogfileServer write SetLogfileServer;
    property LogfileFilePath:String read FLogfileFilePath write SetLogfileFilePath;
    property LogfileFileName:String read FLogfileFileName write SetLogfileFileName;
    property LogfileIsActive:Boolean read FLogfileIsActive write SetLogfileIsActive;
    property ViewerIsActive:Boolean read FViewerIsActive write SetViewerIsActive;
    property SMTPHost:String read FSMTPHost write SetSMTPHost;
    property SMTPPort:Integer read FSMTPPort write SetSMTPPort;
    property SMTPAuth:Boolean read FSMTPAuth write SetSMTPAuth;
    property SMTPUser:String read FSMTPUser write SetSMTPUser;
    property SMTPPass:String read FSMTPPass write SetSMTPPass;
    property SMTPSender:String read FSMTPSender write SetSMTPSender;
    property SMTPRecipients:String read FSMTPRecipients write SetSMTPRecipients;
    property SendScreenShotOnError:Boolean read FSendScreenShotOnError write SetSendScreenShotOnError;
    property SendMailOnError:Boolean read FSendMailOnError write SetSendMailOnError;
    procedure SetProperties(pLogFileIsActive, pViewerIsActive:Boolean; pLogFileName:String;
      pLogFileFilePath, pLogfileServer:String; pSendMailOnError, pSendScreenShotOnError :Boolean;
      pSMTPHost :String; pSMTPPort:Integer; pSMTPAuth:Boolean; pSMTPUser:String;
      pSMTPPass:String; pSMTPSender, pSMTPRecipients :String);
    { Public-Deklarationen }
  end;

var
  DataLog: TDataLog;


  function NetRemoteTOD(UncServerName: PWideChar;
                      var TimeOfDayInfo: PTimeOfDayInfo): DWORD; stdcall; 
                      external 'NetAPI32.dll'; 

implementation
uses variants, forms;
{$R *.dfm}

  // Testaufruf: DataModuleLogging.FelixCodeSite.EnterMethod( Self, 'Button1Click' );
  // Testaufruf: DataModuleLogging.FelixCodeSite.ExitMethod( Self, 'Button1Click' );

procedure TDataLog.DataModuleDestroy(Sender: TObject);
begin
  FelixCodeSite.Send(codesitemanager.AppName + ' closed.');
end;

procedure TDataLog.FelixCodeSiteSendMsg(Sender: TObject;
  MsgData: TCodeSiteMsgData; var Handled: Boolean);
var
  aTypeName:String;
  aWindowHandle:Cardinal;
begin
try
  aTypeName := msgdata.TypeName;
  aWindowHandle := FindWindow(pchar(aTypeName),nil);
  felixcodesite.OnSendMsg := nil;
  msgdata.MsgText := formatdatetime('hhnnss ', getserverdatetime) + ': ' + msgdata.msgtext;
  // showmessage(inttostr(msgdata.MsgType));
  case msgdata.MsgType of
  0: // Send, SendMsg, SendFmtMsg, SendAssigned, SendCurrency, SendDateTime,
     // SendEnum, SendSet, SendProperty, SendKey, SendMouseButton, SendPointer, SendVariant,
     // SendCustomData, SendIf, SendDateTimeIf
    begin
      // msgdata.MsgText := formatdatetime('yyyymmdd_hhnnsss',now) + ' ' + msgdata.msgtext;
    end;
  1: // SendWarning
    begin

    end;
  2: // SendError, SendWinError
    begin
      FelixCodeSite.AddCheckPoint;
      if SendScreenshotOnError then
        felixcodesite.SendScreenShot('ERROR-Screenshot', aWindowHandle);
      if SendMailOnError then
        SendMail('FelixCodeSite: ' + msgdata.TypeName, msgdata.MsgText );
    end;
  3: // AddCheckpoint
    begin

    end;
  5: // SendComponentAsText
    begin

    end;
  8: // SendNote
    begin

    end;
  9: // EnterMethod
    begin

    end;
  10: // ExitMethod
    begin

    end;
  11: // AddSeperator
  begin
  
  end;
  14: // Write, WriteColor, WriteCurrency
  begin

  end;
  16: // SendScreenshot
    begin

    end;
  17: // SendTextfile
    begin

    end;
  18: // SendWindowHandle
    begin

    end;
  19: // SendMemoryAsHex, SendStreamAsText, SendStreamAsHex, SendFileAsHex
    begin

    end;
  20: // SendHeapStatus, SendMemoryStatus
    begin

    end;
  23: // SendReminder
    begin

    end;
  31: // SendColor
    begin

    end;
  32: // SendRegistry
    begin

    end;
  33: // SendSystemInfo
    begin

    end;
  34: // SendVersionInfo
    begin

    end;
  35: // SendXmlFile, SendXmlData
    begin

    end;
  37: // SendException
    begin

    end;
  43: // ExitMethodCollapse
  begin

  end;    
  44: // SendControls, SendComponents, SendParents
    begin

    end;
  end;
finally
  felixcodesite.SendMsgDetails(msgdata.MsgType, msgdata.MsgText, msgdata.Details, msgdata.TypeName);
  felixcodesite.OnSendMsg := FelixCodeSiteSendMsg;
end;
end;

function TDataLog.GetServerDateTime: TDateTime;
var
  TimeOfDayInfo: PTimeOfDayInfo;
  astr:string;
  stamp:TDatetime;
begin
  //change UNCServerName to a machine on your LAN or nil for localhost
  if LogfileServer <> '' then
  begin
    if NetRemoteTOD(pwidechar(LogfileServer), TimeOfDayInfo) = 0 then
      astr:= Format('%.02d:%.02d:%.02d', [TimeOfDayInfo.todHours, TimeOfDayInfo.todMins, TimeOfDayInfo.todSecs])
        + chr(13) + 'Month: ' + IntToStr(TimeOfDayInfo.todMonth) + chr(13) + 'Day: ' + IntToStr(TimeOfDayInfo.todDay)
        + chr(13) + 'WeekDay: ' + IntToStr(TimeOfDayInfo.todWeekday)
    else
      if NetRemoteTOD(nil, TimeOfDayInfo) = 0 then
      astr:= Format('%.02d:%.02d:%.02d', [TimeOfDayInfo.todHours, TimeOfDayInfo.todMins, TimeOfDayInfo.todSecs])
        + chr(13) + 'Month: ' + IntToStr(TimeOfDayInfo.todMonth) + chr(13) + 'Day: ' + IntToStr(TimeOfDayInfo.todDay)
        + chr(13) + 'WeekDay: ' + IntToStr(TimeOfDayInfo.todWeekday);
    Stamp := EncodeDate(timeofdayinfo.todYear, timeofdayinfo.todMonth, timeofdayinfo.todDay)
      + EncodeTime(timeofdayinfo.todHours, timeofdayinfo.todMins, timeofdayinfo.todSecs, timeofdayinfo.todHunds)
      - (timeofdayinfo.todTimeZone / 1440);
  end
  else
    stamp := now;

  Result := stamp;
end;

procedure TDataLog.SendMail(aSubject, aText: String);
begin
try
  if (smtpsender = null) then
    raise exception.Create('SmtpSender not defined');
  if (smtprecipients = null) then
    raise exception.Create('SmtpRecipients not defined');
  if (smtpport = null) then
    raise exception.Create('SmtpPort not defined');
  if (smtphost = null) then
    raise exception.Create('SmtpHost not defined');

  idMessageFelix.Subject := aSubject;
  idMessageFelix.Body.Text := aText;
  try
    try
      idSMTPFelix.Connect;
      idSMTPFelix.Send(idMessageFelix);
    except on E:Exception do
      felixcodesite.SendError('Error on trying to send DMLogging-Error-Message' + #13#10 + e.message)
    end;
  finally
    if idSMTPFelix.Connected then
      idSMTPFelix.Disconnect;
  end;
except
  on ex:Exception do
    felixcodesite.SendError(ex.Message) 
end;
end;

procedure TDataLog.SetCodeSiteIsEnabled(const Value: Boolean);
begin
  FCodeSiteIsEnabled := Value;
  felixcodesite.Enabled := Value;
end;

procedure TDataLog.SetLogfileFileName(const Value: String);
begin
  FLogfileFileName := Value;
  FelixCodesite.Destination.LogFile.FileName := Value;
end;

procedure TDataLog.SetLogfileIsActive(const Value: Boolean);
begin
  FLogfileIsActive := Value;
  FelixCodesite.Destination.LogFile.Active := Value;
end;

procedure TDataLog.SetLogfileServer(const Value: string);
begin
  FLogfileServer := Value;
end;

procedure TDataLog.SetProperties(pLogFileIsActive,
  pViewerIsActive: Boolean; pLogFileName, pLogFileFilePath,
  pLogfileServer: String; pSendMailOnError, pSendScreenShotOnError: Boolean;
  pSMTPHost: String; pSMTPPort: Integer; pSMTPAuth:Boolean; pSMTPUser:String;
  pSMTPPass:String;  pSMTPSender, pSMTPRecipients: String);
begin
  // Werte setzen:
  LogFileIsActive := pLogFileIsActive;
  ViewerIsActive := pViewerIsActive;
  LogFileFilePath := pLogFileFilePath;
  LogfileServer := pLogfileServer;
  SendMailOnError := pSendMailOnError;
  SendScreenShotOnError := pSendScreenShotOnError;
  SMTPHost :=  pSMTPHost;
  SMTPPort := pSMTPPort;
  SMTPAuth := pSMTPAuth;
  SMTPUser := pSMTPUser;
  SMTPPass := pSMTPPass;
  SMTPSender := pSMTPSender;
  SMTPRecipients := pSMTPRecipients;
  LogFileFileName := pLogFileName + '_' + formatdatetime('yyyymmdd', getserverdatetime) + '.csl';

  if Logfileisactive then
    FelixCodesite.Enabled := true;

  if LogfileServer <> '' then
    FelixCodeSite.ConnectUsingTcp( logfileserver );
  // Versioninfo, Systeminfo und MemoryStatus:
  FelixCodeSite.Send(codesitemanager.AppName);
  FelixcodeSite.AddSeparator;
  FelixCodeSite.SendVersionInfo;
  FelixCodeSite.SendSystemInfo;
  FelixcodeSite.SendMemoryStatus;
  FelixcodeSite.AddSeparator;
end;

procedure TDataLog.SetSendMailOnError(const Value: Boolean);
begin
  FSendMailOnError := Value;
end;

procedure TDataLog.SetSendScreenShotOnError(const Value: Boolean);
begin
  FSendScreenShotOnError := Value;
end;

procedure TDataLog.SetSMTPAuth(const Value: Boolean);
begin
  FSMTPAuth := Value;
end;

procedure TDataLog.SetSMTPHost(const Value: String);
begin
  FSMTPHost := Value;
  idSMTPFelix.Host := Value;
end;

procedure TDataLog.SetSMTPPass(const Value: String);
begin
  FSMTPPass := Value;
end;

procedure TDataLog.SetSMTPPort(const Value: Integer);
begin
  FSMTPPort := Value;
  idSMTPFelix.Port := Value;
end;

procedure TDataLog.SetSMTPRecipients(const Value: String);
begin
  FSMTPRecipients := Value;
  idMessageFelix.Recipients.EMailAddresses := Value;
end;

procedure TDataLog.SetSMTPSender(const Value: String);
begin
  FSMTPSender := Value;
  idMessageFelix.From.Address := Value;
end;

procedure TDataLog.SetSMTPUser(const Value: String);
begin
  FSMTPUser := Value;
end;

procedure TDataLog.SetLogfileFilePath(const Value: String);
begin
  FLogfileFilePath := Value;
  felixcodesite.Destination.LogFile.FilePath := Value;
end;

procedure TDataLog.SetViewerIsActive(const Value: Boolean);
begin
  FViewerIsActive := Value;
  FelixCodesite.Destination.Viewer.Active := value;

end;

end.

