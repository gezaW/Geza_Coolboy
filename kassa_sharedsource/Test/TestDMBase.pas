unit TestDMBase;
{

  Delphi DUnit Testfall
  ----------------------
  Diese Unit enthält ein Codegerüst einer Testfallklasse, das vom Testfall-Experten
  erzeugt wurde. Ändern Sie den erzeugten Code, damit die Methoden aus der
  getesteten Unit korrekt eingerichtet und aufgerufen werden.

}

interface

uses
  TestFramework, LMDCustomComponent, IB_Components, Classes, DMBase, IB_Monitor,
  LMDSysInfo, IBODataset, ExtCtrls, ExceptionLog, IB_Session, IB_Access, IB_StoredProc, DB,
  IB_SessionProps, SysUtils, ADODB;

type
  // Testmethoden für Klasse TDBase

  TestTDBase = class(TTestCase)
  strict private
    FDBase: TDBase;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestDataModuleCreate;
  end;

implementation

uses Forms;

procedure TestTDBase.SetUp;
begin
  FDBase := DBase;
end;

procedure TestTDBase.TearDown;
begin
  // do nothing
end;

procedure TestTDBase.TestDataModuleCreate;
begin
  check(FDBase <> nil, 'Data module "DBase" does not exist!');
  status('EurekaLog Subject = ' + CurrentEurekaLogOptions.EMailSubject);
end;


initialization
  // Alle Testfälle beim Test-Runner registrieren
  RegisterTest(TestTDBase.Suite);
end.

