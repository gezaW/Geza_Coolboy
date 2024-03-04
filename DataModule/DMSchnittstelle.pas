unit DMSchnittstelle;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, Variants, IBODataset, IB_Components, IB_Access;

type
  TDataSchnittstelle = class(TDataModule)
    TableAnlageTelefon: TIBOTable;
    TableAnlageKasse: TIBOTable;
    QueryGebuehrenTelefon: TIBOQuery;
    QueryGebuehrenKasse: TIBOQuery;
    Query_GetZimmerID: TIBOQuery;
    Query_GetApparateNr: TIBOQuery;
    DataSourceGebuehrenKasse: TDataSource;
    DataSourceGebuehrenTelefon: TDataSource;
    QueryGebuehrenKasseFirma: TLargeIntField;
    QueryGebuehrenKasseKellNr: TLargeIntField;
    QueryGebuehrenKasseTischNr: TWideStringField;
    QueryGebuehrenKasseDatum: TDateField;
    QueryGebuehrenKasseZeit: TTimeField;
    QueryGebuehrenKasseZimmerID: TLargeIntField;
    QueryGebuehrenKasseBetrag: TFloatField;
    QueryGebuehrenKasseLeistungsID: TLargeIntField;
    QueryGebuehrenKasseLookLeistung: TWideStringField;
    TableMessageTV: TIBOTable;
    QueryGebuehrenTelefonFirma: TLargeIntField;
    QueryGebuehrenTelefonApparatnr: TLargeIntField;
    QueryGebuehrenTelefonGespraechDatum: TDateField;
    QueryGebuehrenTelefonGespraechBeginnZeit: TTimeField;
    QueryGebuehrenTelefonGespraechEndeZeit: TTimeField;
    QueryGebuehrenTelefonGebuehreneinheit: TLargeIntField;
    QueryGebuehrenTelefonZielnummer: TWideStringField;
    QueryGebuehrenTelefonEntgeld: TFloatField;
    TableGastInfo: TIBOTable;
    QueryCheckIn: TIBOQuery;
    TableBankZuKasse: TIBOTable;
    TableKasseZuBank: TIBOTable;
    QueryGMS: TIBOQuery;
    DataSourceGMS: TDataSource;
    TableExterneSchnittstellen: TIBOTable;
    QueryGMSKorrekt: TIBOQuery;
    StringField1: TWideStringField;
    IntegerField1: TLargeIntField;
    CurrencyField1: TCurrencyField;
    StringField2: TWideStringField;
    IntegerField2: TLargeIntField;
    DataSourceGMSKorrekt: TDataSource;
    QueryGMSKorrektJournalArchivID: TLargeIntField;
    QueryGMSKorrektArtikelID: TLargeIntField;
    QueryGMSBezeichnung: TWideStringField;
    QueryGMSMenge: TFloatField;
    QueryGMSBetrag: TCurrencyField;
    QueryGMSNachname: TWideStringField;
    TableTischzuordnung: TIBOTable;
    TableTischzuordnungTischVon: TLargeIntField;
    TableTischzuordnungTischBis: TLargeIntField;
    TableTischzuordnungLeistungsID: TLargeIntField;
    TableTischzuordnungLeistungsBez: TWideStringField;
    TableTischzuordnungSteuerID: TFloatField;
    TableTischzuordnungSteuer: TFloatField;
    TableAnlageKeyCard: TIBOTable;
    TableKeySendDataToServer: TIBOTable;
    QueryGMSDATUM: TDateTimeField;
    QueryGMSZEIT: TDateTimeField;
    QueryGMSKorrektDATUM: TDateTimeField;
    QueryGMSKorrektZEIT: TDateTimeField;
    QueryGMSZIMMERID: TLargeIntField;
    QueryFelix: TIBOQuery;
    TableRechzahlweg: TIBOTable;
    TableLosungszuordnung: TIBOTable;
    TableSendToTesax: TIBOTable;
    TableGetFromTesa: TIBOTable;
    QueryJournalKorrekt: TIBOQuery;
    TableTelefonapparate: TIBOTable;
    DataSourceTelefonapparate: TDataSource;
    Table_SendDataToServer: TIBOTable;
    TableLeistungenSkidata: TIBOTable;
    TableTelefonapparateFIRMA: TLargeIntField;
    TableTelefonapparateID: TLargeIntField;
    TableTelefonapparateAPPARATENR: TLargeIntField;
    TableTelefonapparateZIMMERID: TLargeIntField;
    TableTelefonapparateABTEILUNG: TWideStringField;
    TableTelefonapparateZIMMERAPPARAT: TWideStringField;
    TableTelefonapparateZUSTAND: TWideStringField;
    TableTelefonapparateCHANGEZUSTAND: TWideStringField;
    TableTelefonapparateGASTNAME: TWideStringField;
    TableTelefonapparatePROTOKOLLIEREN: TWideStringField;
    TableTelefonapparateWECKZEIT: TDateTimeField;
    TableTelefonapparateWECKDATUMVON: TDateTimeField;
    TableTelefonapparateWECKDATUMBIS: TDateTimeField;
    TableTelefonapparateLETZTEWECKZEIT: TDateTimeField;
    TableTelefonapparateZUSTANDKASSE: TWideStringField;
    TableTelefonapparateCHANGEZUSTANDKASSE: TWideStringField;
    TableTelefonapparateAPPARATENR2: TLargeIntField;
    TableTelefonapparateSECURITY: TWideStringField;
    TableTelefonapparateAPPARATENR3: TLargeIntField;
    TableTelefonapparateAPPARATENR4: TLargeIntField;
    TableTelefonapparateAPPARATENR5: TLargeIntField;
    TableTelefonapparateAPPARATENR6: TLargeIntField;
    TableTelefonapparateAPPARATENR7: TLargeIntField;
    TableTelefonapparateAPPARATENR8: TLargeIntField;
    TableTelefonapparateAPPARATENR9: TLargeIntField;
    TableTelefonapparateAPPARATENR10: TLargeIntField;
    TableTelefonapparateAPPARATENR11: TLargeIntField;
    TableTelefonapparateAPPARATENR12: TLargeIntField;
    TableTelefonapparateAPPARATENR13: TLargeIntField;
    TableTelefonapparateAPPARATENR14: TLargeIntField;
    TableTelefonapparateAPPARATENR15: TLargeIntField;
    TableTelefonapparateZUSTANDTV: TWideStringField;
    TableTelefonapparateCHANGEZUSTANDTV: TWideStringField;
    QueryGebuehrenKasseTEXT: TWideStringField;
    QueryCheckKasse: TIBOQuery;
    TableUmsatzzuordnung: TIBOTable;
    QueryKasse: TIBOQuery;
    TableEinstellKasse: TIBOTable;
    QueryCheckGMSDone: TIBOQuery;
    QueryCheckUmsatzTag: TIBOQuery;
    QueryCheckWaiterReservID: TIBOQuery;
    IBOQueryKey_Features: TIBOQuery;
    IB_QueryCheckKassaLosung: TIB_Query;
    procedure TableRechzahlwegAfterInsert(DataSet: TDataSet);
    procedure DataSchnittstelleCreate(Sender: TObject);
    procedure DataSchnittstelleDestroy(Sender: TObject);
  private
    FFelixUmsatzLosung,
    FFelixNachKasse: Boolean;
    function CheckUmsatzTag(pDatum: TDateTime): Boolean;
    //if the waiter cash should be stored on an PayMasterRoom...
    function GetWaiterReservID(pWaiterID: LongInt): LongInt;
  public
    procedure SetFilter;
    procedure ZimmerdatenAktualisieren;
    procedure SetKeyCard(pReservID: LongInt);
    Procedure LosungenKellner(pAuto: Boolean);
    procedure UmsatzKasse;
    function CheckKasse(pReservID: LongInt): Boolean;
  end;

