unit ServerMethodsUnit;

interface

uses System.SysUtils, System.Classes, System.Json, System.Variants,
  DataSnap.DSProviderDataModuleAdapter, Winapi.Windows,
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
    // function getGender(pGenderCode: string): string;
    function transmitKassInfo(DataForKassInfo: TJSONObject): TJSONObject;
    function getTableValuesForGastInfo(pParams: TJSONObject): TJSONObject;
    function LosungKellner(pLosung: TJSONObject): TJSONObject;
    function transmitArticles(pArticles: TJSONObject): TJSONObject;
    function transmitWaiter(pWaiter: TJSONObject): TJSONObject;
    function transmitJournalArchiv(pJournal: TJSONObject): TJSONObject;
    function transmitJournal(pJournal: TJSONObject): TJSONObject;

  public
    { Public-Deklarationen }
    function api(pParams: TJSONObject): TJSONObject;

    function processesCashRegister(pCashReg: TJSONObject): TJSONObject;
    function bookABill(pParams: TJSONObject): TJSONObject;

    function setOrgOrTeiln(pParams: TJSONObject): TJSONObject;
    function setReservState(pParams: TJSONObject): TJSONObject;
    function setVeranstaltung(pParams: TJSONObject): TJSONObject;

    function getEvents(pParams: TJSONObject): TJSONObject;
    function getNewArrIds: TJSONObject;
    function getReservArtcles(pParams: TJSONObject): TJSONObject;
    function getReservationData(pParams: TJSONObject): TJSONObject;
    function getUiCodes: TJSONObject;
    function getVersion: TJSONObject;


{$REGION 'ExternalCashDesk'}
    function getGuestInfo: TJSONObject;
    function transmitCashInfo(pParams: TJSONObject): TJSONObject;
{$ENDREGION}

{$METHODINFO OFF}
  end;

var
  sMethod: TAPI;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}
{$R *.dfm}


uses System.StrUtils, DataModule, ExternalCashDesk, DMEmail,
  TempModul, EventUnit, Logging;

// const // in this array are the used columns in the ClientMethod insertG_Info
// ListOfGastInfoColumn: Array [0 .. 6] of string = ('ZI_PERS', 'PERS_NR',
// 'TERMIN_NR', 'VON', 'BIS', 'ZI_NUMMER', 'BEMERKUNG');


function TAPI.api(pParams: TJSONObject): TJSONObject;
var
  aFunctionName: string;
  aString: String;
  aCompanyName: string;
begin
  try
    aFunctionName := pParams.GetValue<string>('FunctionName');
    aCompanyName := DM.FUserCompanyName;
    // try
    // rstFelixMain.MemoLog.Lines.Add(DateToStr(Date) + ' ' + TimeToStr(Time) +
    // ' ' + DM.FUserCompanyName + ': api FunctionName: ' + aFunctionName);
    // except
    // //
    // end;
    Log.WriteToLog(aCompanyName, 0, '<TAPI> api FunctionName: ' + aFunctionName, lmtInfo, true);
    if aFunctionName = 'transmitKassInfo' then
    begin
      result := transmitKassInfo(pParams);
    end
    else
      if aFunctionName = 'getTableValuesForGastInfo' then
      begin
        result := getTableValuesForGastInfo(pParams);
      end
      else
        if aFunctionName = 'LosungKellner' then
        begin
          result := LosungKellner(pParams);
        end
        else
          if aFunctionName = 'processesCashRegister' then
          begin
            result := processesCashRegister(pParams);
          end
          else
            if aFunctionName = 'transmitArticles' then
            begin
              result := transmitArticles(pParams);
            end
            else
              if aFunctionName = 'transmitWaiter' then
              begin
                result := transmitWaiter(pParams);
              end
              else
                if aFunctionName = 'transmitJournalArchiv' then
                begin
                  result := transmitJournalArchiv(pParams);
                end
                else
                  if aFunctionName = 'transmitJournal' then
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
      Log.WriteToLog(aCompanyName, 0, '<TAPI> api: ' + E.Message, lmtError);
    end;

  end;

end;

{$REGION 'OEBB'}


function TAPI.setOrgOrTeiln(pParams: TJSONObject): TJSONObject;
var
  pResultArr: TJSONArray;
  aDataBase, aMessage: String;
  aFirma: integer;
  aHaveValues: boolean;
  aOEBB: TEvent;
begin
  try
    try
      if not pParams.TryGetValue<integer>('companyId', aFirma) then
        aFirma := 1;
      if not pParams.TryGetValue<string>('percSilenz', aDataBase) then
      begin
        aDataBase := DM.FUserCompanyName;
        Log.WriteToLog(aDataBase, aFirma, '<TAPI> setOrgOrTeiln ' +
          'Auslesen von CompanyName aus  JSON war nicht möglich! ');
      end
      else
      begin
        if aDataBase = '' then
        begin
          aDataBase := DM.FUserCompanyName;
          Log.WriteToLog(aDataBase, aFirma, '<TAPI> setOrgOrTeiln CompanyName im JSON ist leer! ');
        end;
      end;
      aOEBB := TEvent.Create(nil);
      aOEBB.CompanyName := aDataBase;
      Log.WriteToLog(aDataBase, aFirma, '<TAPI> setOrgOrTeiln In JSON: ' + pParams.ToJson);
      aHaveValues := False;
      // aDataBase := DM.FUserCompanyName;
      // aFirma := DM.FUserFirmaID;
      pResultArr := TJSONArray.Create;
      aHaveValues := aOEBB.setOrgOrTeiln(aDataBase, pParams, pResultArr);
    except
      on E: Exception do
      begin
        aHaveValues := False;
        Log.WriteToLog(aDataBase, aFirma, '<TAPI> setOrgOrTeiln: ' + E.Message, lmtError);
        aMessage := E.Message;
      end;
    end;
  finally
    result := TJSONObject.Create;
    result.AddPair('success', TJSONBool.Create(aHaveValues));
    Log.WriteToLog(aDataBase, aFirma, '<TAPI> setOrgOrTeiln Out JSON:' + result.ToString, lmtInfo);
    aOEBB.Free;
  end;

end;

function TAPI.setVeranstaltung(pParams: TJSONObject): TJSONObject;
var
  pResultArr: TJSONArray;
  aDataBase, aMessage: String;
  aFirma: integer;
  aHaveValues: boolean;
  aOEBB: TEvent;
begin
  try
    try
      if not pParams.TryGetValue<integer>('companyId', aFirma) then
        aFirma := 1;
      if not pParams.TryGetValue<string>('percSilenz', aDataBase) then
      begin
        aDataBase := DM.FUserCompanyName;
        Log.WriteToLog(aDataBase, aFirma, '<TAPI> setVeranstaltung ' +
          'Auslesen von CompanyName aus  JSON war nicht möglich! ');
      end
      else
      begin
        if aDataBase = '' then
        begin
          aDataBase := DM.FUserCompanyName;
          Log.WriteToLog(aDataBase, aFirma, '<TAPI> setVeranstaltung CompanyName im JSON ist leer!');
        end;
      end;
      aOEBB := TEvent.Create(nil);
      aOEBB.CompanyName := aDataBase;
      Log.WriteToLog(aDataBase, aFirma, '<TAPI> setVeranstaltung In JSON: ' + pParams.ToJson);
      aHaveValues := False;
      pResultArr := TJSONArray.Create;
      aHaveValues := aOEBB.setVeranstaltung(aDataBase, pParams, pResultArr);
    except
      on E: Exception do
      begin
        aHaveValues := False;
        Log.WriteToLog(aDataBase, aFirma, '<TAPI> setVeranstaltung: ' + E.Message, lmtError);
        aMessage := E.Message;
      end;
    end;
  finally
    result := TJSONObject.Create;
    result.AddPair('success', TJSONBool.Create(aHaveValues));
    Log.WriteToLog(aDataBase, aFirma, '<TAPI> setVeranstaltung Out JSON: ' + result.ToString);
    aOEBB.Free;
  end;

end;

function TAPI.getEvents(pParams: TJSONObject): TJSONObject;
var
  pResultArr: TJSONArray;
  aDataBase, aMessage: String;
  aFirma: integer;
  aHaveValues: boolean;
  aOEBB: TEvent;
begin
  try
    try
      if not pParams.TryGetValue<integer>('companyId', aFirma) then
        aFirma := 1;
      if not pParams.TryGetValue<string>('percSilenz', aDataBase) then
      begin
        aDataBase := DM.FUserCompanyName;
        Log.WriteToLog(aDataBase, aFirma, '<TAPI> getEvents ' +
          'Auslesen von CompanyName aus  JSON war nicht möglich! ');
      end
      else
      begin
        if aDataBase = '' then
        begin
          aDataBase := DM.FUserCompanyName;
          Log.WriteToLog(aDataBase, aFirma, '<TAPI> getEvents CompanyName im JSON ist leer! ');
        end;
      end;
      aOEBB := TEvent.Create(nil);
      aOEBB.CompanyName := aDataBase;
      Log.WriteToLog(aDataBase, aFirma, '<TAPI> getEvents In JSON: ' + pParams.ToJson);
      aHaveValues := False;
      pResultArr := TJSONArray.Create;
      aHaveValues := aOEBB.getEvents(aDataBase, pParams, pResultArr, aMessage);
      if not aHaveValues then
      begin
        aMessage := 'Keine Daten Vorhanden';
      end;
    except
      on E: Exception do
      begin
        aHaveValues := False;
        Log.WriteToLog(aDataBase, aFirma, '<TAPI> getEvents : ' + E.Message, lmtError);
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
    Log.WriteToLog(aDataBase, aFirma, '<TAPI> getEvents Out JSON: ' + result.ToString);
    aOEBB.Free;
  end;
