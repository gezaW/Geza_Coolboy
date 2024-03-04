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
    function getEvents(pParams: TJSONObject): TJSONObject;
    function getReservationData(pParams: TJSONObject): TJSONObject;
    function setOrgOrTeiln(pParams: TJSONObject): TJSONObject;
    function setReservState(pParams: TJSONObject): TJSONObject;
    function getReservArtcles(pParams: TJSONObject): TJSONObject;
    function setVeranstaltung(pParams: TJSONObject): TJSONObject;
    function getUiCodes: TJSONObject;
{$REGION 'MelzerX3000'}
    function getGuestInfo: TJSONObject;
    function transmitCashInfo(pParams: TJSONObject): TJSONObject;
{$ENDREGION}

{$METHODINFO OFF}
  end;

var
  sMethod: TAPI;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}
{$R *.dfm}  // Zum compilieren muss die Zeile aktiviert werden und danach wieder auskommentiert werden da sonst die Form umgebaut wird.

uses System.StrUtils, DataModule, restFelixMainUnit, InterfaceToX3000, DMEmail,
  TempModul, OEBBUnit;

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

{$Region 'OEBB'}

function TAPI.setOrgOrTeiln(pParams: TJSONObject): TJSONObject;
var
  pResultArr: TJSONArray;
  aDataBase, aMessage: String;
  aFirma: Integer;
  aHaveValues: boolean;
begin
  try
    try
      rstFelixMain.WriteToColorLog('TAPI.setOrgOrTeiln: ' + pParams.ToJson,
          lmtInfo);
      aHaveValues := False;
      aDataBase := DM.FUserCompanyName;
      aFirma := DM.FUserFirmaID;
      pResultArr := TJSONArray.Create;
      aHaveValues := OEBB.setOrgOrTeiln(aDataBase, pParams, pResultArr);
    except
      on E: Exception do
      begin
        aHaveValues := FALSE;
        rstFelixMain.WriteToColorLog('TAPI.setOrgOrTeiln: ' + E.Message,
          lmtError);
        aMessage := E.Message;
      end;
    end;
  finally
    result := TJSONObject.Create;
    result.AddPair('success', TJSONBool.Create(aHaveValues));
    rstFelixMain.WriteToColorLog(result.ToString,lmtInfo);
  end;

end;

function TAPI.setVeranstaltung(pParams: TJSONObject): TJSONObject;
var
  pResultArr: TJSONArray;
  aDataBase, aMessage: String;
  aFirma: Integer;
  aHaveValues: boolean;
begin
  try
    try
      rstFelixMain.WriteToColorLog('TAPI.setVeranstaltung: ' + pParams.ToJson,
          lmtInfo);
      aHaveValues := False;
      aDataBase := DM.FUserCompanyName;
      aFirma := DM.FUserFirmaID;
      pResultArr := TJSONArray.Create;
      aHaveValues := OEBB.setVeranstaltung(aDataBase, pParams, pResultArr);
    except
      on E: Exception do
      begin
        aHaveValues := FALSE;
        rstFelixMain.WriteToColorLog('TAPI.setVeranstaltung: ' + E.Message,
          lmtError);
        aMessage := E.Message;
      end;
    end;
  finally
    result := TJSONObject.Create;
    result.AddPair('success', TJSONBool.Create(aHaveValues));
    rstFelixMain.WriteToColorLog(result.ToString,lmtInfo);
  end;

end;

function TAPI.getEvents(pParams: TJSONObject): TJSONObject;
var
  pResultArr: TJSONArray;
  aDataBase, aMessage: String;
  aFirma: Integer;
  aHaveValues: boolean;
begin
  try
    try
      rstFelixMain.WriteToColorLog('TAPI.getEvents: ' + pParams.ToJson,
          lmtInfo);
      aHaveValues := False;
      aDataBase := DM.FUserCompanyName;
      aFirma := DM.FUserFirmaID;
      pResultArr := TJSONArray.Create;
      aHaveValues := OEBB.getEvents(aDataBase, pParams, pResultArr, aMessage);
      if not aHaveValues then
      begin
        aMessage := 'Keine Daten Vorhanden';
      end;
    except
      on E: Exception do
      begin
        aHaveValues := FALSE;
        rstFelixMain.WriteToColorLog('TAPI.getEvents: ' + E.Message,
          lmtError);
        aMessage := E.Message;
      end;
    end;
  finally
    result := TJSONObject.Create;
    result.AddPair('success', TJSONBool.Create(aHaveValues));
    if aHaveValues then
    begin
      result.AddPair('Events', pResultArr);
    end
    else
    begin
      result.AddPair('message', aMessage);
    end;
    rstFelixMain.WriteToColorLog(result.ToString,lmtInfo);
  end;
