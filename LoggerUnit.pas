unit LoggerUnit;

interface

uses
  System.Generics.Collections, ServerIntf, nxLogging, System.SysUtils;


type
  TRestLogger = class(TInterfacedObject, IRestLogger)
  private
    procedure PrepareLogFileInfo;
    procedure WriteToLogInfo(pLogStr: string);
  protected
    FInternalLogger: TNxLogger;
    FCopyLoggers: TList<IRestLogger>;
    FSuffix, FPrefix: string;
    procedure PrepareLogFile; virtual;
    function PrepareMessage(const pSource: string): string;
  public
    constructor Create;
    destructor Destroy;
    procedure RegisterCopyLogger(pCopyLogger: IRestLogger);
    procedure WriteToLog(const pMessageString: string; pMessageType: TLogMessageTypes = lmtInfo); overload; virtual;
    procedure WriteToLog(const pModuleName, pMessageString: string; pMessageType: TLogMessageTypes = lmtInfo); overload; virtual;
    procedure WriteToLog(const pModuleName, pMessageString: string; const pCategory : TNxLoggerCategory; pMessageType: TLogMessageTypes = lmtInfo; const pException : Exception = nil); overload; virtual;
    procedure SetLogNameSuffix(const pSuffix: string);
    procedure SetLogNamePrefix(const pPrefix: string);
  end;

implementation

uses
  Spring.Container, System.Classes,
  IniFiles, Resources{, DMBase}, System.DateUtils, DataModule;
{ TRestLogger }

var
  aLastLogfileTime: TDateTime;
  aLastLogFileState: String;

constructor TRestLogger.Create;
begin
  inherited;
  FSuffix := '';
  FPrefix := '';
  FInternalLogger := Logger;
  FCopyLoggers := TList<IRestLogger>.Create;
  if Assigned(DM) and (DM.DebugModus >= 1) then
    FInternalLogger.CurrentLevel := NXLL_DEBUG;
end;

destructor TRestLogger.Destroy;
begin
  if Assigned(FCopyLoggers) then
  begin
    FCopyLoggers.Clear;
    FreeAndNil(FCopyLoggers);
  end;
  inherited;
end;

procedure TRestLogger.PrepareLogFile;
var
  s: string;
  aHour, aMinute: Integer;
begin
  //FSuffix := 'P'+DM.ServerPort.tostring+'_'+DM.VersionNumber;
  if (date <> aLastLogfileTime) then
//  or (aLastLogFileState <> 'Error') then
  begin

    aHour := HourOf(Now);
    aMinute := MinuteOf(Now);
    s := 'T';
    if aHour < 10 then
      s := '0';
    s := s + aHour.ToString;
    if aMinute < 10 then
      s := s + '0';
    s := s + aMinute.ToString;
    FInternalLogger.initializeFileLogging(ExtractFileName(ParamStr(0)),
    DM.LogPath,
    FPrefix + 'rest_Felix_' + FSuffix + '_' + s );
    aLastLogfileTime := date;
//    aLastLogFileState := 'Error';
  end;
end;

procedure TRestLogger.WriteToLogInfo (pLogStr: string);
var
	fileName: string;
	fHandle: TextFile;

begin
  try
//    if DM.LogPath = '' then
//    begin
//      FLogPath := ExtractFilePath(ExtractFileName(ParamStr(0)),
//      DM.LogPath;
//    end;
    if (DM.LogPath <> '') then
    begin
      ForceDirectories(DM.LogPath);
      fileName := DM.LogPath+
        FPrefix + 'rest_Felix_InfoLog' + FSuffix + '_' + FormatDateTime('yyyymmddhh', now)+ '00.log';
      AssignFile(fHandle, fileName);

      if FileExists (fileName) then Append(fHandle)
      else Rewrite (fHandle);
      pLogStr := '(' + TimeToStr(Time)+')' +pLogStr;

//      if FLogClientName <> '' then
//        pLogStr := pLogStr + ' (' + FLogClientName + ')';

      WriteLn (fHandle, pLogStr);
      CloseFile(fHandle);
    end;
  except
  end;
end;

procedure TRestLogger.PrepareLogFileInfo;
var
  s: string;
  aHour, aMinute: Integer;
begin
  //FSuffix := 'P'+DM.ServerPort.tostring+'_'+DM.VersionNumber;
  if (date <> aLastLogfileTime)
  or (aLastLogFileState <> 'Info') then
  begin
    aHour := HourOf(Now);
    aMinute := MinuteOf(Now);
    s := 'T';
    if aHour < 10 then
      s := '0';
    s := s + aHour.ToString;
    if aMinute < 10 then
      s := s + '0';
    s := s + aMinute.ToString;
    FInternalLogger.initializeFileLogging(ExtractFileName(ParamStr(0)),
    DM.LogPath,
    FPrefix + 'rest_Felix_InfoLog' + FSuffix + '_' + s );
    aLastLogfileTime := date;
    aLastLogFileState := 'Info';
  end;
