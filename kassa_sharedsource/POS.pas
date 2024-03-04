// ************************************************************************ //
// Die in dieser Datei deklarierten Typen wurden aus Daten generiert, die aus 
// unten beschriebener WSDL-Datei stammen:
// WSDL     : http://192.168.0.11:1204/fiskaltrust/POS?wsdl

//  >Importieren : http://192.168.0.11:1204/fiskaltrust/POS?wsdl:0//  >Importieren : http://192.168.0.11:1204/fiskaltrust/POS?xsd=xsd0//  >Importieren : http://192.168.0.11:1204/fiskaltrust/POS?xsd=xsd2//  >Importieren : http://192.168.0.11:1204/fiskaltrust/POS?xsd=xsd3//  >Importieren : http://192.168.0.11:1204/fiskaltrust/POS?xsd=xsd4//  >Importieren : http://192.168.0.11:1204/fiskaltrust/POS?xsd=xsd1// Codierung : utf-8// Version  : 1.0// (13.01.2016 16:55:45 - - $Rev: 7300 $)
// ************************************************************************ //

unit POS;

interface

uses InvokeRegistry, SOAPHTTPClient, Types, XSBuiltIns;

const
  IS_OPTN = $0001;
  IS_UNBD = $0002;
  IS_NLBL = $0004;


