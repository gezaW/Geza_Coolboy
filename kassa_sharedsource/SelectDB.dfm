object frmSelectDB: TfrmSelectDB
  Left = 476
  Top = 413
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Auswahl'
  ClientHeight = 181
  ClientWidth = 294
  Color = clBtnHighlight
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnShow = FormShow
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 203
    Height = 16
    Caption = 'W'#228'hlen Sie eine Datenbank aus'
    Color = clBtnHighlight
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    WordWrap = True
  end
  object ComboBoxDB: TComboBox
    Left = 8
    Top = 30
    Width = 278
    Height = 27
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    Text = 'ComboBoxDB'
  end
  object ButtonOK: TButton
    Left = 106
    Top = 144
    Width = 180
    Height = 29
    Cancel = True
    Caption = 'OK'
    Default = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    OnClick = ButtonOKClick
  end
end