unit TempModul;

interface

uses
  System.SysUtils, System.Classes, System.Variants,
  FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.UI.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Phys, FireDAC.VCLUI.Wait, FireDAC.Phys.FB,
  FireDAC.Phys.FBDef;

type
  TTM = class(TDataModule)
    QueryGetOpenTable: TFDQuery;
    QueryFelix: TFDQuery;
    TableKassa: TFDTable;
    TableKassaZahlweg: TFDTable;
    QueryUpdateKassaZahlweg: TFDQuery;
    QueryGetZahlwegBar: TFDQuery;
    TransactionDiverses2: TFDTransaction;
    QuerySetKassenbuch: TFDQuery;
    QueryGetKassenbuch: TFDQuery;
    TableDiverses: TFDTable;
    TableDiverses2: TFDTable;
    insertGastkonto: TFDQuery;
    QueryLeistung: TFDQuery;
    QueryTabMWST: TFDQuery;
    QueryInsertKassenjournal: TFDQuery;
    QueryArrangementLeistungen: TFDQuery;
    QueryDoSomething: TFDQuery;
    insertGKonto: TFDQuery;
    QueryCheckLosungKellner: TFDQuery;
    QueryUpdateReservierung: TFDQuery;
    QueryCheckReservierung: TFDQuery;
    QueryGetGastData: TFDQuery;
    QueryUpdateGaestestamm: TFDQuery;
    TableLosungsZuordnung: TFDTable;
    TableRechZahlweg: TFDTable;
    TableKreditOffen: TFDTable;
    TableUmsatzzuordnung: TFDTable;
    TableRechnung: TFDTable;
    TableRechnungsKonto: TFDTable;
    TableZahlweg: TFDTable;
    TableArrangement: TFDTable;
    QueryUniqueNr: TFDQuery;
    QueryGastInfo: TFDQuery;
    QueryProcGastkontoRechnung: TFDQuery;
    FDStoredProcGastKontoRechnung: TFDStoredProc;
    QueryGetTableIdFromReservId: TFDQuery;
    QueryInsertKass_KassenArchiv: TFDQuery;
    QueryGetKassIdIsSaved: TFDQuery;
    QueryTemp: TFDQuery;
    QueryAnlage: TFDQuery;
    StoredProcBOOK_RESTAURANTVALUEEXTERN: TFDStoredProc;
    QueryUpdateOrInsertArtikel: TFDQuery;
    QueryUpdateOrInsertKellner: TFDQuery;
    QueryUpdateOrInsertJournalArchiv: TFDQuery;
    TableKassenJournal: TFDTable;
    QueryFirma: TFDQuery;
    QueryInsertSendetMail: TFDQuery;
    QuerySelectErrorSendDate: TFDQuery;
    QueryUpdateOrInsertJournal: TFDQuery;
    QueryDeleteJournal: TFDQuery;
    MainConnection: TFDConnection;
    QueryLookForDoubleBooking: TFDQuery;
    QueryInsertRechnungskonto: TFDQuery;
    QueryGetDoubleBookingInvoice: TFDQuery;
    QueryUpdateJournalBetrag: TFDQuery;
    QueryIndex: TFDQuery;
    QueryGetGuestsByDate: TFDQuery;
    QueryGetCheckedInGuests: TFDQuery;
    QueryInsertRechnung: TFDQuery;
    QueryInsertRechZahlweg: TFDQuery;
    QueryGetFelixZahlweg: TFDQuery;
    QueryCheckInvoice: TFDQuery;
    QueryGetNextInvoiceNumber: TFDQuery;
    QueryInsertInvoiceForDoubleBooking: TFDQuery;
    QueryInsertKassenjournalDirectInvoice: TFDQuery;
    QueryInsertInvoiceTax: TFDQuery;
    QueryGetAmountOrderByTax: TFDQuery;
    QueryUpdateDIVERSESRECHNR: TFDQuery;
    QueryCheckGuestId: TFDQuery;
    QueryCheckCompanyId: TFDQuery;
    QueryLeistungByName: TFDQuery;
    QueryGetServerSettings: TFDQuery;
  private

    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    function SetKassenBuch(pConnection: TFDConnection;
      pZahlwegID, pErfassungDurch: Variant; pFirma: Integer; pCompanyName: string): Variant;
    function GetBoolean(aStr: String): Boolean;
    function ReadGlobalValue2(pConnection: TFDConnection; FieldName: String;
      ADefault: Variant; aTyp: String): Variant;
    function BetragToFloat(s: string; pCompanyName: string): double;
    function WriteToGastkonto(pConnection: TFDConnection;
      ATischNr, AZimmerNr: string; pAnzahl: Integer; pBetrag: double;
      pMehrwertsteuer: double; pKellnerNr, pReservID, aFirma: Integer;
      ptext, pLog_T: string; isEinzelBuchung, pIsBelegNr: Boolean;
      CompanyName: string; pFelixNachKassen: Boolean; pKasseId: Integer;
      pKassInfoId: string; var errorString: string;
      pBuchungsdatum: String; isExtern: boolean): Boolean;
    function GetFelixDate(pConnection: TFDConnection; pFirma: string;
      CompanyName: string = ''): TDateTime;
    function getCheckID(pConnection: TFDConnection; reserfID: Integer;
      CompanyName: string; pFirma: integer): Integer;
    function getKassInfoIdIsSaved(pConnection: TFDConnection;
      pID: string; pFirma: integer; pCompanyName: string): Boolean;
    function GetGeneratorID(pConnection: TFDConnection; PGenerator: string;
      PInc: Integer; pCompanyName: string): Integer;
    function getLeistIDandBez(pConnection: TFDConnection; pTischNr: Integer;
      pMwSt: double; CompanyName: string; pFelixNachKassen: Boolean;
      pKasseId: Integer; pFirma: Integer; var pLeistId: Integer;
      var pLeistBez: String): Boolean;
    function WriteToGastkontoRechnung(pConnection: TFDConnection;
      pTischNr: string; pTime: TTime; pBetrag, pMehrwertsteuer: double;
      pKellnerNr, pZahlwegID: Integer; ptext: string; pFirma: Integer; pDiscount: double;
      var pResultString: string; pCompanyName: string): Boolean;
    function getLeistungsID1(pConnection: TFDConnection;
      pFirma, pKasseId: Integer; pHauptGruppeID: string): Integer;
    function SetQueryLeistung(pFirma: Integer;
      pLeistungsID: LongInt; var LeistBez : string; pCompanyName: string): Boolean;
    function ReadGlobalValue(pConnection: TFDConnection; FieldName: String;
      ADefault: Variant; aTyp: String): Variant;

    procedure WriteToKassenJournal(pConnection: TFDConnection; pDatum: TDate;
      ARechnungsText: String; AZahlWegID, AMenge, ALeistungsID, AArrangementID,
      pErfassungDurch, AReservID: Variant; ABetrag: double; ANetto: Boolean;
      pFirma: Integer; pMitArbID, pKassaID: LargeInt; pMwSt: Variant; pCompanyName: string);
    procedure getRebookings(pConnection: TFDConnection; pDate: TDateTime;
      pFirma: string; pCompanyName: string);
    procedure setAllRebookingsToNull(pConnection: TFDConnection;
      pDate: TDateTime; pFirma: string);
    procedure WriteToTableRechnungskonto(
      pFirma, pLeistId: Integer; pMenge: Integer; pGesamtbetrag: double;
       pRechId: Int64; pFelixDate: TDate; pLeisungsText : string; pCompanyName: string);
    procedure InsertKreditOffen(pConnection: TFDConnection; pCompanyID: Int64;
      pBetrag: double; pZahlwegID: Int64; pDatum: TDateTime;
      pRechNr, pReservID: Int64; pCompanyName: string);
    procedure WriteLeistungToGastKontoIB(pConnection: TFDConnection;
      pDatum: TDate; pFirma, pMitarbeiterId, pKassaID, ALeistungsID,
      AMenge: LongInt; ABetrag: double; AAufRechnungsAdresse, AFix,
      AInTABSGebucht, InKassenJournal: Boolean;
      ARechnungsText, AStornoGrund: String; AErfassungDurch, AZahlArt,
      AReservID: LongInt; pArrangementID, pVonReservID: Variant; pCompanyName: string);
    function CreateInvoice0(pFelixDate, pCashDDate: TDate; pCompanyId: integer; pCompanyName: string; pLocationId: string = ''): Int64;
    function CheckIndice(PTableName, pColumn, pIndexname: string): Boolean;
    function CheckSalesDoubleBooking(pKassaDate, pFelixDate: TDateTime; pCompanyId: integer;
                 pCompanyName: string; pLocationId: string): boolean;
    function CheckDoubleBookingGegenbuchungKasse(pConnection: TFDConnection; pCompanyName: string;
                    pCompanyId: integer; pBetrag: Double;
                    pLeistId: Int64; pUmsatzDatum: TDateTime; pLocationId: string): boolean;
    function getZahlweg(pCompanyName: string; pFirma : integer; pZahlweg: integer): integer;
    function CheckDoubleBookingInvoice(pCompanyName: string; pCompanyId: integer; pInvoiceId: string): boolean;
    function GetNextInvoiceNumber(pCompanyName: string; pCompanyId: integer): integer;
    function InsertForBookingInvoice(pCompanyName: string; pCompanyId: integer; pInvoiceId: string;
      pRechnungID: LargeInt): boolean;
    function InsertRechnungMwSt(pCompanyName: string; pCompanyId: integer;pInvoiceId: integer): boolean;
    function UpdateDiversRechnungNr(pCompanyName: string; pCompanyId, pInvoiceNumber: integer): boolean;
    function InsertRechnungZahlweg(pCompanyName: string; pCompanyId: integer; pInvoiceId: integer;
                              pDate: TDate; pPaymentMethodId: integer;
                              pAmount: Double;
                              pAlreadyPaid: boolean): boolean;
    function InsertInvoiceJournal(pCompanyName: string; pCompanyId, pInvoiceId, pLeistungsId: integer;
      pTime: TTime;
      pcashDeskId: integer; pAmount: Double; pQuantity, pPaymentMethodId, pErfassungDurch: integer;
      pTax: double; pText: string): boolean;
    function DeleteInvoice(pCompanyName: string; pCompanyId,aInvoiceId: integer): boolean;
    function CheckGuestId(pCompanyName: string; pCpmpanyId, pGuestID: integer): boolean;
    function CheckCompany(pCompanyName: string;pCompanyId: integer): boolean;
    function GetQueryLeistungByName(pFirma: Integer; pCompanyName, pLeistBez: string;
      var pLeistungsID: LongInt): Boolean;
    function GetLeistungByNameOrId(pFirma: Integer; pCompanyName: string; var pLeistBez: string;
      var pLeistungsID: LongInt): Boolean;
  end;

var
  TM: TTM;

implementation

uses {restFelixMainUnit, ServerIntf,} Logging;
{%CLASSGROUP 'Vcl.Controls.TControl'}
{$R *.dfm}

function TTM.CheckIndice(PTableName, pColumn: String; pIndexname: string): Boolean;
var
  aCount: Integer;
