object DMCashDesk: TDMCashDesk
  Height = 363
  Width = 679
  object ConnectionFelix: TFDConnection
    Left = 168
    Top = 16
  end
  object ConnectionZen: TFDConnection
    Params.Strings = (
      'Protocol=Local'
      'DriverID=FB'
      'User_Name=sysdba'
      'Password=masterkey')
    Left = 56
    Top = 16
  end
  object FDQuery1: TFDQuery
    Connection = ConnectionFelix
    Left = 280
    Top = 16
  end
  object QueryGetWorkAreaPicture: TFDQuery
    Connection = ConnectionZen
    SQL.Strings = (
      'select pageid, area, imagedata, Height, Width from TablePlan  t'
      'where Firma = :pFirma'
      'and area = :pArea'
      'and not t.imagedata is null')
    Left = 56
    Top = 96
    ParamData = <
      item
        Name = 'PFIRMA'
        ParamType = ptInput
      end
      item
        Name = 'PAREA'
        ParamType = ptInput
      end>
  end
  object QueryGetWorkAreaByName: TFDQuery
    Connection = ConnectionZen
    SQL.Strings = (
      'select * from TablePlan where area = :pArea and Firma = :pFirma')
    Left = 464
    Top = 96
    ParamData = <
      item
        Name = 'PAREA'
        ParamType = ptInput
      end
      item
        Name = 'PFIRMA'
        ParamType = ptInput
      end>
  end
  object QueryGetAllTables: TFDQuery
    Connection = ConnectionZen
    SQL.Strings = (
      'select tp.*, t.TischreservId from TablePlan tp'
      
        'left outer Join Tisch t on t.TischId = tp.TableId and t.Firma = ' +
        'tp.Firma '
      'where tp.Firma = :pFirma')
    Left = 312
    Top = 100
    ParamData = <
      item
        Name = 'PFIRMA'
        ParamType = ptInput
      end>
  end
  object QueryUpdatePlanDB: TFDQuery
    Connection = ConnectionZen
    SQL.Strings = (
      
        'Update PlanDB set TischID = :pNewTischID, ResTischId = :pNewResT' +
        'ischID'
      'Where TischID = :pOldTischID AND '
      'PlannerKey = :pOldPlannerKey '
      '')
    Left = 200
    Top = 84
    ParamData = <
      item
        Name = 'PNEWTISCHID'
        ParamType = ptInput
      end
      item
        Name = 'PNEWRESTISCHID'
        ParamType = ptInput
      end
      item
        Name = 'POLDTISCHID'
        ParamType = ptInput
      end
      item
        Name = 'POLDPLANNERKEY'
        ParamType = ptInput
      end>
  end
  object QueryGetWorkArea: TFDQuery
    Connection = ConnectionZen
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    SQL.Strings = (
      'select area, imagedata from TablePlan  t'
      'where Firma = :pFirma')
    Left = 56
    Top = 160
    ParamData = <
      item
        Name = 'PFIRMA'
        ParamType = ptInput
      end>
  end
  object FDQuery2: TFDQuery
    Connection = ConnectionZen
    FetchOptions.AssignedValues = [evLiveWindowFastFirst]
    FetchOptions.LiveWindowFastFirst = True
    SQL.Strings = (
      'select IMAGEDATA'
      'from TABLEPLAN'
      'where IMAGEDATA is not null   ')
    Left = 344
    Top = 40
  end
  object QueryGetPlanDB: TFDQuery
    Connection = ConnectionZen
    SQL.Strings = (
      'SELECT * from PlanDB'
      
        'where ((tischid = :pTischId) and :pDateTimeVon between starttime' +
        ' and endtime)'
      'order by starttime,id'
      '')
    Left = 192
    Top = 168
    ParamData = <
      item
        Name = 'PTISCHID'
        ParamType = ptInput
      end
      item
        Name = 'PDATETIMEVON'
        ParamType = ptInput
      end>
  end
  object FDStoredProcGetHTML: TFDStoredProc
    Left = 320
    Top = 168
  end
  object QuerySetNewTableId: TFDQuery
    Connection = ConnectionZen
    SQL.Strings = (
      
        'update PlanDB p set p.TischId = :pNewTableId, p.ResTischId = :pN' +
        'ewTableId'
      'where p.TischId = :pOldTableid and p.FelixReservId = :pReservId'
      
        'and ((:pstarttime between starttime and endtime) or (:pEndtime b' +
        'etween starttime and endtime))'
      'returning p.id'
      '')
    Left = 488
    Top = 184
    ParamData = <
      item
        Name = 'PNEWTABLEID'
        ParamType = ptInput
      end
      item
        Name = 'POLDTABLEID'
        ParamType = ptInput
      end
      item
        Name = 'PRESERVID'
        ParamType = ptInput
      end
      item
        Name = 'PSTARTTIME'
        ParamType = ptInput
      end
      item
        Name = 'PENDTIME'
        ParamType = ptInput
      end>
  end
  object QueryCheckTableReservId: TFDQuery
    Connection = ConnectionZen
    SQL.Strings = (
      'select id from PlanDB'
      'where TischId = :pNewTableId'
      
        'and ((:pstarttime between starttime and endtime) or (:pEndtime b' +
        'etween starttime and endtime))')
    Left = 488
    Top = 248
    ParamData = <
      item
        Name = 'PNEWTABLEID'
        ParamType = ptInput
      end
      item
        Name = 'PSTARTTIME'
        ParamType = ptInput
      end
      item
        Name = 'PENDTIME'
        ParamType = ptInput
      end>
  end
end