end;

function TAPI.getUiCodes: TJSONObject;
var
  pResultArr: TJSONArray;
  aDataBase, aMessage: String;
  aFirma: Integer;
  aHaveValues : Boolean;
begin
  try
    try
      rstFelixMain.WriteToColorLog('TAPI.getUiCodes ... ',
          lmtInfo);
      aDataBase := DM.FUserCompanyName;
      aFirma := DM.FUserFirmaID;
      pResultArr := TJSONArray.Create;
      aHaveValues := OEBB.getUIDs(aDataBase,aFirma, pResultArr, aMessage);
      if not aHaveValues then
      begin
        aMessage := 'Keine Daten Vorhanden';
      end;
     except
      on E: Exception do
      begin
        aHaveValues := FALSE;
        rstFelixMain.WriteToColorLog('TAPI.getUiCodes: ' + E.Message,
          lmtError);
        aMessage := E.Message;
      end;
    end;
  finally
    result := TJSONObject.Create;
    result.AddPair('success', TJSONBool.Create(aHaveValues));
    if aHaveValues then
    begin
      result.AddPair('codedata', pResultArr);
    end
    else
    begin
      result.AddPair('message', aMessage);
    end;
    rstFelixMain.WriteToColorLog(result.ToString,lmtInfo);
  end;
end;


function TAPI.getReservArtcles(pParams: TJSONObject): TJSONObject;
var
  pResultArr: TJSONArray;
  aDataBase, aMessage: String;
  aFirma: Integer;
  aHaveValues : Boolean;
begin
  try
    try
      rstFelixMain.WriteToColorLog('TAPI.getReservArtcles for '+pParams.ToString,
          lmtInfo);
      aDataBase := DM.FUserCompanyName;
      aFirma := DM.FUserFirmaID;
      pResultArr := TJSONArray.Create;
      aHaveValues := OEBB.getReservArticle(aDataBase,pParams,aFirma, pResultArr, aMessage);
      if not aHaveValues then
      begin
        aMessage := 'Keine Daten Vorhanden';
      end;
     except
      on E: Exception do
      begin
        aHaveValues := FALSE;
        rstFelixMain.WriteToColorLog('TAPI.getReservArtcles: ' + E.Message,
          lmtError);
        aMessage := E.Message;
      end;
    end;
  finally
    result := TJSONObject.Create;
    result.AddPair('success', TJSONBool.Create(aHaveValues));
    if aHaveValues then
    begin
      result.AddPair('arrangements', pResultArr);
    end
    else
    begin
      result.AddPair('message', aMessage);
    end;
    rstFelixMain.WriteToColorLog(result.ToString,lmtInfo);
  end;
end;

function TAPI.getReservationData(pParams: TJSONObject): TJSONObject;
var
  pResultArr: TJSONArray;
  aDataBase: String;
  aFirma: Integer;
begin
  try
    try
      rstFelixMain.WriteToColorLog('TAPI.getReservationData: ' + pParams.ToJson,
          lmtInfo);
      aDataBase := DM.FUserCompanyName;
      aFirma := DM.FUserFirmaID;
      pResultArr := TJSONArray.Create;
      OEBB.getReservData(aDataBase, pParams, pResultArr);
    except
      on E: Exception do
      begin
        rstFelixMain.WriteToColorLog('TAPI.getReservationData: ' + E.Message,
          lmtError);
      end;
    end;
  finally
    result := TJSONObject.Create;
    result.AddPair('reservationData', pResultArr);
    rstFelixMain.WriteToColorLog(result.ToString,lmtInfo);
  end;

end;

function TAPI.setReservState(pParams: TJSONObject): TJSONObject;
var
  aDataBase: String;
  aFirma: Integer;
begin
  try
    try
      rstFelixMain.WriteToColorLog('TAPI.setReservState: ' + pParams.ToJson,
          lmtInfo);
      aDataBase := DM.FUserCompanyName;
      aFirma := DM.FUserFirmaID;
      result := TJSONObject.Create;
      OEBB.setReservState(aDataBase, pParams, result);
    except
      on E: Exception do
      begin
        rstFelixMain.WriteToColorLog('TAPI.setReservState: ' + E.Message,
          lmtError);
      end;
    end;
  finally
    rstFelixMain.WriteToColorLog(result.ToString,lmtInfo);
  end;

