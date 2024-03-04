unit DMWaiterkey;

interface

uses
  System.SysUtils, System.Classes,
  firedac.comp.client, StdCtrls, bsdbctrls,
  ZylSerialPort, Vcl.ExtCtrls;

type
  // diverse Schloss-Typen (Kellnerschloss) verwendet in gl.SchlossTyp
  TSchlossTyp = (
    stNone=-1,
    stSteingress=0,
    stFSSchlüsselNr=1,
    stFSSchlüsselCode=2,
    stZMUGG=3,
    stSteingressKey=4,
    stTowitokoChipkarten=5,
    stDallasSeriell=6,
    stNovatec=7,
    stWMF=8,
    stDallasSteinbauer=9,
    stDallasTastatur=10,
    stTBTPatriot=11,
    stLegic=12,
    stASSI=13,
    stFSII=14,
    stASCON=15,
    stASSIUSB=16,
    stSeriellKonfigurierbar=17,
    stTimeware=18,
    stFingerprint=19,
    stMifarePromag=20,
    stTowtiokoNeu=21,
    stRFIDPromag=22);

type
  TWaiterkey = class(TDataModule)
    ZylSerialPort: TZylSerialPort;
    TimerASSI: TTimer;
    procedure ZylSerialPortReceive(Sender: TObject; Buffer: AnsiString);
    procedure ZylSerialPortSend(Sender: TObject; Buffer: AnsiString);
    procedure ZylSerialPortConnect(Sender: TObject; Port: TCommPort);
    procedure ZylSerialPortDisconnect(Sender: TObject; Port: TCommPort);
    procedure ZylSerialPortLineStatusChange(Sender: TObject;
      LineStatus: TLineStatusSet);
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure TimerASSITimer(Sender: TObject);
  private
    FTouchsetupLabel: TLabel; // used in Touchsetup.exe
    FKellnerDBEdit: TbsSkinDBEdit; // used in Kellner.exe
    FKellnerLabel: TLabel; // used in Kellner.exe
    FSchlosstyp: TSchlossTyp;
    FBaudrate, FPort, FParity, FDatawidth, FStopbits: Integer;
    FKeySerialFrom, FKeySerialLength: Integer;
    FCurrentKeyNumber, FLastKeyNumber: Int64;

    // 19.03.2013 KL: #4673:
    FLastAssiPoll: TDateTime; // Uhrzeit des letzten Polls merken
    FLastComPort: Byte;    // und Com-Port des letzten Polls
    // 24.09.2014 KL: immer nur ein Zugriff aufs Schloss, nicht starten und stoppen gleichzeitig
    FLockInProcess: Boolean;
    FAssiDLL: Integer;

    procedure ASSIInit;
    Procedure ASSIDeInit;
    function ShowSetupKey : Byte;
    function StartKey(xkDefaults,xkComPort,xkBaudRate,xkDSCode,xkPolling,xkReadTyp: Byte) : Byte;
    function StopKey : Byte;
    function GetKeyData(var NewKeyMsg, OldKeyMsg: ShortString; var KeyIsOn: Byte): Byte;
    procedure CheckLockInProcess;
    function getAssi128: boolean;

    procedure Log(pMessage: string);
    procedure ResetValues();
    function getIsConnected: Boolean;
    function getIsDisconnected: Boolean;
    procedure setCurrentKeyNumber(const Value: int64);
    { Private-Deklarationen }
  public
		property Assi128: boolean read getAssi128;

    procedure Init(pQueryOrTable: TFDCustomQuery); overload;
    procedure Init(pTouchsetupLabel: TLabel); overload;
    procedure Init(pKellnerDBEdit: TbsSkinDBEdit; pKellnerLabel: TLabel); overload;
    procedure Disconnect();
    procedure Connect();
    { Public-Deklarationen }
    property isConnected: Boolean read getIsConnected;
    property isDisconnected: Boolean read getIsDisconnected;
    property CurrentKeyNumber: int64 read FCurrentKeyNumber write setCurrentKeyNumber;
    property LastKeyNumber: int64 read FLastKeyNumber write FLastKeyNumber;
  end;


