unit gmstools;
//-----------------------------------------------------------------------------
// Software Stylers  - Utilitites
//-----------------------------------------------------------------------------
// DATUM DER ERSTELLUNG        : 8-3-02
// ERSTELLER                   : Ulrich HUTTER
// DATUM LETZTER ÄNDERUNG      :
// BEARBEITER LETZTER ÄNDERUNG :
// BESCHREIBUNG DER UNIT:
//   Verschiedene immer wieder verwendete Utilitites
//
//
// ÄNDERUNGEN:
//
//
//-----------------------------------------------------------------------------
// Katschberg 423, 5582 St. Michael/i.Lg
//-----------------------------------------------------------------------------

interface

uses forms, db, controls, dbgrids,
  IBODataset,
  FireDAC.Comp.Client;

//Ruft Abort auf, da bei der Implementierung der Unit BDE Abort nicht
//direkt aufgerufen werden darf
procedure AbortFunc;

//Löscht die Tausendertrennzeichen eines Betrages
function BetragToFloat(s: string): double;

//Erlaubt nur die Eingabe von Zahlen und Kommatrennzeichen
procedure BetragKeyPress(Sender: TObject;var Key: Char);
procedure DBBetragKeyPress(Sender: TObject;var Key: Char);

//Überprüft, ob mindestens 80 MB Speicher auf der Hauptplatte frei sind
function CheckDiskSpace: Boolean;

//Testet das übergebene Datum auf Richtigkeit und gibt in diesem
//Fall true zurück
function DatumTest (const s: string): Boolean;

//Formatiert während der Eingabe das Datum (Punkt setzen)
procedure DatumKeyPress(Sender: TObject;var Key: Char);

//Gibt die Tage des übergebenen Monats und des übergebenen Jahres zurück
function DaysThisMonth(pJahr, pMonat: word): integer;

//Formatiert während der Eingabe das Datum (Punkt setzen)
procedure DBDatumKeyPress(Sender: TObject;var Key: Char);

//Vervollstädnignt
procedure DatumExit(Sender: TObject; pDate: TDateTime);
//Muss in SetText des Datumfeldes plaziert werden
function DBDatumExit(aText: String; pDate: TDateTime): String;

//Ist das Suchen eines Datensatzes nicht erfolgreich, obwohl dies
//bei korrekter Funktion nicht möglich wäre, wird eine Exception ausgelöst
procedure FoundError(str: String);

//Erlaubt nur die Eingabe von Zahlen
procedure NummerKeyPress(var Key: Char);

function GetFileVersion: String;

//Liest einen Wert aus der Tabelle Einstellungen
function ReadTableValue(FieldName:String; ADefault: Variant; aTyp: String;
  pTable: TFDTable): Variant;

function CheckTablesFields(pAliasName, pTableName, pFieldName, pFieldTyp: String): Boolean;
procedure CheckTablesIndex(pAliasName, pTableName, pFieldName, pIndexname: String);

//Überprüft, ob die aktuelle Zeit (genau auf Minuten) pCheckMin Minuten vor pTime liegt
function CheckTimeMinute(pTime: TDateTime; pCheckMin: integer): Boolean;

Procedure StartTimeMessung;

Procedure StopTimeMessung;

//Überprüft, ob ein Drucker an den Computer angeschlossen ist und ob dieser
//auch bereit ist
function CheckPrinter: Boolean;
//Tagesabschluß in Spool-Datei drucken
function GetMonthName(aMonth: Integer): String;



implementation

uses
  SysUtils,
  WinProcs, //für Virtuelle Tastencodes
  Dialogs,  //für ShowMessage
  StdCtrls, //für TEdit
  dbCtrls,  //für DBEdit
  Buttons,
  classes,
  WIBUKEYLib_TLB,
  Windows, Printers,Variants;

var aEnd, aBegin, aDiff: TSystemtime;

const
  ScreenHeigthDev = 600;
  ScreenWidthDev = 800;


//Ruft Abort auf, da bei der Implementierung der Unit BDE Abort nicht
//direkt aufgerufen werden darf
procedure AbortFunc;
begin
  Abort;
end;

//Löscht die Tausendertrennzeichen eines Betrages
function BetragToFloat(s: string): double;
var posit: byte;
begin
  Posit := Pos(FormatSettings.ThousandSeparator, s);
  repeat
    Delete(s, posit, 1);
    Posit := Pos(FormatSettings.ThousandSeparator, s);
  until(Posit = 0);
  Posit := Pos(FormatSettings.ThousandSeparator, s);
  repeat
    Delete(s, posit, 1);
    Posit := Pos('e', s);
  until(Posit = 0);
  Result := 0;
  Posit := Pos(FormatSettings.ThousandSeparator, s);
  repeat
    Delete(s, posit, 1);
    Posit := Pos('E', s);
  until(Posit = 0);
  if s = '' then s := '0';
  try
    Result := StrToFloat(s);
  except
    ShowMessage('269: Dieser Wert ist keine Zahl');
  end;
