unit ExternalCashDesk;

interface

uses
  System.SysUtils, System.Classes, System.JSON, System.Variants,
  ServerIntf, // FireDAC.Stan.Intf, FireDAC.Stan.Option,
  // FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  // FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  // FireDAC.Comp.DataSet,
  FireDAC.Comp.Client;

type
  TExtern = class(TDataModule)
  private

    { Private-Deklarationen }
  public
    { Public-Deklarationen }
//    procedure processesCashRegister(pParam: TJSONObject;
//      var pResult: TJSONObject);
    procedure getGuestByDate(pFirma: integer; pCompany: string; pDate: TDateTime; var pResult: TJSONArray; var pHasError: boolean);
    procedure saveKassInfo(pFirma : integer; pCompanyName: string; pParam: TJSONObject; var pResult: TJSONObject);
    procedure getGastInfo(pFirma:integer; pCompany: string; var pResult: TJSONArray);
    procedure getCheckedInGuests(pFirma: integer; pCompany: string; var pResult: TJSONArray; var pHasError: boolean);
    procedure createInvoice(pParams: TJSONObject; pCompanyName: string; pCompanyId: integer; var pResult: TJSONObject);
    procedure createARoomBill(pParams: TJSONObject; pCompanyName: string; pCompanyId: integer; var pResult: TJSONObject);
//    procedure waiterReceipts(pLosung: TJSONObject; var pResult: TJSONObject);
  end;

var
  Extern: TExtern;

implementation

uses DataModule, restFelixMainUnit, Resources, TempModul, Logging;
{%CLASSGROUP 'Vcl.Controls.TControl'}
{$R *.dfm}

procedure TExtern.getGastInfo(pFirma:integer; pCompany: string; var pResult: TJSONArray);
var
  aResultArray, aUniqueID: TJSONArray;
  aRquestObj, aUniqueObject: TJSONObject;
  aConnection : TFDConnection;
  aQuery, aUniqueQuery : TFDQuery;
  aBemerkung: string;
begin
  try
    Log.WriteToLog(pCompany, pFirma,'<TExtern> getGastInfo ...');
    try
      aResultArray := TJSONArray.Create;
      aQuery := TFDQuery.Create(nil);

      aConnection := TFDConnection.Create(nil);
      aConnection.Params.Clear;
      aConnection.ConnectionDefName := pCompany;
      aConnection.Connected := true;
    except on e : Exception do
      begin
        Log.WriteToLog(pCompany, pFirma,'<TExtern> getGastInfo/ Create Connection: ' + E.Message,
            lmtError);
      end;
    end;
    aQuery.SQL.Clear;
    aQuery.SQL.Add(cQueryGastInfo);

    with aQuery do
      try
        Close;
        Connection := aConnection;
        ParamByName('Firma').Value := pFirma;
        ParamByName('dateToday').Value := date;

        Open;
        while not EOF do
        begin
          aRquestObj := TJSONObject.Create;

          aRquestObj.AddPair('customerName', FieldByName('name').AsString);
          aRquestObj.AddPair('customerId', FieldByName('gastadresseid').AsString);
          aRquestObj.AddPair('reservId', FieldByName('id').AsString);
          aRquestObj.AddPair('arrivalDate', FieldByName('anreisedatum')
            .AsString);
          aRquestObj.AddPair('departureDate', FieldByName('abreisedatum')
            .AsString);
          aRquestObj.AddPair('roomId', FieldByName('zimmerid').AsString);

          aBemerkung := FieldByName('bemerkung2').AsString;
//          if Pos('"',aBemerkung) > -1 then
//          begin
//            aBemerkung := StringReplace(aBemerkung, '"', '\"', [rfReplaceAll, rfIgnoreCase]);
//          end;
          aRquestObj.AddPair('note', aBemerkung); // FieldByName('bemerkung2').AsString);

          aUniqueID := TJSONArray.Create;
          aUniqueQuery := TFDQuery.Create(nil);
          aUniqueQuery.SQL.Add(cQueryUiqueKey);
//          with DM.QueryUniqueNr do
          begin
            aUniqueQuery.Close;
            aUniqueQuery.Connection := aConnection;
            aUniqueQuery.ParamByName('ReservId').Value := aQuery.FieldByName
              ('id').Value;
            aUniqueQuery.Open;
            while not aUniqueQuery.EOF do
            begin
              aUniqueObject := TJSONObject.Create;
              aUniqueObject.AddPair('cardNumber', aUniqueQuery.FieldByName('cardnumber').AsString);
              aUniqueObject.AddPair('uniqueNumber', aUniqueQuery.FieldByName('uniqueNumber').AsString);
              aUniqueObject.AddPair('advUniqueNumber',aUniqueQuery.FieldByName('ADVUID').AsString);
              aUniqueID.AddElement(aUniqueObject);
              aUniqueQuery.next;
            end;
            aUniqueQuery.Close;
            aUniqueQuery.Free;
          end;
          aRquestObj.AddPair('uniqueIDs', aUniqueID);
          aResultArray.AddElement(aRquestObj);
          next;
        end;
      except
        on E: Exception do
        begin
          if Pos('KC.ADVUID', e.Message) > -1 then
          begin
            Log.WriteToLog(pCompany, pFirma,'<TExtern> getGastInfo: ' +
            E.Message, lmtInfo);
          end
          else
          Log.WriteToLog(pCompany, pFirma,'<TExtern> getGastInfo: ' +
            E.Message, lmtError);
        end;
      end;

  finally
    pResult := aResultArray;
    DM.QueryFelix.Close;
    aConnection.Connected := FALSE;
    aConnection.Free;
    aQuery.Free;
  end;
end;

procedure TExtern.getGuestByDate(pFirma: integer; pCompany: string; pDate: TDateTime; var pResult: TJSONArray; var pHasError: boolean);
var
  aResultArray, aUniqueID: TJSONArray;
  aRquestObj, aUniqueObject: TJSONObject;
  aGender: string;
  aBemerkung: string;
  aTempModul: TTM;
