object DM: TDM
  OnCreate = DataModuleCreate
  Height = 579
  Width = 1140
  object QueryGetOpenTable: TFDQuery
    SQL.Strings = (
      'Select * from OffeneTische'
      'Where'
      'firma = :CompanyID and'
      'OffeneTischID = :OpenTableID')
    Left = 56
    Top = 16
    ParamData = <
      item
        Name = 'COMPANYID'
        ParamType = ptInput
      end
      item
        Name = 'OPENTABLEID'
        ParamType = ptInput
      end>
  end
  object TimerStartService: TTimer
    Enabled = False
    OnTimer = TimerStartServiceTimer
    Left = 32
    Top = 72
  end
  object ConnectionManager: TFDManager
    DriverDefFileAutoLoad = False
    ConnectionDefFileAutoLoad = False
    WaitCursor = gcrAppWait
    FetchOptions.AssignedValues = [evAutoFetchAll]
    FetchOptions.AutoFetchAll = afTruncate
    FormatOptions.AssignedValues = [fvMapRules]
    FormatOptions.OwnMapRules = True
    FormatOptions.MapRules = <
      item
        SourceDataType = dtDateTimeStamp
        TargetDataType = dtDateTime
      end
      item
        SourceDataType = dtSingle
        TargetDataType = dtDouble
      end>
    Active = True
    Left = 184
    Top = 16
  end
  object ConnectionFelix: TFDConnection
    Params.Strings = (
      '')
    OnError = ConnectionFelixError
    Left = 288
    Top = 13
  end
  object QueryFelix: TFDQuery
    ResourceOptions.AssignedValues = [rvParamCreate]
    ResourceOptions.ParamCreate = False
    Left = 40
    Top = 125
  end
  object TableKassa: TFDTable
    Connection = ConnectionFelix
    UpdateOptions.UpdateTableName = 'KASSA'
    TableName = 'KASSA'
    Left = 32
    Top = 416
  end
  object TableKassaZahlweg: TFDTable
    Connection = ConnectionFelix
    UpdateOptions.UpdateTableName = 'KASSAZAHLWEG'
    TableName = 'KASSAZAHLWEG'
    Left = 120
    Top = 416
  end
  object QueryUpdateKassaZahlweg: TFDQuery
    Connection = ConnectionFelix
    SQL.Strings = (
      
        'update or insert into KASSAZAHLWEG (FIRMA, KASSAID, ZAHLWEGID, A' +
        'NFANGSBESTAND, BETRAG)'
      'values (:FIRMA, :KASSAID, :ZAHLWEGID, :ANFANGSBESTAND, :BETRAG)'
      'matching (kassaid,zahlwegID,Firma)')
    Left = 160
    Top = 128
    ParamData = <
      item
        Name = 'FIRMA'
        ParamType = ptInput
      end
      item
        Name = 'KASSAID'
        ParamType = ptInput
      end
      item
        Name = 'ZAHLWEGID'
        ParamType = ptInput
      end
      item
        Name = 'ANFANGSBESTAND'
        ParamType = ptInput
      end
      item
        Name = 'BETRAG'
        ParamType = ptInput
      end>
  end
  object QueryGetZahlwegBar: TFDQuery
    Connection = ConnectionFelix
    SQL.Strings = (
      'SELECT BAR FROM Zahlweg'
      '      WHERE ID = :ID AND Firma = :Firma')
    Left = 304
    Top = 128
    ParamData = <
      item
        Name = 'ID'
        ParamType = ptInput
      end
      item
        Name = 'FIRMA'
        ParamType = ptInput
      end>
  end
  object TransactionDiverses2: TFDTransaction
    Connection = ConnectionFelix
    Left = 392
    Top = 16
  end
  object QuerySetKassenbuch: TFDQuery
    Connection = ConnectionFelix
    SQL.Strings = (
      'Update Diverses2'
      '      Set LastKassenID = LastKassenID +1'
      '      WHERE Firma = :Firma')
    Left = 424
    Top = 128
    ParamData = <
      item
        Name = 'FIRMA'
        ParamType = ptInput
      end>
  end
  object QueryGetKassenbuch: TFDQuery
    Connection = ConnectionFelix
    SQL.Strings = (
      'SELECT LastKassenID FROM Diverses2'
      'WHERE Firma = :Firma')
    Left = 536
    Top = 128
    ParamData = <
      item
        Name = 'FIRMA'
        ParamType = ptInput
      end>
  end
  object TableDiverses: TFDTable
    Connection = ConnectionFelix
    UpdateOptions.UpdateTableName = 'DIVERSES'
    TableName = 'DIVERSES'
    Left = 224
    Top = 416
  end
  object TableDiverses2: TFDTable
    Connection = ConnectionFelix
    UpdateOptions.UpdateTableName = 'DIVERSES2'
    TableName = 'DIVERSES2'
    Left = 316
    Top = 416
  end
  object insertGastkonto: TFDQuery
    Connection = ConnectionFelix
    SQL.Strings = (
      
        'Insert into GASTKONTO(firma, reservid, datum, menge,betrag, leis' +
        'tungsid,fix, aufrechnungsadresse, intabsgebucht, Leistungstext)'
      
        'Values(:ifirma, :ireservid,:vdatum, :imenge, :ivalue,:ileistungs' +
        'id, :ifix, :iaufrechnungsadresse, :iIntabsgebucht, :itext)')
    Left = 640
    Top = 128
    ParamData = <
      item
        Name = 'IFIRMA'
        ParamType = ptInput
      end
      item
        Name = 'IRESERVID'
        ParamType = ptInput
      end
      item
        Name = 'VDATUM'
        ParamType = ptInput
      end
      item
        Name = 'IMENGE'
        ParamType = ptInput
      end
      item
        Name = 'IVALUE'
        ParamType = ptInput
      end
      item
        Name = 'ILEISTUNGSID'
        ParamType = ptInput
      end
      item
        Name = 'IFIX'
        ParamType = ptInput
      end
      item
        Name = 'IAUFRECHNUNGSADRESSE'
        ParamType = ptInput
      end
      item
        Name = 'IINTABSGEBUCHT'
        ParamType = ptInput
      end
      item
        Name = 'ITEXT'
        ParamType = ptInput
      end>
  end
  object QueryLeistung: TFDQuery
    Connection = ConnectionFelix
    SQL.Strings = (
      'SELECT * FROM Leistungen'
      'WHERE Firma = :Firma AND'
      'ID = :ID')
    Left = 48
    Top = 208
    ParamData = <
      item
        Name = 'FIRMA'
        ParamType = ptInput
      end
      item
        Name = 'ID'
        ParamType = ptInput
      end>
  end
  object QueryTabMWST: TFDQuery
    Connection = ConnectionFelix
    SQL.Strings = (
      'SELECT * FROM Mehrwertsteuer'
      'WHERE Firma = :Firma')
    Left = 160
    Top = 208
    ParamData = <
      item
        Name = 'FIRMA'
        ParamType = ptInput
      end>
  end
  object QueryInsertKassenjournal: TFDQuery
    Connection = ConnectionFelix
    SQL.Strings = (
      'INSERT INTO Kassenjournal'
      '      '
      
        '        (ID, FIRMA,KASSAID,BEARBEITERID,DATUM,ZEIT,BETRAG,MENGE,' +
        'LEISTUNGSID,'
      
        '         ARRANGEMENTID,RESERVID,ZAHLWEGID,BANKLEITZAHL,SCHECKNUM' +
        'MER,BETRAGDEVISEN,'
      '         ERFASSUNGDURCH,TEXT, MWST)'
      'VALUES'
      '      '
      
        '        (:ID, :FIRMA,:KASSAID,:BEARBEITERID,:DATUM,:ZEIT,:BETRAG' +
        ',:MENGE,'
      '        :LEISTUNGSID,'
      
        '        :ARRANGEMENTID,:RESERVID,:ZAHLWEGID,:BANKLEITZAHL,:SCHEC' +
        'KNUMMER,'
      '        :BETRAGDEVISEN,'
      '        :ERFASSUNGDURCH,:TEXT,:MwSt)')
    Left = 272
    Top = 208
    ParamData = <
      item
        Name = 'ID'
        ParamType = ptInput
      end
      item
        Name = 'FIRMA'
        ParamType = ptInput
      end
      item
        Name = 'KASSAID'
        ParamType = ptInput
      end
      item
        Name = 'BEARBEITERID'
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
        Name = 'ARRANGEMENTID'
        ParamType = ptInput
      end
      item
        Name = 'RESERVID'
        ParamType = ptInput
      end
      item
        Name = 'ZAHLWEGID'
        ParamType = ptInput
      end
      item
        Name = 'BANKLEITZAHL'
        ParamType = ptInput
      end
      item
        Name = 'SCHECKNUMMER'
        ParamType = ptInput
      end
      item
        Name = 'BETRAGDEVISEN'
        ParamType = ptInput
      end
      item
        Name = 'ERFASSUNGDURCH'
        ParamType = ptInput
      end
      item
        Name = 'TEXT'
        ParamType = ptInput
      end
      item
        Name = 'MWST'
        ParamType = ptInput
      end>
  end
  object QueryArrangementLeistungen: TFDQuery
    Connection = ConnectionFelix
    SQL.Strings = (
      'SELECT * FROM ArrangementLeistungen'
      'WHERE Firma = :Firma AND'
      'ArrangementID = :ArrangementID'
      'ORDER BY Preiskategorie')
    Left = 420
    Top = 208
    ParamData = <
      item
        Name = 'FIRMA'
        ParamType = ptInput
      end
      item
        Name = 'ARRANGEMENTID'
        ParamType = ptInput
      end>
  end
  object QueryDoSomething: TFDQuery
    Connection = ConnectionFelix
    Left = 552
    Top = 208
  end
  object insertGKonto: TFDQuery
    Connection = ConnectionFelix
    Left = 664
    Top = 208
  end
  object QueryCheckLosungKellner: TFDQuery
    Connection = ConnectionFelix
    SQL.Strings = (
      'select ID from kassenjournal'
      
        'where Firma = :Firma and Erfassungdurch = 7 and Datum = :Datum a' +
        'nd Text LIKE :Text')
    Left = 776
    Top = 208
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
        Name = 'TEXT'
        ParamType = ptInput
      end>
  end
  object QueryUpdateReservierung: TFDQuery
    Connection = ConnectionFelix
    SQL.Strings = (
      'update RESERVIERUNG'
      'set CHECKIN = :pCheckIn,'
      '  ABGEREIST = :pAbgereist'
      'where ID = :pID')
    Left = 48
    Top = 280
    ParamData = <
      item
        Name = 'PCHECKIN'
        ParamType = ptInput
      end
      item
        Name = 'PABGEREIST'
        ParamType = ptInput
      end
      item
        Name = 'PID'
        ParamType = ptInput
      end>
  end
  object QueryCheckReservierung: TFDQuery
    Connection = ConnectionFelix
    SQL.Strings = (
      'select CHECKIN from Reservierung where ID = :pID')
    Left = 184
    Top = 280
    ParamData = <
      item
        Name = 'PID'
        ParamType = ptInput
      end>
  end
  object QueryGetGastData: TFDQuery
    Connection = ConnectionFelix
    SQL.Strings = (
      'select g.*, xn.landcode as LAND from gaestestamm g'
      'left join reservierung r on r.gastadresseid = g.id '
      'left join xnation xn on g.nationalid = xn.id'
      'where r.id = :pID')
    Left = 312
    Top = 280
    ParamData = <
      item
        Name = 'PID'
        ParamType = ptInput
      end>
  end
  object QueryUpdateGaestestamm: TFDQuery
    Connection = ConnectionFelix
    Left = 768
    Top = 128
  end
  object TableLosungsZuordnung: TFDTable
    Connection = ConnectionFelix
    UpdateOptions.UpdateTableName = 'KASS_PAYMENTTOFELIX'
    TableName = 'KASS_PAYMENTTOFELIX'
    Left = 416
    Top = 416
  end
  object TableRechZahlweg: TFDTable
    Connection = ConnectionFelix
    UpdateOptions.UpdateTableName = 'RECHNUNGSZAHLWEG'
    TableName = 'RECHNUNGSZAHLWEG'
    Left = 608
    Top = 416
  end
  object TableKreditOffen: TFDTable
    Connection = ConnectionFelix
    UpdateOptions.UpdateTableName = 'KREDITOFFEN'
    TableName = 'KREDITOFFEN'
    Left = 720
    Top = 416
  end
  object TableUmsatzzuordnung: TFDTable
    Connection = ConnectionFelix
    UpdateOptions.UpdateTableName = 'KASS_TURNOVERTOFELIX'
    TableName = 'KASS_TURNOVERTOFELIX'
    Left = 32
    Top = 472
  end
  object TableRechnung: TFDTable
    Connection = ConnectionFelix
    UpdateOptions.UpdateTableName = 'Rechnung'
    TableName = 'Rechnung'
    Left = 152
    Top = 472
  end
  object TableRechnungsKonto: TFDTable
    Connection = ConnectionFelix
    UpdateOptions.UpdateTableName = 'RECHNUNGSKONTO'
    TableName = 'RECHNUNGSKONTO'
    Left = 248
    Top = 472
  end
  object TableZahlweg: TFDTable
    Connection = ConnectionFelix
    UpdateOptions.UpdateTableName = 'ZAHLWEG'
    TableName = 'ZAHLWEG'
    Left = 512
    Top = 416
  end
  object TableArrangement: TFDTable
    Connection = ConnectionFelix
    UpdateOptions.UpdateTableName = 'ARRANGEMENT'
    TableName = 'ARRANGEMENT'
    Left = 376
    Top = 472
  end
  object QueryUniqueNr: TFDQuery
    Connection = ConnectionFelix
    SQL.Strings = (
      
        'SELECT kc.ReservID, kc.Cardnumber, kc.Zimmerid, kc.Uniquenumber,' +
        ' kc.advuid'
      'FROM Key_Card_Online kc'
      'WHERE CheckOut = '#39'F'#39
      'and kc.ReservID = :reservId')
    Left = 424
    Top = 280
    ParamData = <
      item
        Name = 'RESERVID'
        ParamType = ptInput
      end>
  end
  object QueryGastInfo: TFDQuery
    Connection = ConnectionFelix
    SQL.Strings = (
      'select (trim(g.nachname) || '#39' '#39' || trim(g.vorname)) as name,'
      'r.id , r.id , r.anreisedatum, r.abreisedatum, r.zimmerid,'
      'r.bemerkung2 FROM reservierung r'
      'left  outer join gaestestamm g on g.id = r.gastadresseid'
      
        'left outer join Arrangement a on a.firma = r.firma AND a.id = r.' +
        'arrangementid'
      
        'left outer join room_categories rc on rc.category_number = r.kat' +
        'egorieid'
      'where r.firma = :Firma'
      
        'and r.buchart in (0,1) and (r.storniert is null or  r.storniert ' +
        '='#39'F'#39')'
      'and r.zimmeranzahl = 1 and r.checkin = '#39'T'#39
      'and r.abreisedatum >= :dateToday'
      'and r.anreisedatum <= :dateToday'
      'and (r.SPERRENEXTRA = '#39'F'#39' or (r.sperrenextra is null))'
      '--and rc.short_description <> '#39'PSE'#39
      
        'group by r.id, g.nachname, g.vorname, r.anreisedatum, r.abreised' +
        'atum,'
      'r.zimmerid, r.bemerkung2 order by G.Nachname')
    Left = 536
    Top = 280
    ParamData = <
      item
        Name = 'FIRMA'
        ParamType = ptInput
      end
      item
        Name = 'DATETODAY'
        ParamType = ptInput
      end>
  end
  object QueryProcGastkontoRechnung: TFDQuery
    Connection = ConnectionFelix
    SQL.Strings = (
      'create or alter  procedure BOOK_RESTAURANTVALUEBILL ('
      '    ITEXT char(19),'
      '    IFIRMA integer,'
      '    ITISCHNR integer,'
      '    IMWST float,'
      '    IZAHLWEGID integer,'
      '    ITIME date,'
      '    IVALUE float,'
      '    IDISCOUNT float)'
      'returns ('
      '    ORESULT integer)'
      'as'
      'declare variable VRECHID integer;'
      'declare variable VTEXT char(40);'
      'declare variable VDATUM date;'
      'declare variable VLEISTUNGSID integer;'
      'begin'
      
        ' for SELECT ZahlwgIDFelix FROM kass_paymenttofelix WHERE ZahlwgI' +
        'DKAsse = :iZahlwegID  into'
      '   :oresult DO'
      ' begin'
      '   for select felixdate from diverses where firma = :ifirma'
      '     into :vdatum do'
      '   begin'
      '     for SELECT DISTINCT LeistungsID, l.leistungsbezeichnung'
      '      FROM Kass_Tischzuordnung kt'
      
        '      LEFT OUTER JOIN Leistungen l on kt.LeistungsID = l.ID and ' +
        'l.Firma = 1'
      
        '      LEFT OUTER JOIN mehrwertsteuer mw on l.firma = mw.firma an' +
        'd l.MwstID = mw.id'
      
        '      WHERE kt.TischVon <= :iTischNr AND kt.TischBis >= :iTischN' +
        'r and mw.mwst = :imwst'
      '      INTO :vleistungsid, :vtext do'
      '      begin'
      '        vtext = trim(trim(:vtext)||'#39' '#39'||trim(:itext));'
      '        SELECT GEN_ID(ID, 1) FROM RDB$DATABASE into :vrechid;'
      
        '        INSERT into kassenjournal (firma  , zahlwegid,  datum, m' +
        'enge, betrag, leistungsid, zeit,  erfassungdurch, text)'
      
        '                       VALUES (:ifirma, null, :vdatum, 1 , :ival' +
        'ue, :vleistungsid,  Current_Time, 12, '#39'Kassenrechnung'#39');'
      '        if (:oresult = 1) then'
      
        '          INSERT into kassenjournal (firma  , zahlwegid,  datum,' +
        ' menge, betrag, leistungsid, zeit,  erfassungdurch, text, bankle' +
        'itzahl)   -- reduzieren'
      
        '                       VALUES (:ifirma, :oREsult, :vdatum, null ' +
        ', (:ivalue-:iDiscount), null,  Current_Time, 7, '#39'Kassenrechnung'#39 +
        ', 1);'
      '        else'
      
        '          INSERT into kassenjournal (firma  , zahlwegid,  datum,' +
        ' menge, betrag, leistungsid, zeit,  erfassungdurch, text)    -- ' +
        'reduzieren'
      
        '                       VALUES (:ifirma, :oREsult, :vdatum, null ' +
        ', (:ivalue-:iDiscount), null,  Current_Time, 7, '#39'Kassenrechnung'#39 +
        ');'
      ''
      
        '         insert into rechnung ( firma,id, erstellerid,rechnungsn' +
        'ummer,adresseid,datum,gedruckt,bezahlt,zahlungsbetrag,bereitsbez' +
        'ahlt, nachlass)'
      
        '           Values(:ifirma, :vrechid, -1, 0, null, :vdatum, '#39'T'#39', ' +
        #39'T'#39', (:ivalue-:iDiscount), (:ivalue-:iDiscount), :iDiscount);'
      ''
      
        '         insert into rechnungszahlweg ( firma,RechnungsID,datum,' +
        'zahlwegid, Betrag, Verbucht)    -- reduzieren'
      
        '           Values(:ifirma, :vrechid, :vdatum, :oREsult, (:ivalue' +
        '-:iDiscount), '#39'T'#39');'
      '            '
      
        '         insert into rechnungskonto ( firma,RechnungsID,datum,Le' +
        'istungsid, menge, GesamtBetrag)'
      
        '           Values(:ifirma, :vrechid,  :vdatum, :vleistungsid, 1,' +
        ' :ivalue);'
      ''
      ''
      '      end'
      '   end'
      ' end'
      ' suspend;'
      'end')
    Left = 944
    Top = 24
    ParamData = <
      item
        Name = 'IZAHLWEGID'
        ParamType = ptInput
      end
      item
        Name = 'ORESULT'
        ParamType = ptInput
      end
      item
        Name = 'IFIRMA'
        ParamType = ptInput
      end
      item
        Name = 'VDATUM'
        ParamType = ptInput
      end
      item
        Name = 'ITISCHNR'
        ParamType = ptInput
      end
      item
        Name = 'IMWST'
        ParamType = ptInput
      end
      item
        Name = 'VLEISTUNGSID'
        ParamType = ptInput
      end
      item
        Name = 'VTEXT'
        ParamType = ptInput
      end
      item
        Name = 'ITEXT'
        ParamType = ptInput
      end
      item
        Name = 'VRECHID'
        ParamType = ptInput
      end
      item
        Name = 'IVALUE'
        ParamType = ptInput
      end
      item
        Name = 'IDISCOUNT'
        ParamType = ptInput
      end>
  end
  object FDStoredProcGastKontoRechnung: TFDStoredProc
    StoredProcName = 'BOOK_RESTAURANTVALUEBILL'
    Left = 584
    Top = 16
    ParamData = <
      item
        Name = 'iFirma'
      end
      item
        Name = 'iTischNr'
      end
      item
        Name = 'iZahlwegId'
      end
      item
        Name = 'iTime'
      end
      item
        Name = 'iValue'
      end
      item
        Name = 'iMwst'
      end
      item
        Name = 'iText'
      end>
  end
  object QueryGetTableIdFromReservId: TFDQuery
    Connection = ConnectionFelix
    SQL.Strings = (
      
        'select * from Reservierung Zimmerid where Firma = :pFirma and ID' +
        ' = :pReservID')
    Left = 816
    Top = 280
    ParamData = <
      item
        Name = 'PFIRMA'
        ParamType = ptInput
      end
      item
        Name = 'PRESERVID'
        ParamType = ptInput
      end>
  end
  object QueryInsertKass_KassenArchiv: TFDQuery
    Connection = ConnectionFelix
    SQL.Strings = (
      
        'insert into KASS_KASSENARCHIV (id, firma, tischnr, datum, zeit, ' +
        'betrag, zimmerid, leistungsid, kellnr, reservid, text, kassinfoi' +
        'd)'
      
        'values (:id, :firma, :tischnr, :datum, :zeit, :betrag, :zimmerid' +
        ', :leistungsid, :kellnr, :reservid, :text, :kassinfoid)')
    Left = 64
    Top = 336
    ParamData = <
      item
        Name = 'ID'
        ParamType = ptInput
      end
      item
        Name = 'FIRMA'
        ParamType = ptInput
      end
      item
        Name = 'TISCHNR'
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
        Name = 'ZIMMERID'
        ParamType = ptInput
      end
      item
        Name = 'LEISTUNGSID'
        ParamType = ptInput
      end
      item
        Name = 'KELLNR'
        ParamType = ptInput
      end
      item
        Name = 'RESERVID'
        ParamType = ptInput
      end
      item
        Name = 'TEXT'
        ParamType = ptInput
      end
      item
        Name = 'KASSINFOID'
        ParamType = ptInput
      end>
  end
  object QueryGetKassIdIsSaved: TFDQuery
    Connection = ConnectionFelix
    SQL.Strings = (
      
        'select KASSINFOID from KASS_KASSENARCHIV where KASSINFOID = :KIn' +
        'fId')
    Left = 216
    Top = 336
    ParamData = <
      item
        Name = 'KINFID'
        ParamType = ptInput
      end>
  end
  object QueryTemp: TFDQuery
    Connection = ConnectionFelix
    Left = 328
    Top = 344
  end
  object QueryAnlage: TFDQuery
    Connection = ConnectionFelix
    SQL.Strings = (
      
        'Select Typ from AnlagenTyp where Firma = :Firma and anlage_typ =' +
        ' '#39'Kassen'#39)
    Left = 416
    Top = 352
    ParamData = <
      item
        Name = 'FIRMA'
        ParamType = ptInput
      end>
  end
  object StoredProcBOOK_RESTAURANTVALUEEXTERN: TFDStoredProc
    Connection = ConnectionFelix
    StoredProcName = 'BOOK_RESTAURANTVALUEEXTERN'
    Left = 712
    Top = 32
    ParamData = <
      item
        Name = 'iText'
        ParamType = ptInput
      end
      item
        Name = 'iLeistung'
        ParamType = ptInput
      end
      item
        Name = 'iFirma'
        ParamType = ptInput
      end
      item
        Name = 'iReservId'
        ParamType = ptInput
      end
      item
        Name = 'iTime'
        ParamType = ptInput
      end
      item
        Name = 'iValue'
        ParamType = ptInput
      end
      item
        Name = 'iMwst'
        ParamType = ptInput
      end
      item
        Name = 'oResult'
        ParamType = ptOutput
      end>
  end
  object QueryUpdateOrInsertArtikel: TFDQuery
    Connection = ConnectionFelix
    SQL.Strings = (
      'Update or Insert into Artikel (Firma, ArtikelId, Bezeichnung)'
      'Values(:CompanyId, :ArticleId, :Description)'
      'matching (Firma, ArtikelId)')
    Left = 536
    Top = 352
    ParamData = <
      item
        Name = 'COMPANYID'
        ParamType = ptInput
      end
      item
        Name = 'ARTICLEID'
        ParamType = ptInput
      end
      item
        Name = 'DESCRIPTION'
        ParamType = ptInput
      end>
  end
  object QueryUpdateOrInsertKellner: TFDQuery
    Connection = ConnectionFelix
    SQL.Strings = (
      'Update or Insert into Kellner (Firma, KellnerId, Nachname)'
      'Values(:CompanyId, :WaiterId, :Surname)'
      'matching (Firma, KellnerId)')
    Left = 688
    Top = 360
    ParamData = <
      item
        Name = 'COMPANYID'
        ParamType = ptInput
      end
      item
        Name = 'WAITERID'
        ParamType = ptInput
      end
      item
        Name = 'SURNAME'
        ParamType = ptInput
      end>
  end
  object QueryUpdateOrInsertJournalArchiv: TFDQuery
    Connection = ConnectionFelix
    SQL.Strings = (
      
        'Update or Insert into JOURNALARCHIV (Firma, JOURNALARCHIVId, Dat' +
        'um, Zeit, KellnerId, Menge, Betrag, ArtikelId, BeilagenId, Zahlw' +
        'egId, TischId, JournalTyp, Verbucht, Text, VonOffeneTischId, Rec' +
        'hnungsId, Nachlass, Lagerverbucht, Lagerdatum, LagerId, SyncId, ' +
        'BonNr, Preisebene)'
      
        'Values(:Firma, :JOURNALARCHIVId, :Datum, :Zeit, :KellnerId, :Men' +
        'ge, :Betrag, :ArtikelId, :BeilagenId, :ZahlwegId, :TischId, :Jou' +
        'rnalTyp, :Verbucht, :Text, :VonOffeneTischId, :RechnungsId, :Nac' +
        'hlass, :Lagerverbucht, :Lagerdatum, :LagerId, :SyncId, :BonNr, :' +
        'Preisebene)'
      'matching (Firma, JOURNALARCHIVId)')
    Left = 808
    Top = 344
    ParamData = <
      item
        Name = 'FIRMA'
        ParamType = ptInput
      end
      item
        Name = 'JOURNALARCHIVID'
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
        Name = 'KELLNERID'
        ParamType = ptInput
      end
      item
        Name = 'MENGE'
        ParamType = ptInput
      end
      item
        Name = 'BETRAG'
        ParamType = ptInput
      end
      item
        Name = 'ARTIKELID'
        ParamType = ptInput
      end
      item
        Name = 'BEILAGENID'
        ParamType = ptInput
      end
      item
        Name = 'ZAHLWEGID'
        ParamType = ptInput
      end
      item
        Name = 'TISCHID'
        ParamType = ptInput
      end
      item
        Name = 'JOURNALTYP'
        ParamType = ptInput
      end
      item
        Name = 'VERBUCHT'
        ParamType = ptInput
      end
      item
        Name = 'TEXT'
        ParamType = ptInput
      end
      item
        Name = 'VONOFFENETISCHID'
        ParamType = ptInput
      end
      item
        Name = 'RECHNUNGSID'
        ParamType = ptInput
      end
      item
        Name = 'NACHLASS'
        ParamType = ptInput
      end
      item
        Name = 'LAGERVERBUCHT'
        ParamType = ptInput
      end
      item
        Name = 'LAGERDATUM'
        ParamType = ptInput
      end
      item
        Name = 'LAGERID'
        ParamType = ptInput
      end
      item
        Name = 'SYNCID'
        ParamType = ptInput
      end
      item
        Name = 'BONNR'
        ParamType = ptInput
      end
      item
        Name = 'PREISEBENE'
        ParamType = ptInput
      end>
  end
  object TableKassenJournal: TFDTable
    Connection = ConnectionFelix
    TableName = 'KASSENJOURNAL'
    Left = 512
    Top = 480
  end
  object QueryFirma: TFDQuery
    Connection = ConnectionFelix
    SQL.Strings = (
      
        'select fs.firmenname --, ft.titel, ft.text1, ft.text2, ft.text3,' +
        ' ft.text4, ft.text5'
      'from firmenstamm fs'
      '--JOIN firmentext ft on ft.firma=fs.firma')
    Left = 168
    Top = 80
  end
  object QueryInsertSendetMail: TFDQuery
    Connection = ConnectionFelix
    SQL.Strings = (
      
        'insert into Kass_send_Bug_RestServer (Firma,ReservId,sendDay, Te' +
        'xt)'
      'values (:Firma, :ReservId, :sendDay, :Text)')
    Left = 936
    Top = 296
    ParamData = <
      item
        Name = 'FIRMA'
        ParamType = ptInput
      end
      item
        Name = 'RESERVID'
        ParamType = ptInput
      end
      item
        Name = 'SENDDAY'
        ParamType = ptInput
      end
      item
        Name = 'TEXT'
        ParamType = ptInput
      end>
  end
  object QuerySelectErrorSendDate: TFDQuery
    Connection = ConnectionFelix
    SQL.Strings = (
      
        'select max(sendDay) as Datum from Kass_send_Bug_RestServer where' +
        ' ReservId = :ReservId')
    Left = 912
    Top = 224
    ParamData = <
      item
        Name = 'RESERVID'
        ParamType = ptInput
      end>
  end
  object QueryUpdateOrInsertJournal: TFDQuery
    Connection = ConnectionFelix
    SQL.Strings = (
      
        'Update or Insert into JOURNAL (Firma, JOURNALId, Datum, Zeit, Ke' +
        'llnerId, KasseId, Menge, Betrag, ArtikelId, BeilagenId, ZahlwegI' +
        'd, OffeneTischId, JournalTyp, Verbucht, Text, VonOffeneTischId, ' +
        'RechnungsId, Nachlass, Bankomat, Lagerverbucht, Lagerdatum, Lage' +
        'rId, SyncId, BonNr, Preisebene)'
      
        '   Values(:Firma, :JOURNALId, :Datum, :Zeit, :KellnerId, :KasseI' +
        'd, :Menge, :Betrag, :ArtikelId, :BeilagenId, :ZahlwegId, :Offene' +
        'TischId, :JournalTyp, :Verbucht, :Text, :VonOffeneTischId, :Rech' +
        'nungsId, :Nachlass, :Bankomat, :Lagerverbucht, :Lagerdatum, :Lag' +
        'erId, :SyncId, :BonNr, :Preisebene)'
      'matching (Firma, JOURNALId)')
    Left = 912
    Top = 408
    ParamData = <
      item
        Name = 'FIRMA'
        ParamType = ptInput
      end
      item
        Name = 'JOURNALID'
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
        Name = 'KELLNERID'
        ParamType = ptInput
      end
      item
        Name = 'KASSEID'
        ParamType = ptInput
      end
      item
        Name = 'MENGE'
        ParamType = ptInput
      end
      item
        Name = 'BETRAG'
        ParamType = ptInput
      end
      item
        Name = 'ARTIKELID'
        ParamType = ptInput
      end
      item
        Name = 'BEILAGENID'
        ParamType = ptInput
      end
      item
        Name = 'ZAHLWEGID'
        ParamType = ptInput
      end
      item
        Name = 'OFFENETISCHID'
        ParamType = ptInput
      end
      item
        Name = 'JOURNALTYP'
        ParamType = ptInput
      end
      item
        Name = 'VERBUCHT'
        ParamType = ptInput
      end
      item
        Name = 'TEXT'
        ParamType = ptInput
      end
      item
        Name = 'VONOFFENETISCHID'
        ParamType = ptInput
      end
      item
        Name = 'RECHNUNGSID'
        ParamType = ptInput
      end
      item
        Name = 'NACHLASS'
        ParamType = ptInput
      end
      item
        Name = 'BANKOMAT'
        ParamType = ptInput
      end
      item
        Name = 'LAGERVERBUCHT'
        ParamType = ptInput
      end
      item
        Name = 'LAGERDATUM'
        ParamType = ptInput
      end
      item
        Name = 'LAGERID'
        ParamType = ptInput
      end
      item
        Name = 'SYNCID'
        ParamType = ptInput
      end
      item
        Name = 'BONNR'
        ParamType = ptInput
      end
      item
        Name = 'PREISEBENE'
        ParamType = ptInput
      end>
  end
  object QueryDeleteJournal: TFDQuery
    Connection = ConnectionFelix
    SQL.Strings = (
      'delete from Journal j where j.datum = :Datum')
    Left = 832
    Top = 480
    ParamData = <
      item
        Name = 'DATUM'
        ParamType = ptInput
      end>
  end
end
