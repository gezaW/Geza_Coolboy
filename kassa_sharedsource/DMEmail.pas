unit DMEmail;

interface

uses
  System.SysUtils, System.Classes,
  IdComponent, IdTCPConnection, IdTCPClient,
  IdExplicitTLSClientServerBase, IdMessageClient, IdSMTPBase, IdSMTP,
  IdBaseComponent, IdMessage, IdIPWatch, IdAttachmentFile,
  WIBUKEYLib_TLB,
  FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Winapi.Windows, Controls;

type
  TDataEmail = class(TDataModule)
    IdSMTP: TIdSMTP;
    IdIPWatch: TIdIPWatch;
    procedure DataModuleCreate(Sender: TObject);
  private
    function  GetSerialNumberFromWIBU: string;
    // 27.10.2014 KL: Programm in Registry suchen
    function CheckProgramInstalled(const pProgramDisplayName: string): Boolean; overload;
    // 27.10.2014 KL: Programm im Ordner Programme suchen
    function CheckProgramInstalled(const pProgramPath, pFileName: string): Boolean; overload;
    function GetPVSFixedFileInfo(pFileName: string): PVSFixedFileInfo;
  public
    function GetFileVersion(const pFileName: string=''): TStringList;
    function SendEmail(out pError: String; pSubject: string; pBody: TStrings = nil; pAttachment: String = ''): Boolean;
    // 18.11.2014 KL: Codemeter- oder Wibu-Lizenz prüfen
    function GetSerialNumber: string;
  end;

var
  DataEmail: TDataEmail;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

uses
  DMBase, Registry, CodemeterStick;

{ TDataEmail }

// 27.10.2014 KL: Programm in der "Registry" suchen
function TDataEmail.CheckProgramInstalled(
  const pProgramDisplayName: string): Boolean;
var
  aRegistry: TRegistry;
  aKeyNames: TStringList;
  i: Integer;
  aLength: Integer;

