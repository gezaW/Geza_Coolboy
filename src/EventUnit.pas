unit EventUnit;

interface

uses
  System.SysUtils, System.Classes, System.JSON, System.Variants,
  System.DateUtils,
  ServerIntf, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.FB, FireDAC.Phys.FBDef,
  FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet;

type
  TEvent = class(TDataModule)
    OEBBConnection: TFDConnection;
    QueryGetEvents: TFDQuery;
    QueryGetReservData: TFDQuery;
    QueryCheckGast: TFDQuery;
    QueryCheckSeminarRes: TFDQuery;
    QueryParticipant: TFDQuery;
    QueryInsertTemp: TFDQuery;
    QueryInsertSeminarRes: TFDQuery;
    QueryTemp: TFDQuery;
    QueryCheckEvent: TFDQuery;
    QueryInsertSeminar: TFDQuery;
    QueryInsertGast: TFDQuery;
    QueryUpdateGast: TFDQuery;
    QuerySeminarGenID: TFDQuery;
    QueryUpdateReservState: TFDQuery;
    QueryselectReserv: TFDQuery;
    QueryInsertReservJournal: TFDQuery;
    QueryCheckinTelefon: TFDQuery;
    QueryGetFelixDate: TFDQuery;
    QueryApparate: TFDQuery;
    QueryUpdateApperate: TFDQuery;
    QueryGetArrangemntArticle: TFDQuery;
    QueryCheckEventByName: TFDQuery;
    QueryGetUID: TFDQuery;
    QueryCheckReserv: TFDQuery;
    QueryGetReservDataForKeyCard: TFDQuery;
    QueryGetNewReservPAck: TFDQuery;
    QuerySetArrSend: TFDQuery;
    QueryGetLogArrId: TFDQuery;
    QueryGetReservDates: TFDQuery;
  private
    FCompanyName: string;
    function CheckGast(pGAstId: integer): boolean;
    procedure InsertGast(aGastid, aMarktsegmentID, aOrgEinheitInt, asprachid,
      aGastkZ9ID: integer; aNachname, aNachnamegross, aVorname, aZusatzname,
      aOrt, aTitle, aEmail, aKostenstelle, aOrgEinheit, aBuchungsKreis,
      aTelBuero, aMobil: String);
    procedure InsertSeminarRes(pReservid, pGastname: String;
      pRaumID, pGAstId, pTeilnehmeranzahl: integer;
      pVon, pBis, pVonUhr, pBisUhr: TDateTime);
    procedure InsertSeminar(pReservid: string;
      pRaumID, pTeilnehmeranzahl: integer;
      pVon, pBis, pVonUhr, pBisUhr: TDateTime);
    procedure InsertSeminarTrainer(pReservid, pGAstId: integer;
      pNachname: string);
    function SetGeneratorID(aGenerator: String): integer;
    procedure InsertParticipants(pReservid, pGAstId: Int64; pAnzahl: integer);
    function insertReservJournal(pReservid: Int64): boolean;
    function CheckInTelephone(pRoom, pCompanyId: integer; pGuestName: string;
      pPayTv: boolean): boolean;
    procedure SetTelefonAndTV(AZimmerID: LongInt; CheckIn: boolean;
      AGastName: String; pFirma: integer; pPayTv: boolean);

    { Private-Deklarationen }
  public
    { Public-Deklarationen }
     property CompanyName: string  read FCompanyName write FCompanyName;
    function getEvents(pDafaultUser: string; pParams: TJsonObject;
      var pResultArr: TJsonArray; var aMessage: String): boolean;
    procedure getReservData(pDafaultUser: string; pParams: TJsonObject;
      var pResultArr: TJsonArray);
    function setOrgOrTeiln(pDafaultUser: string; pParams: TJsonObject;
      var pResultArr: TJsonArray): boolean;
    function setVeranstaltung(pDafaultUser: string; pParams: TJsonObject;
      var pResultArr: TJsonArray): boolean;
    function setReservState(pDafaultUser: string; pParams: TJsonObject;
      var pResultObj: TJsonObject): boolean;
    function getReservArticle(pDafaultUser: string; pParams: TJsonObject;
      pFirma: integer; var pResultArr: TJsonArray;
      var aMessage: String): boolean;
    function getUIDs(pDafaultUser: string; pFirma: integer;
      var pResultArr: TJsonArray; var aMessage: String): boolean;
    function getNewPack(pDafaultUser: string; pFirma: integer;
      var pResultArr: TJsonArray; var ArrIds: TStringList): boolean;
    procedure setArrToSend(pDafaultUser, pLogArrId: String);
  end;

var
  Event: TEvent;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}
{$R *.dfm}


uses DataModule, Resources, Logging;
{ TOEBB }

function TEvent.SetGeneratorID(aGenerator: String): integer;
begin
  Result := 0;

  with QuerySeminarGenID do
    try
      Close;
      SQL.CLear;
      SQL.Add('Select Gen_ID(' + aGenerator + ',1) from RDB$database');
      Open;
      Result := FieldByName('Gen_ID').asInteger;
      Close;
    except
      on e: Exception do
        Log.WriteToLog(FCompanyName, 0,'<TEvent> SetGeneratorID: ' + e.Message,
          lmtError);
    end;
end;

function TEvent.CheckGast(pGAstId: integer): boolean;
begin
  Result := False;

  if pGAstId > 0 then
  begin
    with QueryCheckGast do
      try
        Close;
        ParamByName('pGastID').asInteger := pGAstId;
        Open;
        if QueryCheckGast.RecordCount > 0 then
          Result := true;
      except
        on e: Exception do
        begin
          Log.WriteToLog(FCompanyName, 0,'<TEvent> CheckGast: '
            + e.Message, lmtError);
        end;
      end; // End of try
  end;

end;

procedure TEvent.InsertGast(aGastid, aMarktsegmentID, aOrgEinheitInt, asprachid,
  aGastkZ9ID: integer; aNachname, aNachnamegross, aVorname, aZusatzname, aOrt,
  aTitle, aEmail, aKostenstelle, aOrgEinheit, aBuchungsKreis, aTelBuero,
  aMobil: String);
var
  i: integer;
begin

  with QueryInsertGast do
  begin
    try
      ParamByName('Gastid').asInteger := aGastid;
      ParamByName('MarktsegmentID').asInteger := aMarktsegmentID;
      ParamByName('IndKundennr').asInteger := aOrgEinheitInt;
      ParamByName('sprachid').asInteger := asprachid;
      ParamByName('GASTKZ9ID').asInteger := aGastkZ9ID;
      ParamByName('nachname').AsString := Copy(aNachname, 1, 50);
      ParamByName('NachnameGross').AsString := Copy(aNachnamegross, 1, 50);
      ParamByName('Vorname').AsString := Copy(aVorname, 1, 40);
      ParamByName('Zusatzname').AsString := Copy(aZusatzname, 1, 40);
      ParamByName('Titel').AsString := Copy(aTitle, 1, 30);
      ParamByName('EMail').AsString := Copy(aEmail, 1, 60);
      // ParamByName('Hobbies').AsString := aKostenstelle;
      ParamByName('Ort').AsString := aKostenstelle;
      ParamByName('Website').AsString := aOrgEinheit;
      ParamByName('Reisepass').AsString := aBuchungsKreis;
      if aTelBuero <> '' then
        ParamByName('TELBUERO').AsString := Copy(aTelBuero, 1, 25);
      if aMobil <> '' then
        ParamByName('Mobil').AsString := Copy(aMobil, 1, 25);
      ExecSQL;
    except
      on e: Exception do
      begin
        Log.WriteToLog(FCompanyName, 0,'<TEvent> InsertGast: ' + e.Message,
          lmtError);
      end;
    end;
  end;
end;

