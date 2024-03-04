// ************************************************************************ //
// The types declared in this file were generated from data read from the
// WSDL File described below:
// WSDL     : fiskaltrust.interface.1.0.16298.1022-rc.wsdl
// Encoding : utf-8
// Codegen  : [wfUseSettersAndGetters+]
// Version  : 1.0
// (08.06.2018 13:30:31 - - $Rev: 90173 $)
// ************************************************************************ //

unit fiskaltrust;

interface

uses Soap.InvokeRegistry, Soap.SOAPHTTPClient, System.Types, Soap.XSBuiltIns,
  REST.Json.Types, Data.DBXJSONReflect;

const
  IS_OPTN = $0001;
  IS_UNBD = $0002;
  IS_NLBL = $0004;
  IS_REF  = $0080;


type

  // ************************************************************************ //
  // The following types, referred to in the WSDL document are not being represented
  // in this file. They are either aliases[@] of other types represented or were referred
  // to but never[!] declared in the document. The types from the latter category
  // typically map to predefined/known XML or Embarcadero types; however, they could also
  // indicate incorrect WSDL documents that failed to declare or import a schema type.
  // ************************************************************************ //
  // !:string          - "http://www.w3.org/2001/XMLSchema"[Gbl]
  // !:base64Binary    - "http://www.w3.org/2001/XMLSchema"[Gbl]
  // !:decimal         - "http://www.w3.org/2001/XMLSchema"[Gbl]
  // !:dateTime        - "http://www.w3.org/2001/XMLSchema"[Gbl]
  // !:long            - "http://www.w3.org/2001/XMLSchema"[Gbl]

  SignaturItem2        = class;                 { "http://schemas.datacontract.org/2004/07/fiskaltrust.ifPOS.v0"[GblCplx] }
  SignaturItem         = class;                 { "http://schemas.datacontract.org/2004/07/fiskaltrust.ifPOS.v0"[GblElm] }
  PayItem2             = class;                 { "http://schemas.datacontract.org/2004/07/fiskaltrust.ifPOS.v0"[GblCplx] }
  PayItem              = class;                 { "http://schemas.datacontract.org/2004/07/fiskaltrust.ifPOS.v0"[GblElm] }
  ChargeItem2          = class;                 { "http://schemas.datacontract.org/2004/07/fiskaltrust.ifPOS.v0"[GblCplx] }
  ChargeItem           = class;                 { "http://schemas.datacontract.org/2004/07/fiskaltrust.ifPOS.v0"[GblElm] }
  ReceiptRequest2      = class;                 { "http://schemas.datacontract.org/2004/07/fiskaltrust.ifPOS.v0"[GblCplx] }
  ReceiptRequest       = class;                 { "http://schemas.datacontract.org/2004/07/fiskaltrust.ifPOS.v0"[GblElm] }
  ReceiptResponse2     = class;                 { "http://schemas.datacontract.org/2004/07/fiskaltrust.ifPOS.v0"[GblCplx] }
  ReceiptResponse      = class;                 { "http://schemas.datacontract.org/2004/07/fiskaltrust.ifPOS.v0"[GblElm] }

  ArrayOfSignaturItem = array of SignaturItem2;   { "http://schemas.datacontract.org/2004/07/fiskaltrust.ifPOS.v0"[GblCplx] }
  StreamBody      =  TByteDynArray;      { "http://schemas.microsoft.com/Message"[GblSmpl] }

  // ************************************************************************ //
  // XML       : SignaturItem, global, <complexType>
  // Namespace : http://schemas.datacontract.org/2004/07/fiskaltrust.ifPOS.v0
  // ************************************************************************ //
  SignaturItem2 = class(TRemotable)
  private
    FftSignatureFormat: Int64;
    FftSignatureType: Int64;
    FCaption: string;
    [JSONMarshalledAttribute(False)]
    FCaption_Specified: boolean;
    FData: string;
    function  GetftSignatureFormat: Int64;
    procedure SetftSignatureFormat(const AInt64: Int64);
    function  GetftSignatureType: Int64;
    procedure SetftSignatureType(const AInt64: Int64);
    function  GetCaption(Index: Integer): string;
    procedure SetCaption(Index: Integer; const Astring: string);
    function  Caption_Specified(Index: Integer): boolean;
    function  GetData(Index: Integer): string;
    procedure SetData(Index: Integer; const Astring: string);
  published
    property ftSignatureFormat: Int64   read GetftSignatureFormat write SetftSignatureFormat;
    property ftSignatureType:   Int64   read GetftSignatureType write SetftSignatureType;
    property Caption:           string  Index (IS_OPTN or IS_NLBL) read GetCaption write SetCaption stored Caption_Specified;
    property Data:              string  Index (IS_NLBL) read GetData write SetData;
  end;



  // ************************************************************************ //
  // XML       : SignaturItem, global, <element>
  // Namespace : http://schemas.datacontract.org/2004/07/fiskaltrust.ifPOS.v0
  // ************************************************************************ //
  SignaturItem = class(SignaturItem2)
  private
  published
  end;



  // ************************************************************************ //
  // XML       : PayItem, global, <complexType>
  // Namespace : http://schemas.datacontract.org/2004/07/fiskaltrust.ifPOS.v0
  // ************************************************************************ //
  PayItem2 = class(TRemotable)
  private
    [JSONMarshalledAttribute(False)]
    FPosition: Int64;
    [JSONMarshalledAttribute(False)]
    FPosition_Specified: boolean;
    FQuantity: TXSDecimal;
    FDescription: string;
    FAmount: TXSDecimal;
    FftPayItemCase: Int64;
    [JSONMarshalledAttribute(False)]
    FftPayItemCaseData: string;
    [JSONMarshalledAttribute(False)]
    FftPayItemCaseData_Specified: boolean;
    [JSONMarshalledAttribute(False)]
    FAccountNumber: string;
    [JSONMarshalledAttribute(False)]
    FAccountNumber_Specified: boolean;
    [JSONMarshalledAttribute(False)]
    FCostCenter: string;
    [JSONMarshalledAttribute(False)]
    FCostCenter_Specified: boolean;
    [JSONMarshalledAttribute(False)]
    FMoneyGroup: string;
    [JSONMarshalledAttribute(False)]
    FMoneyGroup_Specified: boolean;
    [JSONMarshalledAttribute(False)]
    FMoneyNumber: string;
    [JSONMarshalledAttribute(False)]
    FMoneyNumber_Specified: boolean;
    [JSONMarshalledAttribute(False)]
    FMoment: TXSDateTime;
    [JSONMarshalledAttribute(False)]
    FMoment_Specified: boolean;
    function  GetPosition(Index: Integer): Int64;
    procedure SetPosition(Index: Integer; const AInt64: Int64);
    function  Position_Specified(Index: Integer): boolean;
    function  GetQuantity: TXSDecimal;
    procedure SetQuantity(const ATXSDecimal: TXSDecimal);
    function  GetDescription(Index: Integer): string;
    procedure SetDescription(Index: Integer; const Astring: string);
    function  GetAmount: TXSDecimal;
    procedure SetAmount(const ATXSDecimal: TXSDecimal);
    function  GetftPayItemCase: Int64;
    procedure SetftPayItemCase(const AInt64: Int64);
    function  GetftPayItemCaseData(Index: Integer): string;
    procedure SetftPayItemCaseData(Index: Integer; const Astring: string);
    function  ftPayItemCaseData_Specified(Index: Integer): boolean;
    function  GetAccountNumber(Index: Integer): string;
    procedure SetAccountNumber(Index: Integer; const Astring: string);
    function  AccountNumber_Specified(Index: Integer): boolean;
    function  GetCostCenter(Index: Integer): string;
    procedure SetCostCenter(Index: Integer; const Astring: string);
    function  CostCenter_Specified(Index: Integer): boolean;
    function  GetMoneyGroup(Index: Integer): string;
    procedure SetMoneyGroup(Index: Integer; const Astring: string);
    function  MoneyGroup_Specified(Index: Integer): boolean;
    function  GetMoneyNumber(Index: Integer): string;
    procedure SetMoneyNumber(Index: Integer; const Astring: string);
    function  MoneyNumber_Specified(Index: Integer): boolean;
    function  GetMoment(Index: Integer): TXSDateTime;
    procedure SetMoment(Index: Integer; const ATXSDateTime: TXSDateTime);
    function  Moment_Specified(Index: Integer): boolean;
  public
    destructor Destroy; override;
  published
    property Position:          Int64        Index (IS_OPTN) read GetPosition write SetPosition stored Position_Specified;
    property Quantity:          TXSDecimal   read GetQuantity write SetQuantity;
    property Description:       string       Index (IS_NLBL) read GetDescription write SetDescription;
    property Amount:            TXSDecimal   read GetAmount write SetAmount;
    property ftPayItemCase:     Int64        read GetftPayItemCase write SetftPayItemCase;
    property ftPayItemCaseData: string       Index (IS_OPTN or IS_NLBL) read GetftPayItemCaseData write SetftPayItemCaseData stored ftPayItemCaseData_Specified;
    property AccountNumber:     string       Index (IS_OPTN or IS_NLBL) read GetAccountNumber write SetAccountNumber stored AccountNumber_Specified;
    property CostCenter:        string       Index (IS_OPTN or IS_NLBL) read GetCostCenter write SetCostCenter stored CostCenter_Specified;
    property MoneyGroup:        string       Index (IS_OPTN or IS_NLBL) read GetMoneyGroup write SetMoneyGroup stored MoneyGroup_Specified;
    property MoneyNumber:       string       Index (IS_OPTN or IS_NLBL) read GetMoneyNumber write SetMoneyNumber stored MoneyNumber_Specified;
    property Moment:            TXSDateTime  Index (IS_OPTN or IS_NLBL) read GetMoment write SetMoment stored Moment_Specified;
  end;



  // ************************************************************************ //
  // XML       : PayItem, global, <element>
  // Namespace : http://schemas.datacontract.org/2004/07/fiskaltrust.ifPOS.v0
  // ************************************************************************ //
  PayItem = class(PayItem2)
  private
  published
  end;

  ArrayOfstring = array of string;              { "http://schemas.microsoft.com/2003/10/Serialization/Arrays"[GblCplx] }


  // ************************************************************************ //
  // XML       : ChargeItem, global, <complexType>
  // Namespace : http://schemas.datacontract.org/2004/07/fiskaltrust.ifPOS.v0
  // ************************************************************************ //
  ChargeItem2 = class(TRemotable)
  private
    [JSONMarshalledAttribute(False)]
    FPosition: Int64;
    [JSONMarshalledAttribute(False)]
    FPosition_Specified: boolean;
    FQuantity: TXSDecimal;
    FDescription: string;
    FAmount: TXSDecimal;
    FVATRate: TXSDecimal;
    FftChargeItemCase: Int64;
    [JSONMarshalledAttribute(False)]
    FftChargeItemCaseData: string;
    [JSONMarshalledAttribute(False)]
    FftChargeItemCaseData_Specified: boolean;
    [JSONMarshalledAttribute(False)]
    FVATAmount: TXSDecimal;
    [JSONMarshalledAttribute(False)]
    FVATAmount_Specified: boolean;
    [JSONMarshalledAttribute(False)]
    FAccountNumber: string;
    [JSONMarshalledAttribute(False)]
    FAccountNumber_Specified: boolean;
    [JSONMarshalledAttribute(False)]
    FCostCenter: string;
    [JSONMarshalledAttribute(False)]
    FCostCenter_Specified: boolean;
    [JSONMarshalledAttribute(False)]
    FProductGroup: string;
    [JSONMarshalledAttribute(False)]
    FProductGroup_Specified: boolean;
    FProductNumber: string;
    [JSONMarshalledAttribute(False)]
    FProductNumber_Specified: boolean;
    [JSONMarshalledAttribute(False)]
    FProductBarcode: string;
    [JSONMarshalledAttribute(False)]
    FProductBarcode_Specified: boolean;
    [JSONMarshalledAttribute(False)]
    FUnit_: string;
    [JSONMarshalledAttribute(False)]
    FUnit__Specified: boolean;
    [JSONMarshalledAttribute(False)]
    FUnitQuantity: TXSDecimal;
    [JSONMarshalledAttribute(False)]
    FUnitQuantity_Specified: boolean;
    [JSONMarshalledAttribute(False)]
    FUnitPrice: TXSDecimal;
    [JSONMarshalledAttribute(False)]
    FUnitPrice_Specified: boolean;
    [JSONMarshalledAttribute(False)]
    FMoment: TXSDateTime;
    [JSONMarshalledAttribute(False)]
    FMoment_Specified: boolean;
    function  GetPosition(Index: Integer): Int64;
    procedure SetPosition(Index: Integer; const AInt64: Int64);
    function  Position_Specified(Index: Integer): boolean;
    function  GetQuantity: TXSDecimal;
    procedure SetQuantity(const ATXSDecimal: TXSDecimal);
    function  GetDescription(Index: Integer): string;
    procedure SetDescription(Index: Integer; const Astring: string);
    function  GetAmount: TXSDecimal;
    procedure SetAmount(const ATXSDecimal: TXSDecimal);
    function  GetVATRate: TXSDecimal;
    procedure SetVATRate(const ATXSDecimal: TXSDecimal);
    function  GetftChargeItemCase: Int64;
    procedure SetftChargeItemCase(const AInt64: Int64);
    function  GetftChargeItemCaseData(Index: Integer): string;
    procedure SetftChargeItemCaseData(Index: Integer; const Astring: string);
    function  ftChargeItemCaseData_Specified(Index: Integer): boolean;
    function  GetVATAmount(Index: Integer): TXSDecimal;
    procedure SetVATAmount(Index: Integer; const ATXSDecimal: TXSDecimal);
    function  VATAmount_Specified(Index: Integer): boolean;
    function  GetAccountNumber(Index: Integer): string;
    procedure SetAccountNumber(Index: Integer; const Astring: string);
    function  AccountNumber_Specified(Index: Integer): boolean;
    function  GetCostCenter(Index: Integer): string;
    procedure SetCostCenter(Index: Integer; const Astring: string);
    function  CostCenter_Specified(Index: Integer): boolean;
    function  GetProductGroup(Index: Integer): string;
    procedure SetProductGroup(Index: Integer; const Astring: string);
    function  ProductGroup_Specified(Index: Integer): boolean;
    function  GetProductNumber(Index: Integer): string;
    procedure SetProductNumber(Index: Integer; const Astring: string);
    function  ProductNumber_Specified(Index: Integer): boolean;
    function  GetProductBarcode(Index: Integer): string;
    procedure SetProductBarcode(Index: Integer; const Astring: string);
    function  ProductBarcode_Specified(Index: Integer): boolean;
    function  GetUnit_(Index: Integer): string;
    procedure SetUnit_(Index: Integer; const Astring: string);
    function  Unit__Specified(Index: Integer): boolean;
    function  GetUnitQuantity(Index: Integer): TXSDecimal;
    procedure SetUnitQuantity(Index: Integer; const ATXSDecimal: TXSDecimal);
    function  UnitQuantity_Specified(Index: Integer): boolean;
    function  GetUnitPrice(Index: Integer): TXSDecimal;
    procedure SetUnitPrice(Index: Integer; const ATXSDecimal: TXSDecimal);
    function  UnitPrice_Specified(Index: Integer): boolean;
    function  GetMoment(Index: Integer): TXSDateTime;
    procedure SetMoment(Index: Integer; const ATXSDateTime: TXSDateTime);
    function  Moment_Specified(Index: Integer): boolean;
  public
    destructor Destroy; override;
  published
    property Position:             Int64        Index (IS_OPTN) read GetPosition write SetPosition stored Position_Specified;
    property Quantity:             TXSDecimal   read GetQuantity write SetQuantity;
    property Description:          string       Index (IS_NLBL) read GetDescription write SetDescription;
    property Amount:               TXSDecimal   read GetAmount write SetAmount;
    property VATRate:              TXSDecimal   read GetVATRate write SetVATRate;
    property ftChargeItemCase:     Int64        read GetftChargeItemCase write SetftChargeItemCase;
    property ftChargeItemCaseData: string       Index (IS_OPTN or IS_NLBL) read GetftChargeItemCaseData write SetftChargeItemCaseData stored ftChargeItemCaseData_Specified;
    property VATAmount:            TXSDecimal   Index (IS_OPTN or IS_NLBL) read GetVATAmount write SetVATAmount stored VATAmount_Specified;
    property AccountNumber:        string       Index (IS_OPTN or IS_NLBL) read GetAccountNumber write SetAccountNumber stored AccountNumber_Specified;
    property CostCenter:           string       Index (IS_OPTN or IS_NLBL) read GetCostCenter write SetCostCenter stored CostCenter_Specified;
    property ProductGroup:         string       Index (IS_OPTN or IS_NLBL) read GetProductGroup write SetProductGroup stored ProductGroup_Specified;
    property ProductNumber:        string       Index (IS_OPTN or IS_NLBL) read GetProductNumber write SetProductNumber stored ProductNumber_Specified;
    property ProductBarcode:       string       Index (IS_OPTN or IS_NLBL) read GetProductBarcode write SetProductBarcode stored ProductBarcode_Specified;
    property Unit_:                string       Index (IS_OPTN or IS_NLBL) read GetUnit_ write SetUnit_ stored Unit__Specified;
    property UnitQuantity:         TXSDecimal   Index (IS_OPTN or IS_NLBL) read GetUnitQuantity write SetUnitQuantity stored UnitQuantity_Specified;
    property UnitPrice:            TXSDecimal   Index (IS_OPTN or IS_NLBL) read GetUnitPrice write SetUnitPrice stored UnitPrice_Specified;
    property Moment:               TXSDateTime  Index (IS_OPTN or IS_NLBL) read GetMoment write SetMoment stored Moment_Specified;
  end;



  // ************************************************************************ //
  // XML       : ChargeItem, global, <element>
  // Namespace : http://schemas.datacontract.org/2004/07/fiskaltrust.ifPOS.v0
  // ************************************************************************ //
  ChargeItem = class(ChargeItem2)
  private
  published
  end;

  ArrayOfChargeItem = array of ChargeItem2;     { "http://schemas.datacontract.org/2004/07/fiskaltrust.ifPOS.v0"[GblCplx] }
  ArrayOfPayItem = array of PayItem2;           { "http://schemas.datacontract.org/2004/07/fiskaltrust.ifPOS.v0"[GblCplx] }


  // ************************************************************************ //
  // XML       : ReceiptRequest, global, <complexType>
  // Namespace : http://schemas.datacontract.org/2004/07/fiskaltrust.ifPOS.v0
  // ************************************************************************ //
  ReceiptRequest2 = class(TRemotable)
  private
    FftCashBoxID: string;
    [JSONMarshalledAttribute(False)]
    FftQueueID: string;
    [JSONMarshalledAttribute(False)]
    FftQueueID_Specified: boolean;
    FftPosSystemId: string;
    [JSONMarshalledAttribute(False)]
    FftPosSystemId_Specified: boolean;
    FcbTerminalID: string;
    FcbReceiptReference: string;
    FcbReceiptMoment: TXSDateTime;
    FcbChargeItems: ArrayOfChargeItem;
    FcbPayItems: ArrayOfPayItem;
    FftReceiptCase: Int64;
    [JSONMarshalledAttribute(False)]
    FftReceiptCaseData: string;
    [JSONMarshalledAttribute(False)]
    FftReceiptCaseData_Specified: boolean;
    FcbReceiptAmount: TXSDecimal;
    [JSONMarshalledAttribute(False)]
    FcbReceiptAmount_Specified: boolean;
    FcbUser: string;
    [JSONMarshalledAttribute(False)]
    FcbUser_Specified: boolean;
    FcbArea: string;
    [JSONMarshalledAttribute(False)]
    FcbArea_Specified: boolean;
    FcbCustomer: string;
    [JSONMarshalledAttribute(False)]
    FcbCustomer_Specified: boolean;
    FcbSettlement: string;
    [JSONMarshalledAttribute(False)]
    FcbSettlement_Specified: boolean;
    FcbPreviousReceiptReference: string;
    [JSONMarshalledAttribute(False)]
    FcbPreviousReceiptReference_Specified: boolean;
    function  GetftCashBoxID(Index: Integer): string;
    procedure SetftCashBoxID(Index: Integer; const Astring: string);
    function  GetftQueueID(Index: Integer): string;
    procedure SetftQueueID(Index: Integer; const Astring: string);
    function  ftQueueID_Specified(Index: Integer): boolean;
    function  GetftPosSystemId(Index: Integer): string;
    procedure SetftPosSystemId(Index: Integer; const Astring: string);
    function  ftPosSystemId_Specified(Index: Integer): boolean;
    function  GetcbTerminalID(Index: Integer): string;
    procedure SetcbTerminalID(Index: Integer; const Astring: string);
    function  GetcbReceiptReference(Index: Integer): string;
    procedure SetcbReceiptReference(Index: Integer; const Astring: string);
    function  GetcbReceiptMoment: TXSDateTime;
    procedure SetcbReceiptMoment(const ATXSDateTime: TXSDateTime);
    function  GetcbChargeItems(Index: Integer): ArrayOfChargeItem;
    procedure SetcbChargeItems(Index: Integer; const AArrayOfChargeItem: ArrayOfChargeItem);
    function  GetcbPayItems(Index: Integer): ArrayOfPayItem;
    procedure SetcbPayItems(Index: Integer; const AArrayOfPayItem: ArrayOfPayItem);
    function  GetftReceiptCase: Int64;
    procedure SetftReceiptCase(const AInt64: Int64);
    function  GetftReceiptCaseData(Index: Integer): string;
    procedure SetftReceiptCaseData(Index: Integer; const Astring: string);
    function  ftReceiptCaseData_Specified(Index: Integer): boolean;
    function  GetcbReceiptAmount(Index: Integer): TXSDecimal;
    procedure SetcbReceiptAmount(Index: Integer; const ATXSDecimal: TXSDecimal);
    function  cbReceiptAmount_Specified(Index: Integer): boolean;
    function  GetcbUser(Index: Integer): string;
    procedure SetcbUser(Index: Integer; const Astring: string);
    function  cbUser_Specified(Index: Integer): boolean;
    function  GetcbArea(Index: Integer): string;
    procedure SetcbArea(Index: Integer; const Astring: string);
    function  cbArea_Specified(Index: Integer): boolean;
    function  GetcbCustomer(Index: Integer): string;
    procedure SetcbCustomer(Index: Integer; const Astring: string);
    function  cbCustomer_Specified(Index: Integer): boolean;
    function  GetcbSettlement(Index: Integer): string;
    procedure SetcbSettlement(Index: Integer; const Astring: string);
    function  cbSettlement_Specified(Index: Integer): boolean;
    function  GetcbPreviousReceiptReference(Index: Integer): string;
    procedure SetcbPreviousReceiptReference(Index: Integer; const Astring: string);
    function  cbPreviousReceiptReference_Specified(Index: Integer): boolean;
  public
    destructor Destroy; override;
  published
    property ftCashBoxID:                string             Index (IS_NLBL) read GetftCashBoxID write SetftCashBoxID;
    property ftQueueID:                  string             Index (IS_OPTN or IS_NLBL) read GetftQueueID write SetftQueueID stored ftQueueID_Specified;
    property ftPosSystemId:              string             Index (IS_OPTN or IS_NLBL) read GetftPosSystemId write SetftPosSystemId stored ftPosSystemId_Specified;
    property cbTerminalID:               string             Index (IS_NLBL) read GetcbTerminalID write SetcbTerminalID;
    property cbReceiptReference:         string             Index (IS_NLBL) read GetcbReceiptReference write SetcbReceiptReference;
    property cbReceiptMoment:            TXSDateTime        read GetcbReceiptMoment write SetcbReceiptMoment;
    property cbChargeItems:              ArrayOfChargeItem  Index (IS_NLBL) read GetcbChargeItems write SetcbChargeItems;
    property cbPayItems:                 ArrayOfPayItem     Index (IS_NLBL) read GetcbPayItems write SetcbPayItems;
    property ftReceiptCase:              Int64              read GetftReceiptCase write SetftReceiptCase;
    property ftReceiptCaseData:          string             Index (IS_OPTN or IS_NLBL) read GetftReceiptCaseData write SetftReceiptCaseData stored ftReceiptCaseData_Specified;
    property cbReceiptAmount:            TXSDecimal         Index (IS_OPTN or IS_NLBL) read GetcbReceiptAmount write SetcbReceiptAmount stored cbReceiptAmount_Specified;
    property cbUser:                     string             Index (IS_OPTN or IS_NLBL) read GetcbUser write SetcbUser stored cbUser_Specified;
    property cbArea:                     string             Index (IS_OPTN or IS_NLBL) read GetcbArea write SetcbArea stored cbArea_Specified;
    property cbCustomer:                 string             Index (IS_OPTN or IS_NLBL) read GetcbCustomer write SetcbCustomer stored cbCustomer_Specified;
    property cbSettlement:               string             Index (IS_OPTN or IS_NLBL) read GetcbSettlement write SetcbSettlement stored cbSettlement_Specified;
    property cbPreviousReceiptReference: string             Index (IS_OPTN or IS_NLBL) read GetcbPreviousReceiptReference write SetcbPreviousReceiptReference stored cbPreviousReceiptReference_Specified;
  end;



  // ************************************************************************ //
  // XML       : ReceiptRequest, global, <element>
  // Namespace : http://schemas.datacontract.org/2004/07/fiskaltrust.ifPOS.v0
  // ************************************************************************ //
  ReceiptRequest = class(ReceiptRequest2)
  private
  published
  end;



  // ************************************************************************ //
  // XML       : ReceiptResponse, global, <complexType>
  // Namespace : http://schemas.datacontract.org/2004/07/fiskaltrust.ifPOS.v0
  // ************************************************************************ //
  ReceiptResponse2 = class(TRemotable)
  private
    FftCashBoxID: string;
    FftQueueID: string;
    FftQueueItemID: string;
    FftQueueRow: Int64;
    FcbTerminalID: string;
    FcbReceiptReference: string;
    FftCashBoxIdentification: string;
    FftReceiptIdentification: string;
    FftReceiptMoment: TXSDateTime;
    FftReceiptHeader: ArrayOfstring;
    FftReceiptHeader_Specified: boolean;
    FftChargeItems: ArrayOfChargeItem;
    FftChargeItems_Specified: boolean;
    FftChargeLines: ArrayOfstring;
    FftChargeLines_Specified: boolean;
    FftPayItems: ArrayOfPayItem;
    FftPayItems_Specified: boolean;
    FftPayLines: ArrayOfstring;
    FftPayLines_Specified: boolean;
    FftSignatures: ArrayOfSignaturItem;
    FftReceiptFooter: ArrayOfstring;
    FftReceiptFooter_Specified: boolean;
    FftState: Int64;
    FftStateData: string;
    FftStateData_Specified: boolean;
    function  GetftCashBoxID(Index: Integer): string;
    procedure SetftCashBoxID(Index: Integer; const Astring: string);
    function  GetftQueueID(Index: Integer): string;
    procedure SetftQueueID(Index: Integer; const Astring: string);
    function  GetftQueueItemID(Index: Integer): string;
    procedure SetftQueueItemID(Index: Integer; const Astring: string);
    function  GetftQueueRow: Int64;
    procedure SetftQueueRow(const AInt64: Int64);
    function  GetcbTerminalID(Index: Integer): string;
    procedure SetcbTerminalID(Index: Integer; const Astring: string);
    function  GetcbReceiptReference(Index: Integer): string;
    procedure SetcbReceiptReference(Index: Integer; const Astring: string);
    function  GetftCashBoxIdentification(Index: Integer): string;
    procedure SetftCashBoxIdentification(Index: Integer; const Astring: string);
    function  GetftReceiptIdentification(Index: Integer): string;
    procedure SetftReceiptIdentification(Index: Integer; const Astring: string);
    function  GetftReceiptMoment: TXSDateTime;
    procedure SetftReceiptMoment(const ATXSDateTime: TXSDateTime);
    function  GetftReceiptHeader(Index: Integer): ArrayOfstring;
    procedure SetftReceiptHeader(Index: Integer; const AArrayOfstring: ArrayOfstring);
    function  ftReceiptHeader_Specified(Index: Integer): boolean;
    function  GetftChargeItems(Index: Integer): ArrayOfChargeItem;
    procedure SetftChargeItems(Index: Integer; const AArrayOfChargeItem: ArrayOfChargeItem);
    function  ftChargeItems_Specified(Index: Integer): boolean;
    function  GetftChargeLines(Index: Integer): ArrayOfstring;
    procedure SetftChargeLines(Index: Integer; const AArrayOfstring: ArrayOfstring);
    function  ftChargeLines_Specified(Index: Integer): boolean;
    function  GetftPayItems(Index: Integer): ArrayOfPayItem;
    procedure SetftPayItems(Index: Integer; const AArrayOfPayItem: ArrayOfPayItem);
    function  ftPayItems_Specified(Index: Integer): boolean;
    function  GetftPayLines(Index: Integer): ArrayOfstring;
    procedure SetftPayLines(Index: Integer; const AArrayOfstring: ArrayOfstring);
    function  ftPayLines_Specified(Index: Integer): boolean;
    function  GetftSignatures(Index: Integer): ArrayOfSignaturItem;
    procedure SetftSignatures(Index: Integer; const AArrayOfSignaturItem: ArrayOfSignaturItem);
    function  GetftReceiptFooter(Index: Integer): ArrayOfstring;
    procedure SetftReceiptFooter(Index: Integer; const AArrayOfstring: ArrayOfstring);
    function  ftReceiptFooter_Specified(Index: Integer): boolean;
    function  GetftState: Int64;
    procedure SetftState(const AInt64: Int64);
    function  GetftStateData(Index: Integer): string;
    procedure SetftStateData(Index: Integer; const Astring: string);
    function  ftStateData_Specified(Index: Integer): boolean;
  public
    destructor Destroy; override;
  published
    property ftCashBoxID:             string               Index (IS_NLBL) read GetftCashBoxID write SetftCashBoxID;
    property ftQueueID:               string               Index (IS_NLBL) read GetftQueueID write SetftQueueID;
    property ftQueueItemID:           string               Index (IS_NLBL) read GetftQueueItemID write SetftQueueItemID;
    property ftQueueRow:              Int64                read GetftQueueRow write SetftQueueRow;
    property cbTerminalID:            string               Index (IS_NLBL) read GetcbTerminalID write SetcbTerminalID;
    property cbReceiptReference:      string               Index (IS_NLBL) read GetcbReceiptReference write SetcbReceiptReference;
    property ftCashBoxIdentification: string               Index (IS_NLBL) read GetftCashBoxIdentification write SetftCashBoxIdentification;
    property ftReceiptIdentification: string               Index (IS_NLBL) read GetftReceiptIdentification write SetftReceiptIdentification;
    property ftReceiptMoment:         TXSDateTime          read GetftReceiptMoment write SetftReceiptMoment;
    property ftReceiptHeader:         ArrayOfstring        Index (IS_OPTN or IS_NLBL) read GetftReceiptHeader write SetftReceiptHeader stored ftReceiptHeader_Specified;
    property ftChargeItems:           ArrayOfChargeItem    Index (IS_OPTN or IS_NLBL) read GetftChargeItems write SetftChargeItems stored ftChargeItems_Specified;
    property ftChargeLines:           ArrayOfstring        Index (IS_OPTN or IS_NLBL) read GetftChargeLines write SetftChargeLines stored ftChargeLines_Specified;
    property ftPayItems:              ArrayOfPayItem       Index (IS_OPTN or IS_NLBL) read GetftPayItems write SetftPayItems stored ftPayItems_Specified;
    property ftPayLines:              ArrayOfstring        Index (IS_OPTN or IS_NLBL) read GetftPayLines write SetftPayLines stored ftPayLines_Specified;
    property ftSignatures:            ArrayOfSignaturItem  Index (IS_NLBL) read GetftSignatures write SetftSignatures;
    property ftReceiptFooter:         ArrayOfstring        Index (IS_OPTN or IS_NLBL) read GetftReceiptFooter write SetftReceiptFooter stored ftReceiptFooter_Specified;
    property ftState:                 Int64                read GetftState write SetftState;
    property ftStateData:             string               Index (IS_OPTN or IS_NLBL) read GetftStateData write SetftStateData stored ftStateData_Specified;
  end;



  // ************************************************************************ //
  // XML       : ReceiptResponse, global, <element>
  // Namespace : http://schemas.datacontract.org/2004/07/fiskaltrust.ifPOS.v0
  // ************************************************************************ //
  ReceiptResponse = class(ReceiptResponse2)
  private
  published
  end;


  // ************************************************************************ //
  // Namespace : http://tempuri.org/
  // soapAction: http://tempuri.org/IPOS/%operationName%
  // transport : http://schemas.xmlsoap.org/soap/http
  // style     : document
  // use       : literal
  // binding   : BasicHttpBinding_IPOS
  // service   : worker
  // port      : BasicHttpBinding_IPOS
  // URL       : http://localhost:1200/fiskaltrust
  // ************************************************************************ //
  IPOS = interface(IInvokable)
  ['{E2FA8424-460E-C4F7-2508-000E745AD493}']
    function  Sign(const data: ReceiptRequest2): ReceiptResponse2; stdcall;
    function  Journal(const ftJournalType: Int64; const from: Int64; const to_: Int64): StreamBody; stdcall;
    function  Echo(const message_: string): string; stdcall;
  end;