//------------------------ ASSI

// 07.10.2014 KL: alte Assi32.dll mit 8 Ports
type
  TShowSetupKey = function : Byte;
  TStartKey     = function (xkDefaults,xkComPort,xkBaudRate,xkDSCode,xkPolling,xkReadTyp: Byte) : Byte;
  TStopKey      = function : Byte;
  TGetKeyData   = function (var NewKeyMsg, OldKeyMsg: ShortString; var KeyIsOn: Byte): Byte;
var
  FShowSetupKey : TShowSetupKey;
  FStartKey : TStartKey;
  FStopKey : TStopKey;
  FGetKeyData : TGetKeyData;
  hDLL: THandle;

// 07.10.2014 KL: neue Assi32.dll mit bis zu 128 Ports
type
  TShowSetupKey128 = function : Integer;  stdcall;
  TStartKey128     = function (xkDefaults,xkComPort,xkBaudRate,xkDSCode,xkPolling,xkReadTyp: Integer) : Integer; stdcall;
  TStopKey128      = function : Integer;  stdcall;
  TGetKeyData128   = function (var NewKeyMsg, OldKeyMsg: ShortString; var KeyIsOn: Integer): Integer; stdcall;
var
  FShowSetupKey128 : TShowSetupKey128;
  FStartKey128 : TStartKey128;
  FStopKey128 : TStopKey128;
  FGetKeyData128 : TGetKeyData128;
  hDLL128: THandle;


var
  Waiterkey: TWaiterkey;

implementation

uses
  windows;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

function TWaiterkey.getAssi128: boolean;
begin
  Result := FAssiDLL=128;
end;

procedure TWaiterkey.setCurrentKeyNumber(const Value: int64);
begin
  FCurrentKeyNumber := Value;

  if FCurrentKeyNumber <> 0 then
  begin
    FLastKeyNumber := FCurrentKeyNumber;
    if FKellnerDBEdit <> nil then
      FKellnerDBEdit.Text := inttostr(FLastKeyNumber);
    if FKellnerLabel <> nil then
      FKellnerLabel.Visible := true;
  end
  else
    if FKellnerLabel <> nil then
      FKellnerLabel.Visible := false;

end;

function TWaiterkey.getIsConnected: Boolean;
begin
  try
    case FSchlosstyp of
      stNone: result := false;
      stASSI: result := (now - FLastAssiPoll) < (1/24/60/60/1000*5000);
      else result := ZylSerialPort.Port = ZylSerialPort.IsConnected;
    end;
  except on e:Exception do
    begin
      result := false;
      Log(e.Message);
    end;
  end;
end;

function TWaiterkey.getIsDisconnected: Boolean;
begin
  result := NOT isConnected;
end;

function TWaiterkey.GetKeyData(var NewKeyMsg, OldKeyMsg: ShortString;
  var KeyIsOn: Byte): Byte;
var aResult, aKeyIsOn: Integer;
Begin
  Result := 0;

  CheckLockInProcess;
  FLockInProcess := TRUE;
  try
    // 21.03.2013 KL: #4673: Wird ASSI Interface 2 Sek. nicht gepollt, schaltet es auf No Polling-Mode um!
    // Daher: wenn mehr als 1,9 Sekunden vergangen sind, Schloss neu initialisieren
    // 02.10.2014 KL: 2 Sekunden-Limit ist angeblich irrelevant lt. Addimat.
    // 01.04.2015 KL: stimmt aber nicht wie sich herausgestellt hat, deshalb wieder aktiviert!
