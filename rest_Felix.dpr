program rest_Felix;
{$APPTYPE GUI}

{$R *.dres}

uses
  Vcl.Forms,
  Web.WebReq,
  IdHTTPWebBrokerBridge,
  Vcl.Themes,
  Vcl.Styles,
  restFelixMainUnit in 'restFelixMainUnit.pas' {rstFelixMain},
  ServerContainerUnit in 'ServerContainerUnit.pas' {ServerContainer1: TDataModule},
  DMEmail in 'DMEmail.pas' {DataEmail: TDataModule},
  TempModul in 'TempModul.pas' {TM: TDataModule},
  ExternalCashDesk in 'ExternalCashDesk.pas' {Extern: TDataModule},
  DataModule in 'DataModule.pas' {DM: TDataModule},
  Resources in 'Resources.pas',
  TokenUnit in 'TokenUnit.pas',
  ServerIntf in 'ServerIntf.pas',
  CheckThingsUnit in 'CheckThingsUnit.pas',
  WebModuleUnit in 'WebModuleUnit.pas' {WebModule1: TWebModule},
  CertificateSettings in 'CertificateSettings.pas' {FormCertificates},
  SettingsUnit in 'SettingsUnit.pas' {SettingForm},
  enmploy_contr in 'enmploy_contr.pas' {employee_control},
  user_data in 'user_data.pas' {FormUserData},
  ServerMethodsUnit in 'ServerMethodsUnit.pas' {API: TDataModule},
  EventUnit in 'EventUnit.pas' {Event: TDataModule},
  Logging in 'Logging.pas' {Log: TDataModule},
  DataModulCashDesk in 'DataModulCashDesk.pas' {DMCashDesk: TDataModule},
  ServerCashDeskUnit in 'ServerCashDeskUnit.pas' {CD: TDataModule},
  ServerExternFunctions in 'ServerExternFunctions.pas' {EF: TDataModule},
  CashDeskWork in 'CashDeskWork.pas' {CWU: TDataModule};

{$R *.res}

begin
  if WebRequestHandler <> nil then
    WebRequestHandler.WebModuleClass := WebModuleClass;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('GMS Felix');
  Application.CreateForm(TLog, Log);
  Application.CreateForm(TrstFelixMain, rstFelixMain);
  Application.CreateForm(TCD, CD);
  Application.CreateForm(TEF, EF);
  Application.CreateForm(TCWU, CWU);
  // CashdeskUnit
    Application.CreateForm(TDM, DM);
//  Application.CreateForm(TDMCashDesk, DMCashDesk);
  //  Application.CreateForm(TOEBB, OEBB);
  // Korrekte Form: Application.CreateForm(TAPI, sMethod);
  Application.CreateForm(TAPI, sMethod);
//  Application.CreateForm(TX3000, X3000);
  Application.CreateForm(Temployee_control, employee_control);
  Application.CreateForm(TFormUserData, FormUserData);
  Application.CreateForm(TDataEmail, DataEmail);

  Application.CreateForm(TFormCertificates, FormCertificates);
  Application.Run;
end.
