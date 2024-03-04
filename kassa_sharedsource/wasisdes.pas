unit wasisdes;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, OleCtrls, WIBUKEYLib_TLB, ExtCtrls, CodemeterStick;

const
{ ----------------------------------------------------------------------
  Wibu-Key-Modules
  ---------------------------------------------------------------------- }
  C_INTERNEZIMMERVERWALTUNG	: Integer = 2;
  C_KASSEWORD: Integer = 4;
  C_KITCHENDISPLAY	: Integer = 8;
  // 16;
  C_Schank : Integer = 32;
  C_Scale	: Integer = 64;
  C_KREDITANSCHLUSS	: Integer = 128;
  // 256;
  C_FelixZimmer	: Integer = 512;
  C_Fiskaltrust	: Integer = 1024;
  // 2048;
  // 4096;
  // 8192;
  // 16384;
  C_STOCKLAGER	: Integer = 32768;
  C_ARBEITSZEIT	: Integer = 65536;
  C_GASTPASS	: Integer = 131072;
  // 262144;
  C_MARKEN	: Integer = 524288;
  C_GEGENBUCHUNG	: Integer = 1048576;
  C_TISCHRESERVIERUNG	: Integer = 2097152;
  C_PIZZAMODUL	: Integer = 4194304;
  C_HAPPYHOUR	: Integer = 8388608;

type
  Tfmwasisdes = class(TForm)
    TimerWasisdes: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TimerWasisdesTimer(Sender: TObject);
  private
    FWibuKey: TWibuKey;
    FSeriennummer: string;
    FUserCode: Integer;
    FRelease: Integer;
    { Private-Deklarationen }
    function CheckNamen: Boolean;
    procedure CheckLicenseKeys(pCheckAgain: Boolean);
    procedure DeactivateModul(var pModul: boolean; const pLocal: Boolean;
      const pName, pVariable, pLizenz: string); overload;
    procedure DeactivateModul(var pModul: boolean; const pLocal: Boolean;
      const pName, pVariable: string; const pProduct: Boolean); overload; // CodeMeter
    procedure DeactivateModul(var pModul: Boolean; const pLocal: Boolean;
      const pName, pVariable: string; const pWibu: Integer); overload;    // WIBU
    procedure ActivateModul(var pModul: Boolean; const pProduct: Boolean); overload; // CodeMeter
    procedure ActivateModul(var pModul: Boolean; const pWibu: Integer); overload;    // WIBU
  public
    //FALSE: Beim Starten
    //TRUE: noch mal checken, ob Lizenz vorhanden
    function  CheckWasIsDes(pCheckAgain: Boolean; pShowMessage: Boolean=TRUE): Boolean;
    procedure DeactivateModulesGKL(const pCheckAgain: Boolean; const pGKT: TGKT);
    procedure DeactivateModulesGKT(pStick: TStick);
    procedure GetSchutzintervall;
    procedure HaltOnLicenseWarning(pReasonForWarning: string);
    // 27.10.2014 KL: Programm in Registry suchen
    function CheckProgramInstalled(const pProgramDisplayName: string): Boolean; overload;
    // 27.10.2014 KL: Programm im Ordner Programme suchen
    function CheckProgramInstalled(const pProgramPath, pFileName: string): Boolean; overload;
    // 18.11.2014 KL: Codemeter- oder Wibu-Lizenz prüfen
    function CheckLicence(pHaltOnLicenseWarning: boolean = True): Boolean;

    property SNR: string read FSeriennummer;
  end;

var
  fmwasisdes: Tfmwasisdes;

implementation

{$R *.dfm}

uses Global, Utilities, IvDictio, DMDesign, DMBase,
//  Info,
  Registry;

function Tfmwasisdes.CheckNamen: Boolean;
begin
    Result := FALSE;
//  Result := TRUE;
end;

// 27.10.2014 KL: Programm im Ordner "ProgrammFiles" suchen
function Tfmwasisdes.CheckProgramInstalled(const pProgramPath, pFileName: string): Boolean;
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

// 27.10.2014 KL: Programm in der "Registry" suchen
function Tfmwasisdes.CheckProgramInstalled(const pProgramDisplayName: string): Boolean;
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