begin
  try
    Log.WriteToLog(pCompany, pFirma,'<TExtern> getGuestByDate ...');
    try
      aResultArray := TJSONArray.Create;
      aTempModul := TTm.Create(nil);
      aTempModul.MainConnection.Params.Clear;
      aTempModul.MainConnection.ConnectionDefName := pCompany;
      aTempModul.MainConnection.Connected := true;
    except on e : Exception do
      begin
        Log.WriteToLog(pCompany, pFirma,'<TExtern> getGuestByDate/ Create Connection: ' + E.Message,
            lmtError);
        pHasError := True;
      end;
    end;

    with aTempModul.QueryGetGuestsByDate do
      try
        Close;
        ParamByName('UpdateTimeStamp').AsDateTime := pDate;

        Open;
        while not EOF do
        begin
          aRquestObj := TJSONObject.Create;

          aRquestObj.AddPair('id', TJSONNumber.Create(FieldByName('id').AsInteger));
          aRquestObj.AddPair('title', FieldByName('titel').AsString);
          aRquestObj.AddPair('firstName', Trim(FieldByName('vorname').AsString));
          aRquestObj.AddPair('additionalName', Trim(FieldByName('zusatzname').AsString));
          aRquestObj.AddPair('surName', Trim(FieldByName('nachname').AsString));
          aRquestObj.AddPair('salutation', FieldByName('Anrede').AsString);
          aRquestObj.AddPair('birthdate', FieldByName('geburtstag').AsString);
          aGender := FieldByName('geschlecht').AsString;
          if aGender = 'W' then
          begin
            aRquestObj.AddPair('gender', 'Weiblich');
          end
          else
          begin
            aRquestObj.AddPair('gender', 'Männlich');
          end;
          aRquestObj.AddPair('street', Trim(FieldByName('strasse').ASString));
          aRquestObj.AddPair('street2', Trim(FieldByName('strasse2').ASString));
          aRquestObj.AddPair('postcode', FieldByName('PLZ').ASString);
          aRquestObj.AddPair('city', Trim(FieldByName('Ort').ASString));
          aRquestObj.AddPair('countryCode', FieldByName('ISO_COUNTRY_CODE').ASString);
          aRquestObj.AddPair('language', FieldByName('sprache').ASString);
          aRquestObj.AddPair('email_1', FieldByName('email').ASString);
          aRquestObj.AddPair('email_2', FieldByName('email2').ASString);
          aRquestObj.AddPair('email_3', FieldByName('email3').ASString);
          aRquestObj.AddPair('email_4', FieldByName('email4').ASString);
          aRquestObj.AddPair('phone_privat', FieldByName('telefonprivat').ASString);
          aRquestObj.AddPair('phone_office', FieldByName('telefonbuero').ASString);
          aRquestObj.AddPair('phone_mobile', FieldByName('mobil').ASString);
          aRquestObj.AddPair('phone_fax', FieldByName('fax').ASString);
          aRquestObj.AddPair('created_by', Trim(FieldByName('created_by').ASString));
          aRquestObj.AddPair('created_at', FieldByName('created_at').ASString);
          aRquestObj.AddPair('updated_by', Trim(FieldByName('updated_by').ASString));
          aRquestObj.AddPair('updated_at', FieldByName('updated_at').ASString);
          aRquestObj.AddPair('isBlocked', TJsonBool.Create(false));
          aRquestObj.AddPair('isAnonymized', TJsonBool.Create(FieldByName('isAnonymized').ASBoolean));
          aRquestObj.AddPair('note', FieldByName('bemerkung').AsString);



          aResultArray.AddElement(aRquestObj);
          next;
        end;
      except
        on E: Exception do
        begin
          pHasError := true;
          Log.WriteToLog(pCompany, pFirma,'<TExtern> getGuestByDate: ' + E.Message, lmtError);
        end;
      end;

  finally
    pResult := aResultArray;
    aTempModul.QueryGetGuestsByDate.Close;
    aTempModul.MainConnection.Connected := False;
    FreeAndNil(aTempModul);
  end;
end;

procedure TExtern.getCheckedInGuests(pFirma: integer; pCompany: string;var pResult: TJSONArray; var pHasError: boolean);
var
  aResultArray, aUniqueID: TJSONArray;
  aRquestObj, aUniqueObject: TJSONObject;
  aGender: string;
  aBemerkung: string;
  aTempModul: TTM;
begin
  try
    Log.WriteToLog(pCompany, pFirma,'<TExtern> CheckedInGuests ...');
    try
      aResultArray := TJSONArray.Create;
      aTempModul := TTm.Create(nil);
      aTempModul.MainConnection.Params.Clear;
      aTempModul.MainConnection.ConnectionDefName := pCompany;
      aTempModul.MainConnection.Connected := true;
    except on e : Exception do
      begin
        Log.WriteToLog(pCompany, pFirma,'<TExtern> CheckedInGuests/ Create Connection: ' + E.Message,
            lmtError);
        pHasError := True;
      end;
    end;

    with aTempModul.QueryGetCheckedInGuests do
    try
      Close;
      ParamByName('dateToday').AsDateTime := Date;
      ParamByName('firma').ASInteger := pFirma;

      Open;
      while not EOF do
      begin
        aRquestObj := TJSONObject.Create;

        aRquestObj.AddPair('guestTitle', FieldByName('titel').AsString);
        aRquestObj.AddPair('guestFirstName', FieldByName('vorname').AsString);
        aRquestObj.AddPair('guestAdditionalName', FieldByName('zusatzname').AsString);
        aRquestObj.AddPair('guestSurName', FieldByName('nachname').AsString);
        aRquestObj.AddPair('guestBirthdate', FieldByName('geburtstag').AsString);
        aRquestObj.AddPair('guestId', TJSONNumber.Create(FieldByName('Gastid').AsInteger));
        aRquestObj.AddPair('reservId', TJSONNumber.Create(FieldByName('Reservid').AsInteger));
        aRquestObj.AddPair('arrivalDate', FieldByName('anreisedatum').AsString);
        aRquestObj.AddPair('depatureDate', FieldByName('abreisedatum').AsString);
        aRquestObj.AddPair('roomId', TJSONNumber.Create(FieldByName('zimmerid').AsInteger));
        aRquestObj.AddPair('note', FieldByName('bemerkung2').AsString);

        aResultArray.AddElement(aRquestObj);
        next;
      end;
    except
      on E: Exception do
      begin
        pHasError := true;
        Log.WriteToLog(pCompany, pFirma,'<TExtern> CheckedInGuests: ' + E.Message, lmtError);
      end;
    end;

  finally
    pResult := aResultArray;
    aTempModul.QueryGetGuestsByDate.Close;
    aTempModul.MainConnection.Connected := False;
    FreeAndNil(aTempModul);
  end;

end;

procedure TExtern.createARoomBill(pParams: TJSONObject; pCompanyName: string; pCompanyId: integer;
  var pResult: TJSONObject);
var
  aError, aIsBooked, aIsSingleBooking: boolean;
  aErrorStr, aBillId, aPositionId, aDeskNr, aTimeString, aDiscountStr, aText: string;
  aResultArray, aDataArray, aPositionArray, aErrorResultArray: TJSONArray;
  aResultObject: TJsonObject;
  aTempDM: TTM;
  aAmount, aTotalDiscount, aTotalAmount, aDiscount, aTax: double;
  aCashDeskId, aGuestID, aReservID, aQuantity, aRoomId: integer;
  aTime: TTime;
