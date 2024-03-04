unit ServerCashDeskUnit;

interface

uses
  System.SysUtils, System.Classes, System.JSON, ServerMethodsUnit,
  DataSnap.DSProviderDataModuleAdapter, Winapi.Windows,
  DataSnap.DSServer, DataSnap.DSAuth, FireDAC.Comp.Client, data.DB, VCL.Imaging.pngimage,
  VCL.Imaging.jpeg, VCL.Graphics, Vcl.ExtCtrls,
  IdCoderMime;

type
  TCD = class(TDSServerModule)
{$METHODINFO ON}
  private

    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    function createPictureForCompany(pParams: TJSONObject): TJSONObject;
    function GetWorkAreasForCompany(pParams: TJSONObject): TJSONObject;
    function GetWorkAreaTableInfos(pParams: TJSONObject): TJSONObject;
    procedure LogTischReserv(pParams: TJSONObject);//: TJSONObject;
    function getGuestHTML(pParams: TJSONObject): TJSONObject;
    function setNewTable(pParams: TJSONObject): TJSONObject;
{$METHODINFO OFF}
  end;

var
  CD: TCD;

implementation

uses Logging, DataModulCashDesk, DataModule, CashDeskWork;
{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TCD }

procedure TCD.LogTischReserv(pParams: TJSONObject);//: TJSONObject;
var
  aCompanyName: string;
  aCompanyId: integer;
  LogArray: TJsonArray;
  aLogValue, aLogType: string;
begin
  try
    aCompanyName := pParams.GetValue<string>('CompanyName');
    if aCompanyName = '' then
      aCompanyName := 'CashDesk';
    aCompanyId := pParams.GetValue<integer>('CompanyId');

    LogArray := pParams.GetValue('LogStrings') as TJsonArray;
    for var iLog in LogArray do
    begin
      aLogValue := iLog.GetValue<string>('LogStr');
      aLogType := iLog.GetValue<string>('LogType');
      if aLogType = 'Error' then
      begin
        Log.WriteToLog(aCompanyName, aCompanyId, '<TCD> Log from Cashdesk: ' + aLogValue, lmtError);
      end
      else
        if aLogType = 'Info' then
        begin
          Log.WriteToLog(aCompanyName, aCompanyId, '<TCD> Log from Cashdesk: ' + aLogValue, lmtInfo);
        end

    end;
  except
    on E: Exception do
      Log.WriteToLog(aCompanyName, aCompanyId, '<TCD> LogTischReserv Error: ' + E.Message, lmtError);
  end;
end;



function TCD.createPictureForCompany(pParams: TJSONObject): TJSONObject;
var
  aCompanyName, aAreaName: string;
  aCompanyId: integer;
  aPngString: string;
  aDM: TDMCashDesk;
  aImageStream: TMemoryStream;
  aFileStream: TFileStream;
  PngImage: TGraphic;
  base64: TIdEncoderMIME;
  aBlobField: TBlobField;
  aJsonObjectPicture: TJSONObject;
begin
  try
    try
      begin
        try
          begin
            aCompanyName := pParams.GetValue<string>('CompanyName');
            if aCompanyName = '' then
              aCompanyName := 'CashDesk';
            aCompanyId := pParams.GetValue<integer>('CompanyId');
            aAreaName := pParams.GetValue<string>('AreaName');
          end;
        except on e: exception do
          begin
            Log.WriteToLog(aCompanyName, aCompanyId, '<TCD> createPictureForCompany/read param JSON: ' +
                  E.Message, lmtError);
            raise;
          end;
        end;

        try
          begin
            aDM := TDMCashDesk.Create(nil);
            aDM.ConnectionZen.Params.Clear;
            aDM.ConnectionZen.ConnectionDefName := aCompanyName;
            aDM.ConnectionZen.Connected := True;
          end;
        except on e: exception do
          begin
            Log.WriteToLog(aCompanyName, aCompanyId, '<TCD> createPictureForCompany/create DB connection: ' +
                  E.Message, lmtError);
            raise;
          end;
        end;
        try
          begin
            with aDM.QueryGetWorkAreaPicture do
            begin
              close;
              ParamByName('pFirma').AsInteger := aCompanyId;
              ParamByName('pArea').AsString := aAreaName;
              open;
              if not FieldByName('imageData').IsNull then
              begin
                if not DirectoryExists(Log.FLogPath+'/Pictures/') then
                  CreateDir(Log.FLogPath+'/Pictures/');
                PngImage := TBitMap.Create;
                aImageStream := TMemoryStream.Create;  //CreateBlobStream(FieldByName('imageData'), bmRead);//
                aBlobField := FieldByName('imageData') AS TBlobField;
                aBlobField.SaveToStream(aImageSTream);
                aImageSTream.Position := 0;
                PNGImage.LoadFromStream(aImageStream);
                PNGImage.SaveToFile(Log.FLogPath+'/Pictures/image'+FieldByName('pageID').ASString+'.png');
                aFileStream := TFileStream.Create(Log.FLogPath+'/Pictures/image'+
                                  FieldByName('pageID').ASString+'.png',fmOpenRead);
                base64 := TIdEncoderMIME.Create(nil);
                aPngString := TIdEncoderMIME.EncodeStream(aFileStream);
