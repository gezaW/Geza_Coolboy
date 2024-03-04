unit DMFiskaltrust;

interface

uses
  Windows, SysUtils, Classes, DB,
  fiskaltrust, DelphiZXingQRCode, graphics, jpeg,
  XSBuiltIns,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  ActiveX,  // used for CoInitialize
  Soap.InvokeRegistry, Soap.Rio, Soap.SOAPHTTPClient,
  REST.Client, IPPeerClient, Data.Bind.Components, Data.Bind.ObjectScope, // 04.03.2019 KL:#21800
  System.JSON, REST.Json,
  Data.DBXJSONReflect;

const
  // timeouts on sending requests to fiskaltrust service
  C_TIMEOUT_ECHO               = 1000;   // Test Erreichbarkeit: 1 sec
  C_TIMEOUT_NULL               = 30000;  // Nullbelege (Start, End, Monat, Jahr): 30 sec
  C_TIMEOUT_JOURNAL            = 60000;  // Journal (DEP-Export): 60 sec
  C_TIMEOUT_RECEIPT            = 10000;  // Rechnung fiskalisieren: 10 sec
  C_TIMEOUT_FAILURE            = 2000;   // nach Ausfall der SSCD verkürzen auf: 2 sec

  // Das im Portal angelegte PosSystem. Wird zur Identifizierung des
  // Softwaretypes und der Softwareversion verwendet. Wird auch im
  // Abnahmeprozess dokumentiert und dient als Grundlage der Servicegebührberechnung.
  C_POSSYSTEMID = '745be035-a5c0-e511-80ff-3863bb348bb0';

  // Ländercode  ("OR"-Verknüpfung!)
  C_COUNTRY_CODE = $4154000000000000; // AT ... Österreich

  // Rechnungs-Fälle
  C_RECEIPT_CASE_DEFAULT = $0000000000000000; // unbekannt
  C_RECEIPT_CASE_CASH = $0000000000000001; // Bar-Beleg / Kreditkarte
  C_RECEIPT_CASE_NULL = $0000000000000002; // Null-Beleg (charge/pay leer)
  C_RECEIPT_CASE_START = $0000000000000003; // Inbetriebnahme-Beleg
  C_RECEIPT_CASE_END = $0000000000000004; // Außerbetriebnahme-Beleg
  C_RECEIPT_CASE_MONTH = $0000000000000005; // Monats-Beleg
  C_RECEIPT_CASE_YEAR = $0000000000000006; // Jahres-Beleg
  C_RECEIPT_CASE_CASH_IN = $000000000000000A; // Bar-Einzahlung (Kundenkarte)
  C_RECEIPT_CASE_CASH_OUT = $000000000000000B; // Bar-Auszahlung (Lieferanten)
  C_RECEIPT_CASE_CASH_TRANSFER = $000000000000000C; // Zahlungsmittel-Transfer (Zahlwegänderung)
  C_RECEIPT_CASE_CASH_WEBP = $000000000000000E; // Werbung, Eigenverbrauch, Bruch

  // zusätzl.  "OR"-Verknüpfungen
  C_RECEIPT_CASE_SUBSEQUENT = $0000000000010000; // Ausfall-Nacherfassung (siehe auch BELEG-ANFRAGE)
  C_RECEIPT_CASE_TRAINING = $0000000000020000; // Trainings-Beleg (funktioniert nie in Sandbox)
  C_RECEIPT_CASE_REVERSAL = $0000000000040000; // Storno-Beleg
  C_RECEIPT_CASE_HANDWRITTEN = $0000000000080000; // handschriftl. Beleg
  C_RECEIPT_CASE_SMALL_BUSINESSMAN = $0000000000100000; // Kleinunternehmer, USt-Befreiung
  C_RECEIPT_CASE_BUSINESSMAN = $0000000000200000; // Empfänger ist Unternehmer
  C_RECEIPT_CASE_PAR_11_USTG = $0000000000400000; // Enthält Merkmale nach § 11 UStG

  // BELEG-ANFRAGE!
  C_RECEIPT_CASE_EVIDENCE_REQUEST = $0000800000000000; // Beleganfrage (für Nacherfassung)

  // Leistungen
  C_CHARGEITEM_CASE_DEFAULT = $0000000000000000; // unbekannt
  C_CHARGEITEM_CASE_REDUCED1 = $0000000000000001; // Ermäßigt-1 ... 10%
  C_CHARGEITEM_CASE_REDUCED2 = $0000000000000002; // Ermäßigt-2 ... 13%
  C_CHARGEITEM_CASE_NORMAL = $0000000000000003; // Normal ....... 20%
  C_CHARGEITEM_CASE_SPECIAL = $0000000000000004; // undefinierte ... 12%, 19%
  C_CHARGEITEM_CASE_ZERO = $0000000000000005; // Null .........  0%
  C_CHARGEITEM_CASE_NONE = $0000000000000007;
  // kein eigener Umsatz (Wert-Gutschein)

  // Zahlungen
  C_PAYITEM_CASE_DEFAULT = $0000000000000000; // unbekannt
  C_PAYITEM_CASE_CASH = $0000000000000001; // Barzahlung in Landeswährung
  C_PAYITEM_CASE_FOREIGN = $0000000000000002; // Barzahlung in Fremdwährung
  C_PAYITEM_CASE_CASHMACHINE = $0000000000000004; // Bankomatzahlung
  C_PAYITEM_CASE_CREDITCARD = $0000000000000005; // Kreditkartenzahlung
  C_PAYITEM_CASE_VOUCHER = $0000000000000006; // Gutscheinzahlung (Wertgutschein)
  C_PAYITEM_CASE_DEBITOR = $000000000000000B; // Debitor
  C_PAYITEM_CASE_TIP = $0000000000000012; // Retourgeld / Trinkgeld

  // Signatur
  C_SIGNATURE_FORMAT_DEFAULT = $0000000000000000; // unbekannt
  C_SIGNATURE_FORMAT_TEXT = $0000000000000001; // Text
  C_SIGNATURE_FORMAT_LINK = $0000000000000002; // Link
  C_SIGNATURE_FORMAT_QRCODE = $0000000000000003; // QR-Code
  C_SIGNATURE_FORMAT_BARCODE = $0000000000000004; // Barcode Code 128

  // Signatur-Typ
  C_SIGNATURE_TYPE_DEFAULT = $0000000000000000; // unbekannt
  C_SIGNATURE_TYPE_RKSV = $0000000000000001; // Signatur nach RKSV
  C_SIGNATURE_TYPE_FINON = $0000000000000003; // FinanzOnline Meldung

  // Belegantwort Status  "OR"-Verknüpfungen
  C_STATE_OK = $0000000000000000; // alles OK
  C_STATE_OUTOFSERVICE = $0000000000000001; // Außerbetrieb genommen
  C_STATE_TEMPORARY = $0000000000000002; // SSCD temporär ausgefallen
  C_STATE_PERMANENT = $0000000000000004; // SSCD permanent ausgefallen
  C_STATE_POSTGATHERING = $0000000000000008; // Nacherfassung aktiv
  C_STATE_MONTH = $0000000000000010; // Monatsbericht fällig
  C_STATE_YEAR = $0000000000000020; // Jahresbericht fällig
  C_STATE_MESSAGE = $0000000000000040; // Nachricht anstehend

type
  TDataFiskaltrust = class(TDataModule)
    QueryReceipt: TFDQuery;
    QueryChargeItems: TFDQuery;
    QueryPayItems: TFDQuery;
    QueryInsertReceipt: TFDQuery;
    QueryInsertChargeItems: TFDQuery;
    QueryInsertPayItems: TFDQuery;
    QueryInsertSignatureItems: TFDQuery;
    QueryInsertReceiptHeaders: TFDQuery;
    QueryInsertChargeLines: TFDQuery;
    QueryInsertPayLines: TFDQuery;
    QueryInsertReceiptFooters: TFDQuery;
    QueryGetQRCode: TFDQuery;
    QuerySetQRCodeFile: TFDQuery;
    QueryUpdateReceipt: TFDQuery;
    QueryDailyClosing: TFDQuery;
    QueryReprintReceipt: TFDQuery;
    QueryFooters: TFDQuery;
    QueryReprintNull: TFDQuery;
    QueryNewMonth: TFDQuery;
    QuerySubsequent: TFDQuery;
    QuerySubChargeItems: TFDQuery;
    QuerySubPayItems: TFDQuery;
    HTTPRIOFiskaltrust: THTTPRIO;
    QueryGetFTFirmenname: TFDQuery;
    QueryGetFTReceiptData: TFDQuery;
    RestClientFiskaltrust: TRESTClient;
    RestRequestFiskaltrust: TRESTRequest;
    RestResponseFiskaltrust: TRESTResponse;
    procedure DataModuleCreate(Sender: TObject);
    procedure HTTPRIOFiskaltrustBeforeExecute(const MethodName: string;
      SOAPRequest: TStream);
    procedure DataModuleDestroy(Sender: TObject);

  private
    // 19.09.2016 KL: #13579: Fiskaltrust als eigenes Modul
    FFiskaltrust: Boolean;
    FFiskaltrustURL: string;
    FCashboxID: string;
    FAccessToken: string;
    FLastResponse: TDateTime;
    FFiskaltrustStartID: Integer;

    FQRCode: TDelphiZXingQRCode;
    FQRCodeBitmap: TBitmap;
    FQRCodeJpeg: TJPEGImage;

    FResponseState: int64;

    function Actual(const pInt64: int64): integer;
    function SaveFiskaltrustRequest(PReceiptRequest: ReceiptRequest2;
      PID: integer): integer;
    function SaveFiskaltrustResponse(pReceiptResponse: ReceiptResponse2;
      PID: integer): integer;
    procedure SaveFiskaltrustError(PID: integer);
    function GetNewFTID: integer;
    procedure SetInternetTimeouts(PTimeout: integer);
    function GetFiskaltrust: Boolean;
    function GetTempDirectory: string;
    procedure QRCodeToFile(pFilename, pQRCode: String);
    function getFiskaltrustStarted: Boolean;
    function CheckFiskaltrustEnding: Boolean;
    function SendSubsequent(pEvidence: boolean = FALSE): integer;
    function GetFTStartDate: TDateTime;
    function RoundX(const Value: Extended; const nk: Integer): Extended;
    function RoundUp(X: Extended): Extended;
    function GetUseRest: Boolean;
    { Private-Deklarationen }
  public
    function XSDateTime(): TXSDateTime; overload;
    function XSDateTime(const value: TDateTime): TXSDateTime; overload;
    function XSDecimal(const pFloat: Double; const pDecimals: Byte = 2): TXSDecimal;
    function XSFloat(const pXSDecimal: TXSDecimal; const pDecimals: Byte = 2): Double;

    procedure SetFiskalSQLtoFelix;
    { Public-Deklarationen }
    function Echo(): boolean; overload;
    function Echo(var oMessage: string): boolean; overload;
    function SendNull(const pReceiptCase: int64): integer;
    function SerializeReceiptRequest(pReceiptRequest: ReceiptRequest2): string;
    function ParseReceiptResponse(pJson: string): ReceiptResponse2;
    function GetIDforReprintNull(const PReceiptCase: int64): integer;
    function SignReceipt(const PID: integer; const PReceiptCase: int64): integer;
    function GetIDforReprintReceipt(const pReceiptID: integer): integer;
    function ChangeToArchiv(pString: String; pArchiv: Boolean): String;

    function DoNullAtEndofOfMonth(pDay: TDateTime): int64;
    function DoNullAtFirstLoginOfMonth(pDailyClosingTime: TDateTime): int64;
    function CheckFiskaltrustSubsequent: Boolean;
    function CheckFiskaltrustNull: Boolean;

    function SignAmount(const PAmount: Double; const PDescription: string;
      const PReceiptCase, PChargeItemCase, PPayItemCase: int64)
      : integer; overload;
    function SignAmount(const PAmount: Double; const PDescription: string;
      const PReceiptCase, PChargeItemCase, PPayItemCase: string)
      : integer; overload;

    function ExportJournal(const PJournalType: int64;
      const PStart, PEnd: TDateTime; const PFilePath: string): string;

    procedure Initialize(pFiskaltrust: Boolean;
      pFiskaltrustURL, pCashboxID, pAccessToken: string);
    procedure SetQRCodeFile(const pFiskaltrustID: Integer);
    //Result = FinOn QR Code as just text
    function GetQRCode(const pFiskaltrustID: integer): String;
    function GetQRCodeText(const pFiskaltrustID: integer): String;
    function GetFTReceiptData(const pFiskaltrustID: Integer): String;
    function GetFTFirmenname: String;

    function GetInfoOnReceiptState(const pReceiptState: int64): string;
    function GetInfoOnReceiptCase(const pReceiptCase: int64): string;
    function GetInfoOnPayItemCase(const pPayItemCase: int64): string;

    // #13294: TABS prüfen
    function CheckAllDailyClosingsDone: Boolean;
    // #16460: Errors (in receipt footers) for text printing
    procedure GetFtFooters(const pFiskaltrustID: integer;
      var pStringlist: TStringList);

    property Fiskaltrust: Boolean read GetFiskaltrust;
    property FiskaltrustURL: string read FFiskaltrustURL;
    property UseREST: Boolean read GetUseRest;
    property CashboxID: string read FCashboxID;
    property AccessToken: string read FAccessToken;
    property FiskaltrustStarted: Boolean read getFiskaltrustStarted;
    property FiskaltrustStartID: Integer read FFiskaltrustStartID;
    property FiskaltrustStartDate: TDateTime read GetFTStartDate;
  end;

