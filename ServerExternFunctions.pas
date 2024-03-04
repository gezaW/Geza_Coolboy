unit ServerExternFunctions;

interface

uses
  System.SysUtils, System.Classes, System.JSON, System.Variants, System.DateUtils,
  ServerIntf, ServerMethodsUnit,
  DataSnap.DSProviderDataModuleAdapter, Winapi.Windows,
  DataSnap.DSServer, DataSnap.DSAuth,
  FireDAC.Comp.Client;

type
  TEF = class(TDSServerModule)
  private
    procedure SplitParams(Delimiter: Char; Str: string; ListOfStrings: TStringList);
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    function getCheckedInGuests(pParams: string): TJsonObject;
    function getGuestsByDate(pParams: String): TJsonObject;
    function bookAGuestBill(pParams: TJsonObject): TJsonObject;
    function bookARoomBill(pParams: TJsonObject): TJsonObject;
  end;

var
  EF: TEF;

implementation

uses DataModule, restFelixMainUnit, Resources, TempModul, Logging, ExternalCashDesk;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}


procedure TEF.SplitParams(Delimiter: Char; Str: string; ListOfStrings: TStringList);
begin
  // ListOfStrings.Clear;
  ListOfStrings.Delimiter := Delimiter;
  ListOfStrings.StrictDelimiter := True;
  ListOfStrings.DelimitedText := Str;
end;

function TEF.getGuestsByDate(pParams: String): TJsonObject;
var
  pResultArr: TJSONArray;
  aDataBase: String;
  aFirma: integer;
  aExtern: TExtern;
  aParams: TStringList;
  aError: boolean;
  aErrorStr: String;
  aConnection: TFDConnection;
  aDateString: string;
  aDate: TDateTime;
begin
  try
    try
      try
        try
          aErrorStr := '';
          aError := false;
          aParams := TStringList.Create;
          aParams.NameValueSeparator := '|';
          SplitParams('&', pParams, aParams);

          if Copy(aParams[0], 0, Pos('=', aParams[0]) - 1) = 'companyId' then
          begin
            if not TryStrToInt(Copy(aParams[0], Pos('=', aParams[0]) + 1), aFirma) then
            begin
              aError := True;
              aErrorStr := 'getGuestsByDate -> read companyId: wrong ParamValue';
              Log.WriteToLog(aDataBase, aFirma, '<TEF> getGuestsByDate -> read companyId: wrong ParamValue' +
                aParams[0], lmtError);
            end;
          end
          else
          begin
            aError := True;
            aErrorStr := 'getGuestsByDate -> read Params: incorrect sorting';
            Log.WriteToLog(aDataBase, aFirma, '<TEF> getGuestsByDate -> read params: incorrect sorting' +
              aParams[0], lmtError);
          end;

          if not aError then
          begin
            if Copy(aParams[1], 0, Pos('=', aParams[1]) - 1) = 'percSilenz' then
            begin
              aDataBase := Copy(aParams[1], Pos('=', aParams[1]) + 1);
              try
                try
                  aConnection := TFDConnection.Create(nil);
                  aConnection.Params.Clear;
                  aConnection.ConnectionDefName := aDataBase;
                  aConnection.Connected := True;
                except
                  on e: Exception do
                  begin
                    aError := True;
                    aErrorStr := 'getGuestsByDate -> read percSilenz: wrong ParamValue';
                    Log.WriteToLog(aDataBase, aFirma,
                      '<TEF> getGuestsByDate -> read percSilenz: wrong ParamValue: ' + e.Message,
                      lmtError);

                  end;
                end;
              finally
                aConnection.Close;
                FreeAndNil(aConnection);
              end;
            end
            else
            begin
              aError := True;
              aErrorStr := 'getGuestsByDate -> read Params: incorrect sorting';
              Log.WriteToLog(aDataBase, aFirma, '<TEF> getGuestsByDate -> read Params: incorrect sorting' +
                aParams[0], lmtError);
            end;
          end;
          if not aError then
          begin
            if Copy(aParams[2], 0, Pos('=', aParams[2]) - 1) = 'LastModificationDate' then
            begin
              aDateString := Copy(aParams[2], Pos('=', aParams[2]) + 1);
              try
                try
                  aDate := ISO8601ToDate(aDateString);
                except
                  on e: Exception do
                  begin
                    aError := True;
                    aErrorStr := 'getGuestsByDate -> read LastModificationDate: wrong ParamValue';
                    Log.WriteToLog(aDataBase, aFirma,
                      '<TEF> getGuestsByDate -> read LastModificationDate: wrong ParamValue: ' + e.Message,
                      lmtError);

                  end;
                end;
              finally

              end;
            end
            else
            begin
              aError := True;
              aErrorStr := 'getGuestsByDate -> read Params: incorrect sorting';
              Log.WriteToLog(aDataBase, aFirma, '<TEF> getGuestsByDate -> read Params: incorrect sorting' +
                aParams[0], lmtError);
            end;
          end;
        except
          on e: Exception do
          begin
            aError := True;
            aErrorStr := 'getGuestsByDate -> Error while reading Params';
            Log.WriteToLog(aDataBase, aFirma, '<TEF> getGuestsByDate -> Error while reading Params: ' +
              e.Message,
              lmtError);

          end;
        end;
      finally
        FreeAndNil(aParams);
      end;

      if not aError then
      begin
        aExtern := TExtern.Create(nil);
        pResultArr := TJSONArray.Create;
        aExtern.getGuestByDate(aFirma, aDataBase, aDate, pResultArr, aError);
        if aError then
        begin
          aErrorStr := 'getGuestsByDate -> found internal Error';
        end;
      end;
    except
      on e: Exception do
      begin
        Log.WriteToLog(aDataBase, aFirma, '<TEF> getGuestsByDate: ' + e.Message, lmtError);
        aError := True;
      end;
    end;
  finally
    result := TJsonObject.Create;
    if aError then
    begin
      result.AddPair('Error', aErrorStr);
    end
    else
    begin
      result.AddPair('GuestsInfo', pResultArr);
    end;
    Log.WriteToLog(aDataBase, aFirma, '<TEF> getGuestsByDate Out JSON: ' + result.ToString);
  end;
