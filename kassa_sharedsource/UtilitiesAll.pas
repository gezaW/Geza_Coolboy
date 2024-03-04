unit UtilitiesAll;

interface

uses  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls,  IBODataset, DBSelectGrid, DBGrids,
  IniFiles,
  Ucrpe32, UCrpeClasses, FileCtrl, //Für Spooldatei
  bsdbctrls,DB, Variants, bsSkinCtrls,bsSkinBoxCtrls,bsDBGrids; //Für TDataSet und Konstanten dsEdit, dsInsert

//procedure WriteToProtokoll (pWriteStr: string; pWrite: Boolean);
//Ist das Suchen eines Datensatzes nicht erfolgreich, obwohl dies
//bei korrekter Funktion nicht möglich wäre, wird eine Exception ausgelöst
procedure FoundError(str: String);
//Löscht die Tausendertrennzeichen eines Betrages
function BetragToFloat(s: string): double;
//Erlaubt nur die Eingabe von Zahlen und Kommatrennzeichen
procedure BetragKeyPress(Sender: TObject;var Key: Char);
//Testet das übergebene Datum auf Richtigkeit und gibt in diesem
//Fall true zurück
function DatumTest (const s: string): Boolean;
//Formatiert während der Eingabe das Datum (Punkt setzen)
procedure DatumKeyPress(Sender: TObject;var Key: Char);
//Formatiert während der Eingabe das Datum (Punkt setzen)
procedure DBDatumKeyPress(Sender: TObject;var Key: Char);
//Vervollstädnignt
procedure DatumExit(Sender: TObject);
//Muss in SetText des Datumfeldes plaziert werden
function DBDatumExit(aText: String): String;
//Erlaubt nur die Eingabe von Zahlen
procedure NummerKeyPress(var Key: Char);
//Erlaubt nur die Eingabe von Zahlen und Buchstaben
procedure AlphanumericKeyPress(var Key: Char);
// Liest die DisplayWidth der Datensätze von "Query" unter
// "Kategorie" aus dem Ini-File
procedure ReadDataProfile(var Table: TIBOTable; Kategorie: String);
//Für das DBGridDrag muß eine Hilfstabelle verwendet werden, um
//die Prozedur ReadDBGridProfile aus Utilities verwenden zu können
procedure ReadDBSelectGridProfile(var AGrid: TDBSelectGrid; Kategorie: string);
// Liest die DisplayWidth der Datensätze von "Query" unter
// "Kategorie" aus dem Ini-File
procedure ReadDBGridProfile(var DBGrid: TbsSkinDBGrid; Kategorie: String);
//Liest die Zustand Position des
//übergebenen Fensters aus "Kategorie"
procedure ReadDialogProfile(Form: TForm; Kategorie: String);
//Liest den Zustand (Größe. Position und Windowstate) des
//übergebenen Fensters aus "Kategorie"
procedure ReadFormProfile(Form: TForm; Kategorie: String);
// Lesen eines Ini-Eintrags mit Fehlerabfrage
//ShowError -> TRUE: Ist der gesuchte Wert nicht vorhanden, wird eine Fehlermeldung
//          ausgegegeben; FALSE -> keine Fehlermeldung
function ReadProfileValue(Kategorie,Eintrag, Default: String; ShowError: Boolean):String;
// Schreibt die DisplayWidth der Datensätze von "Query" unter
// "Kategorie" in das Ini-File
procedure WriteDataProfile(var Table: TIBOTable; Kategorie: String);
//Siehe ReadDBGridFragProfile
procedure WriteDBSelectGridProfile(AGrid: TDBSelectGrid; Kategorie: string);
// Schreibt die DisplayWidth der Datensätze von "Query" unter
// "Kategorie" in das Ini-File
procedure WriteDBGridProfile(var DBGrid: TbsSkinDBGrid; Kategorie: String);
//Schreibt die Position des
//übergebenen Fensters in "Kategorie"
procedure WriteDialogProfile(Form: TForm; Kategorie: String);
//Schriebt den Zustand (Größe. Position und Windowstate) des
//übergebenen Fensters in "Kategorie"
procedure WriteFormProfile(Form: TForm; Kategorie: String);
procedure WriteMDIProfile(Form: TForm; Kategorie: String);
// Schreiben eines Ini-Eintrags
procedure WriteProfileValue(Kategorie,Eintrag,Wert: String);
procedure ShowMessageSkin(pString: String);
//aTyp ist für neue Felder, damit sie via SQL in der Diverses-Tabelle angelegt
//werden können
function ReadGlobalValue(FieldName:String; ADefault: Variant; aTyp: String): Variant;
//Gibt den WErt zurück
function GetGlobalValue(FieldName:String): Variant;
procedure WriteGlobalValue(pFieldName:String; pValue: Variant); 
procedure DBGridDrawRed(Sender: TObject;
  const Rect: TRect; Column: TbsColumn; FieldNameRed: String);

