object fmDEPExport: TfmDEPExport
  Left = 316
  Top = 214
  BorderStyle = bsNone
  Caption = 'Datenerfassungsprotokoll - Export'
  ClientHeight = 569
  ClientWidth = 381
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -19
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  TextHeight = 23
  object PanelHeader: TPanel
    Left = 0
    Top = 0
    Width = 381
    Height = 97
    Align = alTop
    TabOrder = 0
    ExplicitWidth = 320
    object LabelFormCaption: TW7ActiveLabel
      AlignWithMargins = True
      Left = 22
      Top = 15
      Width = 269
      Height = 58
      MouseInColor = 15026695
      MouseOutColor = 5577749
      MouseInCursor = crHandPoint
      MouseOutCursor = crDefault
      Alignment = taCenter
      Caption = 'Datenerfassungsprotokoll'#13'Export in Textdatei'
      Font.Charset = ANSI_CHARSET
      Font.Color = 5577749
      Font.Height = -24
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object ButtonCancel: TbsSkinButton
      Left = 312
      Top = 23
      Width = 42
      Height = 50
      HintImageIndex = 0
      TabOrder = 0
      SkinData = DataDesign.SkinDataOrange
      SkinDataName = 'button'
      DefaultFont.Charset = DEFAULT_CHARSET
      DefaultFont.Color = clWindowText
      DefaultFont.Height = -19
      DefaultFont.Name = 'Tahoma'
      DefaultFont.Style = [fsBold]
      DefaultWidth = 0
      DefaultHeight = 0
      UseSkinFont = False
      Transparent = False
      CheckedMode = False
      ImageIndex = -1
      AlwaysShowLayeredFrame = False
      UseSkinSize = True
      UseSkinFontColor = True
      RepeatMode = False
      RepeatInterval = 100
      AllowAllUp = False
      TabStop = True
      CanFocused = True
      Down = False
      GroupIndex = 0
      Caption = 'X'
      NumGlyphs = 1
      Spacing = 1
      Cancel = True
      OnClick = ButtonCancelClick
    end
  end
  object PanelFinanzDEPType: TPanel
    Left = 0
    Top = 97
    Width = 381
    Height = 152
    Align = alTop
    TabOrder = 1
    Visible = False
    ExplicitWidth = 320
    DesignSize = (
      381
      152)
    object RadioGroupFinazDEP: TRadioGroup
      Left = 22
      Top = 16
      Width = 393
      Height = 113
      Anchors = [akLeft, akTop, akRight, akBottom]
      Caption = ' Finanz DEP '
      ItemIndex = 1
      Items.Strings = (
        'fiskaltrust.at - Journal - Export'
        'GMS - RKSV Bareinnahmen Export')
      TabOrder = 0
      ExplicitWidth = 332
    end
  end
  object PanelZeitraum: TPanel
    Left = 0
    Top = 249
    Width = 381
    Height = 160
    Align = alTop
    TabOrder = 2
    ExplicitWidth = 320
    DesignSize = (
      381
      160)
    object DateVon: TAdvDateTimePicker
      Left = 22
      Top = 41
      Width = 141
      Height = 31
      Date = 42310.662731481480000000
      Format = ''
      Time = 42310.662731481480000000
      DoubleBuffered = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = []
      Kind = dkDate
      ParentDoubleBuffered = False
      ParentFont = False
      TabOrder = 0
      BorderStyle = bsSingle
      Ctl3D = True
      DateTime = 42310.662731481480000000
      Version = '1.3.2.1'
      LabelCaption = 'Von:'
      LabelPosition = lpTopLeft
      LabelFont.Charset = DEFAULT_CHARSET
      LabelFont.Color = clWindowText
      LabelFont.Height = -19
      LabelFont.Name = 'Tahoma'
      LabelFont.Style = []
    end
    object DateBis: TAdvDateTimePicker
      Left = 213
      Top = 41
      Width = 141
      Height = 31
      Date = 42310.662731481480000000
      Format = ''
      Time = 42310.662731481480000000
      DoubleBuffered = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = []
      Kind = dkDate
      ParentDoubleBuffered = False
      ParentFont = False
      TabOrder = 1
      BorderStyle = bsSingle
      Ctl3D = True
      DateTime = 42310.662731481480000000
      Version = '1.3.2.1'
      LabelCaption = 'Bis:'
      LabelPosition = lpTopLeft
      LabelFont.Charset = DEFAULT_CHARSET
      LabelFont.Color = clWindowText
      LabelFont.Height = -19
      LabelFont.Name = 'Tahoma'
      LabelFont.Style = []
    end
    object DirectorySave: TAdvDirectoryEdit
      Left = 22
      Top = 105
      Width = 393
      Height = 31
      DefaultHandling = True
      EmptyTextStyle = []
      LabelCaption = 'Speicherort:'
      LabelPosition = lpTopLeft
      LabelFont.Charset = DEFAULT_CHARSET
      LabelFont.Color = clWindowText
      LabelFont.Height = -19
      LabelFont.Name = 'Tahoma'
      LabelFont.Style = []
      Lookup.Font.Charset = DEFAULT_CHARSET
      Lookup.Font.Color = clWindowText
      Lookup.Font.Height = -11
      Lookup.Font.Name = 'Arial'
      Lookup.Font.Style = []
      Lookup.Separator = ';'
      Anchors = [akLeft, akTop, akRight]
      Color = clWindow
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      Text = ''
      Visible = True
      Version = '1.5.0.2'
      ButtonStyle = bsButton
      ButtonWidth = 18
      Flat = False
      Etched = False
      Glyph.Data = {
        CE000000424DCE0000000000000076000000280000000C0000000B0000000100
        0400000000005800000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00F00000000FFF
        00000088888880FF00000B088888880F00000BB08888888000000BBB00000000
        00000BBBBBBB0B0F00000BBB00000B0F0000F000BBBBBB0F0000FF0BBBBBBB0F
        0000FF0BBB00000F0000FFF000FFFFFF0000}
      ReadOnly = False
      AllowNewFolder = True
      BrowseDialogText = 'Select Directory'
    end
  end
  object PanelFooter: TPanel
    Left = 0
    Top = 409
    Width = 381
    Height = 160
    Align = alTop
    TabOrder = 3
    ExplicitWidth = 320
    DesignSize = (
      381
      160)
    object ProgressBarDEP: TAdvSmoothProgressBar
      Left = 22
      Top = 16
      Width = 393
      Height = 24
      Step = 1.000000000000000000
      Maximum = 100.000000000000000000
      Appearance.Transparent = True
      Appearance.BackGroundFill.Color = clNone
      Appearance.BackGroundFill.ColorTo = 16765615
      Appearance.BackGroundFill.ColorMirror = clNone
      Appearance.BackGroundFill.ColorMirrorTo = clNone
      Appearance.BackGroundFill.GradientType = gtVertical
      Appearance.BackGroundFill.GradientMirrorType = gtSolid
      Appearance.BackGroundFill.BorderColor = clSilver
      Appearance.BackGroundFill.Rounding = 0
      Appearance.BackGroundFill.ShadowOffset = 0
      Appearance.BackGroundFill.Glow = gmNone
      Appearance.ProgressFill.Color = 16773091
      Appearance.ProgressFill.ColorTo = 16768452
      Appearance.ProgressFill.ColorMirror = 16765357
      Appearance.ProgressFill.ColorMirrorTo = 16767936
      Appearance.ProgressFill.GradientType = gtVertical
      Appearance.ProgressFill.GradientMirrorType = gtVertical
      Appearance.ProgressFill.BorderColor = 16765357
      Appearance.ProgressFill.Rounding = 0
      Appearance.ProgressFill.ShadowOffset = 0
      Appearance.ProgressFill.Glow = gmNone
      Appearance.Font.Charset = DEFAULT_CHARSET
      Appearance.Font.Color = clWindowText
      Appearance.Font.Height = -11
      Appearance.Font.Name = 'Tahoma'
      Appearance.Font.Style = []
      Appearance.ProgressFont.Charset = DEFAULT_CHARSET
      Appearance.ProgressFont.Color = clWindowText
      Appearance.ProgressFont.Height = -11
      Appearance.ProgressFont.Name = 'Tahoma'
      Appearance.ProgressFont.Style = []
      Appearance.ValueFormat = '%.0f%%'
      Appearance.ValueType = vtPercentage
      Appearance.ValueVisible = True
      Version = '1.9.0.3'
      Anchors = [akLeft, akTop, akRight]
      ExplicitWidth = 332
      TMSStyle = 0
    end
    object ButtonStartExport: TbsSkinButton
      Left = 22
      Top = 87
      Width = 332
      Height = 50
      HintImageIndex = 0
      TabOrder = 1
      SkinData = DataDesign.SkinDataOrange
      SkinDataName = 'button'
      DefaultFont.Charset = DEFAULT_CHARSET
      DefaultFont.Color = clWindowText
      DefaultFont.Height = -19
      DefaultFont.Name = 'Tahoma'
      DefaultFont.Style = [fsBold]
      DefaultWidth = 0
      DefaultHeight = 0
      UseSkinFont = True
      Transparent = False
      CheckedMode = False
      ImageIndex = -1
      AlwaysShowLayeredFrame = False
      UseSkinSize = True
      UseSkinFontColor = True
      RepeatMode = False
      RepeatInterval = 100
      AllowAllUp = False
      TabStop = True
      CanFocused = True
      Down = False
      GroupIndex = 0
      Caption = 'Export starten'
      NumGlyphs = 1
      Spacing = 1
      OnClick = ButtonStartExportClick
    end
  end
  object QueryDEP: TFDQuery
    Connection = DBase.ConnectionZEN
    SQL.Strings = (
      '/* Orders */'
      
        'select r.DATUM, r.RECHNUNGSNUMMER, r.ID as Rechnungsid, 0 as Zah' +
        'lwegsid, rk.ID as Rechnungskontoid,'
      'cast('#39'30.12.1899 00:00:00'#39' as timestamp) as Zeit, '#39#39' as Zahlweg,'
      'r.ZIMMERID as kasseid, 0 as Nachlass, r.ZAHLUNGSBETRAG,'
      
        'trim(COALESCE(k.VORNAME,'#39' '#39')||'#39' '#39'||COALESCE(k.NACHNAME, '#39' '#39')) as' +
        ' kellner, trim(COALESCE(g.VORNAME, '#39' '#39')||'#39' '#39'||COALESCE(g.NACHNAM' +
        'E, '#39' '#39')) as gast, g.ORT, t.TISCHNR as tisch,'
      
        'rk.MENGE, rk.BETRAG, st.MWST, (rk.MENGE * rk.BETRAG) as Gesamtbe' +
        'trag, a.BEZEICHNUNG as artikel, hg.BEZEICHNUNG as hauptgruppe'
      ''
      'from RECHNUNG r'
      
        '           join RECHNUNGSKONTO rk   on rk.FIRMA=r.FIRMA and rk.R' +
        'ECHNUNGSID=r.ID and rk.MENGE<>0'
      
        'left outer join ARTIKEL a           on a.FIRMA=rk.FIRMA and a.AR' +
        'TIKELID=rk.ARTIKELID'
      
        'Left Outer Join UNTERGRUPPE ug      on ug.FIRMA=a.FIRMA and ug.U' +
        'NTERGRUPPEID=a.UNTERGRUPPEID'
      
        'Left Outer Join HAUPTGRUPPE hg      on hg.FIRMA=ug.FIRMA and hg.' +
        'HAUPTGRUPPEID=ug.HAUPTGRUPPEID'
      
        'Left outer join STEUER st           on st.FIRMA=hg.FIRMA and st.' +
        'ID=hg.STEUERID'
      ''
      
        'left outer join OFFENETISCHE ot     on ot.FIRMA=r.FIRMA and ot.O' +
        'FFENETISCHID=r.RESERVID'
      
        'left outer join TISCH t             on t.FIRMA=ot.FIRMA and t.TI' +
        'SCHID=ot.TISCHID'
      
        'left outer join KELLNER k           on k.FIRMA=r.FIRMA and k.KEL' +
        'LNERID=r.ERSTELLERID'
      
        'left outer join GAESTESTAMM g       on g.FIRMA=r.FIRMA and g.ID=' +
        'r.ADRESSEID'
      ''
      
        'where r.DATUM >= :VonDatum and r.DATUM <= :BisDatum and r.RECHNU' +
        'NGSNUMMER > -1'
      ''
      '/* Receipts and Reversals */'
      'union all'
      
        'select r.DATUM, r.RECHNUNGSNUMMER, r.ID as Rechnungsid, z.id AS ' +
        'Zahlwegsid, 0 as Rechnungskontoid,'
      
        'cast(j.zeit as timestamp) as Zeit, iif(z.BEZEICHNUNG is NULL, ii' +
        'f(j.journaltyp=2, '#39'Rechnung'#39', '#39'Reaktivierung'#39'), z.bezeichnung) a' +
        's Zahlweg,'
      
        'r.ZIMMERID as kasseid, r.NACHLASS, iif(r.zahlungsbetrag is null,' +
        ' j.betrag, r.zahlungsbetrag) as ZAHLUNGSBETRAG,'
      
        'trim(COALESCE(k.VORNAME,'#39' '#39')||'#39' '#39'||COALESCE(k.NACHNAME, '#39' '#39')) as' +
        ' kellner, trim(COALESCE(g.VORNAME, '#39' '#39')||'#39' '#39'||COALESCE(g.NACHNAM' +
        'E, '#39' '#39')) as gast, g.ORT, t.TISCHNR as tisch,'
      
        '1 as MENGE, iif(rz.BETRAG is null, j.betrag, rz.BETRAG) as betra' +
        'g, 0, iif(rz.BETRAG is null, j.betrag, rz.BETRAG) as Gesamtbetra' +
        'g, '#39#39' as artikel, '#39#39' as hauptgruppe'
      ''
      'from RECHNUNG r'
      
        'left outer join rechnungszahlweg rz on rz.FIRMA=r.FIRMA and rz.r' +
        'echnungsid=r.id'
      
        'left outer join ZAHLWEG z           on z.FIRMA=rz.FIRMA and z.ID' +
        '=rz.zahlwegid'
      
        'left OUTER JOIN journal j           on j.rechnungsid=r.id and j.' +
        'journaltyp in (2,5)'
      ''
      
        'left outer join OFFENETISCHE ot     on ot.FIRMA=r.FIRMA and ot.O' +
        'FFENETISCHID=r.RESERVID'
      
        'left outer join TISCH t             on t.FIRMA=ot.FIRMA and t.TI' +
        'SCHID=ot.TISCHID'
      
        'left outer join KELLNER k           on k.FIRMA=r.FIRMA and k.KEL' +
        'LNERID=r.ERSTELLERID'
      
        'left outer join GAESTESTAMM g       on g.FIRMA=r.FIRMA and g.ID=' +
        'r.ADRESSEID'
      ''
      
        'where r.DATUM >= :VonDatum and r.DATUM <= :BisDatum and r.RECHNU' +
        'NGSNUMMER > -1'
      ''
      '/* Archiv-Orders */'
      'union all'
      
        'select r.DATUM, r.RECHNUNGSNUMMER, r.ID as Rechnungsid, 0 as Zah' +
        'lwegsid, rk.ID as Rechnungskontoid,'
      'cast('#39'30.12.1899 00:00:00'#39' as timestamp) as Zeit, '#39#39' as Zahlweg,'
      'r.ZIMMERID as kasseid, 0 as Nachlass, r.ZAHLUNGSBETRAG,'
      
        'trim(COALESCE(k.VORNAME,'#39' '#39')||'#39' '#39'||COALESCE(k.NACHNAME, '#39' '#39')) as' +
        ' kellner, trim(COALESCE(g.VORNAME, '#39' '#39')||'#39' '#39'||COALESCE(g.NACHNAM' +
        'E, '#39' '#39')) as gast, g.ORT, t.TISCHNR as tisch,'
      
        'rk.MENGE, rk.BETRAG, st.MWST, (rk.MENGE * rk.BETRAG) as Gesamtbe' +
        'trag, a.BEZEICHNUNG as artikel, hg.BEZEICHNUNG as hauptgruppe'
      ''
      'from RECHNUNGARCHIV r'
      
        '       join RECHNUNGSKONTOARCHIV rk on rk.FIRMA=r.FIRMA and rk.R' +
        'ECHNUNGSID=r.ID and rk.MENGE<>0'
      
        'left outer join ARTIKEL a           on a.FIRMA=rk.FIRMA and a.AR' +
        'TIKELID=rk.ARTIKELID'
      
        'Left Outer Join UNTERGRUPPE ug      on ug.FIRMA=a.FIRMA and ug.U' +
        'NTERGRUPPEID=a.UNTERGRUPPEID'
      
        'Left Outer Join HAUPTGRUPPE HG      on hg.FIRMA=ug.FIRMA and hg.' +
        'HAUPTGRUPPEID=ug.HAUPTGRUPPEID'
      
        'Left outer join STEUER st           on st.FIRMA=hg.FIRMA and st.' +
        'ID=hg.STEUERID'
      ''
      
        'left outer join TISCH t             on t.FIRMA=r.FIRMA and t.TIS' +
        'CHID=r.RESERVID'
      
        'left outer join KELLNER k           on k.FIRMA=r.FIRMA and k.KEL' +
        'LNERID=r.ERSTELLERID'
      
        'left outer join GAESTESTAMM g       on g.FIRMA=r.FIRMA and g.ID=' +
        'r.ADRESSEID'
      ''
      
        'where r.DATUM >= :VonDatum and r.DATUM <= :BisDatum and r.RECHNU' +
        'NGSNUMMER > -1'
      ''
      '/* Archive-Receipts and -Reversals */'
      'union all'
      
        'select r.DATUM, r.RECHNUNGSNUMMER, r.ID as Rechnungsid, z.id as ' +
        'Zahlwegsid, 0 as Rechnungskontoid,'
      
        'cast(j.zeit as timestamp) as Zeit, iif(z.BEZEICHNUNG is NULL, ii' +
        'f(j.journaltyp=2, '#39'Rechnung'#39', '#39'Reaktivierung'#39'), z.bezeichnung) a' +
        's Zahlweg,'
      'r.ZIMMERID as kasseid, 0 as Nachlass, r.ZAHLUNGSBETRAG,'
      
        'trim(COALESCE(k.VORNAME,'#39' '#39')||'#39' '#39'||COALESCE(k.NACHNAME, '#39' '#39')) as' +
        ' kellner, trim(COALESCE(g.VORNAME, '#39' '#39')||'#39' '#39'||COALESCE(g.NACHNAM' +
        'E, '#39' '#39')) as gast, g.ORT, t.TISCHNR as tisch,'
      
        '1 as MENGE, iif(rz.BETRAG is null, j.betrag, rz.BETRAG) as betra' +
        'g, 0, iif(rz.BETRAG is null, j.betrag, rz.BETRAG) as Gesamtbetra' +
        'g, '#39#39' as artikel, '#39#39' as hauptgruppe'
      ''
      'from RECHNUNGARCHIV r'
      
        'left outer join rechnungszahlwegarchiv rz on rz.FIRMA=r.FIRMA an' +
        'd rz.RECHNUNGSID=r.ID'
      
        'left outer join ZAHLWEG z           on z.FIRMA=rz.FIRMA and z.ID' +
        '=rz.ZAHLWEGID'
      
        'left OUTER JOIN journalarchiv j     on j.rechnungsid=r.id and j.' +
        'journaltyp in (2,5)'
      ''
      
        'left outer join TISCH t             on t.FIRMA=r.FIRMA and t.TIS' +
        'CHID=r.RESERVID'
      
        'left outer join KELLNER k           on k.FIRMA=r.FIRMA and k.KEL' +
        'LNERID=r.ERSTELLERID'
      
        'left outer join GAESTESTAMM g       on g.FIRMA=r.FIRMA and g.ID=' +
        'r.ADRESSEID'
      ''
      
        'where r.DATUM >= :VonDatum and r.DATUM <= :BisDatum and r.RECHNU' +
        'NGSNUMMER > -1'
      ''
      'order by 1,2,3,4,5'
      '')
    Left = 62
    Top = 422
    ParamData = <
      item
        Name = 'VONDATUM'
        ParamType = ptInput
      end
      item
        Name = 'BISDATUM'
        ParamType = ptInput
      end>
  end
end