end;

function TEF.getCheckedInGuests(pParams: string): TJsonObject;
var
  pResultArr: TJSONArray;
  aDataBase: String;
  aFirma: integer;
  aExtern: TExtern;
  aParams: TStringList;
  aError: boolean;
  aErrorStr: String;
  aConnection: TFDConnection;
  aDateString: string;
  aDate: TDateTime;
begin
  try
    try
      try
        try
          aErrorStr := '';
          aError := false;
          aParams := TStringList.Create;
          aParams.NameValueSeparator := '|';
          SplitParams('&', pParams, aParams);

          if Copy(aParams[0], 0, Pos('=', aParams[0]) - 1) = 'companyId' then
          begin
            if not TryStrToInt(Copy(aParams[0], Pos('=', aParams[0]) + 1), aFirma) then
            begin
              aError := True;
              aErrorStr := 'getCheckedInGuests -> read companyId: wrong ParamValue';
              Log.WriteToLog(aDataBase, aFirma, '<TEF> getCheckedInGuests -> read companyId: wrong ParamValue'
                + aParams[0], lmtError);
            end;
          end
          else
          begin
            aError := True;
            aErrorStr := 'getCheckedInGuests -> read Params: incorrect sorting';
            Log.WriteToLog(aDataBase, aFirma, '<TEF> getCheckedInGuests -> read params: incorrect sorting' +
              aParams[0], lmtError);
          end;

          if not aError then
          begin
            if Copy(aParams[1], 0, Pos('=', aParams[1]) - 1) = 'percSilenz' then
            begin
              aDataBase := Copy(aParams[1], Pos('=', aParams[1]) + 1);
              try
                try
                  aConnection := TFDConnection.Create(nil);
                  aConnection.Params.Clear;
                  aConnection.ConnectionDefName := aDataBase;
                  aConnection.Connected := True;
                except
                  on e: Exception do
                  begin
                    aError := True;
                    aErrorStr := 'getCheckedInGuests -> read percSilenz: wrong ParamValue';
                    Log.WriteToLog(aDataBase, aFirma,
                      '<TEF> getCheckedInGuests -> read percSilenz: wrong ParamValue: ' + e.Message,
                      lmtError);

                  end;
                end;
              finally
                aConnection.Close;
                FreeAndNil(aConnection);
              end;
            end
            else
            begin
              aError := True;
              aErrorStr := 'getCheckedInGuests -> read Params: incorrect sorting';
              Log.WriteToLog(aDataBase, aFirma, '<TEF> getCheckedInGuests -> read Params: incorrect sorting' +
                aParams[0], lmtError);
            end;
          end;
        except
          on e: Exception do
          begin
            aError := True;
            aErrorStr := 'getCheckedInGuests -> Error while reading Params';
            Log.WriteToLog(aDataBase, aFirma, '<TEF> getCheckedInGuests -> Error while reading Params: ' +
              e.Message,
              lmtError);

          end;
        end;
      finally
        FreeAndNil(aParams);
      end;

      if not aError then
      begin
        aExtern := TExtern.Create(nil);
        pResultArr := TJSONArray.Create;
        aExtern.getCheckedInGuests(aFirma, aDataBase, pResultArr, aError);
        if aError then
        begin
          aErrorStr := 'getCheckedInGuests -> found internal Error';
        end;
      end;
    except
      on e: Exception do
      begin
        Log.WriteToLog(aDataBase, aFirma, '<TEF> getCheckedInGuests: ' + e.Message, lmtError);
        aError := True;
      end;
    end;
  finally
    result := TJsonObject.Create;
    if aError then
    begin
      result.AddPair('Error', aErrorStr);
    end
    else
    begin
      result.AddPair('GuestsInfo', pResultArr);
    end;
    Log.WriteToLog(aDataBase, aFirma, '<TEF> getCheckedInGuests Out JSON: ' + result.ToString);
  end;
