unit GlobalFunc;

interface

uses  SysUtils, Windows, StrUtils;

function GetComputerName: String;

function GetReportName(const pPath, pReport: string): String; overload;
function GetReportName(const pReport: string): String; overload;

function GetParamStr(const pName: string): Boolean; overload;
Procedure GetParamStr(const pName: string; var pBoolean: Boolean); overload;
Procedure GetParamStr(const pName: string; var pString: String); overload;
Procedure GetParamStr(const pName: string; var pInteger: Integer); overload;

implementation

// ermittelt den Computername
function GetComputerName: String;
var
  Buffer: Array[0..MAX_COMPUTERNAME_LENGTH+1] of Char;
  Size: DWORD;
begin
  size:=1024;
  Windows.GetComputerName(Buffer, Size);
  Result:=StrPas(Buffer);
end;

// ermittelt den Report-Pfad für CrystalReports
function GetReportName(const pPath, pReport: string): String; overload;
var
  aPath, aReport: string;
begin
  // get name of report
  aReport := LowerCase(Trim(pReport));
  if Length(aReport) = 0 then
    aReport := 'error.rpt';
  if RightStr(aReport, 4) <> '.rpt' then
    aReport := aReport + '.rpt';

  // check path
  aPath := LowerCase(Trim(pPath));
  if Length(aPath) > 0 then
  begin
    if RightStr(aPath, 1) <> '\' then
      aPath := aPath + '\';

    Result := aPath + aReport;                        if FileExists(Result) then EXIT;
    Result := aPath + 'a4reports\' + aReport;         if FileExists(Result) then EXIT;
  end;

  // path or report was wrong, so take application path
  aPath := ExtractFileDir(ParamStr(0)) + '\reports\';

  Result := aPath + aReport;                        if FileExists(Result) then EXIT;
  Result := aPath + 'a4reports\' + aReport;         if FileExists(Result) then EXIT;

  // no correct path and report found
  Result := '';
end;

function GetReportName(const pReport: string): String; overload;
begin
  Result := GetReportName('', pReport);
end;

function GetParamStr(const pName: string): Boolean; overload;
var
  i: Integer;
begin
  Result := FALSE;
  if ParamCount > 0 then
    for i := 1 to ParamCount do
      if LowerCase(ParamStr(i)) = LowerCase(pName) then
        Result := TRUE;
end;

Procedure GetParamStr(const pName: string; var pBoolean: Boolean); overload;
var
  i: Integer;
begin
  if ParamCount > 0 then
    for i := 1 to ParamCount do
      if LowerCase(ParamStr(i)) = LowerCase(pName) then
        pBoolean := TRUE;
end;

Procedure GetParamStr(const pName: string; var pString: String); overload;
var
  i: Integer;
begin
  if ParamCount > 0 then
    for i := 1 to ParamCount do
      if LeftStr(LowerCase(ParamStr(i)), Length(pName) + 1) = LowerCase(pName) + '=' then
        if Copy(ParamStr(i), Length(pName) + 2) > '' then
          pString := Copy(ParamStr(i), Length(pName) + 2);
end;

Procedure GetParamStr(const pName: string; var pInteger: Integer); overload;
var
  aValue: string;
begin
  if ParamCount > 0 then
  begin
    aValue := '';
    GetParamStr(pName, aValue);
    if aValue > '' then
      pInteger := StrToIntDef(aValue, 0);
  end;
end;


end.
