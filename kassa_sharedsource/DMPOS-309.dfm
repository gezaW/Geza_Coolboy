object DataPos: TDataPos
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 902
  Width = 1263
  object CDSKonto: TClientDataSet
    Aggregates = <
      item
        Active = True
        AggregateName = 'Summe'
        Expression = 'SUM(Menge*Betrag)'
        Visible = False
      end
      item
        AggregateName = 'Firma'
        Visible = False
      end
      item
        AggregateName = 'OffeneTischID'
        Visible = False
      end
      item
        AggregateName = 'ArtikelID'
        Visible = False
      end
      item
        AggregateName = 'Betrag'
        Visible = False
      end>
    AggregatesActive = True
    Filter = '((Menge <> 0) or (Menge is null))'
    FieldDefs = <
      item
        Name = 'TischkontoID'
        DataType = ftInteger
      end
      item
        Name = 'Firma'
        DataType = ftSmallint
      end
      item
        Name = 'OffeneTischID'
        DataType = ftInteger
      end
      item
        Name = 'Datum'
        DataType = ftDate
      end
      item
        Name = 'ArtikelID'
        DataType = ftInteger
      end
      item
        Name = 'Menge'
        DataType = ftFloat
      end
      item
        Name = 'LookArtikel'
        DataType = ftString
        Size = 25
      end
      item
        Name = 'Betrag'
        DataType = ftFloat
      end
      item
        Name = 'KellnerID'
        DataType = ftInteger
      end
      item
        Name = 'KasseID'
        DataType = ftInteger
      end
      item
        Name = 'Gedruckt'
        DataType = ftString
        Size = 1
      end
      item
        Name = 'Verbucht'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'Status'
        DataType = ftSmallint
      end
      item
        Name = 'GangID'
        DataType = ftInteger
      end
      item
        Name = 'Zaehler'
        DataType = ftInteger
      end
      item
        Name = 'Beilagenabfrage'
        DataType = ftString
        Size = 1
      end
      item
        Name = 'BeilagenID1'
        DataType = ftInteger
      end
      item
        Name = 'BeilagenID2'
        DataType = ftInteger
      end
      item
        Name = 'BeilagenID3'
        DataType = ftInteger
      end
      item
        Name = 'BeilagenText'
        DataType = ftString
        Size = 35
      end
      item
        Name = 'I_DeviceGuid'
        DataType = ftString
        Size = 40
      end>
    IndexDefs = <
      item
        Name = 'CDSKontoIndex1'
        Fields = 'Firma;TischKontoID'
        Options = [ixPrimary]
      end>
    IndexName = 'CDSKontoIndex1'
    Params = <>
    StoreDefs = True
    Left = 288
    Top = 16
  end
  object DataSourceOffeneTische: TDataSource
    DataSet = TableOffeneTische
    Left = 992
    Top = 234
  end
  object DataSourceReserv: TDataSource
    Left = 996
    Top = 300
  end
  object DataSource1: TDataSource
    DataSet = CDSKonto
    Left = 398
    Top = 16
  end
  object QueryToTisch: TIBOQuery
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    PreparedEdits = True
    PreparedInserts = True
    RecordCountAccurate = True
    Left = 416
    Top = 668
  end
  object QueryInsertTischkonto: TIBOQuery
    Params = <
      item
        DataType = ftInteger
        Name = 'Firma'
        ParamType = ptUnknown
      end
      item
        DataType = ftInteger
        Name = 'OffeneTischID'
        ParamType = ptUnknown
      end
      item
        DataType = ftInteger
        Name = 'ArtikelID'
        ParamType = ptUnknown
      end
      item
        DataType = ftFloat
        Name = 'Menge'
        ParamType = ptUnknown
      end
      item
        DataType = ftFloat
        Name = 'Betrag'
        ParamType = ptUnknown
      end
      item
        DataType = ftInteger
        Name = 'BeilagenID1'
        ParamType = ptUnknown
      end
      item
        DataType = ftInteger
        Name = 'BeilagenID2'
        ParamType = ptUnknown
      end
      item
        DataType = ftInteger
        Name = 'BeilagenID3'
        ParamType = ptUnknown
      end
      item
        DataType = ftInteger
        Name = 'KasseID'
        ParamType = ptUnknown
      end
      item
        DataType = ftString
        Name = 'Gedruckt'
        ParamType = ptUnknown
      end
      item
        DataType = ftInteger
        Name = 'KellnerID'
        ParamType = ptUnknown
      end
      item
        DataType = ftDate
        Name = 'Datum'
        ParamType = ptUnknown
      end
      item
        DataType = ftString
        Name = 'Verbucht'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'BeilagenText'
        ParamType = ptUnknown
      end
      item
        DataType = ftSmallint
        Name = 'Status'
        ParamType = ptUnknown
      end
      item
        DataType = ftSmallint
        Name = 'GangID'
        ParamType = ptUnknown
      end>
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    PreparedEdits = True
    PreparedInserts = True
    RecordCountAccurate = True
    SQL.Strings = (
      'INSERT INTO Tischkonto'
      
        '(Firma, OffeneTischID, ArtikelID, Menge, Betrag, BeilagenID1, Be' +
        'ilagenID2, '
      
        'BeilagenID3, KasseID, Gedruckt, KellnerID, Datum, Verbucht, Beil' +
        'agenText, Status, GangID)'
      'VALUES'
      
        '(:Firma, :OffeneTischID, :ArtikelID, :Menge, :Betrag, :BeilagenI' +
        'D1, :BeilagenID2, '
      
        ':BeilagenID3, :KasseID, :Gedruckt, :KellnerID, :Datum, :Verbucht' +
        ', :BeilagenText, :Status, :GangID)'
      ''
      '')
    Left = 416
    Top = 288
  end
  object Query: TIBOQuery
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    PreparedEdits = True
    PreparedInserts = True
    RecordCountAccurate = True
    Left = 712
    Top = 192
  end
  object QueryDelTischkonto: TIBOQuery
    Params = <
      item
        DataType = ftInteger
        Name = 'OffeneTischID'
        ParamType = ptUnknown
      end
      item
        DataType = ftInteger
        Name = 'Firma'
        ParamType = ptUnknown
      end>
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    PreparedEdits = True
    PreparedInserts = True
    RecordCountAccurate = True
    SQL.Strings = (
      'DELETE FROM Tischkonto'
      'WHERE OffeneTischID = :OffeneTischID'
      'AND Firma =:Firma')
    Left = 512
    Top = 552
  end
  object QueryInsertRechkonto: TIBOQuery
    Params = <
      item
        DataType = ftUnknown
        Name = 'Firma'
        ParamType = ptInput
      end
      item
        DataType = ftUnknown
        Name = 'RechnungsID'
        ParamType = ptInput
      end
      item
        DataType = ftUnknown
        Name = 'Datum'
        ParamType = ptInput
      end
      item
        DataType = ftUnknown
        Name = 'ArtikelID'
        ParamType = ptInput
      end
      item
        DataType = ftUnknown
        Name = 'Menge'
        ParamType = ptInput
      end
      item
        DataType = ftUnknown
        Name = 'Betrag'
        ParamType = ptInput
      end
      item
        DataType = ftUnknown
        Name = 'LeistungsText'
        ParamType = ptInput
      end
      item
        DataType = ftUnknown
        Name = 'BonNr'
        ParamType = ptInput
      end>
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    PreparedEdits = True
    PreparedInserts = True
    RecordCountAccurate = True
    SQL.Strings = (
      'INSERT INTO Rechnungskonto'
      
        '(Firma, RechnungsID, Datum, ArtikelID, Menge, Betrag, LeistungsT' +
        'ext, BonNr)'
      'VALUES '
      
        '(:Firma, :RechnungsID, :Datum, :ArtikelID, :Menge, :Betrag, :Lei' +
        'stungsText, :BonNr)'
      '')
    Left = 512
    Top = 608
  end
  object QueryTastengruppen: TIBOQuery
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    PreparedEdits = True
    PreparedInserts = True
    RecordCountAccurate = True
    SQL.Strings = (
      'Select Bezeichnung, TastengruppeID '
      'from Tastengruppe'
      'Where (Farbe <> 0) '
      '  and ((Bezeichnung <> '#39#39') and NOT (Bezeichnung is NULL))'
      '  and tastengruppeID > 0'
      '  and tastengruppeID < 900'
      'Order By ReihungFunki')
    Left = 512
    Top = 340
  end
  object QueryLocateOffenerTisch: TIBOQuery
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    PreparedEdits = True
    PreparedInserts = True
    RecordCountAccurate = True
    Left = 600
    Top = 256
  end
  object QueryHappyHour: TIBOQuery
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    PreparedEdits = True
    PreparedInserts = True
    RecordCountAccurate = True
    SQL.Strings = (
      'SELECT * FROM HappyHour')
    Left = 416
    Top = 608
  end
  object QueryBeilagengruppe: TIBOQuery
    Params = <
      item
        DataType = ftUnknown
        Name = 'pFirma'
        ParamType = ptInput
      end>
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    PreparedEdits = True
    PreparedInserts = True
    RecordCountAccurate = True
    SQL.Strings = (
      'Select BeilagengruppenID, Bezeichnung '
      'From Beilagengruppe'
      'Where Firma = :pFirma '
      '  and BeilagengruppenID > 0'
      '  and BeilagengruppenID < 900'
      'Order By Bezeichnung')
    Left = 512
    Top = 296
  end
  object QueryBeilagen: TIBOQuery
    Params = <
      item
        DataType = ftUnknown
        Name = 'pFirma'
        ParamType = ptInput
      end
      item
        DataType = ftUnknown
        Name = 'pBeilagengruppeID'
        ParamType = ptInput
      end>
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    PreparedEdits = True
    PreparedInserts = True
    RecordCountAccurate = True
    SQL.Strings = (
      'select'
      '*'
      'from'
      '('
      'select'
      'BeilagenID,'
      
        '(CASE WHEN BeilagenID = -1 THEN '#39'freier Text'#39' ELSE Bezeichnung E' +
        'ND) as Bezeichnung,'
      'BeilagenID as Reihung'
      'from'
      'beilagen'
      'where'
      'beilagenid < 0 and'
      'firma = :pFirma'
      'Union'
      
        'Select BU.BeilagenID, B.Bezeichnung, case when BU.Reihung is nul' +
        'l then 0 else BU.Reihung end as Reihung'
      'from BeilagenUntergruppe BU'
      'Inner Join Beilagen B'
      'on BU.BeilagenID = B.BeilagenID and BU.firma = B.Firma'
      'Where'
      'BU.BeilagengruppeID = :pBeilagengruppeID and'
      'BU.Firma = :pFirma'
      ')'
      'Order By Reihung')
    Left = 504
    Top = 256
  end
  object QueryFromTisch: TIBOQuery
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    PreparedEdits = True
    PreparedInserts = True
    RecordCountAccurate = True
    Left = 416
    Top = 188
  end
  object QueryTastengruppeMenu: TIBOQuery
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    PreparedEdits = True
    PreparedInserts = True
    RecordCountAccurate = True
    SQL.Strings = (
      
        'Select OM.TastengruppeID, TA.Bezeichnung, OM.OrdermanID from O_M' +
        'enucard OM'
      'Inner join Tastengruppe TA'
      'on OM.TastengruppeID = TA.TastengruppeID'
      'Where (not OM.TastengruppeID is NUll)'
      'Order By OM.OrdermanID')
    Left = 416
    Top = 340
  end
  object QueryTKDelete: TIBOQuery
    Params = <
      item
        DataType = ftUnknown
        Name = 'OffeneTischID'
        ParamType = ptUnknown
      end>
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    PreparedEdits = True
    PreparedInserts = True
    RecordCountAccurate = True
    SQL.Strings = (
      'Delete From Tischkonto '
      'Where Status = 255 and'
      '            OffeneTischID = :OffeneTischID')
    Left = 416
    Top = 392
  end
  object QueryRechnungskontoIT: TIBOQuery
    Params = <
      item
        DataType = ftInteger
        Name = 'RechnungsID'
        ParamType = ptUnknown
      end>
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    PreparedEdits = True
    PreparedInserts = True
    RecordCountAccurate = True
    SQL.Strings = (
      
        'SELECT ArtikelID, Betrag, RechnungsID, LeistungsText, SUM(Menge)' +
        ' AS Menge FROM Rechnungskonto'
      'WHERE RechnungsID = :RechnungsID'
      'GROUP BY ArtikelID, Betrag, RechnungsID, LeistungsText')
    Left = 608
    Top = 288
  end
  object QueryBeilagenText: TIBOQuery
    Params = <
      item
        DataType = ftInteger
        Name = 'BeilagenID'
        ParamType = ptUnknown
      end>
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    PreparedEdits = True
    PreparedInserts = True
    RecordCountAccurate = True
    SQL.Strings = (
      'Select Bezeichnung from Beilagen'
      'Where BeilagenID = :BeilagenID')
    Left = 608
    Top = 336
  end
  object QueryZahlweg: TIBOQuery
    Params = <
      item
        DataType = ftUnknown
        Name = 'Firma'
        ParamType = ptInput
      end>
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    PreparedEdits = True
    PreparedInserts = True
    RecordCountAccurate = True
    SQL.Strings = (
      'Select Id, Bezeichnung From Zahlweg'
      'Where Firma = :Firma'
      'Order By Sortiernummer')
    Left = 608
    Top = 384
  end
  object QueryDelRechnung: TIBOQuery
    Params = <
      item
        DataType = ftUnknown
        Name = 'ID'
        ParamType = ptUnknown
      end>
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    PreparedEdits = True
    PreparedInserts = True
    RecordCountAccurate = True
    SQL.Strings = (
      'DELETE FROM Rechnung'
      'WHERE ID = :ID')
    Left = 608
    Top = 440
  end
  object QueryDelRechzahlweg: TIBOQuery
    Params = <
      item
        DataType = ftInteger
        Name = 'RechnungsID'
        ParamType = ptUnknown
      end>
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    PreparedEdits = True
    PreparedInserts = True
    RecordCountAccurate = True
    SQL.Strings = (
      'DELETE FROM Rechnungszahlweg'
      'WHERE RechnungsID = :RechnungsID')
    Left = 608
    Top = 496
  end
  object QuerytastArtikel: TIBOQuery
    Params = <
      item
        DataType = ftUnknown
        Name = 'TastengruppeID'
        ParamType = ptInput
      end>
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    PreparedEdits = True
    PreparedInserts = True
    RecordCountAccurate = True
    SQL.Strings = (
      'Select Bezeichnung, ArtikelID from Artikel'
      'Where (TastengruppeID = :TastengruppeID)'
      'and ((inaktiv is null) or (inaktiv = '#39'F'#39'))'
      'and ((nurlager is null) or (nurlager = '#39'F'#39')) '
      'Order By ReihungFunki, Reihung')
    Left = 608
    Top = 552
  end
  object QueryTransfer: TIBOQuery
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    PreparedEdits = True
    PreparedInserts = True
    RecordCountAccurate = True
    Left = 610
    Top = 610
  end
  object QueryRechNr: TIBOQuery
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    PreparedEdits = True
    PreparedInserts = True
    RecordCountAccurate = True
    Left = 504
    Top = 456
  end
  object QueryInsertRechnung: TIBOQuery
    Params = <
      item
        DataType = ftInteger
        Name = 'Firma'
        ParamType = ptUnknown
      end
      item
        DataType = ftInteger
        Name = 'ID'
        ParamType = ptUnknown
      end
      item
        DataType = ftInteger
        Name = 'ReservID'
        ParamType = ptUnknown
      end
      item
        DataType = ftDateTime
        Name = 'Datum'
        ParamType = ptUnknown
      end
      item
        DataType = ftInteger
        Name = 'Rechnungsnummer'
        ParamType = ptUnknown
      end
      item
        DataType = ftInteger
        Name = 'ErstellerID'
        ParamType = ptUnknown
      end
      item
        DataType = ftFloat
        Name = 'ZahlungsBetrag'
        ParamType = ptUnknown
      end
      item
        DataType = ftFloat
        Name = 'BereitsBezahlt'
        ParamType = ptUnknown
      end
      item
        DataType = ftString
        Name = 'Bezahlt'
        ParamType = ptUnknown
      end
      item
        DataType = ftString
        Name = 'Gedruckt'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'Nachlass'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'AdresseID'
        ParamType = ptUnknown
      end
      item
        DataType = ftString
        Name = 'VorausRechnungKz'
        ParamType = ptUnknown
      end>
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    PreparedEdits = True
    PreparedInserts = True
    RecordCountAccurate = True
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
    Left = 552
    Top = 384
  end
  object QueryInsertRechzahlung: TIBOQuery
    Params = <
      item
        DataType = ftInteger
        Name = 'Firma'
        ParamType = ptUnknown
      end
      item
        DataType = ftInteger
        Name = 'RechnungsID'
        ParamType = ptUnknown
      end
      item
        DataType = ftDate
        Name = 'Datum'
        ParamType = ptUnknown
      end
      item
        DataType = ftInteger
        Name = 'ZahlwegID'
        ParamType = ptUnknown
      end
      item
        DataType = ftFloat
        Name = 'Betrag'
        ParamType = ptUnknown
      end
      item
        DataType = ftString
        Name = 'Verbucht'
        ParamType = ptUnknown
      end>
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    PreparedEdits = True
    PreparedInserts = True
    RecordCountAccurate = True
    SQL.Strings = (
      'INSERT INTO RechnungsZahlweg'
      '(Firma, RechnungsID, Datum, ZahlwegID, Betrag, Verbucht)'
      
        'VALUES (:Firma, :RechnungsID, :Datum, :ZahlwegID, :Betrag, :Verb' +
        'ucht)')
    Left = 712
    Top = 336
  end
  object QueryDelRechnungsKonto: TIBOQuery
    Params = <
      item
        DataType = ftInteger
        Name = 'RechnungsID'
        ParamType = ptUnknown
      end>
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    PreparedEdits = True
    PreparedInserts = True
    RecordCountAccurate = True
    SQL.Strings = (
      'DELETE FROM RechnungsKonto'
      'WHERE RechnungsID = :RechnungsID')
    Left = 712
    Top = 384
  end
  object QueryRechnungsKonto: TIBOQuery
    Params = <
      item
        DataType = ftInteger
        Name = 'RechnungsID'
        ParamType = ptUnknown
      end>
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    PreparedEdits = True
    PreparedInserts = True
    RecordCountAccurate = True
    SQL.Strings = (
      'SELECT * FROM RechnungsKonto'
      'WHERE RechnungsID = :RechnungsID')
    Left = 640
    Top = 344
  end
  object QueryRechnungMwSt: TIBOQuery
    Params = <
      item
        DataType = ftInteger
        Name = 'rechnungsid'
        ParamType = ptUnknown
      end>
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    PreparedEdits = True
    PreparedInserts = True
    RecordCountAccurate = True
    SQL.Strings = (
      'SELECT st.MwSt AS Mwst, sum(menge*betrag) as Gesamt'
      'from rechnungskonto rk'
      'LEFT OUTER JOIN Artikel a'
      '  ON a.ArtikelID = rk.ArtikelID '
      'LEFT OUTER JOIN Untergruppe u'
      '  ON u.Untergruppeid = a.UntergruppeID'
      'LEFT OUTER JOIN Hauptgruppe h'
      '  ON u.Hauptgruppeid = h.HauptgruppeID'
      'LEFT OUTER JOIN Steuer st'
      '  ON h.SteuerID = st.ID'
      'WHERE rechnungsid = :rechnungsid'
      'AND LeistungsText = ""'
      'GROUP BY st.MwSt')
    Left = 712
    Top = 286
  end
  object QueryReviere: TIBOQuery
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    PreparedEdits = True
    PreparedInserts = True
    RecordCountAccurate = True
    SQL.Strings = (
      'Select * '
      'from Reviere'
      'Order by Reihung')
    Left = 792
    Top = 336
  end
  object TableDrucker: TIBOTable
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    PreparedEdits = True
    PreparedInserts = True
    RecordCountAccurate = True
    TableName = 'DRUCKERTXT'
    Left = 150
    Top = 192
  end
  object TableTisch: TIBOTable
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    KeyLinks.Strings = (
      'FIRMA'
      'TISCHID')
    KeyLinksAutoDefine = False
    PreparedEdits = True
    PreparedInserts = True
    RecordCountAccurate = True
    TableName = 'TISCH'
    Left = 40
    Top = 236
  end
  object TableBeilagen: TIBOTable
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    KeyLinks.Strings = (
      'FIRMA'
      'BEILAGENID')
    KeyLinksAutoDefine = False
    PreparedEdits = True
    PreparedInserts = True
    RecordCountAccurate = True
    TableName = 'BEILAGEN'
    Left = 150
    Top = 240
  end
  object TableTischkonto2: TIBOTable
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    GeneratorLinks.Strings = (
      'TISCHKONTOID = GEN_TISCHKONTO')
    KeyLinks.Strings = (
      'FIRMA'
      'TISCHKONTOID')
    KeyLinksAutoDefine = False
    PreparedEdits = True
    PreparedInserts = True
    RecordCountAccurate = True
    TableName = 'TISCHKONTO'
    Left = 150
    Top = 288
  end
  object TableBeilagengruppe: TIBOTable
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    PreparedEdits = True
    PreparedInserts = True
    RecordCountAccurate = True
    TableName = 'BEILAGENGRUPPE'
    Left = 38
    Top = 288
  end
  object TableSchankartikel: TIBOTable
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    KeyLinks.Strings = (
      'FIRMA'
      'ARTIKELID')
    KeyLinksAutoDefine = False
    PreparedEdits = True
    PreparedInserts = True
    RecordCountAccurate = True
    TableName = 'SCHANK_ARTIKEL'
    Left = 38
    Top = 338
  end
  object TableSteuer: TIBOTable
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    PreparedEdits = True
    PreparedInserts = True
    RecordCountAccurate = True
    TableName = 'STEUER'
    Left = 152
    Top = 336
  end
  object TableRechnung: TIBOTable
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    FilterOptions = [foCaseInsensitive]
    GeneratorLinks.Strings = (
      'ID = GEN_RECHNUNG')
    KeyLinks.Strings = (
      'ID')
    KeyLinksAutoDefine = False
    PreparedEdits = True
    PreparedInserts = True
    RecordCountAccurate = True
    TableName = 'RECHNUNG'
    Left = 150
    Top = 390
  end
  object TableKasseIT: TIBOTable
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    PreparedEdits = True
    PreparedInserts = True
    RecordCountAccurate = True
    TableName = 'KASSEIT'
    Left = 150
    Top = 444
  end
  object TableFirmenText: TIBOTable
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    PreparedEdits = True
    PreparedInserts = True
    RecordCountAccurate = True
    TableName = 'FIRMENTEXT'
    Left = 150
    Top = 504
  end
  object QueryHilf_Tischkonto: TIBOQuery
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    PreparedEdits = True
    PreparedInserts = True
    RecordCountAccurate = True
    SQL.Strings = (
      '')
    Left = 712
    Top = 440
  end
  object TableZimmerFELIX: TIBOTable
    IB_Connection = IB_ConnectionFelix
    KeyLinks.Strings = (
      'FIRMA'
      'ID')
    KeyLinksAutoDefine = False
    PreparedEdits = True
    PreparedInserts = True
    RecordCountAccurate = True
    TableName = 'ZIMMER'
    Left = 290
    Top = 240
  end
  object TableGastkontoFELIX: TIBOTable
    GeneratorLinks.Strings = (
      'ID = GEN_GASTKONTO_ID')
    IB_Connection = IB_ConnectionFelix
    KeyLinks.Strings = (
      'ID')
    PreparedEdits = True
    PreparedInserts = True
    RecordCountAccurate = True
    AfterInsert = TableGastkontoFELIXAfterInsert
    IndexFieldNames = 'RESERVID'
    MasterFields = 'ID'
    MasterSource = DataSourceReserv
    TableName = 'GASTKONTO'
    Left = 290
    Top = 288
  end
  object TableSparten: TIBOTable
    IB_Connection = IB_ConnectionFelix
    KeyLinks.Strings = (
      'FIRMA'
      'ID')
    KeyLinksAutoDefine = False
    PreparedEdits = True
    PreparedInserts = True
    RecordCountAccurate = True
    TableName = 'SPARTEN'
    Left = 288
    Top = 336
  end
  object TableFelixMwst: TIBOTable
    IB_Connection = IB_ConnectionFelix
    KeyLinks.Strings = (
      'FIRMA'
      'ID')
    KeyLinksAutoDefine = False
    PreparedEdits = True
    PreparedInserts = True
    RecordCountAccurate = True
    TableName = 'MEHRWERTSTEUER'
    Left = 288
    Top = 384
  end
  object Table_Diverses: TIBOTable
    IB_Connection = IB_ConnectionFelix
    KeyLinks.Strings = (
      'FIRMA')
    KeyLinksAutoDefine = False
    PreparedEdits = True
    PreparedInserts = True
    RecordCountAccurate = True
    TableName = 'DIVERSES'
    Left = 288
    Top = 440
  end
  object QueryGetNextID: TIBOQuery
    IB_Connection = IB_ConnectionFelix
    PreparedEdits = True
    PreparedInserts = True
    RecordCountAccurate = True
    Left = 512
    Top = 664
  end
  object QueryMwSt: TIBOQuery
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    PreparedEdits = True
    PreparedInserts = True
    RecordCountAccurate = True
    SQL.Strings = (
      'SELECT * FROM Hilf_Tischkonto')
    Left = 712
    Top = 496
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
  object QueryTische2: TIBOQuery
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    IB_Transaction = IB_Transaction2
    PreparedEdits = True
    PreparedInserts = True
    RecordCountAccurate = True
    Left = 792
    Top = 616
  end
  object Query_GetLeistungsID: TIBOQuery
    Params = <
      item
        DataType = ftUnknown
        Name = 'pFirma'
        ParamType = ptInput
      end
      item
        DataType = ftString
        Name = 'TischNr'
        ParamType = ptUnknown
      end>
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    PreparedEdits = True
    PreparedInserts = True
    RecordCountAccurate = True
    SQL.Strings = (
      
        'SELECT T.LeistungsID, L.LeistungsBezeichnung FROM Tischzuordnung' +
        ' T'
      
        'LEFT OUTER JOIN leistungen L ON T.leistungsid = L.id AND L.Firma' +
        ' = :pFirma'
      'WHERE T.TischVon <= :TischNr AND T.TischBis >= :TischNr')
    Left = 466
    Top = 182
  end
  object TableArtikel: TIBOTable
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    KeyLinks.Strings = (
      'FIRMA'
      'ARTIKELID')
    KeyLinksAutoDefine = False
    PreparedEdits = True
    PreparedInserts = True
    RecordCountAccurate = False
    TableName = 'ARTIKEL'
    Left = 37
    Top = 394
  end
  object TableOffeneTische: TIBOQuery
    Params = <
      item
        DataType = ftUnknown
        Name = 'pfirma'
        ParamType = ptInput
      end
      item
        DataType = ftUnknown
        Name = 'pOffeneTischID'
        ParamType = ptInput
      end>
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    GeneratorLinks.Strings = (
      'OFFENETISCHID = GEN_OFFENETISCHE')
    KeyLinks.Strings = (
      'FIRMA'
      'OFFENETISCHID')
    KeyLinksAutoDefine = False
    PreparedEdits = True
    PreparedInserts = True
    RecordCountAccurate = True
    SQL.Strings = (
      'Select * from OffeneTische'
      'Where'
      'firma = :pfirma and'
      'OffeneTischID = :pOffeneTischID')
    Left = 40
    Top = 190
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
  object IBOTableSprache: TIBOTable
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    PreparedEdits = True
    PreparedInserts = True
    RecordCountAccurate = True
    TableName = 'SPRACHE'
    Left = 38
    Top = 448
  end
  object TableTischgruppe: TIBOTable
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    KeyLinks.Strings = (
      'FIRMA'
      'TISCHGRUPPEID')
    KeyLinksAutoDefine = False
    PreparedEdits = True
    PreparedInserts = True
    RecordCountAccurate = True
    TableName = 'TISCHGRUPPE'
    Left = 150
    Top = 560
  end
  object TableKellner: TIBOTable
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    KeyLinks.Strings = (
      'FIRMA'
      'KELLNERID')
    KeyLinksAutoDefine = False
    PreparedEdits = True
    PreparedInserts = True
    RecordCountAccurate = True
    TableName = 'KELLNER'
    Left = 38
    Top = 560
  end
  object QueryCheckPreisebene: TIBOQuery
    Params = <
      item
        DataType = ftUnknown
        Name = 'OffeneTischID'
        ParamType = ptInput
      end>
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    PreparedEdits = True
    PreparedInserts = True
    RecordCountAccurate = True
    SQL.Strings = (
      'SELECT t.Preisebene FROM OffeneTische ot'
      'LEFT OUTER JOIN Tisch t ON ot.TischID = t.TischID'
      'WHERE OffeneTischID = :OffeneTischID')
    Left = 712
    Top = 600
  end
  object QueryDelete: TIBOQuery
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    PreparedEdits = True
    PreparedInserts = True
    RecordCountAccurate = True
    RequestLive = True
    Left = 794
    Top = 506
  end
  object QueryOffeneTische: TIBOQuery
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    PreparedEdits = True
    PreparedInserts = True
    RecordCountAccurate = True
    Left = 790
    Top = 442
  end
  object QueryGetTischZimmerNr: TIBOQuery
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    PreparedEdits = True
    PreparedInserts = True
    RecordCountAccurate = True
    Left = 792
    Top = 384
  end
  object IB_DSQLJournal: TIB_DSQL
    IB_Connection = IB_ConnectionFelix
    SQL.Strings = (
      'INSERT INTO Kassenjournal'
      '(FIRMA,DATUM,ZEIT,BETRAG,MENGE,LEISTUNGSID,'
      'RESERVID,ERFASSUNGDURCH,TEXT)'
      'VALUES'
      '(:FIRMA,:DATUM,:ZEIT,:BETRAG,:MENGE,:LEISTUNGSID,'
      ':RESERVID,:ERFASSUNGDURCH,:TEXT)'
      '')
    Left = 802
    Top = 210
  end
  object IB_Query_Insert_HilfTischkonto: TIB_Query
    SQL.Strings = (
      '  insert into hilf_tischkonto ('
      '    firma,'
      '    tischkontoid,'
      '    offenetischid,'
      '    datum,'
      '    artikelid,'
      '    menge,'
      '    betrag,'
      '    kellnerid,'
      '    kasseid,'
      '    gedruckt,'
      '    beilagenid1,'
      '    beilagenid2,'
      '    beilagenid3,'
      '    beilagentext,'
      '    status,'
      '    verbucht,'
      '    gangid)'
      '  values ('
      '    :firma,'
      '    :tischkontoid,'
      '    :offenetischid,'
      '    :datum,'
      '    :artikelid,'
      '    :menge,'
      '    :betrag,'
      '    :kellnerid,'
      '    :kasseid,'
      '    :gedruckt,'
      '    :beilagenid1,'
      '    :beilagenid2,'
      '    :beilagenid3,'
      '    :beilagentext,'
      '    :status,'
      '    :verbucht,'
      '    :gangid)')
    Left = 608
    Top = 664
  end
  object QueryInsertOffeneTische: TIBOQuery
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    PreparedEdits = True
    PreparedInserts = True
    RecordCountAccurate = True
    Left = 584
    Top = 212
  end
  object TableHotellog: TIBOTable
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    PreparedEdits = True
    PreparedInserts = True
    RecordCountAccurate = True
    TableName = 'HOTELLOG'
    Left = 150
    Top = 144
  end
  object TableGastinfo: TIBOTable
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    PreparedEdits = True
    PreparedInserts = True
    RecordCountAccurate = True
    TableName = 'GASTINFO'
    Left = 286
    Top = 496
  end
  object QuerySucheArtikel: TIB_Query
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    SQL.Strings = (
      'Select * from Tischkonto'
      'Where Firma = :Firma And'
      '            OffeneTischID = :OffeneTischID And'
      '            ArtikelID = :ArtikelID And'
      '            Betrag = :Betrag And'
      '            Datum = :Datum And'
      '            Status is Null')
    CallbackInc = -1
    PreparedInserts = False
    CommitAction = caInvalidateCursor
    Left = 416
    Top = 240
  end
  object QueryArtikel: TIB_Query
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    SQL.Strings = (
      'SELECT * FROM Artikel'
      'WHERE Firma = :pFirma AND ArtikelID = :ArtikelID'
      'and ((inaktiv is null) or (inaktiv = '#39'F'#39'))')
    CallbackInc = -1
    KeyLinks.Strings = (
      'Firma'
      'ArtikelID')
    PreparedInserts = False
    CommitAction = caInvalidateCursor
    Left = 416
    Top = 504
  end
  object QueryCheckTischOffen: TIB_Query
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    SQL.Strings = (
      'SELECT Count(*) AS Anzahl FROM TischKonto'
      'WHERE OffeneTischID = :OffeneTischID'
      'AND Firma = :Firma')
    CallbackInc = -1
    PreparedInserts = False
    CommitAction = caInvalidateCursor
    Left = 712
    Top = 236
  end
  object QueryCloseTisch: TIB_Query
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    SQL.Strings = (
      'UPDATE OffeneTische'
      'SET Offen = "F"'
      'WHERE Firma = :Firma'
      'AND OffenetischID = :OffeneTischID')
    CallbackInc = -1
    PreparedInserts = False
    CommitAction = caInvalidateCursor
    Left = 800
    Top = 272
  end
  object QueryLockTisch: TIB_Query
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    IB_Transaction = TransactionLockTable
    SQL.Strings = (
      'UPDATE OffeneTische SET OffeneTischID = OffeneTischID'
      'WHERE OffeneTischID = :OffeneTischID')
    CallbackInc = -1
    PreparedInserts = False
    CommitAction = caInvalidateCursor
    Left = 792
    Top = 20
  end
  object QueryLockTisch2: TIB_Query
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    IB_Transaction = TransactionLockTable2
    SQL.Strings = (
      'UPDATE OffeneTische SET OffeneTischID = OffeneTischID'
      'WHERE OffeneTischID = :OffeneTischID')
    CallbackInc = -1
    PreparedInserts = False
    CommitAction = caInvalidateCursor
    Left = 792
    Top = 72
  end
  object QueryGetMenuCard: TIB_Query
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    SQL.Strings = (
      'SELECT TastengruppeID, ArtikelID FROM O_MenuCard'
      'WHERE OrdermanID = :OrdermanID')
    CallbackInc = -1
    PreparedInserts = False
    CommitAction = caInvalidateCursor
    Left = 488
    Top = 392
  end
  object QueryKellner: TIB_Query
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    CallbackInc = -1
    PreparedInserts = False
    CommitAction = caInvalidateCursor
    Left = 504
    Top = 208
  end
  object QuerySelectArtikel: TIB_Query
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    SQL.Strings = (
      'Select * from Artikel'
      'Where Firma = :pFirma and ArtikelID = :pArtikelID')
    CallbackInc = -1
    KeyLinks.Strings = (
      'FIRMA'
      'ARTIKELID')
    KeyLinksAutoDefine = False
    PreparedInserts = False
    CommitAction = caInvalidateCursor
    Left = 414
    Top = 448
  end
  object TableUntergruppe: TIBOTable
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    PreparedEdits = True
    PreparedInserts = True
    RecordCountAccurate = True
    TableName = 'UNTERGRUPPE'
    Left = 32
    Top = 624
  end
  object TableHauptgruppe: TIBOTable
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    PreparedEdits = True
    PreparedInserts = True
    RecordCountAccurate = True
    TableName = 'HAUPTGRUPPE'
    Left = 144
    Top = 616
  end
  object TableKassinfo: TIBOTable
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    PreparedEdits = True
    PreparedInserts = True
    RecordCountAccurate = True
    TableName = 'KASSINFO'
    Left = 282
    Top = 546
  end
  object TableLeistung: TIBOQuery
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    PreparedEdits = True
    PreparedInserts = True
    RecordCountAccurate = True
    SQL.Strings = (
      'select * from leistungen l '
      
        'LEFT OUTER JOIN Steuer mw ON mw.Firma = l.Firma AND mw.id = l.mw' +
        'stid'
      'order by mw.mwst')
    Left = 502
    Top = 514
  end
  object TableHilf_Tischkonto: TIBOQuery
    Params = <
      item
        DataType = ftUnknown
        Name = 'pOffeneTischID'
        ParamType = ptInput
      end>
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    DeleteSQL.Strings = (
      'DELETE FROM HILF_TISCHKONTO HILF_TISCHKONTO'
      'WHERE'
      '   FIRMA = :OLD_FIRMA AND'
      '   TISCHKONTOID = :OLD_TISCHKONTOID')
    EditSQL.Strings = (
      'UPDATE HILF_TISCHKONTO HILF_TISCHKONTO SET'
      '   HILF_TISCHKONTO.FIRMA = :FIRMA, /*PK*/'
      '   HILF_TISCHKONTO.TISCHKONTOID = :TISCHKONTOID, /*PK*/'
      '   HILF_TISCHKONTO.OFFENETISCHID = :OFFENETISCHID,'
      '   HILF_TISCHKONTO.DATUM = :DATUM,'
      '   HILF_TISCHKONTO.ARTIKELID = :ARTIKELID,'
      '   HILF_TISCHKONTO.MENGE = :MENGE,'
      '   HILF_TISCHKONTO.BETRAG = :BETRAG,'
      '   HILF_TISCHKONTO.KELLNERID = :KELLNERID,'
      '   HILF_TISCHKONTO.KASSEID = :KASSEID,'
      '   HILF_TISCHKONTO.GEDRUCKT = :GEDRUCKT,'
      '   HILF_TISCHKONTO.BEILAGENID1 = :BEILAGENID1,'
      '   HILF_TISCHKONTO.BEILAGENID2 = :BEILAGENID2,'
      '   HILF_TISCHKONTO.BEILAGENID3 = :BEILAGENID3,'
      '   HILF_TISCHKONTO.BEILAGENTEXT = :BEILAGENTEXT,'
      '   HILF_TISCHKONTO.STATUS = :STATUS,'
      '   HILF_TISCHKONTO.VERBUCHT = :VERBUCHT,'
      '   HILF_TISCHKONTO.GANGID = :GANGID,'
      '   HILF_TISCHKONTO.I_DEVICEGUID = :I_DEVICEGUID'
      'WHERE'
      '   FIRMA = :OLD_FIRMA AND'
      '   TISCHKONTOID = :OLD_TISCHKONTOID')
    InsertSQL.Strings = (
      'INSERT INTO HILF_TISCHKONTO('
      '   FIRMA, /*PK*/'
      '   TISCHKONTOID, /*PK*/'
      '   OFFENETISCHID,'
      '   DATUM,'
      '   ARTIKELID,'
      '   MENGE,'
      '   BETRAG,'
      '   KELLNERID,'
      '   KASSEID,'
      '   GEDRUCKT,'
      '   BEILAGENID1,'
      '   BEILAGENID2,'
      '   BEILAGENID3,'
      '   BEILAGENTEXT,'
      '   STATUS,'
      '   VERBUCHT,'
      '   GANGID,'
      '   I_DEVICEGUID)'
      'VALUES ('
      '   :FIRMA,'
      '   :TISCHKONTOID,'
      '   :OFFENETISCHID,'
      '   :DATUM,'
      '   :ARTIKELID,'
      '   :MENGE,'
      '   :BETRAG,'
      '   :KELLNERID,'
      '   :KASSEID,'
      '   :GEDRUCKT,'
      '   :BEILAGENID1,'
      '   :BEILAGENID2,'
      '   :BEILAGENID3,'
      '   :BEILAGENTEXT,'
      '   :STATUS,'
      '   :VERBUCHT,'
      '   :GANGID,'
      '   :I_DEVICEGUID)')
    KeyLinks.Strings = (
      'FIRMA'
      'TISCHKONTOID')
    KeyLinksAutoDefine = False
    PreparedEdits = True
    PreparedInserts = True
    RecordCountAccurate = True
    SQL.Strings = (
      'Select * from Hilf_Tischkonto'
      'Where OffeneTischID = :pOffeneTischID')
    Left = 42
    Top = 498
    object TableHilf_TischkontoFirma: TSmallintField
      DisplayWidth = 10
      FieldName = 'Firma'
    end
    object TableHilf_TischkontoTischkontoID: TIntegerField
      DisplayWidth = 10
      FieldName = 'TischkontoID'
    end
    object TableHilf_TischkontoOffeneTischID: TIntegerField
      DisplayWidth = 10
      FieldName = 'OffeneTischID'
    end
    object TableHilf_TischkontoDatum: TDateField
      DisplayWidth = 10
      FieldName = 'Datum'
    end
    object TableHilf_TischkontoArtikelID: TIntegerField
      DisplayWidth = 10
      FieldName = 'ArtikelID'
    end
    object TableHilf_TischkontoMenge: TFloatField
      DisplayWidth = 10
      FieldName = 'Menge'
    end
    object TableHilf_TischkontoBetrag: TCurrencyField
      DisplayWidth = 10
      FieldName = 'Betrag'
    end
    object TableHilf_TischkontoKellnerID: TIntegerField
      DisplayWidth = 10
      FieldName = 'KellnerID'
    end
    object TableHilf_TischkontoKasseID: TIntegerField
      DisplayWidth = 10
      FieldName = 'KasseID'
    end
    object TableHilf_TischkontoGEDRUCKT: TStringField
      DisplayWidth = 1
      FieldName = 'GEDRUCKT'
      Size = 1
    end
    object TableHilf_TischkontoBeilagenID1: TIntegerField
      DisplayWidth = 10
      FieldName = 'BeilagenID1'
    end
    object TableHilf_TischkontoBeilagenID2: TIntegerField
      DisplayWidth = 10
      FieldName = 'BeilagenID2'
    end
    object TableHilf_TischkontoBeilagenID3: TIntegerField
      DisplayWidth = 10
      FieldName = 'BeilagenID3'
    end
    object TableHilf_TischkontoBeilagenText: TStringField
      DisplayWidth = 35
      FieldName = 'BeilagenText'
      Size = 35
    end
    object TableHilf_TischkontoStatus: TSmallintField
      DisplayWidth = 10
      FieldName = 'Status'
    end
    object TableHilf_TischkontoVERBUCHT: TStringField
      DisplayWidth = 1
      FieldName = 'VERBUCHT'
      Size = 1
    end
    object TableHilf_TischkontoGANGID: TIntegerField
      DisplayWidth = 10
      FieldName = 'GANGID'
    end
    object TableHilf_TischkontoI_DEVICEGUID: TStringField
      FieldName = 'I_DEVICEGUID'
      Size = 40
    end
  end
  object TableTischkonto: TIBOQuery
    Params = <
      item
        DataType = ftUnknown
        Name = 'pOffeneTischID'
        ParamType = ptInput
      end>
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    DeleteSQL.Strings = (
      'DELETE FROM TISCHKONTO TISCHKONTO'
      'WHERE'
      '   FIRMA = :OLD_FIRMA AND'
      '   TISCHKONTOID = :OLD_TISCHKONTOID')
    EditSQL.Strings = (
      'UPDATE TISCHKONTO TISCHKONTO SET'
      '   TISCHKONTO.FIRMA = :FIRMA, /*PK*/'
      '   TISCHKONTO.TISCHKONTOID = :TISCHKONTOID, /*PK*/'
      '   TISCHKONTO.OFFENETISCHID = :OFFENETISCHID,'
      '   TISCHKONTO.DATUM = :DATUM,'
      '   TISCHKONTO.ARTIKELID = :ARTIKELID,'
      '   TISCHKONTO.MENGE = :MENGE,'
      '   TISCHKONTO.BETRAG = :BETRAG,'
      '   TISCHKONTO.KELLNERID = :KELLNERID,'
      '   TISCHKONTO.KASSEID = :KASSEID,'
      '   TISCHKONTO.GEDRUCKT = :GEDRUCKT,'
      '   TISCHKONTO.BEILAGENID1 = :BEILAGENID1,'
      '   TISCHKONTO.BEILAGENID2 = :BEILAGENID2,'
      '   TISCHKONTO.BEILAGENID3 = :BEILAGENID3,'
      '   TISCHKONTO.BEILAGENTEXT = :BEILAGENTEXT,'
      '   TISCHKONTO.STATUS = :STATUS,'
      '   TISCHKONTO.VERBUCHT = :VERBUCHT,'
      '   TISCHKONTO.GANGID = :GANGID,'
      '   TISCHKONTO.I_DEVICEGUID = :I_DEVICEGUID'
      'WHERE'
      '   FIRMA = :OLD_FIRMA AND'
      '   TISCHKONTOID = :OLD_TISCHKONTOID')
    GeneratorLinks.Strings = (
      'TISCHKONTOID = GEN_TISCHKONTO')
    InsertSQL.Strings = (
      'INSERT INTO TISCHKONTO('
      '   FIRMA,'
      '   TISCHKONTOID,'
      '   OFFENETISCHID,'
      '   DATUM,'
      '   ARTIKELID,'
      '   MENGE,'
      '   BETRAG,'
      '   KELLNERID,'
      '   KASSEID,'
      '   GEDRUCKT,'
      '   BEILAGENID1,'
      '   BEILAGENID2,'
      '   BEILAGENID3,'
      '   BEILAGENTEXT,'
      '   STATUS,'
      '   VERBUCHT,'
      '   GANGID,'
      '   I_DEVICEGUID)'
      'VALUES ('
      '   :FIRMA,'
      '   :TISCHKONTOID,'
      '   :OFFENETISCHID,'
      '   :DATUM,'
      '   :ARTIKELID,'
      '   :MENGE,'
      '   :BETRAG,'
      '   :KELLNERID,'
      '   :KASSEID,'
      '   :GEDRUCKT,'
      '   :BEILAGENID1,'
      '   :BEILAGENID2,'
      '   :BEILAGENID3,'
      '   :BEILAGENTEXT,'
      '   :STATUS,'
      '   :VERBUCHT,'
      '   :GANGID,'
      '   :I_DEVICEGUID)')
    KeyLinks.Strings = (
      'FIRMA'
      'TISCHKONTOID')
    KeyLinksAutoDefine = False
    PreparedEdits = True
    PreparedInserts = True
    RecordCountAccurate = True
    SQL.Strings = (
      'SELECT * FROM Tischkonto '
      'WHERE OffeneTischID = :pOffeneTischID'
      'ORDER BY Tischkonto.TischkontoID')
    Left = 40
    Top = 138
  end
  object IB_QueryArtikelPreise: TIB_Query
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    SQL.Strings = (
      'Select * from ArtikelPreise'
      'Where Firma = :pFirma '
      '            and ArtikelID = :pArtikelID'
      '            and BeilagenID = :pBeilagenID'
      '')
    CallbackInc = -1
    KeyLinks.Strings = (
      'FIRMA'
      'ARTIKELID')
    KeyLinksAutoDefine = False
    PreparedInserts = False
    CommitAction = caInvalidateCursor
    Left = 286
    Top = 632
  end
  object IB_QueryUpdateMenge: TIB_Query
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    SQL.Strings = (
      'Update Tischkonto'
      'Set menge = :pMenge'
      'Where TischkontoID = :pTKID')
    CallbackInc = -1
    PreparedInserts = False
    CommitAction = caInvalidateCursor
    Left = 712
    Top = 656
  end
  object IB_QueryGetZaehler: TIB_Query
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    SQL.Strings = (
      'SELECT Zaehler FROM Artikel'
      'WHERE Firma = 1 AND ArtikelID = :ArtikelID')
    CallbackInc = -1
    PreparedInserts = False
    ReadOnly = True
    CommitAction = caInvalidateCursor
    Left = 912
    Top = 232
  end
  object QueryRoomDiscount: TIBOQuery
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    PreparedEdits = True
    PreparedInserts = True
    RecordCountAccurate = True
    SQL.Strings = (
      'SELECT * FROM Hilf_Tischkonto')
    Left = 920
    Top = 294
  end
  object QueryGetHaupgruppeVorSum: TIBOQuery
    Params = <
      item
        DataType = ftInteger
        Name = 'ArtikelID'
        ParamType = ptInput
      end>
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    PreparedEdits = True
    PreparedInserts = True
    RecordCountAccurate = True
    SQL.Strings = (
      'select h.vorsum'
      'from Artikel a'
      
        'left outer JOIN Untergruppe u ON u.firma = a.firma and u.untergr' +
        'uppeid = a.untergruppeid'
      
        'left outer join hauptgruppe h ON h.firma = u.firma and h.hauptgr' +
        'uppeid = u.hauptgruppeid'
      'WHERE a.firma = 1 and a.artikelid = :ArtikelID')
    Left = 912
    Top = 364
  end
  object IBOQueryGetRabatt: TIBOQuery
    Params = <
      item
        DataType = ftUnknown
        Name = 'pPers_Nr'
        ParamType = ptInput
      end>
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    PreparedEdits = True
    PreparedInserts = True
    RecordCountAccurate = True
    SQL.Strings = (
      'SELECT RT FROM GastInfo'
      'Where Pers_Nr = :pPers_Nr')
    Left = 912
    Top = 438
  end
  object QueryJournalControl: TIBOQuery
    Params = <
      item
        DataType = ftInteger
        Name = 'Firma'
        ParamType = ptInput
      end
      item
        DataType = ftInteger
        Name = 'KellnerID'
        ParamType = ptInput
      end
      item
        DataType = ftInteger
        Name = 'OffeneTischID'
        ParamType = ptInput
      end
      item
        DataType = ftDate
        Name = 'Datum'
        ParamType = ptInput
      end
      item
        DataType = ftDateTime
        Name = 'Zeit'
        ParamType = ptInput
      end
      item
        DataType = ftInteger
        Name = 'KasseID'
        ParamType = ptInput
      end
      item
        DataType = ftInteger
        Name = 'JournalTyp'
        ParamType = ptInput
      end
      item
        DataType = ftString
        Name = 'Text'
        ParamType = ptInput
      end
      item
        DataType = ftFloat
        Name = 'Menge'
        ParamType = ptInput
      end
      item
        DataType = ftInteger
        Name = 'ZahlwegID'
        ParamType = ptInput
      end
      item
        DataType = ftFloat
        Name = 'Betrag'
        ParamType = ptInput
      end
      item
        DataType = ftInteger
        Name = 'ArtikelID'
        ParamType = ptInput
      end
      item
        DataType = ftInteger
        Name = 'BeilagenID'
        ParamType = ptInput
      end
      item
        DataType = ftInteger
        Name = 'VonOffeneTischID'
        ParamType = ptInput
      end
      item
        DataType = ftInteger
        Name = 'RechnungsID'
        ParamType = ptInput
      end
      item
        DataType = ftFloat
        Name = 'Nachlass'
        ParamType = ptInput
      end
      item
        DataType = ftString
        Name = 'LagerVerbucht'
        ParamType = ptInput
      end
      item
        DataType = ftDate
        Name = 'LagerDatum'
        ParamType = ptInput
      end>
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    PreparedEdits = True
    PreparedInserts = True
    RecordCountAccurate = True
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
    Left = 912
    Top = 496
  end
  object IB_ConnectionFelix: TIB_Connection
    CacheStatementHandles = False
    PasswordStorage = psNotSecure
    SQLDialect = 3
    Params.Strings = (
      'USER NAME=SYSDBA'
      'PATH=C:\fx-2000\Data\felix_hotel.gdb')
    Left = 40
    Top = 16
    SavedPassword = '.JuMbLe.01.56'
  end
  object IB_Transaction2: TIB_Transaction
    AutoCommit = True
    Isolation = tiCommitted
    Left = 132
    Top = 16
  end
  object QueryCheckZimmerIB: TIBOQuery
    PreparedEdits = True
    PreparedInserts = True
    RecordCountAccurate = True
    Left = 908
    Top = 566
  end
  object IBOQueryTischkonto: TIBOQuery
    Params = <
      item
        DataType = ftUnknown
        Name = 'pOffeneTischID'
        ParamType = ptInput
      end>
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    DeleteSQL.Strings = (
      'DELETE FROM TISCHKONTO TISCHKONTO'
      'WHERE'
      '   FIRMA = :OLD_FIRMA AND'
      '   TISCHKONTOID = :OLD_TISCHKONTOID')
    EditSQL.Strings = (
      'UPDATE TISCHKONTO TISCHKONTO SET'
      '   TISCHKONTO.FIRMA = :FIRMA, /*PK*/'
      '   TISCHKONTO.TISCHKONTOID = :TISCHKONTOID, /*PK*/'
      '   TISCHKONTO.OFFENETISCHID = :OFFENETISCHID,'
      '   TISCHKONTO.DATUM = :DATUM,'
      '   TISCHKONTO.ARTIKELID = :ARTIKELID,'
      '   TISCHKONTO.MENGE = :MENGE,'
      '   TISCHKONTO.BETRAG = :BETRAG,'
      '   TISCHKONTO.KELLNERID = :KELLNERID,'
      '   TISCHKONTO.KASSEID = :KASSEID,'
      '   TISCHKONTO.GEDRUCKT = :GEDRUCKT,'
      '   TISCHKONTO.BEILAGENID1 = :BEILAGENID1,'
      '   TISCHKONTO.BEILAGENID2 = :BEILAGENID2,'
      '   TISCHKONTO.BEILAGENID3 = :BEILAGENID3,'
      '   TISCHKONTO.BEILAGENTEXT = :BEILAGENTEXT,'
      '   TISCHKONTO.STATUS = :STATUS,'
      '   TISCHKONTO.VERBUCHT = :VERBUCHT,'
      '   TISCHKONTO.GANGID = :GANGID,'
      '   TISCHKONTO.I_DEVICEGUID = :I_DEVICEGUID'
      'WHERE'
      '   FIRMA = :OLD_FIRMA AND'
      '   TISCHKONTOID = :OLD_TISCHKONTOID')
    GeneratorLinks.Strings = (
      'TISCHKONTOID = GEN_TISCHKONTO')
    InsertSQL.Strings = (
      'INSERT INTO TISCHKONTO('
      '   FIRMA,'
      '   TISCHKONTOID,'
      '   OFFENETISCHID,'
      '   DATUM,'
      '   ARTIKELID,'
      '   MENGE,'
      '   BETRAG,'
      '   KELLNERID,'
      '   KASSEID,'
      '   GEDRUCKT,'
      '   BEILAGENID1,'
      '   BEILAGENID2,'
      '   BEILAGENID3,'
      '   BEILAGENTEXT,'
      '   STATUS,'
      '   VERBUCHT,'
      '   GANGID,'
      '   I_DEVICEGUID)'
      'VALUES ('
      '   :FIRMA,'
      '   :TISCHKONTOID,'
      '   :OFFENETISCHID,'
      '   :DATUM,'
      '   :ARTIKELID,'
      '   :MENGE,'
      '   :BETRAG,'
      '   :KELLNERID,'
      '   :KASSEID,'
      '   :GEDRUCKT,'
      '   :BEILAGENID1,'
      '   :BEILAGENID2,'
      '   :BEILAGENID3,'
      '   :BEILAGENTEXT,'
      '   :STATUS,'
      '   :VERBUCHT,'
      '   :GANGID,'
      '   :I_DEVICEGUID)')
    KeyLinks.Strings = (
      'FIRMA'
      'TISCHKONTOID')
    KeyLinksAutoDefine = False
    PreparedEdits = True
    PreparedInserts = True
    RecordCountAccurate = True
    SQL.Strings = (
      'SELECT Tischkonto.*, artikel.Bezeichnung AS LookArtikel'
      'FROM Tischkonto '
      
        'LEFT OUTER JOIN Artikel ON artikel.Firma = Tischkonto.Firma AND ' +
        'Artikel.ArtikelID = Tischkonto.ArtikelID'
      'WHERE OffeneTischID = :pOffeneTischID'
      'ORDER BY Tischkonto.TischkontoID')
    Left = 40
    Top = 82
  end
  object QueryUsers: TIBOQuery
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    PreparedEdits = True
    PreparedInserts = True
    RecordCountAccurate = True
    SQL.Strings = (
      'SELECT * FROM KELLNER')
    Left = 416
    Top = 720
  end
  object QueryTische: TIBOQuery
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    PreparedEdits = True
    PreparedInserts = True
    RecordCountAccurate = True
    Left = 896
    Top = 632
  end
  object QueryUpdateTischKonto: TIBOQuery
    Params = <
      item
        DataType = ftUnknown
        Name = 'pMenge'
        ParamType = ptInput
      end
      item
        DataType = ftUnknown
        Name = 'pFirma'
        ParamType = ptInput
      end
      item
        DataType = ftUnknown
        Name = 'pTischKontoId'
        ParamType = ptInput
      end>
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    PreparedEdits = True
    PreparedInserts = True
    RecordCountAccurate = True
    SQL.Strings = (
      'update TischKonto'
      'set Menge = :pMenge'
      'where'
      'Firma = :pFirma and'
      'TischKontoId = :pTischKontoId')
    Left = 616
    Top = 8
  end
  object QueryDeleteTischKonto: TIBOQuery
    Params = <
      item
        DataType = ftUnknown
        Name = 'pFirma'
        ParamType = ptInput
      end
      item
        DataType = ftUnknown
        Name = 'pTischKontoID'
        ParamType = ptInput
      end>
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    PreparedEdits = True
    PreparedInserts = True
    RecordCountAccurate = True
    SQL.Strings = (
      'delete '
      'from TischKonto'
      'where'
      'firma = :pFirma and'
      'TischKontoID = :pTischKontoID')
    Left = 504
    Top = 8
  end
  object CDSHilfKonto: TClientDataSet
    Aggregates = <
      item
        Active = True
        AggregateName = 'Summe'
        Expression = 'SUM(Menge*Betrag)'
        Visible = False
      end
      item
        AggregateName = 'Firma'
        Visible = False
      end
      item
        AggregateName = 'OffeneTischID'
        Visible = False
      end
      item
        AggregateName = 'ArtikelID'
        Visible = False
      end
      item
        AggregateName = 'Betrag'
        Visible = False
      end>
    AggregatesActive = True
    Filter = '((Menge <> 0) or (Menge is null))'
    FieldDefs = <
      item
        Name = 'TischkontoID'
        DataType = ftInteger
      end
      item
        Name = 'Firma'
        DataType = ftSmallint
      end
      item
        Name = 'OffeneTischID'
        DataType = ftInteger
      end
      item
        Name = 'Datum'
        DataType = ftDate
      end
      item
        Name = 'ArtikelID'
        DataType = ftInteger
      end
      item
        Name = 'Menge'
        DataType = ftFloat
      end
      item
        Name = 'LookArtikel'
        DataType = ftString
        Size = 25
      end
      item
        Name = 'Betrag'
        DataType = ftFloat
      end
      item
        Name = 'KellnerID'
        DataType = ftInteger
      end
      item
        Name = 'KasseID'
        DataType = ftInteger
      end
      item
        Name = 'Gedruckt'
        DataType = ftString
        Size = 1
      end
      item
        Name = 'Verbucht'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'Status'
        DataType = ftSmallint
      end
      item
        Name = 'GangID'
        DataType = ftInteger
      end
      item
        Name = 'Zaehler'
        DataType = ftInteger
      end
      item
        Name = 'Beilagenabfrage'
        DataType = ftString
        Size = 1
      end
      item
        Name = 'BeilagenID1'
        DataType = ftInteger
      end
      item
        Name = 'BeilagenID2'
        DataType = ftInteger
      end
      item
        Name = 'BeilagenID3'
        DataType = ftInteger
      end
      item
        Name = 'BeilagenText'
        DataType = ftString
        Size = 35
      end
      item
        Name = 'I_DeviceGuid'
        DataType = ftString
        Size = 40
      end>
    IndexDefs = <
      item
        Name = 'CDSKontoIndex1'
        Fields = 'Firma;TischkontoID'
        Options = [ixPrimary]
      end>
    IndexName = 'CDSKontoIndex1'
    Params = <>
    StoreDefs = True
    Left = 288
    Top = 64
  end
  object QueryTableAccount: TIBOQuery
    Params = <
      item
        DataType = ftUnknown
        Name = 'pfirma'
        ParamType = ptInput
      end
      item
        DataType = ftUnknown
        Name = 'poffenetischid'
        ParamType = ptInput
      end>
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    DeleteSQL.Strings = (
      'DELETE FROM TISCHKONTO TISCHKONTO'
      'WHERE'
      '   FIRMA = :OLD_FIRMA AND'
      '   TISCHKONTOID = :OLD_TISCHKONTOID')
    EditSQL.Strings = (
      'UPDATE TISCHKONTO TISCHKONTO SET'
      '   TISCHKONTO.FIRMA = :FIRMA, /*PK*/'
      '   TISCHKONTO.TISCHKONTOID = :TISCHKONTOID, /*PK*/'
      '   TISCHKONTO.OFFENETISCHID = :OFFENETISCHID,'
      '   TISCHKONTO.DATUM = :DATUM,'
      '   TISCHKONTO.ARTIKELID = :ARTIKELID,'
      '   TISCHKONTO.MENGE = :MENGE,'
      '   TISCHKONTO.BETRAG = :BETRAG,'
      '   TISCHKONTO.KELLNERID = :KELLNERID,'
      '   TISCHKONTO.KASSEID = :KASSEID,'
      '   TISCHKONTO.GEDRUCKT = :GEDRUCKT,'
      '   TISCHKONTO.BEILAGENID1 = :BEILAGENID1,'
      '   TISCHKONTO.BEILAGENID2 = :BEILAGENID2,'
      '   TISCHKONTO.BEILAGENID3 = :BEILAGENID3,'
      '   TISCHKONTO.BEILAGENTEXT = :BEILAGENTEXT,'
      '   TISCHKONTO.STATUS = :STATUS,'
      '   TISCHKONTO.VERBUCHT = :VERBUCHT,'
      '   TISCHKONTO.GANGID = :GANGID,'
      '   TISCHKONTO.I_DEVICEGUID = :I_DEVICEGUID'
      'WHERE'
      '   FIRMA = :OLD_FIRMA AND'
      '   TISCHKONTOID = :OLD_TISCHKONTOID')
    InsertSQL.Strings = (
      'INSERT INTO TISCHKONTO('
      '   FIRMA, /*PK*/'
      '   TISCHKONTOID, /*PK*/'
      '   OFFENETISCHID,'
      '   DATUM,'
      '   ARTIKELID,'
      '   MENGE,'
      '   BETRAG,'
      '   KELLNERID,'
      '   KASSEID,'
      '   GEDRUCKT,'
      '   BEILAGENID1,'
      '   BEILAGENID2,'
      '   BEILAGENID3,'
      '   BEILAGENTEXT,'
      '   STATUS,'
      '   VERBUCHT,'
      '   GANGID,'
      '   I_DEVICEGUID)'
      'VALUES ('
      '   :FIRMA,'
      '   :TISCHKONTOID,'
      '   :OFFENETISCHID,'
      '   :DATUM,'
      '   :ARTIKELID,'
      '   :MENGE,'
      '   :BETRAG,'
      '   :KELLNERID,'
      '   :KASSEID,'
      '   :GEDRUCKT,'
      '   :BEILAGENID1,'
      '   :BEILAGENID2,'
      '   :BEILAGENID3,'
      '   :BEILAGENTEXT,'
      '   :STATUS,'
      '   :VERBUCHT,'
      '   :GANGID,'
      '   :I_DEVICEGUID)')
    KeyLinks.Strings = (
      'Firma'
      'TischKontoId')
    PreparedEdits = True
    PreparedInserts = True
    RecordCountAccurate = True
    SQL.Strings = (
      'select * from'
      'Tischkonto'
      'where'
      'firma = :pfirma and'
      'offenetischid = :poffenetischid'
      'order by'
      'Firma, TischKontoID')
    Left = 1144
    Top = 8
  end
  object TransactionProcessingTable: TIB_Transaction
    IB_Connection = ConnectionKasseProcessingTable
    Isolation = tiCommitted
    Left = 600
    Top = 120
  end
  object QueryTableAccount2: TIBOQuery
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    DeleteSQL.Strings = (
      'DELETE FROM TISCHKONTO TISCHKONTO'
      'WHERE'
      '   FIRMA = :OLD_FIRMA AND'
      '   TISCHKONTOID = :OLD_TISCHKONTOID')
    EditSQL.Strings = (
      'UPDATE TISCHKONTO TISCHKONTO SET'
      '   TISCHKONTO.FIRMA = :FIRMA, /*PK*/'
      '   TISCHKONTO.TISCHKONTOID = :TISCHKONTOID, /*PK*/'
      '   TISCHKONTO.OFFENETISCHID = :OFFENETISCHID,'
      '   TISCHKONTO.DATUM = :DATUM,'
      '   TISCHKONTO.ARTIKELID = :ARTIKELID,'
      '   TISCHKONTO.MENGE = :MENGE,'
      '   TISCHKONTO.BETRAG = :BETRAG,'
      '   TISCHKONTO.KELLNERID = :KELLNERID,'
      '   TISCHKONTO.KASSEID = :KASSEID,'
      '   TISCHKONTO.GEDRUCKT = :GEDRUCKT,'
      '   TISCHKONTO.BEILAGENID1 = :BEILAGENID1,'
      '   TISCHKONTO.BEILAGENID2 = :BEILAGENID2,'
      '   TISCHKONTO.BEILAGENID3 = :BEILAGENID3,'
      '   TISCHKONTO.BEILAGENTEXT = :BEILAGENTEXT,'
      '   TISCHKONTO.STATUS = :STATUS,'
      '   TISCHKONTO.VERBUCHT = :VERBUCHT,'
      '   TISCHKONTO.GANGID = :GANGID,'
      '   TISCHKONTO.I_DEVICEGUID = :I_DEVICEGUID'
      'WHERE'
      '   FIRMA = :OLD_FIRMA AND'
      '   TISCHKONTOID = :OLD_TISCHKONTOID')
    InsertSQL.Strings = (
      'INSERT INTO TISCHKONTO('
      '   FIRMA, /*PK*/'
      '   OFFENETISCHID,'
      '   DATUM,'
      '   ARTIKELID,'
      '   MENGE,'
      '   BETRAG,'
      '   KELLNERID,'
      '   KASSEID,'
      '   GEDRUCKT,'
      '   BEILAGENID1,'
      '   BEILAGENID2,'
      '   BEILAGENID3,'
      '   BEILAGENTEXT,'
      '   STATUS,'
      '   VERBUCHT,'
      '   GANGID,'
      '   I_DEVICEGUID)'
      'VALUES ('
      '   :FIRMA,'
      '   :OFFENETISCHID,'
      '   :DATUM,'
      '   :ARTIKELID,'
      '   :MENGE,'
      '   :BETRAG,'
      '   :KELLNERID,'
      '   :KASSEID,'
      '   :GEDRUCKT,'
      '   :BEILAGENID1,'
      '   :BEILAGENID2,'
      '   :BEILAGENID3,'
      '   :BEILAGENTEXT,'
      '   :STATUS,'
      '   :VERBUCHT,'
      '   :GANGID,'
      '   :I_DEVICEGUID)')
    KeyLinks.Strings = (
      'Firma'
      'TischKontoId')
    PreparedEdits = True
    PreparedInserts = True
    RecordCountAccurate = True
    SQL.Strings = (
      'select * from'
      'Tischkonto'
      'order by'
      'Firma, TischKontoID')
    Left = 1168
    Top = 152
  end
  object QueryGetTableAccount: TIBOQuery
    Params = <
      item
        DataType = ftUnknown
        Name = 'pFirma'
        ParamType = ptInput
      end
      item
        DataType = ftUnknown
        Name = 'pOffeneTischID'
        ParamType = ptInput
      end>
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    DeleteSQL.Strings = (
      'DELETE FROM TISCHKONTO TISCHKONTO'
      'WHERE'
      '   FIRMA = :OLD_FIRMA AND'
      '   TISCHKONTOID = :OLD_TISCHKONTOID')
    EditSQL.Strings = (
      'UPDATE TISCHKONTO TISCHKONTO SET'
      '   TISCHKONTO.FIRMA = :FIRMA, /*PK*/'
      '   TISCHKONTO.TISCHKONTOID = :TISCHKONTOID, /*PK*/'
      '   TISCHKONTO.OFFENETISCHID = :OFFENETISCHID,'
      '   TISCHKONTO.DATUM = :DATUM,'
      '   TISCHKONTO.ARTIKELID = :ARTIKELID,'
      '   TISCHKONTO.MENGE = :MENGE,'
      '   TISCHKONTO.BETRAG = :BETRAG,'
      '   TISCHKONTO.KELLNERID = :KELLNERID,'
      '   TISCHKONTO.KASSEID = :KASSEID,'
      '   TISCHKONTO.GEDRUCKT = :GEDRUCKT,'
      '   TISCHKONTO.BEILAGENID1 = :BEILAGENID1,'
      '   TISCHKONTO.BEILAGENID2 = :BEILAGENID2,'
      '   TISCHKONTO.BEILAGENID3 = :BEILAGENID3,'
      '   TISCHKONTO.BEILAGENTEXT = :BEILAGENTEXT,'
      '   TISCHKONTO.STATUS = :STATUS,'
      '   TISCHKONTO.VERBUCHT = :VERBUCHT,'
      '   TISCHKONTO.GANGID = :GANGID,'
      '   TISCHKONTO.I_DEVICEGUID = :I_DEVICEGUID'
      'WHERE'
      '   FIRMA = :OLD_FIRMA AND'
      '   TISCHKONTOID = :OLD_TISCHKONTOID')
    InsertSQL.Strings = (
      'INSERT INTO TISCHKONTO('
      '   FIRMA, /*PK*/'
      '   TISCHKONTOID, /*PK*/'
      '   OFFENETISCHID,'
      '   DATUM,'
      '   ARTIKELID,'
      '   MENGE,'
      '   BETRAG,'
      '   KELLNERID,'
      '   KASSEID,'
      '   GEDRUCKT,'
      '   BEILAGENID1,'
      '   BEILAGENID2,'
      '   BEILAGENID3,'
      '   BEILAGENTEXT,'
      '   STATUS,'
      '   VERBUCHT,'
      '   GANGID,'
      '   I_DEVICEGUID)'
      'VALUES ('
      '   :FIRMA,'
      '   :TISCHKONTOID,'
      '   :OFFENETISCHID,'
      '   :DATUM,'
      '   :ARTIKELID,'
      '   :MENGE,'
      '   :BETRAG,'
      '   :KELLNERID,'
      '   :KASSEID,'
      '   :GEDRUCKT,'
      '   :BEILAGENID1,'
      '   :BEILAGENID2,'
      '   :BEILAGENID3,'
      '   :BEILAGENTEXT,'
      '   :STATUS,'
      '   :VERBUCHT,'
      '   :GANGID,'
      '   :I_DEVICEGUID)')
    KeyLinks.Strings = (
      'Firma'
      'TischKontoId')
    PreparedEdits = True
    PreparedInserts = True
    RecordCountAccurate = True
    SQL.Strings = (
      
        'SELECT t.TischkontoID, t.OffeneTischID, t.Firma, t.Gedruckt, t.K' +
        'ellnerID,'
      't.KasseID, t.Datum, t.ArtikelID, t.Menge, t.Betrag,'
      '(case when t.artikelid is not null then'
      'a.bezeichnung'
      'else'
      '(case when b1.beilagenid = -1 then TRIM(t.Beilagentext)'
      'else'
      
        '((case when b1.bezeichnung is not null then TRIM(b1.bezeichnung)' +
        ' else '#39#39' end) || '#39' '#39' ||'
      
        '(case when b2.bezeichnung is not null then TRIM(b2.bezeichnung) ' +
        'else '#39#39' end) || '#39' '#39' ||'
      
        '(case when b3.bezeichnung is not null then TRIM(b3.bezeichnung) ' +
        'else '#39#39' end))'
      'END)'
      'END) as LookArtikel,'
      
        't.BeilagenID1, t.BeilagenID2, t.BeilagenID3, t.BeilagenText, t.S' +
        'tatus, t.Verbucht, t.GangID, t.I_DeviceGuid'
      'FROM tischkonto t'
      
        'LEFT OUTER JOIN Artikel a ON a.Firma = t.Firma AND a.ArtikelID =' +
        ' t.ArtikelID'
      
        'LEFT OUTER JOIN Beilagen b1 ON b1.Firma = t.Firma AND b1.beilage' +
        'nid = t.beilagenid1'
      
        'LEFT OUTER JOIN Beilagen b2 ON b2.Firma = t.Firma AND b2.beilage' +
        'nid = t.beilagenid2'
      
        'LEFT OUTER JOIN Beilagen b3 ON b3.Firma = t.Firma AND b3.beilage' +
        'nid = t.beilagenid3'
      'WHERE'
      't.firma = :pFirma and'
      't.offenetischid = :pOffeneTischID'
      'ORDER BY'
      't.TischkontoID')
    Left = 1032
    Top = 8
  end
  object QueryHelpTableAccount: TIBOQuery
    Params = <
      item
        DataType = ftUnknown
        Name = 'pfirma'
        ParamType = ptInput
      end
      item
        DataType = ftUnknown
        Name = 'poffenetischid'
        ParamType = ptInput
      end>
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    DeleteSQL.Strings = (
      'DELETE FROM HILF_TISCHKONTO HILF_TISCHKONTO'
      'WHERE'
      '   FIRMA = :OLD_FIRMA AND'
      '   TISCHKONTOID = :OLD_TISCHKONTOID')
    EditSQL.Strings = (
      'UPDATE HILF_TISCHKONTO HILF_TISCHKONTO SET'
      '   HILF_TISCHKONTO.FIRMA = :FIRMA, /*PK*/'
      '   HILF_TISCHKONTO.TISCHKONTOID = :TISCHKONTOID, /*PK*/'
      '   HILF_TISCHKONTO.OFFENETISCHID = :OFFENETISCHID,'
      '   HILF_TISCHKONTO.DATUM = :DATUM,'
      '   HILF_TISCHKONTO.ARTIKELID = :ARTIKELID,'
      '   HILF_TISCHKONTO.MENGE = :MENGE,'
      '   HILF_TISCHKONTO.BETRAG = :BETRAG,'
      '   HILF_TISCHKONTO.KELLNERID = :KELLNERID,'
      '   HILF_TISCHKONTO.KASSEID = :KASSEID,'
      '   HILF_TISCHKONTO.GEDRUCKT = :GEDRUCKT,'
      '   HILF_TISCHKONTO.BEILAGENID1 = :BEILAGENID1,'
      '   HILF_TISCHKONTO.BEILAGENID2 = :BEILAGENID2,'
      '   HILF_TISCHKONTO.BEILAGENID3 = :BEILAGENID3,'
      '   HILF_TISCHKONTO.BEILAGENTEXT = :BEILAGENTEXT,'
      '   HILF_TISCHKONTO.STATUS = :STATUS,'
      '   HILF_TISCHKONTO.VERBUCHT = :VERBUCHT,'
      '   HILF_TISCHKONTO.GANGID = :GANGID,'
      '   HILF_TISCHKONTO.I_DEVICEGUID = :I_DEVICEGUID'
      'WHERE'
      '   FIRMA = :OLD_FIRMA AND'
      '   TISCHKONTOID = :OLD_TISCHKONTOID')
    InsertSQL.Strings = (
      'INSERT INTO HILF_TISCHKONTO('
      '   FIRMA, /*PK*/'
      '   TISCHKONTOID, /*PK*/'
      '   OFFENETISCHID,'
      '   DATUM,'
      '   ARTIKELID,'
      '   MENGE,'
      '   BETRAG,'
      '   KELLNERID,'
      '   KASSEID,'
      '   GEDRUCKT,'
      '   BEILAGENID1,'
      '   BEILAGENID2,'
      '   BEILAGENID3,'
      '   BEILAGENTEXT,'
      '   STATUS,'
      '   VERBUCHT,'
      '   GANGID,'
      '   I_DEVICEGUID)'
      'VALUES ('
      '   :FIRMA,'
      '   :TISCHKONTOID,'
      '   :OFFENETISCHID,'
      '   :DATUM,'
      '   :ARTIKELID,'
      '   :MENGE,'
      '   :BETRAG,'
      '   :KELLNERID,'
      '   :KASSEID,'
      '   :GEDRUCKT,'
      '   :BEILAGENID1,'
      '   :BEILAGENID2,'
      '   :BEILAGENID3,'
      '   :BEILAGENTEXT,'
      '   :STATUS,'
      '   :VERBUCHT,'
      '   :GANGID,'
      '   :I_DEVICEGUID)')
    KeyLinks.Strings = (
      'Firma'
      'TischKontoId')
    PreparedEdits = True
    PreparedInserts = True
    RecordCountAccurate = True
    SQL.Strings = (
      'select * from'
      'Hilf_Tischkonto'
      'where'
      'firma = :pfirma and'
      'offenetischid = :poffenetischid'
      'order by'
      'Firma, TischKontoID')
    Left = 1152
    Top = 72
  end
  object ConnectionKasseProcessingTable: TIB_Connection
    CacheStatementHandles = False
    DefaultTransaction = TransactionProcessingTable
    PasswordStorage = psNotSecure
    SQLDialect = 3
    Params.Strings = (
      'USER NAME=SYSDBA'
      'PATH=C:\fx-2000\Data\felix_hotel.gdb')
    Left = 600
    Top = 64
    SavedPassword = '.JuMbLe.01.56'
  end
  object TransactionLockTable: TIB_Transaction
    Isolation = tiCommitted
    Left = 464
    Top = 64
  end
  object TransactionLockTable2: TIB_Transaction
    Isolation = tiCommitted
    Left = 464
    Top = 120
  end
  object QueryGetHelpTableAccount: TIBOQuery
    Params = <
      item
        DataType = ftUnknown
        Name = 'pFirma'
        ParamType = ptInput
      end
      item
        DataType = ftUnknown
        Name = 'pOffeneTischID'
        ParamType = ptInput
      end>
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    DeleteSQL.Strings = (
      'DELETE FROM TISCHKONTO TISCHKONTO'
      'WHERE'
      '   FIRMA = :OLD_FIRMA AND'
      '   TISCHKONTOID = :OLD_TISCHKONTOID')
    EditSQL.Strings = (
      'UPDATE TISCHKONTO TISCHKONTO SET'
      '   TISCHKONTO.FIRMA = :FIRMA, /*PK*/'
      '   TISCHKONTO.TISCHKONTOID = :TISCHKONTOID, /*PK*/'
      '   TISCHKONTO.OFFENETISCHID = :OFFENETISCHID,'
      '   TISCHKONTO.DATUM = :DATUM,'
      '   TISCHKONTO.ARTIKELID = :ARTIKELID,'
      '   TISCHKONTO.MENGE = :MENGE,'
      '   TISCHKONTO.BETRAG = :BETRAG,'
      '   TISCHKONTO.KELLNERID = :KELLNERID,'
      '   TISCHKONTO.KASSEID = :KASSEID,'
      '   TISCHKONTO.GEDRUCKT = :GEDRUCKT,'
      '   TISCHKONTO.BEILAGENID1 = :BEILAGENID1,'
      '   TISCHKONTO.BEILAGENID2 = :BEILAGENID2,'
      '   TISCHKONTO.BEILAGENID3 = :BEILAGENID3,'
      '   TISCHKONTO.BEILAGENTEXT = :BEILAGENTEXT,'
      '   TISCHKONTO.STATUS = :STATUS,'
      '   TISCHKONTO.VERBUCHT = :VERBUCHT,'
      '   TISCHKONTO.GANGID = :GANGID,'
      '   TISCHKONTO.I_DEVICEGUID = :I_DEVICEGUID'
      'WHERE'
      '   FIRMA = :OLD_FIRMA AND'
      '   TISCHKONTOID = :OLD_TISCHKONTOID')
    InsertSQL.Strings = (
      'INSERT INTO TISCHKONTO('
      '   FIRMA, /*PK*/'
      '   TISCHKONTOID, /*PK*/'
      '   OFFENETISCHID,'
      '   DATUM,'
      '   ARTIKELID,'
      '   MENGE,'
      '   BETRAG,'
      '   KELLNERID,'
      '   KASSEID,'
      '   GEDRUCKT,'
      '   BEILAGENID1,'
      '   BEILAGENID2,'
      '   BEILAGENID3,'
      '   BEILAGENTEXT,'
      '   STATUS,'
      '   VERBUCHT,'
      '   GANGID,'
      '   I_DEVICEGUID)'
      'VALUES ('
      '   :FIRMA,'
      '   :TISCHKONTOID,'
      '   :OFFENETISCHID,'
      '   :DATUM,'
      '   :ARTIKELID,'
      '   :MENGE,'
      '   :BETRAG,'
      '   :KELLNERID,'
      '   :KASSEID,'
      '   :GEDRUCKT,'
      '   :BEILAGENID1,'
      '   :BEILAGENID2,'
      '   :BEILAGENID3,'
      '   :BEILAGENTEXT,'
      '   :STATUS,'
      '   :VERBUCHT,'
      '   :GANGID,'
      '   :I_DEVICEGUID)')
    KeyLinks.Strings = (
      'Firma'
      'TischKontoId')
    PreparedEdits = True
    PreparedInserts = True
    RecordCountAccurate = True
    SQL.Strings = (
      
        'SELECT t.TischkontoID, t.OffeneTischID, t.Firma, t.Gedruckt, t.K' +
        'ellnerID,'
      't.KasseID, t.Datum, t.ArtikelID, t.Menge, t.Betrag,'
      '(case when t.artikelid is not null then'
      'a.bezeichnung'
      'else'
      '(case when b1.beilagenid = -1 then TRIM(t.Beilagentext)'
      'else'
      
        '((case when b1.bezeichnung is not null then TRIM(b1.bezeichnung)' +
        ' else '#39#39' end) || '#39' '#39' ||'
      
        '(case when b2.bezeichnung is not null then TRIM(b2.bezeichnung) ' +
        'else '#39#39' end) || '#39' '#39' ||'
      
        '(case when b3.bezeichnung is not null then TRIM(b3.bezeichnung) ' +
        'else '#39#39' end))'
      'END)'
      'END) as LookArtikel,'
      
        't.BeilagenID1, t.BeilagenID2, t.BeilagenID3, t.BeilagenText, t.S' +
        'tatus, t.Verbucht, t.GangID, t.I_DeviceGuid'
      'FROM hilf_tischkonto t'
      
        'LEFT OUTER JOIN Artikel a ON a.Firma = t.Firma AND a.ArtikelID =' +
        ' t.ArtikelID'
      
        'LEFT OUTER JOIN Beilagen b1 ON b1.Firma = t.Firma AND b1.beilage' +
        'nid = t.beilagenid1'
      
        'LEFT OUTER JOIN Beilagen b2 ON b2.Firma = t.Firma AND b2.beilage' +
        'nid = t.beilagenid2'
      
        'LEFT OUTER JOIN Beilagen b3 ON b3.Firma = t.Firma AND b3.beilage' +
        'nid = t.beilagenid3'
      'WHERE'
      't.firma = :pFirma and'
      't.offenetischid = :pOffeneTischID'
      'ORDER BY'
      't.TischkontoID')
    Left = 1032
    Top = 72
  end
  object QueryGetOpenTableIDbyTableID: TIBOQuery
    Params = <
      item
        DataType = ftUnknown
        Name = 'pFirma'
        ParamType = ptInput
      end
      item
        DataType = ftUnknown
        Name = 'pTischID'
        ParamType = ptInput
      end
      item
        DataType = ftUnknown
        Name = 'pDatum'
        ParamType = ptInput
      end>
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    PreparedEdits = True
    PreparedInserts = True
    RecordCountAccurate = True
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
    Left = 896
    Top = 88
  end
  object QueryWaiter: TIBOQuery
    Params = <
      item
        DataType = ftUnknown
        Name = 'pFirma'
        ParamType = ptInput
      end>
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    KeyLinks.Strings = (
      'Firma'
      'KellnerID')
    PreparedEdits = True
    PreparedInserts = True
    RecordCountAccurate = True
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
    Top = 40
  end
  object QueryReactivateTable: TIBOQuery
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    IB_Transaction = TransactionLockTable
    PreparedEdits = True
    PreparedInserts = True
    RecordCountAccurate = True
    Left = 864
    Top = 32
  end
  object CDSMakeLists: TClientDataSet
    Aggregates = <>
    AggregatesActive = True
    FieldDefs = <
      item
        Name = 'ID'
        DataType = ftInteger
      end
      item
        Name = 'Description'
        DataType = ftString
        Size = 25
      end>
    IndexDefs = <
      item
        Name = 'CDSMakeListIndex1'
        Fields = 'ID'
        Options = [ixPrimary]
      end>
    IndexFieldNames = 'ID'
    Params = <>
    StoreDefs = True
    Left = 216
    Top = 16
  end
  object QueryTop20: TIBOQuery
    Params = <
      item
        DataType = ftUnknown
        Name = 'pFirma'
        ParamType = ptInput
      end
      item
        DataType = ftUnknown
        Name = 'pStartDate'
        ParamType = ptInput
      end>
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    PreparedEdits = True
    PreparedInserts = True
    RecordCountAccurate = True
    SQL.Strings = (
      'select FIRST 20'
      'ja.artikelid, art.bezeichnung, count(*) as counter'
      'from'
      'journalarchiv ja'
      
        'inner join artikel art on art.firma = ja.firma and art.artikelid' +
        ' = ja.artikelid'
      'where'
      'ja.journaltyp = 1 and'
      'ja.firma = :pFirma and'
      'ja.datum > :pStartDate'
      'group by'
      'ja.artikelid, art.bezeichnung'
      'order by'
      'counter desc')
    Left = 728
    Top = 96
  end
  object CDSKonto2: TClientDataSet
    Aggregates = <
      item
        Active = True
        AggregateName = 'Summe'
        Expression = 'SUM(Menge*Betrag)'
        Visible = False
      end
      item
        AggregateName = 'Firma'
        Visible = False
      end
      item
        AggregateName = 'OffeneTischID'
        Visible = False
      end
      item
        AggregateName = 'ArtikelID'
        Visible = False
      end
      item
        AggregateName = 'Betrag'
        Visible = False
      end>
    AggregatesActive = True
    Filter = '((Menge <> 0) or (Menge is null))'
    FieldDefs = <
      item
        Name = 'TischkontoID'
        DataType = ftInteger
      end
      item
        Name = 'Firma'
        DataType = ftSmallint
      end
      item
        Name = 'OffeneTischID'
        DataType = ftInteger
      end
      item
        Name = 'Datum'
        DataType = ftDate
      end
      item
        Name = 'ArtikelID'
        DataType = ftInteger
      end
      item
        Name = 'Menge'
        DataType = ftFloat
      end
      item
        Name = 'LookArtikel'
        DataType = ftString
        Size = 25
      end
      item
        Name = 'Betrag'
        DataType = ftFloat
      end
      item
        Name = 'KellnerID'
        DataType = ftInteger
      end
      item
        Name = 'KasseID'
        DataType = ftInteger
      end
      item
        Name = 'Gedruckt'
        DataType = ftString
        Size = 1
      end
      item
        Name = 'Verbucht'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'Status'
        DataType = ftSmallint
      end
      item
        Name = 'GangID'
        DataType = ftInteger
      end
      item
        Name = 'Zaehler'
        DataType = ftInteger
      end
      item
        Name = 'Beilagenabfrage'
        DataType = ftString
        Size = 1
      end
      item
        Name = 'BeilagenID1'
        DataType = ftInteger
      end
      item
        Name = 'BeilagenID2'
        DataType = ftInteger
      end
      item
        Name = 'BeilagenID3'
        DataType = ftInteger
      end
      item
        Name = 'BeilagenText'
        DataType = ftString
        Size = 35
      end
      item
        Name = 'I_DeviceGuid'
        DataType = ftString
        Size = 40
      end>
    IndexDefs = <
      item
        Name = 'CDSKontoIndex1'
        Fields = 'Firma;TischkontoID'
        Options = [ixPrimary]
      end>
    IndexName = 'CDSKontoIndex1'
    Params = <>
    StoreDefs = True
    Left = 344
    Top = 16
  end
  object QueryCheckTableisReopened: TIBOQuery
    Params = <
      item
        DataType = ftUnknown
        Name = 'pfirma'
        ParamType = ptInput
      end
      item
        DataType = ftUnknown
        Name = 'pdatum'
        ParamType = ptInput
      end
      item
        DataType = ftUnknown
        Name = 'poffen'
        ParamType = ptInput
      end
      item
        DataType = ftUnknown
        Name = 'ptischid'
        ParamType = ptInput
      end>
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    PreparedEdits = True
    PreparedInserts = True
    RecordCountAccurate = True
    SQL.Strings = (
      'Select OffeneTischID from OffeneTische'
      'Where'
      'firma = :pfirma and'
      'datum = :pdatum and'
      'offen = :poffen and'
      'tischid = :ptischid')
    Left = 792
    Top = 128
  end
  object QueryProcedureCheckTischOffen: TIBOQuery
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    IB_Transaction = TransactionLockTable
    PreparedEdits = True
    PreparedInserts = True
    RecordCountAccurate = True
    Left = 904
    Top = 136
  end
  object QueryWriteCurrentWaiterToOpenTable: TIBOQuery
    Params = <
      item
        DataType = ftUnknown
        Name = 'pCurrentWaiterID'
        ParamType = ptInput
      end
      item
        DataType = ftUnknown
        Name = 'pfirma'
        ParamType = ptInput
      end
      item
        DataType = ftUnknown
        Name = 'poffenetischid'
        ParamType = ptInput
      end>
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    PreparedEdits = True
    PreparedInserts = True
    RecordCountAccurate = True
    SQL.Strings = (
      'update'
      'OffeneTische'
      'set'
      'CurrentWaiterID = :pCurrentWaiterID'
      'where'
      'firma = :pfirma and'
      'offenetischid = :poffenetischid')
    Left = 1040
    Top = 136
  end
  object QueryGetFertigeSpeisen: TIBOQuery
    Params = <
      item
        DataType = ftUnknown
        Name = 'KellnerID'
        ParamType = ptInput
      end>
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    PreparedEdits = True
    PreparedInserts = True
    RecordCountAccurate = True
    RequestLive = True
    SQL.Strings = (
      'SELECT TischNR, Anz, Bez, Status '
      'FROM iPAQ'
      'WHERE (KellnerID = :KellnerID) '
      '  AND ((Status < 1) OR (Status is Null))')
    Left = 1100
    Top = 400
  end
  object QueryConfirmFertigeSpeisen: TIBOQuery
    Params = <
      item
        DataType = ftUnknown
        Name = 'KellnerID'
        ParamType = ptInput
      end>
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    PreparedEdits = True
    PreparedInserts = True
    RecordCountAccurate = True
    RequestLive = True
    SQL.Strings = (
      'DELETE FROM iPAQ'
      'WHERE (KellnerID = :KellnerID) '
      '  AND (Status = 1)')
    Left = 1100
    Top = 460
  end
  object QueryReservFELIX: TIBOQuery
    Params = <
      item
        DataType = ftUnknown
        Name = 'pFirma'
        ParamType = ptInput
      end
      item
        DataType = ftUnknown
        Name = 'pID'
        ParamType = ptInput
      end>
    IB_Connection = IB_ConnectionFelix
    PreparedEdits = True
    PreparedInserts = True
    RecordCountAccurate = True
    RequestLive = True
    SQL.Strings = (
      
        'select r.FIRMA, r.ID, r.ZIMMERID, r.GASTNAME, r.CHECKIN from RES' +
        'ERVIERUNG r'
      'where r.FIRMA=:pFirma and r.ID = :pID')
    Left = 290
    Top = 180
  end
  object QueryCheckFELIX: TIBOQuery
    IB_Connection = IB_ConnectionFelix
    PreparedEdits = True
    PreparedInserts = True
    RecordCountAccurate = True
    SQL.Strings = (
      'select first 1 * from leistungen')
    Left = 290
    Top = 120
  end
  object QueryTerminNr: TIBOQuery
    Params = <
      item
        DataType = ftUnknown
        Name = 'pTerminNr'
        ParamType = ptInput
      end>
    DatabaseName = 'localhost:C:\touch2000\Daten\Kasse.GDB'
    PreparedEdits = True
    PreparedInserts = True
    RecordCountAccurate = True
    RequestLive = True
    SQL.Strings = (
      
        'SELECT Distinct(ZI_Nummer) AS ZimmerID, Substring(ZI_Pers from 1' +
        ' for 18) AS TischNR,'
      
        'Termin_Nr AS TischID, Pers_NR as gastadresseid, Zi_Pers as Gastn' +
        'ame'
      'FROM GastInfo'
      'Where TERMIN_Nr = :pTerminNr')
    Left = 338
    Top = 172
  end
end