procedure DBSelectGridDrawRed(Sender: TObject;
  const Rect: TRect; Column: TColumn; FieldNameRed: String);

function AnsiUpperCaseFireBird(pStr: String): String;
procedure DatumDBbsSkinExit(Sender: TObject);
procedure DatumbsSkinExit(Sender: TObject);
function GenerateGUIDKey: String;



var FProfile: TIniFile; // Einstellungen in Ini-Datei speichern


implementation

uses Global, DMDesign, DMBase, ActiveX;

resourcestring
  rscStr269DieserWert = '269: Dieser Wert ist keine Zahl';
  rscStrDatensatzNicht = 'Datensatz nicht gefunden';
  rscStrFirma = ') Firma: ';
  rscStrMitarbeiter = ' Mitarbeiter: ';
  rscStr271Fehler = '271: Fehler in Ini-Datei';

var FIniFileName: String;

function AnsiUpperCaseFireBird(pStr: String): String;
var aHStr: String;
begin
  Result := AnsiUpperCase(pstr);
  aHStr := Result;
  while Pos('Ü', aHstr) > 0 do
  begin
    if pStr[Pos('Ü', aHStr)] <> 'Ü'  then
      Result[Pos('Ü', aHStr)] := 'ü';
    aHStr[Pos('Ü', aHStr)] := 'ü';
  end;
  aHStr := Result;
  while Pos('Ä', aHStr) > 0 do
  begin
    if pStr[Pos('Ä', aHStr)] <> 'Ä'  then
      Result[Pos('Ä', aHStr)] := 'ä';
    aHStr[Pos('Ä', aHStr)] := 'ä';
  end;
  aHStr := Result;
  while Pos('Ö', aHStr) > 0 do
  begin
    if pStr[Pos('Ö', aHStr)] <> 'Ö'  then
      Result[Pos('Ö', aHStr)] := 'ö';
    aHStr[Pos('Ö', aHStr)] := 'ö';
  end;
  //Der erste Buchstabe muss auch bei Umlauten groß sein!
  if length(Result) > 0 then
    Result[1] := AnsiUpperCase(Result[1])[1];
end;

procedure DBGridDrawRed(Sender: TObject;
  const Rect: TRect; Column: TbsColumn; FieldNameRed: String);
var FieldText: String;
    AbstandLinks: Integer;
begin
  if (Sender as TbsSkinDBGrid).DataSource.DataSet.FieldByName(FieldNameRed).AsFloat
     <= 0
  then
  begin
    AbstandLinks := 0;
    with (Sender as TbsSkinDBGrid).Canvas do
    begin
      FieldText := Column.Field.DisplayText;
      //Abstände abhängig vom Alignement des Feldes berrechnen
      if Column.Field.Alignment = taLeftJustify then AbstandLinks := 2;
      if Column.Field.Alignment = taCenter
        then AbstandLinks := Round((Column.Width-TextWidth(FieldText))/2)+1;
      if Column.Field.Alignment = taRightJustify
        then AbstandLinks := Round((Column.Width-TextWidth(FieldText)))-3;
      Font.color := clRed;
      //Rechteck muß mit Hintergrundfarbe des Grid gefüllt werden,
      //damit der alte Text nicht mehr aufscheint
      FillRect(Rect);
      //Text nur im Clipping-Rect anzeigen, da sonst beim verschieben
      //der Spalte der Text nicht immer in der Spalte bleibt
      TextRect(Rect, Rect.Left+Abstandlinks, Rect.Top+2, FieldText);
    end;
  end;
