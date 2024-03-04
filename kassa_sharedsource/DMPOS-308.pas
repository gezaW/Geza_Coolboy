unit DMPos;
(* ---------------------------------------------------------------------------
 Software Stylers  - GMS Touch 2003 - Orderman
  ----------------------------------------------------------------------------
  DATUM DER ERSTELLUNG       : 2004-02-16
  ERSTELLER                  : Ulrich HUTTER
  BESCHREIBUNG DER UNIT      :
    Dies ist die Datenschicht der Andwendung.
    Für jeden Orderman wird eine eigene Instanz von TDataOrder erzeugt.
    Alle Ordermantabellen fangen mit o_ an


   TABELLEN:

   ÄNDERUNGEN:

 -----------------------------------------------------------------------------
  Katschberg 423, 5582 St. Michael/i.Lg
 -----------------------------------------------------------------------------
 *)

interface

uses
  SysUtils, Classes, Dialogs, Variants, Controls, Provider,
  IBODataset, DB, DBClient, IB_Components, MidasLib, StdCtrls, IB_Access,
  DMBase, Pglobal;
//  ToPrintDefine, // for TDruckArt (daTeilUmbuchng, daBonRechnung, ...)
//  OrdermanConst;
// for TTableTypes (TableTypeNormal, TableTypeRegularGuest, ...)

type
  // Schlüssel für Passwortkodierung
  TSchluessel =(Gerade, Ungerade);

type
  TDataPos = class(TDataModule)
    CDSKonto: TClientDataSet;
    DataSourceOffeneTische: TDataSource;
    DataSourceReserv: TDataSource;
    DataSource1: TDataSource;
    QueryToTisch: TIBOQuery;
    QueryInsertTischkonto: TIBOQuery;
    Query: TIBOQuery;
    QueryDelTischkonto: TIBOQuery;
    QueryInsertRechkonto: TIBOQuery;
    QueryTastengruppen: TIBOQuery;
    QueryLocateOffenerTisch: TIBOQuery;
    QueryHappyHour: TIBOQuery;
    QueryBeilagengruppe: TIBOQuery;
    QueryBeilagen: TIBOQuery;
    QueryFromTisch: TIBOQuery;
    QueryTastengruppeMenu: TIBOQuery;
    QueryTKDelete: TIBOQuery;
    QueryRechnungskontoIT: TIBOQuery;
    QueryBeilagenText: TIBOQuery;
    QueryZahlweg: TIBOQuery;
    QueryDelRechnung: TIBOQuery;
    QueryDelRechzahlweg: TIBOQuery;
    QuerytastArtikel: TIBOQuery;
    QueryTransfer: TIBOQuery;
    QueryRechNr: TIBOQuery;
    QueryInsertRechnung: TIBOQuery;
    QueryInsertRechzahlung: TIBOQuery;
    QueryDelRechnungsKonto: TIBOQuery;
    QueryRechnungsKonto: TIBOQuery;
    QueryRechnungMwSt: TIBOQuery;
    QueryReviere: TIBOQuery;
    TableDrucker: TIBOTable;
    TableTisch: TIBOTable;
    TableBeilagen: TIBOTable;
    TableTischkonto2: TIBOTable;
    TableBeilagengruppe: TIBOTable;
    TableSchankartikel: TIBOTable;
    TableSteuer: TIBOTable;
    TableRechnung: TIBOTable;
    TableKasseIT: TIBOTable;
    TableFirmenText: TIBOTable;
    QueryHilf_Tischkonto: TIBOQuery;
    IB_ConnectionFelix: TIB_Connection;
    TableZimmerFELIX: TIBOTable;
    TableGastkontoFELIX: TIBOTable;
    TableSparten: TIBOTable;
    TableFelixMwst: TIBOTable;
    Table_Diverses: TIBOTable;
    QueryGetNextID: TIBOQuery;
    QueryMwSt: TIBOQuery;
    QueryMwStFirma: TSmallintField;
    QueryMwStOffeneTischID: TIntegerField;
    QueryMwStArtikelID: TIntegerField;
    QueryMwStMenge: TFloatField;
    QueryMwStBetrag: TCurrencyField;
    QueryMwStLookUntergruppeID: TIntegerField;
    QueryMwStLookHauptGruppeID: TIntegerField;
    QueryMwStLookSteuerID: TIntegerField;
    QueryMwStLookSteuer: TIntegerField;
    QueryMwStLookArtikel: TStringField;
    QueryTische2: TIBOQuery;
    Query_GetLeistungsID: TIBOQuery;
    IB_Transaction2: TIB_Transaction;
    TableOffeneTische: TIBOQuery;
    TableOffeneTischeFIRMA: TSmallintField;
    TableOffeneTischeOFFENETISCHID: TIntegerField;
    TableOffeneTischeTISCHID: TIntegerField;
    TableOffeneTischeBEZEICHNUNG: TStringField;
    TableOffeneTischeGASTADRESSEID: TIntegerField;
    TableOffeneTischeBEMERKUNG: TMemoField;
    TableOffeneTischeDATUM: TDateTimeField;
    TableOffeneTischeBEGINN: TDateTimeField;
    TableOffeneTischeENDE: TDateTimeField;
    TableOffeneTischeOFFEN: TStringField;
    TableOffeneTischeKELLNERID: TIntegerField;
    TableOffeneTischeANREISEDATUM: TDateTimeField;
    TableOffeneTischeABREISEDATUM: TDateTimeField;
    TableOffeneTischeLookTischNr: TStringField;
    TableOffeneTischeReservID: TIntegerField;
    IBOTableSprache: TIBOTable;
    TableTischgruppe: TIBOTable;
    TableKellner: TIBOTable;
    QueryCheckPreisebene: TIBOQuery;
    QueryDelete: TIBOQuery;
    QueryOffeneTische: TIBOQuery;
    QueryGetTischZimmerNr: TIBOQuery;
    IB_DSQLJournal: TIB_DSQL;
    IB_Query_Insert_HilfTischkonto: TIB_Query;
    QueryInsertOffeneTische: TIBOQuery;
    TableHotellog: TIBOTable;
    TableGastinfo: TIBOTable;
    QuerySucheArtikel: TIB_Query;
    QueryArtikel: TIB_Query;
    QueryCheckTischOffen: TIB_Query;
    QueryCloseTisch: TIB_Query;
    QueryLockTisch: TIB_Query;
    QueryLockTisch2: TIB_Query;
    QueryGetMenuCard: TIB_Query;
    QueryKellner: TIB_Query;
    QuerySelectArtikel: TIB_Query;
    TableArtikel: TIBOTable;
    TableUntergruppe: TIBOTable;
    TableHauptgruppe: TIBOTable;
    TableKassinfo: TIBOTable;
    TableLeistung: TIBOQuery;
    TableHilf_Tischkonto: TIBOQuery;
    TableHilf_TischkontoFirma: TSmallintField;
    TableHilf_TischkontoTischkontoID: TIntegerField;
    TableHilf_TischkontoOffeneTischID: TIntegerField;
    TableHilf_TischkontoDatum: TDateField;
    TableHilf_TischkontoArtikelID: TIntegerField;
    TableHilf_TischkontoMenge: TFloatField;
    TableHilf_TischkontoBetrag: TCurrencyField;
    TableHilf_TischkontoKellnerID: TIntegerField;
    TableHilf_TischkontoKasseID: TIntegerField;
    TableHilf_TischkontoGEDRUCKT: TStringField;
    TableHilf_TischkontoBeilagenID1: TIntegerField;
    TableHilf_TischkontoBeilagenID2: TIntegerField;
    TableHilf_TischkontoBeilagenID3: TIntegerField;
    TableHilf_TischkontoBeilagenText: TStringField;
    TableHilf_TischkontoStatus: TSmallintField;
    TableHilf_TischkontoVERBUCHT: TStringField;
    TableHilf_TischkontoGANGID: TIntegerField;
    TableTischkonto: TIBOQuery;
    IB_QueryArtikelPreise: TIB_Query;
    IB_QueryUpdateMenge: TIB_Query;
    IB_QueryGetZaehler: TIB_Query;
    QueryRoomDiscount: TIBOQuery;
    QueryGetHaupgruppeVorSum: TIBOQuery;
    IBOQueryGetRabatt: TIBOQuery;
    QueryJournalControl: TIBOQuery;
    QueryCheckZimmerIB: TIBOQuery;
    IBOQueryTischkonto: TIBOQuery;
    QueryUsers: TIBOQuery;
    QueryTische: TIBOQuery;
    QueryUpdateTischKonto: TIBOQuery;
    QueryDeleteTischKonto: TIBOQuery;
    CDSHilfKonto: TClientDataSet;
    QueryTableAccount: TIBOQuery;
    TransactionProcessingTable: TIB_Transaction;
    QueryTableAccount2: TIBOQuery;
    QueryGetTableAccount: TIBOQuery;
    QueryHelpTableAccount: TIBOQuery;
    ConnectionKasseProcessingTable: TIB_Connection;
    TransactionLockTable: TIB_Transaction;
    TransactionLockTable2: TIB_Transaction;
    QueryGetHelpTableAccount: TIBOQuery;
    QueryGetOpenTableIDbyTableID: TIBOQuery;
    QueryWaiter: TIBOQuery;
    QueryReactivateTable: TIBOQuery;
    CDSMakeLists: TClientDataSet;
    QueryTop20: TIBOQuery;
    CDSKonto2: TClientDataSet;
    QueryCheckTableisReopened: TIBOQuery;
    QueryProcedureCheckTischOffen: TIBOQuery;
    QueryWriteCurrentWaiterToOpenTable: TIBOQuery;
    TableOffeneTischeCURRENTWAITERID: TIntegerField;
    QueryGetFertigeSpeisen: TIBOQuery;
    QueryConfirmFertigeSpeisen: TIBOQuery;
    TableHilf_TischkontoI_DEVICEGUID: TStringField;
    QueryReservFELIX: TIBOQuery;
    QueryCheckFELIX: TIBOQuery;
    QueryTerminNr: TIBOQuery;
    procedure DataModuleCreate(Sender: TObject);
    procedure TableGastkontoFELIXAfterInsert(DataSet: TDataSet);

  private

    FSerialNumber: Integer;
    FPreisEbene, FPreisebeneTisch: Integer;

    FKellnerLagertisch,
      FKellnerPreisebene: Integer;
    FKellnerSpracheID: Integer;

    // fields for waiter rights (are accessed over property in public)
    FKellnerDarfSplitten,
      FKellnerLagerNichtBon,
      FKellnerLagerStorno,
      FKellnerLagerAnzeigen,
      FKellnerDarfXBon,
      FKellnerDarfZBon,
      FKellnerWerbung,
      FKellnerBruch,
      FKellnerPersonal,
      FKellnerEigenbedarf,
      FKellnerStammgaeste,
      FKellnerIsChef,
      FKellnerGesamtStorno,
      FKellnerStorno,
      FKellnerTeilStorno,
      FKellnerSofortStorno,
      FKellnerUmbuchen,
      FKellnerGesamtUmbuchen,
      FKellnerTeilUmbuchen,
      FKellnerRechnung,
      FKellnerGesamtRechnung,
      FKellnerTeilRechnung,
      FKellnerSofortRechnung,
      FKellnerBonDruck,
      FKellnerOhneDruck,
      FKellnerdarfreakt,
      FKellnerDarfWechsel,
      FKellnerDarfNachrichten: Boolean;

    FTabelleSchluesselUrsprung,
      FTabelleSchluesselGerade, // Kodierungstabelle für Paßwort (Gerade)
    // Kodierungstabelle für Paßwort (Ungerade)
    FTabelleSchluesselUnGerade: array[1 .. 39] of Char;

// *********** universal functions (copied from KASSE) ***********
    function GetSchluesselChar(Schluessel: TSchluessel; Zeichen: Char): Char;
    function Verschluesseln(PPW:string):string;
    // copied from DMBASE but without starting an extra transaction and commit it
    function GetGeneratorID(PGenerator:string; PInc: Integer): Integer;
    function GetNextIBID(ATableName:string; ATable: TDataSet;
      AIDString:string): Integer;
// **************************************************************

// *********** Billing functions for SetSofortRechnung(copied from KASSE) ***********
    // Eine neue Rechnungsnummer holen
    // Bei Proforma RechnungsNr wieder zurücksetzeb
    procedure SetRechnungsNr(PProforma: Boolean; PBetrag: Single);
    // Die Leistungen der Hilfstabelle werden auf die Rechnung transferiert
    procedure TransferLeistungToRechnung(PTischkontoTabelle: TIBOQuery;
      PProforma: Boolean; PRechID: Integer);
    // Ins Rechnungskonto einen Artikel einfügen
    procedure DoInsertIntoRechkonto(PFirma, PRechID: Integer; PDatum: TDateTime;
      PArtikelID: Integer; PMenge, PBetrag: Real; PBeilagen:string;
      PBonNr: Integer);
    // Die Leistungen von Rechnungskonto werden wieder auf den Tisch transferiert (Rechnung Reaktivieren)
    procedure TransferLeistungToTischkonto;
// **************************************************************

// *********** special billing functions for italian customers ***********
    procedure SetKasseIT(PRechnungsID: Integer; PRabatt, PNachlass: Real);
    procedure DoProforma(PTischkontoTabelle: TIBOQuery; PRechID: Integer);
    procedure DeleteHilfTischkontoFromServer(PDeleteHilfTischkonto: Boolean);
// **************************************************************

// *********** TransferToGuest functions for ZimmerTeilUmbuchung(copied from KASSE) ***********
    procedure TransferToZimmer(PReservID: Integer;
      PZimmer, PGastadresseID:string);
    procedure WriteToGastkonto(PTischNr:string; PReservID: Integer;
      PDatum: TDateTime; PTime: TTime; PBetrag: Double;
      PMehrwertsteuer: Integer; PText:string; PMenge: Integer;
      PHauptgruppe, PGastadresseID, PZimmer:string; PArtikelID: Integer);
    procedure WriteToKassenJournalIB(PFirma, PReservID:
      Integer; PZimmerNr, PTischNr:string; PDatum: TDateTime; PTime: TTime;
      PLeistungsID: Integer; PBetrag: Double; PMenge: Integer);
    procedure WriteHotelLog(PText:string; PDatum: TDateTime;
      PKellnerID, PVonTischID: Integer; PReservID, PZimmerNR:string);
    procedure WriteToKassInfo(PTischNr:string; PReservID:string;
      PBetrag: Double; PMehrwertsteuer, PLeistungsID: Integer;
      PText:string; PHauptGruppeID, PArtikelID: Integer;
      PMenge: Integer; PZimmerNr:string);
    procedure CheckRoomDiscount;
    procedure WriteToJournalControl(PText:string; PZahlwegID,
      PMenge, PArtikelID, PBeilagenID, PJournalTyp, POffeneTischID: Variant;
      PBetrag: Double; PVonOffeneTischID, PRechnungsID, PNachlass: Variant;
      PKellnerID: Integer);
// **************************************************************

// *********** open/close table functions (copied from KASSE) ***********
     // Tisch in der Datenbank freigeben. Wenn keine Artikel mehr drauf sind, dann Offen = FALSE
    procedure Tischschliessen;
     // Tisch sperren und Transaktion starten
    function LockTisch(POffeneTischID: Integer): Boolean;
     // Tisch entsperren und je nach Parameter Commit oder Rollback
    function UnLockTisch(PCommit: Boolean): Boolean;
// **************************************************************

// *********** 27.05.2010 BW: new functions for moving articles between table accounts  ***********
    function RemoveTableAccountEntry(PTargetAccount, PSourceAccount: TDataSet;
      PTableAccountID: Integer; PFactor: Integer): Boolean;
    procedure RemoveAllTableAccountEntries(PAccount: TDataSet);
    procedure AddTableAccountEntry(PTargetAccount, PSourceAccount: TDataSet;
      PTableAccountID: Integer; PFactor: Integer);
    procedure InsertTableAccountEntryIntoAccount(PTargetAccount,
      PSourceAccount: TDataSet; PTableAccountID: Integer; PAmount: Double);
    procedure UpdateTableAccountEntryIntoAccount(PTargetAccount: TDataSet;
      PTableAccountID: Integer; PAmount: Double);
    function CheckPriceChanged(PTargetAccount: TDataSet): Boolean;
// **************************************************************

// *********** 27.05.2010 BW: new get functions ***********
    function GetPricebyPriceLevel(PPriceLevel: Integer): Double;
    // old get function (copied from KASSE)
    function GetPreisEbene: Integer;
// **************************************************************

    // 23.09.2014 KL: Table ersetzen durch Query
    function CheckReservId(PFirma, PReservID: Integer): Boolean;
    function CheckReservIdCheckIn(PFirma, PReservID: Integer): Boolean;

  public

    FRechNr: Integer;
    FIsSplit: Boolean;
    FKasseID: Integer;

    // 14.07.2010 BW: new fields
    FTableID: Integer;
    FArticleID: Integer;
    FTableAccountID: Integer;
    FTableAccountID_modifyprice: Integer;
    FFreeTextInput:string;
    FWaiterID: Integer;
    FTableType: TTableTypes;
    FTableMode: TTischArt;
    FStationID: Integer;
    FRoomID: Integer;
    FMasterTableID: Integer;
    FisReactivationMode: Boolean;
    FPrint_PaymentMethodID: Integer;
    FPrint_Discount: Double;
    FPrint_isKassierBon: Boolean;
    FPrint_AmountofPrintouts: Byte;
    FTableSearchString:string;
    FTableGroupID_SwitchtingBar: Integer;

    // 24.11.2010 BW: not used now or anymore
    FHappyHourAn, FHappyHourAus: Boolean;
    FTischpax: Integer;
    FSprache: Integer;

// *********** universal functions (copied from KASSE) ***********
    // Definiert die Datenbank KASSE
    procedure SetupDatabase(PSerialNumber, PKasseID: Integer);
    // delete table HILF_TISCHKONTO and CDSHilfKonto
    procedure DeleteHilfTischkonto(PDeleteCDS: Boolean = True);
    // Eine neue Bonnummer holen
    procedure SetBonNr;
// **************************************************************

// *********** Billing functions (copied from KASSE) ***********
    // Holt die letzte Rechnung des übergebenen Tisches
     // Result: 0 = keine Rechnung
     // sonst RechnungsID
    function HoleRechnungen(PTischID: Integer): Integer;
     // die übergebene RechnungsID reaktivieren
    function ReaktiviereRechnung(PRechID: Integer): Boolean;
    // Kompletten Tisch abrechnen
    procedure SetSofortRechnung(PTyp: Integer; PTischkontoTable: TIBOQuery;
      PZahlweg: Integer; PRabatt: Real; PAdresseID, PAnzahl: Integer);
    procedure WriteUmbuchToJournal(PTischID, PTyp: Integer;
      PText, PZimmerNR:string);
// **************************************************************

// *********** TransferToGuest/Table functions (copied from KASSE) ***********
    function ZimmerTeilUmbuchen(PReservID, PDruckerID,
      PAnzahl: Integer): Boolean;
    function CheckZimmer(PZimmerID: Integer): Integer; overload;
    function CheckZimmer(PZimmerNr:string): Integer; overload;
    // Vergleicht die Tischpreisebenen bei Umbuchungen und passt die Preise am Zieltisch gegebenfalls an
    procedure CheckPreisChange(PVonOffeneTischID, PZuOffeneTischID: Integer;
      PTeil: Boolean);
// **************************************************************

// *********** open/close table functions (copied from KASSE) ***********
    // Geht in den bereits belgten Tisch oder öffnet den Tisch Neu
     // Result FALSE: Tisch konnte nicht geöffnet werden (z.b. weil wer anderer drin ist
    function Tischoeffnen(PTischID: Integer;var PErrorMessage:string): Boolean;
     // Sucht den Tisch, schickt die noch nicht bonierten Artikel zum Server und ruft "Tischschliessen" auf
    procedure Tischbeenden(PTischID: Integer);
    function LocateOffenenTisch(PTischTyp:string; PTischID: Integer): Boolean;
    // Liefert ALLE oder Belegte Tische in der QueryTisch zurück
    procedure GetTische(PTischart: TTischart; PTischTyp:string;
      PSplitTischID, PRevierID: Integer; PTableSearchString:string);
// **************************************************************

// *********** 27.05.2010 BW: new functions for add/modify articles/sideorders ***********
    procedure AddArticle(PTargetAccount: TDataSet;
      PArticleID, PMultiplier: Integer);
    procedure AddSideOrder(PTargetAccount: TDataSet;
      PTableAccountID, PSideOrderID: Integer);
    procedure ModifyPricebyValue(PTargetAccount: TDataSet;
      PTableAccountID: Integer; PPrice: Double);
    procedure ModifyPricebySideOrder(PTargetAccount: TDataSet;
      PSideOrderCounter: Integer);
// **************************************************************

// *********** 27.05.2010 BW: new functions for moving articles between table accounts  ***********
    procedure MoveArticleFromAccount(PTableAccountId: Integer;
      PFactor: Integer);
    procedure MoveArticleToAccount(PTableAccountId: Integer; PFactor: Integer);
    procedure GetTableAccount(PTargetAccount: TClientDataSet;
      PSourceAccount: TIBOQuery);
    procedure SendTableAccount(PTargetAccount, PSourceAccount: TDataSet);
    procedure MoveTableAccount(PTargetAccount, PSourceAccount: TDataSet);
    procedure ChangeTableAccount(PTargetAccount: TDataSet;
      POpenTableID: Integer);
    procedure SetTableAccount(POpenTableID: Integer);
    procedure SumArticlesinTableAccount(PTargetAccount, PSourceAccount
      : TDataSet);
// **************************************************************

// *********** 27.05.2010 BW: new check functions ***********
    function CheckLoginName(PLoginName:string): Boolean;
    function CheckLoginPassword(PLoginPassword:string): Boolean;
    function CheckSplitTables(PTableID: Integer): Boolean;
    function CheckHasHotelInterface: Boolean;
    function CheckTableAccountEmpty(PAccount: TDataSet): Boolean;
    // 03.02.2012 19:35 KL: ceck if there is one ore more rooms tallied at table account
    function CheckTableAccountHasRooms(PAccount: TDataSet): Boolean;

    // 07.04.2011 BW: new check function for side order obligation in order to deny DoTally
    function CheckTableAccountSideOrderObligation(PAccount: TDataSet): Boolean;
    function CheckWaiterRight(PWaiterHasRight: Boolean): Boolean;
// **************************************************************

// *********** 27.05.2010 BW: new get functions ***********
    function GetArticleIDbyTableAccountID(PTargetAccount: TDataSet;
      PTableAccountID: Integer): Integer;
    function GetOpenTableIDbyTableID(PTableID: Integer): Integer;
    function GetTableNumberbyTableID(PTableID: Integer):string;
    function GetTableIDbyTableName(PTablename:string): Integer;
    function GetGuestNamebyReservId(PReservID: Integer):string;
    function GetTableDescriptionbyTableID(PTableID: Integer):string;
    function GetTableDescription:string;
    function GetTableTypeAbbreviationbyTableID(PTableID: Integer):string;
    function GetTablenumber:string;
    function GetWaiterName:string;
    function GetLoginName:string;
    function GetLoginNamebyWaiterID(PWaiterID: Integer):string;
    function GetWaiterNamebyWaiterID(PWaiterID: Integer):string;
    function GetStationName:string;
    function GetPaymentMethodName:string;
    function GetSideOrderListName:string;
    function GetSideOrderIDbyTableAccountID(PTableAccountID: Integer): Integer;
    function GetAccountTotal(PAccount: TDataSet): Double;
    function GetLogInfoTablebyTableID(PTableID: Integer):string;
    function GetLogInfoWaiterbyWaiterID(PWaiterID: Integer):string;
    function GetLogInfoArticlebyArticleID(PArticleID: Integer):string;
    function GetLogInfoSideOrderbySideOrderID(PSideOrderID: Integer):string;
    function GetMobilePrinterNamebyPrinterID(PPrinterID: Integer):string;
    // 21.12.2013 KL: interne Zimmerverwaltung
    function GetGastname(PZimmerNr:string):string;

    // 08.03.2013 KL: TODO (11:30)
    function GetFertigeSpeisen(PWaiterID: Integer):string;
    function ConfirmFertigeSpeisen(PWaiterID: Integer):string;

// *********** properties for waiter rights (copied from KASSE) ***********
    property KellnerLagerNichtBon: Boolean read FKellnerLagerNichtBon;
    property KellnerLagerStorno: Boolean read FKellnerLagerStorno;
    property KellnerRechnung: Boolean read FKellnerRechnung;
    property KellnerGesamtRechnung: Boolean read FKellnerGesamtRechnung;
    property KellnerTeilRechnung: Boolean read FKellnerTeilRechnung;
    property KellnerSofortRechnung: Boolean read FKellnerSofortRechnung;
    property KellnerUmbuchen: Boolean read FKellnerUmbuchen;
    property KellnerGesamtUmbuchen: Boolean read FKellnerGesamtUmbuchen;
    property KellnerTeilUmbuchen: Boolean read FKellnerTeilUmbuchen;
    property KellnerStorno: Boolean read FKellnerStorno;
    property KellnerGesamtStorno: Boolean read FKellnerGesamtStorno;
    property KellnerTeilStorno: Boolean read FKellnerTeilStorno;
    property KellnerSofortStorno: Boolean read FKellnerSofortStorno;
    property KellnerBonDruck: Boolean read FKellnerBonDruck;
    property KellnerOhneDruck: Boolean read FKellnerOhneDruck;
    property Kellnerdarfreakt: Boolean read FKellnerdarfreakt;
    property KellnerdarfWechsel: Boolean read FKellnerdarfWechsel;
    property KellnerIsChef: Boolean read FKellnerIsChef;
    property KellnerStammgaeste: Boolean read FKellnerStammgaeste;
    property KellnerDarfXBon: Boolean read FKellnerDarfXBon;
    property KellnerDarfZBon: Boolean read FKellnerDarfZBon;
    property KellnerDarfSplitten: Boolean read FKellnerDarfSplitten;
    property KellnerDarfNachrichten: Boolean read FKellnerDarfNachrichten;
// **************************************************************

  end;

var
  DataPos: TDataPos;

implementation

{$R *.dfm}


uses
//PrintInterface,
IvDictio, PDMDrucken, PDMStatistik, Math,
  IdGlobal; // for iif