end;

function TAPI.getNewArrIds: TJSONObject;
var
  aIdList: TSTringList;
  aDataBase: String;
  aFirma: integer;
  aResultArr: TJSONArray;
  aHaveValues: boolean;
  aOEBB: TEvent;
begin
  try
    try

      aOEBB := TEvent.Create(nil);

      aIdList := TSTringList.Create;
      aDataBase := DM.FUserCompanyName;
      aOEBB.CompanyName := aDataBase;
      aFirma := DM.FUserFirmaID;
      Log.WriteToLog(aDataBase, aFirma, '<TAPI> getNewArrIds ... ');
      aResultArr := TJSONArray.Create;
      aOEBB.getNewPack(aDataBase, aFirma, aResultArr, aIdList);

      result := TJSONObject.Create;
      result.AddPair('Ids', aResultArr);

    except
      on E: Exception do
      begin
        Log.WriteToLog(aDataBase, aFirma, '<TAPI> getNewArrIds: ' + E.Message, lmtError);
        aIdList.Clear;
      end;
    end;
  finally
    if aIdList.Count > 0 then
    begin
      for var id in aIdList do
      begin
        aOEBB.setArrToSend(aDataBase, id);
      end;

    end;
    aIdList.Free;
    aOEBB.Free;
  end;
end;

function TAPI.getUiCodes: TJSONObject;
var
  pResultArr: TJSONArray;
  aDataBase, aMessage: String;
  aFirma: integer;
  aHaveValues: boolean;
  aOEBB: TEvent;
begin
  try
    try
      aOEBB := TEvent.Create(nil);
      aDataBase := DM.FUserCompanyName;
      aFirma := DM.FUserFirmaID;
      aOEBB.CompanyName := aDataBase;
      Log.WriteToLog(aDataBase, aFirma, '<TAPI> getUiCodes ... ');
      pResultArr := TJSONArray.Create;
      aHaveValues := aOEBB.getUIDs(aDataBase, aFirma, pResultArr, aMessage);
      if not aHaveValues then
      begin
        aMessage := 'Keine Daten Vorhanden';
      end;
    except
      on E: Exception do
      begin
        aHaveValues := False;
        Log.WriteToLog(aDataBase, aFirma, '<TAPI> getUiCodes: ' + E.Message, lmtError);
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
    Log.WriteToLog(aDataBase, aFirma, '<TAPI> getUiCodes Out JSON: ' + result.ToString);
    aOEBB.Free;
  end;
end;