var
  DataSchnittstelle: TDataSchnittstelle;

implementation

{$R *.DFM}

uses Global, MainWin, DMSonstige, DMNachschlag, KeyCard, DMFaktura,
  DMStatistik, Utilities, DMBase, DMDesign, DMKasse, DMReservierung;

resourcestring
  resDMSchnittstelle1 = 'ACHTUNG: Der Gast hat noch was in der Kasse offen!';
  resDMSchnittstelle2 = 'Soll trotzdem eine Rechnung gemacht werden?';
  resDMSchnittstelle3 = 'Fehler in CheckKasse';
  resDMSchnittstelle4 = 'Umsatz Kasse';
  resDMSchnittstelle5 = 'Umsatz aus GMS Kassa Touch übernehmen: Rechnung nicht gefunden';
  resDMSchnittstelle6 = 'Fehler1: Keine Leistung zu Umsatz definiert!!';
  resDMSchnittstelle7 = 'Fehler2: Keine Leistung zu Umsatz definiert!!';
  resDMSchnittstelle8 = 'Fehler3: Keine Leistung zu Umsatz definiert!!';
  resDMSchnittstelle9 = 'Fehler4: Keine Leistung zu Umsatz definiert!!';
  resDMSchnittstelle10 = 'Fehler5: Keine Leistung zu Umsatz definiert!!';
  resDMSchnittstelle11 = 'Fehler6: Keine Leistung zu Umsatz definiert!!';
  resDMSchnittstelle12 = 'Die Losungen des Tages wurden schon übernommen und können nicht nochmal übernommen werden!';
  resDMSchnittstelle13 = 'Buchen Sie die Beträge manuell auf!';
  resDMSchnittstelle14 = 'Losungen wurden verbucht';
  resDMSchnittstelle15 = 'Losung';

procedure TDataSchnittstelle.SetFilter;
begin
  if cFirma > 0 then
  begin
  end;
  try
    MainWindow.MenuItemTelefonAbrechnung.Visible := FALSE;
    with TableAnlageTelefon do
    begin
      Close;
      Filter := 'Anlage_Typ=''Telefon'' AND Firma = '+IntToStr(cFirma);
      Filtered := TRUE;
      Open;
      if not FieldByName('Typ').IsNull then
      begin
        MainWindow.Telefon1.Enabled := TRUE;
        MainWindow.MenuItemTelefonAbrechnung.Visible := TRUE;
        MainWindow.MenuItemAnschlusse.Visible := TRUE;
        MainWindow.MenuItemTelefonAbrechnung.Caption :=
          FieldByName('Typ').AsString;
      end;
      Close;
    end;
  except
  end;
  try
    MainWindow.MenuItemKasseAbrechnung.Visible := FALSE;
    MainWindow.MenuItemKasseLosungubernehmen.Visible := FALSE;
    with TableAnlageKasse do
    begin
      Close;
      Filter := 'Anlage_Typ=''Kassen'' AND Firma = '+IntToStr(cFirma);
      Filtered := TRUE;
      Open;
      if not FieldByName('Typ').IsNull then
      begin
        MainWindow.N1.Enabled := TRUE;
        MainWindow.MenuItemKasseAbrechnung.Visible := TRUE;
        MainWindow.MenuItemAnschlusse.Visible := TRUE;
        MainWindow.MenuItemKasseAbrechnung.Caption :=
          FieldByName('Typ').AsString;
        if FieldByName('Typ').AsString = 'GMS' then
        begin
          if FieldByName('Path').AsString<> '' then
          begin
            DataKasse.DatabaseKasse.Connected := FALSE;
            DataKasse.DatabaseKasse.AliasName := '';
            DataKasse.DatabaseKasse.Database := FieldByName('Path').AsString;
            DataKasse.DatabaseKasse.Connected := TRUE;
          end;
          MainWindow.MenuItemKasseLosungubernehmen.Visible := TRUE;
        end;
      end;
    end;
  except
    on e:Exception do
    begin
      DBase.WriteToLog('Error Kasse:'+e.Message, TRUE);
    end;
  end;
  try
    MainWindow.MenuItemKarteerstellen.Visible := FALSE;
    with TableAnlageKeyCard do
    begin
      Close;
      Filter := 'Anlage_Typ=''Keycard'' AND Firma = '+IntToStr(cFirma);
      Filtered := TRUE;
      Open;
      if not FieldByName('Typ').IsNull then
      begin
        MainWindow.MenuItemTuerschliesystem.Enabled := TRUE;
        glKeySystem := FieldByName('Typ').asString;
        MainWindow.MenuItemKarteerstellen.Visible := TRUE;
        MainWindow.MenuItemAnschlusse.Visible := TRUE;
      end;
      Close;
    end;
  except
  end;
  If glExterneSchnittstelle Then
  with TableExterneSchnittstellen do
  Begin
    Open;
    If RecordCount > 0 Then
    begin
      MainWindow.Sonstige1.Enabled := TRUE;
      MainWindow.MenutItemAnschlussExtern.Visible := TRUE;
        MainWindow.MenuItemAnschlusse.Visible := TRUE;
      MainWindow.MenutItemAnschlussExtern.Caption := FieldByName('Bezeichnung').AsString;
    end;
    Close;
  End;
  MainWindow.MenuItemStornoKredit.Visible := glKreditAnschluss;
  MainWindow.MenuItemKreditkarten1.Enabled := glKreditAnschluss;
  if glSkidataKarten then
  begin
    MainWindow.Sonstige1.Enabled := TRUE;
    MainWindow.MenuItemVerbuchenSkikarten.Visible := TRUE;
    MainWindow.MenutItemAnschlussExternSkidatakartenimportieren.Visible := TRUE;
  end;
  MainWindow.MenuItemListenKontrollMeldescheine.Visible := glMeldeschein;

end;

