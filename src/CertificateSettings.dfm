object FormCertificates: TFormCertificates
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Certificates settings'
  ClientHeight = 287
  ClientWidth = 426
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  TextHeight = 13
  object LabelCertificateName: TLabel
    Left = 24
    Top = 24
    Width = 100
    Height = 13
    Caption = 'Certificate file name:'
  end
  object LabelKeyFile: TLabel
    Left = 24
    Top = 72
    Width = 68
    Height = 13
    Caption = 'Key file name:'
  end
  object LabelKeyPassword: TLabel
    Left = 24
    Top = 120
    Width = 88
    Height = 13
    Caption = 'Key file password:'
  end
  object LabelRootCertificate: TLabel
    Left = 24
    Top = 170
    Width = 124
    Height = 13
    Caption = 'Root certificate file name:'
  end
  object EditCertificateFileName: TEdit
    Left = 24
    Top = 43
    Width = 345
    Height = 21
    TabOrder = 0
  end
  object ButtonSelectCertificate: TButton
    Left = 375
    Top = 41
    Width = 26
    Height = 25
    Caption = '...'
    TabOrder = 1
    OnClick = ButtonSelectCertificateClick
  end
  object EditKeyFileName: TEdit
    Left = 24
    Top = 91
    Width = 345
    Height = 21
    TabOrder = 2
  end
  object ButtonSelectKey: TButton
    Left = 375
    Top = 89
    Width = 26
    Height = 25
    Caption = '...'
    TabOrder = 3
    OnClick = ButtonSelectKeyClick
  end
  object EditKeyPassword: TEdit
    Left = 24
    Top = 139
    Width = 153
    Height = 21
    PasswordChar = '*'
    TabOrder = 4
  end
  object EditRootCertificateFileName: TEdit
    Left = 24
    Top = 189
    Width = 345
    Height = 21
    TabOrder = 5
  end
  object ButtonSelectRootSertificate: TButton
    Left = 375
    Top = 187
    Width = 26
    Height = 25
    Caption = '...'
    TabOrder = 6
    OnClick = ButtonSelectRootSertificateClick
  end
  object ButtonOk: TButton
    Left = 238
    Top = 240
    Width = 75
    Height = 25
    Caption = 'Ok'
    TabOrder = 7
    OnClick = ButtonOkClick
  end
  object ButtonCancel: TButton
    Left = 326
    Top = 240
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 8
    OnClick = ButtonCancelClick
  end
  object FileOpenDialog: TFileOpenDialog
    FavoriteLinks = <>
    FileTypes = <
      item
        DisplayName = 'PEM file (*.pem;*.crt;*.cer;*.key)'
        FileMask = '*.pem;*.crt;*.cer;*.key'
      end
      item
        DisplayName = 'Any file (*.*)'
        FileMask = '*.*'
      end>
    Options = []
    Left = 32
    Top = 232
  end
end
