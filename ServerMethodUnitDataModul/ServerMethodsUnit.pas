unit ServerMethodsUnit;

interface

uses System.SysUtils, System.Classes, System.Json, System.Variants,
  DataSnap.DSProviderDataModuleAdapter,
  DataSnap.DSServer, DataSnap.DSAuth,
  Vcl.ExtCtrls, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, ServerIntf, Vcl.Graphics;

type
  TAPI = class(TDSServerModule)
{$METHODINFO ON}
  private
    rows: integer;
//    function getGender(pGenderCode: string): string;
    function transmitKassInfo(DataForKassInfo: TJSONObject): TJSONObject;
    function getTableValuesForGastInfo(pParams: TJSONObject): TJSONObject;
    function LosungKellner(pLosung: TJSONObject): TJSONObject;
    function transmitArticles(pArticles: TJSONObject): TJSONObject;
    function transmitWaiter(pWaiter: TJSONObject): TJSONObject;
    function transmitJournalArchiv(pJournal: TJSONObject): TJSONObject;
    function transmitJournal(pJournal: TJSONObject): TJSONObject;
  public
    { Public-Deklarationen }
    function processesCashRegister(pCashReg: TJSONObject): TJSONObject;
    function api(pParams: TJSONObject): TJSONObject;
    function bookABill(pParams: TJSONObject): TJSONObject;
{$REGION 'MelzerX3000'}
    function getGuestInfo: TJSONObject;
    function transmitCashInfo(pParams: TJSONObject): TJSONObject;
{$ENDREGION}
{$REGION 'At-Vision'}
//    function CheckInOut(pParams: TJSONObject): TJSONObject;
//    function getReservationData(pParams: TJSONObject): TJSONObject;
    // procedure updateReservationData(pParams: TJSONObject);
{$ENDREGION}

    // function testTheConnection: TJSONObject;
{$METHODINFO OFF}
  end;

var
  sMethod: TAPI;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}
//{$R *.dfm}  // Zum compilieren muss die Zeile aktiviert werden und danach wieder auskommentiert werden da sonst die Form umgebaut wird.

uses System.StrUtils, DataModule, restFelixMainUnit, InterfaceToX3000, DMEmail,
  TempModul;

const // in this array are the used columns in the ClientMethod insertG_Info
  ListOfGastInfoColumn: Array [0 .. 6] of string = ('ZI_PERS', 'PERS_NR',
    'TERMIN_NR', 'VON', 'BIS', 'ZI_NUMMER', 'BEMERKUNG');

function TAPI.api(pParams: TJSONObject): TJSONObject;
var
  aFunctionName: string;
  aString: String;
begin
  try
    aFunctionName := pParams.GetValue<string>('FunctionName');
    rstFelixMain.WriteToColorLog('api FunctionName: ' + aFunctionName, lmtInfo);
    try
      rstFelixMain.MemoLog.Lines.Add(DateToStr(Date) + ' ' + TimeToStr(Time) +
        ' ' + DM.FUserCompanyName + ': api FunctionName: ' + aFunctionName);
    except
      //
    end;
    if aFunctionName = 'transmitKassInfo' then
    begin
      result := transmitKassInfo(pParams);
    end
    else if aFunctionName = 'getTableValuesForGastInfo' then
    begin
      // aString := getTableValuesForGastInfo(pParams);
      // result := TJSONObject.ParseJSONValue(aString) as TJSONObject;
      result := getTableValuesForGastInfo(pParams);
    end
    else if aFunctionName = 'LosungKellner' then
    begin
      result := LosungKellner(pParams);
    end
    else if aFunctionName = 'processesCashRegister' then
    begin
      result := processesCashRegister(pParams);
    end
    else if aFunctionName = 'transmitArticles' then
    begin
      result := transmitArticles(pParams);
    end
    else if aFunctionName = 'transmitWaiter' then
    begin
      result := transmitWaiter(pParams);
    end
    else if aFunctionName = 'transmitJournalArchiv' then
    begin
      result := transmitJournalArchiv(pParams);
    end
    else if aFunctionName = 'transmitJournal' then
    begin
      result := transmitJournal(pParams);
    end
    else
    begin
      // result := TJSONObject.ParseJSONValue('{"Durchgeführt": "Funktion nicht gefunden"}')
      // as TJSONObject;
    end;
  except
    on E: Exception do
    begin
      rstFelixMain.WriteToColorLog('api: ' + E.Message, lmtError);
    end;

  end;

end;

{$REGION 'At-Vision'}
// ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
// Programierung wurde gestoppt
// TODO
// JSONString mit allen Gstdaten auslesen und Gaestestamm aktulisieren
// JSONString muss von uns definiert werden
// Die QueryUpdateGaestestamm hat derzeit noch kein SQL
// procedure TAPI.updateReservationData(pParams: TJSONObject);
// var
// aUpdateReservation: TJSONArray;
// aDatabase,
// aReservID : string;
// begin
// try
// aDatabase := 'ReservDataBase'; //<-- The SectionName of the ini File
//
// DM.ConnectionFelix.ConnectionDefName := aDatabase;
// aUpdateReservation := pParams.GetValue('DataForUpdate') as TJSONArray;
// for var update in aUpdateReservation do
// begin
// aReservID := pParams.GetValue<string>('reservID');
// with QueryUpdateGaestestamm do
// begin
// Connection := DM.ConnectionFelix;
// ParamByName('pID').Value := StrToInt(aReservID);
// end;
// end;
//
// except
// on E: Exception do
// begin
// rstFelixMain.WriteToColorLog('updateReservationData: ' +
// E.Message, lmtError);
// end;
// end;
// end;

//function TAPI.getGender(pGenderCode: string): string;
//begin
//
//  if pGenderCode = 'M' then
//    result := 'male'
//  else if pGenderCode = 'W' then
//    result := 'female';
//
//end;

//function TAPI.getReservationData(pParams: TJSONObject): TJSONObject;
//var
//  aRequestObject: TJSONObject;
//  aAusweisArray: TJSONArray;
//  aDatabase, aCompName: string;
//  aReservID: integer;
//  aConnection: TFDConnection;
//  aQuery: TFDQuery;
//begin
//  try
//    if not pParams.TryGetValue<string>('PercSilenz', aCompName) then
//    begin
//      aCompName := DM.FUserCompanyName;
//      rstFelixMain.WriteToColorLog
//        ('Auslesen von CompanyName aus  JSON war nicht möglich! ', lmtWarning);
//    end
//    else
//    begin
//      if aCompName = '' then
//      begin
//        aCompName := DM.FUserCompanyName;
//        rstFelixMain.WriteToColorLog('CompanyName im JSON ist leer! ',
//          lmtWarning);
//      end;
//    end;
//    try
//      aQuery := TFDQuery.Create(nil);
//      aConnection := TFDConnection.Create(nil);
//      aConnection.ConnectionDefName := aCompName;
//      aConnection.Connected := true;
//    except
//      on E: Exception do
//      begin
//        rstFelixMain.WriteToColorLog
//          ('Error in TAPI.getReservationData/ Create Connection: ' + E.Message,
//          lmtError);
//      end;
//    end;
//    aQuery.SQL.Clear;
//    aQuery.SQL.Add('select g.*, xn.landcode as LAND from gaestestamm g ');
//    aQuery.SQL.Add('left join reservierung r on r.gastadresseid = g.id ');
//    aQuery.SQL.Add('left join xnation xn on g.nationalid = xn.id ');
//    aQuery.SQL.Add('where r.id = :pID');
//    with aQuery do
//      try
//        result := TJSONObject.Create;
//        aReservID := pParams.GetValue<integer>('reservID');
//        // aDatabase := 'ReservDataBase'; // <-- The SectionName of the ini File
//        aAusweisArray := TJSONArray.Create;
//        aRequestObject := TJSONObject.Create;
//
//        // DM.ConnectionFelix.ConnectionDefName := aDatabase;
//        Connection := aConnection;
//
//        ParamByName('preservID').Value := aReservID;
//        open;
//
//        result.AddPair('titel', FieldByName('TITEL').AsString);
//        result.AddPair('vorname', FieldByName('VORNAME').AsString);
//        result.AddPair('nachname', FieldByName('NACHNAME').AsString);
//        result.AddPair('gender', getGender(FieldByName('GESCHLECHT').AsString));
//        result.AddPair('geburtstag',
//          FormatDateTime('yyyy-mm-dd"T"hh:mm:ss.zzz"Z"',
//          FieldByName('GEBURTSTAG').AsDateTime));
//        result.AddPair('adresse', FieldByName('ADRESSE').AsString);
//        result.AddPair('stadt', FieldByName('ORT').AsString);
//        result.AddPair('land', FieldByName('LAND').AsString);
//        result.AddPair('telefon', FieldByName('TELEFON').AsString);
//        result.AddPair('e-mail', FieldByName('E-MAIL').AsString);
//
//        aRequestObject.AddPair('ausweisID', FieldByName('AusweisID').AsString);
//        aRequestObject.AddPair('ablaufdatum',
//          FormatDateTime('yyyy-mm-dd"T"hh:mm:ss.zzz"Z"',
//          FieldByName('Ablaufdatum').AsDateTime));
//        aRequestObject.AddPair('typ', FieldByName('Typ').AsString);
//        aRequestObject.AddPair('ausstellungsbehörde', FieldByName('Behörde')
//          .AsString);
//        aRequestObject.AddPair('land', FieldByName('Land').AsString);
//        aAusweisArray.Add(aRequestObject);
//
//        result.AddPair('Ausweis', aAusweisArray);
//
//      except
//        on E: Exception do
//        begin
//          rstFelixMain.WriteToColorLog('getReservationData: ' + E.Message,
//            lmtError);
//        end;
//      end;
//  finally
//    aConnection.Free;
//    aQuery.Free;
//  end;
//end;