end;

procedure DBSelectGridDrawRed(Sender: TObject;
  const Rect: TRect; Column: TColumn; FieldNameRed: String);
var FieldText: String;
    AbstandLinks: Integer;
begin
  if (Sender as TDBSelectGrid).DataSource.DataSet.FieldByName(FieldNameRed).AsFloat
     <= 0
  then
  begin
    AbstandLinks := 0;
    with (Sender as TDBSelectGrid).Canvas do
    begin
      FieldText := Column.Field.DisplayText;
      //Abstände abhängig vom Alignement des Feldes berrechnen
      if Column.Field.Alignment = taLeftJustify then AbstandLinks := 2;
      if Column.Field.Alignment = taCenter
        then AbstandLinks := Round((Column.Width-TextWidth(FieldText))/2)+1;
      if Column.Field.Alignment = taRightJustify
        then AbstandLinks := Round((Column.Width-TextWidth(FieldText)))-3;
      Font.color := clRed;
      //Rechteck muß mit Hintergrundfarbe des Grid gefüllt werden,
      //damit der alte Text nicht mehr aufscheint
      FillRect(Rect);
      //Text nur im Clipping-Rect anzeigen, da sonst beim verschieben
      //der Spalte der Text nicht immer in der Spalte bleibt
      TextRect(Rect, Rect.Left+Abstandlinks, Rect.Top+2, FieldText);
    end;
  end;
end;

function ReadGlobalValue(FieldName:String; ADefault: Variant; aTyp: String): Variant;
var aQuery: TIBOQuery;
begin
  if NOT DBAse.TableDiverses.active then
    DBAse.TableDiverses.Open;

  with DBase.TableDiverses do
  begin
    REfresh;
    if FieldDefs.IndexOf(FieldName) = -1 then
    begin