begin
try
try
  aError := false;
  aErrorStr := '';
  aResultArray := TJSONArray.Create;
  aErrorResultArray := TJSONArray.Create;
  aIsBooked := false;
  try
    aTempDM := TTM.Create(nil);
    aTempDM.MainConnection.Params.Clear;
    aTempDM.MainConnection.ConnectionDefName := pCompanyName;
    aTempDM.MainConnection.Connected := True;
    aTempDM.MainConnection.TxOptions.AutoCommit := false;
  except
    on e: Exception do
    begin
      aError := True;
      aErrorStr := 'createARoomBill --> wrong JSON: percSilenz was wrong, JSON rejected! NO INVOICE CREATED';
      Log.WriteToLog(pCompanyName, pCompanyId, '<TExtern> createARoomBill/Create Connection: ' + e.Message,
        lmtError);
      raise;
    end;
  end;
  if not aError then
  begin
    aDataArray := pParams.GetValue('bookInfo') as TJSONArray;

    for var Item in aDataArray do
    begin
      if aTempDM.MainConnection.InTransaction then
        aTempDM.MainConnection.Commit;
      aTempDM.MainConnection.StartTransaction;
      aAmount := 0;
      aTax := 0;
      aDiscount := 0;
      aTotalAmount := 0;
      aTotalDiscount := 0;
      aIsBooked := false;
      aBillId := Item.GetValue<string>('billId');

      try
        if not Item.TryGetValue<integer>('cashDeskId', acashDeskId) then
        begin
          acashDeskId := 1000;
        end
        else
        begin
          if acashDeskId = 0 then
          begin
            acashDeskId := 1000;
          end;
        end;
        aTotalAmount := (StringReplace(Item.GetValue<string>('totalAmount'), '.', ',', [rfReplaceAll])
          ).ToDouble;
        aTotalDiscount := (StringReplace(Item.GetValue<string>('totalDiscount'), '.', ',', [rfReplaceAll])
          ).ToDouble;
        aGuestID := Item.GetValue<integer>('guestId');
        aReservID := Item.GetValue<integer>('reservId');
        aRoomId := Item.GetValue<integer>('roomId');
        if not Item.tryGetValue<boolean>('singleBooking', aIsSingleBooking) then
        begin
          aIsSingleBooking := true;
        end;
        aPositionArray := TJSONArray.Create;
        aPositionArray := Item.GetValue<TJSONArray>('billPositions');
        for var Position in aPositionArray do
        begin
          aPositionId := Position.GetValue<string>('id');
          if not Position.TryGetValue<string>('deskNumber', aDeskNr) then
          begin
            aDeskNr := '1';
          end;
          if Position.TryGetValue<string>('time', aTimeString) then
          begin
            aTime := StrToTime(aTimeString);
          end
          else
          begin
            aTime := Time;
          end;
          // Tax comes in percent
          aTax := (StringReplace(Position.GetValue<string>('tax'), '.', ',', [rfReplaceAll])).ToDouble;
          // amount comes without discouunt. therefore no further calculation is necessary
          aAmount := (StringReplace(Position.GetValue<string>('amount'), '.', ',', [rfReplaceAll])
                      ).ToDouble;
          aquantity := Position.GetValue<integer>('quantity');
          if Position.TryGetValue<string>('discount', aDiscountStr) then
          begin
            aDiscount := (StringReplace(aDiscountStr, '.', ',', [rfReplaceAll])).ToDouble
          end
          else
          begin
            aDiscount := 0;
          end;
          Position.TryGetValue('description', aText);
          if aError then
          begin
            // Wenn eine Position einen Fehler hat dann alle weiteren als nicht gebucht schreiben
            aResultObject := TJSONObject.Create;
            aResultObject.AddPair('id', aPositionId);
            aResultObject.AddPair('booked', TJSONBool.Create(false));
          end
          else
          begin
            if NOT aTempDM.getKassInfoIdIsSaved(aTempDM.MainConnection, aBillId+'_'+aPositionId,
            pCompanyId,pCompanyName) then
            begin
              if aTempDM.WriteToGastkonto(aTempDM.MainConnection, aDeskNr, IntTostr(aRoomId),
                aQuantity, aAmount, aTax, -1, aReservId, pCompanyId,
                aText, aBillId, aIsSingleBooking, true, pCompanyName,
                true, aCashDeskId, aBillId+'_'+aPositionId, aErrorStr, DateToStr(now), true) then
              begin
                aResultObject := TJSONObject.Create;
                aResultObject.AddPair('id', aPositionId);
                aResultObject.AddPair('booked', TJSONBool.Create(true));
                if aErrorStr <> '' then
                begin
                  aResultObject.AddPair('error', aErrorStr);
                end;
                Log.WriteToLog(pCompanyName, pCompanyId, '<TExtern> createARoomBill/create invoice KassInfoId: '
                  + aBillId+'_'+aPositionId + ' JSONObj: ' + aResultObject.ToString,
                  lmtInfo);
              end
              else
              begin
                aError := True;
                aResultObject := TJSONObject.Create;
                aResultObject.AddPair('id', aPositionId);
                aResultObject.AddPair('booked', TJSONBool.Create(false));
                aResultObject.AddPair('error', aErrorStr);
                Log.WriteToLog(pCompanyName, pCompanyId, '<TExtern> createARoomBill/create invoice KassInfoId: '
                  + aBillId+'_'+aPositionId + ' JSONObj: ' + aResultObject.ToString,
                  lmtInfo);
              end;
            end
            else
            begin
              aResultObject := TJSONObject.Create;
              aResultObject.AddPair('id', aBillId);
              aResultObject.AddPair('booked', TJSONBool.Create(true));
              aResultObject.AddPair('error', 'Die ID: '+ aBillId +
                ' wurde schon früher einmal verwendet. Bitte eine neue Rechnungsnummer verwenden');
              aResultArray.Add(aResultObject);
              Log.WriteToLog(pCompanyName, pCompanyId, '<TExtern> createARoomBill/create invoice KassInfoId: '
                + aBillId+'_'+aPositionId + ' JSONObj: ' + aResultObject.ToString,
                lmtInfo);
                break;
            end;
          end;
          aResultArray.Add(aResultObject);
        end;
        if aError then
        begin
          if aTempDM.MainConnection.InTransaction then
          begin
            aTempDM.MainConnection.Rollback;
          end;
          for var obj in aResultArray do
          begin
            aResultObject := TJsonObject.Create;
            aResultObject.AddPair('id', obj.GetValue<string>('id'));
            aResultObject.AddPair('booked', TJSONBool.Create(false));
            if obj.TryGetValue<string>('error', aErrorStr) then
            begin
              aResultObject.AddPair('error', aErrorStr);
            end;
            aErrorResultArray.Add(aResultObject);
          end;
          aResultArray := aErrorResultArray;
        end
        else
        begin
          aTempDM.MainConnection.Commit;
        end;
      except on e: exception do
        begin
          if aTempDM.MainConnection.InTransaction then
          begin
            aTempDM.MainConnection.Rollback;
          end;
          aError := True;
          aErrorStr := 'createARoomBill --> Found Error while creating RoomInvoice!';
          // create answer
          aResultObject := TJsonObject.Create;
          aResultObject.AddPair('billId', aBillId);
          aResultObject.AddPair('booked', TJSONBool.Create(false));
          aResultObject.AddPair('error', aErrorStr);
          aResultArray.AddElement(aResultObject);
          for var obj in aResultArray do
          begin
            aResultObject := TJsonObject.Create;
            aResultObject.AddPair('id', obj.GetValue<string>('id'));
            aResultObject.AddPair('booked', TJSONBool.Create(false));
            if obj.TryGetValue<string>('error', aErrorStr) then
            begin
              aResultObject.AddPair('error', aErrorStr);
            end;
            aErrorResultArray.Add(aResultObject);
          end;
          aResultArray := aErrorResultArray;
          Log.WriteToLog(pCompanyName, pCompanyId, '<TExtern> createARoomBill/create invoice: ' + e.Message,
                lmtError);
        end;
      end;
    end;
  end;