function GetIPOS(UseWSDL: Boolean=System.False; Addr: string=''; HTTPRIO: THTTPRIO = nil): IPOS;


implementation
  uses System.SysUtils;

function GetIPOS(UseWSDL: Boolean; Addr: string; HTTPRIO: THTTPRIO): IPOS;
const
  defWSDL = 'D:\Downloads\GMS\fiskaltrust.interface.1.0.16298.1022-rc.wsdl';
  defURL  = 'http://localhost:1200/fiskaltrust';
  defSvc  = 'worker';
  defPrt  = 'BasicHttpBinding_IPOS';
var
  RIO: THTTPRIO;
begin
  Result := nil;
  if (Addr = '') then
  begin
    if UseWSDL then
      Addr := defWSDL
    else
      Addr := defURL;
  end;
  if HTTPRIO = nil then
    RIO := THTTPRIO.Create(nil)
  else
    RIO := HTTPRIO;
  try
    Result := (RIO as IPOS);
    if UseWSDL then
    begin
      RIO.WSDLLocation := Addr;
      RIO.Service := defSvc;
      RIO.Port := defPrt;
    end else
      RIO.URL := Addr;
  finally
    if (Result = nil) and (HTTPRIO = nil) then
      RIO.Free;
  end;
end;


function SignaturItem2.GetftSignatureFormat: Int64;
begin
  Result := FftSignatureFormat;