procedure Tfmwasisdes.FormCreate(Sender: TObject);
begin
  FSeriennummer := '';
  FUserCode := 0;
  FRelease := 0;
end;

procedure Tfmwasisdes.FormDestroy(Sender: TObject);
begin
  if FWibuKey<>nil then
    FreeAndNil(FWibuKey);
end;

procedure Tfmwasisdes.TimerWasisdesTimer(Sender: TObject);
begin
  FWibuKey.TextData := 'GMS rocks';
  FWibuKey.EncryptMode := 1; //'wkEncIndirect
  FWibuKey.Encrypt();
  FWibuKey.UsedEncryption.Purge;
end;

function Tfmwasisdes.CheckWasIsDes(pCheckAgain: Boolean; pShowMessage: Boolean=TRUE): Boolean;
begin
  Result := False;
  gl.LicenseKeys := 0;

  if CheckNamen then
    EXIT;


  if FWIbukey=nil then
  begin
    FWibuKey := TWibuKEy.Create(self);
    FWibuKey.UsedSubsystems := wkSbLocal + wkSbWkLAN;
    if DBase.DAS then
    begin
      FWibuKey.FirmCode := 250010;
      FWibuKey.UserCode := 1011;
      FWibuKey.AlgorithmVersion := wkAlgPermutate;
    end
    else
    begin
      // 22.06.2018 KL: #20203 zuerst ohne Firmencode suchen,
      // weil GKL-Stick sonst nicht funkt. (abhängig vom Wibu-Treiber)
      FWibuKey.DialogOptions := wkDlgNoScanDialog;
      FWibuKey.LimitCounterDecrementMode;
      FWibuKey.RestrictedUserQuantityMode := ( UpperCase(ExtractFileName(ParamStr(0)))
                                       = Uppercase('Tagesabschluss.exe') );
      FWibuKey.CheckBox;
      FWibuKey.UsedBoxEntry.MoveFirst;
      FWibuKey.UsedBoxEntry.Index := 1;
      FWibuKey.UsedBoxEntry.MoveToIndex;
      if NOT FWibuKey.UsedBoxEntry.HasAddedDataEntry then
        FWibuKey.FirmCode := 2268;
    end;

    FWibuKey.DialogOptions := wkDlgNoScanDialog;
    FWibuKey.LimitCounterDecrementMode;
  end;

  // 17.11.2014 KL: RestrictedUserQuantityMode bei KASSE.EXE deaktiviert,
  // damit nicht 2 WIBU-Lizenzen abgezogen werden!
  // Denn es wird bereits eine abgezogen durch die
  // Verschlüsselung mit dem AxProtector!
  FWibuKey.RestrictedUserQuantityMode := ( UpperCase(ExtractFileName(ParamStr(0)))
                                   = Uppercase('Tagesabschluss.exe') );
  FWibuKey.CheckBox;
  FWibuKey.UsedBoxEntry.MoveFirst;
  FWibuKey.UsedBoxEntry.Index := 1;
  FWibuKey.UsedBoxEntry.MoveToIndex;
  if FWibuKey.UsedBoxEntry.HasAddedDataEntry then
  begin
    FWibuKey.UsedAddedEntry.MoveToAddedDataEntry;
    gl.LicenseKeys := FWibuKey.UsedAddedEntry.AddedDataLow;
    // ==============================
    // just for debugging and testing
    // ==============================