//function TAPI.CheckInOut(pParams: TJSONObject): TJSONObject;
//var
//  aRequestObject: TJSONObject;
//  aReservations, aRequestArray: TJSONArray;
//  aReservationID: integer;
//  aIsCheckIn, aIsSaved, aIsCheckedIn: boolean;
//  aErrorString, aDatabase, aCompName: string;
//  aConnection: TFDConnection;
//begin
//  try
//    try
//      if not pParams.TryGetValue<string>('PercSilenz', aCompName) then
//      begin
//        aCompName := DM.FUserCompanyName;
//        rstFelixMain.WriteToColorLog
//          ('Auslesen von CompanyName aus  JSON war nicht möglich! ',
//          lmtWarning);
//      end
//      else
//      begin
//        if aCompName = '' then
//        begin
//          aCompName := DM.FUserCompanyName;
//          rstFelixMain.WriteToColorLog('CompanyName im JSON ist leer! ',
//            lmtWarning);
//        end;
//      end;
//      try
//        aConnection := TFDConnection.Create(nil);
//        aConnection.ConnectionDefName := aCompName;
//        aConnection.Connected := true;
//      except
//        on E: Exception do
//        begin
//          rstFelixMain.WriteToColorLog
//            ('Error in TAPI.getReservationData/ Create Connection: ' +
//            E.Message, lmtError);
//        end;
//      end;
//      // aDatabase := 'ReservDataBase'; // <-- The SectionName of the ini File
//      aRequestArray := TJSONArray.Create;
//      aRequestObject := TJSONObject.Create;
//
//      aReservations := pParams.GetValue('reservations') as TJSONArray;
//      for var reservation in aReservations do
//      begin
//        aReservationID := reservation.GetValue<integer>('reservID');
//        aIsCheckIn := reservation.GetValue<boolean>('CheckIn');
//        with DM.QueryUpdateReservierung do
//        begin
//          // aConnection.ConnectionDefName := aDatabase;
//          // DM.ConnectionFelix.Connected := true;
//          Connection := aConnection;
//          ParamByName('pID').Value := aReservationID;
//          if aIsCheckIn then
//          begin
//            ParamByName('pCheckIn').Value := 'T';
//            ParamByName('pAbgereist').Value := 'F';
//          end
//          else
//          begin
//            with DM.QueryCheckReservierung do
//            begin
//              Connection := aConnection;
//              ParamByName('pID').Value := aReservationID;
//              open;
//              aIsCheckedIn := FieldByName('CHECKIN').AsBoolean;
//              close;
//            end;
//            if aIsCheckedIn then
//            begin
//              ParamByName('pAbgereist').Value := 'T';
//              ParamByName('pCheckIn').Value := 'F';
//            end
//            else
//            begin
//              aIsSaved := FALSE;
//              rstFelixMain.WriteToColorLog
//                ('ReservierungsNummer noch nicht eingecheckt: ' +
//                IntToStr(aReservationID), lmtInfo);
//              aErrorString := 'ReservierungsNummer noch nicht eingecheckt: ' +
//                IntToStr(aReservationID);
//            end;
//          end;
//
//          if aIsCheckIn or aIsCheckedIn then
//            try
//              DM.QueryUpdateReservierung.ExecSQL;
//              aIsSaved := true;
//            except
//              on E: Exception do
//              begin
//                rstFelixMain.WriteToColorLog
//                  ('Fehler beim Speichern der Reservierung: ' +
//                  IntToStr(aReservationID) + ' | ' + E.Message, lmtError);
//                aIsSaved := FALSE;
//                aErrorString := E.Message;
//              end
//            end;
//        end;
//        if aIsSaved then
//        begin
//          aRequestObject.AddPair('reservID', IntToStr(aReservationID));
//          aRequestObject.AddPair('isSaved', 'true');
//        end
//        else
//        begin
//          aRequestObject.AddPair('reservID', IntToStr(aReservationID));
//          aRequestObject.AddPair('isSaved', 'false');
//          aRequestObject.AddPair('Error', aErrorString);
//        end;
//        aRequestArray.Add(aRequestObject);
//      end;
//    except
//      on E: Exception do
//      begin
//        rstFelixMain.WriteToColorLog('CheckInOut: ' + E.Message, lmtError);
//        aRequestObject.AddPair('reservID', IntToStr(aReservationID));
//        aRequestObject.AddPair('isSaved', 'false');
//        aRequestObject.AddPair('Error', E.Message);
//        aRequestArray.Add(aRequestObject);
//      end;
//    end;
//  finally
//    result := TJSONObject.Create;
//    result.AddPair('SavedReservations', aRequestArray);
//    aConnection.Connected := FALSE;
//    aConnection.Free;
//    // aRequestArray.Free;
//
//    // aRequestObject.Free;
//  end;
//end;

{$ENDREGION}
{$REGION 'MelzerX3000'}

function TAPI.getGuestInfo: TJSONObject;
var
  pResultArr: TJSONArray;
  aDataBase: String;
  aFirma: Integer;
begin
  try
    try
      aDataBase := DM.FUserCompanyName;
      aFirma := DM.FUserFirmaID;
      pResultArr := TJSONArray.Create;
      X3000.getGastInfo(aFirma, aDataBase, pResultArr);
    except
      on E: Exception do
      begin
        rstFelixMain.WriteToColorLog('TAPI.getGuestInfo: ' + E.Message,
          lmtError);
      end;
    end;
  finally
    result := TJSONObject.Create;
    // result := TJSONObject.ParseJSONValue('{"GuestsInfo": ' + pResultArr.ToString)
    // as TJSONObject;
    result.AddPair('GuestsInfo', pResultArr);
    rstFelixMain.WriteToColorLog(result.ToString,lmtInfo);
  end;
end;

function TAPI.transmitCashInfo(pParams: TJSONObject): TJSONObject;
var
  pResultObj: TJSONObject;
  aDataBase: String;
  aFirma: Integer;
begin
  try
    try
      aDataBase := DM.FUserCompanyName;
      aFirma := DM.FUserFirmaID;
      pResultObj := TJSONObject.Create;
      X3000.saveKassInfo(aFirma, aDataBase, pParams, pResultObj);
    except
      on E: Exception do
      begin
        rstFelixMain.WriteToColorLog('TAPI.transmitCashInfo: ' + E.Message,
          lmtError);
      end;
    end;
  finally
    result := pResultObj;
  end;
end;

{$ENDREGION}

// ***********************************************************************
// pParams: Firma as String;
// Result JsonObject Name := GASTINFO
// call the Values: GASTINFO[index].[ColumnName]
// ***********************************************************************
function TAPI.getTableValuesForGastInfo(pParams: TJSONObject): TJSONObject;
// : string;
var
  countOfField, aFirma: integer;
  strForJSON, teststring, compName: string;
  columnName: string;
  dateVon, dateBis: string;
  aConnection: TFDConnection;
  aQuery: TFDQuery;
begin
  dateVon := DateToStr(Date);
  dateBis := DateToStr(Date);
  if not pParams.TryGetValue<integer>('companyId', aFirma) then
    aFirma := 1;
  if not pParams.TryGetValue<string>('percSilenz', compName) then
  begin
    compName := DM.FUserCompanyName;
    rstFelixMain.WriteToColorLog
      ('Auslesen von CompanyName aus  JSON war nicht möglich! ', lmtWarning);
  end
  else
  begin
    if compName = '' then
    begin
      compName := DM.FUserCompanyName;
      rstFelixMain.WriteToColorLog('CompanyName im JSON ist leer! ',
        lmtWarning);
    end;
  end;
  try

    with aQuery do
      try
        try
          aQuery := TFDQuery.Create(nil);
          aQuery.SQL.Clear;
          aQuery.SQL.Add
            ('select (trim(g.nachname) || '' '' || trim(g.vorname)) as ZI_PERS, ');
          aQuery.SQL.Add
            ('r.id as PERS_NR, r.id as TERMIN_NR, r.anreisedatum as VON, r.abreisedatum as BIS, r.zimmerid as ZI_NUMMER, ');
          aQuery.SQL.Add('r.bemerkung2 as BEMERKUNG FROM reservierung r ');
          aQuery.SQL.Add
            ('left  outer join gaestestamm g on g.id = r.gastadresseid ');
          aQuery.SQL.Add
            ('left outer join Arrangement a on a.firma = r.firma AND a.id = r.arrangementid ');
          aQuery.SQL.Add
            ('left outer join room_categories rc on rc.category_number = r.kategorieid ');
          aQuery.SQL.Add('where r.firma = :Firma ');
          aQuery.SQL.Add
            ('and r.buchart in (0,1) and (r.storniert is null or  r.storniert =''F'') ');
          aQuery.SQL.Add('and r.zimmeranzahl = 1 and r.checkin = ''T'' ');
          aQuery.SQL.Add('and r.abreisedatum >= :dateToday ');
          aQuery.SQL.Add('and r.anreisedatum <= :dateToday ');
          aQuery.SQL.Add
            ('and (r.SPERRENEXTRA = ''F'' or (r.sperrenextra is null)) ');
          aQuery.SQL.Add('--and rc.short_description <> ''PSE'' ');
          aQuery.SQL.Add
            ('group by r.id, g.nachname, g.vorname, r.anreisedatum, r.abreisedatum, ');
          aQuery.SQL.Add('r.zimmerid, r.bemerkung2 order by G.Nachname');
          // rstFelixMain.WriteToColorLog ('getTableValuesForGastInfo - Connect To Database: 1', lmtInfo);
          aConnection := TFDConnection.Create(nil);
          aConnection.Params.Clear;
          aConnection.ConnectionDefName := compName;

          // rstFelixMain.WriteToColorLog ('getTableValuesForGastInfo - Connect To Database: 2', lmtInfo);
          aConnection.Connected := true;
          // rstFelixMain.WriteToColorLog ('getTableValuesForGastInfo - Connect To Database: 3', lmtInfo);
          aQuery.close;
          // rstFelixMain.WriteToColorLog ('getTableValuesForGastInfo - Connect To Database: 4', lmtInfo);
          aQuery.Connection := aConnection;
        except
          on E: Exception do
          begin
            rstFelixMain.WriteToColorLog
              ('getTableValuesForGastInfo - Create Connection: ' + E.Message,
              lmtError);
          end;
        end;
        try

          aQuery.ParamByName('Firma').AsInteger := aFirma;
          rstFelixMain.WriteToColorLog
            ('getTableValuesForGastInfo - Set Param and open: 1 ', lmtInfo);
          aQuery.ParamByName('dateToday').AsDateTime := Date;
          rstFelixMain.WriteToColorLog
            ('getTableValuesForGastInfo - Set Param and open: 2', lmtInfo);
          // DM.QueryGastInfo.Prepare;
          aQuery.open;
        except
          on E: Exception do
          begin
            rstFelixMain.WriteToColorLog
              ('getTableValuesForGastInfo - Set Param and open: ' + E.Message,
              lmtError);
            raise;
          end;
        end;
        rows := 0;
        try
          strForJSON := '{"GASTINFO":[';
          while not aQuery.EOF do
          begin
            if rows > 0 then
              strForJSON := strForJSON + ',';

            strForJSON := strForJSON + '{';
            for countOfField := 0 to (aQuery.Fields.Count - 1) do
            begin
              columnName := ListOfGastInfoColumn[countOfField];
              strForJSON := strForJSON + '"' + columnName + '": "' +
                aQuery.FieldByName(columnName).AsString + '"';
              // VarToStr(Fields[countOfField].Value) + '"';

              if countOfField < aQuery.Fields.Count - 1 then
                strForJSON := strForJSON + ',';
            end;
            strForJSON := strForJSON + '}';
            aQuery.next;
            inc(rows);
          end;
          aQuery.close;
          strForJSON := strForJSON + ']}';

        except
          on E: Exception do
          begin
            rstFelixMain.WriteToColorLog
              ('getTableValuesForGastInfo - Create Json in While Loop: ' +
              E.Message, lmtError);
          end;
        end;

        result := TJSONObject.Create;
        result := TJSONObject.ParseJSONValue(strForJSON) as TJSONObject;
        // teststring := result.ToString;
        rstFelixMain.WriteToColorLog('Values transmited: ' +
          rows.ToString, lmtInfo);
      except
        on E: Exception do
        begin
          rstFelixMain.WriteToColorLog('getTableValuesForGastInfo: ' +
            E.Message, lmtError);
        end;
      end;
  finally
    aConnection.Connected := FALSE;
    aConnection.Free;
    aQuery.Free;
  end;