begin
  try
    with QueryIndex do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select * from rdb$indices ri');
      SQL.Add('left outer join rdb$index_segments ris on ri.rdb$index_name=ris.rdb$index_name');
      SQL.Add(' where ri.rdb$relation_name=''' + PTableName + '''');
      SQL.Add(' and ris.rdb$field_name =''' + Trim(pColumn) + '''');
      Open;
      if RecordCount = 0 then
      begin
        Close;
        SQL.Clear;

        SQL.Add('CREATE INDEX ' + pIndexname + ' ON ' + PTableName + ' (' + pColumn + ')');

        try
          ExecSQL;
          Result := true;
        except
          begin
            Log.WriteToLog('Admin', 0,'<TTM> Fehler bei Index erstellen für Tabelle ' + PTableName + ' Spalte ' +
              Trim(pColumn));
          end;

        end;
      end;
    end;
  except
    on E: Exception do
    begin
      Result := False;
    end;
  end;
end;

//*****************************************************************
//  Funktion zum Abfangen von Umsatz Doppelbuchungen
//  Überprüft wird in der Tabelle KassenJournal
//*****************************************************************
function TTM.CheckSalesDoubleBooking(pKassaDate, pFelixDate: TDateTime; pCompanyId: integer;
         pCompanyName: string; pLocationId: string): boolean;
begin
  try
    try
      result := false;
      with QueryLookForDoubleBooking do
      begin
        close;
        ParamByName('CompanyId').AsInteger := pCompanyId;
        ParamByName('FelixDate').ASDate := pFelixDate;
//        ParamByName('CashDeskId').ASInteger := pCashDeskId;
        if (pLocationId <> '') then
        begin
          ParamByName('Text').AsString := 'Umsatz Kasse ' + pLocationId + ' | ' + DateToStr(pKassaDate);
        end
        else
        begin
          ParamByName('Text').AsString := 'Umsatz Kasse | ' + DateToStr(pKassaDate);
        end;
        open;
        result := not FieldByName('id').isNull;
      end;
    except on e: Exception do
      begin
        Log.WriteToLog(pCompanyName, pCompanyId,'<TTM> Error in CheckSalesDoubleBooking: ' + e.Message, lmtError);
      end;
    end;
  finally
    QueryLookForDoubleBooking.Close;
  end;
end;

function TTM.WriteToGastkonto(pConnection: TFDConnection;
  ATischNr, AZimmerNr: string; pAnzahl: Integer; pBetrag: double;
  pMehrwertsteuer: double; pKellnerNr, pReservID, aFirma: Integer;
  ptext, pLog_T: string; isEinzelBuchung, pIsBelegNr: Boolean;
  CompanyName: string; pFelixNachKassen: Boolean; pKasseId: Integer;
  pKassInfoId: string; var errorString: string; pBuchungsdatum: String; isExtern: boolean)
  : Boolean;
var
  pfelixDate: TDateTime;
  pFirma: string;
  pZimmer, ALeistBez: string;
  pLeistungsID, tischNr, AleistId, aGastkontoId: Integer;
  aCkeckId, AReservID, bezeichnung, aText, aKassId, MailOut: string;
begin
  Result := False;
  insertGastkonto.Connection := pConnection;
  insertGastkonto.Connection.StartTransaction;
  try
    try

      pLeistungsID := 0;
      if (AZimmerNr <> '') or (pReservID <> 0) then
      begin
        try
          // Um die nullen am Anfang abzuschneiden
          AZimmerNr := IntToStr(StrToInt(AZimmerNr));
        except
        end;
        if aFirma = 0 then
        begin
          pFirma := AZimmerNr[1];
          pZimmer := Copy(AZimmerNr, 2, Length(AZimmerNr));
        end
        else
        begin
          pFirma := IntToStr(aFirma);
          pZimmer := AZimmerNr;
        end;

        pfelixDate := GetFelixDate(pConnection, pFirma, CompanyName); // <-- pfelixDate wird gesetzt
        begin
          // Überprüfen ob Gast eingecheckt ist
          if getCheckID(pConnection, pReservID, CompanyName, StrToInt(pFirma)) <> pReservID then
          begin
            Result := False;
             Log.WriteToLog(CompanyName, StrToInt(pFirma),'<TTM> Schreiben auf Reservierung: ReservID '
              + IntToStr(pReservID) + ' nicht gefunden!');
            // Email
            errorString := 'Schreiben auf Reservierung: ReservID ' +
              IntToStr(pReservID) + ' nicht gefunden!' + #10#13 + ' TischNr: ' +
              ATischNr + '; Menge: ' + IntToStr(pAnzahl) + '; Preis: ' +
              FloatToStr(pBetrag) + '; MWST: ' + FloatToStr(pMehrwertsteuer) +
              '; Text: ' + ptext + '; Belegnummer: ' + trim(pLog_T) +
              '; Firma: ' + pFirma + '; KassInfoId: ' + pKassInfoId +
              '; Datum der Buchung: ' + pBuchungsdatum;

          end
          else
          begin
            if NOT getKassInfoIdIsSaved(pConnection, pKassInfoId, StrToInt(pFirma),CompanyName) then
            begin
              if isExtern then
              begin
                // FremdKassen
                Log.WriteToLog(CompanyName, StrToInt(pFirma),'<TTM> use BOOK_RESTAURANTVALUEEXTERN');
                Log.WriteToLog(CompanyName, StrToInt(pFirma),'<TTM> KassInfoId: ' + pKassInfoId +
                  ' ReservId: ' + IntToStr(pReservID) + ' Zeit: ' +
                  TimeToStr(Time) + ' Text: ' + ptext +'Firma: '+ pFirma + 'Tischnummer: '+ATischNr);

                StoredProcBOOK_RESTAURANTVALUEEXTERN.Connection := pConnection;
                aKassId := pKassInfoId;
                Delete(aKassId, Length(aKassId) - 1, 2);
                if isEinzelBuchung then
                  StoredProcBOOK_RESTAURANTVALUEEXTERN.ParamByName('iText').Value := ptext; // name
                if not isEinzelBuchung then
                  StoredProcBOOK_RESTAURANTVALUEEXTERN.ParamByName('iText').Value := aKassId;  // id

                StoredProcBOOK_RESTAURANTVALUEEXTERN.ParamByName('iLeistung').Value := IntToStr(pKasseId); // cashDId
                StoredProcBOOK_RESTAURANTVALUEEXTERN.ParamByName('iFirma').Value := pFirma;
                StoredProcBOOK_RESTAURANTVALUEEXTERN.ParamByName('iReservId').Value := pReservID; // reservId
                StoredProcBOOK_RESTAURANTVALUEEXTERN.ParamByName('iTime').Value := Time;
                begin   // begin for inline variable
                  var iHasNoQuantity: boolean := false;
                  try   // Abfangen da nicht alle diesen Parameter besitzen
                    StoredProcBOOK_RESTAURANTVALUEEXTERN.ParamByName('iMenge').Value := pAnzahl;  // quantity
                  except on e : Exception do
                    iHasNoQuantity := True;
                  end;
                  if iHasNoQuantity then
                  begin
                    StoredProcBOOK_RESTAURANTVALUEEXTERN.ParamByName('iValue').Value := pBetrag * pAnzahl; //price * quantity
                  end
                  else
                  begin
                    StoredProcBOOK_RESTAURANTVALUEEXTERN.ParamByName('iValue').Value:= pBetrag; //price
                  end;
                end; // end for inline Variable

                StoredProcBOOK_RESTAURANTVALUEEXTERN.ParamByName('iMwst').Value
                  := pMehrwertsteuer;  // taxRate
                StoredProcBOOK_RESTAURANTVALUEEXTERN.ParamByName('IBELEGNUMMER').Value := aKassId;  // Id

                try              // Abfangen da nicht alle diesen Parameter besitzen
                  StoredProcBOOK_RESTAURANTVALUEEXTERN.ParamByName('itischnummer')
                    .Value := ATischNr;  // tableId
                except on e : Exception do
                  Log.WriteToLog(CompanyName, StrToInt(pFirma),'<TTM> No ITischNummer: ' + e.Message);
                end;
                StoredProcBOOK_RESTAURANTVALUEEXTERN.ExecProc;
                AleistId := StoredProcBOOK_RESTAURANTVALUEEXTERN.ParamByName('oResult').AsInteger;
                try
                  aGastkontoId := StoredProcBOOK_RESTAURANTVALUEEXTERN.ParamByName('OGASTKONTOID').AsInteger;
                except on e : Exception do
                  begin
                    aGastkontoId := -1;
                    Log.WriteToLog(CompanyName, StrToInt(pFirma),'<TTM> No OGASTKONTOID: ' + e.Message);
                  end;
                end;
                if aGastkontoId = 0 then
                begin
                   // Wenn ALeistId = 0 dann Fehler beim einfügen
                  Log.WriteToLog(CompanyName, StrToInt(pFirma),'<TTM> Values transmited: ' + VarToStr(Result));
                  if AleistId = 0 then
                  begin
                    Log.WriteToLog(CompanyName, StrToInt(pFirma),'<TTM> '+
                      'Keine LeistungsID oder Bezeichnung gefunden! Möglicherweise ist die MWST nicht hinterlegt! '
                      + #10#13 + 'Es wurde nicht gespeichert');
                    Log.WriteToLog(CompanyName, StrToInt(pFirma),'<TTM> KassenId: ' + IntToStr(pKasseId)
                      + ' MWST: ' + FloatToStr(pMehrwertsteuer), lmtInfo);
                    // Für Email
                    errorString :=
                      'Keine LeistungsID oder Bezeichnung gefunden! Möglicherweise ist die MWST nicht hinterlegt! Es wurde nicht gespeichert';
                  end
                  else
                  begin
                    Log.WriteToLog(CompanyName, StrToInt(pFirma),'<TTM> '+
                      'Es wurde nichts gespeichert. Leider kam von der Procedure BOOK_RESTAURANTVALUEEXTERN keine GastkontoId '
                      + #10#13 + 'Es wurde nicht gespeichert');
                    Log.WriteToLog(CompanyName, StrToInt(pFirma),'<TTM> KassenId: ' + IntToStr(pKasseId)
                      + ' MWST: ' + FloatToStr(pMehrwertsteuer), lmtInfo);
                    // Für Email
                    errorString :=
                      'Leider konnte der Betrag nicht gespeichert werden!'+ #10#13 +
                      'ReservID ' +
                      IntToStr(pReservID) + ' nicht gefunden!' + #10#13 + ' TischNr: ' +
                      ATischNr + '; Menge: ' + IntToStr(pAnzahl) + '; Preis: ' +
                      FloatToStr(pBetrag) + '; MWST: ' + FloatToStr(pMehrwertsteuer) +
                      '; Text: ' + ptext + '; Belegnummer: ' + trim(pLog_T) +
                      '; Firma: ' + pFirma + '; KassInfoId: ' + pKassInfoId +
                      '; Datum der Buchung: ' + pBuchungsdatum;

                  end;
                end;
                if AleistId = 0 then
                begin
                  // Wenn ALeistId = 0 dann Fehler beim einfügen
                  Log.WriteToLog(CompanyName, StrToInt(pFirma),'<TTM> Values transmited: ' + VarToStr(Result));
                  Log.WriteToLog(CompanyName, StrToInt(pFirma),'<TTM> '+
                    'Keine LeistungsID oder Bezeichnung gefunden! Möglicherweise ist die MWST nicht hinterlegt! '
                    + #10#13 + 'Es wurde nicht gespeichert');
                  Log.WriteToLog(CompanyName, StrToInt(pFirma),'<TTM> KassenId: ' + IntToStr(pKasseId)
                    + ' MWST: ' + FloatToStr(pMehrwertsteuer), lmtInfo);
                  // Für Email
                  errorString :=
                    'Keine LeistungsID oder Bezeichnung gefunden! Möglicherweise ist die MWST nicht hinterlegt! Es wurde nicht gespeichert';
                end
                else
                begin
                  // noch ins Archiv speichern, wird auch für die Überprüfung von Doppelbuchungen verwendet
                  // KassInfoId
                  with QueryInsertKass_KassenArchiv do
                  begin
                    Close;
                    Connection := pConnection;
                    ParamByName('ID').AsInteger :=
                      GetGeneratorID(pConnection, 'id', 1,CompanyName);
                    ParamByName('Firma').AsInteger := StrToInt(pFirma);
                    ParamByName('Tischnr').AsString := ATischNr;
                    ParamByName('Datum').AsDate := pfelixDate;
                    ParamByName('Zeit').AsTime := now;
                    ParamByName('Betrag').AsFloat := pBetrag * pAnzahl;
                    ParamByName('Zimmerid').AsInteger := StrToInt(pZimmer);
                    ParamByName('Leistungsid').AsInteger := AleistId;
                    ParamByName('Kellnr').Value := null;
                    ParamByName('Reservid').AsInteger := pReservID;
                    ParamByName('Text').AsString := ptext;
                    ParamByName('KassInfoId').AsString := pKassInfoId;
                    execSQL;
                    Close;
                  end;
                  Result := True;
                  Log.WriteToLog(CompanyName, StrToInt(pFirma),'<TTM> Values transmited: ' + VarToStr(Result));
                end;
              end
              else
              begin
                // Eigene Kassen
                with insertGastkonto do
                begin
                  Close;
                  Connection := pConnection;
                  ParamByName('iFirma').AsInteger := StrToInt(pFirma);
                  ParamByName('iReservID').AsInteger := pReservID;
                  ParamByName('vdatum').AsDateTime := pfelixDate;
                  ParamByName('iMenge').AsInteger := pAnzahl;
                  ParamByName('iValue').AsFloat := pBetrag;

                  ParamByName('iFix').AsString := 'F';
                  ParamByName('iaufrechnungsadresse').AsString := 'F';
                  ParamByName('iIntabsgebucht').AsString := 'F';

                  // Leistung holen und Text setzen
                  if getLeistIDandBez(pConnection, StrToInt(ATischNr),
                    pMehrwertsteuer, CompanyName, pFelixNachKassen, pKasseId,
                    StrToInt(pFirma), AleistId, ALeistBez) then
                  begin
                    ParamByName('ileistungsid').AsInteger := AleistId;
                    if not(isEinzelBuchung) and (pIsBelegNr) then
                    begin
                      aText := trim(ALeistBez) + ' ' + trim(pLog_T);
                    end
                    else if (isEinzelBuchung) and (pIsBelegNr) then
                    begin
                      aText := ptext + ' ' + trim(pLog_T);
                    end
                    else if not(isEinzelBuchung) and not(pIsBelegNr) then
                    begin
                      aText := trim(ALeistBez);
                    end
                    else if (isEinzelBuchung) and not(pIsBelegNr) then
                    begin
                      aText := ptext;
                    end;
                    ParamByName('itext').AsString := aText;
                    // Ins Gstkonto schreiben
                    execSQL;

                    // Ins Journal schreiben
                    WriteToKassenJournal(pConnection, pfelixDate, aText, null,
                      pAnzahl, AleistId, null, 6, pReservID, pBetrag, False,
                      StrToInt(pFirma), pKellnerNr, pKasseId, pMehrwertsteuer,CompanyName);

                    with QueryGetTableIdFromReservId do
                    begin
                      Close;
                      Connection := pConnection;
                      ParamByName('pFirma').AsInteger := StrToInt(pFirma);
                      ParamByName('pReservID').AsInteger := pReservID;
                      Open;
                      pZimmer := FieldByName('Zimmerid').AsString;
                      Close;
                    end;

                    // Ins Archiv schreiben, wird auch verwendet um Doppelbuchungen ab zu fangen
                    // KassInfoId
                    with QueryInsertKass_KassenArchiv do
                    begin
                      Close;
                      Connection := pConnection;
                      ParamByName('ID').AsInteger :=
                        GetGeneratorID(pConnection, 'id', 1,CompanyName);
                      ParamByName('Firma').AsInteger := StrToInt(pFirma);
                      ParamByName('Tischnr').AsString := ATischNr;
                      ParamByName('Datum').AsDate := pfelixDate;
                      ParamByName('Zeit').AsTime := now;
                      ParamByName('Betrag').AsFloat := pBetrag * pAnzahl;
                      ParamByName('Zimmerid').AsInteger := StrToInt(pZimmer);
                      ParamByName('Leistungsid').AsInteger := AleistId;
                      ParamByName('Kellnr').Value := null;
                      ParamByName('Reservid').AsInteger := pReservID;
                      ParamByName('Text').AsString := aText;
                      ParamByName('KassInfoId').AsString := pKassInfoId;
                      execSQL;
                      Close;
                    end;

                    Result := True;
                    Log.WriteToLog(CompanyName, StrToInt(pFirma),'<TTM> Values transmited: ' +
                      VarToStr(Result));
                  end
                  else
                  begin
                    Log.WriteToLog(CompanyName, StrToInt(pFirma),'<TTM> Values transmited: ' +
                      VarToStr(Result));
                    Log.WriteToLog(CompanyName, StrToInt(pFirma),'<TTM> '+
                      'Keine LeistungsID oder Bezeichnung für TischNr: ' +
                      ATischNr +
                      ' gefunden! Möglicherweise ist die MWST nicht hinterlegt! '
                      + #10#13 + 'Es wurde nicht gespeichert', lmtError);
                    // Für Emial
                    errorString :=
                      'Keine LeistungsID oder Bezeichnung für TischNr: ' +
                      ATischNr +
                      ' gefunden! Möglicherweise ist die MWST nicht hinterlegt! Es wurde nicht gespeichert';
                  end;
                end;
              end;
            end
            else
            begin
              Result := True;
              errorString := 'Die ID: '+ pKassInfoId + 'wurde schon früher einmal verwendet. Bitte eine neue Rechnungsnummer verwenden';
              Log.WriteToLog(CompanyName, StrToInt(pFirma),'<TTM> KassInfoId ' + pKassInfoId +
                ' wurde schon früher gespeichert');
            end;
          end;
        end;
      end;
    except
      on e: Exception do
      begin
        Log.WriteToLog(CompanyName, StrToInt(pFirma),'<TTM> WriteToGastkonto: ' + e.Message,
          lmtError);
        Result := False;
        // Für Email
        errorString := 'Fehler beim Schreiben in Datenbank!';
        insertGastkonto.Connection.Rollback;
      end;
    end;
  finally
    if insertGastkonto.Connection.InTransaction then
      insertGastkonto.Connection.Commit;
    StoredProcBOOK_RESTAURANTVALUEEXTERN.Close;
    QueryAnlage.Close;
  end;

end;

function TTM.GetFelixDate(pConnection: TFDConnection; pFirma: string;
  CompanyName: string = ''): TDateTime;
var
  aQuery: TFDQuery;
begin

  with aQuery do
  begin
    try
      try
        aQuery := TFDQuery.Create(nil);
        Connection := pConnection;
        Close;
        SQL.Clear;
        SQL.Add('select felixdate from diverses where firma = ' + pFirma);
        Open;
        while not EOF do
        begin
          Result := Fields[0].Value;

          next;
        end;
      except
        on e: Exception do
        begin
          Log.WriteToLog(CompanyName, StrToInt(pFirma),'<TTM> GetFelixDate: ' +
            e.Message, lmtError);
        end;
      end;
    finally
      Close;
      SQL.Clear;
      aQuery.Free;
    end;
  end;
end;

function TTM.getCheckID(pConnection: TFDConnection; reserfID: Integer;
  CompanyName: string; pFirma: integer): Integer;
var
  aQuery: TFDQuery;
begin
  with aQuery do
  begin
    Result := 0;
    try
      try
        aQuery := TFDQuery.Create(nil);
        Connection := pConnection;
        Close;
        SQL.Clear;
        SQL.Add('SELECT ID FROM Reservierung WHERE ID = ' + IntToStr(reserfID) +
          ' AND CheckIn = ''T''');

        Open;
        while not EOF do
        begin
          Result := FieldByName('ID').AsInteger;
          next;
        end;
      except
        on e: Exception do
        begin
          Log.WriteToLog(CompanyName, pFirma,'<TTM> getCheckId: ' + e.Message,
            lmtError);
        end;
      end;
    finally
      Close;
      SQL.Clear;
      aQuery.Free;
    end;
  end;