var
  DataFiskaltrust: TDataFiskaltrust;

implementation

{$R *.dfm}
{$WARN SYMBOL_PLATFORM OFF}

uses
  Dialogs, DMBase, DateUtils, WinInet, Controls, math, IdCoderMIME,
  nxLogging;

function TDataFiskaltrust.RoundUp(X: Extended): Extended;
begin
   Result := Trunc(X) + Trunc (Frac(X) * 2);
end;

function TDataFiskaltrust.RoundX(const Value:Extended; const nk:Integer):Extended;
var
   multi: Extended;
begin
   multi := IntPower(10, nk);
   Result := RoundUp(Value*multi) / multi;
end;


procedure TDataFiskaltrust.SetFiskalSQLtoFelix;
begin
  with DataFiskaltrust.QueryReceipt do
  begin
    SQL.Clear;
    SQL.Add('select Firma as TerminalID,  r.rechnungsnummer as ReceiptReference, r.zahlungsbetrag as ReceiptAmount');
    SQL.Add(', r.Vorauszahlung, r.Nachlass as Discount');
    SQL.Add('from rechnung r where r.id = :pID');
  end;

  with DataFiskaltrust.QueryChargeItems do
  begin
    SQL.Clear;
    SQL.Add('select 1 as CHARGEQUANTITY, RM.BETRAG  as CHARGEAMOUNT, RM.MWST as CHARGEVATRATE,');
    SQL.Add('RM.MWST as CHARGEPRODUCTNUMBER, RM.MWST as CHARGEDESCRIPTION');
    SQL.Add('from RECHNUNGSMWST RM');
    // SQL.Add('left outer join LEISTUNGEN L on L.FIRMA = RK.FIRMA and L.ID = RK.LEISTUNGSID');
    // SQL.Add('left outer join MEHRWERTSTEUER ST on ST.FIRMA = L.FIRMA and ST.ID = L.MWSTID');
    SQL.Add('where RM.RECHNUNGSID = :PID');
    // SQL.Add('select RK.MENGE as CHARGEQUANTITY, RK.GESAMTBETRAG  as CHARGEAMOUNT, ST.MWST as CHARGEVATRATE,');
    /// /    SQL.Add('select RK.MENGE as CHARGEQUANTITY, RK.GESAMTBETRAG / RK.MENGE as CHARGEAMOUNT, ST.MWST as CHARGEVATRATE,');
    // SQL.Add('RK.LEISTUNGSID as CHARGEPRODUCTNUMBER, L.leistungsbezeichnung as CHARGEDESCRIPTION');
    // SQL.Add('from RECHNUNGSKONTO RK');
    // SQL.Add('left outer join LEISTUNGEN L on L.FIRMA = RK.FIRMA and L.ID = RK.LEISTUNGSID');
    // SQL.Add('left outer join MEHRWERTSTEUER ST on ST.FIRMA = L.FIRMA and ST.ID = L.MWSTID');
    // SQL.Add('where RK.RECHNUNGSID = :PID and RK.MENGE <> 0');
  end;
end;

function TDataFiskaltrust.Actual(const pInt64: int64): integer;
var
  i: int64;
begin
  result := 0;
  for i := 1 to 16 do
    if (pInt64 and i) = i then
      if pInt64 and C_RECEIPT_CASE_REVERSAL = C_RECEIPT_CASE_REVERSAL then
        result := 0 - i
      else
        result := i;
end;

function TDataFiskaltrust.ChangeToArchiv(pString: String;
  pArchiv: Boolean): String;
var
  s, aTmp: string;
begin
  s := 'ARCHIV';

  If DataFiskaltrust = nil Then
    DataFiskaltrust := TDataFiskaltrust.Create(nil);

  try
    result := pString;

    aTmp := uppercase(pString);
    if pArchiv then
    begin
      if pos('FROM RECHNUNG ', aTmp) > 0 then
        result := StringReplace(result, 'FROM RECHNUNG ',
          'FROM RECHNUNG' + s + ' ', [rfReplaceAll]);
      if pos('FROM RECHNUNGSKONTO ', aTmp) > 0 then
        result := StringReplace(result, 'FROM RECHNUNGSKONTO ',
          'FROM RECHNUNGSKONTO' + s + ' ', [rfReplaceAll]);
      if pos('FROM RECHNUNGSZAHLWEG ', aTmp) > 0 then
        result := StringReplace(result, 'FROM RECHNUNGSZAHLWEG ',
          'FROM RECHNUNGSZAHLWEG' + s + ' ', [rfReplaceAll]);
      if pos('FROM ARRANGEMENT_STEUER(', aTmp) > 0 then
        result := StringReplace(result, 'FROM ARRANGEMENT_STEUER(',
          'FROM ARRANGEMENT_STEUER_' + s + '(', [rfReplaceAll]);
    end
    else
    begin
      if pos('FROM RECHNUNG' + s + ' ', aTmp) > 0 then
        result := StringReplace(result, 'FROM RECHNUNG' + s + ' ',
          'FROM RECHNUNG ', [rfReplaceAll]);
      if pos('FROM RECHNUNGSKONTO' + s + ' ', aTmp) > 0 then
        result := StringReplace(result, 'FROM RECHNUNGSKONTO' + s + ' ',
          'FROM RECHNUNGSKONTO ', [rfReplaceAll]);
      if pos('FROM RECHNUNGSZAHLWEG' + s + ' ', aTmp) > 0 then
        result := StringReplace(result, 'FROM RECHNUNGSZAHLWEG' + s + ' ',
          'FROM RECHNUNGSZAHLWEG ', [rfReplaceAll]);
      if pos('FROM ARRANGEMENT_STEUER_' + s + '(', aTmp) > 0 then
        result := StringReplace(result, 'FROM ARRANGEMENT_STEUER_' + s + '(',
          'FROM ARRANGEMENT_STEUER(', [rfReplaceAll]);
    end;

  except
    on e: Exception do
    begin
      logger.Error('TDataFiskaltrust.ChangeToArchiv', pString, NXLCAT_NONE, e);
      raise;
    end;
  end;
end;

function TDataFiskaltrust.CheckAllDailyClosingsDone: Boolean;
var
  s: string;
begin
  result := TRUE;

  with QueryDailyClosing do
  begin
    Close;
    Open;
    while not EOF do
    begin
      if (not FieldByName('Datum').IsNull) then
      begin
        s := 'Es müssen zuerst ALLE Tage abgeschlossen sein,' + sLineBreak +
          'bevor mit Fiskaltrust begonnen wird!' + sLineBreak +
          'Wollen Sie trotzdem fortfahren?';
        if (MessageDlg(s, mtCOnfirmation, [mbYes, mbNo, mbAbort], 0) = mrYes)
        then
        begin
          Last; // jump to last record to leave while loop
          logger.info('TDataFiskaltrust.CheckAllDailyClosingsDone',
            'ACHTUNG: Frage "' + StringReplace(s, sLineBreak, ' ',
            [rfReplaceAll]) + '" wurde mit "JA" beantwortet!');
        end
        else
        begin
          result := FALSE;
          Last; // jump to last record to leave while loop
        end;
      end;
      Next;
    end;
  end;
end;

function TDataFiskaltrust.getFiskaltrustStarted: Boolean;
var
  aFiskaltrustEndID: integer;
begin

  FFiskaltrustStartID := DataFiskaltrust.GetIDforReprintNull(C_RECEIPT_CASE_START);
  aFiskaltrustEndID := DataFiskaltrust.GetIDforReprintNull(C_RECEIPT_CASE_END);

  result := (FFiskaltrustStartID > aFiskaltrustEndID);
end;

procedure TDataFiskaltrust.DataModuleCreate(Sender: TObject);
begin
  DBase.SetDefaulftConnection(Self); // fuer D10!

  // 19.09.2016 KL: #13579: Fiskaltrust als eigenes Modul
  FFiskaltrustURL := '';
  FCashboxID := '';
  FAccessToken := '';
  FFiskaltrust := FALSE;
  FLastResponse := now-1;
  getFiskaltrustStarted;

  FQRCode := TDelphiZXingQRCode.Create;
  FQRCodeBitmap := TBitmap.Create;
  FQRCodeJpeg := TJPEGImage.Create;
end;

procedure TDataFiskaltrust.DataModuleDestroy(Sender: TObject);
begin
  freeandnil(FQRCodeJpeg);
  freeandnil(FQRCodeBitmap);
  freeandnil(FQRCode);
end;

procedure TDataFiskaltrust.SetInternetTimeouts(pTimeout: integer);
var
  iTimeOut: Integer;
begin
  try
    iTimeOut := pTimeout;

    // 19.07.2017 KL: #16935 Timeout reduzieren wenn Dienst ausgefallen
    if (iTimeOut = C_TIMEOUT_RECEIPT) then
      if (FResponseState = -1)
      or (FResponseState and C_STATE_TEMPORARY = C_STATE_TEMPORARY)
      or (FResponseState and C_STATE_PERMANENT = C_STATE_PERMANENT) then
        iTimeOut := C_TIMEOUT_FAILURE;

    InternetSetOption(nil, INTERNET_OPTION_CONNECT_TIMEOUT, Pointer(@iTimeOut), SizeOf(iTimeOut));
    InternetSetOption(nil, INTERNET_OPTION_SEND_TIMEOUT,    Pointer(@iTimeOut), SizeOf(iTimeOut));
    InternetSetOption(nil, INTERNET_OPTION_RECEIVE_TIMEOUT, Pointer(@iTimeOut), SizeOf(iTimeOut));
  except on E: Exception do
    logger.Error('TDataFiskaltrust.HTTPRIOBeforeExecute', IntToStr(PTimeout),
        NXLCAT_NONE, e);
  end;
end;

procedure TDataFiskaltrust.HTTPRIOFiskaltrustBeforeExecute(
  const MethodName: string; SOAPRequest: TStream);
var
  sl: TStringList;
  i: Integer;
begin
  SOAPRequest.Position := 0;
  sl := TStringList.Create;
  try
    sl.LoadFromStream(SOAPRequest);
    for i := 0 to sl.Count-1 do
      DBase.WriteToLog('Fiskaltrust.'+MethodName+':'+sl[i], DBase.IsDebug);
  finally
    FreeAndNil(sl);
  end;
end;

procedure TDataFiskaltrust.Initialize(pFiskaltrust: Boolean;
      pFiskaltrustURL, pCashboxID, pAccessToken: string);
begin
  FFiskaltrust := pFiskaltrust; // from Wibu/Codemeter
  FFiskaltrustURL := Trim(pFiskaltrustURL);
  if copy(FFiskaltrustURL,length(FFiskaltrustURL),1)<>'/' then
    FFiskaltrustURL := FFiskaltrustURL + '/';
  FCashboxID := Trim(pCashboxID);
  FAccessToken := Trim(pAccessToken);
  // #21800: set properties for REST client
  RestClientFiskaltrust.BaseURL := FFiskaltrustURL;
  with RestRequestFiskaltrust do
  begin
    Params[Params.IndexOf('cashboxid')].Value := FCashboxID;
    Params[Params.IndexOf('accesstoken')].Value := FAccessToken;
  end;
end;

function TDataFiskaltrust.Echo(): Boolean;
begin
  Result := TRUE;

  // prüfen, ob Fiskaltrust aktiviert ist
  if NOT FFiskaltrust then
    Exit;

  Result := FALSE;
  try
    // Request abschicken und Response empfangen
    try
      // siehe https://msdn.microsoft.com/en-us/library/windows/desktop/ms680112(v=vs.85).aspx
      CoInitialize(nil);
      SetInternetTimeouts(C_TIMEOUT_ECHO);

      if UseREST then // #####################
      begin           // ##    R  E  S T    ##
        // #21800: KL // #####################
        RestRequestFiskaltrust.Resource := 'json/echo';
        RestRequestFiskaltrust.Params[RestRequestFiskaltrust.Params.IndexOf('body')].Value := '"ping"';
        RestRequestFiskaltrust.Execute;

        if RestResponseFiskaltrust.Content <> '' then
        begin
          logger.info('TDataFiskaltrust.Echo.Response:'+RestResponseFiskaltrust.Content);
          Result := (RestResponseFiskaltrust.Content = '"ping"');
        end;
      end
      else // HTTPRIO - S O A P
      begin
        Result := (GetIPOS(FALSE, FFiskalTrustURL, HTTPRIOFiskaltrust).Echo('ping') = 'ping');
      end;

      FLastResponse := now;
    except on E: Exception do
      begin
        if dbase.IsDebug then
          ShowMessage(e.message);
        logger.Error('TDataFiskaltrust.Echo', 'Error', NXLCAT_NONE, e);
      end;
    end;
  finally
    CoUninitialize;
  end;
end;