end;


// ****************************************************************************
// restores the ID of all stored data records
// ****************************************************************************

function TAPI.transmitKassInfo(DataForKassInfo: TJSONObject): TJSONObject;
var
  strJSONstored_ID, objectName, pers_Nr, Log_T, aKassID, compName, aKassInfoId,
    aDateString: string;
  Preis, steuer: double;
  row, Count, arrlenght, termin_Nr, aFirma, Anzahl, aArtikelId,
    aKellnerID: integer;
  aDate, aZeit: TDateTime;
  aSumme: double;
  aKurzbezeichnung: String;
  aIsEinzelBuchung, aIsBelegNr, aFelixNAchKasse: boolean;
  DataArray: TJSONArray;
  teststring, aTischNr, aErrorString, MailOut: string;
  aErrors, aErrorId: TStrings;
  aConnection: TFDConnection;
  aTempDM: TTM;
begin
  row := 0;
  try
    if not DataForKassInfo.TryGetValue<string>('percSilenz', compName) then
    begin
      compName := DM.FUserCompanyName;
      rstFelixMain.WriteToColorLog
        ('Auslesen von CompanyName aus  JSON war nicht möglich! ', lmtWarning);
    end
    else
    begin
      if compName = '' then
      begin
        compName := DM.FUserCompanyName;
        rstFelixMain.WriteToColorLog('CompanyName im JSON ist leer! ',
          lmtWarning);
      end;
    end;
    if not DataForKassInfo.TryGetValue<integer>('companyId', aFirma) then
      aFirma := 1;
    try
      if DataForKassInfo.GetValue<string>('EinzelBuchung').ToUpper = 'TRUE' then
        aIsEinzelBuchung := true
      else if DataForKassInfo.GetValue<string>('EinzelBuchung').ToUpper = 'FALSE'
      then
        aIsEinzelBuchung := FALSE;
      if DataForKassInfo.GetValue<string>('isBelegNr').ToUpper = 'TRUE' then
        aIsBelegNr := true
      else if DataForKassInfo.GetValue<string>('isBelegNr').ToUpper = 'FALSE'
      then
        aIsBelegNr := FALSE;
      if DataForKassInfo.GetValue<string>('FelixNachKassen').ToUpper = 'TRUE'
      then
        aFelixNAchKasse := true
      else if DataForKassInfo.GetValue<string>('FelixNachKassen').ToUpper = 'FALSE'
      then
        aFelixNAchKasse := FALSE;
    except
      on E: Exception do
      begin
        rstFelixMain.WriteToColorLog
          ('Error in TAPI.transmitKassInfo/read Properties: ' + E.Message,
          lmtError);
        raise;
      end;
    end;
    try
      aErrors := TStringList.Create;
      aErrorId := TStringList.Create;
    except
      on E: Exception do
      begin
        rstFelixMain.WriteToColorLog
          ('Error in TAPI.transmitKassInfo/Create Lists: ' + E.Message,
          lmtError);
        raise;
      end;
    end;
    try
      try
        aTempDM := TTM.Create(nil);
        aConnection := TFDConnection.Create(nil);
        aConnection.Params.Clear;
        // rstFelixMain.WriteToColorLog ('transmitKassInfo/set connection: 1', lmtInfo);
        aConnection.ConnectionDefName := compName;
        // rstFelixMain.WriteToColorLog ('transmitKassInfo/set connection: 1', lmtInfo);
        aConnection.Connected := true;
        // rstFelixMain.WriteToColorLog ('transmitKassInfo/set connection: 1', lmtInfo);
        // aTempDM.QueryFelix.Connection := aConnection;
        // rstFelixMain.WriteToColorLog ('transmitKassInfo/set connection: 1', lmtInfo);
        aTempDM.insertGastkonto.Connection := aConnection;
      except
        on E: Exception do
        begin
          rstFelixMain.WriteToColorLog
            ('Error in TAPI.transmitKassInfo/set connection: ' + E.Message,
            lmtError);
          raise;
        end;
      end;
      try
        // Firma := aFirma;
        teststring := DataForKassInfo.ToString;
        DataArray := DataForKassInfo.GetValue('KASSINFO') as TJSONArray;
        arrlenght := DataArray.Count;
      except
        on E: Exception do
        begin
          rstFelixMain.WriteToColorLog
            ('Error in TAPI.transmitKassInfo/get Company and Data: ' +
            E.Message, lmtError);
          raise;
        end;
      end;
      try
        strJSONstored_ID := '{"stored_ID":[';
        for Count := 0 to arrlenght - 1 do
        begin
          pers_Nr := DataForKassInfo.GetValue<string>
            ('KASSINFO[' + Count.ToString + '].PERS_NR');
          Anzahl := (DataForKassInfo.GetValue<string>('KASSINFO[' +
            Count.ToString + '].ANZAHL')).ToInteger;
          Preis := (DataForKassInfo.GetValue<string>('KASSINFO[' +
            Count.ToString + '].PREIS')).ToDouble;
          steuer := DataForKassInfo.GetValue<string>
            ('KASSINFO[' + Count.ToString + '].STEUER').ToDouble;
          termin_Nr := DataForKassInfo.GetValue<string>
            ('KASSINFO[' + Count.ToString + '].TERMIN_NR').ToInteger;
          Log_T := DataForKassInfo.GetValue<string>('KASSINFO[' + Count.ToString
            + '].LOG_T');
          // Log_T := DataForKassInfo.GetValue<string>('KASSINFO[' + Count.ToString +
          // '].BELEGNR');
          aKassID := DataForKassInfo.GetValue<string>
            ('KASSINFO[' + Count.ToString + '].KASSEID');
          // DataForKassInfo.TryGetValue('KASSINFO[' + Count.ToString +
          // '].KELLNERNR',aKellnerID);
          aKellnerID := 1;
          DataForKassInfo.TryGetValue('KASSINFO[' + Count.ToString + '].DATUM',
            aDateString);
          aDate := StrToDate(aDateString);
          var aSummenString : String := '';
          if DataForKassInfo.TryGetValue('KASSINFO[' + Count.ToString +
            '].SUMME', aSummenString) then
            aSumme := aSummenstring.ToDouble;
          DataForKassInfo.TryGetValue('KASSINFO[' + Count.ToString +
            '].KURZBEZ', aKurzbezeichnung);
          DataForKassInfo.TryGetValue('KASSINFO[' + Count.ToString +
            '].ARTIKELID', aArtikelId);
          DataForKassInfo.TryGetValue('KASSINFO[' + Count.ToString +
            '].TischNr', aTischNr);
          aKassInfoId := DataForKassInfo.GetValue<string>
            ('KASSINFO[' + Count.ToString + '].ID');

          if aTempDM.WriteToGastkonto(aConnection, aTischNr, pers_Nr, Anzahl,
            Preis, steuer, aKellnerID, termin_Nr, aFirma, aKurzbezeichnung,
            Log_T, aIsEinzelBuchung, aIsBelegNr, compName, aFelixNAchKasse,
            strToInt(aKassID), aKassInfoId, aErrorString, aDateString) then
          begin
            if row > 0 then
              strJSONstored_ID := strJSONstored_ID + ',';

            strJSONstored_ID := strJSONstored_ID + Format('{"ID": "%s"}',
              [aKassInfoId]);
            inc(row);

          end
          else
          begin
            aTempDM.QuerySelectErrorSendDate.Connection := aConnection;
            aTempDM.QuerySelectErrorSendDate.close;
            aTempDM.QuerySelectErrorSendDate.ParamByName('ReservId').AsString :=
              IntToStr(termin_Nr);
            aTempDM.QuerySelectErrorSendDate.open;
            if not(aTempDM.QuerySelectErrorSendDate.FieldByName('Datum')
              .AsDateTime = Date) then
            begin
              aErrorId.Add(IntToStr(termin_Nr));
              aErrors.Add(aErrorString);
            end;
            aTempDM.QuerySelectErrorSendDate.close;
          end;
        end;
        strJSONstored_ID := strJSONstored_ID + ']}';
      except
        on E: Exception do
        begin
          rstFelixMain.WriteToColorLog
            ('Error in TAPI.transmitKassInfo/read Data: ' + E.Message,
            lmtError);
          raise;
        end;
      end;
      try
        result := TJSONObject.Create;
        result := TJSONObject.ParseJSONValue(strJSONstored_ID) as TJSONObject;
      except
        on E: Exception do
        begin
          rstFelixMain.WriteToColorLog
            ('Error in TAPI.transmitKassInfo/create Result: ' + E.Message,
            lmtError);
          raise;
        end;
      end;
      teststring := result.ToString;
      if aErrors.Count > 0 then
      begin
        DataEmail.SendEmail(compName, MailOut, 'Fehler bei einer Umbuchung', aErrors,
          DM.ErrorMail);
        if MailOut <> '' then
        begin
          rstFelixMain.WriteToColorLog('Error in DataEmail.SendEmail: ' +
            MailOut, lmtError);
        end
        else
        begin
          rstFelixMain.WriteToColorLog
            ('FehlerMail wurde an support@gms.info gesendet! ', lmtInfo);

          for var errorCount := 0 to aErrors.Count - 1 do
          begin
            aTempDM.QueryInsertSendetMail.Connection := aConnection;
            aTempDM.QueryInsertSendetMail.close;
            aTempDM.QueryInsertSendetMail.ParamByName('Firma').AsInteger
              := aFirma;
            aTempDM.QueryInsertSendetMail.ParamByName('ReservId').AsString :=
              aErrorId[errorCount];
            aTempDM.QueryInsertSendetMail.ParamByName('sendDay')
              .AsDateTime := Date;
            aTempDM.QueryInsertSendetMail.ParamByName('Text').AsString :=
              aErrors[errorCount];
            aTempDM.QueryInsertSendetMail.ExecSQL;
          end;
        end;
        aErrors.Free;
      end;
      // end;
    except
      on E: Exception do
      begin
        rstFelixMain.WriteToColorLog('Error in TAPI.transmitKassInfo: ' +
          E.Message, lmtError);
      end;
    end;
  finally
    aConnection.Connected := FALSE;
    aConnection.Free;
    aTempDM.Free;
  end;