// ******************************************************************************
// Preisänderung beim Umbuchen?
// ******************************************************************************
procedure TDataPos.CheckPreisChange(PVonOffeneTischID, PZuOffeneTischID
  : Integer; PTeil: Boolean);
var APreisebeneQuelle, APreisebeneZiel: Integer;
begin
  if not pGl.ChangePriceOnTransfer then
    EXIT;

  with QueryCheckPreisebene do
  begin
    Close;
    ParamByName('OffeneTischID').AsInteger := PVonOffeneTischID;
    Open;
    APreisebeneQuelle := FieldByName('Preisebene').AsInteger;
    Close;
    ParamByName('OffeneTischID').AsInteger := PZuOffeneTischID;
    Open;
    APreisebeneZiel := FieldByName('Preisebene').AsInteger;
    Close;
    if(APreisebeneQuelle <> APreisebeneZiel)and
      not(((APreisebeneQuelle = 0)and(APreisebeneZiel = 1))or
      ((APreisebeneQuelle = 1)and(APreisebeneZiel = 0)))then
    begin
      // 24.11.2010 BW: exchange TableHilf_Tischkonto with CDSHilfKonto because OrdermanServer 8.5 and higher works with CDSHilfKonto during transfering
      with CDSHilfKonto do // TableHilf_Tischkonto Do
      begin
        if not PTeil then
        begin
          Close;
          ParamByname('pOffeneTischID').AsInteger := PVonOffeneTischID;
          Open;
        end;
        First;
        while not EOF do
        begin
          PDataStatistik.WriteToJournal(IvDictio.Translate('Preisumbuchung -'),
            Null,
            -FieldByName('Menge').AsInteger,
            FieldByName('ArtikelID').AsInteger, Null, 1,
            PVonOffeneTischID,
            FieldByName('Betrag').AsFloat, Null, Null, Null, FWaiterID,
            FALSE, Null);
          Next;
        end; // while
        First;
        QuerySelectArtikel.ParambyName('pFirma').AsInteger := Gl.Firma;
        while not EOF do
        begin
          QuerySelectArtikel.ParambyName('pArtikelID').AsInteger :=
            FieldByName('ArtikelID').AsInteger;
          QuerySelectArtikel.Open;
          if QuerySelectArtikel.Recordcount = 1 then
          begin
            Edit;
            case APreisebeneZiel of //
            0:
              if not QuerySelectArtikel.FieldByName('Preis1').IsNull then
                FieldByName('Betrag').AsFloat := QuerySelectArtikel.FieldByName
                  ('Preis1').AsFloat;
            1 .. 30:
              if not QuerySelectArtikel.FieldByName
                ('Preis' + IntToStr(APreisebeneZiel)).IsNull then
                FieldByName('Betrag').AsFloat := QuerySelectArtikel.FieldByName
                  ('Preis' + IntToStr(APreisebeneZiel)).AsFloat;
            end; // case
            Post;
            PDataStatistik.WriteToJournal
              (IvDictio.Translate('Preisumbuchung +'), Null,
              FieldByName('Menge').AsInteger,
              FieldByName('ArtikelID').AsInteger, Null, 1,
              PVonOffeneTischID,
              FieldByName('Betrag').AsFloat, Null, Null, Null, FWaiterID,
              FALSE, Null);
          end;
          QuerySelectArtikel.Close;
          Next;
        end; // while
      end; // with
    end;
  end; // with
end;

// ******************************************************************************
//
// ******************************************************************************
procedure TDataPos.DoProforma;
begin
   // und danach alle Artikel stornieren!!
   // Wenn gerade ein Datensatz im Edit-Modus ist, wird in den Tabellen
   // in BeforePost ein Abort gesetzt, damit man die Menge nicht verändern kann
   // Bei einem Storno wird dann ganz einfach ein Cancel gemacht.
  PTischkontoTabelle.Cancel;
  PDataStatistik.DeleteProformaFromJournal
    (TableOffeneTischeOffeneTischID.AsInteger,
    PRechID, PTischkontoTabelle, FWaiterID);

    // Jetzt die Rechnung wieder löschen!
  QueryDelRechZahlweg.ParamByName('RechnungsID').AsInteger := PRechID;
  QueryDelRechZahlweg.ExecSQL;
  QueryDelRechnung.ParamByName('ID').AsInteger := PRechID;
  QueryDelRechnung.ExecSQL;
  QueryDelRechnungskonto.ParamByName('RechnungsID').AsInteger := PRechID;
  QueryDelRechnungskonto.ExecSQL;
  PTischkontoTabelle.Open;
end;

// ******************************************************************************
//
// ******************************************************************************
procedure TDataPos.SetKasseIT(PRechnungsID: Integer; PRabatt, PNachlass: Real);
begin
  with QueryRechnungskontoIT do
  begin
    Close;
    ParamByName('RechnungsID').AsInteger := PRechnungsID;
    Open;
    First;

    TableKasseIt.Open;
    while not EOF do
    begin
      QuerySelectArtikel.ParambyName('pFirma').AsInteger := Gl.Firma;
      QuerySelectArtikel.ParambyName('pArtikelID').AsInteger :=
        FieldByName('ArtikelID').AsInteger;
      QuerySelectArtikel.Open;
      if(Trim(FieldByName('LeistungsText').AsString)= '')and
        (QuerySelectArtikel.RecordCount = 1)then
      begin
        TableKasseIt.Append;
        TableKasseIt.FieldByName('ID').AsInteger :=
          FieldByName('RechnungsID').AsInteger;
        TableKasseIt.FieldByName('Menge').AsInteger :=
          FieldByName('Menge').AsInteger;

        if PRabatt > 0 then
          TableKasseIt.FieldByName('Betrag').AsString :=
            Format('%.' + IntToStr(Gl.Nachkommastellen)+ 'n',
            [FieldByName('Betrag').AsFloat -(FieldByName('Betrag').AsFloat *
            PRabatt / 100)])
        else
          TableKasseIt.FieldByName('Betrag').AsString :=
            FieldByName('Betrag').AsString;

        TableKasseIt.FieldByName('Data').AsString :=
          QuerySelectArtikel.FieldByName('Bezeichnung').AsString;
        TableKasseIt.FieldByName('TischNr').AsString :=
          TableOffeneTische.FieldByName('LookTischNr').AsString;
        TableKasseIt.FieldByName('Gruppe').AsInteger :=
          TableTisch.FieldByName('GruppeID').AsInteger;
        TableKasseIt.FieldByName('Kellner').AsString := GetWaitername;
        TableArtikel.Open;
        TableHauptgruppe.Open;
        TableUntergruppe.Open;
        TableSteuer.Open;
        if TableUntergruppe.Locate('UntergruppeID',
          TableArtikel.FieldByName('UntergruppeID').AsInteger,[])and
          TableHauptgruppe.Locate('HauptgruppeID',
          TableUntergruppe.FieldByName('HauptgruppeID').AsInteger,[])and
          TableSteuer.Locate('ID',
          TableHAuptgruppe.FieldByName('SteuerID').AsInteger,[])then
        begin
          TableKasseIt.FieldByName('Abteilung').AsString :=
            TableSteuer.FieldByName('Mwst').AsString;
        end;

        TableKasseIt.Post;
      end;
      QuerySelectArtikel.Close;
      Next;
    end; // while
// if not gl.IsDBF then
    begin
      TableKasseIt.Append;
      TableKasseIt.FieldByName('ID').AsInteger :=
        FieldByName('RechnungsID').AsInteger;
      TableKasseIt.FieldByName('Menge').AsInteger := 0;
      TableKasseIt.FieldByName('Betrag').AsString := '0';
      TableKasseIt.FieldByName('Data').AsString := ':END';
      TableKasseIt.FieldByName('TischNr').AsString :=
        TableOffeneTische.FieldByName('LookTischNr').AsString;
      TableKasseIt.FieldByName('Gruppe').AsInteger :=
        TableTisch.FieldByName('GruppeID').AsInteger;
      TableKasseIt.FieldByName('Kellner').AsString := GetWaitername;
      TableKasseIt.Post;
    end;
    TableKasseIt.Close;
    Close;
  end; // with
end;

// ******************************************************************************
//
// ******************************************************************************
function TDataPos.GetPreisEbene: Integer;
var ADay: Integer;
  ATime: Real;
begin
  if FPreisEbeneTisch <> 0 then
    Result := FPreisEbeneTisch
  else
    Result := FKellnerPreisEbene;

  if Gl.HappyHour
    and not((TableTisch.FieldbyName('TischTyp').AsString = 'W')or
    (TableTisch.FieldbyName('TischTyp').AsString = 'E')or
    (TableTisch.FieldbyName('TischTyp').AsString = 'P')or
    (TableTisch.FieldbyName('TischTyp').AsString = 'B'))
  then
    with QueryHappyHour do
    begin
      FHappyHourAn := False;
      Open;
      ADay := DayOfWeek(Gl.KassenDatum)- 1;
      First;
      ATime := Time;
      if Atime >(1 -(1 /(24 * 60)))then
        Atime := 1 -(1 /(24 * 60));

      while not EOF do
      begin
        if(ATime <= FieldByName('UhrzeitBis').AsDateTime)and
          (ATime >= FieldByName('UhrzeitVon').AsDateTime)and
          (((ADay = FieldByName('WochenTag').AsInteger)and
          (FieldByName('WochenTag').Value <> NULL))or
          (Gl.KassenDatum = FieldByName('Datum').AsDateTime))and
          ((FieldByName('TischgruppeID').AsInteger = 0)or
          (FieldByName('TischgruppeID').AsInteger = TableTisch.FieldByName
          ('GruppeID').AsInteger))then
        begin
          Result := FieldByName('PreisEbene').AsInteger;
          FHappyHourAn := True;
        end;
        Next;
      end;
      Close;
    end;

  if FPreisEbene <> 1 then
    Result := FPreisEbene;

  if Result = 0 then
    Result := 1;
end;

// ******************************************************************************
// Tisch - Prozeduren
// ******************************************************************************
procedure TDataPos.DeleteHilfTischkonto(PDeleteCDS: Boolean = True);
begin
  if TableHilf_Tischkonto.State <> DsInactive then
  begin
// 2009-06-16   if TableHilf_Tischkonto.IB_Transaction.InTransaction then
// 2009-06-16   TableHilf_Tischkonto.IB_Transaction.CommitRetaining;
    TableHilf_Tischkonto.Close;
  end;

  with QueryToTisch do
  begin
    SQL.Clear;
    SQL.Add('DELETE FROM Hilf_Tischkonto Where Firma = ' + IntToStr(Gl.Firma));
    SQL.Add(' and OffeneTischID = ' +
      TableOffeneTische.FieldByName('OffeneTischID').AsString);
    ExecSQL;
  end;
// 2009-06-16 QueryToTisch.IB_Transaction.CommitRetaining;
  TableHilf_Tischkonto.ParambyName('pOffeneTischID').Value :=
    TableOffeneTische.FieldByName('OffeneTischID').AsInteger;
  TableHilf_Tischkonto.Open;

  // 18.12.2010 BW: also fetch new data from table HILF_TISCHKONTO into QueryHelpTableAccount
  with QueryHelpTableAccount do
  begin
    Close;
    ParambyName('pFirma').Asinteger := Gl.Firma;
    ParambyName('pOffeneTischID').Value := TableOffeneTische.FieldByName
      ('OffeneTischID').AsInteger;
    Open;
  end;

  // 25.07.2010 BW: Delete CDSHilfKonto, except the optional parameter pDeleteCDS is given with false!!
  if PDeleteCDS then
  begin
    CdsHilfKonto.Open;
    CdsHilfKonto.EmptyDataSet;
  end;
end;

// ******************************************************************************
//
// ******************************************************************************
procedure TDataPos.DeleteHilfTischkontoFromServer(PDeleteHilfTischkonto
  : Boolean);
begin
  with QueryFromTisch do
  begin
    TableHilf_Tischkonto.Close;
    TableHilf_Tischkonto.ParambyName('pOffeneTischID').Value :=
      TableOffeneTische.FieldByName('OffeneTischID').AsInteger;
    TableHilf_Tischkonto.Open;
    TableHilf_Tischkonto.First;
    SQL.Clear;
    SQL.Add('SELECT * FROM Tischkonto');
    SQL.Add('WHERE TischkontoID = :TischkontoID');
    RequestLive := TRUE;
    Prepare;
    while not TableHilf_Tischkonto.EOF do
    begin
      if TableHilf_Tischkonto.FieldByName('Gedruckt').AsBoolean then
      begin
        // Zuerst vom Server löschen
        Close;
        ParamByName('TischKontoID').AsInteger :=
          TableHilf_Tischkonto.FieldByName('TischkontoID').AsInteger;
        Open;
        if FieldByName('Menge').AsFloat > TableHilf_Tischkonto.FieldByName
          ('Menge').AsFloat then
        begin
          Edit;
          FieldByName('Menge').AsFloat := FieldByName('Menge').AsFloat -
            TableHilf_Tischkonto.FieldByName('Menge').AsFloat;
          if FieldByName('Firma').IsNull then
            FieldByName('Firma').AsInteger := Gl.Firma;

          if FieldByName('TischkontoID').IsNull then
            FieldByName('TischkontoID').AsInteger :=
              TableHilf_Tischkonto.FieldByName('TischkontoID').AsInteger;

          Post;
          repeat
            TableHilf_Tischkonto.Next;
          until not TableHilf_Tischkonto.FieldByname('ArtikelID').IsNull or
            TableHilf_Tischkonto.EOF;
        end
        else
        begin
          repeat
            Close;
            ParamByName('TischKontoID').AsInteger :=
              TableHilf_Tischkonto.FieldByName('TischkontoID').AsInteger;
            Open;
            try
              Delete;
            except
              Gl.DoLogFile(FSerialNumber,
                IVDictio.Translate
                ('ACHTUNG: Artikel im Tischkonto nicht gefunden!'));
            end;
            TableHilf_Tischkonto.Next;
          until not TableHilf_Tischkonto.FieldByname('ArtikelID').IsNull or
            TableHilf_Tischkonto.EOF;
        end;
      end
      else
      begin
        repeat
          TableHilf_Tischkonto.Next;
        until not TableHilf_Tischkonto.FieldByname('ArtikelID').IsNull or
          TableHilf_Tischkonto.EOF;
      end;
    end; // while
    Close;
    RequestLive := False;
    Unprepare;
    if PDeleteHilfTischkonto then
      DeleteHilfTischkonto;
  end; // with
end;

// ******************************************************************************
// Liefert ALLE oder Belegte Tische in der QueryTisch zurück
// ******************************************************************************
procedure TDataPos.GetTische(PTischart: TTischart; PTischTyp:string;
  PSplitTischID, PRevierID: Integer; PTableSearchString:string);
var
  ATischID:string;
  ADescription:string;
  AFirma: Integer;
begin

  // 03.11.2010 BW: get rid of "select * from tisch" because of speed optimization
  // instead make "select Tischid, aDescpription from tisch"
  // aDescription is always 'TischNr' except regular guests, because regular guests normally have their name in field 'Bezeichnung'
  if PTischTyp <> 'G' then
    ADescription := 'TischNr'
  else
    ADescription := 'Bezeichnung';
  // 24.02.2015 KL: TODO: #3230 iif(Bezeichnung isnull or bezeichnung='',TischNr,Bezeichnung)

  ATischID := IntToStr(PSplitTischID);
  // 31.08.2010 BW: obsolete, because gl.Kassendatum is now a property read GetDate
  // gl.GetDate;

  if Gl.FelixHotelFirma > 0 then
  // 05.01.2015 KL: Kroneck hat Version von Kurts PC
    AFirma := Gl.FelixHotelFirma
  else
    AFirma := Gl.Firma;

  with QueryTische do
  begin
    Close;
    if(PTischart = TT_AlleGaeste)then
    begin
      if Gl.HotelProgrammTyp = HpHotelFelix then
      begin
        QueryTische.IB_Connection := IB_ConnectionFelix;
        SQL.Clear;
        SQL.Add('SELECT Distinct(R.ZimmerID) AS ZimmerID, SubString(R.Gastname from 1 for 18) AS TischNR, R.ID AS TischID');
        SQL.Add('FROM Reservierung r, Zimmer z');
        SQL.Add('WHERE R.CheckIn = ''T'' AND R.Firma = ' + IntToStr(AFirma));
        // 05.01.2015 KL: war vorher:  = 1');
        SQL.Add('AND R.ZimmerID = ' + ATischID);
      end
      else
        if Gl.HotelProgrammTyp = HpAllgemeinSQL then
        begin
          QueryTische.IB_Connection := DBase.ConnectionZEN;
          SQL.Clear;
          SQL.Add('SELECT Distinct(ZI_Nummer) AS ZimmerID, Substring(ZI_Pers from 1 for 18) AS TischNR,');
          SQL.Add('Termin_Nr AS TischID, Pers_NR as gastadresseid, Zi_Pers as Gastname');
          SQL.Add('FROM GastInfo');
          SQL.Add('Where ZI_Nummer = ''' + ATischID + '''');
        end
    end

    else
      if(PTischart = TT_FelixZimmer)then
      begin
        if Gl.HotelProgrammTyp = HpHotelFelix then
        begin
          QueryTische.IB_Connection := IB_ConnectionFelix;
          SQL.Clear;
          SQL.Add('SELECT Distinct(ZimmerID) AS TischID, r.ID AS OffeneTischID, ');
          SQL.Add('z.ZimmerNr AS TischNr ');
          SQL.Add('FROM Reservierung r, Zimmer z');
          SQL.Add('WHERE r.CheckIn = ''T'' AND r.Firma = ' + IntToStr(AFirma));
          // 05.01.2015 KL: war vorher:  + IntToStr(gl.Firma));
          SQL.Add('AND r.ZimmerID = z.ID AND r.Firma = z.Firma');
          SQL.Add('AND (r.SperrenExtra = ''F'' OR r.SperrenExtra IS NULL)');
        end

        else
          if Gl.HotelProgrammTyp = HpAllgemeinSQL then
          begin
            QueryTische.IB_Connection := DBase.ConnectionZEN;
            SQL.Clear;
        // 16.08.2010 BW: delete query fields ZI_Pers AS Bezeichnung, Pers_NR as gastadresseid
        // and add a distinct
            SQL.Add('SELECT Distinct(ZI_Nummer) AS TischID,');
            SQL.Add('Termin_Nr AS OffeneTischID,');
            SQL.Add('ZI_Nummer AS TischNr, 0 AS Farbe, ');
            SQL.Add('1 As Firma');
            SQL.Add('FROM GastInfo');
            SQL.Add('Order By TischNr');
            RequestLive := FALSE;
          end
      end

      else
        if(PTischart = TT_ZimmerIntern)and(Gl.HotelProgrammTyp = HpHotelFelix)
        then
        begin
          QueryTische.IB_Connection := IB_ConnectionFelix;
          SQL.Clear;
          SQL.Add('SELECT Distinct(ZimmerID) AS TischID, r.ID AS OffeneTischID, ');
          SQL.Add('z.ZimmerNr AS Description ');
          SQL.Add('FROM Reservierung r, Zimmer z');
          SQL.Add('WHERE r.CheckIn = ''T'' AND r.Firma = ' + IntToStr(AFirma));
          // 05.01.2015 KL: war vorher:  +IntToStr(gl.Firma));
          SQL.Add('AND r.ZimmerID = z.ID AND r.Firma = z.Firma');
          SQL.Add('AND (r.SperrenExtra = ''F'' OR r.SperrenExtra IS NULL)');
        end

        else
        begin
          QueryTische.IB_Connection := DBase.ConnectionZEN;
          SQL.Clear;
          if(not(PRevierID = 0)and not(PTischart = TT_Split))and(PTischTyp = '')
          then
          begin
        // 03.11.2010 BW: exchange select t.* by select t.TischID, aDescription because of speed optimization
            SQL.Add('SELECT t.TischID, t.' + ADescription +
              ' as Description FROM REVIERGRUPPE RG ');
            SQL.Add('LEFT OUTER JOIN Tisch t');
            SQL.Add('On ((t.TischID = RG.TischID) or (T.OberTischID = RG.TischID)) and (T.Firma = 1)');
          end
          else
        // 03.11.2010 BW: exchange select * by select TischID, aDescription because of speed optimization
            SQL.Add('SELECT t.TischID, t.' + ADescription +
              ' as Description FROM Tisch t');

          if(PTischart = TT_Alle)then
          begin
        // 18.08.2010 BW: reset split mode to normal mode
            FIsSplit := False;
            if PTischTyp = '' then
            begin
              SQL.Add('WHERE (t.TischTyp = '''' or t.TischTyp IS NULL)');
              SQL.Add('      AND (t.ObertischID IS NULL)');
              SQL.Add('      AND ((t.Inaktiv IS NULL) or (t.Inaktiv=''F''))');
              // 07.08.2013 KL: #5698
            end
            else
            begin
              if FKellnerIsChef then
                SQL.Add('WHERE (t.TischTyp = ''' + PTischTyp + ''')')
              else
                if FKellnerWerbung and(PTischTyp = 'W')then
                  SQL.Add('WHERE (t.TischTyp = ''W'')')
                else
                  if FKellnerEigenbedarf and(PTischTyp = 'E')then
                    SQL.Add('WHERE (t.TischTyp = ''E'')')
                  else
                    if FKellnerPersonal and(PTischTyp = 'P')then
                      SQL.Add('WHERE (t.TischTyp = ''P'')')
                    else
                      if FKellnerBruch and(PTischTyp = 'B')then
                        SQL.Add('WHERE (t.TischTyp = ''B'')')
                      else
                        if FKellnerLagerAnzeigen and(PTischTyp = 'L')then
                        begin
                          SQL.Add('WHERE (t.TischTyp = ''L'')');
                          SQL.Add('AND t.TischID = ' +
                            IntToStr(FKellnerLagertisch))
                        end
                        else
                          if((PTischTyp = 'G')and FKellnerStammgaeste)or
                            (PTischTyp = 'S')or(PTischTyp = 'Z')
                          then
                            SQL.Add('WHERE (t.TischTyp = ''' +
                              PTischTyp + ''')')
                          else // nichts anzeigen - unbekannter Tischtyp
                            SQL.Add('WHERE (t.TischTyp = ''X'')');
          // der folgende Filter gilt für alle Tischtypen!
              SQL.Add('      AND (t.ObertischID IS NULL)');
              SQL.Add('      AND ((t.Inaktiv IS NULL) or (t.Inaktiv=''F''))');
              // 07.08.2013 KL: #5698
            end
          end

          else
            if PTischart = TT_Split then
            begin
              FIsSplit := True;
              Sql.Add('WHERE ((t.obertischid = ' + ATischID +
                ') or (t.TischID = ' + ATischID);
              Sql.Add(' and (t.obertischid is null))) ');
              SQL.Add(' AND ((t.Inaktiv IS NULL) or (t.Inaktiv=''F''))');
              // 07.08.2013 KL: #5698
              SQL.Add(' and not (t.TischID in');
              Sql.Add('(SELECT tisch.TischID FROM Tisch, offenetische ot');
              Sql.Add('WHERE ot.tischid = tisch.tischid AND ot.offen = ''T''');
              Sql.Add('AND tisch.Firma = ot.Firma');
              Sql.Add('AND ot.datum = ''' + DateToStr(Gl.KassenDatum)+ '''');
              Sql.Add('AND ((tisch.ObertischID = ' + ATischID + ')');
              Sql.Add('OR ((tisch.tischID = ' + ATischID +
                ') AND (tisch.ObertischID IS NULL)))))');
            end

            else
              if PTischart = TT_SplitOffen then
              begin
                FIsSplit := True;
                Sql.Add(', offenetische ot');
                Sql.Add('WHERE ot.tischid = t.tischid AND offen = ''T''');
                Sql.Add('AND t.Firma = ot.Firma');
                Sql.Add('AND ot.datum = ''' + DateToStr(Gl.KassenDatum)+ '''');
                Sql.Add('AND ((t.ObertischID = ''' + ATischID + ''')');
                Sql.Add('     OR ((t.tischID = ''' + ATischID +
                  ''') AND (t.ObertischID IS NULL)))');
              end

              else
                if PTischart = TT_Belegt then
                begin
                  SQL.Add('INNER JOIN OffeneTische OT');
                  SQL.Add('ON (T.TischID = OT.TischID)');

                  if(PTischTyp = 'G')then
                    SQL.Add('WHERE (t.TischTyp = ''' + PTischTyp + ''') ')
                  else // nichts anzeigen - unbekannter Tischtyp
                    SQL.Add('WHERE (t.TischTyp = ''' + PTischTyp +
                      ''' or t.TischTyp IS NULL) ');

                  SQL.Add('AND (OT.Offen = ''T'')');
                  if((PTischTyp <> 'G')and(PTischTyp <> 'S'))then
                    SQL.Add('AND (OT.Datum = ''' +
                      DateToStr(Gl.KassenDatum)+ ''')');

                  if(Gl.TischNurKellner)and not FKellnerIsChef then
                  begin
                    SQL.Add('AND ((OT.KellnerID = ' + IntToStr(FWaiterID)+ ')');
          // Smart Order tables do have waiter id = -2
                    SQL.Add('     OR (OT.KellnerID = -2))');
                  end;

                end

                else
                  if PTischart = TT_Offen then
                  begin
                    SQL.Add('Where not (T.TischID in (Select Ot.TischID from offeneTische OT');

                    if(PTischTyp = 'G')or(PTischTyp = 'S')then
                      SQL.Add('Where (Ot.Offen = ''T''))) and')
                    else
                      SQL.Add('Where (OT.Offen = ''T'' and OT.Datum = ''' +
                        DateToStr(Gl.KassenDatum)+ '''))) and');

                    if(PTischTyp = 'G')then
                      SQL.Add('(t.TischTyp = ''' + PTischTyp + ''') AND ')
                    else
                      SQL.Add('(t.TischTyp = ''' + PTischTyp +
                        ''' or t.TischTyp IS NULL) AND ');
          // SQL.Add(' (t.TischTyp = ''X'') AND');

                    SQL.Add('(T.ObertischID is Null)');
                  end;

      // Kellnertische beachten - geht nur ohne Verwendung von Makros
      // da wegen der Makros der Tisch immer angezeigt wird
// if not FKellnerIsChef then
// begin
// SQL.Add('and ((T.KellnerID = ' + IntToStr(FKellnerID) + ')');
// SQL.Add('or (T.KellnerID is Null))');
// end;

      // 25.08.2010 BW: if there is a table search string passed --> add another WHERE clause for table search
          if PTableSearchString <> '' then
          begin
            SQL.Add('AND ((UPPER(t.TischNr) LIKE ''' +
              UpperCase(PTableSearchString)+ ''')');
        // check if table type is regualar guests --> add a further OR clause,
        // because regualar guests have there names in field 'Bezeichnung' and this should also be searched
            if PTischTyp = 'G' then
            begin
          // 10.11.2010 BW: check if search string is only one character
              if Length(PTableSearchString)= 1 then
            // only one character --> get only regular guests that START with this character
                SQL.Add('OR (UPPER(t.Bezeichnung) LIKE ''' +
                  UpperCase(PTableSearchString)+ '%'')')
              else
            // more than one character --> make normal full context search
                SQL.Add('OR (UPPER(t.Bezeichnung) LIKE ''%' +
                  UpperCase(PTableSearchString)+ '%'')');
            end;
            SQL.Add(')');
          end;
      // 25.08.2010 BW: reset the table search string
          FTableSearchString := '';

      // Nur wenn es auch Reviere gibt
          if(not(PRevierID = 0)and not(PTischart = TT_Split))and(PTischTyp = '')
          then
          begin
            SQL.Add('and RG.RevierID = ' + IntToStr(PRevierID));
            SQL.Add('ORDER BY RG.Reihung, T.TischID')
          end
          else
          begin
            if Gl.StammgastSortieren and(PTischTyp = 'G')then
              SQL.Add('ORDER BY T.Bezeichnung, T.TischID')
            else
              SQL.Add('ORDER BY T.Reihung, T.TischID');
          end;
        end;
    Open;

    // 18.12.2013 KL: TODO (14:28)
    // gl.DoLogFile(FSerialNumber, '** ' + IntToStr(RecordCount) + ' Records @ ' + StringReplace(SQL.Text, sLineBreak, ' ', [rfReplaceAll]));
    // 18.12.2013 KL: TODO (14:29)

  end;
