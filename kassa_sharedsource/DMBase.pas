unit DMBase;

interface

uses
  SysUtils, Classes,
  DB,
  ExtCtrls, ADODB,
  IdIPWatch, IdComponent,
  IdTCPConnection, IdTCPClient, IdExplicitTLSClientServerBase, IdMessageClient,
  IdSMTPBase, IdSMTP, IdBaseComponent, IdMessage,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.VCLUI.Wait, FireDAC.Comp.Client, FireDAC.Comp.DataSet,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.ScriptCommands, FireDAC.Stan.Util, FireDAC.Comp.Script,
  FireDAC.Phys.FB, FireDAC.Phys.FBDef, ComCtrls;

type
  TDBase = class(TDataModule)
    DSQueryKasse: TDataSource;
    TimerConnect: TTimer;
    ConnectionZEN: TFDConnection;
    TableDiverses: TFDTable;
    QueryGetNextID: TFDQuery;
    QueryShort: TFDQuery;
    QueryKasse: TFDQuery;
    QueryEinstell: TFDQuery;
    QuerySchlossOptionen: TFDQuery;
    ScriptExecuteSQL: TFDScript;
    DSQLExecute: TFDQuery;
    ConnectionManager: TFDManager;
    QueryFirma: TFDQuery;
    ConnectionFelix: TFDConnection;
    QueryFelix: TFDQuery;
    procedure TimerConnectTimer(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);
    procedure ConnectionZENBeforeConnect(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure ConnectionZENError(ASender, AInitiator: TObject;
      var AException: Exception);
    procedure ConnectionZENAfterConnect(Sender: TObject);

  private
    // für "sauberes" Beenden von modalen Fenstern bei Abzug des Kellnerschlüssels
    // immer nur in Hauptfunktionen die "Sanduhr" setzen, nicht nochmal in den Unterfunktionen
    FBusy: Integer;

    FFirma: Integer;
    FFirmenname: string;
    FDebugModus: Integer;
    FLogClientName: string;
    FServerPathArchive: string;
    FFelixPath: string;
    FLogPath: string;
    FLogSize: Integer;
    FLogParts: Integer;
    // FReportPath:string;
    FServerPath: string;
    FFiskaltrustPath: string;
    FSectionName: string;
    FKasseID: Integer;
    FKasseLocalID: Integer;
    FMonitor: Integer;
    FWaiterID: Integer;
    FDFMVerzeichnis: string;
    FReservationSetup: string;
    FLogViewer: Integer;
    FLogFileServer: string;
    // TRUE: Datebase tries actually to reconnect
    FReconnect: Integer;
    FConnected: Boolean;
    FOnReconnect: TNotifyEvent;
    FSystemPassword: string;
    FDAS: Boolean;
//    FAktion: string;
    FIsServer: Boolean;


    procedure SetFirma(const Value: Integer);
    procedure SetDebugModus(const Value: Integer);
    procedure SetODBCPath(PServer: string);
    procedure SetLogPath(const Value: string);
    procedure SetLogClientName(const Value: string);
    procedure SetServerPath(const Value: string);
    procedure SetFiskaltrustPath(const Value: string);
    procedure SetServerPathArchive(const Value: string);
    procedure SetFelixPath(const Value: string);
    procedure SetSectionName(const Value: string);
    procedure SetKasseID(const Value: Integer);
    procedure SetMonitor(const Value: Integer);
    procedure SetWaiterID(const Value: Integer);
    procedure SetDFMVerzeichnis(const Value: string);
    procedure SetReservationSetup(const Value: string);
    procedure SetLogViewer(const Value: Integer);
    procedure SetLogFileServer(const Value: string);
    function GetKasseID: Integer;
    procedure SetSystemPassword(const Value: string);
    function GetKasseLocalID: Integer;
    procedure SetKasseLocalID(const Value: Integer);
    function GetBusy: Boolean;
    procedure SetBusy(const Value: Boolean);

  public
    FProgrammStart: Boolean;
    FisErrorFormShow: Boolean;
    FAnzahl: Integer;

    ConnectPathList: TStringList;

    property Busy: Boolean read GetBusy write SetBusy;

    property SectionName: string read FSectionName write SetSectionName;
    property Firma: Integer read FFirma write SetFirma;
    property Firmenname:string read FFirmenname;

    property DebugModus: Integer read FDebugModus write SetDebugModus;
    property LogPath: string read FLogPath write SetLogPath;
    property LogSize: Integer read FLogSize write FLogSize;
    property LogParts: Integer read FLogParts write FLogParts;

    // property LogServer: String read FLogServer write FLogServer;
    property ServerPath: string read FServerPath write SetServerPath;
    property FiskaltrustPath: string read FFiskaltrustPath write SetFiskaltrustPath;
    property ServerPathArchive: string read FServerPathArchive
      write SetServerPathArchive;
    property FelixPath: string read FFelixPath write SetFelixPath;
    property LogClientName: string read FLogClientName write SetLogClientName;
    property KasseID: Integer read GetKasseID write SetKasseID;
    property KasseLocalID: Integer read GetKasseLocalID write SetKasseLocalID;
    property Monitor: Integer read FMonitor write SetMonitor;
    property WaiterID: Integer read FWaiterID write SetWaiterID;
    property DFMVerzeichnis: string read FDFMVerzeichnis
      write SetDFMVerzeichnis;
    property ReservationSetup: string read FReservationSetup
      write SetReservationSetup;
    property LogViewer: Integer read FLogViewer write SetLogViewer;
    property LogFileServer: string read FLogFileServer write SetLogFileServer;
    property SystemPassword: string read FSystemPassword
      write SetSystemPassword;
    property OnReconnect: TNotifyEvent read FOnReconnect write FOnReconnect;
    property DAS: Boolean read FDAS write FDAS;
    property IsServer: Boolean read FIsServer write FIsServer;

    function GetGeneratorID(PGenerator: string; PInc: Integer): Integer;
    function SetGeneratorID(PGenerator: string): Integer;
    // function DeleteCheck(PProcedureName, PParam, PNotDelete:string): Boolean;
    function DoConnectDatabase(pConnection: TFDConnection=nil): Boolean;
    function GetMaxID(PTableName, PFeld: string): Integer;
    // Get the next id from the generator
    function GetNextID(PTableName: string; PDataSet: TDataSet): Integer;
    function SetMaxID(PTableName: string; PDataSet: TDataSet): Integer;
    // get the next ID from MaxID by Table
    function GetNextNumber(PTableName, PFeld: string): Integer;
    function GetCount(pSQL: string): Integer;
    // function SQLExecute(PSQL:string): Boolean;
    // if field in a Table then add a new field
    // function CheckTablesFields(PTableName, PFieldName,
    // PFieldTyp:string): Boolean;

    procedure CursorON;
    procedure CursorOFF;
    procedure WriteToLog(PLogStr: string; PWrite: Boolean = TRUE);
    // procedure ExecuteProzedure(PProz:string);
    procedure ChangeToArchiv(PArchiv: Boolean);

    // 11.03.2014 KL: Daten-Migration in allen GKT-Programmen vereinheitlichen
    function CheckTable(const PTableName: string): Boolean;
    function CheckField(const PTableName, PFieldName: string; PFieldSource: string=''): Boolean;
    function CheckTrigger(const PTableName, PTriggerSource: string;
      PTriggerType: Integer; out OTriggerName: string;
      out OSequence: Integer): Boolean;
    function CheckTriggerName(const pTriggerName: string): Boolean;
    function CheckIndexName(const pIndexName: String): Boolean;
    function CheckGeneratorName(const pGeneratorName: string): Boolean;
    function CheckConstraintName(const pConstraintName: string): Boolean;
    function GetPrimaryKeyName(const pTableName: string): string;
    function CheckProcedureName(const pProcedureName: string): Boolean;
    function CheckViewName(const pViewName: string): Boolean;
    function ExecuteSQL(const pSqlCommand: String; pWriteToReplDB: Boolean = TRUE): Boolean;
    procedure MigrateData;
    procedure LogParams;
    function GetMyApplicationVersion: String;

    // // 09.07.2014 KL: SQL-Statements für Unit-Tests
    // function SQLUnitTest(PSQL:string): Integer;

    // in D10 muss die IB_Connection immer neu zugeordnet werden, weil die IDE sie immer wieder "verliert"
    procedure SetDefaulftConnection(PComponent: TComponent; pConnection: TFDConnection = nil);

    // 27.10.2016 KL: Debug-Modus nur zum testen in der IDE auf Starscreen
    function IsDebug: Boolean;
    procedure CopyQueryToClipboard(pQueryOrTable: TFDCustomQuery);
    procedure CopyToClipboard(pText: string);
    function SQLExecute(pSQL:String):boolean;
    // 01.04.2019 KL: #22278 Feldlänge abfragen
    function GetFieldLength(const pTableName, pFieldName: string): integer;

    // 16.07.2019 KL: #22960
    function AnsiUpperCaseFireBird(const pStr: String): String; // obsolete, please use AnsiUppercaseSQL
    function AnsiUppercaseUmlauteFirebird(const pField: string): string;
    function AnsiUppercaseUmlaute(const pStr: string): string;
    function AnsiUppercaseSQL(const pField, pStr: String): String;

    procedure ApplicationProcessMessages;
    procedure CommitAllNestedTransactions(pConnection: TFDConnection = nil);

  end;

var
  DBase: TDBase;

implementation

{$R *.dfm}
{$WARN SYMBOL_PLATFORM OFF}

uses IniFiles, Forms, Dialogs, clipbrd,
Registry, Windows, Controls, StrUtils, nxLogging, SelectDB;

resourcestring
  RscCheckDelete1 = 'Wollen Sie diesen Datensatz wirklich löschen?';
  // übersetzt von KL am 30.8.2011
  // rscCheckDelete1 = 'Do you really want to delete this dataset?';
  RscCheckDelete2 = 'Error in procedure. ';
  RscSQLExecute1 = 'Error in SQLExecute: ';
  RscGetGeneratorID1 = 'Error: ';
  RscStrVersucheVerbindung = 'Trying to establish the connection again.';
  RscStrVerbindungZurDaten =
    'Lost connection to database. Please check your network.';
  RscStrDieVerbindung = 'Connection to database could not be established.';
  RscStrBitte = 'Please check the paths in file: Kasse.ini';
  StrNoKasseiniFileFo = 'No kasse.ini file found!';
  StrUnknownParameter = 'unknown parameter - ';
  RscConnectionEstablished = 'Connection is now established!';

  // ******************************************************************************
  // Standrard aufruf für das Löschen, alle löschungen erolgen in der Proc.
  // sollte kein löschen möglich sein, gibt die Proc die Namen der Tabellen zurück
  // procedure bedienung ist,  das Resultfeld muss immer o_table sein
  // bei erfolgreichen Löschen wird true zurückgegeben
  // Beispielaufruf
  // if DBase.DeleteCheck('Delete_Artikel(124)','Der Artikel kann nicht gelöscht werde, da er verwendet wird bei ') then begin
  // // bei erfolg etwas machen;
  // end;
  // ******************************************************************************
  // function TDBase.DeleteCheck(PProcedureName, PParam, PNotDelete:string): Boolean;
  // begin
  // Result := False;
  // if DataDesign.ShowMessageDlgSkin(RscCheckDelete1, MtConfirmation,
  // [MbYes, MbNo], 0)= MrYes then
  // begin
  // with IB_StoredProz do
  // begin
  // StoredProcName := PProcedureName;
  // IB_StoredProz.Prepare;
  // IB_StoredProz.Params[0].Value := PParam;
  //
  /// / SQL.Clear;
  /// / SQL.Add('Select * from ' + pProcedure );
  // if DBase.TransactionZEN.Connection.InTransaction then
  // begin
  /// / Execute;
  // ExecProc;
  // if FieldByName('o_table').AsString <> '' then
  // begin
  // DataDesign.ShowMessageSkin(PNotDelete + ' -> ' +
  // FieldByName('o_table').AsString);
  // Result := False;
  // end
  // else
  // Result := True;
  // end
  // else
  // begin
  // try
  // DBase.TransactionZEN.StartTransaction;
  // ExecProc;
  // if FieldByName('o_table').AsString <> '' then
  // begin
  // DataDesign.ShowMessageSkin(PNotDelete + ' -> ' +
  // FieldByName('o_table').AsString);
  // Result := False;
  // end
  // else
  // Result := True;
  // DBase.TransactionZEN.Commit;
  // except
  // on E: Exception do
  // begin
  // DBase.TransactionZEN.Rollback;
  // DataDesign.ShowMessageSkin(RscCheckDelete2 + PProcedureName + ' ' +
  // E.Message + #13#13);
  // end;
  // end;
  // end;
  // Unprepare;
  // Close;
  // end;
  // end
  // else
  // Result := False;
  // end;

  // ******************************************************************************
  // Datenbank verbinden
  // ******************************************************************************
function TDBase.DoConnectDatabase(pConnection: TFDConnection=nil): Boolean;
  function Reconnect: Boolean;
  begin
    Result := FALSE;
    try
      pConnection.Connected := False;
      pConnection.Connected := TRUE;
      RESULT := TRUE;
    except
    end;
  end;

var
  Cnt: Integer;
begin
  Result := FALSE;
  try
    if pConnection=nil then
      pConnection := ConnectionFelix;

    // 5 Versuche, da der erste oft scheitert
    Cnt := 0;
    while (Cnt < 5) and NOT Result do
    begin
      Result := Reconnect;
      inc(Cnt);
    end;
  except
  end;
end;


// ******************************************************************************
// Setzt den ODBC Pfad
// ******************************************************************************
procedure TDBase.SetODBCPath(PServer: string);
var
  Xx: TRegistry;
begin
  // exit;

  Xx := TRegistry.Create;
  try
    Xx.RootKey := HKey_Current_USer;
    Xx.OpenKey('\Software\ODBC\ODBC.INI\ODBC Data Sources', TRUE);
    Xx.WriteString('KasseODBC', 'Firebird/InterBase(r) driver');
    Xx.OpenKey('\Software\ODBC\ODBC.INI\KasseODBC', TRUE);
    Xx.WriteString('DbName', PServer);
    Xx.WriteString('AutoQuotedIdentifier', 'N');
    Xx.WriteString('CharacterSet', 'NONE');
    Xx.WriteString('Client', '');
    Xx.WriteString('Dialect', '1');
    Xx.WriteString('Driver', 'OdbcJdbc.dll');
    Xx.WriteString('JdbcDriver', 'IscDbc');
    Xx.WriteString('NoWait', 'Y');
    Xx.WriteString('Password',
      'ALIKAKIJAJIIAIIHAHIGAGIFAFIEAEIDADICACIBABIAAAIPAPIOAOINANIMAMILALIKAKIJAJIIAIIHIF');
    Xx.WriteString('QuotedIdentifier', 'Y');
    Xx.WriteString('ReadOnly', 'N');
    Xx.WriteString('Role', '');
    Xx.WriteString('SensitiveIdentifier', 'N');
    Xx.WriteString('User', 'SYSDBA');
    Xx.CloseKey;
  finally
    Freeandnil(Xx);
  end;
end;

// ******************************************************************************
// Setzen der Property
// ******************************************************************************
procedure TDBase.SetSectionName(const Value: string);
begin
  FSectionName := Value;
end;

// ******************************************************************************
// Setzen der Property
// ******************************************************************************
procedure TDBase.SetServerPath(const Value: string);
begin
  FServerPath := Value;
end;

// ******************************************************************************
// Setzen der Property
// ******************************************************************************
procedure TDBase.SetServerPathArchive(const Value: string);
begin
  FServerPathArchive := Value;
end;

procedure TDBase.SetSystemPassword(const Value: string);
begin
  FSystemPassword := Value;
end;

// ******************************************************************************
// Ermittelt die nächste ID für eine Tabelle
// ******************************************************************************
function TDBase.GetNextID(PTableName: string; PDataSet: TDataSet): Integer;
var
  AID: Integer;
begin
  Result := 0;
  with QueryGetNextID do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT GEN_ID(GEN_' + PTableName + ', 1) FROM RDB$DATABASE');
    Open;
    AID := FieldByName('Gen_ID').AsInteger;
    Close;
  end;
  with PDataSet do
  begin
    try
      FieldByName('Firma').AsInteger := Firma;
      FieldByName('ID').AsInteger := AID;
      Post;
    except
      FieldByName('ID').AsInteger := SetMaxID(PTableName, PDataSet);
      Post;
    end;
    Edit;
  end;
end;

// ******************************************************************************
// Setzt den Generator aud den nächsten Wert
// ******************************************************************************
function TDBase.SetMaxID(PTableName: string; PDataSet: TDataSet): Integer;
var
  AID: Integer;
begin
  with QueryGetNextID do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT MAX(ID) AS MAXID FROM ' + PTableName + '');
    Open;
    AID := FieldByName('MAXID').AsInteger + 1;
    Close;
    SQL.Clear;
    SQL.Add('SET GENERATOR GEN_' + PTableName + ' TO ' + IntToStr(AID));
    ExecSQL;
    Result := AID;
  end;
end;

// ******************************************************************************
//
// ******************************************************************************
procedure TDBase.SetMonitor(const Value: Integer);
begin
  FMonitor := Value;
end;

// ******************************************************************************
//
// ******************************************************************************
procedure TDBase.SetWaiterID(const Value: Integer);
begin
  FWaiterID := Value;
end;

function TDBase.SQLExecute(pSQL: String): boolean;
begin
  Result := True;
  with DSQLExecute do
  begin
    SQL.Clear;
    SQL.Text := pSQL;
    Prepare;
    if   ConnectionZEN.InTransaction then  // prüfung ob eine Transaktion lauft
    begin
      ExecSQL;
      UnPrepare;
    end
    else
    begin
      try
        ConnectionZEN.StartTransaction;
        ExecSQL;
        ConnectionZEN.Commit;
        UnPrepare;
      except on E: Exception do
        begin
          if ConnectionZEN.InTransaction then
            ConnectionZEN.Rollback;
          if not IsServer then
            ShowMessage(inttoStr(E.HelpContext) + rscSQLExecute1 +
                       E.Message + #13#13 + pSQL);
          Logger.Error('TDBase.SQLExecute', pSQL, NXLCAT_NONE, E);
          raise;
        end;
      end;
    end;
  end;
end;

// ******************************************************************************
// Holt den nächsthöheren Wert für ein Feld
// ******************************************************************************
function TDBase.GetNextNumber(PTableName, PFeld: string): Integer;
begin
  with QueryGetNextID do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Select MAX(' + PFeld + ') AS ' + PFeld + ' FROM ' + PTableName);
    Open;
    Result := FieldByName(PFeld).AsInteger + 1;
    Close;
  end;
end;

// ******************************************************************************
// Zaehlt die Anzahl Datensätze
// ******************************************************************************
function TDBase.GetCount(pSQL: string): Integer;
begin
  result := 0;
  with QueryShort do
  try
    Close;
    SQL.Clear;
    SQL.Add(pSQL);
    Open;
    Result := Fields[0].AsInteger;
    Close;
  except on E: Exception do
    WriteToLog('Error in GetCount: '+e.Message, TRUE);
  end;
end;

function TDBase.GetPrimaryKeyName(const pTableName: string): string;
begin
  Result := '';

  if trim(pTableName) = '' then
    exit;

  with QueryShort do
  try
    Close;
    SQL.Clear;
    SQL.Add(' select rdb$constraint_name from rdb$relation_constraints ');
    SQL.add('  where upper(rdb$relation_name)=upper('''+trim(pTableName)+''') ');
    SQL.Add('    and rdb$constraint_type=''PRIMARY KEY'' ');
    open;
    while not EOF do
    begin
      Result := Result + ',' + fieldbyname('rdb$constraint_name').AsString;
      next;
    end;
    if result <> '' then
      result := copy(Result, 2);
    Close;
  except on E: Exception do
    WriteToLog(Format('Primary-Key für %s existiert nicht.', [pTableName])
               +sLineBreak+e.Message, TRUE);
  end;
end;



// ******************************************************************************
// Erzeugen des Datenmoduls, setzen der Propertywerte
// ******************************************************************************
procedure TDBase.DataModuleCreate(Sender: TObject);
var
  AIni, AIni2: TIniFile;
  AStrList: TStringList;
  AfrmSelectDB: SelectDB.TfrmSelectDB;
  s, APath, aParam, aValue: string;
  I: Integer;
  ABuffer: array [0 .. MAX_PATH + 1] of Char;
  AWindowsDirectory: string;
  aConnectionParams: TStringList;
  aConnFelixParams: TStringList;
  aProgramName: string;

  function DoIni(pFile: TIniFile; pName: string;
    pType: string='string'; pDefault: string=''; pSection: string='DATABASE'): variant;
  begin
    if Not pFile.ValueExists(pSection, pName) and (pDefault <> '') then
      if lowercase(pType)='integer' then
        pFile.WriteInteger(pSection, pName, strtointdef(pDefault, 0))
      else
        pFile.WriteString(pSection, pName, pDefault);

    if lowercase(pType)='integer' then
      Result := pFile.ReadInteger(pSection, pName, strtointdef(pDefault, 0))
    else
      Result := pFile.ReadString(pSection, pName, pDefault);
  end;


begin
  FIsServer := False;
  GetWindowsDirectory(ABuffer, MAX_PATH + 1);
  AWindowsDirectory := StrPas(ABuffer);

  AStrList := TStringList.Create;
  ConnectPathList:= TStringlist.Create;
  FisErrorFormShow := False;
  FAnzahl := 0;

  Firma := 1;
  KasseID := 0;
  WaiterID := 0;
  Monitor := 0;
  DFMVerzeichnis := '';
  ReservationSetup := '';
  LogClientName := '';
  LogPath := '';
  FReconnect := 0;
  FConnected := False;
             { TODO -o geza : ini Datei ändern }
  APath := 'Kasse.ini';
  i := 0;
  while (i < 6) and NOT Fileexists(ExpandFileName(ExtractFilePath(ParamStr(0)) + APath)) do
  begin
    APath := '..\' + APath;
    inc(i);
  end;

  if not Fileexists(ExpandFileName(ExtractFilePath(ParamStr(0)) + APath)) then
  begin
    ShowMessage(StrNoKasseiniFileFo);
    Application.Terminate;
    exit;
  end;

  // Parameter einlesen
  if ParamCount >= 1 then
  begin
    // möglicherweise sind die parameter auf 1 anders gesetzt
    for I := 1 to ParamCount do
    try
      aParam := UPPERCASE(Copy(ParamStr(I), 1, Pos('=', ParamStr(I)) -1));
      aValue := trim(Copy(ParamStr(I), Pos('=', ParamStr(I)) + 1, Length(ParamStr(I))));
      if aParam = 'KASSEID' then
        FKasseID := StrToInt(aValue)
      else if aParam = 'KASSELOCALID' then
        FKasseLocalID := StrToInt(aValue)
      else if aParam = 'SECTIONNAME' then
        SectionName := aValue
      else if aParam = 'MONITOR' then
        Monitor := StrToInt(aValue)
      else if aParam = 'DFMDIRECTORY' then
        DFMVerzeichnis := aValue
      else if aParam = 'WAITERID' then
        WaiterID := StrToInt(aValue)
      else if aParam = 'RESERVATIONSETUP' then
        ReservationSetup := aValue;
    except
    end;
  end;

//  // Auswahl der passenden Section in der INI-Datei
//  s := AWindowsDirectory + '\System32\Kasse_local.ini';
//  if (SectionName = '') and (Fileexists(s)) then
//  begin
//    AIni2 := TIniFile.Create(s);
//    try
//      KasseID := DoIni(AIni2, 'KasseID', 'integer');
//      SectionName := DoIni(AIni2, 'SectionName');
//      Monitor := DoIni(AIni2, 'Monitor', 'integer');
//      DFMVerzeichnis := DoIni(AIni2, 'DFMDirectory');
//    finally
//      AIni2.Free;
//    end
//  end
//  else
  begin
    AIni := TIniFile.Create(ExpandFileName(ExtractFilePath(ParamStr(0)) + APath));
    try
      AIni.ReadSections(AStrList);

      // unit tests for printerpackage and zenserver
      aProgramName := LowerCase(ExtractFileName(ParamStr(0)));
      if pos('.exe', aProgramName) = (Length(aProgramName)-3) then
        aProgramName := Copy(aProgramName, 1, Length(aProgramName)-4);

      // section name for unit tests
      if AStrList.IndexOf(aProgramName) <> -1 then
        SectionName := aProgramName
      else  // section name not found
      if AStrList.IndexOf(SectionName) = -1 then
        if AStrList.Count = 1 then  // take the only one
          SectionName := AStrList.Strings[0]
        else
        begin
          for var SName in AStrList do
          begin
            ServerPath := DoIni(AIni, 'ServerPath', 'string','', SectionName);
          end;
        end;

      // Daten aus der INI-Datei auslesen
      if SectionName > '' then
      begin


        FiskaltrustPath := DoIni(AIni, 'FiskaltrustPath', 'string', '', SectionName);
        ServerPathArchive := DoIni(AIni, 'ServerPathArchive', 'string',
          Copy(ServerPath, 1, Length(ServerPath) - 4) + 'Archiv' + Copy(ServerPath, Length(ServerPath)-3), SectionName);
        //FelixPath := DoIni(AIni, 'FelixPath', 'string', '', SectionName);
        DebugModus := DoIni(AIni, 'DebugModus', 'integer', '0', SectionName);
        SystemPassword := DoIni(AIni, 'SystemPassword', 'string', '', SectionName);
        if SystemPassword = '' then SystemPassword := '7410';
        // properties for code site logging
        LogPath := DoIni(AIni, 'LogPath', 'string', '', SectionName);
        LogSize := DoIni(AIni, 'LogSize', 'integer', '2048', SectionName);
        LogParts := DoIni(AIni, 'LogParts', 'integer', '5120', SectionName);
        // properties for nxLogging  (see also nxLogging.initializeFileLogging!)
        LogClientName := DoIni(AIni, 'LogClientName', 'string', '', SectionName);
        LogViewer := DoIni(AIni, 'LogViewer', 'integer', '0', SectionName);
        LogFileServer := DoIni(AIni, 'LogFileServer', 'string', '', SectionName);
        if DFMVerzeichnis = '' then
          DFMVerzeichnis := DoIni(AIni, 'DFMDirectory', 'string', '', SectionName);

      end;
    finally
      AIni.Free;
    end;
  end;

  aConnFelixParams:= TStringList.Create;
 // aConnectionParams := TStringList.Create;
  try
    try
//      aConnectionParams.Add('DriverID=FB');
//      aConnectionParams.Add('Protocol=Local');
//      aConnectionParams.Add('SQLDialect=1');
//      aConnectionParams.Add('Pooled=True');
//      aConnectionParams.Add('Database=' + ServerPath);
//      aConnectionParams.Add('User_Name=SYSDBA');
//      aConnectionParams.Add('Password=x');
//      ConnectionManager.AddConnectionDef('ConnectionZEN', 'FB', aConnectionParams);
      aConnFelixParams.Clear;
      aConnFelixParams.Add('DriverID=FB');
      aConnFelixParams.Add('Protocol=Local');
      aConnFelixParams.Add('SQLDialect=3');
      aConnFelixParams.Add('Pooled=True');
      aConnFelixParams.Add('Database=' + ServerPath);
      aConnFelixParams.Add('User_Name=SYSDBA');
      aConnFelixParams.Add('Password=x');

      ConnectionManager.AddConnectionDef('ConnectionFelix', 'FB', aConnFelixParams);
      ConnectionManager.Active := True;

      ConnectionFelix.Connected := False;
      ConnectionFelix.Params.Values['Database'] := ServerPath;
      // connect to database
      DoConnectDatabase(ConnectionFelix);
//      ConnectionFelix.Params.Values['Firma1'] := FelixPath;
//      DoConnectDatabase(ConnectionFelix);

//      ConnectionFelix.Connected := False;
//      // ConnectionZEN.Connect;
//      SetODBCPath(ConnectionZEN.Params.Values['Firma1']);

     // TableDiverses.Open;
    except on E: Exception do
      begin
        ShowMessage(RscStrDieVerbindung + #13#13 + RscStrBitte +
          #13 + RscGetGeneratorID1 + E.Message);
        serverPath := '';
        Application.Terminate;
        exit;
      end
    end;
  finally
    AStrList.Free;
  end;

  // IB_Monitor.Enabled :=(DebugModus = 3);

  // ##################################
  // ##  initialize standard logger  ##
  // ##################################
  if trim(LogPath)='' then
    LogPath := ExtractFilePath(ParamStr(0))+'logs';
  ForceDirectories(LogPath);
  nxLogging.Logger.initializeFileLogging(ExtractFileName(ParamStr(0)), // name of application
    LogPath+'\', // path for log files   // 24.09.2018 KL: #20588: backslash was missing
    'ZEN'); // prefix for log files
  Logger.info('TDBase.DataModuleCreate', 'Logger started at ' + LogPath);

  // prüft ob die Datenbank schon eine Kassennummer vergeben hat
  // als default wird ansonst Kasse 1 angelegt.
  // öffnen sollte jedes Programm selber da die Datenbank nicht überall verwendet wird.
//  try
//    QueryEinstell.ParamByName('KasseID').AsInteger := 1;
//    QueryEinstell.Open;
//    FDAS := False;
//    if CheckField('EINSTELL', 'DAS') then
//      FDAS := QueryEinstell.FieldByName('DAS').AsBoolean;
//    QueryEinstell.Close;
//    QueryKasse.Open;
//    if QueryKasse.Eof then
//    begin
//      ExecuteSQL('Insert Into Kasse (Firma,KasseID,Bezeichnung) Values (' +
//        IntToStr(Firma) + ',1,''Kasse 1'')', TRUE);
//    end;
//    QueryKasse.Close;
//  except
//    on E: Exception do
//      Logger.Error('TDBase.DataModuleCreate', 'Einstell or Kasse',
//        NXLCAT_NONE, E);
//  end;
//
//  try
//    QueryFirma.Open;
//    FFirmenname := QueryFirma.FieldByName('Firmenname').AsString;
//    // 06.03.2013 KL: Eurekalog-EMailSubject auch gleich setzen
////    if IsEurekaLogActive then
////      if pos(FFirmenname, CurrentEurekaLogOptions.EMailSubject) = 0 then
////        CurrentEurekaLogOptions.EMailSubject := CurrentEurekaLogOptions.EMailSubject + ' - ' + FFirmenname;
//  except
//    try
//      FFirmenname := '';
////      if IsEurekaLogActive then
////        if pos('Firmenname FEHLT', CurrentEurekaLogOptions.EMailSubject) = 0 then
////          CurrentEurekaLogOptions.EMailSubject := CurrentEurekaLogOptions.EMailSubject + ' - Firmenname FEHLT';
//    except
//    end
//  end;

end;

procedure TDBase.DataModuleDestroy(Sender: TObject);
begin
  ConnectionZEN.Connected := False;
end;

// ******************************************************************************
//
// ******************************************************************************

function TDBase.IsDebug: Boolean;
begin
  Result := False;
{$IFDEF DEBUG}
  if (DebugHook <> 0) then // just for debugging in the Delphi-IDE
    if (ParamStr(ParamCount) = 'debug') then // "debug" always as last parameter
      Result := TRUE;
{$ENDIF}
end;

procedure TDBase.LogParams;
var
  i: integer;
  s: string;
begin
  WriteToLog('Applikation: '+ParamStr(0), true);
  WriteToLog('Version: ' + GetMyApplicationVersion, true);
  if paramcount>0 then
  begin
    s := Format('%d Parameter:', [paramcount]);
    for i := 1 to ParamCount do
      s := s + ' ' + ParamStr(i);
    WriteToLog(s, true);
  end
  else
    WriteToLog('KEINE Parameter', true);
  WriteToLog('Datenbank: '+DBase.ServerPath, true);
  if trim(DBase.FelixPath)>'' then
    WriteToLog('Felix: '+DBase.FelixPath, true);
  WriteToLog('Logging (DebugModus='+inttostr(dbase.DebugModus)+'): '+DBase.LogPath, true);
end;

procedure TDBase.CopyQueryToClipboard(pQueryOrTable: TFDCustomQuery);
var i: Integer;
begin
  if isdebug then
  begin
    i := 0;
    while pQueryOrTable.Connection.InTransaction do
    begin
      inc(i);
      pQueryOrTable.Connection.Commit;
    end;
    for i := 0 to i - 1 do
      pQueryOrTable.Connection.StartTransaction;

    if pQueryOrTable.Filtered and (pQueryOrTable.Filter <> '') then
      CopyToClipboard(pQueryOrTable.sql.text + sLineBreak +sLineBreak
        + '-- and ( ' + pQueryOrTable.Filter + ' ) ')
    else
      CopyToClipboard(pQueryOrTable.sql.text);
  end;
end;

procedure TDBase.CopyToClipboard(pText: string);
begin
  if isdebug then
    if trim(pText)>'' then
      Clipboard.AsText := pText;
end;


procedure TDBase.CommitAllNestedTransactions(pConnection: TFDConnection = nil);
begin
if pConnection=nil then
    pConnection := ConnectionZEN;
  // 09.12.2019 KL: #24378 commit all transactions, even nested ones
  // to guarantee all data is saved and comitted to current moment
  while pConnection.InTransaction do
    pConnection.Commit;
end;

procedure TDBase.ConnectionZENAfterConnect(Sender: TObject);
begin
  FConnected := TRUE;
  FProgrammStart := False;
end;

procedure TDBase.ConnectionZENBeforeConnect(Sender: TObject);
begin
  FConnected := False;
  FProgrammStart := TRUE;
end;

procedure TDBase.ConnectionZENError(ASender, AInitiator: TObject;
  var AException: Exception);
begin
  Logger.Error('ConnectionZENError', AException.Message,
    NXLCAT_NONE, AException);
end;


// ******************************************************************************
//
// ******************************************************************************
procedure TDBase.TimerConnectTimer(Sender: TObject);
begin
  TimerConnect.Enabled := False;
  try
    ConnectionZEN.Connected := False;
  except
  end;
  try
    ConnectionZEN.Connected := TRUE;
    FReconnect := 0;
    // DataDesign.ShowMessageSkin(rscConnectionEstablished);
    if Assigned(FOnReconnect) then
      FOnReconnect(Self);
  except
  end;
  FConnected := TRUE;
end;

// ******************************************************************************
// SQL-Statement just for UNIT-Tests
// ******************************************************************************
// function TDBase.SQLUnitTest(PSQL:string): Integer;
// var
// ASQL:string;
// begin
// Result := 0;
// ASQL := UpperCase(Trim(PSQL));
// if Length(ASQL)= 0 then
// EXIT;
//
// // SQL-Statement ausführen und Anzahl betroffener Records zurückgeben
// with QueryShort do
// try
// Close;
// SQL.Clear;
// SQL.Add(ASQL);
// if Pos('SELECT', ASQL)= 1 then
// begin
// Open;
// Result := RecordCount;
// // kein Close, damit man die Daten weiterhin verwenden kann
// end
// else
// begin
// ExecSQL;
// Result := RowsAffected;
// Close;
// end;
// except
// end;
// end;

// ******************************************************************************
// Setzen der Property
// ******************************************************************************
procedure TDBase.SetFelixPath(const Value: string);
begin
  FFelixPath := Value;
end;

// ******************************************************************************
// Setzen der Property
// ******************************************************************************
procedure TDBase.SetFirma(const Value: Integer);
begin
  FFirma := Value;
end;

procedure TDBase.SetFiskaltrustPath(const Value: string);
begin
  FFiskaltrustPath := Value;
end;

// ******************************************************************************
// Setzen der Property
// ******************************************************************************
procedure TDBase.SetDebugModus(const Value: Integer);
begin
  FDebugModus := Value;
end;

// ******************************************************************************
//
// ******************************************************************************
procedure TDBase.SetDFMVerzeichnis(const Value: string);
begin
  FDFMVerzeichnis := Value;
end;

// ******************************************************************************
//
// ******************************************************************************
procedure TDBase.SetReservationSetup(const Value: string);
begin
  FReservationSetup := Value;
end;

// ******************************************************************************
// Allgemeines SQLExecute
// ******************************************************************************
// function TDBase.SQLExecute(PSQL:string): Boolean;
// begin
// Result := True;
// with IB_DSQLExecute do
// begin
// CommandText.Clear;
// CommandText.Text := PSQL;
// Prepare;
// if transactionZEN.Connection.InTransaction then
// // prüfung ob eine Transaktion lauft
// begin
// Execute;
// UnPrepare;
// end
// else
// begin
// try
// TransactionZEN.StartTransaction;
// Execute;
// UnPrepare;
// transactionZEN.CommitRetaining;
// except
// on E: Exception do
// begin
// transactionZEN.Rollback;
// DataDesign.ShowMessageSkin(InttoStr(E.HelpContext)+ RscSQLExecute1 +
// E.Message + #13#13 + PSQL);
// raise;
// Result := False;
// end;
// end;
// end;
// end;
// end;

// ******************************************************************************
//
// ******************************************************************************
function TDBase.AnsiUpperCaseFireBird(const pStr: String): String;
begin
  Result := pStr;

  // 15.07.2019 KL: #22960 this old code replaced by "AnsiUppercaseSQL"
  if trim(pStr)<>'' then
  begin
    // alle Buchstaben GROSS machen
    Result := AnsiUpperCase(Result);
    // UMLAUTE werden bei SQL-UPPER() nicht verändert, daher wieder KLEIN machen
    Result := AnsiReplaceText(Result,'Ä','ä');
    Result := AnsiReplaceText(Result,'Ö','ö');
    Result := AnsiReplaceText(Result,'Ü','ü');
    // Der ERSTE Buchstabe muss auch bei Umlauten groß sein!
    if length(Result) > 0 then
      Result[1] := AnsiUpperCase(Result[1])[1];
  end;
end;

function TDBase.AnsiUppercaseSQL(const pField, pStr: String): String;
begin
  // Achtung, in das zugehoerige Datenmodul die "FireDAC.Stan.ExprFuncs" unter "uses" hinzufuegen!
  Result := ' (UPPER(' + AnsiUppercaseUmlauteFirebird(pField)+') ' +
    'Like ''%'+Uppercase(AnsiUppercaseUmlaute(pStr))+'%'') ';
end;

function TDBase.AnsiUppercaseUmlaute(const pStr: string): string;
const
  Ersatz:  array[0..2] of string = ('Ä', 'Ö', 'Ü');
  Umlaute: array[0..2] of string = ('ä', 'ö', 'ü');
var
  i: integer;
begin
  result := pStr;
  for i := Low(Umlaute) to High(Umlaute) do
    result := AnsiReplaceStr(result, Umlaute[i], Ersatz[i]);
end;

function TDBase.AnsiUppercaseUmlauteFirebird(const pField: string): string;
const
  Ersatz:  array[0..2] of string = ('Ä', 'Ö', 'Ü');
  Umlaute: array[0..2] of string = ('ä', 'ö', 'ü');
var
  i: integer;
begin
  // Achtung, in das zugehoerige Datenmodul die "FireDAC.Stan.ExprFuncs" unter "uses" hinzufuegen!
  result := '';
  for i := Low(Umlaute) to High(Umlaute) do
    result := result + 'replace(';
  result := result + pfield;
  for i := Low(Umlaute) to High(Umlaute) do
    result := result + ','''+Umlaute[i]+''','''+Ersatz[i]+''')';
end;

procedure TDBase.ApplicationProcessMessages;
begin
  if FBusy = 0 then
    Application.ProcessMessages;
end;

procedure TDBase.ChangeToArchiv(PArchiv: Boolean);
begin
  try
    ConnectionZEN.Connected := False;
    if PArchiv then
      ConnectionZEN.Params.Values['Database'] := ServerPathArchive
    else
      ConnectionZEN.Params.Values['Database'] := ServerPath;

    ConnectionZEN.Connected := TRUE;
    SetODBCPath(ConnectionZEN.Params.Values['Database']);
    TableDiverses.Open;
  except
    on E: Exception do
    begin
      ShowMessage(RscStrDieVerbindung + #13#13 + RscStrBitte +
        #13 + RscGetGeneratorID1 + E.Message);
      Application.Terminate;
      exit;
    end;
  end;
end;

// ******************************************************************************
//
// ******************************************************************************
// function TDBase.CheckTablesFields(PTableName, PFieldName,
// PFieldTyp:string): Boolean;
// begin
// Result := TRUE;
// with IB_DSQLExecute do
// begin
// try
// CommandText.Clear;
// CommandText.Add('ALTER TABLE ' + PTableName + ' ADD ' + PFieldName + ' ' +
// PFieldTyp);
// try
// Execute;
// except
// Result := False;
// end;
// finally
// end;
// end;
// end;

// ******************************************************************************
// prüfen, ob Tabelle existiert
// ******************************************************************************
function TDBase.CheckTable(const PTableName: string): Boolean;
begin
  Result := False;

  if Trim(PTableName) = '' then
    Exit;

  with QueryShort do
    try
      Close;
      SQL.Clear;
      SQL.Add(' SELECT RDB$RELATION_NAME FROM RDB$RELATIONS ');
      SQL.Add('  WHERE RDB$RELATION_NAME = UPPER(''' + Trim(PTableName)
        + ''') ');
      Open;
      Result := RecordCount = 1;
      Close;
    except
      on E: Exception do
        Logger.Error('TDBase.CheckTable', PTableName, NXLCAT_NONE, E);
    end;
end;

// ******************************************************************************
// prüfen, ob Feld (Spalte) in Tabelle existiert
// ******************************************************************************
function TDBase.CheckConstraintName(const pConstraintName: string): Boolean;
begin
  Result := FALSE;

  if trim(pConstraintName) = '' then
    exit;

  with QueryShort do
  try
    Close;
    SQL.Clear;
    SQL.Add(' select RDB$INDEX_NAME from rdb$indices ');
    SQL.add('  where upper(rdb$index_name)=upper('''+trim(pConstraintName)+''') ');
    SQL.Add('    and (rdb$unique_flag is not NULL or rdb$foreign_key is not NULL) ');
    open;
    Result := Recordcount = 1;
    Close;
  except on E: Exception do
    Logger.Error('TDBase.CheckConstraintName', pConstraintName, NXLCAT_NONE, E);
  end;

end;

function TDBase.CheckField(const PTableName, PFieldName: string; PFieldSource: string=''): Boolean;
begin
  Result := False;

  if (Trim(PTableName) = '') or (Trim(PFieldName) = '') then
    Exit;

  if not CheckTable(Trim(PTableName)) then
    Exit;

  with QueryShort do
    try
      Close;
      SQL.Clear;
      SQL.Add(' SELECT RDB$FIELD_NAME FROM RDB$RELATION_FIELDS ');
      SQL.Add('  WHERE RDB$RELATION_NAME = UPPER(''' + Trim(PTableName) + ''') ');
      SQL.Add('    AND RDB$FIELD_NAME = UPPER(''' + Trim(PFieldName) + ''') ');
      if PFieldSource <> '' then
        SQL.Add('    AND RDB$FIELD_SOURCE = UPPER(''' + Trim(PFieldSource) + ''') ');
      Open;
      Result := RecordCount = 1;
      Close;
    except
      on E: Exception do
        Logger.Error('TDBase.CheckField', trim(PTableName + '.' + PFieldName + ' ' + PFieldSource),
          NXLCAT_NONE, E);
    end;
end;

function TDBase.CheckGeneratorName(const pGeneratorName: string): Boolean;
begin
  Result := FALSE;

  if trim(pGeneratorName) = '' then
    exit;

  with QueryShort do
  try
    Close;
    SQL.Clear;
    SQL.Add(' select RDB$GENERATOR_NAME from rdb$generators ');
    SQL.Add('  where upper(rdb$generator_name)=upper('''+trim(pGeneratorName)+''') ');
    open;
    Result := Recordcount = 1;
    Close;
  except on E: Exception do
    Logger.Error('TDBase.CheckGeneratorName', pGeneratorName, NXLCAT_NONE, E);
  end;
end;

// ******************************************************************************
// prüfen, ob Index existiert
// ******************************************************************************
function TDBase.CheckIndexName(const PIndexName: string): Boolean;
begin
  Result := False;

  if Trim(PIndexName) = '' then
    Exit;

  with QueryShort do
    try
      Close;
      SQL.Clear;
      SQL.Add(' select distinct rdb$index_name from rdb$indices ');
      SQL.Add('  where (substring(rdb$index_name from 1 for 3) not in (''UNQ'', ''RDB'')) ');
      SQL.Add('    and (UPPER(rdb$index_name)=UPPER('''+trim(PIndexName)+''')) ');
      Open;
      Result := RecordCount = 1;
      Close;
    except
      on E: Exception do
        Logger.Error('TDBase.CheckIndexName', PIndexName, NXLCAT_NONE, E);
    end;
end;

function TDBase.CheckProcedureName(const pProcedureName: string): Boolean;
begin
  Result := FALSE;

  if trim(pProcedureName) = '' then
    exit;

  with QueryShort do
  try
    Close;
    SQL.Clear;
    SQL.Add(' select RDB$PROCEDURE_NAME from rdb$procedures ');
    SQL.Add('  where upper(rdb$procedure_name)=upper('''+trim(pProcedureName)+''') ');
    open;
    Result := Recordcount = 1;
    Close;
  except on E: Exception do
    Logger.Error('TDBase.CheckProcedureName', pProcedureName, NXLCAT_NONE, E);
  end;
end;

// ******************************************************************************
// prüfen, ob Trigger in Tabelle existiert
// ******************************************************************************
function TDBase.CheckTrigger(const PTableName, PTriggerSource: string;
  PTriggerType: Integer; out OTriggerName: string;
  out OSequence: Integer): Boolean;

  function Raw(PSource: string): string;
  var
    I: Integer;
  begin
    Result := '';
    for I := 1 to Length(PSource) do
      if LowerCase(PSource)[I] in ['a' .. 'z', '0' .. '9', '(', ')', '*', ':',
        ',', ';'] then
        Result := Result + LowerCase(PSource[I]);
  end;

begin
  Result := False;
  OSequence := 0;
  OTriggerName := '';

  if (Trim(PTableName) = '') or (Trim(PTriggerSource) = '') or
    (not PTriggerType in [1 .. 6, 17, 18, 25 .. 28, 113, 114]) then
    Exit;

  if not CheckTable(Trim(PTableName)) then
    Exit;

  with QueryShort do
    try
      Close;
      SQL.Clear;
      SQL.Add(' SELECT RDB$TRIGGER_SEQUENCE as SEQUENCE, RDB$TRIGGER_NAME as TRIGGERNAME, RDB$TRIGGER_SOURCE as SOURCE ');
      SQL.Add(' FROM RDB$TRIGGERS WHERE RDB$SYSTEM_FLAG=0 ');
      SQL.Add(' AND UPPER(RDB$RELATION_NAME) = UPPER(''' + Trim(PTableName)
        + ''') ');
      SQL.Add(' AND RDB$TRIGGER_TYPE = ' + IntToStr(PTriggerType));
      Open;
      while not Eof do
      begin
        if (Raw(FieldByName('SOURCE').AsString) = Raw(PTriggerSource)) then
        begin
          Result := TRUE;
          OSequence := FieldByName('SEQUENCE').AsInteger;
          OTriggerName := FieldByName('TRIGGERNAME').AsString;
          BREAK;
        end;
        Next;
      end;
      Close;
    except
      on E: Exception do
        Logger.Error('TDBase.CheckTrigger', PTableName + '/' +
          IntToStr(PTriggerType), NXLCAT_NONE, E);
    end;
end;

function TDBase.CheckTriggerName(const PTriggerName: string): Boolean;
begin
  Result := False;

  if (Trim(PTriggerName) = '') then
    Exit;

  with QueryShort do
    try
      Close;
      SQL.Clear;
      SQL.Add(' SELECT RDB$TRIGGER_NAME ');
      SQL.Add(' FROM RDB$TRIGGERS WHERE RDB$SYSTEM_FLAG=0 ');
      SQL.Add(' AND UPPER(RDB$TRIGGER_NAME) = UPPER(''' + Trim(PTriggerName)
        + ''') ');
      Open;
      Result := RecordCount = 1;
      Close;
    except
      on E: Exception do
        Logger.Error('TDBase.CheckTriggerName', PTriggerName, NXLCAT_NONE, E);
    end;
end;

function TDBase.CheckViewName(const pViewName: string): Boolean;
begin
  Result := FALSE;

  if trim(pViewName) = '' then
    exit;

  with QueryShort do
  try
    Close;
    SQL.Clear;
    SQL.Add(' select RDB$RELATION_NAME from rdb$relations ');
    SQL.Add('  where upper(rdb$relation_name)=upper('''+trim(pViewName)+''') ');
    SQL.add('    and (NOT rdb$view_blr is null) ');
    SQL.add('    and (rdb$system_flag is NULL or rdb$system_flag=0) ');
    open;
    Result := Recordcount = 1;
    Close;
  except on E: Exception do
    Logger.Error('TDBase.CheckViewName', pViewName, NXLCAT_NONE, E);
  end;
end;

// ******************************************************************************
// SQL-Command ausführen
// ******************************************************************************
function TDBase.ExecuteSQL(const PSqlCommand: string;
  PWriteToReplDB: Boolean = TRUE): Boolean;
var
  AMaxId: Integer;
  ASQL: string;
begin
  Result := False;

  if (Trim(PSqlCommand) = '') then
    Exit;

//  if (Pos('''', PSqlCommand) > 0) then
//  begin
//    ASQL := StringReplace(PSqlCommand, '''', '''''', [RfReplaceAll]);
//    if (Pos('''''''''''''''''', ASQL) > 0) then
//      ASQL := StringReplace(ASQL, '''''''''''''''''', '''''''''', [RfReplaceAll]);
//  end
//  else
    ASQL := PSqlCommand;

  with ScriptExecuteSQL do
    try
      SQLScripts.Clear;
      SQLScripts.Add;
      SQLScripts[0].SQL.Add(ASQL);
      ValidateAll;
      ExecuteAll;
      Result := TRUE;

      // 07.05.2014 KL: #7229: SQL in REPL_DB schreiben für Replikation!
      if PWriteToReplDB and CheckTable('Repl_Log') then
      begin
        QueryShort.Close;
        QueryShort.SQL.Clear;
        QueryShort.SQL.Add('SELECT MAX(ID) AS MAXID FROM Repl_DB');
        QueryShort.Open;
        AMaxId := QueryShort.FieldByName('MAXID').AsInteger + 1;
        QueryShort.Close;

        SQLScripts.Clear;
        SQLScripts.Add;
        SQLScripts[0].SQL.Add(' INSERT INTO Repl_DB (ID, Firma, SQLText, Typ) ');
        SQLScripts[0].SQL.Add(' VALUES  ('+inttostr(aMaxID)+', 1, ');
        ASQL := StringReplace(ASQL, '''', '''''', [RfReplaceAll]);
        while (Pos('''''''''''''''''', ASQL) > 0) do
          ASQL := StringReplace(ASQL, '''''''''''''''''', '''''''''', [RfReplaceAll]);
        SQLScripts[0].SQL.Add(''''+ASQL+'''');
        SQLScripts[0].SQL.Add(', ''DBaseMigrateData'') ');
        ValidateAll;
        ExecuteAll;
      end;

    except on E: Exception do
      if pos('already exists', lowercase(e.Message)) < 1 then
        Logger.Error('TDBase.ExecuteSQL', PSqlCommand, NXLCAT_NONE, E);
    end;
end;

// ******************************************************************************
// Schreibt einen String in die Log-Datei
// ******************************************************************************
procedure TDBase.WriteToLog(PLogStr: string; PWrite: Boolean = TRUE);
begin
  if nxLogging.Logger <> nil then
    if (DebugModus > 0) or pWrite then
      Logger.info(PLogStr);
end;

// ******************************************************************************
// Setzen der Property
// ******************************************************************************
procedure TDBase.SetLogPath(const Value: string);
begin
  FLogPath := Value;
end;

// ******************************************************************************
// Setzen der Property
// ******************************************************************************
procedure TDBase.SetLogViewer(const Value: Integer);
begin
  FLogViewer := Value;
end;

// ******************************************************************************
// Setzen der Property
// ******************************************************************************
procedure TDBase.SetLogClientName(const Value: string);
begin
  FLogClientName := Value;
end;

// ******************************************************************************
// Setzen der Property
// ******************************************************************************
procedure TDBase.SetLogFileServer(const Value: string);
begin
  FLogFileServer := Value;
end;

// ******************************************************************************
//
// ******************************************************************************
function TDBase.GetMaxID(PTableName, PFeld: string): Integer;
begin
  with QueryGetNextID do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT GEN_ID(GEN_' + PTableName + ', 1) FROM RDB$DATABASE');
    Open;
    Result := FieldByName('Gen_ID').AsInteger;
    Close;
  end;
end;

function TDBase.GetMyApplicationVersion: String;
var
  FileName: string;
  InfoSize, Wnd: DWORD;
  VerBuf: Pointer;
  FI: PVSFixedFileInfo;
  VerSize: DWORD;
begin
  Result := '';
  FileName := Application.ExeName;
  InfoSize := GetFileVersionInfoSize(PChar(FileName), Wnd);
  if InfoSize <> 0 then
  begin
    GetMem(VerBuf, InfoSize);
    try
      if GetFileVersionInfo(PChar(FileName), Wnd, InfoSize, VerBuf) then
        if VerQueryValue(VerBuf, '\', Pointer(FI), VerSize) then
        begin
          Result := '  ' + IntToStr(FI.dwFileVersionMS shr 16);
          Result := Result + '.' + IntToStr((FI.dwFileVersionMS shl 16) shr 16);
          Result := Result + '.' + IntToStr(FI.dwFileVersionLS shr 16);
          Result := Result + '.' + IntToStr((FI.dwFileVersionLS shl 16) shr 16);
        end;
    finally
      FreeMem(VerBuf);
    end;
  end;
end;

// ******************************************************************************
// bei vielen SQL Anweisungen das Blinken ausschalten
// ******************************************************************************
procedure TDBase.CursorON;
begin
  if not DBase.Busy then
    Screen.Cursor := CrHourGlass;
end;

// ******************************************************************************
// normale Cursor wieder einschalten
// ******************************************************************************
procedure TDBase.CursorOFF;
begin
  if not DBase.Busy then
    Screen.Cursor := CrDefault;
end;

// ******************************************************************************
// Liest die nummer aus dem Generator und verändert
// aInc = 0 Generator Wert bleibt gleich
// aInc > 0 Generator Wert wird erhöht
// ******************************************************************************
function TDBase.GetGeneratorID(PGenerator: string; PInc: Integer): Integer;
begin
  Result := 0;
  with QueryShort do
  begin
    QueryShort.Close;
    SQL.Clear;
    if PInc = 0 then
      SQL.Add('Select Gen_ID(' + PGenerator + ',0) as Gen_ID from RDB$database')
    else
      SQL.Add('Select Gen_ID(' + PGenerator + ',' + IntToStr(PInc) +
        ') as Gen_ID from RDB$database');
  end;
  if ConnectionZEN.InTransaction then
  begin
    QueryShort.Open;
    Result := QueryShort.FieldByName('Gen_ID').AsInteger;
    QueryShort.Close;
  end
  else
  begin
    try
      ConnectionZEN.StartTransaction;
      QueryShort.Open;
      Result := QueryShort.FieldByName('Gen_ID').AsInteger;
      QueryShort.Close;
      ConnectionZEN.Commit;
    except
      on E: Exception do
      begin
        if ConnectionZEN.InTransaction then // 25.02.2015 KL: #8928
          ConnectionZEN.Rollback;
        if not IsServer then
          ShowMessage(RscGetGeneratorID1 + E.Message + #13 + #13);
      end;
    end;
  end;
  QueryShort.Close;
end;

function TDBase.GetKasseID: Integer;
begin
  if FKasseID = 0 then
    Result := 1
  else
    Result := FKasseID;

end;

function TDBase.GetKasseLocalID: Integer;
begin
  if FKasseLocalID = 0 then
    Result := KasseID
  else
    Result := FKasseLocalID;
end;

// ******************************************************************************
// erhöt den Generator manuel um 1,
// ohne Transaktion sollte immer eine ebene höher sein
// ******************************************************************************
function TDBase.SetGeneratorID(PGenerator: string): Integer;
begin
  with QueryShort do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Select Gen_ID(' + PGenerator + ',1) as Gen_ID from RDB$database');
    Open;
    Result := FieldByName('Gen_ID').AsInteger;
    Close;
  end;
end;

// ******************************************************************************
//
// ******************************************************************************
procedure TDBase.SetKasseID(const Value: Integer);
begin
  FKasseID := Value;
end;

procedure TDBase.SetKasseLocalID(const Value: Integer);
begin
  FKasseLocalID := Value;
end;

// ******************************************************************************
//
// ******************************************************************************
// procedure TDBase.ExecuteProzedure(PProz:string);
// begin
// IB_StoredProz.StoredProcName.Empty;
// IB_StoredProz.StoredProcName := PProz;
// if TransactionZEN.Connection.InTransaction then
// begin
// IB_StoredProz.ExecProc;
// end
// else
// begin
// try
// if not TransactionZEN.Connection.InTransaction then
// TransactionZEN.StartTransaction;
// IB_StoredProz.ExecProc;
// if TransactionZEN.Connection.InTransaction then
// // 25.02.2015 KL: #8928
// TransactionZEN.Commit;
// except
// on E: Exception do
// begin
// if TransactionZEN.Connection.InTransaction then
// // 25.02.2015 KL: #8928
// TransactionZEN.Rollback;
// DataDesign.ShowMessageSkin(E.Message + #13#13 + IB_StoredProz.StoredProcName);
// end;
// end;
// end;
// IB_StoredProz.StoredProcName.Empty;
// end;

// ******************************************************************************
// Cursor zur Sanduhr machen bzw. Standard-Mauszeiger
// ******************************************************************************
function TDBase.GetBusy: Boolean;
begin
  Result := (FBusy > 0) and (Screen.Cursor = CrHourGlass);
  if result then
    WriteToLog('Kasse ist beschäftigt...', true);
end;

procedure TDBase.SetBusy(const Value: Boolean);
begin
  if Value = TRUE then
  begin
    if FBusy > 0 then
      Inc(FBusy)
    else
      FBusy := 1;

    if Screen.Cursor <> CrHourGlass then
      Screen.Cursor := CrHourGlass;
//    if Screen.ActiveForm.Enabled then
//      Screen.ActiveForm.Enabled := false; // funkt. nicht, weil setfocus dann error bringt
  end
  else
  begin
    if FBusy > 0 then
      Dec(FBusy)
    else
      FBusy := 0;

    if (FBusy = 0) and (Screen.Cursor = CrHourGlass) then
      Screen.Cursor := CrDefault;
//    if not Screen.ActiveForm.Enabled then
//      Screen.ActiveForm.Enabled := true;
  end;
end;

//******************************************************************************
// allgemeine Datenmigration für alle Kassenprogramme
//******************************************************************************
procedure TDBase.MigrateData;
var
  i: integer;
  aScriptFile: string;

begin
  // 01.08.2013 KL: wichtig für WebUpdate in V8.8
  WriteToLog('--- Start GKT-Data-Migration ---', TRUE);

  // 24.07.2014 KL: CheckTabsDateHigher (übernommen aus Update 8.0->8.5)
  if NOT CheckField('EINSTELL', 'CheckTabsDateHigher') then
    ExecuteSQL(' ALTER TABLE EINSTELL ADD CheckTabsDateHigher KBOOLEAN');
  if CheckField('EINSTELL', 'CheckTabsDateHigher') then
    ExecuteSQL(' UPDATE EINSTELL SET CheckTabsDateHigher = ''T'' WHERE CheckTabsDateHigher is null ', FALSE);

  // 06.03.2014 KL: es kommt des Öfteren vor dass das Feld fehlt (wird aber in Datenanlage verwendet!)
  if NOT CheckField('LOKALDRUCKER', 'ChangeDruckerID') then
    ExecuteSQL(' ALTER TABLE LOKALDRUCKER ADD ChangeDruckerID KINTEGER');

  // 10.07.2014 KL: #7421: zusätzl. Auswahl für FastReport ermöglichen im TouchSetup
  if NOT CheckField('SCHLOSS_OPTIONEN', 'EinzelbonReportType') then
    ExecuteSQL(' ALTER TABLE SCHLOSS_OPTIONEN ADD EinzelBonReportType KINTEGER');
  if NOT CheckField('SCHLOSS_OPTIONEN', 'RechnungReportType') then
    ExecuteSQL(' ALTER TABLE SCHLOSS_OPTIONEN ADD RechnungReportType KINTEGER');
  if NOT CheckField('SCHLOSS_OPTIONEN', 'UmbuchungsbonReportType') then
    ExecuteSQL(' ALTER TABLE SCHLOSS_OPTIONEN ADD UmbuchungsbonReportType KINTEGER');
  if NOT CheckField('SCHLOSS_OPTIONEN', 'A4RechnungReportType') then
    ExecuteSQL(' ALTER TABLE SCHLOSS_OPTIONEN ADD A4RechnungReportType KINTEGER');
  if NOT CheckField('SCHLOSS_OPTIONEN', 'KassierbonReportType') then
    ExecuteSQL(' ALTER TABLE SCHLOSS_OPTIONEN ADD KassierbonReportType KINTEGER');
  if NOT CheckField('SCHLOSS_OPTIONEN', 'LagerbonReportType') then
    ExecuteSQL(' ALTER TABLE SCHLOSS_OPTIONEN ADD LagerbonReportType KINTEGER');
  if NOT CheckField('SCHLOSS_OPTIONEN', 'StornobonReportType') then
    ExecuteSQL(' ALTER TABLE SCHLOSS_OPTIONEN ADD StornobonReportType KINTEGER');

  // 16.10.2014 KL: Weiche für ASSI32.DLL vs. ASSI128.DLL
  if NOT CheckField('SCHLOSS_OPTIONEN', 'ASSI128PORTS') then
    ExecuteSQL(' ALTER TABLE SCHLOSS_OPTIONEN ADD ASSI128PORTS KBOOLEAN');

  // 15.10.2014 KL: Beilagen fürs Rechnungsdisplay
  if CheckTable('RECHNUNGSDISPLAY') then
  begin
    if NOT CheckField('RECHNUNGSDISPLAY', 'LOOKBEILAGEN') then
      ExecuteSQL('ALTER TABLE RECHNUNGSDISPLAY ADD LOOKBEILAGEN VARCHAR(255)');
    if NOT CheckField('RECHNUNGSDISPLAY', 'TISCHKONTOID') then
      ExecuteSQL('ALTER TABLE RECHNUNGSDISPLAY ADD TISCHKONTOID INTEGER');
  end;

  // 21.10.2015 KL: Umbuchen von Tisch auf Felix-Zimmer
  if NOT CheckField('HOTELLOG', 'TERMIN_NR') then
    ExecuteSQL(' ALTER TABLE HOTELLOG ADD TERMIN_NR CHAR(20)');
  if NOT CheckField('HOTELLOG', 'PERS_NR') then
    ExecuteSQL(' ALTER TABLE HOTELLOG ADD PERS_NR CHAR(20)');
  if NOT CheckField('HOTELLOG', 'ZIMMER_NR') then
    ExecuteSQL(' ALTER TABLE HOTELLOG ADD ZIMMER_NR CHAR(20)');

  // 09.11.2015 KL: #10292: Bonnummer in JOURNAL hinzufügen
  if NOT CheckField('JOURNAL', 'BONNR') then
    ExecuteSQL(' ALTER TABLE JOURNAL ADD BONNR KINTEGER');
  if NOT CheckField('JOURNALARCHIV', 'BONNR') then
    ExecuteSQL(' ALTER TABLE JOURNALARCHIV ADD BONNR KINTEGER');

  // 29.01.2016 KL: #10566: RechnungsID wird benötigt beim Reaktivieren einer Rechnung
  if DBase.CheckTable('KUNDENRABATT') then
  begin
    if NOT DBase.CheckField('KUNDENRABATT', 'VERFALLDATUM') then
      DBase.ExecuteSQL(' ALTER TABLE KUNDENRABATT ADD VERFALLDATUM KDATE; ');
    if NOT DBase.CheckField('KUNDENRABATT', 'RECHNUNGSID') then
      DBase.ExecuteSQL(' ALTER TABLE KUNDENRABATT ADD RECHNUNGSID INTEGER; ');
  end;

  // 02.02.2016 KL: #10566: Kartennummer wird benötigt beim Reaktivieren einer Rechnung
  if DBase.CheckTable('RECHNUNGSZAHLWEG') then
  begin
    if NOT DBase.CheckField('RECHNUNGSZAHLWEG', 'KARTENNUMMER') then
      DBase.ExecuteSQL(' ALTER TABLE RECHNUNGSZAHLWEG ADD KARTENNUMMER INTEGER; ');
  end;
  if DBase.CheckTable('RECHNUNGSZAHLWEGARCHIV') then
  begin
    if NOT DBase.CheckField('RECHNUNGSZAHLWEGARCHIV', 'KARTENNUMMER') then
      DBase.ExecuteSQL(' ALTER TABLE RECHNUNGSZAHLWEGARCHIV ADD KARTENNUMMER INTEGER; ');
  end;

  // 29.04.2016 KL: #11867: Arrangementartikel in Prozent angeben
  for i := 2 to 10 do
    if dbase.CheckField('ARTIKEL', 'ARTIKELID'+inttostr(i)) then
    begin
      if not dbase.CheckField('ARTIKEL', 'ARTIKELPREISID'+inttostr(i)) then
        executeSQL(' ALTER TABLE ARTIKEL ADD ARTIKELPREISID'+inttostr(i)+' KFLOAT; ');
      if not dbase.CheckField('ARTIKEL', 'ARTIKELPROZENTID'+inttostr(i)) then
        executeSQL(' ALTER TABLE ARTIKEL ADD ARTIKELPROZENTID'+inttostr(i)+' KFLOAT; ');
    end;

  // 30.12.2016 KL: ohne diese neuen Felder für Fiskaltrust kann KassaServer.exe nicht starten!
  if NOT CheckField('EINSTELL', 'Fiskaltrust') then
    ExecuteSQL(' ALTER TABLE EINSTELL ADD Fiskaltrust KBOOLEAN');
  if NOT CheckField('EINSTELL', 'FiskalTrustURL') then
    ExecuteSQL(' ALTER TABLE EINSTELL ADD FiskalTrustURL VARCHAR(255)');
  if NOT CheckField('EINSTELL', 'CashBoxID') then
    ExecuteSQL(' ALTER TABLE EINSTELL ADD CashBoxID VARCHAR(255)');
  if NOT CheckField('EINSTELL', 'AccessToken') then
    ExecuteSQL(' ALTER TABLE EINSTELL ADD AccessToken VARCHAR(255)');


  // 20.02.2017 KL: #15710: WebUp.sql NICHT mehr ausführen (ist obsolete)
  // 25.08.2016 KL: #13159: falls das Script "WebUp.sql" existiert, ausführen und danach löschen
  aScriptFile := ExtractFilePath(ParamStr(0)) + 'WebUp.sql';
  if (lowercase(ExtractFileName(paramstr(0)))<>lowercase('Update.exe'))
  and (FileExists(aScriptFile)) then
  try
    SysUtils.DeleteFile(aScriptFile);
  except
  end;

  // 19.07.2017 KL: #17327 Boolean setzen falls Drucker QR-Code drucken kann
  if NOT DBase.CheckField('DRUCKERNAMEN', 'QRCode') then
    DBase.ExecuteSQL(' ALTER TABLE DRUCKERNAMEN ADD QRCode KBoolean; ');
  if NOT DBase.CheckField('DRUCKDEFINITION', 'QRCode') then
    DBase.ExecuteSQL(' ALTER TABLE DRUCKDEFINITION ADD QRCode KBoolean; ');

  // 31.08.2017 KL: #17830
  if NOT CheckField('DRUCKERNAMEN', 'QRType') then
    DBase.ExecuteSQL(' ALTER TABLE DRUCKERNAMEN ADD QRType KINTEGER');
  if CheckField('DRUCKERNAMEN', 'QRType') then
  begin
    DBase.ExecuteSQL(
    ' UPDATE DRUCKERNAMEN SET QRType = 1 WHERE QRType is null and QRCode = ''T'' ');
    DBase.ExecuteSQL(
    ' UPDATE DRUCKERNAMEN SET QRType = 0 WHERE QRType is null ');
  end;
  if NOT CheckField('DRUCKDEFINITION', 'QRType') then
    DBase.ExecuteSQL(' ALTER TABLE DRUCKDEFINITION ADD QRType KINTEGER');
  if CheckField('DRUCKDEFINITION', 'QRType') then
  begin
    DBase.ExecuteSQL(
    ' UPDATE DRUCKDEFINITION SET QRType = 1 WHERE QRType is null and QRCode = ''T'' ');
    DBase.ExecuteSQL(
    ' UPDATE DRUCKDEFINITION SET QRType = 0 WHERE QRType is null ');
  end;

  // 21.06.2018 KL: #19891: Index on FiskaltrustDifferenz-Program
  if NOT dbase.CheckIndexName('FT_RECEIPT_IDXRECREF') then
    DBase.ExecuteSQL(
      ' CREATE INDEX FT_RECEIPT_IDXRECREF ON FT_RECEIPT (RECEIPTREFERENCE) ');

  if NOT DBase.CheckTable('ZEN_DEVICEUSAGE') then
    DBase.ExecuteSQL(
    ' CREATE TABLE ZEN_DEVICEUSAGE ('+
    '  ID INTEGER NOT NULL, '+
    '  LOGIN_DATE KDATE, '+
    '  GUID KCHAR255, '+
    '  REPORTED_DATE  KDATE); ');

  // 30.07.2018 AI: #20345 FavoriteSorting
  if NOT CheckField('ARTIKEL', 'FavoriteSorting') then
    DBase.ExecuteSQL(' ALTER TABLE ARTIKEL ADD FavoriteSorting KINTEGER ');

  if NOT CheckField('EINSTELL', 'Spoolpath') then
    DBase.ExecuteSQL(' ALTER TABLE EINSTELL ADD Spoolpath VARCHAR(255) ');

  // 14.05.2019 KL: #22652 accesstoken hat gefehlt
  if NOT CheckField('EINSTELL', 'ACCESSTOKEN') then
    DBase.ExecuteSQL(' ALTER TABLE EINSTELL ADD ACCESSTOKEN VARCHAR(255) ');

  WriteToLog('--- End GKT-Data-Migration ---', TRUE);
end;


procedure TDBase.SetDefaulftConnection(PComponent: TComponent; pConnection: TFDConnection = nil);
var
  I: Integer;
begin
  if pConnection=nil then
    pConnection := ConnectionZEN;

  for I := 0 to PComponent.ComponentCount - 1 do
  begin
         if (PComponent.Components[I] is TFDTransaction) then
            (PComponent.Components[I] as TFDTransaction).Connection := pConnection
    else if (PComponent.Components[I] is TFDQuery) then
            (PComponent.Components[I] as TFDQuery).Connection := pConnection
    else if (PComponent.Components[I] is TFDTable) then
            (PComponent.Components[I] as TFDTable).Connection := pConnection
    else if (PComponent.Components[I] is TFDCommand) then
            (PComponent.Components[I] as TFDCommand).Connection := pConnection
    else if (PComponent.Components[I] is TFDScript) then
            (PComponent.Components[I] as TFDScript).Connection := pConnection
    else if (PComponent.Components[i] is TFDStoredProc) then
            (PComponent.Components[I] as TFDStoredProc).Connection := pConnection;
  end;
end;


function TDBase.GetFieldLength(const pTableName, pFieldName: string): integer;
begin
  result := 0;
  with QueryShort do
  try
    Close;
    SQL.Clear;
    SQL.Add(' select f.rdb$field_length as FLDLEN from rdb$relation_fields r ');
    SQL.Add(' join rdb$fields f on f.rdb$field_name=r.rdb$field_source ');
    SQL.Add(' where r.rdb$relation_name='''+UpperCase(pTableName)+''' ');
    SQL.Add('   and r.rdb$field_name='''+UpperCase(pFieldName)+''' ');
    Open;
    if NOT EOF then
      result := FieldByName('FLDLEN').AsInteger;
  except on E: Exception do
    Logger.Error('TDBase.GetFieldLength', pTableName+'.'+pFieldName, NXLCAT_NONE, E);
  end;
end;



end.
