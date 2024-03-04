unit ErrorLoggerUnit;

interface

uses
  ServerIntf,
  nxLogging,
  System.SysUtils,
  LoggerUnit;

type
  TRestErrorLogger =class(TRestLogger, IRestLogger)
  protected
    procedure PrepareLogFile; override;
  public
    constructor Create;
    destructor Destroy;
    procedure WriteToLog(const pMessageString: string; pMessageType: TLogMessageTypes = lmtInfo); overload; override;
    procedure WriteToLog(const pModuleName, pMessageString: string; pMessageType: TLogMessageTypes = lmtInfo); overload; override;
    procedure WriteToLog(const pModuleName, pMessageString: string; const pCategory : TNxLoggerCategory; pMessageType: TLogMessageTypes = lmtInfo; const pException : Exception = nil); overload; override;
  end;

implementation

uses
  DMBase;

{ TRestErrorLogger }

constructor TRestErrorLogger.Create;
begin
  inherited;
  FInternalLogger := TNxLogger.Create(nil);
end;

destructor TRestErrorLogger.Destroy;
begin
  FInternalLogger.Free;
end;

procedure TRestErrorLogger.PrepareLogFile;
begin
  FInternalLogger.initializeFileLogging(ExtractFileName(ParamStr(0)),
    Dbase.LogPath + 'Errors\',
    FPrefix + 'Errors_' + FSuffix);
end;

procedure TRestErrorLogger.WriteToLog(const pMessageString: string;
  pMessageType: TLogMessageTypes);
begin
  if pMessageType = lmtError then
    inherited WriteToLog(pMessageString, pMessageType);
end;

procedure TRestErrorLogger.WriteToLog(const pModuleName, pMessageString: string;
  pMessageType: TLogMessageTypes);
begin
  if pMessageType = lmtError then
    inherited WriteToLog(pModuleName, pMessageString, pMessageType);
end;

procedure TRestErrorLogger.WriteToLog(const pModuleName, pMessageString: string;
  const pCategory: TNxLoggerCategory; pMessageType: TLogMessageTypes;
  const pException: Exception);
begin
  if pMessageType = lmtError then
    inherited WriteToLog(pModuleName, pMessageString, pCategory, pMessageType, pException);
end;

end.