end;

// ******************************************************************************
// Liefert Gastname des eingecheckten Zimmers bei interner Zimmerverwaltung
// ******************************************************************************
function TDataPos.GetGastname(PZimmerNr:string):string;
begin
  Result := PZimmerNr;
  with QueryTische do
    try
      Close;
      QueryTische.IB_Connection := IB_ConnectionFelix;
      SQL.Clear;
      SQL.Add('SELECT r.Gastname FROM Reservierung r, Zimmer z');
      SQL.Add('WHERE r.CheckIn = ''T'' AND r.Firma = ' + IntToStr(Gl.Firma));
      SQL.Add('AND r.ZimmerID = z.ID AND r.Firma = z.Firma');
      SQL.Add('AND (r.SperrenExtra = ''F'' OR r.SperrenExtra IS NULL)');
      SQL.Add('AND z.ZimmerNr = ''' + PZimmerNr + ''' ');
      Open;
      if Recordcount > 0 then
        Result := FieldByName('Gastname').AsString;
    finally
      Close;
    end
end;

// ******************************************************************************
// Geht in den bereits belgten Tisch oder öffnet den Tisch Neu
// Result FALSE: Tisch konnte nicht geöffnet werden (z.b. weil wer anderer drin ist
// ******************************************************************************
function TDataPos.Tischoeffnen(PTischID: Integer;
  var PErrorMessage:string): Boolean;
var
  ALagertisch, ATischTyp:string;
  ALagerTischID, ATischID: Integer;
begin
  Result := FALSE;
  PErrorMessage := '';
  FPreisEbeneTisch := 0;
  FPreisEbene := 1;

  TableTisch.Close;
  TableTisch.Open;

  if not TableTisch.Locate('Firma;TischID', VarArrayOf([Gl.Firma, PTischID]),[])
  then
  begin
    PErrorMessage := Translate('Tisch mit der ID')+ ' ' + IntToStr(PTischID)+
      ' ' + Translate('nicht gefunden!');
    Exit;
  end;

  if not KellnerIsChef and not TableTisch.FieldByName('KellnerID').IsNull and
    (TableTisch.FieldByName('KellnerID').Asinteger <> FWaiterID)then
  begin
    PErrorMessage := Translate('Falscher Kellner fuer Kellnertisch')+ ' ' +
      IntToStr(PTischID);
    Exit;
  end;

  ALagerTischID := FKasseID; // gl.KasseID;
  FTischPax := TableTisch.FieldByName('Pax').AsInteger;
  ATischID := TableTisch.FieldByName('TischID').AsInteger;

  if Pgl.MehrereLagerJeKellner and(Gl.KasseID > 100)then
  // ACHTUNG FKasseID;//gl.KasseID;
  begin
    if(not TableTisch.FieldByName('GruppeID').IsNull)and
    // 23.03.2012 KL: check to NULL
      (TableTisch.FieldByName('GruppeID').AsInteger <> 0)then
    begin
      TableTischgruppe.Close; // 23.03.2012 KL: close before open
      TableTischgruppe.Open;
      if TableTischgruppe.Locate('TischgruppeID',
        TableTisch.FieldByName('GruppeID').AsInteger,[])then
      begin
        ALagertisch := 'L' + TableTischgruppe.FieldByName('SchankID').AsString;
        if not TableTisch.Locate('TischNr;TischTyp',
          VarArrayOf([ALagertisch, 'L']),[])then
          PErrorMessage := IvDictio.Translate('Lagertisch falsch definiert!')+
            ' ' + ALagertisch;
        ALagerTischID := TableTischgruppe.FieldByName('SchankID').AsInteger;
        TableTisch.Locate('Firma;TischID', VarArrayOf([Gl.Firma, ATischID]),[]);
      end
      else
      begin
        TableKellner.Close; // 23.03.2012 KL: close before open
        TableKellner.Open;
        if TableKellner.Locate('Firma;KellnerID',
          VarArrayOf([Gl.Firma, FWaiterID]),[])then
          ALagerTischID := TableKellner.FieldByName('LagertischID').AsInteger;
        TableKellner.Close;
      end;
      TableTischgruppe.Close;
    end;
// end
// else // 23.03.2012 KL: TODO: #1320 Bonierungen vom Lager abbuchen nach Tischgruppe
// begin
// if pgl.MehrereLagerJeKellner and
// (not TableTisch.FieldByName('GruppeID').IsNull) and // 23.03.2012 KL: check to NULL
// (TableTisch.FieldByName('GruppeID').AsInteger <> 0) then
// begin
// TableTischgruppe.Close; // 23.03.2012 KL: close before open
// TableTischgruppe.Open;
// if TableTischgruppe.Locate('TischgruppeID', TableTisch.FieldByName('GruppeID').AsInteger, []) then
// begin
// aLagertisch := 'L'+TableTischgruppe.FieldByName('SchankID').AsString;
// if not TableTisch.Locate('TischNr;TischTyp', VarArrayOf([aLagertisch, 'L']), []) then
// pErrorMessage := IvDictio.Translate('Lagertisch falsch definiert!') + ' ' + aLagertisch;
// aLagerTischID := TableTisch.FieldByName('TischID').AsInteger;
// TableTisch.Locate('Firma;TischID', VarArrayOf([gl.Firma, aTischID]), []);
// end;
// TableTischgruppe.Close;
// end;
  end;

  // set waiter and kasse in printerpackage
  DoOpenLagerTische(FWaiterID, FKasseID, ALagerTischID);

  ATischTyp := Trim(TableTisch.FieldbyName('TischTyp').AsString);

  // check if there is already an open table for this table
  if LocateOffenenTisch(ATischTyp, PTischID)then
  begin
    // if yes --> set Query TableOffeneTische to this table (former locate)
    if Gl.TischNurKellner and
      (FWaiterID <> TableOffeneTische.FieldByName('KellnerID').AsInteger)and
      (ATischtyp = '')and not FKellnerIsChef
       // Smart Order tables do have waiter id = -2
      and(TableOffeneTische.FieldByName('KellnerID').AsInteger > 0)
    then
    begin
      PErrorMessage := Translate('Tisch gehoert einem anderen Kellner');
      Exit;
    end
  end
  else
  begin
    // there is no open table --> create new entry in table OFFENETISCHE
    with QueryInsertOffeneTische do
    begin
      Sql.Clear;
      Sql.Text :=
        'INSERT INTO OffeneTische (Firma, TischID, Bezeichnung, GastadresseID, Offen, Datum, Beginn, KellnerID) VALUES (:Firma, :TischID, :Bezeichnung, :GastadresseID, :Offen, :Datum, :Beginn, :KellnerID)';
      ParamByName('Firma').AsInteger := Gl.Firma;
      ParamByName('TischID').AsInteger := PTischID;
      ParamByName('Bezeichnung').AsString :=
        TableTisch.FieldByName('Bezeichnung').AsString;
      ParamByName('GastadresseID').AsInteger :=
        TableTisch.FieldByName('TischgruppeID').AsInteger;
      ParamByName('Offen').AsString := 'T';
      ParamByName('Datum').AsDateTime := Gl.KassenDatum;
      ParamByName('Beginn').AsDateTime := Gl.KassenDatum + Time;
      ParamByName('KellnerID').AsInteger := FWaiterID;
      ExecSQL;
    end;
    // 14.12.2010 BW: senseless because of exchange table/locate with query/params
    // TableOffeneTische.Refresh;

    // set Query TableOffeneTische to this table (former locate)
    if not LocateOffenenTisch(ATischTyp, PTischID)then
    begin
      PErrorMessage := Translate('Kein offener Tisch zu ID')+ ' ' +
        IntToStr(PTischID);
      Exit;
    end;
  end;

  // lock table
  if not LockTisch(TableOffeneTische.FieldByName('OffeneTischID').AsInteger)then
  begin
    PErrorMessage := Translate('Tisch bereits geoeffnet von ')+
      GetWaiterNamebyWaiterID(TableOffeneTische.FieldByName('CurrentWaiterID')
      .AsInteger);
    Exit;
  end;

  if TableTisch.FieldByName('tischTyp').AsString = 'P' then
    FPreisEbeneTisch := 99
  else
    FPreisEbeneTisch := TableTisch.FieldByName('Preisebene').AsInteger;
  FPreisebene := GetPreisEbene;

  Result := TRUE;
end;

// ******************************************************************************
//
// ******************************************************************************
procedure TDataPos.CheckRoomDiscount;
var ARabatt: Single;
  ABetrag: Double;
// aTiKoID: Integer;
begin
  IBOQuerygetRabatt.ParamByName('pPers_Nr').AsInteger :=
    QueryTische.FieldByName('GastAdresseID').AsInteger;
  IBOQuerygetRabatt.Open;
  // 16.08.2010 BW: if db field RT is NULL --> set aRabatt 0 and therefore do nothing!
  if IBOQuerygetRabatt.Fieldbyname('RT').Isnull then
    ARabatt := 0
  else
    ARabatt := IBOQuerygetRabatt.FieldByName('RT').AsFloat;
  IBOQuerygetRabatt.Close;
  if ARabatt <> 0 then
    with QueryRoomDiscount do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT Firma, ArtikelID, Betrag, SUM(Menge) AS Menge, OffeneTischID');
      SQL.Add('FROM Hilf_Tischkonto');
      SQL.Add('WHERE OffeneTischID = ' +
        TableOffeneTische.FieldByName('OffeneTischID').AsString +
        ' AND Firma = ' + IntToStr(Gl.Firma));
      SQL.Add('AND Betrag <> 0');
      SQL.Add('GROUP BY Firma, ArtikelID, Betrag, OffeneTischID');
      Open;
      TableHilf_Tischkonto.Open;
      TableHilf_Tischkonto.Last;
// aTiKoID := TableHilf_Tischkonto.FieldByName('TischkontoID').AsInteger;
      while not EOF do
      begin
        QueryGetHaupgruppeVorSum.Close;
        QueryGetHaupgruppeVorSum.ParamByName('ArtikelID').AsInteger :=
          FieldByName('ArtikelID').AsInteger;
        QueryGetHaupgruppeVorSum.Open;
        if QueryGetHaupgruppeVorSum.FieldByName('VorSum').IsNull then
        begin
          ABetrag := Round(FieldByName('Betrag').AsFloat * ARabatt)/ 100;
          WriteToJournalControl(IvDictio.Translate('Rabatt'), Null,
            -FieldByName('Menge').AsInteger,
            FieldByName('ArtikelID').AsInteger, Null, 1,
            TableOffeneTische.FieldByName('OffeneTischID').AsInteger,
            ABetrag, Null, Null, Null, FWaiterID);
// inc(aTiKoID);
          TableHilf_Tischkonto.Append;
          TableHilf_Tischkonto.FieldByName('I_DeviceGuid').AsString := '';
          TableHilf_Tischkonto.FieldByName('Firma').AsInteger := 1;
          TableHilf_Tischkonto.FieldByName('OffeneTischID').AsInteger :=
            TableOffeneTische.FieldByName('OffeneTischID').AsInteger;
// DataTische.TableHilf_Tischkonto.FieldByName('TischkontoID').AsInteger := aTikoID;
// DataTische.TableHilf_Tischkonto.FieldByName('Datum').AsDateTime := gl.Datum;
          TableHilf_Tischkonto.FieldByName('ArtikelID').AsInteger :=
            FieldByName('ArtikelID').AsInteger;
          TableHilf_Tischkonto.FieldByName('Menge').AsInteger :=
            -FieldByName('Menge').AsInteger;
          TableHilf_Tischkonto.FieldByName('Betrag').AsFloat := ABetrag;
          TableHilf_Tischkonto.FieldByName('Gedruckt').AsBoolean := TRUE;
          TableHilf_Tischkonto.FieldByName('Verbucht').AsBoolean := TRUE;
          TableHilf_Tischkonto.FieldByName('KellnerID').AsInteger := FWaiterID;
          TableHilf_Tischkonto.FieldByName('Datum').AsDateTime :=
            Gl.KassenDatum;
          TableHilf_Tischkonto.Post;
        end;
        Next;
      end; // while
      QueryGetHaupgruppeVorSum.Close;
      Close;
    end;
end;

// ******************************************************************************
//
// ******************************************************************************
procedure TDataPos.WriteToJournalControl(PText:string; PZahlwegID,
  PMenge, PArtikelID, PBeilagenID, PJournalTyp, POffeneTischID: Variant;
  PBetrag: Double; PVonOffeneTischID, PRechnungsID, PNachlass: Variant;
  PKellnerID: Integer);
begin
  try
    with QueryJournalControl do
    begin
      ParamByName('Firma').AsInteger := Gl.Firma;
      ParamByName('KellnerID').AsInteger := PKellnerID;
      ParamByName('OffeneTischID').Value := POffeneTischID;
      ParamByName('Datum').AsDateTime := Gl.KassenDatum;
      ParamByName('Zeit').AsDateTime := Time;
      ParamByName('KasseID').AsInteger := Gl.KasseID;
      ParamByName('JournalTyp').Value := PJournalTyp;
      ParamByName('Text').AsString := Copy(PText, 1, 50);
      ParamByName('Menge').Value := PMenge;
      ParamByName('ZahlwegID').Value := PZahlwegID;
      ParamByName('Betrag').AsFloat := PBetrag;
      ParamByName('ArtikelID').Value := PArtikelID;
      ParamByName('BeilagenID').Value := PBeilagenID;
      ParamByName('VonOffeneTischID').Value := PVonOffeneTischID;
      ParamByName('RechnungsID').Value := PRechnungsID;
      ParamByName('Nachlass').Value := PNachlass;
      ParamByName('Lagerverbucht').AsString := 'T';
      ParamByName('LagerDatum').AsDateTime := Gl.KassenDatum;
      Prepare;
      ExecSQL;
    end;
  except
    on E: Exception do
      Gl.DoLogError(FSerialNumber,
        Translate('129: Fehler in WriteTojournalControl')+ #13 + E.Message);
  end;

end;

// ******************************************************************************
// Teilumbuchen auf Zimmer
// ******************************************************************************
function TDataPos.ZimmerTeilUmbuchen(PReservID, PDruckerID,
  PAnzahl: Integer): Boolean;
var
  ATischID, ZuTischID, AFirma: Integer;
  ATischTyp, AzuTischTyp, AVonTisch, ANachTisch, ATischNr,
    AGastadresseID, AGastname, AUmbuchungstext:string;
begin
  Result := False;
  ZuTischID :=-1;
  AGastadresseID := '';
  AGastname := '';

  if(Gl.HotelProgrammTyp = HpHotelFelix)then
  begin
    if Gl.FelixHotelFirma > 0 then
      AFirma := Gl.FelixHotelFirma
    else
      AFirma := Gl.Firma;

    if not CheckReservId(AFirma, PReservID)then
    begin
      Gl.DoLogError(FSerialNumber,
        IvDictio.Translate
        ('Gesamtumbuchen - Reservierung nicht gefunden - ID: ')+
        IntToStr(PReservID));
      Exit;
    end
    else
    begin
      ZuTischID := QueryReservFELIX.FieldbyName('ZimmerID').AsInteger;
      AGastname := QueryReservFELIX.FieldbyName('GastName').AsString;
    end;

    TableZimmerFELIX.Open;
    if not TableZimmerFELIX.Locate('Firma;ID',
      VarArrayOf([AFirma, ZuTischID]),[])then
    begin
      Gl.DoLogError(FSerialNumber,
        IvDictio.Translate('Gesamtumbuchen - zuTisch nicht gefunden - ID: ')+
        IntToStr(ZuTischID));
      Exit;
    end
    else
      AzuTischTyp := Trim(TableTisch.FieldbyName('TischTyp').AsString);

    if(Gl.HotelProgrammTyp = HpHotelFelix)then
      ATischNr := Trim(TableZimmerFELIX.FieldbyName('ZimmerNr').AsString)
    else
      ATischNr := Trim(QueryTische.FieldbyName('ZimmerID').AsString);

    ATischID := TableTisch.FieldByName('TischID').AsInteger;
    TableZimmerFELIX.Close;
  end
  else
  begin
    if QueryTische.EOF then
      QueryTische.Prior;

    AzuTischTyp := Trim(TableTisch.FieldbyName('TischTyp').AsString);
    ATischNr := Trim(QueryTische.FieldbyName('ZimmerID').AsString);
    ATischID := TableTisch.FieldByName('TischID').AsInteger;
    AGastadresseID := Trim(QueryTische.FieldbyName('GastAdresseID').AsString);
    AGastname := Trim(QueryTische.FieldbyName('Gastname').AsString);
  end;

  if not TableTisch.Locate('Firma;TischID', VarArrayOf([Gl.Firma, ATischID]),[])
  then
  begin
    Gl.DoLogError(FSerialNumber,
      Translate('ZimmerTeilumbuchen - vonTisch zu ID nicht gefunden ')+
      IntToStr(ATischID));
    EXIT;
  end;

  ATischTyp := Trim(TableTisch.FieldbyName('TischTyp').AsString);
  if not LocateOffenenTisch(ATischTyp, ATischID)then
  begin
    Gl.DoLogError(FSerialNumber,
      Translate('Teilumbuchen - offenen Tisch nicht gefunden ID: ')+
      IntToStr(ATischID));
    Exit;
  end;

  ANachTisch := Translate('Hotel: ')+ ATischNr + TrimRight(' ' + AGastname);
  if Trim(TableOffeneTische.FieldByName('LookTischNr').AsString)<>
    Trim(TableOffeneTische.FieldByName('Bezeichnung').AsString)then
    AVonTisch := Trim(TableOffeneTische.FieldByName('LookTischNr').AsString)+
      ' - ' +
      Trim(TableOffeneTische.FieldByName('Bezeichnung').AsString)
  else
    AVonTisch := Trim(TableOffeneTische.FieldByName('Bezeichnung').AsString);

  // Überprüfen, ob Tisch vorhanden ist
  TableTisch.Locate('Firma;TischID', VarArrayOf([Gl.Firma, ATischID]),[]);
  ATischTyp := Trim(TableTisch.FieldbyName('TischTyp').AsString);
  if not LocateOffenenTisch(ATischTyp, ATischID)then
    Gl.DoLogFile(FSerialNumber,
      Translate('Teilumbuchen - offenen Tisch nicht gefunden ID: ')+
      IntToStr(ATischID))
  else
    Gl.DoLogFile(FSerialNumber,
      Format(Translate('Teilumbuchen von Tisch %s nach Zimmer %s'),
      [IntToStr(ATischID), IntToStr(ZuTischID)]));

  { for i := 0 to RecordCount - 1 do
  begin
    aTischKontoID := getStrToInt(copy(aStr, i*recordlength + 1, 10));
    DataTische.IsnertHilfkontoToTischkonto(aTischkontoID,
      Translate('Teilumbuchen - TischkontoID nicht gefunden ID: '));
  end; }
  if(Gl.HotelProgrammTyp = HpAllgemeinSQL)then
    CheckRoomDiscount;

  // 09.02.2015 KL: #7759: pLoginKellner setzen, damit er richtig am Umbuchungsbon steht.
  DoSetPrintpackage(Getorderman(FSerialNumber).FDataBase.FWaiterID, FKasseID);

  // 11.10.2010 BW: do not print bon if printerid = 0 ('kein Druck')!
  // 10.11.2015 KL: beim Umbuchen auf Zimmer IMMER Bon Drucken!
  if(Gl.DruckeUmbuchungsBon and(PDruckerID <> 0))
    or((PAnzahl > 0)and(PDruckerID <> 0))
    or((AzuTischTyp <> '')and(AzuTischTyp[1] in['W', 'E', 'P', 'B']))then
    DoDruckeBon(TableOffeneTische.FieldByName('OffeneTischID').AsInteger,
      DaTeilUmbuchung, PAnzahl, Gl.KassenDatum, AVonTisch, ANachTisch,
      PDruckerID, True, Gl.SpracheID, 0);

  AUmbuchungstext := IntToStr(Pgl.BonNr)+ Translate(' Hotel: ')+ ATischNr +
    Iif(LowerCase(ExtractFileName(ParamStr(0)))= 'ordermanserver.exe',
    ' (Orderman)', ' (Smart-Order)');
  WriteUmbuchToJournal(PReservID, 9, AUmbuchungstext, ATischNr);
  TransferToZimmer(PReservID, ATischNr, AGastadresseID);

  Result := True;
end;

// ******************************************************************************
// ReservID zu ZimmerID holen
// bei INTEGER wird KEIN JOIN auf Tabelle ZIMMER gemacht!
// ******************************************************************************
function TDataPos.CheckZimmer(PZimmerID: Integer): Integer;
begin
  Result := 0;

  with QueryCheckZimmerIB do
    try
      Close;
      SQL.Clear;

      if Gl.HotelProgrammTyp = HpAllgemeinSQL then // Firebird Allgemein SQL = 3
      begin
        SQL.Add('SELECT Termin_Nr AS ID, zi_pers AS Gastname, Pers_Nr as GastadresseID, RT AS ZimmerID');
        SQL.Add('  FROM Gastinfo ');
        SQL.Add(' WHERE zi_nummer = :ZimmerID ');
      end
      else
        if Gl.HotelProgrammTyp = HpHotelFelix then // Hotel Felix = 4
        begin
          SQL.Add(' SELECT r.ID, r.Gastname, r.GastadresseID, r.ZimmerID ');
          SQL.Add('   FROM Reservierung r ');
          SQL.Add('  WHERE (r.CheckIn = ''T'') ');
          SQL.Add('    AND (r.SperrenExtra = ''F'' OR r.SperrenExtra IS NULL) ');
          if Gl.FelixHotelFirma > 0 then
            SQL.Add('  AND (r.Firma = ' + IntToStr(Gl.FelixHotelfirma)+ ') ');
          SQL.Add('    AND (r.ZimmerID = :ZimmerID) ');
        end
        else // weder noch
        begin
          Gl.DoLogError(FSerialNumber,
            IvDictio.Translate('HotelProgrammTyp falsch in CheckZimmer: ')
            + IntToStr(Ord(Gl.HotelProgrammTyp)));
          EXIT;
        end;

      ParamByName('ZimmerID').AsInteger := PZimmerID;
      Open;
      if RecordCount > 0 then
        Result := FieldByName('ID').AsInteger;
    except
      on E: Exception do
        Gl.DoLogError(FSerialNumber, IvDictio.Translate('Fehler in CheckZimmer')
          + #13 + E.Message);
    end;
end;

// ******************************************************************************
// ReservID zu ZimmerNR holen
// bei STRING wird ein JOIN auf Tabelle ZIMMER gemacht!
// ******************************************************************************
function TDataPos.CheckZimmer(PZimmerNr:string): Integer;
begin
  Result := 0;

  with QueryCheckZimmerIB do
    try
      Close;
      SQL.Clear;

      if Gl.HotelProgrammTyp = HpAllgemeinSQL then // Firebird Allgemein SQL = 3
      begin
        SQL.Add('SELECT Termin_Nr AS ID, zi_pers AS Gastname, Pers_Nr as GastadresseID, RT AS ZimmerID ');
        SQL.Add('  FROM Gastinfo ');
        SQL.Add(' WHERE zi_nummer = ''' + PZimmerNr + ''' ');
      end
      else
        if Gl.HotelProgrammTyp = HpHotelFelix then // Hotel Felix = 4
        begin
          SQL.Add(' SELECT r.ID, r.Gastname, r.GastadresseID, r.ZimmerID ');
          SQL.Add('   FROM Reservierung r ');
          SQL.Add('  INNER JOIN Zimmer z ON (r.FIRMA = z.FIRMA) and (r.ZIMMERID = z.ID) ');
          SQL.Add('  WHERE (r.CheckIn = ''T'') ');
          SQL.Add('    AND (r.SperrenExtra = ''F'' OR r.SperrenExtra IS NULL) ');
          if Gl.FelixHotelFirma > 0 then
            SQL.Add('  AND (r.Firma = ' + IntToStr(Gl.FelixHotelfirma)+ ') ');
          SQL.Add('    AND (z.ZimmerNr = ''' + PZimmerNr + ''') ');
        end
        else // weder noch
        begin
          Gl.DoLogError(FSerialNumber,
            IvDictio.Translate('HotelProgrammTyp falsch in CheckZimmer: ')
            + IntToStr(Ord(Gl.HotelProgrammTyp)));
          EXIT;
        end;

      Open;
      if RecordCount > 0 then
        Result := FieldByName('ID').AsInteger;
    except
      on E: Exception do
        Gl.DoLogError(FSerialNumber,
          IvDictio.Translate('Fehler in CheckZimmer: ')+ #13 + E.Message);
    end;

end;

// *****************************************************************************
// Italien hat eigenen Hotelanschluss
// *****************************************************************************
procedure TDataPos.WriteToKassInfo(PTischNr:string;
  PReservID:string; PBetrag: Double; PMehrwertsteuer,
  PLeistungsID: Integer; PText:string;
  PHauptGruppeID, PArtikelID: Integer; PMenge: Integer; PZimmerNr:string);
var AReservID, AWriteReservID:string;
  I: Integer;
begin
  with TableKassinfo do
  begin
    TableGastinfo.Open;
    AREservID := PReservID;
    // Wurde für Phönix wieder reingegeben
    for I := Length(AREservID)to 5 do // Iterate
    begin
      AReservID := '0' + AReservID;
    end; // for
    if TableGastinfo.Locate('Termin_NR;Zi_Nummer',
      VarArrayOf([AReserVID, PZimmerNr]),[])then
    begin
      AWriteReservID := AReservID;
    // oder nach normaler ReservID
    end
    else
      if TableGastinfo.Locate('Termin_NR;Zi_Nummer',
        VarArrayOf([PReserVID, PZimmerNr]),[])then
      begin
        AWriteReservID := PReservID;
      end
      else
        Gl.DoLogError(FSerialNumber,
          IVDictio.Translate('14563: Reservierung nicht gefunden!'));
    Open;
    Append;
    if Gl.HotelProgrammTyp = HpAllgemeinSQL then
      FieldByName('ID').AsInteger := PDataDrucken.GetNextGENID
        ('KassInfo', TRUE);

    TableLeistung.Open;
    if not TableLeistung.Locate('ID', PLeistungsID,[])then
      Gl.DoLogError(FSerialNumber,
        Format(IvDictio.Translate
        ('Umbuchen Hotelprogramm: Leistung %s nicht gefunden'),
        [IntToStr(PLeistungsID)]));
    if Gl.HotelEinzelnBuchen then
      FieldByName('KurzBez').AsString := PText
    else
      FieldByName('KurzBez').AsString :=
        Copy(TableLeistung.FieldByName('LeistungsBezeichnung').AsString, 1, 14);
    FieldByName('Anzahl').AsInteger := PMenge;
    FieldByName('Preis').AsFloat := PBetrag;
    FieldByName('Summe').AsFloat := PBetrag * PMenge;
    FieldByName('Steuer').AsInteger := PMehrwertsteuer;
    // TableLeistung.FieldByName('Mwst').AsInteger;
    FieldByName('Datum').AsDateTime := Date;
    try
      FieldByName('Log_T').AsString := IntToStr(Pgl.BonNr);
    except
    end;
    FieldByName('Termin_Nr').AsString := AWriteReservID;
    try
      FieldByName('Pers_Nr').AsString := TableGastinfo.FieldByName
        ('Pers_NR').AsString;
      // TODO: ZI_Nummer gibts nicht in KASSINFO ?
      FieldByName('ZI_Nummer').AsString := TableGastinfo.FieldByName
        ('ZI_Nummer').AsString;
    except
    end;
    FieldByName('Log_K').AsInteger := PHauptGruppeID;
    try
      FieldByName('ArtikelID').AsInteger := PArtikelID;
    except
    end;
    Post;
    Close;
  end; // with
end;

// ******************************************************************************
// Leistung auf Zimmer buchen
// ******************************************************************************
procedure TDataPos.WriteToGastkonto(PTischNr:string; PReservID: Integer;
  PDatum: TDateTime; PTime: TTime; PBetrag: Double;
  PMehrwertsteuer: Integer; PText:string; PMenge: Integer;
  PHauptgruppe, PGastadresseID, PZimmer:string; PArtikelID: Integer);
var PfelixDate: TDateTime;
  PLeistungsID, AKasseID, AFirma: Integer;
  PLeistungsText:string;

begin
  if Gl.FelixHotelFirma > 0 then
    AFirma := Gl.FelixHotelFirma
  else
    AFirma := Gl.Firma;

  PLeistungsID := 0;
  AKasseID := 1;
  try
    if Gl.FelixNachKassen then
    begin
      AKasseID := Gl.KasseID;
      if TableTisch.Locate('TischNr', PTischNr,[])then
        if TableTisch.FieldByName('GruppeID').AsInteger <> 0 then
        begin
          TableTischgruppe.Open;
          if TableTischgruppe.Locate('TischgruppeID',
            TableTisch.FieldByName('GruppeID').AsInteger,[])then
          begin
            AKasseID := TableTischgruppe.FieldByName('SchankID').AsInteger;
            if AKasseID = 0 then
              AKasseID := 1;
          end;
          TableTischgruppe.Close;
        end;
    end;

    // pFelixDate := Date;
    // Datum der aktuellen Firma auslesen
    if Gl.HotelProgrammTyp = HpAllgemeinSQL then
    begin
      // Die Leistungsnummer bekommt man über die Tischnummer (Tabelle
      // Tischzuordnung)
      with Query_GetLeistungsID do
      begin
        Close;
        if Gl.FelixNachKassen then
          ParamByName('TischNr').AsInteger := Gl.KasseID
        else
          ParamByName('TischNr').AsInteger := StrToIntDef(PTischNr, 0);
        Open;
        PLeistungsID := 0;
        if RecordCount > 0 then
        begin
          TableLeistung.Open;
          if PMehrwertsteuer = 0 then
            PLeistungsID := FieldByName('LeistungsID').AsInteger
          else
          begin
            First;
            while not EOF do
            begin
              if TableLeistung.Locate('Firma;ID', VarArrayOf([Gl.Firma,
                FieldByName('LeistungsID').AsInteger]),[])then
              begin
                if(PMehrwertsteuer =
                  TableLeistung.FieldByName('MwSt').AsFloat)then
                  PLeistungsID := FieldByName('LeistungsID').AsInteger;
              end;
              Next;
            end;
          end;
          if PLeistungsID = 0 then
            PLeistungsID := FieldByName('LeistungsID').AsInteger;
        end
        else
        begin
          Gl.DoLogError(FSerialNumber,
            Format(IvDictio.Translate
            ('Schreiben auf Gast: Dem Tisch %s ist keine Leistung zugeordnet'),
            [PTischNr]));
          Close;
          Exit;
        end;
        Close;
      end;
    end;

// *****
    if Gl.HotelProgrammTyp = HpAllgemeinSQL then
    begin
// procedure WriteToKassInfo(pTischNr: string; pReservID: String;
// pBetrag: double; pMehrwertsteuer, pLeistungsID: Integer;
// pText: String; pHauptGruppeID, pArtikelID: Integer;
// pMenge: Integer; pZimmerNr: String);
      WriteToKassInfo(PTischNr, IntToStr(PReservID), PBetrag, PMehrwertsteuer,
        PLeistungsID,
        PText, StrToInt(PHauptgruppe), PArtikelID, PMenge, PZimmer);
    end
    else
      if Gl.HotelProgrammTyp = HpHotelFelix then
      begin
        with Table_Diverses do
        begin
          Open;
          if Locate('Firma', AFirma,[])then
            PfelixDate := FieldByName('FelixDate').AsDateTime
          else
          begin
            Gl.DoLogFile(FSerialNumber,
              Format(IvDictio.Translate(
              'Schreiben auf Gast: Die Firma %s ist nicht definiert'),
              [IntToStr(AFirma)]));
            Exit;
          end;
          Close;
        end;
      // Die Leistungsnummer bekommt man über die Tischnummer (Tabelle
      // Tischzuordnung)
        with Query_GetLeistungsID do
        begin
          Close;
          SQL.Clear;
          IB_Connection := IB_ConnectionFelix;

{ select kt.leistungsid, mw.mwst, l.Leistungsbezeichnung from kass_tischzuordnung kt
LEFT OUTER JOIN leistungen l ON kt.leistungsid = l.id AND l.Firma = 1
LEFT OUTER JOIN MehrwertSteuer mw ON mw.Firma = l.Firma AND mw.id = l.mwstid
WHERE :TischNR >= TischVOn AND :TischNr <= TischBis
order by mw.mwst }

          SQL.Add('SELECT T.LeistungsID, MW.MWST, L.LeistungsBezeichnung ');
          SQL.Add('FROM kass_Tischzuordnung T ');
          SQL.Add('Left Outer join Leistungen L on L.ID = T.LeistungsID AND l.Firma = '
            + IntToStr(AFirma));
          SQL.Add('LEFT OUTER JOIN MehrwertSteuer mw ON mw.Firma = l.Firma AND mw.id = l.mwstid');
          SQL.Add('WHERE TischVon <= :TischNr AND TischBis >= :TischNr');
          SQL.Add('order by mw.mwst');

          if Gl.FelixNachKassen then
            ParamByName('TischNr').AsInteger := AKasseID
          else
            ParamByName('TischNr').AsInteger := StrToIntDef(PTischNr, 0);

          Open;
          PLeistungsID := 0;

          if RecordCount > 0 then
          begin
          // Felix Interbase
            if Gl.HotelProgrammTyp = HpHotelFelix then
            begin
              if PMehrwertsteuer = 0 then
              begin
                PLeistungsID := FieldByName('LeistungsID').AsInteger;
                PLeistungsText := FieldByName('LeistungsBezeichnung').AsString;
              end
              else
              begin
                First;
                while not EOF do
                begin
                  if PMehrwertsteuer = FieldByName('MwSt').AsFloat then
                  begin
                    PLeistungsID := FieldByName('LeistungsID').AsInteger;
                    PLeistungsText :=
                      FieldByName('LeistungsBezeichnung').AsString;
                  end;
                  Next;
                end;
              end;
              if PLeistungsID = 0 then
              begin
                PLeistungsID := FieldByName('LeistungsID').AsInteger;
                PLeistungsText := FieldByName('LeistungsBezeichnung').AsString;
              end;
            end
          end
          else
          begin
            Gl.DoLogFile(FSerialNumber, Format(IvDictio.Translate(
              'Schreiben auf Gast: Dem Tisch %s ist keine Leistung zugeordnet'),
              [PTischNr]));
            Close;
            Exit;
          end;
          Close;
        end;

        if Gl.HotelProgrammTyp <> HpAllgemeinSQL then
        begin
        // Wenn die Apparatenummer nicht in die Tabelle eingetragen wurde,
        // dann
          TableGastKontoFELIX.Close;
          TableGastKontoFELIX.Open;
          TableGastKontoFELIX.Refresh;
          // 23.09.2014 KL: TODO wozu refresh nach clode/open?

          if CheckReservIdCheckIn(AFirma, PReservID)then
          begin
            TableGastKontoFELIX.Append;
            TableGastKontoFELIX.FieldByName('Firma').AsInteger := AFirma;
          // 13.10.2014 KL: Reversierungs-ID fehlt seit mindest. März 2013
            TableGastKontoFELIX.FieldByName('ReservID').AsInteger := PReservID;
          // Die Menge ist immer 1
            TableGastKontoFELIX.FieldByName('Menge').AsInteger := PMenge;
            TableGastKontoFELIX.FieldByName('LeistungsID').AsInteger :=
              PLeistungsID;
            TableGastKontoFELIX.FieldByName('Betrag').AsFloat := PBetrag;
            TableGastKontoFELIX.FieldByName('Fix').AsBoolean := FALSE;
            TableGastKontoFELIX.FieldByName('AufRechnungsAdresse')
              .AsBoolean := FALSE;
            TableGastKontoFELIX.FieldByName('InTABSGebucht').AsBoolean := FALSE;
            TableGastKontoFELIX.FieldByName('Datum').AsDatetime := PFelixDate;
            if PText <> '' then
            begin
              if Gl.BonNumberOnHotel then
                TableGastKontoFELIX.FieldByName('LeistungsText').AsString :=
                  PText + ' ' + IntToStr(Pgl.BonNr)
              else
                TableGastKontoFELIX.FieldByName('LeistungsText')
                  .AsString := PText;
            end
            else
            begin
              if Gl.BonNumberOnHotel then
                TableGastKontoFELIX.FieldByName('LeistungsText').AsString :=
                  PLeistungstext + ' ' + IntToStr(Pgl.BonNr)
              else
                TableGastKontoFELIX.FieldByName('LeistungsText').AsString := '';
            end;

            TableGastKontoFELIX.Post;
            WriteToKassenJournalIB(Gl.Firma,
              QueryReservFELIX.FieldByName('ID').AsInteger,
              QueryReservFELIX.FieldByName('ZimmerID').AsString, PTischNr,
              PfelixDate, PTime, PLeistungsID, PBetrag, PMenge);
          end
          else
          begin
            Gl.DoLogFile(FSerialNumber, Format(Translate(
              'Schreiben auf Zimmer: Reservierung %d nicht gefunden'),
              [PReservID]));
          end;
          TableGastKontoFELIX.Close;
        end;
      end;

  except
    on E: Exception do
      Gl.DoLogError(FSerialNumber, Translate('FEHLER in WriteToGastkonto: ')+
        E.Message);
  end;
end;

// ******************************************************************************
//
// ******************************************************************************
procedure TDataPos.WriteToKassenJournalIB(PFirma,
  PReservID: Integer; PZimmerNr, PTischNr:string; PDatum: TDateTime;
  PTime: TTime; PLeistungsID: Integer; PBetrag: Double; PMenge: Integer);
begin
  try
    with IB_DSQLJournal do
    begin
      ParamByName('Firma').AsInteger := PFirma;
      ParamByName('ReservID').Value := PReservID;
      ParamByName('Datum').AsDateTime := PDatum;
      ParamByName('Zeit').AsDateTime := PTime;
      ParamByName('ErfassungDurch').Value := 6;
      ParamByName('Text').AsString := IvDictio.Translate('Kasse ZimmerNr: ')+
        PZimmerNr;
      ParamByName('Menge').Value := PMenge;
      ParamByName('Betrag').AsFloat := PBetrag;
      ParamByName('LeistungsID').Value := PLeistungsID;
      ExecSQL;
    end;
  except
    on E: Exception do
    begin
      Gl.DoLogFile(FSerialNumber, 'Error in "Kassenjournal": ' + E.Message);
    end;
  end;

end;

// ******************************************************************************
// Damit in der Kasse die Buchungen reaktiviert werden kann
// ******************************************************************************
procedure TDataPos.WriteHotelLog(PText:string; PDatum: TDateTime;
  PKellnerID, PVonTischID: Integer; PReservID, PZimmerNR:string);
var AReservID, AWriteReservID:string;
  I: Integer;
begin
  // TODO: wenn die Tabelle nach dem Append sowieso geschlossen wird,
  // ist ein INSERT-SQL wesentlich schneller!
  with TableHotellog do
  begin
    Open;
    Append;
    FieldByName('Firma').AsInteger := Gl.Firma;
    FieldByName('ID').AsInteger := PDataDrucken.GetNextGenID('Hotellog', True);
    FieldByName('Datum').AsDateTime := PDatum;
    FieldByName('KellnerID').AsInteger := PKellnerID;
    FieldByName('VonTischID').AsInteger := PVonTischID;
    FieldByName('Text').AsString := PText;
    FieldByName('Zimmer_Nr').AsString := PZimmerNr;
    if Gl.HotelProgrammTyp = HpAllgemeinSQL then
    begin
      TableGastinfo.Open;
      AREservID := PReservID;
      // Wurde für Phönix wieder reingegeben
      for I := Length(AREservID)to 5 do // Iterate
      begin
        AReservID := '0' + AReservID;
      end; // for
      if TableGastinfo.Locate('Termin_NR;Zi_Nummer',
        VarArrayOf([AReserVID, PZimmerNR]),[])then
      begin
        AWriteReservID := AReservID;
      // oder nach normaler ReservID
      end
      else
        if TableGastinfo.Locate('Termin_NR;Zi_Nummer',
          VarArrayOf([PReserVID, PZimmerNR]),[])then
        begin
          AWriteReservID := PReservID;
        end
        else
          Gl.DoLogFile(FSerialNumber,
            IVDictio.Translate('12409: Reservierung nicht gefunden!'));
      FieldByName('Termin_Nr').AsString := AWriteReservID;
      try
        FieldByName('Pers_Nr').AsString := TableGastinfo.FieldByName
          ('Pers_NR').AsString;
        FieldByName('Zimmer_Nr').AsString :=
          TableGastinfo.FieldByName('ZI_Nummer').AsString;
      except
      end;
    end
    else
    begin
      FieldByName('ReservID').AsString := PReservID;

    end;
    if Gl.HotelProgrammTyp in[HpAllgemeinSQL, HpHotelFelix] then
      FieldByName('VonTischID').AsInteger :=
        TableOffeneTische.FieldByName('OffeneTischID').AsInteger;

    Post;
    Close;
  end; // with
  TableGastinfo.Close;
end;

// ******************************************************************************
// Bucht Artikel auf Zimmer um
// ******************************************************************************
procedure TDataPos.TransferToZimmer(PReservID: Integer;
  PZimmer, PGastadresseID:string);
var AMwst10, AMwst20, AMwst0: Double;
  AMenge, AArtikelID: Integer;
// 03.04.2013 KL: TODO (09:16)  aMenge: Double; // Menge von Integer zu Double geändert
  ABetrag: Real;
  AHauptgruppe:string;
begin
  AArtikelID := 0;
  with QueryMwst do
  begin
    Close;
    // DatabaseName := DatabaseLocalOD.AliasName;
    SQL.Clear;
    SQL.Add('SELECT Firma, ArtikelID, Betrag, SUM(Menge) AS Menge, OffeneTischID');
    SQL.Add('FROM Hilf_Tischkonto ');
    SQL.Add('WHERE OffeneTischID = ' +
      TableOffeneTische.FieldByName('OffeneTischID').AsString +
      ' AND Firma = ' + IntToStr(Gl.Firma)+ ' AND Betrag <> 0');
    SQL.Add('GROUP BY Firma, ArtikelID, Betrag, OffeneTischID');
    Open;
    First;

    AMwst10 := 0; AMwst20 := 0; AMwst0 := 0;
    while not EOF do
    begin
      AArtikelID := FieldByName('ArtikelID').AsInteger;
      AHauptgruppe := FieldByName('LookHauptgruppeID').AsString;
      ABetrag := FieldByName('Betrag').AsFloat;
      AMenge := FieldByName('Menge').AsInteger;
      if FieldByName('LookSteuer').AsInteger = 10 then
      begin
        AMwst10 := AMwst10 + FieldByName('Betrag').AsFloat *
          FieldByName('Menge').AsFloat;
        if Gl.HotelEinzelnBuchen then
          WriteToGastkonto(TableOffeneTische.FieldByName('LookTischNr').AsString,
            PReservID, Gl.KassenDatum, Time, ABetrag, 10,
            FieldByName('LookArtikel').AsString, AMenge,
            AHauptgruppe, PGastadresseID, PZimmer, AArtikelID);
      end
      else
        if FieldByName('LookSteuer').AsInteger = 20 then
        begin
          AMwst20 := AMwst20 + FieldByName('Betrag').AsFloat *
            FieldByName('Menge').AsFloat;
          if Gl.HotelEinzelnBuchen then
            WriteToGastkonto(TableOffeneTische.FieldByName('LookTischNr')
              .AsString,
              PReservID, Gl.KassenDatum, Time, ABetrag, 20,
              FieldByName('LookArtikel').AsString, AMenge,
              AHauptgruppe, PGastadresseID, PZimmer, AArtikelID);
        end
        else
          if FieldByName('LookSteuer').AsInteger = 0 then
          begin
            AMwst0 := AMwst0 + FieldByName('Betrag').AsFloat *
              FieldByName('Menge').AsFloat;
            if Gl.HotelEinzelnBuchen then
              WriteToGastkonto(TableOffeneTische.FieldByName('LookTischNr')
                .AsString,
                PReservID, Gl.KassenDatum, Time, ABetrag, 0,
                FieldByName('LookArtikel').AsString, AMenge,
                AHauptgruppe, PGastadresseID, PZimmer, AArtikelID);
          end;
      Next;
    end;
    Close;
  end;
  if not Gl.HotelEinzelnBuchen then
  begin
    if AMwst10 <> 0 then
      WriteToGastkonto(
        TableOffeneTische.FieldByName('LookTischNr').AsString,
        PReservID, Gl.KassenDatum, Time, AMwst10, 10, '', 1, AHauptgruppe,
        PGastadresseID, PZimmer, AArtikelID);
    if AMwst20 <> 0 then
      WriteToGastkonto(
        TableOffeneTische.FieldByName('LookTischNr').AsString,
        PReservID, Gl.KassenDatum, Time, AMwst20, 20, '', 1, AHauptgruppe,
        PGastadresseID, PZimmer, AArtikelID);
    if AMwst0 <> 0 then
      WriteToGastkonto(
        TableOffeneTische.FieldByName('LookTischNr').AsString,
        PReservID, Gl.KassenDatum, Time, AMwst0, 0, '', 1, AHauptgruppe,
        PGastadresseID, PZimmer, AArtikelID);
  end;
  WriteHotelLog(IntToStr(Pgl.BonNr)+ IvDictio.Translate(' Hotel: ')+ PZimmer +
    Iif(LowerCase(ExtractFileName(ParamStr(0)))= 'ordermanserver.exe',
    ' (Orderman)', ' (Smart-Order)'),
    Gl.KassenDatum, FWaiterID,
    TableOffeneTische.FieldByName('TischID').AsInteger,
    IntToStr(PReservID), PZimmer);

end;

// ******************************************************************************
//
// ******************************************************************************
procedure TDataPos.WriteUmbuchToJournal(PTischID, PTyp: Integer;
  PText, PZimmerNR:string);
begin
  TableHilf_Tischkonto.Close;
  TableHilf_Tischkonto.ParambyName('pOffeneTischID').Value :=
    TableOffeneTische.FieldByName('OffeneTischID').AsInteger;
  TableHilf_Tischkonto.Open;
  TableHilf_Tischkonto.First;

// if pZimmerNr = '' then
// pZimmerNr := TableOffeneTische.FieldByName('TischID').AsString;

  while not TableHilf_Tischkonto.EOF do
  begin
{ procedure TpDataStatistik.WriteToJournal(
    pText: String;
    pZahlwegID,
    pMenge,
		pArtikelID,
    pBeilagenID,
    pJournalTyp,
    pOffeneTischID :Variant;
    pBetrag: double;
		pVonOffeneTischID,
    pRechnungsID,
    pNachlass: Variant;
    pKellnerID: Integer;
    pNotClose: Boolean);
}
    if PTyp = 9 then
      PDataStatistik.WriteToJournal(
        PText,
        NULL,
        TableHilf_Tischkonto.FieldByName('Menge').Value,
        TableHilf_Tischkonto.FieldByName('ArtikelID').Value,
        TableHilf_Tischkonto.FieldByName('BeilagenID1').Value,
        PTyp,
        PTischID,
        TableHilf_Tischkonto.FieldByName('Betrag').AsFloat,
        PZimmerNr, // vonTischID
                    // 09.08.2010 BW: take TableID from source table
                    // TableOffeneTische.FieldByName('TischID').AsInteger,
        FTableID,
        Null,
        FWaiterID,
        TRUE,
        Pgl.BonNr)
    else
      PDataStatistik.WriteToJournal(
        PText,
        NULL,
        TableHilf_Tischkonto.FieldByName('Menge').Value,
        TableHilf_Tischkonto.FieldByName('ArtikelID').Value,
        TableHilf_Tischkonto.FieldByName('BeilagenID1').Value,
        PTyp,
        PTischID,
        TableHilf_Tischkonto.FieldByName('Betrag').AsFloat,
                    // 09.08.2010 BW: take OpenTableID from source table
                    // TableOffeneTische.FieldByName('OffeneTischID').AsString, //vonTischID
        GetOpenTableIDbyTableID(FTableID),
        Null,
        Null,
        FWaiterID,
        TRUE,
        Pgl.BonNr);

// 2. Beilage
    if not TableHilf_Tischkonto.FieldByName('BeilagenID2').IsNull then
      PDataStatistik.WriteToJournal(
        PText,
        NULL,
        TableHilf_Tischkonto.FieldByName('Menge').Value,
        TableHilf_Tischkonto.FieldByName('ArtikelID').Value,
        TableHilf_Tischkonto.FieldByName('BeilagenID2').Value,
        PTyp,
        PTischID,
        TableHilf_Tischkonto.FieldByName('Betrag').AsFloat,
                    // 09.08.2010 BW: take OpenTableID from source table
                    // TableOffeneTische.FieldByName('OffeneTischID').AsString, //vonTischID
        GetOpenTableIDbyTableID(FTableID),
        NULL,
        NULL,
        FWaiterID,
        TRUE,
        Pgl.BonNr);

    // 3. Beilage
    if not TableHilf_Tischkonto.FieldByName('BeilagenID3').IsNull then
      PDataStatistik.WriteToJournal(
        PText,
        NULL,
        TableHilf_Tischkonto.FieldByName('Menge').Value,
        TableHilf_Tischkonto.FieldByName('ArtikelID').Value,
        TableHilf_Tischkonto.FieldByName('BeilagenID3').Value,
        PTyp,
        PTischID,
        TableHilf_Tischkonto.FieldByName('Betrag').AsFloat,
                    // 09.08.2010 BW: take OpenTableID from source table
                    // TableOffeneTische.FieldByName('OffeneTischID').AsString, //vonTischID
        GetOpenTableIDbyTableID(FTableID),
        NULL,
        NULL,
        FWaiterID,
        TRUE,
        Pgl.BonNr);

    TableHilf_Tischkonto.Next
  end;
  TableHilf_Tischkonto.Close;
  TableHilf_Tischkonto.ParambyName('pOffeneTischID').Value := PTischID;
  TableHilf_Tischkonto.Open;
end;

// ******************************************************************************
// Setzt den Datenbankzeiger in OffeneTische
// ******************************************************************************
function TDataPos.LocateOffenenTisch(PTischTyp:string;
  PTischID: Integer): Boolean;
begin
  with QueryLocateOffenerTisch do
  begin
    Close;
    SQL.Clear;
    // Handelt es sich beim abgefragten Tisch um einen W/E/P/B-Tisch
    // so ist das Datum der ersten Tischbuchung irrelevant
    if(PTischTyp <> '')and(PTischTyp[1] in['W', 'E', 'P', 'B', 'S', 'G', 'Z',
      'L'])then
    begin
      SQL.Add('SELECT ot.OffeneTischID FROM OffeneTische ot');
      SQL.Add('LEFT OUTER JOIN Tisch t');
      SQL.Add('ON t.TischID = ot.TischID AND t.Firma = ot.Firma');
      SQL.Add('WHERE ot.Firma = ' + IntToStr(Gl.Firma));
    end
    else
    begin
      SQL.Add('SELECT ot.OffeneTischID FROM OffeneTische ot');
      SQL.Add('WHERE ot.Firma = ' + IntToStr(Gl.Firma));
      SQL.Add('AND ot.DATUM = ''' + DateToStr(Gl.KassenDatum)+ '''');
    end;
    SQL.Add('AND ot.Offen = ''T'' AND ot.TischID = ' + IntToStr(PTischID));
    Open;
    Result := not FieldByName('OffeneTischID').IsNull;
    // 14.12.2010 BW: exchange table/locate with query/params
    with TableOffeneTische do
    begin
      Close;
      Parambyname('pFirma').Asinteger := Gl.Firma;
      Parambyname('pOffeneTischID').Asinteger :=
        QueryLocateOffenerTisch.FieldByName('OffeneTischID').AsInteger;
      Open;
      if Result and(Recordcount < 1)then
      begin
        Result := False;
        Gl.DoLogError(FSerialNumber,
          IvDictio.Translate
          ('LocateOffenenTisch: Offener Tisch nicht gefunden'));
      end;
    end;
  end; // with
end;

// ******************************************************************************
// Tisch sperren und Transaktion starten
// ******************************************************************************
function TDataPos.LockTisch(POffeneTischID: Integer): Boolean;
begin
  Result := TRUE;
  try
    // 27.07.2010 BW: added new transaction (TransactionLockTable) and start it
    if not TransactionLockTable.InTransaction then
      TransactionLockTable.StartTransaction;

    // if there is a lock conflict --> this means another waiter is currently on this table --> return false!
    with QueryWriteCurrentWaiterToOpenTable do
    begin
      Close;
      Parambyname('pFirma').Asinteger := Gl.Firma;
      Parambyname('pOffeneTischID').Asinteger := POffeneTischID;
      Parambyname('pCurrentWaiterID').Asinteger := FWaiterID;
      ExecSQL;
    end;

    // make an update on the record of the passed open table id in table OFFENETISCHE
    // with new transaction (TransactionLockTable) in order to lock the open table
    with QueryLockTisch do
    begin
      Close;
      Parambyname('OffeneTischID').Asinteger := POffeneTischID;
      ExecSQL;
    end;

  except
    TransactionLockTable.Rollback;
    Result := FALSE;
  end;
end;

// ******************************************************************************
// Tisch entsperren und je nach Parameter Commit oder Rollback
// ******************************************************************************
function TDataPos.UnLockTisch(PCommit: Boolean): Boolean;
begin
  Result := TRUE;
  try
    // 27.07.2010 BW: added new transaction (TransactionLockTable) and commit or rollback it
    // 20.01.2011 BW: senseless check?! --> leads to problem in DoTransferToTable because when target table
    // is closed the transaction is not intransaction anymore and
    // therefore there is NO commit!!!
    // if TransactionLockTable.InTransaction Then
    begin
      if PCommit then
        // 27.07.2010 BW: replace CommitRetaining with Commit
        TransactionLockTable.Commit
      else
        TransactionLockTable.RollBack;
    end;
  except
    // Bei Fehler immer Rollback
    TransactionLockTable.RollBack;
    Result := FALSE;
    raise;
  end;
end;

// ******************************************************************************
// Sucht den Tisch, schickt die noch nicht bonierten Artikel zum Server und
// ruft "Tischschliessen" auf
// ******************************************************************************
procedure TDataPos.Tischbeenden(PTischID: Integer);
begin
  if LocateOffenenTisch(GetTableTypeAbbreviationbyTableID(PTischID), PTischID)
  then
  begin
    Tischschliessen;
    Gl.DoLogFile(FSerialNumber,
      IVDictio.Translate('Tisch erfolgreich geschlossen'));
  end;
end;

// ******************************************************************************
// Tisch in der Datenbank freigeben. Wenn keine Artikel mehr drauf sind
// dann Offen = FALSE
// ******************************************************************************
procedure TDataPos.Tischschliessen;
begin
  // 14.12.2010 BW: exchange QueryCheckTischOffen with stored procedure CheckTischOffen
  with QueryProcedureCheckTischOffen do
  // this query has same transaction as QueryLockTable otherwise there would be a lock conflict!
  begin
    Close;
    Sql.Clear;
    Sql.Add('execute procedure checktischoffen(:pOffeneTischID)');
    // ATTENTION: firma is hardcoded 1 in stored procedure
    Parambyname('pOffeneTischID').Asinteger := TableOffeneTische.FieldByName
      ('OffeneTischID').AsInteger;
    ExecSql;
  end;
  UnlockTisch(TRUE);
end;


// ******************************************************************************
// ******************************************************************************
// Produzeduren für die Rechnung
// ******************************************************************************
// ******************************************************************************

// ******************************************************************************
// Eine neue Rechnungsnummer holen
// Die letzte Rechnungsnummer steht in der Tabelle ":Kasse_Stamm_Sonstige:Diverses"
// diese wird eingelesn, um 1 erhöht und wieder weggeschrieben
// ******************************************************************************
procedure TDataPos.SetRechnungsNr(PProforma: Boolean; PBetrag: Single);
begin
  if(Gl.PrintBillNumberValue > 0)and(PBetrag < Gl.PrintBillNumberValue)then
    Gl.LastRechNr := 0
  else
    with QueryRechNr do
    begin
      Close;
      SQL.Clear;
      if PProforma then
      begin
        SQL.Add('SELECT GEN_ID(GEN_LASTRechNR, 0) FROM RDB$DATABASE');
        Open;
        Gl.LastRechNr := FieldByName('GEN_ID').AsInteger;
        Close;
        Dec(Gl.LastRechNr);
        SQL.Clear;
        SQL.Add('SET generator GEN_LASTRECHNR TO ' + IntToStr(Gl.LastRechNr));
        ExecSQL;
      end
      else
      begin
        SQL.Add('SELECT GEN_ID(GEN_LASTRechNR, 1) FROM RDB$DATABASE');
        Open;
        Gl.LastRechNr := FieldByName('Gen_ID').AsInteger;
        Close;
      end;
    end; // with
end;

// ******************************************************************************
// Eine neue Bonnummer holen
// ******************************************************************************
procedure TDataPos.SetBonNr;
begin
  with QueryRechNr do
  begin
    Close;
    SQL.Clear;
    if Pgl.BonNrIsRechNr then
    begin
      SQL.Add('SELECT GEN_ID(GEN_LastRechNr, 0) FROM RDB$DATABASE');
      Open;
      Pgl.BonNr := FieldByName('Gen_ID').AsInteger + 1;
    end
    else
    begin
      SQL.Add('SELECT GEN_ID(GEN_LastBonNr, 1) FROM RDB$DATABASE');
      Open;
      Pgl.BonNr := FieldByName('Gen_ID').AsInteger;
    end;
    Close;
  end;
end;

// ******************************************************************************
// Kompletten Tisch abrechnen
// ******************************************************************************
procedure TDataPos.SetSofortRechnung(PTyp: Integer; PTischkontoTable: TIBOQuery;
  PZahlweg: Integer; PRabatt: Real; PAdresseID, PAnzahl: Integer);
var ABetrag: Double;
  ARechID: Integer;
begin
  // pTischkontotable gibt die Tischkontotabelle an, aus der die Rechnung
  // erstellt wird.
  // Bein einer Teilrechnung ist das Hilf_Tischkonto
  // Bei einer Gesamtrechnung ist das Tischkonto
  if PTischKontoTable = TableHilf_Tischkonto then
    with PTischkontoTable do
    begin
  // 28.07.2010 BW: close/open Query TableHilf_TischKonto
      Close;
      Parambyname('pOffeneTischID').Asinteger := TableOffeneTische.Fieldbyname
        ('OffeneTischID').Asinteger;
      Open;
      First;
      ABetrag := 0;
    // Gesamtbetrag ermitteln
      while not EOF do
      begin
        ABetrag := ABetrag + FieldByName('Menge').AsInteger *
          FieldByName('Betrag').AsFloat;
        Next;
      end;
    end
  else
    with Query do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT SUM(Menge*Betrag) AS Betrag');
      SQL.Add('FROM Tischkonto');
      SQL.Add('WHERE Firma = ' + IntToStr(Gl.Firma));
      SQL.Add('AND OffeneTischID = ' +
        TableOffeneTische.FieldByName('OffeneTischID').AsString);
      Open;
      ABetrag := FieldByName('Betrag').AsFloat;
      Close;
    end; // with

  // Rechnungsnummer bei Kassabon und Proforma zurücksetzen!
  if(Gl.ItalienAnschluss and(PTyp in[0, 99]))then
  begin
    // SetRechnungsNr(TRUE);
    Gl.LastRechnr := 0;
  end
  else
    SetRechnungsNr(FALSE, ABetrag);

    { if TableOffeneTische.FieldByName('GastAdresseID').AsInteger <> 0 then
    FAdresseID :=
      TableOffeneTische.FieldByName('GastAdresseID').AsInteger; }

  with QueryInsertRechnung do
  begin
    ParamByName('Firma').AsInteger := Gl.Firma;
    ARechID := PDataDrucken.GetNextGenID('Rechnung', True);
    FRechNr := ARechID;
    ParamByName('ID').AsInteger := ARechID;
    ParamByName('ReservID').AsInteger :=
      TableOffeneTische.FieldByName('OffeneTischID').AsInteger;
    ParamByName('Datum').AsDateTime := Gl.KassenDatum;
    ParamByName('Rechnungsnummer').AsInteger := Gl.LastRechNr;
    ParamByName('ErstellerID').AsInteger := FWaiterID;
    ParamByName('ZahlungsBetrag').AsFloat := ABetrag -
      RoundTo((ABetrag * PRabatt / 100),-2);

    if(PTyp = 0)or((Gl.PrintBillNumberValue > 0)and
      ((ABetrag -(Round(ABetrag * PRabatt)/ 100))< Gl.PrintBillNumberValue))then
      ParamByName('VorausRechnungKz').AsString := 'T'
    else
      ParamByName('VorausRechnungKz').AsString := 'F';

    if PZahlweg = 4 then
    begin
      ParamByName('BereitsBezahlt').AsFloat := 0;
      ParamByName('Bezahlt').AsString := 'F';
    end
    else
    begin
      ParamByName('BereitsBezahlt').AsFloat := ABetrag -
        RoundTo((ABetrag * PRabatt / 100),-2);
      ParamByName('Bezahlt').AsString := 'T';
    end;
    ParamByName('Gedruckt').AsString := 'T';
    ParamByName('Nachlass').AsFloat := RoundTo(ABetrag * PRabatt / 100,-2);
    ParamByName('AdresseID').AsInteger := PAdresseID;
    ExecSQL;
  end;

  if Gl.ItalienAnschluss then
  begin
    case PTyp of //
    0:
      if Gl.ZahlwegKassaBon > 0 then
        PZahlweg := Gl.ZahlwegKassaBon;
    end; // case
  end;

  with QueryInsertRechzahlung do
  begin
    ParamByName('Firma').AsInteger := Gl.Firma;
    ParamByName('RechnungsID').AsInteger := ARechID;
    ParamByName('Datum').AsDateTime := Gl.KassenDatum;
    ParamByName('Betrag').AsFloat := ABetrag -
      RoundTo((ABetrag * PRabatt / 100),-2);
    ParamByName('Verbucht').AsString := 'T';
    ParamByName('ZahlwegID').AsInteger := PZahlweg;
    ExecSQL;
  end;

  // Die Zahlwege müssen ins Journal eingetragen werden
  if PTyp <> 99 then // bei Proforma nichts eintragen
    PDataStatistik.WriteToJournal(IvDictio.Translate('RechNr: ')+
      IntToStr(Gl.LastRechNr),
      PZahlweg, Null, Null, Null, 2, // Zahlung von Rechnungn
      TableOffeneTische.FieldByName('OffeneTischID').AsInteger,
      ABetrag -(ABetrag * PRabatt / 100), Null, ARechID, ABetrag * PRabatt / 100,
      FWaiterID, FALSE, Null);

  // Die Leistungen vom Hilfskonto auf die Rechnung transferieren
  TransferLeistungToRechnung(PTischkontoTable, PTyp = 99, ARechID);
  // Sonst bekommt das Printpackage nichts mit!
  UnlockTisch(TRUE);
  LockTisch(TableOffeneTische.FieldByName('OffeneTischID').AsInteger);
  // Bei Bonieren ohne Tisch wird keine Sofortrechnung gedruckt!
  // Das Drucken wird über die ID der offenen Tische aufgerufen

  DoSetPrintpackage(Getorderman(FSerialNumber).FDataBase.FWaiterID, FKasseID);

  if Gl.ItalienAnschluss then
  begin
    if Gl.ItalienRegistrierKasseSenden and(PTyp = 0)then
      // Kassabon
      SetKasseIT(ARechID, PRabatt, RoundTo(ABetrag * PRabatt / 100,-2))
    else
    begin
      if not((PTyp = 99)and Gl.ProformaOhneDruck)then
      begin
        if PTischKontoTable = TableHilf_Tischkonto then
          DoSetPrintpackage(Getorderman(FSerialNumber).FDataBase.FWaiterID,
            FKasseID);

        if(PTyp = 99)then
          DoDruckeBon(TableOffeneTische.FieldByName('OffeneTischID').AsInteger,
            Dakassierbon, PAnzahl, Gl.KassenDatum, '', '', PTyp, True,
            Gl.SpracheID, 0)
        else
          DoDruckeBon(ARechID, DaBonRechnung, PAnzahl, Gl.KassenDatum, '', '',
            -1, True, FSprache, 0);
      end;
    end;
  end
  else
    if(PTyp > 0)and not((PTyp = 99)and Gl.ProformaOhneDruck)then
      DoDruckeBon(ARechID, DaBonRechnung, PAnzahl, Gl.KassenDatum, '', '', PTyp,
        True, FSprache, 0);

  if PTyp = 99 then
  begin
    if PTischKontoTable = TableHilf_Tischkonto then
      DeleteHilfTischkontoFromServer(True);
    DoProforma(PTischKontoTable, ARechID);
  end;
end;

// ******************************************************************************
// Die Leistungen der Hilfstabelle werden auf die Rechnung transferiert
// ******************************************************************************
procedure TDataPos.TransferLeistungToRechnung(PTischkontoTabelle: TIBOQuery;
  PProforma: Boolean; PRechID: Integer);
var AArtikelID, I, ABonNr: Integer;
  ABeil1, ABeil2, ABeil3:string;
  APreisMinus, APreisPlus, APreisStatt: Boolean;
  AStattPreis1, AStattPreis2: Double;
begin
  I := 0;
  begin
    // Sonst in einem Rutsch!
    with Query do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT tk.Firma, ' + IntToStr(PRechID)+ ', ''' +
        DateToStr(Gl.KassenDatum)+ ''',');
      SQL.Add('tk.ArtikelID, tk.Menge, tk.Betrag,');
      SQL.Add('b1.PreisPlus as PreisPlus1, b1.PreisMinus as PreisMinus1, ');
      SQL.Add('b1.BeilagenID as Beil1ID, b1.Bezeichnung AS Beilage1, ');
      SQL.Add('b2.PreisPlus as PreisPlus2, b2.PreisMinus as PreisMinus2, ');
      SQL.Add('b2.BeilagenID as Beil2ID, b2.Bezeichnung AS Beilage2, ');
      SQL.Add('b3.PreisPlus as PreisPlus3, b3.PreisMinus as PreisMinus3, ');
      SQL.Add('b3.BeilagenID as Beil3ID, b3.Bezeichnung AS Beilage3, tk.BeilagenText');

      if(PTischkontoTabelle = TableHilf_TischKonto)then
        SQL.Add('FROM Hilf_Tischkonto tk')
      else
        SQL.Add('FROM Tischkonto tk');

      SQL.Add('LEFT OUTER JOIN Beilagen b1');
      SQL.Add('ON tk.Firma = b1.Firma AND tk.BeilagenID1 = b1.BeilagenID');
      SQL.Add('LEFT OUTER JOIN Beilagen b2');
      SQL.Add('ON tk.Firma = b2.Firma AND tk.BeilagenID2 = b2.BeilagenID');
      SQL.Add('LEFT OUTER JOIN Beilagen b3');
      SQL.Add('ON tk.Firma = b3.Firma AND tk.BeilagenID3 = b3.BeilagenID');
      SQL.Add('WHERE tk.Firma = ' + IntToStr(Gl.Firma));
      SQL.Add('AND tk.OffeneTischID = ' +
        TableOffeneTische.FieldByName('OffeneTischID').AsString);
      Open;
      First;
      while not EOF do
      begin
        ABeil1 := ''; ABeil2 := ''; ABeil3 := '';
        if not FieldByName('ArtikelID').IsNull then
        begin
          AArtikelID := FieldByName('ArtikelID').AsInteger;
          Inc(I);
          ABonNr := I;
        end
        else
        begin
          ABonNr := I;
          if FieldByName('ArtikelID').IsNull then
          begin
            AStattPreis1 := 0;
            AStattPreis2 := 0;
            APreisMinus := FieldByName('Beil1ID').AsInteger =-3;
            APreisPlus :=(Gl.BeilagenPreisImmerMit and
              (FieldByName('Beil1ID').AsInteger > 0))or
              (FieldByName('Beil1ID').AsInteger =-2);
            APreisStatt := FieldByName('Beil1ID').AsInteger =-6;

            // 1. Beilage
            if(FieldByName('Beil1ID').AsInteger > 0)and Gl.BeilagenPreisImmerMit
            then
            begin
              ABeil1 := '(' + Format('%.2f',[FieldByName('PreisPlus1').AsFloat])
                + ') ' +
                FieldByName('Beilage1').AsString;
              if(FieldByName('Beil2ID').AsInteger > 0)then
                ABeil2 := '(' + Format('%.2f',
                  [FieldByName('PreisPlus2').AsFloat])+ ') ' +
                  FieldByName('Beilage2').AsString;
              if(FieldByName('Beil3ID').AsInteger > 0)then
                ABeil3 := '(' + Format('%.2f',
                  [FieldByName('PreisPlus3').AsFloat])+ ') ' +
                  FieldByName('Beilage3').AsString;
            end
            else
              if APreisPlus or APreisMinus or APreisStatt then // Preisänderung
              begin
              // erste Beilage ist ID < 0 -> kein Preis
                ABeil1 := FieldByName('Beilage1').AsString;
              // 2. Beilage
                if not FieldByName('Beil2ID').IsNull then
                begin
                  ABeil2 := FieldByName('Beilage2').AsString;
                  if APreisPlus and(FieldByName('PreisPlus2').AsFloat <> 0)then
                    ABeil1 := '(' + Format('%.2f',
                      [FieldByName('PreisPlus2').AsFloat])+ ') ' + ABeil1
                  else
                    if APreisMinus and(FieldByName('PreisMinus2').AsFloat <> 0)
                    then
                      ABeil1 := '(' + Format('%.2f',
                        [FieldByName('PreisMinus2').AsFloat])+ ') ' + ABeil1
                    else
                      if APreisStatt then
                      begin
                        AStattPreis1 := FieldByName('PreisMinus2').AsFloat;
                  // 3. Beilage
                        if not FieldByName('Beil3ID').IsNull then
                        begin
                          AStattPreis2 := FieldByName('PreisPlus3').AsFloat;
                          ABeil3 := FieldByName('Beilage3').AsString;
                          if Abs(AStattPreis2)> Abs(AStattPreis1)then
                            ABeil1 := '(' +
                              Format('%.2f',[AStattPreis1 + AStattPreis2])+
                              ') ' + ABeil1;
                        end;
                      end
                      else
                        ABeil2 := FieldByName('Beilage2').AsString
                end
// 16.08.2010 BW: BUG: must be uncommented because side orders would jump to the end of the query and skip all other articles/side orders!!!
// else
// if not EOF then
// next;
// 16.08.2010 BW: End

// //erste Beilage ist ID < 0 -> kein Preis
// aBeil1 := FieldByName('Beilage1').AsString;
//
// if not EOF then
// next;
//
// //2. Beilage
// if not FieldByName('Beil1ID').IsNull then
// begin
// aBeil2 := FieldByName('Beilage1').AsString;
// if aPreisPlus and (FieldByName('PreisPlus1').AsFloat <> 0) then
// aBeil1 := '(' + Format('%.2f', [FieldByName('PreisPlus1').AsFloat]) + ') ' + aBeil1
// else if aPreisMinus and (FieldByName('PreisMinus1').AsFloat <> 0) then
// aBeil1 := '(' + Format('%.2f', [FieldByName('PreisMinus1').AsFloat]) + ') ' + aBeil1
// else if aPreisStatt then
// begin
// aStattPreis1 := FieldByName('PreisMinus1').AsFloat;
// if not EOF then
// next;
// //3. Beilage
// if not FieldByName('Beil1ID').IsNull then
// begin
// aStattPreis2 := FieldByName('PreisPlus1').AsFloat;
// aBeil3 := FieldByName('Beilage1').AsString;
// if Abs(aStattPreis2) > Abs(aStattPreis1) then
// aBeil1 := '(' + Format('%.2f', [aStattPreis1 + aStattPreis2]) + ') ' + aBeil1;
// end;
// end
// else
// aBeil2 := FieldByName('Beilage1').AsString
// end;
              end
              else // keine Preisänderung
              begin
                ABeil1 := FieldByName('Beilage1').AsString;
                ABeil2 := FieldByName('Beilage2').AsString;
                ABeil3 := FieldByName('Beilage3').AsString;
              end;
          end;
        end;

        if Pos('(0,00) ', ABeil1)> 0 then
          ABeil1 := StringReplace(ABeil1, '(0,00) ', '',[RfReplaceAll]);

        if Pos('(0,00) ', ABeil2)> 0 then
          ABeil2 := StringReplace(ABeil2, '(0,00) ', '',[RfReplaceAll]);

        if Pos('(0,00) ', ABeil3)> 0 then
          ABeil3 := StringReplace(ABeil3, '(0,00) ', '',[RfReplaceAll]);

        if(Pos('0)', ABeil1)> 3)and(Pos('0)', ABeil1)<=(Length(ABeil1)- 5))then
          ABeil1 := StringReplace(ABeil1, '0)', ')',[RfReplaceAll]);

        if(Pos('0)', ABeil2)> 3)and(Pos('0)', ABeil2)<=(Length(ABeil2)- 5))then
          ABeil2 := StringReplace(ABeil2, '0)', ')',[RfReplaceAll]);

        if(Pos('0)', ABeil3)> 3)and(Pos('0)', ABeil3)<=(Length(ABeil3)- 5))then
          ABeil3 := StringReplace(ABeil3, '0)', ')',[RfReplaceAll]);

        DoInsertIntoRechkonto(Gl.Firma, PRechID, Gl.KassenDatum, AArtikelID,
          FieldByName('Menge').AsFloat, FieldByName('Betrag').AsFloat,
          ABeil1 + ' ' + ABeil2 + ' ' + ABeil3 +
          FieldByName('BeilagenText').AsString, ABonNr);
        Next;
      end;
      Close;
    end; // with
    // Daten werden noch zum löschen aus dem Journal benötigt
    if not(PTischkontoTabelle = TableHilf_TischKonto)and not PProforma then
    begin
      // Sonst über Query
      QueryDelTischkonto.ParamByName('OffeneTischID').AsInteger :=
        TableOffeneTische.FieldByName('OffeneTischID').AsInteger;
      QueryDelTischkonto.ParamByName('Firma').AsInteger := Gl.Firma;
      QueryDelTischkonto.ExecSQL;
// 2009-06-16       QueryDelTischkonto.IB_Transaction.CommitRetaining;
    end;
  end;
end;

// ******************************************************************************
// Ins Rechnungskonto einen Artikel einfügen
// ******************************************************************************
procedure TDataPos.DoInsertIntoRechkonto(PFirma, PRechID: Integer;
  PDatum: TDateTime; PArtikelID: INteger; PMenge, PBetrag: Real;
  PBeilagen:string; PBonNr: Integer);
begin
  with QueryInsertRechkonto do
  begin
    ParamByName('Firma').AsInteger := PFirma;
    ParamByName('RechnungsID').AsInteger := PRechID;
    ParamByName('Datum').AsDateTime := PDatum;
    ParamByName('ArtikelID').AsInteger := PArtikelID;
    ParamByName('Menge').AsFloat := PMenge;
    ParamByName('Betrag').AsFloat := PBetrag;
    // Die Beilagen werden in den Leistungstext geschrieben
    ParamByName('LeistungsText').AsString :=
      Format('%-35.35s',[PBeilagen]);
    ParamByName('BonNr').AsInteger := PBonNr;
    ExecSQL;
  end;
end;

// ******************************************************************************
// Hole alle Rechnungen zu einem Tisch,
// wenn dieser offen ist oder Teilrechnungen gemacht wurden
// Holt die letzte Rechnung des übergebenen Tisches
// Result: 0 = keine Rechnung
// sonst RechnungsID
// ******************************************************************************
function TDataPos.HoleRechnungen(PTischID: Integer): Integer;
begin
  Result := 0;
  with Query do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT r.ID, r.Rechnungsnummer, r.Zahlungsbetrag, r.Nachlass, T.TischNR FROM rechnung r');
    SQL.Add('LEFT OUTER JOIN OffeneTische ot');
    SQL.Add('ON r.ReservID = ot.offeneTischID AND r.Firma = ot.Firma');
    SQL.Add('LEFT OUTER JOIN Tisch T');
    SQL.Add('ON ot.TischID = T.TischID AND ot.Firma = t.Firma ');
    SQL.Add('WHERE r.Gedruckt = ''T'' AND r.Datum = ''' +
      DateToStr(Gl.KassenDatum)+ '''');
    SQL.Add('AND r.Firma=' + IntToStr(Gl.Firma));
// if (not gl.ChefKellner) and gl.ReakEigenRech then
    SQL.Add('AND r.ErstellerID=' + IntToStr(FWaiterID));
    SQL.Add('AND ((T.TischID = ' + IntToStr(PTischID)+ '))');
    // OR (T.ObertischID = ' + IntToStr(pTischID) + '))');
// SQL.Add('AND (T.TischID = ' + aTischID);
// If LocateOffenenTisch('', pTischID) Then
// begin
// SQL.Add('AND ((ot.Offen = ''T'') OR (T.ObertischID = ' + IntToStr(pTischID) + '))')
// end;
    SQL.Add('ORDER BY r.ID');
    Open;
    if Recordcount > 0 then
    begin
      // bis zur Letzten Rechnung alle durchgehen
      while not EOF do
      begin
{ If (FieldByName('Rechnungsnummer').AsInteger > 0) then
          SendString := SendString +
                        Format('%7.7s' + chr(9) + '%7.7s' + chr(9) + '%7.7s' + Chr(9) + '%1.1s',
                        [FieldByName('Rechnungsnummer').AsString,
                         FieldByName('TischNR').AsString,
                         FloatToStrF(FieldByName('Zahlungsbetrag').AsFloat - FieldByName('Nachlass').AsFloat, ffGeneral, 7, 2),
                         '1']); }
        Next;
      end;
      Result := FieldByName('ID').AsInteger;
      Gl.DoLogFile(FSerialNumber,
        IvDictio.Translate('Hole letzte Rechnung von Tisch mit der ID')+ ' ' +
        IntToStr(PTischID))
    end;
  end;
end;

// ******************************************************************************
// Rechnung reaktivieren
// ******************************************************************************
function TDataPos.ReaktiviereRechnung(PRechID: Integer): Boolean;

  procedure ActivateTisch(PRechID, POffeneTischID:string);
  begin
    // 16.08.2010 BW: change Query to QueryReactivateTable with Transaction TransactionLockTable to prevent lock conflict with locktable function!
    with QueryReactivateTable do
    begin
      Close;
      SQL.Clear;
      // Bei Direktrechnungen muß "0" als Reservierungsnummer übergeben werden
      SQL.Add('UPDATE OffeneTische');
      SQL.Add('SET Offen = ''T''');
      // , Kellnerid = ' + IntToStr(LogInKellner.ID));
      SQL.Add('WHERE OffeneTischID = ' + POffeneTischID);
      if Gl.Firma > 0 then
        SQL.Add('AND Firma=' + IntToStr(Gl.Firma));
      ExecSQL;
      // 14.12.2010 BW: just a senseless check --> skip!
      // if not TableOffeneTische.Locate('Firma;OffeneTischID',
      // VarArrayOf([gl.Firma, pOffeneTischID]), []) then
      // gl.DoLogError(FSerialNumber, IvDictio.Translate('3: ReaktiviereRechnung: Offener Tisch nicht gefunden'));
    end;
  end;

