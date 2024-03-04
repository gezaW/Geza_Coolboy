unit DMBase;

interface

uses
  SysUtils, Classes,
  // IB_Components,
  DB,
  // IBODataset, IB_Monitor,
  ExtCtrls, ADODB,
  // IB_Access,
  IdIPWatch, IdComponent,
  IdTCPConnection, IdTCPClient, IdExplicitTLSClientServerBase, IdMessageClient,
  IdSMTPBase, IdSMTP, IdBaseComponent, IdMessage,
  // IB_Process, IB_Script,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.VCLUI.Wait, FireDAC.Comp.Client, FireDAC.Comp.DataSet,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.ScriptCommands, FireDAC.Stan.Util, FireDAC.Comp.Script,
  FireDAC.Phys.FB, FireDAC.Phys.FBDef;

type
  TDBase = class(TDataModule)
    DSQueryKasse: TDataSource;
    IdMessage: TIdMessage;
    IdIPWatch: TIdIPWatch;
    IdSMTP: TIdSMTP;
    TimerConnect: TTimer;
    ConnectionZEN: TFDConnection;
    TransactionZEN: TFDTransaction;
    TableFirma: TFDTable;
    TableDiverses: TFDTable;
    QueryGetNextID: TFDQuery;
    QueryShort: TFDQuery;
    QueryKasse: TFDQuery;
    QueryEinstell: TFDQuery;
    QuerySchlossOptionen: TFDQuery;
    ScriptExecuteSQL: TFDScript;
    DSQLExecute: TFDQuery;
    procedure TimerConnectTimer(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);
    procedure ConnectionZENBeforeConnect(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure ConnectionZENSoundExParse(Sender: TObject;
      const SourceStr: string; var ResultStr: string);
    procedure ConnectionZENError(ASender, AInitiator: TObject;
      var AException: Exception);
    procedure ConnectionZENAfterConnect(Sender: TObject);

  private
    // für "sauberes" Beenden von modalen Fenstern bei Abzug des Kellnerschlüssels
    // immer nur in Hauptfunktionen die "Sanduhr" setzen, nicht nochmal in den Unterfunktionen
    FBusy: Integer;

    FFirma, FDebugModus: Integer;
    FLogClientName: string;
    FServerPathArchive: string;
    FFelixPath: string;
    FLogPath: string;
    // FLogServer: string;
    FLogSize: Integer;
    FLogParts: Integer;
    // FReportPath:string;
    FServerPath: string;
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
    FAktion: string;

    procedure SetFirma(const Value: Integer);
    procedure SetDebugModus(const Value: Integer);
    procedure SetODBCPath(PServer: string);
    procedure SetLogPath(const Value: string);
    procedure SetLogClientName(const Value: string);
    procedure SetServerPath(const Value: string);
    procedure SetServerPathArchive(const Value: string);
    procedure SetFelixPath(const Value: string);
    // procedure SetReportPath(const Value:string);
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

    property Busy: Boolean read GetBusy write SetBusy;

    property SectionName: string read FSectionName write SetSectionName;
    property Firma: Integer read FFirma write SetFirma;
    // property ReportPath:string read FReportPath write SetReportPath;

    property DebugModus: Integer read FDebugModus write SetDebugModus;
    property LogPath: string read FLogPath write SetLogPath;
    property LogSize: Integer read FLogSize write FLogSize;
    property LogParts: Integer read FLogParts write FLogParts;

    // property LogServer: String read FLogServer write FLogServer;
    property ServerPath: string read FServerPath write SetServerPath;
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

    function GetGeneratorID(PGenerator: string; PInc: Integer): Integer;
    function SetGeneratorID(PGenerator: string): Integer;
    // function DeleteCheck(PProcedureName, PParam, PNotDelete:string): Boolean;
    function DoConnectDatabase: Boolean;
    function GetMaxID(PTableName, PFeld: string): Integer;
    // Get the next id from the generator
    function GetNextID(PTableName: string; PDataSet: TDataSet): Integer;
    function SetMaxID(PTableName: string; PDataSet: TDataSet): Integer;
    // get the next ID from MaxID by Table
    function GetNextNumber(PTableName, PFeld: string): Integer;
    // function SQLExecute(PSQL:string): Boolean;
    // if field in a Table then add a new field
    // function CheckTablesFields(PTableName, PFieldName,
    // PFieldTyp:string): Boolean;

    procedure CursorON;
    procedure CursorOFF;
    procedure WriteToLog(PLogStr: string; PWrite: Boolean = TRUE);
    // procedure ExecuteProzedure(PProz:string);
    procedure ChangeToArchiv(PArchiv: Boolean);
    function SendEmail(PString: string): Boolean;

    // 11.03.2014 KL: Daten-Migration in allen GKT-Programmen vereinheitlichen
    function CheckTable(const PTableName: string): Boolean;
    function CheckField(const PTableName, PFieldName: string): Boolean;
    function CheckTrigger(const PTableName, PTriggerSource: string;
      PTriggerType: Integer; out OTriggerName: string;
      out OSequence: Integer): Boolean;
    function CheckTriggerName(const PTriggerName: string): Boolean;
    function CheckIndexName(const PIndexName: string): Boolean;
    function ExecuteSQL(const PSqlCommand: string;
      PWriteToReplDB: Boolean = TRUE): Boolean;
    procedure MigrateData;

    // // 09.07.2014 KL: SQL-Statements für Unit-Tests
    // function SQLUnitTest(PSQL:string): Integer;

    // in D10 muss die IB_Connection immer neu zugeordnet werden, weil die IDE sie immer wieder "verliert"
    procedure SetDefaulftConnection(PComponent: TComponent);

    // 27.10.2016 KL: Debug-Modus nur zum testen in der IDE auf Starscreen
    function IsDebug: Boolean;

    function SQLExecute(pSQL:String):boolean;
  end;

var
  DBase: TDBase;

implementation

{$R *.dfm}

uses IniFiles, Forms, Dialogs,
//DMDesign,
Registry, Windows, Controls, SelectDB,  nxLogging; //  pGlobal,

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
function TDBase.DoConnectDatabase: Boolean;
  function Reconnect: Boolean;
  begin
    Result := TRUE;
    try
      ConnectionZEN.Connected := False;
      ConnectionZEN.Connected := TRUE;
    except
      Result := False;
    end;
  end;

var
  Cnt: Integer;
begin
  Result := TRUE;
  try
    // 5 Versuche, da der erste oft scheitert
    Cnt := 0;
    while (Cnt < 5) and not Reconnect do
    begin
    end;
  except
    Result := False;
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
// procedure TDBase.SetReportPath(const Value:string);
// begin
// FReportPath := Value;
// end;

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
    FieldByName('Firma').AsInteger := Firma;
    FieldByName('ID').AsInteger := AID;
    try
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
        UnPrepare;
        ConnectionZEN.CommitRetaining;
      except
        on E: Exception do
        begin
          ConnectionZEN.Rollback;
          ShowMessage(inttoStr(E.HelpContext) + rscSQLExecute1 +
                       E.Message + #13#13 + pSQL);

          Logger.Error('TDBase.SQLExecute', pSQL, NXLCAT_NONE, E);

          raise;
          Result := False;
        end;
      end;
    end;
  end;
end;

// ******************************************************************************
// Hohlt den nächsthöheren Wert für ein Feld
// ******************************************************************************
function TDBase.GetNextNumber(PTableName, PFeld: string): Integer;
begin
  with QueryGetNextID do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Select MAX(' + PFeld + ') AS ' + PFeld + ' FROM ' + PTableName);
    Open;
    Last;
    Result := FieldByName(PFeld).AsInteger + 1;
    Close;
  end;
end;

// ******************************************************************************
// Erzeugen des Datenmoduls, setzen der Propertywerte
// ******************************************************************************
procedure TDBase.DataModuleCreate(Sender: TObject);
var
  AIni, AIni2: TIniFile;
  AStrList: TStringList;
  AfrmSelectDB: TfrmSelectDB;
  APath, AParam: string;
  I: Integer;
  ABuffer: array [0 .. MAX_PATH + 1] of Char;
  AWindowsDirectory: string;
begin

  // Pgl := Tpglobal.Create;
  GetWindowsDirectory(ABuffer, MAX_PATH + 1);
  AWindowsDirectory := StrPas(ABuffer);

  AStrList := TStringList.Create;
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

  APath := 'Kasse.ini';
  for I := 1 to 6 do
    if not Fileexists(ExpandFileName(ExtractFilePath(ParamStr(0)) + APath)) then
      APath := '..\' + APath;

  if not Fileexists(ExpandFileName(ExtractFilePath(ParamStr(0)) + APath)) then
  begin
    ShowMessage(StrNoKasseiniFileFo);
    Exit;
  end;
  AIni := TIniFile.Create(ExpandFileName(ExtractFilePath(ParamStr(0)) + APath));

  // Parameter einlesen
  if ParamCount >= 1 then
  begin
    // möglicherweise sind die parameter auf 1 anders gesetzt
    try
      for I := 1 to ParamCount do
      begin
        AParam := Copy(ParamStr(I), Pos('=', ParamStr(I)) + 1,
          Length(ParamStr(I)));
        if Pos('KASSEID=', UpperCase(ParamStr(I))) > 0 then
          FKasseID := StrToInt(AParam)
        else if Pos('KASSELOCALID=', UpperCase(ParamStr(I))) > 0 then
          FKasseLocalID := StrToInt(AParam)
        else if Pos('SECTIONNAME=', UpperCase(ParamStr(I))) > 0 then
          SectionName := AParam
        else if Pos('MONITOR=', UpperCase(ParamStr(I))) > 0 then
          Monitor := StrToInt(AParam)
        else if Pos('DFMDIRECTORY=', UpperCase(ParamStr(I))) > 0 then
          DFMVerzeichnis := AParam
        else if Pos('WAITERID=', UpperCase(ParamStr(I))) > 0 then
          WaiterID := StrToInt(AParam)
        else if Pos('RESERVATIONSETUP=', UpperCase(ParamStr(I))) > 0 then
          ReservationSetup := AParam;
      end;
    except
    end;
  end;

  // Auswahl der passenden Section in der INI-Datei
  if SectionName = '' then
  begin
    AIni2 := TIniFile.Create(AWindowsDirectory + '\System32\Kasse_local.ini');
    if Fileexists(AIni2.FileName) then
    begin
      KasseID := StrToInt(AIni2.ReadString('DataBase', 'KasseID', '0'));
      SectionName := AIni2.ReadString('DataBase', 'Sectionname', '');
      Monitor := StrToInt(AIni2.ReadString('DataBase', 'Monitor', '0'));;
      DFMVerzeichnis := AIni2.ReadString('DataBase', 'DFMDirectory', '');
    end
    else
    begin
      AIni.ReadSections(AStrList);
      if AStrList.Count > 1 then
      begin
        AfrmSelectDB := TfrmSelectDB.Create(Self);
        AfrmSelectDB.ComboBoxDB.Items := AStrList;
        AfrmSelectDB.ShowModal;
      end
      else
        SectionName := AStrList.Strings[0];
    end;
    AIni2.Free;
  end;

  // Daten aus der INI-Datei auslesen
  try
    ServerPath := AIni.ReadString(SectionName, 'ServerPath', '');
    ServerPathArchive := AIni.ReadString(SectionName, 'ServerPathArchive',
      Copy(ServerPath, 1, Length(ServerPath) - 4) + 'Archiv.gdb');
    FelixPath := AIni.ReadString(SectionName, 'FelixPath', '');
    LogPath := AIni.ReadString(SectionName, 'LogPath', '');
    LogClientName := AIni.ReadString(SectionName, 'LogClientName', '');
    LogViewer := AIni.ReadInteger(SectionName, 'LogViewer', 0);
    LogClientName := AIni.ReadString(SectionName, 'LogClientName', '');
    LogFileServer := AIni.ReadString(SectionName, 'LogFileServer', '');
    DebugModus := AIni.ReadInteger(SectionName, 'DebugModus', 0);
    SystemPassword := AIni.ReadString(SectionName, 'Systempassword', '7410');

    ConnectionZEN.Params.Values['Database'] := ServerPath;
    // ConnectionZEN.Connect;
    SetODBCPath(ServerPath);

  except
    on E: Exception do
    begin
      ShowMessage(RscStrDieVerbindung + #13#13 + RscStrBitte +
        #13 + RscGetGeneratorID1 + E.Message);
      // Application.Terminate;
    end
  end;
  AStrList.Free;
  AIni.Free;
  // IB_Monitor.Enabled :=(DebugModus = 3);

  // ##################################
  // ##  initialize standard logger  ##
  // ##################################
  if trim(LogPath)='' then
    LogPath := ExtractFilePath(ParamStr(0))+'logs';
  ForceDirectories(LogPath);
  nxLogging.Logger.initializeFileLogging(ExtractFileName(ParamStr(0)),
    // name of application
    LogPath, // path for log files
    'ZEN'); // prefix for log files
  Logger.info('TDBase.DataModuleCreate', 'Logger started at ' + LogPath);

  // connect to database
  ConnectionZEN.Connected := TRUE;

  TableDiverses.Open;

  // prüft ob die Datenbank schon eine Kassennummer vergeben hat
  // als default wird ansonst Kasse 1 angelegt.
  // öffnen sollte jedes Programm selber da die Datenbank nicht überall verwendet wird.
  try
    QueryEinstell.ParamByName('KasseID').AsInteger := 1;
    QueryEinstell.Open;
    FDAS := QueryEinstell.FieldByName('DAS').AsBoolean;
    QueryEinstell.Close;
    QueryKasse.Open;
    if QueryKasse.Eof then
    begin
      ExecuteSQL('Insert Into Kasse (Firma,KasseID,Bezeichnung) Values (' +
        IntToStr(Firma) + ',1,''Kasse 1'')', TRUE);
    end;
    QueryKasse.Close;
  except
    on E: Exception do
      Logger.Error('TDBase.DataModuleCreate', 'Einstell or Kasse',
        NXLCAT_NONE, E);
  end;

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
  if (DebugHook <> 0) then // nur zum Testen in der Delphi-IDE
    if (ParamStr(ParamCount) = 'debug') then // immer als LETZTER Parameter
      if Pos(LowerCase('C:\SVN\'), LowerCase(ExtractFileDir(ParamStr(0)))) = 1
      then // nur wenn auf StarScreen im SVN-Ordner
        Result := TRUE;
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
  Logger.Error('ConnectionZENError', 'Connection to database failed',
    NXLCAT_NONE, AException);
end;

// procedure TDBas.ConnectionZENError(ASender, AInitiator: TObject;
// var AException: Exception);
// var aStr: String;
// i: integer;
// begin
/// / ISC ERROR CODE:335544721  Netwerkrequest
/// / ISC ERROR CODE:335544336  Deadlock
//
/// /  RaiseException := TRUE;
/// /  Application.ProcessMessages;
/// /  if (errcode = 335544721) then  // Unable to complete network request to host "....". Error writing data to the connection.
/// /  begin
/// /    if not FConnected then
/// /    begin
/// /      if FReconnect = 0 then
/// /      begin
/// /        DataDesign.ShowMessageSkin(rscStrVerbindungZurDaten + #13 +
/// /                    rscStrVersucheVerbindung+#13+
/// /                    'Warencontrol wird nach Netzwerkausfall beendet');
/// /        Application.Terminate;
/// /        HALT;
/// /        TimerConnect.Enabled := TRUE;
/// /        FReconnect := 10000;
/// /        RaiseException := FALSE;
/// /      end else
/// /      begin
/// /        Dec(FReconnect);
/// /        RaiseException := FALSE;
/// /      end;
/// /    end else
/// /    begin
/// /      RaiseException := FALSE;
/// /      FConnected := FALSE;
/// /   end;
/// /  end;
//
//
/// /
/// /  aStr := 'error '+inttostr(errcode)+' '+inttostr(sqlcode);
/// /  for i := 1 to ErrorMessage.Count do
/// /    aStr := aStr + #13+errormessage[i-1];
/// /  for i := 1 to  errorcodes.Count do
/// /    aStr := aStr + #13+errorcodes[i-1];
/// /  for i := 1 to  sqlmessage.Count do
/// /    aStr := aStr + #13+sqlmessage[i-1];
/// /  for i := 1 to  sql.Count do
/// /    aStr := aStr + #13+sql[i-1];
/// /  WriteToLog(aStr, TRUE);
/// /
/// /  exit;
//
/// / beim Programmstart soll er schon die fehler zeigen
/// / if not fProgrammStart and (errcode <> 335544351) then begin
// if (errcode <> 335544351) then begin
// aStr := 'error code ='+inttostr(errcode)+#13+inttostr(sqlcode);
// for i := 1 to ErrorMessage.Count do
// aStr := aStr + #13+errormessage[i-1];
// for i := 1 to  errorcodes.Count do
// aStr := aStr + #13+errorcodes[i-1];
// for i := 1 to  sqlmessage.Count do
// aStr := aStr + #13+sqlmessage[i-1];
// for i := 1 to  sql.Count do
// aStr := aStr + #13+sql[i-1];
// WriteToLog(aStr, TRUE);
// end;
//
/// / neu eingefügt 19.09.2016
// {
// RaiseException := TRUE;
// Application.ProcessMessages;
// if (errcode = 335544721) then  // Unable to complete network request to host "....". Error writing data to the connection.
// begin
// if not FConnected then
// begin
// if FReconnect = 0 then
// begin
// DataDesign.ShowMessageSkin(rscStrVerbindungZurDaten + #13 +
// rscStrVersucheVerbindung+#13+
// 'Warencontrol wird nach Netzwerkausfall beendet');
// Application.Terminate;
// HALT;
// TimerConnect.Enabled := TRUE;
// FReconnect := 10000;
// RaiseException := FALSE;
// end else
// begin
// Dec(FReconnect);
// RaiseException := FALSE;
// end;
// end else
// begin
// RaiseException := FALSE;
// FConnected := FALSE;
// end;
// end;
//
// }
/// ///////////// herausgenommen am 19.09.2016
//
// // 335544351 -607  wird bei start  ca 10 mal ausgelöst
// RaiseException := TRUE;
// Application.ProcessMessages;
// if (errcode = 335544721) or (errcode = 335544485) then       // 335544721 -902
// begin
// if not FConnected then
// begin
// if FReconnect = 0 then
// begin
/// /        DataDesign.ShowMessageSkin(rscStrVerbindungZurDaten + #13 +
/// /                    rscStrVersucheVerbindung+#13+
/// /                    'Kasse wird nach Netzwerkausfall beendet');
// //      Application.Terminate;
// //       HALT;
// TimerConnect.Enabled := TRUE;
// FReconnect := 10000;
// RaiseException := FALSE;
// end else
// begin
// Dec(FReconnect);
// RaiseException := FALSE;
// end;
// end else
// begin
// RaiseException := FALSE;
// FConnected := FALSE;
// end;
//
// end;
//
/// //////////////////////////////////////////////////////////////////////////////////////
/// /  if (errcode <> 335544351) then begin
//
/// /  end;
// {
// aStr := 'error '+inttostr(errcode)+' '+inttostr(sqlcode);
// for i := 1 to ErrorMessage.Count do
// aStr := aStr + #13+errormessage[i-1];
// for i := 1 to  errorcodes.Count do
// aStr := aStr + #13+errorcodes[i-1];
// for i := 1 to  sqlmessage.Count do
// aStr := aStr + #13+sqlmessage[i-1];
// for i := 1 to  sql.Count do
// aStr := aStr + #13+sql[i-1];
// }
//
// end;

procedure TDBase.ConnectionZENSoundExParse(Sender: TObject;
  const SourceStr: string; var ResultStr: string);
begin
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
function TDBase.CheckField(const PTableName, PFieldName: string): Boolean;
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
      SQL.Add('  WHERE RDB$RELATION_NAME = UPPER(''' + Trim(PTableName)
        + ''') ');
      SQL.Add('    AND RDB$FIELD_NAME = UPPER(''' + Trim(PFieldName) + ''') ');
      Open;
      Result := RecordCount = 1;
      Close;
    except
      on E: Exception do
        Logger.Error('TDBase.CheckField', PTableName + '.' + PFieldName,
          NXLCAT_NONE, E);
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
  {
    select distinct rdb$index_name
    from rdb$indices
    where (substring(rdb$index_name from 1 for 3) not in ('UNQ', 'RDB'))
    and (rdb$index_name not in (
    select distinct rdb$constraint_name from rdb$relation_constraints
    where (rdb$constraint_type in ('FOREIGN KEY','PRIMARY KEY'))
    ))
    and (UPPER(rdb$index_name)=UPPER(:pIndexName));
  }
  with QueryShort do
    try
      Close;
      SQL.Clear;
      SQL.Add(' select distinct rdb$index_name from rdb$indices ');
      SQL.Add('  where (substring(rdb$index_name from 1 for 3) not in (''UNQ'', ''RDB'')) ');
      SQL.Add('    and (rdb$index_name not in ( ');
      SQL.Add('           select distinct rdb$constraint_name from rdb$relation_constraints ');
      SQL.Add('            where rdb$constraint_type in (''FOREIGN KEY'',''PRIMARY KEY'') ');
      SQL.Add('        )) ');
      SQL.Add('    and (UPPER(rdb$index_name)=UPPER(:pIndexName)); ');
      Open;
      Result := RecordCount = 1;
      Close;
    except
      on E: Exception do
        Logger.Error('TDBase.CheckIndexName', PIndexName, NXLCAT_NONE, E);
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
      SQL.Add(' SELECT * ');
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

  if (Pos('''', PSqlCommand) > 0) then
  begin
    ASQL := StringReplace(PSqlCommand, '''', '''''', [RfReplaceAll]);
    if (Pos('''''''''''''''''', ASQL) > 0) then
      ASQL := StringReplace(ASQL, '''''''''''''''''', '''''''''',
        [RfReplaceAll]);
  end
  else
    ASQL := PSqlCommand;

  with ScriptExecuteSQL do
    try
      SQLScripts.Clear;
      SQLScripts.Add;
      with SQLScripts[0].SQL do
      begin
        Add('SET TERM !! ; ' + SLineBreak);
        Add('EXECUTE BLOCK AS BEGIN ' + SLineBreak);
        Add('EXECUTE STATEMENT '' ' + SLineBreak);
        Add(ASQL + SLineBreak);
        Add('; ''; ' + SLineBreak);
        Add('END!! ' + SLineBreak);
        Add('SET TERM ; !! ' + SLineBreak);
      end;
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
        QueryShort.SQL.Clear;
        QueryShort.SQL.Add(' INSERT INTO Repl_DB (ID, Firma, SQLText, Typ) ');
        QueryShort.SQL.Add
          (Format('      VALUES  (%d, 1, ''%s'',  ''DBaseMigrateData'') ',
          [AMaxId, ASQL]));
        QueryShort.ExecSQL;
        QueryShort.Close;
      end;

    except
      on E: Exception do
        Logger.Error('TDBase.ExecuteSQL', PSqlCommand, NXLCAT_NONE, E);
    end;
end;

// ******************************************************************************
// Schreibt einen String in die Log-Datei
// ******************************************************************************
procedure TDBase.WriteToLog(PLogStr: string; PWrite: Boolean = TRUE);
var
  FileName: string;
  F: TextFile;
  XPfad: string;

begin
  if nxLogging.Logger = nil then
    Exit;

  if PWrite then
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
      SQL.Add('Select Gen_ID(' + PGenerator + ',0) from RDB$database')
    else
      SQL.Add('Select Gen_ID(' + PGenerator + ',' + IntToStr(PInc) +
        ') from RDB$database');
  end;
  if TransactionZEN.Connection.InTransaction then
  begin
    QueryShort.Open;
    Result := QueryShort.FieldByName('Gen_ID').AsInteger;
    QueryShort.Close;
  end
  else
  begin
    try
      if not TransactionZEN.Connection.InTransaction then
        TransactionZEN.StartTransaction;
      QueryShort.Open;
      Result := QueryShort.FieldByName('Gen_ID').AsInteger;
      QueryShort.Close;
      if TransactionZEN.Connection.InTransaction then
        // 25.02.2015 KL: #8928
        TransactionZEN.Commit;
    except
      on E: Exception do
      begin
        if TransactionZEN.Connection.InTransaction then
          // 25.02.2015 KL: #8928
          TransactionZEN.Rollback;
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
    SQL.Add('Select Gen_ID(' + PGenerator + ',1) from RDB$database');
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
  end
  else
  begin
    if FBusy > 0 then
      Dec(FBusy)
    else
      FBusy := 0;
    if (FBusy = 0) and (Screen.Cursor = CrHourGlass) then
      Screen.Cursor := CrDefault;
  end;
end;

// ******************************************************************************
// allgemeine Datenmigration für alle Kassenprogramme
// ******************************************************************************
procedure TDBase.MigrateData;
var
  I: Integer;
begin
  // 01.08.2013 KL: wichtig für WebUpdate in V8.8
  Logger.info('TDBase.MigrateData', '--- Start GKT-Data-Migration ---');

  // 24.07.2014 KL: CheckTabsDateHigher (übernommen aus Update 8.0->8.5)
  if not CheckField('EINSTELL', 'CheckTabsDateHigher') then
    ExecuteSQL(' ALTER TABLE EINSTELL ADD CheckTabsDateHigher KBOOLEAN');
  if CheckField('EINSTELL', 'CheckTabsDateHigher') then
    ExecuteSQL
      (' UPDATE EINSTELL SET CheckTabsDateHigher = ''T'' WHERE CheckTabsDateHigher is null ',
      False);

  // 22.07.2013 KL: #5598
  if not CheckField('TISCHKONTO', 'I_DeviceGUID') then
    ExecuteSQL(' ALTER TABLE TISCHKONTO ADD I_DeviceGUID KCHAR40');
  if not CheckField('HILF_TISCHKONTO', 'I_DeviceGUID') then
    ExecuteSQL(' ALTER TABLE HILF_TISCHKONTO ADD I_DeviceGUID KCHAR40');
  if CheckField('TISCHKONTO', 'I_DeviceGUID') then
    ExecuteSQL
      (' ALTER TABLE TISCHKONTO ALTER COLUMN I_DeviceGUID SET DEFAULT "" ');
  if CheckField('HILF_TISCHKONTO', 'I_DeviceGUID') then
    ExecuteSQL
      (' ALTER TABLE HILF_TISCHKONTO ALTER COLUMN I_DeviceGUID SET DEFAULT "" ');
  if CheckField('TISCHKONTO', 'I_DeviceGUID') then
    ExecuteSQL
      (' UPDATE TISCHKONTO SET I_DeviceGUID = '''' WHERE I_DeviceGUID is null ',
      False);
  if CheckField('HILF_TISCHKONTO', 'I_DeviceGUID') then
    ExecuteSQL
      (' UPDATE HILF_TISCHKONTO SET I_DeviceGUID = '''' WHERE I_DeviceGUID is null ',
      False);

  // 23.07.2013 KL: #5593
  if not CheckField('EINSTELL', 'StornoGrund') then
    ExecuteSQL(' ALTER TABLE EINSTELL ADD StornoGrund KBOOLEAN');
  if CheckField('EINSTELL', 'StornoGrund') then
    ExecuteSQL
      (' UPDATE EINSTELL SET StornoGrund = ''F'' WHERE StornoGrund is null ',
      False);

  // 23.07.2013 KL: #5610
  if not CheckField('EINSTELL', 'BonNummerDrucken') then
    ExecuteSQL(' ALTER TABLE EINSTELL ADD BonNummerDrucken KBOOLEAN');
  if CheckField('EINSTELL', 'BonNummerDrucken') then
    ExecuteSQL
      (' UPDATE EINSTELL SET BonNummerDrucken = ''T'' WHERE BonNummerDrucken is null ',
      False);

  // 18.02.2014 KL:  #6865
  if not CheckField('LOKALDRUCKER', 'Buzzer') then
    ExecuteSQL(' ALTER TABLE LOKALDRUCKER ADD Buzzer KBOOLEAN');
  if CheckField('LOKALDRUCKER', 'Buzzer') then
    ExecuteSQL
      (' UPDATE LOKALDRUCKER SET Buzzer = ''F'' WHERE Buzzer is null ', False);

  // 06.03.2014 KL: es kommt des Öfteren vor dass das Feld fehlt (wird aber in Datenanlage verwendet!)
  if not CheckField('LOKALDRUCKER', 'ChangeDruckerID') then
    ExecuteSQL(' ALTER TABLE LOKALDRUCKER ADD ChangeDruckerID KINTEGER');

  // 27.03.2014 KL: INTERNEZIMMERJEKASSE
  if not CheckField('EINSTELL', 'INTERNEZIMMERJEKASSE') then
    ExecuteSQL(' ALTER TABLE EINSTELL ADD INTERNEZIMMERJEKASSE KBOOLEAN');
  if CheckField('EINSTELL', 'INTERNEZIMMERJEKASSE') then
    ExecuteSQL
      (' UPDATE EINSTELL SET INTERNEZIMMERJEKASSE = ''F'' WHERE INTERNEZIMMERJEKASSE is null ',
      False);

  // 10.07.2014 KL: #7421: zusätzl. Auswahl für FastReport ermöglichen im TouchSetup
  if not CheckField('SCHLOSS_OPTIONEN', 'EinzelbonReportType') then
    ExecuteSQL
      (' ALTER TABLE SCHLOSS_OPTIONEN ADD EinzelBonReportType KINTEGER');
  if not CheckField('SCHLOSS_OPTIONEN', 'RechnungReportType') then
    ExecuteSQL(' ALTER TABLE SCHLOSS_OPTIONEN ADD RechnungReportType KINTEGER');
  if not CheckField('SCHLOSS_OPTIONEN', 'UmbuchungsbonReportType') then
    ExecuteSQL
      (' ALTER TABLE SCHLOSS_OPTIONEN ADD UmbuchungsbonReportType KINTEGER');
  if not CheckField('SCHLOSS_OPTIONEN', 'A4RechnungReportType') then
    ExecuteSQL
      (' ALTER TABLE SCHLOSS_OPTIONEN ADD A4RechnungReportType KINTEGER');
  if not CheckField('SCHLOSS_OPTIONEN', 'KassierbonReportType') then
    ExecuteSQL
      (' ALTER TABLE SCHLOSS_OPTIONEN ADD KassierbonReportType KINTEGER');
  if not CheckField('SCHLOSS_OPTIONEN', 'LagerbonReportType') then
    ExecuteSQL(' ALTER TABLE SCHLOSS_OPTIONEN ADD LagerbonReportType KINTEGER');
  if not CheckField('SCHLOSS_OPTIONEN', 'StornobonReportType') then
    ExecuteSQL
      (' ALTER TABLE SCHLOSS_OPTIONEN ADD StornobonReportType KINTEGER');

  // 16.10.2014 KL: Weiche für ASSI32.DLL vs. ASSI128.DLL
  if not CheckField('SCHLOSS_OPTIONEN', 'ASSI128PORTS') then
    ExecuteSQL(' ALTER TABLE SCHLOSS_OPTIONEN ADD ASSI128PORTS KBOOLEAN');

  // 15.10.2014 KL: Beilagen fürs Rechnungsdisplay
  if CheckTable('RECHNUNGSDISPLAY') then
  begin
    if not CheckField('RECHNUNGSDISPLAY', 'LOOKBEILAGEN') then
      ExecuteSQL('ALTER TABLE RECHNUNGSDISPLAY ADD LOOKBEILAGEN VARCHAR(255)');
    if not CheckField('RECHNUNGSDISPLAY', 'TISCHKONTOID') then
      ExecuteSQL('ALTER TABLE RECHNUNGSDISPLAY ADD TISCHKONTOID INTEGER');
  end;

  // 21.10.2015 KL: Umbuchen von Tisch auf Felix-Zimmer
  if not CheckField('HOTELLOG', 'TERMIN_NR') then
    ExecuteSQL(' ALTER TABLE HOTELLOG ADD TERMIN_NR CHAR(20)');
  if not CheckField('HOTELLOG', 'PERS_NR') then
    ExecuteSQL(' ALTER TABLE HOTELLOG ADD PERS_NR CHAR(20)');
  if not CheckField('HOTELLOG', 'ZIMMER_NR') then
    ExecuteSQL(' ALTER TABLE HOTELLOG ADD ZIMMER_NR CHAR(20)');

  // 29.10.2015 KL: #10292: Rechnungsnummer immer vergeben, keine Ausnahmen mehr, auch nicht bei kleinen Beträgen
  if CheckField('EINSTELL', 'PrintBillNumberValue') then
    ExecuteSQL
      (' UPDATE EINSTELL SET PrintBillNumberValue = 0 where PrintBillNumberValue<>0 ');
  // 24.11.2015 KL: #10292: jeden Bon drucken, ohne Ausnahme
  if CheckField('EINSTELL', 'SofortRechOhneDruck') then
    ExecuteSQL
      (' UPDATE EINSTELL SET SofortRechOhneDruck = ''F'' where SofortRechOhneDruck<>''F'' ');

  if CheckField('EINSTELL', 'BonNrIsRechNr') then // KL TODO
    ExecuteSQL
      (' UPDATE EINSTELL SET BonNrIsRechNr = ''F'' where BonNrIsRechNr <> ''F'' ');

  // 09.11.2015 KL: #10292: Bonnummer in JOURNAL hinzufügen
  if not CheckField('JOURNAL', 'BONNR') then
    ExecuteSQL(' ALTER TABLE JOURNAL ADD BONNR KINTEGER');
  if not CheckField('JOURNALARCHIV', 'BONNR') then
    ExecuteSQL(' ALTER TABLE JOURNALARCHIV ADD BONNR KINTEGER');

  // 29.01.2016 KL: #10566: RechnungsID wird benötigt beim Reaktivieren einer Rechnung
  if DBase.CheckTable('KUNDENRABATT') then
  begin
    if not DBase.CheckField('KUNDENRABATT', 'VERFALLDATUM') then
      DBase.ExecuteSQL(' ALTER TABLE KUNDENRABATT ADD VERFALLDATUM KDATE; ');
    if not DBase.CheckField('KUNDENRABATT', 'RECHNUNGSID') then
      DBase.ExecuteSQL(' ALTER TABLE KUNDENRABATT ADD RECHNUNGSID INTEGER; ');
  end;

  // 02.02.2016 KL: #10566: Kartennummer wird benötigt beim Reaktivieren einer Rechnung
  if DBase.CheckTable('RECHNUNGSZAHLWEG') then
  begin
    if not DBase.CheckField('RECHNUNGSZAHLWEG', 'KARTENNUMMER') then
      DBase.ExecuteSQL
        (' ALTER TABLE RECHNUNGSZAHLWEG ADD KARTENNUMMER INTEGER; ');
  end;
  if DBase.CheckTable('RECHNUNGSZAHLWEGARCHIV') then
  begin
    if not DBase.CheckField('RECHNUNGSZAHLWEGARCHIV', 'KARTENNUMMER') then
      DBase.ExecuteSQL
        (' ALTER TABLE RECHNUNGSZAHLWEGARCHIV ADD KARTENNUMMER INTEGER; ');
  end;

  // 29.04.2016 KL: #11867: Arrangementartikel in Prozent angeben
  for I := 2 to 10 do
    if DBase.CheckField('ARTIKEL', 'ARTIKELID' + IntToStr(I)) then
    begin
      if not DBase.CheckField('ARTIKEL', 'ARTIKELPREISID' + IntToStr(I)) then
        ExecuteSQL(' ALTER TABLE ARTIKEL ADD ARTIKELPREISID' + IntToStr(I) +
          ' KFLOAT; ');
      if not DBase.CheckField('ARTIKEL', 'ARTIKELPROZENTID' + IntToStr(I)) then
        ExecuteSQL(' ALTER TABLE ARTIKEL ADD ARTIKELPROZENTID' + IntToStr(I) +
          ' KFLOAT; ');
    end;

  // 30.12.2016 KL: ohne diese neuen Felder für Fiskaltrust kann KassaServer.exe nicht starten!
  if not CheckField('EINSTELL', 'Fiskaltrust') then
    ExecuteSQL(' ALTER TABLE EINSTELL ADD Fiskaltrust KBOOLEAN');
  if not CheckField('EINSTELL', 'FiskalTrustURL') then
    ExecuteSQL(' ALTER TABLE EINSTELL ADD FiskalTrustURL VARCHAR(255)');
  if not CheckField('EINSTELL', 'CashBoxID') then
    ExecuteSQL(' ALTER TABLE EINSTELL ADD CashBoxID VARCHAR(255)');

  Logger.info('TDBase.MigrateData', '--- End GKT-Data-Migration ---');
end;

function TDBase.SendEmail(PString: string): Boolean;
begin
  Result := False;
  // prepare email

  with IdMessage do
  begin
    TableFirma.Open;

    if IsDebug then
      Recipients.EMailAddresses := 'kurt.l@gms.info'
    else
      Recipients.EMailAddresses := 'update@gms.info';

    From.Address := Recipients.EMailAddresses;
    From.Name := TableFirma.FieldByName('Firmenname').AsString;
    Subject := Trim(PString);

    with Body do
    begin
      Clear;
      Text := LineBreak + Subject + LineBreak + LineBreak +
        Format('IP: %s', [IdIPWatch.LocalIP]) + LineBreak + LineBreak +
        Trim(TableFirma.FieldByName('Firmenname').AsString) + LineBreak;
    end;
  end;

  // send email
  with IdSMTP do
    try
      try
        Connect;
        Send(IdMessage);
        Result := TRUE;
        // 12.03.2014 KL: logging auskommentiert lt. Walters Email vom 11.3.2014
        // DoLogFile('Email wurde korrekt versandt.');
      except
        on E: Exception do
        begin
          Logger.Error('TDBase.SendEmail',
            'Email konnte NICHT versandt werden!', NXLCAT_NONE, E);
        end;
      end;
    finally
      if Connected then
        Disconnect;
    end;
end;

procedure TDBase.SetDefaulftConnection(PComponent: TComponent);
var
  I: Integer;
begin
  for I := 0 to PComponent.ComponentCount - 1 do
  begin
    if (PComponent.Components[I] is TFDTransaction) then
      (PComponent.Components[I] as TFDTransaction).Connection := ConnectionZEN
    else if (PComponent.Components[I] is TFDQuery) then
      (PComponent.Components[I] as TFDQuery).Connection := ConnectionZEN
    else if (PComponent.Components[I] is TFDTable) then
      (PComponent.Components[I] as TFDTable).Connection := ConnectionZEN
    else if (PComponent.Components[I] is TFDCommand) then
      (PComponent.Components[I] as TFDCommand).Connection := ConnectionZEN;
  end;
end;

end.
