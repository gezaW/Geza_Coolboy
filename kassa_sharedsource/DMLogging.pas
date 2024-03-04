unit DMLogging;

interface

uses
  SysUtils, Classes,
  IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdExplicitTLSClientServerBase, IdMessageClient,
  IdSMTPBase, IdSMTP, IdMessage, Windows, DMBase;

type
  TMeinFeld = array [0 .. 1] of Integer; // nur ein Test

type

  PTimeOfDayInfo = ^TTimeOfDayInfo;

  TTimeOfDayInfo = record
    TodElapsedt: DWORD;
    TodMSecs: DWORD;
    TodHours: DWORD;
    TodMins: DWORD;
    TodSecs: DWORD;
    TodHunds: DWORD;
    TodTimeZone: LongInt;
    TodTInterval: DWORD;
    TodDay: DWORD;
    TodMonth: DWORD;
    TodYear: DWORD;
    TodWeekday: DWORD;
  end;

  TDataLogging = class(TDataModule)
    IdSMTPKasse: TIdSMTP;
    IdMessageKasse: TIdMessage;
    procedure DataModuleCreate(Sender: TObject);
    procedure KasseCodeSiteSendMsg(Sender: TObject; MsgData: string;
      var Handled: Boolean);

    procedure DataModuleDestroy(Sender: TObject);
  private
    FLogfileFilePath: string;
    FViewerIsActive: Boolean;
    FLogfileIsActive: Boolean;
    FLogfileFileName: string;
    FSMTPPort: Integer;
    FSMTPHost: string;
    FSMTPSender: string;
    FSMTPRecipients: string;
    procedure SendMail(ASubject: string; AText: string);
    procedure SetSMTPHost(const Value: string);
    procedure SetSMTPPort(const Value: Integer);
    procedure SetSMTPSender(const Value: string);
    procedure SetSMTPRecipients(const Value: string);
    { Private-Deklarationen }
  public
    XTest: Integer;

    property SMTPHost: string read FSMTPHost write SetSMTPHost;
    property SMTPPort: Integer read FSMTPPort write SetSMTPPort;
    property SMTPSender: string read FSMTPSender write SetSMTPSender;
    property SMTPRecipients: string read FSMTPRecipients
      write SetSMTPRecipients;
    procedure KasseLog(AString: string);
  end;

var
  DataLogging: TDataLogging;

function NetRemoteTOD(UncServerName: PWideChar;
  var TimeOfDayInfo: PTimeOfDayInfo): DWORD; stdcall; external 'NetAPI32.dll';

implementation

uses Variants, Forms, Dialogs, nxLogging;
{$R *.dfm}

procedure TDataLogging.DataModuleCreate(Sender: TObject);
begin
  Logger.info(ExtractFileName(ParamStr(0)) + ' started.');
end;

procedure TDataLogging.DataModuleDestroy(Sender: TObject);
begin
  Logger.info(ExtractFileName(ParamStr(0)) + ' closed.');
end;

procedure TDataLogging.KasseCodeSiteSendMsg(Sender: TObject; MsgData: string;
  var Handled: Boolean);
begin
  Logger.info((Sender as TObject).ToString, MsgData);
end;

procedure TDataLogging.KasseLog(AString: string);
begin
  Logger.info(AString);
end;

procedure TDataLogging.SendMail(ASubject, AText: string);
begin
  try
    if (SMTPSender = Null) then
      raise Exception.Create('SmtpSender not defined');
    if (SMTPRecipients = Null) then
      raise Exception.Create('SmtpRecipients not defined');
    if (SMTPPort = Null) then
      raise Exception.Create('SmtpPort not defined');
    if (SMTPHost = Null) then
      raise Exception.Create('SmtpHost not defined');

    IdMessageKasse.Subject := ASubject;
    IdMessageKasse.Body.Text := AText;
    try
      try
        IdSMTPKasse.Connect;
        IdSMTPKasse.Send(IdMessageKasse);
      except
        on E: Exception do
          Logger.error('TDataLogging.SendMail', ASubject, NXLCAT_NONE, E);
      end;
    finally
      if IdSMTPKasse.Connected then
        IdSMTPKasse.Disconnect;
    end;
  except
    on Ex: Exception do
      Logger.error('TDataLogging.SendMail', ASubject, NXLCAT_NONE, Ex);
  end;
end;

procedure TDataLogging.SetSMTPHost(const Value: string);
begin
  FSMTPHost := Value;
  IdSMTPKasse.Host := Value;
end;

procedure TDataLogging.SetSMTPPort(const Value: Integer);
begin
  FSMTPPort := Value;
  IdSMTPKasse.Port := Value;
end;

procedure TDataLogging.SetSMTPRecipients(const Value: string);
begin
  FSMTPRecipients := Value;
  IdMessageKasse.Recipients.EMailAddresses := Value;
end;

procedure TDataLogging.SetSMTPSender(const Value: string);
begin
  FSMTPSender := Value;
  IdMessageKasse.From.Address := Value;
end;

end.