except
  // Main Exceptblock
  on e: Exception do
  begin
    if aTempDM.MainConnection.InTransaction then
    begin
      aTempDM.MainConnection.Rollback;
    end;
    Log.WriteToLog(pCompanyName, pCompanyId, '<TExtern> createARoomBill:  ' + e.Message, lmtError);
    aResultObject := TJsonObject.Create;
    aResultObject.AddPair('billId', aBillId);
    aResultObject.AddPair('booked', TJSONBool.Create(false));
    if aErrorStr <> '' then
    begin
      aResultObject.AddPair('error', aErrorStr);
    end
    else
    begin
      aResultObject.AddPair('error', 'INTERNAL ERROR');
    end;
    aResultArray.AddElement(aResultObject);
  end;
end;
finally
  begin
    pResult.AddPair('value',aResultArray);
    aTempDM.MainConnection.Connected := False;
    FreeAndNil(aTempDM);
  end;
end;

end;

procedure TExtern.createInvoice(pParams: TJSONObject; pCompanyName: string; pCompanyId: integer; var pResult: TJSONObject);
var
  aDeskNr, aText, aTimeString, aResultString, aBillId, aArticleID, aDiscountStr: string;
  aTime: TTime;
  aAmount, aTax, aDiscount, aTotalAmount, aTotalDiscount: double;
  acashDeskId, aPaymentMethodId, aQuantity, aInvoiceId: integer;
  aIsBooked: boolean;
  aDataArray, aResultArray, aPositionArray: TJSONArray;
  aResultObject: TJsonObject;
  aTempDM: TTM;
  aError, aAlreadyPaid: boolean;
  aErrorStr: string;
  aPositionId,aHauptgruppeStr: string;
  aPaymentMethodIdList: TStringList;
  aGuestID, aInvoiceNr, aLeistungsId, aHauptgruppe: integer;
begin
  try
    try
      aError := false;
      aErrorStr := '';
      aResultArray := TJSONArray.Create;

      aIsBooked := false;
      try
        aTempDM := TTM.Create(nil);
        aTempDM.MainConnection.Params.Clear;
        aTempDM.MainConnection.ConnectionDefName := pCompanyName;
        aTempDM.MainConnection.Connected := True;
        aTempDM.MainConnection.TxOptions.AutoCommit := false;
        if not aTempDM.CheckCompany(pCompanyName, pCompanyId) then
        begin
          Log.WriteToLog(pCompanyName, pCompanyId, '<TExtern> createInvoice/wrong CompanyId ',
            lmtError);
          aError := True;
          aErrorStr := 'bookAGuestBill --> pCompanyId not found! NO INVOICE CREATED';
          // create answer
          aResultObject := TJsonObject.Create;
          aResultObject.AddPair('billId', '');
          aResultObject.AddPair('booked', TJSONBool.Create(false));
          aResultObject.AddPair('error', aErrorStr);
          aResultArray.AddElement(aResultObject);
//          pResult.AddPair('value',aResultArray);
        end;
      except
        on e: Exception do
        begin
          aError := True;
          aErrorStr := 'bookAGuestBill --> wrong JSON: percSilenz was wrong, JSON rejected! NO INVOICE CREATED';
          Log.WriteToLog(pCompanyName, pCompanyId, '<TExtern> createInvoice/Create Connection: ' + e.Message,
            lmtError);
          aResultObject := TJsonObject.Create;
          aResultObject.AddPair('billId', '');
          aResultObject.AddPair('booked', TJSONBool.Create(false));
          aResultObject.AddPair('error', aErrorStr);
          aResultArray.AddElement(aResultObject);