procedure TEvent.getReservData(pDafaultUser: string; pParams: TJsonObject;
  var pResultArr: TJsonArray);
var
  aFirma: integer;
  aCompName: string;
  aTempObj: TJsonObject;
  aReservArray: TJsonArray;
begin
  if not pParams.TryGetValue<integer>('companyId', aFirma) then
    aFirma := 1;
  if not pParams.TryGetValue<string>('percSilenz', aCompName) then
  begin
    aCompName := pDafaultUser;
    Log.WriteToLog(aCompName, aFirma,'<TEvent> getReservData: '+
      'Auslesen von CompanyName aus  JSON war nicht möglich! ');
  end
  else
  begin
    if aCompName = '' then
    begin
      aCompName := pDafaultUser;
      Log.WriteToLog(aCompName, aFirma,'<TEvent> getReservData: CompanyName im JSON ist leer! ');
    end;
  end;
  try
    try
      OEBBConnection.Close;
      OEBBConnection.Params.CLear;
      OEBBConnection.ConnectionDefName := aCompName;
      OEBBConnection.Connected := true;
      aReservArray := pParams.GetValue('reservIds') as TJsonArray;
      for var i := 0 to aReservArray.Count - 1 do
      begin
        with QueryGetReservData do
        begin
          Close;
          ParamByName('ReservId').AsString :=
            stringreplace(aReservArray[i].ToString, '"', '',
            [rfReplaceAll, rfIgnoreCase]);
          ParamByName('Firma').asInteger := aFirma;
          Open;
          if not EOF then
          begin
            aTempObj := TJsonObject.Create;
            aTempObj.AddPair('ReservId', FieldByName('Id').AsString);
            if not(FieldByName('Storniert').AsString = 'T') then
            begin
              if FieldByName('CheckIn').AsString = 'T' then
              begin
                aTempObj.AddPair('status', 'checkIn');
              end
              else if (FieldByName('CheckIn').AsString = 'F') and
                (FieldByName('Abgereist').AsString = 'T') then
              begin
                aTempObj.AddPair('status', 'checkOut');
              end
              else
              begin
                aTempObj.AddPair('status', 'reservation');
              end;
            end
            else
            begin
              aTempObj.AddPair('status', 'cancelled');
            end;
            if FieldByName('room_type').asInteger = 4 then
            begin
              aTempObj.AddPair('pseudo', TJsonBool.Create(true));
            end
            else
              aTempObj.AddPair('pseudo', TJsonBool.Create(False));
            if FieldByName('sperrenextra').AsString = 'T' then
              aTempObj.AddPair('buchungsSperre', TJsonBool.Create(true))
            else
              aTempObj.AddPair('buchungsSperre', TJsonBool.Create(False));

            aTempObj.AddPair('anreiseDatum', FieldByName('anreiseDatum')
              .AsString);
            aTempObj.AddPair('abreiseDatum', FieldByName('abreiseDatum')
              .AsString);
            aTempObj.AddPair('zimmerId',
              TJsonNumber.Create(FieldByName('ZimmerId').asInteger));
            aTempObj.AddPair('nachname', FieldByName('Nachname').AsString);
            aTempObj.AddPair('vorname', FieldByName('Vorname').AsString);
            aTempObj.AddPair('zusatzname', FieldByName('Zusatzname').AsString);
            aTempObj.AddPair('geschlecht', FieldByName('Geschlecht').AsString);
            aTempObj.AddPair('sprache', FieldByName('Sprache').AsString);
            aTempObj.AddPair('email', FieldByName('email').AsString);
            aTempObj.AddPair('strasse', FieldByName('Strasse').AsString + ' ' +
              FieldByName('Strasse2').AsString);
            aTempObj.AddPair('plz', FieldByName('Plz').AsString);
            aTempObj.AddPair('ort', FieldByName('ort').AsString);
            aTempObj.AddPair('Land', FieldByName('Land').AsString);

            pResultArr.AddElement(aTempObj);
          end;

        end;
      end;
    except
      on e: Exception do
      begin
        Log.WriteToLog(aCompName, aFirma,'<TEvent> getReservData: ' + e.Message, lmtError);
        raise;
      end;
    end;
  finally

  end;
end;

function TEvent.setOrgOrTeiln(pDafaultUser: string; pParams: TJsonObject;
  var pResultArr: TJsonArray): boolean;
var
  aGastid: Int64;
  aMarktsegmentID: integer;
  aKennzeichen: string;
  aNachname: string;
  aVorname: string;
  aOrt: string;
  aEmail: string;
  aTitle: string;
  aKostenstelle: string;
  aOrgEinheit: string;
  aTelBuero: string;
  aMobil: string;
  aBuchungsKreis: string;
  asprachid: integer;
  aOrgEinheitInt: integer;
  aNachnamegross: string;
  aGastkZ9ID: integer;
  aZusatzname: string;
  aFirma: integer;
  aCompName: string;
  aDataArray: TJsonArray;
  aIsTeilnehmer: boolean;

  function CompareName(pGAstId: integer; pNachname: String): integer;
  var
    aOrgEinheit: string;
    aStr: string;
  begin
    Result := 0;
    pNachname := UpperCase(pNachname);

    if pGAstId > 0 then
    begin
      try
        with QueryCheckGast do
          try
            Close;
            ParamByName('pGastID').asInteger := pGAstId;
            Open;
            if QueryCheckGast.RecordCount > 0 then
            begin
              aOrgEinheit := UpperCase(trim(FieldByName('Nachname').AsString));
              Result := AnsiCompareStr(aOrgEinheit, pNachname);

              if Result <> 0 then
              begin
                aStr := 'OrganisationImport Reservid ' +
                  format('%s', [intTostr(pGAstId)]) +
                  ' ist schon vorhanden, aber';
                aStr := aStr + 'NachName: ' + pNachname + ' und ' + aOrgEinheit
                  + ' stimmt nicht überein ';
                Log.WriteToLog(aCompName, aFirma,'<TEvent> CompareName:'+aStr);
              end
            end;

          except
            on e: Exception do
            begin
               Log.WriteToLog(aCompName, aFirma,'<TEvent> CompareName: '+
                'Error in Insert CompareName in Data.QueryCheckGast: ' +
                e.Message, lmtError);
              raise;
            end;
          end; // end of try
      finally
        QueryCheckGast.Close;
      end;
    end; // end of pGastid >0
  end;
  function CheckEvent(pEventName: string): boolean;
  begin
    Result := False;

    if pEventName <> '' then
    begin
      try
        with QueryCheckEventByName do
          try
            Close;
            ParamByName('pEventName').AsString := pEventName;
            Open;
            if QueryCheckEventByName.RecordCount > 0 then
              Result := true;

          except
            on e: Exception do
            begin
               Log.WriteToLog(aCompName, aFirma,'<TEvent> CheckEvent: '+
                'Error in CheckEvent in QueryCheckEventByName: ' + e.Message,
                lmtError);
            end;
          end; // End of try
      finally
        QueryCheckEventByName.Close;
      end;
    end;
  end;
  procedure UpdateGast(aGastid: integer; aNachname, aVorname, aKostenstelle,
    aZusatzname: string);
  begin
    with QueryUpdateGast do
    begin
      try
        Close;
        ParamByName('pKostenstelle').AsString := aKostenstelle;
        ParamByName('pGastId').asInteger := aGastid;
        ParamByName('pZusatzname').AsString := aZusatzname;
        ParamByName('pVorname').AsString := aVorname;
        ParamByName('pNachname').AsString := aNachname;
        // open;
        ExecSQL;
      except
        on e: Exception do
        begin
          Log.WriteToLog(aCompName, aFirma,'<TEvent> CheckEvent: '+
            'Error in UpdateGast in QueryUpdateGast: ' + e.Message, lmtError);
          raise;
        end;
      end;
    end;
  end;