end;

function TAPI.transmitJournalArchiv(pJournal: TJSONObject): TJSONObject;
var
  JournalArray: TJSONArray;
  isCorrect: boolean;
  aErrorString: string;
  KellnerId, ArtikelId, BeilagenId, Zahlwegid, TischId, JournalTyp,
    VonOffeneTischId, RechnungsId, LagerId, SyncId, BonNr, Preisebene: integer;
  Nachlass, aBetrag: double;
  Lagerdatum, compName: string;
  aConnection: TFDConnection;
  aQuery :TFDQuery;
begin
  try
    try
      isCorrect := FALSE;
      if not pJournal.TryGetValue<string>('percSilenz', compName) then
      begin
        compName := DM.FUserCompanyName;
        rstFelixMain.WriteToColorLog
          ('Auslesen von CompanyName aus  JSON war nicht möglich! ',
          lmtWarning);
      end
      else
      begin
        if compName = '' then
        begin
          compName := DM.FUserCompanyName;
          rstFelixMain.WriteToColorLog('CompanyName im JSON ist leer! ',
            lmtWarning);
        end;
      end;
      aQuery := TFDQuery.Create(nil);
      aConnection := TFDConnection.Create(nil);
      aConnection.Params.Clear;
      aConnection.ConnectionDefName := compName;
      aConnection.Connected := true;
      JournalArray := pJournal.GetValue('JournalRecords') as TJSONArray;
      aQuery.SQL.Clear;
      aQuery.SQL.Add('Update or Insert into JOURNALARCHIV (Firma, JOURNALARCHIVId, Datum, Zeit, KellnerId, Menge, Betrag, ArtikelId,'+
          ' BeilagenId, ZahlwegId, TischId, JournalTyp, Verbucht, Text, VonOffeneTischId, RechnungsId, Nachlass, Lagerverbucht, Lagerdatum, LagerId, SyncId, BonNr, Preisebene) ');
      aQuery.SQL.Add('Values(:Firma, :JOURNALARCHIVId, :Datum, :Zeit, :KellnerId, :Menge, :Betrag, :ArtikelId, :BeilagenId, :ZahlwegId,'+
          ' :TischId, :JournalTyp, :Verbucht, :Text, :VonOffeneTischId, :RechnungsId, :Nachlass, :Lagerverbucht, :Lagerdatum, :LagerId, :SyncId, :BonNr, :Preisebene) ');
      aQuery.SQL.Add('matching (Firma, JOURNALARCHIVId)');

      for var Item in JournalArray do
      begin
        with aQuery do
        begin
          close;
          Connection := aConnection;
          ParamByName('Firma').AsInteger := Item.GetValue<integer>('Firma');
          ParamByName('JOURNALARCHIVId').AsInteger :=
            Item.GetValue<integer>('JournalArchivId');
          ParamByName('Datum').AsString := Item.GetValue<string>('Datum');
          ParamByName('Zeit').AsString := Item.GetValue<String>('Zeit');
          if TryStrToInt(Item.GetValue<string>('KellnerId'), KellnerId) then
            ParamByName('KellnerId').AsInteger := KellnerId
          else
            ParamByName('KellnerId').Value := null;

          ParamByName('Menge').AsFloat := Item.GetValue<double>('Menge');
          aBetrag := Item.GetValue<double>('Betrag');
          ParamByName('Betrag').ASFloat := aBetrag;

          // rstFelixMain.WriteToColorLog('Betrag für JournalArchiv: ' + FloatTostr(aBetrag), lmtInfo);
          // rstFelixMain.WriteToColorLog('Betrag im Query für JournalArchiv: ' + FloatTostr(ParamByName('Betrag').AsFloat),
          // lmtInfo);

          if TryStrToInt(Item.GetValue<string>('ArtikelId'), ArtikelId) then
            ParamByName('ArtikelId').AsInteger := ArtikelId
          else
            ParamByName('ArtikelId').Value := null;
          if TryStrToInt(Item.GetValue<string>('BeilagenId'), BeilagenId) then
            ParamByName('BeilagenId').AsInteger := BeilagenId
          else
            ParamByName('BeilagenId').Value := null;
          if TryStrToInt(Item.GetValue<string>('ZahlwegId'), Zahlwegid) then
            ParamByName('ZahlwegId').AsInteger := Zahlwegid
          else
            ParamByName('ZahlwegId').Value := null;
          if TryStrToInt(Item.GetValue<string>('TischId'), TischId) then
            ParamByName('TischId').AsInteger := TischId
          else
            ParamByName('TischId').Value := null;
          if TryStrToInt(Item.GetValue<string>('JournalTyp'), JournalTyp) then
            ParamByName('JournalTyp').AsInteger := JournalTyp
          else
            ParamByName('JournalTyp').Value := null;
          ParamByName('Verbucht').AsString := Item.GetValue<String>('Verbucht');
          ParamByName('Text').AsString := Item.GetValue<String>('Text');
          if TryStrToInt(Item.GetValue<string>('VonOffeneTischId'),
            VonOffeneTischId) then
            ParamByName('VonOffeneTischId').AsInteger := VonOffeneTischId
          else
            ParamByName('VonOffeneTischId').Value := null;
          if TryStrToInt(Item.GetValue<string>('RechnungsId'), RechnungsId) then
            ParamByName('RechnungsId').AsInteger := RechnungsId
          else
            ParamByName('RechnungsId').Value := null;
          if TryStrToFloat(Item.GetValue<string>('Nachlass'), Nachlass) then
            ParamByName('Nachlass').AsFloat := Nachlass
          else
            ParamByName('Nachlass').Value := null;
          ParamByName('Lagerverbucht').AsString :=
            Item.GetValue<String>('Lagerverbucht');
          Lagerdatum := Item.GetValue<String>('Lagerdatum');
          if Lagerdatum = '' then
          begin
            ParamByName('Lagerdatum').Value := null;
          end
          else
          begin
            ParamByName('Lagerdatum').AsString := Lagerdatum;
          end;
          if TryStrToInt(Item.GetValue<string>('LagerId'), LagerId) then
            ParamByName('LagerId').AsInteger := LagerId
          else
            ParamByName('LagerId').Value := null;

          if TryStrToInt(Item.GetValue<string>('SyncId'), SyncId) then
            ParamByName('SyncId').AsInteger := SyncId
          else
            ParamByName('SyncId').Value := null;
          if TryStrToInt(Item.GetValue<string>('BonNr'), BonNr) then
            ParamByName('BonNr').AsInteger := BonNr
          else
            ParamByName('BonNr').Value := null;
          if TryStrToInt(Item.GetValue<string>('BonNr'), BonNr) then
            ParamByName('BonNr').AsInteger := BonNr
          else
            ParamByName('BonNr').Value := null;
          ExecSQL;
          close;
        end;
      end;
      isCorrect := true;
    except
      on E: Exception do
      begin
        rstFelixMain.WriteToColorLog('TAPI.transmitJournalArchiv: ' + E.Message,
          lmtError);
        aErrorString := E.Message;
        isCorrect := FALSE;
      end;
    end;
  finally
    result := TJSONObject.Create;
    result.AddPair('FullyTransferred', TJSONBool.Create(isCorrect));
    if not isCorrect then
      result.AddPair('Error', aErrorString);
    aConnection.Connected := FALSE;
    aConnection.Free;
    aQuery.Free;
  end;
end;

function TAPI.transmitJournal(pJournal: TJSONObject): TJSONObject;
var
  JournalArray: TJSONArray;
  isCorrect: boolean;
  aErrorString, Bankkomat: string;
  KellnerId, ArtikelId, BeilagenId, Zahlwegid, TischId, JournalTyp,
    OffeneTischId, KasseId, VonOffeneTischId, RechnungsId, LagerId, SyncId,
    BonNr, Preisebene: integer;
  Nachlass: double;
  Lagerdatum, compName: string;
  aConnection: TFDConnection;
  aQuery: TFDQuery;