type

  // ************************************************************************ //
  // Die folgenden Typen, auf die im WSDL-Dokument Bezug genommen wird, sind in dieser Datei
  // nicht repräsentiert. Sie sind entweder Aliase(@) anderer repräsentierter Typen oder auf sie wurde Bezug genommen,
  // aber in diesem Dokument nicht deklariert (!). Die Typen aus letzterer Kategorie
  // sind normalerweise mit vordefinierten/bekannten XML- oder Borland-Typen verbunden; sie könnten aber auch ein Anzeichen 
  // für ein falsches WSDL-Dokument sein, das einen Schema-Typ nicht deklariert oder importiert..
  // ************************************************************************ //
  // !:string          - "http://www.w3.org/2001/XMLSchema"[Gbl]
  // !:dateTime        - "http://www.w3.org/2001/XMLSchema"[Gbl]
  // !:long            - "http://www.w3.org/2001/XMLSchema"[Gbl]
  // !:decimal         - "http://www.w3.org/2001/XMLSchema"[Gbl]
  // !:int             - "http://www.w3.org/2001/XMLSchema"[Gbl]

  ReceiptRequest       = class;                 { "http://schemas.datacontract.org/2004/07/fiskaltrust.ifPOS.v0"[GblCplx] }
  ChargeItem           = class;                 { "http://schemas.datacontract.org/2004/07/fiskaltrust.ifPOS.v0"[GblCplx] }
  PayItem              = class;                 { "http://schemas.datacontract.org/2004/07/fiskaltrust.ifPOS.v0"[GblCplx] }
  ReceiptResponse      = class;                 { "http://schemas.datacontract.org/2004/07/fiskaltrust.ifPOS.v0"[GblCplx] }
  SignaturItem         = class;                 { "http://schemas.datacontract.org/2004/07/fiskaltrust.ifPOS.v0"[GblCplx] }
  ReceiptRequest2      = class;                 { "http://schemas.datacontract.org/2004/07/fiskaltrust.ifPOS.v0"[GblElm] }
  ChargeItem2          = class;                 { "http://schemas.datacontract.org/2004/07/fiskaltrust.ifPOS.v0"[GblElm] }
  PayItem2             = class;                 { "http://schemas.datacontract.org/2004/07/fiskaltrust.ifPOS.v0"[GblElm] }
  ReceiptResponse2     = class;                 { "http://schemas.datacontract.org/2004/07/fiskaltrust.ifPOS.v0"[GblElm] }
  SignaturItem2        = class;                 { "http://schemas.datacontract.org/2004/07/fiskaltrust.ifPOS.v0"[GblElm] }
  person               = class;                 { "http://schemas.datacontract.org/2004/07/fiskaltrust.service"[GblCplx] }
  person2              = class;                 { "http://schemas.datacontract.org/2004/07/fiskaltrust.service"[GblElm] }
  GetEcho              = class;                 { "http://tempuri.org/"[GblElm] }
  GetEchoResponse      = class;                 { "http://tempuri.org/"[GblElm] }
  PostJsonEcho         = class;                 { "http://tempuri.org/"[GblElm] }
  PostJsonEchoResponse = class;                 { "http://tempuri.org/"[GblElm] }
  PostXmlEcho          = class;                 { "http://tempuri.org/"[GblElm] }
  PostXmlEchoResponse  = class;                 { "http://tempuri.org/"[GblElm] }
  PostAnyEcho          = class;                 { "http://tempuri.org/"[GblElm] }
  PostAnyEchoResponse  = class;                 { "http://tempuri.org/"[GblElm] }
  PostJsonSign         = class;                 { "http://tempuri.org/"[GblElm] }
  PostJsonSignResponse = class;                 { "http://tempuri.org/"[GblElm] }
  PostXmlSign          = class;                 { "http://tempuri.org/"[GblElm] }
  PostXmlSignResponse  = class;                 { "http://tempuri.org/"[GblElm] }
  PostAnySign          = class;                 { "http://tempuri.org/"[GblElm] }
  PostAnySignResponse  = class;                 { "http://tempuri.org/"[GblElm] }
  PostPerson           = class;                 { "http://tempuri.org/"[GblElm] }
  PostPersonResponse   = class;                 { "http://tempuri.org/"[GblElm] }

  ArrayOfstring = array of WideString;          { "http://schemas.microsoft.com/2003/10/Serialization/Arrays"[GblCplx] }
  ArrayOfChargeItem = array of ChargeItem;      { "http://schemas.datacontract.org/2004/07/fiskaltrust.ifPOS.v0"[GblCplx] }
  ArrayOfPayItem = array of PayItem;            { "http://schemas.datacontract.org/2004/07/fiskaltrust.ifPOS.v0"[GblCplx] }


  // ************************************************************************ //
  // XML       : ReceiptRequest, global, <complexType>
  // Namespace : http://schemas.datacontract.org/2004/07/fiskaltrust.ifPOS.v0
  // ************************************************************************ //
  ReceiptRequest = class(TRemotable)
  private
    FftCashBoxID: WideString;
    FcbTerminalID: WideString;
    FcbReceiptReference: WideString;
    FcbReceiptMoment: TXSDateTime;
    FcbChargeItems: ArrayOfChargeItem;
    FcbPayItems: ArrayOfPayItem;
    FftReceiptCase: Int64;
    FftReceiptCaseData: WideString;
    FftReceiptCaseData_Specified: boolean;
    FcbReceiptAmount: TXSDecimal;
    FcbReceiptAmount_Specified: boolean;
    FcbUser: WideString;
    FcbUser_Specified: boolean;
    FcbArea: WideString;
    FcbArea_Specified: boolean;
    FcbCustomer: WideString;
    FcbCustomer_Specified: boolean;
    FcbSettlement: WideString;
    FcbSettlement_Specified: boolean;
    procedure SetftReceiptCaseData(Index: Integer; const AWideString: WideString);
    function  ftReceiptCaseData_Specified(Index: Integer): boolean;
    procedure SetcbReceiptAmount(Index: Integer; const ATXSDecimal: TXSDecimal);
    function  cbReceiptAmount_Specified(Index: Integer): boolean;
    procedure SetcbUser(Index: Integer; const AWideString: WideString);
    function  cbUser_Specified(Index: Integer): boolean;
    procedure SetcbArea(Index: Integer; const AWideString: WideString);
    function  cbArea_Specified(Index: Integer): boolean;
    procedure SetcbCustomer(Index: Integer; const AWideString: WideString);
    function  cbCustomer_Specified(Index: Integer): boolean;
    procedure SetcbSettlement(Index: Integer; const AWideString: WideString);
    function  cbSettlement_Specified(Index: Integer): boolean;
  public
    destructor Destroy; override;
  published
    property ftCashBoxID:        WideString         Index (IS_NLBL) read FftCashBoxID write FftCashBoxID;
    property cbTerminalID:       WideString         Index (IS_NLBL) read FcbTerminalID write FcbTerminalID;
    property cbReceiptReference: WideString         Index (IS_NLBL) read FcbReceiptReference write FcbReceiptReference;
    property cbReceiptMoment:    TXSDateTime        read FcbReceiptMoment write FcbReceiptMoment;
    property cbChargeItems:      ArrayOfChargeItem  Index (IS_NLBL) read FcbChargeItems write FcbChargeItems;
    property cbPayItems:         ArrayOfPayItem     Index (IS_NLBL) read FcbPayItems write FcbPayItems;
    property ftReceiptCase:      Int64              read FftReceiptCase write FftReceiptCase;
    property ftReceiptCaseData:  WideString         Index (IS_OPTN or IS_NLBL) read FftReceiptCaseData write SetftReceiptCaseData stored ftReceiptCaseData_Specified;
    property cbReceiptAmount:    TXSDecimal         Index (IS_OPTN or IS_NLBL) read FcbReceiptAmount write SetcbReceiptAmount stored cbReceiptAmount_Specified;
    property cbUser:             WideString         Index (IS_OPTN or IS_NLBL) read FcbUser write SetcbUser stored cbUser_Specified;
    property cbArea:             WideString         Index (IS_OPTN or IS_NLBL) read FcbArea write SetcbArea stored cbArea_Specified;
    property cbCustomer:         WideString         Index (IS_OPTN or IS_NLBL) read FcbCustomer write SetcbCustomer stored cbCustomer_Specified;
    property cbSettlement:       WideString         Index (IS_OPTN or IS_NLBL) read FcbSettlement write SetcbSettlement stored cbSettlement_Specified;
  end;



  // ************************************************************************ //
  // XML       : ChargeItem, global, <complexType>
  // Namespace : http://schemas.datacontract.org/2004/07/fiskaltrust.ifPOS.v0
  // ************************************************************************ //
  ChargeItem = class(TRemotable)
  private
    FQuantity: TXSDecimal;
    FDescription: WideString;
    FAmount: TXSDecimal;
    FVATRate: TXSDecimal;
    FftChargeItemCase: Int64;
    FftChargeItemCaseData: WideString;
    FftChargeItemCaseData_Specified: boolean;
    FVATAmount: TXSDecimal;
    FVATAmount_Specified: boolean;
    FAccountNumber: WideString;
    FAccountNumber_Specified: boolean;
    FCostCenter: WideString;
    FCostCenter_Specified: boolean;
    FProductGroup: WideString;
    FProductGroup_Specified: boolean;
    FProductNumber: WideString;
    FProductNumber_Specified: boolean;
    FProductBarcode: WideString;
    FProductBarcode_Specified: boolean;
    FUnit_: WideString;
    FUnit__Specified: boolean;
    FUnitQuantity: TXSDecimal;
    FUnitQuantity_Specified: boolean;
    FUnitPrice: TXSDecimal;
    FUnitPrice_Specified: boolean;
    FMoment: TXSDateTime;
    FMoment_Specified: boolean;
    procedure SetftChargeItemCaseData(Index: Integer; const AWideString: WideString);
    function  ftChargeItemCaseData_Specified(Index: Integer): boolean;
    procedure SetVATAmount(Index: Integer; const ATXSDecimal: TXSDecimal);
    function  VATAmount_Specified(Index: Integer): boolean;
    procedure SetAccountNumber(Index: Integer; const AWideString: WideString);
    function  AccountNumber_Specified(Index: Integer): boolean;
    procedure SetCostCenter(Index: Integer; const AWideString: WideString);
    function  CostCenter_Specified(Index: Integer): boolean;
    procedure SetProductGroup(Index: Integer; const AWideString: WideString);
    function  ProductGroup_Specified(Index: Integer): boolean;
    procedure SetProductNumber(Index: Integer; const AWideString: WideString);
    function  ProductNumber_Specified(Index: Integer): boolean;
    procedure SetProductBarcode(Index: Integer; const AWideString: WideString);
    function  ProductBarcode_Specified(Index: Integer): boolean;
    procedure SetUnit_(Index: Integer; const AWideString: WideString);
    function  Unit__Specified(Index: Integer): boolean;
    procedure SetUnitQuantity(Index: Integer; const ATXSDecimal: TXSDecimal);
    function  UnitQuantity_Specified(Index: Integer): boolean;
    procedure SetUnitPrice(Index: Integer; const ATXSDecimal: TXSDecimal);
    function  UnitPrice_Specified(Index: Integer): boolean;
    procedure SetMoment(Index: Integer; const ATXSDateTime: TXSDateTime);
    function  Moment_Specified(Index: Integer): boolean;
  public
    destructor Destroy; override;
  published
    property Quantity:             TXSDecimal   read FQuantity write FQuantity;
    property Description:          WideString   Index (IS_NLBL) read FDescription write FDescription;
    property Amount:               TXSDecimal   read FAmount write FAmount;
    property VATRate:              TXSDecimal   read FVATRate write FVATRate;
    property ftChargeItemCase:     Int64        read FftChargeItemCase write FftChargeItemCase;
    property ftChargeItemCaseData: WideString   Index (IS_OPTN or IS_NLBL) read FftChargeItemCaseData write SetftChargeItemCaseData stored ftChargeItemCaseData_Specified;
    property VATAmount:            TXSDecimal   Index (IS_OPTN or IS_NLBL) read FVATAmount write SetVATAmount stored VATAmount_Specified;
    property AccountNumber:        WideString   Index (IS_OPTN or IS_NLBL) read FAccountNumber write SetAccountNumber stored AccountNumber_Specified;
    property CostCenter:           WideString   Index (IS_OPTN or IS_NLBL) read FCostCenter write SetCostCenter stored CostCenter_Specified;
    property ProductGroup:         WideString   Index (IS_OPTN or IS_NLBL) read FProductGroup write SetProductGroup stored ProductGroup_Specified;
    property ProductNumber:        WideString   Index (IS_OPTN or IS_NLBL) read FProductNumber write SetProductNumber stored ProductNumber_Specified;
    property ProductBarcode:       WideString   Index (IS_OPTN or IS_NLBL) read FProductBarcode write SetProductBarcode stored ProductBarcode_Specified;
    property Unit_:                WideString   Index (IS_OPTN or IS_NLBL) read FUnit_ write SetUnit_ stored Unit__Specified;
    property UnitQuantity:         TXSDecimal   Index (IS_OPTN or IS_NLBL) read FUnitQuantity write SetUnitQuantity stored UnitQuantity_Specified;
    property UnitPrice:            TXSDecimal   Index (IS_OPTN or IS_NLBL) read FUnitPrice write SetUnitPrice stored UnitPrice_Specified;
    property Moment:               TXSDateTime  Index (IS_OPTN or IS_NLBL) read FMoment write SetMoment stored Moment_Specified;
  end;



  // ************************************************************************ //
  // XML       : PayItem, global, <complexType>
  // Namespace : http://schemas.datacontract.org/2004/07/fiskaltrust.ifPOS.v0
  // ************************************************************************ //
  PayItem = class(TRemotable)
  private
    FQuantity: TXSDecimal;
    FDescription: WideString;
    FAmount: TXSDecimal;
    FftPayItemCase: Int64;
    FftPayItemCaseData: WideString;
    FftPayItemCaseData_Specified: boolean;
    FAccountNumber: WideString;
    FAccountNumber_Specified: boolean;
    FCostCenter: WideString;
    FCostCenter_Specified: boolean;
    FMoneyGroup: WideString;
    FMoneyGroup_Specified: boolean;
    FMoneyNumber: WideString;
    FMoneyNumber_Specified: boolean;
    FMoment: TXSDateTime;
    FMoment_Specified: boolean;
    procedure SetftPayItemCaseData(Index: Integer; const AWideString: WideString);
    function  ftPayItemCaseData_Specified(Index: Integer): boolean;
    procedure SetAccountNumber(Index: Integer; const AWideString: WideString);
    function  AccountNumber_Specified(Index: Integer): boolean;
    procedure SetCostCenter(Index: Integer; const AWideString: WideString);
    function  CostCenter_Specified(Index: Integer): boolean;
    procedure SetMoneyGroup(Index: Integer; const AWideString: WideString);
    function  MoneyGroup_Specified(Index: Integer): boolean;
    procedure SetMoneyNumber(Index: Integer; const AWideString: WideString);
    function  MoneyNumber_Specified(Index: Integer): boolean;
    procedure SetMoment(Index: Integer; const ATXSDateTime: TXSDateTime);
    function  Moment_Specified(Index: Integer): boolean;
  public
    destructor Destroy; override;
  published
    property Quantity:          TXSDecimal   read FQuantity write FQuantity;
    property Description:       WideString   Index (IS_NLBL) read FDescription write FDescription;
    property Amount:            TXSDecimal   read FAmount write FAmount;
    property ftPayItemCase:     Int64        read FftPayItemCase write FftPayItemCase;
    property ftPayItemCaseData: WideString   Index (IS_OPTN or IS_NLBL) read FftPayItemCaseData write SetftPayItemCaseData stored ftPayItemCaseData_Specified;
    property AccountNumber:     WideString   Index (IS_OPTN or IS_NLBL) read FAccountNumber write SetAccountNumber stored AccountNumber_Specified;
    property CostCenter:        WideString   Index (IS_OPTN or IS_NLBL) read FCostCenter write SetCostCenter stored CostCenter_Specified;
    property MoneyGroup:        WideString   Index (IS_OPTN or IS_NLBL) read FMoneyGroup write SetMoneyGroup stored MoneyGroup_Specified;
    property MoneyNumber:       WideString   Index (IS_OPTN or IS_NLBL) read FMoneyNumber write SetMoneyNumber stored MoneyNumber_Specified;
    property Moment:            TXSDateTime  Index (IS_OPTN or IS_NLBL) read FMoment write SetMoment stored Moment_Specified;
  end;

  ArrayOfSignaturItem = array of SignaturItem;   { "http://schemas.datacontract.org/2004/07/fiskaltrust.ifPOS.v0"[GblCplx] }


  // ************************************************************************ //
  // XML       : ReceiptResponse, global, <complexType>
  // Namespace : http://schemas.datacontract.org/2004/07/fiskaltrust.ifPOS.v0
  // ************************************************************************ //
  ReceiptResponse = class(TRemotable)
  private
    FftCashBoxID: WideString;
    FcbTerminalID: WideString;
    FcbReceiptReference: WideString;
    FftReceiptID: WideString;
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
    FftStateData: WideString;
    FftStateData_Specified: boolean;
    procedure SetftReceiptHeader(Index: Integer; const AArrayOfstring: ArrayOfstring);
    function  ftReceiptHeader_Specified(Index: Integer): boolean;
    procedure SetftChargeItems(Index: Integer; const AArrayOfChargeItem: ArrayOfChargeItem);
    function  ftChargeItems_Specified(Index: Integer): boolean;
    procedure SetftChargeLines(Index: Integer; const AArrayOfstring: ArrayOfstring);
    function  ftChargeLines_Specified(Index: Integer): boolean;
    procedure SetftPayItems(Index: Integer; const AArrayOfPayItem: ArrayOfPayItem);
    function  ftPayItems_Specified(Index: Integer): boolean;
    procedure SetftPayLines(Index: Integer; const AArrayOfstring: ArrayOfstring);
    function  ftPayLines_Specified(Index: Integer): boolean;
    procedure SetftReceiptFooter(Index: Integer; const AArrayOfstring: ArrayOfstring);
    function  ftReceiptFooter_Specified(Index: Integer): boolean;
    procedure SetftStateData(Index: Integer; const AWideString: WideString);
    function  ftStateData_Specified(Index: Integer): boolean;
  public
    destructor Destroy; override;
  published
    property ftCashBoxID:        WideString           Index (IS_NLBL) read FftCashBoxID write FftCashBoxID;
    property cbTerminalID:       WideString           Index (IS_NLBL) read FcbTerminalID write FcbTerminalID;
    property cbReceiptReference: WideString           Index (IS_NLBL) read FcbReceiptReference write FcbReceiptReference;
    property ftReceiptID:        WideString           Index (IS_NLBL) read FftReceiptID write FftReceiptID;
    property ftReceiptMoment:    TXSDateTime          read FftReceiptMoment write FftReceiptMoment;
    property ftReceiptHeader:    ArrayOfstring        Index (IS_OPTN or IS_NLBL) read FftReceiptHeader write SetftReceiptHeader stored ftReceiptHeader_Specified;
    property ftChargeItems:      ArrayOfChargeItem    Index (IS_OPTN or IS_NLBL) read FftChargeItems write SetftChargeItems stored ftChargeItems_Specified;
    property ftChargeLines:      ArrayOfstring        Index (IS_OPTN or IS_NLBL) read FftChargeLines write SetftChargeLines stored ftChargeLines_Specified;
    property ftPayItems:         ArrayOfPayItem       Index (IS_OPTN or IS_NLBL) read FftPayItems write SetftPayItems stored ftPayItems_Specified;
    property ftPayLines:         ArrayOfstring        Index (IS_OPTN or IS_NLBL) read FftPayLines write SetftPayLines stored ftPayLines_Specified;
    property ftSignatures:       ArrayOfSignaturItem  Index (IS_NLBL) read FftSignatures write FftSignatures;
    property ftReceiptFooter:    ArrayOfstring        Index (IS_OPTN or IS_NLBL) read FftReceiptFooter write SetftReceiptFooter stored ftReceiptFooter_Specified;
    property ftState:            Int64                read FftState write FftState;
    property ftStateData:        WideString           Index (IS_OPTN or IS_NLBL) read FftStateData write SetftStateData stored ftStateData_Specified;
  end;



  // ************************************************************************ //
  // XML       : SignaturItem, global, <complexType>
  // Namespace : http://schemas.datacontract.org/2004/07/fiskaltrust.ifPOS.v0
  // ************************************************************************ //
  SignaturItem = class(TRemotable)
  private
    FftSignatureFormat: Int64;
    FftSignatureType: Int64;
    FCaption: WideString;
    FCaption_Specified: boolean;
    FData: WideString;
    procedure SetCaption(Index: Integer; const AWideString: WideString);
    function  Caption_Specified(Index: Integer): boolean;
  published
    property ftSignatureFormat: Int64       read FftSignatureFormat write FftSignatureFormat;
    property ftSignatureType:   Int64       read FftSignatureType write FftSignatureType;
    property Caption:           WideString  Index (IS_OPTN or IS_NLBL) read FCaption write SetCaption stored Caption_Specified;
    property Data:              WideString  Index (IS_NLBL) read FData write FData;
  end;



  // ************************************************************************ //
  // XML       : ReceiptRequest, global, <element>
  // Namespace : http://schemas.datacontract.org/2004/07/fiskaltrust.ifPOS.v0
  // ************************************************************************ //
  ReceiptRequest2 = class(ReceiptRequest)
  private
  published
  end;



  // ************************************************************************ //
  // XML       : ChargeItem, global, <element>
  // Namespace : http://schemas.datacontract.org/2004/07/fiskaltrust.ifPOS.v0
  // ************************************************************************ //
  ChargeItem2 = class(ChargeItem)
  private
  published
  end;



  // ************************************************************************ //
  // XML       : PayItem, global, <element>
  // Namespace : http://schemas.datacontract.org/2004/07/fiskaltrust.ifPOS.v0
  // ************************************************************************ //
  PayItem2 = class(PayItem)
  private
  published
  end;



  // ************************************************************************ //
  // XML       : ReceiptResponse, global, <element>
  // Namespace : http://schemas.datacontract.org/2004/07/fiskaltrust.ifPOS.v0
  // ************************************************************************ //
  ReceiptResponse2 = class(ReceiptResponse)
  private
  published
  end;



  // ************************************************************************ //
  // XML       : SignaturItem, global, <element>
  // Namespace : http://schemas.datacontract.org/2004/07/fiskaltrust.ifPOS.v0
  // ************************************************************************ //
  SignaturItem2 = class(SignaturItem)
  private
  published
  end;



  // ************************************************************************ //
  // XML       : person, global, <complexType>
  // Namespace : http://schemas.datacontract.org/2004/07/fiskaltrust.service
  // ************************************************************************ //
  person = class(TRemotable)
  private
    Fage: Integer;
    Fage_Specified: boolean;
    Ffirstname: WideString;
    Ffirstname_Specified: boolean;
    Flastname: WideString;
    Flastname_Specified: boolean;
    procedure Setage(Index: Integer; const AInteger: Integer);
    function  age_Specified(Index: Integer): boolean;
    procedure Setfirstname(Index: Integer; const AWideString: WideString);
    function  firstname_Specified(Index: Integer): boolean;
    procedure Setlastname(Index: Integer; const AWideString: WideString);
    function  lastname_Specified(Index: Integer): boolean;
  published
    property age:       Integer     Index (IS_OPTN) read Fage write Setage stored age_Specified;
    property firstname: WideString  Index (IS_OPTN or IS_NLBL) read Ffirstname write Setfirstname stored firstname_Specified;
    property lastname:  WideString  Index (IS_OPTN or IS_NLBL) read Flastname write Setlastname stored lastname_Specified;
  end;



  // ************************************************************************ //
  // XML       : person, global, <element>
  // Namespace : http://schemas.datacontract.org/2004/07/fiskaltrust.service
  // ************************************************************************ //
  person2 = class(person)
  private
  published
  end;



  // ************************************************************************ //
  // XML       : GetEcho, global, <element>
  // Namespace : http://tempuri.org/
  // ************************************************************************ //
  GetEcho = class(TRemotable)
  private
    FMessage_: WideString;
    FMessage__Specified: boolean;
    procedure SetMessage_(Index: Integer; const AWideString: WideString);
    function  Message__Specified(Index: Integer): boolean;
  published
    property Message_: WideString  Index (IS_OPTN or IS_NLBL) read FMessage_ write SetMessage_ stored Message__Specified;
  end;



  // ************************************************************************ //
  // XML       : GetEchoResponse, global, <element>
  // Namespace : http://tempuri.org/
  // ************************************************************************ //
  GetEchoResponse = class(TRemotable)
  private
    FGetEchoResult: WideString;
    FGetEchoResult_Specified: boolean;
    procedure SetGetEchoResult(Index: Integer; const AWideString: WideString);
    function  GetEchoResult_Specified(Index: Integer): boolean;
  published
    property GetEchoResult: WideString  Index (IS_OPTN or IS_NLBL) read FGetEchoResult write SetGetEchoResult stored GetEchoResult_Specified;
  end;



  // ************************************************************************ //
  // XML       : PostJsonEcho, global, <element>
  // Namespace : http://tempuri.org/
  // ************************************************************************ //
  PostJsonEcho = class(TRemotable)
  private
    FMessage_: WideString;
    FMessage__Specified: boolean;
    procedure SetMessage_(Index: Integer; const AWideString: WideString);
    function  Message__Specified(Index: Integer): boolean;
  published
    property Message_: WideString  Index (IS_OPTN or IS_NLBL) read FMessage_ write SetMessage_ stored Message__Specified;
  end;



  // ************************************************************************ //
  // XML       : PostJsonEchoResponse, global, <element>
  // Namespace : http://tempuri.org/
  // ************************************************************************ //
  PostJsonEchoResponse = class(TRemotable)
  private
    FPostJsonEchoResult: WideString;
    FPostJsonEchoResult_Specified: boolean;
    procedure SetPostJsonEchoResult(Index: Integer; const AWideString: WideString);
    function  PostJsonEchoResult_Specified(Index: Integer): boolean;
  published
    property PostJsonEchoResult: WideString  Index (IS_OPTN or IS_NLBL) read FPostJsonEchoResult write SetPostJsonEchoResult stored PostJsonEchoResult_Specified;
  end;



  // ************************************************************************ //
  // XML       : PostXmlEcho, global, <element>
  // Namespace : http://tempuri.org/
  // ************************************************************************ //
  PostXmlEcho = class(TRemotable)
  private
    FMessage_: WideString;
    FMessage__Specified: boolean;
    procedure SetMessage_(Index: Integer; const AWideString: WideString);
    function  Message__Specified(Index: Integer): boolean;
  published
    property Message_: WideString  Index (IS_OPTN or IS_NLBL) read FMessage_ write SetMessage_ stored Message__Specified;
  end;



  // ************************************************************************ //
  // XML       : PostXmlEchoResponse, global, <element>
  // Namespace : http://tempuri.org/
  // ************************************************************************ //
  PostXmlEchoResponse = class(TRemotable)
  private
    FPostXmlEchoResult: WideString;
    FPostXmlEchoResult_Specified: boolean;
    procedure SetPostXmlEchoResult(Index: Integer; const AWideString: WideString);
    function  PostXmlEchoResult_Specified(Index: Integer): boolean;
  published
    property PostXmlEchoResult: WideString  Index (IS_OPTN or IS_NLBL) read FPostXmlEchoResult write SetPostXmlEchoResult stored PostXmlEchoResult_Specified;
  end;



  // ************************************************************************ //
  // XML       : PostAnyEcho, global, <element>
  // Namespace : http://tempuri.org/
  // ************************************************************************ //
  PostAnyEcho = class(TRemotable)
  private
    FMessage_: WideString;
    FMessage__Specified: boolean;
    procedure SetMessage_(Index: Integer; const AWideString: WideString);
    function  Message__Specified(Index: Integer): boolean;
  published
    property Message_: WideString  Index (IS_OPTN or IS_NLBL) read FMessage_ write SetMessage_ stored Message__Specified;
  end;



  // ************************************************************************ //
  // XML       : PostAnyEchoResponse, global, <element>
  // Namespace : http://tempuri.org/
  // ************************************************************************ //
  PostAnyEchoResponse = class(TRemotable)
  private
    FPostAnyEchoResult: WideString;
    FPostAnyEchoResult_Specified: boolean;
    procedure SetPostAnyEchoResult(Index: Integer; const AWideString: WideString);
    function  PostAnyEchoResult_Specified(Index: Integer): boolean;
  published
    property PostAnyEchoResult: WideString  Index (IS_OPTN or IS_NLBL) read FPostAnyEchoResult write SetPostAnyEchoResult stored PostAnyEchoResult_Specified;
  end;



  // ************************************************************************ //
  // XML       : PostJsonSign, global, <element>
  // Namespace : http://tempuri.org/
  // ************************************************************************ //
  PostJsonSign = class(TRemotable)
  private
    Fdata: ReceiptRequest;
    Fdata_Specified: boolean;
    procedure Setdata(Index: Integer; const AReceiptRequest: ReceiptRequest);
    function  data_Specified(Index: Integer): boolean;
  public
    destructor Destroy; override;
  published
    property data: ReceiptRequest  Index (IS_OPTN or IS_NLBL) read Fdata write Setdata stored data_Specified;
  end;



  // ************************************************************************ //
  // XML       : PostJsonSignResponse, global, <element>
  // Namespace : http://tempuri.org/
  // ************************************************************************ //
  PostJsonSignResponse = class(TRemotable)
  private
    FPostJsonSignResult: ReceiptResponse;
    FPostJsonSignResult_Specified: boolean;
    procedure SetPostJsonSignResult(Index: Integer; const AReceiptResponse: ReceiptResponse);
    function  PostJsonSignResult_Specified(Index: Integer): boolean;
  public
    destructor Destroy; override;
  published
    property PostJsonSignResult: ReceiptResponse  Index (IS_OPTN or IS_NLBL) read FPostJsonSignResult write SetPostJsonSignResult stored PostJsonSignResult_Specified;
  end;



  // ************************************************************************ //
  // XML       : PostXmlSign, global, <element>
  // Namespace : http://tempuri.org/
  // ************************************************************************ //
  PostXmlSign = class(TRemotable)
  private
    Fdata: ReceiptRequest;
    Fdata_Specified: boolean;
    procedure Setdata(Index: Integer; const AReceiptRequest: ReceiptRequest);
    function  data_Specified(Index: Integer): boolean;
  public
    destructor Destroy; override;
  published
    property data: ReceiptRequest  Index (IS_OPTN or IS_NLBL) read Fdata write Setdata stored data_Specified;
  end;



  // ************************************************************************ //
  // XML       : PostXmlSignResponse, global, <element>
  // Namespace : http://tempuri.org/
  // ************************************************************************ //
  PostXmlSignResponse = class(TRemotable)
  private
    FPostXmlSignResult: ReceiptResponse;
    FPostXmlSignResult_Specified: boolean;
    procedure SetPostXmlSignResult(Index: Integer; const AReceiptResponse: ReceiptResponse);
    function  PostXmlSignResult_Specified(Index: Integer): boolean;
  public
    destructor Destroy; override;
  published
    property PostXmlSignResult: ReceiptResponse  Index (IS_OPTN or IS_NLBL) read FPostXmlSignResult write SetPostXmlSignResult stored PostXmlSignResult_Specified;
  end;



  // ************************************************************************ //
  // XML       : PostAnySign, global, <element>
  // Namespace : http://tempuri.org/
  // ************************************************************************ //
  PostAnySign = class(TRemotable)
  private
    Fdata: ReceiptRequest;
    Fdata_Specified: boolean;
    procedure Setdata(Index: Integer; const AReceiptRequest: ReceiptRequest);
    function  data_Specified(Index: Integer): boolean;
  public
    destructor Destroy; override;
  published
    property data: ReceiptRequest  Index (IS_OPTN or IS_NLBL) read Fdata write Setdata stored data_Specified;
  end;



  // ************************************************************************ //
  // XML       : PostAnySignResponse, global, <element>
  // Namespace : http://tempuri.org/
  // ************************************************************************ //
  PostAnySignResponse = class(TRemotable)
  private
    FPostAnySignResult: ReceiptResponse;
    FPostAnySignResult_Specified: boolean;
    procedure SetPostAnySignResult(Index: Integer; const AReceiptResponse: ReceiptResponse);
    function  PostAnySignResult_Specified(Index: Integer): boolean;
  public
    destructor Destroy; override;
  published
    property PostAnySignResult: ReceiptResponse  Index (IS_OPTN or IS_NLBL) read FPostAnySignResult write SetPostAnySignResult stored PostAnySignResult_Specified;
  end;



  // ************************************************************************ //
  // XML       : PostPerson, global, <element>
  // Namespace : http://tempuri.org/
  // ************************************************************************ //
  PostPerson = class(TRemotable)
  private
    Fdata: person;
    Fdata_Specified: boolean;
    procedure Setdata(Index: Integer; const Aperson: person);
    function  data_Specified(Index: Integer): boolean;
  public
    destructor Destroy; override;
  published
    property data: person  Index (IS_OPTN or IS_NLBL) read Fdata write Setdata stored data_Specified;
  end;



  // ************************************************************************ //
  // XML       : PostPersonResponse, global, <element>
  // Namespace : http://tempuri.org/
  // ************************************************************************ //
  PostPersonResponse = class(TRemotable)
  private
    FPostPersonResult: person;
    FPostPersonResult_Specified: boolean;
    procedure SetPostPersonResult(Index: Integer; const Aperson: person);
    function  PostPersonResult_Specified(Index: Integer): boolean;
  public
    destructor Destroy; override;
  published
    property PostPersonResult: person  Index (IS_OPTN or IS_NLBL) read FPostPersonResult write SetPostPersonResult stored PostPersonResult_Specified;
  end;


  // ************************************************************************ //
  // Namespace : http://tempuri.org/
  // soapAction: http://tempuri.org/IPOS/%operationName%
  // Transport : http://schemas.xmlsoap.org/soap/http
  // Stil     : document
  // Bindung   : BasicHttpBinding_IPOS
  // Service   : POSpfx
  // Port      : BasicHttpBinding_IPOS
  // URL       : http://192.168.0.11:1204/fiskaltrust/POS
  // ************************************************************************ //
  IPOS = interface(IInvokable)
  ['{BD665969-9FDA-803E-25E8-BDB363C82A46}']
    function  Sign(const data: ReceiptRequest): ReceiptResponse; stdcall;
    function  Echo(const Message_: WideString): WideString; stdcall;
  end;


  // ************************************************************************ //
  // Namespace : http://tempuri.org/
  // Transport : http://schemas.xmlsoap.org/soap/http
  // ************************************************************************ //
  restIPOS = interface(IInvokable)
  ['{366D1442-3114-E69D-0B6B-858F5C7E307A}']
    function  GetEcho(const parameters: GetEcho): GetEchoResponse; stdcall;
    function  PostJsonEcho(const parameters: PostJsonEcho): PostJsonEchoResponse; stdcall;
    function  PostXmlEcho(const parameters: PostXmlEcho): PostXmlEchoResponse; stdcall;
    function  PostAnyEcho(const parameters: PostAnyEcho): PostAnyEchoResponse; stdcall;
    function  PostJsonSign(const parameters: PostJsonSign): PostJsonSignResponse; stdcall;
    function  PostXmlSign(const parameters: PostXmlSign): PostXmlSignResponse; stdcall;
    function  PostAnySign(const parameters: PostAnySign): PostAnySignResponse; stdcall;
    function  PostPerson(const parameters: PostPerson): PostPersonResponse; stdcall;
  end;