end;

function TTM.getKassInfoIdIsSaved(pConnection: TFDConnection;
  pID: string; pFirma: integer; pCompanyName: string): Boolean;
begin
  try
    Result := False;
    try
      Log.WriteToLog(pCompanyName, pFirma,'<TTM> getKassInfoId: '+pID+' IsSaved: ', lmtInfo);
      QueryGetKassIdIsSaved.Connection := pConnection;
      with QueryGetKassIdIsSaved do
      begin
        Close;
        ParamByName('KInfId').AsString := pID;
        Open;
        Result := not FieldByName('KASSINFOID').IsNull;// RecordCount = 1;
        Close;
      end;
    except
      on e: Exception do
      begin
        Log.WriteToLog(pCompanyName, pFirma,'<TTM> getKassInfoIdIsSaved: ' +
          e.Message, lmtError);
      end;
    end;
  finally
    QueryGetKassIdIsSaved.Close;
  end;
end;

function TTM.GetGeneratorID(pConnection: TFDConnection; PGenerator: string;
  PInc: Integer; pCompanyName: string): Integer;
var
  aQuery: TFDQuery;
begin
  try
    Result := 0;
    aQuery := TFDQuery.Create(nil);
    aQuery.Connection := pConnection;
    with aQuery do
    begin
      aQuery.Close;
      SQL.Clear;
      if PInc = 0 then
        SQL.Add('Select Gen_ID(' + PGenerator +
          ',0) as Gen_ID from RDB$database')
      else
        SQL.Add('Select Gen_ID(' + PGenerator + ',' + IntToStr(PInc) +
          ') as Gen_ID from RDB$database');
    end;
    if pConnection.InTransaction then
    begin
      aQuery.Open;
      Result := aQuery.FieldByName('Gen_ID').AsInteger;
      aQuery.Close;
    end
    else
    begin
      try
        pConnection.StartTransaction;
        aQuery.Open;
        Result := aQuery.FieldByName('Gen_ID').AsInteger;
        aQuery.Close;
        pConnection.Commit;
      except
        on e: Exception do
        begin
          if pConnection.InTransaction then
            pConnection.Rollback;
           Log.WriteToLog(pCompanyName,0,'<TTM> GetGeneratorID: ' + e.Message,
            lmtError);
        end;
      end;
    end;
  finally
    aQuery.Close;
    aQuery.Free;
  end;