//          pResult.AddPair('value',aResultArray);
        end;
      end;
      if not aError then
      begin
          aDataArray := pParams.GetValue('bookInfo') as TJSONArray;
          aPaymentMethodIdList := TStringList.Create;
          for var Item in aDataArray do
          begin
            if aTempDM.MainConnection.InTransaction then
              aTempDM.MainConnection.Commit;
            aTempDM.MainConnection.StartTransaction;
            aPaymentMethodIdList.clear;
            aAmount := 0;
            aTax := 0;
            aDiscount := 0;
            aTotalAmount := 0;
            aTotalDiscount := 0;
            aIsBooked := false;
            aBillId := Item.GetValue<string>('billId');
            Log.WriteToLog(pCompanyName, pCompanyId, '<TExtern> createInvoice/Create Invoice for BillId: ' + aBillId,
              lmtInfo);
            if not aTempDM.CheckDoubleBookingInvoice(pCompanyName,pCompanyId, aBillId) then
            begin
              try
                if not Item.TryGetValue<integer>('cashDeskId', acashDeskId) then
                begin
                  acashDeskId := 1000;
                end
                else
                begin
                  if acashDeskId = 0 then
                  begin
                    acashDeskId := 1000;
                  end;
                end;
                aTotalAmount := (StringReplace(Item.GetValue<string>('totalAmount'), '.', ',', [rfReplaceAll])
                  ).ToDouble;
                aTotalDiscount := (StringReplace(Item.GetValue<string>('totalDiscount'), '.', ',', [rfReplaceAll])
                  ).ToDouble;
                aGuestID := Item.GetValue<integer>('guestId');
                if aTempDM.CheckGuestId(pCompanyName,pCompanyId,aGuestID) then
                begin
                  aAlreadyPaid := Item.GetValue<boolean>('alreadyPaid');
                  aInvoiceNr := aTempDM.GetNextInvoiceNumber(pCompanyName,pCompanyId);
                  if aInvoiceNr > 0 then
                  begin
                    // Get next Invoice Id
                    aInvoiceId := aTempDM.GetGeneratorID(aTempDM.MainConnection,'ID',1,pCompanyName);
                    // create Invoice at first
                    try

                      with aTempDM.QueryInsertRechnung do
                      begin
                        close;
                        ParamByName('pId').AsInteger := aInvoiceId;
                        ParamByName('pfirma').AsInteger := pCompanyId;
                        ParamByName('pRechNr').AsInteger := aInvoiceNr;
                        ParamByName('pGastId').AsInteger := aGuestID;
                        ParamByName('pdatum').AsDateTime := Date;
                        ParamByName('pGedruckt').AsBoolean := true;
                        ParamByName('pBezahlt').AsBoolean := aAlreadyPaid;
                        ParamByName('pBetrag').AsFloat := aTotalAmount;
      //                    ParamByName('KrankenkasseId').AsInteger := aBillId;
                        if aAlreadyPaid then
                        begin
                          ParamByName('pBereitsbezahlt').AsFloat := aTotalAmount;
                        end
                        else
                        begin
                          ParamByName('pBereitsbezahlt').AsFloat := 0;
                        end;
                        ParamByName('pDiscount').AsFloat := aTotalDiscount;
                        Log.WriteToLog(pCompanyName, pCompanyId, '<TExtern> createInvoice/Insert invoice Id: ' + IntToStr(aInvoiceId) +
                              ' Number: ' + IntToStr(aInvoiceNr),
                            lmtInfo);
                        ExecSql;
                      end;
                    except on e: exception do
                      begin
                        Log.WriteToLog(pCompanyName, pCompanyId, '<TExtern> createInvoice/insert invoice: ' + e.Message,
                            lmtError);
                        raise;
                      end;
                    end;
                    Log.WriteToLog(pCompanyName, pCompanyId, '<TExtern> createInvoice/Insert invoice for CheckDoubleBooking: ' + IntToStr(aInvoiceId) +
                              ' Number: ' + IntToStr(aInvoiceNr),
                            lmtInfo);
                    aTempDM.InsertForBookingInvoice(pCompanyName,pCompanyId,aBillId,aInvoiceId);
                    // read all Positions for Rechnungskonto
                    try
                      aPositionArray := TJSONArray.Create;
                      aPositionArray := Item.GetValue<TJSONArray>('billPositions');
                      Log.WriteToLog(pCompanyName, pCompanyId, '<TExtern> createInvoice/read BillPositions ...', lmtInfo);
                      for var Position in aPositionArray do
                      begin
                        aPositionId := Position.GetValue<string>('id');
                        if not Position.TryGetValue<string>('deskNumber', aDeskNr) then
                        begin
                          aDeskNr := '1000';
                        end;
                        if Position.TryGetValue<string>('time', aTimeString) then
                        begin
                          aTime := StrToTime(aTimeString);
                        end
                        else
                        begin
                          aTime := Time;
                        end;
                        // Tax comes in percent
                        aTax := (StringReplace(Position.GetValue<string>('tax'), '.', ',', [rfReplaceAll])).ToDouble;
                        // amount comes without discount. therefore no further calculation is necessary
                        aAmount := (StringReplace(Position.GetValue<string>('amount'), '.', ',', [rfReplaceAll])
                                    ).ToDouble;
                        aquantity := Position.GetValue<integer>('quantity');
                        if Position.TryGetValue<string>('discount', aDiscountStr) then
                        begin
                          aDiscount := (StringReplace(aDiscountStr, '.', ',', [rfReplaceAll])).ToDouble
                        end
                        else
                        begin
                          aDiscount := 0;
                        end;

                        if not Position.TryGetValue<integer>('paymentMethodId', aPaymentMethodId) then
                        begin
                          aPaymentMethodId := 1;
                        end
                        else
                        begin
                          aPaymentMethodId := aTempDM.getZahlweg(pCompanyName, pCompanyId, aPaymentMethodId);
                        end;
                        // Liste auf Paymentmethod überprüfen
                        begin
                          var
                          aPaymentListIndex := aPaymentMethodIdList.IndexOfName(IntToStr(aPaymentMethodId));
                          // increase Payment Amount for RechnungZahlweg
                          if aPaymentListIndex <> -1 then
                          begin
                            var
                              iLastAmount: double;
                            iLastAmount := StrToFloat(aPaymentMethodIdList.ValueFromIndex[aPaymentListIndex]);
                            iLastAmount := iLastAmount + aAmount;
                            aPaymentMethodIdList[aPaymentListIndex] := IntToStr(aPaymentMethodId) + '=' +
                              FloatToStr(iLastAmount);
                          end
                          else
                          begin
                            aPaymentMethodIdList.AddPair(IntToStr(aPaymentMethodId), FloatToStr(aAmount))
                          end;
                        end;
                        Position.TryGetValue('description', aText);
                        if not Position.TryGetValue<integer>('articleGroupId', aHauptgruppe) then
                          aHauptgruppe := 0;
                        if not Position.TryGetValue<string>('articleGroupName', aHauptgruppeStr) then
                          aHauptgruppeStr := '';
                        aText := aText + ' ' + aBillId;

                        if aTempDM.GetLeistungByNameOrId(pCompanyId,pCompanyName,aHauptgruppeStr,aHauptgruppe) then
                        begin

                          aLeistungsId := aHauptgruppe;
                          Log.WriteToLog(pCompanyName, pCompanyId, '<TExtern> createInvoice/Insert invoice to Rechnungskonto ',
                              lmtInfo);
                          if aLeistungsId > 0 then
                          begin
                            // insert to Rechnungskonto
                            with aTempDM.QueryInsertRechnungskonto do
                            begin
                              close;
                              ParamByName('Firma').AsInteger := pCompanyId;
                              ParamByName('RechnungsId').AsInteger := aInvoiceID;
                              ParamByName('LeistungsId').AsInteger := aLeistungsId;
                              ParamByName('LeistungsText').AsString := Trim(aText);
                              ParamByName('Datum').AsDateTime := date;
                              ParamByNAme('Menge').AsInteger := aQuantity;
                              ParamByNAme('GesamtBetrag').AsFloat := aAmount;
                              ParamByNAme('pMWST').AsFloat := aTax;
                              ExecSQL;
                            end;
                            // insert to Journal
                            Log.WriteToLog(pCompanyName, pCompanyId, '<TExtern> createInvoice/Insert invoice to Journal ',
                                lmtInfo);
                            aTempDM.InsertInvoiceJournal(pCompanyName,pCompanyId,aInvoiceID,aLeistungsId,aTime,
                                                         acashDeskId, aAmount/aQuantity, aQuantity, -1,
                                                         12, aTax, Trim(aText) );
                          end
                          else
                          begin
                            aError := True;
                          end;
                        end
                        else
                        begin
                          aError := True;
                          Log.WriteToLog(pCompanyName, pCompanyId, '<TExtern> createInvoice/Get Leistung, Leistung nicht gefunden ',
                              lmtInfo);
                          aErrorStr := 'bookAGuestBill --> No internal ID can be found for articleGroupId: '+
                                  IntToStr(aHauptgruppe)+ ' and articleGroupName: '+aHauptgruppeStr+' ! NO INVOICE CREATED';
                          break;
                        end;
                      end;
                    except on e: exception do
                      begin
                        Log.WriteToLog(pCompanyName, pCompanyId, '<TExtern> createInvoice/insert rechnungskonto: ' + e.Message,
                          lmtError);
                        raise;
                      end;
                    end;
                    if not aError then
                    begin
                      if aTempDM.InsertRechnungMwSt(pCompanyName,pCompanyId,aInvoiceId) then
                      begin

                        for var payMethIndex := 0 to aPaymentMethodIdList.Count -1 do
                        begin
                          if (StrToFloat(aPaymentMethodIdList.ValueFromIndex[payMethIndex]) <> 0) then
                          begin
                            aTempDM.InsertRechnungZahlweg(pCompanyName,pCompanyId,aInvoiceId,
                                  Date, StrToInt(aPaymentMethodIdList.Names[payMethIndex]),
                                  StrToFloat(aPaymentMethodIdList.ValueFromIndex[payMethIndex]),
                                  aAlreadyPaid);
                          end;
                        end;
                        aTempDM.InsertInvoiceJournal(pCompanyName,pCompanyId,aInvoiceID,-1,aTime,
                                                       acashDeskId, aTotalAmount, 1, aPaymentMethodId,
                                                       7, -1, 'Kassenrechnung');
                        // Now write Invoice Number back to DB
                        aTempDM.UpdateDiversRechnungNr(pCompanyName,pCompanyId,aInvoiceNr);

                        // create answer
                        aResultObject := TJsonObject.Create;
                        aResultObject.AddPair('billId', aBillId);
                        aResultObject.AddPair('booked', TJSONBool.Create(True));
                        aResultObject.AddPair('felixInvoiceNumber', TJSONNumber.Create(aInvoiceNr));
                        aResultArray.AddElement(aResultObject);
                        aTempDM.MainConnection.Commit;
                      end;
                    end
                    else
                    begin
                      aTempDM.MainConnection.Rollback;
                      aResultObject := TJsonObject.Create;
                      aResultObject.AddPair('billId', aBillId);
                      aResultObject.AddPair('booked', TJSONBool.Create(false));
                      aResultObject.AddPair('error', aErrorStr);
                      aResultArray.AddElement(aResultObject);
                    end;
                  end
                  else
                  begin
                    aError := True;
                    aErrorStr := 'bookAGuestBill --> Can not create an InvoiceNumber! NO INVOICE CREATED';
                    // create answer
                    aResultObject := TJsonObject.Create;
                    aResultObject.AddPair('billId', aBillId);
                    aResultObject.AddPair('booked', TJSONBool.Create(false));
                    aResultObject.AddPair('error', aErrorStr);
                    aResultArray.AddElement(aResultObject);
                  end
                end
                else
                begin
                  aError := True;
                  aErrorStr := 'bookAGuestBill --> GuestId not found! NO INVOICE CREATED';
                  // create answer
                  aResultObject := TJsonObject.Create;
                  aResultObject.AddPair('billId', aBillId);
                  aResultObject.AddPair('booked', TJSONBool.Create(false));
                  aResultObject.AddPair('error', aErrorStr);
                  aResultArray.AddElement(aResultObject);
                  if aTempDM.MainConnection.InTransaction then
                    aTempDM.MainConnection.Rollback;
                end;
              except on e: exception do
                begin
                  // all Exceptions while createing invoice run in this except block

                  aError := True;
                  aErrorStr := 'bookAGuestBill --> Found Error while creating Invoice! NO INVOICE CREATED';
                  // create answer
                  aResultObject := TJsonObject.Create;
                  aResultObject.AddPair('billId', aBillId);
                  aResultObject.AddPair('booked', TJSONBool.Create(false));
                  aResultObject.AddPair('error', aErrorStr);
                  aResultArray.AddElement(aResultObject);
                  if aTempDM.MainConnection.InTransaction then
                    aTempDM.MainConnection.Rollback;