begin
  aIsTeilnehmer := False;
  Result := False;
  if not pParams.TryGetValue<integer>('companyId', aFirma) then
    aFirma := 1;
  if not pParams.TryGetValue<string>('percSilenz', aCompName) then
  begin
    aCompName := pDafaultUser;
    Log.WriteToLog(aCompName, aFirma,'<TEvent> setOrgOrTeiln: '+
      'Auslesen von CompanyName aus  JSON war nicht möglich! ');
  end
  else
  begin
    if aCompName = '' then
    begin
      aCompName := pDafaultUser;
      Log.WriteToLog(aCompName, aFirma,'<TEvent> setOrgOrTeiln: CompanyName im JSON ist leer! ');
    end;
  end;
  try
    Log.WriteToLog(aCompName, aFirma,'<TEvent> setOrgOrTeiln: '+pParams.ToString);
    OEBBConnection.Close;
    OEBBConnection.Params.CLear;
    OEBBConnection.ConnectionDefName := aCompName;
    OEBBConnection.Connected := true;
    aIsTeilnehmer := pParams.GetValue<boolean>('IsTeilnehmer');
    aDataArray := pParams.GetValue('rows') as TJsonArray;
    for var Item in aDataArray do
    begin
      aGastid := Item.GetValue<integer>('gastId');
      aNachname := trim(Item.GetValue<string>('nachname'));
      aNachnamegross := UpperCase(aNachname);
      aVorname := Item.GetValue<string>('vorname');
      aKostenstelle := Item.GetValue<string>('kostenstelle');
      aZusatzname := Item.GetValue<string>('zusatzname');
      aOrgEinheit := Item.GetValue<string>('orgEinheit');
      aOrgEinheitInt := Item.GetValue<integer>('orgEinheitInt');
      aBuchungsKreis := Item.GetValue<string>('buchungsKreis');
      aMarktsegmentID := Item.GetValue<integer>('marktsegmentID');
      asprachid := Item.GetValue<integer>('sprachId');
      aGastkZ9ID := Item.GetValue<integer>('gastkZ9ID');
      aTelBuero := Item.GetValue<string>('telBuero');
      aMobil := Item.GetValue<string>('mobil');
      if aGastid > 0 then
      begin
        if aIsTeilnehmer then
        begin
          if CheckGast(aGastid) = False then
          begin
            InsertGast(aGastid, aMarktsegmentID, aOrgEinheitInt, asprachid,
              aGastkZ9ID, aNachname, aNachnamegross, aVorname, aZusatzname,
              aOrt, aTitle, aEmail, aKostenstelle, aOrgEinheit, aBuchungsKreis,
              aTelBuero, aMobil);
          end;
        end
        else if not aIsTeilnehmer then
        begin
          if not CheckEvent(aNachname) then
          begin
            InsertGast(aGastid, aMarktsegmentID, aOrgEinheitInt, asprachid,
              aGastkZ9ID, aNachname, aNachnamegross, aVorname, aZusatzname,
              aOrt, aTitle, aEmail, aKostenstelle, aOrgEinheit, aBuchungsKreis,
              aTelBuero, aMobil);
          end
          else if CompareName(aGastid, aNachname) = 0 then
            UpdateGast(aGastid, aNachname, aVorname, aKostenstelle,
              aZusatzname);
        end
        else
          Log.WriteToLog(aCompName, aFirma,'<TEvent> setOrgOrTeiln: TeilnehmerImport Reservid ' +
            format('%s', [intTostr(aGastid)]) + ' ist schon vorhanden');
      end;
    end;
    Result := true;
  except
    on e: Exception do
    begin
      Log.WriteToLog(aCompName, aFirma,'<TEvent> setOrgOrTeiln: ' + e.Message,lmtError);
      raise;
    end;
  end;
end;

function TEvent.insertReservJournal(pReservid: Int64): boolean;
begin
  try
    Result := False;
    try
      with QueryselectReserv do
      begin
        Close;
        ParamByName('ReservId').asInteger := pReservid;
        Open;
        QueryInsertReservJournal.Close;
        QueryInsertReservJournal.ParamByName('Firma').asInteger :=
          FieldByName('Firma').asInteger;
        QueryInsertReservJournal.ParamByName('zeit').AsString := '30.12.1899 ' +
          FormatDateTime('hh:mm:ss', now);
        QueryInsertReservJournal.ParamByName('datum').AsDateTime := Date;
        QueryInsertReservJournal.ParamByName('journaltyp').asInteger := 4;
        QueryInsertReservJournal.ParamByName('gastname').AsString :=
          FieldByName('Gastname').AsString;
        QueryInsertReservJournal.ParamByName('buchart').asInteger :=
          FieldByName('Buchart').asInteger;
        QueryInsertReservJournal.ParamByName('kategorieid').asInteger :=
          FieldByName('KategorieId').asInteger;
        QueryInsertReservJournal.ParamByName('zimmerid').asInteger :=
          FieldByName('ZimmerId').asInteger;
        QueryInsertReservJournal.ParamByName('anreise').AsDateTime :=
          FieldByName('Anreisedatum').AsDateTime;
        QueryInsertReservJournal.ParamByName('abreise').AsDateTime :=
          FieldByName('Abreisedatum').AsDateTime;
        if not FieldByName('GesamtPreis').IsNull then
          // QueryInsertReservJournal.ParamByName('gesamtpreis').AsString := FieldByName('GesamtPreis').AsString;
          QueryInsertReservJournal.ExecSQL;
        QueryInsertReservJournal.Close;
        Result := true;
      end;
    except
      on e: Exception do
      begin
        Log.WriteToLog(FCompanyName, 0,'<TEvent> insertReservJournal ' +e.Message, lmtError);
        raise;
      end;
    end;
  finally
    QueryselectReserv.Close;
  end;
end;

function TEvent.CheckInTelephone(pRoom: integer; pCompanyId: integer;
  pGuestName: string; pPayTv: boolean): boolean;
begin
  try
    Result := False;
    try
      with QueryCheckinTelefon do
      begin
        Close;
        ParamByName('Firma').asInteger := pCompanyId;
        ParamByName('ZimmerId').asInteger := pRoom;
        ParamByName('Name').AsString := pGuestName;
        ExecSQL;
        SetTelefonAndTV(pRoom, true, pGuestName, pCompanyId, pPayTv);
        Result := true;
      end;
    except
      on e: Exception do
      begin
        Log.WriteToLog(FCompanyName, pCompanyId,'<TEvent> CheckInTelephone: ' + e.Message, lmtError);
      end;
    end;
  finally
    QueryCheckinTelefon.Close;
  end;
end;

procedure TEvent.SetTelefonAndTV(AZimmerID: LongInt; CheckIn: boolean;
  AGastName: String; pFirma: integer; pPayTv: boolean);
