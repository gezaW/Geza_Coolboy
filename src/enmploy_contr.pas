unit enmploy_contr;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls;

type
  Temployee_control = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    EditEmployeeName: TEdit;
    EditPassword: TEdit;
    ButtonCheck: TButton;
    StatusBar1: TStatusBar;
    procedure ButtonCheckClick(Sender: TObject);
    procedure EditPasswordKeyPress(Sender: TObject; var Key: Char);
  private
    { Private-Deklarationen }

  public
    { Public-Deklarationen }
  end;

var
  employee_control: Temployee_control;

implementation
{$R *.dfm}

procedure Temployee_control.ButtonCheckClick(Sender: TObject);
begin
   if (EditEmployeeName.Text = '')
   or (EditPassword.Text = '') then
   begin
     StatusBar1.Panels[0].Text := 'Es müssen beide Felder ausgefüllt werden'
   end
   else
   begin
     if (EditEmployeeName.Text = 'admin') and
        (EditPassword.Text = '+9874123') then
     begin
        ModalResult := 1337;
     end
     else
     begin
      ShowMessage('Sie haben keinen Zugriff');
     end;

   end;

end;


procedure Temployee_control.EditPasswordKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #0 then
    ButtonCheck.Click;
end;

end.
