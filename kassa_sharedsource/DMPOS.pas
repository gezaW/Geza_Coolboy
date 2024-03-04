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
  FireDAC.Comp.Client, DB, DBClient, MidasLib, StdCtrls,
  DMBase, Pglobal, PDMTische, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.UI.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys, FireDAC.VCLUI.Wait,
  FireDAC.Comp.DataSet, FireDAC.Phys.FB, FireDAC.Phys.FBDef;
// OrdermanConst;

type
  TDataPos = class(TDataModule)
    DataSourceOffeneTische: TDataSource;
    QueryToTisch: TFDQuery;
    Query: TFDQuery;
    QueryDelTischkonto: TFDQuery;
    QueryInsertRechkonto: TFDQuery;
    QueryLocateOffenerTisch: TFDQuery;
    QueryHappyHour: TFDQuery;
    QueryFromTisch: TFDQuery;
    QueryRechnungskontoIT: TFDQuery;
    QueryZahlweg: TFDQuery;
    QueryDelRechnung: TFDQuery;
    QueryDelRechzahlweg: TFDQuery;
    QueryRechNr: TFDQuery;
    QueryInsertRechnung: TFDQuery;
    QueryInsertRechzahlung: TFDQuery;
    QueryDelRechnungsKonto: TFDQuery;
    QueryRechnungsKonto: TFDQuery;
    QueryReviere: TFDQuery;
    TableDrucker: TFDTable;
    TableTisch: TFDTable;
    TableBeilagen: TFDTable;
    TableSteuer: TFDTable;
    TableRechnung: TFDTable;
    TableKasseIT: TFDTable;
    TableZimmerFELIX: TFDTable;
    TableGastkontoFELIX: TFDTable;
    TableDiverses: TFDTable;
    QueryGetNextID: TFDQuery;
    QueryMwSt: TFDQuery;
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
    QueryGetLeistungsID: TFDQuery;
    TableOffeneTische: TFDQuery;
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
    TableTischgruppe: TFDTable;
    TableKellner: TFDTable;
    CommandJournal: TFDCommand;
    QueryInsertOffeneTische: TFDQuery;
    TableHotellog: TFDTable;
    TableGastinfo: TFDTable;
    QueryArtikel: TFDQuery;
    QueryLockTisch: TFDQuery;
    QuerySelectArtikel: TFDQuery;
    TableArtikel: TFDTable;
    TableUntergruppe: TFDTable;
    TableHauptgruppe: TFDTable;
    TableKassinfo: TFDTable;
    QueryGetLeistung: TFDQuery;
    QueryHilfTischkonto: TFDQuery;
    QueryHilfTischkontoFirma: TSmallintField;
    QueryHilfTischkontoTischkontoID: TIntegerField;
    QueryHilfTischkontoOffeneTischID: TIntegerField;
    QueryHilfTischkontoDatum: TDateField;
    QueryHilfTischkontoArtikelID: TIntegerField;
    QueryHilfTischkontoMenge: TFloatField;
    QueryHilfTischkontoBetrag: TCurrencyField;
    QueryHilfTischkontoKellnerID: TIntegerField;
    QueryHilfTischkontoKasseID: TIntegerField;
    QueryHilfTischkontoGEDRUCKT: TStringField;
    QueryHilfTischkontoBeilagenID1: TIntegerField;
    QueryHilfTischkontoBeilagenID2: TIntegerField;
    QueryHilfTischkontoBeilagenID3: TIntegerField;
    QueryHilfTischkontoBeilagenText: TStringField;
    QueryHilfTischkontoStatus: TSmallintField;
    QueryHilfTischkontoVERBUCHT: TStringField;
    QueryHilfTischkontoGANGID: TIntegerField;
    TableTischkonto: TFDQuery;
    QueryRoomDiscount: TFDQuery;
    QueryGetHaupgruppeVorSum: TFDQuery;
    QueryGetRabatt: TFDQuery;
    QueryJournalControl: TFDQuery;
    QueryCheckZimmerIB: TFDQuery;
    QueryTische: TFDQuery;
    QueryTableAccount: TFDQuery;
    QueryHelpTableAccount: TFDQuery;
    TransactionLockTable: TFDTransaction;
    QueryGetOpenTableIDbyTableID: TFDQuery;
    QueryWaiter: TFDQuery;
    QueryReactivateTable: TFDQuery;
    QueryCheckTableisReopened: TFDQuery;
    QueryProcedureCheckTischOffen: TFDQuery;
    QueryWriteCurrentWaiterToOpenTable: TFDQuery;
    TableOffeneTischeCURRENTWAITERID: TIntegerField;
    QueryGetFertigeSpeisen: TFDQuery;
    QueryConfirmFertigeSpeisen: TFDQuery;
    QueryHilfTischkontoI_DEVICEGUID: TStringField;
    QueryReservFELIX: TFDQuery;
    QueryCheckFELIX: TFDQuery;
    QueryTerminNr: TFDQuery;
    ConnectionFelix: TFDConnection;
    procedure DataModuleCreate(Sender: TObject);
    procedure TableGastkontoFELIXAfterInsert(DataSet: TDataSet);

  private

    FSerialNumber: Integer;
    FPreisEbene, FPreisebeneTisch: Integer;

    FKellnerLagertisch, FKellnerPreisebene: Integer;
    FKellnerSpracheID: Integer;

    // fields for waiter rights (are accessed over property in public)
    FKellnerDarfSplitten, FKellnerLagerNichtBon, FKellnerLagerStorno,
      FKellnerLagerAnzeigen, FKellnerDarfXBon, FKellnerDarfZBon,
      FKellnerWerbung, FKellnerBruch, FKellnerPersonal, FKellnerEigenbedarf,
      FKellnerStammgaeste, FKellnerIsChef, FKellnerGesamtStorno, FKellnerStorno,
      FKellnerTeilStorno, FKellnerSofortStorno, FKellnerUmbuchen,
      FKellnerGesamtUmbuchen, FKellnerTeilUmbuchen, FKellnerRechnung,
      FKellnerGesamtRechnung, FKellnerTeilRechnung, FKellnerSofortRechnung,
      FKellnerBonDruck, FKellnerOhneDruck, FKellnerdarfreakt,
      FKellnerDarfWechsel, FKellnerDarfNachrichten: Boolean;

    FTabelleSchluesselUrsprung, FTabelleSchluesselGerade,
    // Kodierungstabelle für Paßwort (Gerade)
    // Kodierungstabelle für Paßwort (Ungerade)
    FTabelleSchluesselUnGerade: array [1 .. 39] of Char;

    // *********** universal functions (copied from KASSE) ***********
    function GetSchluesselChar(Schluessel: TSchluessel; Zeichen: Char): Char;
    function Verschluesseln(PPW: string): string;
    // copied from DMBASE but without starting an extra transaction and commit it
    function GetGeneratorID(PGenerator: string; PInc: Integer): Integer;
    function GetNextIBID(ATableName: string; ATable: TDataSet;
      AIDString: string): Integer;
    // **************************************************************

    // *********** Billing functions for SetSofortRechnung(copied from KASSE) ***********
    // Eine neue Rechnungsnummer holen
    // Bei Proforma RechnungsNr wieder zurücksetzeb
    procedure SetRechnungsNr(PProforma: Boolean; PBetrag: Single);
    // Die Leistungen der Hilfstabelle werden auf die Rechnung transferiert
    procedure TransferLeistungToRechnung(PTischkontoTabelle: TFDQuery;
      PProforma: Boolean; PRechID: Integer);
    // Ins Rechnungskonto einen Artikel einfügen
    procedure DoInsertIntoRechkonto(PFirma, PRechID: Integer; PDatum: TDateTime;
      PArtikelID: Integer; PMenge, PBetrag: Real; PBeilagen: string;
      PBonNr: Integer);
    // Die Leistungen von Rechnungskonto werden wieder auf den Tisch transferiert (Rechnung Reaktivieren)
    procedure TransferLeistungToTischkonto;
    // **************************************************************

    // *********** special billing functions for italian customers ***********
    procedure SetKasseIT(PRechnungsID: Integer; PRabatt, PNachlass: Real);
    procedure DoProforma(PTischkontoTabelle: TFDQuery; PRechID: Integer);
    procedure DeleteHilfTischkontoFromServer(PDeleteHilfTischkonto: Boolean);
    // **************************************************************

    // *********** TransferToGuest functions for ZimmerTeilUmbuchung(copied from KASSE) ***********
    procedure TransferToZimmer(PReservID: Integer;
      PZimmer, PGastadresseID: string);
    procedure WriteToGastkonto(PTischNr: string; PReservID: Integer;
      PDatum: TDateTime; PTime: TTime; PBetrag: Double;
      PMehrwertsteuer: Integer; PText: string; PMenge: Integer;
      PHauptgruppe, PGastadresseID, PZimmer: string; PArtikelID: Integer);
    procedure WriteToKassenJournalIB(PFirma, PReservID: Integer;
      PZimmerNr, PTischNr: string; PDatum: TDateTime; PTime: TTime;
      PLeistungsID: Integer; PBetrag: Double; PMenge: Integer);
    procedure WriteHotelLog(PText: string; PDatum: TDateTime;
      PKellnerID, PVonTischID: Integer; PReservID, PZimmerNr: string);
    procedure WriteToKassInfo(PTischNr: string; PReservID: string;
      PBetrag: Double; PMehrwertsteuer, PLeistungsID: Integer; PText: string;
      PHauptGruppeID, PArtikelID: Integer; PMenge: Integer; PZimmerNr: string);
    procedure CheckRoomDiscount;
    procedure WriteToJournalControl(PText: string;
      PZahlwegID, PMenge, PArtikelID, PBeilagenID, PJournalTyp,
      POffeneTischID: Variant; PBetrag: Double; PVonOffeneTischID, PRechnungsID,
      PNachlass: Variant; PKellnerID: Integer);
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
    // function RemoveTableAccountEntry(PTargetAccount, PSourceAccount: TDataSet;
    // PTableAccountID: Integer; PFactor: Integer): Boolean;
    // procedure RemoveAllTableAccountEntries(PAccount: TDataSet);
    // procedure AddTableAccountEntry(PTargetAccount, PSourceAccount: TDataSet;
    // PTableAccountID: Integer; PFactor: Integer);
    // procedure InsertTableAccountEntryIntoAccount(PTargetAccount,
    // PSourceAccount: TDataSet; PTableAccountID: Integer; PAmount: Double);
    // procedure UpdateTableAccountEntryIntoAccount(PTargetAccount: TDataSet;
    // PTableAccountID: Integer; PAmount: Double);
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
    FFreeTextInput: string;
    FWaiterID: Integer;
    FTableType: TTableTypes;
    FTableMode: TTischTyp;
    FStationID: Integer;
    FRoomID: Integer;
    FMasterTableID: Integer;
    FisReactivationMode: Boolean;
    FPrint_PaymentMethodID: Integer;
    FPrint_Discount: Double;
    FPrint_isKassierBon: Boolean;
    FPrint_AmountofPrintouts: Byte;
    FTableSearchString: string;
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
    procedure SetSofortRechnung(PTyp: Integer; PTischkontoTable: TFDQuery;
      PZahlweg: Integer; PRabatt: Real; PAdresseID, PAnzahl: Integer);
    procedure WriteUmbuchToJournal(PTischID, PTyp: Integer;
      PText, PZimmerNr: string);
    // **************************************************************

    // *********** TransferToGuest/Table functions (copied from KASSE) ***********
    function ZimmerTeilUmbuchen(PReservID, PDruckerID,
      PAnzahl: Integer): Boolean;
    function CheckZimmer(PZimmerID: Integer): Integer; overload;
    function CheckZimmer(PZimmerNr: string): Integer; overload;
    // // Vergleicht die Tischpreisebenen bei Umbuchungen und passt die Preise am Zieltisch gegebenfalls an
    // procedure CheckPreisChange(PVonOffeneTischID, PZuOffeneTischID: Integer;
    // PTeil: Boolean);
    // **************************************************************

    // *********** open/close table functions (copied from KASSE) ***********
    // Geht in den bereits belgten Tisch oder öffnet den Tisch Neu
    // Result FALSE: Tisch konnte nicht geöffnet werden (z.b. weil wer anderer drin ist
    function Tischoeffnen(PTischID: Integer; var PErrorMessage: string)
      : Boolean;
    // Sucht den Tisch, schickt die noch nicht bonierten Artikel zum Server und ruft "Tischschliessen" auf
    procedure Tischbeenden(PTischID: Integer);
    function LocateOffenenTisch(PTischTyp: string; PTischID: Integer): Boolean;
    // Liefert ALLE oder Belegte Tische in der QueryTisch zurück
    procedure GetTische(PTischart: TTischTyp; PTischTyp: string;
      PSplitTischID, PRevierID: Integer; PTableSearchString: string);
    // **************************************************************

    /// / *********** 27.05.2010 BW: new functions for add/modify articles/sideorders ***********
    // procedure AddArticle(PTargetAccount: TDataSet;
    // PArticleID, PMultiplier: Integer);
    // procedure AddSideOrder(PTargetAccount: TDataSet;
    // PTableAccountID, PSideOrderID: Integer);
    procedure ModifyPricebyValue(PTargetAccount: TDataSet;
      PTableAccountID: Integer; PPrice: Double);
    // procedure ModifyPricebySideOrder(PTargetAccount: TDataSet;
    // PSideOrderCounter: Integer);
    // **************************************************************

    // *********** 27.05.2010 BW: new functions for moving articles between table accounts  ***********
    // procedure MoveArticleFromAccount(PTableAccountId: Integer;
    // PFactor: Integer);
    // procedure MoveArticleToAccount(PTableAccountId: Integer; PFactor: Integer);
    // procedure GetTableAccount(PTargetAccount: TClientDataSet;
    // PSourceAccount: TFDQuery);
    // procedure SendTableAccount(PTargetAccount, PSourceAccount: TDataSet);
    // procedure MoveTableAccount(PTargetAccount, PSourceAccount: TDataSet);
    // procedure ChangeTableAccount(PTargetAccount: TDataSet;
    // POpenTableID: Integer);
    // procedure SetTableAccount(POpenTableID: Integer);
    // procedure SumArticlesinTableAccount(PTargetAccount, PSourceAccount
    // : TDataSet);
    // **************************************************************

    // *********** 27.05.2010 BW: new check functions ***********
    function CheckLoginName(PLoginName: string): Boolean;
    function CheckLoginPassword(PLoginPassword: string): Boolean;
    function CheckSplitTables(PTableID: Integer): Boolean;
    function CheckHasHotelInterface: Boolean;
    // function CheckTableAccountEmpty(PAccount: TDataSet): Boolean;
    // // 03.02.2012 19:35 KL: ceck if there is one ore more rooms tallied at table account
    // function CheckTableAccountHasRooms(PAccount: TDataSet): Boolean;
    //
    // // 07.04.2011 BW: new check function for side order obligation in order to deny DoTally
    // function CheckTableAccountSideOrderObligation(PAccount: TDataSet): Boolean;
    function CheckWaiterRight(PWaiterHasRight: Boolean): Boolean;
    // **************************************************************

    // *********** 27.05.2010 BW: new get functions ***********
    // function GetArticleIDbyTableAccountID(PTargetAccount: TDataSet;
    // PTableAccountID: Integer): Integer;
    function GetOpenTableIDbyTableID(PTableID: Integer): Integer;
    function GetTableNumberbyTableID(PTableID: Integer): string;
    function GetTableIDbyTableName(PTablename: string): Integer;
    function GetGuestNamebyReservId(PReservID: Integer): string;
    function GetTableDescriptionbyTableID(PTableID: Integer): string;
    function GetTableDescription: string;
    function GetTableTypeAbbreviationbyTableID(PTableID: Integer): string;
    function GetTablenumber: string;
    function GetWaiterName: string;
    function GetLoginName: string;
    function GetLoginNamebyWaiterID(PWaiterID: Integer): string;
    function GetWaiterNamebyWaiterID(PWaiterID: Integer): string;
    function GetStationName: string;
    function GetPaymentMethodName: string;
    // function GetSideOrderListName:string;
    // function GetSideOrderIDbyTableAccountID(PTableAccountID: Integer): Integer;
    // function GetAccountTotal(PAccount: TDataSet): Double;
    function GetLogInfoTablebyTableID(PTableID: Integer): string;
    function GetLogInfoWaiterbyWaiterID(PWaiterID: Integer): string;
    function GetLogInfoArticlebyArticleID(PArticleID: Integer): string;
    function GetLogInfoSideOrderbySideOrderID(PSideOrderID: Integer): string;
    function GetMobilePrinterNamebyPrinterID(PPrinterID: Integer): string;
    // 21.12.2013 KL: interne Zimmerverwaltung
    function GetGastname(PZimmerNr: string): string;

    // 08.03.2013 KL: TODO (11:30)
    function GetFertigeSpeisen(PWaiterID: Integer): string;
    function ConfirmFertigeSpeisen(PWaiterID: Integer): string;

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
    property KellnerdarfWechsel: Boolean read FKellnerDarfWechsel;
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
  IvDictio, PDMDrucken, PDMStatistik, Math, PosPrinting,
  IdGlobal, NXLogging; // for iif

/// / ******************************************************************************
/// / Preisänderung beim Umbuchen?
/// / ******************************************************************************
// procedure TDataPos.CheckPreisChange(PVonOffeneTischID, PZuOffeneTischID
// : Integer; PTeil: Boolean);
// var APreisebeneQuelle, APreisebeneZiel: Integer;
// begin
// if not pGl.ChangePriceOnTransfer then
// EXIT;
//
// with QueryCheckPreisebene do
// begin
// Close;
// ParamByName('OffeneTischID').AsInteger := PVonOffeneTischID;
// Open;
// APreisebeneQuelle := FieldByName('Preisebene').AsInteger;
// Close;
// ParamByName('OffeneTischID').AsInteger := PZuOffeneTischID;
// Open;
// APreisebeneZiel := FieldByName('Preisebene').AsInteger;
// Close;
// if(APreisebeneQuelle <> APreisebeneZiel)and
// not(((APreisebeneQuelle = 0)and(APreisebeneZiel = 1))or
// ((APreisebeneQuelle = 1)and(APreisebeneZiel = 0)))then
// begin
// // 24.11.2010 BW: exchange TableHilf_Tischkonto with CDSHilfKonto because OrdermanServer 8.5 and higher works with CDSHilfKonto during transfering
// with CDSHilfKonto do // TableHilf_Tischkonto Do
// begin
// if not PTeil then
// begin
// Close;
// ParamByname('pOffeneTischID').AsInteger := PVonOffeneTischID;
// Open;
// end;
// First;
// while not EOF do
// begin
// PDataStatistik.WriteToJournal(IvDictio.Translate('Preisumbuchung -'),
// Null,
// -FieldByName('Menge').AsInteger,
// FieldByName('ArtikelID').AsInteger, Null, 1,
// PVonOffeneTischID,
// FieldByName('Betrag').AsFloat, Null, Null, Null, FWaiterID,
// FALSE, Null);
// Next;
// end; // while
// First;
// QuerySelectArtikel.ParambyName('pFirma').AsInteger := pGl.Firma;
// while not EOF do
// begin
// QuerySelectArtikel.ParambyName('pArtikelID').AsInteger :=
// FieldByName('ArtikelID').AsInteger;
// QuerySelectArtikel.Open;
// if QuerySelectArtikel.Recordcount = 1 then
// begin
// Edit;
// case APreisebeneZiel of //
// 0:
// if not QuerySelectArtikel.FieldByName('Preis1').IsNull then
// FieldByName('Betrag').AsFloat := QuerySelectArtikel.FieldByName
// ('Preis1').AsFloat;
// 1 .. 30:
// if not QuerySelectArtikel.FieldByName
// ('Preis' + IntToStr(APreisebeneZiel)).IsNull then
// FieldByName('Betrag').AsFloat := QuerySelectArtikel.FieldByName
// ('Preis' + IntToStr(APreisebeneZiel)).AsFloat;
// end; // case
// Post;
// PDataStatistik.WriteToJournal
// (IvDictio.Translate('Preisumbuchung +'), Null,
// FieldByName('Menge').AsInteger,
// FieldByName('ArtikelID').AsInteger, Null, 1,
// PVonOffeneTischID,
// FieldByName('Betrag').AsFloat, Null, Null, Null, FWaiterID,
// FALSE, Null);
// end;
// QuerySelectArtikel.Close;
// Next;
// end; // while
// end; // with
// end;
// end; // with
// end;
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
    (TableOffeneTischeOFFENETISCHID.AsInteger, PRechID, PTischkontoTabelle,
    FWaiterID);

  // Jetzt die Rechnung wieder löschen!
  QueryDelRechzahlweg.ParamByName('RechnungsID').AsInteger := PRechID;
  QueryDelRechzahlweg.ExecSQL;
  QueryDelRechnung.ParamByName('ID').AsInteger := PRechID;
  QueryDelRechnung.ExecSQL;
  QueryDelRechnungsKonto.ParamByName('RechnungsID').AsInteger := PRechID;
  QueryDelRechnungsKonto.ExecSQL;
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

    TableKasseIT.Open;
    while not EOF do
    begin
      QuerySelectArtikel.ParamByName('pFirma').AsInteger := PGl.Firma;
      QuerySelectArtikel.ParamByName('pArtikelID').AsInteger :=
        FieldByName('ArtikelID').AsInteger;
      QuerySelectArtikel.Open;
      if (Trim(FieldByName('LeistungsText').AsString) = '') and
        (QuerySelectArtikel.RecordCount = 1) then
      begin
        TableKasseIT.Append;
        TableKasseIT.FieldByName('ID').AsInteger := FieldByName('RechnungsID')
          .AsInteger;
        TableKasseIT.FieldByName('Menge').AsInteger := FieldByName('Menge')
          .AsInteger;

        if PRabatt > 0 then
          TableKasseIT.FieldByName('Betrag').AsString :=
            Format('%.' + IntToStr(PGl.Nachkommastellen) + 'n',
            [FieldByName('Betrag').AsFloat - (FieldByName('Betrag').AsFloat *
            PRabatt / 100)])
        else
          TableKasseIT.FieldByName('Betrag').AsString :=
            FieldByName('Betrag').AsString;

        TableKasseIT.FieldByName('Data').AsString :=
          QuerySelectArtikel.FieldByName('Bezeichnung').AsString;
        TableKasseIT.FieldByName('TischNr').AsString :=
          TableOffeneTische.FieldByName('LookTischNr').AsString;
        TableKasseIT.FieldByName('Gruppe').AsInteger :=
          TableTisch.FieldByName('GruppeID').AsInteger;
        TableKasseIT.FieldByName('Kellner').AsString := GetWaiterName;
        TableArtikel.Open;
        TableHauptgruppe.Open;
        TableUntergruppe.Open;
        TableSteuer.Open;
        if TableUntergruppe.Locate('UntergruppeID',
          TableArtikel.FieldByName('UntergruppeID').AsInteger, []) and
          TableHauptgruppe.Locate('HauptgruppeID',
          TableUntergruppe.FieldByName('HauptgruppeID').AsInteger, []) and
          TableSteuer.Locate('ID', TableHauptgruppe.FieldByName('SteuerID')
          .AsInteger, []) then
        begin
          TableKasseIT.FieldByName('Abteilung').AsString :=
            TableSteuer.FieldByName('Mwst').AsString;
        end;

        TableKasseIT.Post;
      end;
      QuerySelectArtikel.Close;
      Next;
    end; // while
    // if not gl.IsDBF then
    begin
      TableKasseIT.Append;
      TableKasseIT.FieldByName('ID').AsInteger := FieldByName('RechnungsID')
        .AsInteger;
      TableKasseIT.FieldByName('Menge').AsInteger := 0;
      TableKasseIT.FieldByName('Betrag').AsString := '0';
      TableKasseIT.FieldByName('Data').AsString := ':END';
      TableKasseIT.FieldByName('TischNr').AsString :=
        TableOffeneTische.FieldByName('LookTischNr').AsString;
      TableKasseIT.FieldByName('Gruppe').AsInteger :=
        TableTisch.FieldByName('GruppeID').AsInteger;
      TableKasseIT.FieldByName('Kellner').AsString := GetWaiterName;
      TableKasseIT.Post;
    end;
    TableKasseIT.Close;
    Close;
  end; // with
