unit CashDeskWork;

interface

uses
  System.SysUtils, System.Classes, System.JSON,
  DataModulCashDesk, JvComponentBase, JvStrToHtml, Data.DB;

type
  TCWU = class(TDataModule)
    JvStrToHtml1: TJvStrToHtml;
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    function CheckDatabase(pDatebaseName: string; pCompanyId: integer; pCashDesk: boolean): boolean;
    function getGuestHTML(pParams: TJSONObject): TJSONObject;
    function setNewTable(pParams: TJSONObject): TJSONObject;
  end;

var
  CWU: TCWU;

implementation
 uses Logging;
{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

function TCWU.CheckDatabase(pDatebaseName: string; pCompanyId: integer; pCashDesk: boolean): boolean;
var aDM: TDMCashDesk;
begin
  try
    try
      result := false;
      aDM := TDMCashDesk.Create(nil);
      if pCashDesk then
      begin
        aDM.ConnectionZen.Params.Clear;
        aDM.ConnectionZen.ConnectionDefName := pDatebaseName;
        aDM.ConnectionZen.Connected := True;
        result := aDM.ConnectionZen.Connected;
      end
      else
      begin
        aDM.ConnectionZen.Params.Clear;
        aDM.ConnectionZen.ConnectionDefName := pDatebaseName;
        aDM.ConnectionZen.Connected := True;
        result := aDM.ConnectionZen.Connected;
      end;

    except on E: Exception do
      Log.WriteToLog(pDatebaseName, pCompanyId, '<TCWU> CheckDatabase --> Error: '+e.Message, lmtError);
    end;
  finally
    aDM.ConnectionFelix.Connected := false;
    aDM.ConnectionZen.Connected := false;
    FreeAndNil(aDM);
  end;
end;

function TCWU.getGuestHTML(pParams: TJSONObject): TJSONObject;
var aDM: TDMCashDesk;
  aCompanyName: string;
  aCompanyId: integer;
  aHTMLInfoStr, aHTMLString: string;
  aStoredProcName: string;
  aBlobStream: TStream;
  aStrStream: TstringStream;
  aIsFelix: boolean;
begin
  try
    try
      aHTMLInfoStr := '';
      aHtmlString := '';
      aCompanyName := pParams.GetValue<string>('CompanyName');
      aCompanyId := pParams.GetValue<integer>('CompanyId');
      aIsFelix := pParams.GetValue<boolean>('IsFelix');
      aDM := TDMCashDesk.Create(nil);
      if aIsFelix then
      begin
        aDM.ConnectionFelix.Params.Clear;
        aDM.ConnectionFelix.ConnectionDefName := aCompanyName;
        aDM.ConnectionFelix.Connected := True;
      end
      else
      begin
        aDM.ConnectionZen.Params.Clear;
        aDM.ConnectionZen.ConnectionDefName := aCompanyName;
        aDM.ConnectionZen.Connected := True;
      end;
    except on e: exception do
      begin
        Log.WriteToLog(aCompanyName, aCompanyId, '<TCWU> getGuestHTML/ set connection --> Error: '+e.Message, lmtError);
        aHTMLInfoStr := 'Es konnte keine Datenbankverbindung hergestellt werden. Der HTML Service ist derzeit nicht verfügbar! ';
        exit;
      end;
    end;

    try
      if not pParams.TryGetValue<string>('procedureName', aStoredProcName) then
      begin
        aHTMLInfoStr := 'Der HMTL Service wurde geändert oder nicht eingerichtet. Wenn Sie den Serviece nutzen wollen, wenden Sie sich bitte an den Support!';
        exit;
      end
      else
      begin
        if aStoredProcName = '' then
        begin
          aHTMLInfoStr := 'No HTMLService';
        end
        else
        begin
          if aIsFelix then
          begin
            aDM.FDStoredProcGetHTML.Connection := aDM.ConnectionFelix;
          end
          else
          begin
            aDM.FDStoredProcGetHTML.Connection := aDM.ConnectionZen;
          end;
          aDM.FDStoredProcGetHTML.StoredProcName := aStoredProcName;
          aDM.FDStoredProcGetHTML.AutoCalcFields := true;
          aDM.FDStoredProcGetHTML.Command.FillParams(aDM.FDStoredProcGetHTML.Params);
//          aDM.FDStoredProcGetHTML.Command.FillParams(aDM.FDStoredProcGetHTML.);
          aDM.FDStoredProcGetHTML.ParamByName('I_TISCHID').AsInteger := pParams.GetValue<integer>('deskId');
          aDM.FDStoredProcGetHTML.ParamByName('I_OFFENETISCHID').AsInteger := pParams.GetValue<integer>('openDeskId');
          aDM.FDStoredProcGetHTML.ParamByName('I_RESERVID').AsInteger := pParams.GetValue<integer>('reservId');
          aDM.FDStoredProcGetHTML.open;
          if aDM.FDStoredProcGetHTML.FieldByName('O_HTML').AsString <> '' then
          begin
            aBlobStream := aDM.FDStoredProcGetHTML.CreateBlobStream(
                          aDM.FDStoredProcGetHTML.FieldByName('O_HTML'),TBlobStreamMode.bmRead);
            aStrStream := tStringStream.Create;
            aStrStream.CopyFrom(aBlobStream, 0);
            aHtmlString := aStrStream.DataString;
          end
          else
          begin
            aHTMLInfoStr := 'Kein HTML gefunden';
          end;
        end;
      end;
    except on e: exception do
      begin
        Log.WriteToLog(aCompanyName, aCompanyId, '<TCWU> getGuestHTML/ get HTML --> Error: '+e.Message, lmtError);
        aHTMLInfoStr := 'Es ist ein Fehler beim erstellen des HTML files aufgetreten. Der HTML Service ist derzeit nicht verfügbar! ';
        exit;
      end;
    end;
  finally
    aDM.ConnectionZen.Close;
    FreeAndNil(aDM);
    result := TJSONObject.Create;
    result.AddPair('HTMLInfoStr',aHTMLInfoStr);
    result.AddPair('HTMLString',aHtmlString);
  end;
end;

function TCWU.setNewTable(pParams: TJSONObject): TJSONObject;
var aCompanyName, aResultStr: string;
  aCompanyId: integer;
  aDM: TDMCashDesk;
  aTableIsFree: boolean;
begin
  try
    try
      aCompanyName := pParams.GetValue<string>('CompanyName');
      aCompanyId := pParams.GetValue<integer>('CompanyId');
      aDM := TDMCashDesk.Create(nil);
      aDM.ConnectionZen.Params.Clear;
      aDM.ConnectionZen.ConnectionDefName := aCompanyName;
      aDM.ConnectionZen.Connected := True;

    except on e: exception do
      begin
        Log.WriteToLog(aCompanyName, aCompanyId, '<TCWU> setNewTable/ set connection --> Error: '+e.Message, lmtError);
        aResultStr := 'Fehler: Es konnte keine Datenbankverbindung hergestellt werden. ';
        exit;
      end;
    end;
    try
      try
        aTableIsFree := true;
        with aDM.QueryCheckTableReservId do
        begin
          close;
          ParamByName('pNewTableId').AsInteger := pParams.GetValue<integer>('newTableId');
          ParamByName('pStartTime').AsDateTime := StrToDateTime(pParams.GetValue<String>('from'));
          ParamByName('pEndTime').AsDateTime := StrToDateTime(pParams.GetValue<string>('to'));
          open;
          if FieldByName('Id').AsInteger > 0 then
          begin
            aTableIsFree := false;
          end;
          close;
        end;
        if aTableIsFree then
        begin
          with aDM.QuerySetNewTableId do
          begin
            close;
            ParamByName('pNewTableId').AsInteger := pParams.GetValue<integer>('newTableId');
            ParamByName('pOldTableId').AsInteger := pParams.GetValue<integer>('oldTableId');
            ParamByName('preservId').AsInteger := pParams.GetValue<integer>('reservId');
            ParamByName('pStartTime').AsDateTime := StrToDateTime(pParams.GetValue<String>('from'));
            ParamByName('pEndTime').AsDateTime := StrToDateTime(pParams.GetValue<string>('to'));
            open;
            if FieldByName('Id').AsInteger > 0 then
            begin
              aResultStr := 'Update erfolgreich';
            end;

          end;
        end
        else
        begin
          aResultStr := 'Fehler: Der Tisch ist einer anderen ReservId zugeordnet.';
        end;
      except on e: exception do
      begin
        Log.WriteToLog(aCompanyName, aCompanyId, '<TCWU> setNewTable/ set new Table --> Error: '+e.Message, lmtError);
        aResultStr := 'Fehler: Der Tisch konnte nicht geändert werden. ';
        exit;
      end;
      end;
    finally
      aDM.QuerySetNewTableId.Close;
      aDM.QueryCheckTableReservId .Close
    end;
  finally
    aDM.ConnectionZen.Close;
    FreeAndNil(aDM);
    result := TJSONObject.Create;
    result.AddPair('resultStr',aResultStr);
  end;
end;

end.