function GetIPOS(UseWSDL: Boolean=System.False; Addr: string=''; HTTPRIO: THTTPRIO = nil): IPOS;


implementation
  uses SysUtils;

function GetIPOS(UseWSDL: Boolean; Addr: string; HTTPRIO: THTTPRIO): IPOS;
const
  defWSDL = 'http://192.168.0.11:1204/fiskaltrust/POS?wsdl';
  defURL  = 'http://192.168.0.11:1204/fiskaltrust/POS';
  defSvc  = 'POSpfx';
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


destructor ReceiptRequest.Destroy;
var
  I: Integer;
begin
  for I := 0 to Length(FcbChargeItems)-1 do
    FreeAndNil(FcbChargeItems[I]);
  SetLength(FcbChargeItems, 0);
  for I := 0 to Length(FcbPayItems)-1 do
    FreeAndNil(FcbPayItems[I]);
  SetLength(FcbPayItems, 0);
  FreeAndNil(FcbReceiptMoment);
  FreeAndNil(FcbReceiptAmount);
  inherited Destroy;
end;

procedure ReceiptRequest.SetftReceiptCaseData(Index: Integer; const AWideString: WideString);
begin
  FftReceiptCaseData := AWideString;
  FftReceiptCaseData_Specified := True;
end;

function ReceiptRequest.ftReceiptCaseData_Specified(Index: Integer): boolean;
begin
  Result := FftReceiptCaseData_Specified;