end;

procedure BetragKeyPress(Sender: TObject;var Key: Char);
begin
  if not (key in [chr(VK_BACK), FormatSettings.DecimalSeparator,'0'..'9', '-']) then key := #0
  //Zwei Beistriche verhindern
  else if (key = FormatSettings.DecimalSeparator) and
    (Pos(FormatSettings.DecimalSeparator,(Sender as TEdit).Text)>0) then key := #0;
end;

procedure DBBetragKeyPress(Sender: TObject;var Key: Char);
begin
  if not (key in [chr(VK_BACK), FormatSettings.DecimalSeparator,'0'..'9', '-']) then key := #0
  //Zwei Beistriche verhindern
  else if (key = FormatSettings.DecimalSeparator) and
    (Pos(FormatSettings.DecimalSeparator,(Sender as TDBEdit).Text)>0) then key := #0;
end;

//Testet das übergebene Datum auf Richtigkeit und gibt in diesem
//Fall true zurück
function DatumTest (const s: string): Boolean;
begin
  try
    StrToDate(s);
    DatumTest := TRUE;
  except
    on EConvertError do DatumTest := FALSE;
  end;
end;

//Formatiert während der Eingabe das Datum (Punkt setzen)
//Backspace wird beachtet, nach dem Tag, bzw. dem Monat wird immer
//ein Punkt eingefügt
procedure DatumKeyPress(Sender: TObject;var Key: Char);
var l: integer;
    s: string;
    EditDatum: TEdit;
begin
  EditDatum := TEdit(Sender);
  if key in [chr(VK_BACK), '0'..'9'] then
  begin
    EditDatum.SelText := '';
    s := EditDatum.Text;
    l := length(s);
    if key = chr(VK_BACK) then
    begin
      Delete(s,l,1);
      if (l = 3) or (l = 6) then Delete(s,l-1,1);
    end else
    begin
      if l < 10 then s := s+key;
      if (l = 1) or (l = 4) then s := s+FormatSettings.DateSeparator;
    end;
    EditDatum.Text := s;
    l := length(s);
    EditDatum.SelStart := l+1;
  end;
  key := #0;
end;

// Wieviele Tage hat das aktuelle Monat
function DaysThisMonth(pJahr, pMonat: word): integer;const	DaysPerMonth: array[1..12] of Integer =		(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);	// Tage pro Monat
begin
	Result := DaysPerMonth[pMonat];	// Gib Tage des aktuellen Monats zurück

	// Beim Schaltjahr hat Februar 29 Tage
	if (pMonat = 2) and IsLeapYear(pJahr) then Inc(Result);
end;
//Formatiert während der Eingabe das Datum (Punkt setzen) für DBEditFelder
//Backspace wird beachtet, nach dem Tag, bzw. dem Monat wird immer
//ein Punkt eingefügt
//Wichtig bei DBEdit-Felder ist, das bei einer Verbindung mit einer
//DataSource die "AutoEdit"=TRUE hat, die Tabelle bei einer
//Eingabe auf "Edit" gesetzt wird, ansonsten darf keine Eingabe zugelassen
//werden
procedure DBDatumKeyPress(Sender: TObject;var Key: Char);
var l: integer;
    s: string;
    EditDatum: TDBEdit;