//    if dbase.isdebug then
//      gl.LicenseKeys := 2047; // alle Bits aktivieren von 1 bis 1024
    // ==============================
    // end of testing
    // ==============================
  end;

  try
    FSeriennummer := FWibuKey.UsedWibuBox.SerialText;
  except
    FSeriennummer := '';
  end;
  try
    FUserCode := FWibuKey.UsedBoxEntry.UserCode;
  except
    FUserCode := 0;
  end;
  if FUserCode = 0 then
  begin
    if pShowMessage then
      HaltOnLicenseWarning('Keine Lizenz gefunden. (UserCode=0)');
    EXIT;
  end;

  // alte Releases kleiner Kasse ZEN blockieren
  try
    FRelease := FWibuKey.UsedAddedEntry.AddedDataHigh;
  except
    FRelease := 0;
  end;
  if FRelease < 100 then
  if NOT DBase.IsDebug then   // IPs: 192.168.101.85 / 192.168.100.8
  begin
    HaltOnLicenseWarning('Ihre Wibu-Lizenz ist ab Kasse ZEN nicht mehr gültig.');
    EXIT;
  end;

  TimerWasIsDes.Enabled := TRUE;
  gl.NoScale := FALSE;
  gl.NoTischReservierung := False;
  gl.NoStammgast := False;

  // check license keys, but NOT in DAS (All-In-One-Kasse)
  if FWibuKey.UsedBoxEntry.UserCode <> 1011 then
    CheckLicenseKeys(pCheckAgain);

  // deaktivate modules in DAS and GKL, but NOT in GKT
  Result := TRUE;
  case FWibuKey.UsedBoxEntry.UserCode of
    8011: DeactivateModulesGKL(PCheckAgain, nil); // deaktivate some modules in GKL (GMS Kasse Light)
    8061: ;                                       // no deactivating in GKT (GMS Kasse Touch)
    else
    begin
      Result := FALSE;
      HaltOnLicenseWarning('Keine gültige Lizenz gefunden. (UserCode='+IntToStr(FWibuKey.UsedBoxEntry.UserCode)+')');
      Exit;
    end;
  end;

  // Schutzintervall auslesen
  GetSchutzintervall;

end;

procedure Tfmwasisdes.DeactivateModulesGKT(pStick: TStick);
begin
  gl.LicenseKeys := 0;

  // ############################################################################
  // # Wenn hier was geändert wird, dann auch in "CheckLicenseKeys" ändern!     #
  // ############################################################################

  gl.NoTischReservierung := False;
  gl.NoStammgast := False;

  // Lizenzen prüfen und deaktivieren
  // wenn der 3.Parameter leer ist, wird KEINE Meldung angezeigt
  // wenn der 4.Parameter leer ist, wird das Feld in der Datenbank NICHT auf FALSE gesetzt

  DeactivateModul(gl.KitchenDisplay, FALSE, 'Küchendisplay', 'KITCHENDISPLAY', pStick.GKT.Kuechendisplay);

  DeactivateModul(gl.Schank, FALSE, 'Schank', '', pStick.GKT.Schankanschluss);
  DeactivateModul(gl.Gegenbuchung, FALSE, '', '', pStick.GKT.Schankanschluss); // Gegenbuchung OHNE Meldung

  DeactivateModul(gl.Scale, FALSE, '', '', pStick.GKT.Waagenanschluss); // Waagenanschluss OHNE Meldung, u.in EINSTELL nicht FALSE setzen
  gl.NoScale := NOT gl.scale;

  DeactivateModul(gl.KreditAnschluss, TRUE, 'Kreditkarten', 'KREDITANSCHLUSS', pStick.GKT.Kreditkartenanschluss);

  if gl.FelixZimmer and (gl.HotelProgrammTyp = 3) then
    DeactivateModul(gl.FelixZimmer, FALSE, 'Hotelprogramm', '', pStick.GHF.isActivated); // FelixZimmer in EINSTELL nicht auf FALSE setzen

  if NOT dbase.isdebug then
    DeactivateModul(gl.Fiskaltrust, FALSE, 'Fiskaltrust', '', pStick.GKT.Fiskaltrust); // Fiskaltrust in EINSTELL nicht auf FALSE setzen

end;

procedure Tfmwasisdes.HaltOnLicenseWarning(pReasonForWarning: string);
var
  aMessage: string;
begin
  aMessage := 'Computerschutz ist aktiviert!';

  if trim(pReasonForWarning) <> '' then
    aMessage := aMessage + sLineBreak + pReasonForWarning;

  aMessage := aMessage
    + sLineBreak + 'Bitte informieren Sie Ihren Softwarepartner'
    + sLineBreak + 'oder die Firma GMS'
    + sLineBreak + 'Tel.: +43-4734-627-50';

  DataDesign.ShowMessageSkin(Translate(aMessage));
  Application.Terminate;
  Halt;
end;


procedure Tfmwasisdes.GetSchutzintervall;
var
  aFile: TextFile;
  aStr: String;