end;

procedure SignaturItem2.SetftSignatureFormat(const AInt64: Int64);
begin
  FftSignatureFormat := AInt64;
end;

function SignaturItem2.GetftSignatureType: Int64;
begin
  Result := FftSignatureType;
end;

procedure SignaturItem2.SetftSignatureType(const AInt64: Int64);
begin
  FftSignatureType := AInt64;
end;

function SignaturItem2.GetCaption(Index: Integer): string;
begin
  Result := FCaption;
end;

procedure SignaturItem2.SetCaption(Index: Integer; const Astring: string);
begin
  FCaption := Astring;
  FCaption_Specified := True;
end;

function SignaturItem2.Caption_Specified(Index: Integer): boolean;
begin
  Result := FCaption_Specified;
end;

function SignaturItem2.GetData(Index: Integer): string;
begin
  Result := FData;
end;

procedure SignaturItem2.SetData(Index: Integer; const Astring: string);
begin
  FData := Astring;
end;

destructor PayItem2.Destroy;
begin
  System.SysUtils.FreeAndNil(FQuantity);
  System.SysUtils.FreeAndNil(FAmount);
  System.SysUtils.FreeAndNil(FMoment);
  inherited Destroy;
end;

function PayItem2.GetPosition(Index: Integer): Int64;
begin
  Result := FPosition;