//                Log.WriteToLog(aCompanyName, aCompanyId, '<TCD> createPictureForCompany PictureString: ' +
//                        aPngString, lmtInfo);
                result := TJSONObject.Create;
                result.AddPair('PictureString',aPngString);
                result.AddPair('PictureHeight',TJsonNumber.Create(FieldByName('Height').ASinteger));
                result.AddPair('PictureWidth',TJsonNumber.Create(FieldByName('Width').ASinteger));

//                aJsonPair := TJsonPair.Create('PictureString',aPngString);
//                result.AddPair('Picture', aJsonObjectPicture);
//                result := TJSONObject.Create(aJsonObjectPicture);
              end;
            end;
          end;
        except on e: exception do
          begin
            Log.WriteToLog(aCompanyName, aCompanyId, '<TCD> createPictureForCompany/create picture: ' +
                  E.Message, lmtError);
            raise;
          end;
        end;
      end;
    except on e: exception do
      begin
        Log.WriteToLog(aCompanyName, aCompanyId, '<TCD> createPictureForCompany Error: ' +
              E.Message, lmtError);
        result.AddPair('Server Error', 'INTERNAL ERROR');
      end;
    end;
  finally
    begin
      if Assigned(aDM) then
      begin
        aDM.QueryGetWorkAreaPicture.Close;
      end;
      if Assigned(PngImage) then
      begin
        FreeAndNil(PngImage);
      end;
      if Assigned(aFileStream) then
      begin
        FreeAndNil(aFileStream);
      end;
      if Assigned(aImageStream) then
      begin
        FreeAndNil(aImageStream);
      end;
      if Assigned(base64) then
      begin
        FreeAndNil(base64);
      end;
      if Assigned(PngImage) then
      begin
        FreeAndNil(PngImage);
      end;
      if Assigned(aDM) then
      begin
        FreeAndNil(aDM);
      end;
    end;
  end;
end;

function TCD.GetWorkAreasForCompany(pParams: TJSONObject): TJSONObject;
var
  aCompanyName: string;
  aCompanyId: integer;
  aDM: TDMCashDesk;
  aAreaList: TStringList;
