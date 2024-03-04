object Event: TEvent
  Height = 402
  Width = 825
  object OEBBConnection: TFDConnection
    Params.Strings = (
      'Protocol=Local'
      'DriverID=FB'
      'User_Name=sysdba'
      'Password=masterkey')
    Left = 56
    Top = 16
  end
  object QueryGetEvents: TFDQuery
    Connection = OEBBConnection
    SQL.Strings = (
      'select se.datum,se.datumbis, g.Nachname, ra.Bezeichnung, sr.*'
      'from seminar se'
      
        'left outer join seminarreservierung sr on sr.Firma = se.Firma an' +
        'd sr.Gruppennr = se.ReservId'
      
        'left outer join Raum ra on ra.Firma = sr.Firma and ra.Id = se.ra' +
        'umid'
      
        'left outer join gaestestamm g on g.Firma = sr.Firma and g.Id = s' +
        'r.gastadresseId'
      'where sr.firma = :firma and'
      
        '(sr.storniert is null or (sr.Storniert = '#39'F'#39')) and se.datum <= :' +
        'Beginn and se.datumbis >= :Ende'
      'and ((se.raumid > 0) and not (se.raumid is null))'
      ''
      ''
      
        '--select se.datum,se.datumbis, sr.*, ra.Bezeichnung, sd.seminarl' +
        'eiter, g.Nachname'
      '--from seminarreservierung sr'
      
        '--left outer join Raum ra on ra.Firma = sr.Firma and ra.Id = sr.' +
        'zimmerid'
      
        '--left outer join seminar se on se.firma = sr.firma and se.reser' +
        'vid = sr.id'
      
        '--left outer join seminardetail sd on sd.firma = sr.Firma and sd' +
        '.seminarid = se.Id'
      
        '--left outer join gaestestamm g on g.Firma = sr.Firma and g.Id =' +
        ' sr.gastadresseId'
      '--where sr.firma = :firma and'
      
        '--se.datumbis >= :Ende and se.datum <= :Beginn and (sr.storniert' +
        ' is null or (sr.Storniert = '#39'F'#39'))'
      '--and ((sr.ZimmerId > 0) and not (sr.ZimmerId is null))'
      ''
      ''
      '')
    Left = 52
    Top = 87
    ParamData = <
      item
        Name = 'FIRMA'
        ParamType = ptInput
      end
      item
        Name = 'BEGINN'
        ParamType = ptInput
      end
      item
        Name = 'ENDE'
        ParamType = ptInput
      end>
  end
  object QueryGetReservData: TFDQuery
    Connection = OEBBConnection
    SQL.Strings = (
      
        'select n.land, s.sprache, rc.short_description,rc.room_type, r.*' +
        ', g.* from Reservierung r'
      
        'left outer join gaestestamm g on g.id = r.gastadresseid and r.Fi' +
        'rma = g.firma'
      
        'left outer join room_rooms rr on rr.lookup_company_id = r.Firma ' +
        'and rr.room_number = r.zimmerid'
      
        'left outer join room_categories rc on rc.lookup_company_id = r.f' +
        'irma and rc.id = rr.room_category_id'
      
        'left outer join sprache s on s.firma = g.firma and s.id = g.spra' +
        'cheid'
      
        'left outer join nation n on n.firma = r.Firma and n.id = g.natio' +
        'nalid'
      'where r.id = :ReservId and r.Firma = :Firma')
    Left = 164
    Top = 87
    ParamData = <
      item
        Name = 'RESERVID'
        ParamType = ptInput
      end
      item
        Name = 'FIRMA'
        ParamType = ptInput
      end>
  end
  object QueryCheckGast: TFDQuery
    Connection = OEBBConnection
    SQL.Strings = (
      'select * from gaestestamm g where :pGastID=g.id')
    Left = 48
    Top = 152
    ParamData = <
      item
        Name = 'PGASTID'
        ParamType = ptInput
      end>
  end
  object QueryCheckSeminarRes: TFDQuery
    Connection = OEBBConnection
    SQL.Strings = (
      'select * from seminarreservierung r where r.id = :pReservid')
    Left = 168
    Top = 152
    ParamData = <
      item
        Name = 'PRESERVID'
        ParamType = ptInput
      end>
  end
  object QueryParticipant: TFDQuery
    Connection = OEBBConnection
    Left = 272
    Top = 152
  end
  object QueryInsertTemp: TFDQuery
    Connection = OEBBConnection
    Left = 48
    Top = 224
  end
  object QueryInsertSeminarRes: TFDQuery
    Connection = OEBBConnection
    Left = 168
    Top = 216
  end
  object QueryTemp: TFDQuery
    Connection = OEBBConnection
    Left = 272
    Top = 216
  end
  object QueryCheckEvent: TFDQuery
    Connection = OEBBConnection
    Left = 368
    Top = 152
  end
  object QueryInsertSeminar: TFDQuery
    Connection = OEBBConnection
    Left = 368
    Top = 216
  end
  object QueryInsertGast: TFDQuery
    Connection = OEBBConnection
    SQL.Strings = (
      
        'Insert into Gaestestamm (id, Firma, Marktsegmentid, IndKundennr,' +
        '   spracheid, GASTKZ9ID,  nachname,  NachnameGross, '
      
        ' Vorname,  Zusatzname, Titel, EMail,  Hobbies,      Website,    ' +
        ' Reisepass,      TELEFONBUERO, Mobil, Ort)'
      'VALUES'
      
        '(:Gastid, 1, :Marktsegmentid, :IndKundennr, :Sprachid, :GastkZ9I' +
        'D, :Nachname, :NachnameGross, '
      
        ' :Vorname, :Zusatzname, :Titel, :Email, :Hobbies, :Website, :Rei' +
        'sepass, :TelBuero,  :Mobil, :Ort); ')
    Left = 464
    Top = 152
    ParamData = <
      item
        Name = 'GASTID'
        ParamType = ptInput
      end
      item
        Name = 'MARKTSEGMENTID'
        ParamType = ptInput
      end
      item
        Name = 'INDKUNDENNR'
        ParamType = ptInput
      end
      item
        Name = 'SPRACHID'
        ParamType = ptInput
      end
      item
        Name = 'GASTKZ9ID'
        ParamType = ptInput
      end
      item
        Name = 'NACHNAME'
        ParamType = ptInput
      end
      item
        Name = 'NACHNAMEGROSS'
        ParamType = ptInput
      end
      item
        Name = 'VORNAME'
        ParamType = ptInput
      end
      item
        Name = 'ZUSATZNAME'
        ParamType = ptInput
      end
      item
        Name = 'TITEL'
        ParamType = ptInput
      end
      item
        Name = 'EMAIL'
        ParamType = ptInput
      end
      item
        Name = 'HOBBIES'
        ParamType = ptInput
      end
      item
        Name = 'WEBSITE'
        ParamType = ptInput
      end
      item
        Name = 'REISEPASS'
        ParamType = ptInput
      end
      item
        Name = 'TELBUERO'
        ParamType = ptInput
      end
      item
        Name = 'MOBIL'
        ParamType = ptInput
      end
      item
        Name = 'ORT'
        ParamType = ptInput
      end>
  end
  object QueryUpdateGast: TFDQuery
    Connection = OEBBConnection
    SQL.Strings = (
      'update gaestestamm g'
      'set g.hobbies = :pKostenstelle,'
      '    g.zusatzname= :pZusatzname,'
      '    g.vorname = :pVorname,'
      '    g.Nachname = :pNachname'
      'where'
      ' g.id= :pGastid')
    Left = 464
    Top = 216
    ParamData = <
      item
        Name = 'PKOSTENSTELLE'
        ParamType = ptInput
      end
      item
        Name = 'PZUSATZNAME'
        ParamType = ptInput
      end
      item
        Name = 'PVORNAME'
        ParamType = ptInput
      end
      item
        Name = 'PNACHNAME'
        ParamType = ptInput
      end
      item
        Name = 'PGASTID'
        ParamType = ptInput
      end>
  end
  object QuerySeminarGenID: TFDQuery
    Connection = OEBBConnection
    Left = 48
    Top = 280
  end
  object QueryUpdateReservState: TFDQuery
    Connection = OEBBConnection
    Left = 456
    Top = 88
  end
  object QueryselectReserv: TFDQuery
    Connection = OEBBConnection
    SQL.Strings = (
      'select * from Reservierung where Id = :ReservId')
    Left = 168
    Top = 280
    ParamData = <
      item
        Name = 'RESERVID'
        ParamType = ptInput
      end>
  end
  object QueryInsertReservJournal: TFDQuery
    Connection = OEBBConnection
    SQL.Strings = (
      
        'insert into reservierungsjournal (firma, reservid, datum, zeit, ' +
        'journaltyp, gastname, buchart, kategorieid, zimmerid, anreise, a' +
        'breise, gesamtpreis)'
      
        'values (:firma, :reservid, :datum, :zeit, :journaltyp, :gastname' +
        ', :buchart, :kategorieid, :zimmerid, :anreise, :abreise, :gesamt' +
        'preis)')
    Left = 296
    Top = 280
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
        Name = 'DATUM'
        ParamType = ptInput
      end
      item
        Name = 'ZEIT'
        ParamType = ptInput
      end
      item
        Name = 'JOURNALTYP'
        ParamType = ptInput
      end
      item
        Name = 'GASTNAME'
        ParamType = ptInput
      end
      item
        Name = 'BUCHART'
        ParamType = ptInput
      end
      item
        Name = 'KATEGORIEID'
        ParamType = ptInput
      end
      item
        Name = 'ZIMMERID'
        ParamType = ptInput
      end
      item
        Name = 'ANREISE'
        ParamType = ptInput
      end
      item
        Name = 'ABREISE'
        ParamType = ptInput
      end
      item
        Name = 'GESAMTPREIS'
        ParamType = ptInput
      end>
  end
  object QueryCheckinTelefon: TFDQuery
    Connection = OEBBConnection
    SQL.Strings = (
      'update room_telephone_statuses rts'
      'set rts.checkin = '#39'T'#39','
      'rts.change_checkin = '#39'T'#39','
      'rts.checkin_pos = '#39'T'#39','
      'rts.change_checkin_pos = '#39'T'#39','
      'rts.checkin_tv = '#39'T'#39','
      'rts.change_checkin_tv = '#39'T'#39','
      'rts.name = :Name'
      'where id ='
      '(select rt.Id from room_telephones rt'
      
        'inner Join room_rooms rr on rr.id = rt.room_room_id and rr.looku' +
        'p_company_id = :Firma'
      'where rr.room_number = :ZimmerId)')
    Left = 432
    Top = 280
    ParamData = <
      item
        Name = 'NAME'
        ParamType = ptInput
      end
      item
        Name = 'FIRMA'
        ParamType = ptInput
      end
      item
        Name = 'ZIMMERID'
        ParamType = ptInput
      end>
  end
  object QueryGetFelixDate: TFDQuery
    Connection = OEBBConnection
    SQL.Strings = (
      'select felixdate from diverses where firma = :Firma')
    Left = 272
    Top = 88
    ParamData = <
      item
        Name = 'FIRMA'
        ParamType = ptInput
      end>
  end
  object QueryApparate: TFDQuery
    Connection = OEBBConnection
    SQL.Strings = (
      'SELECT * FROM Telefonapparate'
      'WHERE Firma = :Firma and ZimmerID = :ZimmerID')
    Left = 576
    Top = 152
    ParamData = <
      item
        Name = 'FIRMA'
        ParamType = ptInput
      end
      item
        Name = 'ZIMMERID'
        ParamType = ptInput
      end>
  end
  object QueryUpdateApperate: TFDQuery
    Connection = OEBBConnection
    Left = 584
    Top = 88
  end
  object QueryGetArrangemntArticle: TFDQuery
    Connection = OEBBConnection
    SQL.Strings = (
      
        'select r.id as ReservId,r.anreisedatum, r.abreisedatum, l.leistu' +
        'ngsbezeichnung, l.id as leistId,ar.menge, ar.preiskategorie,'
      
        'sum(r.Erwachsene) AS erwachsene, sum(r.KinderKategorie1) as Kind' +
        '1, sum(r.KinderKategorie2) as Kind2,sum(r.KinderKategorie3) as K' +
        'ind3,sum(r.KinderKategorie4) as Kind4,sum(r.KinderKategorie5) as' +
        ' Kind5,sum(r.KinderKategorie6) as Kind6'
      'from ArrangementLeistungen ar'
      
        'inner join leistungen l on l.id = ar.leistungsid  and l.firma = ' +
        'ar.Firma'
      
        'inner join reservierung r on r.arrangementid = ar.arrangementid ' +
        'and r.firma = ar.Firma'
      'where r.checkin = '#39'T'#39' and ar.Firma = :Firma'
      
        'Group By r.id,r.anreisedatum, r.abreisedatum, l.leistungsbezeich' +
        'nung, l.id,ar.menge, ar.preiskategorie,'
      
        '        r.Erwachsene, KinderKategorie1, KinderKategorie2, Kinder' +
        'Kategorie3, KinderKategorie4, KinderKategorie5, KinderKategorie6'
      'order by r.Id')
    Left = 560
    Top = 280
    ParamData = <
      item
        Name = 'FIRMA'
        ParamType = ptInput
      end>
  end
  object QueryCheckEventByName: TFDQuery
    Connection = OEBBConnection
    SQL.Strings = (
      'select * from gaestestamm g  where g.Nachname = :pEventName')
    Left = 576
    Top = 216
    ParamData = <
      item
        Name = 'PEVENTNAME'
        ParamType = ptInput
      end>
  end
  object QueryGetUID: TFDQuery
    Connection = OEBBConnection
    SQL.Strings = (
      'select first(1) id, kco.uniquenumber  from key_card_online kco'
      'where kco.reservid = :Id'
      'order by ID desc')
    Left = 48
    Top = 344
    ParamData = <
      item
        Name = 'ID'
        ParamType = ptInput
      end>
  end
  object QueryCheckReserv: TFDQuery
    Connection = OEBBConnection
    SQL.Strings = (
      'select * from Reservierung where Id = :Id and Firma = :Firma')
    Left = 152
    Top = 344
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
  object QueryGetReservDataForKeyCard: TFDQuery
    Connection = OEBBConnection
    SQL.Strings = (
      
        'select r.id, g.Id as GuestId, g.vorname, g.nachname, r.zimmerid,' +
        ' r.anreisedatum, r.abreisedatum  from reservierung r'
      
        'inner join gaestestamm g on g.firma = r.Firma and g.Id = r.gasta' +
        'dresseid'
      
        'where (r.checkin = '#39'T'#39') and (r.Firma = :Firma) and (r.Id in (sel' +
        'ect ReservId from key_card_online)) and (r.anreisedatum <= curre' +
        'nt_date and r.abreisedatum >= current_date)'
      'order by r.ID')
    Left = 296
    Top = 344
    ParamData = <
      item
        Name = 'FIRMA'
        ParamType = ptInput
      end>
  end
  object QueryGetNewReservPAck: TFDQuery
    Connection = OEBBConnection
    SQL.Strings = (
      'select max(Id) as Id, ReservId from LOG_RESERVARRANGEMENT'
      'where IsSend is null or IsSend = '#39'F'#39' and Firma = :FId'
      'group by ReservId')
    Left = 464
    Top = 344
    ParamData = <
      item
        Name = 'FID'
        ParamType = ptInput
      end>
  end
  object QuerySetArrSend: TFDQuery
    Connection = OEBBConnection
    SQL.Strings = (
      'update LOG_RESERVARRANGEMENT set IsSend = '#39'T'#39' where Id = :Id')
    Left = 592
    Top = 344
    ParamData = <
      item
        Name = 'ID'
        ParamType = ptInput
      end>
  end
  object QueryGetLogArrId: TFDQuery
    Connection = OEBBConnection
    SQL.Strings = (
      'select id from LOG_RESERVARRANGEMENT where ReservId = :RId')
    Left = 704
    Top = 344
    ParamData = <
      item
        Name = 'RID'
        ParamType = ptInput
      end>
  end
  object QueryGetReservDates: TFDQuery
    Connection = OEBBConnection
    SQL.Strings = (
      'select * from Reservierung where id = :RID and Firma = :Firma')
    Left = 704
    Top = 288
    ParamData = <
      item
        Name = 'RID'
        ParamType = ptInput
      end
      item
        Name = 'FIRMA'
        ParamType = ptInput
      end>
  end
end