begin
  try
    try
      isCorrect := FALSE;
      if not pJournal.TryGetValue<string>('percSilenz', compName) then
      begin
        compName := DM.FUserCompanyName;
        rstFelixMain.WriteToColorLog
          ('Auslesen von CompanyName aus  JSON war nicht möglich! ',
          lmtWarning);
      end
      else
      begin
        if compName = '' then
        begin
          compName := DM.FUserCompanyName;
          rstFelixMain.WriteToColorLog('CompanyName im JSON ist leer! ',
            lmtWarning);
        end;
      end;
      aQuery := TFDQuery.Create(nil);
      aConnection := TFDConnection.Create(nil);
      aConnection.Params.Clear;
      aConnection.ConnectionDefName := compName;
      aConnection.Connected := true;
      JournalArray := pJournal.GetValue('JournalRecords') as TJSONArray;
      aQuery.SQL.Clear;
      aQuery.SQL.Add
        ('Update or Insert into JOURNAL (Firma, JOURNALId, Datum, Zeit, KellnerId, KasseId, Menge, Betrag, ArtikelId,'
        + ' BeilagenId, ZahlwegId, OffeneTischId, JournalTyp, Verbucht, Text, VonOffeneTischId, RechnungsId, Nachlass, Bankomat, Lagerverbucht, Lagerdatum, LagerId, SyncId, BonNr, Preisebene)');
      aQuery.SQL.Add
        ('Values(:Firma, :JOURNALId, :Datum, :Zeit, :KellnerId, :KasseId, :Menge, :Betrag, :ArtikelId, :BeilagenId,'
        + ' :ZahlwegId, :OffeneTischId, :JournalTyp, :Verbucht, :Text, :VonOffeneTischId, :RechnungsId, :Nachlass, :Bankomat, :Lagerverbucht, :Lagerdatum, :LagerId, :SyncId, :BonNr, :Preisebene)');
      aQuery.SQL.Add('matching (Firma, JOURNALId)');
      aQuery.Connection := aConnection;
      for var Item in JournalArray do
      begin
        with aQuery do
        begin
          close;
          // Connection := aConnection;
          ParamByName('Firma').AsInteger := Item.GetValue<integer>('Firma');
          ParamByName('JOURNALId').AsInteger :=
            Item.GetValue<integer>('JournalId');
          ParamByName('Datum').AsString := Item.GetValue<string>('Datum');
          ParamByName('Zeit').AsString := Item.GetValue<String>('Zeit');
          if TryStrToInt(Item.GetValue<string>('KellnerId'), KellnerId) then
            ParamByName('KellnerId').AsInteger := KellnerId
          else
            ParamByName('KellnerId').Value := null;
          if TryStrToInt(Item.GetValue<string>('KasseId'), KasseId) then
            ParamByName('KasseId').AsInteger := KasseId
          else
            ParamByName('KasseId').Value := null;

          ParamByName('Menge').AsFloat := Item.GetValue<double>('Menge');
          ParamByName('Betrag').AsFloat := Item.GetValue<double>('Betrag');

          if TryStrToInt(Item.GetValue<string>('ArtikelId'), ArtikelId) then
            ParamByName('ArtikelId').AsInteger := ArtikelId
          else
            ParamByName('ArtikelId').Value := null;
          if TryStrToInt(Item.GetValue<string>('BeilagenId'), BeilagenId) then
            ParamByName('BeilagenId').AsInteger := BeilagenId
          else
            ParamByName('BeilagenId').Value := null;
          if TryStrToInt(Item.GetValue<string>('ZahlwegId'), Zahlwegid) then
            ParamByName('ZahlwegId').AsInteger := Zahlwegid
          else
            ParamByName('ZahlwegId').Value := null;

          if TryStrToInt(Item.GetValue<string>('OffeneTischId'), OffeneTischId)
          then
            ParamByName('OffeneTischId').AsInteger := OffeneTischId
          else
            ParamByName('OffeneTischId').Value := null;

          if TryStrToInt(Item.GetValue<string>('JournalTyp'), JournalTyp) then
            ParamByName('JournalTyp').AsInteger := JournalTyp
          else
            ParamByName('JournalTyp').Value := null;

          ParamByName('Verbucht').AsString := Item.GetValue<String>('Verbucht');

          ParamByName('Text').AsString := Item.GetValue<String>('Text');

          if TryStrToInt(Item.GetValue<string>('VonOffeneTischId'),
            VonOffeneTischId) then
            ParamByName('VonOffeneTischId').AsInteger := VonOffeneTischId
          else
            ParamByName('VonOffeneTischId').Value := null;

          if TryStrToInt(Item.GetValue<string>('RechnungsId'), RechnungsId) then
            ParamByName('RechnungsId').AsInteger := RechnungsId
          else
            ParamByName('RechnungsId').Value := null;

          if TryStrToFloat(Item.GetValue<string>('Nachlass'), Nachlass) then
            ParamByName('Nachlass').AsFloat := Nachlass
          else
            ParamByName('Nachlass').Value := null;

          ParamByName('Bankomat').AsString := Item.GetValue<string>('Bankomat');

          ParamByName('Lagerverbucht').AsString :=
            Item.GetValue<String>('Lagerverbucht');

          Lagerdatum := Item.GetValue<String>('Lagerdatum');
          if Lagerdatum = '' then
          begin
            ParamByName('Lagerdatum').Value := null;
          end
          else
          begin
            ParamByName('Lagerdatum').AsString := Lagerdatum;
          end;

          if TryStrToInt(Item.GetValue<string>('LagerId'), LagerId) then
            ParamByName('LagerId').AsInteger := LagerId
          else
            ParamByName('LagerId').Value := null;

          if TryStrToInt(Item.GetValue<string>('SyncId'), SyncId) then
            ParamByName('SyncId').AsInteger := SyncId
          else
            ParamByName('SyncId').Value := null;

          if TryStrToInt(Item.GetValue<string>('BonNr'), BonNr) then
            ParamByName('BonNr').AsInteger := BonNr
          else
            ParamByName('BonNr').Value := null;

          if TryStrToInt(Item.GetValue<string>('Preisebene'), Preisebene) then
            ParamByName('Preisebene').AsInteger := Preisebene
          else
            ParamByName('Preisebene').Value := null;
          ExecSQL;
          close;
        end;
      end;
      isCorrect := true;
    except
      on E: Exception do
      begin
        rstFelixMain.WriteToColorLog('TAPI.transmitJournalArchiv: ' + E.Message,
          lmtError);
        aErrorString := E.Message;
        isCorrect := FALSE;
      end;
    end;
  finally
    result := TJSONObject.Create;
    result.AddPair('FullyTransferred', TJSONBool.Create(isCorrect));
    if not isCorrect then
      result.AddPair('Error', aErrorString);
    aConnection.Connected := FALSE;
    aConnection.Free;
    aQuery.Free;
  end;
end;

function TAPI.transmitWaiter(pWaiter: TJSONObject): TJSONObject;
var
  WaiterArray: TJSONArray;
  isCorrect: boolean;
  aErrorString, compName: string;
  aConnection: TFDConnection;
  aQuery: TFDQuery;
begin
  try
    try
      isCorrect := FALSE;
      if not pWaiter.TryGetValue<string>('percSilenz', compName) then
      begin
        compName := DM.FUserCompanyName;
        rstFelixMain.WriteToColorLog
          ('Auslesen von CompanyName aus  JSON war nicht möglich! ',
          lmtWarning);
      end
      else
      begin
        if compName = '' then
        begin
          compName := DM.FUserCompanyName;
          rstFelixMain.WriteToColorLog('CompanyName im JSON ist leer! ',
            lmtWarning);
        end;
      end;
      try
        aQuery := TFDQuery.Create(nil);
        aConnection := TFDConnection.Create(nil);
        aConnection.Params.Clear;
        aConnection.ConnectionDefName := compName;
        aConnection.Connected := true;
      except
        on E: Exception do
        begin
          rstFelixMain.WriteToColorLog('TAPI.transmitWaiter/Create Connection: '
            + E.Message, lmtError);
        end;
      end;
      WaiterArray := pWaiter.GetValue('Waiters') as TJSONArray;
      aQuery.SQL.Clear;
      aQuery.SQL.Add
        ('Update or Insert into Kellner (Firma, KellnerId, Nachname)');
      aQuery.SQL.Add('Values(:CompanyId, :WaiterId, :Surname)');
      aQuery.SQL.Add('matching (Firma, KellnerId)');
      for var Item in WaiterArray do
      begin
        with aQuery do
        begin
          close;
          Connection := aConnection;
          ParamByName('CompanyId').AsInteger :=
            Item.GetValue<integer>('CompanyId');
          ParamByName('WaiterId').AsInteger :=
            Item.GetValue<integer>('WaiterId');
          ParamByName('Surname').AsString := Item.GetValue<string>('Surname');
          ExecSQL;
          close;
        end;
      end;
      isCorrect := true;
    except
      on E: Exception do
      begin
        rstFelixMain.WriteToColorLog('TAPI.transmitWaiter: ' + E.Message,
          lmtError);
        aErrorString := E.Message;
        isCorrect := FALSE;
      end;
    end;
  finally
    result := TJSONObject.Create;
    result.AddPair('FullyTransferred', TJSONBool.Create(isCorrect));
    if not isCorrect then
      result.AddPair('Error', aErrorString);
    aConnection.Connected := FALSE;
    aConnection.Free;
    aQuery.Free;
  end;
end;

function TAPI.transmitArticles(pArticles: TJSONObject): TJSONObject;
var
  ArticleArray: TJSONArray;
  isCorrect: boolean;
  aErrorString, compName: string;
  aConnection: TFDConnection;
  aQuery: TFDQuery;
begin
  try
    try
      isCorrect := FALSE;
      if not pArticles.TryGetValue<string>('percSilenz', compName) then
      begin
        compName := DM.FUserCompanyName;
        rstFelixMain.WriteToColorLog
          ('Auslesen von CompanyName aus  JSON war nicht möglich! ',
          lmtWarning);
      end
      else
      begin
        if compName = '' then
        begin
          compName := DM.FUserCompanyName;
          rstFelixMain.WriteToColorLog('CompanyName im JSON ist leer! ',
            lmtWarning);
        end;
      end;
      try
        aQuery := TFDQuery.Create(nil);
        aConnection := TFDConnection.Create(nil);
        aConnection.Params.Clear;
        aConnection.ConnectionDefName := compName;
        aConnection.Connected := true;
      except
        on E: Exception do
        begin
          rstFelixMain.WriteToColorLog
            ('TAPI.transmitArticles/Create Connection: ' + E.Message, lmtError);
        end;
      end;
      ArticleArray := pArticles.GetValue('Articles') as TJSONArray;
      aQuery.SQL.Clear;
      aQuery.SQL.Add
        ('Update or Insert into Artikel (Firma, ArtikelId, Bezeichnung)');
      aQuery.SQL.Add('Values(:CompanyId, :ArticleId, :Description)');
      aQuery.SQL.Add('matching (Firma, ArtikelId)');
      for var Item in ArticleArray do
      begin
        with aQuery do
        begin
          close;
          Connection := aConnection;
          ParamByName('CompanyId').AsInteger :=
            Item.GetValue<integer>('CompanyId');
          ParamByName('ArticleId').AsInteger :=
            Item.GetValue<integer>('ArticleId');
          ParamByName('Description').AsString :=
            Item.GetValue<string>('Description');
          ExecSQL;
          close;
        end;
      end;
      isCorrect := true;
    except
      on E: Exception do
      begin
        rstFelixMain.WriteToColorLog('TAPI.transmitArticles: ' + E.Message,
          lmtError);
        aErrorString := 'Fataler Datenbank Fehler';
        isCorrect := FALSE;
      end;
    end;
  finally
    result := TJSONObject.Create;
    result.AddPair('FullyTransferred', TJSONBool.Create(isCorrect));
    if not isCorrect then
      result.AddPair('Error', aErrorString);
    aConnection.Connected := FALSE;
    aConnection.Free;
    aQuery.Free;
  end;
