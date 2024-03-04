unit Resources;

interface

uses
  System.Generics.Collections;

const
  cSecretKeyForToken = '{25438E77-D878-4158-B44F-0ED799057D63}';

  cTokenExpirationTerm = 1440;           // Expiration term of a token (in minutes) 1440 min = 24 hours
  cTokenIssuerName = 'GMS restFelix Server';
  cRightsBoss = 65536;                        //checked in do opentable and getTables
  cRightsMakeBill        = 8;            //cBonierRechnung checked in DoBill
  cRightsMakeWholeBill  = 16; //cBonierGesamtRechnung checked in DoBill
  cRightsMakePartialBill    = 32; //cBonierTeilRechnung checked in DoBill
  cRightsMakeTotalImediateBill  = 64; //cBonierSofortRechnung only in KASSE, cash only
  cRightsTransfare        = 128; // cBonierUmbuchen checked in DoTransferToTable and DoTransferToGuest and DoTransferRooms
  cRightsTransfareTotal  = 256; //cBonierGesamtUmbuchen checked in DoTransferToTable and DoTransferToGuest
  cRightsTransfarePartial    = 512; //cBonierTeilUmbuchen checked in DoTransferToTable and DoTransferToGuest
  cRightsReversal          = 1024;// cBonierStorno checked in DoReversal
  cRightsReversalTotal    = 2048;//cBonierGesamtStorno checked in DoReversal
  cRightsReversalPartial      = 4096;// cBonierTeilStorno checked in DoReversal
  cRightsReversalImedeate    = 8192;//cBonierSofortStorno checked in DoDecreaseAccountEntry
  cRightsOrderSlip        = 16384;//cBonierBonDruck checked in DoKassierBon
  cAppFolder = '/app/';                 // Subfolder where app is stored
  cDocsFolder = '/docs/';               // Subfolder where API documentation is stored
  cAuthorizationPrefix = 'Bearer';
  cWindowsServiceName = 'restFelixService';
  cRestFelixIniFileName = 'restFelix.ini';
  //cDefaultPort = 8080;
  cRestFelixIniServerSectionName = 'Server';
  cRestFelixIniPortNumberKeyName = 'Port';
  cRestFelixIniIsHTTPSName = 'IsHTTPS';
  cRestFelixIniKeyPasswordName = 'KeyPassword';
  cRestFelixIniKeyNameFileName = 'KeyNameFile';
  cRestFelixIniKeyCertificateFileName = 'KeyCertificateFile';
  cRestFelixIniRootCertificateFileName = 'RootCertificateFile';
  cZenSIniSettingsSectionName = 'Settings';
  cZenSIniSettingsLogPathKeyName = 'LogPath';
  cZenSIniSettingsLogDefaultPath = '.\logs';
  cZenSIniSettingsLogPrefixKeyName = 'LogPrefix';
  cZenSIniSettingsLogDefaultPrefix = 'ZenS';
  cServiceTetheringManagerName = 'ServiceTetheringManager';
  cServiceTetheringAppProfileName = 'ServiceTetheringAppProfile';
  cConfigTetheringManagerName = 'ConfigTetheringManager';
  cConfigTetheringAppProfileName = 'ConfigTetheringAppProfile';
  cTetheringGroupName = 'ZEN';
  cTetheringLogResourceDescription = 'Log from the service';
  cRegistryServicePath = 'SYSTEM\CurrentControlSet\Services\ZenRestService';
  cDefaultLangID = 0;
  cDefaultKasseID = 1;
  cTemplateForResultWithHash = '{"hash":"%s", "data": %s}';