end;

function TEF.bookAGuestBill(pParams: TJsonObject): TJsonObject;
var
  aError: boolean;
  aErrorStr, aCompName: string;
  aDM: TExtern;
  aFirma: integer;
  aResultObject: TJsonObject;
begin
  try
    try

      result := TJsonObject.Create;
      aError := false;
      aErrorStr := '';
      if not pParams.TryGetValue<string>('percSilenz', aCompName) then
      begin
        aError := True;
        aErrorStr := 'bookAGuestBill --> wrong JSON: Reading percSilenz from JSON was not possible!';
        Log.WriteToLog(aCompName, aFirma,
          '<TEF> bookAGuestBill: Auslesen von CompanyName aus JSON war nicht möglich! ');
      end
      else
      begin
        if aCompName = '' then
        begin
          aError := True;
          aErrorStr := 'bookAGuestBill --> wrong JSON: Reading percSilenz from JSON was not possible!';
          Log.WriteToLog(aCompName, aFirma, '<TEF> bookAGuestBill: CompanyName im JSON ist leer! ');
        end;
      end;
      if not aError then
      begin
        if not pParams.TryGetValue<integer>('companyId', aFirma) then
        begin
          aError := True;
          aErrorStr := 'bookAGuestBill --> wrong JSON: Reading companyId from JSON was not possible!';
          Log.WriteToLog(aCompName, aFirma, '<TEF> bookAGuestBill: companyId im JSON ist leer! ');
        end;
      end;
      Log.WriteToLog(aCompName, aFirma,
          '<TEF> bookAGuestBill in String: ' + pParams.ToJSON);
      if not aError then
      begin
        aDM := TExtern.Create(nil);
        aDM.createInvoice(pParams,aCompName, aFirma, result);
      end
      else
      begin
        aResultObject := TJsonObject.Create;
        aResultObject.AddPair('billId', '');
        aResultObject.AddPair('booked', 'false');
        aResultObject.AddPair('error', aErrorStr);
        result := TJsonObject.ParseJSONValue('{"value":' + aResultObject.ToJson
          + '}') as TJsonObject;
      end;
    except
      on e: Exception do
      begin
        Log.WriteToLog(aCompName, aFirma, '<TEF> bookAGuestBill:  ' + e.Message,
          lmtError);
        aResultObject := TJsonObject.Create;
        aResultObject.AddPair('billId', '');
        aResultObject.AddPair('booked', 'false');
        if aErrorStr <> '' then
        begin
          aResultObject.AddPair('error', aErrorStr);
        end
        else
        begin
          aResultObject.AddPair('error', 'INTERNAL ERROR');
        end;
        result := TJsonObject.ParseJSONValue('{"value":' + aResultObject.ToJson
          + '}') as TJsonObject;
      end;
    end;
  finally
    Log.WriteToLog(aCompName, aFirma, '<TEF> bookAGuestBill Out JSON: ' + result.ToString);
    FreeAndNil(aDM);
  end;