end;

function TAPI.LosungKellner(pLosung: TJSONObject): TJSONObject;
var
  aKasseDate, aOldKasseDate, aFelixDate: TDate;
  aLosungen: TJSONArray;
  aLosungCount, aArticleID: integer;
  testStr, aFirma, aNachname, UmsatzTagString: string;
  AZahlWegID, aFelixZahlwegID, aWaiterReservID, aRechnungsId: LargeInt;
  aBetrag, aSumBetrag: double;
  compName, aCheckUmsatzTag: string;
  isCheckUmsatzTag: boolean;

  aConnection: TFDConnection;
  aTempDM: TTM;
begin
  try
    try
      if not pLosung.TryGetValue<string>('percSilenz', compName) then
      begin
        compName := DM.FUserCompanyName;
        rstFelixMain.WriteToColorLog
          ('Auslesen von CompanyName aus  JSON war nicht möglich! ',
          lmtWarning);
      end
      else
      begin
        if compName = '' then
        begin
          compName := DM.FUserCompanyName;
          rstFelixMain.WriteToColorLog('CompanyName im JSON ist leer! ',
            lmtWarning);
        end;
      end;
      if not pLosung.TryGetValue<string>('Firma', aFirma) then
        aFirma := IntToStr(1);
      try
        aTempDM := TTM.Create(nil);
        aTempDM.MainConnection.Params.Clear;
        aTempDM.MainConnection.ConnectionDefName := compName;
        aTempDM.MainConnection.Connected := true;
        aConnection := TFDConnection.Create(nil);
        aConnection.Params.Clear;
        aConnection.ConnectionDefName := compName;
        aConnection.Connected := true;
      except
        on E: Exception do
        begin
          rstFelixMain.WriteToColorLog
            ('Error in TAPI.LosungKellner/Create Connection: ' + E.Message,
            lmtError);
          raise;
        end;
      end;
      try
        result := TJSONObject.Create;
      except
        on E: Exception do
        begin
          rstFelixMain.WriteToColorLog
            ('Error in TAPI.LosungKellner/Create result Object: ' + E.Message,
            lmtError);
          raise;
        end;
      end;
      testStr := pLosung.ToString;
      isCheckUmsatzTag := FALSE;
      try
        aTempDM.TableLosungsZuordnung.Connection := aConnection;
        aTempDM.TableLosungsZuordnung.open;
      except
        on E: Exception do
        begin
          rstFelixMain.WriteToColorLog
            ('Error in TAPI.LosungKellner/TableLosungsZuordnung.open: ' +
            E.Message, lmtError);
          raise;
        end;
      end;

      try
        // aFirma := IntToStr(DM.FUserFirmaID);
        aFelixDate := aTempDM.getFelixDate(aConnection, aFirma);
      except
        on E: Exception do
        begin
          rstFelixMain.WriteToColorLog
            ('Error in TAPI.LosungKellner/get Company and Felix Date: ' +
            E.Message, lmtError);
          raise;
        end;
      end;
      begin
        aLosungen := pLosung.GetValue('LosungKellner') as TJSONArray;
//        isCheckUmsatzTag := pLosung.TryGetValue<string>('CheckUmsatzTag',
//          aCheckUmsatzTag);

//      try
//        With aDeleteQuery Do
//        Begin
//          close;
//          SQL.Clear;
//          SQL.Add('select id from Rechnung');
//          SQL.Add('WHERE VonDatum = ''' + DateToStr(aKasseDate) + ''' AND ');
//          SQL.Add('Rechnungsnummer in (0,99999) and Firma = ' + aFirma);
//          open;
//          if RecordCount > 0 then
//          begin
//            close;
//            SQL.Clear;
//            SQL.Add('DELETE FROM  Rechnungskonto');
//            SQL.Add('WHERE exists ( SELECT ID FROM RECHNUNG');
//            SQL.Add('WHERE RECHNUNG.ID = Rechnungskonto.RechnungsID AND RECHNUNG.VonDatum = '''
//              + DateToStr(aKasseDate) + ''' AND ');
//            SQL.Add('Rechnungsnummer in (0,99999) and RECHNUNG.Firma = ' +
//              aFirma + ')');
//            ExecSQL;
//            close;
//            SQL.Clear;
//            SQL.Add('DELETE FROM  Rechnungszahlweg');
//            SQL.Add('WHERE exists ( SELECT ID FROM RECHNUNG');
//            SQL.Add('WHERE RECHNUNG.ID = Rechnungszahlweg.RechnungsID AND RECHNUNG.VonDatum = '''
//              + DateToStr(aKasseDate) + ''' AND ');
//            SQL.Add('RECHNUNG.Rechnungsnummer in (0,99999) and RECHNUNG.Firma = '
//              + aFirma + ')');
//            ExecSQL;
//            close;
//            SQL.Clear;
//            SQL.Add('DELETE FROM  RechnungsMwst');
//            SQL.Add('WHERE exists ( SELECT ID FROM RECHNUNG');
//            SQL.Add('WHERE RECHNUNG.ID = RechnungsMwst.RechnungsID  AND RECHNUNG.VonDatum = '''
//              + DateToStr(aKasseDate) + ''' AND ');
//            SQL.Add('RECHNUNG.Rechnungsnummer in (0,99999) and RECHNUNG.Firma = '
//              + aFirma + ')');
//            ExecSQL;
//            close;
//            SQL.Clear;
//            SQL.Add('DELETE FROM RECHNUNG');
//            SQL.Add('WHERE VonDatum = ''' + DateToStr(aKasseDate) + ''' AND ');
//            SQL.Add('Rechnungsnummer in (0,99999) and Firma = ' + aFirma);
//            ExecSQL;
//            close;
//            SQL.Clear;
//            SQL.Add('DELETE FROM  KassenJournal');
//            SQL.Add('WHERE Datum >= ''' + DateToStr(aFelixDate-10) + ''' AND erfassungdurch = 7 AND  ');
//            SQL.Add('Text Like ''Losung ' + DateToStr(aKasseDate) +'%'' and Firma = ' + aFirma);
//            ExecSQL;
//            close;
//            SQL.Clear;
//            SQL.Add('DELETE FROM  KassenJournal');
//            SQL.Add('WHERE Datum >= ''' + DateToStr(aFelixDate-10) + ''' AND erfassungdurch = 12 AND ');
//            SQL.Add('Text Like ''Umsatz Kasse | ' + DateToStr(aKasseDate) +'%'' and Firma = ' + aFirma);
//            ExecSQL;
//          end;
//          close;
//        End; // with
//      except
//        on E: Exception do
//        begin
//          rstFelixMain.WriteToColorLog
//            ('Error in TAPI.LosungKellner/Delete Query: ' + E.Message,
//            lmtError);
//        end;
//      end;

        aTempDM.TableRechZahlweg.Connection := aConnection;
        aTempDM.TableRechZahlweg.open;
        aTempDM.TableLosungsZuordnung.Connection := aConnection;
        aTempDM.TableLosungsZuordnung.open;

//        aTempDM.TableRechnung.Connection := aConnection;
//        aTempDM.TableRechnung.open;
//        aTempDM.TableRechnung.Append;
//        aTempDM.TableRechnung.FieldByName('ID').AsInteger :=
//          aTempDM.GetGeneratorID(aConnection, 'id', 1);
//        aTempDM.TableRechnung.FieldByName('Firma').AsInteger :=
//          strToInt(aFirma);
//        aTempDM.TableRechnung.FieldByName('Datum').AsDateTime := aFelixDate;
//        aTempDM.TableRechnung.FieldByName('VonDatum').AsDateTime := aKasseDate;
//        aTempDM.TableRechnung.FieldByName('Rechnungsnummer')
//          .AsLargeInt := 0;
//        aTempDM.TableRechnung.FieldByName('Gedruckt').AsBoolean := true;
//        aTempDM.TableRechnung.FieldByName('Bezahlt').AsBoolean := true;
//        aTempDM.TableRechnung.Post;

        if (aLosungen.Count > 0) then // or isCheckUmsatzTag then
        begin
          aOldKasseDate := StrToDate(pLosung.GetValue<string>('LosungKellner[0].Datum'));
          aRechnungsId := aTempDM.CreateInvoice0(aFelixDate,aOldKasseDate, StrToInt(aFirma));
          for aLosungCount := 0 to aLosungen.Count - 1 do
          begin
            aKasseDate :=
              StrToDate(pLosung.GetValue<string>('LosungKellner[' +
              aLosungCount.ToString + '].Datum'));
            if aOldKasseDate <> aKasseDate then
            begin
              aTempDM.CreateInvoice0(aFelixDate, aKasseDate, StrToInt(aFirma));
              aOldKasseDate := aKasseDate
            end;
            aOldKasseDate := aKasseDate;

            pLosung.TryGetValue('LosungKellner[' + aLosungCount.ToString +
              '].Nachname', aNachname);