var ATischId: Integer;
  // für den Nachlass
  ACount: Integer;
begin
  Result := FALSE;
  TableRechnung.Close;
  TableRechnung.Open;
  if TableRechnung.Locate('ID', PRechID,[])then
  begin
    // Überprüfen, ob der Tisch bereits offen ist
    with TableOffeneTische do
    begin
      // 14.12.2010 BW: exchange table/locate with query/params
      Close;
      Parambyname('pFirma').Asinteger := Gl.Firma;
      Parambyname('pOffeneTischID').Asinteger :=
        TableRechnung.FieldByName('ReservID').AsInteger;
      Open;
      if Recordcount < 1 then
        Gl.DoLogError(FSerialNumber,
          IvDictio.Translate
          ('5: Rechnung reaktivieren: OffeneTischID nicht gefunden'));
      ATischID := FieldByName('TischID').AsInteger;

// //16.08.2010 BW: insert close; open; in order to fetch up-to-date data from TableOffeneTische
// close;
// open;
// //Diesen Tisch in der OffeneTischTabelle suchen
// if not Locate('Firma;OffeneTischID', VarArrayOf([gl.Firma,
// TableRechnung.FieldByName('ReservID').AsInteger]), []) then
// gl.DoLogError(FSerialNumber, IvDictio.Translate('5: Rechnung reaktivieren: OffeneTischID nicht gefunden'));
// aTischID := FieldByName('TischID').AsInteger;

      // 14.12.2010 BW: exchange table/locate with query/params
      // nach einem offenen Tisch mit der gleichen Nummer suchen
      with QueryCheckTableisReopened do
      begin
        Close;
        Parambyname('pFirma').Asinteger := Gl.Firma;
        Parambyname('pDatum').Asdate := Gl.KassenDatum;
        Parambyname('pOffen').Asstring := 'T';
        Parambyname('pTischID').Asinteger := ATischID;
        Open;
        if Recordcount > 0 then
        begin
          // und wenn das ein anderer ist, kann der Tisch nicht reaktiviert werden
          if TableRechnung.FieldByName('ReservID').AsInteger <>
            FieldByName('OffeneTischID').AsInteger then
          begin
            Gl.DoLogFile(FSerialNumber,
              Ivdictio.Translate
              ('Tisch ist schon wieder belegt! Offene Tisch ID')+ ': ' +
              Inttostr(FieldByName('OffeneTischID').AsInteger));
            Exit;
          end;
        end;
      end;

