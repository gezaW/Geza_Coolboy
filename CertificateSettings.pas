unit CertificateSettings;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TFormCertificates = class(TForm)
    LabelCertificateName: TLabel;
    EditCertificateFileName: TEdit;
    ButtonSelectCertificate: TButton;
    LabelKeyFile: TLabel;
    EditKeyFileName: TEdit;
    ButtonSelectKey: TButton;
    LabelKeyPassword: TLabel;
    EditKeyPassword: TEdit;
    LabelRootCertificate: TLabel;
    EditRootCertificateFileName: TEdit;
    ButtonSelectRootSertificate: TButton;
    ButtonOk: TButton;
    ButtonCancel: TButton;
    FileOpenDialog: TFileOpenDialog;
    procedure FormShow(Sender: TObject);
    procedure ButtonSelectCertificateClick(Sender: TObject);
    procedure ButtonSelectKeyClick(Sender: TObject);
    procedure ButtonSelectRootSertificateClick(Sender: TObject);
    procedure ButtonOkClick(Sender: TObject);
    procedure ButtonCancelClick(Sender: TObject);
  private
    { Private declarations }
    procedure SaveSettings;
  public
    { Public declarations }
  end;

var
  FormCertificates: TFormCertificates;

implementation

{$R *.dfm}
uses
  System.IniFiles, Resources;

procedure TFormCertificates.ButtonCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TFormCertificates.ButtonOkClick(Sender: TObject);
begin
  SaveSettings;
  ModalResult := mrOk;
end;

procedure TFormCertificates.ButtonSelectCertificateClick(Sender: TObject);
begin
  if FileOpenDialog.Execute then
    EditCertificateFileName.Text := FileOpenDialog.FileName;
end;

procedure TFormCertificates.ButtonSelectKeyClick(Sender: TObject);
begin
  if FileOpenDialog.Execute then
    EditKeyFileName.Text := FileOpenDialog.FileName;
end;

procedure TFormCertificates.ButtonSelectRootSertificateClick(Sender: TObject);
begin
  if FileOpenDialog.Execute then
    EditRootCertificateFileName.Text := FileOpenDialog.FileName;
end;

procedure TFormCertificates.FormShow(Sender: TObject);
var
  aIni: TIniFile;
begin
  aIni := TIniFile.Create(ExtractFilePath(ParamStr(0)) + cRestFelixIniFileName);
  try
    EditKeyPassword.Text := aIni.ReadString(cRestFelixIniServerSectionName, cRestFelixIniKeyPasswordName, '');
    EditKeyFileName.Text := aIni.ReadString(cRestFelixIniServerSectionName, cRestFelixIniKeyNameFileName, '');
    EditCertificateFileName.Text := aIni.ReadString(cRestFelixIniServerSectionName, cRestFelixIniKeyCertificateFileName, '');
    EditRootCertificateFileName.Text := aIni.ReadString(cRestFelixIniServerSectionName, cRestFelixIniRootCertificateFileName, '');
  finally
    FreeAndNil(aIni);
  end;
end;

procedure TFormCertificates.SaveSettings;
var
  aIni: TIniFile;
begin
  aIni := TIniFile.Create(ExtractFilePath(ParamStr(0)) + cRestFelixIniFileName);
  try
    aIni.WriteString(cRestFelixIniServerSectionName, cRestFelixIniKeyPasswordName, EditKeyPassword.Text);
    aIni.WriteString(cRestFelixIniServerSectionName, cRestFelixIniKeyNameFileName, Trim(EditKeyFileName.Text));
    aIni.WriteString(cRestFelixIniServerSectionName, cRestFelixIniKeyCertificateFileName, Trim(EditCertificateFileName.Text));
    aIni.WriteString(cRestFelixIniServerSectionName, cRestFelixIniRootCertificateFileName, Trim(EditRootCertificateFileName.Text));
  finally
    FreeAndNil(aIni);
  end;
end;

end.