begin
  try
    try

      aCompanyName := pParams.GetValue<string>('CompanyName');
      if aCompanyName = '' then
        aCompanyName := 'CashDesk';
      aCompanyId := pParams.GetValue<integer>('CompanyId');
      Log.WriteToLog(aCompanyName, aCompanyId, '<TCD> GetWorkAreasForCompany/ starte Arbeit', lmtInfo);
      aDM := TDMCashDesk.Create(nil);
      aDM.ConnectionZen.Params.Clear;
      aDM.ConnectionZen.ConnectionDefName := aCompanyName;
      aDM.ConnectionZen.Connected := True;
      try
        try
          with aDM.QueryGetWorkArea do
          begin
            Log.WriteToLog(aCompanyName, aCompanyId, '<TCD> GetWorkAreasForCompany --> get WorkAreas', lmtInfo);
            ParamByName('pFirma').AsInteger := aCompanyId;
            open;
            aAreaList := TStringList.Create;
            while not EOF do
            begin
              if aAreaList.IndexOf(FieldByName('Area').ASString) = -1 then
              begin
                aAreaList.Add(FieldByName('Area').ASString);
              end;
              next;
            end
          end;
        except
          on E: Exception do
          begin
            Log.WriteToLog(aCompanyName, aCompanyId, '<TCD> GetWorkAreasForCompany/QueryGetWorkArea Error: ' +
              E.Message, lmtError);
            raise;
          end;
        end;
      finally
        aDM.QueryGetWorkArea.Close;
      end;
      if aAreaList.Count > 0 then
      begin
        try
          Log.WriteToLog(aCompanyName, aCompanyId, '<TCD> GetWorkAreasForCompany --> set WorkAreas in Json', lmtInfo);
          result := TJSONObject.Create;
          begin
            var aJsonarray := TJsonArray.Create;
            for var area in aAreaList do
            begin
              aJsonarray.Add(area);
            end;
            result.AddPair('Areas', aJsonarray);
          end;
          for var area in aAreaList do
          begin
            Log.WriteToLog(aCompanyName, aCompanyId, '<TCD> GetWorkAreasForCompany --> get Tables for '+area, lmtInfo);
            var aJsonarray := TJsonArray.Create;
            with aDM.QueryGetWorkAreaByName do
            begin
              Close;
              ParamByName('pArea').ASString := area;
              ParamByName('pFirma').AsInteger := aCompanyId;
              open;
              while not EOF do
              begin
                var
                aJsonObject := TJSONObject.Create;

                aJsonObject.AddPair('tableId', TJsonNumber.Create(FieldByName('TableID').AsLargeInt));
                aJsonObject.AddPair('pageId', TJsonNumber.Create(FieldByName('pageId').AsInteger));
                aJsonObject.AddPair('leftPos', TJsonNumber.Create(FieldByName('LEFTPOS').AsInteger));
                aJsonObject.AddPair('topPos', TJsonNumber.Create(FieldByName('Toppos').AsInteger));
                aJsonObject.AddPair('height', TJsonNumber.Create(FieldByName('Height').AsInteger));
                aJsonObject.AddPair('width', TJsonNumber.Create(FieldByName('Width').AsInteger));
                aJsonObject.AddPair('fontHeight', TJsonNumber.Create(FieldByName('fontHeight').AsInteger));
                aJsonObject.AddPair('shape', FieldByName('Shape').ASString);
                aJsonObject.AddPair('name', FieldByName('Name').ASString);
                aJsonObject.AddPair('text', FieldByName('text').ASString);
                aJsonObject.AddPair('color', TJsonNumber.Create(FieldByName('Color').AsInteger));
                  aDM.QueryGetPlanDB.Close;
                  aDM.QueryGetPlanDB.ParamByName('pTischId').AsLargeInt := FieldByName('TableID').AsLargeInt;
                  aDM.QueryGetPlanDB.ParamByName('pDateTimeVon').AsDateTime := now;
                  aDM.QueryGetPlanDB.open;
                  var aPlannerJsonArray := TJsonArray.Create;
                  while not aDM.QueryGetPlanDB.EOF do
                  begin
                    var aPlannerJsonObject := TJSONObject.Create;
                    aPlannerJsonObject.AddPair('plannerKey',
                      aDM.QueryGetPlanDB.FieldByName('plannerKey').AsString);
                    aPlannerJsonObject.AddPair('restTischId',
                        TJsonNumber.Create(aDM.QueryGetPlanDB.FieldByName('TischId').AsLargeInt));
                    aPlannerJsonObject.AddPair('anzahlErw',
                        TJsonNumber.Create(aDM.QueryGetPlanDB.FieldByName('AnzErw').AsLargeInt));
                    aPlannerJsonObject.AddPair('anzahlKind',
                        TJsonNumber.Create(aDM.QueryGetPlanDB.FieldByName('AnzKinder').AsLargeInt));
                    aPlannerJsonObject.AddPair('subject',
                        aDM.QueryGetPlanDB.FieldByName('subject').AsString);
                    aPlannerJsonObject.AddPair('felixReservId',
                        TJsonNumber.Create(aDM.QueryGetPlanDB.FieldByName('felixReservId').AsLargeInt));
                    aPlannerJsonObject.AddPair('startTime',
                        aDM.QueryGetPlanDB.FieldByName('startTime').AsString);
                    aPlannerJsonObject.AddPair('endTime',
                        aDM.QueryGetPlanDB.FieldByName('endTime').AsString);
                    aPlannerJsonObject.AddPair('notes',
                        aDM.QueryGetPlanDB.FieldByName('notes').AsString);
                    aPlannerJsonObject.AddPair('abreise',
                        aDM.QueryGetPlanDB.FieldByName('abreise').AsString);
                    aPlannerJsonObject.AddPair('felixZimmerId',
                      TJsonNumber.Create(aDM.QueryGetPlanDB.FieldByName('felixZimmerId').AsInteger));
                    aPlannerJsonObject.AddPair('stammgast',
                      TJsonBool.Create(aDM.QueryGetPlanDB.FieldByName('stammgast').AsBoolean));