end;

// ******************************************************************************
//
// ******************************************************************************
function TDataPos.GetPreisEbene: Integer;
var
  ADay: Integer;
  ATime: Real;
begin
  if FPreisebeneTisch <> 0 then
    Result := FPreisebeneTisch
  else
    Result := FKellnerPreisebene;

  if PGl.HappyHour and not((TableTisch.FieldByName('TischTyp').AsString = 'W')
    or (TableTisch.FieldByName('TischTyp').AsString = 'E') or
    (TableTisch.FieldByName('TischTyp').AsString = 'P') or
    (TableTisch.FieldByName('TischTyp').AsString = 'B')) then
    with QueryHappyHour do
    begin
      FHappyHourAn := False;
      Open;
      ADay := DayOfWeek(PGl.Datum) - 1;
      First;
      ATime := Time;
      if ATime > (1 - (1 / (24 * 60))) then
        ATime := 1 - (1 / (24 * 60));

      while not EOF do
      begin
        if (ATime <= FieldByName('UhrzeitBis').AsDateTime) and
          (ATime >= FieldByName('UhrzeitVon').AsDateTime) and
          (((ADay = FieldByName('WochenTag').AsInteger) and
          (FieldByName('WochenTag').Value <> NULL)) or
          (PGl.Datum = FieldByName('Datum').AsDateTime)) and
          ((FieldByName('TischgruppeID').AsInteger = 0) or
          (FieldByName('TischgruppeID').AsInteger = TableTisch.FieldByName
          ('GruppeID').AsInteger)) then
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
  if QueryHilfTischkonto.State <> DsInactive then
  begin
    QueryHilfTischkonto.Close;
  end;

  with QueryToTisch do
  begin
    SQL.Clear;
    SQL.Add('DELETE FROM Hilf_Tischkonto Where Firma = ' + IntToStr(PGl.Firma));
    SQL.Add(' and OffeneTischID = ' + TableOffeneTische.FieldByName
      ('OffeneTischID').AsString);
    ExecSQL;
  end;
  QueryHilfTischkonto.ParamByName('pOffeneTischID').Value :=
    TableOffeneTische.FieldByName('OffeneTischID').AsInteger;
  QueryHilfTischkonto.Open;

  // 18.12.2010 BW: also fetch new data from table HILF_TISCHKONTO into QueryHelpTableAccount
  with QueryHelpTableAccount do
  begin
    Close;
    ParamByName('pFirma').AsInteger := PGl.Firma;
    ParamByName('pOffeneTischID').Value := TableOffeneTische.FieldByName
      ('OffeneTischID').AsInteger;
    Open;
  end;

  // // 25.07.2010 BW: Delete CDSHilfKonto, except the optional parameter pDeleteCDS is given with false!!
  // if PDeleteCDS then
  // begin
  // CdsHilfKonto.Open;
  // CdsHilfKonto.EmptyDataSet;
  // end;
end;

// ******************************************************************************
//
// ******************************************************************************
procedure TDataPos.DeleteHilfTischkontoFromServer(PDeleteHilfTischkonto
  : Boolean);
begin
  with QueryFromTisch do
  begin
    QueryHilfTischkonto.Close;
    QueryHilfTischkonto.ParamByName('pOffeneTischID').Value :=
      TableOffeneTische.FieldByName('OffeneTischID').AsInteger;
    QueryHilfTischkonto.Open;
    QueryHilfTischkonto.First;
    SQL.Clear;
    SQL.Add('SELECT * FROM Tischkonto');
    SQL.Add('WHERE TischkontoID = :TischkontoID');
    UpdateOptions.RequestLive := True;
    Prepare;
    while not QueryHilfTischkonto.EOF do
    begin
      if QueryHilfTischkonto.FieldByName('Gedruckt').AsBoolean then
      begin
        // Zuerst vom Server löschen
        Close;
        ParamByName('TischKontoID').AsInteger :=
          QueryHilfTischkonto.FieldByName('TischkontoID').AsInteger;
        Open;
        if FieldByName('Menge').AsFloat > QueryHilfTischkonto.FieldByName
          ('Menge').AsFloat then
        begin
          Edit;
          FieldByName('Menge').AsFloat := FieldByName('Menge').AsFloat -
            QueryHilfTischkonto.FieldByName('Menge').AsFloat;
          if FieldByName('Firma').IsNull then
            FieldByName('Firma').AsInteger := PGl.Firma;

          if FieldByName('TischkontoID').IsNull then
            FieldByName('TischkontoID').AsInteger :=
              QueryHilfTischkonto.FieldByName('TischkontoID').AsInteger;

          Post;
          repeat
            QueryHilfTischkonto.Next;
          until not QueryHilfTischkonto.FieldByName('ArtikelID').IsNull or
            QueryHilfTischkonto.EOF;
        end
        else
        begin
          repeat
            Close;
            ParamByName('TischKontoID').AsInteger :=
              QueryHilfTischkonto.FieldByName('TischkontoID').AsInteger;
            Open;
            try
              Delete;
            except
              logger.Error(IntToStr(FSerialNumber) + ':' +
                IvDictio.Translate
                ('ACHTUNG: Artikel im Tischkonto nicht gefunden!'));
            end;
            QueryHilfTischkonto.Next;
          until not QueryHilfTischkonto.FieldByName('ArtikelID').IsNull or
            QueryHilfTischkonto.EOF;
        end;
      end
      else
      begin
        repeat
          QueryHilfTischkonto.Next;
        until not QueryHilfTischkonto.FieldByName('ArtikelID').IsNull or
          QueryHilfTischkonto.EOF;
      end;
    end; // while
    Close;
    UpdateOptions.RequestLive := False;
    Unprepare;
    if PDeleteHilfTischkonto then
      DeleteHilfTischkonto;
  end; // with
end;

// ******************************************************************************
// Liefert ALLE oder Belegte Tische in der QueryTisch zurück
// ******************************************************************************
procedure TDataPos.GetTische(PTischart: TTischTyp; PTischTyp: string;
  PSplitTischID, PRevierID: Integer; PTableSearchString: string);
