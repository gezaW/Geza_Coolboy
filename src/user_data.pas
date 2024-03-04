unit user_data;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  System.IniFiles, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, ServerIntf,
  Spring.Container, Spring.Services;

type
  TFormUserData = class(TForm)
    RichEditUserData: TRichEdit;
    EditCompayName: TEdit;
    ButtonReports: TButton;
    Label1: TLabel;
    procedure ButtonReportsClick(Sender: TObject);
  private
    { Private-Deklarationen }
    FCheck: IRestChecker;
    procedure UserInfo;
  public
    { Public-Deklarationen }
  end;

var
  FormUserData: TFormUserData;

implementation
{$R *.dfm}

procedure TFormUserData.ButtonReportsClick(Sender: TObject);
begin
 if EditCompayName.Text = '' then
 begin
   ShowMessage('Der Firmenname muss ausgefüllt sein');
 end
 else
 begin
   UserInfo;
 end;
end;

procedure TFormUserData.UserInfo;
var
  AIni: TIniFile;
  ASectionList: TStringList;
  APath, AUserName, AComanyName, APassword, ACompanyId: string;
  i, UserCount: integer;
begin
  try
    UserCount := 0;
    FCheck := Spring.Services.ServiceLocator.GetService<IRestChecker>;
    RichEditUserData.Lines.Clear;

      ASectionList := TStringList.Create;
      APath := 'restFelix_Auth.ini';
      i := 0;
    while (i < 6) and NOT Fileexists(ExpandFileName(ExtractFilePath(ParamStr(0)) + APath)) do
    begin
      APath := '..\' + APath;
      inc(i);
    end;
    AIni := TIniFile.Create(ExpandFileName(ExtractFilePath(ParamStr(0)) + APath));
    AIni.ReadSections(ASectionList);
    for var Item in ASectionList do
    begin
      AUserName := FCheck.DecryptString(Item);
      APassword := FCheck.DecryptString(AIni.ReadString(Item, 'pwd', ''));
      AComanyName := AIni.ReadString(Item, 'FirmenName', '');
      ACompanyId := AIni.ReadString(Item, 'FirmaID', '');
      if EditCompayName.Text = AComanyName then
      begin
        RichEditUserData.Lines.AddPair('Firmenname', AComanyName);
        RichEditUserData.Lines.AddPair('FirmaId', ACompanyId);
        RichEditUserData.Lines.AddPair('User Name', AUserName);
        RichEditUserData.Lines.AddPair('Passwort', APassword);
        RichEditUserData.Lines.Add('------------------------------------------------');
        RichEditUserData.Lines.Add(' ');
        inc(UserCount);
      end;
    end;
    if UserCount = 0 then
    begin
     RichEditUserData.Lines.Add('Für Firma: '+ EditCompayName.Text + ' wurden keine Daten angelegt!');
    end;
  finally
    ASectionList.Free;
  end;
end;

end.
