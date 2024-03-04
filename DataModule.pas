unit DataModule;

interface

uses

  System.SysUtils, System.Classes, System.Variants, System.UITypes, IniFiles,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, System.StrUtils,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  Data.DB, FireDAC.Comp.Client, FireDAC.Phys.FB, FireDAC.Phys.FBDef,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.VCLUI.Wait, SQLResources, IdHTTPWebBrokerBridge,
  IdContext, IdHeaderList, ServerIntf, Web.WebReq, Vcl.ExtCtrls,
  System.SyncObjs, IdGlobal,
  Generics.Collections, Vcl.Dialogs;

type
  TAppMode = (amService, amConfig, amApplication);

type
  TRestServerStatus = (rssAppServerRunning, rssAppServerStopped,
    rssServiceRunning, rssServiceStartPending, rssServiceStopPending,
    rssServiceStopped, rssServicePaused, rssServiceContinuePending,
    rssServicePausePending, rssUnknown);

type
  TServiceAction = (saStart, saStop);

type
  TDM = class(TDataModule)
    QueryGetOpenTable: TFDQuery;
    TimerStartService: TTimer;
    ConnectionManager: TFDManager;
    ConnectionFelix: TFDConnection;
    QueryFelix: TFDQuery;
    TableKassa: TFDTable;
    TableKassaZahlweg: TFDTable;
    QueryUpdateKassaZahlweg: TFDQuery;
    QueryGetZahlwegBar: TFDQuery;
    TransactionDiverses2: TFDTransaction;
    QuerySetKassenbuch: TFDQuery;
    QueryGetKassenbuch: TFDQuery;
    TableDiverses: TFDTable;
    TableDiverses2: TFDTable;
    insertGastkonto: TFDQuery;
    QueryLeistung: TFDQuery;
    QueryTabMWST: TFDQuery;
    QueryInsertKassenjournal: TFDQuery;
    QueryArrangementLeistungen: TFDQuery;
    QueryDoSomething: TFDQuery;
    insertGKonto: TFDQuery;
    QueryCheckLosungKellner: TFDQuery;
    QueryUpdateReservierung: TFDQuery;
    QueryCheckReservierung: TFDQuery;
    QueryGetGastData: TFDQuery;
    QueryUpdateGaestestamm: TFDQuery;
    TableLosungsZuordnung: TFDTable;
    TableRechZahlweg: TFDTable;
    TableKreditOffen: TFDTable;
    TableUmsatzzuordnung: TFDTable;
    TableRechnung: TFDTable;
    TableRechnungsKonto: TFDTable;
    TableZahlweg: TFDTable;
    TableArrangement: TFDTable;
    QueryUniqueNr: TFDQuery;
    QueryGastInfo: TFDQuery;
    QueryProcGastkontoRechnung: TFDQuery;
    FDStoredProcGastKontoRechnung: TFDStoredProc;
    QueryGetTableIdFromReservId: TFDQuery;
    QueryInsertKass_KassenArchiv: TFDQuery;
    QueryGetKassIdIsSaved: TFDQuery;
    QueryTemp: TFDQuery;
    QueryAnlage: TFDQuery;
    StoredProcBOOK_RESTAURANTVALUEEXTERN: TFDStoredProc;
    QueryUpdateOrInsertArtikel: TFDQuery;
    QueryUpdateOrInsertKellner: TFDQuery;
    QueryUpdateOrInsertJournalArchiv: TFDQuery;
    TableKassenJournal: TFDTable;
    QueryFirma: TFDQuery;
    QueryInsertSendetMail: TFDQuery;
    QuerySelectErrorSendDate: TFDQuery;
    QueryUpdateOrInsertJournal: TFDQuery;
    QueryDeleteJournal: TFDQuery;
    procedure DataModuleCreate(Sender: TObject);
    procedure TimerStartServiceTimer(Sender: TObject);
    procedure ConnectionFelixError(ASender, AInitiator: TObject;
      var AException: Exception);
    // procedure DataModuleDestroy(Sender: TObject);

  private
    // FLogger: IRestLogger;
    FChecker: IRestChecker;
    FServer: TIdHTTPWebBrokerBridge;
    FAppMode: TAppMode;
    FServerPort: Integer;
    FErrorMail: string;
    FLogPath: string;
    FLogSize: Integer;
    FLogParts: Integer;
    FLogViewer: Integer;
    FLogFileServer: string;
    FLogClientName: string;
    FSectionName: string;
    FServerPath: string;
    FServerPathArchive: string;
    FSystemPassword: string;
    FVersionNumber: String;
    FIsHTTPS: Boolean;
    FKeyPassword: string;
    FKeyNameFile: string;
    FKeyCertificateFile: string;
    FRootCertificateFile: string;
    FDebugModus: Integer;
    FReconnect: Integer;
    procedure ChangeServiceState(pAction: TServiceAction);
    procedure SetServerPort(pPortNumber: Integer);
    procedure SetIsHTTPS(const Value: Boolean);
    procedure OnGetSSLPassword(var APassword: String);
    procedure SetSectionName(const Value: string);
    procedure SetServerPath(const Value: string);
    procedure SetServerPathArchive(const Value: string);
    procedure SetSystemPassword(const Value: string);
    procedure SetLogPath(const Value: string);
    procedure SetLogViewer(const Value: Integer);
    procedure SetLogFileServer(const Value: string);
    procedure SetLogClientName(const Value: string);
    procedure SetDebugModus(const Value: Integer);
    procedure LoadCertSettingsViaFile;

    function GetBoolean(aStr: String): Boolean;
    // function BetragToFloat(s: string): double;
    // function getKassInfoIdIsSaved(pConnection: TFDConnection;
    // pID: string): Boolean;
    function getDBPathName(pConnectionString: String): String;
    function getDBPort(pConnectionString: String): String;
    function getDBServerName(pConnectionString: String): String;
    procedure OnQuerySSLPort(APort: TIdPort; var AUseSSL: Boolean);
  public
    FUserCompanyName: string;
    FUserFirmaID: Integer;
    FleistId: Integer;
    FLeisBez: string;
    procedure LoadCertificateSettings;
    procedure StartServer;
    procedure StopServer;
    procedure OnParseAuthentication(AContext: TIdContext;
      const AAuthType, AAuthData: String; var VUsername, VPassword: String;
      var VHandled: Boolean);
    procedure OnHeadersAvailable(AContext: TIdContext; const AUri: string;
      AHeaders: TIdHeaderList; var VContinueProcessing: Boolean);
    function IsServerActive: Boolean;
    property AppMode: TAppMode read FAppMode write FAppMode;
    function GetServerStatus: TRestServerStatus;
    property ServerStatus: TRestServerStatus read GetServerStatus;
    property ServerPort: Integer read FServerPort write SetServerPort;
    property ErrorMail: string read FErrorMail write FErrorMail;
    property VersionNumber: String read FVersionNumber write FVersionNumber;
    property IsHTTPS: Boolean read FIsHTTPS write SetIsHTTPS;
    property SectionName: string read FSectionName write SetSectionName;
    property ServerPath: string read FServerPath write SetServerPath;
    property SystemPassword: string read FSystemPassword
      write SetSystemPassword;
    property ServerPathArchive: string read FServerPathArchive
      write SetServerPathArchive;
    property LogPath: string read FLogPath write SetLogPath;
    property LogSize: Integer read FLogSize write FLogSize;
    property LogParts: Integer read FLogParts write FLogParts;
    property LogClientName: string read FLogClientName write SetLogClientName;
    property LogViewer: Integer read FLogViewer write SetLogViewer;
    property LogFileServer: string read FLogFileServer write SetLogFileServer;
    property DebugModus: Integer read FDebugModus write SetDebugModus;

    // procedure WriteToKassaZahlWeg(pConnection: TFDConnection;
    // AZahlWegID, pKassaID: LongInt; ABetrag: double; pFirma: Integer);
    // function SetKassenBuch(pConnection: TFDConnection;
    // pZahlwegID, pErfassungDurch: Variant; pFirma: Integer): Variant;
    // function ReadGlobalValue(pConnection: TFDConnection; FieldName: String;
    // ADefault: Variant; aTyp: String): Variant;
    // function ReadGlobalValue2(pConnection: TFDConnection; FieldName: String;
    // ADefault: Variant; aTyp: String): Variant;
    //
    // function GetFelixDate(pConnection: TFDConnection; pFirma: string;
    // CompanyName: string = ''): TDateTime;
    // function getLeistIDandBez(pConnection: TFDConnection; pTischNr: Integer;
    // pMwSt: double; CompanyName: string; pFelixNachKassen: Boolean;
    // pKasseId: Integer): Boolean;
    // function getCheckID(pConnection: TFDConnection; reserfID: Integer;
    // CompanyName: string): Integer;
    // function WriteToGastkonto(pConnection: TFDConnection;
    // ATischNr, AZimmerNr: string; pAnzahl: Integer; pBetrag: double;
    // pMehrwertsteuer: double; pKellnerNr, pReservID, aFirma: Integer;
    // ptext, pLog_T: string; isEinzelBuchung, pIsBelegNr: Boolean;
    // CompanyName: string; pFelixNachKassen: Boolean; pKasseId: Integer;
    // pKassInfoId: string; var errorString: string;
    // pBuchungsdatum: String): Boolean;
    //
    // procedure WriteToKassenJournal(pConnection: TFDConnection; pDatum: TDate;
    // ARechnungsText: String; AZahlWegID, AMenge, ALeistungsID, AArrangementID,
    // pErfassungDurch, AReservID: Variant; ABetrag: double; ANetto: Boolean;
    // pFirma: Integer; pMitArbID, pKassaID: LargeInt; pMwSt: Variant);
    // function getLeistungsID1(pConnection: TFDConnection;
    // pFirma, pKasseId: Integer; pHauptGruppeID: string): Integer;
    //
    // procedure setAllRebookingsToNull(pConnection: TFDConnection;
    // pDate: TDateTime; pFirma: string);
    // procedure getRebookings(pConnection: TFDConnection; pDate: TDateTime;
    // pFirma: string);
    // procedure WriteLeistungToGastKontoIB(pConnection: TFDConnection;
    // pDatum: TDate; pFirma, pMitarbeiterId, pKassaID, ALeistungsID,
    // AMenge: LongInt; ABetrag: double; AAufRechnungsAdresse, AFix,
    // AInTABSGebucht, InKassenJournal: Boolean;
    // ARechnungsText, AStornoGrund: String; AErfassungDurch, AZahlArt,
    // AReservID: LongInt; pArrangementID, pVonReservID: Variant);
    // function SetQueryLeistung(pConnection: TFDConnection; pFirma: Integer;
    // pLeistungsID: LongInt): Boolean;
    // function GetGeneratorID(pConnection: TFDConnection; PGenerator: string;
    // PInc: Integer): Integer;
    // function checkIsDone(pConnection: TFDConnection;
    // pRecordedBy, pCompany: Integer; ptext: string; pDate: TDate;
    // pLeistungsID: Integer): Boolean;
    // procedure InsertKreditOffen(pConnection: TFDConnection; pCompanyID: Int64;
    // pBetrag: double; pZahlwegID: Int64; pDatum: TDateTime;
    // pRechNr, pReservID: Int64);
    /// /    procedure WriteToTableRechnungskonto(pConnection: TFDConnection;
    /// /      pFirma, pLeistID: Integer; pMenge: Integer; pGesamtbetrag: double);
    // function WriteToGastkontoRechnung(pConnection: TFDConnection;
    // pTischNr: string; pTime: TTime; pBetrag, pMehrwertsteuer: double;
    // pKellnerNr, pZahlwegID: Integer; ptext: string;
    // var pResultString: string): Boolean;
    procedure readConnections;
  end;