end;

procedure ReceiptRequest.SetcbReceiptAmount(Index: Integer; const ATXSDecimal: TXSDecimal);
begin
  FcbReceiptAmount := ATXSDecimal;
  FcbReceiptAmount_Specified := True;
end;

function ReceiptRequest.cbReceiptAmount_Specified(Index: Integer): boolean;
begin
  Result := FcbReceiptAmount_Specified;
end;

procedure ReceiptRequest.SetcbUser(Index: Integer; const AWideString: WideString);
begin
  FcbUser := AWideString;
  FcbUser_Specified := True;
end;

function ReceiptRequest.cbUser_Specified(Index: Integer): boolean;
begin
  Result := FcbUser_Specified;
end;

procedure ReceiptRequest.SetcbArea(Index: Integer; const AWideString: WideString);
begin
  FcbArea := AWideString;
  FcbArea_Specified := True;
end;

function ReceiptRequest.cbArea_Specified(Index: Integer): boolean;
begin
  Result := FcbArea_Specified;
end;

procedure ReceiptRequest.SetcbCustomer(Index: Integer; const AWideString: WideString);
begin
  FcbCustomer := AWideString;
  FcbCustomer_Specified := True;
end;

function ReceiptRequest.cbCustomer_Specified(Index: Integer): boolean;
begin
  Result := FcbCustomer_Specified;