var
  ATischID: string;
  ADescription: string;
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
  // 31.08.2010 BW: obsolete, because pgl.datum is now a property read GetDate
  // gl.GetDate;

  if PGl.FelixHotelFirma > 0 then
    // 05.01.2015 KL: Kroneck hat Version von Kurts PC
    AFirma := PGl.FelixHotelFirma
  else
    AFirma := PGl.Firma;

  with QueryTische do
  begin
    Close;
    if (PTischart = TT_AlleGaeste) then
    begin
      if PGl.HotelProgrammTyp = HpHotelFelix then
      begin
        QueryTische.Connection := ConnectionFelix;
        SQL.Clear;
        SQL.Add('SELECT Distinct(R.ZimmerID) AS ZimmerID, SubString(R.Gastname from 1 for 18) AS TischNR, R.ID AS TischID');
        SQL.Add('FROM Reservierung r, Zimmer z');
        SQL.Add('WHERE R.CheckIn = ''T'' AND R.Firma = ' + IntToStr(AFirma));
        // 05.01.2015 KL: war vorher:  = 1');
        SQL.Add('AND R.ZimmerID = ' + ATischID);
      end
      else if PGl.HotelProgrammTyp = HpAllgemeinSQL then
      begin
        QueryTische.Connection := DBase.ConnectionZEN;
        SQL.Clear;
        SQL.Add('SELECT Distinct(ZI_Nummer) AS ZimmerID, Substring(ZI_Pers from 1 for 18) AS TischNR,');
        SQL.Add('Termin_Nr AS TischID, Pers_NR as gastadresseid, Zi_Pers as Gastname');
        SQL.Add('FROM GastInfo');
        SQL.Add('Where ZI_Nummer = ''' + ATischID + '''');
      end
    end

    else if (PTischart = TT_FelixZimmer) then
    begin
      if PGl.HotelProgrammTyp = HpHotelFelix then
      begin
        QueryTische.Connection := ConnectionFelix;
        SQL.Clear;
        SQL.Add('SELECT Distinct(ZimmerID) AS TischID, r.ID AS OffeneTischID, ');
        SQL.Add('z.ZimmerNr AS TischNr ');
        SQL.Add('FROM Reservierung r, Zimmer z');
        SQL.Add('WHERE r.CheckIn = ''T'' AND r.Firma = ' + IntToStr(AFirma));
        // 05.01.2015 KL: war vorher:  + IntToStr(gl.Firma));
        SQL.Add('AND r.ZimmerID = z.ID AND r.Firma = z.Firma');
        SQL.Add('AND (r.SperrenExtra = ''F'' OR r.SperrenExtra IS NULL)');
      end

      else if PGl.HotelProgrammTyp = HpAllgemeinSQL then
      begin
        QueryTische.Connection := DBase.ConnectionZEN;
        SQL.Clear;
        // 16.08.2010 BW: delete query fields ZI_Pers AS Bezeichnung, Pers_NR as gastadresseid
        // and add a distinct
        SQL.Add('SELECT Distinct(ZI_Nummer) AS TischID,');
        SQL.Add('Termin_Nr AS OffeneTischID,');
        SQL.Add('ZI_Nummer AS TischNr, 0 AS Farbe, ');
        SQL.Add('1 As Firma');
        SQL.Add('FROM GastInfo');
        SQL.Add('Order By TischNr');
        UpdateOptions.RequestLive := False;
      end
    end

    else if (PTischart = TT_ZimmerIntern) and
      (PGl.HotelProgrammTyp = HpHotelFelix) then
    begin
      QueryTische.Connection := ConnectionFelix;
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
      QueryTische.Connection := DBase.ConnectionZEN;
      SQL.Clear;
      if (not(PRevierID = 0) and not(PTischart = TT_Split)) and (PTischTyp = '')
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

      if (PTischart = TT_Alle) then
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
          else if FKellnerWerbung and (PTischTyp = 'W') then
            SQL.Add('WHERE (t.TischTyp = ''W'')')
          else if FKellnerEigenbedarf and (PTischTyp = 'E') then
            SQL.Add('WHERE (t.TischTyp = ''E'')')
          else if FKellnerPersonal and (PTischTyp = 'P') then
            SQL.Add('WHERE (t.TischTyp = ''P'')')
          else if FKellnerBruch and (PTischTyp = 'B') then
            SQL.Add('WHERE (t.TischTyp = ''B'')')
          else if FKellnerLagerAnzeigen and (PTischTyp = 'L') then
          begin
            SQL.Add('WHERE (t.TischTyp = ''L'')');
            SQL.Add('AND t.TischID = ' + IntToStr(FKellnerLagertisch))
          end
          else if ((PTischTyp = 'G') and FKellnerStammgaeste) or
            (PTischTyp = 'S') or (PTischTyp = 'Z') then
            SQL.Add('WHERE (t.TischTyp = ''' + PTischTyp + ''')')
          else // nichts anzeigen - unbekannter Tischtyp
            SQL.Add('WHERE (t.TischTyp = ''X'')');
          // der folgende Filter gilt für alle Tischtypen!
          SQL.Add('      AND (t.ObertischID IS NULL)');
          SQL.Add('      AND ((t.Inaktiv IS NULL) or (t.Inaktiv=''F''))');
          // 07.08.2013 KL: #5698
        end
      end

      else if PTischart = TT_Split then
      begin
        FIsSplit := True;
        SQL.Add('WHERE ((t.obertischid = ' + ATischID + ') or (t.TischID = ' +
          ATischID);
        SQL.Add(' and (t.obertischid is null))) ');
        SQL.Add(' AND ((t.Inaktiv IS NULL) or (t.Inaktiv=''F''))');
        // 07.08.2013 KL: #5698
        SQL.Add(' and not (t.TischID in');
        SQL.Add('(SELECT tisch.TischID FROM Tisch, offenetische ot');
        SQL.Add('WHERE ot.tischid = tisch.tischid AND ot.offen = ''T''');
        SQL.Add('AND tisch.Firma = ot.Firma');
        SQL.Add('AND ot.datum = ''' + DateToStr(PGl.Datum) + '''');
        SQL.Add('AND ((tisch.ObertischID = ' + ATischID + ')');
        SQL.Add('OR ((tisch.tischID = ' + ATischID +
          ') AND (tisch.ObertischID IS NULL)))))');
      end

      else if PTischart = TT_SplitOffen then
      begin
        FIsSplit := True;
        SQL.Add(', offenetische ot');
        SQL.Add('WHERE ot.tischid = t.tischid AND offen = ''T''');
        SQL.Add('AND t.Firma = ot.Firma');
        SQL.Add('AND ot.datum = ''' + DateToStr(PGl.Datum) + '''');
        SQL.Add('AND ((t.ObertischID = ''' + ATischID + ''')');
        SQL.Add('     OR ((t.tischID = ''' + ATischID +
          ''') AND (t.ObertischID IS NULL)))');
      end

      else if PTischart = TT_Belegt then
      begin
        SQL.Add('INNER JOIN OffeneTische OT');
        SQL.Add('ON (T.TischID = OT.TischID)');

        if (PTischTyp = 'G') then
          SQL.Add('WHERE (t.TischTyp = ''' + PTischTyp + ''') ')
        else // nichts anzeigen - unbekannter Tischtyp
          SQL.Add('WHERE (t.TischTyp = ''' + PTischTyp +
            ''' or t.TischTyp IS NULL) ');

        SQL.Add('AND (OT.Offen = ''T'')');
        if ((PTischTyp <> 'G') and (PTischTyp <> 'S')) then
          SQL.Add('AND (OT.Datum = ''' + DateToStr(PGl.Datum) + ''')');

        if (PGl.TischNurKellner) and not FKellnerIsChef then
        begin
          SQL.Add('AND ((OT.KellnerID = ' + IntToStr(FWaiterID) + ')');
          // Smart Order tables do have waiter id = -2
          SQL.Add('     OR (OT.KellnerID = -2))');
        end;

      end

      else if PTischart = TT_Offen then
      begin
        SQL.Add('Where not (T.TischID in (Select Ot.TischID from offeneTische OT');

        if (PTischTyp = 'G') or (PTischTyp = 'S') then
          SQL.Add('Where (Ot.Offen = ''T''))) and')
        else
          SQL.Add('Where (OT.Offen = ''T'' and OT.Datum = ''' +
            DateToStr(PGl.Datum) + '''))) and');

        if (PTischTyp = 'G') then
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
          UpperCase(PTableSearchString) + ''')');
        // check if table type is regualar guests --> add a further OR clause,
        // because regualar guests have there names in field 'Bezeichnung' and this should also be searched
        if PTischTyp = 'G' then
        begin
          // 10.11.2010 BW: check if search string is only one character
          if Length(PTableSearchString) = 1 then
            // only one character --> get only regular guests that START with this character
            SQL.Add('OR (UPPER(t.Bezeichnung) LIKE ''' +
              UpperCase(PTableSearchString) + '%'')')
          else
            // more than one character --> make normal full context search
            SQL.Add('OR (UPPER(t.Bezeichnung) LIKE ''%' +
              UpperCase(PTableSearchString) + '%'')');
        end;
        SQL.Add(')');
      end;
      // 25.08.2010 BW: reset the table search string
      FTableSearchString := '';

      // Nur wenn es auch Reviere gibt
      if (not(PRevierID = 0) and not(PTischart = TT_Split)) and (PTischTyp = '')
      then
      begin
        SQL.Add('and RG.RevierID = ' + IntToStr(PRevierID));
        SQL.Add('ORDER BY RG.Reihung, T.TischID')
      end
      else
      begin
        if PGl.StammgastSortieren and (PTischTyp = 'G') then
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
function TDataPos.GetGastname(PZimmerNr: string): string;
begin
  Result := PZimmerNr;
  with QueryTische do
    try
      Close;
      QueryTische.Connection := ConnectionFelix;
      SQL.Clear;
      SQL.Add('SELECT r.Gastname FROM Reservierung r, Zimmer z');
      SQL.Add('WHERE r.CheckIn = ''T'' AND r.Firma = ' + IntToStr(PGl.Firma));
      SQL.Add('AND r.ZimmerID = z.ID AND r.Firma = z.Firma');
      SQL.Add('AND (r.SperrenExtra = ''F'' OR r.SperrenExtra IS NULL)');
      SQL.Add('AND z.ZimmerNr = ''' + PZimmerNr + ''' ');
      Open;
      if RecordCount > 0 then
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
  var PErrorMessage: string): Boolean;
var
  ALagertisch, ATischTyp: string;
  ALagerTischID, ATischID: Integer;
begin
  Result := False;
  PErrorMessage := '';
  FPreisebeneTisch := 0;
  FPreisEbene := 1;

  TableTisch.Close;
  TableTisch.Open;

  if not TableTisch.Locate('Firma;TischID', VarArrayOf([PGl.Firma, PTischID]
    ), []) then
  begin
    PErrorMessage := Translate('Tisch mit der ID') + ' ' + IntToStr(PTischID) +
      ' ' + Translate('nicht gefunden!');
    Exit;
  end;

  if not KellnerIsChef and not TableTisch.FieldByName('KellnerID').IsNull and
    (TableTisch.FieldByName('KellnerID').AsInteger <> FWaiterID) then
  begin
    PErrorMessage := Translate('Falscher Kellner fuer Kellnertisch') + ' ' +
      IntToStr(PTischID);
    Exit;
  end;

  ALagerTischID := FKasseID; // gl.KasseID;
  FTischpax := TableTisch.FieldByName('Pax').AsInteger;
  ATischID := TableTisch.FieldByName('TischID').AsInteger;

  if PGl.MehrereLagerJeKellner and (PGl.KasseID > 100) then
  // ACHTUNG FKasseID;//gl.KasseID;
  begin
    if (not TableTisch.FieldByName('GruppeID').IsNull) and
    // 23.03.2012 KL: check to NULL
      (TableTisch.FieldByName('GruppeID').AsInteger <> 0) then
    begin
      TableTischgruppe.Close; // 23.03.2012 KL: close before open
      TableTischgruppe.Open;
      if TableTischgruppe.Locate('TischgruppeID',
        TableTisch.FieldByName('GruppeID').AsInteger, []) then
      begin
        ALagertisch := 'L' + TableTischgruppe.FieldByName('SchankID').AsString;
        if not TableTisch.Locate('TischNr;TischTyp',
          VarArrayOf([ALagertisch, 'L']), []) then
          PErrorMessage := IvDictio.Translate('Lagertisch falsch definiert!') +
            ' ' + ALagertisch;
        ALagerTischID := TableTischgruppe.FieldByName('SchankID').AsInteger;
        TableTisch.Locate('Firma;TischID',
          VarArrayOf([PGl.Firma, ATischID]), []);
      end
      else
      begin
        TableKellner.Close; // 23.03.2012 KL: close before open
        TableKellner.Open;
        if TableKellner.Locate('Firma;KellnerID',
          VarArrayOf([PGl.Firma, FWaiterID]), []) then
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
  UOpenLagerTische(FWaiterID, FKasseID, ALagerTischID);

  ATischTyp := Trim(TableTisch.FieldByName('TischTyp').AsString);

  // check if there is already an open table for this table
  if LocateOffenenTisch(ATischTyp, PTischID) then
  begin
    // if yes --> set Query TableOffeneTische to this table (former locate)
    if PGl.TischNurKellner and
      (FWaiterID <> TableOffeneTische.FieldByName('KellnerID').AsInteger) and
      (ATischTyp = '') and not FKellnerIsChef
    // Smart Order tables do have waiter id = -2
      and (TableOffeneTische.FieldByName('KellnerID').AsInteger > 0) then
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
      SQL.Clear;
      SQL.Text :=
        'INSERT INTO OffeneTische (Firma, TischID, Bezeichnung, GastadresseID, Offen, Datum, Beginn, KellnerID) VALUES (:Firma, :TischID, :Bezeichnung, :GastadresseID, :Offen, :Datum, :Beginn, :KellnerID)';
      ParamByName('Firma').AsInteger := PGl.Firma;
      ParamByName('TischID').AsInteger := PTischID;
      ParamByName('Bezeichnung').AsString :=
        TableTisch.FieldByName('Bezeichnung').AsString;
      ParamByName('GastadresseID').AsInteger :=
        TableTisch.FieldByName('TischgruppeID').AsInteger;
      ParamByName('Offen').AsString := 'T';
      ParamByName('Datum').AsDateTime := PGl.Datum;
      ParamByName('Beginn').AsDateTime := PGl.Datum + Time;
      ParamByName('KellnerID').AsInteger := FWaiterID;
      ExecSQL;
    end;
    // 14.12.2010 BW: senseless because of exchange table/locate with query/params
    // TableOffeneTische.Refresh;

    // set Query TableOffeneTische to this table (former locate)
    if not LocateOffenenTisch(ATischTyp, PTischID) then
    begin
      PErrorMessage := Translate('Kein offener Tisch zu ID') + ' ' +
        IntToStr(PTischID);
      Exit;
    end;
  end;

  // lock table
  if not LockTisch(TableOffeneTische.FieldByName('OffeneTischID').AsInteger)
  then
  begin
    PErrorMessage := Translate('Tisch bereits geoeffnet von ') +
      GetWaiterNamebyWaiterID(TableOffeneTische.FieldByName('CurrentWaiterID')
      .AsInteger);
    Exit;
  end;

  if TableTisch.FieldByName('tischTyp').AsString = 'P' then
    FPreisebeneTisch := 99
  else
    FPreisebeneTisch := TableTisch.FieldByName('Preisebene').AsInteger;
  FPreisEbene := GetPreisEbene;

  Result := True;
end;

// ******************************************************************************
//
// ******************************************************************************
procedure TDataPos.CheckRoomDiscount;
var
  ARabatt: Single;
  ABetrag: Double;
  // aTiKoID: Integer;
begin
  QueryGetRabatt.ParamByName('pPers_Nr').AsInteger :=
    QueryTische.FieldByName('GastAdresseID').AsInteger;
  QueryGetRabatt.Open;
  // 16.08.2010 BW: if db field RT is NULL --> set aRabatt 0 and therefore do nothing!
  if QueryGetRabatt.FieldByName('RT').IsNull then
    ARabatt := 0
  else
    ARabatt := QueryGetRabatt.FieldByName('RT').AsFloat;
  QueryGetRabatt.Close;
  if ARabatt <> 0 then
    with QueryRoomDiscount do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT Firma, ArtikelID, Betrag, SUM(Menge) AS Menge, OffeneTischID');
      SQL.Add('FROM Hilf_Tischkonto');
      SQL.Add('WHERE OffeneTischID = ' + TableOffeneTische.FieldByName
        ('OffeneTischID').AsString + ' AND Firma = ' + IntToStr(PGl.Firma));
      SQL.Add('AND Betrag <> 0');
      SQL.Add('GROUP BY Firma, ArtikelID, Betrag, OffeneTischID');
      Open;
      QueryHilfTischkonto.Open;
      QueryHilfTischkonto.Last;
      // aTiKoID := TableHilf_Tischkonto.FieldByName('TischkontoID').AsInteger;
      while not EOF do
      begin
        QueryGetHaupgruppeVorSum.Close;
        QueryGetHaupgruppeVorSum.ParamByName('ArtikelID').AsInteger :=
          FieldByName('ArtikelID').AsInteger;
        QueryGetHaupgruppeVorSum.Open;
        if QueryGetHaupgruppeVorSum.FieldByName('VorSum').IsNull then
        begin
          ABetrag := Round(FieldByName('Betrag').AsFloat * ARabatt) / 100;
          WriteToJournalControl(IvDictio.Translate('Rabatt'), NULL,
            -FieldByName('Menge').AsInteger, FieldByName('ArtikelID').AsInteger,
            NULL, 1, TableOffeneTische.FieldByName('OffeneTischID').AsInteger,
            ABetrag, NULL, NULL, NULL, FWaiterID);
          // inc(aTiKoID);
          QueryHilfTischkonto.Append;
          QueryHilfTischkonto.FieldByName('I_DeviceGuid').AsString := '';
          QueryHilfTischkonto.FieldByName('Firma').AsInteger := 1;
          QueryHilfTischkonto.FieldByName('OffeneTischID').AsInteger :=
            TableOffeneTische.FieldByName('OffeneTischID').AsInteger;
          // DataTische.TableHilf_Tischkonto.FieldByName('TischkontoID').AsInteger := aTikoID;
          // DataTische.TableHilf_Tischkonto.FieldByName('Datum').AsDateTime := gl.Datum;
          QueryHilfTischkonto.FieldByName('ArtikelID').AsInteger :=
            FieldByName('ArtikelID').AsInteger;
          QueryHilfTischkonto.FieldByName('Menge').AsInteger :=
            -FieldByName('Menge').AsInteger;
          QueryHilfTischkonto.FieldByName('Betrag').AsFloat := ABetrag;
          QueryHilfTischkonto.FieldByName('Gedruckt').AsBoolean := True;
          QueryHilfTischkonto.FieldByName('Verbucht').AsBoolean := True;
          QueryHilfTischkonto.FieldByName('KellnerID').AsInteger := FWaiterID;
          QueryHilfTischkonto.FieldByName('Datum').AsDateTime := PGl.Datum;
          QueryHilfTischkonto.Post;
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
procedure TDataPos.WriteToJournalControl(PText: string;
  PZahlwegID, PMenge, PArtikelID, PBeilagenID, PJournalTyp, POffeneTischID
  : Variant; PBetrag: Double; PVonOffeneTischID, PRechnungsID,
  PNachlass: Variant; PKellnerID: Integer);
begin
  try
    with QueryJournalControl do
    begin
      ParamByName('Firma').AsInteger := PGl.Firma;
      ParamByName('KellnerID').AsInteger := PKellnerID;
      ParamByName('OffeneTischID').Value := POffeneTischID;
      ParamByName('Datum').AsDateTime := PGl.Datum;
      ParamByName('Zeit').AsDateTime := Time;
      ParamByName('KasseID').AsInteger := PGl.KasseID;
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
      ParamByName('LagerDatum').AsDateTime := PGl.Datum;
      Prepare;
      ExecSQL;
    end;
  except
    on E: Exception do
      logger.Error('TDataPos.WriteToJournalControl', IntToStr(FSerialNumber) +
        ':' + Translate('129: Fehler in WriteTojournalControl'),
        NXLCAT_NONE, E);
  end;

end;

// ******************************************************************************
// Teilumbuchen auf Zimmer
// ******************************************************************************
function TDataPos.ZimmerTeilUmbuchen(PReservID, PDruckerID,
  PAnzahl: Integer): Boolean;
var
  ATischID, ZuTischID, AFirma: Integer;
  ATischTyp, AzuTischTyp, AVonTisch, ANachTisch, ATischNr, AGastadresseID,
    AGastname, AUmbuchungstext: string;
begin
  Result := False;
  ZuTischID := -1;
  AGastadresseID := '';
  AGastname := '';

  if (PGl.HotelProgrammTyp = HpHotelFelix) then
  begin
    if PGl.FelixHotelFirma > 0 then
      AFirma := PGl.FelixHotelFirma
    else
      AFirma := PGl.Firma;

    if not CheckReservId(AFirma, PReservID) then
    begin
      logger.info(IntToStr(FSerialNumber) + ':' +
        IvDictio.Translate
        ('Gesamtumbuchen - Reservierung nicht gefunden - ID: ') +
        IntToStr(PReservID));
      Exit;
    end
    else
    begin
      ZuTischID := QueryReservFELIX.FieldByName('ZimmerID').AsInteger;
      AGastname := QueryReservFELIX.FieldByName('GastName').AsString;
    end;

    TableZimmerFELIX.Open;
    if not TableZimmerFELIX.Locate('Firma;ID', VarArrayOf([AFirma, ZuTischID]
      ), []) then
    begin
      logger.info(IntToStr(FSerialNumber) + ':' +
        IvDictio.Translate('Gesamtumbuchen - zuTisch nicht gefunden - ID: ') +
        IntToStr(ZuTischID));
      Exit;
    end
    else
      AzuTischTyp := Trim(TableTisch.FieldByName('TischTyp').AsString);

    if (PGl.HotelProgrammTyp = HpHotelFelix) then
      ATischNr := Trim(TableZimmerFELIX.FieldByName('ZimmerNr').AsString)
    else
      ATischNr := Trim(QueryTische.FieldByName('ZimmerID').AsString);

    ATischID := TableTisch.FieldByName('TischID').AsInteger;
    TableZimmerFELIX.Close;
  end
  else
  begin
    if QueryTische.EOF then
      QueryTische.Prior;

    AzuTischTyp := Trim(TableTisch.FieldByName('TischTyp').AsString);
    ATischNr := Trim(QueryTische.FieldByName('ZimmerID').AsString);
    ATischID := TableTisch.FieldByName('TischID').AsInteger;
    AGastadresseID := Trim(QueryTische.FieldByName('GastAdresseID').AsString);
    AGastname := Trim(QueryTische.FieldByName('Gastname').AsString);
  end;

  if not TableTisch.Locate('Firma;TischID', VarArrayOf([PGl.Firma, ATischID]
    ), []) then
  begin
    logger.info(IntToStr(FSerialNumber) + ':' +
      Translate('ZimmerTeilumbuchen - vonTisch zu ID nicht gefunden ') +
      IntToStr(ATischID));
    Exit;
  end;

  ATischTyp := Trim(TableTisch.FieldByName('TischTyp').AsString);
  if not LocateOffenenTisch(ATischTyp, ATischID) then
  begin
    logger.info(IntToStr(FSerialNumber) + ':' +
      Translate('Teilumbuchen - offenen Tisch nicht gefunden ID: ') +
      IntToStr(ATischID));
    Exit;
  end;

  ANachTisch := Translate('Hotel: ') + ATischNr + TrimRight(' ' + AGastname);
  if Trim(TableOffeneTische.FieldByName('LookTischNr').AsString) <>
    Trim(TableOffeneTische.FieldByName('Bezeichnung').AsString) then
    AVonTisch := Trim(TableOffeneTische.FieldByName('LookTischNr').AsString) +
      ' - ' + Trim(TableOffeneTische.FieldByName('Bezeichnung').AsString)
  else
    AVonTisch := Trim(TableOffeneTische.FieldByName('Bezeichnung').AsString);

  // Überprüfen, ob Tisch vorhanden ist
  TableTisch.Locate('Firma;TischID', VarArrayOf([PGl.Firma, ATischID]), []);
  ATischTyp := Trim(TableTisch.FieldByName('TischTyp').AsString);
  if not LocateOffenenTisch(ATischTyp, ATischID) then
    logger.info(IntToStr(FSerialNumber) + ':' +
      Translate('Teilumbuchen - offenen Tisch nicht gefunden ID: ') +
      IntToStr(ATischID))
  else
    logger.info(IntToStr(FSerialNumber) + ':' +
      Format(Translate('Teilumbuchen von Tisch %s nach Zimmer %s'),
      [IntToStr(ATischID), IntToStr(ZuTischID)]));

  { for i := 0 to RecordCount - 1 do
    begin
    aTischKontoID := getStrToInt(copy(aStr, i*recordlength + 1, 10));
    DataTische.IsnertHilfkontoToTischkonto(aTischkontoID,
    Translate('Teilumbuchen - TischkontoID nicht gefunden ID: '));
    end; }
  if (PGl.HotelProgrammTyp = HpAllgemeinSQL) then
    CheckRoomDiscount;

  // 09.02.2015 KL: #7759: pLoginKellner setzen, damit er richtig am Umbuchungsbon steht.
  // DoSetPrintpackage(Getorderman(FSerialNumber).FDataBase.FWaiterID, FKasseID);
  UOpenLagerTische(FWaiterID, FKasseID, 0);

  // 11.10.2010 BW: do not print bon if printerid = 0 ('kein Druck')!
  // 10.11.2015 KL: beim Umbuchen auf Zimmer IMMER Bon Drucken!
  if (PGl.DruckeUmbuchungsBon and (PDruckerID <> 0)) or
    ((PAnzahl > 0) and (PDruckerID <> 0)) or
    ((AzuTischTyp <> '') and (AzuTischTyp[1] in ['W', 'E', 'P', 'B'])) then
  begin
    pgl.BonNr := UmbuchungsBon.BonNummerDefinieren;
    PrintSlip(TableOffeneTische.FieldByName('OffeneTischID').AsInteger,
      PkTransferPartial, PAnzahl, PGl.Datum, AVonTisch, ANachTisch, PDruckerID,
      True, PGl.SpracheID, 0);
  end;

  AUmbuchungstext := IntToStr(PGl.BonNr) + Translate(' Hotel: ') + ATischNr +
    Iif(LowerCase(ExtractFileName(ParamStr(0))) = 'ordermanserver.exe',
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

      if PGl.HotelProgrammTyp = HpAllgemeinSQL then
      // Firebird Allgemein SQL = 3
      begin
        SQL.Add('SELECT Termin_Nr AS ID, zi_pers AS Gastname, Pers_Nr as GastadresseID, RT AS ZimmerID');
        SQL.Add('  FROM Gastinfo ');
        SQL.Add(' WHERE zi_nummer = :ZimmerID ');
      end
      else if PGl.HotelProgrammTyp = HpHotelFelix then // Hotel Felix = 4
      begin
        SQL.Add(' SELECT r.ID, r.Gastname, r.GastadresseID, r.ZimmerID ');
        SQL.Add('   FROM Reservierung r ');
        SQL.Add('  WHERE (r.CheckIn = ''T'') ');
        SQL.Add('    AND (r.SperrenExtra = ''F'' OR r.SperrenExtra IS NULL) ');
        if PGl.FelixHotelFirma > 0 then
          SQL.Add('  AND (r.Firma = ' + IntToStr(PGl.FelixHotelFirma) + ') ');
        SQL.Add('    AND (r.ZimmerID = :ZimmerID) ');
      end
      else // weder noch
      begin
        logger.info(IntToStr(FSerialNumber) + ':' +
          IvDictio.Translate('HotelProgrammTyp falsch in CheckZimmer: ') +
          IntToStr(Ord(PGl.HotelProgrammTyp)));
        Exit;
      end;

      ParamByName('ZimmerID').AsInteger := PZimmerID;
      Open;
      if RecordCount > 0 then
        Result := FieldByName('ID').AsInteger;
    except
      on E: Exception do
        logger.Error('TDataPos.CheckZimmer', IntToStr(FSerialNumber) + ': ' +
          IvDictio.Translate('Fehler in CheckZimmer'), NXLCAT_NONE, E);
    end;
end;

// ******************************************************************************
// ReservID zu ZimmerNR holen
// bei STRING wird ein JOIN auf Tabelle ZIMMER gemacht!
// ******************************************************************************
function TDataPos.CheckZimmer(PZimmerNr: string): Integer;
begin
  Result := 0;

  with QueryCheckZimmerIB do
    try
      Close;
      SQL.Clear;

      if PGl.HotelProgrammTyp = HpAllgemeinSQL then
      // Firebird Allgemein SQL = 3
      begin
        SQL.Add('SELECT Termin_Nr AS ID, zi_pers AS Gastname, Pers_Nr as GastadresseID, RT AS ZimmerID ');
        SQL.Add('  FROM Gastinfo ');
        SQL.Add(' WHERE zi_nummer = ''' + PZimmerNr + ''' ');
      end
      else if PGl.HotelProgrammTyp = HpHotelFelix then // Hotel Felix = 4
      begin
        SQL.Add(' SELECT r.ID, r.Gastname, r.GastadresseID, r.ZimmerID ');
        SQL.Add('   FROM Reservierung r ');
        SQL.Add('  INNER JOIN Zimmer z ON (r.FIRMA = z.FIRMA) and (r.ZIMMERID = z.ID) ');
        SQL.Add('  WHERE (r.CheckIn = ''T'') ');
        SQL.Add('    AND (r.SperrenExtra = ''F'' OR r.SperrenExtra IS NULL) ');
        if PGl.FelixHotelFirma > 0 then
          SQL.Add('  AND (r.Firma = ' + IntToStr(PGl.FelixHotelFirma) + ') ');
        SQL.Add('    AND (z.ZimmerNr = ''' + PZimmerNr + ''') ');
      end
      else // weder noch
      begin
        logger.info(IntToStr(FSerialNumber) + ': ' +
          IvDictio.Translate('HotelProgrammTyp falsch in CheckZimmer: ') +
          IntToStr(Ord(PGl.HotelProgrammTyp)));
        Exit;
      end;

      Open;
      if RecordCount > 0 then
        Result := FieldByName('ID').AsInteger;
    except
      on E: Exception do
        logger.Error('TDataPos.CheckZimmer', IntToStr(FSerialNumber) + ': ' +
          IvDictio.Translate('Fehler in CheckZimmer: '), NXLCAT_NONE, E);
    end;

end;

// *****************************************************************************
// Italien hat eigenen Hotelanschluss
// *****************************************************************************
procedure TDataPos.WriteToKassInfo(PTischNr: string; PReservID: string;
  PBetrag: Double; PMehrwertsteuer, PLeistungsID: Integer; PText: string;
  PHauptGruppeID, PArtikelID: Integer; PMenge: Integer; PZimmerNr: string);
var
  AReservID, AWriteReservID: string;
  I: Integer;
begin
  with TableKassinfo do
  begin
    TableGastinfo.Open;
    AReservID := PReservID;
    // Wurde für Phönix wieder reingegeben
    for I := Length(AReservID) to 5 do // Iterate
    begin
      AReservID := '0' + AReservID;
    end; // for
    if TableGastinfo.Locate('Termin_NR;Zi_Nummer',
      VarArrayOf([AReservID, PZimmerNr]), []) then
    begin
      AWriteReservID := AReservID;
      // oder nach normaler ReservID
    end
    else if TableGastinfo.Locate('Termin_NR;Zi_Nummer',
      VarArrayOf([PReservID, PZimmerNr]), []) then
    begin
      AWriteReservID := PReservID;
    end
    else
      logger.info(IntToStr(FSerialNumber) + ': ' +
        IvDictio.Translate('14563: Reservierung nicht gefunden!'));
    Open;
    Append;
    if PGl.HotelProgrammTyp = HpAllgemeinSQL then
      FieldByName('ID').AsInteger := PDataDrucken.GetNextGENID
        ('KassInfo', True);

    QueryGetLeistung.Open;
    if not QueryGetLeistung.Locate('ID', PLeistungsID, []) then
      logger.info(IntToStr(FSerialNumber) + ': ' +
        Format(IvDictio.Translate
        ('Umbuchen Hotelprogramm: Leistung %s nicht gefunden'),
        [IntToStr(PLeistungsID)]));
    if PGl.HotelEinzelnBuchen then
      FieldByName('KurzBez').AsString := Copy(pText, 1, 20)
    else
      FieldByName('KurzBez').AsString :=
        Copy(QueryGetLeistung.FieldByName('LeistungsBezeichnung').AsString, 1, 14);
    FieldByName('Anzahl').AsFloat := PMenge;
    FieldByName('Preis').AsFloat := PBetrag;
    FieldByName('Summe').AsFloat := PBetrag * PMenge;
    FieldByName('Steuer').AsInteger := PMehrwertsteuer;
    // TableLeistung.FieldByName('Mwst').AsInteger;
    FieldByName('Datum').AsDateTime := Date;
    try
      FieldByName('Log_T').AsString := IntToStr(PGl.BonNr);
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
procedure TDataPos.WriteToGastkonto(PTischNr: string; PReservID: Integer;
  PDatum: TDateTime; PTime: TTime; PBetrag: Double; PMehrwertsteuer: Integer;
  PText: string; PMenge: Integer; PHauptgruppe, PGastadresseID, PZimmer: string;
  PArtikelID: Integer);
var
  PfelixDate: TDateTime;
  PLeistungsID, AKasseID, AFirma: Integer;
  PLeistungsText: string;

begin
  if PGl.FelixHotelFirma > 0 then
    AFirma := PGl.FelixHotelFirma
  else
    AFirma := PGl.Firma;

  PLeistungsID := 0;
  AKasseID := 1;
  try
    if PGl.FelixNachKassen then
    begin
      AKasseID := PGl.KasseID;
      if TableTisch.Locate('TischNr', PTischNr, []) then
        if TableTisch.FieldByName('GruppeID').AsInteger <> 0 then
        begin
          TableTischgruppe.Open;
          if TableTischgruppe.Locate('TischgruppeID',
            TableTisch.FieldByName('GruppeID').AsInteger, []) then
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
    if PGl.HotelProgrammTyp = HpAllgemeinSQL then
    begin
      // Die Leistungsnummer bekommt man über die Tischnummer (Tabelle
      // Tischzuordnung)
      with QueryGetLeistungsID do
      begin
        Close;
        if PGl.FelixNachKassen then
          ParamByName('TischNr').AsInteger := PGl.KasseID
        else
          ParamByName('TischNr').AsInteger := StrToIntDef(PTischNr, 0);
        Open;
        PLeistungsID := 0;
        if not IsEmpty then
        begin
          QueryGetLeistung.Open;
          if PMehrwertsteuer = 0 then
            PLeistungsID := FieldByName('LeistungsID').AsInteger
          else
          begin
            First;
            while not EOF do
            begin
              if QueryGetLeistung.Locate('Firma;ID',
                VarArrayOf([PGl.Firma, FieldByName('LeistungsID').AsInteger]
                ), []) then
              begin
                if (Round(pMehrwertsteuer*100)/100 = Round(QueryGetLeistung.FieldByName('MwSt').AsFloat*100)/100) then
                 PLeistungsID := FieldByName('LeistungsID').AsInteger;
              end;
              Next;
            end;
          end;
          if PLeistungsID = 0 then
          begin
            PLeistungsID := FieldByName('LeistungsID').AsInteger;
            logger.info(Format(IvDictio.Translate(
              'Schreiben auf Gast: Der MWSt "%s Prozent" ist keine Leistung zugeordnet!%sTabellen: %s, Feld: %s'),
              [FloatToStr(pMehrwertsteuer), sLineBreak,
              '(KASSE-DB) TISCHZUORDNUNG --> LEISTUNGEN --> STEUER', 'MWST']));
          end;
        end
        else
        begin
          logger.info(IntToStr(FSerialNumber) + ': ' +
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
    if PGl.HotelProgrammTyp = HpAllgemeinSQL then
    begin
      // procedure WriteToKassInfo(pTischNr: string; pReservID: String;
      // pBetrag: double; pMehrwertsteuer, pLeistungsID: Integer;
      // pText: String; pHauptGruppeID, pArtikelID: Integer;
      // pMenge: Integer; pZimmerNr: String);
      WriteToKassInfo(PTischNr, IntToStr(PReservID), PBetrag, PMehrwertsteuer,
        PLeistungsID, PText, StrToInt(PHauptgruppe), PArtikelID,
        PMenge, PZimmer);
    end
    else if PGl.HotelProgrammTyp = HpHotelFelix then
    begin
      with TableDiverses do
      begin
        Open;
        if Locate('Firma', AFirma, []) then
          PfelixDate := FieldByName('FelixDate').AsDateTime
        else
        begin
          logger.info(IntToStr(FSerialNumber) + ': ' +
            Format(IvDictio.Translate
            ('Schreiben auf Gast: Die Firma %s ist nicht definiert'),
            [IntToStr(AFirma)]));
          Exit;
        end;
        Close;
      end;
      // Die Leistungsnummer bekommt man über die Tischnummer (Tabelle
      // Tischzuordnung)
      with QueryGetLeistungsID do
      begin
        Close;
        SQL.Clear;
        Connection := ConnectionFelix;

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

        if PGl.FelixNachKassen then
          ParamByName('TischNr').AsInteger := AKasseID
        else
          ParamByName('TischNr').AsInteger := StrToIntDef(PTischNr, 0);

        Open;
        PLeistungsID := 0;

        if RecordCount > 0 then
        begin
          // Felix Interbase
          if PGl.HotelProgrammTyp = HpHotelFelix then
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
                  PLeistungsText := FieldByName('LeistungsBezeichnung')
                    .AsString;
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
          logger.info(IntToStr(FSerialNumber) + ': ' +
            Format(IvDictio.Translate
            ('Schreiben auf Gast: Dem Tisch %s ist keine Leistung zugeordnet'),
            [PTischNr]));
          Close;
          Exit;
        end;
        Close;
      end;

      if PGl.HotelProgrammTyp <> HpAllgemeinSQL then
      begin
        // Wenn die Apparatenummer nicht in die Tabelle eingetragen wurde,
        // dann
        TableGastkontoFELIX.Close;
        TableGastkontoFELIX.Open;
        TableGastkontoFELIX.Refresh;
        // 23.09.2014 KL: TODO wozu refresh nach clode/open?

        if CheckReservIdCheckIn(AFirma, PReservID) then
        begin
          TableGastkontoFELIX.Append;
          TableGastkontoFELIX.FieldByName('Firma').AsInteger := AFirma;
          // 13.10.2014 KL: Reversierungs-ID fehlt seit mindest. März 2013
          TableGastkontoFELIX.FieldByName('ReservID').AsInteger := PReservID;
          // Die Menge ist immer 1
          TableGastkontoFELIX.FieldByName('Menge').AsInteger := PMenge;
          TableGastkontoFELIX.FieldByName('LeistungsID').AsInteger :=
            PLeistungsID;
          TableGastkontoFELIX.FieldByName('Betrag').AsFloat := PBetrag;
          TableGastkontoFELIX.FieldByName('Fix').AsBoolean := False;
          TableGastkontoFELIX.FieldByName('AufRechnungsAdresse')
            .AsBoolean := False;
          TableGastkontoFELIX.FieldByName('InTABSGebucht').AsBoolean := False;
          TableGastkontoFELIX.FieldByName('Datum').AsDateTime := PfelixDate;
          if PText <> '' then
          begin
            if PGl.BonNumberOnHotel then
              TableGastkontoFELIX.FieldByName('LeistungsText').AsString :=
                PText + ' ' + IntToStr(PGl.BonNr)
            else
              TableGastkontoFELIX.FieldByName('LeistungsText').AsString
                := PText;
          end
          else
          begin
            if PGl.BonNumberOnHotel then
              TableGastkontoFELIX.FieldByName('LeistungsText').AsString :=
                PLeistungsText + ' ' + IntToStr(PGl.BonNr)
            else
              TableGastkontoFELIX.FieldByName('LeistungsText').AsString := '';
          end;

          TableGastkontoFELIX.Post;
          WriteToKassenJournalIB(PGl.Firma, QueryReservFELIX.FieldByName('ID')
            .AsInteger, QueryReservFELIX.FieldByName('ZimmerID').AsString,
            PTischNr, PfelixDate, PTime, PLeistungsID, PBetrag, PMenge);
        end
        else
        begin
          logger.info(IntToStr(FSerialNumber) + ': ' +
            Format(Translate
            ('Schreiben auf Zimmer: Reservierung %d nicht gefunden'),
            [PReservID]));
        end;
        TableGastkontoFELIX.Close;
      end;
    end;

  except
    on E: Exception do
      logger.Error('TDataPos.WriteToGastkonto', IntToStr(FSerialNumber) + ': ' +
        Translate('FEHLER in WriteToGastkonto: '), NXLCAT_NONE, E);
  end;
end;

// ******************************************************************************
//
// ******************************************************************************
procedure TDataPos.WriteToKassenJournalIB(PFirma, PReservID: Integer;
  PZimmerNr, PTischNr: string; PDatum: TDateTime; PTime: TTime;
  PLeistungsID: Integer; PBetrag: Double; PMenge: Integer);
begin
  try
    with CommandJournal do
    begin
      ParamByName('Firma').AsInteger := PFirma;
      ParamByName('ReservID').Value := PReservID;
      ParamByName('Datum').AsDateTime := PDatum;
      ParamByName('Zeit').AsDateTime := PTime;
      ParamByName('ErfassungDurch').Value := 6;
      ParamByName('Text').AsString := IvDictio.Translate('Kasse ZimmerNr: ') +
        PZimmerNr;
      ParamByName('Menge').Value := PMenge;
      ParamByName('Betrag').AsFloat := PBetrag;
      ParamByName('LeistungsID').Value := PLeistungsID;
      Execute;
    end;
  except
    on E: Exception do
    begin
      logger.Error('TDataPos.WriteToKassenJournalIB', IntToStr(FSerialNumber) +
        ': ' + 'Error in "Kassenjournal"', NXLCAT_NONE, E);
    end;
  end;

end;

// ******************************************************************************
// Damit in der Kasse die Buchungen reaktiviert werden kann
// ******************************************************************************
procedure TDataPos.WriteHotelLog(PText: string; PDatum: TDateTime;
  PKellnerID, PVonTischID: Integer; PReservID, PZimmerNr: string);
var
  AReservID, AWriteReservID: string;
  I: Integer;
begin
  // TODO: wenn die Tabelle nach dem Append sowieso geschlossen wird,
  // ist ein INSERT-SQL wesentlich schneller!
  with TableHotellog do
  begin
    Open;
    Append;
    FieldByName('Firma').AsInteger := PGl.Firma;
    FieldByName('ID').AsInteger := PDataDrucken.GetNextGENID('Hotellog', True);
    FieldByName('Datum').AsDateTime := PDatum;
    FieldByName('KellnerID').AsInteger := PKellnerID;
    FieldByName('VonTischID').AsInteger := PVonTischID;
    FieldByName('Text').AsString := PText;
    FieldByName('Zimmer_Nr').AsString := PZimmerNr;
    if PGl.HotelProgrammTyp = HpAllgemeinSQL then
    begin
      TableGastinfo.Open;
      AReservID := PReservID;
      // Wurde für Phönix wieder reingegeben
      for I := Length(AReservID) to 5 do // Iterate
      begin
        AReservID := '0' + AReservID;
      end; // for
      if TableGastinfo.Locate('Termin_NR;Zi_Nummer',
        VarArrayOf([AReservID, PZimmerNr]), []) then
      begin
        AWriteReservID := AReservID;
        // oder nach normaler ReservID
      end
      else if TableGastinfo.Locate('Termin_NR;Zi_Nummer',
        VarArrayOf([PReservID, PZimmerNr]), []) then
      begin
        AWriteReservID := PReservID;
      end
      else
        logger.info(IntToStr(FSerialNumber) + ': ' +
          IvDictio.Translate('12409: Reservierung nicht gefunden!'));
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
    if PGl.HotelProgrammTyp in [HpAllgemeinSQL, HpHotelFelix] then
      FieldByName('VonTischID').AsInteger := TableOffeneTische.FieldByName
        ('OffeneTischID').AsInteger;

    Post;
    Close;
  end; // with
  TableGastinfo.Close;
end;

// ******************************************************************************
// Bucht Artikel auf Zimmer um
// ******************************************************************************
procedure TDataPos.TransferToZimmer(PReservID: Integer;
  PZimmer, PGastadresseID: string);
var
  AMwst10, AMwst20, AMwst0: Double;
  AMenge, AArtikelID: Integer;
  // 03.04.2013 KL: TODO (09:16)  aMenge: Double; // Menge von Integer zu Double geändert
  ABetrag: Real;
  AHauptgruppe: string;
begin
  AArtikelID := 0;
  with QueryMwSt do
  begin
    Close;
    // DatabaseName := DatabaseLocalOD.AliasName;
    SQL.Clear;
    SQL.Add('SELECT Firma, ArtikelID, Betrag, SUM(Menge) AS Menge, OffeneTischID');
    SQL.Add('FROM Hilf_Tischkonto ');
    SQL.Add('WHERE OffeneTischID = ' + TableOffeneTische.FieldByName
      ('OffeneTischID').AsString + ' AND Firma = ' + IntToStr(PGl.Firma) +
      ' AND Betrag <> 0');
    SQL.Add('GROUP BY Firma, ArtikelID, Betrag, OffeneTischID');
    Open;
    First;

    AMwst10 := 0;
    AMwst20 := 0;
    AMwst0 := 0;
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
        if PGl.HotelEinzelnBuchen then
          WriteToGastkonto(TableOffeneTische.FieldByName('LookTischNr')
            .AsString, PReservID, PGl.Datum, Time, ABetrag, 10,
            FieldByName('LookArtikel').AsString, AMenge, AHauptgruppe,
            PGastadresseID, PZimmer, AArtikelID);
      end
      else if FieldByName('LookSteuer').AsInteger = 20 then
      begin
        AMwst20 := AMwst20 + FieldByName('Betrag').AsFloat *
          FieldByName('Menge').AsFloat;
        if PGl.HotelEinzelnBuchen then
          WriteToGastkonto(TableOffeneTische.FieldByName('LookTischNr')
            .AsString, PReservID, PGl.Datum, Time, ABetrag, 20,
            FieldByName('LookArtikel').AsString, AMenge, AHauptgruppe,
            PGastadresseID, PZimmer, AArtikelID);
      end
      else if FieldByName('LookSteuer').AsInteger = 0 then
      begin
        AMwst0 := AMwst0 + FieldByName('Betrag').AsFloat *
          FieldByName('Menge').AsFloat;
        if PGl.HotelEinzelnBuchen then
          WriteToGastkonto(TableOffeneTische.FieldByName('LookTischNr')
            .AsString, PReservID, PGl.Datum, Time, ABetrag, 0,
            FieldByName('LookArtikel').AsString, AMenge, AHauptgruppe,
            PGastadresseID, PZimmer, AArtikelID);
      end;
      Next;
    end;
    Close;
  end;
  if not PGl.HotelEinzelnBuchen then
  begin
    if AMwst10 <> 0 then
      WriteToGastkonto(TableOffeneTische.FieldByName('LookTischNr').AsString,
        PReservID, PGl.Datum, Time, AMwst10, 10, '', 1, AHauptgruppe,
        PGastadresseID, PZimmer, AArtikelID);
    if AMwst20 <> 0 then
      WriteToGastkonto(TableOffeneTische.FieldByName('LookTischNr').AsString,
        PReservID, PGl.Datum, Time, AMwst20, 20, '', 1, AHauptgruppe,
        PGastadresseID, PZimmer, AArtikelID);
    if AMwst0 <> 0 then
      WriteToGastkonto(TableOffeneTische.FieldByName('LookTischNr').AsString,
        PReservID, PGl.Datum, Time, AMwst0, 0, '', 1, AHauptgruppe,
        PGastadresseID, PZimmer, AArtikelID);
  end;
  WriteHotelLog(IntToStr(PGl.BonNr) + IvDictio.Translate(' Hotel: ') + PZimmer +
    Iif(LowerCase(ExtractFileName(ParamStr(0))) = 'ordermanserver.exe',
    ' (Orderman)', ' (Smart-Order)'), PGl.Datum, FWaiterID,
    TableOffeneTische.FieldByName('TischID').AsInteger,
    IntToStr(PReservID), PZimmer);

end;

// ******************************************************************************
//
// ******************************************************************************
procedure TDataPos.WriteUmbuchToJournal(PTischID, PTyp: Integer;
  PText, PZimmerNr: string);
begin
  QueryHilfTischkonto.Close;
  QueryHilfTischkonto.ParamByName('pOffeneTischID').Value :=
    TableOffeneTische.FieldByName('OffeneTischID').AsInteger;
  QueryHilfTischkonto.Open;
  QueryHilfTischkonto.First;

  // if pZimmerNr = '' then
  // pZimmerNr := TableOffeneTische.FieldByName('TischID').AsString;

  while not QueryHilfTischkonto.EOF do
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
      PDataStatistik.WriteToJournal(PText, NULL,
        QueryHilfTischkonto.FieldByName('Menge').Value,
        QueryHilfTischkonto.FieldByName('ArtikelID').Value,
        QueryHilfTischkonto.FieldByName('BeilagenID1').Value, PTyp, PTischID,
        QueryHilfTischkonto.FieldByName('Betrag').AsFloat, PZimmerNr,
        // vonTischID
        // 09.08.2010 BW: take TableID from source table
        // TableOffeneTische.FieldByName('TischID').AsInteger,
        FTableID, NULL, FWaiterID, True, PGl.BonNr)
    else
      PDataStatistik.WriteToJournal(PText, NULL,
        QueryHilfTischkonto.FieldByName('Menge').Value,
        QueryHilfTischkonto.FieldByName('ArtikelID').Value,
        QueryHilfTischkonto.FieldByName('BeilagenID1').Value, PTyp, PTischID,
        QueryHilfTischkonto.FieldByName('Betrag').AsFloat,
        // 09.08.2010 BW: take OpenTableID from source table
        // TableOffeneTische.FieldByName('OffeneTischID').AsString, //vonTischID
        GetOpenTableIDbyTableID(FTableID), NULL, NULL, FWaiterID, True,
        PGl.BonNr);

    // 2. Beilage
    if not QueryHilfTischkonto.FieldByName('BeilagenID2').IsNull then
      PDataStatistik.WriteToJournal(PText, NULL,
        QueryHilfTischkonto.FieldByName('Menge').Value,
        QueryHilfTischkonto.FieldByName('ArtikelID').Value,
        QueryHilfTischkonto.FieldByName('BeilagenID2').Value, PTyp, PTischID,
        QueryHilfTischkonto.FieldByName('Betrag').AsFloat,
        // 09.08.2010 BW: take OpenTableID from source table
        // TableOffeneTische.FieldByName('OffeneTischID').AsString, //vonTischID
        GetOpenTableIDbyTableID(FTableID), NULL, NULL, FWaiterID, True,
        PGl.BonNr);

    // 3. Beilage
    if not QueryHilfTischkonto.FieldByName('BeilagenID3').IsNull then
      PDataStatistik.WriteToJournal(PText, NULL,
        QueryHilfTischkonto.FieldByName('Menge').Value,
        QueryHilfTischkonto.FieldByName('ArtikelID').Value,
        QueryHilfTischkonto.FieldByName('BeilagenID3').Value, PTyp, PTischID,
        QueryHilfTischkonto.FieldByName('Betrag').AsFloat,
        // 09.08.2010 BW: take OpenTableID from source table
        // TableOffeneTische.FieldByName('OffeneTischID').AsString, //vonTischID
        GetOpenTableIDbyTableID(FTableID), NULL, NULL, FWaiterID, True,
        PGl.BonNr);

    QueryHilfTischkonto.Next
  end;
  QueryHilfTischkonto.Close;
  QueryHilfTischkonto.ParamByName('pOffeneTischID').Value := PTischID;
  QueryHilfTischkonto.Open;
end;

// ******************************************************************************
// Setzt den Datenbankzeiger in OffeneTische
// ******************************************************************************
function TDataPos.LocateOffenenTisch(PTischTyp: string;
  PTischID: Integer): Boolean;
begin
  with QueryLocateOffenerTisch do
  begin
    Close;
    SQL.Clear;
    // Handelt es sich beim abgefragten Tisch um einen W/E/P/B-Tisch
    // so ist das Datum der ersten Tischbuchung irrelevant
    if (PTischTyp <> '') and (PTischTyp[1] in ['W', 'E', 'P', 'B', 'S', 'G',
      'Z', 'L']) then
    begin
      SQL.Add('SELECT ot.OffeneTischID FROM OffeneTische ot');
      SQL.Add('LEFT OUTER JOIN Tisch t');
      SQL.Add('ON t.TischID = ot.TischID AND t.Firma = ot.Firma');
      SQL.Add('WHERE ot.Firma = ' + IntToStr(PGl.Firma));
    end
    else
    begin
      SQL.Add('SELECT ot.OffeneTischID FROM OffeneTische ot');
      SQL.Add('WHERE ot.Firma = ' + IntToStr(PGl.Firma));
      SQL.Add('AND ot.DATUM = ''' + DateToStr(PGl.Datum) + '''');
    end;
    SQL.Add('AND ot.Offen = ''T'' AND ot.TischID = ' + IntToStr(PTischID));
    Open;
    Result := not FieldByName('OffeneTischID').IsNull;
    // 14.12.2010 BW: exchange table/locate with query/params
    with TableOffeneTische do
    begin
      Close;
      ParamByName('pFirma').AsInteger := PGl.Firma;
      ParamByName('pOffeneTischID').AsInteger :=
        QueryLocateOffenerTisch.FieldByName('OffeneTischID').AsInteger;
      Open;
      if Result and (RecordCount < 1) then
      begin
        Result := False;
        logger.info(IntToStr(FSerialNumber) + ': ' +
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
  Result := False;

  // 27.07.2010 BW: added new transaction (TransactionLockTable) and start it
  if not TransactionLockTable.Connection.InTransaction then
    TransactionLockTable.StartTransaction;

  // if there is a lock conflict --> this means another waiter is currently on this table --> return false!
  try
    with QueryWriteCurrentWaiterToOpenTable do
    begin
      Close;
      ParamByName('pFirma').AsInteger := PGl.Firma;
      ParamByName('pOffeneTischID').AsInteger := POffeneTischID;
      ParamByName('pCurrentWaiterID').AsInteger := FWaiterID;
      ExecSQL;
    end;
    // commit to update the current waiter id
    TransactionLockTable.Commit;
    // and start again to keep the transaction open
    TransactionLockTable.StartTransaction;

    // make an update on the record of the passed open table id in table OFFENETISCHE
    // with new transaction (TransactionLockTable) in order to lock the open table
    with QueryLockTisch do
    begin
      Close;
      ParamByName('OffeneTischID').AsInteger := POffeneTischID;
      ExecSQL;
    end;
    Result := True;
  except
    TransactionLockTable.Rollback;
  end;
end;

// ******************************************************************************
// Tisch entsperren und je nach Parameter Commit oder Rollback
// ******************************************************************************
function TDataPos.UnLockTisch(PCommit: Boolean): Boolean;
begin
  Result := True;
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
        TransactionLockTable.Rollback;
    end;
  except
    // Bei Fehler immer Rollback
    TransactionLockTable.Rollback;
    Result := False;
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
    logger.info(IntToStr(FSerialNumber) + ': ' +
      IvDictio.Translate('Tisch erfolgreich geschlossen'));
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
    SQL.Clear;
    SQL.Add('execute procedure checktischoffen(:pOffeneTischID)');
    // ATTENTION: firma is hardcoded 1 in stored procedure
    ParamByName('pOffeneTischID').AsInteger := TableOffeneTische.FieldByName
      ('OffeneTischID').AsInteger;
    ExecSQL;
  end;
  UnLockTisch(True);
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
  if (PGl.PrintBillNumberValue > 0) and (PBetrag < PGl.PrintBillNumberValue)
  then
    PGl.LastRechNr := 0
  else
    with QueryRechNr do
    begin
      Close;
      SQL.Clear;
      if PProforma then
      begin
        SQL.Add('SELECT GEN_ID(GEN_LASTRechNR, 0) FROM RDB$DATABASE');
        Open;
        PGl.LastRechNr := FieldByName('GEN_ID').AsInteger;
        Close;
        PGl.LastRechNr := PGl.LastRechNr - 1;
        SQL.Clear;
        SQL.Add('SET generator GEN_LASTRECHNR TO ' + IntToStr(PGl.LastRechNr));
        ExecSQL;
      end
      else
      begin
        SQL.Add('SELECT GEN_ID(GEN_LASTRechNR, 1) FROM RDB$DATABASE');
        Open;
        PGl.LastRechNr := FieldByName('Gen_ID').AsInteger;
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
    if PGl.BonNrIsRechNr then
    begin
      SQL.Add('SELECT GEN_ID(GEN_LastRechNr, 0) FROM RDB$DATABASE');
      Open;
      PGl.BonNr := FieldByName('Gen_ID').AsInteger + 1;
    end
    else
    begin
      SQL.Add('SELECT GEN_ID(GEN_LastBonNr, 1) FROM RDB$DATABASE');
      Open;
      PGl.BonNr := FieldByName('Gen_ID').AsInteger;
    end;
    Close;
  end;
end;

// ******************************************************************************
// Kompletten Tisch abrechnen
// ******************************************************************************
procedure TDataPos.SetSofortRechnung(PTyp: Integer; PTischkontoTable: TFDQuery;
  PZahlweg: Integer; PRabatt: Real; PAdresseID, PAnzahl: Integer);
var
  ABetrag: Double;
  ARechID: Integer;
begin
  // pTischkontotable gibt die Tischkontotabelle an, aus der die Rechnung
  // erstellt wird.
  // Bein einer Teilrechnung ist das Hilf_Tischkonto
  // Bei einer Gesamtrechnung ist das Tischkonto
  if PTischkontoTable = QueryHilfTischkonto then
    with PTischkontoTable do
    begin
      // 28.07.2010 BW: close/open Query TableHilf_TischKonto
      Close;
      ParamByName('pOffeneTischID').AsInteger := TableOffeneTische.FieldByName
        ('OffeneTischID').AsInteger;
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
      SQL.Add('WHERE Firma = ' + IntToStr(PGl.Firma));
      SQL.Add('AND OffeneTischID = ' + TableOffeneTische.FieldByName
        ('OffeneTischID').AsString);
      Open;
      ABetrag := FieldByName('Betrag').AsFloat;
      Close;
    end; // with

  // Rechnungsnummer bei Kassabon und Proforma zurücksetzen!
  if (PGl.ItalienAnschluss and (PTyp in [0, 99])) then
  begin
    // SetRechnungsNr(TRUE);
    PGl.LastRechNr := 0;
  end
  else
    SetRechnungsNr(False, ABetrag);

  { if TableOffeneTische.FieldByName('GastAdresseID').AsInteger <> 0 then
    FAdresseID :=
    TableOffeneTische.FieldByName('GastAdresseID').AsInteger; }

  with QueryInsertRechnung do
  begin
    ParamByName('Firma').AsInteger := PGl.Firma;
    ARechID := PDataDrucken.GetNextGENID('Rechnung', True);
    FRechNr := ARechID;
    ParamByName('ID').AsInteger := ARechID;
    ParamByName('ReservID').AsInteger := TableOffeneTische.FieldByName
      ('OffeneTischID').AsInteger;
    ParamByName('Datum').AsDateTime := PGl.Datum;
    ParamByName('Rechnungsnummer').AsInteger := PGl.LastRechNr;
    ParamByName('ErstellerID').AsInteger := FWaiterID;
    ParamByName('ZahlungsBetrag').AsFloat := ABetrag -
      RoundTo((ABetrag * PRabatt / 100), -2);

    if (PTyp = 0) or ((PGl.PrintBillNumberValue > 0) and
      ((ABetrag - (Round(ABetrag * PRabatt) / 100)) < PGl.PrintBillNumberValue))
    then
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
        RoundTo((ABetrag * PRabatt / 100), -2);
      ParamByName('Bezahlt').AsString := 'T';
    end;
    ParamByName('Gedruckt').AsString := 'T';
    ParamByName('Nachlass').AsFloat := RoundTo(ABetrag * PRabatt / 100, -2);
    ParamByName('AdresseID').AsInteger := PAdresseID;
    ExecSQL;
  end;

  if PGl.ItalienAnschluss then
  begin
    case PTyp of //
      0:
        if PGl.ZahlwegKassaBon > 0 then
          PZahlweg := PGl.ZahlwegKassaBon;
    end; // case
  end;

  with QueryInsertRechzahlung do
  begin
    ParamByName('Firma').AsInteger := PGl.Firma;
    ParamByName('RechnungsID').AsInteger := ARechID;
    ParamByName('Datum').AsDateTime := PGl.Datum;
    ParamByName('Betrag').AsFloat := ABetrag -
      RoundTo((ABetrag * PRabatt / 100), -2);
    ParamByName('Verbucht').AsString := 'T';
    ParamByName('ZahlwegID').AsInteger := PZahlweg;
    ExecSQL;
  end;

  // Die Zahlwege müssen ins Journal eingetragen werden
  if PTyp <> 99 then // bei Proforma nichts eintragen
    PDataStatistik.WriteToJournal(IvDictio.Translate('RechNr: ') +
      IntToStr(PGl.LastRechNr), PZahlweg, NULL, NULL, NULL, 2,
      // Zahlung von Rechnungn
      TableOffeneTische.FieldByName('OffeneTischID').AsInteger,
      ABetrag - (ABetrag * PRabatt / 100), NULL, ARechID,
      ABetrag * PRabatt / 100, FWaiterID, False, NULL);

  // Die Leistungen vom Hilfskonto auf die Rechnung transferieren
  TransferLeistungToRechnung(PTischkontoTable, PTyp = 99, ARechID);
  // Sonst bekommt das Printpackage nichts mit!
  UnLockTisch(True);
  LockTisch(TableOffeneTische.FieldByName('OffeneTischID').AsInteger);
  // Bei Bonieren ohne Tisch wird keine Sofortrechnung gedruckt!
  // Das Drucken wird über die ID der offenen Tische aufgerufen

  UOpenLagerTische(FWaiterID, FKasseID, 0);

  // if pGl.ItalienAnschluss then
  // begin
  // if pGl.ItalienRegistrierKasseSenden and(PTyp = 0)then
  // // Kassabon
  // SetKasseIT(ARechID, PRabatt, RoundTo(ABetrag * PRabatt / 100,-2))
  // else
  // begin
  // if not((PTyp = 99)and pGl.ProformaOhneDruck)then
  // begin
  // if PTischKontoTable = TableHilf_Tischkonto then
  // uOpenLagerTische(FWaiterID, FKasseID, 0);
  //
  // if(PTyp = 99)then
  // DoDruckeBon(TableOffeneTische.FieldByName('OffeneTischID').AsInteger,
  // Dakassierbon, PAnzahl, pgl.datum, '', '', PTyp, True,
  // Gl.SpracheID, 0)
  // else
  // DoDruckeBon(ARechID, DaBonRechnung, PAnzahl, pgl.datum, '', '',
  // -1, True, FSprache, 0);
  // end;
  // end;
  // end
  // else
  // if(PTyp > 0)and not((PTyp = 99)and pGl.ProformaOhneDruck)then
  // DoDruckeBon(ARechID, DaBonRechnung, PAnzahl, pgl.datum, '', '', PTyp,
  // True, FSprache, 0);

  if PTyp = 99 then
  begin
    if PTischkontoTable = QueryHilfTischkonto then
      DeleteHilfTischkontoFromServer(True);
    DoProforma(PTischkontoTable, ARechID);
  end;
end;

// ******************************************************************************
// Die Leistungen der Hilfstabelle werden auf die Rechnung transferiert
// ******************************************************************************
procedure TDataPos.TransferLeistungToRechnung(PTischkontoTabelle: TFDQuery;
  PProforma: Boolean; PRechID: Integer);
var
  AArtikelID, I, ABonNr: Integer;
  ABeil1, ABeil2, ABeil3: string;
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
      SQL.Add('SELECT tk.Firma, ' + IntToStr(PRechID) + ', ''' +
        DateToStr(PGl.Datum) + ''',');
      SQL.Add('tk.ArtikelID, tk.Menge, tk.Betrag,');
      SQL.Add('b1.PreisPlus as PreisPlus1, b1.PreisMinus as PreisMinus1, ');
      SQL.Add('b1.BeilagenID as Beil1ID, b1.Bezeichnung AS Beilage1, ');
      SQL.Add('b2.PreisPlus as PreisPlus2, b2.PreisMinus as PreisMinus2, ');
      SQL.Add('b2.BeilagenID as Beil2ID, b2.Bezeichnung AS Beilage2, ');
      SQL.Add('b3.PreisPlus as PreisPlus3, b3.PreisMinus as PreisMinus3, ');
      SQL.Add('b3.BeilagenID as Beil3ID, b3.Bezeichnung AS Beilage3, tk.BeilagenText');

      if (PTischkontoTabelle = QueryHilfTischkonto) then
        SQL.Add('FROM Hilf_Tischkonto tk')
      else
        SQL.Add('FROM Tischkonto tk');

      SQL.Add('LEFT OUTER JOIN Beilagen b1');
      SQL.Add('ON tk.Firma = b1.Firma AND tk.BeilagenID1 = b1.BeilagenID');
      SQL.Add('LEFT OUTER JOIN Beilagen b2');
      SQL.Add('ON tk.Firma = b2.Firma AND tk.BeilagenID2 = b2.BeilagenID');
      SQL.Add('LEFT OUTER JOIN Beilagen b3');
      SQL.Add('ON tk.Firma = b3.Firma AND tk.BeilagenID3 = b3.BeilagenID');
      SQL.Add('WHERE tk.Firma = ' + IntToStr(PGl.Firma));
      SQL.Add('AND tk.OffeneTischID = ' + TableOffeneTische.FieldByName
        ('OffeneTischID').AsString);
      Open;
      First;
      while not EOF do
      begin
        ABeil1 := '';
        ABeil2 := '';
        ABeil3 := '';
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
            APreisMinus := FieldByName('Beil1ID').AsInteger = -3;
            APreisPlus := (PGl.BeilagenPreisImmerMit and
              (FieldByName('Beil1ID').AsInteger > 0)) or
              (FieldByName('Beil1ID').AsInteger = -2);
            APreisStatt := FieldByName('Beil1ID').AsInteger = -6;

            // 1. Beilage
            if (FieldByName('Beil1ID').AsInteger > 0) and PGl.BeilagenPreisImmerMit
            then
            begin
              ABeil1 := '(' + Format('%.2f', [FieldByName('PreisPlus1').AsFloat]
                ) + ') ' + FieldByName('Beilage1').AsString;
              if (FieldByName('Beil2ID').AsInteger > 0) then
                ABeil2 := '(' + Format('%.2f',
                  [FieldByName('PreisPlus2').AsFloat]) + ') ' +
                  FieldByName('Beilage2').AsString;
              if (FieldByName('Beil3ID').AsInteger > 0) then
                ABeil3 := '(' + Format('%.2f',
                  [FieldByName('PreisPlus3').AsFloat]) + ') ' +
                  FieldByName('Beilage3').AsString;
            end
            else if APreisPlus or APreisMinus or APreisStatt then
            // Preisänderung
            begin
              // erste Beilage ist ID < 0 -> kein Preis
              ABeil1 := FieldByName('Beilage1').AsString;
              // 2. Beilage
              if not FieldByName('Beil2ID').IsNull then
              begin
                ABeil2 := FieldByName('Beilage2').AsString;
                if APreisPlus and (FieldByName('PreisPlus2').AsFloat <> 0) then
                  ABeil1 := '(' + Format('%.2f',
                    [FieldByName('PreisPlus2').AsFloat]) + ') ' + ABeil1
                else if APreisMinus and (FieldByName('PreisMinus2').AsFloat <> 0)
                then
                  ABeil1 := '(' + Format('%.2f',
                    [FieldByName('PreisMinus2').AsFloat]) + ') ' + ABeil1
                else if APreisStatt then
                begin
                  AStattPreis1 := FieldByName('PreisMinus2').AsFloat;
                  // 3. Beilage
                  if not FieldByName('Beil3ID').IsNull then
                  begin
                    AStattPreis2 := FieldByName('PreisPlus3').AsFloat;
                    ABeil3 := FieldByName('Beilage3').AsString;
                    if Abs(AStattPreis2) > Abs(AStattPreis1) then
                      ABeil1 := '(' + Format('%.2f',
                        [AStattPreis1 + AStattPreis2]) + ') ' + ABeil1;
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

        if Pos('(0,00) ', ABeil1) > 0 then
          ABeil1 := StringReplace(ABeil1, '(0,00) ', '', [RfReplaceAll]);

        if Pos('(0,00) ', ABeil2) > 0 then
          ABeil2 := StringReplace(ABeil2, '(0,00) ', '', [RfReplaceAll]);

        if Pos('(0,00) ', ABeil3) > 0 then
          ABeil3 := StringReplace(ABeil3, '(0,00) ', '', [RfReplaceAll]);

        if (Pos('0)', ABeil1) > 3) and
          (Pos('0)', ABeil1) <= (Length(ABeil1) - 5)) then
          ABeil1 := StringReplace(ABeil1, '0)', ')', [RfReplaceAll]);

        if (Pos('0)', ABeil2) > 3) and
          (Pos('0)', ABeil2) <= (Length(ABeil2) - 5)) then
          ABeil2 := StringReplace(ABeil2, '0)', ')', [RfReplaceAll]);

        if (Pos('0)', ABeil3) > 3) and
          (Pos('0)', ABeil3) <= (Length(ABeil3) - 5)) then
          ABeil3 := StringReplace(ABeil3, '0)', ')', [RfReplaceAll]);

        DoInsertIntoRechkonto(PGl.Firma, PRechID, PGl.Datum, AArtikelID,
          FieldByName('Menge').AsFloat, FieldByName('Betrag').AsFloat,
          ABeil1 + ' ' + ABeil2 + ' ' + ABeil3 + FieldByName('BeilagenText')
          .AsString, ABonNr);
        Next;
      end;
      Close;
    end; // with
    // Daten werden noch zum löschen aus dem Journal benötigt
    if not(PTischkontoTabelle = QueryHilfTischkonto) and not PProforma then
    begin
      // Sonst über Query
      QueryDelTischkonto.ParamByName('OffeneTischID').AsInteger :=
        TableOffeneTische.FieldByName('OffeneTischID').AsInteger;
      QueryDelTischkonto.ParamByName('Firma').AsInteger := PGl.Firma;
      QueryDelTischkonto.ExecSQL;
    end;
  end;
end;

// ******************************************************************************
// Ins Rechnungskonto einen Artikel einfügen
// ******************************************************************************
procedure TDataPos.DoInsertIntoRechkonto(PFirma, PRechID: Integer;
  PDatum: TDateTime; PArtikelID: Integer; PMenge, PBetrag: Real;
  PBeilagen: string; PBonNr: Integer);
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
    ParamByName('LeistungsText').AsString := Format('%-35.35s', [PBeilagen]);
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
      DateToStr(PGl.Datum) + '''');
    SQL.Add('AND r.Firma=' + IntToStr(PGl.Firma));
    // if (not gl.ChefKellner) and gl.ReakEigenRech then
    SQL.Add('AND r.ErstellerID=' + IntToStr(FWaiterID));
    SQL.Add('AND ((T.TischID = ' + IntToStr(PTischID) + '))');
    // OR (T.ObertischID = ' + IntToStr(pTischID) + '))');
    // SQL.Add('AND (T.TischID = ' + aTischID);
    // If LocateOffenenTisch('', pTischID) Then
    // begin
    // SQL.Add('AND ((ot.Offen = ''T'') OR (T.ObertischID = ' + IntToStr(pTischID) + '))')
    // end;
    SQL.Add('ORDER BY r.ID');
    Open;
    if RecordCount > 0 then
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
      logger.info(IntToStr(FSerialNumber) + ': ' +
        IvDictio.Translate('Hole letzte Rechnung von Tisch mit der ID') + ' ' +
        IntToStr(PTischID))
    end;
  end;
end;

// ******************************************************************************
// Rechnung reaktivieren
// ******************************************************************************
function TDataPos.ReaktiviereRechnung(PRechID: Integer): Boolean;

  procedure ActivateTisch(PRechID, POffeneTischID: string);
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
      if PGl.Firma > 0 then
        SQL.Add('AND Firma=' + IntToStr(PGl.Firma));
      ExecSQL;
      // 14.12.2010 BW: just a senseless check --> skip!
      // if not TableOffeneTische.Locate('Firma;OffeneTischID',
      // VarArrayOf([gl.Firma, pOffeneTischID]), []) then
      // gl.DoLogError(FSerialNumber, IvDictio.Translate('3: ReaktiviereRechnung: Offener Tisch nicht gefunden'));
    end;
  end;

var
  ATischID: Integer;
  // für den Nachlass
  ACount: Integer;
begin
  Result := False;
  TableRechnung.Close;
  TableRechnung.Open;
  if TableRechnung.Locate('ID', PRechID, []) then
  begin
    // Überprüfen, ob der Tisch bereits offen ist
    with TableOffeneTische do
    begin
      // 14.12.2010 BW: exchange table/locate with query/params
      Close;
      ParamByName('pFirma').AsInteger := PGl.Firma;
      ParamByName('pOffeneTischID').AsInteger :=
        TableRechnung.FieldByName('ReservID').AsInteger;
      Open;
      if RecordCount < 1 then
        logger.info(IntToStr(FSerialNumber) + ': ' +
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
        ParamByName('pFirma').AsInteger := PGl.Firma;
        ParamByName('pDatum').Asdate := PGl.Datum;
        ParamByName('pOffen').AsString := 'T';
        ParamByName('pTischID').AsInteger := ATischID;
        Open;
        if RecordCount > 0 then
        begin
          // und wenn das ein anderer ist, kann der Tisch nicht reaktiviert werden
          if TableRechnung.FieldByName('ReservID').AsInteger <>
            FieldByName('OffeneTischID').AsInteger then
          begin
            logger.info(IntToStr(FSerialNumber) + ': ' +
              IvDictio.Translate
              ('Tisch ist schon wieder belegt! Offene Tisch ID') + ': ' +
              IntToStr(FieldByName('OffeneTischID').AsInteger));
            Exit;
          end;
        end;
      end;

      // //Diese Tabelle nach einem offenen Tisch mit der gleichen Nummer suchen
      // if Locate('Firma;TischID;Offen;Datum',
      // VarArrayOf([gl.Firma, aTischID, 'T', pgl.datum]), []) then
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
      if LockTisch(TableOffeneTische.FieldByName('OffeneTischID').AsInteger)
      then
      begin
        // Kassenjournal und Kasse gegenbuchen
        SQL.Clear;
        SQL.Add('SELECT * FROM Rechnungszahlweg');
        SQL.Add('WHERE RechnungsID = ' + IntToStr(PRechID));
        if PGl.Firma > 0 then
          SQL.Add('AND Firma=' + IntToStr(PGl.Firma));
        Open;
        ACount := 0;
        while not EOF do
        begin
          if ACount = 0 then
            PDataStatistik.WriteToJournal
              (Format(IvDictio.Translate('Rech. %s reaktiv. - %s'),
              [TableRechnung.FieldByName('Rechnungsnummer').AsString,
              IntToStr(FWaiterID)]), FieldByName('ZahlwegID').AsInteger, NULL,
              NULL, NULL, 5, // Zahlung von Rechnungn
              TableRechnung.FieldByName('ReservID').Value,
              -FieldByName('Betrag').AsFloat,
              TableRechnung.FieldByName('AdresseID').AsInteger,
              TableRechnung.FieldByName('ID').AsInteger,
              TableRechnung.FieldByName('Nachlass').AsFloat,
              TableRechnung.FieldByName('ErstellerID').AsInteger, False, NULL)
          else
            PDataStatistik.WriteToJournal
              (Format(IvDictio.Translate('Rechn. %s reaktiv. - %s'),
              [TableRechnung.FieldByName('Rechnungsnummer').AsString,
              IntToStr(FWaiterID)]), FieldByName('ZahlwegID').AsInteger, NULL,
              NULL, NULL, 5, // Zahlung von Rechnungn
              TableRechnung.FieldByName('ReservID').Value,
              -FieldByName('Betrag').AsFloat,
              TableRechnung.FieldByName('AdresseID').AsInteger,
              TableRechnung.FieldByName('ID').AsInteger, NULL,
              TableRechnung.FieldByName('ErstellerID').AsInteger, False, NULL);
          Next;
        end;
        Close;
        // Rechnungszahlweg löschen
        SQL.Clear;
        SQL.Add('DELETE FROM Rechnungszahlweg');
        SQL.Add('WHERE RechnungsID = ' + IntToStr(PRechID));
        if PGl.Firma > 0 then
          SQL.Add('AND Firma=' + IntToStr(PGl.Firma));
        ExecSQL;
        if not TableRechnung.FieldByName('ReservID').IsNull then
        begin
          // Die Reservierung der Rechnung reaktivieren
          ActivateTisch(IntToStr(PRechID), TableRechnung.FieldByName('ReservID')
            .AsString);
          TransferLeistungToTischkonto;
        end;
        // Die Rechnung wird nur auf 0 gesetzt, eine neue Rechnung bekommt auch
        // eine neue Rechnungsnummer
        // Auch die ReservierungsID wird NULL gesetzt, für die Rechnungsausgangsliste
        // reicht die AdresseID
        SQL.Clear;
        SQL.Add('UPDATE Rechnung SET ZahlungsBetrag = NULL,');
        SQL.Add('BereitsBezahlt = NULL, Gedruckt = NULL, BearbeiterID = ' +
          IntToStr(FWaiterID) + ', Nachlass = NULL,');
        SQL.Add('Mahndatum = NULL, Mahnstufe = NULL');
        // Bearbeiterid = -1 ->> Rechnung reaktiviert
        SQL.Add('WHERE ID = ' + IntToStr(PRechID));
        if PGl.Firma > 0 then
          SQL.Add('AND Firma=' + IntToStr(PGl.Firma));
        ExecSQL;
        Result := True;
      end
      else
      begin
        logger.info(IntToStr(FSerialNumber) + ': ' +
          IvDictio.Translate('Rechn. Reakt. - Tisch bereits WIEDER geöffnet!'));
      end;
      // Tisch Entsperren
      UnLockTisch(True);
    end;
    logger.info(IntToStr(FSerialNumber) + ': ' +
      Format(IvDictio.Translate('Rechnung %s wurde erfolgreich reaktiviert'),
      [TableRechnung.FieldByName('Rechnungsnummer').AsString]));
    // 15.12.2010 BW: this is dead!!! remove this fucking table.close!!!
    // TableRechnung.Close;
  end
  else
    logger.info(IntToStr(FSerialNumber) + ': ' +
      Format(Translate
      ('Reaktiviere Rechnung: Rechnungsnummer %s nicht gefunden'),
      [IntToStr(PRechID)]));
end;

// ******************************************************************************
// Die Leistungen von Rechnungskonto werden wieder auf den Tisch transferiert
// ******************************************************************************
procedure TDataPos.TransferLeistungToTischkonto;
begin
  with QueryRechnungsKonto do
  begin
    Close;
    ParamByName('RechnungsID').AsInteger := TableRechnung.FieldByName('ID')
      .AsInteger;
    Open;
    First;
    TableTischkonto.ParamByName('pOffeneTischID').Value :=
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
        TableTischkonto.FieldByName('Datum').AsDateTime := PGl.Datum;
        TableTischkonto.FieldByName('Menge').AsFloat :=
          FieldByName('Menge').AsFloat;
        TableTischkonto.FieldByName('Betrag').AsFloat :=
          FieldByName('Betrag').AsFloat;
        TableTischkonto.FieldByName('Gedruckt').AsBoolean := True;
        if (FieldByName('LeistungsText').Value = NULL) or
          (FieldByName('LeistungsText').Value = '') then
          TableTischkonto.FieldByName('BeilagenText').Value := NULL
        else
          TableTischkonto.FieldByName('BeilagenText').Value :=
            FieldByName('LeistungsText').Value;
      end
      else
      begin
        // freier Text
        TableTischkonto.FieldByName('Datum').AsDateTime := PGl.Datum;
        TableTischkonto.FieldByName('BeilagenID1').AsInteger := -1;
        if (FieldByName('LeistungsText').Value = NULL) or
          (FieldByName('LeistungsText').Value = '') then
          TableTischkonto.FieldByName('BeilagenText').Value := NULL
        else
          TableTischkonto.FieldByName('BeilagenText').Value :=
            FieldByName('LeistungsText').Value;
      end;
      TableTischkonto.FieldByName('KasseID').AsInteger := PGl.KasseID;
      TableTischkonto.FieldByName('Firma').AsInteger := PGl.Firma;
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
  with QueryDelRechnungsKonto do
  begin
    Close;
    ParamByName('RechnungsID').AsInteger := TableRechnung.FieldByName('ID')
      .AsInteger;
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
  Found := False;
  repeat
    if FTabelleSchluesselUrsprung[Pos] = Zeichen then
      Found := True;
    if not(Found) then
      Inc(Pos);
  until Found;
  case Schluessel of
    Gerade:
      Result := FTabelleSchluesselGerade[Pos];
    Ungerade:
      Result := FTabelleSchluesselUnGerade[Pos];
  end;
end;

// ******************************************************************************
// Verschlüsselt den in FPasswort enthaltenen String und schreibt das
// Ergebnis in FPasswortKodiert
// ******************************************************************************
function TDataPos.Verschluesseln(PPW: string): string;
var
  PassStrg, AResult: string;
  CharCnt: Integer;
begin
  PassStrg := '';
  AResult := '';
  for CharCnt := 1 to Length(PPW) do
  begin
    if CharCnt mod 2 = 0 then
      PassStrg := PassStrg + GetSchluesselChar(Gerade, PPW[CharCnt])
    else
      PassStrg := PassStrg + GetSchluesselChar(Ungerade, PPW[CharCnt]);
  end;
  for CharCnt := Length(PassStrg) downto 1 do
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
  // CDSKonto.CreateDataSet; // for table TISCHKONTO
  // // 22.07.2010 BW: add new Client Data Set:
  // CDSHilfKonto.CreateDataSet; // for table HILF_TISCHKONTO
  // CDSMakeLists.CreateDataSet;
  // // for making static lists in hermes and classic line (downloadlist)
  // CDSKonto2.CreateDataSet; // for SumArticlesinTableAccount

  // 05.12.2010 BW: remove load printer package to InitializeOrdermanServer in MainUnit

  // 07.12.2010 BW: open every 'important' DataSet once at startup
  TableTisch.Open;
  QueryWaiter.ParamByName('pFirma').AsInteger := PGl.Firma;
  QueryWaiter.Open;
  TableBeilagen.Open;
  QueryTableAccount.ParamByName('pFirma').AsInteger := PGl.Firma;
  QueryTableAccount.ParamByName('pOffeneTischID').AsInteger := 0;
  QueryTableAccount.Open;
  QueryHelpTableAccount.ParamByName('pFirma').AsInteger := PGl.Firma;
  QueryHelpTableAccount.ParamByName('pOffeneTischID').AsInteger := 0;
  QueryHelpTableAccount.Open;

end;

// ******************************************************************************
//
// ******************************************************************************
procedure TDataPos.DataModuleCreate(Sender: TObject);
begin
  PosPrinting.PosPrintingInitialize(0, DBase.KasseID,
    DBase.ConnectionZEN.Params.Values['Database'], DBase.ConnectionZEN);

  FTabelleSchluesselUrsprung := 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789ÄÜÖ';
  FTabelleSchluesselGerade := 'sklqmndf7328045xuÖihägwzoüy1c6b9jperatv';
  FTabelleSchluesselUnGerade := '9bÜ6cÄ1vtarepjsklfdnmq457328Ö0hiuxzwgyo';

  if PGl.HotelProgrammTyp = HpAllgemeinSQL then
  begin
    QueryCheckZimmerIB.Connection := DBase.ConnectionZEN;
    TableGastinfo.Connection := DBase.ConnectionZEN;
    TableKassinfo.Connection := DBase.ConnectionZEN;
  end
  else
    QueryCheckZimmerIB.Connection := ConnectionFelix;    // 06.12.2018 KL: #21324

  if PGl.FelixZimmer and (PGl.HotelProgrammTyp = HpHotelFelix) then
  begin
    if Trim(DBase.FelixPath)='' then
    begin
      logger.error('==================================================');
      logger.error('==  FELIX-Datenbank fehlt in KASSE.INI  ==========');
      logger.error('==================================================');
    end
    else
    try
      ConnectionFelix.Params.Values['Database'] := DMBase.DBase.FelixPath;
      ConnectionFelix.Connected := True;
    except on E: Exception do
      begin
        logger.error('==================================================');
        logger.error('==  KEINE Verbindung zur FELIX-Datenbank =========');
        logger.error('==================================================');
        logger.error(e.message);
        logger.error('==================================================');
        // 24.10.2018 KL: #20964 clear FelixPath if database does not exist or is not reachable
        Dbase.FelixPath := '';
      end;
    end;
  end;

  // 11.08.2010 BW: Set initial values for new fields:
  FTableType := TableTypeNormal;
  FTableMode := TT_Alle;
  FPrint_PaymentMethodID := 1; // normally 'Bar'
  FPrint_AmountofPrintouts := 1; // 1 printout
end;

// copied from DMBASE but without starting an extra transaction and commit it (speed!!!)
function TDataPos.GetGeneratorID(PGenerator: string; PInc: Integer): Integer;
begin
  Result := 0;
  with Query do
  begin
    Close;
    SQL.Clear;
    if PInc = 0 then
      SQL.Add('Select Gen_ID(' + PGenerator + ',0) from RDB$database')
    else
      SQL.Add('Select Gen_ID(' + PGenerator + ',' + IntToStr(PInc) +
        ') from RDB$database');
    Open;
    Result := FieldByName('Gen_ID').AsInteger;
    Close;
  end;
end;

// ******************************************************************************
//
// ******************************************************************************
function TDataPos.GetNextIBID(ATableName: string; ATable: TDataSet;
  AIDString: string): Integer;
var
  AID: Integer;
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
    FieldByName('Firma').AsInteger := PGl.Firma;
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

function TDataPos.CheckLoginName(PLoginName: string): Boolean;
  function GetValue(Rechte: LongInt; AConst: Integer): Boolean;
  begin
    if (Rechte and AConst) = AConst then
      Result := True
    else
      Result := False;
  end;

var
  ABonierRechte, ZugriffsRechte: LongInt;
begin
  Result := False;

  // 20.08.2010 BW: if user did not enter a username --> return false and exit!
  if PLoginName = '' then
    Exit;

  with QueryWaiter do
  begin
    Close;
    ParamByName('pFirma').AsInteger := PGl.Firma;
    Open;
    if Locate('Firma;LoginName', VarArrayOf([PGl.Firma, PLoginName]), []) then
    begin
      Result := True;
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
      FKellnerdarfreakt := GetValue(ZugriffsRechte, CMainReaktivieren);
      FKellnerDarfXBon := GetValue(ZugriffsRechte, CMainXBon);
      FKellnerDarfZBon := GetValue(ZugriffsRechte, CMainZBon);
      FKellnerDarfSplitten := GetValue(ZugriffsRechte, CMainTischSplitting);
      FKellnerDarfNachrichten := GetValue(ZugriffsRechte, CMainNachrichten);
      FKellnerStammgaeste := GetValue(ZugriffsRechte, CMainStammgaeste);
      FKellnerIsChef := GetValue(ZugriffsRechte, CChef);

      // 24.08.2010 BW: BUGFIX: read "asinteger" and not "asvariant" in order to get no error if the field 'RechteBonier' is NULL!
      ABonierRechte := FieldByName('RechteBonier').AsInteger;
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

function TDataPos.CheckLoginPassword(PLoginPassword: string): Boolean;
begin
  Result := False;
  with QueryWaiter do
  begin
    Close;
    ParamByName('pFirma').AsInteger := PGl.Firma;
    Open;
    if Locate('Firma;LoginName;Passwort',
      VarArrayOf([PGl.Firma, GetLoginName,
      Verschluesseln(UpperCase(PLoginPassword))]), []) then
      Result := True;
  end;
end;

function TDataPos.CheckWaiterRight(PWaiterHasRight: Boolean): Boolean;
var
  AMsgStrNoRight: string;
begin
  Result := False;

  AMsgStrNoRight := Translate('Keine Berechtigung!');

  if not PWaiterHasRight then
  begin
    logger.info(IntToStr(FSerialNumber) + ': ' + AMsgStrNoRight);
    // GetOrderman(FserialNumber).FcurrentForm.ShowInfo(AMsgStrNoRight, '');
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
    SQL.Clear;
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
    // Parambyname('pDatum').asdate := pgl.datum;

    SQL.Add('SELECT * FROM Tisch T, offenetische OT');
    SQL.Add('WHERE OT.tischid = T.tischid AND OT.offen = ''T''');
    SQL.Add('AND T.Firma = OT.Firma');
    SQL.Add('AND OT.datum = ''' + DateToStr(PGl.Datum) + '''');
    SQL.Add('AND T.ObertischID = ''' + IntToStr(PTableID) + '''');
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
  Result := False;
  // check if there is a hotel interface is installed (felix or other)
  if PGl.FelixZimmer then
  begin
    Result := True;
    // if hotel program is felix then also check, if a correct felix.gdb is available (in kasse.ini FelixPath=)
    if PGl.HotelProgrammTyp = HpHotelFelix then
      with QueryCheckFELIX do
        try
          Close;
          Open;
          Close;
        except
          on E: Exception do
          begin
            logger.Error('TDataPos.CheckHasHotelInterface',
              IntToStr(FSerialNumber), NXLCAT_NONE, E);
            Result := False;
          end;
        end;
  end;

end;

// procedure TDataPos.GetTableAccount(PTargetAccount: TClientDataSet;
// PSourceAccount: TFDQuery);
// begin
// // clear target account
// PTargetAccount.EmptyDataSet;
//
// with PSourceAccount do
// begin
// Close;
// Parambyname('pFirma').Asinteger := pGl.Firma;
// Parambyname('pOffeneTischID').Asinteger := TableOffeneTische.FieldByName
// ('OffeneTischID').AsInteger;
// Open;
// while not EOF do
// begin
// InsertTableAccountEntryIntoAccount(PTargetAccount, PSourceAccount,
// FieldbyName('TischKontoID').Asinteger, FieldbyName('Menge').Asfloat);
// Next;
// end;
// end;
// end;
//
// procedure TDataPos.SendTableAccount(PTargetAccount, PSourceAccount: TDataSet);
/// / internal function for getting the sync status of a table account entry
// function GetSyncStatus: Word;
// begin
// Result := 0;
// // check if table account entry has been changed/added
// if PSourceAccount.Fieldbyname('Zaehler').Asinteger <> 0 then
// // if not pSourceAccount.Fieldbyname('Gedruckt').asboolean then
// begin
// // check if table account entry already exists in target account
// if PTargetAccount.Locate('Firma;TischKontoID',
// VarArrayOf([pGl.Firma, PSourceAccount.FieldbyName('TischKontoID')
// .AsInteger]),[])then
// begin
// Result := 1; // table account entry already exists and has changed
// end
// else
// Result := 2; // table account entry does not exist and has been added
// end;
// end;
//
/// / end of internal function
// var
// ADifferenceOfAmount: Double;
// begin
//
// with PSourceAccount do
// begin
// // go to first record in source account! important!
// Close;
// Open;
// // refresh target account! important!
// PTargetAccount.Close;
// PTargetAccount.Open;
// while not EOF do
// begin
// // check sync status of the current table account entry
// case GetSyncStatus of
// 0: // table account entry has not changed and is not new
// begin
// // do nothing
// end;
// 1: // table account entry already exists in target account
// begin
// ADifferenceofAmount := FieldbyName('Menge').Asfloat -
// PTargetAccount.FieldbyName('Menge').Asfloat;
// UpdateTableAccountEntryIntoAccount(PTargetAccount,
// Fieldbyname('TischKontoID').Asinteger, ADifferenceofAmount);
// end;
// 2: // table account entry does not exist in target account
// begin
// InsertTableAccountEntryIntoAccount(PTargetAccount, PSourceAccount,
// Fieldbyname('TischKontoID').Asinteger,
// Fieldbyname('Menge').Asfloat);
// end;
// end;
// Next; // get next table account entry of source account
// end;
// end;
//
// end;
//
// procedure TDataPos.MoveTableAccount(PTargetAccount, PSourceAccount: TDataSet);
// begin
// // flag all entries of pSourceAccount as changed (field 'Zaehler' = - field 'Menge' //set all entries of pSourceAccount 'Gedruckt' to false (flag that these entries have been changed)
// with PSourceAccount do
// begin
// Close;
// Open;
// while not EOF do
// begin
// Edit;
// Fieldbyname('Zaehler').Asinteger :=
// -Ceil(Abs(FieldByName('Menge').AsFloat));
// Post;
// Next;
// end;
// end;
// // insert entries from pSourceAccount into pTargetAccount
// SendTableAccount(PTargetAccount, PSourceAccount);
// // delete all entries from pSourceAccount
// RemoveAllTableAccountEntries(PSourceAccount);
// end;
//
// procedure TDataPos.ChangeTableAccount(PTargetAccount: TDataSet;
// POpenTableID: Integer);
// var
// ARecordCount, ARecNo, I: Integer;
// begin
// with PTargetAccount do
// begin
// Close;
// Open;
// ARecordCount := Recordcount;
// for I := 1 to ARecordCount do
// begin
// ARecNo := RecNo;
// // Workaround for Post and Order by TischKontoID problem, because after the Post, the db cursor stands at the just changed entry at the end of the query!!!
// Edit;
// Fieldbyname('TischKontoID').Asinteger :=
// DBase.GetGeneratorID('GEN_TISCHKONTO', 1);
// Fieldbyname('OffeneTischID').Asinteger := POpenTableID;
// Post;
// RecNo := ARecNo;
// // Next Workaround --> this solution goes to the "next" entry
// end;
// end;
// end;
//
// procedure TDataPos.SetTableAccount(POpenTableID: Integer);
// begin
// // set QueryTableAccount to table TISCHKONTO from passed open table
// with QueryTableAccount do
// begin
// Close;
// Parambyname('pFirma').Asinteger := pGl.Firma;
// Parambyname('pOffeneTischID').Asinteger := POpenTableID;
// Open;
// end;
// // set QueryHelpTableAccount to table HILF_TISCHKONTO from passed open table
// with QueryHelpTableAccount do
// begin
// Close;
// Parambyname('pFirma').Asinteger := pGl.Firma;
// Parambyname('pOffeneTischID').Asinteger := POpenTableID;
// Open;
// end;
// end;
//
// function TDataPos.CheckTableAccountEmpty(PAccount: TDataSet): Boolean;
// var
// ATotal: Double;
// begin
// Result := False;
// ATotal := 0;
// with PAccount do
// begin
// Close;
// Open;
// while not EOF do
// begin
// ATotal := ATotal + FieldbyName('Menge').Asfloat;
// Next;
// end;
// end;
// if ATotal = 0 then
// Result := True;
//
// end;
//
// function TDataPos.CheckTableAccountHasRooms(PAccount: TDataSet): Boolean;
// var
// ATempInteger: Integer;
// begin
// Result := False;
// with PAccount do
// begin
// Close;
// Open;
// while not EOF do
// begin
// try
// ATempInteger := FieldbyName('LookArtikel').AsInteger;
// Result := True;
// except
// // on exception result is still false
// end;
// Next;
// end;
// end;
// end;
//
// function TDataPos.CheckTableAccountSideOrderObligation
// (PAccount: TDataSet): Boolean;
// begin
// Result := False;
// with PAccount do
// begin
// Close;
// Open;
// while not EOF do
// begin
// // check if side order obligation AND amount of article is not 0 (valid article for tally)
// if((Fieldbyname('Beilagenabfrage').Asstring = '!')and
// (Fieldbyname('Menge').Asinteger <> 0))then
// begin
// Result := True;
// Exit;
// end;
// Next;
// end;
// end;
// end;
//
// procedure TDataPos.SumArticlesinTableAccount(PTargetAccount, PSourceAccount
// : TDataSet);
/// / internal function for getting all side orders of an article
// function GetSideOrdersofArticle(PAccount: TDataSet):string;
// var
// ARecNo: Integer;
// begin
// Result := '';
// with PAccount do
// begin
// // store position of cursor (article) in account
// ARecNo := RecNo;
// // go to next table account entry after the article
// Next;
// // check if table account entry is an article; if Yes --> exit because article has no sideorders
// if((not Fieldbyname('ArtikelID').Isnull)or EOF)then
// begin
// // restore position of cursor (article) in account before exit
// RecNo := ARecNo;
// Exit;
// end;
// // go through all side orders of the article
// while(Fieldbyname('ArtikelID').Isnull and(not EOF))do
// begin
// // concanete string of all side orders of the article e.g.: 'mit 2 Gläser ohne Eis'
// Result := Result + Fieldbyname('LookArtikel').Asstring;
// // go to next side order
// Next;
// end;
// // restore position of cursor (article) in account before exit
// RecNo := ARecNo;
// end;
// end;
/// / end of internal function
/// / internal function for checking if two table account entries are the SAME article (with same side orders!)
// function CheckArticlesAreSame: Boolean;
// begin
// Result := False;
// // check if target article is NO side order
// if not PTargetAccount.FieldbyName('ArtikelID').Isnull then
// begin
// // check if articles are same
// if((PTargetAccount.FieldbyName('ArtikelID')
// .Asinteger = PSourceAccount.FieldbyName('ArtikelID').Asinteger)
// // same articleid
// and(PTargetAccount.FieldbyName('Betrag')
// .AsFloat = PSourceAccount.FieldbyName('Betrag').AsFloat)// same price
// and(PTargetAccount.FieldbyName('LookArtikel')
// .AsString = PSourceAccount.FieldbyName('LookArtikel').AsString)
// // same description (this is important because user can change article description in 'Datenanlage'!)
// and(PTargetAccount.FieldbyName('I_DeviceGuid')
// .AsString = PSourceAccount.FieldbyName('I_DeviceGuid').AsString))then
// // same device (important for Smart-Order)
// begin
// // check if articles have same side orders
// if GetSideOrdersofArticle(PTargetAccount)= GetSideOrdersofArticle
// (PSourceAccount)then
// Result := True;
// end;
// end;
// end;
/// / end of internal function
/// / internal function for summing an article to another article in table account if they are the SAME
// procedure SumArticleToSameArticle;
// var
// ASourceArticle_TableAccountID, ATargetArticle_TableAccountID: Integer;
// begin
// // go through all articles in target account
// with PTargetAccount do
// begin
// Close;
// Open;
// while not EOF do
// begin
// // 07.04.2011 BW: skip "deleted" articles in target account (amount = 0)
// if Fieldbyname('Menge').Asfloat <> 0 then
// begin
// // check if article in source account and article in target account are the same
// // BUT NOT the same table account entry
// ASourceArticle_TableAccountID := PSourceAccount.FieldbyName
// ('TischKontoID').Asinteger;
// ATargetArticle_TableAccountID := FieldbyName('TischKontoID')
// .Asinteger;
// if((ATargetArticle_TableAccountID <> ASourceArticle_TableAccountID)and
// CheckArticlesAreSame)then
// begin
// // increase target article in target account
// Edit;
// FieldbyName('Menge').Asfloat := FieldbyName('Menge').Asfloat +
// PSourceAccount.FieldbyName('Menge').Asfloat;
// FieldbyName('Zaehler').Asinteger := FieldbyName('Zaehler').Asinteger
// + Ceil(Abs(PSourceAccount.FieldbyName('Menge').Asfloat));
// Post;
// // delete source article in target account
// if Locate('Firma;TischKontoID',
// VarArrayOf([pGl.Firma, ASourceArticle_TableAccountID]),[])then
// begin
// Edit;
// FieldbyName('Menge').Asfloat := 0;
// FieldbyName('Zaehler').Asinteger := 0;
// Post;
// end;
// // delete target article in source account
// with PSourceAccount do
// begin
// if Locate('Firma;TischKontoID',
// VarArrayOf([pGl.Firma, ATargetArticle_TableAccountID]),[])then
// begin
// Edit;
// FieldbyName('Menge').Asfloat := 0;
// FieldbyName('Zaehler').Asinteger := 0;
// Post;
// end;
// end;
// Exit;
// end;
// end;
// Next;
// end;
// end;
// end;
//
/// / end of internal function
// var
// ARecNo, I: Integer;
// begin
//
// // copy records from target account to source account in order to have a deep copy of the target account as source account (you have to work with 2 accounts!!!)
// with PSourceAccount do
// begin
// Close;
// Open;
// while not EOF do
// Delete;
// end;
// with PTargetAccount do
// begin
// Close;
// Open;
// while not EOF do
// begin
// CDSKonto2.Append;
// for I := 0 to FieldCount - 1 do
// CDSKonto2.Fields[I].Value := Fields[I].Value;
// CDSKonto2.Post;
// Next;
// end;
// end;
// // end of copy
//
// // go through all articles in source account (copy)
// with PSourceAccount do
// begin
// Close;
// Open;
// while not EOF do
// begin
// // check if source article is new and NO side order
/// / gl.DoLogFile(0,'Menge='+FloatToStr(Fieldbyname('Menge').AsFloat)+', Zähler='+FloatToStr(Fieldbyname('Zaehler').asinteger));
// if((Fieldbyname('Menge').AsFloat <> 0)and
// (FieldbyName('Menge').Asfloat = FieldbyName('Zaehler').Asinteger))then
// begin
// // store position of cursor in source account
// ARecNo := RecNo;
// // try to sum this current article in source account to all articles in target account
// SumArticleToSameArticle;
// // restore position of cursor in source account
// RecNo := ARecNo;
// end;
// // go to next article in source account
// Next;
// end;
// end;
// end;
//
// procedure TDataPos.AddArticle(PTargetAccount: TDataSet;
// PArticleId, PMultiplier: Integer);
// var
// I: Integer;
// begin
// // check if selected article exists in kasse.gdb
// with QueryArtikel do
// begin
// Close;
// Parambyname('pFirma').Asinteger := pGl.Firma;
// ParamByName('ArtikelID').AsInteger := PArticleID;
// Open;
// if RecordCount = 0 then
// begin
// Logger.info(inttostr(FSerialNumber)+': '+
// IvDictio.Translate('Artikel nicht gefunden!'), true);
// Exit;
// end
// end;
//
// with PTargetAccount do
// begin
// // 06.12.2010 BW
// // close;
// // open;
/// / 30.07.2010 BW: Do not allow new articles added to existing articles and increase amount by 1
/// / if Locate('ArtikelID;Firma', VarArrayOf([pArticleID, gl.Firma]), []) then
/// / begin
/// / UpdateTableAccountEntryIntoAccount(CDSKonto, FieldbyName('TischKontoID').asinteger, 1);
/// / end
/// / else
// begin
// Append;
// FieldByName('Firma').AsInteger := pGl.Firma;
// FieldByName('TischkontoID').AsInteger := GetGeneratorID('GEN_TISCHKONTO',
// 1); // 06.12.2010 BW: use own function instead of DBase.GetGeneratorID because of speed optimization
// FieldByName('OffeneTischID').AsInteger := TableOffeneTische.FieldByName
// ('OffeneTischID').AsInteger;
// FieldByName('Gedruckt').AsString := 'F';
// FieldByName('KellnerID').AsInteger := FWaiterID;
// FieldByName('KasseID').AsInteger := FKasseID;
// FieldByName('Datum').AsDateTime := pgl.datum;
// FieldByName('ArtikelID').AsInteger := PArticleID;
// FieldByName('Menge').AsFloat := PMultiplier;
// FieldByName('Betrag').AsFloat := GetPricebyPriceLevel(FPreisEbene);
// FieldByName('Verbucht').AsString := 'T';
// // 29.11.2010 BW: 'Verbucht' is always true because false is only important if you make instant stock withdrawal without closing table
// FieldByName('LookArtikel').AsString :=
// QueryArtikel.FieldByName('Bezeichnung').AsString;
// // 23.07.2010 BW: Set Counter to 1
// FieldbyName('Zaehler').AsInteger := PMultiplier;
// // check if there is a side order obligation on the selected article
// if QueryArtikel.FieldByName('MussBeilagen').AsInteger = 2 then
// // ='Beilagenpflicht Zwang'
// FieldByName('Beilagenabfrage').AsString := '!'
// // sign the article, that the user must add a side order
// else
// FieldByName('Beilagenabfrage').AsString := '';
// // unsign the article (normal status)
//
// Post;
// end;
// end;
//
// // add article to CDSHilfKonto
// for I := 0 to PMultiplier - 1 do
// AddTableAccountEntry(CDSHilfKonto, PTargetAccount,
// PTargetAccount.FieldbyName('TischKontoID').Asinteger, 1);
// end;
//
// procedure TDataPos.AddSideOrder(PTargetAccount: TDataSet;
// PTableAccountID, PSideOrderID: Integer);
// var
// AArticleID, ASideOrderCounter, ANewTableAccountID, ARecNoOfLastSideOrder, I,
// ARecNo, ARecordCount: Integer;
// begin
// // check if selected side order exists in kasse.gdb
// with TableBeilagen do
// begin
// Close;
// Open;
// if not TableBeilagen.Locate('Firma;BeilagenID',
// VarArrayOf([pGl.Firma, PSideOrderID]),[])then
// begin
// Logger.info(inttostr(FSerialNumber)+': '+
// IvDictio.Translate('Beilage nicht gefunden!'));
// Exit;
// end;
// end;
//
// // get ArticleID of selected table account entry
// AArticleID := GetOrderman(FSerialNumber)
// .FDataBase.GetArticleIDbyTableAccountID(PTargetAccount, PTableAccountID);
//
// with PTargetAccount do
// begin
// // 06.12.2010 BW
// // close;
// // Open;
// // check if selected table account is article and entry is new, because tallied and printed articles CANNOT change/add side order
// if(AArticleID > 0)and(Locate('Firma;TischkontoID;Gedruckt',
// VarArrayOf([pGl.Firma, PTableAccountID, 'F']),[]))then
// begin
//
// // 07.04.2011 BW: check if the article of the just added side order is not "deleted" (amount = 0)
// if Fieldbyname('Menge').Asfloat = 0 then
// Exit;
//
// // unsign side order obligation of the article of the just added side order
// Edit;
// FieldByName('Beilagenabfrage').AsString := '';
// Post;
//
// // go to last side order of the selected table account entry or stay at the selected table account if there are no side orders
// Next;
// while(FieldbyName('ArtikelID').Isnull and not EOF)do
// Next;
// if not EOF then
// Prior;
// // store recordnumber of last side order
// ARecNoOfLastSideOrder := RecNo;
//
// // check how many side orders the current table account entry has got
// ASideOrderCounter := 0;
// if not FieldByName('BeilagenID1').Isnull then
// Inc(ASideOrderCounter);
// if not FieldByName('BeilagenID2').Isnull then
// Inc(ASideOrderCounter);
// if not FieldByName('BeilagenID3').Isnull then
// Inc(ASideOrderCounter);
//
// // check if side order belongs to new table account entry or add to last side order (table account entry)
// if((PSideOrderID < 0)// modifier ('statt', weniger', ...)
// or(ASideOrderCounter = 0)// first side order
// or((ASideOrderCounter > 0)and(Fieldbyname('BeilagenID1').Asinteger >= 0)
// )// if last side order begins with NO modifier
// or((ASideOrderCounter > 1)and(Fieldbyname('BeilagenID1').Asinteger <>-6)
// )// if last side order begins with NO modifier is 'statt' (id -6) and there are already two side orders
// or(ASideOrderCounter > 2)
// // all three possible side orders are already filled out
// )then
// begin
// // new table account entry
//
// // fetch new generator id for new table account entry
// // if target account is CDSHilfKonto, then do not fetch a new generator id from db, but take the table account id from CDSKonto
// if PTargetAccount = CDSHilfKonto then
// ANewTableAccountID := CDSKonto.FieldByName('TischKontoID').Asinteger
// else
// ANewTableAccountID := GetGeneratorID('GEN_TISCHKONTO', 1);
// // 06.12.2010 BW: use own function instead of DBase.GetGeneratorID because of speed optimization
//
// // fetch new generator ids for all following table account entries in order to stick them AFTER the new table account entry
// Next;
// ARecordCount := Recordcount;
// for I := ARecNoOfLastSideOrder + 1 to ARecordCount do
// begin
// ARecNo := RecNo;
// // Workaround for Post and Order by TischKontoID problem, because after the Post, the db cursor stands at the just changed entry at the end of the query!!!
// Edit;
// // if target account is CDSHilfKonto, then do not fetch a new generator id from db, but take the table account id from CDSKonto
// if PTargetAccount = CDSHilfKonto then
// begin
// CDSKonto.Next;
// FieldByName('TischkontoID').AsInteger :=
// CDSKonto.FieldByName('TischKontoID').Asinteger;
// end
// else
// FieldByName('TischkontoID').AsInteger :=
// GetGeneratorID('GEN_TISCHKONTO', 1);
// // 06.12.2010 BW: use own function instead of DBase.GetGeneratorID because of speed optimization
// Post;
// RecNo := ARecNo;
// // Next Workaround --> this solution goes to the "next" entry
// end;
//
// // insert new table account entry
// Append;
// FieldByName('OffeneTischID').AsInteger := TableOffeneTische.FieldByName
// ('OffeneTischID').AsInteger;
// FieldByName('Firma').AsInteger := pGl.Firma;
// FieldByName('Gedruckt').AsString := 'F';
// FieldByName('KellnerID').AsInteger := FWaiterID;
// FieldByName('KasseID').AsInteger := FKasseID;
// FieldByName('Datum').AsDateTime := pgl.datum;
// FieldByName('BeilagenID1').AsInteger := PSideOrderID;
// // 29.07.2010 BW: take description from table BEILAGEN
// FieldByName('LookArtikel').Value := TableBeilagen.FieldByName
// ('Bezeichnung').Value;
// FieldByName('Menge').Value := Null;
// FieldByName('Verbucht').AsString := 'T';
// // 29.11.2010 BW: 'Verbucht' is always true because false is only important if you make instant stock withdrawal without closing table
// FieldByName('Beilagenabfrage').AsString := '';
// // unsign new side order, because you can only sign articles for side order obligation
// FieldByName('TischkontoID').AsInteger := ANewTableAccountID;
// // 05.08.2010 BW: take stored string by FormFreeTextInput for 'BeilagenText', if side order is free text input (id = -1)
// // and take the free text input for description!
// if PSideOrderID =-1 then
// begin
// FieldByName('BeilagenText').AsString := FFreeTextInput;
// FieldByName('LookArtikel').Value := FFreeTextInput;
// end;
// Post;
// end
// else
// begin
// // add to last side order (table account entry)
// Edit;
// FieldByName('BeilagenID' + Inttostr(ASideOrderCounter + 1)).Asinteger :=
// PSideOrderID;
// // 29.07.2010 BW: take description from table BEILAGEN and concat it to the current description
// FieldByName('LookArtikel').AsString :=
// Concat(FieldByName('LookArtikel').AsString, ' ',
// TableBeilagen.FieldByName('Bezeichnung').AsString);
// Post;
// end;
//
// // modify the price of the article of the just added side order (field 'PreisPlus' and 'PreisMinus')
// ModifyPricebySideOrder(PTargetAccount, ASideOrderCounter + 1);
//
// end;
// end;
// end;
//
// procedure TDataPos.MoveArticleFromAccount(PTableAccountId: Integer;
// PFactor: Integer);
// begin
//
// if RemoveTableAccountEntry(CDSKonto, CDSHilfKonto, PTableAccountID, PFactor)
// then
// AddTableAccountEntry(CDSHilfKonto, CDSKonto, PTableAccountID, 1);
//
// end;
//
// procedure TDataPos.MoveArticleToAccount(PTableAccountId: Integer;
// PFactor: Integer);
// begin
//
// if RemoveTableAccountEntry(CDSHilfKonto, CDSKonto, PTableAccountID,-1)then
// AddTableAccountEntry(CDSKonto, CDSHilfKonto, PTableAccountID, PFactor);
//
// end;
//
// procedure TDataPos.AddTableAccountEntry(PTargetAccount, PSourceAccount
// : TDataSet; PTableAccountId: Integer; PFactor: Integer);
// begin
//
// with PSourceAccount do
// begin
// // 06.12.2010 BW
// // close;
// // open;
// Locate('Firma; TischKontoID;', VarArrayOf([pGl.Firma, PTableAccountID]),[]);
// end;
//
// with PTargetAccount do
// begin
// // 06.12.2010 BW
// // close;
// // open;
// if Locate('TischKontoID;Firma', VarArrayOf([PTableAccountID, pGl.Firma]),[])
// then
// begin
// UpdateTableAccountEntryIntoAccount(PTargetAccount,
// PTableAccountID, PFactor);
// end
// else
// begin
// InsertTableAccountEntryIntoAccount(PTargetAccount, PSourceAccount,
// PTableAccountID, 1);
// end;
// end;
//
// end;
//
// function TDataPos.RemoveTableAccountEntry(PTargetAccount, PSourceAccount
// : TDataSet; PTableAccountId: Integer; PFactor: Integer): Boolean;
// begin
// Result := False;
// with PTargetAccount do
// begin
// // 06.12.2010 BW
// // close;
// // open;
// if Locate('Firma; TischKontoID', VarArrayOf([pGl.Firma, PTableAccountID]),[])
// then
// begin
// // check if it is tally or if amount is not 0, because negative selections are not allowed!
// if((PFactor = 1)or(FieldByName('Menge').AsInteger <> 0))then
// // 25.11.2010 BW: field amount has to be AsInteger in order to forbid selections on 0,3
// begin
// // check if it is a article or side order --> side orders are not allowed to be moved between CDS accounts!!!
// if not FieldByName('ArtikelID').Isnull then
// begin
// // 24.11.2010 BW: check if it is a tally and table account entry is NOT new and price has changed since the last tally
// if((PFactor = 1)and Fieldbyname('Gedruckt').Asboolean and
// CheckPriceChanged(PTargetAccount))then
// begin
// Logger.info(inttostr(FSerialNumber)+': '+
// IvDictio.Translate('Erhöhen von')+ ' ' +
// GetLogInfoArticlebyArticleID(PTargetAccount.Fieldbyname
// ('ArtikelID').Asinteger)
// + ' ' + IvDictio.Translate
// ('aufgrund von Preisänderung NICHT möglich!'));
// // just add the article and make a NEW table account entry
// GetOrderman(FSerialNumber).FcurrentForm.DoAddArticle
// (FieldByName('ArtikelID').AsInteger, 1, False)
// end
// else
// begin
// UpdateTableAccountEntryIntoAccount(PTargetAccount,
// PTableAccountID, PFactor);
// Result := True;
// end;
// end;
// end;
// end;
// end;
// end;
//
// procedure TDataPos.RemoveAllTableAccountEntries(PAccount: TDataSet);
// begin
// with PAccount do
// begin
// Close;
// Open;
// while not EOF do
// begin
// Edit;
// FieldbyName('Menge').Asfloat := 0;
// Post;
// Next;
// end;
// end;
// end;
//
// procedure TDataPos.InsertTableAccountEntryIntoAccount(PTargetAccount,
// PSourceAccount: TDataSet; PTableAccountID: Integer; PAmount: Double);
// begin
//
// // do not insert entries with amount 0!
// if not(PAmount = 0)then
// begin
// with PTargetAccount do
// begin
// // 14.12.2010 BW:
// // close;
// // open;
// Append;
// FieldByName('I_DeviceGuid').Value := PSourceAccount.FieldByName
// ('I_DeviceGuid').Value;
// FieldByName('TischKontoID').Value := PSourceAccount.FieldByName
// ('TischKontoID').Value;
// FieldByName('OffeneTischID').Value := PSourceAccount.FieldByName
// ('OffeneTischID').Value;
// FieldByName('Gedruckt').Value := PSourceAccount.FieldByName
// ('Gedruckt').Value;
// FieldByName('ArtikelID').Value := PSourceAccount.FieldByName
// ('ArtikelID').Value;
// FieldByName('Betrag').Value := PSourceAccount.FieldByName('Betrag').Value;
// FieldByName('BeilagenID1').Value := PSourceAccount.FieldByName
// ('BeilagenID1').Value;
// FieldByName('BeilagenID2').Value := PSourceAccount.FieldByName
// ('BeilagenID2').Value;
// FieldByName('BeilagenID3').Value := PSourceAccount.FieldByName
// ('BeilagenID3').Value;
// FieldByName('BeilagenText').Value := PSourceAccount.FieldByName
// ('BeilagenText').Value;
// FieldByName('Status').Value := PSourceAccount.FieldByName('Status').Value;
// FieldByName('Verbucht').Value := PSourceAccount.FieldByName
// ('Verbucht').Value;
// FieldByName('GangID').Value := PSourceAccount.FieldByName('GangID').Value;
// // 04.11.2010 BW: check if table account entry is no side order --> side orders must not have an amount!
// if not PSourceAccount.FieldByName('ArtikelID').Isnull then
// FieldByName('Menge').AsFloat := PAmount;
// FieldByName('Firma').Value := pGl.Firma;
// // 05.02.2015 KL: TODO: hier wird beim Umbuchen der aktuelle Kellner übernommen
// FieldByName('KellnerID').Value := FWaiterID;
// FieldByName('KasseID').Value := FKasseID;
// FieldByName('Datum').Value := pgl.datum;
//
// // if target account is a CDS --> change counter by amount
// // and insert name of article in LookArtikel and
// // and insert BeilagenAbfrage
// if ClassType = TClientDataSet then
// begin
// // if target account is a CDS and source account is a table --> set counter to null
// // and do not insert BeilagenAbfrage, because this field does not exist in tables
// if(not(PSourceAccount.ClassType = TClientDataSet))then
// FieldByName('Zaehler').Value := Null
// else
// begin
// // 17.11.2010 BW: only set counter and beilagenabfrage if it is NO side order!!!
// if not PSourceAccount.FieldByName('ArtikelID').Isnull then
// begin
// FieldByName('Zaehler').AsInteger := Trunc(PAmount);
// FieldByName('BeilagenAbfrage').Value :=
// PSourceAccount.FieldByName('BeilagenAbfrage').Value;
// end;
// end;
//
// FieldByName('LookArtikel').Value := PSourceAccount.FieldByName
// ('LookArtikel').Value;
// end
// // if target account is a table --> set 'Gedruckt' for printing Bons
// else
// begin
// // if target account is table TISCHKONTO --> set 'Gedruckt' to true, because printpackage prints Bons out of table Hilf_TischKonto
// // and therefore does not set this field to true in table TischKonto
// if PTargetAccount = QueryTableAccount then
// FieldByName('Gedruckt').AsString := 'T'
// else
// // if target account is table HILF_TISCHKONTO
// begin
// // check which is the current Form
// // FormTable, ... Tally (DoDruckeBon(daEinzelBon) only prints articles that have 'Gedruckt' = False)
// // every other Form ... Reversal (DoDruckeBon(daStornoBon) only prints articles that have 'Gedruckt' = True)
// // ATTENTION: this is a simple workaround --> problem must be fixed otherwise (e.g.: in the print package)
// // 25.02.2011 BW: same for field 'Verbucht' in order to make a proper stock withdrawal after tally articles/sideorders
// if(GetOrderman(FSerialNumber).GetcurrentForm = FormTable)then
// begin
// FieldByName('Gedruckt').AsString := 'F';
// FieldByName('Verbucht').AsString := 'F';
// end
// else
// begin
// FieldByName('Gedruckt').AsString := 'T';
// FieldByName('Verbucht').AsString := 'T';
// end;
// end;
// end;
// Post;
// end;
// end;
//
// // check if article has side orders and insert them also
// with PSourceAccount do
// begin
// Next;
// while((FieldByName('ArtikelID').IsNull)and(not EOF))do
// begin
// // do not insert side orders of articles with amount 0!
// if not(PAmount = 0)then
// InsertTableAccountEntryIntoAccount(PTargetAccount, PSourceAccount,
// FieldbyName('TischKontoID').Asinteger, 1);
// Next;
// end;
// if not EOF then
// Prior;
// end;
// end;
//
// procedure TDataPos.UpdateTableAccountEntryIntoAccount(PTargetAccount: TDataSet;
// PTableAccountID: Integer; PAmount: Double);
// var
// AOldAmount: Double;
// AIsLastRec: Boolean;
// begin
//
// // do not update entries with change amount 0!
// if PAmount = 0 then
// Exit;
//
// with PTargetAccount do
// begin
// Close;
// Open;
// if Locate('Firma;TischKontoID', VarArrayOf([pGl.Firma, PTableAccountID]),[])
// then
// begin
// Edit;
// // 04.11.2010 BW: store old amount
// AOldAmount := FieldByName('Menge').AsFloat;
// // change amount by amount
// FieldByName('Menge').AsFloat := FieldByName('Menge').AsFloat + PAmount;
/// / //mark entry to "amount has been changed"
/// / FieldByName('Gedruckt').AsString := 'F';
// // if target account is a CDS --> change counter by amount and set side order amount (visibility in hermes line)
// if ClassType = TClientDataSet then
// begin
// FieldbyName('Zaehler').AsInteger := FieldbyName('Zaehler').AsInteger +
// Trunc(PAmount);
// Post;
// // 04.11.2010 BW: if a decrease of an article goes to 0 --> set its side orders also to amount = 0 in order to hide the table account entries in hermes lists
// if FieldByName('Menge').AsFloat = 0 then
// begin
// Next;
// // go through all possible side orders
// while((FieldByName('ArtikelID').Isnull)and(not EOF))do
// begin
// Edit;
// Fieldbyname('Menge').AsFloat := 0;
// Post;
// Next;
// end;
// end
// else
// // 04.11.2010 BW: if an increase of an article goes from 0 to x --> set its side orders to amount = NULL in order to show the table account entries in hermes lists
// if AOldAmount = 0 then
// begin
// Next;
// // go through all possible side orders
// while((FieldByName('ArtikelID').Isnull)and(not EOF))do
// begin
// Edit;
// Fieldbyname('Menge').Value := Null;
// Post;
// Next;
// end;
// end
// // 04.11.2010 BW: end
// end
// else
// // if target account is a Table (TISCHKONTO) --> delete whole entry incl. side orders, if a decrease goes to 0
// // do not delete if it is a CDS in order to leave the 0 entry for countermanding selection
// begin
// Post;
// if FieldByName('Menge').AsFloat = 0 then
// begin
// // check if this is the last record, because after delete last record, cursor stands at the record before and not at EOF!!!
// AIsLastRec := RecNo = Recordcount;
// Delete;
// // go through all possible side orders and delete them too
// while((FieldByName('ArtikelID').Isnull)and(not EOF)and
// (not AIsLastRec))do
// begin
// // check if this is the last record, because after delete last record, cursor stands at the record before and not at EOF!!!
// AIsLastRec := RecNo = Recordcount;
// Delete;
// end;
// end;
// end;
// end;
// end;
//
// end;

function TDataPos.CheckPriceChanged(PTargetAccount: TDataSet): Boolean;
begin
  Result := False;
  with QueryArtikel do
  begin
    Close;
    ParamByName('pFirma').AsInteger := PGl.Firma;
    ParamByName('ArtikelID').AsInteger := PTargetAccount.FieldByName
      ('ArtikelID').AsInteger;
    Open;
    if RecordCount > 0 then
      // check if it is NOT an article, which the user has to input an individual price because this one is always different
      if ((FieldByName('MengePreis').AsString <> 'P') and
        (FieldByName('MengePreis').AsString <> 'B')) then
        Result := PTargetAccount.FieldByName('Betrag').AsFloat <>
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

  if APrice = NULL then
    APrice := QueryArtikel.FieldByName('Preis1').Value;

  // 31.08.2010 BW: is aPrice still NULL than take 0 because NULL cannot be converted to datatype float ( or currency)
  if APrice = NULL then
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
    if Locate('Firma;TischKontoID', VarArrayOf([PGl.Firma, PTableAccountID]), [])
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

/// / this function is copied from GKT TDataTische.AddBeilagenpreis
// procedure TDataPos.ModifyPricebySideOrder(PTargetAccount: TDataSet;
// PSideOrderCounter: Integer);
// var ABookMark: TBookMark;
// APreisMinus, APreisPlus: Boolean;
// ABetrag, AOldBeilagenPreis: Variant;
// // 0 = kein
// // 1 = statt abziehen (beilagen1)
// // 2 = statt dazuaddieren (beilagen2)
// AStatt: Integer;
// begin
// if(TableBeilagen.FieldByName('PreisPlus').AsFloat <> 0)or
// (TableBeilagen.FieldByName('PreisMinus').AsFloat <> 0)or
// (Gl.BeilagenPreisTabelle)or
// (not TableBeilagen.FieldByName('PreisEbene').IsNull)then
// with PTargetAccount do
// begin
// ABookMark := GetBookmark;
//
// APreisMinus := FieldByName('BeilagenID1').AsInteger =-3;
//
// // Preis PLus entweder immmer, oder nur bei "mit"
// APreisPlus :=(Gl.BeilagenPreisImmerMit or
// (FieldByName('BeilagenID1').AsInteger =-2))and not// immer bei mit
// (FieldByName('BeilagenID1').AsInteger =-6)and not// nicht bei statt
// (FieldByName('BeilagenID1').AsInteger =-5); // nicht bei weniger
//
// if(FieldByName('BeilagenID1').AsInteger =-6)and(PSideOrderCounter > 1)then
// begin
// if PSideOrderCounter = 2 then
// begin
// APreisMinus := TRUE;
// AStatt := 1
// end
// else
// if PSideOrderCounter = 3 then
// begin
// APreisPLus := TRUE;
// AStatt := 2;
// end;
// end
// else
// AStatt := 0;
//
// ABetrag := 0;
// // bei "ohne", dann PreisMinus!
// if APreisMinus then
// begin
// ABetrag := TableBeilagen.FieldByName('PreisMinus').AsFloat;
// if AStatt = 1 then
// AOldBeilagenPreis := ABetrag;
// end
// else
// if APreisPlus then
// begin
// if AStatt = 2 then
// begin
// ABetrag := TableBeilagen.FieldByName('PreisPlus').AsFloat;
// // Der Stattpreis darf den Gesamtwert nicht verringern
// if Abs(AOldBeilagenPreis)> ABetrag then
// ABetrag := Abs(AOldBeilagenPreis);
// end
// else
// ABetrag := TableBeilagen.FieldByName('PreisPlus').AsFloat;
// end;
// // bis zum Artikel zurückgehen;
// while FieldByName('ArtikelID').IsNull and not BOF do
// Prior;
//
// if not TableBeilagen.FieldByName('PreisEbene').IsNull then
// begin
// case TableBeilagen.FieldByName('PreisEbene').AsInteger of
// 1 .. 30:
// ABetrag := QueryArtikel.FieldByName
// ('Preis' + IntToStr(TableBeilagen.FieldByName('PreisEbene')
// .AsInteger)).Value;
// end; { end of CASE }
//
// if ABetrag = Null then
// ABetrag := QueryArtikel.FieldByName('Preis1').AsFloat;
// ABetrag := ABetrag - FieldByName('Betrag').AsFloat;
// end;
//
// if ABetrag <> 0 then
// begin
// ABetrag := ABetrag; // * FieldByName('Menge').AsFloat;
// Edit;
// FieldbyName('Betrag').AsFloat := FieldByName('Betrag').AsFloat
// + ABetrag;
// Post;
// end;
// GotoBookMark(ABookMark);
// FreeBookMark(ABookMark);
// end;
// end;
//
// function TDataPos.GetArticleIDbyTableAccountID(PTargetAccount: TDataSet;
// PTableAccountID: Integer): Integer;
// begin
// Result :=-1;
// with PTargetAccount do
// begin
// // 06.12.2010 BW:
// // close;
// // open;
// if Locate('Firma;TischKontoID', VarArrayOf([pGl.Firma, PTableAccountID]),[])
// then
// Result := Fieldbyname('ArtikelID').Asinteger;
// end;
// end;

function TDataPos.GetFertigeSpeisen(PWaiterID: Integer): string;
begin
  Result := '';
  if PWaiterID = 0 then
    Exit;

  with QueryGetFertigeSpeisen do
  begin
    Close;
    ParamByName('KellnerID').AsInteger := PWaiterID;
    Open;
    if not EOF then
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

function TDataPos.ConfirmFertigeSpeisen(PWaiterID: Integer): string;
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
  Result := -1;
  with QueryGetOpenTableIDbyTableID do
  begin
    Close;
    ParamByName('pFirma').AsInteger := PGl.Firma;
    ParamByName('pTischID').AsInteger := PTableID;
    ParamByName('pDatum').Asdate := PGl.Datum;
    Open;
    if RecordCount > 0 then
      Result := FieldByName('OffeneTischID').AsInteger;
  end;
end;

function TDataPos.GetTableNumberbyTableID(PTableID: Integer): string;
begin
  Result := '';
  with TableTisch do
  begin
    if Locate('TischID;Firma', VarArrayOf([PTableID, PGl.Firma]), []) then
      Result := Trim(FieldByName('TischNR').AsString);
  end;
end;

function TDataPos.GetTableIDbyTableName(PTablename: string): Integer;
begin
  Result := 0;
  with TableTisch do
  begin
    if Locate('Bezeichnung;Firma', VarArrayOf([PTablename, PGl.Firma]), []) then
      if FieldByName('Bezeichnung').AsString = PTablename then
        Result := FieldByName('TischID').AsInteger;
  end;
end;

function TDataPos.GetGuestNamebyReservId(PReservID: Integer): string;
begin
  Result := '';

  if PGl.HotelProgrammTyp = HpHotelFelix then
    with QueryReservFELIX do
    begin
      Close;
      ParamByName('pFirma').AsInteger := PGl.Firma;
      ParamByName('pID').AsInteger := PReservID;
      Open;
      if not EOF then
        Result := Trim(FieldByName('Gastname').AsString);
    end
  else if PGl.HotelProgrammTyp = HpAllgemeinSQL then
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
    Result := (not EOF) and (FieldByName('CheckIn').AsBoolean);
  end;
end;

function TDataPos.GetTablenumber: string;
begin
  Result := '';
  with TableTisch do
  begin
    // 06.12.2010 BW:
    Close;
    Open;
    if Locate('Firma;TischID', VarArrayOf([PGl.Firma, FTableID]), []) then
      Result := Trim(FieldByName('TischNR').AsString);
  end;
end;

function TDataPos.GetTableDescriptionbyTableID(PTableID: Integer): string;
begin
  Result := '';
  with TableTisch do
  begin
    // 06.12.2010 BW:
    // close;
    // open;
    if Locate('Firma;TischID', VarArrayOf([PGl.Firma, PTableID]), []) then
      Result := Trim(FieldByName('Bezeichnung').AsString);
  end;
end;

function TDataPos.GetTableDescription: string;
begin
  Result := '';
  with TableTisch do
  begin
    // 06.12.2010 BW:
    Close;
    Open;
    if Locate('Firma;TischID', VarArrayOf([PGl.Firma, FTableID]), []) then
      Result := Trim(FieldByName('Bezeichnung').AsString);
  end;
end;

function TDataPos.GetTableTypeAbbreviationbyTableID(PTableID: Integer): string;
begin
  Result := '';
  with TableTisch do
    if Locate('Firma;TischID', VarArrayOf([PGl.Firma, PTableID]), []) then
      Result := Trim(FieldByName('Tischtyp').AsString);
end;

function TDataPos.GetWaiterName: string;
begin
  Result := '';
  with QueryWaiter do
    if Locate('Firma; KellnerID', VarArrayOf([PGl.Firma, FWaiterID]), []) then
      Result := Trim(Trim(FieldByName('Vorname').AsString) + ' ' +
        Trim(FieldByName('Nachname').AsString));
end;

function TDataPos.GetLoginName: string;
begin
  Result := '';
  with QueryWaiter do
    if Locate('Firma; KellnerID', VarArrayOf([PGl.Firma, FWaiterID]), []) then
      Result := Trim(FieldByName('Loginname').AsString);
end;

function TDataPos.GetLoginNamebyWaiterID(PWaiterID: Integer): string;
begin
  Result := '';
  with QueryWaiter do
    if Locate('Firma;KellnerID', VarArrayOf([PGl.Firma, PWaiterID]), []) then
      Result := Trim(FieldByName('Loginname').AsString);
end;

function TDataPos.GetWaiterNamebyWaiterID(PWaiterID: Integer): string;
begin
  Result := '';
  with QueryWaiter do
    if Locate('Firma;KellnerID', VarArrayOf([PGl.Firma, PWaiterID]), []) then
      Result := Trim(Trim(FieldByName('Vorname').AsString) + ' ' +
        Trim(FieldByName('Nachname').AsString));
end;

function TDataPos.GetStationName: string;
begin
  Result := '';
  with QueryReviere do
  begin
    Close;
    Open;
    if Locate('ID', VarArrayOf([FStationID]), []) then
      Result := Trim(FieldByName('Name').AsString);
  end;
end;

function TDataPos.GetPaymentMethodName: string;
begin
  Result := '';
  with QueryZahlweg do
  begin
    Close;
    ParamByName('Firma').AsInteger := PGl.Firma;
    Open;
    if Locate('ID', VarArrayOf([FPrint_PaymentMethodID]), []) then
      Result := Trim(FieldByName('Bezeichnung').AsString);
  end;
end;

// function TDataPos.GetSideOrderListName:string;
// var
// AArticleID: Integer;
// begin
// Result := 'S100'; // standard empty list ('KEINE')
// AArticleID := GetArticleIDbyTableAccountID(CDSKonto, FTableAccountID);
// with QueryArtikel do
// begin
// Close;
// Parambyname('pFirma').Asinteger := pGl.Firma;
// Parambyname('ArtikelID').Asinteger := AArticleID;
// Open;
// if Recordcount > 0 then
// Result := 'S' + Inttostr(100 + Fieldbyname('BeilagenGruppeID').Asinteger);
// end;
// end;
//
// function TDataPos.GetSideOrderIDbyTableAccountID(PTableAccountID
// : Integer): Integer;
// var
// AArticleID: Integer;
// begin
// Result := 0; // standard empty list ('KEINE')
// AArticleID := GetArticleIDbyTableAccountID(CDSKonto, PTableAccountID);
// with QueryArtikel do
// begin
// Close;
// Parambyname('pFirma').Asinteger := pGl.Firma;
// Parambyname('ArtikelID').Asinteger := AArticleID;
// Open;
// if Recordcount > 0 then
// Result := Fieldbyname('BeilagenGruppeID').Asinteger;
// end;
// end;
//
// function TDataPos.GetAccountTotal(PAccount: TDataSet): Double;
// var
// ABetragAsCurr: Currency;
// ABetrag, AMenge, AProdukt, ATotal: Double;
// begin
// Result := 0;
// ATotal := 0;
// with PAccount do
// begin
// Close;
// Open;
// while not EOF do
// begin
// // don't mix currency with float!
// ABetragAsCurr := FieldbyName('Betrag').AsCurrency;
// ABetrag := ABetragAsCurr;
// AMenge := FieldbyName('Menge').AsFloat;
// AProdukt := ABetrag * AMenge;
// ATotal := ATotal + AProdukt;
// // original source code below has been replaced by KL with source code above!
// // aTotal := aTotal + FieldbyName('Betrag').AsCurrency * FieldbyName('Menge').AsFloat;
// Next;
// end;
// Result := RoundDouble(ATotal); // KL: kaufmänn. runden
// end;
// end;

function TDataPos.GetLogInfoTablebyTableID(PTableID: Integer): string;
begin
  Result := '';
  with TableTisch do
  begin
    // 06.12.2010 BW:
    // close;
    // open;
    if Locate('Firma;TischID', VarArrayOf([PGl.Firma, PTableID]), []) then
      Result := IvDictio.Translate('Tisch') + ' ' +
        Trim(FieldByName('TischNR').AsString) + ' ' +
        IvDictio.Translate('mit der ID') + ' ' + IntToStr(PTableID);
  end;
end;

function TDataPos.GetLogInfoArticlebyArticleID(PArticleID: Integer): string;
begin
  Result := '';
  with QueryArtikel do
  begin
    Close;
    ParamByName('pFirma').AsInteger := PGl.Firma;
    ParamByName('ArtikelID').AsInteger := PArticleID;
    Open;
    if RecordCount > 0 then
      Result := IvDictio.Translate('Artikel') + ' ' +
        Trim(FieldByName('Bezeichnung').AsString) + ' ' +
        IvDictio.Translate('mit der ID') + ' ' +
        IntToStr(FieldByName('ArtikelID').AsInteger);
  end;
end;

function TDataPos.GetLogInfoSideOrderbySideOrderID(PSideOrderID
  : Integer): string;
begin
  Result := '';
  with TableBeilagen do
  begin
    // 06.12.2010 BW:
    // close;
    // open;
    if Locate('Firma;BeilagenID', VarArrayOf([PGl.Firma, PSideOrderID]), [])
    then
      Result := IvDictio.Translate('Beilage') + ' ' +
        Trim(FieldByName('Bezeichnung').AsString) + ' ' +
        IvDictio.Translate('mit der ID') + ' ' +
        IntToStr(FieldByName('BeilagenID').AsInteger);
  end;
end;

function TDataPos.GetLogInfoWaiterbyWaiterID(PWaiterID: Integer): string;
begin
  Result := '';
  with QueryWaiter do
    if Locate('Firma;KellnerID', VarArrayOf([PGl.Firma, PWaiterID]), []) then
      Result := IvDictio.Translate('Kellner') + ' ' +
        Trim(Trim(FieldByName('Vorname').AsString) + ' ' +
        Trim(FieldByName('Nachname').AsString)) + ' ' +
        IvDictio.Translate('mit der ID') + ' ' + IntToStr(PWaiterID);
end;

function TDataPos.GetMobilePrinterNamebyPrinterID(PPrinterID: Integer): string;
begin
  Result := '';
  with TableDrucker do
  begin
    Close;
    Open;
    if Locate('DruckerID', PPrinterID, []) then
      Result := Trim(FieldByName('Bezeichnung').AsString);
  end;
end;

end.