//                    aPlannerJsonObject.AddPair('restTischId',
//                        TJsonNumber.Create(aDM.QueryGetPlanDB.FieldByName('restTischId').AsLargeInt));
//                    aPlannerJsonObject.AddPair('subject',
//                        aDM.QueryGetPlanDB.FieldByName('subject').AsString);
//                    aPlannerJsonObject.AddPair('felixReservId',
//                        TJsonNumber.Create(aDM.QueryGetPlanDB.FieldByName('felixReservId').AsLargeInt));
//                    aPlannerJsonObject.AddPair('startTime',
//                        aDM.QueryGetPlanDB.FieldByName('startTime').AsString);
//                    aPlannerJsonObject.AddPair('endTime',
//                        aDM.QueryGetPlanDB.FieldByName('endTime').AsString);
//                    aPlannerJsonObject.AddPair('notes',
//                        aDM.QueryGetPlanDB.FieldByName('notes').AsString);
//                    aPlannerJsonObject.AddPair('abreise',
//                        aDM.QueryGetPlanDB.FieldByName('abresise').AsString);

                    aPlannerJsonArray.AddElement(aPlannerJsonObject);
                    aDM.QueryGetPlanDB.Next;

                  end;
                aJsonObject.AddPair('tableReservData',aPlannerJsonArray);
//                aJsonObject.AddPair('imageData', TJSONString.Create(FieldByName('imageData').AsInteger));
                aJsonarray.AddElement(aJsonObject);
                next;
              end;
              result.AddPair(area.ToLower, aJsonarray);
            end;
          end;
          Log.WriteToLog(aCompanyName, aCompanyId, '<TCD> GetWorkAreasForCompany --> send Json: '+result.ToJson, lmtInfo);
        except
          on E: Exception do
          begin
            Log.WriteToLog(aCompanyName, aCompanyId, '<TCD> GetWorkAreasForCompany/QueryGetWorkAreaByName Error: ' +
              E.Message, lmtError);
            raise;
          end;
        end;
      end;

    except
      on E: Exception do
      begin
        Log.WriteToLog(aCompanyName, aCompanyId, '<TCD> GetWorkAreasForCompany Error: ' +
              E.Message, lmtError);
        result.AddPair('Server Error', 'INTERNAL ERROR');
      end;
    end;
  finally
    if Assigned(aAreaList) then
    begin
      FreeAndNil(aAreaList);
    end;
    if Assigned(aDM) then
    begin
      aDM.QueryGetWorkArea.Close;
      aDM.QueryGetWorkAreaByName.Close;
      aDM.ConnectionZen.Connected := false;
      FreeAndNil(aDM);
    end;
  end;

end;

function TCD.GetWorkAreaTableInfos(pParams: TJSONObject): TJSONObject;
var aCompanyName, aArea: string;
  aCompanyId: integer;
  aDM: TDMCashDesk;
  var aPlannerJsonArray: TJsonArray;
