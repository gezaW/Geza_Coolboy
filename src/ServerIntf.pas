unit ServerIntf;

interface

uses
  System.JSON, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, system.DateUtils,
  Data.DB, FireDAC.Comp.Client, FireDAC.DApt, Spring.Container.Common, nxLogging,
  System.SysUtils, Math, System.Variants, system.classes, System.SyncObjs;

type
  TLicenseWarningTypes = (lwtNone, lwtOK, lwtWarning, lwtDeny, lwtError);

type
  TAfterPrintEvent = reference to procedure;

  IRestCommand = interface
  ['{51061E10-9884-4796-9FE8-877BEA42B4BE}']
    function DoCommand(const pParameters: string): string;
//    procedure SetCompanyID(pCompanyID: Integer);
//    procedure SetUserID(pUserID: Integer);
//    procedure SetWaiterName(pWaiterName: String);
//    procedure SetCommandName(const pCommandName: string);
//    procedure DeleteHelpTableAccount(pOpenTableID: Integer);
{$REGION 'Unit testing'}
{$IFDEF UNITTESTS}
    procedure SetStructureCheckMode(pValue: Boolean);
    function GetStructureCheckMode: Boolean;
    property CheckStructureMode: Boolean read GetStructureCheckMode write SetStructureCheckMode;
{$ENDIF}
{$ENDREGION}
  end;

  IRestDBConnection = interface
  ['{6C502A21-D49B-41E4-9CFD-EBE67F5FE379}']
    function GetConnection: TFDConnection;
    function GetTransaction: TFDTransaction;
    function GetConnectionFelix: TFDConnection;
    function GetTransactionFelix: TFDTransaction;
  end;

  IJWTToken = interface
  ['{35F13C4C-FAA8-4A3E-A000-3F15CF1747B3}']
    procedure SetToken(const pToken: string);
    function GetToken: string;
    function GetCustomClaimsValue(pName: string): string;
    function CreateToken(pCustomClaims: TJSONObject; pIssuedAt: TDateTime = 0;
      pNotBefore: TDateTime = 0; pExpiration: TDateTime = 0; const pIssuer: string = '';
      const pSecretKey: string = ''): string;
    function CheckToken(const pToken: string; out pErrorMessage: string): Boolean; overload;
    function CheckToken(out pErrorMessage: string): Boolean; overload;
    property Token: string read GetToken write SetToken;
  end;

  IRestChecker = Interface
  ['{D3E5E61F-2392-49A7-9DED-621E8031AC86}']
    function CheckUser(pUserName, pPassword: string): Boolean;
    function CheckOrCreateKASS_KASSENARCHIV_KassInfoId(pCompanyName: string): Boolean;
    function GetFirebirdPassword: String; // ADD_DB_CONNECTOR
    function EncryptString(pStringToEncrypt: string): string;
    function DecryptString(pCryptedString: string): string;
    procedure CheckOrCreateStProcGastKontoRechnung(pSectionName: string);
    procedure checkAndCreateArtikel(pCompName : string);
    procedure checkAndCreateKellner(pCompName: string);
    procedure checkAndCreateJournalArchiv(pCompName : string);
    procedure checkAndCreateSend_Bug_RestServer(pCompName: string);
    procedure checkAndCreateJournal(pCompName: string);
    procedure checkAndCreateHotel_Signature(pCompName: string);
    procedure checkAndCreateServerInvoice(pCompName: string);
    procedure checkDiversesServer_GetLeistungByID(pCompName: string);
  End;

  IRestServFunc = Interface
  ['{154FEE79-ADDB-4B24-91BF-DC7A0DB871A1}']

  End;

  IRestVouchers = Interface
  ['{3B09CFCD-7CCF-4EC1-BE63-2BFCDAFB9A5F}']
    function AddVoucher(pParameters: TJSONObject): string;
    function GetVoucher(pParameters: TJSONObject): string;
    function PayWithVoucher(pParameters: TJSONObject): string;
  End;


  TActionType = (atBill, atReversal, atTableTransfer, atRoomTranfer);

  THotelProgrammTyp = (hptNone =0,
                       hptCashDesk = 3,
                       hptHotelFelix = 4);

  TLanguage = (lGerman = 1,
               lEnglish =2);

  TJournalType = ( jTransferToTable=4,
                   jTransferToRoom =9 );

  TGMSProgrammType = (gpNONE =0,
                      gpCashRegister= 1,
                      gpFelix =2);
  TVoucherType = (vtNon = 0,
                  vtLocal =1,
                  vtVioma =2,
                  vtHKS =3);

  TGuest = class(Tobject)
  private
    FID : Int64;
    FCreationDate : TDate;
    FCreatorID : Int64;
  published
    property CreationDate : TDate read FCreationDate write FCreationDate;
    property CreatorID : Int64 read FCreatorID write FCreatorID;
    Property ID : Int64 read FID write FID;
  end;

  TArticle = class(Tobject)
    private
      FArticleID   : Int64;
      FArticleName : String;
      FTax         : Double;
      FTaxID       : Integer;
      FMainGroupID : Integer;
      FPrice       : Double;
      FQuantity    : Double;
    published
      property ArticleID : int64 read FArticleID write FArticleID;
      property MainGroupID : integer read FMainGroupID write FMainGroupID;
      property ArticleName : string read FArticleName write FArticleName;
      property Tax : Double read FTax  write FTax;
      property TaxID : Integer read FTaxID  write FTaxID;
      property Price : Double read FPrice  write FPrice;
      property Quantity : Double read FQuantity  write FQuantity;

  end;

  TRestCommand = class(TInterfacedObject, IRestCommand)
  private
     FFelixVersion :         Integer;
     function WriteTransferToJournal(pOpentbaleIDFrom, pOpenTableIDTo,
      pArticleid, pQuantity, pPrice, pText: String;
      pExtras: array of string): boolean;
      procedure SetWaiterLanguage;


  protected
    FDBConnection: IRestDBConnection;
    FQuery: TFDQuery;
    FCompanyID: Integer;
    FCashRegisterID : Integer;
    FLocalCashRegisterID: Integer;
    FWaiterID: Integer;
    FWaiterRights: Integer;
    FWaiterName : String;
    FStorageTableID: Integer;
    FLanguageID : TLanguage;
    FCommandName: string;
    FDateAutomaticly : Boolean;
    FClosingTime: TDateTime;
    FTableOnlyBySameWaiter : Boolean;  // waiters should not be allowed to open tables that have been opened by other waiters (#4695)
    FWaiterIsBoss : Boolean;
    FPriceLevel : Integer;
    FWaiterPriceLevel : Integer;
    FPriceLevelTable : Integer;
    FHappyHourPossible : Boolean;
    FOpenTableWaiterID : Integer;
    FHotelProgrammTyp : THotelProgrammTyp;
    FVoucher_GMSProgrammType : TGMSProgrammType;
    FVoucherType  : TVoucherType;
    FVoucher_Incert_CompanyCode : string;
    FVoucher_Incert_Link : String;
    FVoucher_Incert_Password : String;
    FVoucher_Incert_User : String;
    FPrintTransferSlip : Boolean;
    FPrintTransferSlipCount : Integer;
    FFelixTransferByCashRegisterID : Boolean;
    FFelixCompanyID : Integer;
    FKitchenDisplay : Boolean;
    FStorageUsed : Boolean;
    FImmidiateBillShowMessage : Boolean;
    FFelixRooms : Boolean;
    FSlipNumberOnHotel: Boolean;
    FBookHotelDetailed:  Boolean; // HOTELEINZELNBUCHEN
    FPasswordRequired :  Boolean;
    FVoucherNumberAuto : Boolean;
