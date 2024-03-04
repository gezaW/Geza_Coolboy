object fmTouchKeyboard: TfmTouchKeyboard
  Left = 236
  Top = 168
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Touch Keyboard'
  ClientHeight = 356
  ClientWidth = 818
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
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
    Left = 74
    Top = 40
    Width = 741
    Height = 48
    TabOrder = 1
  end
  object EditTouchText: TEdit
    Left = 83
    Top = 47
    Width = 716
    Height = 31
    AutoSelect = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    Text = 'EditTouchText'
    OnKeyPress = EditTouchTextKeyPress
  end
  object Panel2: TPanel
    Left = 4
    Top = 4
    Width = 811
    Height = 32
    TabOrder = 2
    object Label2: TLabel
      Left = 11
      Top = 5
      Width = 95
      Height = 19
      Caption = 'Eingabe von:'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object LabelAktuelleEingabe: TLabel
      Left = 116
      Top = 5
      Width = 167
      Height = 19
      Caption = 'LabelAktuelleEingabe'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = False
    end
  end
  object TouchKeyboard1: TTouchKeyboard
    Left = 8
    Top = 94
    Width = 802
    Height = 254
    GradientEnd = clSilver
    GradientStart = clGray
    Layout = 'Standard'
  end
  object IvTranslator1: TIvTranslator
    DictionaryName = 'Dictionary1'
    Left = 25
    Top = 45
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