function TDataSchnittstelle.CheckKasse(pReservID: LongInt): Boolean;
begin
  Result := TRUE;
  try
    if MainWindow.MenuItemKasseAbrechnung.Caption = 'GMS' then
    begin
      with QueryCheckKasse do
      begin
        Close;
        ParamByName('ReservID').AsLargeInt := pReservID;
        Open;
        Result := FieldByName('OffeneTischID').IsNull;
        Close;
      end;
      if not Result  then
      begin
        if DataDesign.ShowMessageDlgSkin(resDMSchnittstelle1+#13+
          resDMSchnittstelle2, mtConfirmation, [mbYes, mbNo], 0) = mrYes then
            Result := TRUE;
      end;
    end;
  except
    on e:Exception do
      DBase.WriteToLog(resDMSchnittstelle3+ #13+e.message, TRUE);
  end;
end;

procedure TDataSchnittstelle.DataSchnittstelleCreate(Sender: TObject);
begin
  DBase.SetDefaulftIBConnection(self);
  SetFilter;
  TableEinstellKasse.DatabaseName := 'KasseFelix';
  QueryKasse.DatabaseName := 'KasseFelix';
  QueryCheckKasse.DatabaseName := 'KasseFelix';
  QueryCheckWaiterReservID.DatabaseName := 'KasseFelix';
  TableBankZuKasse.DatabaseName := 'KasseFelix';
  TableKasseZuBank.DatabaseName := 'KasseFelix';
  TableEinstellKasse.DatabaseName := 'KasseFelix';
  QueryCheckUmsatzTag.DatabaseName := 'KasseFelix';
  TableEinstellKasse.IB_Connection := DataKasse.DatabaseKasse;
  QueryKasse.IB_Connection := DataKasse.DatabaseKasse;
  QueryCheckKasse.IB_Connection := DataKasse.DatabaseKasse;
  QueryCheckWaiterReservID.IB_Connection := DataKasse.DatabaseKasse;
  TableBankZuKasse.IB_Connection := DataKasse.DatabaseKasse;
  TableKasseZuBank.IB_Connection := DataKasse.DatabaseKasse;
  TableEinstellKasse.IB_Connection := DataKasse.DatabaseKasse;
  QueryCheckUmsatzTag.IB_Connection := DataKasse.DatabaseKasse;
  QueryGMS.IB_Connection := DataKasse.DatabaseKasse;
end;

procedure TDataSchnittstelle.DataSchnittstelleDestroy(Sender: TObject);
begin
  TableAnlageTelefon.Close;
  TableAnlageKasse.Close;
  TableMessageTV.Close;
end;

function TDataSchnittstelle.GetWaiterReservID(pWaiterID: LongInt): LongInt;
begin
  with QueryCheckWaiterReservID do
  begin
    Close;
    ParamByName('KellnerID').AsLargeInt := pWaiterID;
    Open;
    Result := FieldByName('FelixReservID').AsLargeInt;
    Close;
  end;
end;

procedure TDataSchnittstelle.ZimmerdatenAktualisieren;
begin
  //Wenn überhaupt eine Kasse installiert ist...
  if MainWindow.MenuItemKasseAbrechnung.Visible and
    ((MainWindow.MenuItemTelefonAbrechnung.Caption = 'Viertl') or
     (MainWindow.MenuItemTelefonAbrechnung.Caption = 'Mers')) then
  begin
    with TableGastinfo do
    begin
      Open;
      while not EOF do Delete;
      QueryCheckIn.Close;
      QueryCheckIn.ParamByName('Firma').AsLargeInt := cFirma;
      QueryCheckIn.Open;
      QueryCheckIn.First;
      while not QueryCheckIn.EOF do
      begin
        if not QueryCheckIn.FieldByName('SperrenExtra').AsBoolean then
        begin
          Append;
          FieldByName('Zi_Pers').AsString :=
            QueryCheckIn.FieldByName('GastName').AsString;
          FieldByName('Pers_Nr').AsString := QueryCheckIn.FieldByName('ZimmerID').AsString;
          FieldByName('Termin_Nr').AsString := QueryCheckIn.FieldByName('ZimmerID').AsString;
          FieldByName('Von').AsDateTime :=
            QueryCheckIn.FieldByName('Anreisedatum').AsDateTime;
          FieldByName('Zi_Nummer').AsString := QueryCheckIn.FieldByName('ZimmerID').AsString;
          FieldByName('Belegt').AsBoolean := TRUE;
          Post;
        end;
        QueryCheckIn.Next;
      end;
      QueryCheckIn.Close;
      Close;
    end;
  end;
end;

procedure TDataSchnittstelle.SetKeyCard(pReservID: LongInt);
begin
  If MainWindow.MenuItemKarteerstellen.Visible Then
  Begin
    fmKeyCard := TfmKeyCard.Create(Self);
    With fmKeyCard Do
    Try
      ReservID := pReservID;
      ShowModal;
    Finally
      Release;
    End;    
  End;

end;

procedure TDataSchnittstelle.TableRechzahlwegAfterInsert(DataSet: TDataSet);
begin
	DataFaktura.GetNextID('RechnungsZahlweg', TableRechZahlweg);
end;

procedure TDataSchnittstelle.UmsatzKasse;
var aFelixDate: TDateTime;
    aLeistungsID: LongInt;

  procedure BucheUmsatz(pBetrag: Currency);
  begin
    DataSonstige.WriteToKassenJournal(resDMSchnittstelle4, null, 1, aLeistungsID, null, 12, null,
      pBetrag, FALSE);
    with DataFaktura do
    begin
      TableRechnung.Open;
      TableRechnungsKonto.Open;
      if ((TableRechnung.FieldByName('Datum').AsDateTime = aFelixDate) and
           ((TableRechnung.FieldByName('Rechnungsnummer').AsLargeInt = 0) or (TableRechnung.FieldByName('Rechnungsnummer').AsLargeInt = 99999))) OR
        TableRechnung.Locate('Firma;Rechnungsnummer;Datum', VarArrayOf([cFirma, 0, gl.FelixDate]), []) then
      begin
        TableRechnungskonto.Append;
        TableRechnungskonto.FieldByName('Datum').AsDateTime := gl.FelixDate;
        TableRechnungskonto.FieldByName('LeistungsID').AsLargeInt := aLeistungsID;
        TableRechnungskonto.FieldByName('Menge').AsLargeInt := 1;
        TableRechnungskonto.FieldByName('GesamtBetrag').AsCurrency := pBetrag;
        DataSonstige.SetQueryLeistung(aLeistungsID);
        TableRechnungskonto.FieldByName('LeistungsText').AsString :=
          DataSonstige.QueryLeistung.FieldByName('LeistungsBezeichnung').AsString;
        TableRechnungskonto.Post;
      end else
        DataDesign.ShowMessageSkin(resDMSchnittstelle5);
    end;
    
  end;

begin
  TableEinstellKasse.IB_Connection := DataKasse.DatabaseKasse;;
  TableEinstellKasse.Open;
  FFelixUmsatzLosung := TableEinstellKasse.FieldByName('FelixUmsatzLosung').AsBoolean;
  FFelixNachKAsse := TableEinstellKasse.FieldByName('FelixNachKassen').AsBoolean;
  TableEinstellKasse.Close;
  If FFelixUmsatzLosung Then
  Begin
    afelixDate := gl.FelixDate;
    with QueryCheckGMSDone do
    begin
      Close;
      ParamByName('Erfassungdurch').AsLargeInt := 12;
      ParamByName('Firma').AsLargeInt := cfirma;
      ParamByName('Datum').AsDateTime := aFelixDate;
      ParamByName('Text').AsString := resDMSchnittstelle4+'%';
      open;
      if not FieldBYName('ID').IsNull then
        exit;
      
    end;
    TableUmsatzzuordnung.Open;
    //Dann die Umsätze
    With QueryKasse Do
    Begin
      Close;
      SQL.Clear;
      If FFelixNachKAsse Then
        SQL.Add('SELECT j.KasseID, u.HauptGruppeID, sum(j.Betrag*j.Menge) AS Betrag')
      else
        SQL.Add('SELECT u.HauptGruppeID, sum(j.Betrag*j.Menge) AS Betrag');
      SQL.Add('FROM Journal j');
      SQL.Add('LEFT OUTER JOIN Artikel a ON a.Firma = j.Firma AND a.ArtikelID = j.ArtikelID');
      SQL.Add('LEFT OUTER JOIN Untergruppe u ON a.Firma = u.Firma AND a.UntergruppeID = u.UntergruppeID');

      SQL.Add('WHERE j.Datum = '''+DateToStr(afelixDate)+''' and j.JournalTyp = 1');
      SQL.Add('AND (a.ZahlwegID IS NULL)');

{      If FFelixNachKAsse Then
        SQL.Add('SELECT j.KasseID, u.HauptGruppeID, sum(j.Betrag*j.Menge) AS Betrag')
      else
        SQL.Add('SELECT u.HauptGruppeID, sum(j.Betrag*j.Menge) AS Betrag');
      SQL.Add('FROM Journal j');

      SQL.Add('LEFT OUTER JOIN OffeneTische o ON o.Firma = j.Firma AND o.OffeneTischID = j.OffeneTischID');
      SQL.Add('LEFT OUTER JOIN Artikel a ON a.Firma = j.Firma AND a.ArtikelID = j.ArtikelID');
      SQL.Add('LEFT OUTER JOIN Untergruppe u ON a.Firma = u.Firma AND a.UntergruppeID = u.UntergruppeID');
      SQL.Add('LEFT OUTER JOIN Tisch t on t.Firma = o.Firma AND t.TischID = o.TischID');
      SQL.Add('WHERE j.Datum = '''+DateToStr(afelixDate)+''' and j.JournalTyp = 1');
      SQL.Add('AND (NOT (t.TischTYP in (''E'', ''P'', ''W'', ''B'')) OR t.TischTyp IS NULL)');}
      If FFelixNachKAsse Then
        SQL.Add('GROUP BY j.KasseID, u.HauptGruppeID')
      else
        SQL.Add('GROUP BY u.HauptGruppeID');
      Open;
      if RecordCount = 0 then
      begin
        Close;
        SQL[1] := 'FROM JournalArchiv j';
//        SQL[2] := '';
//        SQL[5] := 'LEFT OUTER JOIN Tisch t on t.Firma = j.Firma AND t.TischID = j.TischID';
        Open;
      end;

      First;
      aLeistungsID := 0;
      If FFelixNachKAsse Then
      begin
        While Not EOF Do
        Begin
          if FieldByName('Betrag').AsFloat <> 0 then
          begin
            //Vielleicht ist jedem Kellner eine Leistungs zugeordnet
            If TableUmsatzzuordnung.Locate('Firma;KasseID;HauptGruppeID',
              VarArrayOF([cFirma, FieldByName('KasseID').AsLargeInt ,
                FieldByName('HauptGruppeID').AsLargeInt]) , []) Then
              aLeistungsID := TableUmsatzzuordnung.FieldByName('LeistungsID').AsLargeInt
            //Soonst muss zumindest der 0 Kellner exestieren
            else
            //Vielleicht ist jedem Kellner eine Leistungs zugeordnet
            If TableUmsatzzuordnung.Locate('KasseID;HauptGruppeID',
              VarArrayOF([FieldByName('KasseID').AsLargeInt ,
                FieldByName('HauptGruppeID').AsLargeInt]) , []) Then
              aLeistungsID := TableUmsatzzuordnung.FieldByName('LeistungsID').AsLargeInt
            //Soonst muss zumindest der 0 Kellner exestieren
            else
              DataDesign.ShowMessageSkin(resDMSchnittstelle6+
                FieldByName('KasseID').AsString+':'+
                FieldByName('HauptGruppeID').AsString);
            BucheUmsatz(FieldByName('Betrag').AsFloat);
          end;
          Next;
        End;
      end else
      begin
        While Not EOF Do
        Begin
          if FieldByName('Betrag').AsFloat <> 0 then
          begin
            //Vielleicht ist jedem Kellner eine Leistungs zugeordnet
            If TableUmsatzzuordnung.Locate('Firma;HauptGruppeID',
              VarArrayOf([cFirma, FieldByName('HauptGruppeID').AsLargeInt ]), []) Then
              aLeistungsID := TableUmsatzzuordnung.FieldByName('LeistungsID').AsLargeInt
            //Soonst muss zumindest der 0 Kellner exestieren
            else
            //Vielleicht ist jedem Kellner eine Leistungs zugeordnet
            If TableUmsatzzuordnung.Locate('HauptGruppeID', FieldByName('HauptGruppeID').AsLargeInt , []) Then
              aLeistungsID := TableUmsatzzuordnung.FieldByName('LeistungsID').AsLargeInt
            //Soonst muss zumindest der 0 Kellner exestieren
            else
              If TableUmsatzzuordnung.Locate('HauptGruppeID', 0 , []) Then
                aLeistungsID := TableUmsatzzuordnung.FieldByName('LeistungsID').AsLargeInt
            else DataDesign.ShowMessageSkin(resDMSchnittstelle7+
                   FieldByName('HauptGruppeID').AsString);
            BucheUmsatz(FieldByName('Betrag').AsFloat);
          end;
          Next;
        End;
      end;
      //WEBP wieder abziehen
      Close;
      SQL.Clear;
   {   If FFelixNachKAsse Then
        SQL.Add('SELECT j.KasseID, u.HauptGruppeID, sum(j.Betrag*j.Menge) AS Betrag')
      else
        SQL.Add('SELECT u.HauptGruppeID, sum(j.Betrag*j.Menge) AS Betrag');
      SQL.Add('FROM Journal j');
      SQL.Add('LEFT OUTER JOIN OffeneTische o ON o.Firma = j.Firma AND o.OffeneTischID = j.OffeneTischID');
      SQL.Add('LEFT OUTER JOIN Artikel a ON a.Firma = j.Firma AND a.ArtikelID = j.ArtikelID');
      SQL.Add('LEFT OUTER JOIN Untergruppe u ON a.Firma = u.Firma AND a.UntergruppeID = u.UntergruppeID');
      SQL.Add('LEFT OUTER JOIN Tisch t on t.Firma = o.Firma AND t.TischID = o.TischID');
      SQL.Add('WHERE j.Datum = '''+DateToStr(afelixDate)+''' and j.JournalTyp = 4');
      SQL.Add('AND (t.TischTYP in (''E'', ''P'', ''W'', ''B''))');
      If FFelixNachKAsse Then
        SQL.Add('GROUP BY j.KasseID, u.HauptGruppeID')
      else
        SQL.Add('GROUP BY u.HauptGruppeID');}
      If FFelixNachKAsse Then
        SQL.Add('SELECT j.KasseID, u.HauptGruppeID, sum(j.Betrag*j.Menge) AS Betrag')
      else
        SQL.Add('SELECT u.HauptGruppeID, sum(j.Betrag*j.Menge) AS Betrag');
      SQL.Add('FROM Journal j');
      SQL.Add('LEFT OUTER JOIN Artikel a ON a.Firma = j.Firma AND a.ArtikelID = j.ArtikelID');
      SQL.Add('LEFT OUTER JOIN Untergruppe u ON a.Firma = u.Firma AND a.UntergruppeID = u.UntergruppeID');
      SQL.Add('LEFT OUTER JOIN OffeneTische o ON o.Firma = j.Firma AND o.OffeneTischID = j.OffeneTischID');
      SQL.Add('LEFT OUTER JOIN Tisch t on t.Firma = o.Firma AND t.TischID = o.TischID');
      SQL.Add('LEFT OUTER JOIN OffeneTische vo ON vo.Firma = j.Firma AND vo.OffeneTischID = j.VonOffeneTischID');
      SQL.Add('LEFT OUTER JOIN Tisch Vt ON vt.Firma = vo.Firma AND vo.tischid = Vt.tischID');
      SQL.Add('WHERE j.Datum = '''+DateToStr(afelixDate)+'''');
      SQL.Add('AND (t.TischTYP in (''E'', ''P'', ''W'', ''B''))');
      SQL.Add('AND not (j.ArtikelID IS NULL)');
      SQL.Add('AND (j.JournalTyp in (1,4))');
      SQL.Add('AND (vt.TischTyp IS NULL OR vt.TischTyp = '''' OR VT.TischTyp = '' '' OR vt.TischTyp = ''G'' OR vt.TischTyp = ''Z'' OR VT.TischTyp = ''S'')');
      If FFelixNachKAsse Then
        SQL.Add('GROUP BY j.KasseID, u.HauptGruppeID')
      else
        SQL.Add('GROUP BY u.HauptGruppeID');
      Open;
      if RecordCount = 0 then
      begin
        Close;
        SQL.Clear;
        If FFelixNachKAsse Then
          SQL.Add('SELECT j.KasseID, u.HauptGruppeID, sum(j.Betrag*j.Menge) AS Betrag')
        else
          SQL.Add('SELECT u.HauptGruppeID, sum(j.Betrag*j.Menge) AS Betrag');
        SQL.Add('FROM JournalArchiv j');
        SQL.Add('LEFT OUTER JOIN Artikel a ON a.Firma = j.Firma AND a.ArtikelID = j.ArtikelID');
        SQL.Add('LEFT OUTER JOIN Untergruppe u ON a.Firma = u.Firma AND a.UntergruppeID = u.UntergruppeID');
        SQL.Add('LEFT OUTER JOIN Tisch t on t.Firma = j.Firma AND t.TischID = j.TischID');
        SQL.Add('LEFT OUTER JOIN Tisch Vt ON vt.Firma = j.Firma AND j.VonOffenetischid = Vt.tischID');
        SQL.Add('WHERE j.Datum = '''+DateToStr(afelixDate)+'''');
        SQL.Add('AND (t.TischTYP in (''E'', ''P'', ''W'', ''B''))');
        SQL.Add('AND not (j.ArtikelID IS NULL)');
        SQL.Add('AND (j.JournalTyp in (1,4))');
        SQL.Add('AND (vt.TischTyp IS NULL OR vt.TischTyp = '''' OR VT.TischTyp = '' '' OR vt.TischTyp = ''G'' OR vt.TischTyp = ''Z'' OR VT.TischTyp = ''S'')');
        If FFelixNachKAsse Then
          SQL.Add('GROUP BY j.KasseID, u.HauptGruppeID')
        else
          SQL.Add('GROUP BY u.HauptGruppeID');
        Open;
      end;
      First;
      aLeistungsID := 0;
      If FFelixNachKAsse Then
      begin
        While Not EOF Do
        Begin
          if FieldByName('Betrag').AsFloat <> 0 then
          begin
            //Vielleicht ist jedem Kellner eine Leistungs zugeordnet
            If TableUmsatzzuordnung.Locate('Firma;KasseID;HauptGruppeID',
              VarArrayOF([cFirma, FieldByName('KasseID').AsLargeInt ,
                FieldByName('HauptGruppeID').AsLargeInt]) , []) Then
              aLeistungsID := TableUmsatzzuordnung.FieldByName('LeistungsID').AsLargeInt
            //Soonst muss zumindest der 0 Kellner exestieren
            else
            //Vielleicht ist jedem Kellner eine Leistungs zugeordnet
            If TableUmsatzzuordnung.Locate('KasseID;HauptGruppeID',
              VarArrayOF([ FieldByName('KasseID').AsLargeInt ,
                FieldByName('HauptGruppeID').AsLargeInt]) , []) Then
              aLeistungsID := TableUmsatzzuordnung.FieldByName('LeistungsID').AsLargeInt
            //Soonst muss zumindest der 0 Kellner exestieren
            else
              DataDesign.ShowMessageSkin(resDMSchnittstelle8+
                FieldByName('KasseID').AsString+':'+
                FieldByName('HauptGruppeID').AsString);
            BucheUmsatz(-FieldByName('Betrag').AsFloat);
          end;
          Next;
        End;
      end else
      begin
        While Not EOF Do
        Begin
          if FieldByName('Betrag').AsFloat <> 0 then
          begin
            //Vielleicht ist jedem Kellner eine Leistungs zugeordnet
            If TableUmsatzzuordnung.Locate('HauptGruppeID', FieldByName('HauptGruppeID').AsLargeInt , []) Then
              aLeistungsID := TableUmsatzzuordnung.FieldByName('LeistungsID').AsLargeInt
            //Soonst muss zumindest der 0 Kellner exestieren
            else
              If TableUmsatzzuordnung.Locate('HauptGruppeID', 0 , []) Then
                aLeistungsID := TableUmsatzzuordnung.FieldByName('LeistungsID').AsLargeInt
            else DataDesign.ShowMessageSkin(resDMSchnittstelle9+
                   FieldByName('HauptGruppeID').AsString);
            BucheUmsatz(-FieldByName('Betrag').AsFloat);
          end;
          Next;
        End;
      end;

      //WEBP wieder dazubuchen, welche von einem WEBP Tisch wieder auf einen normalen Tisch gebucht wurden!
      Close;
      SQL.Clear;
      If FFelixNachKAsse Then
        SQL.Add('SELECT j.KasseID, u.HauptGruppeID, sum(j.Betrag*j.Menge) AS Betrag')
      else
        SQL.Add('SELECT u.HauptGruppeID, sum(j.Betrag*j.Menge) AS Betrag');
      SQL.Add('FROM Journal j');
      SQL.Add('LEFT OUTER JOIN Artikel a ON a.Firma = j.Firma AND a.ArtikelID = j.ArtikelID');
      SQL.Add('LEFT OUTER JOIN Untergruppe u ON a.Firma = u.Firma AND a.UntergruppeID = u.UntergruppeID');
      SQL.Add('LEFT OUTER JOIN OffeneTische o ON o.Firma = j.Firma AND o.OffeneTischID = j.OffeneTischID');
      SQL.Add('LEFT OUTER JOIN Tisch t on t.Firma = o.Firma AND t.TischID = o.TischID');
      SQL.Add('LEFT OUTER JOIN OffeneTische vo ON vo.Firma = j.Firma AND vo.OffeneTischID = j.VonOffeneTischID');
      SQL.Add('LEFT OUTER JOIN Tisch Vt ON vt.Firma = vo.Firma AND vo.tischid = Vt.tischID');
      SQL.Add('WHERE j.Datum = '''+DateToStr(afelixDate)+'''');
      SQL.Add('AND (vt.TischTYP in (''E'', ''P'', ''W'', ''B''))');
      SQL.Add('AND not (j.ArtikelID IS NULL)');
      SQL.Add('AND (j.JournalTyp in (4))');
      SQL.Add('AND (t.TischTyp IS NULL OR t.TischTyp = '''' OR T.TischTyp = '' '' OR t.TischTyp = ''G'' OR t.TischTyp = ''Z'' OR T.TischTyp = ''S'')');
      If FFelixNachKAsse Then
        SQL.Add('GROUP BY j.KasseID, u.HauptGruppeID')
      else
        SQL.Add('GROUP BY u.HauptGruppeID');
      Open;
      if RecordCount = 0 then
      begin
        Close;
        SQL.Clear;
        If FFelixNachKAsse Then
          SQL.Add('SELECT j.KasseID, u.HauptGruppeID, sum(j.Betrag*j.Menge) AS Betrag')
        else
          SQL.Add('SELECT u.HauptGruppeID, sum(j.Betrag*j.Menge) AS Betrag');
        SQL.Add('FROM JournalArchiv j');
        SQL.Add('LEFT OUTER JOIN Artikel a ON a.Firma = j.Firma AND a.ArtikelID = j.ArtikelID');
        SQL.Add('LEFT OUTER JOIN Untergruppe u ON a.Firma = u.Firma AND a.UntergruppeID = u.UntergruppeID');
        SQL.Add('LEFT OUTER JOIN Tisch t on t.Firma = j.Firma AND t.TischID = j.TischID');
        SQL.Add('LEFT OUTER JOIN Tisch Vt ON vt.Firma = j.Firma AND j.VonOffenetischid = Vt.tischID');
        SQL.Add('WHERE j.Datum = '''+DateToStr(afelixDate)+'''');
        SQL.Add('AND (vt.TischTYP in (''E'', ''P'', ''W'', ''B''))');
        SQL.Add('AND not (j.ArtikelID IS NULL)');
        SQL.Add('AND (j.JournalTyp in (4))');
        SQL.Add('AND (t.TischTyp IS NULL OR t.TischTyp = '''' OR T.TischTyp = '' '' OR t.TischTyp = ''G'' OR t.TischTyp = ''Z'' OR T.TischTyp = ''S'')');
        If FFelixNachKAsse Then
          SQL.Add('GROUP BY j.KasseID, u.HauptGruppeID')
        else
          SQL.Add('GROUP BY u.HauptGruppeID');
        Open;
      end;


//      Close;
//      SQL.Clear;
//      If FFelixNachKAsse Then
//        SQL.Add('SELECT j.KasseID, u.HauptGruppeID, sum(j.Betrag*j.Menge) AS Betrag')
//      else
//        SQL.Add('SELECT u.HauptGruppeID, sum(j.Betrag*j.Menge) AS Betrag');
//      SQL.Add('FROM Journal j');
//      SQL.Add('LEFT OUTER JOIN OffeneTische o ON o.Firma = j.Firma AND o.OffeneTischID = j.VonOffeneTischID');
//      SQL.Add('LEFT OUTER JOIN Artikel a ON a.Firma = j.Firma AND a.ArtikelID = j.ArtikelID');
//      SQL.Add('LEFT OUTER JOIN Untergruppe u ON a.Firma = u.Firma AND a.UntergruppeID = u.UntergruppeID');
//      SQL.Add('LEFT OUTER JOIN Tisch t on t.Firma = o.Firma AND t.TischID = o.TischID');
//      SQL.Add('WHERE j.Datum = '''+DateToStr(afelixDate)+''' and j.JournalTyp = 4');
//      SQL.Add('AND (t.TischTYP in (''E'', ''P'', ''W'', ''B''))');
//      If FFelixNachKAsse Then
//        SQL.Add('GROUP BY j.KasseID, u.HauptGruppeID')
//      else
//        SQL.Add('GROUP BY u.HauptGruppeID');
//      Open;
//      if RecordCount = 0 then
//      begin
//        Close;
//        SQL[1] := 'FROM JournalArchiv j';
//        SQL[2] := '';
//        SQL[5] := 'LEFT OUTER JOIN Tisch t on t.Firma = j.Firma AND t.TischID = j.VonOffeneTischID';
//        Open;
//      end;
      First;
      aLeistungsID := 0;
      If FFelixNachKAsse Then
      begin
        While Not EOF Do
        Begin
          if FieldByName('Betrag').AsFloat <> 0 then
          begin
            //Vielleicht ist jedem Kellner eine Leistungs zugeordnet
            If TableUmsatzzuordnung.Locate('KasseID;HauptGruppeID',
              VarArrayOF([ FieldByName('KasseID').AsLargeInt ,
                FieldByName('HauptGruppeID').AsLargeInt]) , []) Then
              aLeistungsID := TableUmsatzzuordnung.FieldByName('LeistungsID').AsLargeInt
            //Soonst muss zumindest der 0 Kellner exestieren
            else
              DataDesign.ShowMessageSkin(resDMSchnittstelle10+
                FieldByName('KasseID').AsString+':'+
                FieldByName('HauptGruppeID').AsString);
            BucheUmsatz(FieldByName('Betrag').AsFloat);
          end;
          Next;
        End;
      end else
      begin
        While Not EOF Do
        Begin
          if FieldByName('Betrag').AsFloat <> 0 then
          begin
            //Vielleicht ist jedem Kellner eine Leistungs zugeordnet
            If TableUmsatzzuordnung.Locate('Firma;HauptGruppeID',
              VarArrayOf([cFirma,FieldByName('HauptGruppeID').AsLargeInt]) , []) Then
              aLeistungsID := TableUmsatzzuordnung.FieldByName('LeistungsID').AsLargeInt
            //Soonst muss zumindest der 0 Kellner exestieren
            else
            //Vielleicht ist jedem Kellner eine Leistungs zugeordnet
            If TableUmsatzzuordnung.Locate('HauptGruppeID', FieldByName('HauptGruppeID').AsLargeInt , []) Then
              aLeistungsID := TableUmsatzzuordnung.FieldByName('LeistungsID').AsLargeInt
            //Soonst muss zumindest der 0 Kellner exestieren
            else
              If TableUmsatzzuordnung.Locate('HauptGruppeID', 0 , []) Then
                aLeistungsID := TableUmsatzzuordnung.FieldByName('LeistungsID').AsLargeInt
            else DataDesign.ShowMessageSkin(resDMSchnittstelle11+
                   FieldByName('HauptGruppeID').AsString);
            BucheUmsatz(FieldByName('Betrag').AsFloat);
          end;
          Next;
        End;
      end;
    End;    // with
    //Nun die Umbuchungen Minus auf die Rechnung schreiben
    With QueryFelix Do
    Begin
      Close;
      SQL.Clear;
      SQL.Add('select sum(menge*betrag) AS Betrag, sum(menge) AS Menge, leistungsid FROM  KassenJournal');
      SQL.Add('WHERE Datum = '''+DateToStr(aFelixDate)+''' AND');
      SQL.Add('BearbeiterID IS NULL AND Firma = '+IntToStr(cFirma));
      SQL.Add('AND LeistungsID IN');
      SQL.Add('(SELECT LeistungsID FROM Kass_Tischzuordnung)');
      SQL.Add('GROUP BY LeistungsID');
      Open;
      while not EOF do
      with DataFaktura do
      begin
        TableRechnung.Open;
        aLeistungsID := QueryFelix.FieldByName('LeistungsID').AsLargeInt;
        TableRechnungsKonto.Open;
        if ((TableRechnung.FieldByName('Datum').AsDateTime = aFelixDate) and
           ((TableRechnung.FieldByName('Rechnungsnummer').AsLargeInt = 0) or (TableRechnung.FieldByName('Rechnungsnummer').AsLargeInt = 99999))) OR

//             (TableRechnung.FieldByName('Rechnungsnummer').AsLargeInt = 0)) OR
          TableRechnung.Locate('Firma;Rechnungsnummer;Datum', VarArrayOf([cFirma,0, gl.FelixDate]), []) then
        begin
          TableRechnungskonto.Append;
          TableRechnungskonto.FieldByName('Datum').AsDateTime := gl.FelixDate;
          TableRechnungskonto.FieldByName('LeistungsID').AsLargeInt := aLeistungsID;
          TableRechnungskonto.FieldByName('Menge').AsLargeInt := QueryFelix.FieldByName('Menge').AsLargeInt;
          TableRechnungskonto.FieldByName('GesamtBetrag').AsCurrency := -QueryFelix.FieldByName('Betrag').AsFloat ;
          DataSonstige.SetQueryLeistung(aLeistungsID);
          TableRechnungskonto.FieldByName('LeistungsText').AsString :=
            DataSonstige.QueryLeistung.FieldByName('LeistungsBezeichnung').AsString;
          TableRechnungskonto.Post;

        end else
          DataDesign.ShowMessageSkin(resDMSchnittstelle5);
        Next;
      end;
    End;    // with
    try
      //Nun den Nachlass wieder abziehen!
      With QueryKasse Do
      Begin
        Close;
        SQL.Clear;
        SQL.Add('select sum(Nachlass) AS Summe FROM RechnungAll');
        SQL.Add('WHERE Datum = '''+DateToStr(aFelixDate)+'''');
        Open;
        with DataFaktura do
        begin
          TableRechnung.Open;
          aLeistungsID := glNachlass;
          if FieldByName('Summe').AsFloat <> 0 then
          begin
            BucheUmsatz(-FieldByName('Summe').AsFloat);
          end;
        end;
      End;    // with
    except
      on e:exception do
        DBase.WriteToLog('Error 1192: Nachlass von Kasse Buchen: '+e.Message, TRUE);
    end;
    //Alle Umbuchungen aus Felix auf 0 setzen!
    With QueryFelix Do
    Begin
      Close;
      SQL.Clear;
      SQL.Add('UPDATE KassenJournal');
      SQL.Add('SET Menge = 0');
      SQL.Add('WHERE Datum = '''+DateToStr(aFelixDate)+''' AND');
      SQL.Add('BearbeiterID IS NULL AND Firma = '+IntToStr(cFirma));
      SQL.Add('AND LeistungsID IN');
      SQL.Add('(SELECT LeistungsID FROM Kass_Tischzuordnung)');
      ExecSQL;
    End;    // with
    TableUmsatzzuordnung.Close;
    TableTischzuordnung.Close;
  End;
end;

procedure TDataSchnittstelle.LosungenKellner(pAuto: Boolean);
var   aZahlwegID: LongInt;
      aSumBetrag, aBetrag: Currency;
      aWaiterReservID: LongInt;
begin
  datakasse.DatabaseKasse.connected := True;
  TableEinstellKasse.IB_Connection := DataKasse.DatabaseKasse;
  TableEinstellKasse.Open;
  DBase.WriteToLog('Tabs: Starten', FALSE);
  FFelixUmsatzLosung := TableEinstellKasse.FieldByName('FelixUmsatzLosung').AsBoolean;
  FFelixNachKAsse := TableEinstellKasse.FieldByName('FelixNachKassen').AsBoolean;
  TableEinstellKasse.Close;
  If FFelixUmsatzLosung Then
  begin
    IB_QueryCheckKassaLosung.ParamByName('Firma').AsInt64 := cFirma;
    IB_QueryCheckKassaLosung.ParamByName('Datum').AsDateTime := gl.Felixdate;
    IB_QueryCheckKassaLosung.ParamByName('Text').AsString := resDMSchnittstelle15+'%';
    IB_QueryCheckKassaLosung.open;
    If not IB_QueryCheckKassaLosung.FieldbyName('ID').IsNull then //DataSonstige.TableKassenJournal.Locate('Firma;Datum;ErfassungDurch;Text',
      //VarArrayOf([cFirma,gl.FelixDate, 7, resDMSchnittstelle15]), [loPartialKey]) Then
    begin
      if not pAuto then
        ShowMessageSkin(resDMSchnittstelle12+#13+
                    resDMSchnittstelle13);
      IB_QueryCheckKassaLosung.Close;
      Exit;
    end;
    IB_QueryCheckKassaLosung.Close;

    TableRechZahlweg.Open;
    TableLosungszuordnung.Open;
    //Wenn nichts angemeldet, dann auf Kasse 1
    if pAuto and (LogInMitarbeiter.KassaID = 0) then
      LogInMitarbeiter.KassaID := 1;

    //Zuerst die Losungen aufbuchen
    //ZBOn deshalb, da es somit egal ist, ob vor oder nach dem Tagesabschluss
    //Besser nach TABS von Kasse
    With QueryKasse Do
    Begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT k.Nachname, j.ZahlwegID, sum(j.Betrag) AS Betrag, k.KellnerID');
      SQL.Add('FROM Journal j');
      SQL.Add('LEFT OUTER JOIN Kellner k ON k.Firma = j.Firma AND k.KellnerID = j.KellnerID');
      SQL.Add('WHERE j.JournalTyp in  (2,5) AND');
      SQL.Add('j.Datum = '''+DateToStr(gl.FelixDate)+'''');
      SQL.Add('GROUP BY k.Nachname, j.ZahlwegID, k.KellnerID');
      Open;
      First;
      if RecordCount = 0 then
      begin
        Close;
        SQL[1] := 'FROM JournalArchiv j'
      end;
      Open;
      if (RecordCount > 0) or CheckUmsatzTag(gl.FelixDate) then
      begin
        DataFaktura.TableRechnung.Open;
        DataFaktura.TableRechnung.Append;
        DataFaktura.TableRechnung.FieldByName('Rechnungsnummer').AsLargeInt := 0;
        DataFaktura.TableRechnung.FieldByName('Gedruckt').AsBoolean := TRUE;
        DataFaktura.TableRechnung.FieldByName('Bezahlt').AsBoolean := TRUE;
        DataFaktura.TableRechnung.Post;
        aSumBetrag := 0;
        While Not EOF Do
        Begin
          //Vielleicht ist jedem Kellner eine Leistungs zugeordnet
          if TableLosungsZuordnung.Locate('Firma;ZahlwgIDKasse', VarArrayOf([cFirma, FieldByName('ZahlwegID').AsLargeInt]) , [])
            or TableLosungsZuordnung.Locate('ZahlwgIDKasse', FieldByName('ZahlwegID').AsLargeInt , []) Then
            aZahlwegID := TableLosungsZuordnung.FieldByName('ZahlwgIDFelix').AsLargeInt
          //Soonst muss zumindest der 0 Kellner exestieren
          else
            aZahlwegID := FieldByName('ZahlwegID').AsLargeInt;
          aBetrag := FieldByName('Betrag').AsFloat;
          if (glGKTWaiterArticleID > 0) and (aZahlwegID = 1) then
          begin
            aWaiterReservID := GetWaiterReservID(FieldByName('KellnerID').AsLargeInt);
            if aWaiterReservID > 0 then
            begin
              DataReserv.WriteLeistungToGastKontoIB(glGKTWaiterarticleID, 1,
                aBetrag, FALSE, FALSE, FALSE, FALSE, 'Losung '+DateToSTr(gl.FelixDate),
                '', 6, 0, aWAiterReservID, NULL, null);
              aBetrag := 0;
            end;
          end;
          DataSonstige.WriteToKassaZahlweg(aZahlwegID,aBetrag);
          DataSonstige.WriteToKassenJournal(
            resDMSchnittstelle15 + ' '+ FieldByName('Nachname').AsString,
            aZahlwegID,
            null,  null, null, 7, null,aBetrag, FALSE);
          TableRechZahlweg.Append;
          TableRechZahlweg.FieldByName('Firma').AsLargeInt := cFirma;
          TableRechZahlweg.FieldByName('Datum').AsDateTime := gl.FelixDate;
          TableRechZahlweg.FieldByName('RechnungsID').AsLargeInt :=
            DataFaktura.TableRechnung.FieldByName('ID').AsLargeInt;
          TableRechZahlweg.FieldByName('Zahlwegid').AsLargeInt := aZahlwegID;
          TableRechZahlweg.FieldByName('Verbucht').AsBoolean := TRUE;
          TableRechZahlweg.FieldByName('Betrag').AsFloat := aBetrag;
          aSumBetrag := aSumBetrag + aBetrag;
          TableRechZahlweg.Post;
          //Wenn der Zahlweg eine Kreditkarte war, dann Betrag offen erhöhen!
          if DataSonstige.TableZahlweg.Locate('ID;KreditKarte', VarArrayOf([
            aZahlwegID, 'T']), []) then
          begin
            DataSonstige.TableKreditOffen.Open;
            DataSonstige.TableKreditOffen.Append;
            DataSonstige.TableKreditOffen.FieldByName('Betrag').AsFloat := aBetrag;
            DataSonstige.TableKreditOffen.FieldByName('ZahlwegID').AsLargeInt := aZahlwegID;
            DataSonstige.TableKreditOffen.FieldByName('Datum').AsDateTime := gl.FelixDate;
            DataSonstige.TableKreditOffen.FieldByName('RechNr').AsLargeInt := 0;
            DataSonstige.TableKreditOffen.Post;
            DataSonstige.TableKreditOffen.Close;
          end;
          Next;
        End;
        if RecordCount > 0 then
        begin
          DataFaktura.TableRechnung.Edit;
          DataFaktura.TableRechnung.FieldByName('ZahlungsBetrag').AsFloat := aSumBetrag;
          DataFaktura.TableRechnung.FieldByName('BereitsBezahlt').AsFloat := aSumBetrag;
          DataFaktura.TableRechnung.Post;
        end else
        begin
          //es war gar keine Barlosung an dem tag!
          TableRechZahlweg.Append;
          TableRechZahlweg.FieldByName('Firma').AsLargeInt := cFirma;
          TableRechZahlweg.FieldByName('Datum').AsDateTime := gl.FelixDate;
          TableRechZahlweg.FieldByName('RechnungsID').AsLargeInt :=
            DataFaktura.TableRechnung.FieldByName('ID').AsLargeInt;
          TableRechZahlweg.FieldByName('Zahlwegid').AsLargeInt := 1;
          TableRechZahlweg.FieldByName('Verbucht').AsBoolean := TRUE;
          TableRechZahlweg.FieldByName('Betrag').AsFloat := 0;
          TableRechZahlweg.Post;
          DataFaktura.TableRechnung.Edit;
          DataFaktura.TableRechnung.FieldByName('ZahlungsBetrag').AsFloat := 0;
          DataFaktura.TableRechnung.FieldByName('BereitsBezahlt').AsFloat := 0;
          DataFaktura.TableRechnung.Post;
        end;
      end;
      Close;
    End;    // with
    TableRechZahlweg.Close;
    TableLosungszuordnung.Close;
    if not pAuto then
      ShowMessageSkin(resDMSchnittstelle14);
  end;
end;

function TDataSchnittstelle.CheckUmsatzTag(pDatum: TDateTime): Boolean;
begin
  with QueryCheckUmsatzTag do
  begin
    SQL.Clear;
    SQL.Add('SELECT Count(*) AS Anzahl FROM JournalArchiv WHERE Datum = '''+DateToStr(pDatum)+'''');
    Open;
    Result :=  FieldByName('Anzahl').AsLargeInt > 0;
    Close;
    if not Result then
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT Count(*) AS Anzahl FROM Journal WHERE Datum = '''+DateToStr(pDatum)+'''');
      Open;
      Result :=  Result OR (FieldByName('Anzahl').AsLargeInt > 0);
      Close;
    end;

  end;
end;


end.