//    if (now - FLastAssiPoll) > (1/24/60/60/1000*15000) then   //   15 Sekundden
//    begin
//      DBase.WriteToLog('Schloss automatisch neu initialisieren...', TRUE);
//      StopKey;                              // Schloss stoppen,
//      ASSIDeInit;
//      ASSIInit;
//      StartKey(0,FLastComPort,7,1,1,1);     // neu starten
//    end;

    try
      FLastAssiPoll:= now;

      NewKeyMsg := '';
      OldKeyMsg := '';
      KeyIsOn := 0;

      if Assi128 then
      begin
        aKeyIsOn := StrToIntDef(IntToStr(KeyIsOn), 0);
        aResult := FGetKeyData128(NewKeyMsg, OldKeyMsg, aKeyIsOn);
        Result := StrToIntDef(IntToStr(aResult),0);
        KeyIsOn := StrToIntDef(IntToStr(aKeyIsOn),0);
      end
      else
      begin
        Result := FGetKeyData(NewKeyMsg, OldKeyMsg, KeyIsOn);
      end;
    except on E: Exception do
      Log('Fehler in Funktion "GetKeyData": '+e.Message);
    end;
  finally
    FLockInProcess := FALSE;
  end;
end;

procedure TWaiterkey.Init(pQueryOrTable: TFDCustomQuery);
begin
  Disconnect();
  ResetValues();

  with pQueryOrTable do
  try
    if FieldByName('Aktiviert').AsBoolean then
    begin
      FSchlosstyp := TSchlossTyp(StrToIntDef(FieldByName('SchlossTyp').AsString, -1));

      if FieldByName('ASSI128Ports').AsBoolean then
        FAssiDLL := 128;

      FKeySerialFrom := FieldByName('KeySerialFrom').AsInteger;
      FKeySerialLength := FieldByName('KeySerialLength').AsInteger;

      if FieldByName('Baudrate').AsInteger > 0 then
        FBaudrate := FieldByName('Baudrate').AsInteger;

      if Trim(FieldByName('Port').AsString) > '' then
        if UpperCase(Copy(FieldByName('Port').AsString, 1, 3)) = 'COM' then
          FPort := StrToIntDef(Copy(FieldByName('Port').AsString, 4), 0)
        else if UpperCase(Copy(FieldByName('Port').AsString, 1, 1)) = 'C' then
          FPort := StrToIntDef(Copy(FieldByName('Port').AsString, 2), 0)
        else if StrToIntDef(FieldByName('Port').AsString, 0) in [1..128] then
          FPort := StrToInt(FieldByName('Port').AsString);

      if UpperCase(trim(FieldByName('Paritaet').AsString)) = 'ODD' then
        FParity := 1
      else if UpperCase(trim(FieldByName('Paritaet').AsString)) = 'EVEN' then
        FParity := 2;

      if FieldByName('Datenbits').AsInteger = 7 then
        FDatawidth := 7;

      if FieldByName('StopBits').AsInteger = 2 then
        FStopbits := 2;

      case FSchlosstyp of
        // -------------------------------------------------------------------------
        // ASSI key serial
        // -------------------------------------------------------------------------
        stASSI: ASSIInit;
      end;

      Connect();
    end;

  except on e:Exception do
    raise exception.Create('WaiterkeyInit: '+e.Message);
  end;
end;

procedure TWaiterkey.Init(pTouchsetupLabel: TLabel);
begin
  if pTouchsetupLabel<>nil then
    FTouchsetupLabel := pTouchsetupLabel;
end;

procedure TWaiterkey.Init(pKellnerDBEdit: TbsSkinDBEdit; pKellnerLabel: TLabel);
begin
  if pKellnerDBEdit<>nil then
    FKellnerDBEdit := pKellnerDBEdit;
  if pKellnerLabel<>nil then
    FKellnerLabel := pKellnerLabel;
end;

procedure TWaiterkey.Log(pMessage: string);
begin
  if FTouchsetupLabel <> nil then
    FTouchsetupLabel.Caption := pMessage + sLineBreak + formatdatetime('hh:nn:ss.zzz', now);
end;