// //Diese Tabelle nach einem offenen Tisch mit der gleichen Nummer suchen
// if Locate('Firma;TischID;Offen;Datum',
// VarArrayOf([gl.Firma, aTischID, 'T', gl.KassenDatum]), []) then
// begin
// //und wenn das ein anderer ist, kann....
// if TableRechnung.FieldByName('ReservID').AsInteger <>
// FieldByName('OffeneTischID').AsInteger then
// begin
// gl.DoLogFile(FSerialNumber, Format(ivdictio.Translate('Der Tisch %s ist schon wieder belegt.%sEine Rechnung kann nur reaktiviert werden, wenn der Tisch frei ist.'),
// [FieldbyName('LookTischNr').AsString, #13]));
// Exit;
// end;
// end;

    end;
    with Query do
    begin
      // Den Tisch sperren
      if LockTisch(TableOffeneTische.FieldByName('OffeneTischID').AsInteger)then
      begin
        // Kassenjournal und Kasse gegenbuchen
        SQL.Clear;
        SQL.Add('SELECT * FROM Rechnungszahlweg');
        SQL.Add('WHERE RechnungsID = ' + IntToStr(PRechID));
        if Gl.Firma > 0 then
          SQL.Add('AND Firma=' + IntToStr(Gl.Firma));
        Open;
        ACount := 0;
        while not EOF do
        begin
          if ACount = 0 then
            PDataStatistik.WriteToJournal(Format(
              IvDictio.Translate('Rech. %s reaktiv. - %s'),
              [TableRechnung.FieldByName('Rechnungsnummer').AsString,
              IntToStr(FWaiterID)]),
              FieldByName('ZahlwegID').AsInteger, Null, Null, Null,
              5, // Zahlung von Rechnungn
              TableRechnung.FieldByName('ReservID').Value,
              -FieldByName('Betrag').AsFloat,
              TableRechnung.FieldByName('AdresseID').AsInteger,
              TableRechnung.FieldByName('ID').AsInteger,
              TableRechnung.FieldByName('Nachlass').AsFloat,
              TableRechnung.FieldByName('ErstellerID').AsInteger, FALSE, Null)
          else
            PDataStatistik.WriteToJournal(Format(
              IvDictio.Translate('Rechn. %s reaktiv. - %s'),
              [TableRechnung.FieldByName('Rechnungsnummer').AsString,
              IntToStr(FWaiterID)]),
              FieldByName('ZahlwegID').AsInteger, Null, Null, Null,
              5, // Zahlung von Rechnungn
              TableRechnung.FieldByName('ReservID').Value,
              -FieldByName('Betrag').AsFloat,
              TableRechnung.FieldByName('AdresseID').AsInteger,
              TableRechnung.FieldByName('ID').AsInteger, Null,
              TableRechnung.FieldByName('ErstellerID').AsInteger, FALSE, Null);
          Next;
        end;
        Close;
        // Rechnungszahlweg löschen
        SQL.Clear;
        SQL.Add('DELETE FROM Rechnungszahlweg');
        SQL.Add('WHERE RechnungsID = ' + IntToStr(PRechID));
        if Gl.Firma > 0 then
          SQL.Add('AND Firma=' + IntToStr(Gl.Firma));
        ExecSQL;
        if not TableRechnung.FieldByName('ReservID').IsNull then
        begin
          // Die Reservierung der Rechnung reaktivieren
          ActivateTisch(IntToStr(PRechID),
            TableRechnung.FieldByName('ReservID').AsString);
          TransferLeistungToTischkonto;
        end;
        // Die Rechnung wird nur auf 0 gesetzt, eine neue Rechnung bekommt auch
        // eine neue Rechnungsnummer
        // Auch die ReservierungsID wird NULL gesetzt, für die Rechnungsausgangsliste
        // reicht die AdresseID
        SQL.Clear;
        SQL.Add('UPDATE Rechnung SET ZahlungsBetrag = NULL,');
        SQL.Add('BereitsBezahlt = NULL, Gedruckt = NULL, BearbeiterID = ' +
          IntToStr(FWaiterID)+ ', Nachlass = NULL,');
        SQL.Add('Mahndatum = NULL, Mahnstufe = NULL');
        // Bearbeiterid = -1 ->> Rechnung reaktiviert
        SQL.Add('WHERE ID = ' + IntToStr(PRechID));
        if Gl.Firma > 0 then
          SQL.Add('AND Firma=' + IntToStr(Gl.Firma));
        ExecSQL;
        Result := TRUE;
      end
      else
      begin
        Gl.DoLogFile(FSerialNumber,
          IvDictio.Translate('Rechn. Reakt. - Tisch bereits WIEDER geöffnet!'));
      end;
      // Tisch Entsperren
      UnLockTisch(TRUE);
    end;
    Gl.DoLogFile(FSerialNumber,
      Format(IvDictio.Translate('Rechnung %s wurde erfolgreich reaktiviert'),
      [TableRechnung.FieldByName('Rechnungsnummer').AsString]));
    // 15.12.2010 BW: this is dead!!! remove this fucking table.close!!!
    // TableRechnung.Close;
  end
  else
    Gl.DoLogError(FSerialNumber, Format(Translate(
      'Reaktiviere Rechnung: Rechnungsnummer %s nicht gefunden'),
      [IntToStr(PRechID)]));