var
  DM: TDM;

implementation

{$R *.dfm}


uses
  Spring.Container, Spring.Services, Datasnap.DSSession,
  System.NetEncoding, WebModuleUnit, Web.WebBroker, Winapi.WinSvc,
  Winapi.Windows,
  Resources, nxLogging, IdSSLOpenSSL, restFelixMainUnit, Forms, CheckThingsUnit,
  CertificateSettings, SettingsUnit, Logging;

procedure TDM.DataModuleCreate(Sender: TObject);
var
  aIni: TIniFile;
  ASettings: TSettingForm;
  APath, exceptionString: string;
  I: Integer;
begin
  try
    FReconnect := 0;
    FChecker := Spring.Services.ServiceLocator.GetService<IRestChecker>;
    readConnections;

    try
      FServer := TIdHTTPWebBrokerBridge.Create(Self);
      FServer.OnParseAuthentication := OnParseAuthentication;
      FServer.OnHeadersAvailable := OnHeadersAvailable;
    except
      on e: Exception do
        Log.WriteToLog('Admin', 0, '<TDM> DataModulCreate: Fehler beim ServerParameter zuweisen:  ' +
          e.Message, lmtError);
    end;

    try
      aIni := TIniFile.Create(LogPath + cRestFelixIniFileName);

      FServer.MaxConnections := 200;
      try
        if FIsHTTPS then
          LoadCertificateSettings;
      except
        on e: Exception do
          Log.WriteToLog('Admin', 0, '<TDM> DataModulCreate: Fehler bei LoadCertificateSettings: ' + LogPath +
            '-> kein Zugriff: ' + e.Message, lmtError);
      end;
    finally
      FreeAndNil(aIni);
    end;
  finally
  end;
  APath := 'restFelix_Auth.ini';
  I := 0;
  while (I < 6) and NOT Fileexists(ExpandFileName(ExtractFilePath(ParamStr(0)) +
    APath)) do
  begin
    APath := '..\' + APath;
    inc(I);
  end;

  if not Fileexists(ExpandFileName(ExtractFilePath(ParamStr(0)) + APath)) then
  begin
    ShowMessage('Es wurden keine UserDaten gefunden gefunden' + #10#13 +
      'Sie müssen zuerst welche anlegen');
    ASettings := TSettingForm.Create(Self);
    ASettings.Show;
  end;
end;

procedure TDM.readConnections;
var
  AStrList: TStringList;
  exceptionString, AWindowsDirectory, APath, aParam, aValue, aProtocol,
    APort: string;
  ABuffer: array [0 .. MAX_PATH + 1] of Char;
  I: Integer;
  aIni: TIniFile;
  aConnectionParams: TStringList;

  function DoIni(pFile: TIniFile; pName: string; pType: string = 'string';
    pDefault: string = ''; pSection: string = 'DATABASE'): Variant;
  begin
    exceptionString := 'DoIni ';
    if Not pFile.ValueExists(pSection, pName) and (pDefault <> '') then
      if lowercase(pType) = 'integer' then
        pFile.WriteInteger(pSection, pName, strtointdef(pDefault, 0))
      else
        pFile.WriteString(pSection, pName, pDefault);

    if lowercase(pType) = 'integer' then
      Result := pFile.ReadInteger(pSection, pName, strtointdef(pDefault, 0))
    else
      Result := pFile.ReadString(pSection, pName, pDefault);

  end;

begin
  GetWindowsDirectory(ABuffer, MAX_PATH + 1);
  AWindowsDirectory := StrPas(ABuffer);

  AStrList := TStringList.Create;

  APath := 'restFelix.ini';
  I := 0;
  while (I < 6) and NOT Fileexists(ExpandFileName(ExtractFilePath(ParamStr(0)) +
    APath)) do
  begin
    APath := '..\' + APath;
    inc(I);
  end;

  if not Fileexists(ExpandFileName(ExtractFilePath(ParamStr(0)) + APath)) then
  begin
    ShowMessage('Es wurde keine restFelix.ini Datei gefunden');
    Application.Terminate;
    exit;
  end;

  // Parameter einlesen
  if ParamCount >= 1 then
  begin
    // möglicherweise sind die parameter auf 1 anders gesetzt
    for I := 1 to ParamCount do
      try
        aParam := UPPERCASE(Copy(ParamStr(I), 1, Pos('=', ParamStr(I)) - 1));
        aValue := trim(Copy(ParamStr(I), Pos('=', ParamStr(I)) + 1,
          Length(ParamStr(I))));
        if aParam = 'SECTIONNAME' then
          SectionName := aValue

      except
        on e: Exception do
          ShowMessage('Fehler beim Parameter einlesen:  ' + e.Message);
      end;
  end;
  try
    // begin
    aIni := TIniFile.Create(ExpandFileName(ExtractFilePath(ParamStr(0))
      + APath));

    try
      aIni.ReadSections(AStrList);
      aConnectionParams := TStringList.Create;

      Log.FLogPath := DoIni(aIni, 'LogPath', 'string', '', 'Allgemein');
      DebugModus := DoIni(aIni, 'DebugModus', 'integer', '0', 'Allgemein');
      ServerPort := DoIni(aIni, 'ServerPort', 'integer', '8080', 'Allgemein');
      ErrorMail := DoIni(aIni, 'ErrorMail', 'string', 'support@gms.info', 'Allgemein');

      if trim(Log.FLogPath) = '' then
        Log.FLogPath := ExtractFilePath(ParamStr(0)) + 'Logs\';

      if DoIni(aIni, 'IsHTTPS', 'string', 'false', 'Server') = 'true' then
        IsHTTPS := true
      else
        IsHTTPS := false;
      ConnectionManager.ConnectionDefs.Clear;
      rstFelixMain.cmbCompName.Items.Clear;
      for var SName in AStrList do
      begin
        // Daten aus der INI-Datei auslesen
        if (SName <> '') and (SName <> 'Allgemein') and (SName <> 'Server') then
        begin
          SectionName := SName;
          ServerPath := DoIni(aIni, 'ServerPath', 'string', '', SectionName);
          aProtocol := DoIni(aIni, 'Protocol', 'string', '', SectionName);
          APort := DoIni(aIni, 'Port', 'integer', '', SectionName);
          SystemPassword := DoIni(aIni, 'SystemPassword', 'string', '', SectionName);
          if SystemPassword = '' then
            SystemPassword := '7410';

          aConnectionParams.Clear;
          aConnectionParams.Add('DriverID=FB');
          if aProtocol = '' then
            aConnectionParams.Add('Protocol=TCPIP')
          else
            aConnectionParams.Add('Protocol=' + aProtocol);

          if DoIni(aIni, 'IsCashDesk', 'integer', '0', SName) = 0 then
          begin
            aConnectionParams.Add('CharacterSet=UTF8');
          end
          else
          begin
            aConnectionParams.Add('CharacterSet=NONE');
//            aConnectionParams.Add('CharacterSet=UTF8');
            aConnectionParams.Add('Pooled=True');
          end;

          aConnectionParams.Add('SQLDialect=3');
          aConnectionParams.Add('Database=' + getDBPathName(ServerPath));
          aConnectionParams.Add('User_Name=SYSDBA');
          aConnectionParams.Add('Password=x');
          aConnectionParams.Add('Server=' + getDBServerName(ServerPath));
          aConnectionParams.Add('Port=' + getDBPort(ServerPath));

          ConnectionManager.AddConnectionDef(SectionName, 'FB',
            aConnectionParams);
          rstFelixMain.cmbCompName.Items.Add(SectionName);
        end;

      end;

    except
      on e: Exception do
      begin
        Log.WriteToLog('Admin', 0,
          '<TDM> Fehler beim Datebankverbindungen einlesen! Section: ' + SectionName, lmtError);
      end;
    end;
  finally
//    aIni.Free;
    aConnectionParams.Free;
  end;

  try
    ConnectionManager.Active := true;
  except
    on e: Exception do
      Log.WriteToLog('Admin', 0, '<TDM> Connectionmanager kein Zugriff: ' + e.Message, lmtError);
  end;
  try
    try
      for var SName in AStrList do
      begin
        if (SName <> 'Allgemein') and (SName <> 'Server') then
        begin
          // Tabellenüberprüfung darf nur für Felix Datenbanken gemacht werden
          if DoIni(aIni, 'IsCashDesk', 'integer', '0', SName) = 0 then
          begin
            // Tabellen inkl Trigger, Generatoren und Index anlegen
            FChecker.CheckOrCreateKASS_KASSENARCHIV_KassInfoId(SName);
            FChecker.CheckOrCreateStProcGastKontoRechnung(SName);
            FChecker.checkAndCreateArtikel(SName);
            FChecker.checkAndCreateKellner(SName);
            FChecker.checkAndCreateJournalArchiv(SName);
            FChecker.checkAndCreateSend_Bug_RestServer(SName);
            FChecker.checkAndCreateJournal(SName);
            FChecker.checkAndCreateHotel_Signature(SName);
            FChecker.checkAndCreateServerInvoice(SName);
            FChecker.checkDiversesServer_GetLEistungByID(SName);
          end;
        end;
      end;
    except
      on e: Exception do
        Log.WriteToLog('Admin', 0, '<TDM> Fehler beim Tabellen überprüfen:  ' + e.Message, lmtError);
    end;
  finally
    FreeAndNil(aIni);
  end;
