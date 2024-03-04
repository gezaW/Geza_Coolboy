object DataEmail: TDataEmail
  OnCreate = DataModuleCreate
  Height = 150
  Width = 215
  object IdSMTP: TIdSMTP
    Host = 'mail.gms.info'
    Password = '+9874123'
    SASLMechanisms = <>
    Username = 'zenlicense'
    Left = 16
    Top = 16
  end
  object IdIPWatch: TIdIPWatch
    Active = False
    HistoryFilename = 'iphist.dat'
    Left = 160
    Top = 16
  end
end
