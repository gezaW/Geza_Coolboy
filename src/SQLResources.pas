unit SQLResources;

interface

const
  cSQLGetArticleExtraGroups =
    'SELECT DISTINCT ' +
    '  beilagengruppe.firma AS CompanyID, ' +
    '  beilagengruppe.beilagengruppenid AS ID, ' +
    '  beilagengruppe.bezeichnung AS Description ' +
    'FROM '+
    '  beilagengruppe '+
    'INNER JOIN beilagenuntergruppe ON ((beilagengruppe.firma = beilagenuntergruppe.firma) '+
    '  AND (beilagengruppe.beilagengruppenid = beilagenuntergruppe.beilagengruppeid)) '+
    'WHERE (beilagengruppe.firma = :pCompany) '+
    '  AND (beilagengruppe.bezeichnung > '''') '+
    '  AND (beilagengruppe.beilagengruppenid > 0) '+
    'ORDER BY '+
    '  beilagengruppe.beilagengruppenid;';

  cSQLGetBillTaxes =
    'select * from arrangement_steuer (:CompanyID,:Billid)';

  cSQLGetArticleExtraSubGroup =
    'select b.firma as companyid, b.beilagengruppeid as ArticleExtraGroupID, ' +
    '   b.beilagenid as ArticleExtraID ' +
    'from beilagenuntergruppe b ' +
    ' Order by Reihung, beilagengruppeid, beilagenid';


  cSQLGetCompanyInfo =
    ' select f.titel, trim(f.text1) as text1, trim(f.text2) as text2, trim(f.text3) as Text3, trim(f.text4) as Text4, '+
    ' trim(f.text5) as Text5 ' +
    ' from firmentext f ' +
    '  where f.firma=:companyID   ';


  cSQLGetEinstell =
    ' select * from einstell e ' +
    ' where e.firma = :CompanyID ';



  cSQLGetArticleExtras =
    'SELECT ' +
    '  beilagen.firma AS CompanyID, ' +
    '  beilagen.beilagenid AS ID, ' +
    '  beilagen.bezeichnung AS Description, ' +
    '  beilagen.preisplus AS IncreasePrice, ' +
    '  beilagen.preisminus AS DecreasePrice, ' +
    '  COUNT(*) AS aexgLen ' +
    'FROM ' +
    '  beilagen ' +
    'INNER JOIN beilagenuntergruppe ON ' +
    '  (beilagen.firma = beilagenuntergruppe.firma) ' +
    '  AND (beilagen.beilagenid = beilagenuntergruppe.beilagenid) ' +
    'INNER JOIN beilagengruppe ON' +
    '  (beilagengruppe.firma = beilagenuntergruppe.firma) ' +
    '  AND (beilagengruppe.beilagengruppenid = beilagenuntergruppe.beilagengruppeid) ' +
    'WHERE (beilagen.firma = :pCompanyID) ' +
    '  AND (beilagen.bezeichnung > '''') ' +
    '  AND (beilagen.beilagenid > 0) ' +
    '  AND (beilagengruppe.bezeichnung > '''') ' +
    '  AND (beilagengruppe.beilagengruppenid > 0) ' +
    '  AND (beilagenuntergruppe.beilagengruppeid = DECODE(COALESCE(:articlegroupid, 0), 0, beilagenuntergruppe.beilagengruppeid, COALESCE(:articlegroupid, 0))) ' +
    'GROUP BY ' +
    '  beilagen.firma, ' +
    '   beilagenuntergruppe.reihung,  '+
    '  beilagen.beilagenid, ' +
    '  beilagen.bezeichnung, ' +
    '  beilagen.preisplus, ' +
    '  beilagen.preisminus';

  cSQLGetArticleGroups =
    'SELECT '+
    '  tg.FIRMA AS CompanyID, '+
    '  tg.TASTENGRUPPEID AS ID, '+
    '  tg.BEZEICHNUNG AS Description, '+
    '  tg.REIHUNGFUNKI AS Posi, '+
    '  tg.FARBE AS Color '+
    'FROM '+
    '  tastengruppe tg '+
    '  LEFT OUTER JOIN tastengruppekassen tgk ON tgk.tastengruppeid = tg.tastengruppeid '+
    'WHERE '+
    '  (tg.FIRMA = :pCompanyID) '+
    '  AND (tg.TASTENGRUPPEID > 0) '+
    '  AND (coalesce(tg.inaktiv,''F'')=''F'') '+
    '  AND ((tg.Bezeichnung <> '''') AND NOT (tg.Bezeichnung IS NULL)) '+
    '  AND ((tgk.kassennr IS NULL) OR (tgk.kassennr = :pCashRegisterID)) '+
    'ORDER BY '+
    '  REIHUNGFUNKI, BEZEICHNUNG';

  cSQLCheckLanguageDefinition = 'select * from LanguageDefinition';

  cSQLCheckIfGeneratorExists =
    ' SELECT ' +
    '  RDB$GENERATOR_NAME ' +
    ' FROM RDB$GENERATORS r ' +
    ' where r.rdb$generator_name=:pGeneratorName ';

   cSQLCheckIfTriggerExists =
    ' SELECT ' +
    '  RDB$TRIGGER_NAME ' +
    ' FROM RDB$TRIGGERS r ' +
    ' where r.rdb$TRIGGER_NAME=:pTriggerName ';


  cSQLCheckDBTable =
    ' SELECT ' +
    '  RDB$RELATION_NAME FROM RDB$RELATIONS ' +
    ' WHERE RDB$RELATION_NAME = UPPER(:pTable) ';

 cSQLGenerator_SignatureID =
  ' CREATE GENERATOR GEN_SIGNATUREID';

 cSQLCreatTableZen_Signature =
  ' CREATE TABLE HOTEL_SIGNATURE ( ' +
  '   ID              KINTEGER NOT NULL /* KINTEGER = INTEGER */,   ' +
  '   COMPANYID       KSMALLINT /* KSMALLINT = SMALLINT */, ' +
  '   SIGNATUREDATE   KDATE /* KDATE = DATE */, ' +
  '   ROOMID          KINTEGER /* KINTEGER = INTEGER */, ' +
  '   WAITERID        KINTEGER /* KINTEGER = INTEGER */, ' +
  '   OPENTABLEID     KINTEGER /* KINTEGER = INTEGER */, ' +
  '   RESERVID        KINTEGER /* KINTEGER = INTEGER */, ' +
  '   SIGNATUREIMAGE  BLOB SUB_TYPE 0 SEGMENT SIZE 80 )';

 cSQLSetPrimaryKey_HotelSignature =
  ' ALTER TABLE HOTEL_SIGNATURE ADD CONSTRAINT PK_HOTEL_SIGNATURE PRIMARY KEY (ID);';

 cSQLCreateZenIndex_HotelSignature =
  ' CREATE INDEX HOTEL_SIGNATURE_IDX1 ON HOTEL_SIGNATURE (RESERVID, ROOMID); ';

 cSQLCreateTriggerZen_HotelSignature =
   ' CREATE OR ALTER TRIGGER HOTEL_SIGNATURE_BI0 FOR HOTEL_SIGNATURE ' +
   ' ACTIVE BEFORE INSERT POSITION 0 ' +
   ' AS ' +
   ' begin ' +
   '  IF (NEW.ID IS NULL) THEN ' +
   '    NEW.ID = GEN_ID(GEN_SIGNATUREID,1); ' +
   ' end ';





 { cSQLGetArticles =
    ' SELECT  ' +
    '  a.FIRMA AS CompanyID,  ' +
    '  a.ARTIKELID AS ID, ' +
    '  iif(coalesce(a.ButtonText1, a.ButtonText2, a.ButtonText3, '''') <> '''', ' +
    '  coalesce(a.ButtonText1, '''') ||  '' '' || coalesce(a.ButtonText2, '''') || ' +
    '  '' '' || coalesce(a.ButtonText3, ''''), a.BEZEICHNUNG) as Description, ' +
    '  t.TASTENGRUPPEID AS ArticleGroupID, ' +
    '  a.BEILAGENGRUPPEID AS ArticleExtraGroupID, ' +
    '  a.MUSSBEILAGEN AS ArticleExtraObligationType,' +
    '  a.PREIS1 AS UnitPrice,' +
    '  a.REIHUNGFUNKI AS Posi,' +
    '  a.Preis1 AS Price1, a.Preis2 AS Price2, a.Preis3 AS Price3, a.Preis4 AS Price4,   ' +
    '  a.Preis5 AS Price5, a.Preis6 AS Price6, a.Preis7 AS Price7, a.Preis8 AS Price8,  ' +
    '  a.Preis9 AS Price9, a.Preis10 AS Price10,+a.Preis11 AS Price11,+a.Preis12 AS Price12, ' +
    '  a.Preis13 AS Price13, a.Preis14 AS Price14,+a.Preis15 AS Price15,+a.Preis16 AS Price16, ' +
    '  a.Preis17 AS Price17, a.Preis18 AS Price18,+a.Preis19 AS Price19,+a.Preis20 AS Price20, ' +
    '  a.Preis21 AS Price21, a.Preis22 AS Price22,+a.Preis23 AS Price23,+a.Preis24 AS Price24, ' +
    '  a.Preis25 AS Price25, a.Preis26 AS Price26,+a.Preis27 AS Price27,+a.Preis28 AS Price28, ' +
    '  a.Preis29 AS Price29, a.Preis30 AS Price30, ' +
    '  a.PersonalPreis AS EmployeePrice,  ' +
    '  a.mengepreis as QuantPrice,' +
    '  iif( t.farbe=0,1,0) as Group_Aktiv,' +
    '  u.bonsort' +
    ' FROM ' +
    '  artikel a ' +
    ' left outer join' +
    '  tastengruppe t on t.firma=a.firma and t.tastengruppeid=a.tastengruppeid ' +
    '  left outer join untergruppe u on u.firma=a.firma and u.untergruppeid=a.untergruppeid '+
    ' WHERE' +
    '  (FIRMA = :pCompanyID)   ' +
    '  AND (coalesce(a.inaktiv,''F'')=''F'') ' +
    '  AND (coalesce(a.nurlager ,''F'')= ''F'') ' +
    '  AND (coalesce(a.Bezeichnung, a.ButtonText1, a.ButtonText2, a.ButtonText3, '''') <> '''') ' +
   // '  and ((coalesce(a.stocklager,''F'')=''F'' ) or (a.stockartikelid>0)) ' +       according to Walter
    '  AND (t.TASTENGRUPPEID > 0)  ' +
    '  AND (coalesce(t.Bezeichnung,'''') <> '''')  ' +
    '  and ( not exists (select * from artikelkassen ak where a.artikelid=ak.artikelid) ' +
    '  or  (exists (select * from artikelkassen ak where a.artikelid=ak.artikelid and ak.kassennr=:cashregisterid))) '+
    ' ORDER BY  ' +
    '  t.TASTENGRUPPEID, Group_Aktiv, posi, a.REIHUNG, a.ARTIKELID';   }


  cSQLGetArticles =
    ' select ' +
      ' FIRMA AS CompanyID, ' +
      ' ARTIKELID AS ID,   ' +
      ' iif(coalesce(ButtonText1, ButtonText2, ButtonText3, '''') <> '''', ' +
      ' coalesce(ButtonText1, '''') ||'' ''|| coalesce(ButtonText2, '''') || ' +
      ' '' '' || coalesce(ButtonText3, ''''), BEZEICHNUNG) as Description, ' +
      ' Bezeichnung as articlename, ArticleGroupID,  ' +
      ' BEILAGENGRUPPEID AS ArticleExtraGroupID, ' +
      ' MUSSBEILAGEN AS ArticleExtraObligationType,   ' +
      ' PREIS1 AS UnitPrice,  ' +
      // 19.03.2019 KL: #20381 included reihungfunki from artikel_sort
      ' coalesce((select ak.reihungfunki from artikelkassen ak ' +
      '   where (ak.kassennr=:pcashregisterid) and (ak.artikelid=aid)), 0 ) as Posi, ' +
      ' Preis1 AS Price1, Preis2 AS Price2, Preis3 AS Price3, Preis4 AS Price4, ' +
      ' Preis5 AS Price5, Preis6 AS Price6, preis7 AS Price7, Preis8 AS Price8, ' +
      ' Preis9 AS Price9, Preis10 AS Price10,Preis11 AS Price11,Preis12 AS Price12, ' +
      ' Preis13 AS Price13, Preis14 AS Price14,Preis15 AS Price15,Preis16 AS Price16, ' +
      ' Preis17 AS Price17, Preis18 AS Price18,Preis19 AS Price19,Preis20 AS Price20,  ' +
      ' Preis21 AS Price21, Preis22 AS Price22,Preis23 AS Price23,Preis24 AS Price24,  ' +
      ' Preis25 AS Price25, Preis26 AS Price26,Preis27 AS Price27,Preis28 AS Price28,  ' +
      ' Preis29 AS Price29, Preis30 AS Price30,  ' +
      ' PersonalPreis AS EmployeePrice,   ' +
      ' mengepreis as QuantPrice, bonsort, color, ' +
      ' FavoriteSorting ' +
      ' from    ' +
      '   ( ' + sLineBreak +
      // query for artikel.tastengruppeid
      ' SELECT a.firma, a.artikelid, a.reihung, a.artikelid as aid, a.reihungfunki as afunki, ' +
      '   a.ButtonText1, a.ButtonText2, a.ButtonText3, a.BEZEICHNUNG, BEILAGENGRUPPEID, MUSSBEILAGEN, ' +
      '   a.Preis1, a.Preis2, a.Preis3, a.Preis4, a.Preis5, a.Preis6, a.Preis7, ' +
      '   a.Preis8, a.Preis9, a.Preis10, a.Preis11, a.Preis12, a.Preis13, a.Preis14, ' +
      '   a.Preis15, a.Preis16, a.Preis17, a.Preis18, a.Preis19, a.Preis20, a.Preis21, ' +
      '   a.Preis22, a.Preis23, a.Preis24, a.Preis25, a.Preis26, a.Preis27, a.Preis28, ' +
      '   a.Preis29, a.Preis30, a.PersonalPreis, a.mengepreis, a.color, a.FavoriteSorting, ' +
      ' tg.tastengruppeid as Articlegroupid, u.bonsort ' +
      ' FROM ' +
      '   tastengruppe tg  ' +
      ' LEFT OUTER JOIN tastengruppekassen tgk ON tgk.tastengruppeid = tg.tastengruppeid ' +
      ' left outer join artikel a on tg.firma=a.firma and tg.tastengruppeid= a.tastengruppeid  ' +
      ' left outer join untergruppe u on u.firma=a.firma and u.untergruppeid=a.untergruppeid ' +
      ' WHERE (tg.FIRMA = :pCompanyID) ' +
      '   AND (tg.TASTENGRUPPEID > 0) ' +
      '   AND (coalesce (tg.inaktiv,''F'') <> ''T'') ' +
      '   AND ((tg.Bezeichnung <> '''') AND NOT (tg.Bezeichnung IS NULL)) ' +
      '   AND ((tgk.kassennr IS NULL) OR (tgk.kassennr = :pCashRegisterID)) ' +
      '   AND (coalesce(a.inaktiv,''F'')=''F'') ' +
      '   AND (coalesce(a.vouchertype, 0) = 0) ' +
      '   AND (coalesce(a.nurlager ,''F'')= ''F'') ' +
      '   AND (coalesce(a.Bezeichnung, a.ButtonText1, a.ButtonText2, a.ButtonText3, '''') <> '''') ' +
      '   AND (coalesce(tg.Bezeichnung,'''') <> '''') ' +
      '   and ( not exists (select * from artikelkassen ak where a.artikelid=ak.artikelid and a.firma=ak.firma) ' +
      '        or  (exists (select * from artikelkassen ak where a.artikelid=ak.artikelid and ak.kassennr=:pcashregisterid))) ' +
      // SAME query for artikel.tastengruppeid2
      ' union ' + sLineBreak +
      ' SELECT a.firma, a.artikelid, a.reihung, a.artikelid as aid, a.reihungfunki as afunki, ' +
      '   a.ButtonText1, a.ButtonText2, a.ButtonText3, a.BEZEICHNUNG, BEILAGENGRUPPEID, MUSSBEILAGEN, ' +
      '   a.Preis1, a.Preis2, a.Preis3, a.Preis4, a.Preis5, a.Preis6, a.Preis7, ' +
      '   a.Preis8, a.Preis9, a.Preis10, a.Preis11, a.Preis12, a.Preis13, a.Preis14, ' +
      '   a.Preis15, a.Preis16, a.Preis17, a.Preis18, a.Preis19, a.Preis20, a.Preis21, ' +
      '   a.Preis22, a.Preis23, a.Preis24, a.Preis25, a.Preis26, a.Preis27, a.Preis28, ' +
      '   a.Preis29, a.Preis30, a.PersonalPreis, a.mengepreis, a.color, a.FavoriteSorting, ' +
      ' tg.tastengruppeid as Articlegroupid, u.bonsort ' +
      ' FROM ' +
      '   tastengruppe tg  ' +
      ' LEFT OUTER JOIN tastengruppekassen tgk ON tgk.tastengruppeid = tg.tastengruppeid ' +
      ' left outer join artikel a on tg.firma=a.firma and tg.tastengruppeid= a.tastengruppeid2 ' +
      ' left outer join untergruppe u on u.firma=a.firma and u.untergruppeid=a.untergruppeid ' +
      ' WHERE (tg.FIRMA = :pCompanyID) ' +
      '   AND (tg.TASTENGRUPPEID > 0) ' +
      '   AND (coalesce (tg.inaktiv,''F'') <> ''T'') ' +
      '   AND ((tg.Bezeichnung <> '''') AND NOT (tg.Bezeichnung IS NULL)) ' +
      '   AND ((tgk.kassennr IS NULL) OR (tgk.kassennr = :pCashRegisterID)) ' +
      '   AND (coalesce(a.inaktiv,''F'')=''F'') ' +
      '   AND (coalesce(a.vouchertype, 0) = 0) ' +
      '   AND (coalesce(a.nurlager ,''F'')= ''F'') ' +
      '   AND (coalesce(a.Bezeichnung, a.ButtonText1, a.ButtonText2, a.ButtonText3, '''') <> '''') ' +
      '   AND (coalesce(tg.Bezeichnung,'''') <> '''') ' +
      '   and ( not exists (select * from artikelkassen ak where a.artikelid=ak.artikelid and a.firma=ak.firma) ' +
      '        or  (exists (select * from artikelkassen ak where a.artikelid=ak.artikelid and ak.kassennr=:pcashregisterid))) ' +
      //  SAME query for artikel.tastengruppeid3
      ' union ' + sLineBreak +
      ' SELECT a.firma, a.artikelid, a.reihung, a.artikelid as aid, a.reihungfunki as afunki, ' +
      '   a.ButtonText1, a.ButtonText2, a.ButtonText3, a.BEZEICHNUNG, BEILAGENGRUPPEID, MUSSBEILAGEN, ' +
      '   a.Preis1, a.Preis2, a.Preis3, a.Preis4, a.Preis5, a.Preis6, a.Preis7, ' +
      '   a.Preis8, a.Preis9, a.Preis10, a.Preis11, a.Preis12, a.Preis13, a.Preis14, ' +
      '   a.Preis15, a.Preis16, a.Preis17, a.Preis18, a.Preis19, a.Preis20, a.Preis21, ' +
      '   a.Preis22, a.Preis23, a.Preis24, a.Preis25, a.Preis26, a.Preis27, a.Preis28, ' +
      '   a.Preis29, a.Preis30, a.PersonalPreis, a.mengepreis, a.color, a.FavoriteSorting, ' +
      ' tg.tastengruppeid as Articlegroupid, u.bonsort ' +
      ' FROM ' +
      '   tastengruppe tg  ' +
      ' LEFT OUTER JOIN tastengruppekassen tgk ON tgk.tastengruppeid = tg.tastengruppeid ' +
      ' left outer join artikel a on tg.firma=a.firma and tg.tastengruppeid= a.tastengruppeid3 ' +
      ' left outer join untergruppe u on u.firma=a.firma and u.untergruppeid=a.untergruppeid ' +
      ' WHERE (tg.FIRMA = :pCompanyID) ' +
      '   AND (tg.TASTENGRUPPEID > 0) ' +
      '   AND (coalesce (tg.inaktiv,''F'') <> ''T'') ' +
      '   AND ((tg.Bezeichnung <> '''') AND NOT (tg.Bezeichnung IS NULL)) ' +
      '   AND ((tgk.kassennr IS NULL) OR (tgk.kassennr = :pCashRegisterID)) ' +
      '   AND (coalesce(a.inaktiv,''F'')=''F'') ' +
      '   AND (coalesce(a.vouchertype, 0) = 0) ' +
      '   AND (coalesce(a.nurlager ,''F'')= ''F'') ' +
      '   AND (coalesce(a.Bezeichnung, a.ButtonText1, a.ButtonText2, a.ButtonText3, '''') <> '''') ' +
      '   AND (coalesce(tg.Bezeichnung,'''') <> '''') ' +
      '   and ( not exists (select * from artikelkassen ak where a.artikelid=ak.artikelid and a.firma=ak.firma) ' +
      '        or  (exists (select * from artikelkassen ak where a.artikelid=ak.artikelid and ak.kassennr=:pcashregisterid))) ' +
      ' ) ' + sLineBreak +
      ' order by articlegroupid, posi, afunki, REIHUNG, artikelid  ' ;
      // 14.10.2019 KL: added "afunki" laut WH (Stiegl)

  cSQLGetTableGroups =
    'SELECT DISTINCT ' +
    '  r.ID, ' +
    '  r.NAME AS Description, ' +
    '  r.REIHUNG AS Posi ' +
    'FROM REVIERE r ' +
    '  JOIN REVIERGRUPPE rg ON ' +
    '    r.ID = rg.REVIERID ' +
    'ORDER BY ' +
    '  r.REIHUNG, r.NAME, r.ID;';

//  the problem is that the list()-function cannot be ordered!
//  see https://firebirdsql.org/refdocs/langrefupd21-aggrfunc-list.html
//  The ordering of the list values is undefined.
//  cSQLGetStationList =
//    ' select id, name, list(tischid) as tableid from (  ' +
//    ' select r.id, r.name,r.reihung as Areasort, rg.tischid, rg.reihung as tablesort from reviere r   ' +
//    ' left outer join reviergruppe rg on rg.revierid=r.id ' +
//    ' order by r.reihung, rg.reihung  ) ' +
//    ' group by Areasort, id, name ' +
//    ' order by Areasort, id ';

  cSQLGetStationListStations =
    ' select r.id, r.name, r.id as tableid from reviere r ' +
    ' order by r.reihung, r.id; ';

  cSQLGetStationListTables =
    ' select rg.tischid from reviergruppe rg ' +
    ' where rg.revierid = :pID ' +
    ' order by rg.reihung, rg.tischid ';

  cSQLGetPaymentMethods =
    'SELECT ' +
    '  z.ID, ' +
    '  z.BEZEICHNUNG AS DESCRIPTION, ' +
    '  z.SORTIERNUMMER AS POSI ' +
    'FROM '+
    '  ZAHLWEG z '+
    'WHERE '+
    '  z.Firma = :pCompanyID ' +
    '  and ((z.inaktiv is null) or (z.inaktiv=''F'')); ';

  cSQLGetTables =
    'SELECT ' +
    '  t.firma, '+
    '  t.TISCHID AS ID, ' +
    '  TISCHNR AS TableNumber, ' +
    '  BEZEICHNUNG AS Description, ' +
    '  TISCHTYP AS TableType, ' +
    '  Obertischid AS MainTableID, '+
    '  Tischgruppeid AS TableGroupID,coalesce(t.preisebene,0) as pricelevel, '+
    '  iif(t.obertischid is null, t.reihung,' +
    '      (select t2.reihung from tisch t2 where t2.tischid=t.obertischid))  AS Posi ' +
    'FROM ' +
    '  TISCH t ' +
    '  LEFT JOIN TischeKassen tk ON tk.Firma = t.Firma AND tk.TischID = t.TischID ';

  cSQLGetWaiters =
    'SELECT ' +
    '  KELLNERID  AS ID, '+
    '  LOGINNAME  AS LoginName, '+
    '  NACHNAME   AS LastName, '+
    '  VORNAME    AS FirstName, '+
    '  RECHTEMAIN   AS AccessRight, '+
    '  RECHTEBONIER AS BillRight, '+
    '  coalesce(k.spracheid, 1) AS LanguageID, ' +
    '  LANG.DLLNAME AS LANGUAGE ' +
    'FROM ' +
    '  KELLNER K'+
    '  LEFT OUTER JOIN LANGUAGEDEFINITION AS LANG ON LANG.SPRACHEID = coalesce(K.SPRACHEID, 1) ' +
    '    AND LANG.FIRMA = :pCompanyID ' +
    'WHERE ' +
    '  (K.FIRMA = :pCompanyID) ' +
    '  AND (KELLNERID > 0) ' +
    '  AND ((INAKTIV = ''F'') OR (INAKTIV IS NULL)) ' +
    '  AND ((DATENANLAGE = ''F'') OR (DATENANLAGE IS NULL)) ' +
    '  AND (LOGINNAME > '''') ' +
    'ORDER BY ' +
    '  KELLNERID;';

  cSQLGetOpenTables =
    ' with base as (  ' +
    '   select ot.tischid, ' +
    '   (select first 1 ot1.offenetischid from offenetische ot1 where ' +
    '     ot1.tischid=ot.tischid and ot1.offen=''T'' order by ot1.datum desc ) as opentableid,   ' +
    '   t.tischtyp,  t.OBERTISCHID AS MainTableID, t.bezeichnung    ' +
    ' FROM' +
    ' offenetische ot   ' +
    ' left outer JOIN TISCH  t ON  ' +
    '   t.firma = ot.firma AND t.tischid = ot.tischid   ' +
    ' left outer join Tischekassen tka on      ' +
    '   tka.firma=t.firma and tka.tischid= t.tischid ' +
    ' WHERE ' +
    '  ot.OFFEN=''T''   ' +
//    '  AND ( (t.tischtyp=''S'') or (t.tischtyp=''G'') or (t.tischtyp=''P'') or (t.tischtyp=''W'') ' +
//    '  or (t.tischtyp=''B'') or (t.tischtyp=''L'') or (t.tischtyp=''Z'')   )  ' +

    // 19.09.2019 KL: #23895 exclude normal tables here
    '  AND ( (t.tischtyp is null) or (t.tischtyp<>'''') )  ' +

    '  AND (tka.kassenNr is null or tka.kassenNr = :pCashRegisterID)   ' +
    '  group by ot.tischid, t.tischtyp,t.OBERTISCHID , t.bezeichnung )    ' +
    ' select  ot2.tischid AS TableID, base.bezeichnung, ' +
    '   round(COALeSCE(SUM(tk.betrag*tk.menge),0),2) AS Total,' +
    '   ot2.kellnerid as FirstWaiterID,   ' +
    '   ot2.currentwaiterid,  ot2.OFFENETISCHID as OpenTableID,  base.MainTableID, ot2.datum ' +
    ' from base ' +
    ' left outer join  offenetische ot2 on ot2.offenetischid= base.opentableid    ' +
    ' left outer JOIN TISCHKONTO  tk ON       ' +
    '    tk.firma = ot2.firma AND tk.offenetischid = ot2.offenetischid   ' +
    ' GROUP BY   ' +
    '   ot2.tischid,  ot2.OFFENETISCHID, ot2.kellnerid, currentwaiterid, ot2.datum, base.MainTableID, base.bezeichnung, ot2.datum   ' +

    ' union  ' +
    ' SELECT  ' +
    '  ot.tischid AS TableID, t.bezeichnung, ' +
    '  round(COALeSCE(SUM(tk.betrag*tk.menge),0),2) AS Total,  ' +
    '  ot.kellnerid as FirstWaiterID,  ot.currentwaiterid, ot.OFFENETISCHID as OpenTableID,    ' +
    '  t.OBERTISCHID AS MainTableID, ot.datum ' +
    ' FROM  ' +
    '   offenetische ot ' +
    ' left outer JOIN TISCHKONTO  tk ON ' +
    '   tk.firma = ot.firma AND tk.offenetischid = ot.offenetischid ' +
    ' left outer JOIN TISCH  t ON ' +
    '   t.firma = ot.firma AND t.tischid = ot.tischid ' +
    ' left outer join Tischekassen tka on ' +
    '   tka.firma=t.firma and tka.tischid= t.tischid ' +
    ' WHERE  ' +
    '   ot.OFFEN=''T''  ' +
    '   AND (ot.DATUM=:pDate) ' +
    '   and ((t.tischtyp is null) or (t.tischtyp = '''')) ' +
    '   AND (tka.kassenNr is null or tka.kassenNr = :pCashRegisterID)     ' +
    ' GROUP BY  ' +
    '   ot.tischid, t.OBERTISCHID, ot.OFFENETISCHID, ot.kellnerid, currentwaiterid, ot.datum, t.bezeichnung ';


  cSQLGetStorageTableID =
    ' SELECT ot.offeneTischID, ot.TischID  ' +
    ' FROM OffeneTische ot LEFT OUTER join Tisch t on ot.Firma = t.Firma AND t.TischId = ot.TischID' +
    ' WHERE t.TischTyp = "L" AND' +
    ' ot.OFFEN = "T" AND ot.Firma = 1 ';

  cSQLGetWaiterLanguage =
    ' select coalesce(k.spracheid,1) as languageid ' +
    ' from kellner k   ' +
    ' where k.kellnerid=:waiterid ';

  cSQLGetWaiterInfoForLogin =
    'SELECT ' +
    '  k.kellnerid AS Waiterid, ' +
    '  k.schluesselnr AS WaiterKeyNr, ' +
    '  k.nachname AS Lastname, ' +
    '  k.vorname AS Firstname, ' +
    '  k.loginname, ' +
    '  k.rechtebonier as WaiterRights, ' +
    '  k.passwort AS Password, ' +
    '  k.preisebene AS PriceLevel, ' +
    '  k.lagertischid as storagetableid,  ' +
    '  coalesce(k.spracheid, 1) AS LanguageID, ' +
    '  LANG.DLLNAME AS LANGUAGE ' +
    'FROM ' +
    '  kellner k ' +
    'LEFT OUTER JOIN LANGUAGEDEFINITION LANG ON LANG.SPRACHEID = coalesce(K.SPRACHEID, 1) ' +
    'WHERE ' +
    ' coalesce(k.datenanlage,''F'')=''F'' and  k.loginname = :UserName and coalesce(k.inaktiv,''F'')=''F'';';

  cSQLSetGuest=
     ' update or insert into GAESTESTAMM ' +
     ' (ID, FIRMA, ERSTELLERID, BEARBEITERID, ERSTELLUNGSDATUM, AENDERUNGSDATUM, NACHNAME, ' +
     ' VORNAME, ZUSATZNAME, ANREDEID, BRIEFANREDE, GEBURTSTAG, TITEL, STRASSE, ' +
     ' STRASSE2, PLZ, ORT, NATIONALID, SPRACHEID, TELEFONPRIVAT, TELEFONBUERO, MOBIL, FAX, ' +
     ' EMAIL,  UID) ' +
     ' values (:ID, :CompanyID, :creatorID, :Editorid, :CreationDate, :EditingDate, :LastNAME, :FirstNAME, :ExtraNAME, ' +
     ' :Titelid, :Salutation, :Birthday, :Degree, :STREET, :STREET2, :ZIPCode, :City, :NATIONALID, ' +
     ' :LanguageID, :phoneprivate, :phoneoffice, :MOBIL, :FAX, :EMAIL, :UID) ' +
     ' matching (ID)';

  cSQLGetFelixVerson =
    ' select d.v11 as V12 from diverses d where d.firma= :companyID ';

  cSQLInsertGUID =
    ' insert into ZEN_DEVICEUSAGE (LOGIN_DATE, GUID) ' +
    ' values ( current_timestamp, :GUID)';

  cSQLCheckGUID =
   ' SELECT * ' +
   ' FROM zen_deviceusage ' +
   ' WHERE login_date  between :DateFrom and :DateTo  and guid=:GUID ';

  cSQLCheckDeviceUsageNotReported =
    ' SELECT '+
    '   extract(year from z.login_date) as YYYY, '+
    '   extract(month from z.login_date) as MM, '+
    '   z.guid, '+
    '   count(*) as Anzahl '+
    ' FROM zen_deviceusage z '+
    ' WHERE z.login_date < :DateTo  and z.reported_date is NULL '+
    ' group BY yyyy, mm, z.guid ';

  cSQLUpdateReportDate =
    ' update ZEN_DEVICEUSAGE set reported_date = current_timestamp ' +
    ' where (reported_date is NULL) and (login_date < :DateTo) ';

  cSQLCheckTableIfExists=
    'select * from tisch t where t.firma=:CompanyID and t.tischid=:TableID';

  cSQLGetWaiter =
    'SELECT ' +
    '  KELLNERID  AS ID, '+
    '  LOGINNAME  AS LoginName, '+
    '  NACHNAME   AS LastName, '+
    '  VORNAME    AS FirstName, '+
    '  RECHTEMAIN   AS AccessRight, '+
    '  RECHTEBONIER AS BillRight, '+
    '  PREISEBENE AS PriceLevel, ' +
    '  coalesce(k.spracheid, 1) AS LanguageID, ' +
    '  LANG.DLLNAME AS LANGUAGE ' +
    'FROM ' +
    '  KELLNER K '+
    'LEFT OUTER JOIN LANGUAGEDEFINITION LANG ON LANG.SPRACHEID = coalesce(K.SPRACHEID, 1) ' +
    'WHERE ' +
    '  (k.FIRMA = :CompanyID) ' +
    '  AND (KELLNERID = :WaiterID) ';

  cSQLInsertOpenTable =
    'INSERT INTO OffeneTische ' +
    '(Firma, TischID, Bezeichnung, Datum, Offen, KellnerID, CurrentwaiterID)' +
    'VALUES ' +
    '(:CompanyID, :TableID, :Description, :Date, :Open, :WaiterID, :CurrentwaiterID) ' +
    ' returning OFFENETISCHID {into :Opentableid}';

  cSQLCheckOpenTableAmount =
    ' SELECT ' +
    '   t.offenetischid as opentableid, sum(t.menge* t.betrag) as Total ' +
    ' FROM   tischkonto t ' +
    ' WHERE ' +
    '   OffeneTischID = :OpenTableID ' +
    ' GROUP by opentableid ' ;


  cSQLCheckOpenTable =
    ' Select t.tischnr as tableNo, t.tischtyp as tableType, ' +
    ' ot.kellnerid as waiterid, ot.offen as isOpen, ot.tischid as tableid ' +
    ' from OffeneTische ot' +
    ' left outer join tisch t on ot.tischid=t.tischid ' +
    ' Where ' +
    ' firma = :CompanyID and ' +
    ' OffeneTischID = :OpenTableID';

  cSQLGetHappyHour =
    ' Select * from HappyHour';

  cSQLGetTableAccountArticle =
    'SELECT ' +
    '  tk.tischkontoid as TableAccountID, ' +
    '  ot.offenetischid as OpenTableID, ' +
    '  tk.artikelid as articleID, ' +
    '  tk.menge as Quantity, ' +
    '  tk.betrag as Price, ' +
    '  tk.roomno as RoomNo, ' +
    '  tk.kellnerid as WaiterID, ' +
    '  tk.beilagenid1 as ArticleExtra1ID, ' +
    '  tk.beilagenid2 as ArticleExtra2ID, ' +
    '  tk.beilagenid3 as ArticleExtra3ID, ' +
    '  tk.BeilagenText as ArticleExtraText, ' +
    '  iif(coalesce(a.ButtonText1, a.ButtonText2, a.ButtonText3, '''') <> '''', ' +
    '      trim(coalesce(a.ButtonText1, '''') ||  '' '' || coalesce(a.ButtonText2, '''') ||   '' '' || coalesce(a.ButtonText3, '''')), ' +
    '      a.BEZEICHNUNG) as Description, ' +
    '  a.bezeichnung as articlename, ' +
    '  a.BEILAGENGRUPPEID as ArticleExtrasGroupID, ' +
    '  ug.bonsort, ' +
    '  (SELECT first 1 ' +
    '    iif(coalesce(x.tischkontoid, tk.tischkontoid) = (tk.tischkontoid+1), ''T'', ''F'') ' +
    '    from tischkonto x ' +
    '    WHERE (x.tischkontoid > tk.tischkontoid) ' +
    '      and (x.artikelid is null) ' +
    '    order by x.firma, x.tischkontoid ' +
    '  ) as hasExtras ' +
    'FROM offenetische ot ' +
    '  left outer JOIN TISCHKONTO AS tk ON   tk.firma = ot.firma AND tk.offenetischid = ot.offenetischid ' +
    '  left outer join artikel as a on a.artikelid = tk.artikelid and a.firma = tk.firma ' +
    '  left outer join untergruppe as ug on a.firma = ug.firma and a.untergruppeid = ug.untergruppeid ' +
    'WHERE (ot.offenetischid = :OpenTableID) ' +
    '  and (not tk.artikelid is null) ';

  cSQLSetHotelType =
    'update einstell e ' +
    'set e.hotelprogrammtyp = :HotelType ';

  cSQLGetTableAccountArticleExtras =
    'SELECT ' +
    '  tk.tischkontoid as Tableaccountid, ' +
    '  ot.offenetischid as OpenTableID, ' +
    '  tk.artikelid as articleID, ' +
    '  tk.menge as Quantity, ' +
    '  tk.betrag as Price, ' +
    '  tk.kellnerid, ' +
    '  tk.Beilagenid1 as ArticleExtraID1, ' +
    '  tk.Beilagenid2 as ArticleExtraID2, ' +
    '  tk.Beilagenid3 as ArticleExtraID3, ' +
    '  tk.BeilagenText as ArticleExtraText, ' +
    '  b1.preisplus as increaseprice1, b1.preisminus as decreaseprice1, ' +
    '  b2.preisplus as increaseprice2, b2.preisminus as decreaseprice2, ' +
    '  b3.preisplus as increaseprice3, b3.preisminus as decreaseprice3 ' +
    'FROM offenetische ot ' +
    '  left outer join tischkonto tk on tk.firma = ot.firma AND tk.offenetischid = ot.offenetischid ' +
    '  left outer join beilagen b1 on b1.firma = tk.firma AND b1.beilagenid = tk.beilagenid1 ' +
    '  left outer join beilagen b2 on b2.firma = tk.firma AND b2.beilagenid = tk.beilagenid2 ' +
    '  left outer join beilagen b3 on b3.firma = tk.firma AND b3.beilagenid = tk.beilagenid3 ' +
    'WHERE ot.offenetischid=:OpenTableID ' +
    '  and tk.artikelid is null ' +
    '  and tk.tischkontoid > :MainTableAccountID ' +
    '  and tk.tischkontoid < coalesce( ' +
    '    (SELECT first 1 x.tischkontoid from tischkonto x ' +
    '      WHERE (x.tischkontoid > :MainTableAccountID) ' +
    '        and (not x.artikelid is null) ' +
    '      order by x.firma, x.tischkontoid), ' +
    '    coalesce( ' +
    '      (SELECT first 1 y.tischkontoid from tischkonto y ' +
    '        WHERE (y.offenetischid = :OpenTableID) ' +
    '          and (y.tischkontoid > :MainTableAccountID) ' +
    '          and (y.artikelid is null) ' +
    '        order by y.firma, y.tischkontoid desc), ' +
    '      :MainTableAccountID) +1 ) ' +
    'ORDER by tk.firma, tk.tischkontoid ';

  cSQLGetTitels =
    'select a.id, a.anrede as titel, a.spracheid as languageid from anrede a ' +
    'where a.firma = :companyid ';

  cSQLGetVoucherTypes =
    ' select l.id, l.leistungsbezeichnung as VoucherName, l.preis as Price ' +
    ' from leistungen l where l.gutschein=''T'' and coalesce(l.inaktiv,''F'')=''F'' and l.firma=:pCompanyID';

  cSQLTableIsLocked =
    'update offenetische o set o.offenetischid= :opentableid where o.offenetischid =:opentableid';

  cSQLInsertVoucherZEN =
    '  insert into VORAUSZAHLUNG ' +
    '  (ID, FIRMA, DATUM, BETRAG, artikelid, GASTID, GUTSCHEIN, ' +
    '    TEXT, RECHNUNGSGUTSCHEINID, GUTSCHEINTEXT) ' +
    '  values ' +
    '  (:ID, :companyid, :selldate, :amount, :articleid, :guestid, ''T'',:vouchernumber, :Sellbillid, :Vouchertext )';

   cSQLInsertVoucherFelix =
    '  insert into VORAUSZAHLUNG ' +
    '  (ID, FIRMA, DATUM, BETRAG, leistungsid, GASTID, GUTSCHEIN, ' +
    '    TEXT, RECHNUNGSGUTSCHEINID, GUTSCHEINTEXT) ' +
    '  values ' +
    '  (:ID, :companyid, :selldate, :amount, :articleid, :guestid, ''T'',:vouchernumber, :Sellbillid, :Vouchertext )';


  cSQLGetCountryCodes =
    ' select n.id, n.land, n.landcode from nation n ' +
    ' where n.firma = :pCompanyID';

  cSQLSetAllOpenTablesClosed =
    'update offenetische ot set ot.offen = ''F''  where NOT exists (select Null from tisch t where ot.tischid=t.tischid and t.tischtyp=''L'')';

  cSQLGetGuests = '  Select ' +
                  '  ID, FIRMA as companyid, ERSTELLERID as creatorid, BEARBEITERID as editorid, ' +
                  '  ERSTELLUNGSDATUM as creationdate, AENDERUNGSDATUM as editingdate, NACHNAME as Lastname, ' +
                  '  VORNAME as firstname, ZUSATZNAME as extraname, ANREDEID as titelid, BRIEFANREDE as salutation, ' +
                  '  GEBURTSTAG as birthday, TITEL as degree, STRASSE as street, ' +
                  '  STRASSE2 as street2, PLZ as zipcode, ORT as city, NATIONALID, SPRACHEID as languageid, ' +
                  '  TELEFONPRIVAT as phoneprivate, TELEFONBUERO as phoneoffice, MOBIL, FAX, ' +
                  '  EMAIL, UID from gaestestamm g ' +
                  ' where (1=1)';


  //before the unit tests
  cSQLDeleteAllTableAccounts =
    ' delete from tischkonto';

  cSQLSetEinstellBeforeTest =
    ' update einstell e  ' +
    ' set e.passwortabfrage = ''T'', ' +
    ' e.hotelprogrammtyp= 4, ' +
    ' e.BONNUMBERONHOTEL =''T'', '+
    ' e.hoteleinzelnbuchen=''F''';

  cSQLGetVoucherCashRegister =
    ' select vz.Betrag as Amount, vz.Datum as DateofSell, vz.Text, a.bezeichnung as VoucherType, ' +
    ' g.Nachname as lastname, g.Vorname as firstname, g.Ort as city, g.PLZ as Zipcode,  vz.gutscheintext as vouchertext, ' +
    ' vz.Firma as companyid' +
    ' from vorauszahlung vz  ' +
    ' left outer join gaestestamm g on g.id = vz.gastid  ' +
    ' left outer join artikel a on a.firma=vz.firma and a.artikelid=vz.artikelid  ' +
    ' where vz.gutschein=''T'' and vz.datumbezahlt is null';

  cSQLGetVoucherFelix =
    ' select vz.Betrag as Amount, vz.Datum as DateofSell, vz.Text, l.Leistungsbezeichnung as VoucherType, ' +
    ' g.Nachname as lastname, g.Vorname as firstname, g.Ort as city, g.PLZ as Zipcode, vz.gutscheintext as vouchertext, ' +
    ' vz.Firma as companyid ' +
    ' from vorauszahlung vz ' +
    ' left outer join gaestestamm g on g.id = vz.gastid ' +
    ' left outer join leistungen l on l.firma=vz.firma and l.id=vz.leistungsid ' +
    ' where vz.gutschein=''T'' and vz.datumbezahlt is null';

  cSQLGetOpenTable =
    'SELECT ' +
    '  ot.offenetischid as OpenTableiD, '+
    '  ot.tischid AS TableID, ' +
    '  COALeSCE(SUM(tk.menge),0) AS Total, ' +
    '  ot.kellnerid as FirstWaiterID, ' +
    '  ot.currentwaiterid ' +
    'FROM ' +
    '  offenetische ot ' +
    '  left outer JOIN TISCHKONTO AS tk ON ' +
    '    tk.firma = ot.firma AND tk.offenetischid = ot.offenetischid '+
    '  left outer JOIN TISCH AS t ON ' +
    '    t.firma = ot.firma AND t.tischid = ot.tischid ' +
    'WHERE ' +
    '   ot.offenetischid =:OpentableID '+
    'GROUP BY ' +
    ' OpenTableiD,  ot.tischid, ot.kellnerid, currentwaiterid;';

  cSQLCheckTableColumn=
    ' SELECT ' +
    '   RDB$RELATION_FIELDS.RDB$FIELD_NAME AS NAME ' +
    ' FROM RDB$RELATION_FIELDS ' +
    ' WHERE ' +
    '   RDB$RELATION_FIELDS.RDB$RELATION_NAME = UPPER(:pTable)' +
    ' AND RDB$RELATION_FIELDS.RDB$FIELD_NAME = UPPER(:pColumn) ';

  // 09.04.2019 KL: #22288 "RT" is always null, so changed to "coalesce(RT, ZI_Nummer)"
  cSQLGetCashRegisterRoom =
    ' SELECT Distinct(ZI_Nummer) AS RoomNo, Termin_Nr AS ReservID, zi_pers AS GuestsName, Pers_Nr as GuestID, coalesce(RT, ZI_Nummer) AS RoomID ' +
    ' FROM Gastinfo ';

  cSQLGetLastBillIDFromTableID =
    ' SELECT r.ID from rechnung ' +
    ' LEFT OUTER JOIN OffeneTische ot ON r.ReservID = ot.offeneTischID AND r.Firma = ot.Firma ' +
    ' LEFT OUTER JOIN Tisch t         ON ot.TischID = t.TischID AND ot.Firma = t.Firma ' +
    ' WHERE r.Gedruckt = ''T'' AND r.Datum = :pDate AND r.Firma = :pCompanyID ' +
    ' AND r.ErstellerID = :pWaiterID AND (t.TischID = :pTableID) ' +
    ' ORDER BY r.id ';

  cSQLInsertIntoKassInfo =
    ' insert into KASSINFO (PERS_NR, TERMIN_NR, KURZBEZ, DATUM, PREIS, SUMME, ANZAHL, STEUER, LOG_T, LOG_K, ARTIKELID, ' +
    ' KASSEID, ZEIT) ' +
    ' values ' +
    ' ( :PERS_NR, :TERMIN_NR, :KURZBEZ, :DATUM, :PREIS, :SUMME, :ANZAHL, :STEUER, :LOG_T, :LOG_K, :ARTIKELID, ' +
    ' :KASSEID, :ZEIT) ';

  cSQLGetFelixReservid =
    'select gen_id(id,1)    FROM RDB$DATABASE;';

  cSQLGetFelixRoom =
    ' select first 1 z.id as Roomid, z.zimmerNr as RoomNo, z.kategorieid as CategoryID ' +
    ' from zimmer z where z.firma=1';

  cSQLGetFelixRooms =
    ' SELECT r.ID as Reservid, trim(left(r.Gastname,25)) as GuestsName, r.GastadresseID as GuestID, r.ZimmerID as RoomID, ' +
    ' z.ZimmerNr as RoomNo ' +
    ' FROM Reservierung r ' +
    ' left outer JOIN Zimmer z ON (r.FIRMA = z.FIRMA) and (r.ZIMMERID = z.ID)  ' +
    ' WHERE (r.CheckIn = ''T'') and COALESCE(r.abgereist,''F'')=''F'' ' +
    ' AND (r.SperrenExtra = ''F'' OR r.SperrenExtra IS NULL) ' +
    ' AND (r.Firma = :FelixCompanyID) ';


  cSQLSetOpenTableClosed =
    'UPDATE '+
    '  offenetische ot '+
    'SET '+
    '  ot.offen = ''F'''+
    'WHERE '+
    '  ot.offenetischid =:OpentableID ';

  cSQLGetQRCode =
    ' select first 1 fr.receiptid, fs.data as QRCode from ft_receipt fr  ' +
    ' left outer join ft_signatureitems fs on fs.ft_receipt_id=fr.id ' +
    '  where fr.receiptid=:billid';

  cSQLGetArticleExtraName =
    ' select * from beilagen b where b.firma= :Company and b.beilagenid= :ArticleExtraID';

  cSQLGetTableID =
    ' Select o.tischid as TableID from offenetische o where o.offenetischid= :OpenTableID and o.offen=''T''';

  cSQLGetArticleIDfromRoomnumber =
    ' Select artikelid from artikel where bezeichnung = :pRoomnumber ';
  cSQLGetRoomnumberFromArticleID =
    ' Select bezeichnung from artikel where artikelid = :pArticleID ';

  cSQLGetArticleStocklagerID =
    ' select a.stocklager, a.stockartikelid from artikel a where a.artikelid= :particleid  and a.firma=:pCompanyID';

  cSQLInsertIntoTableAccount =
    'INSERT INTO Tischkonto ' +
    ' (Firma, OffeneTischID, Datum, ArtikelID, Menge, Betrag, KellnerID, KasseID, Gedruckt, Verbucht,' +
    '  BeilagenID1, BeilagenID2,BeilagenID3, Beilagentext, RoomNo)' +
    'VALUES ' +
    ' (:Company, :OpenTableID, :pDate, :ArticleID, :Quantity, :price, :WaiterID, :CashRegisterID, :Printed, :booked,' +
    '  :ArticleExtraID1,:ArticleExtraID2,:ArticleExtraID3, :FreeText, :RoomNo)';


  cSQLDeleteHelpTableAccount=
    ' DELETE from HILF_TISCHKONTO' +
    ' WHERE offenetischid=:OpenTableID ';

  cSQLInsertBill=
     'INSERT INTO Rechnung ' +
     '  (Firma, ID, ReservID, Datum, Rechnungsnummer, ErstellerID, ' +
     '   ZahlungsBetrag, BereitsBezahlt, Bezahlt, Gedruckt, Nachlass, AdresseID,VorausRechnungKz) ' +
     'VALUES ' +
     '  (:CompanyID, :BillID, :ReservID, :pDate, :BillNr, :WaiterID, ' +
     '   :TotalAmount, :PaymentAmount, :paid, :printed, :reduction, :AddressID, :PreInvoiceCode) ';

    cSQLInsertPayment=
      'INSERT INTO RechnungsZahlweg ' +
      '  (Firma, RechnungsID, Datum, ZahlwegID, Betrag, Verbucht, TransactionNumber) ' +
      'VALUES (:CompanyID, :BillID, :pDate, :PaymentID, :Amount, :booked, :TransactionNumber)';

    cSQLInsertIntoJournal=
      'INSERT INTO JOURNAL ' +
      ' (Firma, KellnerID, OffeneTischID, Datum, Zeit, KasseID, ' +
      ' JournalTyp, Text, Menge, ZahlwegID, Betrag, ArtikelID, ' +
      ' BeilagenID, VonOffeneTischID, RechnungsID, Nachlass, Bankomat, BonNr) ' +
      'VALUES ' +
      ' (:CompanyID, :WaiterID, :OpenTableID, :pDate, :pTime, :CashRegisterID, ' +
      ' :JournalType, :Text, :Quantity, :PaymentID, :Amount, :ArticleID, ' +
      ' :ArticleExtraID, :FromOpenTableID, :BillID, :Reduction, :Bankomat, :SlipNr)';

    cSQLGetTableAccountByTableAccountID =
      'SELECT       ' +
      '  tk.tischkontoid as TableAccountID, '+
      '  ot.offenetischid as OpenTableID, ' +
      '  tk.artikelid as articleID, ' +
      '  tk.menge as Quantity, tk.betrag as Price, tk.kellnerid as WaiterID, '+
      '  tk.beilagenid1 as ArticleExtraID1, tk.beilagenid2 as ArticleExtraID2, tk.beilagenid3 as ArticleExtraID3, '+
      '  tk.BeilagenText as FreeText, tk.gangid as courseid '+
      'FROM ' +
      '  offenetische ot ' +
      '  left outer JOIN TISCHKONTO AS tk ON ' +
      '  tk.firma = ot.firma AND tk.offenetischid = ot.offenetischid '+
      'WHERE  1=1 ';

    cSQLGetFelixDate =
      ' SELECT d.felixdate FROM diverses d WHERE d.firma=:CompanyID ';

    cSQLGetHelpTableBGroupByTax =
      'WITH TAXING AS (                                                                                        '+
      '  SELECT                                                                                                '+
      '    ART.ARTIKELID AS ARTIKELID                                                                          '+
      '    ,TAX.MWST AS TAX                                                                                    '+
      '    ,TAX.ID AS TAXID                                                                                    '+
      '  FROM                                                                                                  '+
      '    ARTIKEL ART                                                                                         '+
      '  LEFT OUTER JOIN                                                                                       '+
      '    UNTERGRUPPE SUBGROUP                                                                                '+
      '    ON SUBGROUP.FIRMA = ART.FIRMA AND ART.UNTERGRUPPEID = SUBGROUP.UNTERGRUPPEID                        '+
      '  LEFT OUTER JOIN                                                                                       '+
      '    HAUPTGRUPPE MAINGROUP                                                                               '+
      '    ON MAINGROUP.FIRMA = SUBGROUP.FIRMA AND SUBGROUP.HAUPTGRUPPEID = MAINGROUP.HAUPTGRUPPEID            '+
      '  LEFT OUTER JOIN                                                                                       '+
      '    STEUER TAX                                                                                          '+
      '    ON MAINGROUP.FIRMA = TAX.FIRMA  AND MAINGROUP.STEUERID = TAX.ID                                     '+
      '  WHERE                                                                                                 '+
      '    ART.FIRMA = :PCOMPANYID                                                                             '+
      ') /* END OF WITH  */                                                                                    '+
      'SELECT                                                                                                  '+
      '  HT.FIRMA AS COMPANYID                                                                                 '+
      '  ,1 AS QUANTITY                                                                                        '+
      '  ,HT.OFFENETISCHID AS OPENTABLEID                                                                      '+
      '  ,SUM(HT.BETRAG*HT.MENGE) AS PRICE                                                                     '+
      '  ,TAXING1.TAX AS TAX1, TAXING1.TAXID AS TAXID1                                                         '+
      '  ,SUM(HT.MENGE*A.ARTIKELPREISID2) AS ARTICLEPRICE2, TAXING2.TAX AS TAX2, TAXING2.TAXID AS TAXID2       '+
      '  ,SUM(HT.MENGE*A.ARTIKELPREISID3) AS ARTICLEPRICE3, TAXING3.TAX AS TAX3, TAXING3.TAXID AS TAXID3       '+
      '  ,SUM(HT.MENGE*A.ARTIKELPREISID4) AS ARTICLEPRICE4, TAXING4.TAX AS TAX4, TAXING4.TAXID AS TAXID4       '+
      '  ,SUM(HT.MENGE*A.ARTIKELPREISID5) AS ARTICLEPRICE5, TAXING5.TAX AS TAX5, TAXING5.TAXID AS TAXID5       '+
      '  ,SUM(HT.MENGE*A.ARTIKELPREISID6) AS ARTICLEPRICE6, TAXING6.TAX AS TAX6, TAXING6.TAXID AS TAXID6       '+
      '  ,SUM(HT.MENGE*A.ARTIKELPREISID7) AS ARTICLEPRICE7, TAXING7.TAX AS TAX7, TAXING7.TAXID AS TAXID7       '+
      '  ,SUM(HT.MENGE*A.ARTIKELPREISID8) AS ARTICLEPRICE8, TAXING8.TAX AS TAX8, TAXING8.TAXID AS TAXID8       '+
      '  ,SUM(HT.MENGE*A.ARTIKELPREISID9) AS ARTICLEPRICE9, TAXING9.TAX AS TAX9, TAXING9.TAXID AS TAXID9       '+
      '  ,SUM(HT.MENGE*A.ARTIKELPREISID10) AS ARTICLEPRICE10, TAXING10.TAX AS TAX10, TAXING10.TAXID AS TAXID10 '+
      'FROM                                                                                                    '+
      '  HILF_TISCHKONTO HT                                                                                    '+
      'LEFT OUTER JOIN ARTIKEL A ON HT.ARTIKELID=A.ARTIKELID AND HT.FIRMA=A.FIRMA                              '+
      'LEFT OUTER JOIN TAXING TAXING1 ON TAXING1.ARTIKELID = HT.ARTIKELID                                      '+
      'LEFT OUTER JOIN TAXING TAXING2 ON TAXING2.ARTIKELID = A.ARTIKELID2                                      '+
      'LEFT OUTER JOIN TAXING TAXING3 ON TAXING3.ARTIKELID = A.ARTIKELID3                                      '+
      'LEFT OUTER JOIN TAXING TAXING4 ON TAXING4.ARTIKELID = A.ARTIKELID4                                      '+
      'LEFT OUTER JOIN TAXING TAXING5 ON TAXING5.ARTIKELID = A.ARTIKELID5                                      '+
      'LEFT OUTER JOIN TAXING TAXING6 ON TAXING6.ARTIKELID = A.ARTIKELID6                                      '+
      'LEFT OUTER JOIN TAXING TAXING7 ON TAXING7.ARTIKELID = A.ARTIKELID7                                      '+
      'LEFT OUTER JOIN TAXING TAXING8 ON TAXING8.ARTIKELID = A.ARTIKELID8                                      '+
      'LEFT OUTER JOIN TAXING TAXING9 ON TAXING9.ARTIKELID = A.ARTIKELID9                                      '+
      'LEFT OUTER JOIN TAXING TAXING10 ON TAXING10.ARTIKELID = A.ARTIKELID10                                   '+
      'WHERE                                                                                                   '+
      '  OFFENETISCHID = :POPENTABLEID                                                                         '+
      '  AND FIRMA = :PCOMPANYID                                                                               '+
      '  AND HT.BETRAG <> 0                                                                                    '+
      'GROUP BY                                                                                                '+
      '  COMPANYID                                                                                             '+
      '  ,OPENTABLEID                                                                                          '+
      '  ,TAX1, TAXID1                                                                                         '+
      '  ,TAX2, TAXID2                                                                                         '+
      '  ,TAX3, TAXID3                                                                                         '+
      '  ,TAX4, TAXID4                                                                                         '+
      '  ,TAX5, TAXID5                                                                                         '+
      '  ,TAX6, TAXID6                                                                                         '+
      '  ,TAX7, TAXID7                                                                                         '+
      '  ,TAX8, TAXID8                                                                                         '+
      '  ,TAX9, TAXID9                                                                                         '+
      '  ,TAX10, TAXID10                                                                                       ';

{     'SELECT ' +
     '  ht.Firma as CompanyID, sum(ht.Betrag*ht.menge) as Price, 1 as Quantity,' +
     '  ht.OffeneTischID as OpenTableID, s.mwst as Tax, s.Id as TaxID ' +
     'FROM Hilf_Tischkonto ht ' +
     '  LEFT OUTER JOIN artikel a on ht.artikelid=a.artikelid and ht.firma=a.firma  ' +
     '  LEFT OUTER JOIN untergruppe u on a.untergruppeid=u.untergruppeid and u.firma=a.firma  ' +
     '  LEFT OUTER JOIN hauptgruppe h on u.hauptgruppeid=h.hauptgruppeid and h.firma=u.firma  ' +
     '  LEFT OUTER JOIN steuer s on h.steuerid=s.id and h.firma=s.firma ' +
     'WHERE OffeneTischID = :pOpenTableID ' +
     '  AND Firma = :pCompanyID AND ht.betrag <> 0   ' +
     'GROUP BY CompanyID, OpenTableID, tax,taxid';
}

   cSQLGetTransferArticleId =
      ' SELECT T.LeistungsID as ArticleID, L.LeistungsBezeichnung as ArticleName, s.mwst as Tax FROM Tischzuordnung T' +
      ' LEFT OUTER JOIN leistungen L ON T.leistungsid = L.id AND L.Firma = :pCompanyID ' +
      ' left outer join  Steuer s on s.firma=l.firma and s.id=l.mwstid ' +
      ' WHERE T.TischVon <= :pTableNo AND T.TischBis >= :pTableNo';

   cSQLGetFelixArticleByTable  =
      ' SELECT T.LeistungsID as ArticleID, L.LeistungsBezeichnung as ArticleName, s.mwst as Tax FROM Tischzuordnung T' +
      ' LEFT OUTER JOIN leistungen L ON T.leistungsid = L.id AND L.Firma = :pCompanyID ' +
      ' left outer join  MehrwertSteuer s on s.firma=l.firma and s.id=l.mwstid ' +
      ' WHERE T.TischVon <= :pTableNo AND T.TischBis >= :pTableNo';


    cSQLGetFelixArticleByChashregisterID =
       ' SELECT ' +
       '   k.LeistungsID as ArticleID, L.LeistungsBezeichnung as ArticleName, s.mwst as Tax   ' +
       ' FROM ' +
       '  kass_tischzuordnung k ' +
       ' LEFT OUTER JOIN leistungen L ON k.leistungsid = L.id AND L.Firma = :pCompanyID  ' +
       ' left outer join  MehrwertSteuer s on s.firma=l.firma and s.id=l.mwstid  WHERE k.TischVon <= :pTableNo AND k.TischBis >= :pTableNo ';

    cSQLInsertIntoFelixJournal =
      ' INSERT INTO Kassenjournal  ' +
      ' (FIRMA,DATUM,ZEIT,BETRAG,MENGE,LEISTUNGSID, ' +
      ' RESERVID,ERFASSUNGDURCH,TEXT) ' +
      ' VALUES ' +
      ' (:CompanyID,:pDate,:pTime,:Price,:Quantity,:ArticleID, ' +
      ' :RESERVID,:createdby,:TEXT) ';

    cSQLInsertIntoHotelLog =
      ' INSERT into HOTELLOG ' +
      ' (FIRMA, DATUM, TEXT, KELLNERID, VONTISCHID, PERS_NR, TERMIN_NR, ZIMMER_NR, RESERVID) ' +
      ' values ' +
      ' ( :CompanyID, :pDATE, :TEXT, :WAITERID, :TABLEID, :GUESTID, :PERIODNo, :ROOMNO, :RESERVID) ';


    cSQLInsertIntoFelixGuestAccount =
      ' INSERT into GASTKONTO ' +
      ' (FIRMA, RESERVID, DATUM, LEISTUNGSID, LEISTUNGSTEXT, MENGE, BETRAG, Fix, AufRechnungsAdresse, ' +
      '  INTABSGEBUCHT ) ' +
      ' VALUES' +
      ' (:CompanyID, :RESERVID, :pDate, :ArticleID, :ArticleName, :Quantity, :Price, :Fix, :onBillAddresse, ' +
      '  :INTABSGEBUCHT )'  ;

    cSQLGetHelpTable=
{      ' SELECT ht.Firma as CompanyID, ht.ArtikelID as ArticleID, a.bezeichnung as ArticleName, ht.Betrag as Price, SUM(ht.Menge) as Quantity, ' +
      ' ht.OffeneTischID as OpenTableID, h.hauptgruppeid as MaingroupId, s.mwst as Tax, s.Id as TaxID, beilagenid1 as ArticleExtraID1, ' +
      ' beilagenid2 as ArticleExtraID2, beilagenid3 as ArticleExtraID3, beilagentext as ArticleExtraText ' +
      ' FROM Hilf_Tischkonto ht' +
      ' LEFT OUTER JOIN artikel a on ht.artikelid=a.artikelid and ht.firma=a.firma ' +
      ' LEFT OUTER JOIN untergruppe u on a.untergruppeid=u.untergruppeid and u.firma=a.firma ' +
      ' LEFT OUTER JOIN hauptgruppe h on u.hauptgruppeid=h.hauptgruppeid and h.firma=u.firma ' +
      ' LEFT OUTER JOIN steuer s on h.steuerid=s.id and h.firma=s.firma ' +
      ' WHERE OffeneTischID = :pOpenTableID ' +
      ' AND Firma = :pCompanyID AND ht.betrag <> 0 ' +
      ' GROUP BY CompanyID, ArticleID,ArticleName, Price, OpenTableID, Maingroupid, tax,taxid, ArticleExtraID1, ArticleExtraID2, ' +
      ' ArticleExtraID3, ArticleExtraText ';
}
      'WITH TAXING AS (                                                                             '+
      '  SELECT                                                                                     '+
      '    ART.ARTIKELID AS ARTIKELID                                                               '+
      '    ,TAX.MWST AS TAX                                                                         '+
      '    ,TAX.ID AS TAXID                                                                         '+
      '    ,MAINGROUP.HAUPTGRUPPEID                                                                 '+
      '  FROM                                                                                       '+
      '    ARTIKEL ART                                                                              '+
      '  LEFT OUTER JOIN                                                                            '+
      '    UNTERGRUPPE SUBGROUP                                                                     '+
      '    ON SUBGROUP.FIRMA = ART.FIRMA AND ART.UNTERGRUPPEID = SUBGROUP.UNTERGRUPPEID             '+
      '  LEFT OUTER JOIN                                                                            '+
      '    HAUPTGRUPPE MAINGROUP                                                                    '+
      '    ON MAINGROUP.FIRMA = SUBGROUP.FIRMA AND SUBGROUP.HAUPTGRUPPEID = MAINGROUP.HAUPTGRUPPEID '+
      '  LEFT OUTER JOIN                                                                            '+
      '    STEUER TAX                                                                               '+
      '    ON MAINGROUP.FIRMA = TAX.FIRMA  AND MAINGROUP.STEUERID = TAX.ID                          '+
      '  WHERE                                                                                      '+
      '    ART.FIRMA = :PCOMPANYID                                                                  '+
      ') /* END OF WITH */                                                                          '+
      'SELECT                                                                                       '+
      '  HT.FIRMA AS COMPANYID                                                                      '+
      '  ,HT.ARTIKELID AS ARTICLEID                                                                 '+
      '  ,A.BEZEICHNUNG AS ARTICLENAME                                                              '+
      '  ,HT.BETRAG AS PRICE                                                                        '+
      '  ,TAXING1.TAX AS TAX1, TAXING1.TAXID AS TAXID1                                              '+
      '  ,SUM(HT.MENGE) AS QUANTITY                                                                 '+
      '  ,HT.OFFENETISCHID AS OPENTABLEID                                                           '+
      '  ,TAXING1.HAUPTGRUPPEID AS MAINGROUPID                                                      '+
      '  ,HT.BEILAGENID1 AS ARTICLEEXTRAID1                                                         '+
      '  ,HT.BEILAGENID2 AS ARTICLEEXTRAID2                                                         '+
      '  ,HT.BEILAGENID3 AS ARTICLEEXTRAID3                                                         '+
      '  ,HT.BEILAGENTEXT AS ARTICLEEXTRATEXT                                                       '+
      '  ,A.ARTIKELID2 AS ARTICLEID2, A.ARTIKELPREISID2 AS ARTICLEPRICE2, A.ARTIKELPROZENTID2 AS ARTICLEPERCENT2 '+
      '  ,A.ARTIKELID3 AS ARTICLEID3, A.ARTIKELPREISID3 AS ARTICLEPRICE3, A.ARTIKELPROZENTID3 AS ARTICLEPERCENT3 '+
      '  ,A.ARTIKELID4 AS ARTICLEID4, A.ARTIKELPREISID4 AS ARTICLEPRICE4, A.ARTIKELPROZENTID4 AS ARTICLEPERCENT4 '+
      '  ,A.ARTIKELID5 AS ARTICLEID5, A.ARTIKELPREISID5 AS ARTICLEPRICE5, A.ARTIKELPROZENTID5 AS ARTICLEPERCENT5 '+
      '  ,A.ARTIKELID6 AS ARTICLEID6, A.ARTIKELPREISID6 AS ARTICLEPRICE6, A.ARTIKELPROZENTID6 AS ARTICLEPERCENT6 '+
      '  ,A.ARTIKELID7 AS ARTICLEID7, A.ARTIKELPREISID7 AS ARTICLEPRICE7, A.ARTIKELPROZENTID7 AS ARTICLEPERCENT7 '+
      '  ,A.ARTIKELID8 AS ARTICLEID8, A.ARTIKELPREISID8 AS ARTICLEPRICE8, A.ARTIKELPROZENTID8 AS ARTICLEPERCENT8 '+
      '  ,A.ARTIKELID9 AS ARTICLEID9, A.ARTIKELPREISID9 AS ARTICLEPRICE9, A.ARTIKELPROZENTID9 AS ARTICLEPERCENT9 '+
      '  ,A.ARTIKELID10 AS ARTICLEID10, A.ARTIKELPREISID10 AS ARTICLEPRICE10, A.ARTIKELPROZENTID10 AS ARTICLEPERCENT10 '+
      '  ,TAXING2.TAX AS TAX2, TAXING2.TAXID AS TAXID2, TAXING2.HAUPTGRUPPEID AS MAINGROUP2 '+
      '  ,TAXING3.TAX AS TAX3, TAXING3.TAXID AS TAXID3, TAXING3.HAUPTGRUPPEID AS MAINGROUP3 '+
      '  ,TAXING4.TAX AS TAX4, TAXING4.TAXID AS TAXID4, TAXING4.HAUPTGRUPPEID AS MAINGROUP4 '+
      '  ,TAXING5.TAX AS TAX5, TAXING5.TAXID AS TAXID5, TAXING5.HAUPTGRUPPEID AS MAINGROUP5 '+
      '  ,TAXING6.TAX AS TAX6, TAXING6.TAXID AS TAXID6, TAXING6.HAUPTGRUPPEID AS MAINGROUP6 '+
      '  ,TAXING7.TAX AS TAX7, TAXING7.TAXID AS TAXID7, TAXING7.HAUPTGRUPPEID AS MAINGROUP7 '+
      '  ,TAXING8.TAX AS TAX8, TAXING8.TAXID AS TAXID8, TAXING8.HAUPTGRUPPEID AS MAINGROUP8 '+
      '  ,TAXING9.TAX AS TAX9, TAXING9.TAXID AS TAXID9, TAXING9.HAUPTGRUPPEID AS MAINGROUP9 '+
      '  ,TAXING10.TAX AS TAX10, TAXING10.TAXID AS TAXID10, TAXING10.HAUPTGRUPPEID AS MAINGROUP10 '+
      'FROM                                                                                         '+
      '  HILF_TISCHKONTO HT                                                                         '+
      'LEFT OUTER JOIN ARTIKEL A ON HT.ARTIKELID = A.ARTIKELID AND HT.FIRMA = A.FIRMA               '+
      'LEFT OUTER JOIN TAXING TAXING1 ON TAXING1.ARTIKELID = HT.ARTIKELID                           '+
      'LEFT OUTER JOIN TAXING TAXING2 ON TAXING2.ARTIKELID = A.ARTIKELID2                           '+
      'LEFT OUTER JOIN TAXING TAXING3 ON TAXING3.ARTIKELID = A.ARTIKELID3                           '+
      'LEFT OUTER JOIN TAXING TAXING4 ON TAXING4.ARTIKELID = A.ARTIKELID4                           '+
      'LEFT OUTER JOIN TAXING TAXING5 ON TAXING5.ARTIKELID = A.ARTIKELID5                           '+
      'LEFT OUTER JOIN TAXING TAXING6 ON TAXING6.ARTIKELID = A.ARTIKELID6                           '+
      'LEFT OUTER JOIN TAXING TAXING7 ON TAXING7.ARTIKELID = A.ARTIKELID7                           '+
      'LEFT OUTER JOIN TAXING TAXING8 ON TAXING8.ARTIKELID = A.ARTIKELID8                           '+
      'LEFT OUTER JOIN TAXING TAXING9 ON TAXING9.ARTIKELID = A.ARTIKELID9                           '+
      'LEFT OUTER JOIN TAXING TAXING10 ON TAXING10.ARTIKELID = A.ARTIKELID10                        '+
      'WHERE                                                                                        '+
      '  OFFENETISCHID = :POPENTABLEID                                                              '+
      '  AND FIRMA = :PCOMPANYID                                                                    '+
      '  AND HT.BETRAG <> 0                                                                         '+
      'GROUP BY                                                                                     '+
      '  COMPANYID                                                                                  '+
      '  ,HT.ARTIKELID                                                                              '+
      '  ,ARTICLENAME                                                                               '+
      '  ,PRICE                                                                                     '+
      '  ,OPENTABLEID                                                                               '+
      '  ,MAINGROUPID                                                                               '+
      '  ,ARTICLEEXTRAID1,ARTICLEEXTRAID2, ARTICLEEXTRAID3, ARTICLEEXTRATEXT                        '+
      '  ,TAX1, TAXID1                                                                              '+
      '  ,ARTICLEID2, ARTICLEPRICE2, ARTICLEPERCENT2, TAX2, TAXID2, MAINGROUP2'+
      '  ,ARTICLEID3, ARTICLEPRICE3, ARTICLEPERCENT3, TAX3, TAXID3, MAINGROUP3'+
      '  ,ARTICLEID4, ARTICLEPRICE4, ARTICLEPERCENT4, TAX4, TAXID4, MAINGROUP4'+
      '  ,ARTICLEID5, ARTICLEPRICE5, ARTICLEPERCENT5, TAX5, TAXID5, MAINGROUP5'+
      '  ,ARTICLEID6, ARTICLEPRICE6, ARTICLEPERCENT6, TAX6, TAXID6, MAINGROUP6'+
      '  ,ARTICLEID7, ARTICLEPRICE7, ARTICLEPERCENT7, TAX7, TAXID7, MAINGROUP7'+
      '  ,ARTICLEID8, ARTICLEPRICE8, ARTICLEPERCENT8, TAX8, TAXID8, MAINGROUP8'+
      '  ,ARTICLEID9, ARTICLEPRICE9, ARTICLEPERCENT9, TAX9, TAXID9, MAINGROUP9'+
      '  ,ARTICLEID10, ARTICLEPRICE10, ARTICLEPERCENT10, TAX10, TAXID10, MAINGROUP10';


    cSQLGetTableAccontForTransferToBill =
      'SELECT tk.Firma, ' +
      '  tk.TischkontoID as TableaccountID, tk.datum as BookedDate, tk.ArtikelID as ArticleID, tk.Menge as Quantity, ' +
      '  tk.Betrag as Price, b1.PreisPlus as PricePlus1, b1.PreisMinus as PriceMinus1, ' +
      '  tk.BeilagenID1 as ArticleExtraID1, b1.Bezeichnung AS ArticleExtra1, ' +
      '  b2.PreisPlus as PricePlus2, b2.PreisMinus as PriceMinus2, ' +
      '  tk.BeilagenID2 as ArticleExtraID2, b2.Bezeichnung AS ArticleExtra2, ' +
      '  b3.PreisPlus as PricePlus3, b3.PreisMinus as PriceMinus3, ' +
      '  tk.BeilagenID3 as ArticleExtraID3, b3.Bezeichnung AS ArticleExtra3, tk.BeilagenText as FreeText ' +
      'FROM Tischkonto tk ' +
      'LEFT OUTER JOIN Beilagen b1 ' +
      '  ON tk.Firma = b1.Firma AND tk.BeilagenID1 = b1.BeilagenID ' +
      'LEFT OUTER JOIN Beilagen b2 ' +
      '  ON tk.Firma = b2.Firma AND tk.BeilagenID2 = b2.BeilagenID ' +
      'LEFT OUTER JOIN Beilagen b3 ' +
      '  ON tk.Firma = b3.Firma AND tk.BeilagenID3 = b3.BeilagenID ' +
      'WHERE tk.Firma = :CompanyID  '  +
      'AND tk.OffeneTischID = :openTableID ';


     cSQLInsertArticleIntoBillAccount =
      'INSERT INTO Rechnungskonto' +
      '  (Firma, RechnungsID, Datum, ArtikelID, Menge, Betrag, LeistungsText, BonNr) ' +
      'VALUES  ' +
      '  (:CompanyID, :BillID, :pDate, :ArticleID, :Quantity, :Amount, :ArticleText, :SlipNr)';

    cSQLInsertArticleIntoHelpAccount =
      ' insert into HILF_TISCHKONTO (FIRMA, TISCHKONTOID, OFFENETISCHID, DATUM, ARTIKELID, MENGE, BETRAG, KELLNERID, KASSEID,' +
      '    GEDRUCKT, BEILAGENID1, BEILAGENID2, BEILAGENID3, BEILAGENTEXT, GANGID     ) ' +
      ' values (:CompanyID, :TableAccountID, :OpenTableID, :pDate, :ArticleId, :quantity, :price, :Waiterid, :Cashdeskid, :printed, ' +
      '        :ArticleExtraID1, :ArticleExtraID2, :ArticleExtraID3, :FreeTEXT,  :CourseID) ';

    cSQLDeleteTableAccountByID =
      ' DELETE from tischkonto tk where tk.tischkontoid=:tableaccountid ';

    cSQLUpdateTableAccountQuantity=
      ' UPDATE tischkonto tk ' +
      ' SET tk.menge=:Quantity ' +
      ' WHERE tk.tischkontoid=:tableaccountid ';

    cSQLGetAllPrinters =
      'select ' +
      '  gd.druckerid as Printerid, gd.bezeichnung as name ' +
      'from lokaldrucker l ' +
      'left outer join ' +
      '  globaldrucker gd on gd.druckerid=l.druckerid ' +
      'where ' +
      '  l.kasseid=:cashregisterid and l.standarddrucker=''T''  ' +
      '  and (gd.printerorder is null or gd.printerorder>-1 ) ' +
      '  and not gd.druckerid is null '+
      'union ' +
      'SELECT  ' +
      '  gd.DruckerID AS PrinterID, ' +
      '  gd.bezeichnung AS name  ' +
      'from lokaldrucker l ' +
      'left outer join ' +
      '  globaldrucker gd on gd.druckerid=l.druckerid ' +
      'WHERE ' +
      ' gd.Firma = :CompanyID ' +
      ' and (gd.printerorder is null or gd.printerorder>-1 ) '+
      ' and not gd.druckerid is null ' +
      'group by gd.printerorder, printerid, name';


    cSQLGetWaiterRights =
      'SELECT ' +
      '  RECHTEMAIN AS MainRights, ' +
      '  RECHTEBONIER AS OrderRights, ' +
      '  RECHTESONSTIGE AS OtherRights ' +
      'FROM ' +
      '  KELLNER ' +
      'WHERE ' +
      '  KELLNERID = :WaiterID ' +
      '  AND FIRMA = :CompanyID';

    cSQLCheckFelixJournal =
      'select * from kassenjournal k where k.reservid=:reservid';

    cSQLCheckKassInfo =
      'select * from kassinfo k where k.termin_nr = :reservid';

    cSQLCheckFelixGuestAccount =
      'select * from gastkonto g where g.reservid=:reservid';

    cSQLCheckHotelLogHotelTyp3 =
      'select * from hotellog h where h.termin_nr = :reservid ';

    cSQLCheckJournalHotelTransfer =
      ' select * from journal j where j.offenetischid = :reservid';

    cSQLCheckTableAccountByArticle =
      ' SELECT Menge as Quantity ' +
      ' from tischkonto tk ' +
      ' where tk.offenetischid=:opentableID and tk.artikelid = :ArticleID ';

    cSQLGetPaymentByBillID =
      ' select rz.zahlwegid as PaymentID, rz.betrag as Amount, rz.TransactionNumber ' +
      ' from rechnungszahlweg rz ' +
      ' where rz.rechnungsid = :pBillid and rz.firma = :pCompanyID ';

    cSQLTransferChargeItemsToTableAccount =
      ' INSERT INTO TISCHKONTO ( ' +
      ' FIRMA, OFFENETISCHID, KASSEID, DATUM, KELLNERID, ' +
      ' ARTIKELID, MENGE, BETRAG, ' +
      ' BEILAGENID1, BEILAGENTEXT, ' +
      ' GEDRUCKT, VERBUCHT, I_DEVICEGUID) ' +
      ' SELECT rk.firma, :pOpenTableID, :pCashRegisterID, :pDate, :pWaiterID, ' +
      ' iif(rk.menge<>0, rk.artikelid, null), ' +
      ' iif(rk.menge<>0, rk.menge, null), ' +
      ' iif(rk.menge<>0, rk.betrag, null), ' +
      ' iif(rk.menge<>0, null, -1), ' +
      ' iif(rk.menge<>0, null, coalesce(rk.leistungstext, '''')), ' +
      ' ''T'', ''T'', '''' ' +
      ' FROM rechnungskonto rk ' +
      ' where rk.rechnungsid = :pBillid and rk.firma = :pCompanyID ';

    cSQLDeleteChargeItemsByBillID =
      ' DELETE FROM Rechnungskonto rk ' +
      ' where rk.rechnungsid = :pBillid and rk.firma = :pCompanyID ';

    cSQLDeletePaymentByBillID =
      ' DELETE FROM Rechnungszahlweg rz ' +
      ' where rz.rechnungsid = :pBillid and rz.firma = :pCompanyID ';

    cSQLResetBillAfterReactivation =
      ' UPDATE Rechnung SET ZahlungsBetrag = NULL, ' +
      ' BereitsBezahlt = NULL, Gedruckt = NULL,  ' +
      ' BearbeiterID = :pWaiterID, ' +
      ' Nachlass = NULL, Mahndatum = NULL, Mahnstufe = NULL ' +
      ' WHERE ID = :PBillID and firma = :pCompanyID ';

    cSQLCheckJournal =
      ' select j.menge as Quantity from journal j where j.offenetischid = :OpenTableID and j.artikelid = :ArticleID';

    cSQLCheckBillAccountByArticle=
      ' select Menge as Quantity, rk.rechnungsid as billid ' +
      ' from rechnungskonto rk     ' +
      ' where exists (select Null from rechnung r where r.reservid=:opentableid and rk.rechnungsid=r.id) and rk.artikelid=:articleid ';

    cSQLSaveHotelSignature =
      'INSERT INTO Hotel_Signature (CompanyID, SignatureDate, WaiterID, OpenTableID, ' +
      '  ReservID, SignatureImage, RoomID) ' +
      'VALUES ( ' +
      '  :CompanyID, :SignatureDate, :WaiterID, :OpenTableID, :ReservID, :SignatureImage, :RoomID)' +
      'RETURNING ID';

  cSQLGetLastBillIDFromTableIDandWaiterID =
    ' SELECT r.ID, r.ReservID, r.AdresseID, r.nachlass, r.rechnungsnummer from rechnung r ' +
    ' JOIN OffeneTische ot ON r.ReservID = ot.offeneTischID AND r.Firma = ot.Firma ' +
    ' JOIN Tisch t         ON ot.TischID = t.TischID AND ot.Firma = t.Firma ' +
    ' WHERE r.Gedruckt = ''T'' AND r.Datum = :pDate AND r.Firma = :pCompanyID ' +
    ' AND r.ErstellerID = :pWaiterID AND (t.TischID = :pTableID) ' +
    ' ORDER BY r.id ';

  cSQLResponseByRequestTimestamp =
    ' Select REQUEST_TIMESTAMP from ZEN_HISTORY where REQUEST_TIMESTAMP = :pREQUEST_TIMESTAMP ';
  cSQLResponseByRequestParameters =
    ' Select first 1 REQUEST_TIMESTAMP, REQUEST_FUNCTION, REQUEST_PARAMETERS ' +
    ' from ZEN_HISTORY order by REQUEST_TIMESTAMP DESC ';
  cSQLInsertZENHistory =
    ' Insert into ZEN_HISTORY (REQUEST_TIMESTAMP, REQUEST_FUNCTION, REQUEST_PARAMETERS ) ' +
    ' values (:pREQUEST_TIMESTAMP, :pREQUEST_FUNCTION, :pREQUEST_PARAMETERS) ';

implementation

end.