procedure TWaiterkey.ResetValues;
begin
  FAssiDLL := 32;
  FCurrentKeyNumber := 0;
  FLastKeyNumber := 0;
  FLastAssiPoll := IncMonth(now, -1);

  FSchlosstyp := stNone;
  FBaudrate := 2400;
  FPort := 1;
  FParity := 0; // =NONE
  FDatawidth := 8;
  FStopbits := 1;

  FKeySerialFrom := 0;
  FKeySerialLength := 0;
end;

function TWaiterkey.ShowSetupKey: Byte;
var aResult: Integer;
begin
  Result := 0;

  CheckLockInProcess;
  FLockInProcess := TRUE;
  try
    try
      if Assi128 then
      begin
        aResult := FShowSetupKey128;
        Result := StrToIntDef(IntToStr(aResult),0);
      end
      else
      begin
        Result := FShowSetupKey;
      end;
    except on E: Exception do
      Log('Fehler in Funktion "ShowSetupKey": '+e.Message);
    end;
  finally
    FLockInProcess := FALSE;
  end;
end;

function TWaiterkey.StartKey(xkDefaults, xkComPort, xkBaudRate, xkDSCode,
  xkPolling, xkReadTyp: Byte): Byte;
var
  aResult, aDefaults, aComPort, aBaudRate, aDSCode, aPolling, aReadTyp: Integer;
Begin
  Result := 0;

  CheckLockInProcess;
  FLockInProcess := TRUE;
  try
    try
      FLastComPort := xkComPort; // 21.03.2013 KL: #4673
      FLastAssiPoll:= now;
      if Assi128 then
      begin
        aDefaults := StrToIntDef(IntToStr(xkDefaults),0);
        aComPort  := StrToIntDef(IntToStr(xkComPort),0);
        aBaudRate := StrToIntDef(IntToStr(xkBaudRate),0);
        aDSCode   := StrToIntDef(IntToStr(xkDSCode),0);
        aPolling  := StrToIntDef(IntToStr(xkPolling),0);
        aReadTyp  := StrToIntDef(IntToStr(xkReadTyp),0);
        FStartKey128(aDefaults,aComPort,aBaudRate,aDSCode,aPolling,aReadTyp);
        Result := 1;
//        xkDefaults := StrToIntDef(IntToStr(aDefaults),0);
//        xkComPort  := StrToIntDef(IntToStr(aComPort),0);
//        xkBaudRate := StrToIntDef(IntToStr(aBaudRate),0);
//        xkDSCode   := StrToIntDef(IntToStr(aDSCode),0);
//        xkPolling  := StrToIntDef(IntToStr(aPolling),0);
//        xkReadTyp  := StrToIntDef(IntToStr(aReadTyp),0);
      end
      else
      begin
        FStartKey(xkDefaults,xkComPort,xkBaudRate,xkDSCode,xkPolling,xkReadTyp);
        Result := 1;
      end;
    except on E: Exception do
      Log('Fehler in Funktion "StartKey": '+e.Message);
    end;
  finally
    FLockInProcess := FALSE;
  end;
End;

function TWaiterkey.StopKey: Byte;
var aResult: Integer;
Begin
  Result := 0;

  CheckLockInProcess;
  FLockInProcess := TRUE;
  try
    try
      if Assi128 then
      begin
        aResult := FStopKey128;
        Result := StrToIntDef(IntToStr(aResult),0);
      end
      else
      begin
        Result := FStopKey;
      end;
      Sleep(1500);  // 03.06.2014 KL: #7286: Wartezeit ist nötig, um Ausnahmecode 0xc0000005 zu vermeiden
    except on E: Exception do
      Log('Fehler in Funktion "StopKey": '+e.Message);
    end;
  finally
    FLockInProcess := FALSE;
  end;
end;

procedure TWaiterkey.TimerASSITimer(Sender: TObject);
var
  aNewKeyMsg, aOldKeyMsg: ShortString;
  aKeyIsOn: Byte;