//            pLosung.TryGetValue('LosungKellner[' + aLosungCount.ToString +
//              '].Nachname', aNachname);
            AZahlWegID :=
              strToInt(pLosung.GetValue<string>('LosungKellner[' +
              aLosungCount.ToString + '].ZahlwegID'));
            aBetrag := StrToFloat(pLosung.GetValue<string>('LosungKellner[' +
              aLosungCount.ToString + '].Betrag'));
            aWaiterReservID :=
              strToInt(pLosung.GetValue<string>('LosungKellner[' +
              aLosungCount.ToString + '].WaiterReservID'));
            aKasseDate :=
              StrToDate(pLosung.GetValue<string>('LosungKellner[' +
              aLosungCount.ToString + '].Datum'));

            if aTempDM.TableLosungsZuordnung.Locate('Firma;ZahlwgIDKasse',
              VarArrayOf([aFirma, AZahlWegID]), []) or
              aTempDM.TableLosungsZuordnung.Locate('ZahlwgIDKasse',
              AZahlWegID, []) Then
              aFelixZahlwegID := aTempDM.TableLosungsZuordnung.FieldByName
                ('ZahlwgIDFelix').AsLargeInt
              // Sonst muss zumindest der 0 Kellner exestieren
            else
              aFelixZahlwegID := AZahlWegID;
            aBetrag := aBetrag;
            if (aTempDM.ReadGlobalValue(aConnection, 'GKTWaiterArticleID', '0',
              'KINTEGER') > 0) and (aFelixZahlwegID = 1) then
            begin
              if aWaiterReservID > 0 then
              begin
                aTempDM.WriteLeistungToGastKontoIB(aConnection, aFelixDate,
                  strToInt(aFirma), aWaiterReservID, 1,
                  aTempDM.ReadGlobalValue(aConnection, 'GKTWaiterArticleID', '0',
                  'KINTEGER'), 1, aBetrag, FALSE, FALSE, FALSE, FALSE,
                  'Losung ' + DateToStr(aKasseDate), '', 7, 0, aWaiterReservID,
                  null, null);
                aBetrag := 0;
              end;
            end;

            aTempDM.WriteToKassenJournal(aConnection, aFelixDate,
              'Losung ' + DateToStr(aKasseDate) + ' | ' + aNachname,
              aFelixZahlwegID, null, null, null, 7, null, aBetrag, FALSE,
              strToInt(aFirma), 1 { <-- MitarbeiterID } ,
              1 { <-- KassaID } , null);
            aTempDM.TableRechZahlweg.Append;
            aTempDM.TableRechZahlweg.FieldByName('ID').AsLargeInt :=
              aTempDM.GetGeneratorID(aConnection, 'id', 1);
            aTempDM.TableRechZahlweg.FieldByName('Firma').AsLargeInt :=
              strToInt(aFirma);
            aTempDM.TableRechZahlweg.FieldByName('Datum').AsDateTime :=
              aFelixDate;
            aTempDM.TableRechZahlweg.FieldByName('RechnungsID').AsLargeInt :=
              aRechnungsId;
            aTempDM.TableRechZahlweg.FieldByName('Zahlwegid').AsLargeInt :=
              aFelixZahlwegID;
            aTempDM.TableRechZahlweg.FieldByName('Verbucht').AsBoolean := true;
            aTempDM.TableRechZahlweg.FieldByName('Betrag').AsFloat := aBetrag;
            aSumBetrag := aSumBetrag + aBetrag;
            aTempDM.TableRechZahlweg.Post;

            aTempDM.TableZahlweg.Connection := aConnection;
            aTempDM.TableZahlweg.open;
            if aTempDM.TableZahlweg.Locate('Firma;ID;KreditKarte',
              VarArrayOf([aFirma, AZahlWegID, 'T']), []) then
            begin
              aTempDM.InsertKreditOffen(aConnection, strToInt(aFirma), aBetrag,
                AZahlWegID, aFelixDate, 0, aWaiterReservID);
            end;
            aTempDM.TableZahlweg.close;

            if (aLosungen.Count > 0) then
            begin
              aTempDM.TableRechnung.Edit;
              aTempDM.TableRechnung.FieldByName('ZahlungsBetrag').AsFloat :=
                aSumBetrag;
              aTempDM.TableRechnung.FieldByName('BereitsBezahlt').AsFloat :=
                aSumBetrag;
              aTempDM.TableRechnung.Post;
            end
            else
            begin
              // es war gar keine Barlosung an dem tag!
              aTempDM.TableRechZahlweg.Append;
              aTempDM.TableRechZahlweg.FieldByName('Firma').AsLargeInt :=
                strToInt(aFirma);
              aTempDM.TableRechZahlweg.FieldByName('Datum').AsDateTime :=
                aFelixDate;
              aTempDM.TableRechZahlweg.FieldByName('RechnungsID').AsLargeInt :=
                aRechnungsId;
              aTempDM.TableRechZahlweg.FieldByName('Zahlwegid').AsLargeInt := 1;
              aTempDM.TableRechZahlweg.FieldByName('Verbucht')
                .AsBoolean := true;
              aTempDM.TableRechZahlweg.FieldByName('Betrag').AsFloat := 0;
              aTempDM.TableRechZahlweg.Post;

              aTempDM.TableRechnung.Edit;
              aTempDM.TableRechnung.FieldByName('ZahlungsBetrag').AsFloat := 0;
              aTempDM.TableRechnung.FieldByName('BereitsBezahlt').AsFloat := 0;
              aTempDM.TableRechnung.Post;
            end;
          end;
          result := TJSONObject.ParseJSONValue('{"Durchgeführt": "TRUE"}')
            as TJSONObject;
        end;
      end
    except
      on E: Exception do
      begin
        rstFelixMain.WriteToColorLog('Error in TAPI.LosungKellner: ' +
          E.Message, lmtError);
        result := TJSONObject.ParseJSONValue('{"Durchgeführt": "' + E.Message +
          '"}') as TJSONObject;
      end;
    end;
  finally
    aTempDM.TableLosungsZuordnung.close;
    aTempDM.TableRechZahlweg.close;
    aTempDM.TableRechnung.close;
    aConnection.Connected := FALSE;
    aConnection.Free;
    aTempDM.Free;
  end;

end;