end;

procedure ReceiptRequest.SetcbSettlement(Index: Integer; const AWideString: WideString);
begin
  FcbSettlement := AWideString;
  FcbSettlement_Specified := True;
end;

function ReceiptRequest.cbSettlement_Specified(Index: Integer): boolean;
begin
  Result := FcbSettlement_Specified;
end;

destructor ChargeItem.Destroy;
begin
  FreeAndNil(FQuantity);
  FreeAndNil(FAmount);
  FreeAndNil(FVATRate);
  FreeAndNil(FVATAmount);
  FreeAndNil(FUnitQuantity);
  FreeAndNil(FUnitPrice);
  FreeAndNil(FMoment);
  inherited Destroy;
end;

procedure ChargeItem.SetftChargeItemCaseData(Index: Integer; const AWideString: WideString);
begin
  FftChargeItemCaseData := AWideString;
  FftChargeItemCaseData_Specified := True;
end;

function ChargeItem.ftChargeItemCaseData_Specified(Index: Integer): boolean;
begin
  Result := FftChargeItemCaseData_Specified;
end;

procedure ChargeItem.SetVATAmount(Index: Integer; const ATXSDecimal: TXSDecimal);
begin
  FVATAmount := ATXSDecimal;
  FVATAmount_Specified := True;