begin
  TimerASSI.Enabled := False;
  try
    GetKeyData(aNewKeyMsg, aOldKeyMsg, aKeyIsOn);
    Log(aNewKeyMsg);

    CurrentKeyNumber := StrToInt64Def(copy(aNewKeyMsg, length(aNewKeyMsg)-8), 0);
  finally
    TimerASSI.Enabled := true;
  end;
end;

procedure TWaiterkey.ASSIDeInit;
begin
  if Assi128 then
  begin
    If hDLL128 <> 0 Then  // 02.06.2014 KL: #7286: NUR freigeben wenn Speicheradresse bekannt ist
    try
      FreeLibrary(hDLL128);
      hDLL128 := 0;
//      @FStartKey128 := nil;
//      @FStopKey128 := nil;
//      @FGetKeyData128 := nil;
//      @FShowSetupKey128 := nil;
    except on E: Exception do
      Log('Fehler beim Freigeben der ASSI128.dll: '+e.Message);
    end;
  end
  else
  begin
    If hDLL <> 0 Then  // 02.06.2014 KL: #7286: NUR freigeben wenn Speicheradresse bekannt ist
    try
      FreeLibrary(hDLL);
      hDLL := 0;
//      @FStartKey := nil;
//      @FStopKey := nil;
//      @FGetKeyData := nil;
//      @FShowSetupKey := nil;
    except on E: Exception do
      Log('Fehler beim Freigeben der ASSI32.dll: '+e.Message);
    end;
  end;
end;

procedure TWaiterkey.ASSIInit;
var dwError: Integer;
begin
  FLockInProcess := FALSE;

  if Assi128 then
  begin
    hDLL128 := LoadLibrary('ASSI128.dll');
    If hDLL128 = 0 Then  // 02.06.2014 KL: #7286: wenn Handler noch 0 ist, hat's nicht funktioniert.
    begin
      dwError := GetLastError;
      Log(Format('Fehler beim Laden der ASSI128.DLL: %d', [dwError]));
    end
    else
    try
      @FStartKey128 := GetProcAddress(hDLL128, 'StartKey');
      @FStopKey128 := GetProcAddress(hDLL128, 'StopKey');
      @FGetKeyData128 := GetProcAddress(hDLL128, 'GetKeyData');
      @FShowSetupKey128 := GetProcAddress(hDLL128, 'ShowSetupKey');
    except on E: Exception do
      Log(Format('Fehler beim Laden der Prozeduren (ASSI128.DLL): %s', [e.Message]));
    End;
  end
  else
  begin
    hDLL := LoadLibrary('ASSI32.dll');
    If hDLL = 0 Then  // 02.06.2014 KL: #7286: wenn Handler noch 0 ist, hat's nicht funktioniert.
    begin
      dwError := GetLastError;
      Log(Format('Fehler beim Laden der ASSI32.DLL: %d', [dwError]));
    end
    else
    try
      @FStartKey := GetProcAddress(hDll, 'StartKey');
      @FStopKey := GetProcAddress(hDll, 'StopKey');
      @FGetKeyData := GetProcAddress(hDll, 'GetKeyData');
      @FShowSetupKey := GetProcAddress(hDll, 'ShowSetupKey');
    except on E: Exception do
      Log(Format('Fehler beim Laden der Prozeduren (ASSI32.DLL): %s', [e.Message]));
    End;
  end;
end;

procedure TWaiterkey.CheckLockInProcess;
var
  aBeginLoop: TDateTime;
begin
  // 25.09.2014 KL: während Zugriff auf Assi-Schloss keinen anderen Zugriff erlauben,
  // sondern warten, max. 1 Sekunde
  aBeginLoop := now;
  while FLockInProcess and ((now - aBeginLoop) < (1/24/60/60)) do
  begin
    Sleep(50);
    Log('Schloss.CheckLockInProcess: Sleep 50');
  end;
end;