begin
  try
    try
      // Copyed from FelixMain DMZimmer SetTelefon and SetPayTV
      with QueryApparate do
      begin
        Close;
        ParamByName('ZimmerID').asInteger := AZimmerID;
        ParamByName('Firma').asInteger := pFirma;
        Open;
        if not FieldByName('ID').IsNull then
        begin
          Close;
          if CheckIn then
          begin
            QueryUpdateApperate.Close;
            QueryUpdateApperate.SQL.CLear;
            QueryUpdateApperate.SQL.Add('update Telefonapparate set');
            QueryUpdateApperate.SQL.Add('Zustand = ''T'',');
            QueryUpdateApperate.SQL.Add('ChangeZustand = ''T'',');
            QueryUpdateApperate.SQL.Add('GastName = ''' + AGastName + '''');
            QueryUpdateApperate.ExecSQL;
          end
          else
          begin
            QueryUpdateApperate.Close;
            QueryUpdateApperate.SQL.CLear;
            QueryUpdateApperate.SQL.Add('update Telefonapparate set');
            QueryUpdateApperate.SQL.Add('Zustand = ''T'',');
            QueryUpdateApperate.SQL.Add('ChangeZustand = ''T'',');
            QueryUpdateApperate.ExecSQL;
          end;

          if not pPayTv then // if is true SperrenExtra is true
            if QueryApparate.FieldDefs.IndexOf('ZustandTV') <> -1 then
            begin
              if CheckIn then
              begin
                QueryUpdateApperate.Close;
                QueryUpdateApperate.SQL.CLear;
                QueryUpdateApperate.SQL.Add('update Telefonapparate set');
                QueryUpdateApperate.SQL.Add('ZustandTV = ''T'',');
                QueryUpdateApperate.SQL.Add('ChangeZustandTV = ''T'',');
                QueryUpdateApperate.SQL.Add('GastName = ''' + AGastName + '''');
                QueryUpdateApperate.ExecSQL;
              end
              else
              begin
                QueryUpdateApperate.Close;
                QueryUpdateApperate.SQL.CLear;
                QueryUpdateApperate.SQL.Add('update Telefonapparate set');
                QueryUpdateApperate.SQL.Add('ZustandTV = ''F'',');
                QueryUpdateApperate.SQL.Add('ChangeZustandTV = ''F'',');
                QueryUpdateApperate.ExecSQL;
              end;
            end;
        end;
      end;
    except
      on e: Exception do
      begin
        Log.WriteToLog(FCompanyName, pFirma,'<TEvent> SetTelefonAndTV:' + e.Message, lmtError);
      end;
    end;
  finally
    QueryUpdateApperate.Close;
    QueryApparate.Close;
  end;
end;

function TEvent.setReservState(pDafaultUser: string; pParams: TJsonObject;
  var pResultObj: TJsonObject): boolean;
var
  aReservid: string;
  aState, aGuestName: string;
  aFirma, aRoomId: integer;
  aCompName, aError: string;
  aReservArray, aResultArray: TJsonArray;
  aResultObj: TJsonObject;
  aFelixDate: TDate;
  aSetTelefon, aSetPayTv: boolean;
begin
  { ************************************
    ** state : 0 --> everything is ok  **
    ** state : 1 --> error             **
    ************************************ }
  aError := '';
  if not pParams.TryGetValue<integer>('companyId', aFirma) then
    aFirma := 1;
  if not pParams.TryGetValue<string>('percSilenz', aCompName) then
  begin
    aCompName := pDafaultUser;
    Log.WriteToLog(aCompName, aFirma,'<TEvent> setReservState: ' +
      'Auslesen von CompanyName aus  JSON war nicht möglich! ');
  end
  else
  begin
    if aCompName = '' then
    begin
      aCompName := pDafaultUser;
      Log.WriteToLog(aCompName, aFirma,'<TEvent> setReservState: CompanyName im JSON ist leer! ');
    end;
  end;
  try
    try
      // OEBBConnection := TFDConnection.Create(nil);
      OEBBConnection.Close;
      OEBBConnection.Params.CLear;
      OEBBConnection.ConnectionDefName := aCompName;
      OEBBConnection.Connected := true;
      aReservArray := pParams.GetValue('reservations') as TJsonArray;
      aResultArray := TJsonArray.Create;
      for var Item in aReservArray do
      begin
        aRoomId := 0;
        aGuestName := '';
        aResultObj := TJsonObject.Create;
        aReservid := Item.GetValue<string>('reservId');
        aState := Item.GetValue<string>('state');
        with QueryUpdateReservState do
        begin
          aResultObj.AddPair('reservId', aReservid);
          Close;
          SQL.CLear;
          SQL.Add('select * from reservierung where id = ' + aReservid);
          Open;
          if not EOF then
          begin
            QueryGetFelixDate.Close;
            QueryGetFelixDate.ParamByName('Firma').asInteger :=
              FieldByName('Firma').asInteger;
            QueryGetFelixDate.Open;
            aFelixDate := QueryGetFelixDate.FieldByName('felixdate').AsDateTime;
            QueryGetFelixDate.Close;
            begin
              if aState.ToUpper = 'CHECKIN' then
              begin
                if FieldByName('AnreiseDatum').AsDateTime <> aFelixDate then
                begin
                  aResultObj.AddPair('state', TJsonNumber.Create(1));
                  aResultObj.AddPair('message',
                    'Das geplante Anreisedatum stimmt nicht mit dem CheckIn Datum überein. Bitte manuel einchecken');
                end
                else if FieldByName('Buchart').asInteger <> 0 then
                begin
                  aResultObj.AddPair('state', TJsonNumber.Create(1));
                  aResultObj.AddPair('message',
                    'Diese Reservierung ist keine Fixbuchug. Bitte manuel einchecken');
                end
                else if FieldByName('CheckIn').AsString = 'T' then
                begin
                  aResultObj.AddPair('state', TJsonNumber.Create(0));
                  aResultObj.AddPair('message',
                    'Diese Reservierung ist schon eingecheckt');
                end
                else if FieldByName('ZimmerId').AsString = '' then
                begin
                  aResultObj.AddPair('state', TJsonNumber.Create(0));
                  aResultObj.AddPair('message',
                    'Dieser Reservierung ist kein Zimmer zugeteilt. Bitte manuell einchecken');
                end
                else
                begin
                  aSetTelefon := FieldByName('SperrenTelefon').AsBoolean;
                  aSetPayTv := FieldByName('SperrenExtra').AsBoolean;

                  aRoomId := FieldByName('ZimmerId').asInteger;
                  aGuestName := FieldByName('GastName').AsString;
                  Close;
                  SQL.CLear;
                  SQL.Add('update reservierung set CheckIn = ''T'',');
                  SQL.Add('Abgereist = ''F''');
                  SQL.Add('where id = ' + aReservid);
                  try
                    ExecSQL;
                    if insertReservJournal(StrToInt64(aReservid)) then
                    begin
                      Close;
                      SQL.CLear;
                      SQL.Add('update ZIMMERSPIEGEL set Typ = 1');
                      SQL.Add('where reservId = ' + aReservid);
                      ExecSQL;
                      if not aSetTelefon then
                      begin
                        if CheckInTelephone(aRoomId, aFirma, aGuestName,
                          aSetPayTv) then
                        begin
                          aResultObj.AddPair('state', TJsonNumber.Create(0));
                          aResultObj.AddPair('message', 'Status wurde geändert')
                        end
                        else
                        begin
                          aResultObj.AddPair('message',
                            'Es wurde eingecheckt, aber Telefon konnte nicht aktiviert werden')
                        end;
                      end
                      else
                      begin
                        aResultObj.AddPair('state', TJsonNumber.Create(0));
                        aResultObj.AddPair('message', 'Status wurde geändert')
                      end;
                    end
                    else
                    begin
                      Close;
                      SQL.CLear;
                      SQL.Add('update reservierung set CheckIn = null,');
                      SQL.Add('Abgereist = null');
                      SQL.Add('where id = ' + aReservid);
                      ExecSQL;
                      aResultObj.AddPair('state', TJsonNumber.Create(1));
                      aResultObj.AddPair('message',
                        'Es ist ein unbekannter Fehler aufgetreten')
                    end;
                  except
                    on e: Exception do
                    begin
                      Log.WriteToLog(aCompName, aFirma,'<TEvent> setReservState: ' +
                        'Fehler bei update Reservierung ' + aReservid + ': ' +
                        e.Message, lmtError);
                      aResultObj.AddPair('state', TJsonNumber.Create(1));
                      aError := e.Message;
                      if aError.ToLower.Contains('deadlock') then
                        aError := 'Fehler: Die Reservierung wird gerade von einem anderem Gerät bearbeitet!'
                      else if aError.ToLower.Contains('connection') then
                        aError := 'Fehler: Die Verbindung zur Datenbank wurde unterbrochen!'
                      else
                        aError := 'Es ist ein Fehler aufgetreten, bitte wende dich an die Rezeption!';
                      aResultObj.AddPair('message', 'Error: ' + aError);
                    end;
                  end;
                end;
              end
              else if aState.ToUpper = 'CANCEL' then
              begin
                Close;
                SQL.CLear;
                SQL.Add('update reservierung set Storniert = ''T''');
                SQL.Add('Stornodatum = ''' + DateToStr(Date) + '''');
                SQL.Add('where id = ' + aReservid);
                try
                  // execSQL;
                  aResultObj.AddPair('state', TJsonNumber.Create(1));
                  aResultObj.AddPair('message',
                    'Status cancel wird derzeit noch nicht unterstützt');
                except
                  on e: Exception do
                  begin
                    Log.WriteToLog(aCompName, aFirma,'<TEvent> setReservState: ' +
                      'Fehler bei update Reservierung ' + aReservid + ': ' +
                      e.Message, lmtError);
                    aResultObj.AddPair('state', TJsonNumber.Create(1));
                    aResultObj.AddPair('message', 'Error: ' + e.Message);
                  end;
                end;
              end
              else if aState.ToUpper = 'CHECKOUT' then
              begin
                Close;
                SQL.CLear;
                SQL.Add('update reservierung set CheckOut = ''T'',');
                SQL.Add('CheckIn = ''F''');
                SQL.Add('where id = ' + aReservid);
                try
                  // execSQL;
                  aResultObj.AddPair('state', TJsonNumber.Create(1));
                  aResultObj.AddPair('message',
                    'Status checkOut wird derzeit noch nicht unterstützt');
                except
                  on e: Exception do
                  begin
                    Log.WriteToLog(aCompName, aFirma,'<TEvent> setReservState: ' +
                      'Fehler bei update Reservierung ' + aReservid + ': ' +
                      e.Message, lmtError);
                    aResultObj.AddPair('state', TJsonNumber.Create(1));
                    aResultObj.AddPair('state', 'Error: ' + e.Message);
                  end;
                end;
              end;
            end;
          end
          else
          begin
            aResultObj.AddPair('state', TJsonNumber.Create(1));
            aResultObj.AddPair('message',
              'Reservierungsnummer wurde nicht gefunden');
          end;
          Close;

        end;
        aResultArray.AddElement(aResultObj);
      end;
    except
      on e: Exception do
      begin
        Log.WriteToLog(aCompName, aFirma,'<TEvent> setReservState: ' + aReservid + 'Error: ' + e.Message,
          lmtError);
        aResultObj.Create;
        aResultObj.AddPair('reservId', '');
        aResultObj.AddPair('state', TJsonNumber.Create(1));
        aError := 'Es ist ein Fehler aufgetreten. Bitte probieren Sie es noch einmal oder wenden Sie sich an einen Mitarbeiter!';
        aResultObj.AddPair('message', 'Fatal Error: ' + e.Message);
        aResultArray.AddElement(aResultObj);
      end;
    end;
  finally
    pResultObj.AddPair('reservations', aResultArray);
  end;