end;

function ChargeItem.VATAmount_Specified(Index: Integer): boolean;
begin
  Result := FVATAmount_Specified;
end;

procedure ChargeItem.SetAccountNumber(Index: Integer; const AWideString: WideString);
begin
  FAccountNumber := AWideString;
  FAccountNumber_Specified := True;
end;

function ChargeItem.AccountNumber_Specified(Index: Integer): boolean;
begin
  Result := FAccountNumber_Specified;
end;

procedure ChargeItem.SetCostCenter(Index: Integer; const AWideString: WideString);
begin
  FCostCenter := AWideString;
  FCostCenter_Specified := True;
end;

function ChargeItem.CostCenter_Specified(Index: Integer): boolean;
begin
  Result := FCostCenter_Specified;
end;

procedure ChargeItem.SetProductGroup(Index: Integer; const AWideString: WideString);
begin
  FProductGroup := AWideString;
  FProductGroup_Specified := True;
end;

function ChargeItem.ProductGroup_Specified(Index: Integer): boolean;
begin
  Result := FProductGroup_Specified;
end;

procedure ChargeItem.SetProductNumber(Index: Integer; const AWideString: WideString);
begin
  FProductNumber := AWideString;
  FProductNumber_Specified := True;
end;

function ChargeItem.ProductNumber_Specified(Index: Integer): boolean;
begin
  Result := FProductNumber_Specified;
end;

procedure ChargeItem.SetProductBarcode(Index: Integer; const AWideString: WideString);
begin
  FProductBarcode := AWideString;
  FProductBarcode_Specified := True;
end;

function ChargeItem.ProductBarcode_Specified(Index: Integer): boolean;
begin
  Result := FProductBarcode_Specified;
end;

procedure ChargeItem.SetUnit_(Index: Integer; const AWideString: WideString);
begin
  FUnit_ := AWideString;
  FUnit__Specified := True;
end;

function ChargeItem.Unit__Specified(Index: Integer): boolean;
begin
  Result := FUnit__Specified;
end;

procedure ChargeItem.SetUnitQuantity(Index: Integer; const ATXSDecimal: TXSDecimal);
begin
  FUnitQuantity := ATXSDecimal;
  FUnitQuantity_Specified := True;
end;

function ChargeItem.UnitQuantity_Specified(Index: Integer): boolean;
begin
  Result := FUnitQuantity_Specified;
end;

procedure ChargeItem.SetUnitPrice(Index: Integer; const ATXSDecimal: TXSDecimal);
begin
  FUnitPrice := ATXSDecimal;
  FUnitPrice_Specified := True;
end;

function ChargeItem.UnitPrice_Specified(Index: Integer): boolean;
begin
  Result := FUnitPrice_Specified;
end;

procedure ChargeItem.SetMoment(Index: Integer; const ATXSDateTime: TXSDateTime);
begin
  FMoment := ATXSDateTime;
  FMoment_Specified := True;
end;

function ChargeItem.Moment_Specified(Index: Integer): boolean;
begin
  Result := FMoment_Specified;
end;

destructor PayItem.Destroy;
begin
  FreeAndNil(FQuantity);
  FreeAndNil(FAmount);
  FreeAndNil(FMoment);
  inherited Destroy;
end;

procedure PayItem.SetftPayItemCaseData(Index: Integer; const AWideString: WideString);
begin
  FftPayItemCaseData := AWideString;
  FftPayItemCaseData_Specified := True;
end;

function PayItem.ftPayItemCaseData_Specified(Index: Integer): boolean;
begin
  Result := FftPayItemCaseData_Specified;
end;

procedure PayItem.SetAccountNumber(Index: Integer; const AWideString: WideString);
begin
  FAccountNumber := AWideString;
  FAccountNumber_Specified := True;
end;

function PayItem.AccountNumber_Specified(Index: Integer): boolean;
begin
  Result := FAccountNumber_Specified;
end;

procedure PayItem.SetCostCenter(Index: Integer; const AWideString: WideString);
begin
  FCostCenter := AWideString;
  FCostCenter_Specified := True;
end;

function PayItem.CostCenter_Specified(Index: Integer): boolean;
begin
  Result := FCostCenter_Specified;
end;

procedure PayItem.SetMoneyGroup(Index: Integer; const AWideString: WideString);
begin
  FMoneyGroup := AWideString;
  FMoneyGroup_Specified := True;
end;

function PayItem.MoneyGroup_Specified(Index: Integer): boolean;
begin
  Result := FMoneyGroup_Specified;
end;

procedure PayItem.SetMoneyNumber(Index: Integer; const AWideString: WideString);
begin
  FMoneyNumber := AWideString;
  FMoneyNumber_Specified := True;
end;

function PayItem.MoneyNumber_Specified(Index: Integer): boolean;
begin
  Result := FMoneyNumber_Specified;
end;

procedure PayItem.SetMoment(Index: Integer; const ATXSDateTime: TXSDateTime);
begin
  FMoment := ATXSDateTime;
  FMoment_Specified := True;
end;

function PayItem.Moment_Specified(Index: Integer): boolean;
begin
  Result := FMoment_Specified;
end;

destructor ReceiptResponse.Destroy;
var
  I: Integer;
begin
  for I := 0 to Length(FftChargeItems)-1 do
    FreeAndNil(FftChargeItems[I]);
  SetLength(FftChargeItems, 0);
  for I := 0 to Length(FftPayItems)-1 do
    FreeAndNil(FftPayItems[I]);
  SetLength(FftPayItems, 0);
  for I := 0 to Length(FftSignatures)-1 do
    FreeAndNil(FftSignatures[I]);
  SetLength(FftSignatures, 0);
  FreeAndNil(FftReceiptMoment);
  inherited Destroy;
end;

procedure ReceiptResponse.SetftReceiptHeader(Index: Integer; const AArrayOfstring: ArrayOfstring);
begin
  FftReceiptHeader := AArrayOfstring;
  FftReceiptHeader_Specified := True;
end;

function ReceiptResponse.ftReceiptHeader_Specified(Index: Integer): boolean;
begin
  Result := FftReceiptHeader_Specified;
end;

procedure ReceiptResponse.SetftChargeItems(Index: Integer; const AArrayOfChargeItem: ArrayOfChargeItem);
begin
  FftChargeItems := AArrayOfChargeItem;
  FftChargeItems_Specified := True;
end;

function ReceiptResponse.ftChargeItems_Specified(Index: Integer): boolean;
begin
  Result := FftChargeItems_Specified;
end;

procedure ReceiptResponse.SetftChargeLines(Index: Integer; const AArrayOfstring: ArrayOfstring);
begin
  FftChargeLines := AArrayOfstring;
  FftChargeLines_Specified := True;
end;

function ReceiptResponse.ftChargeLines_Specified(Index: Integer): boolean;
begin
  Result := FftChargeLines_Specified;
end;