//    FUnitTestVariables : TVariableList;
    function ConvertDatasetToJSON(pDataset: TDataset): string;
    function DoCommand(pParameters: TJSONObject): string; overload; virtual; abstract;
    function EncodePassword(const pPassword: string): string;
    property FelixVersion: Integer read FFelixVersion write FFelixVersion;
  public
    constructor Create; overload;
    procedure SetConnection(pDBConnection: IRestDBConnection);

    function  DoCommand(const pParameters: string): string; overload; virtual;
    //###################
    Function  CreateQueryZen: TFDQuery;
    function  CreateQueryFelix: TFDQuery;
    function  DoMessage(pMessageGerman, pMessageEnglish: String): string;
    function  ConvertJsonStringToFloat(pAmount: String): Double;
//    function TableIsLocked(pVariableList: Tvariablelist): boolean;
    function checkLicense: TLicenseWarningTypes;
    function GetCompanyInfo: TJsonObject;

    {$REGION 'Unit testing'}
{$IFDEF UNITTESTS}
  protected
    FStructureCheckMode: Boolean;
    procedure SetStructureCheckMode(pValue: Boolean);
    function GetStructureCheckMode: Boolean;
  public
    property CheckStructureMode: Boolean read GetStructureCheckMode write SetStructureCheckMode;
{$ENDIF}
{$ENDREGION}
  end;

