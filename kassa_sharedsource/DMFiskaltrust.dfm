object DataFiskaltrust: TDataFiskaltrust
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 421
  Width = 844
  object QueryReceipt: TFDQuery
    Connection = DBase.ConnectionZEN
    FetchOptions.AssignedValues = [evMode, evRecordCountMode]
    FetchOptions.Mode = fmAll
    FetchOptions.RecordCountMode = cmTotal
    SQL.Strings = (
      'select '
      '  r.zimmerid           as TerminalID,'
      '  r.rechnungsnummer    as ReceiptReference,'
      '  r.zahlungsbetrag     as ReceiptAmount,'
      '  r.nachlass           as Discount'
      'from rechnung r'
      'where r.id = :pID')
    Left = 60
    Top = 40
    ParamData = <
      item
        Name = 'PID'
        ParamType = ptInput
      end>
  end
  object QueryChargeItems: TFDQuery
    Connection = DBase.ConnectionZEN
    FetchOptions.AssignedValues = [evMode, evRecordCountMode, evAutoFetchAll]
    FetchOptions.Mode = fmAll
    FetchOptions.RecordCountMode = cmTotal
    SQL.Strings = (
      'select'
      '  rk.menge            as ChargeQuantity,'
      '  rk.betrag*rk.menge  as ChargeAmount,'
      '  st.mwst             as ChargeVATRate,'
      '  st.ftChargeItemCase as ChargeItemCase,'
      '  rk.artikelid        as ChargeProductNumber,'
      '  a.bezeichnung       as ChargeDescription'
      'from rechnungskonto rk'
      
        'left outer join artikel a      on  a.firma = rk.firma and a.arti' +
        'kelid = rk.artikelid'
      
        'left outer join untergruppe ug on ug.firma =  a.firma and ug.unt' +
        'ergruppeid = a.untergruppeid'
      
        'left outer join hauptgruppe hg on hg.firma = ug.firma and hg.hau' +
        'ptgruppeid = ug.hauptgruppeid'
      
        'left outer join steuer st      on st.firma = hg.firma and st.id ' +
        '= hg.steuerid'
      'where rk.rechnungsid = :pID'
      '  and rk.leistungstext='#39#39
      '  and rk.menge<>0'
      '  and rk.betrag<>0')
    Left = 180
    Top = 40
    ParamData = <
      item
        Name = 'PID'
        ParamType = ptInput
      end>
  end
  object QueryPayItems: TFDQuery
    Connection = DBase.ConnectionZEN
    FetchOptions.AssignedValues = [evMode, evRecordCountMode]
    FetchOptions.Mode = fmAll
    FetchOptions.RecordCountMode = cmTotal
    SQL.Strings = (
      'select'
      '  1              as PayQuantity,'
      '  rz.betrag      as PayAmount,'
      '  z.bezeichnung  as PayDescription,'
      '  cast(( iif(z.bankomat='#39'T'#39', 4,'
      '         iif(z.kreditkarte='#39'T'#39', 5,'
      '         iif(z.gutschein='#39'T'#39', 6,'
      '         iif(z.debitor='#39'T'#39', 11,'
      '         1))))'
      '       ) as integer) as PayItemCase'
      'from rechnungszahlweg rz '
      
        'left outer join zahlweg z on z.firma = rz.firma and z.id = rz.za' +
        'hlwegid'
      'where rz.rechnungsid = :pID')
    Left = 280
    Top = 40
    ParamData = <
      item
        Name = 'PID'
        ParamType = ptInput
      end>
  end
  object QueryInsertReceipt: TFDQuery
    Connection = DBase.ConnectionZEN
    FetchOptions.AssignedValues = [evRecordCountMode]
    FetchOptions.RecordCountMode = cmTotal
    SQL.Strings = (
      'INSERT INTO FT_RECEIPT '
      
        '  ( ID, CASHBOXID, TERMINALID, RECEIPTID, RECEIPTREFERENCE, RECE' +
        'IPTMOMENT, STATE, RECEIPTCASE, RECEIPTCASEACTUAL, RECEIPTAMOUNT,' +
        ' PREVIOUSID) '
      'VALUES '
      
        '  (:ID,:CASHBOXID,:TERMINALID,:RECEIPTID,:RECEIPTREFERENCE,:RECE' +
        'IPTMOMENT,:STATE,:RECEIPTCASE,:RECEIPTCASEACTUAL,:RECEIPTAMOUNT,' +
        ':PREVIOUSID)'
      '; ')
    Left = 60
    Top = 200
    ParamData = <
      item
        Name = 'ID'
        ParamType = ptInput
      end
      item
        Name = 'CASHBOXID'
        ParamType = ptInput
      end
      item
        Name = 'TERMINALID'
        ParamType = ptInput
      end
      item
        Name = 'RECEIPTID'
        ParamType = ptInput
      end
      item
        Name = 'RECEIPTREFERENCE'
        ParamType = ptInput
      end
      item
        Name = 'RECEIPTMOMENT'
        ParamType = ptInput
      end
      item
        Name = 'STATE'
        ParamType = ptInput
      end
      item
        Name = 'RECEIPTCASE'
        ParamType = ptInput
      end
      item
        Name = 'RECEIPTCASEACTUAL'
        ParamType = ptInput
      end
      item
        Name = 'RECEIPTAMOUNT'
        ParamType = ptInput
      end
      item
        Name = 'PREVIOUSID'
        ParamType = ptInput
      end>
  end
  object QueryInsertChargeItems: TFDQuery
    Connection = DBase.ConnectionZEN
    FetchOptions.AssignedValues = [evRecordCountMode]
    FetchOptions.RecordCountMode = cmTotal
    SQL.Strings = (
      'INSERT INTO FT_CHARGEITEMS '
      
        '  ( FT_RECEIPT_ID, QUANTITY, DESCRIPTION, AMOUNT, VATRATE, CHARG' +
        'EITEMCASE, PRODUCTNUMBER, STATUS) '
      'VALUES '
      
        '  (:FT_RECEIPT_ID,:QUANTITY,:DESCRIPTION,:AMOUNT,:VATRATE,:CHARG' +
        'EITEMCASE,:PRODUCTNUMBER,:STATUS) '
      ';')
    Left = 60
    Top = 260
    ParamData = <
      item
        Name = 'FT_RECEIPT_ID'
        ParamType = ptInput
      end
      item
        Name = 'QUANTITY'
        ParamType = ptInput
      end
      item
        Name = 'DESCRIPTION'
        ParamType = ptInput
      end
      item
        Name = 'AMOUNT'
        ParamType = ptInput
      end
      item
        Name = 'VATRATE'
        ParamType = ptInput
      end
      item
        Name = 'CHARGEITEMCASE'
        ParamType = ptInput
      end
      item
        Name = 'PRODUCTNUMBER'
        ParamType = ptInput
      end
      item
        Name = 'STATUS'
        ParamType = ptInput
      end>
  end
  object QueryInsertPayItems: TFDQuery
    Connection = DBase.ConnectionZEN
    FetchOptions.AssignedValues = [evRecordCountMode]
    FetchOptions.RecordCountMode = cmTotal
    SQL.Strings = (
      'INSERT INTO FT_PAYITEMS '
      
        '  ( FT_RECEIPT_ID, QUANTITY, DESCRIPTION, AMOUNT, PAYITEMCASE, S' +
        'TATUS) '
      'VALUES '
      
        '  (:FT_RECEIPT_ID,:QUANTITY,:DESCRIPTION,:AMOUNT,:PAYITEMCASE,:S' +
        'TATUS) '
      ';')
    Left = 180
    Top = 260
    ParamData = <
      item
        Name = 'FT_RECEIPT_ID'
        ParamType = ptInput
      end
      item
        Name = 'QUANTITY'
        ParamType = ptInput
      end
      item
        Name = 'DESCRIPTION'
        ParamType = ptInput
      end
      item
        Name = 'AMOUNT'
        ParamType = ptInput
      end
      item
        Name = 'PAYITEMCASE'
        ParamType = ptInput
      end
      item
        Name = 'STATUS'
        ParamType = ptInput
      end>
  end
  object QueryInsertSignatureItems: TFDQuery
    Connection = DBase.ConnectionZEN
    FetchOptions.AssignedValues = [evRecordCountMode]
    FetchOptions.RecordCountMode = cmTotal
    SQL.Strings = (
      'INSERT INTO FT_SIGNATUREITEMS '
      
        '  ( FT_RECEIPT_ID, SIGNATUREFORMAT, SIGNATURETYPE, CAPTION, DATA' +
        ') '
      'VALUES '
      
        '  (:FT_RECEIPT_ID,:SIGNATUREFORMAT,:SIGNATURETYPE,:CAPTION,:DATA' +
        ') '
      ';')
    Left = 280
    Top = 200
    ParamData = <
      item
        Name = 'FT_RECEIPT_ID'
        ParamType = ptInput
      end
      item
        Name = 'SIGNATUREFORMAT'
        ParamType = ptInput
      end
      item
        Name = 'SIGNATURETYPE'
        ParamType = ptInput
      end
      item
        Name = 'CAPTION'
        ParamType = ptInput
      end
      item
        Name = 'DATA'
        ParamType = ptInput
      end>
  end
  object QueryInsertReceiptHeaders: TFDQuery
    Connection = DBase.ConnectionZEN
    FetchOptions.AssignedValues = [evRecordCountMode]
    FetchOptions.RecordCountMode = cmTotal
    SQL.Strings = (
      'INSERT INTO FT_RECEIPTHEADERS'
      '  ( FT_RECEIPT_ID, TEXT) '
      'VALUES '
      '  (:FT_RECEIPT_ID,:TEXT) '
      ';'
      '')
    Left = 280
    Top = 260
    ParamData = <
      item
        Name = 'FT_RECEIPT_ID'
        ParamType = ptInput
      end
      item
        Name = 'TEXT'
        ParamType = ptInput
      end>
  end
  object QueryInsertChargeLines: TFDQuery
    Connection = DBase.ConnectionZEN
    FetchOptions.AssignedValues = [evRecordCountMode]
    FetchOptions.RecordCountMode = cmTotal
    SQL.Strings = (
      'INSERT INTO FT_CHARGELINES '
      '  ( FT_RECEIPT_ID, TEXT) '
      'VALUES '
      '  (:FT_RECEIPT_ID,:TEXT) '
      ';')
    Left = 60
    Top = 320
    ParamData = <
      item
        Name = 'FT_RECEIPT_ID'
        ParamType = ptInput
      end
      item
        Name = 'TEXT'
        ParamType = ptInput
      end>
  end
  object QueryInsertPayLines: TFDQuery
    Connection = DBase.ConnectionZEN
    FetchOptions.AssignedValues = [evRecordCountMode]
    FetchOptions.RecordCountMode = cmTotal
    SQL.Strings = (
      'INSERT INTO FT_CHARGELINES '
      '  ( FT_RECEIPT_ID, TEXT) '
      'VALUES '
      '  (:FT_RECEIPT_ID,:TEXT) '
      ';')
    Left = 180
    Top = 320
    ParamData = <
      item
        Name = 'FT_RECEIPT_ID'
        ParamType = ptInput
      end
      item
        Name = 'TEXT'
        ParamType = ptInput
      end>
  end
  object QueryInsertReceiptFooters: TFDQuery
    Connection = DBase.ConnectionZEN
    FetchOptions.AssignedValues = [evRecordCountMode]
    FetchOptions.RecordCountMode = cmTotal
    SQL.Strings = (
      'INSERT INTO FT_RECEIPTFOOTERS'
      '  ( FT_RECEIPT_ID, TEXT) '
      'VALUES '
      '  (:FT_RECEIPT_ID,:TEXT) '
      ';'
      '')
    Left = 280
    Top = 320
    ParamData = <
      item
        Name = 'FT_RECEIPT_ID'
        ParamType = ptInput
      end
      item
        Name = 'TEXT'
        ParamType = ptInput
      end>
  end
  object QueryGetQRCode: TFDQuery
    Connection = DBase.ConnectionZEN
    FetchOptions.AssignedValues = [evMode, evRecordCountMode]
    FetchOptions.Mode = fmAll
    FetchOptions.RecordCountMode = cmTotal
    SQL.Strings = (
      'select first 1 ID, DATA'
      'from FT_SIGNATUREITEMS '
      'where FT_RECEIPT_ID = :pFT_RECEIPT_ID'
      '  and SIGNATUREFORMAT = 3')
    Left = 60
    Top = 100
    ParamData = <
      item
        Name = 'PFT_RECEIPT_ID'
        ParamType = ptInput
      end>
  end
  object QueryUpdateReceipt: TFDQuery
    Connection = DBase.ConnectionZEN
    FetchOptions.AssignedValues = [evRecordCountMode]
    FetchOptions.RecordCountMode = cmTotal
    SQL.Strings = (
      'UPDATE FT_RECEIPT SET  '
      '  CASHBOXID = :CASHBOXID, '
      '  TERMINALID = :TERMINALID, '
      '  RECEIPTREFERENCE = :RECEIPTREFERENCE, '
      '  STATE = :STATE,'
      '  RECEIPTMOMENT = :RECEIPTMOMENT,'
      '  RECEIPTIDENTIFICATION = :RECEIPTIDENTIFICATION,'
      '  CASHBOXIDENTIFICATION = :CASHBOXIDENTIFICATION'
      'WHERE ID=:ID'
      ';'
      '')
    Left = 180
    Top = 200
    ParamData = <
      item
        Name = 'CASHBOXID'
        ParamType = ptInput
      end
      item
        Name = 'TERMINALID'
        ParamType = ptInput
      end
      item
        Name = 'RECEIPTREFERENCE'
        ParamType = ptInput
      end
      item
        Name = 'STATE'
        ParamType = ptInput
      end
      item
        Name = 'RECEIPTMOMENT'
        ParamType = ptInput
      end
      item
        Name = 'RECEIPTIDENTIFICATION'
        ParamType = ptInput
      end
      item
        Name = 'CASHBOXIDENTIFICATION'
        ParamType = ptInput
      end
      item
        Name = 'ID'
        ParamType = ptInput
      end>
  end
  object QueryDailyClosing: TFDQuery
    Connection = DBase.ConnectionZEN
    FetchOptions.AssignedValues = [evMode, evRecordCountMode]
    FetchOptions.Mode = fmAll
    FetchOptions.RecordCountMode = cmTotal
    SQL.Strings = (
      'SELECT DISTINCT Datum '
      'FROM Journal '
      'ORDER by Datum')
    Left = 740
    Top = 100
  end
  object QueryReprintReceipt: TFDQuery
    Connection = DBase.ConnectionZEN
    FetchOptions.AssignedValues = [evMode, evRecordCountMode]
    FetchOptions.Mode = fmAll
    FetchOptions.RecordCountMode = cmTotal
    SQL.Strings = (
      'select first 1 ft.id'
      'FROM ft_receipt ft'
      'where ft.receiptid = :pReceiptid'
      'and ft.state >= :pState'
      'order by ft.id DESC')
    Left = 740
    Top = 40
    ParamData = <
      item
        Name = 'PRECEIPTID'
        ParamType = ptInput
      end
      item
        Name = 'PSTATE'
        ParamType = ptInput
      end>
  end
  object QueryFooters: TFDQuery
    Connection = DBase.ConnectionZEN
    FetchOptions.AssignedValues = [evMode, evRecordCountMode]
    FetchOptions.Mode = fmAll
    FetchOptions.RecordCountMode = cmTotal
    SQL.Strings = (
      'select TEXT'
      'from FT_RECEIPTFOOTERS'
      'where FT_RECEIPT_ID = :pFT_RECEIPT_ID')
    Left = 280
    Top = 100
    ParamData = <
      item
        Name = 'PFT_RECEIPT_ID'
        ParamType = ptInput
      end>
  end
  object QueryReprintNull: TFDQuery
    Connection = DBase.ConnectionZEN
    FetchOptions.AssignedValues = [evMode, evRecordCountMode]
    FetchOptions.Mode = fmAll
    FetchOptions.RecordCountMode = cmTotal
    SQL.Strings = (
      'select first 1 ft.id'
      'FROM ft_receipt ft'
      'where ft.receiptid = -1'
      'and ft.receiptcaseactual = :pReceiptcaseActual'
      'and ft.state >= :pState'
      'and lower(ft.state) <> lower('#39'Request saved'#39')'
      'order by ft.id DESC')
    Left = 640
    Top = 40
    ParamData = <
      item
        Name = 'PRECEIPTCASEACTUAL'
        ParamType = ptInput
      end
      item
        Name = 'PSTATE'
        ParamType = ptInput
      end>
  end
  object QueryNewMonth: TFDQuery
    Connection = DBase.ConnectionZEN
    FetchOptions.AssignedValues = [evMode, evRecordCountMode]
    FetchOptions.Mode = fmAll
    FetchOptions.RecordCountMode = cmTotal
    SQL.Strings = (
      'SELECT first 1 RECEIPTMOMENT'
      'FROM FT_Receipt '
      'WHERE (NOT RECEIPTMOMENT is NULL)'
      'ORDER by RECEIPTMOMENT desc'
      '')
    Left = 640
    Top = 100
  end
  object QuerySubsequent: TFDQuery
    Connection = DBase.ConnectionZEN
    FetchOptions.AssignedValues = [evMode, evRecordCountMode]
    FetchOptions.Mode = fmAll
    FetchOptions.RecordCountMode = cmTotal
    SQL.Strings = (
      'SELECT r.*'
      'from ft_receipt r'
      'where (UPPER(trim(r.state))=UPPER('#39'Request saved'#39'))'
      '  and (r.receiptcaseactual in (1, -1))'
      
        '  and (r.id > (select first 1 f.id from ft_receipt f where f.rec' +
        'eiptcaseactual = 3 order by f.id desc))'
      'order by r.id')
    Left = 640
    Top = 260
  end
  object QuerySubChargeItems: TFDQuery
    Connection = DBase.ConnectionZEN
    FetchOptions.AssignedValues = [evMode, evRecordCountMode]
    FetchOptions.Mode = fmAll
    FetchOptions.RecordCountMode = cmTotal
    SQL.Strings = (
      'select * '
      'from ft_chargeitems '
      'where ft_receipt_id = :FT_RECEIPT_ID'
      'order by ID')
    Left = 640
    Top = 340
    ParamData = <
      item
        Name = 'FT_RECEIPT_ID'
        ParamType = ptInput
      end>
  end
  object QuerySubPayItems: TFDQuery
    Connection = DBase.ConnectionZEN
    FetchOptions.AssignedValues = [evMode, evRecordCountMode]
    FetchOptions.Mode = fmAll
    FetchOptions.RecordCountMode = cmTotal
    SQL.Strings = (
      'select * '
      'from ft_payitems '
      'where ft_receipt_id = :FT_RECEIPT_ID'
      'order by ID')
    Left = 740
    Top = 340
    ParamData = <
      item
        Name = 'FT_RECEIPT_ID'
        ParamType = ptInput
      end>
  end
  object HTTPRIOFiskaltrust: THTTPRIO
    OnBeforeExecute = HTTPRIOFiskaltrustBeforeExecute
    HTTPWebNode.UseUTF8InHeader = True
    HTTPWebNode.InvokeOptions = [soIgnoreInvalidCerts, soAutoCheckAccessPointViaUDDI]
    HTTPWebNode.WebNodeOptions = []
    Converter.Options = [soSendMultiRefObj, soTryAllSchema, soRootRefNodesToBody, soCacheMimeResponse, soUTF8EncodeXML]
    Left = 460
    Top = 60
  end
  object QueryGetFTFirmenname: TFDQuery
    Connection = DBase.ConnectionZEN
    FetchOptions.AssignedValues = [evMode, evRecordCountMode]
    FetchOptions.Mode = fmAll
    FetchOptions.RecordCountMode = cmTotal
    SQL.Strings = (
      
        'SELECT FIRST 1 e.fiskaltrustfirmenname, f.titel, f.text1, f.text' +
        '2, f.text3, f.text4, f.text5'
      '  FROM FIRMENTEXT f'
      
        '  join EINSTELL e on (e.firma = f.firma) or (e.firma = f.kasseid' +
        ')'
      ' WHERE (f.firma = :pFirma)'
      '    OR (f.kasseid = :pKasse)'
      '    or (f.firma = 1)'
      ' ORDER by f.kasseid DESC;')
    Left = 640
    Top = 200
    ParamData = <
      item
        Name = 'PFIRMA'
        ParamType = ptInput
      end
      item
        Name = 'PKASSE'
        ParamType = ptInput
      end>
  end
  object QueryGetFTReceiptData: TFDQuery
    Connection = DBase.ConnectionZEN
    FetchOptions.AssignedValues = [evMode, evRecordCountMode]
    FetchOptions.Mode = fmAll
    FetchOptions.RecordCountMode = cmTotal
    SQL.Strings = (
      'SELECT *'
      '  FROM FT_RECEIPT'
      ' WHERE (id = :pFTReceiptID)'
      ' ORDER by ID'
      '')
    Left = 740
    Top = 200
    ParamData = <
      item
        Name = 'PFTRECEIPTID'
        ParamType = ptInput
      end>
  end
  object QuerySetQRCodeFile: TFDQuery
    Connection = DBase.ConnectionZEN
    FetchOptions.AssignedValues = [evMode, evRecordCountMode]
    FetchOptions.Mode = fmAll
    FetchOptions.RecordCountMode = cmTotal
    SQL.Strings = (
      'update FT_SIGNATUREITEMS'
      '  set QRCODEFILE = :pQRCODEFILE'
      'where ID = :pID '
      '  and SIGNATUREFORMAT = 3')
    Left = 180
    Top = 100
    ParamData = <
      item
        Name = 'PQRCODEFILE'
        ParamType = ptInput
      end
      item
        Name = 'PID'
        ParamType = ptInput
      end>
  end
  object RestClientFiskaltrust: TRESTClient
    Accept = 'application/json, text/plain; q=0.9, text/html;q=0.8,'
    AcceptCharset = 'UTF-8, *;q=0.8'
    BaseURL = 'https://signaturcloud-sandbox.fiskaltrust.at/json/echo'
    Params = <>
    HandleRedirects = True
    RaiseExceptionOn500 = False
    Left = 460
    Top = 200
  end
  object RestRequestFiskaltrust: TRESTRequest
    Client = RestClientFiskaltrust
    Method = rmPOST
    Params = <
      item
        Kind = pkHTTPHEADER
        name = 'Content-Type'
        Options = [poDoNotEncode]
        Value = 'application/json'
      end
      item
        Kind = pkHTTPHEADER
        name = 'cashboxid'
        Options = [poDoNotEncode]
        Value = '45b5f173-6cfc-44a6-8ac3-d127d7357f2e'
      end
      item
        Kind = pkHTTPHEADER
        name = 'accesstoken'
        Options = [poDoNotEncode]
        Value = 
          'BHada6AGDQEU2IdWo4Uz1ILruSPw0ffkZ0QUN2Z5IGCM/zoxbCcPAQggEA+W7NEL' +
          'fT1OvmFoajVLXY5lbtoSskc='
      end
      item
        Kind = pkREQUESTBODY
        name = 'body'
        Options = [poDoNotEncode]
        Value = '"Test-Fiskaltrust-Signature-Cloud"'
        ContentType = ctAPPLICATION_JSON
      end>
    Response = RestResponseFiskaltrust
    SynchronizedEvents = False
    Left = 460
    Top = 260
  end
  object RestResponseFiskaltrust: TRESTResponse
    ContentType = 'application/json'
    Left = 460
    Top = 320
  end
end