end;


function TEF.bookARoomBill(pParams: TJsonObject): TJsonObject;
var
  aError: boolean;
  aErrorStr, aCompName: string;
  aDM: TExtern;
  aFirma: integer;
  aResultObject: TJsonObject;
begin
  try
    try

      result := TJsonObject.Create;
      aError := false;
      aErrorStr := '';
      if not pParams.TryGetValue<string>('percSilenz', aCompName) then
      begin
        aError := True;
        aErrorStr := 'bookARoomBill --> wrong JSON: Reading percSilenz from JSON was not possible!';
        Log.WriteToLog(aCompName, aFirma,
          '<TEF> bookARoomBill: Auslesen von CompanyName aus JSON war nicht möglich! ');
      end
      else
      begin
        if aCompName = '' then
        begin
          aError := True;
          aErrorStr := 'bookARoomBill --> wrong JSON: Reading percSilenz from JSON was not possible!';
          Log.WriteToLog(aCompName, aFirma, '<TEF> bookARoomBill: CompanyName im JSON ist leer! ');
        end;
      end;
      if not aError then
      begin
        if not pParams.TryGetValue<integer>('companyId', aFirma) then
        begin
          aError := True;
          aErrorStr := 'bookARoomBill --> wrong JSON: Reading companyId from JSON was not possible!';
          Log.WriteToLog(aCompName, aFirma, '<TEF> bookARoomBill: companyId im JSON ist leer! ');
        end;
      end;
      Log.WriteToLog(aCompName, aFirma,
          '<TEF> bookARoomBill in String: ' + pParams.ToJSON);
      if not aError then
      begin
        aDM := TExtern.Create(nil);
        aDM.createARoomBill(pParams,aCompName, aFirma, result);
      end
      else
      begin
        aResultObject := TJsonObject.Create;
        aResultObject.AddPair('billId', '');
        aResultObject.AddPair('booked', 'false');
        aResultObject.AddPair('error', aErrorStr);
        result := TJsonObject.ParseJSONValue('{"value":' + aResultObject.ToJson
          + '}') as TJsonObject;
      end;
    except
      on e: Exception do
      begin
        Log.WriteToLog(aCompName, aFirma, '<TEF> bookARoomBill:  ' + e.Message,
          lmtError);
        aResultObject := TJsonObject.Create;
        aResultObject.AddPair('billId', '');
        aResultObject.AddPair('booked', 'false');
        if aErrorStr <> '' then
        begin
          aResultObject.AddPair('error', aErrorStr);
        end
        else
        begin
          aResultObject.AddPair('error', 'INTERNAL ERROR');
        end;
        result := TJsonObject.ParseJSONValue('{"value":' + aResultObject.ToJson
          + '}') as TJsonObject;
      end;
    end;
  finally
    Log.WriteToLog(aCompName, aFirma, '<TEF> bookARoomBill Out JSON: ' + result.ToString);
    FreeAndNil(aDM);
  end;
end;

end.