end;

procedure PayItem2.SetPosition(Index: Integer; const AInt64: Int64);
begin
  FPosition := AInt64;
  FPosition_Specified := True;
end;

function PayItem2.Position_Specified(Index: Integer): boolean;
begin
  Result := FPosition_Specified;
end;

function PayItem2.GetQuantity: TXSDecimal;
begin
  Result := FQuantity;
end;

procedure PayItem2.SetQuantity(const ATXSDecimal: TXSDecimal);
begin
  FQuantity := ATXSDecimal;
end;

function PayItem2.GetDescription(Index: Integer): string;
begin
  Result := FDescription;
end;

procedure PayItem2.SetDescription(Index: Integer; const Astring: string);
begin
  FDescription := Astring;
end;

function PayItem2.GetAmount: TXSDecimal;
begin
  Result := FAmount;
end;

procedure PayItem2.SetAmount(const ATXSDecimal: TXSDecimal);
begin
  FAmount := ATXSDecimal;
end;

function PayItem2.GetftPayItemCase: Int64;
begin
  Result := FftPayItemCase;
end;

procedure PayItem2.SetftPayItemCase(const AInt64: Int64);
begin
  FftPayItemCase := AInt64;
end;

function PayItem2.GetftPayItemCaseData(Index: Integer): string;
begin
  Result := FftPayItemCaseData;
