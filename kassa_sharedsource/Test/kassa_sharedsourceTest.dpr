program kassa_sharedsourceTest;
{

  Delphi DUnit-Testprojekt
  -------------------------
  Dieses Projekt enthält das DUnit-Test-Framework und die GUI/Konsolen-Test-Runner.
  Zum Verwenden des Konsolen-Test-Runners fügen Sie den konditinalen Definitionen  
  in den Projektoptionen "CONSOLE_TESTRUNNER" hinzu. Ansonsten wird standardmäßig
  der GUI-Test-Runner verwendet.

}

{$IFDEF CONSOLE_TESTRUNNER}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
  ExceptionLog,
  Forms,
  TestFramework,
  GUITestRunner,
  TextTestRunner,
  DMDesign in '..\DMDesign.pas' {DataDesign: TDataModule},
  DMBase in '..\DMBase.pas',
  DMLogging in '..\DMLogging.pas' {DataLogging: TDataModule},
  GlobalFunc in '..\GlobalFunc.pas',
  SelectDB in '..\SelectDB.pas' {frmSelectDB},
  TestDMBase in 'TestDMBase.pas',
  TestDMLogging in 'TestDMLogging.pas';

{$R *.RES}

begin
  Application.Initialize;
  // create some objects needed for testing:
  // ---------------------------------------

  // objects needed in tests for Global.pas:
  Application.CreateForm(TDataDesign, DataDesign);
  Application.CreateForm(TDBase, DBase);
  Application.CreateForm(TDataLogging, DataLogging);
  // start testing
  if IsConsole then
    TextTestRunner.RunRegisteredTests
  else
    GUITestRunner.RunRegisteredTests;
end.