implementation

uses
  Spring.Services, Resources, SQLResources, System.NetEncoding, Windows;

{ TRestCommand }

function TRestCommand.ConvertDatasetToJSON(pDataset: TDataset): string;
var
  i: Integer;
  jso: TjsonObject;
  js: TJsonArray;
  aFieldValue : String;
begin
  js := TJSONArray.Create;
  try
{$IFDEF UNITTESTS}
    if FStructureCheckMode then
      for i:=0 to pDataSet.FieldCount-1 do
        js.AddElement(TJSONString.Create(Lowercase(pDataset.Fields[i].FieldName)))
    else
{$ENDIF}
    with pDataSet do
    begin
      while not EOF do
      begin
        jso := TJSONObject.Create;
        for i:=0 to pDataSet.FieldCount-1 do
        begin
          aFieldValue := Fields[i].AsString;
          if pDataSet.Fields[i] is TFloatField then
          begin
            aFieldValue := stringReplace(aFieldValue, ',', '.', [rfIgnoreCase, rfReplaceAll]);
          end;
          jso.AddPair(TJSONPair.Create(Lowercase(Fields[i].FieldName),aFieldValue));
        end;
        js.AddElement(jso);
        next;
      end;
    end;
    result := js.ToJSON;
  finally
    FreeAndNil(js);
  end;
end;


function TRestCommand.ConvertJsonStringToFloat(pAmount: String): Double;
var
  aOldDecimalSeparator : Char;
  aAmount : String;
begin
  try
    aOldDecimalSeparator := FormatSettings.DecimalSeparator;
    FormatSettings.DecimalSeparator := '.';
    aAmount := stringReplace(pAmount, ',', '.', [rfIgnoreCase, rfReplaceAll]);
    result := StrToFloatDef(aAmount,0, FormatSettings);
  finally
    FormatSettings.DecimalSeparator := aOldDecimalSeparator;
  end;

end;

constructor TRestCommand.Create;
var
  aRoomTransferUsed : Boolean;
begin
  inherited;
//  pgl.isServer := true;
  FCompanyID := 1;
  FDBConnection  := Spring.Services.ServiceLocator.GetService<IRestDBConnection>;
{$IFDEF UNITTESTS}
  FStructureCheckMode := True;
{$ENDIF}
  FQuery := TFDQuery.Create(FDBConnection.GetConnection);
  FQuery.Connection := FDBConnection.GetConnection;

  if FFelixCompanyID < 1 then
    FFelixCompanyID := FCompanyID;

//  FCashRegisterID := DBase.KasseID;
//  FLocalCashRegisterID := DBase.KasseLocalID;

end;


function TRestCommand.checkLicense: TLicenseWarningTypes;
var
  aToday, aEnd: TDate;
  aQuery: TFDQuery;
  aInfo: TStringList;
  aMonth: Integer;
  aReport, aError: string;

  function CheckDeviceUsage: TLicenseWarningTypes;
  begin
    Result := lwtNone;
    with aQuery do
    try
      Close;
      SQL.Clear;
      SQL.Text := cSQLCheckDeviceUsageNotReported;
      ParamByName('DateTo').AsDate := aEnd;
      Open;
      // nothing to report, everything OK
      if RecordCount=0 then
        Result := lwtOK;
    Except on E:Exception do
      begin
        Result := lwtError;
//        FLogger.WriteToLog('Error in CheckDeviceUsage: ' +e.Message, lmtError);
      end;
    end;
  end;

begin
  Result := lwtNone;
  aToday := Trunc(Now);

  aQuery := CreateQueryZen;
  aInfo := TStringList.Create;
  try
    with aQuery do
    try
      // end date is first day of current month
      aEnd := EncodeDate(YearOf(aToday), MonthOf(aToday), 1);
      Result := CheckDeviceUsage;
      if Result <> lwtNone then
        Exit;

      aInfo.Add(' ');
      aInfo.Add('Lizenz-Report');

      // summary of devices per year and month for email body
      first;
      aMonth := 0;
      while not eof do
      begin
        if aMonth <> (FieldByName('YYYY').AsInteger * 100 + FieldByName('MM').AsInteger) then
        begin
          aInfo.Add(StringOfChar('-', 50));
          aInfo.Add(Format('Jahr / Monat: %d / %d', [FieldByName('YYYY').AsInteger, FieldByName('MM').AsInteger]));
          aMonth := FieldByName('YYYY').AsInteger * 100 + FieldByName('MM').AsInteger;
        end;
        aInfo.Add(Format('  Gerät: %s --> Tage: %d', [FieldByName('GUID').AsString, FieldByName('Anzahl').AsInteger]));
        next;
      end;
      Close;

      // create fastreport for email attachment
      aReport := ''; // 'ZenLicense.fr3';  TODO add fastreport!!

      // try to send report by email
