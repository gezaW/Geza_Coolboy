object fmKeyboard_Kasse: TfmKeyboard_Kasse
  Left = 236
  Top = 168
  BorderIcons = []
  BorderStyle = bsNone
  Caption = 'Touch Keyboard'
  ClientHeight = 361
  ClientWidth = 824
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnShow = FormShow
  TextHeight = 14
  object ShapeShift: TShape
    Left = 86
    Top = 201
    Width = 15
    Height = 45
    Brush.Color = clMenu
    Shape = stRoundRect
  end
  object Panel1: TPanel
    Left = 0
    Top = 32
    Width = 824
    Height = 39
    Align = alTop
    AutoSize = True
    TabOrder = 0
    object EditTouchText: TEdit
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 816
      Height = 31
      Align = alClient
      AutoSelect = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      Text = 'EditTouchText'
      OnKeyUp = EditTouchTextKeyUp
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 824
    Height = 32
    Align = alTop
    AutoSize = True
    TabOrder = 1
    object Label2: TLabel
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 65
      Height = 24
      Align = alLeft
      Caption = 'Eingabe:'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ExplicitHeight = 19
    end
    object LabelAktuelleEingabe: TLabel
      AlignWithMargins = True
      Left = 75
      Top = 4
      Width = 745
      Height = 24
      Align = alClient
      Caption = 'LabelAktuelleEingabe'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = False
      ExplicitLeft = 105
      ExplicitWidth = 167
      ExplicitHeight = 19
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 71
    Width = 824
    Height = 290
    Align = alTop
    AutoSize = True
    TabOrder = 2
    object TouchKeyboard1: TTouchKeyboard
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 816
      Height = 282
      Align = alClient
      GradientEnd = clSilver
      GradientStart = clGray
      Layout = 'Standard'
    end
  end
  object IvTranslator1: TIvTranslator
    DictionaryName = 'Dictionary1'
    Left = 729
    Top = 237
    TargetsData = (
      1
      6
      (
        '*'
        'Hint'
        0)
      (
        '*'
        'Caption'
        0)
      (
        '*'
        'Items'
        0)
      (
        '*'
        'Filter'
        0)
      (
        'TKeyButton'
        'Caption2'
        0)
      (
        'TKeyButton'
        'Caption'
        0))
  end
end
