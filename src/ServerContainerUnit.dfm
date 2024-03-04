object ServerContainer1: TServerContainer1
  Height = 271
  Width = 415
  object DSServer1: TDSServer
    Left = 48
    Top = 11
  end
  object DSAuthenticationManager1: TDSAuthenticationManager
    OnUserAuthenticate = DSAuthenticationManager1UserAuthenticate
    OnUserAuthorize = DSAuthenticationManager1UserAuthorize
    Roles = <>
    Left = 48
    Top = 85
  end
  object DSServerClassAPI: TDSServerClass
    OnGetClass = DSServerClassAPIGetClass
    Server = DSServer1
    Left = 168
    Top = 11
  end
  object DSServerClassCD: TDSServerClass
    OnGetClass = DSServerClassCDGetClass
    Server = DSServer1
    Left = 272
    Top = 11
  end
  object DSServerClassEF: TDSServerClass
    OnGetClass = DSServerClassEFGetClass
    Server = DSServer1
    Left = 272
    Top = 83
  end
end