begin
  try
    try
      aPlannerJsonArray := TJsonArray.Create;
      aCompanyName := pParams.GetValue<string>('CompanyName');
      if aCompanyName = '' then
        aCompanyName := 'CashDesk';
      aCompanyId := pParams.GetValue<integer>('CompanyId');
      aArea := pParams.GetValue<string>('area');
      Log.WriteToLog(aCompanyName, aCompanyId, '<TCD> GetWorkAreaTableInfos/ starte Arbeit', lmtInfo);
      Log.WriteToLog(aCompanyName, aCompanyId, '<TCD> GetWorkAreaTableInfos/ incomming Sting: ' +
         pParams.ToString, lmtInfo);
      aDM := TDMCashDesk.Create(nil);
      aDM.ConnectionZen.Params.Clear;
      aDM.ConnectionZen.ConnectionDefName := aCompanyName;
      aDM.ConnectionZen.Connected := True;
      Log.WriteToLog(aCompanyName, aCompanyId, '<TCD> GetWorkAreasForCompany --> get Tables for '+aArea, lmtInfo);
      with aDM.QueryGetWorkAreaByName do
      begin
        Close;
        ParamByName('pArea').ASString := aArea;
        ParamByName('pFirma').AsInteger := aCompanyId;
        open;
        while not EOF do
        begin
          aDM.QueryGetPlanDB.Close;
          aDM.QueryGetPlanDB.ParamByName('pTischId').AsLargeInt := FieldByName('TableID').AsLargeInt;
          aDM.QueryGetPlanDB.ParamByName('pDateTimeVon').AsDateTime := now;
          aDM.QueryGetPlanDB.open;

          while not aDM.QueryGetPlanDB.EOF do
          begin
            var aPlannerJsonObject := TJSONObject.Create;
            aPlannerJsonObject.AddPair('plannerKey',
              aDM.QueryGetPlanDB.FieldByName('plannerKey').AsString);
            aPlannerJsonObject.AddPair('restTischId',
                TJsonNumber.Create(aDM.QueryGetPlanDB.FieldByName('TischId').AsLargeInt));
            aPlannerJsonObject.AddPair('anzahlErw',
                TJsonNumber.Create(aDM.QueryGetPlanDB.FieldByName('AnzErw').AsLargeInt));
            aPlannerJsonObject.AddPair('anzahlKind',
                TJsonNumber.Create(aDM.QueryGetPlanDB.FieldByName('AnzKinder').AsLargeInt));
            aPlannerJsonObject.AddPair('subject',
                aDM.QueryGetPlanDB.FieldByName('subject').AsString);
            aPlannerJsonObject.AddPair('felixReservId',
                TJsonNumber.Create(aDM.QueryGetPlanDB.FieldByName('felixReservId').AsLargeInt));
            aPlannerJsonObject.AddPair('startTime',
                aDM.QueryGetPlanDB.FieldByName('startTime').AsString);
            aPlannerJsonObject.AddPair('endTime',
                aDM.QueryGetPlanDB.FieldByName('endTime').AsString);
            aPlannerJsonObject.AddPair('notes',
                aDM.QueryGetPlanDB.FieldByName('notes').AsString);
            aPlannerJsonObject.AddPair('abreise',
                aDM.QueryGetPlanDB.FieldByName('abreise').AsString);
            aPlannerJsonObject.AddPair('felixZimmerId',
              TJsonNumber.Create(aDM.QueryGetPlanDB.FieldByName('felixZimmerId').AsInteger));
            aPlannerJsonObject.AddPair('stammgast',
                TJsonBool.Create(aDM.QueryGetPlanDB.FieldByName('stammgast').AsBoolean));
    //      aPlannerJsonObject.AddPair('subject',
    //          aDM.QueryGetPlanDB.FieldByName('subject').AsString);
    //      aPlannerJsonObject.AddPair('felixReservId',
    //          TJsonNumber.Create(aDM.QueryGetPlanDB.FieldByName('felixReservId').AsLargeInt));
    //      aPlannerJsonObject.AddPair('startTime',
    //          aDM.QueryGetPlanDB.FieldByName('startTime').AsString);
    //      aPlannerJsonObject.AddPair('endTime',
    //          aDM.QueryGetPlanDB.FieldByName('endTime').AsString);
    //      aPlannerJsonObject.AddPair('notes',
    //          aDM.QueryGetPlanDB.FieldByName('notes').AsString);
    //      aPlannerJsonObject.AddPair('abreise',
    //          aDM.QueryGetPlanDB.FieldByName('abresise').AsString);
            aPlannerJsonArray.AddElement(aPlannerJsonObject);

            aDM.QueryGetPlanDB.Next;

          end;
          next;
        end;
      end;
    except on e: exception do
      begin
        Log.WriteToLog(aCompanyName, aCompanyId, '<TCD> GetWorkAreaTableInfos Error: ' +
              E.Message, lmtError);
        var aPlannerJsonObject := TJSONObject.Create;
         aPlannerJsonObject.AddPair('error', 'Can not Reload Tables');
        aPlannerJsonArray.AddElement(aPlannerJsonObject);
      end;
    end;
  finally
    result := TJsonObject.Create;
    result.AddPair('tableData', aPlannerJsonArray);
    Log.WriteToLog(aCompanyName, aCompanyId, '<TCD> GetWorkAreaTableInfos Out string: ' +
              result.Tostring, lmtInfo);
    aDM.ConnectionFelix.Connected := False;
    FreeAndNil(aDM);
  end;
