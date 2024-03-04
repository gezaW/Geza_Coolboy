object employee_control: Temployee_control
  Left = 0
  Top = 0
  Caption = 'Mitarbeiter Control'
  ClientHeight = 145
  ClientWidth = 283
  Color = clBtnFace
  CustomTitleBar.SystemButtons = False
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  TextHeight = 13
  object Label1: TLabel
    Left = 64
    Top = 32
    Width = 27
    Height = 13
    Caption = 'Name'
  end
  object Label2: TLabel
    Left = 64
    Top = 80
    Width = 44
    Height = 13
    Caption = 'Passwort'
  end
  object EditEmployeeName: TEdit
    Left = 64
    Top = 53
    Width = 121
    Height = 21
    TabOrder = 0
  end
  object EditPassword: TEdit
    Left = 64
    Top = 99
    Width = 121
    Height = 21
    PasswordChar = '*'
    TabOrder = 1
    OnKeyPress = EditPasswordKeyPress
  end
  object ButtonCheck: TButton
    Left = 208
    Top = 97
    Width = 25
    Height = 25
    Caption = '>>'
    TabOrder = 2
    OnClick = ButtonCheckClick
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 126
    Width = 283
    Height = 19
    Panels = <
      item
        Width = 50
      end>
    ExplicitTop = 123
    ExplicitWidth = 275
  end
end