end;

procedure PayItem2.SetftPayItemCaseData(Index: Integer; const Astring: string);
begin
  FftPayItemCaseData := Astring;
  FftPayItemCaseData_Specified := True;
end;

function PayItem2.ftPayItemCaseData_Specified(Index: Integer): boolean;
begin
  Result := FftPayItemCaseData_Specified;
end;

function PayItem2.GetAccountNumber(Index: Integer): string;
begin
  Result := FAccountNumber;
end;

procedure PayItem2.SetAccountNumber(Index: Integer; const Astring: string);
begin
  FAccountNumber := Astring;
  FAccountNumber_Specified := True;
end;

function PayItem2.AccountNumber_Specified(Index: Integer): boolean;
begin
  Result := FAccountNumber_Specified;
end;

function PayItem2.GetCostCenter(Index: Integer): string;
begin
  Result := FCostCenter;
end;

procedure PayItem2.SetCostCenter(Index: Integer; const Astring: string);
begin
  FCostCenter := Astring;
  FCostCenter_Specified := True;
end;

function PayItem2.CostCenter_Specified(Index: Integer): boolean;
begin
  Result := FCostCenter_Specified;
end;

function PayItem2.GetMoneyGroup(Index: Integer): string;
begin
  Result := FMoneyGroup;
end;

procedure PayItem2.SetMoneyGroup(Index: Integer; const Astring: string);
begin
  FMoneyGroup := Astring;
  FMoneyGroup_Specified := True;
end;

function PayItem2.MoneyGroup_Specified(Index: Integer): boolean;
begin
  Result := FMoneyGroup_Specified;
end;

function PayItem2.GetMoneyNumber(Index: Integer): string;
begin
  Result := FMoneyNumber;
end;

procedure PayItem2.SetMoneyNumber(Index: Integer; const Astring: string);
begin
  FMoneyNumber := Astring;
  FMoneyNumber_Specified := True;
end;

function PayItem2.MoneyNumber_Specified(Index: Integer): boolean;
begin
  Result := FMoneyNumber_Specified;
end;

function PayItem2.GetMoment(Index: Integer): TXSDateTime;
begin
  Result := FMoment;
end;

procedure PayItem2.SetMoment(Index: Integer; const ATXSDateTime: TXSDateTime);
begin
  FMoment := ATXSDateTime;
  FMoment_Specified := True;
end;

function PayItem2.Moment_Specified(Index: Integer): boolean;
begin
  Result := FMoment_Specified;
end;

destructor ChargeItem2.Destroy;
begin
  System.SysUtils.FreeAndNil(FQuantity);
  System.SysUtils.FreeAndNil(FAmount);
  System.SysUtils.FreeAndNil(FVATRate);
  System.SysUtils.FreeAndNil(FVATAmount);
  System.SysUtils.FreeAndNil(FUnitQuantity);
  System.SysUtils.FreeAndNil(FUnitPrice);
  System.SysUtils.FreeAndNil(FMoment);
  inherited Destroy;
end;

function ChargeItem2.GetPosition(Index: Integer): Int64;
begin
  Result := FPosition;
end;

procedure ChargeItem2.SetPosition(Index: Integer; const AInt64: Int64);
begin
  FPosition := AInt64;
  FPosition_Specified := True;
end;

function ChargeItem2.Position_Specified(Index: Integer): boolean;
begin
  Result := FPosition_Specified;
end;

function ChargeItem2.GetQuantity: TXSDecimal;
begin
  Result := FQuantity;
end;

procedure ChargeItem2.SetQuantity(const ATXSDecimal: TXSDecimal);
begin
  FQuantity := ATXSDecimal;
end;

function ChargeItem2.GetDescription(Index: Integer): string;
begin
  Result := FDescription;
end;

procedure ChargeItem2.SetDescription(Index: Integer; const Astring: string);
begin
  FDescription := Astring;
end;

function ChargeItem2.GetAmount: TXSDecimal;
begin
  Result := FAmount;
end;

procedure ChargeItem2.SetAmount(const ATXSDecimal: TXSDecimal);
begin
  FAmount := ATXSDecimal;
end;

function ChargeItem2.GetVATRate: TXSDecimal;
begin
  Result := FVATRate;
end;

procedure ChargeItem2.SetVATRate(const ATXSDecimal: TXSDecimal);
begin
  FVATRate := ATXSDecimal;