end;
{$Endregion}

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
          aConnection := TFDConnection.Create(nil);
          aConnection.Params.Clear;
          aConnection.ConnectionDefName := compName;

          aConnection.Connected := true;
          aQuery.close;
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
        aConnection.ConnectionDefName := compName;
        aConnection.Connected := true;
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
          aKassID := DataForKassInfo.GetValue<string>
            ('KASSINFO[' + Count.ToString + '].KASSEID');
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
            strToInt(aKassID), aKassInfoId, aErrorString, aDateString, False) then
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
      rstFelixMain.WriteToColorLog('JournalArchiv String: '+ pJournal.ToString,
              lmtInfo);
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

        end;
      end;
      rstFelixMain.WriteToColorLog('CompanyName im JSON ist leer! ',
            lmtWarning);
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
        rstFelixMain.WriteToColorLog('TAPI.transmitJournal: ' + E.Message,
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
      rstFelixMain.WriteToColorLog(pLosung.ToJSON, lmtInfo);
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

        aTempDM.TableRechZahlweg.Connection := aConnection;
        aTempDM.TableRechZahlweg.open;
        aTempDM.TableLosungsZuordnung.Connection := aConnection;
        aTempDM.TableLosungsZuordnung.open;

        if (aLosungen.Count > 0) then
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
              aRechnungsId := aTempDM.CreateInvoice0(aFelixDate, aKasseDate, StrToInt(aFirma));
              aOldKasseDate := aKasseDate
            end;
            aOldKasseDate := aKasseDate;

            pLosung.TryGetValue('LosungKellner[' + aLosungCount.ToString +
              '].Nachname', aNachname);

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
    rstFelixMain.WriteToColorLog('LosungKellner result: ' +
          result.ToString, lmtInfo);
  end;

end;

function TAPI.processesCashRegister(pCashReg: TJSONObject): TJSONObject;
var
  aCashValues: TJSONArray;
  aLeistungsID: integer;
  isWritten, isBackBooking: boolean;
  aFirma, aKasseID, aHauptGruppeID, aLeistungsBezeichnung, aBetrag, aMitArbID,
    compName, JStr, aResultBuchUmsatz, aDateString, aAmountString: string;
  aUmsatzDatum, aFelixDate: TDate;
  aConnection: TFDConnection;
  aTempDM: TTM;
  aError: TStrings;
  aMailOut: string;
  aRechId : Int64;
  aRechQuery  : TFDQuery;
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
        rstFelixMain.WriteToColorLog('Doppelbuchung abgefangen! ',lmtWarning);
    end;
    if not aISDoubleBooking then
    begin

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

        begin
          aTempDM.WriteToKassenJournal(aConnection, aFelixDate,
            'Umsatz Kasse | ' + DateToStr(aUmsatzDatum), null, 1, aLeistungsID,
            null, 12, null, pBetrag, FALSE, strToInt(aFirma), 1,
            strToInt(aKasseID), null);
        end;

        if pBetrag <> 0 then
          aTempDM.WriteToTableRechnungskonto(strToInt(aFirma),
            aLeistungsID, 1, pBetrag, aRechId, aFelixDate, aLeistungsBezeichnung);

      finally
        aTempDM.TableRechnung.close;
        aTempQuery.Close;
        aTempQuery.Free;
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
      aRechId := 0;
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

      rstFelixMain.WriteToColorLog('processesCashRegister: '+ pCashReg.ToJSON, lmtInfo);
      aCashValues := pCashReg.GetValue('allValues') as TJSONArray;
      aFelixDate := aTempDM.getFelixDate(aConnection, aFirma);
      aTempDM.TableUmsatzzuordnung.Connection := aConnection;
      aTempDM.TableUmsatzzuordnung.open;
      isWritten := FALSE;
      for var aCCount in aCashValues do
      begin

        aCCount.TryGetValue('mainGroupID',aHauptGruppeID);
        if aCCount.TryGetValue('amount', aAmountString) then
          aBetrag := (StringReplace(aAmountString, '.', ',', [rfReplaceAll]))
        else
          aBetrag := '0';
        aCCount.TryGetValue('waiterID', aMitArbID);
        if aCCount.TryGetValue('date', aDateString) then
          aUmsatzDatum := StrToDate(aDateString);
        if not pCashReg.TryGetValue('cashDeskID', aKasseID) then
          aKasseID := '';
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

        aTempDM.SetQueryLeistung(strToInt(aFirma), aLeistungsID, aLeistungsBezeichnung);
         aTempDM.QueryLeistung.Close;
        BucheUmsatz(StrToFloat(aBetrag));

        isWritten := true;
      end;
      isBackBooking := FALSE;
      try
        aCashValues := pCashReg.GetValue('ValForInvoice') as TJSONArray;
//        isBackBooking := TRUE;
      except
        isBackBooking := FALSE;
        rstFelixMain.WriteToColorLog
          ('Fehler beim Auslesen von ValForInvoice', lmtInfo);
        aError.Add('Fehler beim Auslesen von ValForInvoice: Überprüfung ob Client- Versionsnummer = 3.* ');
      end;
      if aCashValues <> nil then
      begin
        isBackBooking := TRUE;
      end
      else
      begin
        rstFelixMain.WriteToColorLog
            ('Fehler beim Auslesen von ValForInvoice', lmtInfo);
        aError.Add('Fehler beim Auslesen von ValForInvoice: Überprüfung ob Client- Versionsnummer = 3.* ')
      end;
      if isBackBooking then
      try
        try
          if aRechId = 0 then
          begin
            try
              try
                aRechQuery := TFDQuery.Create(nil);
                aRechQuery.Connection := aConnection;
                aRechQuery.SQL.Add('select id from Rechnung where VonDatum = ''' + DateToStr(aUmsatzDatum) + ''' ');
                aRechQuery.SQL.Add(' and Rechnungsnummer in (0,99999)');
                aRechQuery.open;
                if aRechQuery.RecordCount > 0 then
                begin
                  aRechId := aRechQuery.FieldByName('Id').AsInteger;
                end;
              except on e : Exception do
                begin
                  rstFelixMain.WriteToColorLog
                    ('Error in aRechQuery: ' + e.Message, lmtInfo);
                end;
              end;
            finally
              aRechQuery.Close;
              aRechQuery.Free;
            end;
          end;
          if aRechId <> 0 then
          begin
            for var Value in aCashValues do
            begin
              aBetrag := '-'+Value.GetValue<string>('amount');
              aKasseID := Value.GetValue<string>('cashDeskID');
              aTempDM.getLeistIDandBez(aConnection,
                                        0,
                                        Value.GetValue<double>('Tax'),
                                        '',
                                        True,
                                        strToInt(aFirma),
                                        Value.GetValue<integer>('cashDeskID'),
                                        aLeistungsID,
                                        aLeistungsBezeichnung);

              aTempDM.QueryGetDoubleBookingInvoice.Close;
              aTempDM.QueryGetDoubleBookingInvoice.ParamByName('LeistungsID').AsInteger := aLeistungsId;
              aTempDM.QueryGetDoubleBookingInvoice.ParamByName('LeistungsText').ASString := aLeistungsBezeichnung;
              aTempDM.QueryGetDoubleBookingInvoice.ParamByName('GesamtBetrag').AsFloat := -Value.GetValue<double>('amount');
              aTempDM.QueryGetDoubleBookingInvoice.ParamByName('Datum').ASDateTime := aFelixDate;
              aTempDM.QueryGetDoubleBookingInvoice.ParamByName('Firma').AsString := aFirma;
              aTempDM.QueryGetDoubleBookingInvoice.open;
              if aTempDM.QueryGetDoubleBookingInvoice.FieldByName('Id').IsNull then
              begin

                aTempDM.QueryGetDoubleBookingInvoice.Close;
                aTempDM.WriteToTableRechnungskonto(strToInt(aFirma),
                                                    aLeistungsID,
                                                    1,
                                                    -Value.GetValue<double>('amount'),
                                                    aRechId,
                                                    aFelixDate,
                                                    aLeistungsBezeichnung);
              end
              else
               aTempDM.QueryGetDoubleBookingInvoice.Close;
            end;
          end;
        except on e : exception do
          begin
             aError.Add('Fehler bei update Rechnungskonto | LeistungsId: '
              + IntToStr(aLeistungsID)+ 'Betrag: '+aBetrag);
            rstFelixMain.WriteToColorLog
              ('Fehler bei update Rechnungskonto | LeistungsId: '
              + IntToStr(aLeistungsID)+ 'Betrag: '+ aBetrag
              + ' Meldung: ' +e.Message, lmtInfo);
          end;
        end;
      finally
        aTempDM.QueryGetDoubleBookingInvoice.Close;
      end;

      aTempDM.TableUmsatzzuordnung.close;
      // ''''''''''''''''''''''''''''''''
//      aTempDM.getRebookings(aConnection, aUmsatzDatum, aFirma);
//      aTempDM.setAllRebookingsToNull(aConnection, aUmsatzDatum, aFirma);
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
        rstFelixMain.WriteToColorLog('Fehler in UmsatzKassa: ' + E.Message,lmtError);
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