begin
  gl.Schutz := 0;
  // Schutzintervall auslesen
  try
    If FileExists('c:\winnt\system32\cobr.ick') Or FileExists('c:\windows\system32\cobr.ick') Then
    Begin
      If FileExists('c:\winnt\system32\cobr.ick') then
        AssignFile(aFile, 'c:\winnt\system32\cobr.ick')
      else
        AssignFile(aFile, 'c:\windows\system32\cobr.ick');
      Reset(aFile);
      ReadLn(aFile, aStr);
      If StrToDate(aStr) < Date Then
        gl.Schutz := round(Date - StrToDate(aStr));
      CloseFile(aFile);
    End;
  except on E: Exception do
    DataDesign.ShowMessageSkin(Translate('Fehler beim Auslesen des Schutzintervalls: ') + E.Message);
  end;

end;

function Tfmwasisdes.CheckLicence(pHaltOnLicenseWarning: boolean = True): Boolean;
var
  aStick: TStick;
  aRuntime: string;

begin
  // check licenses on a codemeter stick or on a wibu key.
  Result := FALSE;
  aRuntime := '';

  // check Codemeter if installed
  if NOT Result then
  begin
    if fmwasisdes.CheckProgramInstalled('CodeMeter Runtime Kit')
    or fmwasisdes.CheckProgramInstalled('CodeMeter Development Kit')
    or fmwasisdes.CheckProgramInstalled('CodeMeter\Runtime\bin', 'CodeMeter.exe') then
    begin
      aRuntime := 'CodeMeter';
      DBase.WriteToLog(aRuntime+' prüfen...', FALSE);
      aStick := TStick.Create;
      try
        if aStick.GKT.isActivated then              // GKT + GKL
        begin
          // 08.05.2018 KL: #18602: block old releases less than Kasse ZEN 10.0
          if aStick.GKT.Features < 10000 then // Release 10.0 = 10000 on stick
          begin
            HaltOnLicenseWarning('Ihre Codemeter-Lizenz ist ab "Kasse ZEN" nicht mehr gültig.');
            Exit;
          end
          else
          begin
            Result := TRUE;
            fmwasisdes.DeactivateModulesGKT(aStick);
            if (NOT aStick.GKT.Vollversion) and (aStick.GKT.Lightversion) then         // GKL
              fmwasisdes.DeactivateModulesGKL(FALSE, aStick.GKT);
            fmwasisdes.GetSchutzintervall;
          end;
        end;
      finally
        aStick.Free;
      end;
    end;
  end;

  // check Wibu-Key if installed
  if NOT Result then
  begin
    if fmwasisdes.CheckProgramInstalled('WibuKey Setup')
    or fmwasisdes.CheckProgramInstalled('WIBU-KEY Setup')
    or fmwasisdes.CheckProgramInstalled('WibuKey Development Kit')
    or fmwasisdes.CheckProgramInstalled('WIBUKEY\Bin', 'Wibukey.dll')
    or fmwasisdes.CheckProgramInstalled('WIBUKEY\Bin', 'Wibukey64.dll') then
    begin
      aRuntime := Trim(aRuntime + ' WibuKey');
      DBase.WriteToLog(aRuntime+' prüfen......', FALSE);
      Result := fmwasisdes.CheckWasIsDes(FALSE, TRUE);
    end;
  end;

  // 17.10.2016 KL: #13579: lt. WH soll TABS nicht beendet werden bei fehlendem Dongle
  if pHaltOnLicenseWarning then
    // without license exit project
    if NOT Result then
      if aRuntime > '' then
        fmwasisdes.HaltOnLicenseWarning('Keine gültige Lizenz gefunden. ('+aRuntime+' found)')
      else
        fmwasisdes.HaltOnLicenseWarning('CodeMeter/WibuKey nicht installiert.');

end;