//                  if aInvoiceId > 0 then
//                  begin
//                    aTempDM.DeleteInvoice(pCompanyName,pCompanyId,aInvoiceId);
//                  end;
                  Log.WriteToLog(pCompanyName, pCompanyId, '<TExtern> createInvoice/create invoice: ' + e.Message,
                        lmtError);
                end;
              end;
            end
            else
            begin
              // send back true because is a double booking
              Log.WriteToLog(pCompanyName, pCompanyId,'<TExtern> createInvoice -> Doublebooking found billId: '+
                     aBillId, lmtInfo);
              if aTempDM.MainConnection.InTransaction then
                aTempDM.MainConnection.Commit;
              aErrorStr := 'bookAGuestBill --> This billId has been booked before ! NO INVOICE CREATED';
              aResultObject := TJsonObject.Create;
              aResultObject.AddPair('billId', aBillId);
              aResultObject.AddPair('booked', TJSONBool.Create(True));
              aResultObject.AddPair('error', aErrorStr);
              aResultArray.AddElement(aResultObject);
            end; // if not Doublebooking

          end; // for var Item in aDataArray do

      end; // if aError after Connection connected

    except
      // Main Exceptblock
      on e: Exception do
      begin
        Log.WriteToLog(pCompanyName, pCompanyId, '<TExtern> createInvoice:  ' + e.Message, lmtError);
        if aTempDM.MainConnection.InTransaction then
          aTempDM.MainConnection.Rollback;
//        aResultObject := TJsonObject.Create;
        aResultObject.AddPair('billId', aBillId);
        aResultObject.AddPair('booked', 'false');
        if aErrorStr <> '' then
        begin
          aResultObject.AddPair('error', aErrorStr);
        end
        else
        begin
          aResultObject.AddPair('error', 'INTERNAL ERROR');
        end;
        aResultArray.AddElement(aResultObject);
      end;
    end;
  finally
    begin
      pResult.AddPair('value',aResultArray);
      aTempDM.MainConnection.Connected := False;
      FreeAndNil(aTempDM);
      if Assigned(aPaymentMethodIdList) then
        aPaymentMethodIdList.Free;
    end;
  end;
end;


procedure TExtern.saveKassInfo(pFirma : integer; pCompanyName: string; pParam: TJSONObject; var pResult: TJSONObject);
var
  aDataArray, aResultArray: TJSONArray;
  aResultObj: TJSONObject;
  aPersId, aReceiptId, aShortName, aSingleBooking, aErrorString, aKassInfoId,
    aWaiterName, aDateString, aDataBase: string;
  aReservId, aQuantity, aWaiterId, aTableId, aCashDId, aFirma: integer;
  aPrice, aTaxRate: Double;
  aIsSingleBooking: boolean;
  aConnection: TFDConnection;
  aTempDM :TTM;
begin
  try
    Log.WriteToLog(pCompanyName, pFirma,'<TExtern> SaveKassInfo ...');
    Log.WriteToLog(pCompanyName, pFirma,'<TExtern> In Json: '+pParam.ToJson);
    try
      try
        if not pParam.TryGetValue<string>('percSilenz', aDataBase) then
           aDataBase := pCompanyName;
        aConnection := TFDConnection.Create(nil);
        aConnection.Params.Clear;
        aConnection.ConnectionDefName := aDataBase;
        aConnection.Connected := true;
        aResultArray := TJSONArray.Create;
      except
        on E: Exception do
        begin
          Log.WriteToLog(pCompanyName, pFirma,'<TExtern> saveKassInfo/ Create Connection: ' + E.Message,
            lmtError);
        end;
      end;
      if not pParam.TryGetValue<integer>('companyId', aFirma) then
           aFirma := pFirma;
      if aFirma = 0 then aFirma := 1;

      aSingleBooking := pParam.GetValue<string>('singleBooking');
      if aSingleBooking.ToUpper = 'TRUE' then
        aIsSingleBooking := true
      else
        aIsSingleBooking := FALSE;
      aDataArray := pParam.GetValue('bookInfo') as TJSONArray;
      aTempDM := TTM.Create(nil);
      for var Item in aDataArray do
      begin
        aPersId := Item.GetValue<string>('persId');
        aReservId := Item.GetValue<string>('reservId').ToInteger;
        aQuantity := (Item.GetValue<string>('quantity')).ToInteger;
        aPrice := (StringReplace(Item.GetValue<string>('price'), '.', ',',
          [rfReplaceAll])).ToDouble;
        aTaxRate := (StringReplace(Item.GetValue<string>('taxRate'), '.', ',',
          [rfReplaceAll])).ToDouble;
        aReceiptId := Item.GetValue<string>('receiptId');
        aCashDId := Item.GetValue<integer>('cashDId');

        if not Item.TryGetValue('waiterId', aWaiterId) then
          aWaiterId := 1;
        Item.TryGetValue('name', aShortName);
        Item.TryGetValue('tableId', aTableId);
        aKassInfoId := Item.GetValue<string>('id');
        aDateString := '';
        if aTempDM.WriteToGastkonto(aConnection, intToStr(aTableId), aPersId,
          aQuantity, aPrice, aTaxRate, aWaiterId, aReservId, aFirma,
          aShortName, aReceiptId, aIsSingleBooking, true, aDataBase,
          true, aCashDId, aKassInfoId, aErrorString, aDateString, true) then
        begin
          aResultObj := TJSONObject.Create;
          aResultObj.AddPair('id', aKassInfoId);
        end
        else
        begin
          aResultObj := TJSONObject.Create;
          aResultObj.AddPair('id', aKassInfoId);
          aResultObj.AddPair('error', aErrorString);
        end;
        aResultArray.Add(aResultObj);
      end;
    except
      on E: Exception do
      begin
        Log.WriteToLog(pCompanyName, pFirma,'<TExtern> saveKassInfo: ' + E.Message, lmtError);
        aResultObj := TJSONObject.Create;
        aResultObj.AddPair('id', aKassInfoId);
        aResultObj.AddPair('error', E.Message);
        aResultArray.Add(aResultObj);
      end;
    end;
  finally
    pResult.AddPair('storedIds', aResultArray);
    Log.WriteToLog(pCompanyName, pFirma,'<TExtern> Result: ' + pResult.ToString);
    aConnection.Connected := FALSE;
    aConnection.Free;
    aTempDM.Free;
  end;