procedure TWaiterkey.Connect();
begin
  try
    Disconnect();

    case FSchlosstyp of
      stNone: exit;
      // -------------------------------------------------------------------------
      // ASSI key serial
      // -------------------------------------------------------------------------
      stASSI:
      begin
        ASSIInit;
        // only COM-Port is used (not baud rate, ...)
        StartKey(0, FPort, 7, 1, 1, 1);
        TimerASSI.Enabled := True;
      end;

      // -------------------------------------------------------------------------
      // ALL OTHER serial keys
      // -------------------------------------------------------------------------
      else
      begin
        ZylSerialPort.Port := TCommPort(FPort);

        ZylSerialPort.BaudRate := brCustom;
        ZylSerialPort.CustomBaudRate := FBaudrate;

        ZylSerialPort.Parity := TParityBits(FParity);
        if FDatawidth=7 then
          ZylSerialPort.DataWidth := dw7Bits
        else
          ZylSerialPort.DataWidth := dw8Bits;
        if FStopbits = 2 then
          ZylSerialPort.StopBits := sb2Bits
        else
          ZylSerialPort.StopBits := sb1Bit;

        // try to connect and wait for Receive-Event
        ZylSerialPort.Open;
      end;
    end;
  except on e:Exception do
    raise Exception.Create('WaiterkeyStart: '+e.Message);
  end;
end;

procedure TWaiterkey.DataModuleCreate(Sender: TObject);
begin
  ResetValues();
end;

procedure TWaiterkey.DataModuleDestroy(Sender: TObject);
begin
  Disconnect;

  try
    case FSchlosstyp of
      // -------------------------------------------------------------------------
      // ASSI key serial
      // -------------------------------------------------------------------------
      stASSI: ASSIDeInit;
    end;
  except on e:Exception do
    Log(e.Message);
  end;

end;

procedure TWaiterkey.Disconnect();
begin
  FCurrentKeyNumber := 0;

  if isConnected then
  try
    case FSchlosstyp of
      stNone: EXIT;
      // -------------------------------------------------------------------------
      // ASSI key serial
      // -------------------------------------------------------------------------
      stASSI:
      begin
        TimerASSI.Enabled := false;
        if (Assi128 and (hDLL128<>0))
        or (NOT Assi128 and (hDLL<>0)) then
        begin
          StopKey;
        end;
      end;
      // -------------------------------------------------------------------------
      // ALL OTHER serial keys
      // -------------------------------------------------------------------------
      else
      begin
        // disconnect
        ZylSerialPort.Close;
      end;
    end;
  except on e:Exception do
    Log(e.Message);
  end;
end;

procedure TWaiterkey.ZylSerialPortConnect(Sender: TObject; Port: TCommPort);
begin
  Log('connected to '+ZylSerialPort.CommPortToString(Port));
end;

procedure TWaiterkey.ZylSerialPortDisconnect(Sender: TObject; Port: TCommPort);
begin
  Log('disconnected from '+ZylSerialPort.CommPortToString(Port));
  FCurrentKeyNumber := 0;
end;

procedure TWaiterkey.ZylSerialPortLineStatusChange(Sender: TObject;
  LineStatus: TLineStatusSet);
begin
  Log('line changed');
end;

procedure TWaiterkey.ZylSerialPortReceive(Sender: TObject; Buffer: AnsiString);
var
  s : String;
begin
  s := Buffer;
  Log(s);
  case FSchlosstyp of
    stNone, stASSI:
      ResetValues;
    stSeriellKonfigurierbar:
      CurrentKeyNumber := StrToInt64Def(Copy(s, FKeySerialFrom, FKeySerialLength), 0);
    stZMUGG:
      CurrentKeyNumber := StrToInt64Def(Copy(s, 2, 3), 0);
    else
      CurrentKeyNumber := StrToInt64Def(s, 0);
  end;
end;

procedure TWaiterkey.ZylSerialPortSend(Sender: TObject; Buffer: AnsiString);
var
  Str : String;
begin
  Str := string(Buffer);
  Log('Send:'+Str);
end;

end.