end;

function TEvent.setVeranstaltung(pDafaultUser: string; pParams: TJsonObject;
  var pResultArr: TJsonArray): boolean;
var
  aReservid: Int64;
  aGastid: integer;
  aColum: integer;
  aOrtID: integer;
  aFirma: integer;
  aNachname: string;
  aCompName: string;
  aVonString, aBisString, aVonUhrString, aBisUhrString: string;
  aRaumID, aTeilnehmeranzahl: integer;
  aVon, aBis, aVonUhr, aBisUhr: TDateTime;
  aDataArray, aParticipants: TJsonArray;
  function CheckReservation(pReservid: integer): boolean;
  var
    i: integer;
  begin
    Result := False;

    if pReservid > 0 then
    begin
      with QueryCheckSeminarRes do
        try
          Close;
          ParamByName('pReservid').asInteger := pReservid;
          // for I := 0 to Data.IBOQueryCheckSeminarRes.SQL.Count -1 do
          // WriteToLog(Data.IBOQueryCheckSeminarRes.SQL[i], true);
          Open;
          if QueryCheckSeminarRes.RecordCount > 0 then
            Result := true;
        except
          on e: Exception do
          begin
            Log.WriteToLog(aCompName, aFirma,'<TEvent> CheckReservation: ' + e.Message,lmtError);
          end;
        end; // End of try
    end;
  end;
  function CheckEvent(pEventName: string): boolean;
  begin
    Result := False;
    try
      if pEventName <> '' then
      begin
        with QueryCheckEventByName do
          try
            Close;
            ParamByName('pEventName').AsString := pEventName;
            Open;
            if QueryCheckEventByName.RecordCount > 0 then
              Result := true;

          except
            on e: Exception do
            begin
              Log.WriteToLog(aCompName, aFirma,'<TEvent> CheckEvent: ' + e.Message,
                lmtError);
            end; // End of try

          end;
      end;
    finally
      QueryCheckEventByName.Close;
    end;
  end;
  procedure InsertEventAsGuest(aGastid: integer);
  var
    aNachnamegross: string;
  begin
    aNachnamegross := UpperCase(aNachname);
    with QueryInsertTemp do
    begin
      try
        Close;
        SQL.CLear;
        SQL.Add('Insert into Gaestestamm(id, Firma, nachname,  NachnameGross) ');
        SQL.Add(' VALUES ');
        SQL.Add(format(' (%d,     1, ''%s'',                 ''%s'' )',
          [aGastid, Copy(aNachname, 1, 50), Copy(aNachnamegross, 1, 50)]));
        ExecSQL;
        Close;
      except
        on e: Exception do
        begin
          Log.WriteToLog(aCompName, aFirma,'<TEvent> InsertEventAsGuest: ' + e.Message,
            lmtError);
        end;
      end;
    end;
  end;

begin
  Result := true;
  if not pParams.TryGetValue<integer>('companyId', aFirma) then
    aFirma := 1;
  if not pParams.TryGetValue<string>('percSilenz', aCompName) then
  begin
    aCompName := pDafaultUser;
    Log.WriteToLog(aCompName, aFirma,'<TEvent> setVeranstaltung: '+
      'Auslesen von CompanyName aus  JSON war nicht möglich! ');
  end
  else
  begin
    if aCompName = '' then
    begin
      aCompName := pDafaultUser;
      Log.WriteToLog(aCompName, aFirma,'<TEvent> setVeranstaltung: CompanyName im JSON ist leer! ');
    end;
  end;
  try
    try
      OEBBConnection.Close;
      OEBBConnection.Params.CLear;
      OEBBConnection.ConnectionDefName := aCompName;
      OEBBConnection.Connected := true;
      aDataArray := pParams.GetValue('rows') as TJsonArray;
      for var Item in aDataArray do
      begin
        begin

          aReservid := Item.GetValue<integer>('reservId');
          aOrtID := Item.GetValue<integer>('ortId');
          aNachname := Item.GetValue<string>('nachname');
          aRaumID := Item.GetValue<integer>('raumId');
          aGastid := Item.GetValue<integer>('gastid');
          aTeilnehmeranzahl := Item.GetValue<integer>('teilnehmeranzahl');
          aVonString := Item.GetValue<string>('von');
          aVon := StrToDateTime(aVonString);
          aBisString := Item.GetValue<string>('bis');
          aBis := StrToDateTime(aBisString);
          aVonUhrString := Item.GetValue<string>('vonUhr');
          aVonUhr := StrToDateTime(aVonUhrString);
          aBisUhrString := Item.GetValue<string>('bisUhr');
          aBisUhr := StrToDateTime(aBisUhrString);

          if (aReservid > 0) then
          begin
            if CheckReservation(aReservid) = False then
            begin
              aGastid := aReservid + 1000000000;
              if CheckGast(aGastid) = False then
              begin
                InsertEventAsGuest(aGastid);
              end;
              InsertSeminarRes(intTostr(aReservid), aNachname, aRaumID, aGastid,
                aTeilnehmeranzahl, aVon, aBis, aVonUhr, aBisUhr);
              InsertSeminarTrainer(aReservid, aGastid, aNachname);
              if Item.TryGetValue<TJsonArray>('Participants', aParticipants)
              then
              begin
                for var Part in aParticipants do
                  InsertParticipants(Part.GetValue<integer>('reservId'),
                    Part.GetValue<integer>('gastid'),
                    Part.GetValue<integer>('teilnehmeranzahl'));
              end;
            end;
          end;
        end;
      end;
      Result := true;
    except
      on e: Exception do
      begin
        Log.WriteToLog(aCompName, aFirma,'<TEvent> setVeranstaltung: ' +e.Message, lmtError);
      end;
    end;
  finally

  end;
