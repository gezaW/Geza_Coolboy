object DataSchnittstelle: TDataSchnittstelle
  OldCreateOrder = True
  OnCreate = DataSchnittstelleCreate
  OnDestroy = DataSchnittstelleDestroy
  Height = 571
  Width = 884
  object TableAnlageTelefon: TIBOTable
    Filtered = True
    Filter = 'Anlage_Typ='#39'Telefon'#39
    RecordCountAccurate = True
    TableName = 'ANLAGENTYP'
    Left = 48
    Top = 34
  end
  object TableAnlageKasse: TIBOTable
    Filtered = True
    Filter = 'Anlage_Typ='#39'Kassen'#39
    RecordCountAccurate = True
    IndexFieldNames = 'StartParameter'
    TableName = 'ANLAGENTYP'
    Left = 154
    Top = 34
  end
  object QueryGebuehrenTelefon: TIBOQuery
    IB_Connection = DBase.IB_ConnectionFelix
    RecordCountAccurate = True
    SQL.Strings = (
      'SELECT * FROM GebuehrenProtokoll'
      'WHERE GespraechDatum = '#39'21.1.99'#39)
    Left = 52
    Top = 114
    object QueryGebuehrenTelefonFirma: TLargeintField
      DisplayLabel = ' Firma'
      FieldName = 'Firma'
      Origin = #39'GebuehrenProtokoll'#39'.Firma'
    end
    object QueryGebuehrenTelefonApparatnr: TLargeintField
      DisplayLabel = 'ApparatNr'
      FieldName = 'Apparatnr'
      Origin = #39'GebuehrenProtokoll'#39'.Apparatnr'
    end
    object QueryGebuehrenTelefonGespraechDatum: TDateField
      DisplayLabel = 'Gespr'#228'ch Datum'
      FieldName = 'GespraechDatum'
      Origin = #39'GebuehrenProtokoll'#39'.GespraechDatum'
    end
    object QueryGebuehrenTelefonGespraechBeginnZeit: TTimeField
      DisplayLabel = 'Gespr'#228'ch Beginnzeit'
      FieldName = 'GespraechBeginnZeit'
      Origin = #39'GebuehrenProtokoll'#39'.GespraechBeginnZeit'
    end
    object QueryGebuehrenTelefonGespraechEndeZeit: TTimeField
      DisplayLabel = 'Gespr'#228'ch EndeZeit'
      FieldName = 'GespraechEndeZeit'
      Origin = #39'GebuehrenProtokoll'#39'.GespraechEndeZeit'
    end
    object QueryGebuehrenTelefonGebuehreneinheit: TLargeintField
      DisplayLabel = 'Geb'#252'hreneinheit'
      FieldName = 'Gebuehreneinheit'
      Origin = #39'GebuehrenProtokoll'#39'.Gebuehreneinheit'
    end
    object QueryGebuehrenTelefonZielnummer: TWideStringField
      DisplayLabel = 'Zielnr'
      FieldName = 'Zielnummer'
      Origin = #39'GebuehrenProtokoll'#39'.Zielnummer'
      Size = 16
    end
    object QueryGebuehrenTelefonEntgeld: TFloatField
      DisplayLabel = ' Entgeld'
      FieldName = 'Entgeld'
      Origin = #39'GebuehrenProtokoll'#39'.Entgeld'
      DisplayFormat = '#,###,##0.00'
    end
  end
  object QueryGebuehrenKasse: TIBOQuery
    IB_Connection = DBase.IB_ConnectionFelix
    RecordCountAccurate = True
    SQL.Strings = (
      'select * from kass_KassenArchiv'
      '')
    Left = 190
    Top = 116
    object QueryGebuehrenKasseFirma: TLargeintField
      DisplayLabel = 'Firma'
      FieldName = 'FIRMA'
      Origin = #39'Kassenarchiv'#39'.Firma'
    end
    object QueryGebuehrenKasseKellNr: TLargeintField
      DisplayLabel = 'KellnerNR'
      FieldName = 'KELLNR'
      Origin = #39'Kassenarchiv'#39'.KellNr'
    end
    object QueryGebuehrenKasseTischNr: TWideStringField
      DisplayLabel = 'TischNR'
      FieldName = 'TISCHNR'
      Origin = #39'Kassenarchiv'#39'.TischNr'
      Size = 5
    end
    object QueryGebuehrenKasseDatum: TDateField
      DisplayLabel = 'Datum'
      FieldName = 'DATUM'
      Origin = #39'Kassenarchiv'#39'.Datum'
      DisplayFormat = 'dd.mm.yy'
    end
    object QueryGebuehrenKasseZeit: TTimeField
      DisplayLabel = 'Zeit'
      FieldName = 'ZEIT'
      Origin = #39'Kassenarchiv'#39'.Zeit'
      DisplayFormat = 'hh:mm:ss'
    end
    object QueryGebuehrenKasseZimmerID: TLargeintField
      DisplayLabel = 'ZimmerID'
      FieldName = 'ZIMMERID'
      Origin = #39'Kassenarchiv'#39'.ZimmerID'
    end
    object QueryGebuehrenKasseBetrag: TFloatField
      DisplayLabel = 'Betrag'
      FieldName = 'BETRAG'
      Origin = #39'Kassenarchiv'#39'.Betrag'
    end
    object QueryGebuehrenKasseLeistungsID: TLargeintField
      DisplayLabel = 'LeistungsID'
      FieldName = 'LEISTUNGSID'
      Origin = #39'Kassenarchiv'#39'.LeistungsID'
    end
    object QueryGebuehrenKasseLookLeistung: TWideStringField
      DisplayLabel = 'Look Leistung'
      FieldKind = fkLookup
      FieldName = 'LookLeistung'
      LookupDataSet = DataSonstige.TableLeistungen
      LookupKeyFields = 'ID'
      LookupResultField = 'LeistungsBezeichnung'
      KeyFields = 'LeistungsID'
      Lookup = True
    end
    object QueryGebuehrenKasseTEXT: TWideStringField
      DisplayLabel = 'Text'
      FieldName = 'TEXT'
      Size = 50
    end
  end
  object Query_GetZimmerID: TIBOQuery
    Params = <
      item
        DataType = ftInteger
        Name = 'firma'
        ParamType = ptUnknown
      end>
    IB_Connection = DBase.IB_ConnectionFelix
    RecordCountAccurate = True
    SQL.Strings = (
      'select id, zimmernr from zimmer'
      
        ' where (id in (select zimmerid from telefonapparate where firma ' +
        '= :firma))'
      '  and firma = :firma'
      'order by id')
    Left = 280
    Top = 36
  end
  object Query_GetApparateNr: TIBOQuery
    Params = <
      item
        DataType = ftSmallint
        Name = 'firma'
        ParamType = ptUnknown
      end>
    IB_Connection = DBase.IB_ConnectionFelix
    RecordCountAccurate = True
    RequestLive = True
    SQL.Strings = (
      'select ID, ApparateNr, ZimmerID from telefonapparate'
      'where firma = :firma'
      'order by apparatenr')
    Left = 446
    Top = 134
  end
  object DataSourceGebuehrenKasse: TDataSource
    DataSet = QueryGebuehrenKasse
    Left = 187
    Top = 197
  end
  object DataSourceGebuehrenTelefon: TDataSource
    DataSet = QueryGebuehrenTelefon
    Left = 53
    Top = 175
  end
  object TableMessageTV: TIBOTable
    RecordCountAccurate = True
    TableName = 'TV_MESSAGE'
    Left = 58
    Top = 244
  end
  object TableGastInfo: TIBOTable
    RecordCountAccurate = True
    TableName = '"'#39'GASTINFO.DBF'#39'"'
    Left = 510
    Top = 14
  end
  object QueryCheckIn: TIBOQuery
    Params = <
      item
        DataType = ftInteger
        Name = 'Firma'
        ParamType = ptUnknown
      end>
    IB_Connection = DBase.IB_ConnectionFelix
    RecordCountAccurate = True
    SQL.Strings = (
      'SELECT Gastname, ZimmerID, Anreisedatum , SperrenExtra'
      'FROM Reservierung'
      'WHERE CheckIn = TRUE AND'
      'Firma = :Firma')
    Left = 450
    Top = 196
  end
  object TableBankZuKasse: TIBOTable
    Filtered = True
    Filter = 'Status <> 1'
    RecordCountAccurate = True
    TableName = 'BANK_BANKZUKASSE'
    Left = 222
    Top = 318
  end
  object TableKasseZuBank: TIBOTable
    GeneratorLinks.Strings = (
      'ID=ID')
    RecordCountAccurate = True
    TableName = 'BANK_KASSEZUBANK'
    Left = 342
    Top = 254
  end
  object QueryGMS: TIBOQuery
    IB_Connection = DataKasse.DatabaseKasse
    RecordCountAccurate = True
    SQL.Strings = (
      
        'SELECT j.Datum, j.Zeit, ar.Bezeichnung, CAST(j.Menge AS FLOAT) A' +
        'S Menge, j.Betrag, kl.Nachname'
      ', j.VonOffeneTischID AS ZimmerID'
      'FROM JournalArchiv j'
      'LEFT OUTER JOIN Artikel ar'
      ' ON ar.ArtikelID = j.ArtikelID AND j.Firma = ar.Firma'
      'LEFT OUTER JOIN Kellner kl'
      'ON kl.KellnerID = j.KellnerID and kl.Firma = j.Firma'
      'WHERE j.JournalTyp = 9'
      '  ORDER BY j.Datum, j.Zeit')
    Left = 272
    Top = 108
    object QueryGMSDATUM: TDateTimeField
      DisplayLabel = 'Datum'
      FieldName = 'DATUM'
      DisplayFormat = 'dd.mm.yy'
    end
    object QueryGMSZEIT: TDateTimeField
      DisplayLabel = 'Zeit'
      FieldName = 'ZEIT'
      DisplayFormat = 'hh:mm:ss'
    end
    object QueryGMSBezeichnung: TWideStringField
      DisplayLabel = ' Bezeichnung'
      FieldName = 'Bezeichnung'
      Size = 25
    end
    object QueryGMSMenge: TFloatField
      DisplayLabel = ' Menge'
      FieldName = 'Menge'
    end
    object QueryGMSBetrag: TCurrencyField
      DisplayLabel = ' Betrag'
      FieldName = 'Betrag'
    end
    object QueryGMSNachname: TWideStringField
      DisplayLabel = ' Nachname'
      FieldName = 'Nachname'
      Size = 80
    end
    object QueryGMSZIMMERID: TLargeintField
      DisplayLabel = 'ZimmerID'
      FieldName = 'ZIMMERID'
    end
  end
  object DataSourceGMS: TDataSource
    DataSet = QueryGMS
    Left = 283
    Top = 197
  end
  object TableExterneSchnittstellen: TIBOTable
    RecordCountAccurate = True
    TableName = 'EXTERNESCHNITTSTELLE'
    Left = 58
    Top = 294
  end
  object QueryGMSKorrekt: TIBOQuery
    IB_Connection = DataKasse.DatabaseKasse
    RecordCountAccurate = True
    SQL.Strings = (
      
        'SELECT j.JournalArchivID, j.Datum, j.Zeit, ar.Bezeichnung, j.Men' +
        'ge, j.Betrag, kl.Nachname, j.VonOffeneTischID AS ZimmerID, j.Art' +
        'ikelID'
      'FROM Journalarchiv j'
      'LEFT OUTER JOIN Artikel ar'
      'ON ar.ArtikelID = j.ArtikelID'
      'LEFT OUTER JOIN Kellner kl'
      'ON kl.KellnerID = j.KellnerID'
      'WHERE JournalTyp = 9')
    Left = 356
    Top = 22
    object QueryGMSKorrektDATUM: TDateTimeField
      DisplayLabel = 'Datum'
      FieldName = 'DATUM'
      DisplayFormat = 'dd.mm.yy'
    end
    object QueryGMSKorrektZEIT: TDateTimeField
      DisplayLabel = 'Zeit'
      FieldName = 'ZEIT'
      DisplayFormat = 'hh:mm:ss'
    end
    object StringField1: TWideStringField
      DisplayLabel = ' Bezeichnung'
      FieldName = 'Bezeichnung'
      Size = 25
    end
    object IntegerField1: TLargeintField
      DisplayLabel = ' Menge'
      FieldName = 'Menge'
    end
    object CurrencyField1: TCurrencyField
      DisplayLabel = ' Betrag'
      FieldName = 'Betrag'
    end
    object StringField2: TWideStringField
      DisplayLabel = ' Nachname'
      FieldName = 'Nachname'
      Size = 80
    end
    object IntegerField2: TLargeintField
      DisplayLabel = 'Zimmer ID'
      FieldName = 'ZimmerID'
    end
    object QueryGMSKorrektJournalArchivID: TLargeintField
      DisplayLabel = 'JournalArchiv ID'
      FieldName = 'JournalArchivID'
    end
    object QueryGMSKorrektArtikelID: TLargeintField
      DisplayLabel = 'Artikel ID'
      FieldName = 'ArtikelID'
    end
  end
  object DataSourceGMSKorrekt: TDataSource
    DataSet = QueryGMSKorrekt
    Left = 351
    Top = 197
  end
  object TableTischzuordnung: TIBOTable
    RecordCountAccurate = True
    TableName = 'KASS_TISCHZUORDNUNG'
    Left = 220
    Top = 272
    object TableTischzuordnungTischVon: TLargeintField
      DisplayLabel = 'Tisch von'
      FieldName = 'TISCHVON'
      Origin = 'KASS_TISCHZUORDNUNG.TISCHVON'
    end
    object TableTischzuordnungTischBis: TLargeintField
      DisplayLabel = 'Tisch bis'
      FieldName = 'TISCHBIS'
      Origin = 'KASS_TISCHZUORDNUNG.TISCHBIS'
    end
    object TableTischzuordnungLeistungsID: TLargeintField
      FieldName = 'LEISTUNGSID'
      Origin = 'KASS_TISCHZUORDNUNG.LEISTUNGSID'
    end
    object TableTischzuordnungLeistungsBez: TWideStringField
      DisplayLabel = 'Leistung Bez.'
      FieldName = 'LEISTUNGSBEZ'
      Origin = 'KASS_TISCHZUORDNUNG.LEISTUNGSBEZ'
    end
    object TableTischzuordnungSteuerID: TFloatField
      DisplayLabel = 'Steuer ID'
      FieldKind = fkLookup
      FieldName = 'SteuerID'
      LookupDataSet = DataSonstige.TableLeistungen
      LookupKeyFields = 'ID'
      LookupResultField = 'MwStID'
      KeyFields = 'LeistungsID'
      Lookup = True
    end
    object TableTischzuordnungSteuer: TFloatField
      DisplayLabel = ' Steuer'
      FieldKind = fkLookup
      FieldName = 'Steuer'
      LookupDataSet = DataNachschlag.TableMwst
      LookupKeyFields = 'ID'
      LookupResultField = 'MwSt'
      KeyFields = 'SteuerID'
      Lookup = True
    end
  end
  object TableAnlageKeyCard: TIBOTable
    Filtered = True
    Filter = 'Anlage_Typ='#39'Keycard'#39
    RecordCountAccurate = True
    TableName = 'ANLAGENTYP'
    Left = 570
    Top = 358
  end
  object TableKeySendDataToServer: TIBOTable
    GeneratorLinks.Strings = (
      'ID=ID')
    RecordCountAccurate = True
    TableName = 'KEY_SENDDATATOSERVER'
    Left = 460
    Top = 358
  end
  object QueryFelix: TIBOQuery
    IB_Connection = DBase.IB_ConnectionFelix
    RecordCountAccurate = True
    Left = 594
    Top = 118
  end
  object TableRechzahlweg: TIBOTable
    GeneratorLinks.Strings = (
      'ID=ID')
    RecordCountAccurate = True
    AfterInsert = TableRechzahlwegAfterInsert
    TableName = 'RECHNUNGSZAHLWEG'
    Left = 598
    Top = 188
  end
  object TableLosungszuordnung: TIBOTable
    RecordCountAccurate = True
    TableName = 'KASS_PAYMENTTOFELIX'
    Left = 592
    Top = 252
  end
  object TableSendToTesax: TIBOTable
    RecordCountAccurate = True
    TableName = 'KEY_SENDDATATOSERVER'
    Left = 460
    Top = 418
  end
  object TableGetFromTesa: TIBOTable
    RecordCountAccurate = True
    TableName = 'KEY_SENDDATATOCLIENT'
    Left = 566
    Top = 420
  end
  object QueryJournalKorrekt: TIBOQuery
    Params = <
      item
        DataType = ftInteger
        Name = 'ArtikelID'
        ParamType = ptUnknown
      end
      item
        DataType = ftDateTime
        Name = 'Datum'
        ParamType = ptUnknown
      end
      item
        DataType = ftFloat
        Name = 'Betrag'
        ParamType = ptUnknown
      end>
    IB_Connection = DataKasse.DatabaseKasse
    RecordCountAccurate = True
    SQL.Strings = (
      'SELECT j.JournalArchivID'
      'FROM Journalarchiv j'
      
        'LEFT OUTER JOIN Tisch T ON t.Firma = j.Firma AND t.TischID = j.T' +
        'ischID'
      'WHERE j.JournalTyp = 1'
      'AND j.ArtikelID = :ArtikelID'
      'AND j.Datum = :Datum'
      'AND (j.Betrag+0.1 >= :Betrag)'
      'AND j.Menge > 0'
      'AND NOT (t.TischTyp in ('#39'W'#39', '#39'P'#39', '#39'E'#39', '#39'B'#39'))'
      '')
    Left = 360
    Top = 100
  end
  object TableTelefonapparate: TIBOTable
    RecordCountAccurate = True
    TableName = 'TELEFONAPPARATE'
    Left = 54
    Top = 346
    object TableTelefonapparateFIRMA: TLargeintField
      DisplayLabel = 'Firma'
      FieldName = 'FIRMA'
      Required = True
    end
    object TableTelefonapparateID: TLargeintField
      DisplayLabel = 'Id'
      FieldName = 'ID'
      Required = True
    end
    object TableTelefonapparateAPPARATENR: TLargeintField
      DisplayLabel = 'ApparateNr'
      FieldName = 'APPARATENR'
    end
    object TableTelefonapparateZIMMERID: TLargeintField
      DisplayLabel = 'ZimmerID'
      FieldName = 'ZIMMERID'
    end
    object TableTelefonapparateABTEILUNG: TWideStringField
      DisplayLabel = 'Abteilung'
      FieldName = 'ABTEILUNG'
      Size = 5
    end
    object TableTelefonapparateZIMMERAPPARAT: TWideStringField
      DisplayLabel = 'ZimmerApparat'
      FieldName = 'ZIMMERAPPARAT'
      Size = 1
    end
    object TableTelefonapparateZUSTAND: TWideStringField
      DisplayLabel = 'Zustand'
      FieldName = 'ZUSTAND'
      Size = 1
    end
    object TableTelefonapparateCHANGEZUSTAND: TWideStringField
      DisplayLabel = 'change Zustand'
      FieldName = 'CHANGEZUSTAND'
      Size = 1
    end
    object TableTelefonapparateGASTNAME: TWideStringField
      DisplayLabel = 'Gastname'
      FieldName = 'GASTNAME'
      Size = 30
    end
    object TableTelefonapparatePROTOKOLLIEREN: TWideStringField
      DisplayLabel = 'protokollieren'
      FieldName = 'PROTOKOLLIEREN'
      Size = 1
    end
    object TableTelefonapparateWECKZEIT: TDateTimeField
      DisplayLabel = 'Weckzeit'
      FieldName = 'WECKZEIT'
      DisplayFormat = 'hh:mm'
    end
    object TableTelefonapparateWECKDATUMVON: TDateTimeField
      DisplayLabel = 'Weckdatum von'
      FieldName = 'WECKDATUMVON'
    end
    object TableTelefonapparateWECKDATUMBIS: TDateTimeField
      DisplayLabel = 'Weckdatum bis'
      FieldName = 'WECKDATUMBIS'
    end
    object TableTelefonapparateLETZTEWECKZEIT: TDateTimeField
      DisplayLabel = 'letzte Weckzeit'
      FieldName = 'LETZTEWECKZEIT'
      DisplayFormat = 'hh:mm'
    end
    object TableTelefonapparateZUSTANDKASSE: TWideStringField
      DisplayLabel = 'Zustand Kasse'
      FieldName = 'ZUSTANDKASSE'
      Size = 1
    end
    object TableTelefonapparateCHANGEZUSTANDKASSE: TWideStringField
      DisplayLabel = 'change Zustand Kasse'
      FieldName = 'CHANGEZUSTANDKASSE'
      Size = 1
    end
    object TableTelefonapparateAPPARATENR2: TLargeintField
      DisplayLabel = 'ApparateNR2'
      FieldName = 'APPARATENR2'
    end
    object TableTelefonapparateSECURITY: TWideStringField
      DisplayLabel = 'Sicherheit'
      FieldName = 'SECURITY'
      Size = 1
    end
    object TableTelefonapparateAPPARATENR3: TLargeintField
      DisplayLabel = 'ApparateNR3'
      FieldName = 'APPARATENR3'
    end
    object TableTelefonapparateAPPARATENR4: TLargeintField
      DisplayLabel = 'ApparateNR4'
      FieldName = 'APPARATENR4'
    end
    object TableTelefonapparateAPPARATENR5: TLargeintField
      DisplayLabel = 'ApparateNR5'
      FieldName = 'APPARATENR5'
    end
    object TableTelefonapparateAPPARATENR6: TLargeintField
      DisplayLabel = 'ApparateNR6'
      FieldName = 'APPARATENR6'
    end
    object TableTelefonapparateAPPARATENR7: TLargeintField
      DisplayLabel = 'ApparateNR7'
      FieldName = 'APPARATENR7'
    end
    object TableTelefonapparateAPPARATENR8: TLargeintField
      DisplayLabel = 'ApparateNR8'
      FieldName = 'APPARATENR8'
    end
    object TableTelefonapparateAPPARATENR9: TLargeintField
      DisplayLabel = 'ApparateNR9'
      FieldName = 'APPARATENR9'
    end
    object TableTelefonapparateAPPARATENR10: TLargeintField
      DisplayLabel = 'ApparateNR10'
      FieldName = 'APPARATENR10'
    end
    object TableTelefonapparateAPPARATENR11: TLargeintField
      DisplayLabel = 'ApparateNR11'
      FieldName = 'APPARATENR11'
    end
    object TableTelefonapparateAPPARATENR12: TLargeintField
      DisplayLabel = 'ApparateNR12'
      FieldName = 'APPARATENR12'
    end
    object TableTelefonapparateAPPARATENR13: TLargeintField
      DisplayLabel = 'ApparateNR13'
      FieldName = 'APPARATENR13'
    end
    object TableTelefonapparateAPPARATENR14: TLargeintField
      DisplayLabel = 'ApparateNR14'
      FieldName = 'APPARATENR14'
    end
    object TableTelefonapparateAPPARATENR15: TLargeintField
      DisplayLabel = 'ApparateNR15'
      FieldName = 'APPARATENR15'
    end
    object TableTelefonapparateZUSTANDTV: TWideStringField
      DisplayLabel = 'Zustand TV'
      FieldName = 'ZUSTANDTV'
      Size = 1
    end
    object TableTelefonapparateCHANGEZUSTANDTV: TWideStringField
      DisplayLabel = 'chaneg Zustand TV'
      FieldName = 'CHANGEZUSTANDTV'
      Size = 1
    end
  end
  object DataSourceTelefonapparate: TDataSource
    DataSet = TableTelefonapparate
    Left = 208
    Top = 364
  end
  object Table_SendDataToServer: TIBOTable
    GeneratorLinks.Strings = (
      'ID=ID')
    RecordCountAccurate = True
    TableName = 'TEL_SENDDATATOSERVER'
    Left = 56
    Top = 404
  end
  object TableLeistungenSkidata: TIBOTable
    GeneratorLinks.Strings = (
      'ID=ID')
    RecordCountAccurate = True
    TableName = 'LEISTUNGENSKIDATA'
    Left = 325
    Top = 369
  end
  object QueryCheckKasse: TIBOQuery
    Params = <
      item
        DataType = ftInteger
        Name = 'ReservID'
        ParamType = ptUnknown
      end>
    IB_Connection = DataKasse.DatabaseKasse
    RecordCountAccurate = True
    SQL.Strings = (
      'SELECT OffeneTischID '
      'FROM OffeneTische ot'
      'WHERE ot.Reservid = :ReservID'
      'AND Offen = '#39'T'#39)
    Left = 728
    Top = 124
  end
  object TableUmsatzzuordnung: TIBOTable
    RecordCountAccurate = True
    TableName = 'KASS_TURNOVERTOFELIX'
    Left = 724
    Top = 195
  end
  object QueryKasse: TIBOQuery
    Params = <
      item
        DataType = ftInteger
        Name = 'ReservID'
        ParamType = ptUnknown
      end>
    IB_Connection = DataKasse.DatabaseKasse
    RecordCountAccurate = True
    SQL.Strings = (
      'SELECT OffeneTischID '
      'FROM OffeneTische ot'
      'WHERE ot.Reservid = :ReservID'
      'AND Offen = '#39'T'#39)
    Left = 730
    Top = 266
  end
  object TableEinstellKasse: TIBOTable
    RecordCountAccurate = True
    TableName = 'EINSTELL'
    Left = 728
    Top = 339
  end
  object QueryCheckGMSDone: TIBOQuery
    Params = <
      item
        DataType = ftDateTime
        Name = 'Datum'
        ParamType = ptInput
      end
      item
        DataType = ftSmallint
        Name = 'Erfassungdurch'
        ParamType = ptInput
      end
      item
        DataType = ftString
        Name = 'Text'
        ParamType = ptInput
      end
      item
        DataType = ftSmallint
        Name = 'Firma'
        ParamType = ptInput
      end>
    IB_Connection = DBase.IB_ConnectionFelix
    RecordCountAccurate = True
    SQL.Strings = (
      'SELECT ID FROM KassenJournal'
      'WHERE Datum = :Datum AND'
      'Erfassungdurch = :Erfassungdurch AND'
      'Text LIKE :Text'
      'AND Firma = :Firma')
    Left = 732
    Top = 396
  end
  object QueryCheckUmsatzTag: TIBOQuery
    Params = <
      item
        DataType = ftDateTime
        Name = 'Datum'
        ParamType = ptInput
      end>
    IB_Connection = DataKasse.DatabaseKasse
    RecordCountAccurate = True
    SQL.Strings = (
      'SELECT Count(*) AS Anzahl '
      'FROM JournalArchiv'
      'WHERE Datum = :Datum')
    Left = 794
    Top = 40
  end
  object QueryCheckWaiterReservID: TIBOQuery
    Params = <
      item
        DataType = ftInteger
        Name = 'KellnerID'
        ParamType = ptInput
      end>
    IB_Connection = DataKasse.DatabaseKasse
    RecordCountAccurate = True
    SQL.Strings = (
      'SELECT FelixReservID '
      'FROM Kellner'
      'WHERE KellnerID = :KellnerID'
      '')
    Left = 726
    Top = 474
  end
  object IBOQueryKey_Features: TIBOQuery
    Params = <
      item
        DataType = ftUnknown
        Name = 'pFirma'
        ParamType = ptInput
      end>
    AutoCalcFields = False
    IB_Connection = DBase.IB_ConnectionFelix
    RecordCountAccurate = True
    SQL.Strings = (
      'SELECT *'
      'FROM Key_Features'
      'WHERE Firma = :pFirma'
      'ORDER BY Id')
    Left = 680
    Top = 44
  end
  object IB_QueryCheckKassaLosung: TIB_Query
    IB_Connection = DBase.IB_ConnectionFelix
    SQL.Strings = (
      'select ID from kassenjournal'
      
        'where Firma = :Firma and Erfassungdurch = 7 and Datum = :Datum a' +
        'nd Text LIKE :Text')
    Left = 224
    Top = 440
    ParamValues = (
      'FIRMA='
      'DATUM='
      'TEXT=')
  end
end