end;






//procedure TX3000.processesCashRegister(pParam: TJSONObject;
//  var pResult: TJSONObject);
//var
//  aCashValues: TJSONArray;
//  aCCount, aLeistungsID, aFirma: integer;
//  isWritten: boolean;
//  aKasseID, aHauptGruppeID, aBetrag, aMitArbID, aResultBuchUmsatz,
//    aDateString: string;
//  aUmsatzDatum, aFelixDate: TDate;
//  aConnection: TFDConnection;
//  procedure BucheUmsatz(pBetrag: Currency);
//  begin
//    DM.WriteToKassenJournal(aConnection, aFelixDate,
//      'Umsatz Kasse | ' + DateToStr(aUmsatzDatum), null, 1, aLeistungsID, null,
//      12, null, pBetrag, FALSE, DM.FUserFirmaID, StrToInt(aMitArbID),
//      StrToInt(aKasseID), null);
//    try
//      DM.TableRechnung.Connection := aConnection;
//      DM.TableRechnung.Open;
//
//      if ((DM.TableRechnung.FieldByName('Datum').AsDateTime = aFelixDate) and
//        ((DM.TableRechnung.FieldByName('Rechnungsnummer').AsLargeInt = 0) or
//        (DM.TableRechnung.FieldByName('Rechnungsnummer').AsLargeInt = 99999)))
//        OR DM.TableRechnung.Locate('Firma;Rechnungsnummer;Datum',
//        VarArrayOf([DM.FUserFirmaID, 0, aFelixDate]), []) then
//      begin
//        DM.WriteToTableRechnungskonto(aConnection, aFirma, aLeistungsID,
//          1, pBetrag);
//      end
//      else
//      begin
//        rstFelixMain.WriteToColorLog
//          ('Fehler in TX3000.BucheUmsatz: Rechnung nicht gefunden gefunden | LeistungsId: '
//          + intToStr(aLeistungsID), lmtError);
//        aResultBuchUmsatz := aResultBuchUmsatz +
//          ' | Rechnung nicht gefunden gefunden | LeistungsId: ' +
//          intToStr(aLeistungsID);
//      end;
//
//    finally
//      DM.TableRechnung.Close;
//    end;
//  end;
//
//begin
//  try
//    try
//      try
//        aConnection := TFDConnection.Create(nil);
//        aConnection.Params.Clear;
//        aConnection.ConnectionDefName := DM.FUserCompanyName;
//        aConnection.Connected := true;
//        pResult := TJSONObject.Create;
//
//        aConnection.ConnectionDefName := DM.FUserCompanyName;
//        aConnection.Connected := true;
//        aFirma := DM.FUserFirmaID
//      except
//        on E: Exception do
//        begin
//          rstFelixMain.WriteToColorLog('TX3000.Fehler in UmsatzKassa: ' +
//            E.Message, lmtError);
//          pResult.AddPair('result', 'Fehler in UmsatzKassa: Internal Error!' +
//            aResultBuchUmsatz);
//        end;
//      end;
//      aCashValues := pParam.GetValue('allValues') as TJSONArray;
//      aFelixDate := DM.GetFelixDate(aConnection, intToStr(aFirma));
//      DM.TableUmsatzzuordnung.Connection := aConnection;
//      DM.TableUmsatzzuordnung.Open;
//      isWritten := FALSE;
//      for var Value in aCashValues do
//      begin
//        Value.TryGetValue('HauptGruppeID', aHauptGruppeID);
//        Value.TryGetValue('Betrag', aBetrag);
//        Value.TryGetValue('MitarbeiterID', aMitArbID);
//        Value.TryGetValue('Datum', aUmsatzDatum);
//        if pParam.TryGetValue('KassaID', aKasseID) then
//          aLeistungsID := DM.getLeistungsID1(aConnection, aFirma,
//            StrToInt(aKasseID), aHauptGruppeID)
//        else
//          aLeistungsID := DM.getLeistungsID1(aConnection, aFirma, 0,
//            aHauptGruppeID);
//
//        BucheUmsatz(StrToFloat(aBetrag));
//        isWritten := true;
//      end;
//
//      DM.TableUmsatzzuordnung.Close;
//      // ''''''''''''''''''''''''''''''''
//      DM.getRebookings(aConnection, aUmsatzDatum, intToStr(aFirma));
//      DM.setAllRebookingsToNull(aConnection, aUmsatzDatum, intToStr(aFirma));
//      // ''''''''''''''''''''''''''''''''''
//      if not isWritten then
//      begin
//        // pResultStr := '{"result": "Es waren keine Einträge vorhanden' + aResultBuchUmsatz + '"}';
//        pResult.AddPair('result', 'Es waren keine Einträge vorhanden' +
//          aResultBuchUmsatz);
//
//      end
//      else
//      begin
//        // pResultStr := '{"result": "Umsatz wurde übertragen' + aResultBuchUmsatz + '"}';
//        pResult.AddPair('result', 'Umsatz wurde übertragen' +
//          aResultBuchUmsatz);
//      end;
//
//    except
//      on E: Exception do
//      begin
//        rstFelixMain.WriteToColorLog('TX3000.Fehler in UmsatzKassa: ' +
//          E.Message, lmtError);
//        pResult.AddPair('result', 'Fehler in UmsatzKassa: ' + E.Message +
//          aResultBuchUmsatz);
//      end;
//    end;
//  finally
//    aConnection.Connected := FALSE;
//    aConnection.Free;
//  end;
//
//end;
//
//procedure TX3000.waiterReceipts(pLosung: TJSONObject; var pResult: TJSONObject);
//var
//  aKasseDate, aFelixDate: TDate;
//  aReceipts, aResultArr: TJSONArray;
//  aResultObj: TJSONObject;
//  aArticleID, aKasseID, aWaiterId: integer;
//  aNachname: string;
//  AZahlWegID, aFelixZahlwegID, aWaiterReservID, aRechnungsId: int64;
//  aBetrag, aSumBetrag: Double;
//  aConnection: TFDConnection;
//begin
//  try
//    try
//      try
//        aConnection := TFDConnection.Create(nil);
//        aConnection.Params.Clear;
//        aConnection.ConnectionDefName := DM.FUserCompanyName;
//        aConnection.Connected := true;
//      except
//        on E: Exception do
//        begin
//          rstFelixMain.WriteToColorLog
//            ('Error in TX3000.saveKassInfo/ Create Connection: ' + E.Message,
//            lmtError);
//        end;
//      end;
//      DM.TableLosungsZuordnung.Connection := aConnection;
//      DM.TableLosungsZuordnung.Open;
//
//      aFelixDate := DM.GetFelixDate(aConnection, intToStr(DM.FUserFirmaID));
//
//      begin
//        aReceipts := pLosung.GetValue('waiterReceipts') as TJSONArray;
//        for var receipt in aReceipts do
//          try
//
//            DM.TableRechZahlweg.Connection := aConnection;
//            DM.TableRechZahlweg.Open;
//            DM.TableLosungsZuordnung.Connection := aConnection;
//            DM.TableLosungsZuordnung.Open;
//
//            DM.TableRechnung.Connection := aConnection;
//            DM.TableRechnung.Open;
//            DM.TableRechnung.Append;
//            DM.TableRechnung.FieldByName('ID').AsInteger :=
//              DM.GetGeneratorID(aConnection, 'id', 1);
//            DM.TableRechnung.FieldByName('Datum').AsDateTime := aFelixDate;
//            DM.TableRechnung.FieldByName('Rechnungsnummer').AsLargeInt := 0;
//            DM.TableRechnung.FieldByName('Gedruckt').AsBoolean := true;
//            DM.TableRechnung.FieldByName('Bezahlt').AsBoolean := true;
//            DM.TableRechnung.Post;
//
//            aReceipts.TryGetValue('name', aNachname);
//            AZahlWegID := aReceipts.GetValue<integer>('payMetId');
//            aBetrag := aReceipts.GetValue<Double>('amount');
//            aWaiterReservID := aReceipts.GetValue<integer>('WaiterReservID');
//            aKasseDate := StrToDate(aReceipts.GetValue<string>('date'));
//            aKasseID := aReceipts.GetValue<integer>('cashDId');
//            aWaiterId := aReceipts.GetValue<integer>('waiterId');
//
//            if DM.TableLosungsZuordnung.Locate('Firma;ZahlwgIDKasse',
//              VarArrayOf([DM.FUserFirmaID, AZahlWegID]), []) or
//              DM.TableLosungsZuordnung.Locate('ZahlwgIDKasse',
//              AZahlWegID, []) Then
//              aFelixZahlwegID := DM.TableLosungsZuordnung.FieldByName
//                ('ZahlwgIDFelix').AsLargeInt
//            else
//              aFelixZahlwegID := AZahlWegID;
//            aBetrag := aBetrag;
//            if (DM.ReadGlobalValue(aConnection, 'GKTWaiterArticleID', '0', 'KINTEGER') > 0)
//              and (aFelixZahlwegID = 1) then
//            begin
//              if aWaiterReservID > 0 then
//              begin
//                DM.WriteLeistungToGastKontoIB(aConnection, aFelixDate, DM.FUserFirmaID,
//                  aWaiterReservID, 1, DM.ReadGlobalValue(aConnection, 'GKTWaiterArticleID',
//                  '0', 'KINTEGER'), 1, aBetrag, FALSE, FALSE, FALSE, FALSE,
//                  'Losung ' + DateToStr(aKasseDate), '', 7, 0, aWaiterReservID,
//                  null, null);
//                aBetrag := 0;
//              end;
//            end;
//
//            DM.WriteToKassenJournal(aConnection, aFelixDate,
//              'Losung ' + DateToStr(aKasseDate) + ' | ' + aNachname,
//              aFelixZahlwegID, null, null, null, 7, null, aBetrag, FALSE,
//              DM.FUserFirmaID, aWaiterId, aKasseID, null);
//
//            DM.TableRechZahlweg.Append;
//            DM.TableRechZahlweg.FieldByName('ID').AsLargeInt :=
//              DM.GetGeneratorID(aConnection, 'id', 1);
//            DM.TableRechZahlweg.FieldByName('Firma').AsLargeInt :=
//              DM.FUserFirmaID;
//            DM.TableRechZahlweg.FieldByName('Datum').AsDateTime := aFelixDate;
//            DM.TableRechZahlweg.FieldByName('RechnungsID').AsLargeInt :=
//              DM.TableRechnung.FieldByName('ID').AsLargeInt;
//            DM.TableRechZahlweg.FieldByName('Zahlwegid').AsLargeInt :=
//              aFelixZahlwegID;
//            DM.TableRechZahlweg.FieldByName('Verbucht').AsBoolean := true;
//            DM.TableRechZahlweg.FieldByName('Betrag').AsFloat := aBetrag;
//            aSumBetrag := aSumBetrag + aBetrag;
//            DM.TableRechZahlweg.Post;
//            DM.TableZahlweg.Open;
//            if DM.TableZahlweg.Locate('Firma;ID;KreditKarte',
//              VarArrayOf([DM.FUserFirmaID, AZahlWegID, 'T']), []) then
//            begin
//              DM.InsertKreditOffen(aConnection, DM.FUserFirmaID, aBetrag, AZahlWegID,
//                aFelixDate, 0, aWaiterReservID);
//            end;
//            DM.TableZahlweg.Close;
//
//            DM.TableRechnung.Edit;
//            DM.TableRechnung.FieldByName('ZahlungsBetrag').AsFloat :=
//              aSumBetrag;
//            DM.TableRechnung.FieldByName('BereitsBezahlt').AsFloat :=
//              aSumBetrag;
//            DM.TableRechnung.Post;
//
//            aResultObj := TJSONObject.Create;
//            aResultObj.AddPair('date', DateToStr(aKasseDate));
//            aResultObj.AddPair('done', 'TRUE');
//            aResultArr.AddElement(aResultObj);
//
//          except
//            on E: Exception do
//            begin
//              rstFelixMain.WriteToColorLog('Error in TAPI.LosungKellner: ' +
//                E.Message, lmtError);
//              aResultObj := TJSONObject.Create;
//              aResultObj.AddPair('date', DateToStr(aKasseDate));
//              aResultObj.AddPair('done', 'FALSE');
//              aResultObj.AddPair('error', E.Message);
//              aResultArr.AddElement(aResultObj);
//            end;
//          end;
//      end
//    except
//      on E: Exception do
//      begin
//        rstFelixMain.WriteToColorLog('Error in TAPI.LosungKellner: ' +
//          E.Message, lmtError);
//        aResultObj := TJSONObject.Create;
//        aResultObj.AddPair('date', DateToStr(aKasseDate));
//        aResultObj.AddPair('done', 'FALSE');
//        aResultObj.AddPair('error', E.Message);
//        aResultArr.AddElement(aResultObj);
//      end;
//    end;
//  finally
//    DM.TableLosungsZuordnung.Close;
//    DM.TableRechZahlweg.Close;
//    DM.TableRechnung.Close;
//    aConnection.Connected := FALSE;
//    aConnection.Free;
//    pResult.AddPair('saved', aResultArr);
//  end;
//
//end;

end.
