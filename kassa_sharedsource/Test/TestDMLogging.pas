unit TestDMLogging;
{

  Delphi DUnit Testfall
  ----------------------
  Diese Unit enthält ein Codegerüst einer Testfallklasse, das vom Testfall-Experten
  erzeugt wurde. Ändern Sie den erzeugten Code, damit die Methoden aus der 
  getesteten Unit korrekt eingerichtet und aufgerufen werden.

}

interface

uses
  TestFramework, LMDIniCtrl, IdExplicitTLSClientServerBase, IdComponent, SysUtils, 
  IdBaseComponent, windows, CodeSiteLogging, IdSMTP, IdTCPConnection, IdMessageClient, 
  LMDCustomComponent, IdTCPClient, Classes, DMLogging, IdSMTPBase, IdMessage;

type
  // Testmethoden für Klasse TDataLogging
  
  TestTDataLogging = class(TTestCase)
  strict private
    FDataLogging: TDataLogging;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestDataModuleCreate;
  end;

implementation

procedure TestTDataLogging.SetUp;
begin
  FDataLogging := DataLogging;
end;

procedure TestTDataLogging.TearDown;
begin
  // do nothing
end;

procedure TestTDataLogging.TestDataModuleCreate;
begin
  check(FDataLogging <> nil, 'Data module "DataLogging" does not exist!');
  status('Logging Path = ' + FDataLogging.KasseCodeSite.Destination.LogFile.FilePath);
end;


initialization
  // Alle Testfälle beim Test-Runner registrieren
  RegisterTest(TestTDataLogging.Suite);
end.

