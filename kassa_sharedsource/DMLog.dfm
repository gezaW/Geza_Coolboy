object DataLog: TDataLog
  OldCreateOrder = False
  OnDestroy = DataModuleDestroy
  Height = 183
  Width = 254
  object FelixCodeSite: TCodeSiteLogger
    Destination = FelixDest
    OnSendMsg = FelixCodeSiteSendMsg
    Left = 64
    Top = 16
  end
  object FelixDest: TCodeSiteDestination
    LogFile.LogByDateFormat = 'yyyymmdd'
    TCP.Host = 'localhost'
    TCP.Port = 3434
    TCP.RemoteDestinationString = 'Viewer'
    UDP.Host = 'localhost'
    UDP.Port = 3435
    UDP.RemoteDestinationString = 'Viewer'
    Left = 64
    Top = 80
  end
  object IdSMTPFelix: TIdSMTP
    SASLMechanisms = <>
    Left = 176
    Top = 16
  end
  object IdMessageFelix: TIdMessage
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