end;

// ******************************************************************************
// Die Leistungen von Rechnungskonto werden wieder auf den Tisch transferiert
// ******************************************************************************
procedure TDataPos.TransferLeistungToTischkonto;
begin
  with QueryRechnungskonto do
  begin
    Close;
    ParamByName('RechnungsID').AsInteger :=
      TableRechnung.FieldByName('ID').AsInteger;
    Open;
    First;
    TableTischkonto.ParambyName('pOffeneTischID').Value :=
      TableOffeneTische.FieldByName('OffeneTischID').AsInteger;
    TableTischkonto.Open;
    while not EOF do
    begin
      TableTischkonto.Append;
      TableTischkonto.FieldByName('I_DeviceGuid').AsString := '';
      if FieldByName('Menge').AsFloat <> 0 then
      begin
        TableTischkonto.FieldByName('ArtikelID').AsInteger :=
          FieldByName('ArtikelID').AsInteger;
        TableTischkonto.FieldByName('Datum').AsDateTime :=
          Gl.KassenDatum;
        TableTischkonto.FieldByName('Menge').AsFloat :=
          FieldByName('Menge').AsFloat;
        TableTischkonto.FieldByName('Betrag').AsFloat :=
          FieldByName('Betrag').AsFloat;
        TableTischkonto.FieldByName('Gedruckt').AsBoolean := TRUE;
        if(FieldByName('LeistungsText').Value = Null)or
          (FieldByName('LeistungsText').Value = '')then
          TableTischkonto.FieldByName('BeilagenText').Value := NULL
        else
          TableTischkonto.FieldByName('BeilagenText').Value :=
            FieldByName('LeistungsText').Value;
      end
      else
      begin
        // freier Text
        TableTischkonto.FieldByName('Datum').AsDateTime :=
          Gl.KassenDatum;
        TableTischkonto.FieldByName('BeilagenID1').AsInteger :=-1;
        if(FieldByName('LeistungsText').Value = Null)or
          (FieldByName('LeistungsText').Value = '')then
          TableTischkonto.FieldByName('BeilagenText').Value := NULL
        else
          TableTischkonto.FieldByName('BeilagenText').Value :=
            FieldByName('LeistungsText').Value;
      end;
      TableTischkonto.FieldByName('KasseID').AsInteger := Gl.KasseID;
      TableTischkonto.FieldByName('Firma').AsInteger := Gl.Firma;
      TableTischkonto.FieldByName('OffeneTischID').Value :=
        TableOffeneTische.FieldByName('OffeneTischID').AsInteger;
      TableTischkonto.FieldByName('KellnerID').AsInteger :=
        TableRechnung.FieldByName('ErstellerID').AsInteger;
      TableTischkonto.Post;
      Next;
    end;
    TableTischkonto.Close;
    Close;
  end;
  // und nun werden Werte der Hilfstabelle wieder gelöscht
  with QueryDelRechnungskonto do
  begin
    Close;
    ParamByName('RechnungsID').AsInteger :=
      TableRechnung.FieldByName('ID').AsInteger;
    ExecSQL;
  end;
end;

// ******************************************************************************
// Wird von Prozetur Verschluesseln verwendet um ein einzelnes Zeichen zu
// verschlüsseln (Über die Verschlüsselungstabellen)
// ******************************************************************************
function TDataPos.GetSchluesselChar(Schluessel: TSchluessel;
  Zeichen: Char): Char;
var
  Pos: Integer;
  Found: Boolean;
begin
  Result := #0;
  Pos := 1;
  Found := FALSE;
  repeat
    if FTabelleSchluesselUrsprung[Pos]= Zeichen then
      Found := TRUE;
    if not(Found)then
      Inc(Pos);
  until Found;
  case Schluessel of
  Gerade:
    Result := FTabelleSchluesselGerade[Pos];
  Ungerade:
    Result := FTabelleSchluesselUngerade[Pos];
  end;
end;

// ******************************************************************************
// Verschlüsselt den in FPasswort enthaltenen String und schreibt das
// Ergebnis in FPasswortKodiert
// ******************************************************************************
function TDataPos.Verschluesseln(PPW:string):string;
var
  PassStrg, AResult:string;
  CharCnt: Integer;
begin
  PassStrg := '';
  AResult := '';
  for CharCnt := 1 to Length(PPW)do
  begin
    if CharCnt mod 2 = 0 then
      PassStrg := PassStrg + GetSchluesselChar(Gerade, PPW[CharCnt])
    else
      PassStrg := PassStrg + GetSchluesselChar(Ungerade, PPW[CharCnt]);
  end;
  for CharCnt := Length(PassStrg)downto 1 do
    AResult := AResult + PassStrg[CharCnt];

  Result := AResult;
end;

// ******************************************************************************
// Definiert die Datenbank KASSE
// ******************************************************************************
procedure TDataPos.SetupDatabase(PSerialNumber, PKasseID: Integer);
begin
  FSerialNumber := PSerialNumber;
  FKasseID := PKasseID;
  CDSKonto.CreateDataSet; // for table TISCHKONTO
  // 22.07.2010 BW: add new Client Data Set:
  CDSHilfKonto.CreateDataSet; // for table HILF_TISCHKONTO
  CDSMakeLists.CreateDataSet;
  // for making static lists in hermes and classic line (downloadlist)
  CDSKonto2.CreateDataSet; // for SumArticlesinTableAccount

  // 05.12.2010 BW: remove load printer package to InitializeOrdermanServer in MainUnit

  // 07.12.2010 BW: open every 'important' DataSet once at startup
  TableTisch.Open;
  QueryWaiter.Parambyname('pFirma').Asinteger := Gl.Firma;
  QueryWaiter.Open;
  TableBeilagen.Open;
  QueryTableAccount.Parambyname('pFirma').Asinteger := Gl.Firma;
  QueryTableAccount.Parambyname('pOffeneTischID').Asinteger := 0;
  QueryTableAccount.Open;
  QueryHelpTableAccount.Parambyname('pFirma').Asinteger := Gl.Firma;
  QueryHelpTableAccount.Parambyname('pOffeneTischID').Asinteger := 0;
  QueryHelpTableAccount.Open;

end;

// ******************************************************************************
//
// ******************************************************************************
procedure TDataPos.DataModuleCreate(Sender: TObject);
begin
  Gl.Initialize;

  FTabelleSchluesselUrsprung := 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789ÄÜÖ';
  FTabelleSchluesselGerade := 'sklqmndf7328045xuÖihägwzoüy1c6b9jperatv';
  FTabelleSchluesselUngerade := '9bÜ6cÄ1vtarepjsklfdnmq457328Ö0hiuxzwgyo';

  if Gl.HotelProgrammTyp = HpAllgemeinSQL then
  begin
    QueryCheckZimmerIB.IB_Connection := DBase.ConnectionZEN;
    TableGastInfo.DatabaseName := 'KasseIB';
    TableKassInfo.DatabaseName := 'KasseIB';
  end
  else
    QueryCheckZimmerIB.IB_Connection := IB_ConnectionFelix;

  if Gl.IsDBF then
  begin
    TableKasseIt.DatabaseName := 'Kasse_Schank';
    TableKasseIt.TableName := 'KasseIT.DBF'
  end;

  if Gl.FelixZimmer and(Gl.HotelProgrammTyp = HpHotelFelix)then
  begin
    IB_ConnectionFelix.DatabaseName := DMBase.DBase.FelixPath;
    IB_ConnectionFelix.Connected := True;
  end;

// 10.08.2010 BW: we do not have an own transaction for table activities (just normal auto commit transaction of IB_ConnectionKasse)
// //04.08.2010 BW: Set new connection ConnectionKasseProcessingTable
// ConnectionKasseProcessingTable.DatabaseName := DMBase.DBase.ConnectionZEN.DatabaseName;
// ConnectionKasseProcessingTable.Connected := True;

 // 11.08.2010 BW: Set initial values for new fields:
  FTableType := TableTypeNormal;
  FTableMode := TT_Alle;
  FPrint_PaymentMethodID := 1; // normally 'Bar'
  FPrint_AmountofPrintouts := 1; // 1 printout
end;

// copied from DMBASE but without starting an extra transaction and commit it (speed!!!)
function TDataPos.GetGeneratorID(PGenerator:string; PInc: Integer): Integer;
begin
  Result := 0;
  with Query do
  begin
    CLose;
    SQL.CLear;
    if PInc = 0 then
      SQL.Add('Select Gen_ID(' + PGenerator + ',0) from RDB$database')
    else
      SQL.Add('Select Gen_ID(' + PGenerator + ',' + IntToStr(PInc)+
        ') from RDB$database');
    Open;
    Result := FieldByName('Gen_ID').AsInteger;
    Close;
  end;
end;

// ******************************************************************************
//
// ******************************************************************************
function TDataPos.GetNextIBID(ATableName:string; ATable: TDataSet;
  AIDString:string): Integer;
var AID: Integer;
begin
  Result := 0;
  try
    with QueryGetNextID do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT GEN_ID(GEN_' + ATableName + '_ID, 1) FROM RDB$DATABASE');
      Open;
      AID := FieldByName('Gen_ID').AsInteger;
      Close;
    end;
  except
    with QueryGetNextID do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT GEN_ID(ID, 1) AS GenID FROM RDB$DATABASE');
      Open;
      AID := FieldByName('GenID').AsInteger;
      Close;
    end;

  end;
  with ATable do
  begin
    FieldByName('Firma').AsInteger := Gl.Firma;
    FieldByName(AIDString).AsInteger := AID;
    Post;
    Edit;
  end;
end;

// ******************************************************************************
//
// ******************************************************************************
procedure TDataPos.TableGastkontoFELIXAfterInsert(DataSet: TDataSet);
begin
  GetNextIBID('Gastkonto', TableGastkontoFELIX, 'ID');
end;

// ******************************************************************************
// ******************************************************************************
// ******************************************************************************
// ******************************************************************************
// ******************************************************************************
// ******************************************************************************
// ******************************************************************************
// ******************************************************************************
// ******************************************************************************
// ******************************************************************************
// ******************************************************************************
// ******************************************************************************
// ******************************************************************************
// ******************************************************************************
// ******************************************************************************
// ******************************************************************************
// ******************************************************************************
// ******************************************************************************

function TDataPos.CheckLoginName(PLoginName:string): Boolean;
  function GetValue(Rechte: LongInt; AConst: Integer): Boolean;
  begin
    if(Rechte and AConst)= AConst then
      Result := TRUE
    else
      Result := FALSE;
  end;

var ABonierRechte, ZugriffsRechte: Longint;
begin
  Result := FALSE;

  // 20.08.2010 BW: if user did not enter a username --> return false and exit!
  if PLoginName = '' then
    Exit;

  with QueryWaiter do
  begin
    Close;
    ParambyName('pFirma').AsInteger := Gl.Firma;
    Open;
    if Locate('Firma;LoginName', VarArrayOf([Gl.Firma, PLoginName]),[])then
    begin
      Result := TRUE;
      FWaiterID := FieldByName('KellnerID').AsInteger;
      FKellnerPreisebene := FieldByName('Preisebene').AsInteger;
      FKellnerSpracheID := FieldByName('SpracheID').AsInteger;
      FKellnerLagertisch := FieldByName('LagertischID').AsInteger;
      // for happy hour messages when waiter opens a table; this is currently not implemented
      FHappyHourAn := False;
      FHappyHourAus := True;

      // set waiter rights

      // 24.08.2010 BW: BUGFIX: read "asinteger" and not "asvariant" in order to get no error if the field 'RechteMain' is NULL!
      ZugriffsRechte := FieldByName('RechteMain').AsInteger;
      FKellnerDarfWechsel := GetValue(ZugriffsRechte, CMainWechsel);
      FKellnerDarfreakt := GetValue(ZugriffsRechte, CMainReaktivieren);
      FKellnerDarfXBon := GetValue(ZugriffsRechte, CMainXBon);
      FKellnerDarfZBon := GetValue(ZugriffsRechte, CMainZBon);
      FKellnerDarfSplitten := GetValue(ZugriffsRechte, CMainTischSplitting);
      FKellnerDarfNachrichten := GetValue(ZugriffsRechte, CMainNachrichten);
      FKellnerStammgaeste := GetValue(ZugriffsRechte, CMainStammgaeste);
      FKellnerIsChef := GetValue(ZugriffsRechte, CChef);

      // 24.08.2010 BW: BUGFIX: read "asinteger" and not "asvariant" in order to get no error if the field 'RechteBonier' is NULL!
      ABonierRechte := FieldbyName('RechteBonier').AsInteger;
      FKellnerRechnung := GetValue(ABonierRechte, CBonierRechnung);
      FKellnerGesamtRechnung := GetValue(ABonierRechte, CBonierGesamtRechnung);
      FKellnerTeilRechnung := GetValue(ABonierRechte, CBonierTeilRechnung);
      FKellnerSofortRechnung := GetValue(ABonierRechte, CBonierSofortRechnung);
      FKellnerUmbuchen := GetValue(ABonierRechte, CBonierUmbuchen);
      FKellnerGesamtUmbuchen := GetValue(ABonierRechte, CBonierGesamtUmbuchen);
      FKellnerTeilUmbuchen := GetValue(ABonierRechte, CBonierTeilUmbuchen);
      FKellnerStorno := GetValue(ABonierRechte, CBonierStorno);
      FKellnerGesamtStorno := GetValue(ABonierRechte, CBonierGesamtStorno);
      FKellnerTeilStorno := GetValue(ABonierRechte, CBonierTeilStorno);
      FKellnerSofortStorno := GetValue(ABonierRechte, CBonierSofortStorno);
      FKellnerBonDruck := GetValue(ABonierRechte, CBonierBonDruck);
      FKellnerOhneDruck := GetValue(ABonierRechte, CRechZahlOhneDruck);
      FKellnerWerbung := not GetValue(ABonierRechte, CNichtWerbung);
      FKellnerEigenbedarf := not GetValue(ABonierRechte, CNichtEigenbedarf);
      FKellnerPersonal := not GetValue(ABonierRechte, CNichtPersonal);
      FKellnerBruch := not GetValue(ABonierRechte, CNichtBruch);
      FKellnerLagerAnzeigen := GetValue(ABonierRechte, CShowLager);
      FKellnerLagerNichtBon := GetValue(ABonierRechte, COnlyShowLager);
      FKellnerLagerStorno := GetValue(ABonierRechte, CStornoLager);
    end;
  end;
end;

function TDataPos.CheckLoginPassword(PLoginPassword:string): Boolean;
begin
  Result := FALSE;
  with QueryWaiter do
  begin
    Close;
    ParambyName('pFirma').AsInteger := Gl.Firma;
    Open;
    if Locate('Firma;LoginName;Passwort',
      VarArrayOf([Gl.Firma, GetLoginName,
      Verschluesseln(UPPERCASE(PLoginPassword))]),[])then
      Result := TRUE;
  end;
end;

function TDataPos.CheckWaiterRight(PWaiterHasRight: Boolean): Boolean;
var
  AMsgStrNoRight:string;
begin
  Result := False;

  AMsgStrNoRight := Translate('Keine Berechtigung!');

  if not PWaiterHasRight then
  begin
    Gl.DoLogFile(FSerialNumber, AMsgStrNoRight);
    GetOrderman(FserialNumber).FcurrentForm.ShowInfo(AMsgStrNoRight, '');
  end
  else
    Result := True;
end;

// copied from KASSE
function TDataPos.CheckSplitTables(PTableID: Integer): Boolean;
begin

  Result := False;

  with Query do
  begin
    Close;
    Sql.Clear;
