object DataLogging: TDataLogging
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 261
  Width = 315
  object IdSMTPKasse: TIdSMTP
    SASLMechanisms = <>
    Left = 176
    Top = 16
  end
  object IdMessageKasse: TIdMessage
    AttachmentEncoding = 'UUE'
    BccList = <>
    CCList = <>
    Encoding = meDefault
    FromList = <
      item
      end>
    Recipients = <>
    ReplyTo = <>
    ConvertPreamble = True
    Left = 176
    Top = 80
  end
end
