unit Logging;

interface

uses
  System.SysUtils, System.Classes, VCL.Forms;

type
  TLogMessageTypes = (lmtInfo, lmtError, lmtLogin);

type
  TLog = class(TDataModule)
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    FLogPath: string;
    procedure WriteToLog(pCompanyName: string; Firma: Integer; pLogStr: string;
                          pStatus: TLogMessageTypes = lmtInfo; pWriteToBoard: boolean = false);
  end;

var
  Log: TLog;


implementation
uses restFelixMainUnit;
{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}
procedure TLog.WriteToLog(pCompanyName: string; Firma: Integer; pLogStr: string;
  pStatus: TLogMessageTypes = lmtInfo; pWriteToBoard: boolean = false);
var
  fileName: string;
  fHandle: TextFile;
begin
  try
    if FLogPath = '' then
    begin
      FLogPath := ExtractFilePath(Application.Exename) + 'Logs\' +
        copy(ExtractFileName(Application.Exename), 1, pos('.', ExtractFileName(Application.Exename))
        - 1) + '\';
    end;
    if (FLogPath <> '') then
    begin
      // Set File and String
      if pStatus = lmtError then
      begin
        ForceDirectories(FLogPath+ '\Error\');
        fileName := FLogPath + '\Error\' + FormatDateTime('yymmdd', Date) + '.log';
        pLogStr := '(' + TimeToStr(Time) + ' Firma:' + IntToStr(Firma) + ' Benutzer:' + pCompanyName +
          ')--> Error: ' + pLogStr;
      end
      else if pStatus = lmtLogin then
      begin
        ForceDirectories(FLogPath+ '\Connection\');
        fileName := FLogPath + '\Connection\' + FormatDateTime('yymmdd', Date) + '.log';
        pLogStr := '(' + TimeToStr(Time) + ' Firma: ' + IntToStr(Firma) + ' Benutzer: ' + pCompanyName +
          ')--> ' + pLogStr;
      end
      else
      begin
        ForceDirectories(FLogPath+ '\Info\'+pCompanyName+'\');
        fileName := FLogPath + '\Info\'+pCompanyName+'\' + FormatDateTime('yymmdd', Date) + '.log';
        pLogStr := '(' + TimeToStr(Time) + ' Firma: ' + IntToStr(Firma) + ' Benutzer: ' + pCompanyName +
          ')--> ' + pLogStr;
      end;

      // Write into file

      AssignFile(fHandle, fileName);

      if FileExists(fileName) then
        Append(fHandle)
      else
        Rewrite(fHandle);

      WriteLn(fHandle, pLogStr);
      CloseFile(fHandle);
      try
        if pWriteToBoard then
        begin
          rstFelixMain.MemoLog.Lines.Add(pLogStr);
        end;
      except

      end;
    end;
  except
  end;
end;

end.