end;

function TTM.CheckGuestId(pCompanyName: string; pCpmpanyId, pGuestID: integer): boolean;
begin
  try
    try
      result := false;
      with QueryCheckGuestId do
      begin
        close;
        ParamByName('pId').AsInteger := pGuestID;
        open;
        if not  fieldbyName('Id').IsNull then
        begin
          result := true;
        end;
      end;
    except on e: exception do
      Log.WriteToLog(pCompanyName,pCpmpanyId,'<TTM> CheckGuestId: ' + e.Message,
            lmtError);
    end;
  finally
    QueryCheckGuestId.Close;
  end;
end;

function TTM.GetNextInvoiceNumber(pCompanyName: string; pCompanyId: integer): integer;
begin
  try
    try
      Result := 0;
      with QueryGetNextInvoiceNumber do
      begin
        close;
        ParamByName('pFirma').AsInteger := pCompanyId;
        open;
        result := FieldByName('Rechnungsnummer').AsInteger;
      end;
    except
      on e: Exception do
        begin
           Log.WriteToLog(pCompanyName, pCompanyId,'<TTM> GetNextInvoiceNumber: ' +
            e.Message, lmtError);

        end;
    end;
  finally
    QueryGetNextInvoiceNumber.Close;
  end;
end;
function TTM.CheckCompany(pCompanyName: string; pCompanyId: integer): boolean;
begin
  try
    try
      result := false;
      with QueryCheckCompanyId do
      begin
        close;
        ParamByName('pFirma').AsInteger := pCompanyId;
        open;
        if not FieldByName('Firma').IsNull then
        begin
          result := true;
        end;
      end;
    except
      on e: Exception do
        begin
           Log.WriteToLog(pCompanyName, pCompanyId,'<TTM> CheckCompany: ' +
            e.Message, lmtError);
        end;
    end;
  finally
    QueryCheckCompanyId.Close;
  end;
end;
function TTM.getLeistIDandBez(pConnection: TFDConnection; pTischNr: Integer;
  pMwSt: double; CompanyName: string; pFelixNachKassen: Boolean;
  pKasseId: Integer; pFirma: Integer; var pLeistId: Integer;
  var pLeistBez: String): Boolean;
var
  aQuery: TFDQuery;
begin

  with aQuery do
  begin
    Result := False;
    try
      try
        aQuery := TFDQuery.Create(nil);
        Connection := pConnection;
        Close;
        SQL.Clear;
        SQL.Add('SELECT DISTINCT LeistungsID, l.leistungsbezeichnung ' +
                'FROM Kass_Tischzuordnung kt ' +
                'LEFT OUTER JOIN Leistungen l on kt.LeistungsID = l.ID and l.Firma = '
          + IntToStr(pFirma) +
                'LEFT OUTER JOIN mehrwertsteuer mw on l.firma = mw.firma and l.MwstID = mw.id ');
        if not pFelixNachKassen then
        begin
          SQL.Add('WHERE kt.TischVon <= ' + IntToStr(pTischNr) +
                  ' AND kt.TischBis >= ' + IntToStr(pTischNr));
        end
        else
        begin
          SQL.Add('WHERE kt.TischVon <= ' + IntToStr(pKasseId) +
            ' AND kt.TischBis >= ' + IntToStr(pKasseId));
        end;
        SQL.Add(' and mw.mwst = :pMWST');
        ParamByName('pMWSt').AsFloat := pMwSt;
        Open;
        while not EOF do
        begin
          pLeistId := Fields[0].Value;
          pLeistBez := Fields[1].Value;
          Result := True;
          next;
        end;
      except
        on e: Exception do
        begin
           Log.WriteToLog(CompanyName, pFirma,'<TTM> getLeistIDandBez: ' +
            e.Message, lmtError);
          Result := False;
        end;
      end;
    finally
      Close;
      SQL.Clear;
      aQuery.Free;
    end;
  end;
  // result:= true; //<-- only for testing        { TODO : wieder rausnehmen }
end;

procedure TTM.WriteToKassenJournal(pConnection: TFDConnection; pDatum: TDate;
  ARechnungsText: String; AZahlWegID, AMenge, ALeistungsID, AArrangementID,
  pErfassungDurch, AReservID: Variant; ABetrag: double; ANetto: Boolean;
  pFirma: Integer; pMitArbID, pKassaID: LargeInt; pMwSt: Variant; pCompanyName: string);
var
  aNotLogisPreis, aPreisAnteil: double;
  aOrtsTaxe: double;
  aProzArrAnteil: double;

  procedure NeuerDatensatzJournal;
  begin
    with QueryInsertKassenjournal do
    begin
      ParamByName('Firma').Value := pFirma;
      ParamByName('ReservID').Value := AReservID;
      ParamByName('Datum').AsDateTime := pDatum;
      ParamByName('Zeit').AsTime := Time;
      ParamByName('KassaID').Value := pKassaId;
      ParamByName('ErfassungDurch').Value := pErfassungDurch;
      ParamByName('Text').AsString := ARechnungsText;
      if VarIsNull(aMenge) then
        ParamByName('Menge').Value := AMenge
      else
      begin
        ParamByName('Menge').AsInteger := AMenge;
      end;
      ParamByName('ArrangementID').Value := AArrangementID;
      ParamByName('ZahlwegID').Value := AZahlWegID;
      ParamByName('Bankleitzahl').Value := SetKassenBuch(pConnection,AZahlWegID, pErfassungDurch, pFirma,pCompanyName);
      ParamByName('Betrag').AsFloat := ABetrag;
      ParamByName('MwSt').Value := pMwSt;
    end;
  end;

begin
  try
    with QueryInsertKassenjournal do
    begin
      Connection := pConnection;
      // Wenn die Leistungsnummer null ist, die Arrngementnummer aber nicht, bedeutet
      // das, dass das ganze Arrangment einzeln in das Kassenjournal verbucht werden
      // muss!
      aNotLogisPreis := 0;
      aProzArrAnteil := 0;
      if (AArrangementID <> null) and (ALeistungsID = null) then
      begin
        // Das Arrangement wird aus der Arrangementtabelle geholt...
        TableArrangement.Connection := pConnection;
        if TableArrangement.Locate('ID', AArrangementID, []) then
        begin
          // Alle Leistungen dieses Arrangements werden in die Gastkontotabelle
          // verbucht
          // Alle Leistungen dieses Arrangements werden in die Gastkontotabelle
          // verbucht
          QueryArrangementLeistungen.Close;
          QueryArrangementLeistungen.Connection := pConnection;
          QueryArrangementLeistungen.ParamByName('Firma').AsInteger := pFirma;
          QueryArrangementLeistungen.ParamByName('ArrangementID').AsInteger :=
            AArrangementID;
          QueryArrangementLeistungen.Open;
          QueryArrangementLeistungen.First;
          while not QueryArrangementLeistungen.EOF do
          begin
            // Wenn 1 dann verbuchen
            if (QueryArrangementLeistungen.FieldByName('PreisKategorie').AsInteger in [1, 8])
            or (QueryArrangementLeistungen.FieldByName('PreisKategorie').Value = null) then
            begin
              NeuerDatensatzJournal;
              ParamByName('LeistungsID').AsInteger :=
                QueryArrangementLeistungen.FieldByName('LeistungsID').AsInteger;
              // Prozentberechnung
              if QueryArrangementLeistungen.FieldByName('PreisKategorie')
                .AsInteger = 8 then
                aPreisAnteil := (ABetrag - aProzArrAnteil) / 100 *
                  QueryArrangementLeistungen.FieldByName('Preisanteil').AsFloat
              else
              begin
                aProzArrAnteil := aProzArrAnteil +
                  QueryArrangementLeistungen.FieldByName('Preisanteil').AsFloat;
                aPreisAnteil := QueryArrangementLeistungen.FieldByName
                  ('Preisanteil').AsFloat;
              end;
              aNotLogisPreis := aNotLogisPreis + aPreisAnteil;
              ParamByName('Betrag').AsFloat := aPreisAnteil;
              // Leistung des Arrangements in Kassenjournal eintragen
              execSQL;
            end;
            QueryArrangementLeistungen.next;
          end;
          QueryArrangementLeistungen.Close;
        end
        else
        begin
           Log.WriteToLog(pCompanyName, pFirma,'<TTM> '+
            '1008: ArrangementVerbuchen in Journal: Arrangement nicht gefunden',
            lmtError);
           Log.WriteToLog(pCompanyName, pFirma,'<TTM>  Arrangement nicht gefunden');
        end;
        if GetBoolean(ReadGlobalValue2(pConnection, 'OrtstaxeProz', '0','BOOLEAN'))
        and (TableArrangement.FieldByName('GesamtPreis').AsLargeInt = 0) then
        begin
          aOrtsTaxe := (ABetrag - aNotLogisPreis) / 100 *
            BetragToFloat(ReadGlobalValue2(pConnection, 'OrtstaxeProzent', '0',
            'FLOAT'),pCompanyName);
          NeuerDatensatzJournal;
          ParamByName('LeistungsID').AsLargeInt :=
            StrToInt(ReadGlobalValue2(pConnection, 'OrtstaxeLNID', '0',
            'INTEGER'));
          ParamByName('Betrag').AsFloat := aOrtsTaxe;
          execSQL;
          aNotLogisPreis := aNotLogisPreis + aOrtsTaxe;
        end;
        // Die Leistung "Logis" berrechnet sich aus dem Gesamtpreis -
        // den Preisanteilen der Leistungen aus der Arrangementleistungstabelle
        NeuerDatensatzJournal;
        ParamByName('LeistungsID').AsLargeInt := TableArrangement.FieldByName
          ('LNLogis').AsLargeInt;
        ParamByName('Betrag').AsFloat := ABetrag - aNotLogisPreis;
        // ErfassungDurch = 11 -> beim tranferieren von Arrangements soll
        // diese Fehlermeldung nicht kommen!!!
        if (aNotLogisPreis > ABetrag) and not(pErfassungDurch = 11) then
        Log.WriteToLog(pCompanyName, pFirma,'<TTM> '+
            '126: Preisanteil der Leistungen größer als Gesamtpreis');
        execSQL;
      end
      else
      begin
        NeuerDatensatzJournal;
        // Wenn ANetto beachtet werden soll
        if ANetto then
        begin
          QueryLeistung.Close;
          QueryLeistung.Connection := pConnection;
          QueryLeistung.ParamByName('Firma').AsLargeInt := pFirma;
          QueryLeistung.ParamByName('ID').AsLargeInt := ALeistungsID;
          QueryLeistung.Open;

          if QueryLeistung.FieldByName('ID').IsNull then
            Log.WriteToLog(pCompanyName, pFirma,'<TTM> 127: WriteToKassenJournal: Leistung nicht gefunden');
          // und das Kennzeichen "KeimUmsatz" in der Leistungstabelle gesetzt
          // ist
          if QueryLeistung.FieldByName('KeinUmsatz').AsBoolean then
          begin
            // Dann im Kassenjournal den Bruttowert des Ã¼bergebenen Betrages
            // errechnen und verbuchen
            QueryTabMWST.Connection := pConnection;
            if not QueryTabMWST.Locate('ID', QueryLeistung.FieldByName('MwstID')
              .AsLargeInt, []) then
              Log.WriteToLog(pCompanyName, pFirma,'<TTM> '
                +'128: WriteToKassenJournal: MwSt nicht gefunden');
            ABetrag := ABetrag + ABetrag * QueryTabMWST.FieldByName('MwSt').AsFloat / 100;
          end;
        end;
        QueryLeistung.Close;
        ParamByName('Betrag').Value := ABetrag;
        ParamByName('LeistungsID').Value := ALeistungsID;
        ParamByName('ReservID').Value := AReservID;
        QueryInsertKassenjournal.execSQL;
      end;
    end;
  except
    on e: Exception do
      Log.WriteToLog(pCompanyName, pFirma,'<TTM> WriteToKassenJournal:'+ e.Message, lmtError);
  end;