end;

function ChargeItem2.GetftChargeItemCase: Int64;
begin
  Result := FftChargeItemCase;
end;

procedure ChargeItem2.SetftChargeItemCase(const AInt64: Int64);
begin
  FftChargeItemCase := AInt64;
end;

function ChargeItem2.GetftChargeItemCaseData(Index: Integer): string;
begin
  Result := FftChargeItemCaseData;
end;

procedure ChargeItem2.SetftChargeItemCaseData(Index: Integer; const Astring: string);
begin
  FftChargeItemCaseData := Astring;
  FftChargeItemCaseData_Specified := True;
end;

function ChargeItem2.ftChargeItemCaseData_Specified(Index: Integer): boolean;
begin
  Result := FftChargeItemCaseData_Specified;
end;

function ChargeItem2.GetVATAmount(Index: Integer): TXSDecimal;
begin
  Result := FVATAmount;
end;

procedure ChargeItem2.SetVATAmount(Index: Integer; const ATXSDecimal: TXSDecimal);
begin
  FVATAmount := ATXSDecimal;
  FVATAmount_Specified := True;
end;

function ChargeItem2.VATAmount_Specified(Index: Integer): boolean;
begin
  Result := FVATAmount_Specified;
end;

function ChargeItem2.GetAccountNumber(Index: Integer): string;
begin
  Result := FAccountNumber;
end;

procedure ChargeItem2.SetAccountNumber(Index: Integer; const Astring: string);
begin
  FAccountNumber := Astring;
  FAccountNumber_Specified := True;
end;

function ChargeItem2.AccountNumber_Specified(Index: Integer): boolean;
begin
  Result := FAccountNumber_Specified;
end;

function ChargeItem2.GetCostCenter(Index: Integer): string;
begin
  Result := FCostCenter;
end;

procedure ChargeItem2.SetCostCenter(Index: Integer; const Astring: string);
begin
  FCostCenter := Astring;
  FCostCenter_Specified := True;
end;

function ChargeItem2.CostCenter_Specified(Index: Integer): boolean;
begin
  Result := FCostCenter_Specified;
end;

function ChargeItem2.GetProductGroup(Index: Integer): string;
begin
  Result := FProductGroup;
end;

procedure ChargeItem2.SetProductGroup(Index: Integer; const Astring: string);
begin
  FProductGroup := Astring;
  FProductGroup_Specified := True;
end;

function ChargeItem2.ProductGroup_Specified(Index: Integer): boolean;
begin
  Result := FProductGroup_Specified;
end;

function ChargeItem2.GetProductNumber(Index: Integer): string;
begin
  Result := FProductNumber;
end;

procedure ChargeItem2.SetProductNumber(Index: Integer; const Astring: string);
begin
  FProductNumber := Astring;
  FProductNumber_Specified := True;
end;

function ChargeItem2.ProductNumber_Specified(Index: Integer): boolean;
begin
  Result := FProductNumber_Specified;
end;

function ChargeItem2.GetProductBarcode(Index: Integer): string;
begin
  Result := FProductBarcode;
end;

procedure ChargeItem2.SetProductBarcode(Index: Integer; const Astring: string);
begin
  FProductBarcode := Astring;
  FProductBarcode_Specified := True;
end;

function ChargeItem2.ProductBarcode_Specified(Index: Integer): boolean;
begin
  Result := FProductBarcode_Specified;
end;

function ChargeItem2.GetUnit_(Index: Integer): string;
begin
  Result := FUnit_;
end;

procedure ChargeItem2.SetUnit_(Index: Integer; const Astring: string);
begin
  FUnit_ := Astring;
  FUnit__Specified := True;
end;

function ChargeItem2.Unit__Specified(Index: Integer): boolean;
begin
  Result := FUnit__Specified;
end;

function ChargeItem2.GetUnitQuantity(Index: Integer): TXSDecimal;
begin
  Result := FUnitQuantity;
end;

procedure ChargeItem2.SetUnitQuantity(Index: Integer; const ATXSDecimal: TXSDecimal);
begin
  FUnitQuantity := ATXSDecimal;
  FUnitQuantity_Specified := True;
end;

function ChargeItem2.UnitQuantity_Specified(Index: Integer): boolean;
begin
  Result := FUnitQuantity_Specified;
end;

function ChargeItem2.GetUnitPrice(Index: Integer): TXSDecimal;
begin
  Result := FUnitPrice;
end;

procedure ChargeItem2.SetUnitPrice(Index: Integer; const ATXSDecimal: TXSDecimal);
begin
  FUnitPrice := ATXSDecimal;
  FUnitPrice_Specified := True;
end;

function ChargeItem2.UnitPrice_Specified(Index: Integer): boolean;
begin
  Result := FUnitPrice_Specified;
end;

function ChargeItem2.GetMoment(Index: Integer): TXSDateTime;
begin
  Result := FMoment;
end;

procedure ChargeItem2.SetMoment(Index: Integer; const ATXSDateTime: TXSDateTime);
begin
  FMoment := ATXSDateTime;
  FMoment_Specified := True;
end;

function ChargeItem2.Moment_Specified(Index: Integer): boolean;
begin
  Result := FMoment_Specified;
end;

destructor ReceiptRequest2.Destroy;
var
  I: Integer;
begin
  for I := 0 to System.Length(FcbChargeItems)-1 do
    System.SysUtils.FreeAndNil(FcbChargeItems[I]);
  System.SetLength(FcbChargeItems, 0);
  for I := 0 to System.Length(FcbPayItems)-1 do
    System.SysUtils.FreeAndNil(FcbPayItems[I]);
  System.SetLength(FcbPayItems, 0);
  System.SysUtils.FreeAndNil(FcbReceiptMoment);
  System.SysUtils.FreeAndNil(FcbReceiptAmount);
  inherited Destroy;
end;

function ReceiptRequest2.GetftCashBoxID(Index: Integer): string;
begin
  Result := FftCashBoxID;
end;

procedure ReceiptRequest2.SetftCashBoxID(Index: Integer; const Astring: string);
begin
  FftCashBoxID := Astring;
end;

function ReceiptRequest2.GetftQueueID(Index: Integer): string;
begin
  Result := FftQueueID;
end;

procedure ReceiptRequest2.SetftQueueID(Index: Integer; const Astring: string);
begin
  FftQueueID := Astring;
  FftQueueID_Specified := True;
end;

function ReceiptRequest2.ftQueueID_Specified(Index: Integer): boolean;
begin
  Result := FftQueueID_Specified;
end;

function ReceiptRequest2.GetftPosSystemId(Index: Integer): string;
begin
  Result := FftPosSystemId;
end;

procedure ReceiptRequest2.SetftPosSystemId(Index: Integer; const Astring: string);
begin
  FftPosSystemId := Astring;
  FftPosSystemId_Specified := True;
end;

function ReceiptRequest2.ftPosSystemId_Specified(Index: Integer): boolean;
begin
  Result := FftPosSystemId_Specified;
end;

function ReceiptRequest2.GetcbTerminalID(Index: Integer): string;
begin
  Result := FcbTerminalID;
end;

procedure ReceiptRequest2.SetcbTerminalID(Index: Integer; const Astring: string);
begin
  FcbTerminalID := Astring;
end;

function ReceiptRequest2.GetcbReceiptReference(Index: Integer): string;
begin
  Result := FcbReceiptReference;
end;

procedure ReceiptRequest2.SetcbReceiptReference(Index: Integer; const Astring: string);
begin
  FcbReceiptReference := Astring;
end;

function ReceiptRequest2.GetcbReceiptMoment: TXSDateTime;
begin
  Result := FcbReceiptMoment;
end;

procedure ReceiptRequest2.SetcbReceiptMoment(const ATXSDateTime: TXSDateTime);
begin
  FcbReceiptMoment := ATXSDateTime;
end;

function ReceiptRequest2.GetcbChargeItems(Index: Integer): ArrayOfChargeItem;
begin
  Result := FcbChargeItems;
end;

procedure ReceiptRequest2.SetcbChargeItems(Index: Integer; const AArrayOfChargeItem: ArrayOfChargeItem);
begin
  FcbChargeItems := AArrayOfChargeItem;
end;

function ReceiptRequest2.GetcbPayItems(Index: Integer): ArrayOfPayItem;
begin
  Result := FcbPayItems;
end;

procedure ReceiptRequest2.SetcbPayItems(Index: Integer; const AArrayOfPayItem: ArrayOfPayItem);
begin
  FcbPayItems := AArrayOfPayItem;
