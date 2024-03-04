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
      'SQLDialect=1'
      'DriverID=FB')
    FetchOptions.AssignedValues = [evRowsetSize, evAutoFetchAll, evLiveWindowFastFirst]
    FetchOptions.RowsetSize = 20
    FetchOptions.AutoFetchAll = afTruncate
    FetchOptions.LiveWindowFastFirst = True
    LoginPrompt = False
    OnError = ConnectionZENError
    AfterConnect = ConnectionZENAfterConnect
    BeforeConnect = ConnectionZENBeforeConnect
    Left = 44
    Top = 24
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
    FetchOptions.AssignedValues = [evRecordCountMode, evAutoFetchAll]
    FetchOptions.RecordCountMode = cmTotal
    Left = 392
    Top = 104
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
    Left = 184
    Top = 196
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
    Left = 282
    Top = 216
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
    Left = 400
    Top = 184
  end
  object DSQLExecute: TFDQuery
    Connection = ConnectionZEN
    Left = 504
    Top = 160
  end
  object ConnectionManager: TFDManager
    DriverDefFileAutoLoad = False
    ConnectionDefFileAutoLoad = False
    WaitCursor = gcrAppWait
    FetchOptions.AssignedValues = [evAutoFetchAll]
    FetchOptions.AutoFetchAll = afTruncate
    FormatOptions.AssignedValues = [fvMapRules]
    FormatOptions.OwnMapRules = True
    FormatOptions.MapRules = <
      item
        SourceDataType = dtDateTimeStamp
        TargetDataType = dtDateTime
      end
      item
        SourceDataType = dtSingle
        TargetDataType = dtDouble
      end>
    Active = True
    Left = 48
    Top = 168
  end
  object QueryFirma: TFDQuery
    Connection = ConnectionZEN
    SQL.Strings = (
      
        'select fs.firmenname, ft.titel, ft.text1, ft.text2, ft.text3, ft' +
        '.text4, ft.text5'
      'from firmenstamm fs'
      'JOIN firmentext ft on ft.firma=fs.firma')
    Left = 168
    Top = 16
  end
  object ConnectionFelix: TFDConnection
    Params.Strings = (
      'User_Name=SYSDBA'
      'Password=x'
      'DriverID=FB')
    Left = 48
    Top = 280
  end
  object QueryFelix: TFDQuery
    Connection = ConnectionFelix
    ResourceOptions.AssignedValues = [rvParamCreate]
    ResourceOptions.ParamCreate = False
    Left = 48
    Top = 360
  end
end
