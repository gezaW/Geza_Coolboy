unit CheckThingsUnit;

interface

uses
  System.SysUtils, System.Variants, System.Classes, System.IniFiles,
  VCL.Forms,
  FireDAC.Comp.Client, Spring.Container, ServerIntf;

type
  TChecker = class(TInterfacedObject, IRestChecker)
    FCheckerQuery: TFDQuery;
    constructor create;
  private

    function CheckTable(pCompName: string; const PTableName: string; pIsProcedure: boolean=false): Boolean;
    function CheckField(pCompName: string; const PTableName, PFieldName: string; PFieldSource: string = ''): Boolean;

    function GetFirebirdPassword_EncryptedFromFile: String; // ADD_DB_CONNECTOR
    function GeneratePWDSecutityString: string;
    function MakeRNDString(Chars: string; Count: Integer): string;

    function DecodePWDEx(Data: string): string;
    function EncodePWDEx(Data: string; MinV: Integer = 0;
      MaxV: Integer = 5): string;
    function CheckIndice(PTableName, pColumn: String; pIndexname: string; pCompName: string): Boolean;

  public

    function GetFirebirdPassword: String; // ADD_DB_CONNECTOR

    function CheckUser(pUserName, pPassword: string): Boolean;
    function CheckOrCreateKASS_KASSENARCHIV_KassInfoId(pCompanyName: string): Boolean;
    property checkerQuery: TFDQuery read FCheckerQuery;
    function EncryptString(pStringToEncrypt: string): string;
    function DecryptString(pCryptedString: string): string;
    procedure CheckOrCreateStProcGastKontoRechnung(pSectionName: string);
    procedure checkAndCreateArtikel(pCompName: string);
    procedure checkAndCreateKellner(pCompName: string);
    procedure checkAndCreateJournalArchiv(pCompName: string);
    procedure checkAndCreateJournal(pCompName: string);
    procedure checkAndCreateSend_Bug_RestServer(pCompName: string);
    procedure checkAndCreateHotel_Signature(pCompName: string);
    procedure checkAndCreateServerInvoice(pCompName: string);
    procedure checkDiversesServer_GetLeistungByID(pCompName: string);
  end;

implementation

uses
  DataModule,Logging,// restFelixMainUnit,
  IOUtils, // ADD_DB_CONNECTOR
  Chilkat.Global, // ADD_DB_CONNECTOR
  Chilkat.PrivateKey, // ADD_DB_CONNECTOR
  Chilkat.RSA;