end;

function TDM.getDBServerName(pConnectionString: String): String;
var
  Buffer: String;
begin
  try
    Buffer := '';

    Buffer := Copy(pConnectionString, 1, Pos('/', pConnectionString, 1) - 1);
    if Buffer = '' then
      Buffer := Copy(pConnectionString, 1, Pos(':', pConnectionString, 1) - 1);

    if Buffer.IsEmpty then
      Result := 'localhost'
    else
      Result := Buffer;

    Log.WriteToLog('Admin', 0, '<TDM> getDBServerName: ' + Buffer);
  except
    on e: Exception do
      Log.WriteToLog('Admin', 0, '<TDM> getDBServerName: ' + e.Message, lmtError);
  end;
end;

function TDM.getDBPort(pConnectionString: String): String;
  function StrBetween(const Value, A, B: string): string;
  var
    aPos, bPos: Integer;
  begin
    Result := '';
    aPos := Pos(A, Value);
    if aPos > 0 then
    begin
      aPos := aPos + Length(A);
      bPos := PosEx(B, Value, aPos);
      if bPos > 0 then
      begin
        Result := Copy(Value, aPos, bPos - aPos);
      end;
    end;
  end;

begin
  try
    Result := StrBetween(pConnectionString, '/', ':');

    if Result.IsEmpty then
      Result := '3050';

    Log.WriteToLog('Admin', 0, '<TDM> getDBPort: ' + Result);
  except
    on e: Exception do
      Log.WriteToLog('Admin', 0, '<TDM> getDBPort:' + e.Message, lmtError);
  end;
end;

function TDM.getDBPathName(pConnectionString: String): String;
var
  Buffer: String;
begin
  try
    Buffer := '';
    Buffer := Copy(pConnectionString, Pos(':', pConnectionString, 1) + 1, Length(pConnectionString));

    if Buffer.IsEmpty then
      Result := 'check db name'
    else
      Result := Buffer;

    Log.WriteToLog('Admin', 0, '<TDM> getDBPathName: ' + Buffer);
  except
    on e: Exception do
      Log.WriteToLog('Admin', 0, '<TDM> getDBPathName' + e.Message, lmtError);
  end;
end;

function TDM.GetServerStatus: TRestServerStatus;
var
  aServiceManager, aService: SC_HANDLE;
  aStatus: TServiceStatus;
begin
  Result := rssUnknown;
  if AppMode = amApplication then
  begin
    if FServer.Active then
      Result := rssAppServerRunning
    else
      Result := rssAppServerStopped;
  end
  else
    if AppMode = amConfig then
    begin
      aServiceManager := OpenSCManager(nil, nil, SC_MANAGER_CONNECT);
      aService := 0;
      try
        if (aServiceManager <> 0) then
          aService := OpenService(aServiceManager, cWindowsServiceName,
            GENERIC_READ);
        if (aService <> 0) and (QueryServiceStatus(aService, aStatus)) then
          case aStatus.dwCurrentState of
            SERVICE_RUNNING:
              Result := rssServiceRunning;
            SERVICE_START_PENDING:
              Result := rssServiceStartPending;
            SERVICE_STOP_PENDING:
              Result := rssServiceStopPending;
            SERVICE_STOPPED:
              Result := rssServiceStopped;
            SERVICE_PAUSED:
              Result := rssServicePaused;
            SERVICE_CONTINUE_PENDING:
              Result := rssServiceContinuePending;
            SERVICE_PAUSE_PENDING:
              Result := rssServicePausePending;
          end;
      finally
        if aServiceManager <> 0 then
          CloseServiceHandle(aServiceManager);
        if aService <> 0 then
          CloseServiceHandle(aService);
      end;
    end;
end;

function TDM.IsServerActive: Boolean;
begin
  Result := FServer.Active;
end;

procedure TDM.LoadCertificateSettings;
var
  aIni: TIniFile;
  APath: string;
  I: Integer;
  ACert: TFormCertificates;
begin
  APath := cRestFelixIniFileName;
  I := 0;
  while (I < 6) and NOT Fileexists(ExpandFileName(ExtractFilePath(ParamStr(0)) +
    APath)) do
  begin
    APath := '..\' + APath;
    inc(I);
  end;
  if not Fileexists(ExpandFileName(ExtractFilePath(ParamStr(0)) + APath)) then
  begin
    ACert := TFormCertificates.Create(Self);
    If ACert.ShowModal = mrCancel then
      Application.Terminate
    else
    begin
      APath := cRestFelixIniFileName;
      while (I < 6) and NOT Fileexists
        (ExpandFileName(ExtractFilePath(ParamStr(0)) + APath)) do
      begin
        APath := '..\' + APath;
        inc(I);
      end;
    end;
  end;
  aIni := TIniFile.Create(ExpandFileName(ExtractFilePath(ParamStr(0)) + APath));
  try
    FKeyPassword := aIni.ReadString(cRestFelixIniServerSectionName,
      cRestFelixIniKeyPasswordName, '');
    FKeyNameFile := aIni.ReadString(cRestFelixIniServerSectionName,
      cRestFelixIniKeyNameFileName, '');
    FKeyCertificateFile := aIni.ReadString(cRestFelixIniServerSectionName,
      cRestFelixIniKeyCertificateFileName, '');
    FRootCertificateFile := aIni.ReadString(cRestFelixIniServerSectionName,
      cRestFelixIniRootCertificateFileName, '');

  finally
    FreeAndNil(aIni);
  end;
end;

procedure TDM.OnGetSSLPassword(var APassword: String);
begin
  APassword := FKeyPassword;
end;

procedure TDM.OnHeadersAvailable(AContext: TIdContext; const AUri: string;
  AHeaders: TIdHeaderList; var VContinueProcessing: Boolean);
begin
  Log.WriteToLog('Admin', 0, '<TDM> Incomming Headers: ' + TNetEncoding.URL.Decode(AHeaders.Text),lmtLogin);
  Log.WriteToLog('Admin', 0, '<TDM> Incomming URL: ' + AUri,lmtLogin);
//  Log.WriteToLog('Admin', 0, '<TDM> Incomming Context: ' + TNetEncoding.URL.Decode(AContext.Text),lmtLogin);
end;

procedure TDM.OnParseAuthentication(AContext: TIdContext;
  const AAuthType, AAuthData: String; var VUsername, VPassword: String;
  var VHandled: Boolean);
begin
//  Log.WriteToLog('Admin', 0, '<TDM> Incomming Authentication: UserName: ' + VUsername);
  // We need this event because datasnap natively doesn't support JTW authorization
  VHandled := true;
end;

procedure TDM.SetIsHTTPS(const Value: Boolean);
var
  aIni: TIniFile;
  APath: string;
  I: Integer;
begin
  FIsHTTPS := Value;
  if ServerStatus in [rssAppServerRunning, rssServiceRunning] then
  begin
    StopServer;
    TimerStartService.Enabled := true;
  end;
end;

procedure TDM.SetServerPort(pPortNumber: Integer);
var
  aIni: TIniFile;
  APath: string;
  I: Integer;
begin
  FServerPort := pPortNumber;
  if ServerStatus in [rssAppServerRunning, rssServiceRunning] then
  begin
    StopServer;
    TimerStartService.Enabled := true;
  end;
end;

procedure TDM.LoadCertSettingsViaFile;
Var
  AFormCertificates: TFormCertificates;
begin
  AFormCertificates := TFormCertificates.Create(Self);
  AFormCertificates.ShowModal;
end;

procedure TDM.StartServer;
var
  LIOHandleSSL: TIdServerIOHandlerSSLOpenSSL;
begin
  try
    if FIsHTTPS then
      LoadCertificateSettings;

    TimerStartService.Enabled := false;

    if AppMode = amConfig then
      ChangeServiceState(saStart)
    else
    begin
      // DBase.IsServer := True;
      if WebRequestHandler <> nil then
        WebRequestHandler.WebModuleClass := WebModuleClass;
      if not FServer.Active then
      begin
        FServer.Bindings.Clear;
        FServer.DefaultPort := FServerPort;
        if FIsHTTPS then
        begin
          LIOHandleSSL := TIdServerIOHandlerSSLOpenSSL.Create(FServer);
          LIOHandleSSL.SSLOptions.CertFile := FKeyCertificateFile;
          LIOHandleSSL.SSLOptions.RootCertFile := FRootCertificateFile;
          LIOHandleSSL.SSLOptions.KeyFile := FKeyCertificateFile;
          LIOHandleSSL.SSLOptions.Method := sslvSSLv23;
          LIOHandleSSL.SSLOptions.Mode := sslmUnassigned;
          LIOHandleSSL.OnGetPassword := OnGetSSLPassword;

          FServer.IOHandler := LIOHandleSSL;
          FServer.OnQuerySSLPort := OnQuerySSLPort;
        end;
        FServer.TerminateWaitTime := 10;
        FServer.Active := true;
      end;
    end;
  finally

  end;
end;

procedure TDM.OnQuerySSLPort(APort: TIdPort; var AUseSSL: Boolean);
begin
  AUseSSL := true;
end;

procedure TDM.ChangeServiceState(pAction: TServiceAction);
var
  aServiceManager, aService: SC_HANDLE;
  aParams: PWideChar;
  aServiceState: TServiceStatus;
begin
  aParams := nil;
  aServiceManager := OpenSCManager(nil, nil, SC_MANAGER_CONNECT);
  aService := 0;
  if aServiceManager <> 0 then
    aService := OpenService(aServiceManager, cWindowsServiceName,
      SERVICE_START + SERVICE_STOP);
  if aService <> 0 then
  begin
    case pAction of
      saStart:
        StartService(aService, 0, aParams);
      saStop:
        ControlService(aService, SERVICE_CONTROL_STOP, aServiceState);
    end;
  end;

end;