// 07.12.2010 BW: not really faster
// //07.12.2010 BW: sql speed optimization
// SQL.Add('select t.tischid from Tisch T');
// SQL.Add('left outer join OffeneTische OT on t.firma = ot.firma and t.tischid = ot.tischid');
// SQL.Add('where');
// SQL.Add('t.obertischid = :pobertischid and');
// SQL.Add('t.firma = :pFirma and');
// SQL.Add('ot.offen = ''T'' and');
// SQL.Add('ot.datum = :pDatum');
// SQL.Add('order by t.reihung,  t.tischid');
// Parambyname('pObertischid').asinteger := pTableID;
// Parambyname('pFirma').asinteger := gl.Firma;
// Parambyname('pDatum').asdate := gl.KassenDatum;

    SQL.Add('SELECT * FROM Tisch T, offenetische OT');
    SQL.Add('WHERE OT.tischid = T.tischid AND OT.offen = ''T''');
    SQL.Add('AND T.Firma = OT.Firma');
    SQL.Add('AND OT.datum = ''' + DateToStr(Gl.KassenDatum)+ '''');
    SQL.Add('AND T.ObertischID = ''' + Inttostr(PTableID)+ '''');
// if gl.TischNurKellner and not KellnerIsChef then
// SQL.Add('      AND (OT.KellnerID = ' + IntToStr(FWaiterID) + ')');
//
// SQL.Add('OR ((T.tischID = ''' + inttostr(pTableID) + ''') AND (T.ObertischID IS NULL)))');
    SQL.Add('ORDER BY T.Reihung, T.TischID');
    Open;
    if RecordCount > 0 then
      Result := True;
  end;
end;

function TDataPos.CheckHasHotelInterface: Boolean;
begin
  Result := FALSE;
  // check if there is a hotel interface is installed (felix or other)
  if Gl.FelixZimmer then
  begin
    Result := True;
    // if hotel program is felix then also check, if a correct felix.gdb is available (in kasse.ini FelixPath=)
    if Gl.HotelProgrammTyp = HpHotelFelix then
      with QueryCheckFELIX do
        try
          Close;
          Open;
          Close;
        except
          on E: Exception do
          begin
            Gl.DoLogFile(FSerialNumber, E.Message);
            Result := False;
          end;
        end;
  end;

end;

procedure TDataPos.GetTableAccount(PTargetAccount: TClientDataSet;
  PSourceAccount: TIBOQuery);
begin
  // clear target account
  PTargetAccount.EmptyDataSet;

  with PSourceAccount do
  begin
    Close;
    Parambyname('pFirma').Asinteger := Gl.Firma;
    Parambyname('pOffeneTischID').Asinteger := TableOffeneTische.FieldByName
      ('OffeneTischID').AsInteger;
    Open;
    while not EOF do
    begin
      InsertTableAccountEntryIntoAccount(PTargetAccount, PSourceAccount,
        FieldbyName('TischKontoID').Asinteger, FieldbyName('Menge').Asfloat);
      Next;
    end;
  end;
end;

procedure TDataPos.SendTableAccount(PTargetAccount, PSourceAccount: TDataSet);
// internal function for getting the sync status of a table account entry
  function GetSyncStatus: Word;
  begin
    Result := 0;
    // check if table account entry has been changed/added
    if PSourceAccount.Fieldbyname('Zaehler').Asinteger <> 0 then
    // if not pSourceAccount.Fieldbyname('Gedruckt').asboolean then
    begin
      // check if table account entry already exists in target account
      if PTargetAccount.Locate('Firma;TischKontoID',
        VarArrayOf([Gl.Firma, PSourceAccount.FieldbyName('TischKontoID')
        .AsInteger]),[])then
      begin
        Result := 1; // table account entry already exists and has changed
      end
      else
        Result := 2; // table account entry does not exist and has been added
    end;
  end;

// end of internal function
var
  ADifferenceOfAmount: Double;
begin

  with PSourceAccount do
  begin
    // go to first record in source account! important!
    Close;
    Open;
    // refresh target account! important!
    PTargetAccount.Close;
    PTargetAccount.Open;
    while not EOF do
    begin
        // check sync status of the current table account entry
      case GetSyncStatus of
      0: // table account entry has not changed and is not new
        begin
            // do nothing
        end;
      1: // table account entry already exists in target account
        begin
          ADifferenceofAmount := FieldbyName('Menge').Asfloat -
            PTargetAccount.FieldbyName('Menge').Asfloat;
          UpdateTableAccountEntryIntoAccount(PTargetAccount,
            Fieldbyname('TischKontoID').Asinteger, ADifferenceofAmount);
        end;
      2: // table account entry does not exist in target account
        begin
          InsertTableAccountEntryIntoAccount(PTargetAccount, PSourceAccount,
            Fieldbyname('TischKontoID').Asinteger,
            Fieldbyname('Menge').Asfloat);
        end;
      end;
      Next; // get next table account entry of source account
    end;
  end;

end;

procedure TDataPos.MoveTableAccount(PTargetAccount, PSourceAccount: TDataSet);
begin
  // flag all entries of pSourceAccount as changed (field 'Zaehler' = - field 'Menge' //set all entries of pSourceAccount 'Gedruckt' to false (flag that these entries have been changed)
  with PSourceAccount do
  begin
    Close;
    Open;
    while not EOF do
    begin
      Edit;
      Fieldbyname('Zaehler').Asinteger :=
        -Ceil(Abs(FieldByName('Menge').AsFloat));
      Post;
      Next;
    end;
  end;
  // insert entries from pSourceAccount into pTargetAccount
  SendTableAccount(PTargetAccount, PSourceAccount);
  // delete all entries from pSourceAccount
  RemoveAllTableAccountEntries(PSourceAccount);
end;

procedure TDataPos.ChangeTableAccount(PTargetAccount: TDataSet;
  POpenTableID: Integer);
var
  ARecordCount, ARecNo, I: Integer;
begin
  with PTargetAccount do
  begin
    Close;
    Open;
    ARecordCount := Recordcount;
    for I := 1 to ARecordCount do
    begin
      ARecNo := RecNo;
      // Workaround for Post and Order by TischKontoID problem, because after the Post, the db cursor stands at the just changed entry at the end of the query!!!
      Edit;
      Fieldbyname('TischKontoID').Asinteger :=
        DBase.GetGeneratorID('GEN_TISCHKONTO', 1);
      Fieldbyname('OffeneTischID').Asinteger := POpenTableID;
      Post;
      RecNo := ARecNo;
      // Next Workaround --> this solution goes to the "next" entry
    end;
  end;
end;

procedure TDataPos.SetTableAccount(POpenTableID: Integer);
begin
  // set QueryTableAccount to table TISCHKONTO from passed open table
  with QueryTableAccount do
  begin
    Close;
    Parambyname('pFirma').Asinteger := Gl.Firma;
    Parambyname('pOffeneTischID').Asinteger := POpenTableID;
    Open;
  end;
  // set QueryHelpTableAccount to table HILF_TISCHKONTO from passed open table
  with QueryHelpTableAccount do
  begin
    Close;
    Parambyname('pFirma').Asinteger := Gl.Firma;
    Parambyname('pOffeneTischID').Asinteger := POpenTableID;
    Open;
  end;
end;

function TDataPos.CheckTableAccountEmpty(PAccount: TDataSet): Boolean;
var
  ATotal: Double;
begin
  Result := False;
  ATotal := 0;
  with PAccount do
  begin
    Close;
    Open;
    while not EOF do
    begin
      ATotal := ATotal + FieldbyName('Menge').Asfloat;
      Next;
    end;
  end;
  if ATotal = 0 then
    Result := True;

end;

function TDataPos.CheckTableAccountHasRooms(PAccount: TDataSet): Boolean;
var
  ATempInteger: Integer;
begin
  Result := False;
  with PAccount do
  begin
    Close;
    Open;
    while not EOF do
    begin
      try
        ATempInteger := FieldbyName('LookArtikel').AsInteger;
        Result := True;
      except
        // on exception result is still false
      end;
      Next;
    end;
  end;
end;

function TDataPos.CheckTableAccountSideOrderObligation
  (PAccount: TDataSet): Boolean;
begin
  Result := False;
  with PAccount do
  begin
    Close;
    Open;
    while not EOF do
    begin
      // check if side order obligation AND amount of article is not 0 (valid article for tally)
      if((Fieldbyname('Beilagenabfrage').Asstring = '!')and
        (Fieldbyname('Menge').Asinteger <> 0))then
      begin
        Result := True;
        Exit;
      end;
      Next;
    end;
  end;
end;

procedure TDataPos.SumArticlesinTableAccount(PTargetAccount, PSourceAccount
  : TDataSet);
// internal function for getting all side orders of an article
  function GetSideOrdersofArticle(PAccount: TDataSet):string;
  var
    ARecNo: Integer;
  begin
    Result := '';
    with PAccount do
    begin
      // store position of cursor (article) in account
      ARecNo := RecNo;
      // go to next table account entry after the article
      Next;
      // check if table account entry is an article; if Yes --> exit because article has no sideorders
      if((not Fieldbyname('ArtikelID').Isnull)or EOF)then
      begin
        // restore position of cursor (article) in account before exit
        RecNo := ARecNo;
        Exit;
      end;
      // go through all side orders of the article
      while(Fieldbyname('ArtikelID').Isnull and(not EOF))do
      begin
        // concanete string of all side orders of the article e.g.: 'mit 2 Gläser ohne Eis'
        Result := Result + Fieldbyname('LookArtikel').Asstring;
        // go to next side order
        Next;
      end;
      // restore position of cursor (article) in account before exit
      RecNo := ARecNo;
    end;
  end;
// end of internal function
// internal function for checking if two table account entries are the SAME article (with same side orders!)
  function CheckArticlesAreSame: Boolean;
  begin
    Result := False;
    // check if target article is NO side order
    if not PTargetAccount.FieldbyName('ArtikelID').Isnull then
    begin
      // check if articles are same
      if((PTargetAccount.FieldbyName('ArtikelID')
        .Asinteger = PSourceAccount.FieldbyName('ArtikelID').Asinteger)
        // same articleid
        and(PTargetAccount.FieldbyName('Betrag')
        .AsFloat = PSourceAccount.FieldbyName('Betrag').AsFloat)// same price
        and(PTargetAccount.FieldbyName('LookArtikel')
        .AsString = PSourceAccount.FieldbyName('LookArtikel').AsString)
        // same description (this is important because user can change article description in 'Datenanlage'!)
        and(PTargetAccount.FieldbyName('I_DeviceGuid')
        .AsString = PSourceAccount.FieldbyName('I_DeviceGuid').AsString))then
      // same device (important for Smart-Order)
      begin
        // check if articles have same side orders
        if GetSideOrdersofArticle(PTargetAccount)= GetSideOrdersofArticle
          (PSourceAccount)then
          Result := True;
      end;
    end;
  end;
// end of internal function
// internal function for summing an article to another article in table account if they are the SAME
  procedure SumArticleToSameArticle;
  var
    ASourceArticle_TableAccountID, ATargetArticle_TableAccountID: Integer;
  begin
    // go through all articles in target account
    with PTargetAccount do
    begin
      Close;
      Open;
      while not EOF do
      begin
        // 07.04.2011 BW: skip "deleted" articles in target account (amount = 0)
        if Fieldbyname('Menge').Asfloat <> 0 then
        begin
          // check if article in source account and article in target account are the same
          // BUT NOT the same table account entry
          ASourceArticle_TableAccountID := PSourceAccount.FieldbyName
            ('TischKontoID').Asinteger;
          ATargetArticle_TableAccountID := FieldbyName('TischKontoID')
            .Asinteger;
          if((ATargetArticle_TableAccountID <> ASourceArticle_TableAccountID)and
            CheckArticlesAreSame)then
          begin
            // increase target article in target account
            Edit;
            FieldbyName('Menge').Asfloat := FieldbyName('Menge').Asfloat +
              PSourceAccount.FieldbyName('Menge').Asfloat;
            FieldbyName('Zaehler').Asinteger := FieldbyName('Zaehler').Asinteger
              + Ceil(Abs(PSourceAccount.FieldbyName('Menge').Asfloat));
            Post;
            // delete source article in target account
            if Locate('Firma;TischKontoID',
              VarArrayOf([Gl.Firma, ASourceArticle_TableAccountID]),[])then
            begin
              Edit;
              FieldbyName('Menge').Asfloat := 0;
              FieldbyName('Zaehler').Asinteger := 0;
              Post;
            end;
            // delete target article in source account
            with PSourceAccount do
            begin
              if Locate('Firma;TischKontoID',
                VarArrayOf([Gl.Firma, ATargetArticle_TableAccountID]),[])then
              begin
                Edit;
                FieldbyName('Menge').Asfloat := 0;
                FieldbyName('Zaehler').Asinteger := 0;
                Post;
              end;
            end;
            Exit;
          end;
        end;
        Next;
      end;
    end;
  end;

// end of internal function
var
  ARecNo, I: Integer;
begin

  // copy records from target account to source account in order to have a deep copy of the target account as source account (you have to work with 2 accounts!!!)
  with PSourceAccount do
  begin
    Close;
    Open;
    while not EOF do
      Delete;
  end;
  with PTargetAccount do
  begin
    Close;
    Open;
    while not EOF do
    begin
      CDSKonto2.Append;
      for I := 0 to FieldCount - 1 do
        CDSKonto2.Fields[I].Value := Fields[I].Value;
      CDSKonto2.Post;
      Next;
    end;
  end;
  // end of copy

  // go through all articles in source account (copy)
  with PSourceAccount do
  begin
    Close;
    Open;
    while not EOF do
    begin
      // check if source article is new and NO side order
// gl.DoLogFile(0,'Menge='+FloatToStr(Fieldbyname('Menge').AsFloat)+', Zähler='+FloatToStr(Fieldbyname('Zaehler').asinteger));
      if((Fieldbyname('Menge').AsFloat <> 0)and
        (FieldbyName('Menge').Asfloat = FieldbyName('Zaehler').Asinteger))then
      begin
        // store position of cursor in source account
        ARecNo := RecNo;
        // try to sum this current article in source account to all articles in target account
        SumArticleToSameArticle;
        // restore position of cursor in source account
        RecNo := ARecNo;
      end;
      // go to next article in source account
      Next;
    end;
  end;
end;

procedure TDataPos.AddArticle(PTargetAccount: TDataSet;
  PArticleId, PMultiplier: Integer);
var
  I: Integer;
begin
  // check if selected article exists in kasse.gdb
  with QueryArtikel do
  begin
    Close;
    Parambyname('pFirma').Asinteger := Gl.Firma;
    ParamByName('ArtikelID').AsInteger := PArticleID;
    Open;
    if RecordCount = 0 then
    begin
      Gl.DoLogError(FSerialNumber,
        IvDictio.Translate('Artikel nicht gefunden!'));
      Exit;
    end
  end;

  with PTargetAccount do
  begin
  // 06.12.2010 BW
  // close;
  // open;
// 30.07.2010 BW: Do not allow new articles added to existing articles and increase amount by 1
// if Locate('ArtikelID;Firma', VarArrayOf([pArticleID, gl.Firma]), []) then
// begin
// UpdateTableAccountEntryIntoAccount(CDSKonto, FieldbyName('TischKontoID').asinteger, 1);
// end
// else
    begin
      Append;
      FieldByName('Firma').AsInteger := Gl.Firma;
      FieldByName('TischkontoID').AsInteger := GetGeneratorID('GEN_TISCHKONTO',
        1); // 06.12.2010 BW: use own function instead of DBase.GetGeneratorID because of speed optimization
      FieldByName('OffeneTischID').AsInteger := TableOffeneTische.FieldByName
        ('OffeneTischID').AsInteger;
      FieldByName('Gedruckt').AsString := 'F';
      FieldByName('KellnerID').AsInteger := FWaiterID;
      FieldByName('KasseID').AsInteger := FKasseID;
      FieldByName('Datum').AsDateTime := Gl.KassenDatum;
      FieldByName('ArtikelID').AsInteger := PArticleID;
      FieldByName('Menge').AsFloat := PMultiplier;
      FieldByName('Betrag').AsFloat := GetPricebyPriceLevel(FPreisEbene);
      FieldByName('Verbucht').AsString := 'T';
      // 29.11.2010 BW: 'Verbucht' is always true because false is only important if you make instant stock withdrawal without closing table
      FieldByName('LookArtikel').AsString :=
        QueryArtikel.FieldByName('Bezeichnung').AsString;
      // 23.07.2010 BW: Set Counter to 1
      FieldbyName('Zaehler').AsInteger := PMultiplier;
      // check if there is a side order obligation on the selected article
      if QueryArtikel.FieldByName('MussBeilagen').AsInteger = 2 then
      // ='Beilagenpflicht Zwang'
        FieldByName('Beilagenabfrage').AsString := '!'
        // sign the article, that the user must add a side order
      else
        FieldByName('Beilagenabfrage').AsString := '';
      // unsign the article (normal status)

      Post;
    end;
  end;

  // add article to CDSHilfKonto
  for I := 0 to PMultiplier - 1 do
    AddTableAccountEntry(CDSHilfKonto, PTargetAccount,
      PTargetAccount.FieldbyName('TischKontoID').Asinteger, 1);
end;

procedure TDataPos.AddSideOrder(PTargetAccount: TDataSet;
  PTableAccountID, PSideOrderID: Integer);
var
  AArticleID, ASideOrderCounter, ANewTableAccountID, ARecNoOfLastSideOrder, I,
    ARecNo, ARecordCount: Integer;
begin
  // check if selected side order exists in kasse.gdb
  with TableBeilagen do
  begin
    Close;
    Open;
    if not TableBeilagen.Locate('Firma;BeilagenID',
      VarArrayOf([Gl.Firma, PSideOrderID]),[])then
    begin
      Gl.DoLogError(FSerialNumber,
        IvDictio.Translate('Beilage nicht gefunden!'));
      Exit;
    end;
  end;

  // get ArticleID of selected table account entry
  AArticleID := GetOrderman(FSerialNumber)
    .FDataBase.GetArticleIDbyTableAccountID(PTargetAccount, PTableAccountID);

  with PTargetAccount do
  begin
    // 06.12.2010 BW
    // close;
    // Open;
    // check if selected table account is article and entry is new, because tallied and printed articles CANNOT change/add side order
    if(AArticleID > 0)and(Locate('Firma;TischkontoID;Gedruckt',
      VarArrayOf([Gl.Firma, PTableAccountID, 'F']),[]))then
    begin

      // 07.04.2011 BW: check if the article of the just added side order is not "deleted" (amount = 0)
      if Fieldbyname('Menge').Asfloat = 0 then
        Exit;

      // unsign side order obligation of the article of the just added side order
      Edit;
      FieldByName('Beilagenabfrage').AsString := '';
      Post;

      // go to last side order of the selected table account entry or stay at the selected table account if there are no side orders
      Next;
      while(FieldbyName('ArtikelID').Isnull and not EOF)do
        Next;
      if not EOF then
        Prior;
      // store recordnumber of last side order
      ARecNoOfLastSideOrder := RecNo;

      // check how many side orders the current table account entry has got
      ASideOrderCounter := 0;
      if not FieldByName('BeilagenID1').Isnull then
        Inc(ASideOrderCounter);
      if not FieldByName('BeilagenID2').Isnull then
        Inc(ASideOrderCounter);
      if not FieldByName('BeilagenID3').Isnull then
        Inc(ASideOrderCounter);

      // check if side order belongs to new table account entry or add to last side order (table account entry)
      if((PSideOrderID < 0)// modifier ('statt', weniger', ...)
        or(ASideOrderCounter = 0)// first side order
        or((ASideOrderCounter > 0)and(Fieldbyname('BeilagenID1').Asinteger >= 0)
        )// if last side order begins with NO modifier
        or((ASideOrderCounter > 1)and(Fieldbyname('BeilagenID1').Asinteger <>-6)
        )// if last side order begins with NO modifier is 'statt' (id -6) and there are already two side orders
        or(ASideOrderCounter > 2)
        // all three possible side orders are already filled out
        )then
      begin
      // new table account entry

        // fetch new generator id for new table account entry
        // if target account is CDSHilfKonto, then do not fetch a new generator id from db, but take the table account id from CDSKonto
        if PTargetAccount = CDSHilfKonto then
          ANewTableAccountID := CDSKonto.FieldByName('TischKontoID').Asinteger
        else
          ANewTableAccountID := GetGeneratorID('GEN_TISCHKONTO', 1);
        // 06.12.2010 BW: use own function instead of DBase.GetGeneratorID because of speed optimization

        // fetch new generator ids for all following table account entries in order to stick them AFTER the new table account entry
        Next;
        ARecordCount := Recordcount;
        for I := ARecNoOfLastSideOrder + 1 to ARecordCount do
        begin
          ARecNo := RecNo;
          // Workaround for Post and Order by TischKontoID problem, because after the Post, the db cursor stands at the just changed entry at the end of the query!!!
          Edit;
          // if target account is CDSHilfKonto, then do not fetch a new generator id from db, but take the table account id from CDSKonto
          if PTargetAccount = CDSHilfKonto then
          begin
            CDSKonto.Next;
            FieldByName('TischkontoID').AsInteger :=
              CDSKonto.FieldByName('TischKontoID').Asinteger;
          end
          else
            FieldByName('TischkontoID').AsInteger :=
              GetGeneratorID('GEN_TISCHKONTO', 1);
          // 06.12.2010 BW: use own function instead of DBase.GetGeneratorID because of speed optimization
          Post;
          RecNo := ARecNo;
          // Next Workaround --> this solution goes to the "next" entry
        end;

        // insert new table account entry
        Append;
        FieldByName('OffeneTischID').AsInteger := TableOffeneTische.FieldByName
          ('OffeneTischID').AsInteger;
        FieldByName('Firma').AsInteger := Gl.Firma;
        FieldByName('Gedruckt').AsString := 'F';
        FieldByName('KellnerID').AsInteger := FWaiterID;
        FieldByName('KasseID').AsInteger := FKasseID;
        FieldByName('Datum').AsDateTime := Gl.KassenDatum;
        FieldByName('BeilagenID1').AsInteger := PSideOrderID;
        // 29.07.2010 BW: take description from table BEILAGEN
        FieldByName('LookArtikel').Value := TableBeilagen.FieldByName
          ('Bezeichnung').Value;
        FieldByName('Menge').Value := Null;
        FieldByName('Verbucht').AsString := 'T';
        // 29.11.2010 BW: 'Verbucht' is always true because false is only important if you make instant stock withdrawal without closing table
        FieldByName('Beilagenabfrage').AsString := '';
        // unsign new side order, because you can only sign articles for side order obligation
        FieldByName('TischkontoID').AsInteger := ANewTableAccountID;
        // 05.08.2010 BW: take stored string by FormFreeTextInput for 'BeilagenText', if side order is free text input (id = -1)
        // and take the free text input for description!
        if PSideOrderID =-1 then
        begin
          FieldByName('BeilagenText').AsString := FFreeTextInput;
          FieldByName('LookArtikel').Value := FFreeTextInput;
        end;
        Post;
      end
      else
      begin
      // add to last side order (table account entry)
        Edit;
        FieldByName('BeilagenID' + Inttostr(ASideOrderCounter + 1)).Asinteger :=
          PSideOrderID;
        // 29.07.2010 BW: take description from table BEILAGEN and concat it to the current description
        FieldByName('LookArtikel').AsString :=
          Concat(FieldByName('LookArtikel').AsString, ' ',
          TableBeilagen.FieldByName('Bezeichnung').AsString);
        Post;
      end;

      // modify the price of the article of the just added side order (field 'PreisPlus' and 'PreisMinus')
      ModifyPricebySideOrder(PTargetAccount, ASideOrderCounter + 1);

    end;
  end;
end;

procedure TDataPos.MoveArticleFromAccount(PTableAccountId: Integer;
  PFactor: Integer);
begin

  if RemoveTableAccountEntry(CDSKonto, CDSHilfKonto, PTableAccountID, PFactor)
  then
    AddTableAccountEntry(CDSHilfKonto, CDSKonto, PTableAccountID, 1);

end;

procedure TDataPos.MoveArticleToAccount(PTableAccountId: Integer;
  PFactor: Integer);
begin

  if RemoveTableAccountEntry(CDSHilfKonto, CDSKonto, PTableAccountID,-1)then
    AddTableAccountEntry(CDSKonto, CDSHilfKonto, PTableAccountID, PFactor);

end;

procedure TDataPos.AddTableAccountEntry(PTargetAccount, PSourceAccount
  : TDataSet; PTableAccountId: Integer; PFactor: Integer);
begin

  with PSourceAccount do
  begin
    // 06.12.2010 BW
    // close;
    // open;
    Locate('Firma; TischKontoID;', VarArrayOf([Gl.Firma, PTableAccountID]),[]);
  end;

  with PTargetAccount do
  begin
    // 06.12.2010 BW
    // close;
    // open;
    if Locate('TischKontoID;Firma', VarArrayOf([PTableAccountID, Gl.Firma]),[])
    then
    begin
      UpdateTableAccountEntryIntoAccount(PTargetAccount,
        PTableAccountID, PFactor);
    end
    else
    begin
      InsertTableAccountEntryIntoAccount(PTargetAccount, PSourceAccount,
        PTableAccountID, 1);
    end;
  end;

end;

function TDataPos.RemoveTableAccountEntry(PTargetAccount, PSourceAccount
  : TDataSet; PTableAccountId: Integer; PFactor: Integer): Boolean;
begin
  Result := False;
  with PTargetAccount do
  begin
    // 06.12.2010 BW
    // close;
    // open;
    if Locate('Firma; TischKontoID', VarArrayOf([Gl.Firma, PTableAccountID]),[])
    then
    begin
      // check if it is tally or if amount is not 0, because negative selections are not allowed!
      if((PFactor = 1)or(FieldByName('Menge').AsInteger <> 0))then
      // 25.11.2010 BW: field amount has to be AsInteger in order to forbid selections on 0,3
      begin
        // check if it is a article or side order --> side orders are not allowed to be moved between CDS accounts!!!
        if not FieldByName('ArtikelID').Isnull then
        begin
          // 24.11.2010 BW: check if it is a tally and table account entry is NOT new and price has changed since the last tally
          if((PFactor = 1)and Fieldbyname('Gedruckt').Asboolean and
            CheckPriceChanged(PTargetAccount))then
          begin
            Gl.Dologfile(FSerialNumber, IvDictio.Translate('Erhöhen von')+ ' ' +
              GetLogInfoArticlebyArticleID(PTargetAccount.Fieldbyname
              ('ArtikelID').Asinteger)
              + ' ' + IvDictio.Translate
              ('aufgrund von Preisänderung NICHT möglich!'));
            // just add the article and make a NEW table account entry
            GetOrderman(FSerialNumber).FcurrentForm.DoAddArticle
              (FieldByName('ArtikelID').AsInteger, 1, False)
          end
          else
          begin
            UpdateTableAccountEntryIntoAccount(PTargetAccount,
              PTableAccountID, PFactor);
            Result := True;
          end;
        end;
      end;
    end;
  end;
end;

procedure TDataPos.RemoveAllTableAccountEntries(PAccount: TDataSet);
begin
  with PAccount do
  begin
    Close;
    Open;
    while not EOF do
    begin
      Edit;
      FieldbyName('Menge').Asfloat := 0;
      Post;
      Next;
    end;
  end;
end;

procedure TDataPos.InsertTableAccountEntryIntoAccount(PTargetAccount,
  PSourceAccount: TDataSet; PTableAccountID: Integer; PAmount: Double);
begin

  // do not insert entries with amount 0!
  if not(PAmount = 0)then
  begin
    with PTargetAccount do
    begin
      // 14.12.2010 BW:
      // close;
      // open;
      Append;
      FieldByName('I_DeviceGuid').Value := PSourceAccount.FieldByName
        ('I_DeviceGuid').Value;
      FieldByName('TischKontoID').Value := PSourceAccount.FieldByName
        ('TischKontoID').Value;
      FieldByName('OffeneTischID').Value := PSourceAccount.FieldByName
        ('OffeneTischID').Value;
      FieldByName('Gedruckt').Value := PSourceAccount.FieldByName
        ('Gedruckt').Value;
      FieldByName('ArtikelID').Value := PSourceAccount.FieldByName
        ('ArtikelID').Value;
      FieldByName('Betrag').Value := PSourceAccount.FieldByName('Betrag').Value;
      FieldByName('BeilagenID1').Value := PSourceAccount.FieldByName
        ('BeilagenID1').Value;
      FieldByName('BeilagenID2').Value := PSourceAccount.FieldByName
        ('BeilagenID2').Value;
      FieldByName('BeilagenID3').Value := PSourceAccount.FieldByName
        ('BeilagenID3').Value;
      FieldByName('BeilagenText').Value := PSourceAccount.FieldByName
        ('BeilagenText').Value;
      FieldByName('Status').Value := PSourceAccount.FieldByName('Status').Value;
      FieldByName('Verbucht').Value := PSourceAccount.FieldByName
        ('Verbucht').Value;
      FieldByName('GangID').Value := PSourceAccount.FieldByName('GangID').Value;
      // 04.11.2010 BW: check if table account entry is no side order --> side orders must not have an amount!
      if not PSourceAccount.FieldByName('ArtikelID').Isnull then
        FieldByName('Menge').AsFloat := PAmount;
      FieldByName('Firma').Value := Gl.Firma;
      // 05.02.2015 KL: TODO: hier wird beim Umbuchen der aktuelle Kellner übernommen
      FieldByName('KellnerID').Value := FWaiterID;
      FieldByName('KasseID').Value := FKasseID;
      FieldByName('Datum').Value := Gl.KassenDatum;

      // if target account is a CDS --> change counter by amount
      // and insert name of article in LookArtikel and
      // and insert BeilagenAbfrage
      if ClassType = TClientDataSet then
      begin
        // if target account is a CDS and source account is a table --> set counter to null
        // and do not insert BeilagenAbfrage, because this field does not exist in tables
        if(not(PSourceAccount.ClassType = TClientDataSet))then
          FieldByName('Zaehler').Value := Null
        else
        begin
          // 17.11.2010 BW: only set counter and beilagenabfrage if it is NO side order!!!
          if not PSourceAccount.FieldByName('ArtikelID').Isnull then
          begin
            FieldByName('Zaehler').AsInteger := Trunc(PAmount);
            FieldByName('BeilagenAbfrage').Value :=
              PSourceAccount.FieldByName('BeilagenAbfrage').Value;
          end;
        end;

        FieldByName('LookArtikel').Value := PSourceAccount.FieldByName
          ('LookArtikel').Value;
      end
      // if target account is a table --> set 'Gedruckt' for printing Bons
      else
      begin
        // if target account is table TISCHKONTO --> set 'Gedruckt' to true, because printpackage prints Bons out of table Hilf_TischKonto
        // and therefore does not set this field to true in table TischKonto
        if PTargetAccount = QueryTableAccount then
          FieldByName('Gedruckt').AsString := 'T'
        else
        // if target account is table HILF_TISCHKONTO
        begin
          // check which is the current Form
          // FormTable, ... Tally (DoDruckeBon(daEinzelBon) only prints articles that have 'Gedruckt' = False)
          // every other Form ... Reversal (DoDruckeBon(daStornoBon) only prints articles that have 'Gedruckt' = True)
          // ATTENTION: this is a simple workaround --> problem must be fixed otherwise (e.g.: in the print package)
          // 25.02.2011 BW: same for field 'Verbucht' in order to make a proper stock withdrawal after tally articles/sideorders
          if(GetOrderman(FSerialNumber).GetcurrentForm = FormTable)then
          begin
            FieldByName('Gedruckt').AsString := 'F';
            FieldByName('Verbucht').AsString := 'F';
          end
          else
          begin
            FieldByName('Gedruckt').AsString := 'T';
            FieldByName('Verbucht').AsString := 'T';
          end;
        end;
      end;
      Post;
    end;
  end;

  // check if article has side orders and insert them also
  with PSourceAccount do
  begin
    Next;
    while((FieldByName('ArtikelID').IsNull)and(not EOF))do
    begin
      // do not insert side orders of articles with amount 0!
      if not(PAmount = 0)then
        InsertTableAccountEntryIntoAccount(PTargetAccount, PSourceAccount,
          FieldbyName('TischKontoID').Asinteger, 1);
      Next;
    end;
    if not EOF then
      Prior;
  end;
end;

procedure TDataPos.UpdateTableAccountEntryIntoAccount(PTargetAccount: TDataSet;
  PTableAccountID: Integer; PAmount: Double);
var
  AOldAmount: Double;
  AIsLastRec: Boolean;
begin

  // do not update entries with change amount 0!
  if PAmount = 0 then
    Exit;

  with PTargetAccount do
  begin
    Close;
    Open;
    if Locate('Firma;TischKontoID', VarArrayOf([Gl.Firma, PTableAccountID]),[])
    then
    begin
      Edit;
      // 04.11.2010 BW: store old amount
      AOldAmount := FieldByName('Menge').AsFloat;
      // change amount by amount
      FieldByName('Menge').AsFloat := FieldByName('Menge').AsFloat + PAmount;
// //mark entry to "amount has been changed"
// FieldByName('Gedruckt').AsString := 'F';
      // if target account is a CDS --> change counter by amount and set side order amount (visibility in hermes line)
      if ClassType = TClientDataSet then
      begin
        FieldbyName('Zaehler').AsInteger := FieldbyName('Zaehler').AsInteger +
          Trunc(PAmount);
        Post;
        // 04.11.2010 BW: if a decrease of an article goes to 0 --> set its side orders also to amount = 0 in order to hide the table account entries in hermes lists
        if FieldByName('Menge').AsFloat = 0 then
        begin
          Next;
          // go through all possible side orders
          while((FieldByName('ArtikelID').Isnull)and(not EOF))do
          begin
            Edit;
            Fieldbyname('Menge').AsFloat := 0;
            Post;
            Next;
          end;
        end
        else
        // 04.11.2010 BW: if an increase of an article goes from 0 to x --> set its side orders to amount = NULL in order to show the table account entries in hermes lists
          if AOldAmount = 0 then
          begin
            Next;
          // go through all possible side orders
            while((FieldByName('ArtikelID').Isnull)and(not EOF))do
            begin
              Edit;
              Fieldbyname('Menge').Value := Null;
              Post;
              Next;
            end;
          end
        // 04.11.2010 BW: end
      end
      else
      // if target account is a Table (TISCHKONTO) --> delete whole entry incl. side orders, if a decrease goes to 0
      // do not delete if it is a CDS in order to leave the 0 entry for countermanding selection
      begin
        Post;
        if FieldByName('Menge').AsFloat = 0 then
        begin
          // check if this is the last record, because after delete last record, cursor stands at the record before and not at EOF!!!
          AIsLastRec := RecNo = Recordcount;
          Delete;
          // go through all possible side orders and delete them too
          while((FieldByName('ArtikelID').Isnull)and(not EOF)and
            (not AIsLastRec))do
          begin
            // check if this is the last record, because after delete last record, cursor stands at the record before and not at EOF!!!
            AIsLastRec := RecNo = Recordcount;
            Delete;
          end;
        end;
      end;
    end;
  end;

end;

function TDataPos.CheckPriceChanged(PTargetAccount: TDataSet): Boolean;
begin
  Result := False;
  with QueryArtikel do
  begin
    Close;
    Parambyname('pFirma').Asinteger := Gl.Firma;
    Parambyname('ArtikelID').Asinteger := PTargetAccount.Fieldbyname
      ('ArtikelID').Asinteger;
    Open;
    if Recordcount > 0 then
      // check if it is NOT an article, which the user has to input an individual price because this one is always different
      if((Fieldbyname('MengePreis').Asstring <> 'P')and
        (Fieldbyname('MengePreis').Asstring <> 'B'))then
        Result := PTargetAccount.Fieldbyname('Betrag').AsFloat <>
          GetPricebyPriceLevel(FPreisEbene);
  end;
end;

function TDataPos.GetPricebyPriceLevel(PPriceLevel: Integer): Double;
var
  APrice: Variant;
begin
  Result := 0;

  case PPriceLevel of
  1 .. 30:
    APrice := QueryArtikel.FieldByName('Preis' + IntToStr(PPriceLevel)).Value;
  99:
    begin
      if QueryArtikel.FieldByName('PersonalPreis').IsNull then
        APrice := QueryArtikel.FieldByName('Preis1').Value
      else
        APrice := QueryArtikel.FieldByName('PersonalPreis').Value;
    end;
else
  APrice := NULL;
  end; { end of CASE }

  if APrice = Null then
    APrice := QueryArtikel.FieldByName('Preis1').Value;

  // 31.08.2010 BW: is aPrice still NULL than take 0 because NULL cannot be converted to datatype float ( or currency)
  if APrice = Null then
    APrice := 0;

  Result := Double(APrice);
end;

procedure TDataPos.ModifyPricebyValue(PTargetAccount: TDataSet;
  PTableAccountID: Integer; PPrice: Double);
begin

  with PTargetAccount do
  begin
    Close;
    Open;
    if Locate('Firma;TischKontoID', VarArrayOf([Gl.Firma, PTableAccountID]),[])
    then
    begin
      Edit;
      // change price by passed value
      FieldByName('Betrag').AsFloat := PPrice;
// //mark entry to "has been changed"
// FieldByName('Gedruckt').AsString := 'F';
      Post;
    end;
  end;
end;

// this function is copied from GKT TDataTische.AddBeilagenpreis
procedure TDataPos.ModifyPricebySideOrder(PTargetAccount: TDataSet;
  PSideOrderCounter: Integer);
var ABookMark: TBookMark;
  APreisMinus, APreisPlus: Boolean;
  ABetrag, AOldBeilagenPreis: Variant;
    // 0 = kein
    // 1 = statt abziehen (beilagen1)
    // 2 = statt dazuaddieren (beilagen2)
  AStatt: Integer;
begin
  if(TableBeilagen.FieldByName('PreisPlus').AsFloat <> 0)or
    (TableBeilagen.FieldByName('PreisMinus').AsFloat <> 0)or
    (Gl.BeilagenPreisTabelle)or
    (not TableBeilagen.FieldByName('PreisEbene').IsNull)then
    with PTargetAccount do
    begin
      ABookMark := GetBookmark;

      APreisMinus := FieldByName('BeilagenID1').AsInteger =-3;

    // Preis PLus entweder immmer, oder nur bei "mit"
      APreisPlus :=(Gl.BeilagenPreisImmerMit or
        (FieldByName('BeilagenID1').AsInteger =-2))and not// immer bei mit
        (FieldByName('BeilagenID1').AsInteger =-6)and not// nicht bei statt
        (FieldByName('BeilagenID1').AsInteger =-5); // nicht bei weniger

      if(FieldByName('BeilagenID1').AsInteger =-6)and(PSideOrderCounter > 1)then
      begin
        if PSideOrderCounter = 2 then
        begin
          APreisMinus := TRUE;
          AStatt := 1
        end
        else
          if PSideOrderCounter = 3 then
          begin
            APreisPLus := TRUE;
            AStatt := 2;
          end;
      end
      else
        AStatt := 0;

      ABetrag := 0;
    // bei "ohne", dann PreisMinus!
      if APreisMinus then
      begin
        ABetrag := TableBeilagen.FieldByName('PreisMinus').AsFloat;
        if AStatt = 1 then
          AOldBeilagenPreis := ABetrag;
      end
      else
        if APreisPlus then
        begin
          if AStatt = 2 then
          begin
            ABetrag := TableBeilagen.FieldByName('PreisPlus').AsFloat;
         // Der Stattpreis darf den Gesamtwert nicht verringern
            if Abs(AOldBeilagenPreis)> ABetrag then
              ABetrag := Abs(AOldBeilagenPreis);
          end
          else
            ABetrag := TableBeilagen.FieldByName('PreisPlus').AsFloat;
        end;
    // bis zum Artikel zurückgehen;
      while FieldByName('ArtikelID').IsNull and not BOF do
        Prior;

      if not TableBeilagen.FieldByName('PreisEbene').IsNull then
      begin
        case TableBeilagen.FieldByName('PreisEbene').AsInteger of
        1 .. 30:
          ABetrag := QueryArtikel.FieldByName
            ('Preis' + IntToStr(TableBeilagen.FieldByName('PreisEbene')
            .AsInteger)).Value;
        end; { end of CASE }

        if ABetrag = Null then
          ABetrag := QueryArtikel.FieldByName('Preis1').AsFloat;
        ABetrag := ABetrag - FieldByName('Betrag').AsFloat;
      end;

      if ABetrag <> 0 then
      begin
        ABetrag := ABetrag; // * FieldByName('Menge').AsFloat;
        Edit;
        FieldbyName('Betrag').AsFloat := FieldByName('Betrag').AsFloat
          + ABetrag;
        Post;
      end;
      GotoBookMark(ABookMark);
      FreeBookMark(ABookMark);
    end;
end;

function TDataPos.GetArticleIDbyTableAccountID(PTargetAccount: TDataSet;
  PTableAccountID: Integer): Integer;
begin
  Result :=-1;
  with PTargetAccount do
  begin
    // 06.12.2010 BW:
    // close;
    // open;
    if Locate('Firma;TischKontoID', VarArrayOf([Gl.Firma, PTableAccountID]),[])
    then
      Result := Fieldbyname('ArtikelID').Asinteger;
  end;
end;

function TDataPos.GetFertigeSpeisen(PWaiterID: Integer):string;
begin
  Result := '';
  if PWaiterID = 0 then
    Exit;

  with QueryGetFertigeSpeisen do
  begin
    Close;
    ParamByName('KellnerID').AsInteger := PWaiterID;
    Open;
    if not Eof then
    begin
      Edit;
      FieldByName('Status').AsInteger := 1;
      Post;
      Result := Format(IvDictio.Translate('Tisch %s: %d x %s'),
        [FieldByName('TischNr').AsString, FieldByName('Anz').AsInteger,
        FieldByName('Bez').AsString]);
    end;
  end;
end;

function TDataPos.ConfirmFertigeSpeisen(PWaiterID: Integer):string;
begin
  Result := '';
  if PWaiterID = 0 then
    Exit;

  with QueryConfirmFertigeSpeisen do
  begin
    Close;
    ParamByName('KellnerID').AsInteger := PWaiterID;
    Open;
  end;
end;

function TDataPos.GetOpenTableIDbyTableID(PTableID: Integer): Integer;
begin
  Result :=-1;
  with QueryGetOpenTableIDbyTableID do
  begin
    Close;
    Parambyname('pFirma').AsInteger := Gl.Firma;
    Parambyname('pTischID').AsInteger := PTableID;
    Parambyname('pDatum').Asdate := Gl.KassenDatum;
    Open;
    if Recordcount > 0 then
      Result := Fieldbyname('OffeneTischID').Asinteger;
  end;
end;

function TDataPos.GetTableNumberbyTableID(PTableID: Integer):string;
begin
  Result := '';
  with TableTisch do
  begin
    if Locate('TischID;Firma', VarArrayOf([PTableID, Gl.Firma]),[])then
      Result := Trim(Fieldbyname('TischNR').Asstring);
  end;
end;

function TDataPos.GetTableIDbyTablename(PTableName:string): Integer;
begin
  Result := 0;
  with TableTisch do
  begin
    if Locate('Bezeichnung;Firma', VarArrayOf([PTableName, Gl.Firma]),[])then
      if Fieldbyname('Bezeichnung').Asstring = PTableName then
        Result := Fieldbyname('TischID').Asinteger;
  end;
end;

function TDataPos.GetGuestNamebyReservId(PReservID: Integer):string;
begin
  Result := '';

  if Gl.HotelProgrammTyp = HpHotelFelix then
    with QueryReservFELIX do
    begin
      Close;
      ParamByName('pFirma').AsInteger := Gl.Firma;
      ParamByName('pID').AsInteger := PReservID;
      Open;
      if not EOF then
        Result := Trim(FieldByName('Gastname').AsString);
    end
  else
    if Gl.HotelProgrammTyp = HpAllgemeinSQL then
      with QueryTerminNr do
      begin
        Close;
        ParamByName('pTerminNr').AsInteger := PReservID;
        Open;
        if not EOF then
          Result := Trim(FieldByName('Gastname').AsString);
      end;
end;

function TDataPos.CheckReservId(PFirma, PReservID: Integer): Boolean;
begin
  with QueryReservFELIX do
  begin
    Close;
    ParamByName('pFirma').AsInteger := PFirma;
    ParamByName('pID').AsInteger := PReservID;
    Open;
    Result := not EOF;
  end;
end;

function TDataPos.CheckReservIdCheckIn(PFirma, PReservID: Integer): Boolean;
begin
  with QueryReservFELIX do
  begin
    Close;
    ParamByName('pFirma').AsInteger := PFirma;
    ParamByName('pID').AsInteger := PReservID;
    Open;
    Result :=(not EOF)and(FieldByName('CheckIn').AsBoolean);
  end;
end;

function TDataPos.GetTableNumber:string;
begin
  Result := '';
  with TableTisch do
  begin
    // 06.12.2010 BW:
    Close;
    Open;
    if Locate('Firma;TischID', VarArrayOf([Gl.Firma, FTableID]),[])then
      Result := Trim(Fieldbyname('TischNR').Asstring);
  end;
end;

function TDataPos.GetTableDescriptionbyTableID(PTableID: Integer):string;
begin
  Result := '';
  with TableTisch do
  begin
    // 06.12.2010 BW:
    // close;
    // open;
    if Locate('Firma;TischID', VarArrayOf([Gl.Firma, PTableID]),[])then
      Result := Trim(Fieldbyname('Bezeichnung').Asstring);
  end;
end;

function TDataPos.GetTableDescription:string;
begin
  Result := '';
  with TableTisch do
  begin
    // 06.12.2010 BW:
    Close;
    Open;
    if Locate('Firma;TischID', VarArrayOf([Gl.Firma, FTableID]),[])then
      Result := Trim(Fieldbyname('Bezeichnung').Asstring);
  end;
end;

function TDataPos.GetTableTypeAbbreviationbyTableID(PTableID: Integer):string;
begin
  Result := '';
  with TableTisch do
    if Locate('Firma;TischID', VarArrayOf([Gl.Firma, PTableID]),[])then
      Result := Trim(Fieldbyname('Tischtyp').Asstring);
end;

function TDataPos.GetWaiterName:string;
begin
  Result := '';
  with QueryWaiter do
    if Locate('Firma; KellnerID', VarArrayOf([Gl.Firma, FWaiterID]),[])then
      Result := Trim(Trim(Fieldbyname('Vorname').Asstring)+ ' ' +
        Trim(Fieldbyname('Nachname').AsString));
end;

function TDataPos.GetLoginName:string;
begin
  Result := '';
  with QueryWaiter do
    if Locate('Firma; KellnerID', VarArrayOf([Gl.Firma, FWaiterID]),[])then
      Result := Trim(Fieldbyname('Loginname').Asstring);
end;

function TDataPos.GetLoginNamebyWaiterID(PWaiterID: Integer):string;
begin
  Result := '';
  with QueryWaiter do
    if Locate('Firma;KellnerID', VarArrayOf([Gl.Firma, PWaiterID]),[])then
      Result := Trim(Fieldbyname('Loginname').Asstring);
end;

function TDataPos.GetWaiterNamebyWaiterID(PWaiterID: Integer):string;
begin
  Result := '';
  with QueryWaiter do
    if Locate('Firma;KellnerID', VarArrayOf([Gl.Firma, PWaiterID]),[])then
      Result := Trim(Trim(Fieldbyname('Vorname').AsString)+ ' ' +
        Trim(Fieldbyname('Nachname').AsString));
end;

function TDataPos.GetStationName:string;
begin
  Result := '';
  with QueryReviere do
  begin
    Close;
    Open;
    if Locate('ID', VarArrayOf([FStationID]),[])then
      Result := Trim(Fieldbyname('Name').Asstring);
  end;
end;

function TDataPos.GetPaymentMethodName:string;
begin
  Result := '';
  with QueryZahlweg do
  begin
    Close;
    Parambyname('Firma').Asinteger := Gl.Firma;
    Open;
    if Locate('ID', VarArrayOf([FPrint_PaymentMethodID]),[])then
      Result := Trim(Fieldbyname('Bezeichnung').Asstring);
  end;
end;

function TDataPos.GetSideOrderListName:string;
var
  AArticleID: Integer;
begin
  Result := 'S100'; // standard empty list ('KEINE')
  AArticleID := GetArticleIDbyTableAccountID(CDSKonto, FTableAccountID);
  with QueryArtikel do
  begin
    Close;
    Parambyname('pFirma').Asinteger := Gl.Firma;
    Parambyname('ArtikelID').Asinteger := AArticleID;
    Open;
    if Recordcount > 0 then
      Result := 'S' + Inttostr(100 + Fieldbyname('BeilagenGruppeID').Asinteger);
  end;
end;

function TDataPos.GetSideOrderIDbyTableAccountID(PTableAccountID
  : Integer): Integer;
var
  AArticleID: Integer;
begin
  Result := 0; // standard empty list ('KEINE')
  AArticleID := GetArticleIDbyTableAccountID(CDSKonto, PTableAccountID);
  with QueryArtikel do
  begin
    Close;
    Parambyname('pFirma').Asinteger := Gl.Firma;
    Parambyname('ArtikelID').Asinteger := AArticleID;
    Open;
    if Recordcount > 0 then
      Result := Fieldbyname('BeilagenGruppeID').Asinteger;
  end;
end;

function TDataPos.GetAccountTotal(PAccount: TDataSet): Double;
var
  ABetragAsCurr: Currency;
  ABetrag, AMenge, AProdukt, ATotal: Double;
begin
  Result := 0;
  ATotal := 0;
  with PAccount do
  begin
    Close;
    Open;
    while not EOF do
    begin
      // don't mix currency with float!
      ABetragAsCurr := FieldbyName('Betrag').AsCurrency;
      ABetrag := ABetragAsCurr;
      AMenge := FieldbyName('Menge').AsFloat;
      AProdukt := ABetrag * AMenge;
      ATotal := ATotal + AProdukt;
      // original source code below has been replaced by KL with source code above!
      // aTotal := aTotal + FieldbyName('Betrag').AsCurrency * FieldbyName('Menge').AsFloat;
      Next;
    end;
    Result := RoundDouble(ATotal); // KL: kaufmänn. runden
  end;
end;

function TDataPos.GetLogInfoTablebyTableID(PTableID: Integer):string;
begin
  Result := '';
  with TableTisch do
  begin
    // 06.12.2010 BW:
    // close;
    // open;
    if Locate('Firma;TischID', VarArrayOf([Gl.Firma, PTableID]),[])then
      Result := IvDictio.Translate('Tisch')+ ' ' +
        Trim(Fieldbyname('TischNR').Asstring)+ ' ' +
        IvDictio.Translate('mit der ID')+ ' ' + Inttostr(PTableID);
  end;
end;

function TDataPos.GetLogInfoArticlebyArticleID(PArticleID: Integer):string;
begin
  Result := '';
  with QueryArtikel do
  begin
    Close;
    Parambyname('pFirma').Asinteger := Gl.Firma;
    Parambyname('ArtikelID').Asinteger := PArticleID;
    Open;
    if Recordcount > 0 then
      Result := IvDictio.Translate('Artikel')+ ' ' +
        Trim(Fieldbyname('Bezeichnung').Asstring)+ ' ' +
        IvDictio.Translate('mit der ID')+ ' ' +
        Inttostr(Fieldbyname('ArtikelID').Asinteger);
  end;
end;

function TDataPos.GetLogInfoSideOrderbySideOrderID(PSideOrderID
  : Integer):string;
begin
  Result := '';
  with TableBeilagen do
  begin
    // 06.12.2010 BW:
    // close;
    // open;
    if Locate('Firma;BeilagenID', VarArrayOf([Gl.Firma, PSideOrderID]),[])then
      Result := IvDictio.Translate('Beilage')+ ' ' +
        Trim(Fieldbyname('Bezeichnung').Asstring)+ ' ' +
        IvDictio.Translate('mit der ID')+ ' ' +
        Inttostr(Fieldbyname('BeilagenID').Asinteger);
  end;
end;

function TDataPos.GetLogInfoWaiterbyWaiterID(PWaiterID: Integer):string;
begin
  Result := '';
  with QueryWaiter do
    if Locate('Firma;KellnerID', VarArrayOf([Gl.Firma, PWaiterID]),[])then
      Result := IvDictio.Translate('Kellner')+ ' '
        + Trim(Trim(Fieldbyname('Vorname').AsString)+ ' ' +
        Trim(Fieldbyname('Nachname').Asstring))+ ' '
        + IvDictio.Translate('mit der ID')+ ' ' + Inttostr(PWaiterID);
end;

function TDataPos.GetMobilePrinterNamebyPrinterID(PPrinterID: Integer):string;
begin
  Result := '';
  with TableDrucker do
  begin
    Close;
    Open;
    if Locate('DruckerID', PPrinterID,[])then
      Result := Trim(Fieldbyname('Bezeichnung').Asstring);
  end;
end;

end.