const
  SplitRange: Array [0 .. 20] of char =
    ('!', '§', '$', '%', '&', '?', '*', '+', '#', ',', ';', '.', ':', '-', '_', '<', '>', '@', '€', ' ', #39);

const
  Codes64 = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz+/';

const
  PWSecurityString: String = '1E/2hz3wI9QL70KB'; // Generated with GenerateSecurtiyString;

constructor TChecker.create;
begin
  inherited create;
  FCheckerQuery := TFDQuery.create(nil);
end;

function TChecker.GetFirebirdPassword: String; // ADD_DB_CONNECTOR
var
  aPasswordEncoded: String;
  aGlobal: HCkGlobal;
  aPrivateKey: HCkPrivateKey;
  aPasswordDecrypted: String;
  aRSADecryptor: HCkRsa;
const
  cChilkatString = 'GMSUHT.CB1102024_JPvadRPNjR1f';
  cPrivateKeyString: String = '-----BEGIN RSA PRIVATE KEY-----' +
    'MIIEpgIBAAKCAQEA7Xis1laJRkPe9lYdHi47pIJnApaWR1v3b8zWg6IGCYocs5uG' +
    'qS7zIFRMlUumRH83mp7A+C8cjH9ZR4GG0kCtaQWEBbgXqK1qCkJr7pac5iyCg5Hi' +
    'sjlcmqttryQa7qgPy4efS/hTJ0kRjKtYMkJJtDJxY2HOJInGC2YzjxqtrvfOGXWE' +
    'S5H1Z+sjrTqX1nkcUD7bzeVfibLyrmwm1ynQSSi835PCtmhsDMTuwJpca3Ou4v8S' +
    'h0xpVDpN4VHxKC9zzT1F1f92eHahyQGnH01ihv6n3Ibhmo3gqWGqLM1EC+vxaxDw' +
    'Y6Guuj/9wO4O3U1w/KjgdQmMjLDvYbhC5YDmpQIDAQABAoIBAQCP8xnaZ+SY2mWa' +
    'r8LA28e9xmqJEB2SrjYE6IeUja/ZMoaJfZqYjeRFUbSGv6/PT8q2CMvy5iQJKt1E' +
    '0kiWxSwZQIWyLdDxqAViqLbijxwXDx4igVmJLepru8UmaN2GlAvXFaRDmglWBB4G' +
    'RouVE8e32ugPFWevkHCj0lUox0RHjbacKDtp8nlDCC+2Xfb/IJdIPstA4mxxQcoa' +
    'TkvwiNrrCBUf7ArWWO8BOBO0lYNhOHbWTkwvKDcW4bRp3rjVWgYOozlzyqD6FBvc' +
    '/cxZkwNhomhJNbxD3Y0DH2FWL4dZOkq5/OEPE8DEUJjNfTeIquxWynjsgC8LI5/6' +
    '562FKac1AoGBAP+cfy0eDLFMJurQLXbfGEbJuik9bMfilXSdnpI+WfRfVIvaHGXr' +
    'TQGRrfkejILnETxK3ZLbNcxJApFfpQaJ1Sc4j2OMorY/x4JINUgR+DHJkd41Zn9R' +
    'lrZgZV9pRvorFRlyxpdl1FR3OJa/vJl/sBqZHu63UMDclKhknn9n7GmvAoGBAO3V' +
    'He9j0XpHnWljuDvCghAkFggmHyd/VB2hgAM/YjsrRiBiChZGPyBPQ36M6puXmfzo' +
    'yg6kUh2WdEGdu07L1C2OIV2tAUr+kluFjmDFLVxFc8lQU3FmEvpqNUk9RYRGc0I3' +
    'Z8H1Kx60xO6UObGXhGslj9X//A+UYleIjPJxQg3rAoGBAJ8XcnhMWa4ILbi8dW+l' +
    'D2EPsVR1rL0EI+1/JPD06dwVcXPR/xbYSweM+nExOFdJJgsWta3vzh4l2vlMRFQ7' +
    'eXV92JEnOSahr7VA6BjBRm8GfEmHhxH7YAiHGtE1nz2ZjvpV25DjijJAOfJpyCLp' +
    'vFvxrbT6V8KSB9x/M78smZJ1AoGBAKsS4j6BGXwQqWzWev4Zcn7zxhlEeqJpl3Lc' +
    '6Xzsidcv0HiYrNLK4rt16IHOES+sQ+rE9BrGHf8Ea0mLkOEkAtJl6yA7wrNUHKjS' +
    'j9CR5If7uUa0jeEC4GHaJcwx06BLILsfqXW9ya+DrihC3KEe8PQ1h5oSURhPztFR' +
    '+riluTLTAoGBAPOXEobKEXqLI8YABTVrz1QzE6SRZSDy/c4a4Kq3XEVVVGg4fyMv' +
    'zi/1sO7CY6CVxNEfjjbk1EE+vvtzsOU7Tv8Q9znbejCs5qzSPhaRmNVdLr5YiyxW' +
    'h9nYu6w88eg0+FF0B74mEvNh3ipuecgom2m6bFSHyXx6JjlSSSQQibSt' + '-----END RSA PRIVATE KEY-----';
begin
  // DO NOT FORGET TO COPY these files into the folder of exe:
  // - ChilkatDelphi32.dll
  // - ChilkatDelphi64.dll
  try
    Result := 'x';
    aPasswordEncoded := GetFirebirdPassword_EncryptedFromFile;
    if (aPasswordEncoded <> '') then
    begin
      aGlobal := nil;
      aRSADecryptor := nil;
      aPrivateKey := nil;
      try
        aGlobal := CkGlobal_Create();
        if not CkGlobal_UnlockBundle(aGlobal, cChilkatString) then
        begin
          Log.WriteToLog('ADMIN', 0,'<TChecker> error on CkGlobal_UnlockBundle', lmtError);
          Exit;
        end;
        aRSADecryptor := CkRsa_Create();
        CkRsa_putEncodingMode(aRSADecryptor, 'base64');
        aPrivateKey := CkPrivateKey_Create();
        if not CkPrivateKey_LoadPem(aPrivateKey, PWideChar(cPrivateKeyString)) then
        begin
          Log.WriteToLog('ADMIN', 0,'<TChecker> failed to load private key', lmtError);
          Exit;
        end;
        if not CkRsa_ImportPrivateKeyObj(aRSADecryptor, aPrivateKey) then
        begin
          Log.WriteToLog('ADMIN', 0,'<TChecker> failed to import private key', lmtError);
          Exit;
        end;
        aPasswordDecrypted := CkRsa__decryptStringEnc(aRSADecryptor, PWideChar(aPasswordEncoded), False);
        if Trim(aPasswordDecrypted) <> '' then
          Result := aPasswordDecrypted;
      finally
        if Assigned(aPrivateKey) then
          CkPrivateKey_Dispose(aPrivateKey);
        if Assigned(aRSADecryptor) then
          CkRsa_Dispose(aRSADecryptor);
        if Assigned(aGlobal) then
          CkGlobal_Dispose(aGlobal);
      end;
    end;
  except
    on ex: Exception do
      Log.WriteToLog('ADMIN', 0,'<TChecker> ERROR in CherckerUnit on trying to set db-password' + #13#10 + ex.Message,
        lmtError);
  end;
end;

function TChecker.GetFirebirdPassword_EncryptedFromFile: String; // ADD_DB_CONNECTOR
var
  aParentDirectory: String;
  aCounter: Integer;
  aLines: TStringList;
  i: Integer;
  aResult: PWideChar;
  aCheckFilePath: String;
begin
  try
    aResult := '';
    aCounter := 0;
    try
      aParentDirectory := TDirectory.GetParent(ExcludeTrailingPathDelimiter(Application.Exename));
      while (aParentDirectory <> '') and (aCounter < 20) do
      begin
        aCounter := aCounter + 1;
        aCheckFilePath := IncludeTrailingPathDelimiter(aParentDirectory) + 'hidden\password.txt';
        if fileexists(aCheckFilePath) then
        begin
          try
            aLines := TStringList.create;
            aLines.Loadfromfile(aCheckFilePath);
            for i := 0 to aLines.Count - 1 do
              if (Trim(aLines[i]) <> '') then
                aResult := PWideChar(Trim(aLines[i]));
          finally
            aLines.Free;
            if aResult <> '' then
              aParentDirectory := '';
          end;
        end
        else
          aParentDirectory := TDirectory.GetParent(aParentDirectory);
      end;
    except
      on ex: Exception do
        Log.WriteToLog('ADMIN', 0,'<TChecker> ERROR in CherckerUnit on trying to get db-password' + #13#10 + ex.Message,
          lmtError);
    end;
  finally
    Result := aResult;
  end;
end;

// This will encode your data.
// "SecurityString" must be generated using method
// described above, and then stored anywhere to
// use it in Decode function.
// "Data" is your string (you can use any characters here)
// "MinV" - minimum quantity of "noise" chars before each encoded data char.
// "MaxV" - maximum quantity of "noise" chars before each encoded data char.
function TChecker.EncodePWDEx(Data: string; MinV: Integer = 0;
  MaxV: Integer = 5): string;
var
  i, x: Integer;
  s1, s2, ss: string;
begin
  if MinV > MaxV then
  begin
    i := MinV;
    MinV := MaxV;
    MaxV := i;
  end;
  if MinV < 0 then
    MinV := 0;
  if MaxV > 100 then
    MaxV := 100;
  Result := '';
  if Length(PWSecurityString) < 16 then
    Exit;
  for i := 1 to Length(PWSecurityString) do
  begin
    s1 := Copy(PWSecurityString, i + 1, Length(PWSecurityString));
    if Pos(PWSecurityString[i], s1) > 0 then
      Exit;
    if Pos(PWSecurityString[i], Codes64) <= 0 then
      Exit;
  end;
  s1 := Codes64;
  s2 := '';
  for i := 1 to Length(PWSecurityString) do
  begin
    x := Pos(PWSecurityString[i], s1);
    if x > 0 then
      s1 := Copy(s1, 1, x - 1) + Copy(s1, x + 1, Length(s1));
  end;
  ss := PWSecurityString;
  for i := 1 to Length(Data) do
  begin
    s2 := s2 + ss[Ord(Data[i]) mod 16 + 1];
    ss := Copy(ss, Length(ss), 1) + Copy(ss, 1, Length(ss) - 1);
    s2 := s2 + ss[Ord(Data[i]) div 16 + 1];
    ss := Copy(ss, Length(ss), 1) + Copy(ss, 1, Length(ss) - 1);
  end;
  Result := MakeRNDString(s1, Random(MaxV - MinV) + MinV + 1);
  for i := 1 to Length(s2) do
    Result := Result + s2[i] + MakeRNDString(s1,
      Random(MaxV - MinV) + MinV);
end;

// This will decode your data, encoded with the function above, using specified "SecurityString".
function TChecker.DecodePWDEx(Data: string): string;
var
  i, x, x2: Integer;
  s1, s2, ss: string;
begin
  Result := #1;
  if Length(PWSecurityString) < 16 then
    Exit;
  for i := 1 to Length(PWSecurityString) do
  begin
    s1 := Copy(PWSecurityString, i + 1, Length(PWSecurityString));
    if Pos(PWSecurityString[i], s1) > 0 then
      Exit;
    if Pos(PWSecurityString[i], Codes64) <= 0 then
      Exit;
  end;
  s1 := Codes64;
  s2 := '';
  ss := PWSecurityString;
  for i := 1 to Length(Data) do
    if Pos(Data[i], ss) > 0 then
      s2 := s2 + Data[i];
  Data := s2;
  s2 := '';
  if Length(Data) mod 2 <> 0 then
    Exit;
  for i := 0 to Length(Data) div 2 - 1 do
  begin
    x := Pos(Data[i * 2 + 1], ss) - 1;
    if x < 0 then
      Exit;
    ss := Copy(ss, Length(ss), 1) + Copy(ss, 1, Length(ss) - 1);
    x2 := Pos(Data[i * 2 + 2], ss) - 1;
    if x2 < 0 then
      Exit;
    x := x + x2 * 16;
    s2 := s2 + chr(x);
    ss := Copy(ss, Length(ss), 1) + Copy(ss, 1, Length(ss) - 1);
  end;
  Result := s2;
end;

function TChecker.GeneratePWDSecutityString: string;
var
  i, x: Integer;
  s1, s2: string;
begin
  s1 := Codes64;
  s2 := '';
  for i := 0 to 15 do
  begin
    x := Random(Length(s1));
    x := Length(s1) - x;
    s2 := s2 + s1[x];
    s1 := Copy(s1, 1, x - 1) + Copy(s1, x + 1, Length(s1));
  end;
  Result := s2;
end;

// this function generate random string using
// any characters from "CHARS" string and length
// of "COUNT" - it will be used in encode routine
// to add "noise" into your encoded data.
function TChecker.MakeRNDString(Chars: string; Count: Integer): string;
var
  i, x: Integer;
begin
  Result := '';
  for i := 0 to Count - 1 do
  begin
    x := Length(Chars) - Random(Length(Chars));
    Result := Result + Chars[x];
    Chars := Copy(Chars, 1, x - 1) + Copy(Chars, x + 1, Length(Chars));
  end;
end;

function TChecker.CheckTable(pCompName: string; const PTableName: string; pIsProcedure: boolean=false): Boolean;
begin
  Result := False;

  if Trim(PTableName) = '' then
    Exit;
  try

    DM.ConnectionFelix.Close;
    DM.ConnectionFelix.Params.Clear;
    DM.ConnectionFelix.ConnectionDefName := pCompName;
    // DM.ConnectionFelix.Params.Values['Database'] := '192.168.178.33:C:\Database\Felix_Larrimar.FDB';
    DM.ConnectionFelix.Connected := true;
    with checkerQuery do
      try

        Connection := DM.ConnectionFelix;
        Close;
        SQL.Clear;
        if pIsProcedure then
        begin
          SQL.Add('select '+QuotedStr('Procedure')+', rdb$procedure_name, rdb$valid_blr from rdb$procedures ');
          SQL.Add('where rdb$procedure_name = '+QuotedStr(PTableName));
        end
        else
        begin
          SQL.Add(' SELECT RDB$RELATION_NAME FROM RDB$RELATIONS ');
          SQL.Add('  WHERE RDB$RELATION_NAME = UPPER(''' + Trim(PTableName) + ''') ');
        end;
        Open;
        Result := RecordCount = 1;
        Close;
      except
        on E: Exception do
          Log.WriteToLog(pCompName, 0,'<TChecker> CheckTable: ' + E.Message, lmtError);
      end;
  finally
    DM.ConnectionFelix.Connected := False;
  end;
end;

function TChecker.CheckIndice(PTableName, pColumn: String; pIndexname: string; pCompName: string): Boolean;
var
  aCount: Integer;
begin
  try
    with checkerQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select * from rdb$indices ri');
      SQL.Add('left outer join rdb$index_segments ris on ri.rdb$index_name=ris.rdb$index_name');
      SQL.Add(' where ri.rdb$relation_name=''' + PTableName + '''');
      SQL.Add(' and ris.rdb$field_name =''' + Trim(pColumn) + '''');
      Open;
      if RecordCount = 0 then
      begin
        Close;
        SQL.Clear;

        SQL.Add('CREATE INDEX ' + pIndexname + ' ON ' + PTableName + ' (' + pColumn + ')');

        try
          ExecSQL;
          Result := true;
        except
          begin
            Log.WriteToLog(pCompName, 0,'<TChecker> Fehler bei Index erstellen für Tabelle ' + PTableName + ' Spalte ' +
              Trim(pColumn), lmtInfo);
          end;

        end;
      end;
    end;
  except
    on E: Exception do
    begin
      Result := False;
    end;
  end;
end;

procedure TChecker.checkAndCreateArtikel(pCompName: string);
var
  isThere: Boolean;
begin
  try

    if not CheckTable(pCompName, 'ARTIKEL') then
    begin
      DM.ConnectionFelix.ConnectionDefName := pCompName;
      DM.ConnectionFelix.Connected := true;
      try
        with checkerQuery do
        begin
          Close;
          SQL.Clear;
          Connection := DM.ConnectionFelix;
          SQL.Add('Create Table Artikel (     ' +
                  'Firma integer,               ' +
                  'ID BigInt not null,          ' +
                  'ArtikelId KInteger,                  ' +
                  'Bezeichnung KChar255,            ' +
                  'LOCATIONID KChar255);              ');
          ExecSQL;
          Close;
          // Primary Key
          SQL.Clear;
          Connection := DM.ConnectionFelix;
          SQL.Add('ALTER TABLE Artikel ADD PRIMARY KEY (ID)');
          ExecSQL;
          Close;
          // Generator
          SQL.Clear;
          Connection := DM.ConnectionFelix;
          SQL.Add('CREATE SEQUENCE GEN_Artikel START WITH 0 INCREMENT BY 1;');
          ExecSQL;
          Close;
          // Trigger ID
          SQL.Clear;
          Connection := DM.ConnectionFelix;
          SQL.Add('CREATE trigger Artikel_bi0 for Artikel     ');
          SQL.Add('active before insert position 0            ');
          SQL.Add('AS                                         ');
          SQL.Add('begin                                      ');
          SQL.Add('  if (new.id is null) then                       ');
          SQL.Add('      new.id = gen_id(GEN_Artikel,1);        ');
          SQL.Add('end                                          ');
          ExecSQL;
          Close;
        end;
      except
        on E: Exception do
          Log.WriteToLog(pCompName, 0,'<TChecker> checkAndCreateArtikel: ' + E.Message, lmtError);
      end;
    end
    else
    begin
      if not CheckField(pCompName,'ARTIKEL','LOCATIONID') then
      begin
        with checkerQuery do
        try
          Close;
          SQL.Clear;
          SQL.Add(' ALTER TABLE ARTIKEL add LOCATIONID KCHAR255 ');
          ExecSQL;
        except
          on E: Exception do
          begin
            Log.WriteToLog(pCompName, 0,'<TChecker> checkAndCreateARTIKEL.LOCATIONID: ' + E.Message,
              lmtError);
          end;
        end;
      end;

    end;
    // Index auch bei bestehenden Tabellen überprüfen
//    CheckIndice('ARTIKEL','ARTIKELID','ARTIKEL_IDX1');
  finally
    DM.ConnectionFelix.Connected := False;
  end;
end;

procedure TChecker.checkAndCreateJournalArchiv(pCompName: string);
begin
  try
    if not CheckTable(pCompName, 'JournalArchiv') then
    begin
      DM.ConnectionFelix.ConnectionDefName := pCompName;
      DM.ConnectionFelix.Connected := true;
      try
        with checkerQuery do
        begin
          Close;
          SQL.Clear;
          Connection := DM.ConnectionFelix;
          SQL.Add('Create Table JournalArchiv (     ' +
                  'Firma integer,                 ' +
                  'ID BigInt not null,              ' +
                  'JournalArchivID BigInt,            ' +
                  'Datum KDate,                      ' +
                  'Zeit KDate,                        ' +
                  'KellnerId integer,                           ' +
                  'Menge KFloat,                    ' +
                  'Betrag KFloat,                       ' +
                  'ArtikelId integer,                           ' +
                  'BeilagenId integer,                                     ' +
                  'ZahlwegId integer,                               ' +
                  'TischId integer,                               ' +
                  'Journaltyp integer,                          ' +
                  'Verbucht KBoolean,                                     ' +
                  'Text KChar50,                            ' +
                  'VonOffeneTischId integer,                  ' +
                  'RechnungsId integer,                         ' +
                  'Nachlass KFloat,                               ' +
                  'LagerVerbucht KBoolean,                        ' +
                  'LagerDatum KDate,                                  ' +
                  'LagerId integer,                         ' +
                  'SyncId integer,                                 ' +
                  'BonNr integer,                             ' +
                  'Preisebene integer,                        ' +
                  'LOCATIONID KChar255 );                 ');
          ExecSQL;
          Close;
          // Primary Key
          SQL.Clear;
          Connection := DM.ConnectionFelix;
          SQL.Add('ALTER TABLE JournalArchiv ADD PRIMARY KEY (ID)');
          ExecSQL;
          Close;
          // Generator
          SQL.Clear;
          Connection := DM.ConnectionFelix;
          SQL.Add('CREATE SEQUENCE GEN_JournalArchiv START WITH 0 INCREMENT BY 1;');
          ExecSQL;
          // Trigger ID
          SQL.Clear;
          Connection := DM.ConnectionFelix;
          SQL.Add('CREATE trigger JournalArchiv_bi0 for JournalArchiv   ');
          SQL.Add('active before insert position 0                      ');
          SQL.Add('AS                                                   ');
          SQL.Add('begin                                                ');
          SQL.Add('  if (new.id is null) then                               ');
          SQL.Add('      new.id = gen_id(GEN_JournalArchiv,1);          ');
          SQL.Add('end                                                    ');
          ExecSQL;
          Close;
        end;
        // Index auch bei bestehenden Tabellen überprüfen
//        CheckIndice('JOURNALARCHIV','DATUM','JOURNALARCHIV_IDX1');
//        CheckIndice('JOURNALARCHIV','ARTIKELID','JOURNALARCHIV_IDX2');
//        CheckIndice('JOURNALARCHIV','JOURNALTYP','JOURNALARCHIV_IDX3');
      except
        on E: Exception do
          Log.WriteToLog(pCompName, 0,'<TChecker> checkAndCreateJournalArchiv: ' + E.Message, lmtError);
      end;
    end
    else
    begin
      if not CheckField(pCompName,'JOURNALARCHIV','LOCATIONID') then
      begin
        with checkerQuery do
        try
          Close;
          SQL.Clear;
          SQL.Add(' ALTER TABLE JOURNALARCHIV add LOCATIONID KCHAR255 ');
          ExecSQL;
        except
          on E: Exception do
          begin
            Log.WriteToLog(pCompName, 0,'<TChecker> checkAndCreateJournalArchiv.LOCATIONID: ' + E.Message,
              lmtError);
          end;
        end;
      end;

    end;
  finally
    DM.ConnectionFelix.Connected := False;
  end;
end;

procedure TChecker.checkAndCreateHotel_Signature(pCompName: string);
begin
  try
    if not CheckTable(pCompName, 'HOTEL_SIGNATURE') then
    begin
      DM.ConnectionFelix.ConnectionDefName := pCompName;
      DM.ConnectionFelix.Connected := true;
      try
        with checkerQuery do
        begin
          Close;
          SQL.Clear;
          Connection := DM.ConnectionFelix;
          SQL.Add('Create Table HOTEL_SIGNATURE (                             ' +
                  'ID              KINTEGER NOT NULL /* KINTEGER = BIGINT */, ' +
                  'COMPANYID       KSMALLINT /* KSMALLINT = BIGINT */,         ' +
                  'SIGNATUREDATE   KDATE /* KDATE = TIMESTAMP */,             ' +
                  'ROOMID          KINTEGER /* KINTEGER = BIGINT */,          ' +
                  'WAITERID        KINTEGER /* KINTEGER = BIGINT */,            ' +
                  'OPENTABLEID     KINTEGER /* KINTEGER = BIGINT */,         ' +
                  'RESERVID        KINTEGER /* KINTEGER = BIGINT */,         ' +
                  'SIGNATUREIMAGE  BLOB SUB_TYPE 0 SEGMENT SIZE 80            ' +
                  ');                                                         ');
          ExecSQL;
          Close;
          // Primary Key
          SQL.Clear;
          Connection := DM.ConnectionFelix;
          SQL.Add('ALTER TABLE HOTEL_SIGNATURE ADD CONSTRAINT PK_HOTEL_SIGNATURE PRIMARY KEY (ID);');
          ExecSQL;
          Close;
          // Indices  können hier überprüft werden weil Tabelle neu
          SQL.Clear;
          Connection := DM.ConnectionFelix;
          SQL.Add('CREATE INDEX HOTEL_SIGNATURE_IDX1 ON HOTEL_SIGNATURE (RESERVID);');
          ExecSQL;
          Close;
          SQL.Clear;
          Connection := DM.ConnectionFelix;
          SQL.Add('CREATE INDEX HOTEL_SIGNATURE_IDX_CMPOPNTBL ON HOTEL_SIGNATURE (COMPANYID, OPENTABLEID);');
          ExecSQL;
          Close;
          // Generator
          SQL.Clear;
          Connection := DM.ConnectionFelix;
          SQL.Add('CREATE SEQUENCE gen_signatureid START WITH 0 INCREMENT BY 1;');
          ExecSQL;
          // Trigger
          SQL.Clear;
          Connection := DM.ConnectionFelix;
          SQL.Add('CREATE OR ALTER TRIGGER HOTEL_SIGNATURE_BI0 FOR HOTEL_SIGNATURE        ');
          SQL.Add('active before insert position 0                                        ');
          SQL.Add('AS                                                                     ');
          SQL.Add('begin                                                                      ');
          SQL.Add('  if (new.id is null) then                                               ');
          SQL.Add('      NEW.ID = GEN_ID(gen_signatureid,1);                                  ');
          SQL.Add('end                                                                              ');
          ExecSQL;
          Close;
        end;
      except
        on E: Exception do
          Log.WriteToLog(pCompName, 0,'<TChecker> checkAndCreateHotel_Signature: ' + E.Message, lmtError);
      end;
    end;
  finally
    DM.ConnectionFelix.Connected := False;
  end;
end;

procedure TChecker.checkAndCreateJournal(pCompName: string);
begin
  try
    if not CheckTable(pCompName, 'Journal') then
    begin
      DM.ConnectionFelix.ConnectionDefName := pCompName;
      DM.ConnectionFelix.Connected := true;
      try
        with checkerQuery do
        begin
          Close;
          SQL.Clear;
          Connection := DM.ConnectionFelix;
          SQL.Add('Create Table Journal (' +
            'Firma integer, ' +
            'ID BigInt not null, ' +
            'JournalID BigInt, ' +
            'Datum KDate, ' +
            'Zeit KDate, ' +
            'KellnerId integer, ' +
            'KasseId integer, ' +
            'Menge KFloat, ' +
            'Betrag KFloat, ' +
            'ArtikelId integer, ' +
            'BeilagenId integer, ' +
            'ZahlwegId integer, ' +
            'OffeneTischId integer, ' +
            'Journaltyp integer, ' +
            'Verbucht KBoolean, ' +
            'Text KChar50, ' +
            'VonOffeneTischId integer, ' +
            'RechnungsId integer, ' +
            'Nachlass KFloat, ' +
            'Bankomat KBoolean, ' +
            'LagerVerbucht KBoolean, ' +
            'LagerDatum KDate, ' +
            'LagerId integer, ' +
            'SyncId integer, ' +
            'BonNr integer, ' +
            'Preisebene integer, ' +
            'LOCATIONID KChar255);');
          ExecSQL;
          Close;
          // Primary Key
          SQL.Clear;
          Connection := DM.ConnectionFelix;
          SQL.Add('ALTER TABLE Journal ADD PRIMARY KEY (ID)');
          ExecSQL;
          Close;
          // Generator
          SQL.Clear;
          Connection := DM.ConnectionFelix;
          SQL.Add('CREATE SEQUENCE GEN_Journal START WITH 0 INCREMENT BY 1;');
          ExecSQL;
          // Trigger ID
          SQL.Clear;
          Connection := DM.ConnectionFelix;
          SQL.Add('CREATE trigger Journal_bi0 for Journal');
          SQL.Add('active before insert position 0');
          SQL.Add('AS');
          SQL.Add('begin');
          SQL.Add('  if (new.id is null) then');
          SQL.Add('      new.id = gen_id(GEN_Journal,1);');
          SQL.Add('end');
          ExecSQL;
          Close;
        end;
      except
        on E: Exception do
          Log.WriteToLog(pCompName, 0,'<TChecker> checkAndCreateJournal: ' + E.Message, lmtError);
      end;
    end
    else
    begin
      if not CheckField(pCompName,'JOURNAL','LOCATIONID') then
      begin
        with checkerQuery do
        try
          Close;
          SQL.Clear;
          SQL.Add(' ALTER TABLE JOURNAL add LOCATIONID KCHAR255 ');
          ExecSQL;
        except
          on E: Exception do
          begin
            Log.WriteToLog(pCompName, 0,'<TChecker> checkAndCreateJournal.LOCATIONID: ' + E.Message,
              lmtError);
          end;
        end;
      end;

    end;
    // Index auch bei bestehenden Tabellen überprüfen
//    CheckIndice('JOURNAL','DATUM','JOURNAL_IDX1');
//    CheckIndice('JOURNAL','ARTIKELID','JOURNAL_IDX2');
//    CheckIndice('JOURNAL','JOURNALTYP','JOURNAL_IDX3');
  finally
    DM.ConnectionFelix.Connected := False;
  end;
end;

procedure TChecker.checkAndCreateKellner(pCompName: string);
begin
  try
    if not CheckTable(pCompName, 'Kellner') then
    begin
      DM.ConnectionFelix.ConnectionDefName := pCompName;
      DM.ConnectionFelix.Connected := true;
      try
        with checkerQuery do
        begin
          Close;
          SQL.Clear;
          Connection := DM.ConnectionFelix;
          SQL.Add('Create Table Kellner (  ' +
                  'Firma integer,           ' +
                  'ID BigInt not null,      ' +
                  'KellnerID integer,       ' +
                  'Nachname KChar50,        '+
                  'LOCATIONID KChar255);      ');
          ExecSQL;
          Close;
          // Primary Key
          SQL.Clear;
          Connection := DM.ConnectionFelix;
          SQL.Add('ALTER TABLE Kellner ADD PRIMARY KEY (ID)');
          ExecSQL;
          Close;
          // Generator
          SQL.Clear;
          Connection := DM.ConnectionFelix;
          SQL.Add('CREATE SEQUENCE GEN_Kellner START WITH 0 INCREMENT BY 1;');
          ExecSQL;
          // Trigger ID
          SQL.Clear;
          Connection := DM.ConnectionFelix;
          SQL.Add('CREATE trigger Kellner_bi0 for Kellner     ');
          SQL.Add('active before insert position 0            ');
          SQL.Add('AS                                         ');
          SQL.Add('begin                                      ');
          SQL.Add('  if (new.id is null) then                   ');
          SQL.Add('      new.id = gen_id(GEN_Kellner,1);      ');
          SQL.Add('end                                        ');
          ExecSQL;
          Close;
        end;
      except
        on E: Exception do
          Log.WriteToLog(pCompName, 0,'<TChecker> checkAndCreateKellner: ' + E.Message, lmtError);
      end;
    end
    else
    begin
      if not CheckField(pCompName,'KELLNER','LOCATIONID') then
      begin
        with checkerQuery do
        try
          Close;
          SQL.Clear;
          SQL.Add(' ALTER TABLE KELLNER add LOCATIONID KCHAR255 ');
          ExecSQL;
        except
          on E: Exception do
          begin
            Log.WriteToLog(pCompName, 0,'<TChecker> checkAndCreateKELLNER.LOCATIONID: ' + E.Message,
              lmtError);
          end;
        end;
      end;

    end;
    // Index auch bei bestehenden Tabellen überprüfen
//    CheckIndice('KELLNER','KELLNERID','KELLNER_IDX1');
  finally
    DM.ConnectionFelix.Connected := False;
  end;
end;

procedure TChecker.checkAndCreateSend_Bug_RestServer(pCompName: string);
begin
  try
    if not CheckTable(pCompName, 'Kass_send_Bug_RestServer') then
    begin
      DM.ConnectionFelix.ConnectionDefName := pCompName;
      DM.ConnectionFelix.Connected := true;
      try
        with checkerQuery do
        begin
          Close;
          SQL.Clear;
          Connection := DM.ConnectionFelix;
          SQL.Add('Create Table Kass_send_Bug_RestServer (' +
                  'ID BigInt not null,                        ' +
                  'Firma integer,                           ' +
                  'ReservID BigInt,                          ' +
                  'sendDay TimeStamp,                         ' +
                  'Text KChar1000);                         ');
          ExecSQL;
          // Primary Key
          Close;
          SQL.Clear;
          Connection := DM.ConnectionFelix;
          SQL.Add('ALTER TABLE Kass_send_Bug_RestServer ADD PRIMARY KEY (ID)');
          ExecSQL;
          Close;
          // Generator
          SQL.Clear;
          Connection := DM.ConnectionFelix;
          SQL.Add('CREATE SEQUENCE Gen_Kass_send_Bug_RestServer START WITH 0 INCREMENT BY 1;');
          ExecSQL;
          // Trigger ID
          Close;
          SQL.Clear;
          Connection := DM.ConnectionFelix;
          SQL.Add('CREATE trigger Kass_send_Bug_RestServer_bi0 for Kass_send_Bug_RestServer');
          SQL.Add('active before insert position 0                                          ');
          SQL.Add('AS                                                                         ');
          SQL.Add('begin');
          SQL.Add('  if (new.id is null) then                                               ');
          SQL.Add('      new.id = gen_id(GEN_Kass_send_Bug_RestServer,1);                         ');
          SQL.Add('end                                                                      ');
          ExecSQL;
          Close;
        end;
      except
        on E: Exception do
          Log.WriteToLog(pCompName, 0,'<TChecker> checkAndCreateKass_send_Bug_RestServer: ' + E.Message, lmtError);
      end;
    end;
  finally
    DM.ConnectionFelix.Connected := False;
  end;
end;

procedure TChecker.checkAndCreateServerInvoice(pCompName: string);
begin
  try
    if not CheckTable(pCompName, 'Rechnung_ExternServer') then
    begin
      DM.ConnectionFelix.ConnectionDefName := pCompName;
      DM.ConnectionFelix.Connected := true;
      try
        with checkerQuery do
        begin
          Close;
          SQL.Clear;
          Connection := DM.ConnectionFelix;
          SQL.Add('Create Table Rechnung_ExternServer (' +
                  'ID BigInt not null,                 ' +
                  'Firma integer,                      ' +
                  'InvoiceID KChar80,                ' +
                  'RechnungId BigInt)                  ');
          ExecSQL;
          // Primary Key
          Close;
          SQL.Clear;
          Connection := DM.ConnectionFelix;
          SQL.Add('ALTER TABLE Rechnung_ExternServer ADD PRIMARY KEY (ID)');
          ExecSQL;
          Close;
          // Generator
          SQL.Clear;
          Connection := DM.ConnectionFelix;
          SQL.Add('CREATE SEQUENCE Gen_Rechnung_ExternServer START WITH 0 INCREMENT BY 1;');
          ExecSQL;
          // Trigger ID
          Close;
          SQL.Clear;
          Connection := DM.ConnectionFelix;
          SQL.Add('CREATE trigger Rechnung_ExternServer_bi0 for Rechnung_ExternServer');
          SQL.Add('active before insert position 0                                   ');
          SQL.Add('AS                                                                ');
          SQL.Add('begin                                                             ');
          SQL.Add('  if (new.id is null) then                                        ');
          SQL.Add('      new.id = gen_id(GEN_Rechnung_ExternServer,1);               ');
          SQL.Add('end                                                               ');
          ExecSQL;
          Close;
        end;
      except
        on E: Exception do
          Log.WriteToLog(pCompName, 0,'<TChecker> checkAndCreateServerInvoice: ' + E.Message, lmtError);
      end;
    end;
  finally
    DM.ConnectionFelix.Connected := False;
  end;
end;

procedure TChecker.checkDiversesServer_GetLeistungByID(pCompName: string);
begin
  try
    try
      if not CheckField(pCompName, 'DIVERSES', 'SERVER_GETLEISTUNGBYNAME','KBOOLEAN') then
      begin
        with checkerQuery do
        begin
          Close;
          SQL.Clear;
          SQL.Add(' ALTER TABLE DIVERSES add SERVER_GETLEISTUNGBYNAME KBOOLEAN ');
          ExecSQL;
        end;
      end;
    except
      on E: Exception do
        Log.WriteToLog(pCompName, 0,'<TChecker> checkAndCreateServerInvoice: ' + E.Message, lmtError);
    end;
  finally
    checkerQuery.Close;
  end;
end;

function TChecker.CheckField(pCompName: string; const PTableName, PFieldName: string;
  PFieldSource: string = ''): Boolean;
begin
  Result := False;

  if (Trim(PTableName) = '') or (Trim(PFieldName) = '') or (Trim(pCompName) = '') then
    Exit;

  if not CheckTable(Trim(pCompName), Trim(PTableName)) then
    Exit;
  try
    DM.ConnectionFelix.ConnectionDefName := pCompName;
    DM.ConnectionFelix.Connected := true;
    with checkerQuery do
      try
        Close;
        SQL.Clear;
        Connection := DM.ConnectionFelix;
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
          Log.WriteToLog(pCompName, 0,'<TChecker> CheckField: ' + E.Message, lmtError);
      end;
  finally
    DM.ConnectionFelix.Connected := False;
  end;
end;

// *****************************************************************
// pUserName consists of ConnectionName and Username,
// separated by special characters
// *****************************************************************
function TChecker.CheckUser(pUserName, pPassword: string): Boolean;
var
  aSectionName: String;
  APath: string;
  i: Integer;
  AIni: TIniFile;
  ASectionList: TStringList;
begin
  Result := False;
  try
    try
      ASectionList := TStringList.create;
      APath := 'restFelix_Auth.ini';
      i := 0;
      while (i < 6) and NOT fileexists(ExpandFileName(ExtractFilePath(ParamStr(0)) + APath)) do
      begin
        APath := '..\' + APath;
        inc(i);
      end;
      AIni := TIniFile.create(ExpandFileName(ExtractFilePath(ParamStr(0)) + APath));
      AIni.ReadSections(ASectionList);
      for var Item in ASectionList do
      begin
        if DecryptString(Item) = pUserName then
        begin
          aSectionName := Item;
          break;
        end;
      end;

      if Not AIni.ValueExists(aSectionName, 'pwd') then
      begin
        Log.WriteToLog(aSectionName, 0,'<TChecker> CheckUser: Username wurde nicht gefunden! UserName: ' + pUserName, lmtLogin);
        Exit;
      end
      else if not(DecryptString(AIni.ReadString(aSectionName, 'pwd', '')) = pPassword) then
      begin
        Log.WriteToLog(aSectionName, 0,'<TChecker> CheckUser: Passwort wurde nicht gefunden! Passwort: ' + pPassword, lmtLogin);
        Exit;
      end
      else
      begin
        DM.FUserFirmaID := StrToInt(AIni.ReadString(aSectionName, 'FirmaID', ''));

        DM.FUserCompanyName := AIni.ReadString(aSectionName, 'FirmenName', '');
        Log.WriteToLog(DM.FUserCompanyName, 0,'<TChecker> CheckUser: Incomming Connection for: '
        + DM.FUserCompanyName + ' allowed', lmtLogin);
        Result := true;
      end;
    except
      on E: Exception do
      begin
        Log.WriteToLog(aSectionName, 0,'<TChecker> Error in TChecker.CheckUser: ' + E.Message, lmtError);
        Exit;
      end;
    end;
  finally

  end;
end;

function TChecker.DecryptString(pCryptedString: string): string;
begin
  Result := DecodePWDEx(pCryptedString);
end;

function TChecker.EncryptString(pStringToEncrypt: string): string;
begin
  Result := EncodePWDEx(pStringToEncrypt);
end;

function TChecker.CheckOrCreateKASS_KASSENARCHIV_KassInfoId(pCompanyName: string): Boolean;
begin
  Result := False;
  if NOT CheckField(Trim(pCompanyName), 'KASS_KASSENARCHIV', 'KASSINFOID') then
  begin
    with checkerQuery do
      try
        DM.ConnectionFelix.ConnectionDefName := pCompanyName;
        DM.ConnectionFelix.Connected := true;
        try
          Close;
          SQL.Clear;
          Connection := DM.ConnectionFelix;
          SQL.Add(' ALTER TABLE KASS_KASSENARCHIV add KASSINFOID KCHAR80 ');
          ExecSQL;
          Result := true;
        except
          on E: Exception do
          begin
            Log.WriteToLog(pCompanyName, 0,'<TChecker> CheckOrCreateKASS_KASSENARCHIV_KassInfoId: ' + E.Message,
              lmtError);
            Result := False;
          end;
        end;
      finally
        DM.ConnectionFelix.Connected := False;
      end;
  end;
end;

procedure TChecker.CheckOrCreateStProcGastKontoRechnung(pSectionName: string);
begin
  try
    try
      DM.ConnectionFelix.ConnectionDefName := pSectionName;
      DM.ConnectionFelix.Connected := true;
      if not CheckTable(pSectionName,'BOOK_RESTAURANTVALUEBILL',True) then
      begin
        with DM.QueryProcGastkontoRechnung do
        begin
          Close;
          Connection := DM.ConnectionFelix;
          ExecSQL;
          Close;
        end;
      end;
    except
      on E: Exception do
      begin
        Log.WriteToLog(pSectionName, 0,'<TChecker> CheckOrCreateStProcGastKontoRechnung: ' + E.Message, lmtError);
      end;
    end;
  finally
    DM.ConnectionFelix.Connected := False;
  end;
end;

initialization

begin
  Spring.Container.GlobalContainer.RegisterType<TChecker>.Implements<IRestChecker>;
  Spring.Container.GlobalContainer.Build;
end;

end.
