unit DataModulCashDesk;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client, FireDAC.Phys.FB, FireDAC.Phys.FBDef, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet;

type
  TDMCashDesk = class(TDataModule)
    ConnectionFelix: TFDConnection;
    ConnectionZen: TFDConnection;
    FDQuery1: TFDQuery;
    QueryGetWorkAreaPicture: TFDQuery;
    QueryGetWorkAreaByName: TFDQuery;
    QueryGetAllTables: TFDQuery;
    QueryUpdatePlanDB: TFDQuery;
    QueryGetWorkArea: TFDQuery;
    FDQuery2: TFDQuery;
    QueryGetPlanDB: TFDQuery;
    FDStoredProcGetHTML: TFDStoredProc;
    QuerySetNewTableId: TFDQuery;
    QueryCheckTableReservId: TFDQuery;
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }

  end;

var
  DMCashDesk: TDMCashDesk;

implementation
uses DataModule;
{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TDMCashDesk }


end.
