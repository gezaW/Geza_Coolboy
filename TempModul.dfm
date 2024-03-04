object TM: TTM
  Height = 728
  Width = 1123
  object QueryGetOpenTable: TFDQuery
    Connection = MainConnection
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
  object QueryFelix: TFDQuery
    Connection = MainConnection
    ResourceOptions.AssignedValues = [rvParamCreate]
    ResourceOptions.ParamCreate = False
    Left = 40
    Top = 125
  end
  object TableKassa: TFDTable
    Connection = MainConnection
    UpdateOptions.UpdateTableName = 'KASSA'
    TableName = 'KASSA'
    Left = 32
    Top = 345
  end
  object TableKassaZahlweg: TFDTable
    Connection = MainConnection
    UpdateOptions.UpdateTableName = 'KASSAZAHLWEG'
    TableName = 'KASSAZAHLWEG'
    Left = 120
    Top = 345
  end
  object QueryUpdateKassaZahlweg: TFDQuery
    ConnectionName = 'MainConnection'
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
    Connection = MainConnection
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
    Connection = MainConnection
    Left = 392
    Top = 16
  end
  object QuerySetKassenbuch: TFDQuery
    Connection = MainConnection
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
    Connection = MainConnection
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
    Connection = MainConnection
    UpdateOptions.UpdateTableName = 'DIVERSES'
    TableName = 'DIVERSES'
    Left = 224
    Top = 345
  end
  object TableDiverses2: TFDTable
    Connection = MainConnection
    UpdateOptions.UpdateTableName = 'DIVERSES2'
    TableName = 'DIVERSES2'
    Left = 316
    Top = 345
  end
  object insertGastkonto: TFDQuery
    Connection = MainConnection
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
    Connection = MainConnection
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
    Connection = MainConnection
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
    Connection = MainConnection
    SQL.Strings = (
      'INSERT INTO Kassenjournal'
      
        '        --(ID, FIRMA,KASSAID,BEARBEITERID,DATUM,ZEIT,BETRAG,MENG' +
        'E,LEISTUNGSID, BEARBEITERID,'
      '         (FIRMA,KASSAID, DATUM,ZEIT,BETRAG,MENGE,LEISTUNGSID,'
      
        '         ARRANGEMENTID,RESERVID,ZAHLWEGID,BANKLEITZAHL,SCHECKNUM' +
        'MER,BETRAGDEVISEN,'
      '         ERFASSUNGDURCH,TEXT, MWST)'
      '         --TEXT, MWST)'
      'VALUES'
      '        (:FIRMA,:KASSAID,:DATUM,:ZEIT,:BETRAG,:MENGE,'
      '        :LEISTUNGSID,'
      
        '        :ARRANGEMENTID,:RESERVID,:ZAHLWEGID,:BANKLEITZAHL,:SCHEC' +
        'KNUMMER,'
      '        :BETRAGDEVISEN,:ERFASSUNGDURCH,'
      '        :TEXT,:MwSt)')
    Left = 272
    Top = 208
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
    Connection = MainConnection
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
    Connection = MainConnection
    Left = 552
    Top = 208
  end
  object insertGKonto: TFDQuery
    Connection = MainConnection
    Left = 664
    Top = 208
  end
  object QueryCheckLosungKellner: TFDQuery
    Connection = MainConnection
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
    Connection = MainConnection
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
    Connection = MainConnection
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
    Connection = MainConnection
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
    Connection = MainConnection
    Left = 768
    Top = 128
  end
  object TableLosungsZuordnung: TFDTable
    Connection = MainConnection
    UpdateOptions.UpdateTableName = 'KASS_PAYMENTTOFELIX'
    TableName = 'KASS_PAYMENTTOFELIX'
    Left = 416
    Top = 345
  end
  object TableRechZahlweg: TFDTable
    Connection = MainConnection
    UpdateOptions.UpdateTableName = 'RECHNUNGSZAHLWEG'
    TableName = 'RECHNUNGSZAHLWEG'
    Left = 608
    Top = 345
  end
  object TableKreditOffen: TFDTable
    Connection = MainConnection
    UpdateOptions.UpdateTableName = 'KREDITOFFEN'
    TableName = 'KREDITOFFEN'
    Left = 824
    Top = 433
  end
  object TableUmsatzzuordnung: TFDTable
    Connection = MainConnection
    UpdateOptions.UpdateTableName = 'KASS_TURNOVERTOFELIX'
    TableName = 'KASS_TURNOVERTOFELIX'
    Left = 56
    Top = 489
  end
  object TableRechnung: TFDTable
    Connection = MainConnection
    UpdateOptions.UpdateTableName = 'Rechnung'
    TableName = 'Rechnung'
    Left = 176
    Top = 425
  end
  object TableRechnungsKonto: TFDTable
    Connection = MainConnection
    UpdateOptions.UpdateTableName = 'RECHNUNGSKONTO'
    TableName = 'RECHNUNGSKONTO'
    Left = 296
    Top = 433
  end
  object TableZahlweg: TFDTable
    Connection = MainConnection
    UpdateOptions.UpdateTableName = 'ZAHLWEG'
    TableName = 'ZAHLWEG'
    Left = 512
    Top = 345
  end
  object TableArrangement: TFDTable
    Connection = MainConnection
    UpdateOptions.UpdateTableName = 'ARRANGEMENT'
    TableName = 'ARRANGEMENT'
    Left = 384
    Top = 401
  end
  object QueryUniqueNr: TFDQuery
    Connection = MainConnection
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
    Connection = MainConnection
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
    Connection = MainConnection
    SQL.Strings = (
      'create or alter  procedure BOOK_RESTAURANTVALUEBILL ('
      '    ITEXT char(19),'
      '    IFIRMA integer,'
      '    ITISCHNR integer,'
      '    IMWST float,'
      '    IZAHLWEGID integer,'
      '    ITIME date,'
      '    IVALUE float)'
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
        'itzahl)'
      
        '                       VALUES (:ifirma, :oREsult, :vdatum, null ' +
        ', :ivalue, null,  Current_Time, 7, '#39'Kassenrechnung'#39', 1);'
      '        else'
      
        '          INSERT into kassenjournal (firma  , zahlwegid,  datum,' +
        ' menge, betrag, leistungsid, zeit,  erfassungdurch, text)'
      
        '                       VALUES (:ifirma, :oREsult, :vdatum, null ' +
        ', :ivalue, null,  Current_Time, 7, '#39'Kassenrechnung'#39');'
      ''
      
        '         insert into rechnung ( firma,id, erstellerid,rechnungsn' +
        'ummer,adresseid,datum,gedruckt,bezahlt,zahlungsbetrag,bereitsbez' +
        'ahlt)'
      
        '           Values(:ifirma, :vrechid, -1, 0, null, :vdatum, '#39'T'#39', ' +
        #39'T'#39', :ivalue, :ivalue);'
      ''
      
        '         insert into rechnungszahlweg ( firma,RechnungsID,datum,' +
        'zahlwegid, Betrag, Verbucht)'
      
        '           Values(:ifirma, :vrechid, :vdatum, :oREsult, :ivalue,' +
        ' '#39'T'#39');'
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
    Left = 656
    Top = 280
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
      end>
  end
  object FDStoredProcGastKontoRechnung: TFDStoredProc
    Connection = MainConnection
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
      end
      item
        Name = 'iDiscount'
      end>
  end
  object QueryGetTableIdFromReservId: TFDQuery
    Connection = MainConnection
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
    Connection = MainConnection
    SQL.Strings = (
      
        'insert into KASS_KASSENARCHIV (id, firma, tischnr, datum, zeit, ' +
        'betrag, zimmerid, leistungsid, kellnr, reservid, text, kassinfoi' +
        'd)'
      
        'values (:id, :firma, :tischnr, :datum, :zeit, :betrag, :zimmerid' +
        ', :leistungsid, :kellnr, :reservid, :text, :kassinfoid)')
    Left = 56
    Top = 432
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
    Connection = MainConnection
    SQL.Strings = (
      
        'select KASSINFOID from KASS_KASSENARCHIV where KASSINFOID = :KIn' +
        'fId')
    Left = 256
    Top = 488
    ParamData = <
      item
        Name = 'KINFID'
        ParamType = ptInput
      end>
  end
  object QueryTemp: TFDQuery
    Connection = MainConnection
    Left = 448
    Top = 448
  end
  object QueryAnlage: TFDQuery
    Connection = MainConnection
    SQL.Strings = (
      
        'Select Typ from AnlagenTyp where Firma = :Firma and anlage_typ =' +
        ' '#39'Kassen'#39
      'and not Typ = '#39'GMS'#39)
    Left = 592
    Top = 465
    ParamData = <
      item
        Name = 'FIRMA'
        ParamType = ptInput
      end>
  end
  object StoredProcBOOK_RESTAURANTVALUEEXTERN: TFDStoredProc
    Connection = MainConnection
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
      end
      item
        Name = 'IBELEGNUMMER'
        ParamType = ptInput
      end
      item
        Name = 'itischnummer'
      end
      item
        Name = 'iMenge'
        ParamType = ptInput
      end>
  end
  object QueryUpdateOrInsertArtikel: TFDQuery
    Connection = MainConnection
    SQL.Strings = (
      'Update or Insert into Artikel (Firma, ArtikelId, Bezeichnung)'
      'Values(:CompanyId, :ArticleId, :Description)'
      'matching (Firma, ArtikelId)')
    Left = 544
    Top = 409
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
    Connection = MainConnection
    SQL.Strings = (
      'Update or Insert into Kellner (Firma, KellnerId, Nachname)'
      'Values(:CompanyId, :WaiterId, :Surname)'
      'matching (Firma, KellnerId)')
    Left = 688
    Top = 361
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
    Connection = MainConnection
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
    Connection = MainConnection
    TableName = 'KASSENJOURNAL'
    Left = 688
    Top = 441
  end
  object QueryFirma: TFDQuery
    Connection = MainConnection
    SQL.Strings = (
      
        'select fs.firmenname --, ft.titel, ft.text1, ft.text2, ft.text3,' +
        ' ft.text4, ft.text5'
      'from firmenstamm fs'
      '--JOIN firmentext ft on ft.firma=fs.firma')
    Left = 168
    Top = 80
  end
  object QueryInsertSendetMail: TFDQuery
    Connection = MainConnection
    SQL.Strings = (
      
        'insert into Kass_send_Bug_RestServer (Firma,ReservId,sendDay, Te' +
        'xt)'
      'values (:Firma, :ReservId, :sendDay, :Text)')
    Left = 921
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
    Connection = MainConnection
    SQL.Strings = (
      
        'select max(sendDay) as Datum from Kass_send_Bug_RestServer where' +
        ' ReservId = :ReservId')
    Left = 897
    Top = 224
    ParamData = <
      item
        Name = 'RESERVID'
        ParamType = ptInput
      end>
  end
  object QueryUpdateOrInsertJournal: TFDQuery
    Connection = MainConnection
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
    Left = 913
    Top = 377
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
    Connection = MainConnection
    SQL.Strings = (
      'delete from Journal j where j.datum = :Datum')
    Left = 937
    Top = 433
    ParamData = <
      item
        Name = 'DATUM'
        ParamType = ptInput
      end>
  end
  object MainConnection: TFDConnection
    Params.Strings = (
      'Protocol=Local'
      'DriverID=FB'
      'User_Name=sysdba'
      'Password=masterkey')
    Left = 200
    Top = 16
  end
  object QueryLookForDoubleBooking: TFDQuery
    Connection = MainConnection
    SQL.Strings = (
      'select id from KassenJournal k'
      'where k.firma = :CompanyId'
      '    --and k.kassaid = :CashDeskId'
      '    and k.datum = :FelixDate'
      '    --and k.betrag = :Ammount'
      '    and k.text = :Text')
    Left = 400
    Top = 504
    ParamData = <
      item
        Name = 'COMPANYID'
        ParamType = ptInput
      end
      item
        Name = 'FELIXDATE'
        ParamType = ptInput
      end
      item
        Name = 'TEXT'
        ParamType = ptInput
      end>
  end
  object QueryInsertRechnungskonto: TFDQuery
    Connection = MainConnection
    SQL.Strings = (
      
        'insert into Rechnungskonto (Datum, RechnungsId, firma, Leistungs' +
        'Id, Menge, GesamtBetrag, Leistungstext, MWST)'
      
        'values (:Datum, :RechnungsId, :firma, :LeistungsId, :Menge, :Ges' +
        'amtBetrag, :Leistungstext, :pMWST)')
    Left = 592
    Top = 528
    ParamData = <
      item
        Name = 'DATUM'
        ParamType = ptInput
      end
      item
        Name = 'RECHNUNGSID'
        ParamType = ptInput
      end
      item
        Name = 'FIRMA'
        ParamType = ptInput
      end
      item
        Name = 'LEISTUNGSID'
        ParamType = ptInput
      end
      item
        Name = 'MENGE'
        ParamType = ptInput
      end
      item
        Name = 'GESAMTBETRAG'
        ParamType = ptInput
      end
      item
        Name = 'LEISTUNGSTEXT'
        ParamType = ptInput
      end
      item
        Name = 'PMWST'
        ParamType = ptInput
      end>
  end
  object QueryGetDoubleBookingInvoice: TFDQuery
    Connection = MainConnection
    SQL.Strings = (
      
        'select id from Rechnungskonto r where r.leistungsid = :Leistungs' +
        'ID and r.gesamtbetrag = :GesamtBetrag and r.leistungstext = :Lei' +
        'stungsText and r.datum = :Datum and Firma = :Firma '
      'and RechnungsID= :pRechId')
    Left = 768
    Top = 512
    ParamData = <
      item
        Name = 'LEISTUNGSID'
        ParamType = ptInput
      end
      item
        Name = 'GESAMTBETRAG'
        ParamType = ptInput
      end
      item
        Name = 'LEISTUNGSTEXT'
        ParamType = ptInput
      end
      item
        Name = 'DATUM'
        ParamType = ptInput
      end
      item
        Name = 'FIRMA'
        ParamType = ptInput
      end
      item
        Name = 'PRECHID'
        ParamType = ptInput
      end>
  end
  object QueryUpdateJournalBetrag: TFDQuery
    Connection = MainConnection
    ResourceOptions.AssignedValues = [rvParamCreate]
    ResourceOptions.ParamCreate = False
    SQL.Strings = (
      'update KassenJournal set Betrag = :pBetrag where Id = :pId')
    Left = 56
    Top = 549
  end
  object QueryIndex: TFDQuery
    Connection = MainConnection
    Left = 944
    Top = 528
  end
  object QueryGetGuestsByDate: TFDQuery
    Connection = MainConnection
    SQL.Strings = (
      
        'select g.id, g.titel, g.vorname,  g.nachname, g.zusatzname,  g.g' +
        'eburtstag, g.geschlecht, g.strasse, g.strasse2, g.plz, g.ort, g.' +
        'email,'
      
        'g.email2, g.email3, g.email4,  g.telefonprivat, g.telefonbuero, ' +
        'g.mobil, g.fax, g.created_at,  g.Updated_at, g.isanonymized,  g.' +
        'bemerkung,'
      
        'a.Anrede, n.ISO_COUNTRY_CODE, s.Name as Sprache, m.Nachname as c' +
        'reated_By, b.Nachname as updated_by'
      'from Gaestestamm g'
      
        'left outer join Anrede a on a.id = g.AnredeId and a.Firma = g.Fi' +
        'rma'
      'left outer join LOOKUP_NATIONS n on n.Id = g.NationalId'
      'left outer join LOOKUP_LANGUAGES s on s.Id = g.SpracheId'
      
        'left outer join Mitarbeiter m on m.id = g.Erstellerid and m.Firm' +
        'a = g.Firma'
      
        'left outer join Mitarbeiter b on b.Id = g.BearbeiterId  and b.Fi' +
        'rma = g.Firma'
      'where'
      '(g.updated_At >= :UpdateTimeStamp'
      'or (g.created_at >= :UpdateTimeStamp))')
    Left = 256
    Top = 568
    ParamData = <
      item
        Name = 'UPDATETIMESTAMP'
        ParamType = ptInput
      end>
  end
  object QueryGetCheckedInGuests: TFDQuery
    Connection = MainConnection
    SQL.Strings = (
      
        'select g.nachname, g.vorname, g.titel, g.zusatzname, g.geburtsta' +
        'g,'
      
        'r.id as reservId,r.gastadresseid as GastId, r.anreisedatum, r.ab' +
        'reisedatum, r.zimmerid,'
      'r.bemerkung2'
      'FROM reservierung r'
      'left  outer join gaestestamm g on g.id = r.gastadresseid'
      
        'left outer join Arrangement a on a.firma = r.firma AND a.id = r.' +
        'arrangementid'
      
        'left outer join room_categories rc on rc.category_number = r.kat' +
        'egorieid and rc.lookup_company_id = :Firma'
      'where r.firma = :Firma'
      
        'and r.buchart in (0,1) and (r.storniert is null or  r.storniert ' +
        '='#39'F'#39')'
      'and r.zimmeranzahl = 1 and r.checkin = '#39'T'#39
      'and r.abreisedatum >= :dateToday'
      'and r.anreisedatum <= :dateToday'
      'and (r.SPERRENEXTRA = '#39'F'#39' or (r.sperrenextra is null))')
    Left = 424
    Top = 576
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
  object QueryInsertRechnung: TFDQuery
    Connection = MainConnection
    SQL.Strings = (
      
        'insert into rechnung (id, firma, erstellerid, rechnungsnummer, a' +
        'dresseid, datum, gedruckt, bezahlt, zahlungsbetrag, bereitsbezah' +
        'lt, nachlass)'
      
        'Values(:pid, :pfirma, -1 , :pRechNr, :pGastId, :pdatum, :pGedruc' +
        'kt, :pBezahlt, :pBetrag, :pBereitsbezahlt, :pDiscount);')
    Left = 552
    Top = 608
    ParamData = <
      item
        Name = 'PID'
        ParamType = ptInput
      end
      item
        Name = 'PFIRMA'
        ParamType = ptInput
      end
      item
        Name = 'PRECHNR'
        ParamType = ptInput
      end
      item
        Name = 'PGASTID'
        ParamType = ptInput
      end
      item
        Name = 'PDATUM'
        ParamType = ptInput
      end
      item
        Name = 'PGEDRUCKT'
        ParamType = ptInput
      end
      item
        Name = 'PBEZAHLT'
        ParamType = ptInput
      end
      item
        Name = 'PBETRAG'
        ParamType = ptInput
      end
      item
        Name = 'PBEREITSBEZAHLT'
        ParamType = ptInput
      end
      item
        Name = 'PDISCOUNT'
        ParamType = ptInput
      end>
  end
  object QueryInsertRechZahlweg: TFDQuery
    Connection = MainConnection
    SQL.Strings = (
      
        'insert into rechnungszahlweg ( firma,RechnungsID,datum,zahlwegid' +
        ', Betrag, Verbucht)    -- reduzieren'
      
        'Values(:pfirma, :prechid, :pdatum, :pZahlwegId, :Betrag, :verbuc' +
        'ht);')
    Left = 704
    Top = 608
    ParamData = <
      item
        Name = 'PFIRMA'
        ParamType = ptInput
      end
      item
        Name = 'PRECHID'
        ParamType = ptInput
      end
      item
        Name = 'PDATUM'
        ParamType = ptInput
      end
      item
        Name = 'PZAHLWEGID'
        ParamType = ptInput
      end
      item
        Name = 'BETRAG'
        ParamType = ptInput
      end
      item
        Name = 'VERBUCHT'
        ParamType = ptInput
      end>
  end
  object QueryGetFelixZahlweg: TFDQuery
    Connection = MainConnection
    SQL.Strings = (
      
        'SELECT ZahlwgIDFelix FROM kass_paymenttofelix WHERE ZahlwgIDKAss' +
        'e = :pZahlwegID ')
    Left = 904
    Top = 600
    ParamData = <
      item
        Name = 'PZAHLWEGID'
        ParamType = ptInput
      end>
  end
  object QueryCheckInvoice: TFDQuery
    Connection = MainConnection
    SQL.Strings = (
      
        'Select Id from RECHNUNG_EXTERNSERVER r where r.INVOICEID = :pInv' +
        'oiceId and r.Firma = :pFirma')
    Left = 88
    Top = 608
    ParamData = <
      item
        Name = 'PINVOICEID'
        ParamType = ptInput
      end
      item
        Name = 'PFIRMA'
        ParamType = ptInput
      end>
  end
  object QueryGetNextInvoiceNumber: TFDQuery
    Connection = MainConnection
    SQL.Strings = (
      
        'select dr.LASTRECHNR +1 as Rechnungsnummer, d.felixdate from DIV' +
        'ERSESRECHNR dr left join diverses d on d.firma = dr.firma where ' +
        'dr.firma = :pFirma')
    Left = 256
    Top = 624
    ParamData = <
      item
        Name = 'PFIRMA'
        ParamType = ptInput
      end>
  end
  object QueryInsertInvoiceForDoubleBooking: TFDQuery
    Connection = MainConnection
    SQL.Strings = (
      'insert into RECHNUNG_EXTERNSERVER (Firma, InvoiceId, RechnungId)'
      'values (:pFirma,:pInvoiceId,:pRechnungId)')
    Left = 416
    Top = 640
    ParamData = <
      item
        Name = 'PFIRMA'
        ParamType = ptInput
      end
      item
        Name = 'PINVOICEID'
        ParamType = ptInput
      end
      item
        Name = 'PRECHNUNGID'
        ParamType = ptInput
      end>
  end
  object QueryInsertKassenjournalDirectInvoice: TFDQuery
    Connection = MainConnection
    SQL.Strings = (
      'INSERT INTO Kassenjournal'
      '         (FIRMA,KASSAID, DATUM,ZEIT,BETRAG,MENGE,LEISTUNGSID,'
      '         RechnungsId,ZAHLWEGID,'
      '         ERFASSUNGDURCH,TEXT, MWST, bankleitzahl)'
      'VALUES'
      '        (:FIRMA,:KASSAID,:DATUM,:ZEIT,:BETRAG,:MENGE,'
      '        :LEISTUNGSID,'
      '        :RechnungsId,:ZAHLWEGID,'
      '        :ERFASSUNGDURCH,'
      '        :TEXT,:MwSt, :pbankleitzahl)')
    Left = 808
    Top = 632
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
        Name = 'RECHNUNGSID'
        ParamType = ptInput
      end
      item
        Name = 'ZAHLWEGID'
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
      end
      item
        Name = 'PBANKLEITZAHL'
        ParamType = ptInput
      end>
  end
  object QueryInsertInvoiceTax: TFDQuery
    Connection = MainConnection
    SQL.Strings = (
      'insert into RECHNUNGSMWST (FIRMA, RECHNUNGSID, MWST, BETRAG)'
      'values (:pCompanyId, :pInvoiceId, :pTax, :pAmount)')
    Left = 992
    Top = 632
    ParamData = <
      item
        Name = 'PCOMPANYID'
        ParamType = ptInput
      end
      item
        Name = 'PINVOICEID'
        ParamType = ptInput
      end
      item
        Name = 'PTAX'
        ParamType = ptInput
      end
      item
        Name = 'PAMOUNT'
        ParamType = ptInput
      end>
  end
  object QueryGetAmountOrderByTax: TFDQuery
    Connection = MainConnection
    SQL.Strings = (
      'select rk.mwst, Sum(rk.Gesamtbetrag) as Gesamtbetrag '
      'from rechnungskonto rk '
      'where rk.rechnungsid = :pInvoiceId'
      'and rk.Firma = :pCompanyId'
      'group by rk.mwst')
    Left = 1016
    Top = 576
    ParamData = <
      item
        Name = 'PINVOICEID'
        ParamType = ptInput
      end
      item
        Name = 'PCOMPANYID'
        ParamType = ptInput
      end>
  end
  object QueryUpdateDIVERSESRECHNR: TFDQuery
    Connection = MainConnection
    SQL.Strings = (
      'Update DIVERSESRECHNR d set d.LastRechnr = :pLastInvoiceNr'
      'where d.Firma = :pCompanyId')
    Left = 1008
    Top = 472
    ParamData = <
      item
        Name = 'PLASTINVOICENR'
        ParamType = ptInput
      end
      item
        Name = 'PCOMPANYID'
        ParamType = ptInput
      end>
  end
  object QueryCheckGuestId: TFDQuery
    Connection = MainConnection
    SQL.Strings = (
      'select * from Gaestestamm where Id = :pID')
    Left = 624
    Top = 664
    ParamData = <
      item
        Name = 'PID'
        ParamType = ptInput
      end>
  end
  object QueryCheckCompanyId: TFDQuery
    Connection = MainConnection
    SQL.Strings = (
      'select * from Diverses where Firma = :pFirma')
    Left = 992
    Top = 120
    ParamData = <
      item
        Name = 'PFIRMA'
        ParamType = ptInput
      end>
  end
  object QueryLeistungByName: TFDQuery
    Connection = MainConnection
    SQL.Strings = (
      'SELECT * FROM Leistungen'
      'WHERE Firma = :Firma AND'
      'LEISTUNGSBEZEICHNUNG = :pLeistBez')
    Left = 1024
    Top = 200
    ParamData = <
      item
        Name = 'FIRMA'
        ParamType = ptInput
      end
      item
        Name = 'PLEISTBEZ'
        ParamType = ptInput
      end>
  end
  object QueryGetServerSettings: TFDQuery
    Connection = MainConnection
    SQL.Strings = (
      'SELECT * FROM Diverses'
      'WHERE Firma = :Firma ')
    Left = 912
    Top = 32
    ParamData = <
      item
        Name = 'FIRMA'
        ParamType = ptInput
      end>
  end
end