//      if DataEmail.SendEmail(aError, 'ZenM-Lizenzreport', aInfo, aReport) then
//      begin // if email has been sent, update report date
//        Close;
//        SQL.Clear;
//        SQL.Text := cSQLUpdateReportDate;
//        ParamByName('DateTo').AsDate := aEnd;
//        ExecSQL;
//      end
//      else
//        FLogger.WriteToLog('Error in SendEmail: ' +aError, lmtError);


      Result := CheckDeviceUsage;
      if Result <> lwtNone then
        Exit;

      // after 2 months deny all logins
      if EncodeDate(FieldByName('YYYY').AsInteger, FieldByName('MM').AsInteger, 1) < IncMonth(aEnd, -2) then
      begin
        Result := lwtDeny;
        Exit;
      end;

      // after 2 weeks send warning
      if aToday >= IncDay(aEnd, 13) then
      begin
        Result := lwtWarning;
        Exit;
      end;

    Except on E:Exception do
      begin
        Result := lwtError;
//        FLogger.WriteToLog('Error in checkLicense: ' +e.Message, lmtError);
      end;
    end;
  finally
    aInfo.Destroy;
    aQuery.Destroy;
  end;
end;

function TRestCommand.CreateQueryFelix: TFDQuery;
var
  aQuery : TFDQuery;
begin
   aQuery := TFDQuery.Create(FDBConnection.GetConnectionFelix);
   //aQuery := TFDQuery.Create(nil);
   aQuery.Connection := FDBConnection.GetConnectionFelix;
   aQuery.Connection.Connected := True;
   result := aQuery;
end;

function TRestCommand.CreateQueryZen: TFDQuery;
var
  aQuery : TFDQuery;
begin
   aQuery := TFDQuery.Create(FDBConnection.GetConnection);
   aQuery.FetchOptions.Mode := fmAll; // 15.01.2019 KL:#21659 always fetch all records!
   aQuery.Connection := FDBConnection.GetConnection;
   aQuery.Connection.Connected := True;
   result := aQuery;
end;

procedure TRestCommand.SetWaiterLanguage;
var
  aQuery :TFDQuery;
  aLanguageID : Integer;
begin
  aQuery := CreateQueryZen;
  FLanguageID := lGerman;
  try
    aQuery.SQL.Text := cSQLGetWaiterLanguage;
    aQuery.ParamByName('Waiterid').AsInteger := FWaiterID;
    aQuery.Open;
    if NOT aQuery.Eof then
     aLanguageID :=  aQuery.FieldByName('Languageid').Asinteger;
    if aLanguageID>1 then
      FLanguageID := lEnglish;

  finally
    aQuery.Free;
  end;
end;

function TRestCommand.GetCompanyInfo: TJsonObject;
var
  aQuery :TFDQuery;
  aMessage : String;
  aJSOBject: TJSONObject;
  i: integer;
begin
  try
    result := TJSONObject.create;
    aQuery := CreateQueryZen;
    try
      aQuery.SQL.Text := cSQLGetCompanyInfo;
      aQuery.ParamByName('CompanyID').AsInteger := FCompanyID;
      aQuery.Open;
      if not aQuery.EOF then
      begin
        result.AddPair('titel',aQuery.FieldByName('Titel').AsString);
        for i := 1 to 5 do
          result.AddPair('text'+inttostr(i),aQuery.FieldByName('text'+inttostr(i)).AsString);
//        result.AddPair('sumarticles',GetSettingSumArticle);
      end;
    Except on e:Exception do
      begin
      aMessage :='Error in GetCompanyInfo: '+  E.Message;
//        LogErrorMessageAndCreateJSon (aMessage);
      end;
    end;
  finally
    aQuery.Free;
  end;
end;

