unit abDrucken;

interface
uses  db, DMbase,
      IvDictio,
      SysUtils,
      Dialogs, //DataDesign.ShowMessageSkin
      global, DMDesign, 
      Windows; //DLL-Aufruf


type
  TAbArt = (abXHaupt, abXUnter, abXArtikel, abXKurz,
            abZHaupt, abZUnter, abZArtikel, abZKurz, abZOhne);
  TXBonHaupt = procedure (PFirma, PKellnerID: integer; PFenster: boolean;
    pDatum: TDateTime; pTabs: Boolean );
  TAussenstand = procedure (PZwischenBilanz: boolean; PDatum:TDateTime;
                            PFirma:integer; PFenster: boolean);
  TAbschluss = procedure (PFirma, PKellnerID:integer; PTabs:Boolean; pDatum: TDateTime);
  TRechnungDruck = procedure (PRechnungsID, pAnzahl:integer; pArchiv: Boolean);
  TXText = procedure (pArt: Integer; pBezeichnung: String;
      pFelixUmbuchung, pNachlass, pOffen: Double; pDatum: TDateTime;pFirma: Integer;
        pZimmer: Double; pTabs: Boolean; pStornos: Double);
  TSetParams = procedure (pParam1, pParam2, pParam3, pParam4, pParam5, pParam6 : String);

  procedure DruckeZBonHauptgruppe(PFirma, PKellnerID:integer; PFenster:boolean; pDatum: TDateTime);
  procedure DruckeZBonUntergruppe(PFirma, PKellnerID:integer; PFenster:boolean; pDatum: TDateTime);
  procedure DruckeZBonArtikel    (PFirma, PKellnerID:integer; PFenster:boolean; pDatum: TDateTime);
  procedure DruckeZBonKurzbericht(PFirma, PKellnerID:integer; PFenster:boolean; pDatum: TDateTime);
  procedure DruckeZBonOhne(PFirma, PKellnerID:integer; PFenster:boolean; pDatum: TDateTime);
  procedure DruckeXBonHauptgruppe(PFirma, PKellnerID:integer; PFenster:boolean; pDatum: TDateTime);
  procedure DruckeXBonUntergruppe(PFirma, PKellnerID:integer; PFenster:boolean; pDatum: TDateTime);
  procedure DruckeXBonArtikel    (PFirma, PKellnerID:integer; PFenster:boolean; pDatum: TDateTime);
  procedure DruckeXBonKurzbericht(PFirma, PKellnerID:integer; PFenster:boolean; pDatum: TDateTime);
  procedure DruckeXText(pArt: Integer; pBezeichnung: String;
      pFelixUmbuchung, pNachlass, pOffen: Double; pDatum: TDateTime;pFirma: Integer;
      pZimmer, pStornos: Double);

  procedure DruckeAussenstand(PZwischenBilanz: boolean; PDatum:TDateTime;
                              PFirma:integer; PFenster:boolean);
  procedure Abrechnen(PFirma, PKellnerID:Integer; PTabs:boolean; pDatum: TDateTime);
  procedure RechnungDrucken(PRechnungsID, pAnzahl:integer; pArchiv: Boolean);
  procedure DoSetParams(dllHandle: THandle);

var glTabs: Boolean = FALSE;


implementation

//Aufruf der DLL bei X/Z-Bons
procedure DLLAufruf(PFirma, PKellnerID:integer;
                    PAbArt:TabArt; PFenster:Boolean; pDatum: TDateTime);
var XBon: TXBonHaupt;
    FuncPtr: TFarProc;
    DLLHandle: THandle;