procedure TDM.StopServer;
var
  WebM: WebModuleUnit.TWebModule1;
  I: Integer;
begin
  if AppMode = amConfig then
    ChangeServiceState(saStop)
  else
  begin
    if TDSSessionManager.Instance <> nil then
      TDSSessionManager.Instance.TerminateAllSessions;
    try
      for I := 0 to WebRequestHandler.ComponentCount - 1 do
      begin
        WebM := WebRequestHandler.Components[I] as WebModuleUnit.TWebModule1;
        // WebM.DSServer.Stop;
      end;
      FServer.Active := false;
      FServer.Bindings.Clear;
      if Assigned(FServer.IOHandler) then
      begin
        FServer.IOHandler.Free;
        FServer.IOHandler := nil;
      end;
    except
      on e: Exception do
        Log.WriteToLog('Admin', 0, '<TDM> StopServer: ' + e.Message, lmtError);
    end;
  end;
end;

procedure TDM.TimerStartServiceTimer(Sender: TObject);
begin
  if ServerStatus in [rssServiceStopped, rssAppServerStopped] then
    StartServer;
end;

// ******************************************************************************
// Setzen der Propertys
// ******************************************************************************
procedure TDM.SetSectionName(const Value: string);
begin
  FSectionName := Value;
end;

procedure TDM.SetServerPath(const Value: string);
begin
  FServerPath := Value;
end;

procedure TDM.SetServerPathArchive(const Value: string);
begin
  FServerPathArchive := Value;
end;

procedure TDM.SetSystemPassword(const Value: string);
begin
  FSystemPassword := Value;
end;

procedure TDM.SetLogPath(const Value: string);
begin
  FLogPath := Value;
end;

procedure TDM.SetLogViewer(const Value: Integer);
begin
  FLogViewer := Value;
end;

procedure TDM.SetLogClientName(const Value: string);
begin
  FLogClientName := Value;
end;

procedure TDM.SetLogFileServer(const Value: string);
begin
  FLogFileServer := Value;
end;

procedure TDM.SetDebugModus(const Value: Integer);
begin
  FDebugModus := Value;
end;