//      DBase.TableDiverses.IB_Transaction.Commit;
      Close;

      aQuery := TIBOQuery.Create(Application);
      aQuery.SQL.Add('ALTER TABLE Diverses ADD '+FieldName+' '+aTyp);
      aQuery.ExecSQL;
      aQuery.IB_Transaction.Commit;
      aQuery.SQL.Clear;
      aQuery.SQL.Add('Update Diverses SET '+FieldName+' = '''+aDefault+'''');
      aQuery.ExecSQL;
      aQuery.SQL.Clear;
      aQuery.SQL.Add('SELECT '+FieldName+' FROM Diverses');
      aQuery.Open;
      Result := aQuery.FieldByName(FieldName).Value;
      aQuery.Close;
      aQuery.Free;
      Open;
    end else
    begin
      if FieldByName(FieldName).Value = null then
      begin
        Edit;
        FieldByName(FieldName).Value := ADefault;
        Post;
      end;
      Result := FieldByName(FieldName).Value;
    end;
  end;
end;
//Gibt den WErt zurück
function GetGlobalValue(FieldName:String): Variant;
begin
  with DBase.TableDiverses do
  begin
    Result := FieldByName(FieldName).Value;
  end;
end;

procedure WriteGlobalValue(pFieldName:String; pValue: Variant);
begin
  // Achtung: ist nur für FELIX gültig!
  with DBase.TableDiverses do
  begin
    DBASE.SQLExecute('UPDATE Diverses SET '+pFieldName+' = '''+VarToStr(pValue)+''' WHERE Firma = '+IntToStr(gFirma));
  end;
end;


procedure ShowMessageSkin(pString: String);
begin
  DataDesign.ShowMessageDlgSkin(pString,
        mtConfirmation, [mbOK], 0);
end;


//-------------------------Lesen und schreiben von Profiles!!!------------------

//  Schreibt einen Eintrag in die Ini-Datei
//  <Kategorie>:  Übergeordneter Eintrag der Ini-Datei
//  <Eintrag>:    Eintrag in der der Wert initialisiert werden soll
procedure WriteProfileValue(Kategorie,Eintrag,Wert: String);
begin
//  SetIniFileHidden(FALSE);
  FProfile.WriteString(Kategorie,Eintrag,Wert);
//  SetIniFileHidden(TRUE);
end;

//  Liest einen Eintrag aus der Ini-Datei
//  <Kategorie>:   Übergeordneter Eintrag der Ini-Datei
//  <Eintrag>:     Eintrag aus der der Wert gelesen werden soll
//  ERGEBNIS:      Gibt den Wert aus der Ini-Datei als String zurück
function ReadProfileValue(Kategorie,Eintrag, Default: String; ShowError: Boolean):String;
var
  Strg: String;
begin
  with FProfile do
  begin
    Strg:=ReadString(Kategorie,Eintrag,'ERROR');
    if Strg='ERROR' then
    begin
{      //Fehlermeldung ausgeben
      if 1=2 then
      begin
        ProfileErrDlg:=TProfileErrorDlg.Create(Application);
        try
          ProfileErrDlg.SeTbsSkinStdLabels('Read',Kategorie,Eintrag,'');
          ProfileErrDlg.ShowModal;
        finally
          ProfileErrDlg.Release;
        end;
      end;}
      Result := Default;
      //Default Wert wird weggeschrieben
      WriteProfileValue(Kategorie, Eintrag, Result);
    end
    else Result:=Strg;
  end;
end;

// Schreibt die DisplayWidth der Datensätze von <Table> unter
// <Kategorie> in das Ini-File
// Hier werden alle Felder durchgegangen und die Diplaywidth unter
// dem Feldnamen gespeichert
procedure WriteDataProfile(var Table: TIBOTable; Kategorie: String);
var count: Integer;
begin
  with Table do
    //Alle Felder durchgehen
    for count := 0 to FieldCount-1 do
      WriteProfileValue(Kategorie,'DisplayWidth'+Table.Fields[count].FieldName,
        IntToStr(Table.Fields[count].DisplayWidth));
end;

//Siehe ReadDBGridFragProfile
procedure WriteDBSelectGridProfile;
var count: Integer;
begin
  with AGrid do
    //Alle Felder durchgehen
    for count := 0 to Columns.Count-1 do
      WriteProfileValue(Kategorie,'DisplayWidth'+Columns[count].FieldName,
        IntToStr(Columns[count].Width));
{  HilfsGrid := (AGrid as TbsSkinDBGrid);
  WriteDBGridProfile(HilfsGrid, Kategorie);}
end;

// Schreibt die DisplayWidth der Datensätze von <DBGrid> unter
// <Kategorie> in das Ini-File
// Hier werden alle Felder durchgegangen und die Diplaywidth unter
// dem Feldnamen gespeichert
procedure WriteDBGridProfile(var DBGrid: TbsSkinDBGrid; Kategorie: String);
var count: Integer;
begin
  with DBGrid do
    //Alle Felder durchgehen
    for count := 0 to Columns.Count-1 do
      WriteProfileValue(Kategorie,'DisplayWidth'+Columns[count].FieldName,
        IntToStr(Columns[count].Width));
end;

//Schreibt die Position des
//übergebenen Fensters in "Kategorie"
procedure WriteDialogProfile(Form: TForm; Kategorie: String);
begin
  // Fensterpositionen schreiben}
  WriteProfileValue(Kategorie,'Top',IntToStr(Form.Top));
  WriteProfileValue(Kategorie,'Left',IntToStr(Form.Left));
end;

//Schreibt den Zustand (Größe. Position und Windowstate) des
//übergebenen Fensters in "Kategorie"
procedure WriteFormProfile(Form: TForm; Kategorie: String);
begin
  // Fensterzustand (Maximized,Minimized,Nromal) schreiben
  case Form.WindowState of
    wsNormal:
      WriteProfileValue(Kategorie,'WindowState','wsNormal');
    wsMaximized:
      WriteProfileValue(Kategorie,'WindowState','wsMaximized');
    wsMinimized:
      WriteProfileValue(Kategorie,'WindowState','wsMinimized');
  end;
  // Fensterpositionen schreiben}
  WriteProfileValue(Kategorie,'Top',IntToStr(Form.Top));
  WriteProfileValue(Kategorie,'Left',IntToStr(Form.Left));
  WriteProfileValue(Kategorie,'Width',IntToStr(Form.Width));
  WriteProfileValue(Kategorie,'Height',IntToStr(Form.Height));
end;

//Bei einem MDI-Fenster wird WindowState zuvor wieder auf normal gesetzt,
//da sonst nicht die richtigen Werte für die Position des Fensters
//gespeichert werden
procedure WriteMDIProfile(Form: TForm; Kategorie: String);
var oldWindowState: TWindowState;
begin
  oldWindowState := Form.WindowState;
  Form.WindowState := wsNormal;
  // Fensterpositionen schreiben}
  WriteProfileValue(Kategorie,'Top',IntToStr(Form.Top));
  WriteProfileValue(Kategorie,'Left',IntToStr(Form.Left));
  WriteProfileValue(Kategorie,'Width',IntToStr(Form.Width));
  WriteProfileValue(Kategorie,'Height',IntToStr(Form.Height));
  // Fensterzustand (Maximized,Minimized,Nromal) schreiben
  case OldWindowState of
    wsNormal:
      WriteProfileValue(Kategorie,'WindowState','wsNormal');
    wsMaximized:
      WriteProfileValue(Kategorie,'WindowState','wsMaximized');
    wsMinimized:
      WriteProfileValue(Kategorie,'WindowState','wsMinimized');
  end;
end;

// Liest die DisplayWidth der Datensätze von <DBGrid> unter
// <Kategorie> aus dem Ini-File
// Hier werden alle Felder durchgegangen und die Diplaywidth mit
// dem Feldnamen gelesen
procedure ReadDBGridProfile(var DBGrid: TbsSkinDBGrid; Kategorie: String);
var count: Integer;
    aValue: Integer;
begin
  // Anzeigebreite der Datnsatzfelder im Tabellenmodus lesen
  with DBGrid do
    //Alle Felder durchgehen
    for count := 0 to Columns.Count-1 do
    begin
      //und aus Ini-File lesen
      aValue := StrToInt(ReadProfileValue(Kategorie,
         'DisplayWidth'+Columns[count].FieldName, '0', FALSE));
      if aValue > 0 then
        Columns[count].Width:= aValue;
    end;
end;

// Liest die DisplayWidth der Datensätze von <Query> unter
// <Kategorie> aus dem Ini-File
// Hier werden alle Felder durchgegangen und die Diplaywidth mit
// dem Feldnamen gelesen
procedure ReadDataProfile(var Table: TIBOTable; Kategorie: String);
var count: Integer;
begin
  // Anzeigebreite der Datnsatzfelder im Tabellenmodus lesen
  with Table do
    //Alle Felder durchgehen
    for count := 0 to FieldCount-1 do
      //und aus Ini-File lesen
       Table.Fields[count].DisplayWidth:= StrToInt(ReadProfileValue(Kategorie,
         'DisplayWidth'+Table.Fields[count].FieldName, '30', FALSE));
end;

//Für das DBGridDrag muß eine Hilfstabelle verwendet werden, um
//die Prozedur ReadDBGridProfile aus Utilities verwenden zu können
procedure ReadDBSelectGridProfile;
var count: integer;
    aValue: Integer;
begin
  // Anzeigebreite der Datnsatzfelder im Tabellenmodus lesen
  with AGrid do
  begin
    //Alle Felder durchgehen
    for count := 0 to Columns.Count-1 do
    begin
      //und aus Ini-File lesen
      aValue := StrToInt(ReadProfileValue(Kategorie,
         'DisplayWidth'+Columns[count].FieldName, '0', FALSE));
      //Falls im Ini File nichts steht, dann Standart von der Programmierung nehmen
      if aValue > 0 then
        Columns[count].Width:= aValue;
    end;
  end;

{  HilfsGrid := (AGrid as TbsSkinDBGrid);
  ReadDBGridProfile(HilfsGrid, Kategorie);
  AGrid := (HilfsGrid as TDBSelectGrid);}
end;

//Liest die Zustand Position des
//übergebenen Fensters aus "Kategorie"
procedure ReadDialogProfile(Form: TForm; Kategorie: String);
begin
  // Fensterpositionen lesen
  Form.Top:=StrToInt(ReadProfileValue(Kategorie,'Top', '10', FALSE));
  Form.Left:=StrToInt(ReadProfileValue(Kategorie,'Left', '10', FALSE));
end;

//Liest den Zustand (Größe. Position und Windowstate) des
//übergebenen Fensters aus "Kategorie"
procedure ReadFormProfile(Form: TForm; Kategorie: String);
var aValue: Integer;
begin
  // Fensterpositionen lesen
  aValue := StrToInt(ReadProfileValue(Kategorie,'Top', '0', FALSE));
//  if aValue <> 0 then
    Form.Top := aValue;
  aValue := StrToInt(ReadProfileValue(Kategorie,'Left', '0', FALSE));
//  if aValue <> 0 then
    Form.Left := aValue;
  aValue := StrToInt(ReadProfileValue(Kategorie,'Width', '0', FALSE));
  if aValue > 0 then
    Form.Width := aValue;
  aValue := StrToInt(ReadProfileValue(Kategorie,'Height', '0', FALSE));
  if aValue > 0 then
    Form.Height := aValue;
  //Bei einem MDE führt das zu Problemen
  if Form.FormStyle <> fsMDIChild then
  begin
  // Fensterzustand (Maximized,Minimized,Normal) lesen
    if ReadProfileValue(Kategorie,'WindowState', '', FALSE)='wsMaximized'
       then Form.WindowState:=wsMaximized;
    if ReadProfileValue(Kategorie,'WindowState', '', FALSE)='wsMinimized'
       then Form.WindowState:=wsMinimized;
    if ReadProfileValue(Kategorie,'WindowState', '', FALSE)='wsNormal'
       then Form.WindowState:=wsNormal;
  end;
end;

procedure NummerKeyPress(var Key: Char);
begin
  if not CharInSet(key, [chr(VK_BACK), '0'..'9']) then key := #0;
end;

procedure AlphanumericKeyPress(var Key: Char);
begin
  if not CharInSet(key, [chr(VK_BACK), '0'..'9', 'a'..'z', 'A'..'Z']) then key := #0;
end;

//Löscht die Tausendertrennzeichen eines Betrages
function BetragToFloat(s: string): double;
var posit: byte;
begin
  Result := 0;
  Posit := Pos(FormatSettings.ThousandSeparator, s);
  repeat
    Delete(s, posit, 1);
    Posit := Pos(FormatSettings.ThousandSeparator, s);
  until(Posit = 0);
  try
    Result := StrToFloat(s);
  except
    ShowMessage(rscStr269DieserWert);
  end;
end;

procedure BetragKeyPress(Sender: TObject;var Key: Char);
begin
  if not (key in [chr(VK_BACK), FormatSettings.DecimalSeparator,'0'..'9', '-']) then
    key := #0
  //Zwei Beistriche verhindern
  else
    if (key = FormatSettings.DecimalSeparator)
    and (Pos(FormatSettings.DecimalSeparator,(Sender as TbsSkinEdit).Text)>0) then
      key := #0;
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
    EditDatum: TbsSkinEdit;
begin
  EditDatum := TbsSkinEdit(Sender);
  if key in [chr(VK_BACK), '0'..'9'] then
  begin
    EditDatum.SelText := '';
    s := EditDatum.Text;
    l := length(s);
    if key = chr(VK_BACK) then
    begin
      Delete(s,l,1);
      if (l = 3) or (l = 6) then Delete(s,l-1,1);
    end
    else
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
    EditDatum: TbsSkinDBEdit;
begin
  EditDatum := TbsSkinDBEdit(Sender);
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

procedure DatumExit(Sender: TObject);
var aYear, aMonth, aDay: Word;
begin
  if Length((Sender as TbsSkinEdit).Text) = 3 then
  begin
    DecodeDate(Date, aYear, aMonth, aDay);
    if aMonth < 10 then
      (Sender as TbsSkinEdit).Text := (Sender as TbsSkinEdit).Text+'0';

    (Sender as TbsSkinEdit).Text := (Sender as TbsSkinEdit).Text+
         IntToStr(aMonth)+'.';
  end;
  if Length((Sender as TbsSkinEdit).Text) = 6 then
  begin
    DecodeDate(Date, aYear, aMonth, aDay);
    if StrToInt(copy((Sender as TbsSkinEdit).Text, 4, 2)) < aMonth - 1 then
      (Sender as TbsSkinEdit).Text := (Sender as TbsSkinEdit).Text + IntToStr(aYear+1)
    else
      (Sender as TbsSkinEdit).Text := (Sender as TbsSkinEdit).Text + IntToStr(aYear);
  end;
end;

procedure DatumDBbsSkinExit(Sender: TObject);
var aYear, aMonth, aDay: Word;
    aText : String;
begin
  aText := trim((Sender as TbsSkinDBDateEdit).Text);
  if (Length(aText) = 6)
   and (aText[4] = ' ') then
  begin
    DecodeDate(Date, aYear, aMonth, aDay);
    aText := copy(aText,1,3);
    if aMonth < 10 then
      aText := aText+'0';
    aText := aText+IntToStr(aMonth)+'.';
    (Sender as TbsSkinDBDateEdit).Text := aText;
  end;
  if Length(aText) = 6 then
  begin
    DecodeDate(Date, aYear, aMonth, aDay);
    if StrToInt(copy(aText, 4, 2)) < aMonth - 1 then
      (Sender as TbsSkinDBDateEdit).Text := aText + IntToStr(aYear+1)
    else
      (Sender as TbsSkinDBDateEdit).Text := aText + IntToStr(aYear);
  end;
end;

procedure DatumbsSkinExit(Sender: TObject);
var aYear, aMonth, aDay: Word;
    aText : String;
begin
  aText := trim((Sender as TbsSkinDateEdit).Text);
  if (Length(aText) = 6)
   and (aText[4] = ' ') then
  begin
    DecodeDate(Date, aYear, aMonth, aDay);
    aText := copy(aText,1,3);
    if aMonth < 10 then
      aText := aText+'0';
    aText := aText+IntToStr(aMonth)+'.';
    (Sender as TbsSkinDateEdit).Text := aText;
  end;
  if Length(aText) = 6 then
  begin
    DecodeDate(Date, aYear, aMonth, aDay);
    if StrToInt(copy(aText, 4, 2)) < aMonth - 1 then
      (Sender as TbsSkinDateEdit).Text := aText + IntToStr(aYear+1)
    else
      (Sender as TbsSkinDateEdit).Text := aText + IntToStr(aYear);
  end;
end;

function DBDatumExit(aText: String): String;
var aYear, aMonth, aDay: Word;
begin
  if Length(aText) = 3 then
  begin
    DecodeDate(Date, aYear, aMonth, aDay);
    if aMonth < 10 then aText := aText+'0';
    aText := aText+IntToStr(aMonth)+'.';
  end;
  if Length(aText) = 6 then
  begin
    DecodeDate(Date, aYear, aMonth, aDay);
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
  if str='' then raise EDataBaseError.Create(rscStrDatensatzNicht)
            else
            begin
              DBase.WriteToLog(str, TRUE);
              raise EDataBaseError.Create(str);
            end;
end;


function GenerateGUIDKey: String;
var
  MyGUID: TGUID;
  MyWideChar: array[0..100] of WideChar;
begin
  // First, generate the GUID:
  CoCreateGUID(MyGUID);
  // Now convert it to a wide-character string:
  StringFromGUID2(MyGUID, MyWideChar, 39);
  // Now convert it to a Delphi string:
  Result := WideCharToString(MyWideChar);
  // Get rid of the three dashes that StringFromGUID2()
  // puts in the result string:
  while Pos('-', Result) > 0 do
    Delete(Result, Pos('-', Result), 1);
  // Get rid of the left and right brackets in the string:
  while Pos('{', Result) > 0 do
    Delete(Result, Pos('{', Result), 1);
  while Pos('}', Result) > 0 do
    Delete(Result, Pos('}', Result), 1);
end;

Initialization

finalization


end.