function TAPI.processesCashRegister(pCashReg: TJSONObject): TJSONObject;
var
  aCashValues: TJSONArray;
  aCCount, aLeistungsID: integer;
  isWritten: boolean;
  aFirma, aKasseID, aHauptGruppeID, aLeistungsBezeichnung, aBetrag, aMitArbID,
    compName, JStr, aResultBuchUmsatz, aDateString, aAmountString: string;
  aUmsatzDatum, aFelixDate: TDate;
  aConnection: TFDConnection;
  aTempDM: TTM;
  aError: TStrings;
  aMailOut: string;
  aRechId : Int64;
  procedure BucheUmsatz(pBetrag: Currency);
    var aTempQuery : TFDQuery;
      aIsDoubleBooking : Boolean;
  begin
    aError := TStringList.Create;
    aIsDoubleBooking := False;
    with aTempDM.QueryLookForDoubleBooking do
    begin
      Close;
      ParamByName('CompanyId').AsString := aFirma;
      ParamByName('CashDeskId').ASString := aKasseID;
      ParamByName('FelixDate').ASDate := aFelixDate;
      ParamByName('Ammount').AsFloat := pBetrag;
      ParamByName('Text').AsString := 'Umsatz Kasse | ' + DateToStr(aUmsatzDatum);
      open;
      aISDoubleBooking :=  not FieldByName('id').isNull;
      if aISDoubleBooking then
        rstFelixMain.WriteToColorLog
          ('Doppelbuchung abgefangen! ',
          lmtWarning);
    end;
    if not aISDoubleBooking then
    begin
      begin
        aTempDM.WriteToKassenJournal(aConnection, aFelixDate,
          'Umsatz Kasse | ' + DateToStr(aUmsatzDatum), null, 1, aLeistungsID,
          null, 12, null, pBetrag, FALSE, strToInt(aFirma), 1,
          strToInt(aKasseID), null);
      end;
      try
        aTempQuery := TFDQuery.Create(nil);
        aTempQuery.Connection := aConnection;
        aTempQuery.SQL.Add('select id from Rechnung where VonDatum = ''' + DateToStr(aUmsatzDatum) + ''' ');
        aTempQuery.SQL.Add(' and Rechnungsnummer in (0,99999)');
        aTempQuery.open;
        if aTempQuery.RecordCount > 0 then
          aRechId := StrToInt64(aTempQuery.FieldByName('id').AsString)
        else
        begin
          aRechId := aTempDM.CreateInvoice0(aFelixDate, aUmsatzDatum, StrToInt(aFirma));
        end;
          aTempDM.WriteToTableRechnungskonto(strToInt(aFirma),
            aLeistungsID, 1, pBetrag, aRechId, aFelixDate, aLeistungsBezeichnung);

      finally
        aTempDM.TableRechnung.close;
        aTempQuery.Close;
      end;

      try
        try
        //Nun die Umbuchungen Minus auf die Rechnung schreiben
          With aTempDM.QueryFelix Do
          Begin
            Close;
            SQL.Clear;
            SQL.Add('select sum(menge*betrag) AS Betrag, sum(menge) AS Menge, leistungsid FROM  KassenJournal');
            SQL.Add('WHERE Datum = '''+DateToStr(aUmsatzDatum)+''' AND');
            SQL.Add('BearbeiterID IS NULL AND Firma = '+aFirma);
            SQL.Add('AND LeistungsID IN');
            SQL.Add('(SELECT LeistungsID FROM Kass_Tischzuordnung)');
            SQL.Add('GROUP BY LeistungsID');
            Open;
            while not EOF do
              begin
                aTempDM.WriteToTableRechnungskonto(strToInt(aFirma),
                  aLeistungsID,
                  aTempDM.QueryFelix.FieldByName('Menge').AsLargeInt,
                  -aTempDM.QueryFelix.FieldByName('Betrag').AsFloat,
                  aRechId, aFelixDate, aLeistungsBezeichnung);
                Next;
              end;

          end;
        except on e : exception do
          begin
             aError.Add('BucheUmsatz: Fehler bei update Rechnungskonto | LeistungsId: '
              + IntToStr(aLeistungsID)+ 'Betrag: '+ '-'+aTempDM.QueryFelix.FieldByName('Betrag').AsString);
            rstFelixMain.WriteToColorLog
              ('BucheUmsatz: Fehler bei update Rechnungskonto | LeistungsId: '
              + IntToStr(aLeistungsID)+ 'Betrag: '+ '-'+aTempDM.QueryFelix.FieldByName('Betrag').AsString
              + ' Meldung: ' +e.Message, lmtInfo);
          end;
        end;
      finally
//        aTempDM.TableRechnungskonto.Close;
        aTempDM.QueryFelix.Close;
      end;
      try
        try
          With aTempDM.QueryFelix Do
          Begin
            Close;
            SQL.Clear;
            SQL.Add('UPDATE KassenJournal');
            SQL.Add('SET Menge = 0');
            SQL.Add('WHERE Datum = '''+DateToStr(aUmsatzDatum)+''' AND');
            SQL.Add('BearbeiterID IS NULL AND Firma = '+aFirma);
            SQL.Add('AND LeistungsID IN');
            SQL.Add('(SELECT LeistungsID FROM Kass_Tischzuordnung)');
            ExecSQL;
          End;  // with

        except on e : exception do
          begin
             aError.Add('BucheUmsatz: Fehler bei UPDATE KassenJournal | Bitte Prüfen Umsatzdatum : '+DateToStr(aUmsatzDatum)
             + 'Firma: '+ aFirma);
            rstFelixMain.WriteToColorLog
              ('BucheUmsatz: Fehler bei UPDATE KassenJournal | Bitte Prüfen Umsatzdatum : '+DateToStr(aUmsatzDatum)
                  + 'Firma: '+ aFirma + ' Meldung: ' +e.Message, lmtInfo);
          end;
        end;
      finally
        aTempDM.QueryFelix.Close;
      end;
    end;
  end;

begin

  // *************************************************************
  // If no KassaID is passed then always 1 because no access
  // to the currently logged in ID
  // If no Firma is passed then always 1
  // *************************************************************
  try
    try
      if not (pCashReg.TryGetValue<string>('percSilenz', compName))
      and not (pCashReg.TryGetValue<string>('PercSilenz', compName))then
      begin
        compName := DM.FUserCompanyName;
        rstFelixMain.WriteToColorLog
          ('Auslesen von CompanyName aus  JSON war nicht möglich! ',
          lmtWarning);
      end
      else
      begin
        if compName = '' then
        begin
          compName := DM.FUserCompanyName;
          rstFelixMain.WriteToColorLog('CompanyName im JSON ist leer! ',
            lmtWarning);
        end;
      end;
      if not pCashReg.TryGetValue<string>('companyId', aFirma) then
         aFirma := IntToStr(DM.FUserFirmaID);
       if aFirma = '' then
       aFirma := '1';

      result := TJSONObject.Create;
      try
        aTempDM := TTM.Create(nil);
        aConnection := TFDConnection.Create(nil);
        aTempDM.MainConnection.Close;
        aTempDM.MainConnection.Params.Clear;
        aTempDM.MainConnection.ConnectionDefName := compName;
        aTempDM.MainConnection.Connected := true;
        aConnection.Params.Clear;
        aConnection.ConnectionDefName := compName;
        aConnection.Connected := true;
      except
        on E: Exception do
        begin
          rstFelixMain.WriteToColorLog
            ('Error in TAPI.processesCashRegister/Create Connection: ' +
            E.Message, lmtError);
          raise;
        end;
      end;
        rstFelixMain.WriteToColorLog
            ('JsonString'+ pCashReg.ToJSON, lmtInfo);
      aCashValues := pCashReg.GetValue('allValues') as TJSONArray;
      aFelixDate := aTempDM.getFelixDate(aConnection, aFirma);
      aTempDM.TableUmsatzzuordnung.Connection := aConnection;
      aTempDM.TableUmsatzzuordnung.open;
      isWritten := FALSE;
      for aCCount := 0 to aCashValues.Count - 1 do
      begin
        pCashReg.TryGetValue('allValues[' + IntToStr(aCCount) + '].mainGroupID',
          aHauptGruppeID);
        if pCashReg.TryGetValue('allValues[' + IntToStr(aCCount) + '].amount',
          aAmountString) then
        begin
          aBetrag := (StringReplace(aAmountString, '.', ',', [rfReplaceAll]));
        end;
        pCashReg.TryGetValue('allValues[' + IntToStr(aCCount) + '].waiterID',
          aMitArbID);
        if pCashReg.TryGetValue('allValues[' + IntToStr(aCCount) + '].date',
          aDateString) then
          aUmsatzDatum := StrToDate(aDateString);
        aKasseID := '';
        pCashReg.TryGetValue('allValues[' + IntToStr(aCCount) + '].cashDeskID',
          aKasseID);
        if aKasseID <> '' then
        begin
          aLeistungsID := aTempDM.getLeistungsID1(aConnection, strToInt(aFirma),
            strToInt(aKasseID), aHauptGruppeID);
        end
        else
        begin
          aLeistungsID := aTempDM.getLeistungsID1(aConnection, strToInt(aFirma),
            0, aHauptGruppeID);
          aKasseID := '1';
        end;

        aTempDM.SetQueryLeistung(aConnection, strToInt(aFirma), aLeistungsID);
        aLeistungsBezeichnung := aTempDM.QueryLeistung.FieldByName
          ('LeistungsBezeichnung').AsString;
         aTempDM.QueryLeistung.Close;
        BucheUmsatz(StrToFloat(aBetrag));

        isWritten := true;
      end;

      aTempDM.TableUmsatzzuordnung.close;
      // ''''''''''''''''''''''''''''''''
      aTempDM.getRebookings(aConnection, aUmsatzDatum, aFirma);
      aTempDM.setAllRebookingsToNull(aConnection, aUmsatzDatum, aFirma);
      // ''''''''''''''''''''''''''''''''''
      if not isWritten then
      begin
        // pResultStr := '{"result": "Es waren keine Einträge vorhanden' + aResultBuchUmsatz + '"}';
        result.AddPair('result', 'Es waren keine Einträge vorhanden ' +
          aResultBuchUmsatz);

      end
      else
      begin
        // pResultStr := '{"result": "Umsatz wurde übertragen' + aResultBuchUmsatz + '"}';
        result.AddPair('result', 'Umsatz wurde übertragen ' +
          aResultBuchUmsatz);
      end;

    except
      on E: Exception do
      begin
        rstFelixMain.WriteToColorLog('Fehler in UmsatzKassa: ' + E.Message,
          lmtError);
        result.AddPair('result', 'error: ' + E.Message + aResultBuchUmsatz);
      end;
    end;
  finally
    if aError.Count > 0 then
    begin
      DataEmail.SendEmail(compName, aMailOut, 'Fehler bei einer Umsatzübermittlung', aError,
        DM.ErrorMail);
      if aMailOut <> '' then
      begin
        rstFelixMain.WriteToColorLog('Error in DataEmail.SendEmail: ' +
          aMailOut, lmtError);
      end
      else
      begin
        rstFelixMain.WriteToColorLog
          ('FehlerMail wurde an ' + DM.ErrorMail + ' gesendet! ', lmtInfo);
      end;
    end;
    aConnection.Connected := FALSE;
    aConnection.Free;
    aTempDM.Free;
    aError.Free;
  end;

end;

function TAPI.bookABill(pParams: TJSONObject): TJSONObject;
var
  aDeskNr, aText, aTimeString, aResultString, aBillId, aArticleID,
    aCompName: string;
  aTime: TTime;
  aAmount, aTax: double;
  aWaiterId, aPaymentMethodId, aQuantity, aFirma: integer;
  aIsBooked: boolean;
  aDataArray, aResultArray, aAtricleArray: TJSONArray;
  aResultObject: TJSONObject;
  aConnection: TFDConnection;
  aTempDM: TTM;
begin
  try
    try
      rstFelixMain.WriteToColorLog('bookABill: '+pParams.ToJson,
          lmtInfo);
      if not pParams.TryGetValue<string>('percSilenz', aCompName) then
      begin
        aCompName := DM.FUserCompanyName;
        rstFelixMain.WriteToColorLog
          ('Auslesen von CompanyName aus  JSON war nicht möglich! ',
          lmtWarning);
      end
      else
      begin
        if aCompName = '' then
        begin
          aCompName := DM.FUserCompanyName;
          rstFelixMain.WriteToColorLog('CompanyName im JSON ist leer! ',
            lmtWarning);
        end;
      end;
      if not pParams.TryGetValue<integer>('companyId', aFirma) then
      begin
        aFirma := 1;
      end;
      // aCompName := DM.FUserCompanyName;
      aIsBooked := FALSE;
      try
        aTempDM := TTM.Create(nil);
        aConnection := TFDConnection.Create(nil);
        aConnection.ConnectionDefName := aCompName;
        aConnection.Connected := true;
      except
        on E: Exception do
        begin
          rstFelixMain.WriteToColorLog
            ('Error in TAPI.bookABill/Create Connection: ' + E.Message,
            lmtError);
          raise;
        end;
      end;
      aResultArray := TJSONArray.Create;
      aDataArray := pParams.GetValue('bookInfo') as TJSONArray;
      for var Item in aDataArray do
      begin
        aIsBooked := FALSE;
        aBillId := Item.GetValue<string>('billId');
        if not Item.TryGetValue<string>('deskNumber', aDeskNr) then
          aDeskNr := '1';
        if Item.TryGetValue<string>('time', aTimeString) then
          aTime := StrToTime(aTimeString)
        else
          aTime := StrToTime('00:00:00');

        if not Item.TryGetValue<integer>('waiterId', aWaiterId) then
          aWaiterId := 1;
        if not Item.TryGetValue<integer>('paymentMethodId', aPaymentMethodId)
        then
          aPaymentMethodId := 1;
        Item.TryGetValue('text', aText);
        aText := aText +aBillId;
        aTax := (StringReplace(Item.GetValue<string>('taxRate'), '.', ',',
          [rfReplaceAll])).ToDouble;
        aAmount := (StringReplace(Item.GetValue<string>('amount'), '.', ',',
          [rfReplaceAll])).ToDouble;
        aResultObject := TJSONObject.Create;
        aIsBooked := aTempDM.WriteToGastkontoRechnung(aConnection, aDeskNr,
          aTime, aAmount, aTax, aWaiterId, aPaymentMethodId, aText, aFirma,
          aResultString);
        if aIsBooked then
        begin
          aResultObject.AddPair('billId', aBillId);
          aResultObject.AddPair('booked', 'true');
        end
        else
        begin
          aResultObject.AddPair('billId', aBillId);
          aResultObject.AddPair('booked', 'false');
          aResultObject.AddPair('error', aResultString);
        end;
        aResultArray.AddElement(aResultObject);
      end;
      result := TJSONObject.ParseJSONValue('{"value": ' + aResultArray.ToJSON +
        '}') as TJSONObject;
    except
      on E: Exception do
      begin
        rstFelixMain.WriteToColorLog('Error in TAPI.bookABill: ' + E.Message,
          lmtError);
        aResultObject := TJSONObject.Create;
        aResultObject.AddPair('billId', aBillId);
        aResultObject.AddPair('booked', 'false');
        aResultObject.AddPair('error', E.Message);
        result := TJSONObject.ParseJSONValue('{"value":' + aResultObject.ToJSON
          + '}') as TJSONObject;
      end;
    end;
  finally
    aConnection.Connected := FALSE;
    aConnection.Free;
    aTempDM.Free;
  end;

end;

end.

end.