end;

procedure TEvent.InsertParticipants(pReservid, pGAstId: Int64; pAnzahl: integer);
var
  aGastid: integer;
  aId: integer;
begin
  try
    try
      for var i := 1 to pAnzahl do
      begin
        aId := SetGeneratorID('ID');
        with QueryParticipant do
        begin
          Close;
          SQL.CLear;
          SQL.Add(' INSERT INTO SEMINARTEILNEHMER(ID, FIRMA, RESERVID, GASTID, DRUCK, PREIS, REFERENT,  WARTELISTE, ');
          SQL.Add(' ANMELDUNG)');
          SQL.Add(' VALUES (  :ID, :FIRMA, :RESERVID, :GASTID, :DRUCK, :PREIS, :REFERENT, :WARTELISTE, :ANMELDUNG)');
          ParamByName('id').asInteger := aId;
          ParamByName('Firma').asInteger := 1;
          ParamByName('ReservId').asInteger := pReservid;
          ParamByName('GastId').asInteger := pGAstId;
          ParamByName('Druck').AsString := 'F';
          ParamByName('Preis').AsFloat := 0;
          ParamByName('Referent').AsString := 'F';
          ParamByName('WarteListe').AsString := 'F';
          ParamByName('Anmeldung').AsDateTime := Date;
          ExecSQL;
        end;
      end;

    except
      on e: Exception do
      begin
        Log.WriteToLog(FCompanyName, 1,'<TEvent> QueryParticipant: ' + e.Message,
          lmtError);
      end;
    end;
  finally
    QueryParticipant.Close;
  end;
end;

procedure TEvent.InsertSeminarTrainer(pReservid, pGAstId: integer;
  pNachname: string);
var
  aId: integer;
  function CheckTrainer(pGAstId: integer): boolean;
  begin
    Result := False;

    if pGAstId > 0 then
    begin
      with QueryTemp do
        try
          try
            Close;
            SQL.CLear;
            SQL.Add('select id from Gaestestamm');
            SQL.Add('where id=');
            SQL.Add(intTostr(pGAstId));
            Open;
            if QueryTemp.RecordCount > 0 then
              Result := true;

          except
            on e: Exception do
            begin
              Log.WriteToLog(FCompanyName, 1,'<TEvent> CheckTrainer : ' + e.Message, lmtError);
            end;
          end; // End of try
        finally
          Close;
        end;
    end;
  end;
  procedure InsertTrainerAsGuest(pGAstId: integer; pNachname: string);
  var
    aNachnamegross: string;
  begin
    aNachnamegross := UpperCase(pNachname);
    with QueryInsertTemp do
    begin
      try
        try
          Close;
          SQL.CLear;
          SQL.Add('Insert into Gaestestamm(id, Firma, nachname,  NachnameGross) ');
          SQL.Add(' VALUES ');
          SQL.Add(format(' (%d,     1, ''%s'',                 ''%s'' )',
            [pGAstId, Copy(pNachname, 1, 50), Copy(aNachnamegross, 1, 50)]));
          ExecSQL;
          Close;
        except
          on e: Exception do
          begin
            Log.WriteToLog(FCompanyName, 1,'<TEvent> InsertTrainerAsGuest: ' + e.Message, lmtError);
          end;
        end;
      finally
        Close;
      end;
    end;
  end;

begin
  try
    aId := SetGeneratorID('ID');
    if pGAstId > 0 then
    begin
      with QueryParticipant do
      begin

        Close;
        SQL.CLear;
        SQL.Add(' UPDATE OR INSERT INTO SEMINARTEILNEHMER(ID, FIRMA, RESERVID, GASTID, DRUCK, PREIS, REFERENT,  WARTELISTE, ');
        SQL.Add(' ANMELDUNG)');
        SQL.Add(' VALUES ( :ID, :FIRMA, :RESERVID, :GASTID, :DRUCK, :PREIS, :REFERENT, :WARTELISTE, :ANMELDUNG)');
        ParamByName('id').asInteger := aId;
        ParamByName('Firma').asInteger := 1;
        ParamByName('ReservId').asInteger := pReservid;
        ParamByName('GastId').asInteger := pGAstId;
        ParamByName('Druck').AsString := 'F';
        ParamByName('Preis').AsFloat := 0;
        ParamByName('Referent').AsString := 'T';
        ParamByName('WarteListe').AsString := 'F';
        ParamByName('Anmeldung').AsDateTime := Date;
        ExecSQL;
      end;
      if CheckTrainer(pGAstId) = False then
      begin
        InsertTrainerAsGuest(pGAstId, pNachname);
      end;

    end;
  except
    on e: Exception do
    begin
      Log.WriteToLog(FCompanyName, 1,'<TEvent> InsertSeminarTrainer: ' + e.Message,
        lmtError);
    end;
  end; // end of try
end;

procedure TEvent.InsertSeminar(pReservid: String;
  pRaumID, pTeilnehmeranzahl: integer; pVon, pBis, pVonUhr, pBisUhr: TDateTime);
var
  aDatum, aVonUhrZ, aBisUhrZ: TDateTime;
  aId: integer;
  aPeriod: integer;
  i: integer;

begin

  aDatum := pVon;
  try
    aId := SetGeneratorID('ID');

    with QueryInsertSeminar do
    begin
      Close;
      SQL.CLear;
      SQL.Add('insert into seminar(Id, Firma, Reservid, Datum, DatumBis, Von, Bis, RaumID, Erwachsene)');
      SQL.Add('Values(:Id, :Firma, :Reservid, :Datum, :DatumBis, :Von, :Bis, :RaumID, :Erwachsene)');

      ParamByName('Id').asInteger := aId;
      ParamByName('Firma').asInteger := 1;
      ParamByName('Reservid').AsString := pReservid;
      ParamByName('Datum').AsDateTime := pVon;
      ParamByName('DatumBis').AsDateTime := pBis;
      ParamByName('Von').AsDateTime := pVonUhr;
      ParamByName('Bis').AsDateTime := pBisUhr;
      ParamByName('RaumID').asInteger := pRaumID;
      ParamByName('Erwachsene').asInteger := pTeilnehmeranzahl;
      ExecSQL;

    end;

  except
    on e: Exception do
    begin
      Log.WriteToLog(FCompanyName, 1,'<TEvent> InsertSeminar: ' + e.Message,
        lmtError);

    end;
  end;
end;

procedure TEvent.InsertSeminarRes(pReservid, pGastname: String;
  pRaumID, pGAstId, pTeilnehmeranzahl: integer;
  pVon, pBis, pVonUhr, pBisUhr: TDateTime);
var
  fs: TFormatSettings;
  aErstellungsdatum: TDateTime;