// procedure TDM.WriteToKassaZahlWeg(pConnection: TFDConnection;
// AZahlWegID, pKassaID: LongInt; ABetrag: double; pFirma: Integer);
// begin
// // If glNoKasse Then
// // Exit;
// TableKassa.Close;
// TableKassa.Open;
// TableKassaZahlweg.Open;
// if TableKassa.Locate('ID', pKassaID, []) then
// begin
// with TableKassaZahlweg do
// begin
// // Close;
// // Open;
// try
// QueryUpdateKassaZahlweg.ParamByName('Firma').AsInteger := pFirma;
// QueryUpdateKassaZahlweg.ParamByName('KassaID').AsInteger := pKassaID;
// QueryUpdateKassaZahlweg.ParamByName('ZahlwegID').AsInteger :=
// AZahlWegID;
// if Locate('ZahlwegID', AZahlWegID, []) then
// begin
// QueryUpdateKassaZahlweg.ParamByName('Betrag').AsFloat :=
// FieldByName('Betrag').AsFloat + ABetrag;
// QueryUpdateKassaZahlweg.ParamByName('Anfangsbestand').AsFloat :=
// FieldByName('Anfangsbestand').AsFloat;
// // Edit;
// end
// else
// begin
// QueryUpdateKassaZahlweg.ParamByName('Betrag').AsFloat := ABetrag;
// QueryUpdateKassaZahlweg.ParamByName('Anfangsbestand').AsFloat := 0;
// // Append;
// // FieldByName('Firma').AsLargeInt := cFirma;
// // FieldByName('KassaID').AsLargeInt := LogInMitarbeiter.KassaID;
// // FieldByName('ZahlwegID').AsLargeInt := AZahlwegID;
// // FieldByName('Anfangsbestand').AsFloat := 0;
// // FieldByName('Firma').AsLargeInt := cFirma;
// end;
// QueryUpdateKassaZahlweg.execSQL;
// // FieldByName('Betrag').AsFloat := FieldByName('Betrag').AsFloat+ABetrag;
// // Post;
// except
// on e: Exception do
// rstFelixMain.WriteToColorLog('Error in TDM.WriteToKassaZahlWeg: ' +
// e.Message, lmtError);
//
// end;
// end;
// end
// else
// rstFelixMain.WriteToColorLog('WriteToKassaZahlweg: Kasse nicht gefunden',
// lmtError);
//
// end;
//
// function TDM.SetKassenBuch(pConnection: TFDConnection;
// pZahlwegID, pErfassungDurch: Variant; pFirma: Integer): Variant;
// begin
// Result := null;
// if GetBoolean(ReadGlobalValue2(pConnection, 'KassaBuch', '0', 'BOOLEAN')) and
// (pZahlwegID <> null) then
// begin
// if (pErfassungDurch <> null) and (StrToInt(VarToStr(pErfassungDurch))
// in [0, 1, 2, 3, 4, 5, 7, 8, 9]) then
// begin
// QueryGetZahlwegBar.Close;
// QueryGetZahlwegBar.ParamByName('Firma').AsLargeInt := pFirma;
// QueryGetZahlwegBar.ParamByName('ID').AsLargeInt := pZahlwegID;
// QueryGetZahlwegBar.Open;
// { if not TableZahlweg.Locate('ID', pZahlwegID, []) then
// FoundError( 'WriteToKassenJournal: Zahlweg nicht gefunden '+
// IntToStr(pZahlwegID)); }
// // Nur bei Bar!
// if QueryGetZahlwegBar.FieldByName('Bar').AsBoolean then
// begin
// if not TransactionDiverses2.Active then
// TransactionDiverses2.StartTransaction;
// try
// QuerySetKassenbuch.execSQL;
// TransactionDiverses2.CommitRetaining; // !!!!
// except
// TransactionDiverses2.Rollback; // Retaining;
// rstFelixMain.WriteToColorLog('SetKassenBuch: Abgefangen', lmtInfo);
// raise;
// end;
// QueryGetKassenbuch.Close;
// QueryGetKassenbuch.Open;
// Result := QueryGetKassenbuch.FieldByName('LastKassenID').AsLargeInt;
// QueryGetKassenbuch.Close;
// // TableDiverses2.Close;
// // TableDiverses2.Open;
// // aKassenLastID := TableDiverses2.FieldByName('LastKassenID').AsLargeInt;
// // Inc(aKassenLastID);
// // TableDiverses2.Edit;
// // TableDiverses2.FieldByName('LastKassenID').AsLargeInt := aKassenLastID;
// // TableDiverses2.Post;
// // TableDiverses2.Close;
// // Result := IntToStr(aKassenLastID);
// end;
// QueryGetZahlwegBar.Close;
// end;
// end;
// // 0 : SONSTIGE EINNAHMEN/AUSGABE:
// // 1 : VORAUSZAHLUNG GAST IM HAUS:
// // 2 : VORAUSZAHLUNG AUF RESERVIERUNG:
// // 3 : SCHECKEINLÃ–SUNG:
// // 4 : GASTAUSLAGEN:
// // 5:  DEVISENWECHSEL:
// // 7:  Zahlung von Rechnungen
// // 8:  OP-Verwaltung Einzahlung
// // 9:  KreditkartenDepitor Einzahlung
// end;
//
// function TDM.ReadGlobalValue(pConnection: TFDConnection; FieldName: String;
// ADefault: Variant; aTyp: String): Variant;
// var
// aQuery: TFDQuery;
// begin
// with TableDiverses do
// begin
// Open;
// REfresh;
// if FieldDefs.IndexOf(FieldName) = -1 then
// begin
// Close;
//
// aQuery := TFDQuery.Create(nil);
// aQuery.Connection := ConnectionFelix;
// aQuery.SQL.Add('ALTER TABLE Diverses ADD ' + FieldName + ' ' + aTyp);
// aQuery.execSQL;
// aQuery.Transaction.CommitRetaining; // !!!!
// aQuery.SQL.Clear;
// aQuery.SQL.Add('Update Diverses SET ' + FieldName + ' = ''' +
// ADefault + '''');
// aQuery.execSQL;
// aQuery.SQL.Clear;
// aQuery.SQL.Add('SELECT ' + FieldName + ' FROM Diverses ');
// aQuery.Open;
// Result := aQuery.FieldByName(FieldName).Value;
// aQuery.Close;
// aQuery.Free;
// Unprepare;
// Prepare;
// Open;
// end
// else
// begin
// if FieldByName(FieldName).Value = null then
// begin
// Edit;
// FieldByName(FieldName).Value := ADefault;
// Post;
// end;
// Result := FieldByName(FieldName).Value;
// end;
// end;
// end;
//
// function TDM.ReadGlobalValue2(pConnection: TFDConnection; FieldName: String;
// ADefault: Variant; aTyp: String): Variant;
// var
// aQuery: TFDQuery;
// begin
// with TableDiverses2 do
// begin
// Open;
// REfresh;
// if FieldDefs.IndexOf(FieldName) = -1 then
// begin
// Close;
// aQuery := TFDQuery.Create(nil);
// aQuery.Connection := ConnectionFelix;
// aQuery.SQL.Add('ALTER TABLE Diverses2 ADD ' + FieldName + ' ' + aTyp);
// aQuery.execSQL;
// aQuery.Transaction.CommitRetaining; // !!!!
// aQuery.SQL.Clear;
// aQuery.SQL.Add('Update Diverses2 SET ' + FieldName + ' = ''' +
// ADefault + '''');
// aQuery.execSQL;
// aQuery.SQL.Clear;
// aQuery.SQL.Add('SELECT ' + FieldName + ' FROM Diverses2 ');
// aQuery.Open;
// Result := aQuery.FieldByName(FieldName).Value;
// aQuery.Close;
// aQuery.Free;
// Unprepare;
// Prepare;
// Open;
// end;
// if FieldByName(FieldName).Value = null then
// begin
// Edit;
// FieldByName(FieldName).Value := ADefault;
// Post;
// end;
// Result := FieldByName(FieldName).Value;
// end;
// end;
//
// function TDM.GetGeneratorID(pConnection: TFDConnection; PGenerator: string;
// PInc: Integer): Integer;
// var
// aQuery: TFDQuery;
// begin
// try
// Result := 0;
// aQuery := TFDQuery.Create(nil);
// aQuery.Connection := pConnection;
// with aQuery do
// begin
// aQuery.Close;
// SQL.Clear;
// if PInc = 0 then
// SQL.Add('Select Gen_ID(' + PGenerator +
// ',0) as Gen_ID from RDB$database')
// else
// SQL.Add('Select Gen_ID(' + PGenerator + ',' + IntToStr(PInc) +
// ') as Gen_ID from RDB$database');
// end;
// if pConnection.InTransaction then
// begin
// aQuery.Open;
// Result := aQuery.FieldByName('Gen_ID').AsInteger;
// aQuery.Close;
// end
// else
// begin
// try
// pConnection.StartTransaction;
// aQuery.Open;
// Result := aQuery.FieldByName('Gen_ID').AsInteger;
// aQuery.Close;
// pConnection.Commit;
// except
// on e: Exception do
// begin
// if pConnection.InTransaction then
// pConnection.Rollback;
// rstFelixMain.WriteToColorLog('GetGeneratorID: ' + e.Message,
// lmtError);
// end;
// end;
// end;
// finally
// aQuery.Close;
// aQuery.Free;
// end;
// end;
//
// function TDM.GetFelixDate(pConnection: TFDConnection; pFirma: string;
// CompanyName: string = ''): TDateTime;
// var
// aQuery: TFDQuery;
// begin
//
// with aQuery do
// begin
// try
// try
// aQuery := TFDQuery.Create(nil);
// Connection := pConnection;
// Close;
// SQL.Clear;
// SQL.Add('select felixdate from diverses where firma = ' + pFirma);
// Open;
// while not EOF do
// begin
// Result := Fields[0].Value;
//
// next;
// end;
// except
// on e: Exception do
// begin
// rstFelixMain.WriteToColorLog('Error in TDM.GetFelixDate: ' +
// e.Message, lmtError);
// end;
// end;
// finally
// Close;
// SQL.Clear;
// aQuery.Free;
// end;
// end;
// end;
//
// function TDM.getKassInfoIdIsSaved(pConnection: TFDConnection;
// pID: string): Boolean;
// begin
// try
// Result := False;
// try
// QueryGetKassIdIsSaved.Connection := pConnection;
// with QueryGetKassIdIsSaved do
// begin
// Close;
// ParamByName('KInfId').AsString := pID;
// Open;
// Result := RecordCount = 1;
// Close;
// end;
// except
// on e: Exception do
// begin
// rstFelixMain.WriteToColorLog('Error in TDM.getKassInfoIdIsSaved: ' +
// e.Message, lmtError);
// end;
// end;
// finally
// QueryGetKassIdIsSaved.Close;
// end;
// end;
//
// function TDM.getLeistIDandBez(pConnection: TFDConnection; pTischNr: Integer;
// pMwSt: double; CompanyName: string; pFelixNachKassen: Boolean;
// pKasseId: Integer): Boolean;
// var
// aQuery: TFDQuery;
// begin
//
// with aQuery do
// begin
// Result := False;
// try
// try
// aQuery := TFDQuery.Create(nil);
// Connection := pConnection;
// Close;
// SQL.Clear;
// SQL.Add('SELECT DISTINCT LeistungsID, l.leistungsbezeichnung ' +
// 'FROM Kass_Tischzuordnung kt ' +
// 'LEFT OUTER JOIN Leistungen l on kt.LeistungsID = l.ID and l.Firma = '
// + IntToStr(FUserFirmaID) +
// 'LEFT OUTER JOIN mehrwertsteuer mw on l.firma = mw.firma and l.MwstID = mw.id ');
// if not pFelixNachKassen then
// begin
// SQL.Add('WHERE kt.TischVon <= ' + IntToStr(pTischNr) +
// ' AND kt.TischBis >= ' + IntToStr(pTischNr));
// end
// else
// begin
// SQL.Add('WHERE kt.TischVon <= ' + IntToStr(pKasseId) +
// ' AND kt.TischBis >= ' + IntToStr(pKasseId));
// end;
// SQL.Add(' and mw.mwst = ' + FloatToStr(pMwSt));
// Open;
// while not EOF do
// begin
// FleistId := Fields[0].Value;
// FLeisBez := Fields[1].Value;
// Result := True;
// next;
// end;
// except
// on e: Exception do
// begin
// rstFelixMain.WriteToColorLog('Error in TDM.getLeistIDandBez: ' +
// e.Message, lmtError);
// Result := False;
// end;
// end;
// finally
// Close;
// SQL.Clear;
// aQuery.Free;
// end;
// end;
// // result:= true; //<-- only for testing        { TODO : wieder rausnehmen }
// end;
//
/// / *****************************************************************************
/// / result is the ID if CheckIn is true
/// / *****************************************************************************
// function TDM.getCheckID(pConnection: TFDConnection; reserfID: Integer;
// CompanyName: string): Integer;
// var
// aQuery: TFDQuery;
// begin
// with aQuery do
// begin
// Result := 0;
// try
// try
// // rstFelixMain.WriteToColorLog(' TDM.getCheckId: Line 1', lmtInfo);
// aQuery := TFDQuery.Create(nil);
// // rstFelixMain.WriteToColorLog(' TDM.getCheckId: Line 2', lmtInfo);
// Connection := pConnection;
// // rstFelixMain.WriteToColorLog(' TDM.getCheckId: Line 3', lmtInfo);
// Close;
// // rstFelixMain.WriteToColorLog(' TDM.getCheckId: Line 4', lmtInfo);
// SQL.Clear;
// // rstFelixMain.WriteToColorLog(' TDM.getCheckId: Line 5', lmtInfo);
// SQL.Add('SELECT ID FROM Reservierung WHERE ID = ' + IntToStr(reserfID) +
// ' AND CheckIn = ''T''');
// // rstFelixMain.WriteToColorLog(' TDM.getCheckId: Line 6', lmtInfo);
//
// // SQL.Add('SELECT ID FROM Reservierung WHERE ID = ' + IntToStr(reserfID) +
// // ' AND CheckIn = :pCheckin');
// // ParamByname('pCheckin').AsBoolean := True;
//
// Open;
// rstFelixMain.WriteToColorLog(' TDM.getCheckId: Line 7', lmtInfo);
// while not EOF do
// begin
// Result := FieldByName('ID').AsInteger;
// rstFelixMain.WriteToColorLog(' TDM.getCheckId: Line 8', lmtInfo);
// next;
// end;
// except
// on e: Exception do
// begin
// rstFelixMain.WriteToColorLog('Error in TDM.getCheckId: ' + e.Message,
// lmtError);
// end;
// end;
// finally
// Close;
// SQL.Clear;
// aQuery.Free;
// end;
// end;
// end;
//
/// / ****************************************************************************
/// / the result is true if the dataRecord is stored
/// / ****************************************************************************
// function TDM.WriteToGastkonto(pConnection: TFDConnection;
// ATischNr, AZimmerNr: string; pAnzahl: Integer; pBetrag: double;
// pMehrwertsteuer: double; pKellnerNr, pReservID, aFirma: Integer;
// ptext, pLog_T: string; isEinzelBuchung, pIsBelegNr: Boolean;
// CompanyName: string; pFelixNachKassen: Boolean; pKasseId: Integer;
// pKassInfoId: string; var errorString: string; pBuchungsdatum: String)
// : Boolean;
// var
// pfelixDate: TDateTime;
// pFirma: string;
// pZimmer: string;
// pLeistungsID, tischNr: Integer;
// aCkeckId, AReservID, bezeichnung, aText, aKassId, MailOut: string;
// begin
// Result := False;
// insertGastkonto.Connection := pConnection;
// insertGastkonto.Connection.StartTransaction;
// try
// try
//
// pLeistungsID := 0;
// if (AZimmerNr <> '') or (pReservID <> 0) then
// begin
// try
// // Um die nullen am Anfang abzuschneiden
// AZimmerNr := IntToStr(StrToInt(AZimmerNr));
// except
// end;
// if aFirma = 0 then
// begin
// pFirma := AZimmerNr[1];
// pZimmer := Copy(AZimmerNr, 2, Length(AZimmerNr));
// end
// else
// begin
// pFirma := IntToStr(aFirma);
// pZimmer := AZimmerNr;
// end;
//
// pfelixDate := GetFelixDate(pConnection, pFirma, CompanyName);
// // <-- pfelixDate wird gesetzt
// begin
// // try
// // tischNr := StrToInt(copy(ATischNr, 2, 1))
// // except
// // ;
// // tischNr := 1;
// // end;
//
// if getCheckID(pConnection, pReservID, CompanyName) <> pReservID then
// begin
// Result := False;
// rstFelixMain.WriteToColorLog('Schreiben auf Reservierung: ReservID '
// + IntToStr(pReservID) + ' nicht gefunden!', lmtWarning);
// errorString := 'Schreiben auf Reservierung: ReservID ' +
// IntToStr(pReservID) + ' nicht gefunden!' + #10#13 + ' TischNr: ' +
// ATischNr + '; Menge: ' + IntToStr(pAnzahl) + '; Preis: ' +
// FloatToStr(pBetrag) + '; MWST: ' + FloatToStr(pMehrwertsteuer) +
// '; Text: ' + ptext + '; Belegnummer: ' + trim(pLog_T) +
// '; Firma: ' + pFirma + '; KassInfoId: ' + pKassInfoId +
// '; Datum der Buchung: ' + pBuchungsdatum;
//
// end
// else
// begin
// if NOT getKassInfoIdIsSaved(pConnection, pKassInfoId) then
// begin
// QueryAnlage.Close;
// QueryAnlage.Connection := pConnection;
// QueryAnlage.ParamByName('Firma').AsInteger := StrToInt(pFirma);
// QueryAnlage.Open;
// QueryAnlage.First;
// if (QueryAnlage.FieldByName('Typ').AsString <> '') and
// (QueryAnlage.FieldByName('Typ').AsString <> 'GMS') then
// begin
// rstFelixMain.WriteToColorLog
// ('use BOOK_RESTAURANTVALUEEXTERN', lmtInfo);
// rstFelixMain.WriteToColorLog('KassInfoId: ' + pKassInfoId +
// ' ReservId: ' + IntToStr(pReservID) + ' Zeit: ' +
// TimeToStr(Time) + ' Text: ' + ptext, lmtInfo);
// StoredProcBOOK_RESTAURANTVALUEEXTERN.Connection := pConnection;
// aKassId := pKassInfoId;
// Delete(aKassId, Length(aKassId) - 1, 2);
// if isEinzelBuchung then
// StoredProcBOOK_RESTAURANTVALUEEXTERN.ParamByName('iText')
// .Value := ptext;
// if not isEinzelBuchung then
// StoredProcBOOK_RESTAURANTVALUEEXTERN.ParamByName('iText')
// .Value := aKassId;
//
// StoredProcBOOK_RESTAURANTVALUEEXTERN.ParamByName('iLeistung')
// .Value := IntToStr(pKasseId);
// StoredProcBOOK_RESTAURANTVALUEEXTERN.ParamByName('iFirma').Value
// := pFirma;
// StoredProcBOOK_RESTAURANTVALUEEXTERN.ParamByName('iReservId')
// .Value := pReservID;
// StoredProcBOOK_RESTAURANTVALUEEXTERN.ParamByName('iTime')
// .Value := Time;
// StoredProcBOOK_RESTAURANTVALUEEXTERN.ParamByName('iValue').Value
// := pBetrag * pAnzahl;
// StoredProcBOOK_RESTAURANTVALUEEXTERN.ParamByName('iMwst').Value
// := pMehrwertsteuer;
// StoredProcBOOK_RESTAURANTVALUEEXTERN.ExecProc;
// FleistId := StoredProcBOOK_RESTAURANTVALUEEXTERN.ParamByName
// ('oResult').AsInteger;
// if FleistId = 0 then
// begin
//
// rstFelixMain.WriteToColorLog('Values transmited: ' +
// VarToStr(Result), lmtInfo);
// rstFelixMain.WriteToColorLog
// ('Keine LeistungsID oder Bezeichnung gefunden! Möglicherweise ist die MWST nicht hinterlegt! '
// + #10#13 + 'Es wurde nicht gespeichert', lmtInfo);
// rstFelixMain.WriteToColorLog('KassenId: ' + IntToStr(pKasseId)
// + ' MWST: ' + FloatToStr(pMehrwertsteuer), lmtInfo);
// errorString :=
// 'Keine LeistungsID oder Bezeichnung gefunden! Möglicherweise ist die MWST nicht hinterlegt! Es wurde nicht gespeichert';
// end
// else
// begin
// with QueryInsertKass_KassenArchiv do
// begin
// Close;
// Connection := pConnection;
// ParamByName('ID').AsInteger :=
// GetGeneratorID(pConnection, 'id', 1);
// ParamByName('Firma').AsInteger := StrToInt(pFirma);
// ParamByName('Tischnr').AsString := ATischNr;
// ParamByName('Datum').AsDate := pfelixDate;
// ParamByName('Zeit').AsTime := now;
// ParamByName('Betrag').AsFloat := pBetrag * pAnzahl;
// ParamByName('Zimmerid').AsInteger := StrToInt(pZimmer);
// ParamByName('Leistungsid').AsInteger := FleistId;
// ParamByName('Kellnr').AsInteger := pKellnerNr;
// ParamByName('Reservid').AsInteger := pReservID;
// ParamByName('Text').AsString := ptext;
// ParamByName('KassInfoId').AsString := pKassInfoId;
// execSQL;
// Close;
// end;
//
// Result := True;
// rstFelixMain.WriteToColorLog('Values transmited: ' +
// VarToStr(Result), lmtInfo);
// end;
// end
// else
// begin
// with insertGastkonto do
// begin
// Close;
// Connection := pConnection;
// ParamByName('iFirma').AsInteger := StrToInt(pFirma);
// ParamByName('iReservID').AsInteger := pReservID;
// ParamByName('vdatum').AsDateTime := pfelixDate;
// ParamByName('iMenge').AsInteger := pAnzahl;
// ParamByName('iValue').AsFloat := pBetrag;
//
// ParamByName('iFix').AsString := 'F';
// ParamByName('iaufrechnungsadresse').AsString := 'F';
// ParamByName('iIntabsgebucht').AsString := 'F';
// if getLeistIDandBez(pConnection, StrToInt(ATischNr),
// pMehrwertsteuer, CompanyName, pFelixNachKassen, pKasseId)
// then
// begin
// ParamByName('ileistungsid').AsInteger := FleistId;
// if not(isEinzelBuchung) and (pIsBelegNr) then
// begin
// aText := trim(FLeisBez) + ' ' + trim(pLog_T);
// end
// else if (isEinzelBuchung) and (pIsBelegNr) then
// begin
// aText := ptext + ' ' + trim(pLog_T);
// end
// else if not(isEinzelBuchung) and not(pIsBelegNr) then
// begin
// aText := trim(FLeisBez);
// end
// else if (isEinzelBuchung) and not(pIsBelegNr) then
// begin
// aText := ptext;
// end;
// ParamByName('itext').AsString := aText;
// execSQL;
//
// WriteToKassenJournal(pConnection, pfelixDate, aText, null,
// pAnzahl, FleistId, null, 6, pReservID, pBetrag, False,
// StrToInt(pFirma), pKellnerNr, 1, pMehrwertsteuer);
//
// with QueryGetTableIdFromReservId do
// begin
// Close;
// ParamByName('pFirma').AsInteger := StrToInt(pFirma);
// ParamByName('pReservID').AsInteger := pReservID;
// Open;
// pZimmer := FieldByName('Zimmerid').AsString;
// Close;
// end;
//
// with QueryInsertKass_KassenArchiv do
// begin
// Close;
// ParamByName('ID').AsInteger :=
// GetGeneratorID(pConnection, 'id', 1);
// ParamByName('Firma').AsInteger := StrToInt(pFirma);
// ParamByName('Tischnr').AsString := ATischNr;
// ParamByName('Datum').AsDate := pfelixDate;
// ParamByName('Zeit').AsTime := now;
// ParamByName('Betrag').AsFloat := pBetrag * pAnzahl;
// ParamByName('Zimmerid').AsInteger := StrToInt(pZimmer);
// ParamByName('Leistungsid').AsInteger := FleistId;
// ParamByName('Kellnr').AsInteger := pKellnerNr;
// ParamByName('Reservid').AsInteger := pReservID;
// ParamByName('Text').AsString := aText;
// ParamByName('KassInfoId').AsString := pKassInfoId;
// execSQL;
// Close;
// end;
//
// Result := True;
// rstFelixMain.WriteToColorLog('Values transmited: ' +
// VarToStr(Result), lmtInfo);
// end
// else
// begin
// rstFelixMain.WriteToColorLog('Values transmited: ' +
// VarToStr(Result), lmtInfo);
// rstFelixMain.WriteToColorLog
// ('Keine LeistungsID oder Bezeichnung für TischNr: ' +
// ATischNr +
// ' gefunden! Möglicherweise ist die MWST nicht hinterlegt! '
// + #10#13 + 'Es wurde nicht gespeichert', lmtError);
// errorString :=
// 'Keine LeistungsID oder Bezeichnung für TischNr: ' +
// ATischNr +
// ' gefunden! Möglicherweise ist die MWST nicht hinterlegt! Es wurde nicht gespeichert';
// end;
// end;
// end;
// end
// else
// begin
// Result := True;
// rstFelixMain.WriteToColorLog('KassInfoId ' + pKassInfoId +
// 'wurde schon früher gespeichert', lmtInfo);
// end;
// end;
// end;
// end;
// except
// on e: Exception do
// begin
// rstFelixMain.WriteToColorLog('FEHLER in WriteToGastkonto: ' + e.Message,
// lmtError);
// Result := False;
// errorString := 'Fehler beim Schreiben in Datenbank!';
// insertGastkonto.Connection.Rollback;
// end;
// end;
// finally
// if insertGastkonto.Connection.InTransaction then
// insertGastkonto.Connection.Commit;
// StoredProcBOOK_RESTAURANTVALUEEXTERN.Close;
// QueryAnlage.Close;
// end;
//
// end;
//
// procedure TDM.getRebookings(pConnection: TFDConnection; pDate: TDateTime;
// pFirma: string);
// var
// rowOfFile, ALeistungsID: Integer;
// begin
// With QueryDoSomething Do
// try
// Close;
// Connection := pConnection;
// SQL.Clear;
// SQL.Add('select sum(menge*betrag) AS Betrag, sum(menge) AS Menge, leistungsid FROM  KassenJournal');
// SQL.Add('WHERE Datum = ''' + DateToStr(pDate) + ''' AND');
// SQL.Add('BearbeiterID IS NULL AND Firma = ' + pFirma);
// SQL.Add('AND LeistungsID IN');
// SQL.Add('(SELECT LeistungsID FROM Kass_Tischzuordnung)');
// SQL.Add('GROUP BY LeistungsID');
// Open;
// while not EOF do
// begin
// TableRechnung.Connection := pConnection;
// TableRechnung.Open;
// ALeistungsID := FieldByName('LeistungsID').AsLargeInt;
// TableRechnungsKonto.Connection := pConnection;
// TableRechnungsKonto.Open;
// if ((TableRechnung.FieldByName('Datum').AsDateTime = pDate) and
// ((TableRechnung.FieldByName('Rechnungsnummer').AsLargeInt = 0) or
// (TableRechnung.FieldByName('Rechnungsnummer').AsLargeInt = 99999))) OR
//
// // (TableRechnung.FieldByName('Rechnungsnummer').AsLargeInt = 0)) OR
// TableRechnung.Locate('Firma;Rechnungsnummer;Datum',
// VarArrayOf([pFirma, 0, pDate]), []) then
// begin
// TableRechnungsKonto.Append;
// TableRechnungsKonto.FieldByName('ID').AsLargeInt :=
// GetGeneratorID(pConnection, 'id', 1);
// TableRechnungsKonto.FieldByName('Datum').AsDateTime :=
// GetFelixDate(pConnection, pFirma);
// TableRechnungsKonto.FieldByName('LeistungsID').AsLargeInt :=
// ALeistungsID;
// TableRechnungsKonto.FieldByName('Menge').AsLargeInt :=
// FieldByName('Menge').AsLargeInt;
// TableRechnungsKonto.FieldByName('GesamtBetrag').AsCurrency :=
// -FieldByName('Betrag').AsFloat;
// SetQueryLeistung(pConnection, StrToInt(pFirma), ALeistungsID);
// TableRechnungsKonto.FieldByName('LeistungsText').AsString :=
// QueryLeistung.FieldByName('LeistungsBezeichnung').AsString;
// TableRechnungsKonto.Post;
//
// end
// else
// begin
// rstFelixMain.WriteToColorLog
// ('Fehler in BucheUmsatz: Rechnung nicht gefunden gefunden | LeistungsId: '
// + IntToStr(ALeistungsID), lmtError);
// end;
// next;
// end;
//
// finally
// TableRechnung.Close;
// TableRechnungsKonto.Close;
// end;
//
// end;
//
// procedure TDM.setAllRebookingsToNull(pConnection: TFDConnection;
// pDate: TDateTime; pFirma: string);
// begin
// With QueryDoSomething Do
// Begin
// Close;
// Connection := pConnection;
// SQL.Clear;
// SQL.Add('UPDATE KassenJournal');
// SQL.Add('SET Menge = 0');
// SQL.Add('WHERE Datum = ''' + DateToStr(pDate) + ''' AND');
// SQL.Add('BearbeiterID IS NULL AND Firma = ' + pFirma);
// SQL.Add('AND LeistungsID IN');
// SQL.Add('(SELECT LeistungsID FROM Kass_Tischzuordnung)');
// execSQL;
// End;
// end;
//
// function TDM.getLeistungsID1(pConnection: TFDConnection;
// pFirma, pKasseId: Integer; pHauptGruppeID: string): Integer;
// begin
// If TableUmsatzzuordnung.Locate('Firma;KasseID;HauptGruppeID',
// VarArrayOf([pFirma, pKasseId, pHauptGruppeID]), []) Then
// Result := TableUmsatzzuordnung.FieldByName('LeistungsID').AsLargeInt
// else If TableUmsatzzuordnung.Locate('KasseID;HauptGruppeID',
// VarArrayOf([pKasseId, pHauptGruppeID]), []) Then
// Result := TableUmsatzzuordnung.FieldByName('LeistungsID').AsLargeInt
// else If TableUmsatzzuordnung.Locate('HauptGruppeID', pHauptGruppeID, []) Then
// Result := TableUmsatzzuordnung.FieldByName('LeistungsID').AsLargeInt
// else If TableUmsatzzuordnung.Locate('HauptGruppeID', 0, []) Then
// Result := TableUmsatzzuordnung.FieldByName('LeistungsID').AsLargeInt
// else If TableUmsatzzuordnung.Locate('Firma;HauptGruppeID',
// VarArrayOf([pFirma, pHauptGruppeID]), []) Then
// Result := TableUmsatzzuordnung.FieldByName('LeistungsID').AsLargeInt
// else
// Result := 0;
// end;
//
// procedure TDM.WriteLeistungToGastKontoIB(pConnection: TFDConnection;
// pDatum: TDate; pFirma, pMitarbeiterId, pKassaID, ALeistungsID,
// AMenge: LongInt; ABetrag: double; AAufRechnungsAdresse, AFix, AInTABSGebucht,
// InKassenJournal: Boolean; ARechnungsText, AStornoGrund: String;
// AErfassungDurch, AZahlArt, AReservID: LongInt;
// pArrangementID, pVonReservID: Variant);
// begin
// if AMenge = 0 then
// exit;
// try
// with insertGKonto do
// begin
// Close;
// Connection := pConnection;
// ParamByName('Firma').AsLargeInt := pFirma;
// ParamByName('BearbeiterID').AsLargeInt := pMitarbeiterId;
// ParamByName('ReservID').AsLargeInt := AReservID;
// ParamByName('Datum').AsDateTime := pDatum;
// ParamByName('LeistungsText').AsString := ARechnungsText;
// ParamByName('Menge').AsLargeInt := AMenge;
// ParamByName('Betrag').AsFloat := ABetrag;
// ParamByName('LeistungsID').AsLargeInt := ALeistungsID;
// ParamByName('ArrangementID').Value := pArrangementID;
// // Nur der TagesabschluÃŸ verbucht Fixleistungen und ruft diese Funktion
// // mit InTABSGebucht = TRUE auf..
// ParamByName('Fix').AsBoolean := AFix;
// // Je nach Zahlart, wird das Feld AufRechnungsadresse gesteuert.
// // Wurde keine Zahlart Ã¼bergeben (-1) dann wird der Ã¼bergebene Wert
// // AAufRechnungsadresse genommen
// // fÃ¼r die Werte 0,2,3,4,9 ist noch nichst definiert!
// begin
// case AZahlArt of
// - 1, 0, 2, 3, 4, 9:
// ParamByName('AufRechnungsAdresse').AsBoolean :=
// AAufRechnungsAdresse;
// // Selbstzahler
// 1:
// ParamByName('AufRechnungsAdresse').AsBoolean := False;
// // Full Credit
// 5:
// ParamByName('AufRechnungsAdresse').AsBoolean := True;
// // Fix = FullCredit, Extras = Selbstzahler
// // InTabsGebucht ist gleich wie Fix (siehe Fix weiter oben)
// 7:
// ParamByName('AufRechnungsAdresse').AsBoolean := AInTABSGebucht;
// end;
// end;
// ParamByName('InTABSGebucht').AsBoolean := AInTABSGebucht;
// execSQL;
// end;
// if InKassenJournal then
// begin
// if (ARechnungsText = '') or ((AStornoGrund <> '') And (AMenge < 0)) then
// ARechnungsText := AStornoGrund;
// WriteToKassenJournal(pConnection, pDatum, ARechnungsText, null, AMenge,
// ALeistungsID, pArrangementID, AErfassungDurch, AReservID, ABetrag, True,
// pFirma, pMitarbeiterId, pKassaID, null);
// end;
// except
// on e: Exception do
// begin
// rstFelixMain.WriteToColorLog('Error in TDM.WriteToGastKontoIB: ' +
// e.Message, lmtError);
// end;
// end;
// end;
//
// function TDM.SetQueryLeistung(pConnection: TFDConnection; pFirma: Integer;
// pLeistungsID: LongInt): Boolean;
// begin
//
// QueryLeistung.Close;
// QueryLeistung.Connection := pConnection;
// QueryLeistung.ParamByName('Firma').AsLargeInt := pFirma;
// QueryLeistung.ParamByName('ID').AsLargeInt := pLeistungsID;
// QueryLeistung.Open;
// Result := not QueryLeistung.FieldByName('ID').IsNull;
//
// end;
//
// procedure TDM.WriteToKassenJournal(pConnection: TFDConnection; pDatum: TDate;
// ARechnungsText: String; AZahlWegID, AMenge, ALeistungsID, AArrangementID,
// pErfassungDurch, AReservID: Variant; ABetrag: double; ANetto: Boolean;
// pFirma: Integer; pMitArbID, pKassaID: LargeInt; pMwSt: Variant);
// var
// aNotLogisPreis, aPreisAnteil: double;
// aOrtsTaxe: double;
// aProzArrAnteil: double;
//
// procedure NeuerDatensatzJournal;
// begin
// with QueryInsertKassenjournal do
// begin
// ParamByName('ID').AsLargeInt := GetGeneratorID(pConnection, 'id', 1);
// ParamByName('Firma').AsLargeInt := pFirma;
// ParamByName('BearbeiterID').AsLargeInt := pMitArbID;
// ParamByName('ReservID').Value := AReservID;
// ParamByName('Datum').AsDateTime := pDatum;
// ParamByName('Zeit').AsTime := Time;
// // ParamByName('LEISTUNGSID').Value := FleistId;
// ParamByName('KassaID').AsLargeInt := pKassaID;
// ParamByName('ErfassungDurch').Value := pErfassungDurch;
// ParamByName('Text').AsString := ARechnungsText;
// ParamByName('Menge').Value := AMenge;
// ParamByName('ArrangementID').Value := AArrangementID;
// ParamByName('ZahlwegID').Value := AZahlWegID;
// ParamByName('Bankleitzahl').Value := SetKassenBuch(pConnection,
// AZahlWegID, pErfassungDurch, pFirma);
// // ParamByName('Betrag').AsFloat := ABetrag;
// ParamByName('MwSt').Value := pMwSt;
// // ExecSQL;
// end;
// end;
//
// begin
// try
// with QueryInsertKassenjournal do
// begin
// Connection := pConnection;
// // Wenn die Leistungsnummer null ist, die Arrngementnummer aber nicht, bedeutet
// // das, dass das ganze Arrangment einzeln in das Kassenjournal verbucht werden
// // muss!
// aNotLogisPreis := 0;
// aProzArrAnteil := 0;
// if (AArrangementID <> null) and (ALeistungsID = null) then
// begin
// // Das Arrangement wird aus der Arrangementtabelle geholt...
// if TableArrangement.Locate('ID', AArrangementID, []) then
// begin
// // Alle Leistungen dieses Arrangements werden in die Gastkontotabelle
// // verbucht
// // Alle Leistungen dieses Arrangements werden in die Gastkontotabelle
// // verbucht
// QueryArrangementLeistungen.Close;
// QueryArrangementLeistungen.Connection := pConnection;
// QueryArrangementLeistungen.ParamByName('Firma').AsInteger := pFirma;
// QueryArrangementLeistungen.ParamByName('ArrangementID').AsInteger :=
// AArrangementID;
// QueryArrangementLeistungen.Open;
// QueryArrangementLeistungen.First;
// while not QueryArrangementLeistungen.EOF do
// begin
// // Wenn 1 dann verbuchen
// if (QueryArrangementLeistungen.FieldByName('PreisKategorie')
// .AsInteger in [1, 8]) or
// (QueryArrangementLeistungen.FieldByName('PreisKategorie')
// .Value = null) then
// begin
// NeuerDatensatzJournal;
// ParamByName('LeistungsID').AsInteger :=
// QueryArrangementLeistungen.FieldByName('LeistungsID').AsInteger;
// // Prozentberechnung
// if QueryArrangementLeistungen.FieldByName('PreisKategorie')
// .AsInteger = 8 then
// aPreisAnteil := (ABetrag - aProzArrAnteil) / 100 *
// QueryArrangementLeistungen.FieldByName('Preisanteil').AsFloat
// else
// begin
// aProzArrAnteil := aProzArrAnteil +
// QueryArrangementLeistungen.FieldByName('Preisanteil').AsFloat;
// aPreisAnteil := QueryArrangementLeistungen.FieldByName
// ('Preisanteil').AsFloat;
// end;
// aNotLogisPreis := aNotLogisPreis + aPreisAnteil;
// ParamByName('Betrag').AsFloat := aPreisAnteil;
// // Leistung des Arrangements in Kassenjournal eintragen
// execSQL;
// end;
// QueryArrangementLeistungen.next;
// end;
// QueryArrangementLeistungen.Close;
// end
// else
// rstFelixMain.WriteToColorLog
// ('1008: ArrangementVerbuchen in Journal: Arrangement nicht gefunden',
// lmtError);
// if GetBoolean(DM.ReadGlobalValue2(pConnection, 'OrtstaxeProz', '0',
// 'BOOLEAN')) and (TableArrangement.FieldByName('GesamtPreis')
// .AsLargeInt = 0) then
// begin
// aOrtsTaxe := (ABetrag - aNotLogisPreis) / 100 *
// BetragToFloat(DM.ReadGlobalValue2(pConnection, 'OrtstaxeProzent',
// '0', 'FLOAT'));
// NeuerDatensatzJournal;
// ParamByName('LeistungsID').AsLargeInt :=
// StrToInt(DM.ReadGlobalValue2(pConnection, 'OrtstaxeLNID', '0',
// 'INTEGER'));
// ParamByName('Betrag').AsFloat := aOrtsTaxe;
// execSQL;
// aNotLogisPreis := aNotLogisPreis + aOrtsTaxe;
// end;
// // Die Leistung "Logis" berrechnet sich aus dem Gesamtpreis -
// // den Preisanteilen der Leistungen aus der Arrangementleistungstabelle
// NeuerDatensatzJournal;
// ParamByName('LeistungsID').AsLargeInt := TableArrangement.FieldByName
// ('LNLogis').AsLargeInt;
// ParamByName('Betrag').AsFloat := ABetrag - aNotLogisPreis;
// // ErfassungDurch = 11 -> beim tranferieren von Arrangements soll
// // diese Fehlermeldung nicht kommen!!!
// if (aNotLogisPreis > ABetrag) and not(pErfassungDurch = 11) then
// rstFelixMain.WriteToColorLog
// ('126: Preisanteil der Leistungen größer als Gesamtpreis', lmtInfo);
// execSQL;
// end
// else
// begin
// NeuerDatensatzJournal;
// // Wenn ANetto beachtet werden soll
// if ANetto then
// begin
// QueryLeistung.Close;
// QueryLeistung.Connection := pConnection;
// QueryLeistung.ParamByName('Firma').AsLargeInt := pFirma;
// QueryLeistung.ParamByName('ID').AsLargeInt := ALeistungsID;
// QueryLeistung.Open;
//
// if QueryLeistung.FieldByName('ID').IsNull then
// rstFelixMain.WriteToColorLog
// ('127: WriteToKassenJournal: Leistung nicht gefunden', lmtError);
// // und das Kennzeichen "KeimUmsatz" in der Leistungstabelle gesetzt
// // ist
// if QueryLeistung.FieldByName('KeinUmsatz').AsBoolean then
// begin
// // Dann im Kassenjournal den Bruttowert des Ã¼bergebenen Betrages
// // errechnen und verbuchen
// if not QueryTabMWST.Locate('ID', QueryLeistung.FieldByName('MwstID')
// .AsLargeInt, []) then
// rstFelixMain.WriteToColorLog
// ('128: WriteToKassenJournal: MwSt nicht gefunden', lmtError);
// ABetrag := ABetrag + ABetrag * QueryTabMWST.FieldByName('MwSt')
// .AsFloat / 100;
// end;
// end;
// QueryLeistung.Close;
// ParamByName('Betrag').Value := ABetrag;
// ParamByName('LeistungsID').Value := ALeistungsID;
// ParamByName('ReservID').Value := AReservID;
// execSQL;
// end;
// end;
// except
// on e: Exception do
// rstFelixMain.WriteToColorLog
// ('128: WriteToKassenJournal: MwSt nicht gefunden' + #13 + e.Message,
// lmtError);
// end;
// end;
//
// function TDM.checkIsDone(pConnection: TFDConnection;
// pRecordedBy, pCompany: Integer; ptext: string; pDate: TDate;
// pLeistungsID: Integer): Boolean;
// begin
// Result := False;
// with QueryDoSomething do
// begin
// Connection := pConnection;
// Close;
// SQL.Clear;
// SQL.Add('SELECT ID FROM KassenJournal');
// SQL.Add('WHERE Datum = ''' + DateToStr(pDate) + ''' AND');
// SQL.Add('Erfassungdurch = :Erfassungdurch AND');
// SQL.Add('Text LIKE :Text');
// SQL.Add('AND Firma = :Firma');
// SQL.Add('AND LeistungsId = :LeistungsId');
// ParamByName('Erfassungdurch').Value := pRecordedBy;
// ParamByName('Text').Value := ptext + '%';
// ParamByName('Firma').Value := pCompany;
// ParamByName('LeistungsId').Value := pLeistungsID;
// Open;
//
// if not FieldByName('ID').IsNull then
// Result := True;
// end;
// end;
//
procedure TDM.ConnectionFelixError(ASender, AInitiator: TObject;
  var AException: Exception);