procedure ReceiptResponse.SetftPayItems(Index: Integer; const AArrayOfPayItem: ArrayOfPayItem);
begin
  FftPayItems := AArrayOfPayItem;
  FftPayItems_Specified := True;
end;

function ReceiptResponse.ftPayItems_Specified(Index: Integer): boolean;
begin
  Result := FftPayItems_Specified;
end;

procedure ReceiptResponse.SetftPayLines(Index: Integer; const AArrayOfstring: ArrayOfstring);
begin
  FftPayLines := AArrayOfstring;
  FftPayLines_Specified := True;
end;

function ReceiptResponse.ftPayLines_Specified(Index: Integer): boolean;
begin
  Result := FftPayLines_Specified;
end;

procedure ReceiptResponse.SetftReceiptFooter(Index: Integer; const AArrayOfstring: ArrayOfstring);
begin
  FftReceiptFooter := AArrayOfstring;
  FftReceiptFooter_Specified := True;
end;

function ReceiptResponse.ftReceiptFooter_Specified(Index: Integer): boolean;
begin
  Result := FftReceiptFooter_Specified;
end;

procedure ReceiptResponse.SetftStateData(Index: Integer; const AWideString: WideString);
begin
  FftStateData := AWideString;
  FftStateData_Specified := True;
end;

function ReceiptResponse.ftStateData_Specified(Index: Integer): boolean;
begin
  Result := FftStateData_Specified;
end;

procedure SignaturItem.SetCaption(Index: Integer; const AWideString: WideString);
begin
  FCaption := AWideString;
  FCaption_Specified := True;
end;

function SignaturItem.Caption_Specified(Index: Integer): boolean;
begin
  Result := FCaption_Specified;
end;

procedure person.Setage(Index: Integer; const AInteger: Integer);
begin
  Fage := AInteger;
  Fage_Specified := True;
end;

function person.age_Specified(Index: Integer): boolean;
begin
  Result := Fage_Specified;
end;

procedure person.Setfirstname(Index: Integer; const AWideString: WideString);
begin
  Ffirstname := AWideString;
  Ffirstname_Specified := True;
end;

function person.firstname_Specified(Index: Integer): boolean;
begin
  Result := Ffirstname_Specified;
end;

procedure person.Setlastname(Index: Integer; const AWideString: WideString);
begin
  Flastname := AWideString;
  Flastname_Specified := True;
end;

function person.lastname_Specified(Index: Integer): boolean;
begin
  Result := Flastname_Specified;
end;

procedure GetEcho.SetMessage_(Index: Integer; const AWideString: WideString);
begin
  FMessage_ := AWideString;
  FMessage__Specified := True;
end;

function GetEcho.Message__Specified(Index: Integer): boolean;
begin
  Result := FMessage__Specified;
end;

procedure GetEchoResponse.SetGetEchoResult(Index: Integer; const AWideString: WideString);
begin
  FGetEchoResult := AWideString;
  FGetEchoResult_Specified := True;
end;

function GetEchoResponse.GetEchoResult_Specified(Index: Integer): boolean;
begin
  Result := FGetEchoResult_Specified;
end;

procedure PostJsonEcho.SetMessage_(Index: Integer; const AWideString: WideString);
begin
  FMessage_ := AWideString;
  FMessage__Specified := True;
end;

function PostJsonEcho.Message__Specified(Index: Integer): boolean;
begin
  Result := FMessage__Specified;
end;

procedure PostJsonEchoResponse.SetPostJsonEchoResult(Index: Integer; const AWideString: WideString);
begin
  FPostJsonEchoResult := AWideString;
  FPostJsonEchoResult_Specified := True;
end;

function PostJsonEchoResponse.PostJsonEchoResult_Specified(Index: Integer): boolean;
begin
  Result := FPostJsonEchoResult_Specified;
end;

procedure PostXmlEcho.SetMessage_(Index: Integer; const AWideString: WideString);
begin
  FMessage_ := AWideString;
  FMessage__Specified := True;
end;

function PostXmlEcho.Message__Specified(Index: Integer): boolean;
begin
  Result := FMessage__Specified;
end;

procedure PostXmlEchoResponse.SetPostXmlEchoResult(Index: Integer; const AWideString: WideString);
begin
  FPostXmlEchoResult := AWideString;
  FPostXmlEchoResult_Specified := True;
end;

function PostXmlEchoResponse.PostXmlEchoResult_Specified(Index: Integer): boolean;
begin
  Result := FPostXmlEchoResult_Specified;
end;

procedure PostAnyEcho.SetMessage_(Index: Integer; const AWideString: WideString);
begin
  FMessage_ := AWideString;
  FMessage__Specified := True;
end;

function PostAnyEcho.Message__Specified(Index: Integer): boolean;
begin
  Result := FMessage__Specified;
end;

procedure PostAnyEchoResponse.SetPostAnyEchoResult(Index: Integer; const AWideString: WideString);
begin
  FPostAnyEchoResult := AWideString;
  FPostAnyEchoResult_Specified := True;
end;

function PostAnyEchoResponse.PostAnyEchoResult_Specified(Index: Integer): boolean;
begin
  Result := FPostAnyEchoResult_Specified;
end;

destructor PostJsonSign.Destroy;
begin
  FreeAndNil(Fdata);
  inherited Destroy;
end;

procedure PostJsonSign.Setdata(Index: Integer; const AReceiptRequest: ReceiptRequest);
begin
  Fdata := AReceiptRequest;
  Fdata_Specified := True;
end;

function PostJsonSign.data_Specified(Index: Integer): boolean;
begin
  Result := Fdata_Specified;
end;

destructor PostJsonSignResponse.Destroy;
begin
  FreeAndNil(FPostJsonSignResult);
  inherited Destroy;
end;

procedure PostJsonSignResponse.SetPostJsonSignResult(Index: Integer; const AReceiptResponse: ReceiptResponse);
begin
  FPostJsonSignResult := AReceiptResponse;
  FPostJsonSignResult_Specified := True;
end;

function PostJsonSignResponse.PostJsonSignResult_Specified(Index: Integer): boolean;
begin
  Result := FPostJsonSignResult_Specified;
end;

destructor PostXmlSign.Destroy;
begin
  FreeAndNil(Fdata);
  inherited Destroy;
end;

procedure PostXmlSign.Setdata(Index: Integer; const AReceiptRequest: ReceiptRequest);
begin
  Fdata := AReceiptRequest;
  Fdata_Specified := True;
end;

function PostXmlSign.data_Specified(Index: Integer): boolean;
begin
  Result := Fdata_Specified;
end;

destructor PostXmlSignResponse.Destroy;
begin
  FreeAndNil(FPostXmlSignResult);
  inherited Destroy;
end;

procedure PostXmlSignResponse.SetPostXmlSignResult(Index: Integer; const AReceiptResponse: ReceiptResponse);
begin
  FPostXmlSignResult := AReceiptResponse;
  FPostXmlSignResult_Specified := True;
end;

function PostXmlSignResponse.PostXmlSignResult_Specified(Index: Integer): boolean;
begin
  Result := FPostXmlSignResult_Specified;
end;

destructor PostAnySign.Destroy;
begin
  FreeAndNil(Fdata);
  inherited Destroy;
end;

procedure PostAnySign.Setdata(Index: Integer; const AReceiptRequest: ReceiptRequest);
begin
  Fdata := AReceiptRequest;
  Fdata_Specified := True;
end;

function PostAnySign.data_Specified(Index: Integer): boolean;
begin
  Result := Fdata_Specified;
end;

destructor PostAnySignResponse.Destroy;
begin
  FreeAndNil(FPostAnySignResult);
  inherited Destroy;
end;

procedure PostAnySignResponse.SetPostAnySignResult(Index: Integer; const AReceiptResponse: ReceiptResponse);
begin
  FPostAnySignResult := AReceiptResponse;
  FPostAnySignResult_Specified := True;
end;

function PostAnySignResponse.PostAnySignResult_Specified(Index: Integer): boolean;
begin
  Result := FPostAnySignResult_Specified;
end;

destructor PostPerson.Destroy;
begin
  FreeAndNil(Fdata);
  inherited Destroy;