end;

function TTM.SetKassenBuch(pConnection: TFDConnection;
  pZahlwegID, pErfassungDurch: Variant; pFirma: Integer; pCompanyName: string): Variant;
begin
  Result := null;
  if GetBoolean(ReadGlobalValue2(pConnection, 'KassaBuch', '0', 'BOOLEAN')) and
    (pZahlwegID <> null) then
  begin
    if (pErfassungDurch <> null) and (StrToInt(VarToStr(pErfassungDurch))
      in [0, 1, 2, 3, 4, 5, 7, 8, 9]) then
    begin
      QueryGetZahlwegBar.Close;
      QueryGetZahlwegBar.Connection := pConnection;
      QueryGetZahlwegBar.ParamByName('Firma').AsLargeInt := pFirma;
      QueryGetZahlwegBar.ParamByName('ID').AsLargeInt := pZahlwegID;
      QueryGetZahlwegBar.Open;
      // Nur bei Bar!
      if QueryGetZahlwegBar.FieldByName('Bar').AsBoolean then
      begin
        if not TransactionDiverses2.Active then
        begin
          TransactionDiverses2.Connection := pConnection;
          TransactionDiverses2.StartTransaction;
        end;
        try
          QuerySetKassenbuch.Connection := pConnection;
          QuerySetKassenbuch.execSQL;
          TransactionDiverses2.CommitRetaining; // !!!!
        except
          TransactionDiverses2.Rollback; // Retaining;
          Log.WriteToLog(pCompanyName, pFirma,'<TTM> SetKassenBuch: Abgefangen');
          raise;
        end;
        QueryGetKassenbuch.Close;
        QueryGetKassenbuch.Connection := pConnection;
        QueryGetKassenbuch.Open;
        Result := QueryGetKassenbuch.FieldByName('LastKassenID').AsLargeInt;
        QueryGetKassenbuch.Close;
      end;
      QueryGetZahlwegBar.Close;
    end;
  end;
end;