end;

function ReceiptRequest2.GetftReceiptCase: Int64;
begin
  Result := FftReceiptCase;
end;

procedure ReceiptRequest2.SetftReceiptCase(const AInt64: Int64);
begin
  FftReceiptCase := AInt64;
end;

function ReceiptRequest2.GetftReceiptCaseData(Index: Integer): string;
begin
  Result := FftReceiptCaseData;
end;

procedure ReceiptRequest2.SetftReceiptCaseData(Index: Integer; const Astring: string);
begin
  FftReceiptCaseData := Astring;
  FftReceiptCaseData_Specified := True;
end;

function ReceiptRequest2.ftReceiptCaseData_Specified(Index: Integer): boolean;
begin
  Result := FftReceiptCaseData_Specified;
end;

function ReceiptRequest2.GetcbReceiptAmount(Index: Integer): TXSDecimal;
begin
  Result := FcbReceiptAmount;
end;

procedure ReceiptRequest2.SetcbReceiptAmount(Index: Integer; const ATXSDecimal: TXSDecimal);
begin
  FcbReceiptAmount := ATXSDecimal;
  FcbReceiptAmount_Specified := True;
end;

function ReceiptRequest2.cbReceiptAmount_Specified(Index: Integer): boolean;
begin
  Result := FcbReceiptAmount_Specified;
end;

function ReceiptRequest2.GetcbUser(Index: Integer): string;
begin
  Result := FcbUser;
end;

procedure ReceiptRequest2.SetcbUser(Index: Integer; const Astring: string);
begin
  FcbUser := Astring;
  FcbUser_Specified := True;
end;

function ReceiptRequest2.cbUser_Specified(Index: Integer): boolean;
begin
  Result := FcbUser_Specified;
end;

function ReceiptRequest2.GetcbArea(Index: Integer): string;
begin
  Result := FcbArea;
end;

procedure ReceiptRequest2.SetcbArea(Index: Integer; const Astring: string);
begin
  FcbArea := Astring;
  FcbArea_Specified := True;
end;

function ReceiptRequest2.cbArea_Specified(Index: Integer): boolean;
begin
  Result := FcbArea_Specified;
end;

function ReceiptRequest2.GetcbCustomer(Index: Integer): string;
begin
  Result := FcbCustomer;
end;

procedure ReceiptRequest2.SetcbCustomer(Index: Integer; const Astring: string);
begin
  FcbCustomer := Astring;
  FcbCustomer_Specified := True;
end;

function ReceiptRequest2.cbCustomer_Specified(Index: Integer): boolean;
begin
  Result := FcbCustomer_Specified;
end;

function ReceiptRequest2.GetcbSettlement(Index: Integer): string;
begin
  Result := FcbSettlement;
end;

procedure ReceiptRequest2.SetcbSettlement(Index: Integer; const Astring: string);
begin
  FcbSettlement := Astring;
  FcbSettlement_Specified := True;
end;

function ReceiptRequest2.cbSettlement_Specified(Index: Integer): boolean;
begin
  Result := FcbSettlement_Specified;
end;

function ReceiptRequest2.GetcbPreviousReceiptReference(Index: Integer): string;
begin
  Result := FcbPreviousReceiptReference;
end;

procedure ReceiptRequest2.SetcbPreviousReceiptReference(Index: Integer; const Astring: string);
begin
  FcbPreviousReceiptReference := Astring;
  FcbPreviousReceiptReference_Specified := True;
end;

function ReceiptRequest2.cbPreviousReceiptReference_Specified(Index: Integer): boolean;
begin
  Result := FcbPreviousReceiptReference_Specified;
end;

destructor ReceiptResponse2.Destroy;
var
  I: Integer;
begin
  for I := 0 to System.Length(FftChargeItems)-1 do
    System.SysUtils.FreeAndNil(FftChargeItems[I]);
  System.SetLength(FftChargeItems, 0);
  for I := 0 to System.Length(FftPayItems)-1 do
    System.SysUtils.FreeAndNil(FftPayItems[I]);
  System.SetLength(FftPayItems, 0);
  for I := 0 to System.Length(FftSignatures)-1 do
    System.SysUtils.FreeAndNil(FftSignatures[I]);
  System.SetLength(FftSignatures, 0);
  System.SysUtils.FreeAndNil(FftReceiptMoment);
  inherited Destroy;
end;

function ReceiptResponse2.GetftCashBoxID(Index: Integer): string;
begin
  Result := FftCashBoxID;
end;

procedure ReceiptResponse2.SetftCashBoxID(Index: Integer; const Astring: string);
begin
  FftCashBoxID := Astring;
end;

function ReceiptResponse2.GetftQueueID(Index: Integer): string;
begin
  Result := FftQueueID;
end;

procedure ReceiptResponse2.SetftQueueID(Index: Integer; const Astring: string);
begin
  FftQueueID := Astring;
end;

function ReceiptResponse2.GetftQueueItemID(Index: Integer): string;
begin
  Result := FftQueueItemID;
end;

procedure ReceiptResponse2.SetftQueueItemID(Index: Integer; const Astring: string);
begin
  FftQueueItemID := Astring;
end;

function ReceiptResponse2.GetftQueueRow: Int64;
begin
  Result := FftQueueRow;
end;

procedure ReceiptResponse2.SetftQueueRow(const AInt64: Int64);
begin
  FftQueueRow := AInt64;
end;

function ReceiptResponse2.GetcbTerminalID(Index: Integer): string;
begin
  Result := FcbTerminalID;
end;

procedure ReceiptResponse2.SetcbTerminalID(Index: Integer; const Astring: string);
begin
  FcbTerminalID := Astring;
end;

function ReceiptResponse2.GetcbReceiptReference(Index: Integer): string;
begin
  Result := FcbReceiptReference;
end;

procedure ReceiptResponse2.SetcbReceiptReference(Index: Integer; const Astring: string);
begin
  FcbReceiptReference := Astring;
end;

function ReceiptResponse2.GetftCashBoxIdentification(Index: Integer): string;
begin
  Result := FftCashBoxIdentification;
end;

procedure ReceiptResponse2.SetftCashBoxIdentification(Index: Integer; const Astring: string);
begin
  FftCashBoxIdentification := Astring;
end;

function ReceiptResponse2.GetftReceiptIdentification(Index: Integer): string;
begin
  Result := FftReceiptIdentification;
end;

procedure ReceiptResponse2.SetftReceiptIdentification(Index: Integer; const Astring: string);
begin
  FftReceiptIdentification := Astring;
end;

function ReceiptResponse2.GetftReceiptMoment: TXSDateTime;
begin
  Result := FftReceiptMoment;
end;

procedure ReceiptResponse2.SetftReceiptMoment(const ATXSDateTime: TXSDateTime);
begin
  FftReceiptMoment := ATXSDateTime;
end;

function ReceiptResponse2.GetftReceiptHeader(Index: Integer): ArrayOfstring;
begin
  Result := FftReceiptHeader;
end;

procedure ReceiptResponse2.SetftReceiptHeader(Index: Integer; const AArrayOfstring: ArrayOfstring);
begin
  FftReceiptHeader := AArrayOfstring;
  FftReceiptHeader_Specified := True;
end;

function ReceiptResponse2.ftReceiptHeader_Specified(Index: Integer): boolean;
begin
  Result := FftReceiptHeader_Specified;
end;

function ReceiptResponse2.GetftChargeItems(Index: Integer): ArrayOfChargeItem;
begin
  Result := FftChargeItems;
end;

procedure ReceiptResponse2.SetftChargeItems(Index: Integer; const AArrayOfChargeItem: ArrayOfChargeItem);
begin
  FftChargeItems := AArrayOfChargeItem;
  FftChargeItems_Specified := True;
end;

function ReceiptResponse2.ftChargeItems_Specified(Index: Integer): boolean;
begin
  Result := FftChargeItems_Specified;
end;

function ReceiptResponse2.GetftChargeLines(Index: Integer): ArrayOfstring;
begin
  Result := FftChargeLines;
end;

procedure ReceiptResponse2.SetftChargeLines(Index: Integer; const AArrayOfstring: ArrayOfstring);
begin
  FftChargeLines := AArrayOfstring;
  FftChargeLines_Specified := True;
end;

function ReceiptResponse2.ftChargeLines_Specified(Index: Integer): boolean;
begin
  Result := FftChargeLines_Specified;
end;

