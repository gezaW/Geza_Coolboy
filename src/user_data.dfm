object FormUserData: TFormUserData
  Left = 0
  Top = 0
  Caption = 'User-Daten'
  ClientHeight = 348
  ClientWidth = 333
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 29
    Width = 62
    Height = 13
    Caption = 'Firmenname:'
  end
  object RichEditUserData: TRichEdit
    Left = 8
    Top = 88
    Width = 317
    Height = 252
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    Zoom = 100
  end
  object EditCompayName: TEdit
    Left = 16
    Top = 48
    Width = 121
    Height = 21
    TabOrder = 1
  end
  object ButtonReports: TButton
    Left = 192
    Top = 46
    Width = 133
    Height = 25
    Caption = 'Anzeigen'
    TabOrder = 2
    OnClick = ButtonReportsClick
  end
end