begin
  FuncPtr := nil;
  //Laden der DLL
  try
    DLLHandle := LoadLibrary(PChar('AbschlussBon.dll'));
    DoSetParams(DllHandle);

    //Adresse der jeweiligen Funktion ermitteln:
    case PAbArt of
      abZHaupt:   FuncPtr := GetProcAddress(DLLHandle, 'DruckeZHaupt');
      abZUnter:   FuncPtr := GetProcAddress(DLLHandle, 'DruckeZUnter');
      abZArtikel: FuncPtr := GetProcAddress(DLLHandle, 'DruckeZArtikel');
      abZKurz:    FuncPtr := GetProcAddress(DLLHandle, 'DruckeZKurz');
      abZOhne:    FuncPtr := GetProcAddress(DLLHandle, 'DruckeZOhne');
      abXHaupt:   FuncPtr := GetProcAddress(DLLHandle, 'DruckeXHaupt');
      abXUnter:   FuncPtr := GetProcAddress(DLLHandle, 'DruckeXUnter');
      abXArtikel: FuncPtr := GetProcAddress(DLLHandle, 'DruckeXArtikel');
      abXKurz:    FuncPtr := GetProcAddress(DLLHandle, 'DruckeXKurz');
    end;

    //Wenn die Funktion gefunden wurde
    if FuncPtr <> nil then
    begin
      @XBon := FuncPtr;
      //Ausführen des Codes:
      try
        //DataDesign.ShowMessageSkin(Format('%d. Funktion der "AbschlussBon.dll" wird aufgerufen (Firma=%d, KellnerID=%d) ...',
        //                                  [Ord(PAbArt), PFirma, PKellnerID]));
        XBon(PFirma, PKellnerID, PFenster, pDatum, glTabs);
        // zur sicherheit noch warten, bis der Druck fertig ist
        Sleep(1000);
      except on E: Exception do
        DataDesign.ShowMessageSkin(Translate('Fehler bei Aufruf von')+' "AbschlussBon.dll": '+E.Message);
      end;
    end
    else
      DataDesign.ShowMessageSkin(Format(Translate('%d. Funktion oder "AbschlussBon.dll" nicht gefunden!'), [Ord(PAbArt)]));

  finally
    //Freigabe der DLL
    FreeLibrary(DLLHandle);
  end;
end;

procedure DruckeXText(pArt: Integer; pBezeichnung: String;
      pFelixUmbuchung, pNachlass, pOffen: Double; pDatum: TDateTime;pFirma: Integer;
      pZimmer, pStornos: Double);
var XText: TXText;
    FuncPtr: TFarProc;
    DLLHandle: THandle;
begin
  DLLHandle := LoadLibrary(PChar('AbschlussBon.dll'));
  DoSetParams(DllHandle);
  FuncPtr := GetProcAddress(DLLHandle, 'DruckeXText');
  if FuncPtr <> nil then
  begin
    @XText := FuncPtr;
    XText(pArt, pBezeichnung, pFelixUmbuchung, pNachlass, pOffen, pDatum,
      pFirma, pZimmer, TRUE, pStornos);
  end else DataDesign.ShowMessageSkin(Translate('Funktion oder DLL nicht gefunden!'));
  FreeLibrary(DLLHandle)
end;

//Aufruf der DLL bei Aussenstand
procedure DruckeAussenstand(PZwischenbilanz: boolean; PDatum:TDateTime;
                            PFirma:integer; PFenster: Boolean);
var Aussenstand: TAussenstand;
    FuncPtr: TFarProc;
    DLLHandle: THandle;
begin
  DLLHandle := LoadLibrary(PChar('AbschlussBon.dll'));
  DoSetParams(DllHandle);
  FuncPtr := GetProcAddress(DLLHandle, 'DruckeAussenstand');
  if FuncPtr <> nil then
  begin
    @Aussenstand := FuncPtr;
    Aussenstand(PZwischenbilanz, PDatum, PFirma, PFenster);
  end else DataDesign.ShowMessageSkin(Translate('Funktion oder DLL nicht gefunden!'));
  FreeLibrary(DLLHandle)
end;


procedure DoSetParams(dllHandle: THandle);
var aSetParam: TSetParams;
    aParams: array [1..6] of string;
    FuncPtr: TFarProc;
begin
  FuncPtr := GetProcAddress(DLLHandle, 'SetParams');
  if FuncPtr <> nil then
  begin
    @aSetParam := FuncPtr;
    aParams[1] := 'KASSEID='+IntToStr(DBase.KasseID);
    aParams[2] := 'SECTIONNAME='+DBAse.SectionName;
    aParams[3] := 'KASSELOCALID='+IntToStr(DBase.KasseLocalID);
    aSetParam( aParams[1],aParams[2],aParams[3],aParams[4],aParams[5],aParams[6]);
  end else DataDesign.ShowMessageSkin(Translate('Funktion oder DLL nicht gefunden!'));