begin
  with QueryInsertSeminarRes do
  begin
    try
      Close;
      SQL.CLear;
      SQL.Add(' Insert into seminarreservierung (ID, FIRMA, GRUPPENNR, GASTADRESSEID, GASTNAME, ERSTELLUNGSDATUM,');
      SQL.Add(' BUCHART, ANREISEDATUM, ABREISEDATUM, VON, BIS, ZIMMERID, TISCHNR, ZIMMERANZAHL, PREISKZ, ERWACHSENE)');
      SQL.Add(' VALUES ( :ID, :FIRMA, :GRUPPENNR, :GASTADRESSEID, :GASTNAME, :ERSTELLUNGSDATUM, :BUCHART, :ANREISEDATUM, ');
      SQL.Add(' :ABREISEDATUM, :VON, :BIS, :ZIMMERID, :TISCHNR, :ZIMMERANZAHL, :PREISKZ, :ERWACHSENE)');

      ParamByName('id').AsString := pReservid;
      ParamByName('Firma').asInteger := 1;
      ParamByName('Gruppennr').AsString := pReservid;
      ParamByName('Gastname').AsString := Copy(pGastname, 1, 30);
      ParamByName('GastadresseID').asInteger := pGAstId;
      ParamByName('ERSTELLUNGSDATUM').AsDateTime := aErstellungsdatum;
      ParamByName('Buchart').asInteger := 0;
      ParamByName('AnreiseDatum').AsDateTime := pVon;
      ParamByName('AbreiseDatum').AsDateTime := pBis;
      ParamByName('Von').AsDateTime := pVonUhr;
      ParamByName('Bis').AsDateTime := pBisUhr;
      ParamByName('Zimmerid').asInteger := pRaumID;
      ParamByName('Zimmeranzahl').asInteger := 1;
      ParamByName('PREISKZ').AsString := 'F';
      ParamByName('Erwachsene').asInteger := pTeilnehmeranzahl;
      ExecSQL;

      InsertSeminar(pReservid, pRaumID, pTeilnehmeranzahl, pVon, pBis,
        pVonUhr, pBisUhr);

    except
      on e: Exception do
      begin
        Log.WriteToLog(FCompanyName, 1,'<TEvent> InsertSeminarRes: ' +
          e.Message, lmtError);
      end;
    end;
  end;
end;

function TEvent.getUIDs(pDafaultUser: string; pFirma: integer;
  var pResultArr: TJsonArray; var aMessage: String): boolean;
var
  aTempObject: TJsonObject;
begin
  try
    Result := False;
    try
      OEBBConnection.Close;
      OEBBConnection.Params.CLear;
      OEBBConnection.ConnectionDefName := pDafaultUser;
      OEBBConnection.Connected := true;
      with QueryGetReservDataForKeyCard do
      begin
        Close;
        ParamByName('Firma').asInteger := pFirma;
        Open;
        while not EOF do
        begin
          QueryGetUID.Close;
          QueryGetUID.ParamByName('Id').AsString := FieldByName('Id').AsString;
          QueryGetUID.Open;
          if not QueryGetUID.FieldByName('uniquenumber').IsNull then
          begin
            aTempObject := TJsonObject.Create;
            aTempObject.AddPair('reservId', FieldByName('Id').AsString);
            aTempObject.AddPair('guestId', FieldByName('GuestId').AsString);
            aTempObject.AddPair('surName', FieldByName('Nachname').AsString);
            aTempObject.AddPair('departureDate', FieldByName('abreisedatum').AsString);
            aTempObject.AddPair('givnName', FieldByName('Vorname').AsString);
            aTempObject.AddPair('cardId', QueryGetUID.FieldByName('uniquenumber').AsString);
            aTempObject.AddPair('roomId', FieldByName('ZimmerId').AsString);
            pResultArr.AddElement(aTempObject);
            Result := true;
          end;
          QueryGetUID.Close;
          next;
        end;
      end;
    except
      on e: Exception do
      begin
        Log.WriteToLog(FCompanyName, 1,'<TEvent> getUIDs: ' + e.Message,
          lmtError);
        raise;
      end;
    end;

  finally
    QueryGetUID.Close;
  end;
end;

function TEvent.getReservArticle(pDafaultUser: string; pParams: TJsonObject;
  pFirma: integer; var pResultArr: TJsonArray; var aMessage: String): boolean;
var
  aCompName, aStr: String;
  aTempObj, aTempObj1: TJsonObject;
  aTempArr, aReservIs, aResArr: TJsonArray;
  aMenge, aTage: integer;