function ReceiptResponse2.GetftPayItems(Index: Integer): ArrayOfPayItem;
begin
  Result := FftPayItems;
end;

procedure ReceiptResponse2.SetftPayItems(Index: Integer; const AArrayOfPayItem: ArrayOfPayItem);
begin
  FftPayItems := AArrayOfPayItem;
  FftPayItems_Specified := True;
end;

function ReceiptResponse2.ftPayItems_Specified(Index: Integer): boolean;
begin
  Result := FftPayItems_Specified;
end;

function ReceiptResponse2.GetftPayLines(Index: Integer): ArrayOfstring;
begin
  Result := FftPayLines;
end;

procedure ReceiptResponse2.SetftPayLines(Index: Integer; const AArrayOfstring: ArrayOfstring);
begin
  FftPayLines := AArrayOfstring;
  FftPayLines_Specified := True;
end;

function ReceiptResponse2.ftPayLines_Specified(Index: Integer): boolean;
begin
  Result := FftPayLines_Specified;
end;

function ReceiptResponse2.GetftSignatures(Index: Integer): ArrayOfSignaturItem;
begin
  Result := FftSignatures;
end;

procedure ReceiptResponse2.SetftSignatures(Index: Integer; const AArrayOfSignaturItem: ArrayOfSignaturItem);
begin
  FftSignatures := AArrayOfSignaturItem;
end;

function ReceiptResponse2.GetftReceiptFooter(Index: Integer): ArrayOfstring;
begin
  Result := FftReceiptFooter;
end;

procedure ReceiptResponse2.SetftReceiptFooter(Index: Integer; const AArrayOfstring: ArrayOfstring);
begin
  FftReceiptFooter := AArrayOfstring;
  FftReceiptFooter_Specified := True;
end;

function ReceiptResponse2.ftReceiptFooter_Specified(Index: Integer): boolean;
begin
  Result := FftReceiptFooter_Specified;
end;

function ReceiptResponse2.GetftState: Int64;
begin
  Result := FftState;
end;

procedure ReceiptResponse2.SetftState(const AInt64: Int64);
begin
  FftState := AInt64;
end;

function ReceiptResponse2.GetftStateData(Index: Integer): string;
begin
  Result := FftStateData;
end;

procedure ReceiptResponse2.SetftStateData(Index: Integer; const Astring: string);
begin
  FftStateData := Astring;
  FftStateData_Specified := True;
end;

function ReceiptResponse2.ftStateData_Specified(Index: Integer): boolean;
begin
  Result := FftStateData_Specified;
end;



initialization
  { IPOS }
  InvRegistry.RegisterInterface(TypeInfo(IPOS), 'http://tempuri.org/', 'utf-8');
  InvRegistry.RegisterDefaultSOAPAction(TypeInfo(IPOS), 'http://tempuri.org/IPOS/%operationName%');
  InvRegistry.RegisterInvokeOptions(TypeInfo(IPOS), ioDocument);
  { IPOS.Sign }
  InvRegistry.RegisterMethodInfo(TypeInfo(IPOS), 'Sign', '',
                                 '[ReturnName="SignResult"]', IS_OPTN or IS_NLBL);
  InvRegistry.RegisterParamInfo(TypeInfo(IPOS), 'Sign', 'data', '',
                                '[Namespace="http://schemas.datacontract.org/2004/07/fiskaltrust.ifPOS.v0"]', IS_NLBL);
  InvRegistry.RegisterParamInfo(TypeInfo(IPOS), 'Sign', 'SignResult', '',
                                '[Namespace="http://schemas.datacontract.org/2004/07/fiskaltrust.ifPOS.v0"]', IS_NLBL);
  { IPOS.Journal }
  InvRegistry.RegisterMethodInfo(TypeInfo(IPOS), 'Journal', '',
                                 '[ReturnName="JournalResult"]');
  InvRegistry.RegisterParamInfo(TypeInfo(IPOS), 'Journal', 'to_', 'to', '');
  InvRegistry.RegisterParamInfo(TypeInfo(IPOS), 'Journal', 'JournalResult', '',
                                '[Namespace="http://schemas.microsoft.com/Message"]');
  { IPOS.Echo }
  InvRegistry.RegisterMethodInfo(TypeInfo(IPOS), 'Echo', '',
                                 '[ReturnName="EchoResult"]', IS_OPTN or IS_NLBL);
  InvRegistry.RegisterParamInfo(TypeInfo(IPOS), 'Echo', 'message_', 'message',
                                '', IS_NLBL);
  InvRegistry.RegisterParamInfo(TypeInfo(IPOS), 'Echo', 'EchoResult', '',
                                '', IS_NLBL);
  RemClassRegistry.RegisterXSInfo(TypeInfo(ArrayOfSignaturItem), 'http://schemas.datacontract.org/2004/07/fiskaltrust.ifPOS.v0', 'ArrayOfSignaturItem');
  RemClassRegistry.RegisterXSInfo(TypeInfo(StreamBody), 'http://schemas.microsoft.com/Message', 'StreamBody');
  RemClassRegistry.RegisterXSClass(SignaturItem2, 'http://schemas.datacontract.org/2004/07/fiskaltrust.ifPOS.v0', 'SignaturItem2', 'SignaturItem');
  RemClassRegistry.RegisterXSClass(SignaturItem, 'http://schemas.datacontract.org/2004/07/fiskaltrust.ifPOS.v0', 'SignaturItem');
  RemClassRegistry.RegisterXSClass(PayItem2, 'http://schemas.datacontract.org/2004/07/fiskaltrust.ifPOS.v0', 'PayItem2', 'PayItem');
  RemClassRegistry.RegisterXSClass(PayItem, 'http://schemas.datacontract.org/2004/07/fiskaltrust.ifPOS.v0', 'PayItem');
  RemClassRegistry.RegisterXSInfo(TypeInfo(ArrayOfstring), 'http://schemas.microsoft.com/2003/10/Serialization/Arrays', 'ArrayOfstring');
  RemClassRegistry.RegisterXSClass(ChargeItem2, 'http://schemas.datacontract.org/2004/07/fiskaltrust.ifPOS.v0', 'ChargeItem2', 'ChargeItem');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(ChargeItem2), 'Unit_', '[ExtName="Unit"]');
  RemClassRegistry.RegisterXSClass(ChargeItem, 'http://schemas.datacontract.org/2004/07/fiskaltrust.ifPOS.v0', 'ChargeItem');
  RemClassRegistry.RegisterXSInfo(TypeInfo(ArrayOfChargeItem), 'http://schemas.datacontract.org/2004/07/fiskaltrust.ifPOS.v0', 'ArrayOfChargeItem');
  RemClassRegistry.RegisterXSInfo(TypeInfo(ArrayOfPayItem), 'http://schemas.datacontract.org/2004/07/fiskaltrust.ifPOS.v0', 'ArrayOfPayItem');
  RemClassRegistry.RegisterXSClass(ReceiptRequest2, 'http://schemas.datacontract.org/2004/07/fiskaltrust.ifPOS.v0', 'ReceiptRequest2', 'ReceiptRequest');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(ReceiptRequest2), 'cbChargeItems', '[ArrayItemName="ChargeItem"]');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(ReceiptRequest2), 'cbPayItems', '[ArrayItemName="PayItem"]');
  RemClassRegistry.RegisterXSClass(ReceiptRequest, 'http://schemas.datacontract.org/2004/07/fiskaltrust.ifPOS.v0', 'ReceiptRequest');
  RemClassRegistry.RegisterXSClass(ReceiptResponse2, 'http://schemas.datacontract.org/2004/07/fiskaltrust.ifPOS.v0', 'ReceiptResponse2', 'ReceiptResponse');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(ReceiptResponse2), 'ftReceiptHeader', '[ArrayItemName="string"]');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(ReceiptResponse2), 'ftChargeItems', '[ArrayItemName="ChargeItem"]');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(ReceiptResponse2), 'ftChargeLines', '[ArrayItemName="string"]');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(ReceiptResponse2), 'ftPayItems', '[ArrayItemName="PayItem"]');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(ReceiptResponse2), 'ftPayLines', '[ArrayItemName="string"]');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(ReceiptResponse2), 'ftSignatures', '[ArrayItemName="SignaturItem"]');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(ReceiptResponse2), 'ftReceiptFooter', '[ArrayItemName="string"]');
  RemClassRegistry.RegisterXSClass(ReceiptResponse, 'http://schemas.datacontract.org/2004/07/fiskaltrust.ifPOS.v0', 'ReceiptResponse');

end.