function TAPI.getVersion: TJSONObject;
var
  aStr: string;
  function getVersion: string;
  var
    VerInfoSize: DWORD;
    VerInfo: Pointer;
    VerValueSize: DWORD;
    VerValue: PVSFixedFileInfo;
    Dummy: DWORD;
  begin
    VerInfoSize := GetFileVersionInfoSize(PChar(ParamStr(0)), Dummy);
    GetMem(VerInfo, VerInfoSize);
    GetFileVersionInfo(PChar(ParamStr(0)), 0, VerInfoSize, VerInfo);
    VerQueryValue(VerInfo, '\', Pointer(VerValue), VerValueSize);
    with VerValue^ do
    begin
      result := IntToStr(dwFileVersionMS shr 16);
      result := result + '.' + IntToStr(dwFileVersionMS and $FFFF);
      result := result + '.' + IntToStr(dwFileVersionLS shr 16);
      result := result + '.' + IntToStr(dwFileVersionLS and $FFFF);
    end;
    FreeMem(VerInfo, VerInfoSize);
  end;

begin
  try
    try
      aStr := getVersion;

    except
      on E: Exception do
      begin
        Log.WriteToLog(DM.FUserCompanyName, 0, '<TAPI> getVersion: ' + E.Message, lmtError);
        aStr := 'Version nicht verfügbar';
      end;
    end;
  finally
    result := TJSONObject.Create;
    result.AddPair('version', aStr);
    Log.WriteToLog(DM.FUserCompanyName, 0, '<TAPI> getVersion Out JSON: ' + result.ToString, lmtInfo);
  end;
end;

function TAPI.getReservArtcles(pParams: TJSONObject): TJSONObject;
var
  pResultArr: TJSONArray;
  aDataBase, aMessage: String;
  aFirma: integer;
  aHaveValues: boolean;
  aOEBB: TEvent;
begin
  try
    try
      if not pParams.TryGetValue<integer>('companyId', aFirma) then
        aFirma := 1;
      if not pParams.TryGetValue<string>('percSilenz', aDataBase) then
      begin
        aDataBase := DM.FUserCompanyName;
        Log.WriteToLog(aDataBase, aFirma, '<TAPI> getReservArtcles ' +
          'Auslesen von CompanyName aus  JSON war nicht möglich! ');
      end
      else
      begin
        if aDataBase = '' then
        begin
          aDataBase := DM.FUserCompanyName;
          Log.WriteToLog(aDataBase, aFirma, '<TAPI> getReservArtcles CompanyName im JSON ist leer! ');
        end;
      end;
      aOEBB := TEvent.Create(nil);
      aOEBB.CompanyName := aDataBase;
      Log.WriteToLog(aDataBase, aFirma, '<TAPI> getReservArtcles In JSON: ' + pParams.ToString);
      // aDataBase := DM.FUserCompanyName;
      // aFirma := DM.FUserFirmaID;
      pResultArr := TJSONArray.Create;
      aHaveValues := aOEBB.getReservArticle(aDataBase, pParams, aFirma, pResultArr, aMessage);
      if not aHaveValues then
      begin
        aMessage := 'Keine Daten Vorhanden';
      end;
    except
      on E: Exception do
      begin
        aHaveValues := False;
        Log.WriteToLog(aDataBase, aFirma, '<TAPI> getReservArtcles: ' + E.Message, lmtError);
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
    Log.WriteToLog(aDataBase, aFirma, '<TAPI> getReservArtcles Out JSON ' + result.ToString);
    aOEBB.Free;
  end;
end;

function TAPI.getReservationData(pParams: TJSONObject): TJSONObject;
var
  pResultArr: TJSONArray;
  aDataBase: String;
  aFirma: integer;
  aOEBB: TEvent;
begin
  try
    try
      if not pParams.TryGetValue<integer>('companyId', aFirma) then
        aFirma := 1;
      if not pParams.TryGetValue<string>('percSilenz', aDataBase) then
      begin
        aDataBase := DM.FUserCompanyName;
        Log.WriteToLog(aDataBase, aFirma, '<TAPI> getReservationData ' +
          'Auslesen von CompanyName aus  JSON war nicht möglich! ');
      end
      else
      begin
        if aDataBase = '' then
        begin
          aDataBase := DM.FUserCompanyName;
          Log.WriteToLog(aDataBase, aFirma, '<TAPI> getReservationData  CompanyName im JSON ist leer! ');
        end;
      end;
      aOEBB := TEvent.Create(nil);
      aOEBB.CompanyName := aDataBase;
      Log.WriteToLog(aDataBase, aFirma, '<TAPI> getReservationData In JSON: ' + pParams.ToJson);
      pResultArr := TJSONArray.Create;
      aOEBB.getReservData(aDataBase, pParams, pResultArr);
    except
      on E: Exception do
      begin
        Log.WriteToLog(aDataBase, aFirma, '<TAPI> getReservationData: ' + E.Message, lmtError);
      end;
    end;
  finally
    result := TJSONObject.Create;
    result.AddPair('reservationData', pResultArr);
    Log.WriteToLog(aDataBase, aFirma, '<TAPI> getReservationData Out JSON: ' + result.ToString);
    aOEBB.Free;
  end;

end;

function TAPI.setReservState(pParams: TJSONObject): TJSONObject;
var
  aDataBase: String;
  aFirma: integer;
  aOEBB: TEvent;
begin
  try
    try
      if not pParams.TryGetValue<integer>('companyId', aFirma) then
        aFirma := 1;
      if not pParams.TryGetValue<string>('percSilenz', aDataBase) then
      begin
        aDataBase := DM.FUserCompanyName;
        Log.WriteToLog(aDataBase, aFirma, '<TAPI> setReservState ' +
          'Auslesen von CompanyName aus  JSON war nicht möglich! ');
      end
      else
      begin
        if aDataBase = '' then
        begin
          aDataBase := DM.FUserCompanyName;
          Log.WriteToLog(aDataBase, aFirma, '<TAPI> setReservState CompanyName im JSON ist leer! ');
        end;
      end;
      Log.WriteToLog(aDataBase, aFirma, '<TAPI> setReservState In JSON: ' + pParams.ToJson);
      aOEBB := TEvent.Create(nil);
      aOEBB.CompanyName := aDataBase;
      result := TJSONObject.Create;
      aOEBB.setReservState(aDataBase, pParams, result);
    except
      on E: Exception do
      begin
        Log.WriteToLog(aDataBase, aFirma, '<TAPI> setReservState: ' + E.Message,
          lmtError);
      end;
    end;
  finally
    aOEBB.Free;
    Log.WriteToLog(aDataBase, aFirma, '<TAPI> setReservState Out JSON: ' + result.ToString);
  end;

end;
{$ENDREGION}

{$REGION 'externalCashDesk'}


function TAPI.getGuestInfo: TJSONObject;
var
  pResultArr: TJSONArray;
  aDataBase: String;
  aFirma: integer;
  aExtern: TExtern;
begin
  try
    try
      aExtern := TExtern.Create(nil);
      aDataBase := DM.FUserCompanyName;
      aFirma := DM.FUserFirmaID;
      pResultArr := TJSONArray.Create;
      aExtern.getGastInfo(aFirma, aDataBase, pResultArr);
    except
      on E: Exception do
      begin
        Log.WriteToLog(aDataBase, aFirma, '<TAPI> getGuestInfo: ' + E.Message, lmtError);
      end;
    end;
  finally
    result := TJSONObject.Create;
    result.AddPair('GuestsInfo', pResultArr);
    Log.WriteToLog(aDataBase, aFirma, '<TAPI> getGuestInfo Out JSON: ' + result.ToString);
  end;
end;



function TAPI.transmitCashInfo(pParams: TJSONObject): TJSONObject;
var
  pResultObj: TJSONObject;
  aDataBase: String;
  aFirma: integer;
  aExtern: TExtern;
begin
  try
    try
      aExtern := TExtern.Create(nil);
      aDataBase := DM.FUserCompanyName;
      aFirma := DM.FUserFirmaID;
      pResultObj := TJSONObject.Create;
      aExtern.saveKassInfo(aFirma, aDataBase, pParams, pResultObj);
    except
      on E: Exception do
      begin
        Log.WriteToLog(aDataBase, aFirma, '<TAPI> transmitCashInfo: ' + E.Message, lmtError);
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
  strForJSON, teststring, compName, aBemerkung: string;
  columnName: string;
  dateVon, dateBis: string;
  aConnection: TFDConnection;
  aQuery: TFDQuery;
  aJsonObject: TJSONObject;
  aJsonarray: TJSONArray;
begin
  dateVon := DateToStr(Date);
  dateBis := DateToStr(Date);
  if not pParams.TryGetValue<integer>('companyId', aFirma) then
    aFirma := 1;
  if not pParams.TryGetValue<string>('percSilenz', compName) then
  begin
    compName := DM.FUserCompanyName;
    Log.WriteToLog(compName, aFirma, '<TAPI> getTableValuesForGastInfo ' +
      'Auslesen von CompanyName aus  JSON war nicht möglich! ');
  end
  else
  begin
    if compName = '' then
    begin
      compName := DM.FUserCompanyName;
      Log.WriteToLog(compName, aFirma, '<TAPI> getTableValuesForGastInfo CompanyName im JSON ist leer!');
    end;
  end;
  try

    with aQuery do
      try
        try
          aQuery := TFDQuery.Create(nil);
          aQuery.SQL.Clear;
          aQuery.SQL.Add
            ('select (trim(g.nachname) || '' '' || trim(coalesce(g.vorname, '''', ''''))) as ZI_PERS, ');
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
            Log.WriteToLog(compName, aFirma, '<TAPI> getTableValuesForGastInfo ' +
              ' - Create Connection: ' + E.Message, lmtError);
          end;
        end;
        try

          aQuery.ParamByName('Firma').AsInteger := aFirma;
          // Log.WriteToLog(compName, aFirma,'<TAPI> getTableValuesForGastInfo - Set Param and open: 1 ', lmtInfo);
          aQuery.ParamByName('dateToday').AsDateTime := Date;
          // Log.WriteToLog(compName, aFirma,'<TAPI> getTableValuesForGastInfo - Set Param and open: 2', lmtInfo);

          aQuery.open;
        except
          on E: Exception do
          begin
            Log.WriteToLog(compName, aFirma, '<TAPI> getTableValuesForGastInfo open: ' + E.Message,
              lmtError);
            raise;
          end;
        end;
        rows := 0;
        try
          result := TJSONObject.Create;
          aJsonarray := TJSONArray.Create;
          while not aQuery.EOF do
          begin
            aJsonObject := TJSONObject.Create;
            aJsonObject.AddPair('ZI_PERS', aQuery.FieldByName('ZI_PERS').AsString);
            aJsonObject.AddPair('PERS_NR', aQuery.FieldByName('PERS_NR').AsString);
            aJsonObject.AddPair('TERMIN_NR', aQuery.FieldByName('TERMIN_NR').AsString);
            aJsonObject.AddPair('VON', aQuery.FieldByName('VON').AsString);
            aJsonObject.AddPair('BIS', aQuery.FieldByName('BIS').AsString);
            aJsonObject.AddPair('ZI_NUMMER', aQuery.FieldByName('ZI_NUMMER').AsString);
            aBemerkung := aQuery.FieldByName('BEMERKUNG').AsString;
            aJsonObject.AddPair('BEMERKUNG', aBemerkung);
            aJsonarray.AddElement(aJsonObject);
            aQuery.next;
          end;
          result.AddPair('GASTINFO', aJsonarray);

        except
          on E: Exception do
          begin
            Log.WriteToLog(compName, aFirma, '<TAPI> getTableValuesForGastInfo - Create Json in While Loop: ' +
              E.Message, lmtError);
          end;
        end;

        // teststring := result.ToString;
        Log.WriteToLog(compName, aFirma, '<TAPI> getTableValuesForGastInfo Out JSON: ' +
          result.ToString);
      except
        on E: Exception do
        begin
          Log.WriteToLog(compName, aFirma, '<TAPI> getTableValuesForGastInfo: ' + E.Message, lmtError);
        end;
      end;
  finally
    aConnection.Connected := False;
    aConnection.Free;
    aQuery.close;
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
  aResultObj: TJSONObject;
  aResultArray: TJSONArray;
begin
  row := 0;
  try
    Log.WriteToLog(DM.FUserCompanyName, 0, '<TAPI> transmitKassInfo In JSON: ' + DataForKassInfo.ToString);
    if not DataForKassInfo.TryGetValue<string>('percSilenz', compName) then
    begin
      compName := DM.FUserCompanyName;
      Log.WriteToLog(compName, 0, '<TAPI> transmitKassInfo ' +
        'Auslesen von CompanyName aus  JSON war nicht möglich! ');
    end
    else
    begin
      if compName = '' then
      begin
        compName := DM.FUserCompanyName;
        Log.WriteToLog(compName, 0, '<TAPI> transmitKassInfo CompanyName im JSON ist leer! ');
      end;
    end;
    if not DataForKassInfo.TryGetValue<integer>('companyId', aFirma) then
      aFirma := 1;
    try
      aIsEinzelBuchung := DataForKassInfo.GetValue<boolean>('EinzelBuchung');
      aIsBelegNr := DataForKassInfo.GetValue<boolean>('isBelegNr');
      aFelixNAchKasse := DataForKassInfo.GetValue<boolean>('FelixNachKassen');
      // if DataForKassInfo.GetValue<string>('EinzelBuchung').ToUpper = 'TRUE' then
      // aIsEinzelBuchung := true
      // else
      // if DataForKassInfo.GetValue<string>('EinzelBuchung').ToUpper = 'FALSE'
      // then
      // aIsEinzelBuchung := False;
      // if DataForKassInfo.GetValue<string>('isBelegNr').ToUpper = 'TRUE' then
      // aIsBelegNr := true
      // else
      // if DataForKassInfo.GetValue<string>('isBelegNr').ToUpper = 'FALSE'
      // then
      // aIsBelegNr := False;
      // if DataForKassInfo.GetValue<string>('FelixNachKassen').ToUpper = 'TRUE'
      // then
      // aFelixNAchKasse := true
      // else
      // if DataForKassInfo.GetValue<string>('FelixNachKassen').ToUpper = 'FALSE'
      // then
      // aFelixNAchKasse := False;
    except
      on E: Exception do
      begin
        Log.WriteToLog(compName, aFirma, '<TAPI> transmitKassInfo ' +
          'Error in TAPI.transmitKassInfo/read Properties: ' + E.Message,
          lmtError);
        raise;
      end;
    end;
    try
      aErrors := TSTringList.Create;
      aErrorId := TSTringList.Create;
    except
      on E: Exception do
      begin
        Log.WriteToLog(compName, aFirma, '<TAPI> transmitKassInfo/Create Lists: ' + E.Message,
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
          Log.WriteToLog(compName, aFirma, '<TAPI> transmitKassInfo/set connection: ' + E.Message,
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
          Log.WriteToLog(compName, aFirma, '<TAPI> transmitKassInfo/get Company and Data: ' +
            E.Message, lmtError);
          raise;
        end;
      end;
      try
        aResultArray := TJSONArray.Create;
        // strJSONstored_ID := '{"stored_ID":[';
        for var iKassInfo in DataArray do
        begin
          pers_Nr := iKassInfo.GetValue<string>('PERS_NR');
          Anzahl := iKassInfo.GetValue<integer>('ANZAHL');
          Preis := iKassInfo.GetValue<double>('PREIS');
          steuer := iKassInfo.GetValue<double>('STEUER');
          termin_Nr := iKassInfo.GetValue<integer>('TERMIN_NR');
          Log_T := iKassInfo.GetValue<string>('LOG_T');
          aKassID := iKassInfo.GetValue<string>('KASSEID');
          aKellnerID := 1;
          iKassInfo.TryGetValue('DATUM', aDateString);
          aDate := StrToDate(aDateString);
          iKassInfo.TryGetValue<double>('SUMME', aSumme);
          iKassInfo.TryGetValue('KURZBEZ', aKurzbezeichnung);
          iKassInfo.TryGetValue('ARTIKELID', aArtikelId);
          iKassInfo.TryGetValue('TischNr', aTischNr);
          // Bessere Id unterscheidung wenn meherere Kassendatenbanken
          aKassInfoId := iKassInfo.GetValue<string>('ID');
          // end;
          // for Count := 0 to arrlenght - 1 do
          // begin
          // pers_Nr := DataForKassInfo.GetValue<string>
          // ('KASSINFO[' + Count.ToString + '].PERS_NR');
          // Anzahl := (DataForKassInfo.GetValue<string>('KASSINFO[' +
          // Count.ToString + '].ANZAHL')).ToInteger;
          // Preis := (DataForKassInfo.GetValue<string>('KASSINFO[' +
          // Count.ToString + '].PREIS')).ToDouble;
          // steuer := DataForKassInfo.GetValue<string>
          // ('KASSINFO[' + Count.ToString + '].STEUER').ToDouble;
          // termin_Nr := DataForKassInfo.GetValue<string>
          // ('KASSINFO[' + Count.ToString + '].TERMIN_NR').ToInteger;
          // Log_T := DataForKassInfo.GetValue<string>('KASSINFO[' + Count.ToString
          // + '].LOG_T');
          // aKassID := DataForKassInfo.GetValue<string>
          // ('KASSINFO[' + Count.ToString + '].KASSEID');
          // aKellnerID := 1;
          // DataForKassInfo.TryGetValue('KASSINFO[' + Count.ToString + '].DATUM',
          // aDateString);
          // aDate := StrToDate(aDateString);
          // var
          // aSummenString: String := '';
          // if DataForKassInfo.TryGetValue('KASSINFO[' + Count.ToString +
          // '].SUMME', aSummenString) then
          // aSumme := aSummenString.ToDouble;
          // DataForKassInfo.TryGetValue('KASSINFO[' + Count.ToString +
          // '].KURZBEZ', aKurzbezeichnung);
          // DataForKassInfo.TryGetValue('KASSINFO[' + Count.ToString +
          // '].ARTIKELID', aArtikelId);
          // DataForKassInfo.TryGetValue('KASSINFO[' + Count.ToString +
          // '].TischNr', aTischNr);
          // aKassInfoId := DataForKassInfo.GetValue<string>
          // ('KASSINFO[' + Count.ToString + '].ID');

          if aTempDM.WriteToGastkonto(aConnection, aTischNr, pers_Nr, Anzahl,
            Preis, steuer, aKellnerID, termin_Nr, aFirma, aKurzbezeichnung,
            Log_T, aIsEinzelBuchung, aIsBelegNr, compName, aFelixNAchKasse,
            strToInt(aKassID), aKassInfoId+'_'+IntToStr(aArtikelId)+'_'+aTischNr, aErrorString, aDateString, False) then
          begin
            aResultObj := TJSONObject.Create;
            aResultObj.AddPair('ID', aKassInfoId);
            aResultArray.Add(aResultObj);
            // if row > 0 then
            // strJSONstored_ID := strJSONstored_ID + ',';
            //
            // strJSONstored_ID := strJSONstored_ID + Format('{"ID": "%s"}',
            // [aKassInfoId]);
            // inc(row);

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
        // strJSONstored_ID := strJSONstored_ID + ']}';
      except
        on E: Exception do
        begin
          Log.WriteToLog(compName, aFirma, '<TAPI> transmitKassInfo/read Data: ' + E.Message,
            lmtError);
          raise;
        end;
      end;
      try
        result := TJSONObject.Create;
        result.AddPair('stored_ID', aResultArray)
        // result := TJSONObject.ParseJSONValue(strJSONstored_ID) as TJSONObject;
      except
        on E: Exception do
        begin
          Log.WriteToLog(compName, aFirma, '<TAPI> transmitKassInfo/create Result: ' + E.Message,
            lmtError);
          raise;
        end;
      end;
      teststring := result.ToString;
      Log.WriteToLog(compName, aFirma, '<TAPI> transmitKassInfo Out JSON: ' + teststring);
      if aErrors.Count > 0 then
      begin
        var
          aEmail: TDataEmail;
        aEmail := TDataEmail.Create(nil);
        aEmail.SendEmail(compName, 'Umbuchung auf Zimmer', MailOut, 'Fehler bei einer Umbuchung', aErrors,
          DM.ErrorMail);
        if MailOut <> '' then
        begin
          Log.WriteToLog(compName, aFirma, '<TAPI> transmitKassInfo Error in DataEmail.SendEmail: ' +
            MailOut, lmtError);
        end
        else
        begin
          Log.WriteToLog(compName, aFirma, '<TAPI> transmitKassInfo ' +
            'FehlerMail wurde an support@gms.info gesendet! ');

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
        FreeAndNil(aEmail);
      end;
    except
      on E: Exception do
      begin
        Log.WriteToLog(compName, aFirma, '<TAPI> transmitKassInfo: ' + E.Message, lmtError);
      end;
    end;
  finally
    aConnection.Connected := False;
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
  aQuery: TFDQuery;
  aLocationId: string;
begin
  try
    Log.WriteToLog(DM.FUserCompanyName, 0, '<TAPI> JournalArchiv In JSON: ' + pJournal.ToString);
    try
      isCorrect := False;
      if not pJournal.TryGetValue<string>('percSilenz', compName) then
      begin
        compName := DM.FUserCompanyName;
        Log.WriteToLog(compName, 0, '<TAPI> JournalArchiv: ' +
          'Auslesen von CompanyName aus  JSON war nicht möglich! ');
      end
      else
      begin
        if compName = '' then
        begin
          compName := DM.FUserCompanyName;
        end;
      end;
      aLocationId := '';
      pJournal.TryGetValue<string>('locationId', aLocationId);
      aQuery := TFDQuery.Create(nil);
      aConnection := TFDConnection.Create(nil);
      aConnection.Params.Clear;
      aConnection.ConnectionDefName := compName;
      aConnection.Connected := true;
      JournalArray := pJournal.GetValue('JournalRecords') as TJSONArray;
      aQuery.SQL.Clear;
      aQuery.SQL.Add
        ('Update or Insert into JOURNALARCHIV (Firma, JOURNALARCHIVId, Datum, Zeit, KellnerId, Menge, Betrag, ArtikelId,'
        +
        ' BeilagenId, ZahlwegId, TischId, JournalTyp, Verbucht, Text, VonOffeneTischId, RechnungsId, Nachlass, Lagerverbucht, Lagerdatum, LagerId, SyncId, BonNr, Preisebene, LocationID) ');
      aQuery.SQL.Add
        ('Values(:Firma, :JOURNALARCHIVId, :Datum, :Zeit, :KellnerId, :Menge, :Betrag, :ArtikelId, :BeilagenId, :ZahlwegId,'
        +
        ' :TischId, :JournalTyp, :Verbucht, :Text, :VonOffeneTischId, :RechnungsId, :Nachlass, :Lagerverbucht, :Lagerdatum, :LagerId, :SyncId, :BonNr, :Preisebene, :LocationID) ');
      aQuery.SQL.Add('matching (Firma, JOURNALARCHIVId, LocationID)');

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
          ParamByName('Betrag').AsFloat := aBetrag;

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

          if (aLocationId <> '') then
            ParamByName('LocationID').AsString := aLocationId
          else
            ParamByName('LocationID').Value := null;
          ExecSQL;
          close;
        end;
      end;
      isCorrect := true;
    except
      on E: Exception do
      begin
        Log.WriteToLog(compName, 0, '<TAPI> JournalArchiv: ' + E.Message,
          lmtError);
        aErrorString := E.Message;
        isCorrect := False;
      end;
    end;
  finally
    result := TJSONObject.Create;
    result.AddPair('FullyTransferred', TJSONBool.Create(isCorrect));
    if not isCorrect then
      result.AddPair('Error', aErrorString);
    Log.WriteToLog(compName, 0, '<TAPI> JournalArchiv Out JSON: ' + result.ToString);
    aConnection.Connected := False;
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
  aLocationId: string;
begin
  try
    try

      isCorrect := False;
      if not pJournal.TryGetValue<string>('percSilenz', compName) then
      begin
        compName := DM.FUserCompanyName;
        Log.WriteToLog(compName, 0, '<TAPI> transmitJournal: ' +
          'Auslesen von CompanyName aus  JSON war nicht möglich! ');
      end
      else
      begin
        if compName = '' then
        begin
          compName := DM.FUserCompanyName;
          Log.WriteToLog(compName, 0, '<TAPI> transmitJournal:CompanyName im JSON ist leer! ');
        end;
      end;
      Log.WriteToLog(compName, 0, '<TAPI> transmitJournal --> incomming Json: ' + pJournal.ToString, lmtInfo);
      aLocationId := '';
      pJournal.TryGetValue<string>('locationId', aLocationId);
      aQuery := TFDQuery.Create(nil);
      aConnection := TFDConnection.Create(nil);
      aConnection.Params.Clear;
      aConnection.ConnectionDefName := compName;
      aConnection.Connected := true;
      JournalArray := pJournal.GetValue('JournalRecords') as TJSONArray;
      aQuery.SQL.Clear;
      aQuery.SQL.Add
        ('Update or Insert into JOURNAL (Firma, JOURNALId, Datum, Zeit, KellnerId, KasseId, Menge, Betrag, ArtikelId,'
        + ' BeilagenId, ZahlwegId, OffeneTischId, JournalTyp, Verbucht, Text, VonOffeneTischId, RechnungsId, Nachlass, Bankomat, Lagerverbucht, Lagerdatum, LagerId, SyncId, BonNr, Preisebene, LocationID)');
      aQuery.SQL.Add
        ('Values(:Firma, :JOURNALId, :Datum, :Zeit, :KellnerId, :KasseId, :Menge, :Betrag, :ArtikelId, :BeilagenId,'
        + ' :ZahlwegId, :OffeneTischId, :JournalTyp, :Verbucht, :Text, :VonOffeneTischId, :RechnungsId, :Nachlass, :Bankomat, :Lagerverbucht, :Lagerdatum, :LagerId, :SyncId, :BonNr, :Preisebene, :LocationID)');
      aQuery.SQL.Add('matching (Firma, JOURNALId, LocationID)');
      aQuery.Connection := aConnection;
      Log.WriteToLog(compName, 0, '<TAPI> transmitJournal --> begin update Journal', lmtInfo);
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
          if (aLocationId <> '') then
            ParamByName('LocationID').AsString := aLocationId
          else
            ParamByName('LocationID').Value := null;
          ExecSQL;
          close;
        end;
      end;
      Log.WriteToLog(compName, 0, '<TAPI> transmitJournal --> update Journal finished', lmtInfo);
      isCorrect := true;
    except
      on E: Exception do
      begin
        Log.WriteToLog(compName, 0, '<TAPI> transmitJournal: ' + E.Message, lmtError);
        aErrorString := E.Message;
        isCorrect := False;
      end;
    end;
  finally
    result := TJSONObject.Create;
    result.AddPair('FullyTransferred', TJSONBool.Create(isCorrect));
    if not isCorrect then
      result.AddPair('Error', aErrorString);
    Log.WriteToLog(compName, 0, '<TAPI> transmitJournal Out JSON: ' + result.ToString);
    aConnection.Connected := False;
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
  aLocationId: string;
begin
  try
    try
      isCorrect := False;
      if not pWaiter.TryGetValue<string>('percSilenz', compName) then
      begin
        compName := DM.FUserCompanyName;
        Log.WriteToLog(compName, 0, '<TAPI> transmitWaiter: ' +
          'Auslesen von CompanyName aus  JSON war nicht möglich! ');
      end
      else
      begin
        if compName = '' then
        begin
          compName := DM.FUserCompanyName;
          Log.WriteToLog(compName, 0, '<TAPI> transmitWaiter: CompanyName im JSON ist leer! ');
        end;
      end;
      aLocationId := '';
      pWaiter.TryGetValue<string>('locationID', aLocationId);
      try
        aQuery := TFDQuery.Create(nil);
        aConnection := TFDConnection.Create(nil);
        aConnection.Params.Clear;
        aConnection.ConnectionDefName := compName;
        aConnection.Connected := true;
      except
        on E: Exception do
        begin
          Log.WriteToLog(compName, 0, '<TAPI> transmitWaiter/Create Connection: '
            + E.Message, lmtError);
        end;
      end;
      WaiterArray := pWaiter.GetValue('Waiters') as TJSONArray;
      aQuery.SQL.Clear;
      aQuery.SQL.Add('Update or Insert into Kellner (Firma, KellnerId, Nachname, LocationId)');
      aQuery.SQL.Add('Values(:CompanyId, :WaiterId, :Surname, :LocationId)');
      aQuery.SQL.Add('matching (Firma, KellnerId, LocationId)');
      for var Item in WaiterArray do
      begin
        with aQuery do
        begin
          close;
          Connection := aConnection;
          ParamByName('CompanyId').AsInteger := Item.GetValue<integer>('CompanyId');
          ParamByName('WaiterId').AsInteger := Item.GetValue<integer>('WaiterId');
          ParamByName('Surname').AsString := Item.GetValue<string>('Surname');
          if (aLocationId <> '') then
          begin
            ParamByName('LocationId').AsString := aLocationId;
          end;
          ExecSQL;
          close;
        end;
      end;
      isCorrect := true;
    except
      on E: Exception do
      begin
        Log.WriteToLog(compName, 0, '<TAPI> transmitWaiter: ' + E.Message, lmtError);
        aErrorString := E.Message;
        isCorrect := False;
      end;
    end;
  finally
    result := TJSONObject.Create;
    result.AddPair('FullyTransferred', TJSONBool.Create(isCorrect));
    if not isCorrect then
      result.AddPair('Error', aErrorString);
    Log.WriteToLog(compName, 0, '<TAPI> transmitWaiter Out JSON: ' + result.ToString);
    aConnection.Connected := False;
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
  aLocationId: string;
begin
  try
    try
      isCorrect := False;
      if not pArticles.TryGetValue<string>('percSilenz', compName) then
      begin
        compName := DM.FUserCompanyName;
        Log.WriteToLog(compName, 0, '<TAPI> transmitArticles ' +
          'Auslesen von CompanyName aus  JSON war nicht möglich! ');
      end
      else
      begin
        if compName = '' then
        begin
          compName := DM.FUserCompanyName;
          Log.WriteToLog(compName, 0, '<TAPI> transmitArticles CompanyName im JSON ist leer! ');
        end;
      end;
      aLocationId := '';
      pArticles.TryGetValue<string>('locationID', aLocationId);
      try
        aQuery := TFDQuery.Create(nil);
        aConnection := TFDConnection.Create(nil);
        aConnection.Params.Clear;
        aConnection.ConnectionDefName := compName;
        aConnection.Connected := true;
      except
        on E: Exception do
        begin
          Log.WriteToLog(compName, 0, '<TAPI> transmitArticles/Create Connection: ' + E.Message, lmtError);
        end;
      end;
      ArticleArray := pArticles.GetValue('Articles') as TJSONArray;
      aQuery.SQL.Clear;
      aQuery.SQL.Add('Update or Insert into Artikel (Firma, ArtikelId, Bezeichnung, LocationId)');
      aQuery.SQL.Add('Values(:CompanyId, :ArticleId, :Description, :LocationId)');
      aQuery.SQL.Add('matching (Firma, ArtikelId, LocationId)');
      for var Item in ArticleArray do
      begin
        with aQuery do
        begin
          close;
          Connection := aConnection;
          ParamByName('CompanyId').AsInteger := Item.GetValue<integer>('CompanyId');
          ParamByName('ArticleId').AsInteger := Item.GetValue<integer>('ArticleId');
          ParamByName('Description').AsString := Item.GetValue<string>('Description');
          if (aLocationId <> '') then
          begin
            ParamByName('LocationId').AsString := aLocationId;
          end;
          ExecSQL;
          close;
        end;
      end;
      isCorrect := true;
    except
      on E: Exception do
      begin
        Log.WriteToLog(compName, 0, '<TAPI> transmitArticles: ' + E.Message, lmtError);
        aErrorString := 'Fataler Datenbank Fehler';
        isCorrect := False;
      end;
    end;
  finally
    result := TJSONObject.Create;
    result.AddPair('FullyTransferred', TJSONBool.Create(isCorrect));
    if not isCorrect then
      result.AddPair('Error', aErrorString);
    Log.WriteToLog(compName, 0, '<TAPI> transmitArticles Out JSON: ' + result.ToString);
    aConnection.Connected := False;
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
  aBookWithCashDeskDate: boolean;
  aConnection: TFDConnection;
  aTempDM: TTM;
  aLocationId, aText: string;
begin
  try
    try
      Log.WriteToLog(DM.FUserCompanyName, 0, '<TAPI> LosungKellner In JSON: ' + pLosung.ToJson);
      aBookWithCashDeskDate := False;
      aLocationId := '';
      if not pLosung.TryGetValue<string>('percSilenz', compName) then
      begin
        compName := DM.FUserCompanyName;
        Log.WriteToLog(compName, 0, '<TAPI> LosungKellner ' +
          'Auslesen von CompanyName aus  JSON war nicht möglich! ');
      end
      else
      begin
        if compName = '' then
        begin
          compName := DM.FUserCompanyName;
          Log.WriteToLog(compName, 0, '<TAPI> LosungKellner CompanyName im JSON ist leer! ');
        end;
      end;
      if not pLosung.TryGetValue<string>('Firma', aFirma) then
        aFirma := IntToStr(1);
      // Überprüfung ob alle Buchungen aufs KassenDatum gesendet werden sollen und nicht aufs FelixDatum
      pLosung.TryGetValue<boolean>('bookWithCashDeskDate', aBookWithCashDeskDate);
      // Überprüfung ob zwei verschiedene Kassendatenbanken auf ein Felix zugreifen
      pLosung.TryGetValue<string>('locationId',aLocationId);

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
          Log.WriteToLog(compName, strToInt(aFirma), '<TAPI> LosungKellner/Create Connection: ' + E.Message,
            lmtError);
          raise;
        end;
      end;
      try
        result := TJSONObject.Create;
      except
        on E: Exception do
        begin
          Log.WriteToLog(compName, strToInt(aFirma), '<TAPI> LosungKellner/Create result Object: ' + E.Message,
            lmtError);
          raise;
        end;
      end;
      testStr := pLosung.ToString;
      isCheckUmsatzTag := False;
      try
        aTempDM.TableLosungsZuordnung.Connection := aConnection;
        aTempDM.TableLosungsZuordnung.open;
      except
        on E: Exception do
        begin
          Log.WriteToLog(compName, strToInt(aFirma), '<TAPI> LosungKellner/TableLosungsZuordnung.open: ' +
            E.Message, lmtError);
          raise;
        end;
      end;

      try
        aFelixDate := aTempDM.getFelixDate(aConnection, aFirma);
      except
        on E: Exception do
        begin
          Log.WriteToLog(compName, strToInt(aFirma), '<TAPI> LosungKellner/get Company and Felix Date: ' +
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
          if aBookWithCashDeskDate then
          begin
            aFelixDate := aOldKasseDate;
          end;
          aRechnungsId := aTempDM.CreateInvoice0(aFelixDate, aOldKasseDate, strToInt(aFirma), compName, aLocationId);
          for var aLosung in aLosungen do
          begin
            aKasseDate := StrToDate(aLosung.GetValue<string>('Datum'));
            if aBookWithCashDeskDate then
            begin
              aFelixDate := aOldKasseDate;
            end;
            if aOldKasseDate <> aKasseDate then
            begin
              aRechnungsId := aTempDM.CreateInvoice0(aFelixDate, aKasseDate, strToInt(aFirma), compName, aLocationId);
              aOldKasseDate := aKasseDate
            end;
            aOldKasseDate := aKasseDate;

            aLosung.TryGetValue('Nachname', aNachname);

            AZahlWegID := strToInt(aLosung.GetValue<string>('ZahlwegID'));
            aBetrag := aLosung.GetValue<double>('Betrag');
            aWaiterReservID := strToInt(aLosung.GetValue<string>('WaiterReservID'));
            // aKasseDate := StrToDate(aLosung.GetValue<string>('Datum'));

            if aTempDM.TableLosungsZuordnung.Locate('Firma;ZahlwgIDKasse',
              VarArrayOf([aFirma, AZahlWegID]), [])
              or
              aTempDM.TableLosungsZuordnung.Locate('ZahlwgIDKasse',
              AZahlWegID, [])
            Then
              aFelixZahlwegID := aTempDM.TableLosungsZuordnung.FieldByName('ZahlwgIDFelix').AsLargeInt
              // Sonst muss zumindest der 0 Kellner exestieren
            else
              aFelixZahlwegID := AZahlWegID;
            aBetrag := aBetrag;
            // Für schreiben ins Journal oder Waiter Gastkonto
              if (aLocationId <> '') then
              begin
                aText := 'Losung '+ aLocationId+ ' / ' + DateToStr(aKasseDate)
              end
              else
              begin
                aText := 'Losung ' + DateToStr(aKasseDate)
              end;
            if (aTempDM.ReadGlobalValue(aConnection, 'GKTWaiterArticleID', '0', 'KINTEGER') > 0)
              and (aFelixZahlwegID = 1)
            then
            begin
              if aWaiterReservID > 0 then
              begin

                aTempDM.WriteLeistungToGastKontoIB(aConnection, aFelixDate,
                  strToInt(aFirma), aWaiterReservID, 1,
                  aTempDM.ReadGlobalValue(aConnection, 'GKTWaiterArticleID', '0',
                  'KINTEGER'), 1, aBetrag, False, False, False, False,
                  aText, '', 7, 0, aWaiterReservID,
                  null, null, compName);
                aBetrag := 0;
              end;
            end;

            aTempDM.WriteToKassenJournal(aConnection, aFelixDate,
              aText + ' | ' + aNachname,
              aFelixZahlwegID, null, null, null, 7, null, aBetrag, False,
              strToInt(aFirma), 1 { <-- MitarbeiterID } ,
              1 { <-- KassaID } , null, compName);
            aTempDM.TableRechZahlweg.Append;
            aTempDM.TableRechZahlweg.FieldByName('ID').AsLargeInt :=
              aTempDM.GetGeneratorID(aConnection, 'id', 1, compName);
            aTempDM.TableRechZahlweg.FieldByName('Firma').AsLargeInt := strToInt(aFirma);
            aTempDM.TableRechZahlweg.FieldByName('Datum').AsDateTime := aFelixDate;
            aTempDM.TableRechZahlweg.FieldByName('RechnungsID').AsLargeInt := aRechnungsId;
            aTempDM.TableRechZahlweg.FieldByName('Zahlwegid').AsLargeInt := aFelixZahlwegID;
            aTempDM.TableRechZahlweg.FieldByName('Verbucht').AsBoolean := true;
            aTempDM.TableRechZahlweg.FieldByName('Betrag').AsFloat := aBetrag;
            aSumBetrag := aSumBetrag + aBetrag;
            aTempDM.TableRechZahlweg.Post;

            aTempDM.TableZahlweg.Connection := aConnection;
            aTempDM.TableZahlweg.open;
            if aTempDM.TableZahlweg.Locate('Firma;ID;KreditKarte',
              VarArrayOf([aFirma, aFelixZahlwegID, 'T']), []) then
            // #32374 17.04.23 GW: Es wurde der Kassenzahlweg verwendet, daher kam es zu falschen Zahlwegen im Felix
            begin
              aTempDM.InsertKreditOffen(aConnection, strToInt(aFirma), aBetrag,
                aFelixZahlwegID, aFelixDate, 0, aWaiterReservID, compName);
              // #32374 17.04.23  GW: auch hier Zahlwegänderung
            end;
            aTempDM.TableZahlweg.close;

            if (aLosungen.Count > 0) then
            begin
              aTempDM.TableRechnung.Edit;
              aTempDM.TableRechnung.FieldByName('ZahlungsBetrag').AsFloat := aSumBetrag;
              aTempDM.TableRechnung.FieldByName('BereitsBezahlt').AsFloat := aSumBetrag;
              aTempDM.TableRechnung.Post;
            end
            else
            begin
              // es war gar keine Barlosung an dem tag!
              aTempDM.TableRechZahlweg.Append;
              aTempDM.TableRechZahlweg.FieldByName('Firma').AsLargeInt := strToInt(aFirma);
              aTempDM.TableRechZahlweg.FieldByName('Datum').AsDateTime := aFelixDate;
              aTempDM.TableRechZahlweg.FieldByName('RechnungsID').AsLargeInt := aRechnungsId;
              aTempDM.TableRechZahlweg.FieldByName('Zahlwegid').AsLargeInt := 1;
              aTempDM.TableRechZahlweg.FieldByName('Verbucht').AsBoolean := true;
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
        Log.WriteToLog(compName, strToInt(aFirma), '<TAPI> LosungKellner: ' +
          E.Message, lmtError);
        result := TJSONObject.ParseJSONValue('{"Durchgeführt": "' + E.Message +
          '"}') as TJSONObject;
      end;
    end;
  finally
    aTempDM.TableLosungsZuordnung.close;
    aTempDM.TableRechZahlweg.close;
    aTempDM.TableRechnung.close;
    aConnection.Connected := False;
    aConnection.Free;
    aTempDM.Free;
    Log.WriteToLog(compName, strToInt(aFirma), '<TAPI> LosungKellner Out JSON: ' +
      result.ToString, lmtInfo);
  end;

end;

// ***********************
// Umsatz übermittlung **
// ***********************

function TAPI.processesCashRegister(pCashReg: TJSONObject): TJSONObject;
var
  aCashValues: TJSONArray;
  aLeistungsID: integer;
  isWritten, isBackBooking, aIsDoubleBooking: boolean;
  aFirma, aKasseID, aHauptGruppeID, aLeistungsBezeichnung, aBetrag, aMitArbID,
    compName, JStr, aResultBuchUmsatz, aDateString, aAmountString: string;
  aUmsatzDatum, aFelixDate, aOldSalesDate: TDate;
  aConnection: TFDConnection;
  aTempDM: TTM;
  aError: TStrings;
  aMailOut: string;
  aRechId: Int64;
  aRechQuery: TFDQuery;
  aBookWithCashDeskDate: boolean;
  aLocationId: string;
  aFelixNachKassen: boolean;
  // aQueryTemp: TFDQuery;
  procedure BucheUmsatz(pBetrag: Currency);
  var
    aTempQuery: TFDQuery;
  begin
    try
      aTempQuery := TFDQuery.Create(nil);
      aTempQuery.Connection := aConnection;
      aTempQuery.SQL.Add('select id from Rechnung where VonDatum = ''' + DateToStr(aUmsatzDatum) + ''' ');
      aTempQuery.SQL.Add(' and Rechnungsnummer in (0,99999)');
      if (aLocationId <> '') then
      begin
        aTempQuery.SQL.Add('and Bemerkung = ' + QuotedStr(aLocationId));
      end;
      aTempQuery.open;
      if aTempQuery.RecordCount > 0 then
        aRechId := StrToInt64(aTempQuery.FieldByName('id').AsString)
      else
      begin
        aRechId := aTempDM.CreateInvoice0(aFelixDate, aUmsatzDatum, strToInt(aFirma), compName,aLocationId);
      end;

      Log.WriteToLog(compName, strToInt(aFirma), '<TAPI> BucheUmsatz: Umsatzdatum: ' + DateToStr(aUmsatzDatum) +
        ' Firma: ' + aFirma + ' LeistungsId: ' + IntToStr(aLeistungsID) +
        ' Betrag: ' + FloatToStr(pBetrag) + ifThen((aLocationId <> ''), 'LocationId: '+aLocationId, ''), lmtInfo);
      aTempDM.WriteToKassenJournal(aConnection, aFelixDate,
        ifThen((aLocationId <> ''),'Umsatz Kasse '+aLocationId +' / ' + DateToStr(aUmsatzDatum),
              'Umsatz Kasse | ' + DateToStr(aUmsatzDatum)),
         null, 1, aLeistungsID,
        null, 12, null, pBetrag, False, strToInt(aFirma), 1,
        strToInt(aKasseID), null, compName);

      if pBetrag <> 0 then
        aTempDM.WriteToTableRechnungskonto(strToInt(aFirma),
          aLeistungsID, 1, pBetrag, aRechId, aFelixDate, aLeistungsBezeichnung, compName);

    finally
      aTempDM.TableRechnung.close;
      aTempQuery.close;
      aTempQuery.Free;
    end;

    try
      try
        With aTempQuery Do
        Begin
          // *****************************************
          // Buchungen Gegenbuchen, damit der Betrag im Journal wieder stimmt
          // *****************************************
          aTempQuery := TFDQuery.Create(nil);
          aTempQuery.Connection := aConnection;
//          close;
//          SQL.Clear;
//          SQL.Add('UPDATE KassenJournal');
//          SQL.Add('SET Menge = 0');
//          SQL.Add('WHERE Datum = ''' + DateToStr(aUmsatzDatum) + ''' AND');
//          SQL.Add('LeistungsID IN');
//          SQL.Add('(SELECT LeistungsID FROM Kass_Tischzuordnung)');
//          SQL.Add('and not Text = '+ QuotedStr('Gegenbuchung Kasse | ' + DateToStr(aUmsatzDatum)));
//          ExecSQL;

          close;
          SQL.Clear;
          SQL.Add('select LEISTUNGSID, sum(Menge*Betrag) as Betrag From KassenJournal');
          SQL.Add('WHERE Datum = ''' + DateToStr(aUmsatzDatum) + ''' AND');
          SQL.Add('BearbeiterID IS NULL AND Firma = ' + aFirma);
          SQL.Add(' AND LeistungsID IN');
          SQL.Add('(SELECT LeistungsID FROM Kass_Tischzuordnung)');
          SQL.Add('and not Text = '+ QuotedStr('Gegenbuchung Kasse | ' + DateToStr(aUmsatzDatum)));
          SQL.Add('and not Text = '+ QuotedStr('Gegenbuchung Kasse '+ aLocationId +' | ' + DateToStr(aUmsatzDatum)));
          if aFelixNachKassen then
            SQL.Add('and KassaId = ' + aKasseID );
          SQL.Add('group by LeistungsId');
          open;
          while not EOF do
          begin
            if not (aTempDM.CheckDoubleBookingGegenbuchungKasse(aConnection,compName, strToInt(aFirma),
                               FieldByName('Betrag').AsFloat,
                               FieldByName('LEISTUNGSID').AsLargeInt, aUmsatzDatum, aLocationId )) then
            begin
               Log.WriteToLog
               (compName, strToInt(aFirma),'<TAPI> ' +
               'BucheUmsatz: insert Gegenbuchung Kasse Betrag = Betrag = ' +
               FieldByName('Betrag').AsString +
               ' LeistungsId = ' + FieldByName('LEISTUNGSID').AsString, lmtInfo);

              aTempDM.WriteToKassenJournal(aConnection, aFelixDate,
              ifthen((aLocationId <> ''), 'Gegenbuchung Kasse ' + aLocationId + ' | ' + DateToStr(aUmsatzDatum),
              'Gegenbuchung Kasse | ' + DateToStr(aUmsatzDatum)), null, -1, FieldByName('LEISTUNGSID').AsInteger,
                null, 6, null, FieldByName('Betrag').AsFloat, False, strToInt(aFirma), 1,
                strToInt(aKasseID), null, compName);
            end;
            next;
          end;
        End; // with

      except
        on E: Exception do
        begin
          aError.Add('BucheUmsatz: Fehler bei UPDATE KassenJournal | Bitte Prüfen Umsatzdatum : ' +
            DateToStr(aUmsatzDatum)
            + ' Firma: ' + aFirma);
          Log.WriteToLog(compName, strToInt(aFirma), '<TAPI> ' +
            'BucheUmsatz: Fehler bei UPDATE KassenJournal | Bitte Prüfen Umsatzdatum : ' +
            DateToStr(aUmsatzDatum)
            + ' Firma: ' + aFirma + ' Meldung: ' + E.Message, lmtError);
        end;
      end;
    finally
      aTempDM.QueryFelix.close;
      aTempDM.QueryUpdateJournalBetrag.close;
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
      aFelixNachKassen := false;
      aError := TSTringList.Create;
      aRechId := 0;
      aLocationId := '';
      aBookWithCashDeskDate := False;
      // Bei alten Client Versionen kann es vorkommen dass es noch nicht implementiert wurde, deshalb abfragen
      if not(pCashReg.TryGetValue<string>('percSilenz', compName))
        and not(pCashReg.TryGetValue<string>('PercSilenz', compName)) then
      begin
        compName := DM.FUserCompanyName;
        Log.WriteToLog(compName, strToInt(aFirma),
          '<TAPI> processesCashRegister: Auslesen von CompanyName aus  JSON war nicht möglich! ');
      end
      else
      begin
        if compName = '' then
        begin
          compName := DM.FUserCompanyName;
          Log.WriteToLog(compName, strToInt(aFirma),
            '<TAPI> processesCashRegister: CompanyName im JSON ist leer! ');
        end;
      end;

      // Überprüfung ob alle Buchungen aufs KassenDatum gesendet werden sollen und nicht aufs FelixDatum
      pCashReg.TryGetValue<boolean>('bookWithCashDeskDate', aBookWithCashDeskDate);

      // Überprüfung ob mehrere Kassendatenbanken in eine Felix Datenbank schreiben
      pCashReg.TryGetValue<string>('locationId', aLocationId);  // noch anpassen

      if not pCashReg.TryGetValue<string>('companyId', aFirma) then
        aFirma := IntToStr(DM.FUserFirmaID);
      if aFirma = '' then
        aFirma := '1';

      result := TJSONObject.Create;
      // Verbindung zur Datenbank aufbauen
      try
        aTempDM := TTM.Create(nil);
        aConnection := TFDConnection.Create(nil);
        aTempDM.MainConnection.close;
        aTempDM.MainConnection.Params.Clear;
        aTempDM.MainConnection.ConnectionDefName := compName;
        aTempDM.MainConnection.Connected := true;
        aConnection.Params.Clear;
        aConnection.ConnectionDefName := compName;
        aConnection.Connected := true;
      except
        on E: Exception do
        begin
          Log.WriteToLog(compName, strToInt(aFirma), '<TAPI> processesCashRegister/Create Connection: '
            + E.Message, lmtError);
          raise;
        end;
      end;

      Log.WriteToLog(compName, strToInt(aFirma), '<TAPI> processesCashRegister In JSON: ' + pCashReg.ToJson);
      // Umsätze eintragen
      aCashValues := pCashReg.GetValue('allValues') as TJSONArray;
      aFelixDate := aTempDM.getFelixDate(aConnection, aFirma);
      aTempDM.TableUmsatzzuordnung.Connection := aConnection;
      aTempDM.TableUmsatzzuordnung.open;
      isWritten := False;
      aOldSalesDate := StrToDate('01.01.1999');
      aIsDoubleBooking := False;
      for var aCCount in aCashValues do
      begin
        // Überprüfen ob der Umsatz von dem Tag schon übertragen wurde
        if aCCount.TryGetValue('date', aDateString) then
          aUmsatzDatum := StrToDate(aDateString);
        // Wenn auf Kassendatum gesendet werden soll dann Felixdatum angleichen
        if aBookWithCashDeskDate then
          aFelixDate := aUmsatzDatum;
        // Nur Überprüfen wenn sich das Kassendatum geändert hat
        if (aOldSalesDate <> aUmsatzDatum) then
        begin
          aOldSalesDate := aUmsatzDatum;
          aIsDoubleBooking := aTempDM.CheckSalesDoubleBooking(aUmsatzDatum, aFelixDate, strToInt(aFirma),
            compName, aLocationId);
        end;
        // Wenn keine DoppelBuchung, dann eintragen
        if not aIsDoubleBooking then
        begin
          aCCount.TryGetValue('mainGroupID', aHauptGruppeID);
          if aCCount.TryGetValue('amount', aAmountString) then
            aBetrag := (StringReplace(aAmountString, '.', ',', [rfReplaceAll]))
          else
            aBetrag := '0';
          aCCount.TryGetValue('waiterID', aMitArbID);

          if not aCCount.TryGetValue('cashDeskID', aKasseID) then
          begin
            aFelixNachKassen := false;
            aKasseID := '';
          end
          else
          begin
            aFelixNachKassen := true;
          end;

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

          aTempDM.SetQueryLeistung(strToInt(aFirma), aLeistungsID, aLeistungsBezeichnung, compName);
          aTempDM.QueryLeistung.close;

          // Umsatz in die Datenbank schreiben
          BucheUmsatz(StrToFloat(aBetrag));

          isWritten := true;
        end
        else
        begin
          isWritten := true;
        end;
      end;
      isBackBooking := False;
      try
        aCashValues := pCashReg.GetValue('ValForInvoice') as TJSONArray;
        // isBackBooking := TRUE;
      except
        isBackBooking := False;
        Log.WriteToLog(compName, strToInt(aFirma), '<TAPI> processesCashRegister:' +
          ' Fehler beim Auslesen von ValForInvoice');
        aError.Add('Fehler beim Auslesen von ValForInvoice: Überprüfung ob Client- Versionsnummer >= 3.* ');
      end;
      if aCashValues <> nil then
      begin
        isBackBooking := true;
      end
      else
      begin
        Log.WriteToLog(compName, strToInt(aFirma), '<TAPI> processesCashRegister: ' +
          'Fehler beim Auslesen von ValForInvoice');
        aError.Add('Fehler beim Auslesen von ValForInvoice: Überprüfung ob Client- Versionsnummer >= 3.* ')
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
                  aRechQuery.SQL.Add('select id from Rechnung where VonDatum = ''' +
                    DateToStr(aUmsatzDatum) + ''' ');
                  aRechQuery.SQL.Add(' and Rechnungsnummer in (0,99999)');
                  if (aLocationId <> '') then
                  begin
                    aRechQuery.SQL.Add(' and Bemerkung = '+QuotedStr(aLocationId));
                  end;
                  aRechQuery.open;
                  if aRechQuery.RecordCount > 0 then
                  begin
                    aRechId := aRechQuery.FieldByName('Id').AsInteger;
                  end;
                except
                  on E: Exception do
                  begin
                    Log.WriteToLog(compName, strToInt(aFirma), '<TAPI> processesCashRegister: ' +
                      'Fehler in aRechQuery, Siehe Errorlog ');
                    Log.WriteToLog(compName, strToInt(aFirma), '<TAPI> processesCashRegister/ aRechQuery: ' +
                      E.Message, lmtError);
                  end;
                end;
              finally
                aRechQuery.close;
                aRechQuery.Free;
              end;
            end;
            if aRechId <> 0 then
            begin
              aFelixDate := aTempDM.getFelixDate(aConnection, aFirma);
              for var Value in aCashValues do
              begin
                // Wenn alle Buchungen auf das jeweilige Kassendatum gehen sollen, dann Felixdatum angleichen
                if aBookWithCashDeskDate then
                begin
                  aFelixDate := StrToDate(Value.GetValue<string>('cashDeskDate'));
                end;
                var
                  iTax: double := 0.0;
                if not Value.TryGetValue<double>('Tax', iTax) then
                  iTax := 0;
                aBetrag := '-' + Value.GetValue<string>('amount');
                aKasseID := Value.GetValue<string>('cashDeskID');
                aTempDM.getLeistIDandBez(aConnection,
                  0,
                  iTax,
                  '',
                  true,
                  strToInt(aFirma),
                  Value.GetValue<integer>('cashDeskID'),
                  aLeistungsID,
                  aLeistungsBezeichnung);

                aTempDM.QueryGetDoubleBookingInvoice.close;
                aTempDM.QueryGetDoubleBookingInvoice.ParamByName('LeistungsID').AsInteger := aLeistungsID;
                aTempDM.QueryGetDoubleBookingInvoice.ParamByName('LeistungsText').AsString :=
                  aLeistungsBezeichnung;
                aTempDM.QueryGetDoubleBookingInvoice.ParamByName('GesamtBetrag').AsFloat :=
                  -Value.GetValue<double>('amount');
                aTempDM.QueryGetDoubleBookingInvoice.ParamByName('Datum').AsDateTime := aFelixDate;
                aTempDM.QueryGetDoubleBookingInvoice.ParamByName('Firma').AsString := aFirma;
                aTempDM.QueryGetDoubleBookingInvoice.ParamByName('pRechid').AsLArgeInt := aRechId;
                aTempDM.QueryGetDoubleBookingInvoice.open;
                if aTempDM.QueryGetDoubleBookingInvoice.FieldByName('Id').isNull then
                begin
                  aTempDM.QueryGetDoubleBookingInvoice.close;
                  aTempDM.WriteToTableRechnungskonto(strToInt(aFirma),
                    aLeistungsID,
                    1,
                    -Value.GetValue<double>('amount'),
                    aRechId,
                    aFelixDate,
                    aLeistungsBezeichnung,
                    compName);
                end
                else
                  aTempDM.QueryGetDoubleBookingInvoice.close;
              end;
            end;
          except
            on E: Exception do
            begin
              aError.Add('Fehler bei update Rechnungskonto | LeistungsId: ' + IntToStr(aLeistungsID) +
                ' Betrag: ' + aBetrag + ' Datum: ' + DateToStr(aFelixDate) + ' Buchungszeit: ' +
                DateToStr(now));
              Log.WriteToLog(compName, strToInt(aFirma), '<TAPI> processesCashRegister ' +
                'Fehler bei update Rechnungskonto | LeistungsId: ' +
                IntToStr(aLeistungsID) + 'Betrag: ' + aBetrag +
                ' Meldung: ' + E.Message, lmtInfo);
            end;
          end;
        finally
          aTempDM.QueryGetDoubleBookingInvoice.close;
        end;

      aTempDM.TableUmsatzzuordnung.close;
      // ''''''''''''''''''''''''''''''''
      // aTempDM.getRebookings(aConnection, aUmsatzDatum, aFirma);
      // aTempDM.setAllRebookingsToNull(aConnection, aUmsatzDatum, aFirma);
      // ''''''''''''''''''''''''''''''''''
      if not isWritten then
      begin
        result.AddPair('result', 'Es waren keine Einträge vorhanden ' + aResultBuchUmsatz);
      end
      else
      begin
        result.AddPair('result', 'Umsatz wurde übertragen ' + aResultBuchUmsatz);
      end;
    except
      on E: Exception do
      begin
        Log.WriteToLog(compName, strToInt(aFirma), '<TAPI> processesCashRegister ' +
          'Fehler in UmsatzKassa: ' + E.Message, lmtError);
        result.AddPair('result', 'error: ' + E.Message + aResultBuchUmsatz);
      end;
    end;
  finally
    // Überprüfen ob Email zu senden ist und Email senden
    if aError.Count > 0 then
    begin
      var
        aEmail: TDataEmail;
      aEmail := TDataEmail.Create(nil);
      aEmail.SendEmail(compName, 'Übermittlung von Umsätzen', aMailOut, 'Fehler bei einer Umsatzübermittlung',
        aError, DM.ErrorMail);
      if aMailOut <> '' then
      begin
        Log.WriteToLog(compName, strToInt(aFirma), '<TAPI> processesCashRegister/SendEmail: ' + aMailOut,
          lmtError);
      end
      else
      begin
        Log.WriteToLog(compName, strToInt(aFirma), '<TAPI> processesCashRegister/SendEmail: ' +
          'FehlerMail wurde an ' + DM.ErrorMail + ' gesendet! ');
      end;
      FreeAndNil(aEmail);
    end;
    Log.WriteToLog(compName, strToInt(aFirma), '<TAPI> processesCashRegister Out JSON: ' + result.ToString);
    aConnection.Connected := False;
    aConnection.Free;
    aTempDM.Free;
    aError.Free;
  end;
end;

// ****************************************
// Funktion zur Rechnungs übermittlung
// ****************************************
function TAPI.bookABill(pParams: TJSONObject): TJSONObject;
var
  aDeskNr, aText, aTimeString, aResultString, aBillId, aArticleID,
    aCompName, aDiscountStr: string;
  aTime: TTime;
  aAmount, aTax, aDiscount: double;
  aWaiterId, aPaymentMethodId, aQuantity, aFirma: integer;
  aIsBooked: boolean;
  aDataArray, aResultArray, aAtricleArray: TJSONArray;
  aResultObject: TJSONObject;
  aConnection: TFDConnection;
  aTempDM: TTM;
begin
  try
    try

      if not pParams.TryGetValue<string>('percSilenz', aCompName) then
      begin
        aCompName := DM.FUserCompanyName;
        Log.WriteToLog(aCompName, aFirma, '<TAPI> bookABill: ' +
          'Auslesen von CompanyName aus  JSON war nicht möglich! ');
      end
      else
      begin
        if aCompName = '' then
        begin
          aCompName := DM.FUserCompanyName;
          Log.WriteToLog(aCompName, aFirma, '<TAPI> bookABill: CompanyName im JSON ist leer! ');
        end;
      end;
      if not pParams.TryGetValue<integer>('companyId', aFirma) then
      begin
        aFirma := 1;
      end;
      Log.WriteToLog(aCompName, aFirma, '<TAPI> bookABill: ' + pParams.ToJson);
      // aCompName := DM.FUserCompanyName;
      aIsBooked := False;
      try
        aTempDM := TTM.Create(nil);
        aConnection := TFDConnection.Create(nil);
        aConnection.ConnectionDefName := aCompName;
        aConnection.Connected := true;
      except
        on E: Exception do
        begin
          Log.WriteToLog(aCompName, aFirma, '<TAPI> bookABill/Create Connection: ' + E.Message,
            lmtError);
          raise;
        end;
      end;
      aResultArray := TJSONArray.Create;
      aDataArray := pParams.GetValue('bookInfo') as TJSONArray;
      for var Item in aDataArray do
      begin
        aIsBooked := False;
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
        aText := aText + ' ' + aBillId;
        aTax := (StringReplace(Item.GetValue<string>('taxRate'), '.', ',',
          [rfReplaceAll])).ToDouble;
        aAmount := (StringReplace(Item.GetValue<string>('amount'), '.', ',',
          [rfReplaceAll])).ToDouble;
        // #32591
        if Item.TryGetValue<string>('discount', aDiscountStr) then
        begin
          aDiscount := (StringReplace(aDiscountStr, '.', ',',
            [rfReplaceAll])).ToDouble
        end
        else
        begin
          aDiscount := 0;
        end;
        aResultObject := TJSONObject.Create;
        aIsBooked := aTempDM.WriteToGastkontoRechnung(aConnection, aDeskNr,
          aTime, aAmount, aTax, aWaiterId, aPaymentMethodId, aText, aFirma, aDiscount,
          aResultString, aCompName);
        if aIsBooked then
        begin
          aResultObject.AddPair('billId', aBillId);
          aResultObject.AddPair('booked', TJSONBool.Create(true));
        end
        else
        begin
          aResultObject.AddPair('billId', aBillId);
          aResultObject.AddPair('booked', TJSONBool.Create(False));
          aResultObject.AddPair('error', aResultString);
        end;
        aResultArray.AddElement(aResultObject);
      end;
      result := TJSONObject.ParseJSONValue('{"value": ' + aResultArray.ToJson +
        '}') as TJSONObject;
    except
      on E: Exception do
      begin
        Log.WriteToLog(aCompName, aFirma, '<TAPI> bookABill:  ' + E.Message,
          lmtError);
        aResultObject := TJSONObject.Create;
        aResultObject.AddPair('billId', aBillId);
        aResultObject.AddPair('booked', 'false');
        aResultObject.AddPair('error', E.Message);
        result := TJSONObject.ParseJSONValue('{"value":' + aResultObject.ToJson
          + '}') as TJSONObject;
      end;
    end;
  finally
    Log.WriteToLog(aCompName, aFirma, '<TAPI> bookABill Out JSON: ' + result.ToString);
    aConnection.Connected := False;
    aConnection.Free;
    aTempDM.Free;
  end;

end;

end.