begin
  Result := FALSE;

  aLength := Length(pProgramDisplayName);
  if aLength < 1 then
    exit;

  // wenn das Programm im UnInstall-Eintrag existiert, hat die Installation funktioniert
  try
    aRegistry := TRegistry.Create(KEY_READ);
    try
      aRegistry.RootKey := HKEY_LOCAL_MACHINE;
      if aRegistry.OpenKeyReadOnly('SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall') then
      begin
        aKeyNames := TStringList.Create;
        try
          aRegistry.GetKeyNames(aKeyNames);
          aRegistry.CloseKey;
          for i := 0 to aKeyNames.Count - 1 do
          begin
            if aRegistry.OpenKeyReadOnly('SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\'+aKeyNames[i]) then
            try
              if Copy(aRegistry.ReadString('DisplayName'), 1, aLength) = pProgramDisplayName then
                Result := TRUE;
            finally
              aRegistry.CloseKey;
            end;
            // for-Schleife abbrechen, wenn Eintrag gefunden
            if Result then
              BREAK;
          end;
        finally
          aKeyNames.Free;
        end;
      end;
    finally
      aRegistry.CloseKey;
      aRegistry.Free;
    end;
  except
    Result := FALSE;
  end;
end;

// 27.10.2014 KL: Programm im Ordner "ProgrammFiles" suchen
function TDataEmail.CheckProgramInstalled(const pProgramPath,
  pFileName: string): Boolean;
var
  aProgramFiles: String;

begin
  Result := FALSE;

  if (Length(pProgramPath) < 1)
  or (Length(pFileName) < 1) then
    exit;

  // Umgebungsvariable für 32- oder 64-bit Systeme
  aProgramFiles := GetEnvironmentVariable('ProgramFiles');

  // normalerweise sollte das Programm im richtigen Ordner sein (Umgebungsvariable)
  if FileExists(aProgramFiles+'\'+pProgramPath+'\'+pFileName) then
  begin
    Result := TRUE;
    EXIT;
  end;

  // falls nicht, dann auch im "falschen" Ordner suchen (manchmal wurde der Wibu mit 32 bit installiert statt 64 bit)
  if Pos(' (x86)', LowerCase(aProgramFiles)) > 0 then
    aProgramFiles := Copy(aProgramFiles, 1, Pos(' (x86)', LowerCase(aProgramFiles))-1)
  else
    aProgramFiles := aProgramFiles+' (x86)';
  if FileExists(aProgramFiles+'\'+pProgramPath+'\'+pFileName) then
    Result := TRUE;

end;

procedure TDataEmail.DataModuleCreate(Sender: TObject);
begin
  DBase.SetDefaulftConnection(Self);
end;

function TDataEmail.GetFileVersion(const pFileName: string=''): TStringList;
var
  aFileName: string;
  FI: PVSFixedFileInfo;
begin
  result := TStringList.Create;
  Result.Delimiter := '.';

  if pFileName='' then
    aFileName := paramstr(0)
  else
    aFileName := trim(pFileName);

  FI := GetPVSFixedFileInfo(aFileName);
  if FI = nil then
    result.DelimitedText := '0.0.0.0.File_not_found'
  else
  begin
    result.DelimitedText := format('%d.%d.%d.%d',
      [FI.dwFileVersionMS shr 16, (FI.dwFileVersionMS shl 16) shr 16,
       FI.dwFileVersionLS shr 16, (FI.dwFileVersionLS shl 16) shr 16]);
  end;
  Result.DelimitedText := Result.DelimitedText + '.>>.' + extractfilename(aFileName);
end;

function TDataEmail.GetPVSFixedFileInfo(pFileName: string): PVSFixedFileInfo;
var
  InfoSize, Wnd: DWORD;
  VerBuf: Pointer;
  FI: PVSFixedFileInfo;
  VerSize: DWORD;
begin
  Result := nil;
  if pFileName = '' then
    pFileName := ParamStr(0);

  InfoSize := GetFileVersionInfoSize(PChar(pFileName), Wnd);
  if InfoSize <> 0 then
  begin
    GetMem(VerBuf, InfoSize);
    try
      if GetFileVersionInfo(PChar(pFileName), Wnd, InfoSize, VerBuf) then
        if VerQueryValue(VerBuf, '\', Pointer(FI), VerSize) then
          Result := FI;
    finally
      FreeMem(VerBuf);
    end;
  end;
end;

function TDataEmail.GetSerialNumber: string;
var
  aStick: TStick;
  aRuntime: string;

begin
  // check licenses on a codemeter stick or on a wibu key.
  Result := '';
  aRuntime := '';

  // check Codemeter if installed
  if Result='' then
  begin
    if CheckProgramInstalled('CodeMeter Runtime Kit')
    or CheckProgramInstalled('CodeMeter Development Kit')
    or CheckProgramInstalled('CodeMeter\Runtime\bin', 'CodeMeter.exe') then
    begin
      aRuntime := 'CodeMeter';
      aStick := TStick.Create;
      try
        if aStick.GKT.isActivated then         // GKT + GKL
          Result := aStick.GKT.SerialNumber
        else if aStick.GKMO.isActivated then   // GKMO Orderman
          Result := aStick.GKMO.SerialNumber
        else if aStick.GKMS.isActivated then   // GKMS Smart-Order
          Result := aStick.GKMS.SerialNumber;
        if Result <> '' then
          Result := 'Codemeter: '+Result;
      finally
        aStick.Free;
      end;
    end;
  end;

  // check Wibu-Key if installed
  if Result='' then
  begin
    if CheckProgramInstalled('WibuKey Setup')
    or CheckProgramInstalled('WIBU-KEY Setup')
    or CheckProgramInstalled('WibuKey Development Kit')
    or CheckProgramInstalled('WIBUKEY\Bin', 'Wibukey.dll')
    or CheckProgramInstalled('WIBUKEY\Bin', 'Wibukey64.dll') then
    begin
      aRuntime := Trim(aRuntime + ' WibuKey');
      Result := GetSerialNumberFromWIBU;
      if Result <> '' then
        Result := 'Wibu: '+Result;
    end;
  end;

  if Result='' then
    if aRuntime > '' then
      Result := 'ERROR: no '+aRuntime+' found!'
    else
      Result := 'ERROR: CodeMeter/Wibu not installed!';

end;

function TDataEmail.GetSerialNumberFromWIBU: string;
var
  wk: TWibuKey;
begin
  Result := '';

  try
    wk := TWibuKEy.Create(self);
    wk.UsedSubsystems := 3; //lokal und wklan
    if DBase.DAS then
    begin
      wk.FirmCode := 250010;
      wk.UserCode := 1011;
      wk.AlgorithmVersion := 3;
    end
    else
    begin
      wk.FirmCode := 2268;
    end;
    wk.DialogOptions := wkDlgNoScanDialog;
    wk.LimitCounterDecrementMode;

    wk.RestrictedUserQuantityMode := FALSE; // dadurch wird KEINE Lizenz abgezogen!

    wk.CheckBox;
    wk.UsedBoxEntry.MoveFirst;
    wk.UsedBoxEntry.Index := 1;
    wk.UsedBoxEntry.MoveToIndex;
    if wk.UsedBoxEntry.HasAddedDataEntry then
    begin
      wk.UsedAddedEntry.MoveToAddedDataEntry;
      Result := wk.UsedWibuBox.SerialText;
    end;
  finally
    wk.Destroy;
  end;

end;

function TDataEmail.SendEmail(out pError: String; pSubject: string; pBody: TStrings = nil; pAttachment: String = ''): Boolean;
var
  i: integer;
  snr: string;
  IdMessage: TIdMessage;
begin
  Result := FALSE;
  pError := '';
  IdMessage := TIdMessage.Create(self);
  try
    with IdMessage do
    try
      // prepare email
      if (DebugHook <> 0) then // just for debugging in the Delphi-IDE
        Recipients.EMailAddresses := 'kurt.l@gms.info'
      else
        Recipients.EMailAddresses := 'update@gms.info';

      From.Address := Recipients.EMailAddresses;
      if not DBase.QueryFirma.active then
        DBase.QueryFirma.open;
      From.Name := DBase.QueryFirma.FieldByName('Firmenname').AsString;

      if (DebugHook = 0) then
        snr := GetSerialNumber;
      Subject := Format('%s [%s]', [Trim(pSubject), snr]);

      with Body do
      begin
        Clear;
        Add(StringOfChar('-', 100));
        Add(Format('Kunde: %s', [Trim(DBase.QueryFirma.FieldByName('Titel').AsString)]));
        Add(Format('IP: %s', [IdIPWatch.LocalIP]));
        Add(snr);
        Add('');
        for i := 1 to 5 do
          Add(Trim(DBase.QueryFirma.FieldByName('Text'+inttostr(i)).AsString));
        Add(StringOfChar('-', 100));
        Add('Release Versionen:');
        Add(GetFileVersion(paramstr(0)).DelimitedText); // Update.exe
        Add(GetFileVersion(ExtractFilePath(Paramstr(0))+'TouchSetup.exe').DelimitedText);
        Add(GetFileVersion(ExtractFilePath(Paramstr(0))+'Datenanlage.exe').DelimitedText);
        Add(GetFileVersion(ExtractFilePath(Paramstr(0))+'Kellner.exe').DelimitedText);
        Add(GetFileVersion(ExtractFilePath(Paramstr(0))+'Tagesabschluss.exe').DelimitedText);
        Add(GetFileVersion(ExtractFilePath(Paramstr(0))+'Kasse.exe').DelimitedText);
        Add(GetFileVersion(ExtractFilePath(Paramstr(0))+'ZenS.exe').DelimitedText);
        Add(StringOfChar('-', 100));

        if pBody<>nil then
        begin
          for i := 0 to pBody.Count-1 do
            Add(pBody[i]);
        end;

        if pAttachment<>'' then
        begin
          ContentType := 'multipart/mixed';
          if FileExists(pAttachment) then
            TIdAttachmentFile.Create(MessageParts, pAttachment);
        end;

      end;

      // send email
      with IdSMTP do
      try
        Connect;
        Send(IdMessage);
        Result := TRUE;
      finally
        if Connected then
          Disconnect;
      end;

    except on e:Exception do   // 05.06.2018 KL: #20038
      pError := IdSMTP.Host+': '+e.Message;
    end;
  finally
    IdMessage.Destroy;
  end;

end;


end.
