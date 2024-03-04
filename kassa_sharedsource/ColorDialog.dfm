object ColorForm: TColorForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Farbauswahl'
  ClientHeight = 278
  ClientWidth = 213
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  TextHeight = 13
  object ShapeA1: TShape
    Left = 16
    Top = 32
    Width = 25
    Height = 25
    Brush.Color = 7664628
    OnMouseUp = ShapeA1MouseUp
  end
  object ShapeA2: TShape
    Left = 47
    Top = 32
    Width = 25
    Height = 25
    Brush.Color = 254715
    OnMouseUp = ShapeA1MouseUp
  end
  object ShapeA3: TShape
    Left = 78
    Top = 32
    Width = 25
    Height = 25
    Brush.Color = 50424
    OnMouseUp = ShapeA1MouseUp
  end
  object ShapeA4: TShape
    Left = 109
    Top = 32
    Width = 25
    Height = 25
    Brush.Color = 2660600
    OnMouseUp = ShapeA1MouseUp
  end
  object ShapeA5: TShape
    Left = 140
    Top = 32
    Width = 25
    Height = 25
    Brush.Color = 4748787
    OnMouseUp = ShapeA1MouseUp
  end
  object ShapeA6: TShape
    Left = 171
    Top = 32
    Width = 25
    Height = 25
    Brush.Color = 4612305
    OnMouseUp = ShapeA1MouseUp
  end
  object ShapeB1: TShape
    Left = 16
    Top = 63
    Width = 25
    Height = 25
    Brush.Color = 11776502
    OnMouseUp = ShapeA1MouseUp
  end
  object ShapeB2: TShape
    Left = 47
    Top = 63
    Width = 25
    Height = 25
    Brush.Color = 13217784
    OnMouseUp = ShapeA1MouseUp
  end
  object ShapeB3: TShape
    Left = 78
    Top = 63
    Width = 25
    Height = 25
    Brush.Color = 6704368
    OnMouseUp = ShapeA1MouseUp
  end
  object ShapeB4: TShape
    Left = 109
    Top = 63
    Width = 25
    Height = 25
    Brush.Color = 6440911
    OnMouseUp = ShapeA1MouseUp
  end
  object ShapeB5: TShape
    Left = 140
    Top = 63
    Width = 25
    Height = 25
    Brush.Color = 5131473
    OnMouseUp = ShapeA1MouseUp
  end
  object ShapeB6: TShape
    Left = 171
    Top = 63
    Width = 25
    Height = 25
    Brush.Color = 592291
    OnMouseUp = ShapeA1MouseUp
  end
  object ShapeC1: TShape
    Left = 16
    Top = 94
    Width = 25
    Height = 25
    Brush.Color = 921222
    OnMouseUp = ShapeA1MouseUp
  end
  object ShapeC2: TShape
    Left = 47
    Top = 94
    Width = 25
    Height = 25
    Brush.Color = 14388176
    OnMouseUp = ShapeA1MouseUp
  end
  object ShapeC3: TShape
    Left = 78
    Top = 94
    Width = 25
    Height = 25
    Brush.Color = 13008031
    OnMouseUp = ShapeA1MouseUp
  end
  object ShapeC4: TShape
    Left = 109
    Top = 94
    Width = 25
    Height = 25
    Brush.Color = 10442626
    OnMouseUp = ShapeA1MouseUp
  end
  object ShapeC5: TShape
    Left = 140
    Top = 94
    Width = 25
    Height = 25
    Brush.Color = 12682369
    OnMouseUp = ShapeA1MouseUp
  end
  object ShapeC6: TShape
    Left = 171
    Top = 94
    Width = 25
    Height = 25
    Brush.Color = 9788512
    OnMouseUp = ShapeA1MouseUp
  end
  object ShapeD1: TShape
    Left = 16
    Top = 125
    Width = 25
    Height = 25
    Brush.Color = 14141625
    OnMouseUp = ShapeA1MouseUp
  end
  object ShapeD2: TShape
    Left = 47
    Top = 125
    Width = 25
    Height = 25
    Brush.Color = 12098441
    OnMouseUp = ShapeA1MouseUp
  end
  object ShapeD3: TShape
    Left = 78
    Top = 125
    Width = 25
    Height = 25
    Brush.Color = 14987920
    OnMouseUp = ShapeA1MouseUp
  end
  object ShapeD4: TShape
    Left = 109
    Top = 125
    Width = 25
    Height = 25
    Brush.Color = 9992280
    OnMouseUp = ShapeA1MouseUp
  end
  object ShapeD5: TShape
    Left = 140
    Top = 125
    Width = 25
    Height = 25
    Brush.Color = 11167804
    OnMouseUp = ShapeA1MouseUp
  end
  object ShapeD6: TShape
    Left = 171
    Top = 125
    Width = 25
    Height = 25
    Brush.Color = 15389833
    OnMouseUp = ShapeA1MouseUp
  end
  object ShapeE1: TShape
    Left = 16
    Top = 156
    Width = 25
    Height = 25
    Brush.Color = 11769904
    OnMouseUp = ShapeA1MouseUp
  end
  object ShapeE2: TShape
    Left = 47
    Top = 156
    Width = 25
    Height = 25
    Brush.Color = 12303200
    OnMouseUp = ShapeA1MouseUp
  end
  object ShapeE3: TShape
    Left = 78
    Top = 156
    Width = 25
    Height = 25
    Brush.Color = 8423561
    OnMouseUp = ShapeA1MouseUp
  end
  object ShapeE4: TShape
    Left = 109
    Top = 156
    Width = 25
    Height = 25
    Brush.Color = 7172390
    OnMouseUp = ShapeA1MouseUp
  end
  object ShapeE5: TShape
    Left = 140
    Top = 156
    Width = 25
    Height = 25
    Brush.Color = 4287762
    OnMouseUp = ShapeA1MouseUp
  end
  object ShapeE6: TShape
    Left = 171
    Top = 156
    Width = 25
    Height = 25
    Brush.Color = 3300358
    OnMouseUp = ShapeA1MouseUp
  end
  object Label1: TLabel
    Left = 16
    Top = 13
    Width = 101
    Height = 13
    Caption = 'Empfohlene Farben'
  end
  object MoreColorsButton: TButton
    Left = 16
    Top = 195
    Width = 180
    Height = 25
    Caption = 'Weitere Farben...'
    TabOrder = 0
    OnClick = MoreColorsButtonClick
  end
  object OkButton: TButton
    Left = 16
    Top = 240
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object CancelButton: TButton
    Left = 97
    Top = 240
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Abbruch'
    ModalResult = 2
    TabOrder = 2
  end
  object ColorDialog: TColorDialog
    Color = 16380798
    Options = [cdFullOpen, cdSolidColor]
    Left = 184
    Top = 65528
  end
end
