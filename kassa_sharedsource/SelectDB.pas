unit SelectDB;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DMBase;

type
  TfrmSelectDB = class(TForm)
    ComboBoxDB: TComboBox;
    ButtonOK: TButton;
    Label1: TLabel;
    procedure ButtonOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  FrmSelectDB: TfrmSelectDB;

implementation

{$R *.dfm}

// ******************************************************************************
// Beenden der Anwendung - OK
// ******************************************************************************
procedure TfrmSelectDB.ButtonOKClick(Sender: TObject);
begin
  DBase.SectionName := ComboBoxDB.Items[ComboBoxDB.ItemIndex];
  ModalResult := MrOK;
end;

// ******************************************************************************
// Beenden der Anwendung - FormClose
// ******************************************************************************
procedure TfrmSelectDB.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  DMBase.DBase.SectionName := ComboBoxDB.Items[ComboBoxDB.ItemIndex];
end;

// ******************************************************************************
// Ersten Eintrag in der Combobox anzeigen
// ******************************************************************************
procedure TfrmSelectDB.FormShow(Sender: TObject);
begin
  ComboBoxDB.ItemIndex := 0;
end;

end.