function TDataFiskaltrust.Echo(var oMessage: string): Boolean;
begin
  oMessage := 'Fiskaltrust-';
  if UseREST then
    oMessage := oMessage + 'Signature-Cloud'
  else
    oMessage := oMessage + 'Dienst';
  Result := Echo();
  if Result then
    oMessage := oMessage + ' ist erreichbar.'
  else
    oMessage := oMessage + ' ist   N I C H T   erreichbar!';
  oMessage := oMessage + slinebreak + slinebreak + DataFiskaltrust.FiskaltrustURL;
end;

function TDataFiskaltrust.ExportJournal(const pJournalType: Int64; const pStart, pEnd: TDateTime; const pFilePath: string): string;

  function GetTicks(pDate: TDateTime): int64;
  var
    aDays: integer;
    aTicks: Extended;
  begin
    { Taken from the official msdn website:
      The value of this property represents the number of 100-nanosecond intervals
      that have elapsed since 12:00:00 midnight, January 1, 0001 }
    aDays := DaysBetween(pDate, EncodeDateTime(0001, 01, 01, 0, 0, 0, 0));
    aTicks := aDays * 864000000000; // =24*60*60*1000*1000*1000/100;
    result := trunc(aTicks);
  end;

var
  aDialog: TFileOpenDialog;
  aFilePath: string;
  aMemoryStream: TMemoryStream;
  aStreamBody: StreamBody;
  aStart, aEnd: int64;
  i, x: integer;
  aMessage, s: string;