procedure Tfmwasisdes.CheckLicenseKeys(pCheckAgain: Boolean);
begin
  if pCheckAgain then
    EXIT;

  // ############################################################################
  // # Wenn hier was geändert wird, dann auch in "DeactivateModulesGKT" ändern! #
  // ############################################################################

  gl.NoTischReservierung := False;
  gl.NoStammgast := False;

  // Lizenzen prüfen und deaktivieren
  // wenn der 3.Parameter leer ist, wird KEINE Meldung angezeigt
  // wenn der 4.Parameter leer ist, wird das Feld in der Datenbank NICHT auf FALSE gesetzt

  DeactivateModul(gl.KitchenDisplay, FALSE, 'Küchendisplay', 'KITCHENDISPLAY', C_KITCHENDISPLAY);

  DeactivateModul(gl.Schank, FALSE, 'Schank', '', C_Schank);
  DeactivateModul(gl.Gegenbuchung, FALSE, '', '', C_Schank); // Gegenbuchung OHNE Meldung

  DeactivateModul(gl.Scale, FALSE, '', '', C_Scale); // Waagenanschluss OHNE Meldung, u.in EINSTELL nicht FALSE setzen
  gl.NoScale := NOT gl.scale;

  DeactivateModul(gl.KreditAnschluss, TRUE, 'Kreditkarten', 'KREDITANSCHLUSS', C_KREDITANSCHLUSS);

  if gl.FelixZimmer and (gl.HotelProgrammTyp = 3) then
    DeactivateModul(gl.FelixZimmer, FALSE, 'Hotelprogramm', '', C_FelixZimmer); // FelixZimmer in EINSTELL nicht auf FALSE setzen

  if NOT dbase.isdebug then
    DeactivateModul(gl.Fiskaltrust, FALSE, 'Fiskaltrust', '', C_Fiskaltrust); // Fiskaltrust in EINSTELL nicht auf FALSE setzen

end;


procedure Tfmwasisdes.DeactivateModulesGKL(const pCheckAgain: Boolean; const pGKT: TGKT);

  function GetBoolean(aStr: Variant) : Boolean;
  var dummy: variant;
  begin
    if ASTr = null then
      Result := False
    else
      If (VarToStr(aStr) = 'T') Or (VarToStr(aStr) = 'F') Then
      begin
        if aStr = 'F' then Result := FALSE
                      else Result := TRUE;
      end
      else  // Meldung "ist keinInteger" abfangen und vorher prüfen obs ein Integer ist
        if (StrToIntDef(aStr, low(integer))=StrToIntDef(aStr, high(integer))) then
        begin
          dummy := StrToInt(aStr);
          if dummy = 0 then Result := FALSE
                       else Result := TRUE;
        end
        else
          Result := FALSE;
  end;

begin
  //GKL
  gl.Light := TRUE;

