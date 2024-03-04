unit SettingsUnit;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes, System.IniFiles,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  ServerIntf, Spring.Container, Spring.Services, Vcl.Menus, Vcl.StdCtrls,
  Vcl.ComCtrls;

type
  TSettingForm = class(TForm)
    EditFirmenName: TEdit;
    EditUserName: TEdit;
    EditPassword: TEdit;
    EditPassword1: TEdit;
    MainMenu: TMainMenu;
    Menu1: TMenuItem;
    UserDatenndern1: TMenuItem;
    LabelFirmenName: TLabel;
    LabelUserName: TLabel;
    LabelPassword: TLabel;
    LabelPasswWiederh: TLabel;
    StatusBar1: TStatusBar;
    Button1: TButton;
    Speichern: TMenuItem;
    EditFirmaID: TEdit;
    Label1: TLabel;

    procedure FormCreate(Sender: TObject);

    procedure EditFirmenNameClick(Sender: TObject);
    procedure SpeichernClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);

  private
    { Private-Deklarationen }
    FChecker: IRestChecker;
    FFormName: string;
    procedure saveAsIni;
    function checkIsPWDTheSame: boolean;
    procedure handleSaveing;
  public
    { Public-Deklarationen }
  end;

var
  SettingForm: TSettingForm;

implementation

{$R *.dfm}


procedure TSettingForm.SpeichernClick(Sender: TObject);
begin
   handleSaveing;
end;

procedure TSettingForm.Button1Click(Sender: TObject);
begin
  handleSaveing;
end;

procedure TSettingForm.EditFirmenNameClick(Sender: TObject);
begin
   StatusBar1.Panels[0].Text := 'Der FirmenName dient dazu um den User zuordnen zu können und ist der SectionName für die Datenbank';
end;

procedure TSettingForm.FormCreate(Sender: TObject);
begin
  FChecker := Spring.Services.ServiceLocator.GetService<IRestChecker>;
  FFormName := 'Settings - UserDaten anlegen';
  SettingForm.Caption := FFormName;
end;

function TSettingForm.checkIsPWDTheSame: boolean;
begin
  if EditPassword.Text = EditPassword1.Text then
    result := TRUE
  else
    result := FALSE;
end;

procedure TSettingForm.handleSaveing;
begin
   if FFormName = 'Settings - UserDaten anlegen' then
  begin
    if (EditUserName.Text   = '')
    or (EditPassword.Text   = '')
    or (EditPassword1.Text  = '')
    or (EditFirmaID.Text  = '')
    or (EditFirmenName.Text = '') then
    begin
      ShowMessage('Es müssen alle Felder ausgefüllt sein');
    end
    else if checkIsPWDTheSame then
    begin
      saveAsIni
    end
    else ShowMessage('Die Passwörter müssen übereinstimmen');
  end;
end;


procedure TSettingForm.saveAsIni;
var
  APath: string;
  i: integer;
  AIniFile: TIniFile;
  aUserName, aPassword: string;
  ASectionList: TStringList;
  aIsInList: boolean;
begin
  try
    try
      APath := 'restFelix_Auth.ini';
      aUserName := FChecker.EncryptString(EditUserName.Text);
      aPassword := FChecker.EncryptString(EditPassword.Text);
      ASectionList := TStringList.Create;
      aIsInList := FALSE;
      i := 0;
      while (i < 6) and NOT Fileexists(ExpandFileName(ExtractFilePath(ParamStr(0)) +
        APath)) do
      begin
        APath := '..\' + APath;
        inc(i);
      end;
      if not Fileexists(ExpandFileName(ExtractFilePath(ParamStr(0)) + APath)) then
      begin
        AIniFile := TIniFile.Create
          (ExpandFileName(ExtractFilePath(Application.ExeName)) +
          '\restFelix_Auth.ini');
      end
      else
      begin
        AIniFile:=  TIniFile.Create(ExpandFileName(ExtractFilePath(ParamStr(0)) + APath));
        AIniFile.ReadSections(ASectionList);
      end;
      for var item in ASectionList do
      begin
         if (FChecker.DecryptString(Item) = EditUserName.Text) then
         begin
           aIsInList := TRUE;
           break;
         end;
      end;
      if aIsInList then
      begin
       MessageDlg('User Name ist schon vergeben' ,mtInformation, [mbOk],0,mbOk);
      end
      else
      begin
        AIniFile.WriteString(aUserName, 'FirmenName', EditFirmenName.Text);
        AIniFile.WriteString(aUserName, 'pwd', aPassword);
        AIniFile.WriteString(aUserName, 'FirmaID', EditFirmaID.Text);
        EditUserName.Text   := '';
        EditPassword.Text   := '';
        EditPassword1.Text  := '';
        EditFirmenName.Text := '';
        EditFirmaID.Text := '';
        StatusBar1.Panels[0].Text := 'Die Daten wurden gespeichert';
      end;
    except on e: Exception do
      begin
        ShowMessage('Fehler beim Speichern der Daten: ' + E.Message);
      end;
    end;
  finally
    ASectionList.Free;
  end;
end;



end.