{$REGION 'Unit testing'}
//{$IFDEF UNITTESTS}
const
  cTestIniFile = '.\kasse.ini';
  cTestDBDriver = 'FB';
  cTestDBProtocol = 'Local';
  cTestDBSectionName = 'TestDatabase';
  cTestDBKeyName = 'ServerPath';
  cTestDBDefaultServerPath = '';
  cTestDBUserName = 'SYSDBA';
  cTestDBPassword = 'x';
  cTestWaiterID = 13;
  cTestRestLoginName = 'TestWaiter';
  cTestRestPassword = 'TW';
  CTestRestPasswordDecoded = 'wn';
  cTestRestGuid = '12345678910';
  cTestLoginParameters = '{"loginname":"%s", "password":"%s", "guid":"%s"}';
  cTestReservIDHotelType3 = '4567';
  cFunctionResultStructures: TArray<TArray<string>> =   // FieldNames are case sensitive
    [
    ['Login', '["token", "firstname", "lastname", "languageid"]'],
    ['GetArticleExtraGroupList', '["companyid", "id", "description"]'],
    ['GetArticleExtraList', '["companyid", "id", "description", "increaseprice", ' +
      '"decreaseprice", "aexglen"]'],
    ['GetArticleGroupList', '["companyid", "id", "description", "posi", "color"]'],
    ['GetArticleList', '["companyid", "id", "description", "articlegroupid", ' +
      '"articleextragroupid", "articleextraobligationtype", "unitprice", "posi", ' +
      '"price1", "price2", "price3", "price4", "price5", "price6", "price7", ' +
      '"price8", "price9", "price10", "employeeprice", "quantprice"]'],
    ['GetTableGroupList', '["id", "description", "posi"]'],
    ['GetPaymentmethodList', '["id", "description", "posi"]'],
    ['GetTablesList', '["id", "tablenumber", "description", "tabletype","maintableid","tablegroupid", "posi"]'],
    ['GetWaiterList', '["id", "loginname", "lastname", "firstname", "accessright", "billright", "languageid"]'],
    ['GetOpenTableList', '["tableid", "total","firstwaiterid","currentwaiterid" ]'],
    ['OpenTable', '["Opentableid", "opentablewaiterid" ]'],
    ['AddArticlesToTable', '["opentableid", "opentablewaiterid", "currentwaiterid", "pricelevel", "articles"]'],
    ['AddArticlesToTable_Articles', '["tableaccountid", "articleid", "articledescription", "quantity", "price", "articleextras"]'],
    ['AddArticlesToTable_ArticleExtras', '["tableaccountid", "articleextraid1"]'],
    ['GetAllPrinters', '["printerid", "name"]'],
    ['DoBill','["billid"]']
    ];


  //  ################# Attention!! ###########################################################
  //    if the articleid is changed then this should also be changed in the
  //    procedure TServerMethods.TestDoBill otherwise the test will fail!!!

  cAddArticleParamsTemplate = '{"table_account": {"opentableid": "0","articles": ['+
    '{"articleid":"2","quantity":"2","price":"2,0","articleextras":[]},'+
    '{"articleid":"1","quantity":"1","price":"1,0","articleextras":['+
    '{"articleextraid1":"-1","articleextratext":"blabla"}]}, ' +
    '{"articleid":"3","quantity":"1","price":"3,","articleextras":[]}, ' +
    '{"articleid":"4","quantity":"3","price":"4,0","articleextras":['+
    '{"articleextraid1":"-2","articleextraid2":"10"}]} ' +
    ']}}';

  cTestTableID = 1;

  cDoBillArticleWithoutExtras='{"data":{"opentableid":"0","printerid":"0","articles":[ ' +
                              '{"articleid":"2","quantity":"1","price":"2,0","articleextras":[]} ' +
                              '],"payments":[{"paymentid":"1","amount":"2,0"}]}} ';

  cDoBillArticleWithExtras='{"data":{"opentableid":"0","printerid":"0","articles":[ ' +
                              '{"articleid":"1","quantity":"1","price":"1,0","articleextras":[{ ' +
                              ' "articleextraid1":"-1", ' +
                              ' "articleextratext":"blabla" ' +
                              ' }]} ' +
                              '],"payments":[{"paymentid":"1","amount":"1,0"}]}} ';

  cDoReversalArticleWithExtras=' {"data":{"opentableid":"251853","articles":[ ' +
                               ' {"articleid":"4","quantity":1,"price":4,"articleextras":[ ' +
                               ' {"articleextraid1":"-2","articleextraid2":"10"}]}]}}';

  cTransferArticlesToTable= '{"data":{"opentableid":"0","newtableid":"2","articles": ' +
                            '[{"articleid":"4","quantity":1,"price":4,"articleextras": ' +
                            '[{"articleextraid1":"-2","articleextraid2":"10"}]}]}}';

  cTransferToRoomHotelTyp3=' {"data":{"opentableid":"251838","roomid":"10001","reservid":"4567","signature_image":"data:image/png", ' +
                           ' "articles":[{"articleid":"4","quantity":1,"price":4,"articleextras": ' +
                           ' [{"articleextraid1":"-2","articleextraid2":"10"}]}]}}';

  cTransferToRoomFelix    =' {"data":{"opentableid":"251873","roomid":"105","reservid":"839107656", ' +
                           ' "signature_image":"data:image/png;","articles":[ ' +
                           ' {"articleid":"2","quantity":1,"price":2,"articleextras":[]}]}}';

  // ############################################################################################