//  if NOT dbase.isdebug then
  if pGKT = nil then
  begin  // WIBU
    DeactivateModul(gl.StockLager, FALSE, 'Stocklager', 'STOCKLAGER', C_STOCKLAGER);
    DeactivateModul(gl.ArbeitsZeit, FALSE, 'Arbeitszeiterfassung', 'ARBEITSZEIT', C_ARBEITSZEIT);
    DeactivateModul(gl.InterneZimmerverwaltung, FALSE, 'Interne Zimmerverwaltung', 'INTERNEZIMMERVERWALTUNG', C_INTERNEZIMMERVERWALTUNG);
    DeactivateModul(gl.GastPass, FALSE, 'Gastpass - Umsatzprofi', 'GASTPASS', C_GASTPASS);
    DeactivateModul(gl.Marken, FALSE, 'Essensmarken', 'MARKEN', C_MARKEN);
    DeactivateModul(gl.Gegenbuchung, FALSE, 'Gegenbuchung', 'GEGENBUCHUNG', C_GEGENBUCHUNG);
    DeactivateModul(gl.TischReservierung, FALSE, 'Tischreservierung', 'TISCHRESERVIERUNG', C_TISCHRESERVIERUNG); // 5.7.16 KL: #10988
      ActivateModul(gl.NoTischReservierung, C_TISCHRESERVIERUNG);  // betrifft nur die Sichtbarkeit des Buttons bei GKL
    DeactivateModul(gl.PizzaModul, FALSE, 'Pizza Modul', 'PIZZAMODUL', C_PIZZAMODUL);
    DeactivateModul(gl.HappyHour, FALSE, 'Happy Hour', 'HAPPYHOUR', C_HAPPYHOUR);
    DeactivateModul(gl.KasseWord, FALSE, 'Postwandler - Korrespondenz', 'KASSEWORD', C_KASSEWORD); // 5.7.16 KL: #9661
  end
  else
  begin  // CodeMeter
    DeactivateModul(gl.StockLager, FALSE, 'Stocklager', 'STOCKLAGER', pGKT.Stocklager);
    DeactivateModul(gl.ArbeitsZeit, FALSE, 'Arbeitszeiterfassung', 'ARBEITSZEIT', pGKT.Arbeitszeiterfassung);
    DeactivateModul(gl.InterneZimmerverwaltung, FALSE, 'Interne Zimmerverwaltung', 'INTERNEZIMMERVERWALTUNG', pGKT.InterneZimmerverwaltung);
    DeactivateModul(gl.GastPass, FALSE, 'Gastpass - Umsatzprofi', 'GASTPASS', pGKT.Umsatzprofi);
    DeactivateModul(gl.Marken, FALSE, 'Essensmarken', 'MARKEN', pGKT.Essensmarken);
    DeactivateModul(gl.Gegenbuchung, FALSE, 'Gegenbuchung', 'GEGENBUCHUNG', pGKT.Gegenbuchung);
    DeactivateModul(gl.TischReservierung, FALSE, 'Tischreservierung', 'TISCHRESERVIERUNG', pGKT.Tischreservierung); // 5.7.16 KL: #10988
      ActivateModul(gl.NoTischReservierung, pGKT.Tischreservierung);  // betrifft nur die Sichtbarkeit des Buttons bei GKL
    DeactivateModul(gl.PizzaModul, FALSE, 'Pizza Modul', 'PIZZAMODUL', pGKT.Pizzamodul);
    DeactivateModul(gl.HappyHour, FALSE, 'Happy Hour', 'HAPPYHOUR', pGKT.HappyHour);
    DeactivateModul(gl.KasseWord, FALSE, 'Postwandler - Korrespondenz', 'KASSEWORD', pGKT.Postwandler); // 5.7.16 KL: #9661
  end;

  // 29.04.2019 KL: #22539 nur wenn Light=F, dann auf TRUE setzen
  if NOT (pCheckAgain or getboolean(ReadGlobalValue('Light', 'F', 'KBOOLEAN'))) then
    WriteGlobalValue('Light', 'T', FALSE);

end;

procedure Tfmwasisdes.DeactivateModul(var pModul: boolean; const pLocal: Boolean; const pName, pVariable, pLizenz: string);
begin
  // wenn "pVariable" leer ist, dann Tabellen-Feld nicht auf FALSE setzen
  if (trim(pVariable)<>'') then
    if pLocal then
      WriteLocalValue(pVariable, 'F')
    else
      WriteGlobalValue(pVariable, 'F');

  pModul := FALSE;

  // wenn "pName" leer ist, dann KEINE Meldung bringen
  if (trim(pName)<>'') then
    DataDesign.ShowMessageSkin(pLizenz + '-Lizenz nicht korrekt. Modul "'+pName+'" wurde deaktiviert!');
end;

procedure Tfmwasisdes.DeactivateModul(var pModul: boolean; const pLocal: Boolean; const pName, pVariable: string; const pProduct: Boolean);
begin
  if pModul then
    if (NOT pProduct) then
      DeactivateModul(pModul, pLocal, pName, pVariable, 'Codemeter');
end;

procedure Tfmwasisdes.DeactivateModul(var pModul: Boolean; const pLocal: Boolean; const pName, pVariable: string; const pWibu: Integer);
begin
  if pModul then
    if (gl.LicenseKeys AND pWibu) <> pWibu then
      DeactivateModul(pModul, pLocal, pName, pVariable, 'WIBU');
end;

procedure Tfmwasisdes.ActivateModul(var pModul: Boolean; const pProduct: Boolean);
begin
  if NOT pModul then
    if pProduct then
      pModul := TRUE;
end;

procedure Tfmwasisdes.ActivateModul(var pModul: Boolean; const pWibu: Integer);
begin
  if NOT pModul then
    if (gl.LicenseKeys AND pWibu) = pWibu then
      pModul := TRUE;
end;



end.