end;

function TCD.getGuestHTML(pParams: TJSONObject): TJSONObject;
var aCompanyName: string;
  aCompanyId: integer;
  aWork: TCWU;
begin
  try
    try
      result := TJSONObject.Create;
      aCompanyName := pParams.GetValue<string>('CompanyName');
      aCompanyId := pParams.GetValue<integer>('CompanyId');
      Log.WriteToLog(aCompanyName, aCompanyId, '<TCD> getGuestHTML in string: ' +
              pParams.Tostring, lmtInfo);
      aWork := TCWU.Create(nil);
      if aWork.CheckDatabase(aCompanyName,aCompanyId, true) then
      begin
        result := aWork.getGuestHTML(pParams);
      end
      else
      begin
        result.AddPair('HTMLInfoStr','Dieser CompanyName ist nicht angelegt');
        result.AddPair('HTMLString','');
      end;
    except on e: exception do
      begin
        Log.WriteToLog(aCompanyName, aCompanyId, '<TCD> getGuestHTML Error: ' + e.Message, lmtError);
        result.AddPair('HTMLInfoStr','Es ist ein Fehler beim erstellen des HTML files aufgetreten. Der HTML Service ist derzeit nicht verfügbar! ');
        result.AddPair('HTMLString','');
      end;
    end;
  finally
    FreeAndNil(aWork);
    Log.WriteToLog(aCompanyName, aCompanyId, '<TCD> getGuestHTML Out string: ' +
              result.Tostring, lmtInfo);
  end;
end;

function TCD.setNewTable(pParams: TJSONObject): TJSONObject;
var aCompanyName: string;
  aCompanyId: integer;
  aWork: TCWU;
begin
  try
    try
      result := TJSONObject.Create;
      aCompanyName := pParams.GetValue<string>('CompanyName');
      aCompanyId := pParams.GetValue<integer>('CompanyId');
      Log.WriteToLog(aCompanyName, aCompanyId, '<TCD> setNewTable in string: ' +
              pParams.Tostring, lmtInfo);
      aWork := TCWU.Create(nil);
      if aWork.CheckDatabase(aCompanyName,aCompanyId, true) then
      begin
        result := aWork.setNewTable(pParams);
      end
      else
      begin
        result.AddPair('resultStr','Fehler: Dieser CompanyName ist nicht angelegt');
      end;
    except on e: exception do
      begin
        Log.WriteToLog(aCompanyName, aCompanyId, '<TCD> getGuestHTML Error: ' + e.Message, lmtError);
        result.AddPair('resultStr','Fehler! Eswurde nicht gespeivchert! ');
      end;
    end;
  finally
    FreeAndNil(aWork);
    Log.WriteToLog(aCompanyName, aCompanyId, '<TCD> setNewTable Out string: ' +
              result.Tostring, lmtInfo);
  end;
end;

end.