end;

procedure PostPerson.Setdata(Index: Integer; const Aperson: person);
begin
  Fdata := Aperson;
  Fdata_Specified := True;
end;

function PostPerson.data_Specified(Index: Integer): boolean;
begin
  Result := Fdata_Specified;
end;

destructor PostPersonResponse.Destroy;
begin
  FreeAndNil(FPostPersonResult);
  inherited Destroy;
end;

procedure PostPersonResponse.SetPostPersonResult(Index: Integer; const Aperson: person);
begin
  FPostPersonResult := Aperson;
  FPostPersonResult_Specified := True;
end;

function PostPersonResponse.PostPersonResult_Specified(Index: Integer): boolean;
begin
  Result := FPostPersonResult_Specified;
end;

initialization
  InvRegistry.RegisterInterface(TypeInfo(IPOS), 'http://tempuri.org/', 'utf-8');
  InvRegistry.RegisterDefaultSOAPAction(TypeInfo(IPOS), 'http://tempuri.org/IPOS/%operationName%');
  InvRegistry.RegisterInvokeOptions(TypeInfo(IPOS), ioDocument);
  InvRegistry.RegisterExternalParamName(TypeInfo(IPOS), 'Echo', 'Message_', 'Message');
  InvRegistry.RegisterInterface(TypeInfo(restIPOS), 'http://tempuri.org/', 'utf-8');
  InvRegistry.RegisterDefaultSOAPAction(TypeInfo(restIPOS), '');
  InvRegistry.RegisterExternalParamName(TypeInfo(restIPOS), 'GetEcho', 'parameters1', 'parameters');
  InvRegistry.RegisterExternalParamName(TypeInfo(restIPOS), 'PostJsonEcho', 'parameters1', 'parameters');
  InvRegistry.RegisterExternalParamName(TypeInfo(restIPOS), 'PostXmlEcho', 'parameters1', 'parameters');
  InvRegistry.RegisterExternalParamName(TypeInfo(restIPOS), 'PostAnyEcho', 'parameters1', 'parameters');
  InvRegistry.RegisterExternalParamName(TypeInfo(restIPOS), 'PostJsonSign', 'parameters1', 'parameters');
  InvRegistry.RegisterExternalParamName(TypeInfo(restIPOS), 'PostXmlSign', 'parameters1', 'parameters');
  InvRegistry.RegisterExternalParamName(TypeInfo(restIPOS), 'PostAnySign', 'parameters1', 'parameters');
  InvRegistry.RegisterExternalParamName(TypeInfo(restIPOS), 'PostPerson', 'parameters1', 'parameters');
  RemClassRegistry.RegisterXSInfo(TypeInfo(ArrayOfstring), 'http://schemas.microsoft.com/2003/10/Serialization/Arrays', 'ArrayOfstring');
  RemClassRegistry.RegisterXSInfo(TypeInfo(ArrayOfChargeItem), 'http://schemas.datacontract.org/2004/07/fiskaltrust.ifPOS.v0', 'ArrayOfChargeItem');
  RemClassRegistry.RegisterXSInfo(TypeInfo(ArrayOfPayItem), 'http://schemas.datacontract.org/2004/07/fiskaltrust.ifPOS.v0', 'ArrayOfPayItem');
  RemClassRegistry.RegisterXSClass(ReceiptRequest, 'http://schemas.datacontract.org/2004/07/fiskaltrust.ifPOS.v0', 'ReceiptRequest');
  RemClassRegistry.RegisterXSClass(ChargeItem, 'http://schemas.datacontract.org/2004/07/fiskaltrust.ifPOS.v0', 'ChargeItem');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(ChargeItem), 'Unit_', 'Unit');
  RemClassRegistry.RegisterXSClass(PayItem, 'http://schemas.datacontract.org/2004/07/fiskaltrust.ifPOS.v0', 'PayItem');
  RemClassRegistry.RegisterXSInfo(TypeInfo(ArrayOfSignaturItem), 'http://schemas.datacontract.org/2004/07/fiskaltrust.ifPOS.v0', 'ArrayOfSignaturItem');
  RemClassRegistry.RegisterXSClass(ReceiptResponse, 'http://schemas.datacontract.org/2004/07/fiskaltrust.ifPOS.v0', 'ReceiptResponse');
  RemClassRegistry.RegisterXSClass(SignaturItem, 'http://schemas.datacontract.org/2004/07/fiskaltrust.ifPOS.v0', 'SignaturItem');
  RemClassRegistry.RegisterXSClass(ReceiptRequest2, 'http://schemas.datacontract.org/2004/07/fiskaltrust.ifPOS.v0', 'ReceiptRequest2', 'ReceiptRequest');
  RemClassRegistry.RegisterXSClass(ChargeItem2, 'http://schemas.datacontract.org/2004/07/fiskaltrust.ifPOS.v0', 'ChargeItem2', 'ChargeItem');
  RemClassRegistry.RegisterXSClass(PayItem2, 'http://schemas.datacontract.org/2004/07/fiskaltrust.ifPOS.v0', 'PayItem2', 'PayItem');
  RemClassRegistry.RegisterXSClass(ReceiptResponse2, 'http://schemas.datacontract.org/2004/07/fiskaltrust.ifPOS.v0', 'ReceiptResponse2', 'ReceiptResponse');
  RemClassRegistry.RegisterXSClass(SignaturItem2, 'http://schemas.datacontract.org/2004/07/fiskaltrust.ifPOS.v0', 'SignaturItem2', 'SignaturItem');
  RemClassRegistry.RegisterXSClass(person, 'http://schemas.datacontract.org/2004/07/fiskaltrust.service', 'person');
  RemClassRegistry.RegisterXSClass(person2, 'http://schemas.datacontract.org/2004/07/fiskaltrust.service', 'person2', 'person');
  RemClassRegistry.RegisterXSClass(GetEcho, 'http://tempuri.org/', 'GetEcho');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(GetEcho), 'Message_', 'Message');
  RemClassRegistry.RegisterXSClass(GetEchoResponse, 'http://tempuri.org/', 'GetEchoResponse');
  RemClassRegistry.RegisterXSClass(PostJsonEcho, 'http://tempuri.org/', 'PostJsonEcho');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(PostJsonEcho), 'Message_', 'Message');
  RemClassRegistry.RegisterXSClass(PostJsonEchoResponse, 'http://tempuri.org/', 'PostJsonEchoResponse');
  RemClassRegistry.RegisterXSClass(PostXmlEcho, 'http://tempuri.org/', 'PostXmlEcho');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(PostXmlEcho), 'Message_', 'Message');
  RemClassRegistry.RegisterXSClass(PostXmlEchoResponse, 'http://tempuri.org/', 'PostXmlEchoResponse');
  RemClassRegistry.RegisterXSClass(PostAnyEcho, 'http://tempuri.org/', 'PostAnyEcho');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(PostAnyEcho), 'Message_', 'Message');
  RemClassRegistry.RegisterXSClass(PostAnyEchoResponse, 'http://tempuri.org/', 'PostAnyEchoResponse');
  RemClassRegistry.RegisterXSClass(PostJsonSign, 'http://tempuri.org/', 'PostJsonSign');
  RemClassRegistry.RegisterXSClass(PostJsonSignResponse, 'http://tempuri.org/', 'PostJsonSignResponse');
  RemClassRegistry.RegisterXSClass(PostXmlSign, 'http://tempuri.org/', 'PostXmlSign');
  RemClassRegistry.RegisterXSClass(PostXmlSignResponse, 'http://tempuri.org/', 'PostXmlSignResponse');
  RemClassRegistry.RegisterXSClass(PostAnySign, 'http://tempuri.org/', 'PostAnySign');
  RemClassRegistry.RegisterXSClass(PostAnySignResponse, 'http://tempuri.org/', 'PostAnySignResponse');
  RemClassRegistry.RegisterXSClass(PostPerson, 'http://tempuri.org/', 'PostPerson');
  RemClassRegistry.RegisterXSClass(PostPersonResponse, 'http://tempuri.org/', 'PostPersonResponse');

end.