begin
  EditDatum := TDBEdit(Sender);
  if (EditDatum.DataSource.DataSet.State = dsBrowse) and
     (Key in [^H, ^V, ^X, #32..#255]) and
     EditDatum.DataSource.AutoEdit
       then EditDatum.DataSource.DataSet.Edit;
  if EditDatum.DataSource.DataSet.State in [dsEdit, dsInsert] then
  begin
    if key in [chr(VK_BACK), '0'..'9'] then
    begin
      EditDatum.SelText := '';
      s := EditDatum.Text;
      l := length(s);
      if key = chr(VK_BACK) then
      begin
        Delete(s,l,1);
//        if (l = 3) or (l = 6) then Delete(s,l-1,1);
        if (l = 3) or (l = 6) then Delete(s,l-1,1);
      end else
      begin
        if l < 10 then s := s+key;
        if (l = 1) or (l = 4) then s := s+FormatSettings.DateSeparator;
      end;
      EditDatum.Text := s;
      l := length(s);
      EditDatum.SelStart := l+1;
    end;
    key := #0;
  end;
end;

procedure DatumExit(Sender: TObject; pDate: TDateTime);
var aYear, aMonth, aDay: Word;
begin
  if Length((Sender as TEdit).Text) = 3 then
  begin
    DecodeDate(pDate, aYear, aMonth, aDay);
    if aMonth < 10 then
      (Sender as TEdit).Text := (Sender as TEdit).Text+'0';

    (Sender as TEdit).Text := (Sender as TEdit).Text+
         IntToStr(aMonth)+'.';
  end;
  if Length((Sender as TEdit).Text) = 6 then
  begin
    DecodeDate(pDate, aYear, aMonth, aDay);
    if StrToInt(copy((Sender as TEdit).Text, 4, 2)) < aMonth - 1 then
      (Sender as TEdit).Text := (Sender as TEdit).Text + IntToStr(aYear+1)
    else
      (Sender as TEdit).Text := (Sender as TEdit).Text + IntToStr(aYear);
  end;
end;

function DBDatumExit(aText: String; pDate: TDateTime): String;
var aYear, aMonth, aDay: Word;
begin
  if Length(aText) = 3 then
  begin
    DecodeDate(pDate, aYear, aMonth, aDay);
    if aMonth < 10 then aText := aText+'0';
    aText := aText+IntToStr(aMonth)+'.';
  end;
  if Length(aText) = 6 then
  begin
    DecodeDate(pDate, aYear, aMonth, aDay);
    if StrToInt(copy(aText, 4, 2)) < aMonth - 1 then
      aText := aText + IntToStr(aYear+1)
    else
      aText := aText + IntToStr(aYear);
  end;
  Result := aText;
end;

//Ist das Suchen eines Datensatzes nicht erfolgreich, obwohl dies
//bei korrekter Funktion nicht möglich wäre, wird eine Exception ausgelöst
procedure FoundError(str: String);
begin
  if str='' then raise EDataBaseError.Create('Datensatz nicht gefunden')
            else raise EDataBaseError.Create(str);
end;

procedure NummerKeyPress(var Key: Char);
begin
	if not (key in [chr(VK_BACK), '0'..'9']) then key := #0;
end;

function GetFileVersion: String;
var aFileName : string;
    VersionInfo, Translation, InfoPointer: Pointer;
    VerInfoSize, dummy: DWORD;
    VersionValue: String;
begin
  Result := '';
  VerInfoSize := 0;
  aFileName := Application.ExeName;
  VerInfoSize := GetFileVersionInfoSize(PChar(aFileName), dummy);
  if VerInfoSize > 0 then
  begin
    GetMem(VersionInfo, VerInfoSize);
    GetFileVersionInfo(PChar(aFileName), 0, VerInfoSize, VersionInfo);
    VerQueryValue(VersionInfo, '\\VarFileInfo\\Translation', Translation,
                  VerInfoSize);
    VersionValue := '\\StringFileInfo\\'+
                    IntToHex(LoWord(LongInt(Translation^)), 4)+
                    IntToHex(HiWord(LongInt(Translation^)), 4)+'\\';
    VerQueryValue(VersionInfo, PChar(VersionValue+'FileVersion'), InfoPointer,
                  VerInfoSize);

    Result := string(PChar(InfoPointer));
    FreeMem(VersionInfo);
  end;
end;

function CheckDiskSpace: Boolean;
var root : string;
    VolumeNameBuffer,
    FileSystemNameBuffer : PChar;
    SectorsPerCluster,
    BytesPerSector,
    NumberOfFreeClusters,
    TotalNumberOfClusters : DWORD;
    frei          : double;
begin
  root := 'C:\';
  VolumeNameBuffer:= StrAlloc(256);
  FileSystemNameBuffer := StrAlloc(256);
  GetDiskFreeSpace(PChar(root), SectorsPerCluster,
    BytesPerSector, NumberOfFreeClusters, TotalNumberOfClusters);
  frei := SectorsPerCluster * BytesPerSector;
  frei := frei * NumberOfFreeClusters;
  if Frei < 80*1024*1024 then
    Result := FALSE
  else
    Result := TRUE;
  StrDispose(VolumeNameBuffer);
  StrDispose(FileSystemNameBuffer);
end;

function ReadTableValue(FieldName:String; ADefault: Variant; aTyp: String;
  pTable: TFDTable): Variant;
var aQuery: TFDQuery;
begin
  with pTable do
  begin
    if FieldDefs.IndexOf(FieldName) = -1 then
    begin
      Close;
      aQuery := TFDQuery.Create(Application);
      aQuery.Connection.Connected := False;
      aQuery.Connection.Params.Values['Database'] :=
        pTable.Connection.Params.Values['Database'];
      aQuery.Connection.Connected := TRUE;
      aQuery.SQL.Add('ALTER TABLE '+pTable.TableName+' ADD '+FieldName+' '+aTyp);
      aQuery.ExecSQL;
      aQuery.Free;
      Open;
    end;
    if (FieldByName(FieldName).Value = null) and (aDefault <> '')then
    begin
      Edit;
      FieldByName(FieldName).Value := ADefault;
      Post;
    end;
    Result := FieldByName(FieldName).Value;
  end;
end;

procedure CheckTablesIndex(pAliasName, pTableName, pFieldName, pIndexname: String);
var aQuery: TFDQuery;
    aTable: TFDTable;
begin
  aQuery := TFDQuery.Create(Application);
  aTable := TFDTable.Create(Application);
  try
    aTable.TableName := pTableName;

    aTable.Connection.Connected := False;
    aTable.Connection.Params.Values['Database'] := pAliasName;
    aTable.Connection.Connected := TRUE;

    aTable.Open;
    if (aTable.IndexDefs.IndexOf(pIndexName) = -1) then
    begin
      aTable.Close;
      aQuery.SQL.Clear;

      aQuery.Connection.Connected := False;
      aQuery.Connection.Params.Values['Database'] := pAliasName;
      aQuery.Connection.Connected := TRUE;

      aQuery.SQL.Add('CREATE INDEX '+pIndexName+' ON '''+pTableName+''' ('+pFieldName+')');
      aQuery.ExecSQL;
    end else aTable.Close;
  finally
    aQuery.Free;
    aTable.Free;
  end;
end;

function CheckTablesFields(pAliasName, pTableName,
  pFieldName, pFieldTyp: String): Boolean;
var aQuery: TIBOQuery;
    aTable: TIBOTable;
begin
  Result := TRUE;
  aQuery := TIBOQuery.Create(Application);
  aTable := TIBOTable.Create(Application);
  try
    aTable.TableName := pTableName;
    aTable.DataBaseName := pAliasName;
    aTable.Open;
    if (aTable.FieldDefs.IndexOf(pFieldName) = -1) then
    begin
      Result := FALSE;
      aTable.Close;
      aQuery.SQL.Clear;
      aQuery.DatabaseName := pAliasName;
      aQuery.SQL.Add('ALTER TABLE '''+pTableName+''' ADD '+pFieldName+' '+pFieldTyp);
      aQuery.ExecSQL;
    end else aTable.Close;
  finally
    aQuery.Free;
    aTable.Free;
  end;
end;

function CheckTimeMinute(pTime: TDateTime; pCheckMin: integer): Boolean;
var nowhour, nowmin, tabshour, tabsmin, dummy: Word;
begin
  Result := FALSE;
  //Aktuelle Zeit - 1/4 Stunde, also eine viertel Stunde nach Datumswechsel
  DecodeTime(Time-pCheckMin/24/60, nowHour, nowMin, dummy, dummy);
  DecodeTime(pTime, TabsHour, TabsMin, dummy, dummy);
  if (nowHour = TABSHour) and (nowMin = TABSMin) then
    Result := TRUE;
end;

Procedure StartTimeMessung;
Begin
  GetSystemTime(aBegin);
End;

Procedure StopTimeMessung;
Begin
  GetSystemTime(aEnd);
  DateTimeToSystemTime(SystemTimeToDateTime(aEnd)-SystemTimeToDateTime(aBEgin),
      aDiff);
  ShowMessage(IntToStr(aDiff.wSecond)+':'+IntToStr(aDiff.wMilliseconds));
End;

//Überprüft, ob ein Drucker an den Computer angeschlossen ist und ob dieser
//auch bereit ist
function CheckPrinter: Boolean;
begin
  Result := TRUE;
  try
		if Printer.PrinterIndex < 0 then Result := FALSE;
  except
    Result := FALSE;
  end;
  if not Result then
    ShowMessage('270: Es ist entweder kein Drucker angeschlossen oder dieser funktioniert nicht');
end;

function GetMonthName(aMonth: Integer): String;
begin
  Result := '';
  case aMonth of
    1: Result := 'Januar';
    2: Result := 'Februar';
    3: Result := 'März';
    4: Result := 'April';
    5: Result := 'Mai';
    6: Result := 'Juni';
    7: Result := 'Juli';
    8: Result := 'August';
    9: Result := 'September';
    10: Result :=  'Oktober';
    11: Result := 'November';
    12: Result := 'Dezember';
  end;
end;


end.