begin
  Result := False;
  try
    OEBBConnection.Close;
    OEBBConnection.Params.CLear;
    OEBBConnection.ConnectionDefName := pDafaultUser;
    OEBBConnection.Connected := true;
    aResArr := pParams.GetValue('ReservIds') as TJsonArray;
    aStr := aResArr.ToJSON;
    aStr := stringreplace(aStr, '[', '(', [rfReplaceAll, rfIgnoreCase]);
    aStr := stringreplace(aStr, ']', ')', [rfReplaceAll, rfIgnoreCase]);
    aStr := stringreplace(aStr, '"', '''', [rfReplaceAll, rfIgnoreCase]);
    for var aReservid in aResArr do
    begin
      with QueryGetArrangemntArticle do
      begin
        Close;
        SQL.CLear;
        SQL.Add('select r.*,ap.short_description, res.Anreisedatum, res.Abreisedatum, res.GASTADRESSEID from reservarrangement r');
        SQL.Add('inner join reservierung res on res.id = r.reservId and res.Firma = r.Firma ');
        SQL.Add('inner join article_packages ap on ap.lookup_company_id = r.firma and ap.package_number = r.arrangementid');
        SQL.Add('where r.Firma = :Firma and r.vondatum <= :pFrom and r.bisdatum >= :pTo ');
        SQL.Add('and r.reservid = ' + aReservid.ToString + '');
        SQL.Add('order by r.reservid ');
        Close;
        ParamByName('Firma').asInteger := pFirma;
        // pFrom muss ein tag im Minus sein weil das Package immer vom Vortag weg eingeben wird
        ParamByName('pFrom').AsDateTime := Date-1;
        // pTo ist das heutige Datum damit das Package heute gültig ist
        ParamByName('pTo').AsDateTime := Date;
        Open;
        First;
        aTempArr := TJsonArray.Create;
        if RecordCount > 0 then
        begin
          while not EOF do
          begin
            aMenge := 0;
            aTempObj := TJsonObject.Create;

            aTempObj.AddPair('reservId', FieldByName('ReservId').AsString);
            aTempObj.AddPair('guestId', FieldByName('GASTADRESSEID').AsString);
            aTempObj.AddPair('checkIn', 'T');
            aTempObj.AddPair('arrivalDate', FieldByName('Anreisedatum').AsString);
            aTempObj.AddPair('departureDate', FieldByName('Abreisedatum').AsString);
            aTempObj1 := TJsonObject.Create;
            aTempObj1.AddPair('serviceId',
              TJsonNumber.Create(FieldByName('ArrangementId').asInteger));
            aTempObj1.AddPair('name', FieldByName('short_description').AsString);

            if FieldByName('menge').IsNull then
            begin
              aMenge := 1;
            end
            else
            begin
              aMenge := FieldByName('menge').asInteger;
            end;
            aTempObj1.AddPair('amount',
              TJsonNumber.Create((FieldByName('Erwachsene').asInteger +
              FieldByName('Kinderkategorie1').asInteger +
              FieldByName('Kinderkategorie2').asInteger +
              FieldByName('Kinderkategorie3').asInteger +
              FieldByName('Kinderkategorie4').asInteger +
              FieldByName('Kinderkategorie5').asInteger +
              FieldByName('Kinderkategorie6').asInteger) * aMenge));
            aTempObj1.AddPair('amountDrinks', TJsonNumber.Create(1));
            aTempObj1.AddPair('priceCategory', TJsonNumber.Create(1));
            aTempArr.AddElement(aTempObj1);
            aTempObj.AddPair('services', aTempArr);
            next;
            Result := true;
          end;
        end
        else
        begin
          try
            QueryGetReservDates.Close;
            QueryGetReservDates.ParamByName('RID').AsString := aReservid.ToString;
            QueryGetReservDates.ParamByName('Firma').asInteger := pFirma;
            QueryGetReservDates.Open;
            aTempObj := TJsonObject.Create;
            aTempArr := TJsonArray.Create;
            aTempObj.AddPair('reservId', aReservid.ToString);
            aTempObj.AddPair('arrivalDate', QueryGetReservDates.FieldByName('Anreisedatum').AsString);
            aTempObj.AddPair('departureDate', QueryGetReservDates.FieldByName('Abreisedatum').AsString);
            aTempObj.AddPair('guestId', QueryGetReservDates.FieldByName('GASTADRESSEID').AsString);
            aTempObj1 := TJsonObject.Create;
            aTempObj1.AddPair('serviceId', TJsonNumber.Create(0));
            aTempObj1.AddPair('name', '');
            aTempObj1.AddPair('amount', TJsonNumber.Create(0));
            aTempObj1.AddPair('amountDrinks', TJsonNumber.Create(0));
            aTempObj1.AddPair('priceCategory', TJsonNumber.Create(0));
            aTempArr.AddElement(aTempObj1);
            aTempObj.AddPair('services', aTempArr);
            with QueryCheckReserv do
              try
                Close;
                ParamByName('Firma').asInteger := pFirma;
                ParamByName('Id').AsString := aReservid.ToString;
                Open;
                if FieldByName('CheckIn').AsString = 'T' then
                  aTempObj.AddPair('checkIn', 'T')
                else
                  aTempObj.AddPair('checkIn', 'F');
                Close;

              finally
                QueryCheckReserv.Close;

              end;
            Result := true;

          finally
            QueryGetReservDates.Close;
          end;
        end;
        QueryGetLogArrId.Close;
        QueryGetLogArrId.ParamByName('RId').AsString := aReservid.ToString;
        while not QueryGetLogArrId.EOF do
        begin
          setArrToSend(pDafaultUser, FieldByName('id').AsString);
          QueryGetLogArrId.next;
        end;

      end;
      if Result then
        pResultArr.AddElement(aTempObj);
    end;
  except
    on e: Exception do
    begin
      Log.WriteToLog(pDafaultUser, pFirma,'<TEvent> getReservArticle: ' +
        e.Message, lmtError);
      raise;
    end;
  end;
end;

function TEvent.getEvents(pDafaultUser: string; pParams: TJsonObject;
  var pResultArr: TJsonArray; var aMessage: String): boolean;
var
  aFirma: integer;
  aCompName, aSQLString: String;
  aTempObj: TJsonObject;
begin
  Result := False;
  aSQLString := '';
  if not pParams.TryGetValue<integer>('companyId', aFirma) then
    aFirma := 1;
  if not pParams.TryGetValue<string>('percSilenz', aCompName) then
  begin
    aCompName := pDafaultUser;
    Log.WriteToLog(aCompName, aFirma,'<TEvent> getEvents: '+
      'Auslesen von CompanyName aus  JSON war nicht möglich! ');
  end
  else
  begin
    if aCompName = '' then
    begin
      aCompName := pDafaultUser;
      Log.WriteToLog(aCompName, aFirma,'<TEvent> getEvents: CompanyName im JSON ist leer! ');
    end;
  end;
  try
    OEBBConnection.Close;
    OEBBConnection.Params.CLear;
    OEBBConnection.ConnectionDefName := aCompName;
    OEBBConnection.Connected := true;
    with QueryGetEvents do
    begin
      Close;
      ParamByName('Ende').AsString := pParams.GetValue<string>('BeginDate');
      ParamByName('Beginn').AsString := pParams.GetValue<string>('EndDate');
      ParamByName('Firma').asInteger := aFirma;

      // for SQL StringLog
      for var sqlcount := 0 to QueryGetEvents.SQL.Count - 1 do
        aSQLString := aSQLString + ' ' + QueryGetEvents.SQL[sqlcount];

      Log.WriteToLog(aCompName, aFirma,'<TEvent> getEvents: GetEvent SQL: ' + aSQLString);

      Open;
      var IsOEBBRoom116: boolean;
      while not EOF do
      begin
        IsOEBBRoom116 := False;
        aTempObj := TJsonObject.Create;
        for var i := 0 to FieldCount - 1 do
        begin
          aTempObj.AddPair(Fields[i].FieldName, FieldByName(Fields[i].FieldName).AsString);
          if (aCompName = 'OEBB')
          and (Fields[i].FieldName= 'BEZEICHNUNG')
          and (FieldByName(Fields[i].FieldName).AsString = 'Seminarraum 117') then
          begin
            IsOEBBRoom116 := true;
          end;
        end;
        pResultArr.AddElement(aTempObj);
        if IsOEBBRoom116 then
        begin
          aTempObj := TJsonObject.Create;
          var isRoom117 := False;
          for var FieldCounter := 0 to FieldCount - 1 do
          begin
            if (Fields[FieldCounter].FieldName= 'BEZEICHNUNG')
            and (FieldByName(Fields[FieldCounter].FieldName).AsString = 'Seminarraum 117') then
            begin
              aTempObj.AddPair(Fields[FieldCounter].FieldName, 'Seminarraum 116');
              isRoom117 := true;
            end
            else if isRoom117 and ((Fields[FieldCounter].FieldName= 'ID'))
            then
            begin
              aTempObj.AddPair(Fields[FieldCounter].FieldName, FieldByName(Fields[FieldCounter].FieldName).AsString+'-1');
            end
            else
            begin
              aTempObj.AddPair(Fields[FieldCounter].FieldName, FieldByName(Fields[FieldCounter].FieldName).AsString);
            end;
          end;
          pResultArr.AddElement(aTempObj);
        end;
        next;
        Result := true;
      end;

    end;
  except
    on e: Exception do
    begin
      Log.WriteToLog(aCompName, aFirma,'<TEvent> getEvents: ' + e.Message,
        lmtError);
      raise;
    end;
  end;
end;

function TEvent.getNewPack(pDafaultUser: string; pFirma: integer;
  var pResultArr: TJsonArray; var ArrIds: TStringList): boolean;
begin
  Result := False;
  with QueryGetNewReservPAck do
    try
      try
        OEBBConnection.Close;
        OEBBConnection.Params.CLear;
        OEBBConnection.ConnectionDefName := pDafaultUser;
        OEBBConnection.Connected := true;
        Close;
        ParamByName('FId').asInteger := pFirma;
        Open;
        while not EOF do
        begin
          pResultArr.Add(FieldByName('ReservId').AsString);
          ArrIds.Add(FieldByName('Id').AsString);
          next;
          Result := true;
        end;
      except
        on e: Exception do
        begin
          Log.WriteToLog(pDafaultUser, 0,'<TEvent> getNewPack: ' + e.Message,
            lmtError);
          raise;
        end;
      end;
    finally
      Close;
    end;
end;

procedure TEvent.setArrToSend(pDafaultUser, pLogArrId: String);
begin
  with QuerySetArrSend do
    try
      try
        OEBBConnection.Close;
        OEBBConnection.Params.CLear;
        OEBBConnection.ConnectionDefName := pDafaultUser;
        OEBBConnection.Connected := true;
        Close;
        ParamByName('Id').AsString := pLogArrId;
        ExecSQL;
      except
        on e: Exception do
        begin
          Log.WriteToLog(pDafaultUser, 0,'<TEvent> setArrToSend: ' + e.Message,
            lmtError);
        end;
      end;
    finally
      Close;
    end;;
end;

end.
