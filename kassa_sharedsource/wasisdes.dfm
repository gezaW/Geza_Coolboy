object fmwasisdes: Tfmwasisdes
  Left = 0
  Top = 0
  Caption = 'fmwasisdes'
  ClientHeight = 86
  ClientWidth = 228
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 13
  object TimerWasisdes: TTimer
    Enabled = False
    Interval = 50000
    OnTimer = TimerWasisdesTimer
    Left = 108
    Top = 24
  end
end
