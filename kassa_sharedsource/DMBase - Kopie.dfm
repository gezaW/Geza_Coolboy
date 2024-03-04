object DBase: TDBase
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 492
  Width = 625
  object DSQueryKasse: TDataSource
    DataSet = QueryKasse
    Left = 284
    Top = 150
  end
  object IdMessage: TIdMessage
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
    Left = 572
    Top = 12
  end
  object IdIPWatch: TIdIPWatch
    Active = False
    HistoryFilename = 'iphist.dat'
    Left = 516
    Top = 16
  end
  object IdSMTP: TIdSMTP
    PipeLine = True
    Host = 'mail.gms.info'
    SASLMechanisms = <>
    Left = 576
    Top = 68
  end
  object TimerConnect: TTimer
    Enabled = False
    OnTimer = TimerConnectTimer
    Left = 420
    Top = 24
  end
  object ConnectionZEN: TFDConnection
    Params.Strings = (
      'Database=C:\GMS\KassaTouch\data\KASSE.FDB'
      'User_Name=SYSDBA'
      'Password=x'
      'DriverID=FB')
    FetchOptions.AssignedValues = [evAutoFetchAll]
    FetchOptions.AutoFetchAll = afTruncate
    LoginPrompt = False
    OnError = ConnectionZENError
    AfterConnect = ConnectionZENAfterConnect
    BeforeConnect = ConnectionZENBeforeConnect
    Left = 44
    Top = 24
  end
  object TransactionZEN: TFDTransaction
    Connection = ConnectionZEN
    Left = 44
    Top = 88
  end
  object TableFirma: TFDTable
    Connection = ConnectionZEN
    UpdateOptions.UpdateTableName = 'FIRMENSTAMM'
    TableName = 'FIRMENSTAMM'
    Left = 188
    Top = 20
  end
  object TableDiverses: TFDTable
    Connection = ConnectionZEN
    UpdateOptions.UpdateTableName = 'DIVERSES'
    TableName = 'DIVERSES'
    Left = 172
    Top = 96
  end
  object QueryGetNextID: TFDQuery
    Connection = ConnectionZEN
    Left = 284
    Top = 24
  end
  object QueryShort: TFDQuery
    Connection = ConnectionZEN
    Left = 384
    Top = 240
  end
  object QueryKasse: TFDQuery
    Connection = ConnectionZEN
    SQL.Strings = (
      'Select * from Kasse Order by '
      'Firma, KasseID')
    Left = 280
    Top = 96
  end
  object QueryEinstell: TFDQuery
    Connection = ConnectionZEN
    SQL.Strings = (
      'SELECT * FROM Einstell'
      'WHERE Firma = :KasseID')
    Left = 224
    Top = 300
    ParamData = <
      item
        Name = 'KASSEID'
        ParamType = ptInput
      end>
  end
  object QuerySchlossOptionen: TFDQuery
    Connection = ConnectionZEN
    SQL.Strings = (
      'SELECT * FROM Schloss_Optionen'
      'WHERE kasseID = :KasseID')
    Left = 330
    Top = 304
    ParamData = <
      item
        Name = 'KASSEID'
        ParamType = ptInput
      end>
  end
  object ScriptExecuteSQL: TFDScript
    SQLScripts = <>
    Connection = ConnectionZEN
    Params = <>
    Macros = <>
    Left = 496
    Top = 336
  end
  object DSQLExecute: TFDQuery
    Connection = ConnectionZEN
    Left = 504
    Top = 160
  end
end