resourcestring
  cErrorIncorrectResultStructureCommon = 'Incorrect result structure. %s';
  cErrorIncorrectResultStructureEmptyArray = 'Array of json-strings was expected but found empty array.';
  cErrorIncorrectResultStructureNotArrayOfStrings = 'Array of json-strings was expected.';
  cErrorIncorrectResultStructureNotObject = 'Json-object was expected.';
  cErrorIncorrectResultStructureFieldsNotFound = 'Following field(s) is not found: %s';
  cErrorUnexpectedResultForLogin = 'Unexcepted result of call the function "Login"';
  cErrorUnexpectedResult = 'Unexpected result. Expected: %s Actual: %s';
//{$ENDIF}
{$ENDREGION}

resourcestring
  cErrorUnknownAuthorizationFormat = 'Unknown authorization format';
  cErrorNeedAuthentication = 'You have to authenticate';
  cErrorIncorrectToken = 'The token is incorrect';
  cErrorTokenNotActive = 'The token is not active yet';
  //######## DO NOT Change the Text of   cErrorTokenIsExpired otherwise the App won't redirect
  cErrorTokenIsExpired = 'The token is expired. You have to re-login.';
  //####################################################################
  cErrorLoginOrPasswordIsIncorrect = 'Benutzername oder Password ist falsch!';
  cErrorUnknownRestCommand = 'Unknown function "%s"';
  cErrorUnauthorizedAccess = 'You don''t have the authorization for this function. (%s)';
  cErrorUnauthorizedAccessDE = 'Sie haben kein Recht für diese Funktion. (%s)';
  cErrorTableCannotBeClosed = 'Noch Umsatz vorhanden. Tisch kann nicht geschlossen werden';
  cErrorOpenTableIDNotValidDE = 'OffeneTischID nicht gültig';
  cErrorOpenTableIDNotValidEN = 'OpenTableID not Valid';
  cCantGetServiceState = 'Can''t get service status (error code: %d)';
  cAppModeApplication = 'Application mode';
  cAppModeConfig = 'Configuring service';
  cRestServerStateStopped = 'REST server is stopped';
  cRestServerStateRunning = 'REST server is running';
  cServiceStatusContinuePending = 'The service continue is pending';
  cServiceStatusPausePending = 'The service pause is pending';
  cServiceStatusPaused = 'The service is paused';
  cServiceStatusRunning = 'The service is running';
  cServiceStatusStartPending = 'The service is starting';
  cServiceStatusStopPending = 'The service is stopping';
  cServiceStatusStoped = 'The service is not running';
  cServiceStatusUnknown = 'The service status is unknown';
  cErrorCantConnectToServiceManager = 'Can''t connect to service manager (error code: %d)';
  cSuccess = 'Success';
  cErrorInternal = 'Internal error: %s';
  cQueryGastInfo =  'select (trim(g.nachname) || '' '' || trim(g.vorname)) as name, '+
                    'r.id ,r.gastadresseid, r.anreisedatum, r.abreisedatum, r.zimmerid, '+
                    'r.bemerkung2 FROM reservierung r '+
                    'left  outer join gaestestamm g on g.id = r.gastadresseid '+// and g.Firma = :Firma '+
                    'left outer join Arrangement a on a.firma = r.firma AND a.id = r.arrangementid '+
                    'left outer join room_categories rc on rc.category_number = r.kategorieid and rc.lookup_company_id = :Firma '+
                    'where r.firma = :Firma '+
                    'and r.buchart in (0,1) and (r.storniert is null or  r.storniert =''F'') '+
                    'and r.zimmeranzahl = 1 and r.checkin = ''T'' '+
                    'and r.abreisedatum >= :dateToday '+
                    'and r.anreisedatum <= :dateToday '+
                    'and (r.SPERRENEXTRA = ''F'' or (r.sperrenextra is null)) '+
                    '--and rc.short_description <> ''PSE'' '+
                    'group by r.id,r.gastadresseid, g.nachname, g.vorname, r.anreisedatum, r.abreisedatum, '+
                    'r.zimmerid, r.bemerkung2 order by G.Nachname ';
  cQueryUiqueKey = 'SELECT kc.ReservID, kc.Cardnumber, kc.Zimmerid, kc.Uniquenumber, kc.advuid '+
                   'FROM Key_Card_Online kc ' +
                   'WHERE CheckOut = ''F'' ' +
                   'and kc.ReservID = :reservId ';

implementation

end.