function TRestCommand.DoCommand(const pParameters: string): string;
var
  aErrorMessage: string;
  aParameters: TJSONObject;
  aParamStr : String;
  aWaiterid : Integer;
  aJSONObject: TJSONObject;
  aResultJson: TJSONValue;
begin
  SetWaiterLanguage;

//  if IsAuthorized(aErrorMessage) = False then
//    if aErrorMessage = '' then
//    begin
//      aErrorMessage := DoMessage(Format(cErrorUnauthorizedAccessDE, [FCommandName]),
//                                 Format(cErrorUnauthorizedAccess, [FCommandName]));
//      raise Exception.Create(aErrorMessage)
//    end
//    else
//      raise Exception.Create(aErrorMessage);

  aParamStr := pParameters;
  if Trim(aParamStr) = '' then
    aParamStr := '{}';
  aJSONObject := TJSONObject.Create;

  aParameters := TJSONObject.ParseJSONValue(TNetEncoding.URL.Decode(aParamStr)) as TJSONObject;

  try
    try
//      Result := PostProcessResult(DoCommand(aParameters));
    except
      on E: Exception do
      begin
        aJSONObject.AddPair('error',e.Message);
//        FLogger.WriteToLog(ClassName + ': Error: '+ E.Message, lmtError);
        Result := aJSONObject.ToJSON;
      end;
    end;
  finally
//    FLogger.WriteToLog('Response: ' + Result, lmtDebug);
    FreeAndNil(aParameters);
    FreeAndNil(aJSONObject);
  end;
end;

function TRestCommand.DoMessage(pMessageGerman, pMessageEnglish: String): string;
begin
  if (FLanguageID = lGerman) and (trim(pMessageGerman) > '') then
    Result := pMessageGerman
  else
    Result := pMessageEnglish;
end;

function TRestCommand.EncodePassword(const pPassword: string): string;
type
  TParity = (pOdd, pEven);
const
  cTableKeyOriginal = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789ÄÜÖ';
  cTableKeyEven     = 'sklqmndf7328045xuÖihägwzoüy1c6b9jperatv';
  cTableKeyOdd      = '9bÜ6cÄ1vtarepjsklfdnmq457328Ö0hiuxzwgyo';

var
  PassStrg: String;
  CharCnt: Integer;

  function GetKeyChar(pParity: TParity; pChar: Char): Char;
  var
    aPos: Integer;
    aFound: Boolean;
  begin
    Result := #0;
    aPos:=1;
    aFound:=FALSE;
    repeat
      if cTableKeyOriginal[aPos] = pChar then
        aFound:=TRUE;
      if not aFound then
        Inc(aPos);
    until aFound;
    case pParity of
      pEven  : Result := cTableKeyEven[aPos];
      pOdd   : Result := cTableKeyOdd[aPos];
    end;
  end;

begin
  Result := '';
  PassStrg := '';
  //Überprüfen, ob auch gültige Zeichen enthalten sind, da Über TouchTastatur
  //auch ungültige Zeichen eingegebener werden können
  for CharCnt := 1 to length(pPassword) do
  begin
   if not (pPassword[CharCnt] in
     [Chr(VK_BACK),'A'..'Z','a'..'z','Ä','Ü','Ö','ä','ü','ö','0'..'9']) then
     Exit;
  end;
  For CharCnt:=1 to length(pPassword) do
  begin
    if CharCnt mod 2 = 0 then
      PassStrg:=PassStrg+GetKeyChar(pEven, pPassword[CharCnt])
    else
      PassStrg:=PassStrg+GetKeyChar(pOdd, pPassword[CharCnt]);
  end;
  For CharCnt:=length(PassStrg) downto 1 do
    Result := Result + PassStrg[CharCnt];
end;

procedure TRestCommand.SetConnection(pDBConnection: IRestDBConnection);
begin
  FDBConnection := pDBConnection;
end;

function TRestCommand.WriteTransferToJournal(pOpentbaleIDFrom,pOpenTableIDTo, pArticleid, pQuantity, pPrice,
              pText: String; pExtras: array of string): boolean;
begin

end;


{$REGION 'UnitTesting'}
{$IFDEF UNITTESTS}
procedure TRestCommand.SetStructureCheckMode(pValue: Boolean);
begin
  FStructureCheckMode := pValue;
end;

function TRestCommand.GetStructureCheckMode: Boolean;
begin
  Result := FStructureCheckMode;
end;




{$ENDIF}
{$ENDREGION}


end.
