object DataPos: TDataPos
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 664
  Width = 868
  object DataSourceOffeneTische: TDataSource
    DataSet = TableOffeneTische
    Left = 48
    Top = 90
  end
  object QueryToTisch: TFDQuery
    Left = 352
    Top = 148
  end
  object Query: TFDQuery
    Left = 464
    Top = 88
  end
  object QueryDelTischkonto: TFDQuery
    SQL.Strings = (
      'DELETE FROM Tischkonto'
      'WHERE OffeneTischID = :OffeneTischID'
      'AND Firma =:Firma')
    Left = 352
    Top = 608
    ParamData = <
      item
        Name = 'OffeneTischID'
        DataType = ftInteger
      end
      item
        Name = 'Firma'
        DataType = ftInteger
      end>
  end
  object QueryInsertRechkonto: TFDQuery
    SQL.Strings = (
      'INSERT INTO Rechnungskonto'
      
        '(Firma, RechnungsID, Datum, ArtikelID, Menge, Betrag, LeistungsT' +
        'ext, BonNr)'
      'VALUES '
      
        '(:Firma, :RechnungsID, :Datum, :ArtikelID, :Menge, :Betrag, :Lei' +
        'stungsText, :BonNr)'
      '')
    Left = 472
    Top = 144
    ParamData = <
      item
        Name = 'Firma'
        ParamType = ptInput
      end
      item
        Name = 'RechnungsID'
        ParamType = ptInput
      end
      item
        Name = 'Datum'
        ParamType = ptInput
      end
      item
        Name = 'ArtikelID'
        ParamType = ptInput
      end
      item
        Name = 'Menge'
        ParamType = ptInput
      end
      item
        Name = 'Betrag'
        ParamType = ptInput
      end
      item
        Name = 'LeistungsText'
        ParamType = ptInput
      end
      item
        Name = 'BonNr'
        ParamType = ptInput
      end>
  end
  object QueryLocateOffenerTisch: TFDQuery
    Left = 352
    Top = 328
  end
  object QueryHappyHour: TFDQuery
    SQL.Strings = (
      'SELECT * FROM HappyHour')
    Left = 248
    Top = 600
  end
  object QueryFromTisch: TFDQuery
    Left = 248
    Top = 428
  end
  object QueryRechnungskontoIT: TFDQuery
    SQL.Strings = (
      
        'SELECT ArtikelID, Betrag, RechnungsID, LeistungsText, SUM(Menge)' +
        ' AS Menge FROM Rechnungskonto'
      'WHERE RechnungsID = :RechnungsID'
      'GROUP BY ArtikelID, Betrag, RechnungsID, LeistungsText')
    Left = 472
    Top = 496
    ParamData = <
      item
        Name = 'RechnungsID'
        DataType = ftInteger
      end>
  end
  object QueryZahlweg: TFDQuery
    SQL.Strings = (
      'Select Id, Bezeichnung From Zahlweg'
      'Where Firma = :Firma'
      'Order By Sortiernummer')
    Left = 472
    Top = 264
    ParamData = <
      item
        Name = 'Firma'
        ParamType = ptInput
      end>
  end
  object QueryDelRechnung: TFDQuery
    SQL.Strings = (
      'DELETE FROM Rechnung'
      'WHERE ID = :ID')
    Left = 472
    Top = 328
    ParamData = <
      item
        Name = 'ID'
      end>
  end
  object QueryDelRechzahlweg: TFDQuery
    SQL.Strings = (
      'DELETE FROM Rechnungszahlweg'
      'WHERE RechnungsID = :RechnungsID')
    Left = 472
    Top = 384
    ParamData = <
      item
        Name = 'RechnungsID'
        DataType = ftInteger
      end>
  end
  object QueryRechNr: TFDQuery
    Left = 352
    Top = 496
  end
  object QueryInsertRechnung: TFDQuery
    SQL.Strings = (
      'INSERT INTO Rechnung'
      '(Firma, ID, ReservID, Datum, Rechnungsnummer, ErstellerID, '
      
        ' ZahlungsBetrag, BereitsBezahlt, Bezahlt, Gedruckt, Nachlass, Ad' +
        'resseID,VorausRechnungKz)'
      'VALUES '
      
        '(:Firma, :ID, :ReservID, :Datum, :Rechnungsnummer, :ErstellerID,' +
        ' '
      
        ' :ZahlungsBetrag, :BereitsBezahlt, :Bezahlt, :Gedruckt, :Nachlas' +
        's, :AdresseID, :VorausRechnungKz)')
    Left = 352
    Top = 440
    ParamData = <
      item
        Name = 'Firma'
        DataType = ftInteger
      end
      item
        Name = 'ID'
        DataType = ftInteger
      end
      item
        Name = 'ReservID'
        DataType = ftInteger
      end
      item
        Name = 'Datum'
        DataType = ftDateTime
      end
      item
        Name = 'Rechnungsnummer'
        DataType = ftInteger
      end
      item
        Name = 'ErstellerID'
        DataType = ftInteger
      end
      item
        Name = 'ZahlungsBetrag'
        DataType = ftFloat
      end
      item
        Name = 'BereitsBezahlt'
        DataType = ftFloat
      end
      item
        Name = 'Bezahlt'
        DataType = ftString
      end
      item
        Name = 'Gedruckt'
        DataType = ftString
      end
      item
        Name = 'Nachlass'
      end
      item
        Name = 'AdresseID'
      end
      item
        Name = 'VorausRechnungKz'
        DataType = ftString
      end>
  end
  object QueryInsertRechzahlung: TFDQuery
    SQL.Strings = (
      'INSERT INTO RechnungsZahlweg'
      '(Firma, RechnungsID, Datum, ZahlwegID, Betrag, Verbucht)'
      
        'VALUES (:Firma, :RechnungsID, :Datum, :ZahlwegID, :Betrag, :Verb' +
        'ucht)')
    Left = 352
    Top = 384
    ParamData = <
      item
        Name = 'Firma'
        DataType = ftInteger
      end
      item
        Name = 'RechnungsID'
        DataType = ftInteger
      end
      item
        Name = 'Datum'
        DataType = ftDate
      end
      item
        Name = 'ZahlwegID'
        DataType = ftInteger
      end
      item
        Name = 'Betrag'
        DataType = ftFloat
      end
      item
        Name = 'Verbucht'
        DataType = ftString
      end>
  end
  object QueryDelRechnungsKonto: TFDQuery
    SQL.Strings = (
      'DELETE FROM RechnungsKonto'
      'WHERE RechnungsID = :RechnungsID')
    Left = 472
    Top = 552
    ParamData = <
      item
        Name = 'RechnungsID'
        DataType = ftInteger
      end>
  end
  object QueryRechnungsKonto: TFDQuery
    SQL.Strings = (
      'SELECT * FROM RechnungsKonto'
      'WHERE RechnungsID = :RechnungsID')
    Left = 472
    Top = 440
    ParamData = <
      item
        Name = 'RechnungsID'
        DataType = ftInteger
      end>
  end
  object QueryReviere: TFDQuery
    SQL.Strings = (
      'Select * '
      'from Reviere'
      'Order by Reihung')
    Left = 592
    Top = 144
  end
  object TableDrucker: TFDTable
    UpdateOptions.UpdateTableName = 'DRUCKERTXT'
    TableName = 'DRUCKERTXT'
    Left = 150
    Top = 192
  end
  object TableTisch: TFDTable
    UpdateOptions.UpdateTableName = 'TISCH'
    TableName = 'TISCH'
    Left = 40
    Top = 236
  end
  object TableBeilagen: TFDTable
    UpdateOptions.UpdateTableName = 'BEILAGEN'
    TableName = 'BEILAGEN'
    Left = 150
    Top = 240
  end
  object TableSteuer: TFDTable
    UpdateOptions.UpdateTableName = 'STEUER'
    TableName = 'STEUER'
    Left = 152
    Top = 304
  end
  object TableRechnung: TFDTable
    FilterOptions = [foCaseInsensitive]
    UpdateOptions.UpdateTableName = 'RECHNUNG'
    TableName = 'RECHNUNG'
    Left = 150
    Top = 358
  end
  object TableKasseIT: TFDTable
    UpdateOptions.UpdateTableName = 'KASSEIT'
    TableName = 'KASSEIT'
    Left = 150
    Top = 412
  end
  object TableZimmerFELIX: TFDTable
    UpdateOptions.UpdateTableName = 'ZIMMER'
    TableName = 'ZIMMER'
    Left = 242
    Top = 264
  end
  object TableGastkontoFELIX: TFDTable
    AfterInsert = TableGastkontoFELIXAfterInsert
    IndexFieldNames = 'RESERVID'
    MasterFields = 'ID'
    UpdateOptions.UpdateTableName = 'GASTKONTO'
    TableName = 'GASTKONTO'
    Left = 242
    Top = 312
  end
  object TableDiverses: TFDTable
    UpdateOptions.UpdateTableName = 'DIVERSES'
    TableName = 'DIVERSES'
    Left = 48
    Top = 608
  end
  object QueryGetNextID: TFDQuery
    Left = 472
    Top = 200
  end
  object QueryMwSt: TFDQuery
    SQL.Strings = (
      'SELECT * FROM Hilf_Tischkonto')
    Left = 472
    Top = 608
    object QueryMwStFirma: TSmallintField
      DisplayWidth = 10
      FieldName = 'Firma'
    end
    object QueryMwStOffeneTischID: TIntegerField
      DisplayWidth = 10
      FieldName = 'OffeneTischID'
    end
    object QueryMwStArtikelID: TIntegerField
      DisplayWidth = 10
      FieldName = 'ArtikelID'
    end
    object QueryMwStMenge: TFloatField
      DisplayWidth = 10
      FieldName = 'Menge'
    end
    object QueryMwStBetrag: TCurrencyField
      DisplayWidth = 10
      FieldName = 'Betrag'
    end
    object QueryMwStLookUntergruppeID: TIntegerField
      DisplayWidth = 10
      FieldKind = fkLookup
      FieldName = 'LookUntergruppeID'
      LookupDataSet = TableArtikel
      LookupKeyFields = 'ArtikelID'
      LookupResultField = 'UntergruppeID'
      KeyFields = 'ArtikelID'
      Lookup = True
    end
    object QueryMwStLookHauptGruppeID: TIntegerField
      DisplayWidth = 10
      FieldKind = fkLookup
      FieldName = 'LookHauptGruppeID'
      LookupDataSet = TableUntergruppe
      LookupKeyFields = 'UntergruppeID'
      LookupResultField = 'HauptgruppeID'
      KeyFields = 'LookUntergruppeID'
      Lookup = True
    end
    object QueryMwStLookSteuerID: TIntegerField
      DisplayWidth = 10
      FieldKind = fkLookup
      FieldName = 'LookSteuerID'
      LookupDataSet = TableHauptgruppe
      LookupKeyFields = 'HauptgruppeID'
      LookupResultField = 'SteuerID'
      KeyFields = 'LookHauptGruppeID'
      Lookup = True
    end
    object QueryMwStLookSteuer: TIntegerField
      DisplayWidth = 10
      FieldKind = fkLookup
      FieldName = 'LookSteuer'
      LookupDataSet = TableSteuer
      LookupKeyFields = 'ID'
      LookupResultField = 'MwSt'
      KeyFields = 'LookSteuerID'
      Lookup = True
    end
    object QueryMwStLookArtikel: TStringField
      DisplayWidth = 20
      FieldKind = fkLookup
      FieldName = 'LookArtikel'
      LookupDataSet = TableArtikel
      LookupKeyFields = 'ArtikelID'
      LookupResultField = 'Bezeichnung'
      KeyFields = 'ArtikelID'
      Lookup = True
    end
  end
  object QueryGetLeistungsID: TFDQuery
    SQL.Strings = (
      
        'SELECT T.LeistungsID, L.LeistungsBezeichnung FROM Tischzuordnung' +
        ' T'
      
        'LEFT OUTER JOIN leistungen L ON T.leistungsid = L.id AND L.Firma' +
        ' = :pFirma'
      'WHERE T.TischVon <= :TischNr AND T.TischBis >= :TischNr')
    Left = 354
    Top = 206
    ParamData = <
      item
        Name = 'pFirma'
        ParamType = ptInput
      end
      item
        Name = 'TischNr'
        DataType = ftString
      end>
  end
  object TableArtikel: TFDTable
    UpdateOptions.UpdateTableName = 'ARTIKEL'
    TableName = 'ARTIKEL'
    Left = 45
    Top = 290
  end
  object TableOffeneTische: TFDQuery
    SQL.Strings = (
      'Select * from OffeneTische'
      'Where'
      'firma = :pfirma and'
      'OffeneTischID = :pOffeneTischID')
    Left = 40
    Top = 142
    ParamData = <
      item
        Name = 'pfirma'
        ParamType = ptInput
      end
      item
        Name = 'pOffeneTischID'
        ParamType = ptInput
      end>
    object TableOffeneTischeFIRMA: TSmallintField
      DisplayWidth = 10
      FieldName = 'FIRMA'
      Origin = 'OFFENETISCHE.FIRMA'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object TableOffeneTischeOFFENETISCHID: TIntegerField
      DisplayWidth = 10
      FieldName = 'OFFENETISCHID'
      Origin = 'OFFENETISCHE.OFFENETISCHID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object TableOffeneTischeTISCHID: TIntegerField
      DisplayWidth = 10
      FieldName = 'TISCHID'
      Origin = 'OFFENETISCHE.TISCHID'
    end
    object TableOffeneTischeBEZEICHNUNG: TStringField
      DisplayWidth = 30
      FieldName = 'BEZEICHNUNG'
      Origin = 'OFFENETISCHE.BEZEICHNUNG'
      Size = 30
    end
    object TableOffeneTischeGASTADRESSEID: TIntegerField
      DisplayWidth = 10
      FieldName = 'GASTADRESSEID'
      Origin = 'OFFENETISCHE.GASTADRESSEID'
    end
    object TableOffeneTischeBEMERKUNG: TMemoField
      DisplayWidth = 10
      FieldName = 'BEMERKUNG'
      Origin = 'OFFENETISCHE.BEMERKUNG'
      BlobType = ftMemo
      Size = 8
    end
    object TableOffeneTischeDATUM: TDateTimeField
      DisplayWidth = 18
      FieldName = 'DATUM'
      Origin = 'OFFENETISCHE.DATUM'
    end
    object TableOffeneTischeBEGINN: TDateTimeField
      DisplayWidth = 18
      FieldName = 'BEGINN'
      Origin = 'OFFENETISCHE.BEGINN'
    end
    object TableOffeneTischeENDE: TDateTimeField
      DisplayWidth = 18
      FieldName = 'ENDE'
      Origin = 'OFFENETISCHE.ENDE'
    end
    object TableOffeneTischeOFFEN: TStringField
      DisplayWidth = 1
      FieldName = 'OFFEN'
      Origin = 'OFFENETISCHE.OFFEN'
      Size = 1
    end
    object TableOffeneTischeKELLNERID: TIntegerField
      DisplayWidth = 10
      FieldName = 'KELLNERID'
      Origin = 'OFFENETISCHE.KELLNERID'
    end
    object TableOffeneTischeANREISEDATUM: TDateTimeField
      DisplayWidth = 18
      FieldName = 'ANREISEDATUM'
      Origin = 'OFFENETISCHE.ANREISEDATUM'
    end
    object TableOffeneTischeABREISEDATUM: TDateTimeField
      DisplayWidth = 18
      FieldName = 'ABREISEDATUM'
      Origin = 'OFFENETISCHE.ABREISEDATUM'
    end
    object TableOffeneTischeLookTischNr: TStringField
      DisplayWidth = 20
      FieldKind = fkLookup
      FieldName = 'LookTischNr'
      LookupDataSet = TableTisch
      LookupKeyFields = 'TischID'
      LookupResultField = 'TischNr'
      KeyFields = 'TischID'
      Lookup = True
    end
    object TableOffeneTischeReservID: TIntegerField
      DisplayWidth = 10
      FieldName = 'RESERVID'
      Origin = 'OFFENETISCHE.RESERVID'
    end
    object TableOffeneTischeCURRENTWAITERID: TIntegerField
      FieldName = 'CURRENTWAITERID'
      Origin = 'OFFENETISCHE.CURRENTWAITERID'
    end
  end
  object TableTischgruppe: TFDTable
    UpdateOptions.UpdateTableName = 'TISCHGRUPPE'
    TableName = 'TISCHGRUPPE'
    Left = 150
    Top = 472
  end
  object TableKellner: TFDTable
    UpdateOptions.UpdateTableName = 'KELLNER'
    TableName = 'KELLNER'
    Left = 46
    Top = 408
  end
  object CommandJournal: TFDCommand
    Connection = ConnectionFelix
    CommandText.Strings = (
      'INSERT INTO Kassenjournal'
      '(FIRMA,DATUM,ZEIT,BETRAG,MENGE,LEISTUNGSID,'
      'RESERVID,ERFASSUNGDURCH,TEXT)'
      'VALUES'
      '(:FIRMA,:DATUM,:ZEIT,:BETRAG,:MENGE,:LEISTUNGSID,'
      ':RESERVID,:ERFASSUNGDURCH,:TEXT)')
    ParamData = <
      item
        Name = 'FIRMA'
        ParamType = ptInput
      end
      item
        Name = 'DATUM'
        ParamType = ptInput
      end
      item
        Name = 'ZEIT'
        ParamType = ptInput
      end
      item
        Name = 'BETRAG'
        ParamType = ptInput
      end
      item
        Name = 'MENGE'
        ParamType = ptInput
      end
      item
        Name = 'LEISTUNGSID'
        ParamType = ptInput
      end
      item
        Name = 'RESERVID'
        ParamType = ptInput
      end
      item
        Name = 'ERFASSUNGDURCH'
        ParamType = ptInput
      end
      item
        Name = 'TEXT'
        ParamType = ptInput
      end>
    Left = 378
    Top = 26
  end
  object QueryInsertOffeneTische: TFDQuery
    Left = 352
    Top = 268
  end
  object TableHotellog: TFDTable
    UpdateOptions.UpdateTableName = 'HOTELLOG'
    TableName = 'HOTELLOG'
    Left = 150
    Top = 144
  end
  object TableGastinfo: TFDTable
    UpdateOptions.UpdateTableName = 'GASTINFO'
    TableName = 'GASTINFO'
    Left = 150
    Top = 600
  end
  object QueryArtikel: TFDQuery
    SQL.Strings = (
      'SELECT * FROM Artikel'
      'WHERE Firma = :pFirma AND ArtikelID = :ArtikelID'
      'and ((inaktiv is null) or (inaktiv = '#39'F'#39'))')
    Left = 248
    Top = 544
  end
  object QueryLockTisch: TFDQuery
    SQL.Strings = (
      'UPDATE OffeneTische SET OffeneTischID = OffeneTischID'
      'WHERE OffeneTischID = :OffeneTischID')
    Left = 720
    Top = 260
  end
  object QuerySelectArtikel: TFDQuery
    SQL.Strings = (
      'Select * from Artikel'
      'Where Firma = :pFirma and ArtikelID = :pArtikelID')
    Left = 246
    Top = 488
  end
  object TableUntergruppe: TFDTable
    UpdateOptions.UpdateTableName = 'UNTERGRUPPE'
    TableName = 'UNTERGRUPPE'
    Left = 48
    Top = 472
  end
  object TableHauptgruppe: TFDTable
    UpdateOptions.UpdateTableName = 'HAUPTGRUPPE'
    TableName = 'HAUPTGRUPPE'
    Left = 152
    Top = 536
  end
  object TableKassinfo: TFDTable
    UpdateOptions.UpdateTableName = 'KASSINFO'
    TableName = 'KASSINFO'
    Left = 50
    Top = 538
  end
  object QueryGetLeistung: TFDQuery
    SQL.Strings = (
      'select * from leistungen l '
      
        'LEFT OUTER JOIN Steuer mw ON mw.Firma = l.Firma AND mw.id = l.mw' +
        'stid'
      'order by mw.mwst')
    Left = 350
    Top = 554
  end
  object QueryHilfTischkonto: TFDQuery
    SQL.Strings = (
      'Select * from Hilf_Tischkonto'
      'Where OffeneTischID = :pOffeneTischID')
    Left = 42
    Top = 346
    ParamData = <
      item
        Name = 'pOffeneTischID'
        ParamType = ptInput
      end>
    object QueryHilfTischkontoFirma: TSmallintField
      DisplayWidth = 10
      FieldName = 'Firma'
    end
    object QueryHilfTischkontoTischkontoID: TIntegerField
      DisplayWidth = 10
      FieldName = 'TischkontoID'
    end
    object QueryHilfTischkontoOffeneTischID: TIntegerField
      DisplayWidth = 10
      FieldName = 'OffeneTischID'
    end
    object QueryHilfTischkontoDatum: TDateField
      DisplayWidth = 10
      FieldName = 'Datum'
    end
    object QueryHilfTischkontoArtikelID: TIntegerField
      DisplayWidth = 10
      FieldName = 'ArtikelID'
    end
    object QueryHilfTischkontoMenge: TFloatField
      DisplayWidth = 10
      FieldName = 'Menge'
    end
    object QueryHilfTischkontoBetrag: TCurrencyField
      DisplayWidth = 10
      FieldName = 'Betrag'
    end
    object QueryHilfTischkontoKellnerID: TIntegerField
      DisplayWidth = 10
      FieldName = 'KellnerID'
    end
    object QueryHilfTischkontoKasseID: TIntegerField
      DisplayWidth = 10
      FieldName = 'KasseID'
    end
    object QueryHilfTischkontoGEDRUCKT: TStringField
      DisplayWidth = 1
      FieldName = 'GEDRUCKT'
      Size = 1
    end
    object QueryHilfTischkontoBeilagenID1: TIntegerField
      DisplayWidth = 10
      FieldName = 'BeilagenID1'
    end
    object QueryHilfTischkontoBeilagenID2: TIntegerField
      DisplayWidth = 10
      FieldName = 'BeilagenID2'
    end
    object QueryHilfTischkontoBeilagenID3: TIntegerField
      DisplayWidth = 10
      FieldName = 'BeilagenID3'
    end
    object QueryHilfTischkontoBeilagenText: TStringField
      DisplayWidth = 35
      FieldName = 'BeilagenText'
      Size = 35
    end
    object QueryHilfTischkontoStatus: TSmallintField
      DisplayWidth = 10
      FieldName = 'Status'
    end
    object QueryHilfTischkontoVERBUCHT: TStringField
      DisplayWidth = 1
      FieldName = 'VERBUCHT'
      Size = 1
    end
    object QueryHilfTischkontoGANGID: TIntegerField
      DisplayWidth = 10
      FieldName = 'GANGID'
    end
    object QueryHilfTischkontoI_DEVICEGUID: TStringField
      FieldName = 'I_DEVICEGUID'
      Size = 40
    end
  end
  object TableTischkonto: TFDQuery
    SQL.Strings = (
      'SELECT * FROM Tischkonto '
      'WHERE OffeneTischID = :pOffeneTischID'
      'ORDER BY Tischkonto.TischkontoID')
    Left = 40
    Top = 194
    ParamData = <
      item
        Name = 'pOffeneTischID'
        ParamType = ptInput
      end>
  end
  object QueryRoomDiscount: TFDQuery
    SQL.Strings = (
      'SELECT * FROM Hilf_Tischkonto')
    Left = 592
    Top = 198
  end
  object QueryGetHaupgruppeVorSum: TFDQuery
    SQL.Strings = (
      'select h.vorsum'
      'from Artikel a'
      
        'left outer JOIN Untergruppe u ON u.firma = a.firma and u.untergr' +
        'uppeid = a.untergruppeid'
      
        'left outer join hauptgruppe h ON h.firma = u.firma and h.hauptgr' +
        'uppeid = u.hauptgruppeid'
      'WHERE a.firma = 1 and a.artikelid = :ArtikelID')
    Left = 592
    Top = 260
    ParamData = <
      item
        Name = 'ArtikelID'
        DataType = ftInteger
        ParamType = ptInput
      end>
  end
  object QueryGetRabatt: TFDQuery
    SQL.Strings = (
      'SELECT RT FROM GastInfo'
      'Where Pers_Nr = :pPers_Nr')
    Left = 592
    Top = 326
    ParamData = <
      item
        Name = 'pPers_Nr'
        ParamType = ptInput
      end>
  end
  object QueryJournalControl: TFDQuery
    SQL.Strings = (
      'INSERT INTO JOURNAL'
      '(Firma, KellnerID, OffeneTischID, Datum, Zeit, KasseID, '
      'JournalTyp, Text, Menge, ZahlwegID, Betrag, ArtikelID, '
      
        'BeilagenID, VonOffeneTischID, RechnungsID, Nachlass, LagerVerbuc' +
        'ht, LagerDatum)'
      'VALUES'
      '(:Firma, :KellnerID, :OffeneTischID, :Datum, :Zeit, :KasseID, '
      ':JournalTyp, :Text, :Menge, :ZahlwegID, :Betrag, :ArtikelID, '
      
        ':BeilagenID, :VonOffeneTischID, :RechnungsID, :Nachlass, :LagerV' +
        'erbucht, :LagerDatum)')
    Left = 592
    Top = 384
    ParamData = <
      item
        Name = 'Firma'
        DataType = ftInteger
        ParamType = ptInput
      end
      item
        Name = 'KellnerID'
        DataType = ftInteger
        ParamType = ptInput
      end
      item
        Name = 'OffeneTischID'
        DataType = ftInteger
        ParamType = ptInput
      end
      item
        Name = 'Datum'
        DataType = ftDate
        ParamType = ptInput
      end
      item
        Name = 'Zeit'
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'KasseID'
        DataType = ftInteger
        ParamType = ptInput
      end
      item
        Name = 'JournalTyp'
        DataType = ftInteger
        ParamType = ptInput
      end
      item
        Name = 'Text'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'Menge'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'ZahlwegID'
        DataType = ftInteger
        ParamType = ptInput
      end
      item
        Name = 'Betrag'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'ArtikelID'
        DataType = ftInteger
        ParamType = ptInput
      end
      item
        Name = 'BeilagenID'
        DataType = ftInteger
        ParamType = ptInput
      end
      item
        Name = 'VonOffeneTischID'
        DataType = ftInteger
        ParamType = ptInput
      end
      item
        Name = 'RechnungsID'
        DataType = ftInteger
        ParamType = ptInput
      end
      item
        Name = 'Nachlass'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'LagerVerbucht'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'LagerDatum'
        DataType = ftDate
        ParamType = ptInput
      end>
  end
  object QueryCheckZimmerIB: TFDQuery
    Left = 596
    Top = 438
  end
  object QueryTische: TFDQuery
    Left = 592
    Top = 496
  end
  object QueryTableAccount: TFDQuery
    SQL.Strings = (
      'select * from'
      'Tischkonto'
      'where'
      'firma = :pfirma and'
      'offenetischid = :poffenetischid'
      'order by'
      'Firma, TischKontoID')
    Left = 736
    Top = 552
    ParamData = <
      item
        Name = 'pfirma'
        ParamType = ptInput
      end
      item
        Name = 'poffenetischid'
        ParamType = ptInput
      end>
  end
  object QueryHelpTableAccount: TFDQuery
    SQL.Strings = (
      'select * from'
      'Hilf_Tischkonto'
      'where'
      'firma = :pfirma and'
      'offenetischid = :poffenetischid'
      'order by'
      'Firma, TischKontoID')
    Left = 736
    Top = 608
    ParamData = <
      item
        Name = 'pfirma'
        ParamType = ptInput
      end
      item
        Name = 'poffenetischid'
        ParamType = ptInput
      end>
  end
  object TransactionLockTable: TFDTransaction
    Left = 264
    Top = 24
  end
  object QueryGetOpenTableIDbyTableID: TFDQuery
    SQL.Strings = (
      'select OffeneTischID'
      'from'
      'OffeneTische'
      'where'
      'firma = :pFirma and'
      'TischID = :pTischID and'
      'Datum = :pDatum and'
      'Offen = '#39'T'#39
      'order by'
      'OffeneTischID desc')
    Left = 728
    Top = 384
    ParamData = <
      item
        Name = 'pFirma'
        ParamType = ptInput
      end
      item
        Name = 'pTischID'
        ParamType = ptInput
      end
      item
        Name = 'pDatum'
        ParamType = ptInput
      end>
  end
  object QueryWaiter: TFDQuery
    SQL.Strings = (
      'select *'
      'from'
      'Kellner'
      'where'
      'firma = :pFirma and'
      'kellnerid > 0 and'
      '((inaktiv = '#39'F'#39') or (inaktiv is null)) and'
      '((datenanlage = '#39'F'#39') or (datenanlage is null))'
      'order by'
      'firma, kellnerid')
    Left = 720
    Top = 144
    ParamData = <
      item
        Name = 'pFirma'
        ParamType = ptInput
      end>
  end
  object QueryReactivateTable: TFDQuery
    Left = 720
    Top = 320
  end
  object QueryCheckTableisReopened: TFDQuery
    SQL.Strings = (
      'Select OffeneTischID from OffeneTische'
      'Where'
      'firma = :pfirma and'
      'datum = :pdatum and'
      'offen = :poffen and'
      'tischid = :ptischid')
    Left = 720
    Top = 200
    ParamData = <
      item
        Name = 'pfirma'
        ParamType = ptInput
      end
      item
        Name = 'pdatum'
        ParamType = ptInput
      end
      item
        Name = 'poffen'
        ParamType = ptInput
      end
      item
        Name = 'ptischid'
        ParamType = ptInput
      end>
  end
  object QueryProcedureCheckTischOffen: TFDQuery
    Left = 736
    Top = 440
  end
  object QueryWriteCurrentWaiterToOpenTable: TFDQuery
    SQL.Strings = (
      'update'
      'OffeneTische'
      'set'
      'CurrentWaiterID = :pCurrentWaiterID'
      'where'
      'firma = :pfirma and'
      'offenetischid = :poffenetischid')
    Left = 736
    Top = 496
    ParamData = <
      item
        Name = 'pCurrentWaiterID'
        ParamType = ptInput
      end
      item
        Name = 'pfirma'
        ParamType = ptInput
      end
      item
        Name = 'poffenetischid'
        ParamType = ptInput
      end>
  end
  object QueryGetFertigeSpeisen: TFDQuery
    SQL.Strings = (
      'SELECT TischNR, Anz, Bez, Status '
      'FROM iPAQ'
      'WHERE (KellnerID = :KellnerID) '
      '  AND ((Status < 1) OR (Status is Null))')
    Left = 604
    Top = 552
    ParamData = <
      item
        Name = 'KellnerID'
        ParamType = ptInput
      end>
  end
  object QueryConfirmFertigeSpeisen: TFDQuery
    SQL.Strings = (
      'DELETE FROM iPAQ'
      'WHERE (KellnerID = :KellnerID) '
      '  AND (Status = 1)')
    Left = 604
    Top = 604
    ParamData = <
      item
        Name = 'KellnerID'
        ParamType = ptInput
      end>
  end
  object QueryReservFELIX: TFDQuery
    SQL.Strings = (
      
        'select r.FIRMA, r.ID, r.ZIMMERID, r.GASTNAME, r.CHECKIN from RES' +
        'ERVIERUNG r'
      'where r.FIRMA=:pFirma and r.ID = :pID')
    Left = 242
    Top = 204
    ParamData = <
      item
        Name = 'pFirma'
        ParamType = ptInput
      end
      item
        Name = 'pID'
        ParamType = ptInput
      end>
  end
  object QueryCheckFELIX: TFDQuery
    SQL.Strings = (
      'select first 1 * from leistungen')
    Left = 242
    Top = 144
  end
  object QueryTerminNr: TFDQuery
    SQL.Strings = (
      
        'SELECT Distinct(ZI_Nummer) AS ZimmerID, Substring(ZI_Pers from 1' +
        ' for 18) AS TischNR,'
      
        'Termin_Nr AS TischID, Pers_NR as gastadresseid, Zi_Pers as Gastn' +
        'ame'
      'FROM GastInfo'
      'Where TERMIN_Nr = :pTerminNr')
    Left = 242
    Top = 372
    ParamData = <
      item
        Name = 'pTerminNr'
        ParamType = ptInput
      end>
  end
  object ConnectionFelix: TFDConnection
    Params.Strings = (
      'User_Name=SYSDBA'
      'Password=x'
      'DriverID=FB'
      'CharacterSet=UTF8')
    Left = 144
    Top = 24
  end
end