begin
  if Pos('CONNECTION', AException.Message.ToUpper) > 0 then
  begin
    if FReconnect < 2 then
    begin
      inc(FReconnect);
      ConnectionFelix.Connected := false;

      ConnectionFelix.Connected := true;

    end;
  end;

  Log.WriteToLog(FUserCompanyName, 0, '<TDM> Error in TDM.ConnectionFelixError: ' +
    AException.Message, lmtError);
end;
//
// procedure TDM.InsertKreditOffen(pConnection: TFDConnection; pCompanyID: Int64;
// pBetrag: double; pZahlwegID: Int64; pDatum: TDateTime;
// pRechNr, pReservID: Int64);
// var
// qInsertKreditOffen: TFDQuery;
// begin
// try
// qInsertKreditOffen := TFDQuery.Create(nil);
// qInsertKreditOffen.Connection := pConnection;
// qInsertKreditOffen.SQL.Add
// ('insert into kreditoffen (ID, Firma, Betrag, ZahlwegID, Datum, RechNr, ReservID)');
// qInsertKreditOffen.SQL.Add
// ('values(GEN_ID(ID, 1), :Firma, :Betrag, :ZahlwegID, :Datum, :RechNr, :ReservID)');
//
// qInsertKreditOffen.ParamByName('Firma').AsLargeInt := pCompanyID;
// qInsertKreditOffen.ParamByName('Betrag').AsFloat := pBetrag;
// qInsertKreditOffen.ParamByName('ZahlwegID').AsLargeInt := pZahlwegID;
// qInsertKreditOffen.ParamByName('Datum').AsDateTime := pDatum;
// qInsertKreditOffen.ParamByName('RechNr').AsLargeInt := pRechNr;
// if pReservID <> 0 then
// qInsertKreditOffen.ParamByName('ReservID').AsLargeInt := pReservID
// else
// qInsertKreditOffen.ParamByName('ReservID').Clear;
// qInsertKreditOffen.execSQL;
// except
// on e: Exception do
// rstFelixMain.WriteToColorLog('Error in TDM.InsertKreditOffen: ' +
// e.Message, lmtError);
// end;
// end;
//
//
// function TDM.WriteToGastkontoRechnung(pConnection: TFDConnection;
// pTischNr: string; pTime: TTime; pBetrag, pMehrwertsteuer: double;
// pKellnerNr, pZahlwegID: Integer; ptext: string;
// var pResultString: string): Boolean;
// var
// pfelixDate: TDateTime;
// pFirma: string;
//
// begin
// Result := True;
// try
//
// with FDStoredProcGastKontoRechnung do
// begin
// Close;
// Connection := pConnection;
// ParamByName('iFirma').AsInteger := FUserFirmaID;
// try
// ParamByName('iTischNr').AsInteger := StrToInt(Copy(pTischNr, 2, 1))
// except
// ;
// ParamByName('iTischNr').AsInteger := 1;
// end;
// // ParamByName('iTischNr').AsInteger := 1;
// ParamByName('iZahlwegID').AsInteger := pZahlwegID;
// ParamByName('iTime').AsDateTime := pTime;
// ParamByName('iValue').AsFloat := pBetrag;
// ParamByName('iMwst').AsFloat := pMehrwertsteuer;
// ParamByName('iText').AsString := ptext;
// ExecProc;
// if ParamByName('Oresult').AsInteger = 0 then
// begin
// rstFelixMain.WriteToColorLog
// ('Schreiben von Rechnung nicht OK, Zahlweg nicht definiert', lmtInfo);
// pResultString :=
// 'Schreiben von Rechnung nicht OK, Zahlweg nicht definiert';
// Result := False;
// // ConnectionFelix.Transaction.Rollback;
// end;
// // else
// // begin
// // ConnectionFelix.Transaction.Commit;
// // end;
//
// rstFelixMain.WriteToColorLog('Aufbuchen von ' + Format('%.2n', [pBetrag])
// + ',- Zahlweg ' + IntToStr(pZahlwegID), lmtInfo);
// end;
// except
// on e: Exception do
// begin
// rstFelixMain.WriteToColorLog('FEHLER in WriteToGastkontoRechnung: ' +
// e.Message, lmtError);
// // ConnectionFelix.Transaction.Rollback;
// Result := False;
// raise;
// end;
// end;
// QueryProcGastkontoRechnung.Close;
// FDStoredProcGastKontoRechnung.Close;
// end;
//
/// / Löscht die Tausendertrennzeichen eines Betrages
// function TDM.BetragToFloat(s: string): double;
// var
// posit: byte;
// begin
// Result := 0;
// posit := Pos(FormatSettings.ThousandSeparator, s);
// repeat
// Delete(s, posit, 1);
// posit := Pos(FormatSettings.ThousandSeparator, s);
// until (posit = 0);
// try
// Result := StrToFloat(s);
// except
// rstFelixMain.WriteToColorLog('269: Dieser Wert ist keine Zahl', lmtError);
// end;
// end;

function TDM.GetBoolean(aStr: String): Boolean;
begin
  if aStr = 'T' then
    Result := true
  else
    Result := false;
end;

end.