begin
  Result := '';
  // prüfen, ob Fiskaltrust aktiviert ist
  if NOT FFiskaltrust then
    Exit;

  aFilePath := trim(pFilePath);
  if aFilePath = '' then
  try
    aDialog := TFileOpenDialog.Create(self);
    aDialog.DefaultFolder := ExtractFilePath(paramstr(0));
    aDialog.Options := [fdoPickFolders, fdoPathMustExist, fdoForceFileSystem];
    if aDialog.Execute then
      aFilePath := ExtractFilePath(aDialog.FileName+'\x.txt')
    else
      aFilePath := ExtractFilePath(paramstr(0));
  finally
    aDialog.Free;
  end;

  if LastDelimiter('\', aFilePath) <> length(aFilePath) then
    aFilePath := aFilePath + '\';

  // full file name
  aFilePath := aFilePath +'FT_DEP_' +
    FormatDateTime('yyyy.mm.dd', pStart) + '_' +
    FormatDateTime('yyyy.mm.dd', pEnd) + '.json';

  try
    try // STREAM komplett in RAM empfangen
      aMemoryStream := TMemoryStream.Create;

      // Datum als "Ticks" (1 Tick = 100 Nano-Sekunden) übergeben
      aStart := GetTicks(pStart);
      aEnd := GetTicks(pEnd);

      // siehe https://msdn.microsoft.com/en-us/library/windows/desktop/ms680112(v=vs.85).aspx
      CoInitialize(nil);
      SetInternetTimeouts(C_TIMEOUT_JOURNAL);
      if UseREST then // #####################
      begin           // ##    R  E  S T    ##
        // #21800: KL // #####################
        s := format('type=%d&from=%d&to=%d', [C_COUNTRY_CODE + pJournalType, aStart, aEnd]);
        RestRequestFiskaltrust.Resource := 'json/journal?'+s;
        RestRequestFiskaltrust.Params[RestRequestFiskaltrust.Params.IndexOf('body')].Value := '';
        logger.info('TDataFiskaltrust.ExportJournal.Request:'+s);
        RestRequestFiskaltrust.Execute;
        // write to memory byte for byte (fast)
        x := pos('{', RestResponseFiskaltrust.Content);
        if not (x in [0,1]) then
          x := 0;
        for i := x to RestResponseFiskaltrust.ContentLength-1 do
          aMemoryStream.WriteBuffer(RestResponseFiskaltrust.Content[i], Sizeof(byte));
      end
      else // HTTPRIO - S O A P
      begin
        aStreamBody := GetIPOS(FALSE, FFiskalTrustURL,
          HTTPRIOFiskaltrust).Journal(C_COUNTRY_CODE + pJournalType, aStart, aEnd);
        // write to memory byte for byte (fast)
        for i := 0 to High(aStreamBody) do
          aMemoryStream.WriteBuffer(aStreamBody[i], Sizeof(byte));
      end;

      FLastResponse := now;
      aMessage := 'Fiskaltrust DEP empfangen, Bytes: ' + IntToStr(aMemoryStream.Size);
      DBase.WriteToLog(aMessage, true);

      // write to file (slow, normally its an USB-stick, but from stream to stream)
      aMemoryStream.Position := 0;
      aMemoryStream.SaveToFile(aFilePath);
      Result := aFilePath;

      aMessage := 'Fiskaltrust DEP exportiert nach' +sLineBreak +Result;
      DBase.WriteToLog(aMessage, true);

    except on E: Exception do
      begin
        aMessage := 'Error in Fiskaltrust.ExportJournal: '+inttostr(pJournalType) + sLineBreak
                  + 'von '+FormatDateTime('yyyy.mm.dd', pStart)
                  +' bis '+FormatDateTime('yyyy.mm.dd', pEnd) + sLineBreak
                  + e.Message;
        DBase.WriteToLog(aMessage, true);
      end;
    end;
  finally
    CoUninitialize;
    aMemoryStream.Free;
  end;

end;


function TDataFiskaltrust.GetInfoOnReceiptState(const pReceiptState: Int64): string;
var
  aState: Int64;
  aResult: string;
begin
  Result := '';

  if pReceiptState >= C_COUNTRY_CODE then
    aState := pReceiptState - C_COUNTRY_CODE
  else
    aState := pReceiptState;

  if aState <> C_STATE_OK then
  begin
    aResult := '';
    if aState AND C_STATE_OUTOFSERVICE = C_STATE_OUTOFSERVICE then
      aResult := aResult + 'SSCD außer Betrieb' + sLineBreak;
    if aState AND C_STATE_TEMPORARY = C_STATE_TEMPORARY then
      aResult := aResult + 'SSCD temporär ausgefallen' + sLineBreak;
    if aState AND C_STATE_PERMANENT = C_STATE_PERMANENT then
      aResult := aResult + 'SSCD permanent ausgefallen' + sLineBreak;
    if aState AND C_STATE_POSTGATHERING = C_STATE_POSTGATHERING then
      aResult := aResult + 'Nacherfassung aktiv, Nullbeleg anfordern' + sLineBreak;
    if aState AND C_STATE_MONTH = C_STATE_MONTH then
      aResult := aResult + 'Monatsbericht fällig' + sLineBreak;
    if aState AND C_STATE_YEAR = C_STATE_YEAR then
      aResult := aResult + 'Jahresbericht fällig' + sLineBreak;
    if aState AND C_STATE_MESSAGE = C_STATE_MESSAGE then
      aResult := aResult + 'Nachricht anstehend, Nullbeleg anfordern' + sLineBreak;

    Result := Trim(aResult);
  end;
end;

function TDataFiskaltrust.GetFiskaltrust: Boolean;
begin
  result := FFiskaltrust
       and (FCashboxID <> '')
       and (FFiskaltrustURL <> '');
       // AccessToken wird nur bei Signaturecloud benötigt
end;

function TDataFiskaltrust.SignAmount(const PAmount: Double;
  const PDescription: string; const PReceiptCase, PChargeItemCase,
  PPayItemCase: string): integer;

  function hex(pHex: string): int64;
  begin
    if frac(length(Trim(pHex)) / 2) = 0 then
      result := StrToInt64('$' + Trim(pHex))
    else
      result := StrToInt64('$0' + Trim(pHex));
  end;

begin
  result := SignAmount(PAmount, PDescription, hex(PReceiptCase),
    hex(PChargeItemCase), hex(PPayItemCase));
end;

function TDataFiskaltrust.SignAmount(const PAmount: Double;
  const PDescription: string; const PReceiptCase, PChargeItemCase,
  PPayItemCase: int64): integer;
var
  aReceiptRequest: ReceiptRequest2;
  aReceiptResponse: ReceiptResponse2;
  aChargeItems: ArrayOfChargeItem;
  aPayItems: ArrayOfPayItem;
  aMessage: string;
  aLastFTID: integer;
  s: string;
begin
  result := 0;

  // prüfen, ob Fiskaltrust aktiviert ist
  if NOT FFiskaltrust then
    Exit;

  // Anfrage- und Antwort-Objekte erzeugen
  aReceiptRequest := ReceiptRequest2.Create;
  aReceiptResponse := nil;

  // siehe https://msdn.microsoft.com/en-us/library/windows/desktop/ms680112(v=vs.85).aspx
  CoInitialize(nil);
  try
    aReceiptRequest.ftReceiptCase := C_COUNTRY_CODE + PReceiptCase;

    // Rechnungsdaten
    aReceiptRequest.ftPosSystemId := C_POSSYSTEMID;
    aReceiptRequest.ftCashBoxID := FCashboxID;
    aReceiptRequest.cbTerminalID := '';
    aReceiptRequest.cbReceiptReference := '';
    aReceiptRequest.cbReceiptMoment := XSDateTime;
    aReceiptRequest.cbReceiptAmount := XSDecimal(PAmount);

    // Leistung
    SetLength(aChargeItems, 1);
    aChargeItems[0] := ChargeItem.Create;
    aChargeItems[0].Quantity := XSDecimal(1.0);
    aChargeItems[0].Description := Trim(PDescription);
    aChargeItems[0].Amount := XSDecimal(PAmount);
    aChargeItems[0].VATRate := XSDecimal(0.0);
    aChargeItems[0].ftChargeItemCase := C_COUNTRY_CODE + PChargeItemCase;
    aReceiptRequest.cbChargeItems := aChargeItems;

    // Zahlweg
    SetLength(aPayItems, 1);
    aPayItems[0] := PayItem.Create;
    aPayItems[0].Quantity := XSDecimal(1.0);
    aPayItems[0].Description := Trim(PDescription);
    aPayItems[0].Amount := XSDecimal(PAmount);
    aPayItems[0].ftPayItemCase := C_COUNTRY_CODE + PPayItemCase;
    aReceiptRequest.cbPayItems := aPayItems;

    aLastFTID := -1;
    // Request abschicken und Response empfangen
    try
      aLastFTID := SaveFiskaltrustRequest(aReceiptRequest, -1);
      result := aLastFTID;

      SetInternetTimeouts(C_TIMEOUT_RECEIPT);
      if UseREST then // #####################
      begin           // ##    R  E  S T    ##
        // #21800: KL // #####################
        s := SerializeReceiptRequest(aReceiptRequest);
        RestRequestFiskaltrust.Resource := 'json/sign';
        RestRequestFiskaltrust.Params[RestRequestFiskaltrust.Params.IndexOf('body')].Value := s;
        logger.info('TDataFiskaltrust.SignAmount.Request:'+s);
        RestRequestFiskaltrust.Execute;

        s := RestResponseFiskaltrust.JSONValue.ToString;
        logger.info('TDataFiskaltrust.SignAmount.Response:'+s);
        aReceiptResponse := ParseReceiptResponse(s);
      end
      else // HTTPRIO - S O A P
        aReceiptResponse := GetIPOS(FALSE, FFiskaltrustURL, HTTPRIOFiskaltrust).Sign(aReceiptRequest);

      SaveFiskaltrustResponse(aReceiptResponse, aLastFTID);

    except
      on e: Exception do
      begin
        if aLastFTID <> 0 then
          SaveFiskaltrustError(aLastFTID);

        aMessage := 'FTID: ' + IntToStr(aLastFTID) + ' Betrag: ' +
          FloatToStr(PAmount) + ' ReceiptCase: ' +
          IntToStr(aReceiptRequest.ftReceiptCase) + ' ChargeItemCase: ' +
          IntToStr(aReceiptRequest.cbChargeItems[0].ftChargeItemCase) +
          ' PayItemCase: ' + IntToStr(aReceiptRequest.cbPayItems[0]
          .ftPayItemCase);
        logger.Error('TDataFiskaltrust.SignAmount', aMessage, NXLCAT_NONE, e);
      end;
    end;

  finally
    CoUninitialize;
    // Objekte wieder zerstören
    if Assigned(aReceiptResponse) then
      FreeAndNil(aReceiptResponse);
    SetLength(aPayItems, 0);
    SetLength(aChargeItems, 0);
    try
      FreeAndNil(aReceiptRequest);
    except
    end;
  end;

end;

function TDataFiskaltrust.SignReceipt(const PID: integer; const PReceiptCase: int64): integer;
var
  aReceiptRequest: ReceiptRequest2;
  aReceiptResponse: ReceiptResponse2;
  aChargeItems: ArrayOfChargeItem;
  aPayItems: ArrayOfPayItem;
  aMessage: string;
  aLastFTID: integer;
  s: string;
  aCoefficient: Double;
  i, x: integer;
  arrVatRate, arrVatAmount: array[1..10] of Double;
  arrCase: array[1..10] of int64;

  procedure clearVat;
  var ii: integer;
  begin
    if aCoefficient <> 0 then
      for ii := low(arrVatRate) to High(arrVatRate) do
      begin
        arrVatRate[ii] := 0;
        arrVatAmount[ii] := 0;
        arrCase[ii] := 0;
      end;
  end;


  procedure addVat(pRate, pAmount: TXSDecimal; pCase: int64);
  var
    ii: integer;
    aRate, aAmount: double;
  begin
    if aCoefficient <> 0 then
    begin
      aRate := XSFloat(pRate, 3);
      aAmount := XSFloat(pAmount, 3);
      if (aRate <> 0) and  (aAmount <> 0) then
        for ii := Low(arrVatRate) to High(arrVatRate) do
          if (arrVatRate[ii] = aRate) then
          begin
            arrVatAmount[ii] := arrVatAmount[ii] + aAmount;
            break;
          end
          else
          if (arrVatRate[ii] = 0) and (arrVatAmount[ii] = 0) then
          begin
            arrVatRate[ii] := aRate;
            arrVatAmount[ii] := aAmount;
            arrCase[ii] := pCase;
            break;
          end;
    end;
  end;

begin
  result := 0;

  if (NOT FFiskaltrust) // prüfen, ob Fiskaltrust aktiviert ist
    or (PID < 1) then // Rechnungs-ID muss positive Zahl sein
    Exit;

  // Anfrage- und Antwort-Objekte erzeugen
  aReceiptRequest := ReceiptRequest2.Create;
  aReceiptResponse := nil;
  CoInitialize(nil);
  try
    // receipt data
    with QueryReceipt do
    begin
      Close;
      ParamByName('pID').AsInteger := PID;
      Open;
      if EOF then
        Exit;

      aReceiptRequest.ftReceiptCase := C_COUNTRY_CODE + PReceiptCase;

      aReceiptRequest.ftPosSystemId := C_POSSYSTEMID;
      aReceiptRequest.ftCashBoxID := FCashboxID;
      aReceiptRequest.cbTerminalID :=
        IntToStr(FieldByName('TerminalID').AsInteger);
      aReceiptRequest.cbReceiptReference :=
        IntToStr(FieldByName('ReceiptReference').AsInteger);
      aReceiptRequest.cbReceiptMoment := XSDateTime;
      // bei Storno den Betrag umkehren (=Reaktivieren einer Rechnung)
      // und previousReceiptID angeben  (=ID der Ursprungsrechnung)
      if aReceiptRequest.ftReceiptCase and C_RECEIPT_CASE_REVERSAL = C_RECEIPT_CASE_REVERSAL
      then
      begin
        aReceiptRequest.cbReceiptAmount := XSDecimal(FieldByName('ReceiptAmount').AsCurrency * -1);
        // 27.10.2016 KL: #13295: ursprüngl. Rechnungs-ID bei Reaktivierung angeben
        aReceiptRequest.cbPreviousReceiptReference := IntToStr(PID);
      end
      else
      begin
        aReceiptRequest.cbReceiptAmount := XSDecimal(FieldByName('ReceiptAmount').AsCurrency);
      end;

      // 10.04.2019 KL: #22398 Nachlass-Koeffizienten berechnen
      if FieldByName('ReceiptAmount').AsCurrency = 0 then
        aCoefficient := 1
      else
        aCoefficient := FieldByName('Discount').AsCurrency
          / (FieldByName('Discount').AsCurrency + FieldByName('ReceiptAmount').AsCurrency);
    end;

    clearVat;
    // add charged items
    with QueryChargeItems do
    begin
      Close;
      ParamByName('pID').AsInteger := PID;
      Open;

      SetLength(aChargeItems, RecordCount);
      while NOT EOF do
      begin
        x := recno - 1;
        aChargeItems[x] := ChargeItem.Create;
        aChargeItems[x].Quantity := XSDecimal(FieldByName('ChargeQuantity').AsCurrency, 3);
        aChargeItems[x].Description := FieldByName('ChargeDescription').AsString;
        // bei Storno den Betrag umkehren
        if aReceiptRequest.ftReceiptCase and C_RECEIPT_CASE_REVERSAL = C_RECEIPT_CASE_REVERSAL
        then
          aChargeItems[x].Amount := XSDecimal(FieldByName('ChargeAmount').AsCurrency * -1)
        else
          aChargeItems[x].Amount := XSDecimal(FieldByName('ChargeAmount').AsCurrency);
        aChargeItems[x].VATRate := XSDecimal(FieldByName('ChargeVATRate').AsCurrency);
        // 27.02.2017 KL: #15659: ChargeItemCases nicht auf DEFAULT senden
        if FieldByName('ChargeItemCase').IsNull then
          aChargeItems[x].ftChargeItemCase := C_COUNTRY_CODE + C_CHARGEITEM_CASE_DEFAULT
        else
          aChargeItems[x].ftChargeItemCase := C_COUNTRY_CODE + FieldByName('ChargeItemCase').AsInteger;
        aChargeItems[x].ProductNumber := IntToStr(FieldByName('ChargeProductNumber').AsInteger);
        addVat(aChargeItems[x].VATRate, aChargeItems[x].Amount, aChargeItems[x].ftChargeItemCase);
        Next;
      end;

      // 10.04.2019 KL: #22398 Nachlass
      if aCoefficient <> 0 then
        for i := Low(arrVatRate) to High(arrVatRate) do
          if (arrVatRate[i] <> 0) and (arrVatAmount[i] <> 0) then
          begin
            x := length(aChargeItems);
            SetLength(aChargeItems, x + 1);
            aChargeItems[x] := ChargeItem.Create;
            aChargeItems[x].Quantity := XSDecimal(1);
            aChargeItems[x].Description := format('Nachlass %.2f%% MWSt', [arrVatRate[i]]);
            aChargeItems[x].Amount := XSDecimal(arrVatAmount[i] * aCoefficient * -1);
            aChargeItems[x].VATRate := XSDecimal(arrVatRate[i]);
            aChargeItems[x].ftChargeItemCase := arrCase[i];
            aChargeItems[x].ProductNumber := '';
          end
          else
          if (arrVatRate[i] = 0) and (arrVatAmount[i] = 0) then
            break;

      // Array zuweisen
      aReceiptRequest.cbChargeItems := aChargeItems;
    end;

    // Zahlwege hinzufügen
    with QueryPayItems do
    begin
      Close;
      ParamByName('pID').AsInteger := PID;
      Open;
      Last;
      First;

      SetLength(aPayItems, RecordCount);
      while NOT EOF do
      begin
        aPayItems[recno - 1] := PayItem.Create;
        aPayItems[recno - 1].Quantity :=
          XSDecimal(FieldByName('PayQuantity').AsCurrency, 3);
        aPayItems[recno - 1].Description := FieldByName('PayDescription')
          .AsString;

        // bei Storno den Betrag umkehren
        if aReceiptRequest.ftReceiptCase and C_RECEIPT_CASE_REVERSAL = C_RECEIPT_CASE_REVERSAL
        then
          aPayItems[recno - 1].Amount :=
            XSDecimal(FieldByName('PayAmount').AsCurrency * -1)
        else
          aPayItems[recno - 1].Amount :=
            XSDecimal(FieldByName('PayAmount').AsCurrency);

        // 09.01.2017 KL: #15039: Art des Zahlweges
        aPayItems[recno - 1].ftPayItemCase := C_COUNTRY_CODE +
          FieldByName('PayItemCase').AsInteger;
        Next;
      end;

      // Array zuweisen
      aReceiptRequest.cbPayItems := aPayItems;
    end;

    aLastFTID := -1;
    // Request abschicken und Response empfangen
    try
      // siehe https://msdn.microsoft.com/en-us/library/windows/desktop/ms680112(v=vs.85).aspx

      aLastFTID := SaveFiskaltrustRequest(aReceiptRequest, PID);
      result := aLastFTID;

      SetInternetTimeouts(C_TIMEOUT_RECEIPT);
      if UseREST then // #####################
      begin           // ##    R  E  S T    ##
        // #21800: KL // #####################
        s := SerializeReceiptRequest(aReceiptRequest);
        RestRequestFiskaltrust.Resource := 'json/sign';
        RestRequestFiskaltrust.Params[RestRequestFiskaltrust.Params.IndexOf('body')].Value := s;
        logger.info('TDataFiskaltrust.SignReceipt.Request:'+s);
        RestRequestFiskaltrust.Execute;
        s := ''; // reset string

        if (RestResponseFiskaltrust <> nil) then
          s := RestResponseFiskaltrust.Content;
        logger.info('TDataFiskaltrust.SignReceipt.Response:'+s);
        aReceiptResponse := ParseReceiptResponse(s);
      end
      else // HTTPRIO - S O A P
        aReceiptResponse := GetIPOS(FALSE, FFiskaltrustURL, HTTPRIOFiskaltrust).Sign(aReceiptRequest);

      SaveFiskaltrustResponse(aReceiptResponse, aLastFTID);

    except
      on e: Exception do
      begin
        if aLastFTID <> 0 then
          SaveFiskaltrustError(aLastFTID);

        aMessage := 'FTID: ' + IntToStr(aLastFTID);
        // Rechnungsfall anzeigen
        if aReceiptRequest.ftReceiptCase and C_RECEIPT_CASE_REVERSAL = C_RECEIPT_CASE_REVERSAL
        then
          aMessage := aMessage + ' Rechnungsfall: Stornierung ' +
            IntToStr(aReceiptRequest.ftReceiptCase)
        else
          aMessage := aMessage + ' Rechnungsfall: Bezahlung ' +
            IntToStr(aReceiptRequest.ftReceiptCase);
        logger.Error('TDataFiskaltrust.SignReceipt', aMessage, NXLCAT_NONE, e);
      end;
    end;

  finally
    CoUninitialize;
    // Objekte wieder zerstören
    if Assigned(aReceiptResponse) then
      FreeAndNil(aReceiptResponse);
    SetLength(aPayItems, 0);
    SetLength(aChargeItems, 0);
    try
      FreeAndNil(aReceiptRequest);
    except
    end;
  end;

end;

function TDataFiskaltrust.SaveFiskaltrustResponse(pReceiptResponse
  : ReceiptResponse2; PID: integer): integer;
var
  i: integer;
  aState: int64;
  aError: string;
begin
  FLastResponse := now;

  result := 0;
  // Übergabeparameter prüfen
  if (pReceiptResponse = nil) or (PID = 0) then
    Exit;

  try
    // ftReceipt
    with QueryUpdateReceipt do
    begin
      ParamByName('ID').AsInteger := PID;
      ParamByName('CASHBOXID').AsString := pReceiptResponse.ftCashBoxID;
      ParamByName('TERMINALID').AsString := pReceiptResponse.cbTerminalID;
      ParamByName('RECEIPTREFERENCE').AsString :=
        pReceiptResponse.cbReceiptReference;
      // Wichtig bei Nacherfassung: Zeitpunkt der Rechnung!
      ParamByName('RECEIPTMOMENT').AsDateTime :=
        pReceiptResponse.ftReceiptMoment.AsDateTime;
      ParamByName('STATE').AsString := IntToStr(pReceiptResponse.ftState);
      // 20.02.2017 KL: #15659: identifications müssen am Beleg stehen
      ParamByName('RECEIPTIDENTIFICATION').AsString :=
        pReceiptResponse.ftReceiptIdentification;
      ParamByName('CASHBOXIDENTIFICATION').AsString :=
        pReceiptResponse.ftCashBoxIdentification;

      Execute;
    end;

    // Fehlermeldungen, die am Beleg VOR den Leistungen gedruckt werden müssen
    // ftReceiptHeader [] ... je 4096
    for i := 0 to high(pReceiptResponse.ftReceiptHeader) do
      with QueryInsertReceiptHeaders do
      begin
        ParamByName('FT_RECEIPT_ID').AsInteger := PID;
        ParamByName('TEXT').AsString := pReceiptResponse.ftReceiptHeader[i];
        Execute;
      end;

    // das sind nicht die ursprüngl. Leistungen aus dem Response,
    // sondern Fehlermeldungen, die am Beleg zu den Leistungen gedruckt werden müssen
    // ftChargeItems [] Menge, Preis, Summe = 0
    for i := 0 to high(pReceiptResponse.ftChargeItems) do
      with QueryInsertChargeItems do
      begin
        ParamByName('FT_RECEIPT_ID').AsInteger := PID;
        ParamByName('QUANTITY').AsCurrency :=
          XSFloat(pReceiptResponse.ftChargeItems[i].Quantity, 3);
        ParamByName('DESCRIPTION').AsString := pReceiptResponse.ftChargeItems[i]
          .Description;
        ParamByName('AMOUNT').AsCurrency :=
          XSFloat(pReceiptResponse.ftChargeItems[i].Amount);
        ParamByName('VATRATE').AsCurrency :=
          XSFloat(pReceiptResponse.ftChargeItems[i].VATRate);
        ParamByName('CHARGEITEMCASE').AsString :=
          IntToStr(pReceiptResponse.ftChargeItems[i].ftChargeItemCase);
        ParamByName('PRODUCTNUMBER').AsString := pReceiptResponse.ftChargeItems
          [i].ProductNumber;
        ParamByName('STATUS').AsInteger := 1; // marker for response
        Execute;
      end;

    // Fehlermeldungen, die am Beleg NACH den Leistungen gedruckt werden müssen
    // ftChargeLines [] ... je 4096
    for i := 0 to high(pReceiptResponse.ftChargeLines) do
      with QueryInsertChargeLines do
      begin
        ParamByName('FT_RECEIPT_ID').AsInteger := PID;
        ParamByName('TEXT').AsString := pReceiptResponse.ftChargeLines[i];
        Execute;
      end;

    // das sind nicht die ursprüngl. Zahlwege aus dem Response,
    // sondern Fehlermeldungen, die am Beleg zu den Zahlwegen gedruckt werden müssen
    // ftPayItems [] Betrag, Summe = 0
    for i := 0 to high(pReceiptResponse.ftPayItems) do
      with QueryInsertPayItems do
      begin
        ParamByName('FT_RECEIPT_ID').AsInteger := PID;
        ParamByName('QUANTITY').AsCurrency :=
          XSFloat(pReceiptResponse.ftPayItems[i].Quantity, 3);
        ParamByName('DESCRIPTION').AsString := pReceiptResponse.ftPayItems[i]
          .Description;
        ParamByName('AMOUNT').AsCurrency :=
          XSFloat(pReceiptResponse.ftPayItems[i].Amount);
        ParamByName('PAYITEMCASE').AsString :=
          IntToStr(pReceiptResponse.ftPayItems[i].ftPayItemCase);
        ParamByName('STATUS').AsInteger := 1; // marker for response
        Execute;
      end;

    // Fehlermeldungen, die am Beleg NACH den Zahlwegen gedruckt werden müssen
    // ftPayLines [] ... je 4096
    for i := 0 to high(pReceiptResponse.ftPayLines) do
      with QueryInsertPayLines do
      begin
        ParamByName('FT_RECEIPT_ID').AsInteger := PID;
        ParamByName('TEXT').AsString := pReceiptResponse.ftPayLines[i];
        Execute;
      end;

    // ftSignatures []
    for i := 0 to high(pReceiptResponse.ftSignatures) do
      with QueryInsertSignatureItems do
      begin
        ParamByName('FT_RECEIPT_ID').AsInteger := PID;
        ParamByName('SIGNATUREFORMAT').AsString :=
          IntToStr(pReceiptResponse.ftSignatures[i].ftSignatureFormat);
        ParamByName('SIGNATURETYPE').AsString :=
          IntToStr(pReceiptResponse.ftSignatures[i].ftSignatureType);
        ParamByName('CAPTION').AsString := pReceiptResponse.ftSignatures
          [i].Caption;
        ParamByName('DATA').AsString := pReceiptResponse.ftSignatures[i].Data;
        Execute;
      end;

    // Response-State speichern
    if pReceiptResponse.ftState >= C_COUNTRY_CODE then
      aState := pReceiptResponse.ftState - C_COUNTRY_CODE
    else
      aState := pReceiptResponse.ftState;

    // 24.04.2017 KL: #16488 Response-State merken
    FResponseState := aState;

    if aState = C_STATE_OK then
      result := PID
    else
    begin
      aError := GetInfoOnReceiptState(aState);
      if aError <> '' then
      with QueryInsertReceiptFooters do
      begin
        ParamByName('FT_RECEIPT_ID').AsInteger := PID;
        ParamByName('TEXT').AsString := aError + '!';
        Execute;
        logger.info('TDataFiskaltrust.ReceiptState', aError);
      end;
    end;

    // ftReceiptFooter [] ... je 4096
    for i := 0 to high(pReceiptResponse.ftReceiptFooter) do
      with QueryInsertReceiptFooters do
      begin
        ParamByName('FT_RECEIPT_ID').AsInteger := PID;
        ParamByName('TEXT').AsString := pReceiptResponse.ftReceiptFooter[i];
        Execute;
      end;

  except
    on e: Exception do
    begin
      logger.Error('TDataFiskaltrust', 'SaveFiskaltrustResponse',
        NXLCAT_NONE, e);
      if not DBase.IsServer then
        ShowMessage(e.Message);
      raise Exception.Create('TDataFiskaltrust: SaveFiskaltrustResponse: ' + E.Message);
    end;
  end;
end;

procedure TDataFiskaltrust.SaveFiskaltrustError(PID: integer);
begin
  // save "no reponse" for trying null receipts
  FResponseState := -1;

  // Übergabeparameter prüfen
  if (PID = 0) then
    Exit;

  try
    // ftReceiptFooter
    with QueryInsertReceiptFooters do
    begin
      ParamByName('FT_RECEIPT_ID').AsInteger := PID;
      ParamByName('TEXT').AsString :=
        'Sicherheitseinrichtung ausgefallen! (Dienst)';
      Execute;
    end;
  except
    on e: Exception do
    begin
      logger.Error('TDataFiskaltrust', 'SaveFiskaltrustError', NXLCAT_NONE, e);
      if not DBase.isServer then
        ShowMessage(e.Message);
    end;
  end;
end;

function TDataFiskaltrust.SaveFiskaltrustRequest(PReceiptRequest
  : ReceiptRequest2; PID: integer): integer;
var
  i: integer;

begin
  result := 0;
  // Übergabeparameter prüfen
  if (PReceiptRequest = nil) or (PID = 0) then
    Exit;

  // neue Fiskaltrust_Receipt_ID vom Generator holen
  result := GetNewFTID;

  try
    // ftReceipt
    with QueryInsertReceipt do
    begin
      ParamByName('ID').AsInteger := result;
      ParamByName('CASHBOXID').AsString := PReceiptRequest.ftCashBoxID;
      ParamByName('RECEIPTID').AsInteger := PID;
      case PID of
        - 1:
          ParamByName('RECEIPTREFERENCE').AsString := 'Nullbeleg';
        -2:
          ParamByName('RECEIPTREFERENCE').AsString := 'Journal';
      else
        ParamByName('RECEIPTREFERENCE').AsString :=
          PReceiptRequest.cbReceiptReference;
      end; { end of case }
      // Wichtig bei Nacherfassung: Zeitpunkt der Rechnung!
      ParamByName('RECEIPTMOMENT').AsDateTime :=
        PReceiptRequest.cbReceiptMoment.AsUTCDateTime;
      ParamByName('TERMINALID').AsString := PReceiptRequest.cbTerminalID;
      ParamByName('STATE').AsString := 'Request saved';
      ParamByName('RECEIPTCASE').AsString :=
        IntToStr(PReceiptRequest.ftReceiptCase);
      ParamByName('RECEIPTCASEACTUAL').AsInteger :=
        Actual(PReceiptRequest.ftReceiptCase);
      ParamByName('RECEIPTAMOUNT').AsCurrency :=
        XSFloat(PReceiptRequest.cbReceiptAmount);
      if Trim(PReceiptRequest.cbPreviousReceiptReference) = '' then
        ParamByName('PREVIOUSID').Clear
      else
        ParamByName('PREVIOUSID').AsInteger :=
          strtointdef(PReceiptRequest.cbPreviousReceiptReference, 0);
      Execute;
    end;

    // cbChargeItems [] Menge, Preis, Artikel, Steuer
    for i := 0 to high(PReceiptRequest.cbChargeItems) do
      with QueryInsertChargeItems do
      begin
        ParamByName('FT_RECEIPT_ID').AsInteger := result;
        ParamByName('QUANTITY').AsCurrency :=
          XSFloat(PReceiptRequest.cbChargeItems[i].Quantity, 3);
        ParamByName('DESCRIPTION').AsString := PReceiptRequest.cbChargeItems[i]
          .Description;
        ParamByName('AMOUNT').AsCurrency :=
          XSFloat(PReceiptRequest.cbChargeItems[i].Amount);
        ParamByName('VATRATE').AsCurrency :=
          XSFloat(PReceiptRequest.cbChargeItems[i].VATRate);
        ParamByName('CHARGEITEMCASE').AsString :=
          IntToStr(PReceiptRequest.cbChargeItems[i].ftChargeItemCase);
        ParamByName('PRODUCTNUMBER').AsString := PReceiptRequest.cbChargeItems
          [i].ProductNumber;
        ParamByName('STATUS').AsInteger := 0; // marker for request
        Execute;
      end;

    // cbPayItems [] Menge, Betrag, Zahlweg
    for i := 0 to high(PReceiptRequest.cbPayItems) do
      with QueryInsertPayItems do
      begin
        ParamByName('FT_RECEIPT_ID').AsInteger := result;
        ParamByName('QUANTITY').AsCurrency :=
          XSFloat(PReceiptRequest.cbPayItems[i].Quantity, 3);
        ParamByName('DESCRIPTION').AsString := PReceiptRequest.cbPayItems[i]
          .Description;
        ParamByName('AMOUNT').AsCurrency :=
          XSFloat(PReceiptRequest.cbPayItems[i].Amount);
        ParamByName('PAYITEMCASE').AsString :=
          IntToStr(PReceiptRequest.cbPayItems[i].ftPayItemCase);
        ParamByName('STATUS').AsInteger := 0; // marker for request
        Execute;
      end;

  except
    on e: Exception do
    begin
      logger.Error('TDataFiskaltrust', 'SaveFiskaltrustRequest',
        NXLCAT_NONE, e);
      if not DBase.isServer then
        ShowMessage(e.Message);
      raise Exception.Create('TDataFiskaltrust: SaveFiskaltrustRequest: ' + E.Message);
    end;
  end;
end;

function TDataFiskaltrust.GetIDforReprintReceipt(const pReceiptID
  : integer): integer;
begin
  result := 0;

  if (NOT FFiskaltrust) // prüfen, ob Fiskaltrust aktiviert ist
    or (pReceiptID < 1) then // Rechnungs-ID muss positive Zahl sein
    Exit;

  try
    with QueryReprintReceipt do
    begin
      Close;
      ParamByName('pRECEIPTID').AsString := IntToStr(pReceiptID);
      ParamByName('pSTATE').AsString := IntToStr(C_COUNTRY_CODE);
      Open;
      if NOT EOF then
        result := FieldByName('ID').AsInteger;
    end;

  except
    on e: Exception do
    begin
      logger.Error('TDataFiskaltrust', 'GetIDforReprintReceipt',
        NXLCAT_NONE, e);
      if not DBase.isServer then
        ShowMessage(e.Message);
      raise Exception.Create('TDataFiskaltrust: GetIDforReprintReceipt: ' + E.Message);
    end;
  end;

end;

function TDataFiskaltrust.GetInfoOnReceiptCase(const pReceiptCase: int64): string;
var
  aCase: Int64;
  aResult: string;
begin
  Result := '';

  if pReceiptCase >= C_COUNTRY_CODE then
    aCase := pReceiptCase - C_COUNTRY_CODE
  else
    aCase := pReceiptCase;

  if aCase <> C_RECEIPT_CASE_DEFAULT then
  begin
    aResult := '';
    if aCase AND C_RECEIPT_CASE_CASH = C_RECEIPT_CASE_CASH then
      aResult := aResult + 'Barumsatz' + sLineBreak;
    if aCase AND C_RECEIPT_CASE_NULL = C_RECEIPT_CASE_NULL then
      aResult := aResult + 'Nullbeleg' + sLineBreak;
    if aCase AND C_RECEIPT_CASE_START = C_RECEIPT_CASE_START then
      aResult := aResult + 'Inbetriebnahme-Beleg' + sLineBreak;
    if aCase AND C_RECEIPT_CASE_END = C_RECEIPT_CASE_END then
      aResult := aResult + 'Außerbetriebnahme-Beleg' + sLineBreak;
    if aCase AND C_RECEIPT_CASE_MONTH = C_RECEIPT_CASE_MONTH then
      aResult := aResult + 'Monats-Beleg' + sLineBreak;
    if aCase AND C_RECEIPT_CASE_YEAR = C_RECEIPT_CASE_YEAR then
      aResult := aResult + 'Jahres-Beleg' + sLineBreak;
    if aCase AND C_RECEIPT_CASE_SUBSEQUENT = C_RECEIPT_CASE_SUBSEQUENT then
      aResult := aResult + 'Nacherfassung' + sLineBreak;
    if aCase AND C_RECEIPT_CASE_REVERSAL = C_RECEIPT_CASE_REVERSAL then
      aResult := aResult + 'Stornobeleg' + sLineBreak;
    if aCase AND C_RECEIPT_CASE_HANDWRITTEN = C_RECEIPT_CASE_HANDWRITTEN then
      aResult := aResult + 'Handschriftbeleg-Nacherfassung' + sLineBreak;
    if aCase AND C_RECEIPT_CASE_SMALL_BUSINESSMAN = C_RECEIPT_CASE_SMALL_BUSINESSMAN then
      aResult := aResult + 'Kleinunternehmer, USt-Befreiung' + sLineBreak;
    if aCase AND C_RECEIPT_CASE_BUSINESSMAN = C_RECEIPT_CASE_BUSINESSMAN then
      aResult := aResult + 'Empfänger ist Unternehmer' + sLineBreak;
    if aCase AND C_RECEIPT_CASE_PAR_11_USTG = C_RECEIPT_CASE_PAR_11_USTG then
      aResult := aResult + 'Enthält Merkmale nach § 11 UStG' + sLineBreak;
    if aCase AND C_RECEIPT_CASE_EVIDENCE_REQUEST = C_RECEIPT_CASE_EVIDENCE_REQUEST then
      aResult := aResult + 'Beleganfrage (für Nacherfassung)' + sLineBreak;

    Result := Trim(aResult);
  end;
end;

function TDataFiskaltrust.GetInfoOnPayItemCase(const pPayItemCase: int64): string;
var
  aCase: Int64;
begin
  Result := '';

  if pPayItemCase >= C_COUNTRY_CODE then
    aCase := pPayItemCase - C_COUNTRY_CODE
  else
    aCase := pPayItemCase;

  if aCase <> C_PAYITEM_CASE_DEFAULT then
  begin
    case aCase of
      C_PAYITEM_CASE_CASH:        Result := 'Barzahlung in Landeswährung';
      C_PAYITEM_CASE_FOREIGN:     Result := 'Barzahlung in Fremdwährung';
      C_PAYITEM_CASE_CASHMACHINE: Result := 'Bankomatzahlung';
      C_PAYITEM_CASE_CREDITCARD:  Result := 'Kreditkartenzahlung';
      C_PAYITEM_CASE_VOUCHER:     Result := 'Gutscheinzahlung';
      C_PAYITEM_CASE_DEBITOR:     Result := 'Debitor';
      C_PAYITEM_CASE_TIP:         Result := 'Trinkgeld';
    end;
  end;
end;

procedure TDataFiskaltrust.GetFtFooters(const pFiskaltrustID: integer;
  var pStringlist: TStringList);
begin
  if pStringlist = nil then
    pStringlist := TStringList.Create;
  pStringlist.Clear;
  try
    with QueryFooters do
    begin
      Close;
      ParamByName('pFT_RECEIPT_ID').AsInteger := pFiskaltrustID;
      Open;
      while not EOF do
      begin
        pStringlist.Add(FieldByName('TEXT').AsString);
        Next;
      end;
      Close;
    end;
  except
    on e: Exception do
      logger.Error('TDataFiskaltrust', 'GetFtFooters', NXLCAT_NONE, e);
  end;
end;

function TDataFiskaltrust.GetIDforReprintNull(const PReceiptCase
  : int64): integer;
begin
  result := 0;

  if (PReceiptCase <= 0) then
    Exit;

  try
    with QueryReprintNull do
    begin
      Close;
      ParamByName('pReceiptcaseActual').AsInteger := Actual(PReceiptCase);
      ParamByName('pSTATE').AsString := IntToStr(C_COUNTRY_CODE);
      Open;
      if NOT EOF then
        result := FieldByName('ID').AsInteger;
    end;

  except
    on e: Exception do
    begin
      logger.Error('TDataFiskaltrust.GetIDforReprintNull',
        IntToStr(PReceiptCase), NXLCAT_NONE, e);
      if not DBase.isServer then
        ShowMessage(e.Message);
      raise Exception.Create('TDataFiskaltrust: GetIDforReprintNull: ' + E.Message);
    end;
  end;

end;

function TDataFiskaltrust.DoNullAtEndofOfMonth(pDay: TDateTime): int64;
var
  aNow, aDay: TDateTime;
  aReceiptcase: int64;
begin
  result := 0; // 0 = no new month

  // check start receipt. Without starting, do no monthly closing!
  if NOT FiskaltrustStarted then
    Exit;

  // Monats-/Jahresbeleg wird nur gemacht, wenn's wirklich der LETZTE Tag im Monat ist (pDay!)
  aReceiptcase := 0;
  aNow := now;
  try
    // in January to November check for the last day of THIS month
    aDay := IncDay(IncMonth(EncodeDateTime(YearOf(aNow), MonthOf(aNow), 1, 0, 0, 0, 0), 1), -1);
    if (pDay = aDay) then
      aReceiptcase := C_RECEIPT_CASE_MONTH;
    // in February to December check for the last day of LAST month
    aDay := IncDay(EncodeDateTime(YearOf(aNow), MonthOf(aNow), 1, 0, 0, 0, 0), -1);
    if (pDay = aDay) then
      aReceiptcase := C_RECEIPT_CASE_MONTH;

    // in December check for December 31st THIS year
    aDay := EncodeDateTime(YearOf(aNow), 12, 31, 0, 0, 0, 0);
    if (pDay = aDay) then
      aReceiptcase := C_RECEIPT_CASE_YEAR;
    // in January check for December 31st of LAST year
    aDay := EncodeDateTime(YearOf(aNow)-1, 12, 31, 0, 0, 0, 0);
    if (pDay = aDay) then
      aReceiptcase := C_RECEIPT_CASE_YEAR;

    // do send null receipt
    if aReceiptcase in [C_RECEIPT_CASE_YEAR, C_RECEIPT_CASE_MONTH] then
      if SendNull(aReceiptcase) <> 0 then
        Result := aReceiptcase;
      // don't forget to reprint the yearly closing report!


    // ACHTUNG: was ist mit Kunden, die am letzten Tag des Monats
    // KEINEN Tagesabschluss machen, weil da Ruhetag war?
    // bei denen wird KEIN Monats-/Jahresbeleg erstellt!

    // außer beim KellnerLogin in der Kasse.exe!

  except
    on e: Exception do
      logger.Error('TDataFiskaltrust.DoNullAtEndofOfMonth', DateToStr(pDay),
        NXLCAT_NONE, e);
  end;

end;


{
@ulrich @markus Tagesabschluss.exe:
function TDataFiskaltrust.DoNullAtEndofOfMonth(pDay: TDateTime): int64;

Der automat. Montas-/Jahresbeleg für Fiskaltrust wird beim Tagesabschluss gemacht,
wenn heute der letzte Tags des Monats ist und ich diesen Tag abschließe (zB 31.12.2019).
Oder wenn heute irgend ein Tag ist (zB 07.01.2020) und ich den letzten Tag des Vormonats abschließe (zB 31.12.2019).
Falls der Monatsletzte gar nicht abzuschließen ist, weil da z.B. Ruhetag oder generell geschlossen war,
wird in der Tagesabschluss.exe KEIN Monats-/Jahresbeleg erstellt,
sondern nur beim Kellnerlogin in der Kasse.

KellnerLogin in der Kasse.exe:
function TDataFiskaltrust.DoNullAtFirstLoginOfMonth(pDailyClosingTime
  : TDateTime): int64;

Hier habe ich eine Möglichkeit gefunden, in der KEIN Monats-/Jahresbeleg erstellt wird und zwar,
wenn bereits eine Rechnung im neuen Monat signiert (oder gespeichert) wurde.
Und das kommt wahrscheinlich oft vor, weil die Funktion nur jede Stunde aufgerufen wird.
}

function TDataFiskaltrust.DoNullAtFirstLoginOfMonth(pDailyClosingTime
  : TDateTime): int64;
var
  aNow, aFirstDay, aLastDay: TDateTime;
begin
  result := 0;

  // check start receipt. Without starting, do no monthly closing!
  if NOT FiskaltrustStarted then
    Exit;

  aNow := Now;
  try
    with QueryNewMonth do  // Vorschlag KURT: hier nicht den letzten Record suchen sondern den letzten Monats-/Jahresbeleg
    begin
      Close;
      Open;
      if NOT FieldByName('ReceiptMoment').IsNull then
      begin
        // first Timestamp of month (1st day of month is always 1)
        aFirstDay := EncodeDateTime(YearOf(aNow), MonthOf(aNow), 1,
          HourOf(pDailyClosingTime), MinuteOf(pDailyClosingTime),
          SecondOf(pDailyClosingTime), 0);
        if aNow > aFirstDay then
        begin
          aLastDay := FieldByName('ReceiptMoment').AsDateTime;
          if aLastDay < aFirstDay then
          begin
            if MonthOf(aLastDay) > MonthOf(aFirstDay) then
            begin
              if SendNull(C_RECEIPT_CASE_YEAR) <> 0 then
                result := C_RECEIPT_CASE_YEAR;
              // don't forget to reprint the yearly closing report!
            end
            else
            begin
              if SendNull(C_RECEIPT_CASE_MONTH) <> 0 then
                result := C_RECEIPT_CASE_MONTH;
              // don't forget to reprint the yearly closing report!
            end;
          end;
        end;
      end;
    end;

  except
    on e: Exception do
      logger.Error('TDataFiskaltrust.DoNullAtFirstDayOfMonth',
        TimeToStr(pDailyClosingTime), NXLCAT_NONE, e);
  end;
end;

function TDataFiskaltrust.GetNewFTID: integer;
begin
  result := 0;
  try
    result := DBase.SetGeneratorID('GEN_FT_RECEIPT_ID');
  except
    on e: Exception do
      logger.Error('TDataFiskaltrust', 'GetNewFTID', NXLCAT_NONE, e);
  end;
end;

function TDataFiskaltrust.GetQRCode(const pFiskaltrustID: integer): String;
begin
  result := '';
  try
    with QueryGetQRCode do
    begin
      Close;
      ParamByName('pFT_RECEIPT_ID').AsInteger := pFiskaltrustID;
      Open;
      if not EOF then
        result := FieldByName('DATA').AsString;
      Close;
    end;
  except
    on e: Exception do
      logger.Error('TDataFiskaltrust.GetQRCode', IntToStr(pFiskaltrustID),
        NXLCAT_NONE, e);
  end;

end;
function TDataFiskaltrust.GetFTFirmenname: String;
begin
  Result := '';
  try
    with QueryGetFTFirmenname do
    begin
      close;
      ParamByName('pFirma').AsInteger := dbase.Firma;
      ParamByName('pKasse').AsInteger := dbase.KasseID;
      open;
      if not eof then
        Result := FieldByName('fiskaltrustfirmenname').AsString;
      close;
    end;
  except on E: Exception do
    DBase.WriteToLog('Error in DataFiskaltrust.GetFTFirmenname: '+e.Message, true);
  end;

end;

function TDataFiskaltrust.GetFTReceiptData(const pFiskaltrustID: Integer): String;
begin
  Result := '';
  try
    with QueryGetFTReceiptData do
    begin
      close;
      ParamByName('pFTReceiptID').AsInteger := pFiskaltrustID;
      open;
      if not eof then
        Result := 'Datum: '+FormatDateTime('dd.mm.yyyy', FieldByName('Receiptmoment').AsDateTime)
               + ' Uhrzeit: '+FormatDateTime('hh:nn:ss', FieldByName('Receiptmoment').AsDateTime);
    end;
  except on E: Exception do
    DBase.WriteToLog('Error in DataFiskaltrust.GetFTReceiptData: '+e.Message, true);
  end;

end;

function TDataFiskaltrust.GetFTStartDate: TDateTime;
begin
  Result := strtodatetime('30.12.1899');
  if FiskaltrustStarted then
    if GetFTReceiptData(FiskaltrustStartID) <> '' then
      Result := strtodatetime(FormatDateTime(
        'dd.mm.yyyy', QueryGetFTReceiptData.FieldByName('Receiptmoment').AsDateTime));
end;

function TDataFiskaltrust.GetQRCodeText(const pFiskaltrustID: Integer): String;

  function Base32Encode(data: TBytes): string;
  const
    Alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567';
  var
    dataLength, i, length5, tempInt: Integer;
    tempResult: string;
    x1, x2: Byte;
  begin
    if ((data = Nil) or (Length(data) = 0)) then
    begin
      result := ('');
      Exit;
    end;

    dataLength := Length(data);
    length5 := (dataLength div 5) * 5;
    i := 0;
    while i < length5 do
    begin
      x1 := data[i];
      tempResult := tempResult + (Alphabet[(x1 shr 3) + 1]);
      x2 := data[i + 1];
      tempResult := tempResult + (Alphabet[(((x1 shl 2) and $1C) or (x2 shr 6)) + 1]);
      tempResult := tempResult + (Alphabet[((x2 shr 1) and $1F) + 1]);
      x1 := data[i + 2];
      tempResult := tempResult + (Alphabet[(((x2 shl 4) and $10) or (x1 shr 4)) + 1]);
      x2 := data[i + 3];
      tempResult := tempResult + (Alphabet[(((x1 shl 1) and $1E) or (x2 shr 7)) + 1]);
      tempResult := tempResult + (Alphabet[((x2 shr 2) and $1F) + 1]);
      x1 := data[i + 4];
      tempResult := tempResult + (Alphabet[(((x2 shl 3) and $18) or (x1 shr 5)) + 1]);
      tempResult := tempResult + (Alphabet[(x1 and $1F) + 1]);
      Inc(i, 5);
    end;

    tempInt := dataLength - length5;

    Case tempInt of
      1:begin
          x1 := data[i];
          tempResult := tempResult + (Alphabet[(x1 shr 3) + 1]);
          tempResult := tempResult + (Alphabet[((x1 shl 2) and $1C) + 1]);
          tempResult := tempResult + '======';
        end;
      2:begin
          x1 := data[i];
          tempResult := tempResult + (Alphabet[(x1 shr 3) + 1]);
          x2 := data[i + 1];
          tempResult := tempResult + (Alphabet[(((x1 shl 2) and $1C) or (x2 shr 6)) + 1]);
          tempResult := tempResult + (Alphabet[((x2 shr 1) and $1F) + 1]);
          tempResult := tempResult + (Alphabet[((x2 shl 4) and $10) + 1]);
          tempResult := tempResult + '====';
        end;
      3:begin
          x1 := data[i];
          tempResult := tempResult + (Alphabet[(x1 shr 3) + 1]);
          x2 := data[i + 1];
          tempResult := tempResult + (Alphabet[(((x1 shl 2) and $1C) or (x2 shr 6)) + 1]);
          tempResult := tempResult + (Alphabet[((x2 shr 1) and $1F) + 1]);
          x1 := data[i + 2];
          tempResult := tempResult + (Alphabet[(((x2 shl 4) and $10) or (x1 shr 4)) + 1]);
          tempResult := tempResult + (Alphabet[((x1 shl 1) and $1E) + 1]);
          tempResult := tempResult + '===';
        end;
      4:begin
          x1 := data[i];
          tempResult := tempResult + (Alphabet[(x1 shr 3) + 1]);
          x2 := data[i + 1];
          tempResult := tempResult + (Alphabet[(((x1 shl 2) and $1C) or (x2 shr 6)) + 1]);
          tempResult := tempResult + (Alphabet[((x2 shr 1) and $1F) + 1]);
          x1 := data[i + 2];
          tempResult := tempResult + (Alphabet[(((x2 shl 4) and $10) or (x1 shr 4)) + 1]);
          x2 := data[i + 3];
          tempResult := tempResult + (Alphabet[(((x1 shl 1) and $1E) or (x2 shr 7)) + 1]);
          tempResult := tempResult + (Alphabet[((x2 shr 2) and $1F) + 1]);
          tempResult := tempResult + (Alphabet[((x2 shl 3) and $18) + 1]);
          tempResult := tempResult + '=';
        end;
    end;

    result := tempResult;
  end;

  function Base64To32(pInput: string): string;
  var
    aDecoder: TIdDecoderMIME;
    aDecoded: string;
    aBytes: TBytes;
  begin
    Result := '';

    // decode base 64 to string
    aDecoded := '';
    aDecoder := TIdDecoderMIME.Create(nil);
    try
      aDecoded := aDecoder.DecodeString(pInput);
    finally
      FreeAndNil(aDecoder);
    end;

    // encode string to base 32
    if aDecoded <> '' then
    begin
      aBytes := TBytes(aDecoded);
      Result := Base32Encode(aBytes);
    end;
  end;


var
  aQRCode: string;
  sl: TStringList;
begin
  Result := '';
  try
    aQRCode := GetQRCode(pFiskaltrustID);
    if aQRCode <> '' then
    begin
      sl := TStringList.Create;
      try
        sl.Delimiter := '_';
        sl.DelimitedText := aQRCode;
//        sl.DelimitedText := 'Zum Testen: Bsp. aus Fiskaltrust-Schnittstellenbeschreibung'+
//          '_R1-AT0'+
//          '_DEMO-CASH-BOX426'+
//          '_776730'+
//          '_2015-10-14T18:20:23'+
//          '_0,00'+
//          '_0,00'+
//          '_0,00'+
//          '_0,00'+
//          '_0,00'+
//          '_0gJTFI8/zqc='+
//          '_968935007593160625'+
//          '_fP7/PMPSnQ0='+
//          '_Xh5wNe0akaTOVvMgLVrCcRh2xmIyP91ogbxc5xv4Rrw64lpQsqLm+1GZxuCz4D1sZl9WCv3wMMoE0p+gyLaufg==';
        if sl.Count=14 then
        begin
//          sl[0] := Base64To32(sl[0]);
          sl[10] := Base64To32(sl[10]);
          sl[12] := Base64To32(sl[12]);
          sl[13] := Base64To32(sl[13]);
        end;
        Result := sl.DelimitedText;
      finally
        sl.Destroy;
      end;
    end;

  except on E: Exception do
    DBase.WriteToLog('Error in DataFiskaltrust.GetQRCodeText: '+e.Message, true);
  end;
end;

function TDataFiskaltrust.GetTempDirectory: string;
// http://www.delphi-treff.de/tipps/dateienverzeichnisse/verzeichnisse/temporaeres-verzeichnis-ermitteln/
  function GetTempDir: string;
  var
    aBuffer: array [0 .. MAX_PATH] of Char;
  begin
    GetTempPath(MAX_PATH, aBuffer);
    result := StrPas(aBuffer);
  end;

var
  aTempPath: string;
begin
  // 25.02.2013 KL: Temp-Folder
  aTempPath := GetTempDir;
  if DirectoryExists(aTempPath) then
    result := aTempPath
  else
    result := '';
end;

function TDataFiskaltrust.GetUseRest: Boolean;
begin
  result := (pos('https://', FFiskaltrustURL) > 0)
        and (pos('.fiskaltrust.at/', FFiskaltrustURL) > 0);
end;

procedure TDataFiskaltrust.QRCodeToFile(pFilename, pQRCode: String);
var
  aRow, aColumn: integer;
begin
  try
    FQRCode.Data := pQRCode;
    FQRCode.Encoding := TQRCodeEncoding(0);
    FQRCode.QuietZone := 4;
    FQRCodeBitmap.SetSize(FQRCode.Rows, FQRCode.Columns);
    for aRow := 0 to FQRCode.Rows - 1 do
      for aColumn := 0 to FQRCode.Columns - 1 do
        if (FQRCode.IsBlack[aRow, aColumn]) then
          FQRCodeBitmap.Canvas.Pixels[aColumn, aRow] := clBlack
        else
          FQRCodeBitmap.Canvas.Pixels[aColumn, aRow] := clWhite;

    FQRCodeJpeg.Assign(FQRCodeBitmap);
    FQRCodeJpeg.SaveToFile(pFileName);
  except on E: Exception do
    DBase.WriteToLog('Error in DataFiskaltrust.QRCodeToFile: '+e.Message, true);
  end;
end;


procedure TDataFiskaltrust.SetQRCodeFile(const pFiskaltrustID: Integer);
var
  aSignatureID: integer;
  aQRCode, aQRCodeFile: string;

begin
  aSignatureID := 0;
  aQRCode := '';
  aQRCodeFile := '';

  if pFiskaltrustID<>0 then
  try
    with QueryGetQRCode do
    begin
      close;
      ParamByName('pFT_RECEIPT_ID').AsInteger := pFiskaltrustID;
      open;

      if NOT eof then
      begin
        aSignatureID :=FieldByName('ID').AsInteger;
        aQRCode := FieldByName('DATA').AsString;

        // QR-Code als JPEG erstellen im temp. Windows-Ordner
        aQRCodeFile := GetTempDirectory+format('QRCode%d.jpg', [aSignatureID]);
        QRCodeToFile(aQRCodeFile, aQRCode);
      end;
    end;

    with QuerySetQRCodeFile do
    begin
      ParamByName('pID').AsInteger := aSignatureID;
      ParamByName('pQRCODEFILE').AsString := aQRCodeFile;
      execute;
    end;

  except on E: Exception do
    DBase.WriteToLog('Error in DataFiskaltrust.SetQRCodeFile: '+e.Message, true);
  end;

end;

function TDataFiskaltrust.SendNull(const pReceiptCase: int64): Integer;
var
  aReceiptRequest: ReceiptRequest2;
  aReceiptResponse: ReceiptResponse2;
  aMessage: string;
  aReceiptCase: int64;
  aLastFTID: integer;
  s: string;
begin
  Result := 0;
  // prüfen, ob Fiskaltrust aktiviert ist
  if NOT FFiskaltrust then
    Exit;

  // be carefull with "taking out of service"
  if pReceiptCase = C_RECEIPT_CASE_END then
    if NOT CheckFiskaltrustEnding then
      EXIT;

  // 18.04.2017 KL: #16488 wenn etwas nachzuerfassen ist,
  // danach normalen Nullbeleg anfordern
  if  (pReceiptCase = C_RECEIPT_CASE_SUBSEQUENT) then
    if CheckFiskaltrustSubsequent then
      aReceiptCase := C_RECEIPT_CASE_NULL
    else
      EXIT
  else
    aReceiptCase := pReceiptCase;

  // siehe https://msdn.microsoft.com/en-us/library/windows/desktop/ms680112(v=vs.85).aspx
  CoInitialize(nil);

  // Anfrage- und Antwort-Objekte erzeugen
  aReceiptRequest := ReceiptRequest.Create;
  aReceiptResponse := nil;
  try
    aReceiptRequest.ftReceiptCase := C_COUNTRY_CODE + aReceiptCase;

    // Null-Beleg hat keine Leistungen und Zahlwege
    aReceiptRequest.ftPosSystemId := C_POSSYSTEMID;
    aReceiptRequest.ftCashBoxID := FCashBoxID;
    aReceiptRequest.cbTerminalID := '';
    aReceiptRequest.cbReceiptReference := '';
    aReceiptRequest.cbReceiptMoment := XSDateTime;
    aReceiptRequest.cbReceiptAmount := XSDecimal(0.0);

    aLastFTID := -1;
    // Request abschicken und Response empfangen
    try
      aLastFTID := SaveFiskaltrustRequest(aReceiptRequest, -1);
      Result := aLastFTID;

      SetInternetTimeouts(C_TIMEOUT_NULL);
      if UseREST then // #####################
      begin           // ##    R  E  S T    ##
        // #21800: KL // #####################
        s := SerializeReceiptRequest(aReceiptRequest);
        RestRequestFiskaltrust.Resource := 'json/sign';
        RestRequestFiskaltrust.Params[RestRequestFiskaltrust.Params.IndexOf('body')].Value := s;
        logger.info('TDataFiskaltrust.SendNull.Request:'+s);
        RestRequestFiskaltrust.Execute;

        s := RestResponseFiskaltrust.JSONValue.ToString;
        logger.info('TDataFiskaltrust.SendNull.Response:'+s);
        aReceiptResponse := ParseReceiptResponse(s);
      end
      else // HTTPRIO - S O A P
        aReceiptResponse :=  GetIPOS(FALSE, FFiskalTrustURL, HTTPRIOFiskaltrust).Sign(aReceiptRequest);

      SaveFiskaltrustResponse(aReceiptResponse, aLastFTID);

    except on E: Exception do
      begin
        if aLastFTID <> 0 then
          SaveFiskaltrustError(aLastFTID);

        aMessage := 'FTID: ' + IntToStr(aLastFTID) + ', ReceiptCase: '+inttostr(aReceiptCase);
        logger.Error('TDataFiskaltrust.SendNull', aMessage, NXLCAT_NONE, e);
      end;
    end;

  finally
    CoUninitialize;
    // Objekte wieder zerstören
    if Assigned(aReceiptResponse) then
      FreeAndNil(aReceiptResponse);
    try FreeAndNil(aReceiptRequest); except end;
  end;

end;

function TDataFiskaltrust.SendSubsequent(pEvidence: boolean = FALSE): integer;
var
  aReceiptRequest: ReceiptRequest2;
  aReceiptResponse: ReceiptResponse2;
  aChargeItems: ArrayOfChargeItem;
  aPayItems: ArrayOfPayItem;
  aMessage: string;
  aBigInt: int64;
  i: Integer;
  s: string;
begin
  result := -1;

  if QuerySubsequent.eof then
    exit;

  // 24.05.2018 KL: #19891: Beleganfrage an FT-Dienst
  if NOT pEvidence then
  begin
    Result := SendSubsequent(TRUE); // Achtung rekursiver Aufruf!
    if Result <> 0 then // -1...kein Dienst, +1...Beleganfrage OK, 0...Nacherfassung
      exit;
  end;

  // siehe https://msdn.microsoft.com/en-us/library/windows/desktop/ms680112(v=vs.85).aspx
  CoInitialize(nil);

  // Anfrage- und Antwort-Objekte erzeugen
  aReceiptRequest := ReceiptRequest2.Create;
  aReceiptResponse := nil;
  try
    // Rechnungsdaten
    with QuerySubsequent do
    begin
      aBigInt := StrToInt64Def(FieldByName('RECEIPTCASE').AsString, 0);

      // Nacherfassung bzw. Beleganfrage entfernen
      if aBigInt and C_RECEIPT_CASE_EVIDENCE_REQUEST = C_RECEIPT_CASE_EVIDENCE_REQUEST then
        aBigInt := aBigInt - C_RECEIPT_CASE_EVIDENCE_REQUEST;
      if aBigInt and C_RECEIPT_CASE_SUBSEQUENT = C_RECEIPT_CASE_SUBSEQUENT then
        aBigInt := aBigInt - C_RECEIPT_CASE_SUBSEQUENT;

      // entweder Beleganfrage-Flag oder danach Nacherfassungs-Flag
      if pEvidence then // Beleganfrage hinzufügen
        aReceiptRequest.ftReceiptCase := aBigInt + C_RECEIPT_CASE_EVIDENCE_REQUEST
      else              // Nacherfassung hinzufügen
        aReceiptRequest.ftReceiptCase := aBigInt + C_RECEIPT_CASE_SUBSEQUENT;

      aReceiptRequest.ftPosSystemId := C_POSSYSTEMID;
      // 08.09.2017 eventuell sollte man hier nicht die CashboxID aus der Fiskaltrust-Tabelle nehmen,
      // sondern die FCashboxID (aus der EINSTELL), weil eventuell die falsche CashboxID in der Tabelle steht.
      // passierte bei Jufa so nach Außer-/Inbetriebnahme
      aReceiptRequest.ftCashBoxID := FieldByName('CASHBOXID').AsString;
      aReceiptRequest.cbTerminalID := FieldByName('TERMINALID').AsString;
      aReceiptRequest.cbReceiptReference :=
        FieldByName('RECEIPTREFERENCE').AsString;
      aReceiptRequest.cbReceiptMoment :=
        XSDateTime(FieldByName('RECEIPTMOMENT').AsDateTime);
      aReceiptRequest.cbReceiptAmount :=
        XSDecimal(FieldByName('RECEIPTAMOUNT').AsCurrency);
      if aReceiptRequest.ftReceiptCase and C_RECEIPT_CASE_REVERSAL = C_RECEIPT_CASE_REVERSAL
      then
        aReceiptRequest.cbPreviousReceiptReference :=
          IntToStr(FieldByName('PREVIOUSID').AsInteger);
    end;

    // Leistungen hinzufügen
    with QuerySubChargeItems do
    begin
      Close;
      ParamByName('FT_RECEIPT_ID').AsInteger :=
        QuerySubsequent.FieldByName('ID').AsInteger;
      Open;
      Last;
      First;

      SetLength(aChargeItems, RecordCount);
      while NOT EOF do
      begin
        aChargeItems[recno - 1] := ChargeItem.Create;
        aBigInt := StrToInt64Def(FieldByName('CHARGEITEMCASE').AsString, 0);
        aChargeItems[recno - 1].ftChargeItemCase := aBigInt;

        aChargeItems[recno - 1].Quantity :=
          XSDecimal(FieldByName('QUANTITY').AsCurrency);
        aChargeItems[recno - 1].Description :=
          FieldByName('DESCRIPTION').AsString;
        aChargeItems[recno - 1].Amount :=
          XSDecimal(FieldByName('AMOUNT').AsCurrency);
        aChargeItems[recno - 1].VATRate :=
          XSDecimal(FieldByName('VATRATE').AsCurrency);
        aChargeItems[recno - 1].ProductNumber :=
          FieldByName('PRODUCTNUMBER').AsString;
        Next;
      end;

      // Array zuweisen
      aReceiptRequest.cbChargeItems := aChargeItems;
    end;

    // Zahlwege hinzufügen
    with QuerySubPayItems do
    begin
      Close;
      ParamByName('FT_RECEIPT_ID').AsInteger :=
        QuerySubsequent.FieldByName('ID').AsInteger;
      Open;
      Last;
      First;

      SetLength(aPayItems, RecordCount);
      while NOT EOF do
      begin
        aPayItems[recno - 1] := PayItem.Create;
        aBigInt := StrToInt64Def(FieldByName('PAYITEMCASE').AsString, 0);
        aPayItems[recno - 1].ftPayItemCase := aBigInt;

        aPayItems[recno - 1].Quantity :=
          XSDecimal(FieldByName('QUANTITY').AsCurrency, 3);
        aPayItems[recno - 1].Description := FieldByName('DESCRIPTION').AsString;
        aPayItems[recno - 1].Amount := XSDecimal(FieldByName('AMOUNT').AsCurrency);
        Next;
      end;

      // Array zuweisen
      aReceiptRequest.cbPayItems := aPayItems;
    end;

    // Request abschicken und Response empfangen
    try
      SetInternetTimeouts(C_TIMEOUT_RECEIPT);
      if UseREST then // #####################
      begin           // ##    R  E  S T    ##
        // #21800: KL // #####################
        s := SerializeReceiptRequest(aReceiptRequest);
        RestRequestFiskaltrust.Resource := 'json/sign';
        RestRequestFiskaltrust.Params[RestRequestFiskaltrust.Params.IndexOf('body')].Value := s;
        logger.info('TDataFiskaltrust.SendSubsequent.Request:'+s);
        RestRequestFiskaltrust.Execute;

        s := RestResponseFiskaltrust.JSONValue.ToString;
        logger.info('TDataFiskaltrust.SendNull.Response:'+s);
        aReceiptResponse := ParseReceiptResponse(s);
      end
      else // HTTPRIO - S O A P
        aReceiptResponse := GetIPOS(FALSE, FFiskaltrustURL, HTTPRIOFiskaltrust).Sign(aReceiptRequest);
{
Beleganfrage. Es wird versucht mittels dem Feld cbReceiptReference den Beleg im FiskaltrustJournal zu finden.
Wird cbTerminalID angegeben so werden diese auch in die Suche miteinbezogen.
Die Request-Struktur der Charge-Items und Pay-Items muss in Reihenfolge, ChargeItemCase/PayItemCase
und Betrag mit dem ursprünglich angelieferten übereinstimmen um erfolgreich gefunden zu werden.
Ist die Suche erfolgreich wird die Orginal-Antwort nocheinmal zurückgegeben, ansonsten wird Null zurückgegeben.
}
      if pEvidence and (aReceiptResponse = nil) then
        Result := 0 // 0...Dienst erreichbar aber Rechnung NICHT gefunden, also Nacherfassung starten
      else
      begin         // 1...Dienst erreichbar UND Rechnung gefunden, Request speichern, keine Nacherfassung nötig
        SaveFiskaltrustResponse(aReceiptResponse, QuerySubsequent.FieldByName('ID').AsInteger);
        Result := 1;
      end;

    except
      on e: Exception do
      begin
        // don't call "SaveFiskaltrustError"!

        aMessage := 'Error in Fiskaltrust.SendSubsequent: '
          + inttostr(QuerySubsequent.FieldByName('ID').AsInteger) + sLineBreak
          + 'Rechnungsfall: ';
        // Rechnungsfall anzeigen
        if pEvidence then
          aMessage := aMessage + 'Beleganfrage: '
        else
          aMessage := aMessage + 'Nacherfassung: ';
        aMessage := aMessage + inttostr(aReceiptRequest.ftReceiptCase);
        logger.Error('TDataFiskaltrust.SendSubsequent', aMessage,
          NXLCAT_NONE, e);
      end;
    end;

  finally
    CoUninitialize;
    // Objekte wieder zerstören
    try FreeAndNil(aReceiptResponse); except end;
    SetLength(aPayItems, 0);
    SetLength(aChargeItems, 0);
    try FreeAndNil(aReceiptRequest); except end;
  end;

end;

function TDataFiskaltrust.SerializeReceiptRequest(pReceiptRequest: ReceiptRequest2): string;

  function DelStuff(var aObj: TJSONObject): string;
  var
    i, a: integer;
    aItem: TJSONObject;
    aPair: TJSONPair;
    s: string;
  begin
    Result := '';
    i := -1;
    while i < aObj.Count -1 do
    begin
      inc(i);
      if not aObj.Pairs[i].Null then
      begin
        if aObj.Pairs[i].JsonValue is TJSONArray then   // JSON-ARRAY
        begin  // rekursive call !
          for a := 0 to (aObj.Pairs[i].JsonValue as TJSONArray).Count-1 do
          begin
            aItem := (aObj.Pairs[i].JsonValue as TJSONArray).Items[a] as TJSONObject;
            DelStuff(aItem);
          end;
        end
        else
        if aObj.Pairs[i].JsonValue is TJSONObject then  // JSON-SUB-OBJECT
        begin  // rekursive call !
            aItem := aObj.Pairs[i].JsonValue as TJSONObject;
            s := DelStuff(aItem);
            if s > '' then
            begin
              aPair := TJSONPair.Create(aObj.Pairs[i].JsonString.Value, s);
              aObj.RemovePair(aPair.JsonString.value);
              dec(i);
              aObj.AddPair(aPair);
            end;
        end
        else     // JSON-PAIR
        begin
          // remove some unwanted fields
          if aObj.Pairs[i].JsonString.ToString = '"dataContext"' then
          begin
            aObj.RemovePair('dataContext');
            dec(i);
          end
          else // copy some values to parent pair
          if (aObj.Pairs[i].JsonString.ToString = '"dateTime"')
          or (aObj.Pairs[i].JsonString.ToString = '"decimalString"') then
          begin
            Result := aObj.pairs[0].jsonvalue.value;
            aObj.RemovePair(aObj.Pairs[i].JsonString.value);
            dec(i);
          end;
        end;
      end;
    end;
  end;


var
  aJSON: TJSONObject;

begin
  Result := '';
  try
    // some fields are hidden by JSONMarshalledAttributes
    aJSON := REST.json.TJson.ObjectToJsonObject(pReceiptRequest, [joDateFormatISO8601]);
    delStuff(aJson);
    Result := aJson.tostring;
  except
    Result := '';
  end;
end;

function TDataFiskaltrust.ParseReceiptResponse(pJson: string): ReceiptResponse2;
var
  aJson: TJSONObject;
  s: string;
begin
  try
    aJson := TJSONObject.ParseJSONValue(pJson) as TJSONObject;
    s := aJson.GetValue('ftReceiptMoment').Value; // do NOT use .tostring or .tojson!
    aJson.RemovePair('ftReceiptMoment');
    Result := REST.json.TJson.JsonToObject<ReceiptResponse2>(aJson, [joDateIsUTC]);
    Result.ftReceiptMoment := TXSDateTime.Create;
    Result.ftReceiptMoment.XSToNative(s);
  except
    Result := nil;
  end;
end;

function TDataFiskaltrust.CheckFiskaltrustEnding: Boolean;
begin
  result := FALSE;

  // be carefull with "taking out of service"
  If (MessageDlg('Außerbetriebnahme wird NICHT empfohlen,' + sLineBreak
               + 'denn dann muss eine NEUE QUEUE im' + sLineBreak
               + 'Fiskaltrust-Portal erstellt werden!' + sLineBreak
               + 'Wollen Sie die Sicherheitseinrichtung' + sLineBreak
               + 'wirklich AUSSER BETRIEB nehmen?', mtWarning, [mbYes, mbNo, mbAbort], 0) <>
    mrYes) then
    Exit;

  // confirmation by cashbox ID
  if (FCashboxID = '')
  or (Trim(InputBox('Außerbetriebnahme', 'Wie lautet das Passwort?', '')) <> FCashboxID) then
    Exit;

  // last question befor apocalypse
  If (MessageDlg('Wollen Sie die Sicherheitseinrichtung' + sLineBreak +
    'ernsthaft AUSSER BETRIEB nehmen?', mtWarning, [mbYes, mbNo, mbAbort], 0) <>
    mrYes) then
    Exit;

  // do end fiskaltrust after 3 times answering OK
  result := TRUE;
end;

function TDataFiskaltrust.CheckFiskaltrustSubsequent: boolean;
var s: string;
begin
  Result := FALSE;
  // gespeicherte, nicht signierte Anfragen suchen
  with QuerySubsequent do
  begin
    close;
    open;

    // if no records are found, subsequent is not necessary
    if (not IsEmpty) then
    begin
      if ((now - FLastResponse) > (1 / 24)) then // nur einmal pro Stunde
      begin
        FLastResponse := now; // reset time of last response
        if echo() then
        begin
          Result := (not IsEmpty);
          // wenn Nacherfassung nötig, dann gleich hier durchführen
          while (NOT EOF) do
          begin
            if SendSubsequent = -1 then
            begin
              Result := FALSE; // 16.08.2017 KL: #17790 keinen Nullbeleg drucken bei Error
              Last;
            end;
            Next;
          end;
        end;
      end;
    end; { end of notEmpty }
  end; { end of WITH}
end;

function TDataFiskaltrust.CheckFiskaltrustNull: boolean;

  function Bit(pCheckBit: int64): boolean;
  begin
    Result := (FResponseState and pCheckBit = pCheckBit);
  end;

begin
  Result := (FResponseState > 0)
       and ( Bit(C_STATE_TEMPORARY)
          or Bit(C_STATE_PERMANENT)
          or Bit(C_STATE_POSTGATHERING) );
end;

function TDataFiskaltrust.XSDateTime(): TXSDateTime;
begin
  Result := XSDateTime(now);
end;

function TDataFiskaltrust.XSDateTime(const value: TDateTime): TXSDateTime;
begin
  Result := DateTimeToXSDateTime(value, TRUE);

//  // old code:
//  Result := TXSDateTime.create;
//  // UseZeroMilliseconds ist wichtig, sonst passt es nicht zum Soap-Format
//  Result.UseZeroMilliseconds := true;
//  // und UTC ist ebenfalls wichtig, damit am Ende des Strings nicht +01:00 (bzw.+02:00) steht!
//  Result.AsUTCDateTime := value;
end;

function TDataFiskaltrust.XSDecimal(const pFloat: Double; const pDecimals: Byte = 2): TXSDecimal;
var
  aOldDecimalSeparator: Char;
begin
  aOldDecimalSeparator := FormatSettings.DecimalSeparator;
  if aOldDecimalSeparator <> '.' then
    FormatSettings.DecimalSeparator := '.';

  result := TXSDecimal.Create;
  Result.DecimalString := FormatFloat('0.####', roundx(pFloat, pDecimals));  // 12.11.2018 KL: #21277 roundx added

  if aOldDecimalSeparator <> '.' then
    FormatSettings.DecimalSeparator := aOldDecimalSeparator;
end;

function TDataFiskaltrust.XSFloat(const PXSDecimal: TXSDecimal; const pDecimals: Byte = 2): Double;
var
  aOldDecimalSeparator: Char;
begin
  aOldDecimalSeparator := FormatSettings.DecimalSeparator;
  if aOldDecimalSeparator <> '.' then
    FormatSettings.DecimalSeparator := '.';

  Result := roundx(StrToFloatDef(pXSDecimal.DecimalString, 0), pDecimals);  // 12.11.2018 KL: #21277 roundx added

  if aOldDecimalSeparator <> '.' then
    FormatSettings.DecimalSeparator := aOldDecimalSeparator;
end;

end.