end;

function TRestLogger.PrepareMessage(const pSource: string): string;
begin
  Result := StringReplace(pSource, #13#10, ' ', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, #13, ' ', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, #10, ' ', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, #9, ' ', [rfReplaceAll, rfIgnoreCase]);
end;

procedure TRestLogger.RegisterCopyLogger(pCopyLogger: IRestLogger);
begin
  FCopyLoggers.Add(pCopyLogger);
end;

procedure TRestLogger.SetLogNamePrefix(const pPrefix: string);
begin
  FPrefix := pPrefix;
end;

procedure TRestLogger.SetLogNameSuffix(const pSuffix: string);
begin
  FSuffix := pSuffix;
end;

procedure TRestLogger.WriteToLog(const pModuleName, pMessageString: string;
  pMessageType: TLogMessageTypes);
var
  aCopyLogger: IRestLogger;
  aMessage: string;
begin
  PrepareLogFile;
  aMessage := PrepareMessage(pMessageString);
  case pMessageType of
    lmtInfo:       FInternalLogger.info(pModuleName, aMessage);
    lmtWarning:    FInternalLogger.warn(pModuleName, aMessage);
    lmtError:      FInternalLogger.error(pModuleName, aMessage);
    lmtFatalError: FInternalLogger.fatal(pModuleName, aMessage);
    lmtDebug:      FInternalLogger.debug(pModuleName, aMessage);
    lmtTrace:      FInternalLogger.trace(pModuleName, aMessage);
  end;
  //aMessage := 'restFelix '+DM.VersionNumber+' --> '+aMessage;
  for aCopyLogger in FCopyLoggers do
    aCopyLogger.WriteToLog(pModuleName, aMessage, pMessageType);
end;

procedure TRestLogger.WriteToLog(const pModuleName, pMessageString: string;
  const pCategory: TNxLoggerCategory; pMessageType: TLogMessageTypes;
  const pException: Exception);
var
  aCopyLogger: IRestLogger;
  aMessage: string;
begin
  PrepareLogFile;
  aMessage := PrepareMessage(pMessageString);

  case pMessageType of
    lmtInfo:       FInternalLogger.info(pModuleName, aMessage, pCategory, pException);
    lmtWarning:    FInternalLogger.warn(pModuleName, aMessage, pCategory, pException);
    lmtError:      FInternalLogger.error(pModuleName, aMessage, pCategory, pException);
    lmtFatalError: FInternalLogger.fatal(pModuleName, aMessage, pCategory, pException);
    lmtDebug:      FInternalLogger.debug(pModuleName, aMessage, pCategory, pException);
    lmtTrace:      FInternalLogger.trace(pModuleName, aMessage, pCategory, pException);
  end;
  aMessage := 'restFelix '+DM.VersionNumber+' --> '+aMessage;
  for aCopyLogger in FCopyLoggers do
    aCopyLogger.WriteToLog(pModuleName, aMessage, pMessageType);
end;

procedure TRestLogger.WriteToLog(const pMessageString: string;
  pMessageType: TLogMessageTypes);
var
  aCopyLogger: IRestLogger;
  aMessage: string;
begin
//  if pMessageType = lmtError then
    PrepareLogFile;
//  else
//    PrepareLogFileInfo;
  aMessage := PrepareMessage(pMessageString);

  aMessage := 'restFelix '+DM.VersionNumber+' --> '+aMessage;
  case pMessageType of
    lmtInfo:       WriteToLogInfo(aMessage);
    lmtWarning:    WriteToLogInfo(aMessage);//FInternalLogger.warn(aMessage);
    lmtError:      FInternalLogger.error(aMessage);
    lmtFatalError: FInternalLogger.fatal(aMessage);
    lmtDebug:      WriteToLogInfo(aMessage);//FInternalLogger.debug(aMessage);
    lmtTrace:      WriteToLogInfo(aMessage);//FInternalLogger.trace(aMessage);
  end;

  for aCopyLogger in FCopyLoggers do
    aCopyLogger.WriteToLog(aMessage, pMessageType);
end;

initialization

begin
  aLastLogfileTime := 0;
  Spring.Container.GlobalContainer.RegisterType<TRestLogger>.Implements<IRestLogger>.AsSingleton;
  Spring.Container.GlobalContainer.Build;
end;

end.
