unit PrintInterface;

interface

uses  SysUtils, forms, filectrl, IB_Components,
      Dialogs, //ShowMessage
      Windows, //DLL-Aufruf
      PosPrinting;
//      OMANLib_TLB; //for printer to RF printers in an Orderman radio network

{  TDruckArt = (daEinzelbon, daKassierbon, daLagerstand, daGesamtStorno,
               daTeilStorno, daGesamtUmbuchung, daTeilUmbuchung,
               daA4Rechnung, daBonRechnung);


  TDruckeBon = procedure(PTischID: integer; PDruckart: TDruckArt; pAnzahl: Integer;
                    pDatum: TDateTime; PVon, PNach: string; pDruckerID: Integer;
                    pDruckeBon: Boolean);


  TOpenLagerTische = procedure(pKellnerID: Integer);

  TSetDatabase = procedure(pPFad: String);
  TSetPrivDir = procedure(pPFad: String);}

  procedure DoDruckeBon(PTischID: integer; PDruckart: TDruckArt; pAnzahl: Integer;
                    pDatum: TDateTime; PVon, PNach: string; pDruckerID: Integer;
                    pDruckeBon: Boolean; pSpracheID, pTischGruppeID: Integer);
  procedure DoOpenLagerTische(pKellnerID, pKasseID, pLagerTischID: Integer);
  procedure DoSetDatabase(pConnection: TIB_Connection);  //(pPfad: String);
  procedure DoLoadPackage(pLanguage, pKasseID: Integer; pPath: String; pOman: TOman; pConnection: TIB_Connection);
  procedure DoSetPrintpackage(pWaiterID, pKasseID: Integer);
//  procedure DoSetPrivDir;


var {VDruckeBon: TDruckeBon;
    VOpenLagerTische: TOpenLagerTische;
    VSetDatabase : TSetDatabase;
    VSetPrivDir : TSetPrivDir;

    FuncPtr1: TFarProc;
    FuncPtr2: TFarProc;
    FuncPtr3: TFarProc;
    FuncPtr4: TFarProc;
    DLLHandle: THandle;       }

  PrivDirDLL : String;

implementation

procedure DoDruckeBon(PTischID: integer; PDruckart: TDruckArt; pAnzahl: Integer;
                    pDatum: TDateTime; PVon, PNach: string; pDruckerID: Integer;
                    pDruckeBon: Boolean; pSpracheID, pTischGruppeID: Integer);
begin
  tDruckeBon(PTischID, PDruckart, pAnzahl, pDatum,PCHar(PVon), PCHar(PNach),pDruckerID,
                      pDruckeBon, pSpracheID, pTischGruppeID);

end;

procedure DoOpenLagerTische(pKellnerID, pKasseID, pLagerTischID: Integer);
begin
  tOpenLagerTische(pKellnerID, pKasseID, pLagerTischID);
end;

procedure DoSetDatabase(pConnection: TIB_Connection);  //(pPfad: String);
begin
  tSetDataBase(pConnection);
end;

//05.12.2010 BW: new wrapper for loading the printer package
procedure DoLoadPackage(pLanguage, pKasseID: Integer; pPath: String; pOman: TOman; pConnection: TIB_Connection);
begin
  tLoadPackage(pLanguage, pKasseID, pPath, pOman, pConnection);
  //initialize db connections in printer package
  DoSetDatabase(pConnection);
end;

//05.12.2010 BW: new wrapper for setting the printer package (this must be called BEFORE EVERY DoDruckeBon because there is only one instance for every device)
procedure DoSetPrintpackage(pWaiterID, pKasseID: Integer);
begin
  //set waiter and kasse in printerpackage
  DoOpenLagerTische(pWaiterID, pKasseID, 0);//pLagerTischID = 0 because we just need to set the waiterid and the kasseid for DoDruckeBon
  //04.08.2010 BW: obsolete because connections in print package are already set in DoLoadPackage at startup in InitializeOrdermanServer
  //DoSetDatabase(DBase.ConnectionZEN);
end;

end.