function TTM.CreateInvoice0(pFelixDate, pCashDDate: TDate; pCompanyId: integer; pCompanyName: string; pLocationId: string = ''): Int64;
var aDeleteQuery: TFDQuery;
begin
  try
    try
      aDeleteQuery := TFDQuery.Create(nil);
      aDeleteQuery.Connection := MainConnection;
      try
        With aDeleteQuery Do
        Begin
          close;
          SQL.Clear;
          SQL.Add('select id from Rechnung');
          SQL.Add('WHERE VonDatum = ''' + DateToStr(pCashDDate) + ''' AND ');
          SQL.Add('Rechnungsnummer in (0,99999) and Firma = ' + IntToStr(pCompanyId));
          if (pLocationId <> '') then
          begin
            SQL.Add('and Bemerkung = ' + QuotedStr(pLocationId));
          end;
          open;
          if RecordCount > 0 then
          begin
            close;
            SQL.Clear;
            SQL.Add('DELETE FROM  Rechnungskonto');
            SQL.Add('WHERE exists ( SELECT ID FROM RECHNUNG');
            SQL.Add('WHERE RECHNUNG.ID = Rechnungskonto.RechnungsID AND RECHNUNG.VonDatum = '''
              + DateToStr(pCashDDate) + ''' AND ');
            SQL.Add('Rechnungsnummer in (0,99999) and RECHNUNG.Firma = ' +
              IntToStr(pCompanyId));
            if (pLocationId <> '') then
            begin
              SQL.Add('and RECHNUNG.Bemerkung = ' + QuotedStr(pLocationId));
            end;
            SQL.Add(')');
            ExecSQL;
            close;
            SQL.Clear;
            SQL.Add('DELETE FROM  Rechnungszahlweg');
            SQL.Add('WHERE exists ( SELECT ID FROM RECHNUNG');
            SQL.Add('WHERE RECHNUNG.ID = Rechnungszahlweg.RechnungsID AND RECHNUNG.VonDatum = '''
              + DateToStr(pCashDDate) + ''' AND ');
            SQL.Add('RECHNUNG.Rechnungsnummer in (0,99999) and RECHNUNG.Firma = '
              + IntToStr(pCompanyId));
            if (pLocationId <> '') then
            begin
              SQL.Add('and RECHNUNG.Bemerkung = ' + QuotedStr(pLocationId));
            end;
            SQL.Add(')');
            ExecSQL;
            close;
            SQL.Clear;
            SQL.Add('DELETE FROM  RechnungsMwst');
            SQL.Add('WHERE exists ( SELECT ID FROM RECHNUNG');
            SQL.Add('WHERE RECHNUNG.ID = RechnungsMwst.RechnungsID  AND RECHNUNG.VonDatum = '''
              + DateToStr(pCashDDate) + ''' AND ');
            SQL.Add('RECHNUNG.Rechnungsnummer in (0,99999) and RECHNUNG.Firma = '
              + IntToStr(pCompanyId));
            if (pLocationId <> '') then
            begin
              SQL.Add('and RECHNUNG.Bemerkung = ' + QuotedStr(pLocationId));
            end;
            SQL.Add(')');
            ExecSQL;
            close;
            SQL.Clear;
            SQL.Add('DELETE FROM RECHNUNG');
            SQL.Add('WHERE VonDatum = ''' + DateToStr(pCashDDate) + ''' AND ');
            SQL.Add('Rechnungsnummer in (0,99999) and Firma = ' + IntToStr(pCompanyId));
            if (pLocationId <> '') then
            begin
              SQL.Add('and Bemerkung = ' + QuotedStr(pLocationId));
            end;
            ExecSQL;
            close;
            SQL.Clear;
            SQL.Add('DELETE FROM  KassenJournal');
            SQL.Add('WHERE Datum >= ''' + DateToStr(pFelixDate-10) + ''' AND erfassungdurch = 7 AND  ');
            if (pLocationId <> '') then
            begin
              SQL.Add('Text Like ''Losung ' + pLocationId + ' / ' + DateToStr(pCashDDate) +'%'' and Firma = ' + IntToStr(pCompanyId));
            end
            else
            begin
              SQL.Add('Text Like ''Losung ' + DateToStr(pCashDDate) +'%'' and Firma = ' + IntToStr(pCompanyId));
            end;

            ExecSQL;
            close;
            SQL.Clear;
            SQL.Add('DELETE FROM  KassenJournal');
            SQL.Add('WHERE Datum >= ''' + DateToStr(pFelixDate-10) + ''' AND erfassungdurch = 12 AND ');
            if (pLocationId <> '') then
            begin
              SQL.Add('Text Like ''Umsatz Kasse ' + pLocationId + ' / ' + DateToStr(pCashDDate) +'%'' and Firma = ' + IntToStr(pCompanyId));
            end
            else
            begin
              SQL.Add('Text Like ''Umsatz Kasse | ' + DateToStr(pCashDDate) +'%'' and Firma = ' + IntToStr(pCompanyId));
            end;
            ExecSQL;
            close;
            SQL.Clear;
            SQL.Add('DELETE FROM  KassenJournal');
            SQL.Add('WHERE Datum >= ''' + DateToStr(pFelixDate-10) + ''' AND erfassungdurch = 6 AND ');
            if (pLocationId <> '') then
            begin
              SQL.Add('Text Like ''Gegenbuchung Kasse ' + pLocationId + ' | ' + DateToStr(pCashDDate) +'%'' and Firma = ' + IntToStr(pCompanyId));
            end
            else
            begin
              SQL.Add('Text Like ''Gegenbuchung Kasse | ' + DateToStr(pCashDDate) +'%'' and Firma = ' + IntToStr(pCompanyId));
            end;
            ExecSQL;
          end;
          close;
        End; // with
      except
        on E: Exception do
        begin
          Log.WriteToLog(pCompanyName, pCompanyId,'<TTM> CreateInvoice0/Delete Query: ' + E.Message,
            lmtError);
        end;
      end;


        result := GetGeneratorID(MainConnection, 'id', 1,pCompanyName);
        TableRechnung.Connection := MainConnection;
        TableRechnung.open;
        TableRechnung.Append;
        TableRechnung.FieldByName('ID').AsInteger := result;
        TableRechnung.FieldByName('Firma').AsInteger := pCompanyId;
        TableRechnung.FieldByName('Datum').AsDateTime := pFelixDate;
        TableRechnung.FieldByName('VonDatum').AsDateTime := pCashDDate;
        TableRechnung.FieldByName('Rechnungsnummer').AsLargeInt := 0;
        TableRechnung.FieldByName('Gedruckt').AsBoolean := true;
        TableRechnung.FieldByName('Bezahlt').AsBoolean := true;
        if (pLocationId <> '') then
        begin
          TableRechnung.FieldByName('Bemerkung').AsString := pLocationId;
        end;
        TableRechnung.Post;
    except on e : Exception do
      begin
        Log.WriteToLog(pCompanyName, pCompanyId,'<TTM> CreateInvoice0: ' + e.Message, lmtError);
      end;
    end;
  finally
//    TableRechnung.Close;
  end;
end;



function TTM.CheckDoubleBookingGegenbuchungKasse(pConnection: TFDConnection; pCompanyName: string;
                    pCompanyId: integer; pBetrag: Double;
                    pLeistId: Int64; pUmsatzDatum: TDateTime; pLocationId: string ): boolean;
var
  aQuery: TFDQuery;
begin
  try
    try
      result := false;
      aQuery := TFDQuery.Create(nil);
      with aQuery do
      begin
        close;
        Connection := pConnection;
        SQL.Clear;
        SQL.Add('select Id from Kassenjournal where LEISTUNGSID = :pLeistungsId and Betrag = :pBetrag and Text = :pText');
        SQL.Add(' and Datum >= :pDate');
        ParamByName('pLeistungsId').AsLargeInt := pLeistId;
        ParamByName('pBetrag').AsFloat := pBetrag;
        ParamByName('pDate').AsDateTime := pUmsatzDatum-10;
        if pLocationId <> '' then
        begin
          ParamByName('pText').AsString := 'Gegenbuchung Kasse ' + pLocationId + ' | ' + DateToStr(pUmsatzDatum);
        end
        else
        begin
          ParamByName('pText').AsString := 'Gegenbuchung Kasse | ' + DateToStr(pUmsatzDatum);
        end;
        open;
        Result := not FieldByName('id').isNull;
      end;
    except on e : Exception do
      begin
        Log.WriteToLog(pCompanyName, pCompanyId,'<TTM> CheckDoubleBookingGegenbuchungKasse Error: ' +
         e.Message, lmtError);
      end;
    end;
  finally
    aQuery.Close;
    freeAndNil(aQuery);
  end;
end;

function TTM.CheckDoubleBookingInvoice(pCompanyName: string; pCompanyId: integer; pInvoiceId: string): boolean;
begin
  try
    try
      result := false;
      with QueryCheckInvoice do
      begin
        close;
        ParamByName('pFirma').AsInteger := pCompanyId;
        ParamByName('pInvoiceID').ASString := pInvoiceID;
        open;
        result := FieldByName('Id').AsInteger > 0;

      end;
    except on e : Exception do
      begin
        Log.WriteToLog(pCompanyName, pCompanyId,'<TTM> CheckDoubleBookingInvoice Error: ' +
         e.Message, lmtError);
      end;
    end;
  finally
    QueryCheckInvoice.Close;
  end;
end;

function TTM.InsertForBookingInvoice(pCompanyName: string; pCompanyId: integer; pInvoiceId: string; pRechnungID: LargeInt): boolean;
begin
  try
    try
      result := false;
      with QueryInsertInvoiceForDoubleBooking do
      begin
        close;
        ParamByName('pFirma').AsInteger := pCompanyId;
        ParamByName('pInvoiceID').ASString := pInvoiceID;
        ParamByName('pRechnungId').ASLargeInt:= pRechnungID;
        ExecSQL;
      end;
    except on e : Exception do
      begin
        Log.WriteToLog(pCompanyName, pCompanyId,'<TTM> InsertForBookingInvoice Error: ' +
         e.Message, lmtError);
      end;
    end;
  finally
    QueryInsertInvoiceForDoubleBooking.Close;
  end;
end;

function TTM.UpdateDiversRechnungNr(pCompanyName: string; pCompanyId: integer; pInvoiceNumber: integer): boolean;
begin
  try
    try
      Log.WriteToLog(pCompanyName, pCompanyId, '<TTM> UpdateDiversRechnungNr to: '+ IntToStr(pInvoiceNumber),
                      lmtInfo);
      result := false;
      with QueryUpdateDIVERSESRECHNR do
      begin
        close;
        ParamByName('pCompanyId').AsInteger := pCompanyId;
        ParamByName('pLastInvoiceNr').ASInteger := pInvoiceNumber;
        ExecSQL;
      end;
    except on e : Exception do
      begin
        Log.WriteToLog(pCompanyName, pCompanyId,'<TTM> UpdateDiversRechnungNr Error: ' +
         e.Message, lmtError);
         raise;
      end;
    end;
  finally
    QueryCheckInvoice.Close;
  end;
end;

function TTM.InsertRechnungMwSt(pCompanyName: string; pCompanyId: integer; pInvoiceId: integer): boolean;
begin
  try
    try
      Log.WriteToLog(pCompanyName, pCompanyId, '<TTM>  InsertRechnungMwSt ... ',
                      lmtInfo);
      result := false;
      QueryGetAmountOrderByTax.Close;
      QueryGetAmountOrderByTax.ParamByNAme('pInvoiceID').AsInteger := pInvoiceId;
      QueryGetAmountOrderByTax.ParamByNAme('pCompanyId').AsInteger := pCompanyId;
      QueryGetAmountOrderByTax.open;
      while not QueryGetAmountOrderByTax.EOF do
      begin
        QueryInsertInvoiceTax.Close;
        QueryInsertInvoiceTax.ParamByName('pCompanyId').AsInteger := pCompanyID;
        QueryInsertInvoiceTax.ParamByName('pInvoiceId').AsInteger := pInvoiceId;
        QueryInsertInvoiceTax.ParamByName('pTax').AsFloat := QueryGetAmountOrderByTax.FieldByName('Mwst').AsFloat;
        QueryInsertInvoiceTax.ParamByName('pAmount').AsFloat := QueryGetAmountOrderByTax.FieldByName('Gesamtbetrag').AsFloat;
        QueryInsertInvoiceTax.ExecSQL;
        QueryGetAmountOrderByTax.Next;
      end;
      result := true;
    except on e : Exception do
      begin

        Log.WriteToLog(pCompanyName, pCompanyId,'<TTM> InsertRechnungMwSt Error: ' +
         e.Message, lmtError);
         raise;
      end;
    end;
  finally
    begin
      QueryGetAmountOrderByTax.Close;
      QueryInsertInvoiceTax.Close;
    end;
  end;
end;



function TTM.DeleteInvoice(pCompanyName: string; pCompanyId, aInvoiceId: integer): boolean;
var aDeleteQuery: TFDQuery;
begin
  try
    aDeleteQuery := TFDQuery.Create(nil);
    aDeleteQuery.Connection := MainConnection;
    try
      Log.WriteToLog(pCompanyName, pCompanyId,'<TTM> DeleteInvoice -> Delete InvoiceId: '+ IntToStr(aInvoiceId), lmtInfo);
      With aDeleteQuery Do
      Begin
        close;
        SQL.Clear;
        Log.WriteToLog(pCompanyName, pCompanyId,'<TTM> DeleteInvoice -> Delete from Rechnungskonto', lmtInfo);
        SQL.Add('DELETE FROM  Rechnungskonto');
        SQL.Add('WHERE RechnungsId = :pInvoiceId');
        SQL.Add('and Firma = :pCompanyId');
        ParamByName('pInvoiceId').AsInteger := aInvoiceId;
        ParamByName('pCompanyId').AsInteger := pCompanyId;
        ExecSQL;
        close;
        SQL.Clear;
        Log.WriteToLog(pCompanyName, pCompanyId,'<TTM> DeleteInvoice -> Delete from Rechnungszahlweg', lmtInfo);
        SQL.Add('DELETE FROM  Rechnungszahlweg');
        SQL.Add('WHERE RechnungsId = :pInvoiceId');
        SQL.Add('and Firma = :pCompanyId');
        ParamByName('pInvoiceId').AsInteger := aInvoiceId;
        ParamByName('pCompanyId').AsInteger := pCompanyId;
        ExecSQL;
        close;
        SQL.Clear;
        Log.WriteToLog(pCompanyName, pCompanyId,'<TTM> DeleteInvoice -> Delete from RechnungsMwst', lmtInfo);
        SQL.Add('DELETE FROM  RechnungsMwst');
        SQL.Add('WHERE RechnungsId = :pInvoiceId');
        SQL.Add('and Firma = :pCompanyId');
        ParamByName('pInvoiceId').AsInteger := aInvoiceId;
        ParamByName('pCompanyId').AsInteger := pCompanyId;
        ExecSQL;
        close;
        SQL.Clear;
        Log.WriteToLog(pCompanyName, pCompanyId,'<TTM> DeleteInvoice -> Delete from Rechnung', lmtInfo);
        SQL.Add('DELETE FROM RECHNUNG');
        SQL.Add('WHERE Id = :pInvoiceId');
        SQL.Add('and Firma = :pCompanyId');
        ParamByName('pInvoiceId').AsInteger := aInvoiceId;
        ParamByName('pCompanyId').AsInteger := pCompanyId;
        ExecSQL;

        close;
        SQL.Clear;
        Log.WriteToLog(pCompanyName, pCompanyId,'<TTM> DeleteInvoice -> Delete from Kassenjournal', lmtInfo);
        SQL.Add('DELETE FROM  KassenJournal');
        SQL.Add('WHERE RechnungsId = :pInvoiceId');
        SQL.Add('and Firma = :pCompanyId');
        ParamByName('pInvoiceId').AsInteger := aInvoiceId;
        ParamByName('pCompanyId').AsInteger := pCompanyId;
        ExecSQL;

        close;
        SQL.Clear;
        Log.WriteToLog(pCompanyName, pCompanyId,'<TTM> DeleteInvoice -> Delete from RECHNUNG_EXTERNSERVER', lmtInfo);
        SQL.Add('DELETE FROM  RECHNUNG_EXTERNSERVER');
        SQL.Add('WHERE RechnungId = :pInvoiceId');
        SQL.Add('and Firma = :pCompanyId');
        ParamByName('pInvoiceId').AsInteger := aInvoiceId;
        ParamByName('pCompanyId').AsInteger := pCompanyId;
        ExecSQL;
        close;
      End; // with
    except
      on E: Exception do
      begin
        Log.WriteToLog(pCompanyName, pCompanyId,'<TTM> DeleteInvoice: ' + E.Message, lmtError);
      end;
    end;
  finally
    FreeAndNil(aDeleteQuery);
  end;
end;
function TTM.InsertInvoiceJournal(pCompanyName: string; pCompanyId, pInvoiceId: integer; pLeistungsId: integer;
  pTime: TTime;
  pCashDeskId: integer; pAmount: Double; pQuantity: integer; pPaymentMethodId: integer; pErfassungDurch: integer;
  pTax: double; pText: string): boolean;
begin
  try
    try
      Log.WriteToLog(pCompanyName, pCompanyId, '<TTM> InsertInvoiceJournal ... ',
                      lmtInfo);
      result := false;
      with QueryInsertKassenjournalDirectInvoice do
      begin
        close;
        ParamByName('Firma').AsInteger := pCompanyId;
        ParamByName('RechnungsId').AsInteger := pInvoiceId;
        if pLeistungsId > -1 then
        begin
          ParamByName('LeistungsId').AsInteger := pLeistungsId;
        end
        else
        begin
          ParamByName('LeistungsId').Value := null;
        end;
        ParamByName('KassaId').AsInteger := pCashDeskId;
        ParamByName('Text').AsString := Trim(pText);
        ParamByName('Datum').AsDate := date;
        ParamByName('Zeit').AsTime := pTime;
        ParamByNAme('Menge').AsInteger := pQuantity;
        ParamByNAme('Betrag').AsFloat := pAmount;
        if pPaymentMethodId > -1 then
        begin
          ParamByNAme('ZahlwegID').AsLargeInt := pPaymentMethodId;
        end
        else
        begin
          ParamByNAme('ZahlwegID').Value := null;
        end;
        ParamByNAme('Erfassungdurch').AsInteger := pErfassungDurch;
        if pTax > -1 then
        begin
          ParamByNAme('MWST').AsFloat := pTax;
        end
        else
        begin
          ParamByNAme('MWST').Value := null;
        end;
        if pPaymentMethodId = 1 then
        begin
          ParamByNAme('pbankleitzahl').AsString := '1';
        end
        else
        begin
          ParamByNAme('pbankleitzahl').Value := null;
        end;

        ExecSQL;
      end;
    except on e : Exception do
      begin
        Log.WriteToLog(pCompanyName, pCompanyId,'<TTM> InsertInvoiceJournal Error: ' +
         e.Message, lmtError);
         raise;
      end;
    end;
  finally
    QueryInsertKassenjournalDirectInvoice.Close;
  end;
end;

function TTM.InsertRechnungZahlweg(pCompanyName: string; pCompanyId, pInvoiceId: integer; pDate: TDate;
  pPaymentMethodId: integer; pAmount: Double; pAlreadyPaid: boolean): boolean;
begin
  try
    try
      result := false;
      with QueryInsertRechZahlweg do
      begin
        Close;
        ParamByName('pfirma').ASInteger := pCompanyId;
        ParamByName('prechid').ASInteger := pInvoiceId;
        ParamByName('pdatum').ASDate := pDate;
        ParamByName('pZahlwegId').ASInteger := pPaymentMethodId;
        ParamByName('Betrag').ASFloat := pAmount;
        ParamByName('verbucht').ASBoolean := true;
        ExecSQL;
        result := true;
      end;
    except on e : Exception do
      begin
        Log.WriteToLog(pCompanyName, pCompanyId,'<TTM> InsertRechnungZahlweg Error: ' +
         e.Message, lmtError);
      end;
    end;
  finally
    QueryInsertRechZahlweg.Close;
  end;
end;

function TTM.GetBoolean(aStr: String): Boolean;
begin
  if aStr = 'T' then
    Result := True
  else
    Result := False;
end;

function TTM.ReadGlobalValue2(pConnection: TFDConnection; FieldName: String;
  ADefault: Variant; aTyp: String): Variant;
var
  aQuery: TFDQuery;
begin
  with TableDiverses2 do
  begin
    Connection := pConnection;
    Open;
    REfresh;
    if FieldDefs.IndexOf(FieldName) = -1 then
    begin
      Close;
      aQuery := TFDQuery.Create(nil);
      aQuery.Connection := pConnection;
      aQuery.SQL.Add('ALTER TABLE Diverses2 ADD ' + FieldName + ' ' + aTyp);
      aQuery.execSQL;
      aQuery.Transaction.CommitRetaining; // !!!!
      aQuery.SQL.Clear;
      aQuery.SQL.Add('Update Diverses2 SET ' + FieldName + ' = ''' +
        ADefault + '''');
      aQuery.execSQL;
      aQuery.SQL.Clear;
      aQuery.SQL.Add('SELECT ' + FieldName + ' FROM Diverses2 ');
      aQuery.Open;
      Result := aQuery.FieldByName(FieldName).Value;
      aQuery.Close;
      aQuery.Free;
      Unprepare;
      Prepare;
      Open;
    end;
    if FieldByName(FieldName).Value = null then
    begin
      Edit;
      FieldByName(FieldName).Value := ADefault;
      Post;
    end;
    Result := FieldByName(FieldName).Value;
    close;
  end;
end;

function TTM.BetragToFloat(s: string; pCompanyName: string): double;
var
  posit: byte;
begin
  Result := 0;
  posit := Pos(FormatSettings.ThousandSeparator, s);
  repeat
    Delete(s, posit, 1);
    posit := Pos(FormatSettings.ThousandSeparator, s);
  until (posit = 0);
  try
    Result := StrToFloat(s);
  except
    Log.WriteToLog(pCompanyName, 0,'<TTM> Dieser Wert ist keine Zahl: '+ s);
  end;
end;

function TTM.WriteToGastkontoRechnung(pConnection: TFDConnection;
  pTischNr: string; pTime: TTime; pBetrag, pMehrwertsteuer: double;
  pKellnerNr, pZahlwegID: Integer; ptext: string; pFirma: Integer; pDiscount: double;
  var pResultString: string; pCompanyName: string): Boolean;
var
  pfelixDate: TDateTime;

begin
  Result := True;
  try

    with FDStoredProcGastKontoRechnung do
    begin
      Close;
      Connection := pConnection;
      ParamByName('iFirma').AsInteger := pFirma;
      ParamByName('iTischNr').AsInteger := StrToInt(pTischNr);
      ParamByName('iZahlwegID').AsInteger := pZahlwegID;
      ParamByName('iTime').AsDateTime := pTime;
      ParamByName('iValue').AsFloat := pBetrag;
      ParamByName('iMwst').AsFloat := pMehrwertsteuer;
      ParamByName('iText').AsString := ptext;
      ParamByName('iDiscount').AsFloat := pDiscount;
      ExecProc;
      if ParamByName('Oresult').AsInteger = 0 then
      begin
        Log.WriteToLog(pCompanyName, pFirma,'<TTM> '+
          'Schreiben von Rechnung nicht OK, Zahlweg nicht definiert', lmtInfo);
        pResultString :=
          'Schreiben von Rechnung nicht OK, Zahlweg nicht definiert';
        Result := False;
        // ConnectionFelix.Transaction.Rollback;
      end;
      // else
      // begin
      // ConnectionFelix.Transaction.Commit;
      // end;

      Log.WriteToLog(pCompanyName, pFirma,'<TTM> Aufbuchen von ' + Format('%.2n', [pBetrag])
        + ',- Zahlweg ' + IntToStr(pZahlwegID), lmtInfo);
    end;
  except
    on e: Exception do
    begin
      Log.WriteToLog(pCompanyName, pFirma,'<TTM> WriteToGastkontoRechnung: ' +
        e.Message, lmtError);
      // ConnectionFelix.Transaction.Rollback;
      Result := False;
      raise;
    end;
  end;
  QueryProcGastkontoRechnung.Close;
  FDStoredProcGastKontoRechnung.Close;
end;


function TTM.getLeistungsID1(pConnection: TFDConnection;
  pFirma, pKasseId: Integer; pHauptGruppeID: string): Integer;
begin
  TableUmsatzzuordnung.Close;

  TableUmsatzzuordnung.Connection := pConnection;
  TableUmsatzzuordnung.Open;
  If TableUmsatzzuordnung.Locate('Firma;KasseID;HauptGruppeID',
    VarArrayOf([pFirma, pKasseId, pHauptGruppeID]), []) Then
    Result := TableUmsatzzuordnung.FieldByName('LeistungsID').AsLargeInt
  else If TableUmsatzzuordnung.Locate('KasseID;HauptGruppeID',
    VarArrayOf([pKasseId, pHauptGruppeID]), []) Then
    Result := TableUmsatzzuordnung.FieldByName('LeistungsID').AsLargeInt
  else If TableUmsatzzuordnung.Locate('HauptGruppeID', pHauptGruppeID, []) Then
    Result := TableUmsatzzuordnung.FieldByName('LeistungsID').AsLargeInt
  else If TableUmsatzzuordnung.Locate('HauptGruppeID', 0, []) Then
    Result := TableUmsatzzuordnung.FieldByName('LeistungsID').AsLargeInt
  else If TableUmsatzzuordnung.Locate('Firma;HauptGruppeID',
    VarArrayOf([pFirma, pHauptGruppeID]), []) Then
    Result := TableUmsatzzuordnung.FieldByName('LeistungsID').AsLargeInt
  else
    Result := 0;
end;

function TTM.SetQueryLeistung(pFirma: Integer;
  pLeistungsID: LongInt; var LeistBez : string; pCompanyName: string): Boolean;
begin
  try
    try
      QueryLeistung.Close;
      QueryLeistung.ParamByName('Firma').AsLargeInt := pFirma;
      QueryLeistung.ParamByName('ID').AsLargeInt := pLeistungsID;
      QueryLeistung.Open;
      Result := not QueryLeistung.FieldByName('ID').IsNull;
      LeistBez := QueryLeistung.FieldByName('LeistungsBezeichnung').AsString;
    except
      on E: Exception do
      begin
        Log.WriteToLog(pCompanyName, pFirma,'<TTM> SetQueryLeistung: ' + E.Message,
          lmtError);
      end;
    end;
  finally
    QueryLeistung.Close;
  end;
end;

function TTM.GetQueryLeistungByName(pFirma: Integer; pCompanyName: string;
  pLeistBez : string; var pLeistungsID: LongInt): Boolean;
begin
  try
    try
      pLeistungsID := 0;
      QueryLeistungByName.Close;
      QueryLeistungByName.ParamByName('Firma').AsLargeInt := pFirma;
      QueryLeistungByName.ParamByName('pLeistBez').AsString := pLeistBez;
      QueryLeistungByName.Open;
      Result := not QueryLeistungByName.FieldByName('ID').IsNull;
      pLeistungsID := QueryLeistungByName.FieldByName('ID').AsLargeInt;
    except
      on E: Exception do
      begin
        pLeistungsID := 0;
        Log.WriteToLog(pCompanyName, pFirma,'<TTM> GetQueryLeistungByName: ' + E.Message,
          lmtError);
      end;
    end;
  finally
    QueryLeistungByName.Close;
  end;
end;

function TTM.GetLeistungByNameOrId(pFirma: Integer; pCompanyName: string;
  var pLeistBez : string; var pLeistungsID: LongInt): Boolean;
begin
  try
    try
      result := false;
      QueryGetServerSettings.Close;
      QueryGetServerSettings.ParamByName('Firma').AsLargeInt := pFirma;
      QueryGetServerSettings.Open;
      if QueryGetServerSettings.FieldByName('Server_GetLEistungByName').ASBoolean then
      begin
        pLeistungsID := 0;
        result := GetQueryLeistungByName(pFirma,pCompanyName,pLeistBez,pLeistungsID);
      end
      else
      begin
        pLeistBez := '';
        result := SetQueryLeistung(pFirma,pLeistungsID,pLeistBez,pCompanyName);
      end;
    except
      on E: Exception do
      begin
        Log.WriteToLog(pCompanyName, pFirma,'<TTM> GetLeistungByNameOrId: ' + E.Message,
          lmtError);
      end;
    end;
  finally
    QueryGetServerSettings.Close;
  end;
end;


procedure TTM.getRebookings(pConnection: TFDConnection; pDate: TDateTime;
  pFirma: string; pCompanyName: string);
var
  rowOfFile, ALeistungsID: Integer;
  aLeistBez: string;
begin
  With QueryDoSomething Do
    try
      Close;
      Connection := pConnection;
      SQL.Clear;
      SQL.Add('select sum(menge*betrag) AS Betrag, sum(menge) AS Menge, leistungsid FROM  KassenJournal');
      SQL.Add('WHERE Datum = ''' + DateToStr(pDate) + ''' AND');
      SQL.Add('BearbeiterID IS NULL AND Firma = ' + pFirma);
      SQL.Add('AND LeistungsID IN');
      SQL.Add('(SELECT LeistungsID FROM Kass_Tischzuordnung)');
      SQL.Add('GROUP BY LeistungsID');
      Open;
      while not EOF do
      begin
        TableRechnung.Connection := pConnection;
        TableRechnung.Open;
        ALeistungsID := FieldByName('LeistungsID').AsLargeInt;
        TableRechnungsKonto.Connection := pConnection;
        TableRechnungsKonto.Open;
        if ((TableRechnung.FieldByName('Datum').AsDateTime = pDate) and
          ((TableRechnung.FieldByName('Rechnungsnummer').AsLargeInt = 0) or
          (TableRechnung.FieldByName('Rechnungsnummer').AsLargeInt = 99999))) OR

        // (TableRechnung.FieldByName('Rechnungsnummer').AsLargeInt = 0)) OR
          TableRechnung.Locate('Firma;Rechnungsnummer;Datum',
          VarArrayOf([pFirma, 0, pDate]), []) then
        begin
          TableRechnungsKonto.Append;
          TableRechnungsKonto.FieldByName('ID').AsLargeInt :=
            GetGeneratorID(pConnection, 'id', 1, pCompanyName);
          TableRechnungsKonto.FieldByName('Datum').AsDateTime :=
            GetFelixDate(pConnection, pFirma);
          TableRechnungsKonto.FieldByName('LeistungsID').AsLargeInt :=
            ALeistungsID;
          TableRechnungsKonto.FieldByName('Menge').AsLargeInt :=
            FieldByName('Menge').AsLargeInt;
          TableRechnungsKonto.FieldByName('GesamtBetrag').AsCurrency :=
            -FieldByName('Betrag').AsFloat;
          SetQueryLeistung(StrToInt(pFirma), ALeistungsID, aLeistBez,pCompanyName);
          TableRechnungsKonto.FieldByName('LeistungsText').AsString := aLeistBez;
          TableRechnungsKonto.Post;

        end
        else
        begin
          Log.WriteToLog(pCompanyName, StrToInt(pFirma),'<TTM> '+
            'Fehler in BucheUmsatz: Rechnung nicht gefunden gefunden | LeistungsId: '
            + IntToStr(ALeistungsID), lmtError);
        end;
        next;
      end;

    finally
      TableRechnung.Close;
      TableRechnungsKonto.Close;
    end;

end;

function TTM.getZahlweg(pCompanyName: string; pFirma : integer; pZahlweg: integer): integer;
begin
  try
    with QueryGetFelixZahlweg do
    begin
      close;
      ParamByName('pZahlwegID').AsInteger := pZahlweg;
      open;
      result := FieldByName('ZahlwgIDFelix').AsInteger;
    end;
  except
    on e: Exception do
    begin
      Log.WriteToLog(pCompanyName, pFirma,'<TTM> getZahlweg: ' +
        e.Message, lmtError);
      result := 1;
    end;
  end;
end;

procedure TTM.setAllRebookingsToNull(pConnection: TFDConnection;
  pDate: TDateTime; pFirma: string);
begin
  With QueryDoSomething Do
  Begin
    Close;
    Connection := pConnection;
    SQL.Clear;
    SQL.Add('UPDATE KassenJournal');
    SQL.Add('SET Menge = 0');
    SQL.Add('WHERE Datum = ''' + DateToStr(pDate) + ''' AND');
    SQL.Add('BearbeiterID IS NULL AND Firma = ' + pFirma);
    SQL.Add('AND LeistungsID IN');
    SQL.Add('(SELECT LeistungsID FROM Kass_Tischzuordnung)');
    execSQL;
  End;
end;

procedure TTM.WriteToTableRechnungskonto(
  pFirma, pLeistId: Integer; pMenge: Integer; pGesamtbetrag: double;
  pRechId: Int64; pFelixDate: TDate; pLeisungsText : string; pCompanyName: string);
begin
  try
    with QueryInsertRechnungskonto do
    begin
      Close;
      ParamByName('Datum').AsDateTime := pFelixDate;
      ParamByName('RechnungsId').Value := pRechId;
      ParamByName('Firma').AsInteger := pFirma;
      ParamByName('LeistungsID').Value := pLeistId;
      ParamByName('Menge').Value := pMenge;
      ParamByName('GesamtBetrag').Value := pGesamtbetrag;
      ParamByName('LeistungsText').AsString := pLeisungsText;
      Log.WriteToLog(pCompanyName, pFirma,'<TTM> Buche: LeistungsId: ' + IntToStr(pLeistId) +
          ' Menge: ' +IntToStr(pMenge)+ ' Betrag: '+FloatToStr(pGesamtbetrag)
          , lmtInfo);
      ExecSQL;
    end;
  except
    on e: Exception do
      Log.WriteToLog(pCompanyName, pFirma,'<TTM> WriteToTableRechnungskonto: ' +
        e.Message, lmtError);
  end;
end;

procedure TTM.InsertKreditOffen(pConnection: TFDConnection; pCompanyID: Int64;
  pBetrag: double; pZahlwegID: Int64; pDatum: TDateTime;
  pRechNr, pReservID: Int64; pCompanyName: string);
var
  qInsertKreditOffen: TFDQuery;
begin
  try
    qInsertKreditOffen := TFDQuery.Create(nil);
    qInsertKreditOffen.Connection := pConnection;
    qInsertKreditOffen.SQL.Add
      ('insert into kreditoffen (ID, Firma, Betrag, ZahlwegID, Datum, RechNr, ReservID)');
    qInsertKreditOffen.SQL.Add
      ('values(GEN_ID(ID, 1), :Firma, :Betrag, :ZahlwegID, :Datum, :RechNr, :ReservID)');

    qInsertKreditOffen.ParamByName('Firma').AsLargeInt := pCompanyID;
    qInsertKreditOffen.ParamByName('Betrag').AsFloat := pBetrag;
    qInsertKreditOffen.ParamByName('ZahlwegID').AsLargeInt := pZahlwegID;
    qInsertKreditOffen.ParamByName('Datum').AsDateTime := pDatum;
    qInsertKreditOffen.ParamByName('RechNr').AsLargeInt := pRechNr;
    if pReservID <> 0 then
      qInsertKreditOffen.ParamByName('ReservID').AsLargeInt := pReservID
    else
      qInsertKreditOffen.ParamByName('ReservID').Clear;
    qInsertKreditOffen.execSQL;
  except
    on e: Exception do
      Log.WriteToLog(pCompanyName, pCompanyID,'<TTM> InsertKreditOffen: ' +
        e.Message, lmtError);
  end;
end;


procedure TTM.WriteLeistungToGastKontoIB(pConnection: TFDConnection;
  pDatum: TDate; pFirma, pMitarbeiterId, pKassaID, ALeistungsID,
  AMenge: LongInt; ABetrag: double; AAufRechnungsAdresse, AFix, AInTABSGebucht,
  InKassenJournal: Boolean; ARechnungsText, AStornoGrund: String;
  AErfassungDurch, AZahlArt, AReservID: LongInt;
  pArrangementID, pVonReservID: Variant; pCompanyName: string);
begin
  if AMenge = 0 then
    exit;
  try
    with insertGKonto do
    begin
      Close;
      Connection := pConnection;
      ParamByName('Firma').AsLargeInt := pFirma;
      ParamByName('BearbeiterID').Value := null;
      ParamByName('ReservID').AsLargeInt := AReservID;
      ParamByName('Datum').AsDateTime := pDatum;
      ParamByName('LeistungsText').AsString := ARechnungsText;
      ParamByName('Menge').AsLargeInt := AMenge;
      ParamByName('Betrag').AsFloat := ABetrag;
      ParamByName('LeistungsID').AsLargeInt := ALeistungsID;
      ParamByName('ArrangementID').Value := pArrangementID;
      // Nur der TagesabschluÃŸ verbucht Fixleistungen und ruft diese Funktion
      // mit InTABSGebucht = TRUE auf..
      ParamByName('Fix').AsBoolean := AFix;
      // Je nach Zahlart, wird das Feld AufRechnungsadresse gesteuert.
      // Wurde keine Zahlart Ã¼bergeben (-1) dann wird der Übergebene Wert
      // AAufRechnungsadresse genommen
      // für die Werte 0,2,3,4,9 ist noch nichst definiert!
      begin
        case AZahlArt of
          - 1, 0, 2, 3, 4, 9:
            ParamByName('AufRechnungsAdresse').AsBoolean :=
              AAufRechnungsAdresse;
          // Selbstzahler
          1:
            ParamByName('AufRechnungsAdresse').AsBoolean := False;
          // Full Credit
          5:
            ParamByName('AufRechnungsAdresse').AsBoolean := True;
          // Fix = FullCredit, Extras = Selbstzahler
          // InTabsGebucht ist gleich wie Fix (siehe Fix weiter oben)
          7:
            ParamByName('AufRechnungsAdresse').AsBoolean := AInTABSGebucht;
        end;
      end;
      ParamByName('InTABSGebucht').AsBoolean := AInTABSGebucht;
      execSQL;
    end;
    if InKassenJournal then
    begin
      if (ARechnungsText = '') or ((AStornoGrund <> '') And (AMenge < 0)) then
        ARechnungsText := AStornoGrund;
      WriteToKassenJournal(pConnection, pDatum, ARechnungsText, null, AMenge,
        ALeistungsID, pArrangementID, AErfassungDurch, AReservID, ABetrag, True,
        pFirma, null, pKassaID, null,pCompanyName);
    end;
  except
    on e: Exception do
    begin
      Log.WriteToLog(pCompanyName, pFirma,'<TTM> WriteToGastKontoIB: ' +
        e.Message, lmtError);
    end;
  end;
end;

function TTM.ReadGlobalValue(pConnection: TFDConnection; FieldName: String;
  ADefault: Variant; aTyp: String): Variant;
var
  aQuery: TFDQuery;
begin
  with TableDiverses do
  begin
    TableDiverses.Connection := pConnection;
    Open;
    REfresh;
    if FieldDefs.IndexOf(FieldName) = -1 then
    begin
      Close;

      aQuery := TFDQuery.Create(nil);
      aQuery.Connection := pConnection;
      aQuery.SQL.Add('ALTER TABLE Diverses ADD ' + FieldName + ' ' + aTyp);
      aQuery.execSQL;
      aQuery.Transaction.CommitRetaining; // !!!!
      aQuery.SQL.Clear;
      aQuery.SQL.Add('Update Diverses SET ' + FieldName + ' = ''' +
        ADefault + '''');
      aQuery.execSQL;
      aQuery.SQL.Clear;
      aQuery.SQL.Add('SELECT ' + FieldName + ' FROM Diverses ');
      aQuery.Open;
      Result := aQuery.FieldByName(FieldName).Value;
      aQuery.Close;
      aQuery.Free;
      Unprepare;
      Prepare;
      Open;
    end
    else
    begin
      if FieldByName(FieldName).Value = null then
      begin
        Edit;
        FieldByName(FieldName).Value := ADefault;
        Post;
      end;
      Result := FieldByName(FieldName).Value;
    end;
  end;
end;

end.