end;

//Aufruf der DLL bei Autoabschluss offener Tische
procedure Abrechnen(PFirma, PKellnerID:Integer; PTabs:boolean; pDatum: TDateTime);
var Abschluss: TAbschluss;
    FuncPtr: TFarProc;
    DLLHandle: THandle;
begin
//Laden der DLL
  DLLHandle := LoadLibrary(PChar('AbschlussBon.dll'));
  DoSetParams(DllHandle);
//Adresse der jeweiligen Funktion ermitteln:
  FuncPtr := GetProcAddress(DLLHandle, 'OffeneTischeAbrechnen');
//Wenn die Funktion gefunden wurde
  if FuncPtr <> nil then
  begin
    @Abschluss := FuncPtr;
 //Ausführen des Codes:
    Abschluss(PFirma, PKellnerID, PTabs, pDatum);
  end else DataDesign.ShowMessageSkin(Translate('Funktion oder DLL nicht gefunden!'));
//Freigabe der DLL
  FreeLibrary(DLLHandle)
end;

procedure RechnungDrucken(PRechnungsID, pAnzahl:integer; pArchiv: Boolean);
var RechnungDruck: TRechnungDruck;
    FuncPtr: TFarProc;
    DLLHandle: THandle;
begin
//Laden der DLL
  DLLHandle := LoadLibrary(PChar('AbschlussBon.dll'));
  DoSetParams(DllHandle);
//Adresse der jeweiligen Funktion ermitteln:
  FuncPtr := GetProcAddress(DLLHandle, 'RechnungDrucken');
//Wenn die Funktion gefunden wurde
  if FuncPtr <> nil then
  begin
    @RechnungDruck := FuncPtr;
 //Ausführen des Codes:
    RechnungDruck(PRechnungsID, pAnzahl, pArchiv);
  end else DataDesign.ShowMessageSkin(Translate('Funktion oder DLL nicht gefunden!'));
//Freigabe der DLL
  FreeLibrary(DLLHandle)
end;


procedure DruckeXBonHauptgruppe(PFirma, PKellnerID: integer; PFenster: boolean; pDatum: TDateTime);
begin
  DLLAufruf(PFirma, PKellnerID, abXHaupt, PFenster, pDatum);
end;

procedure DruckeXBonUntergruppe(PFirma, PKellnerID: integer; PFenster: boolean; pDatum: TDateTime);
begin
  DLLAufruf(PFirma, PKellnerID, abXUnter, PFenster, pDatum);
end;

procedure DruckeXBonArtikel(PFirma, PKellnerID: integer; PFenster: boolean; pDatum: TDateTime);
begin
  DLLAufruf(PFirma, PKellnerID, abXArtikel, PFenster, pDatum);
end;

procedure DruckeXBonKurzbericht(PFirma, PKellnerID: integer; PFenster: boolean; pDatum: TDateTime);
begin
  DLLAufruf(PFirma, PKellnerID, abXKurz, PFenster, pDatum);
end;

procedure DruckeZBonHauptgruppe(PFirma, PKellnerID: integer; PFenster: boolean; pDatum: TDateTime);
begin
  DLLAufruf(PFirma, PKellnerID, abZHaupt, PFenster, pDatum);
end;

procedure DruckeZBonUntergruppe(PFirma, PKellnerID: integer; PFenster: boolean; pDatum: TDateTime);
begin
  DLLAufruf(PFirma, PKellnerID, abZUnter, PFenster, pDatum);
end;

procedure DruckeZBonArtikel(PFirma, PKellnerID: integer; PFenster: boolean; pDatum: TDateTime);
begin
  DLLAufruf(PFirma, PKellnerID, abZArtikel, PFenster, pDatum);
end;

procedure DruckeZBonKurzbericht(PFirma, PKellnerID: integer; PFenster: boolean; pDatum: TDateTime);
begin
  DLLAufruf(PFirma, PKellnerID, abZKurz, PFenster, pDatum);
end;

procedure DruckeZBonOhne(PFirma, PKellnerID:integer; PFenster:boolean; pDatum: TDateTime);
begin
  DLLAufruf(PFirma, PKellnerID, abZOhne, PFenster, pDatum);
end;

initialization

begin
end;

finalization


end.
