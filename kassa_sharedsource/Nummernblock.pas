unit Nummernblock;
//-----------------------------------------------------------------------------
// Software Stylers  - FELIX
//-----------------------------------------------------------------------------
// DATUM DER ERSTELLUNG        : 15-3-99
// ERSTELLER                   : Ulrich HUTTER
// DATUM LETZTER ÄNDERUNG      :
// BEARBEITER LETZTER ÄNDERUNG :
// BESCHREIBUNG DER UNIT:
//   Das drücken der Tasten wird über SendMessage an die jeweiligen
//   Formulare geschickt
//
// ÄNDERUNGEN:
//
//
//-----------------------------------------------------------------------------
// Hutterstraße 72, 5582 St. Michael/i.Lg
//-----------------------------------------------------------------------------


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls,
  Hemibtn,
  IvDictio, IvMulti, BusinessSkinForm,
  Mask, bsSkinBoxCtrls, bsSkinCtrls, RzButton;

type
  TNummernblockTyp = (nbMain, nbMarken, nbKreditTrinkGeld, nbEuro);
  TfmNummernblock = class(TForm)
    PanelMain: TPanel;
    PanelRechts: TPanel;
    PanelLinks: TPanel;
    Panel3: TPanel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel4: TPanel;
    HemisphereButton1: THemisphereButton;
    HemisphereButton2: THemisphereButton;
    HemisphereButton3: THemisphereButton;
    HemisphereButton4: THemisphereButton;
    HemisphereButton5: THemisphereButton;
    HemisphereButton6: THemisphereButton;
    HemisphereButton7: THemisphereButton;
    HemisphereButton8: THemisphereButton;
    HemisphereButton9: THemisphereButton;
    HemisphereButton10: THemisphereButton;
    HemisphereButton11: THemisphereButton;
    HemisphereButton12: THemisphereButton;
    HemisphereButton13: THemisphereButton;
    HemisphereButtonEnter: THemisphereButton;
    Label1: TLabel;
    IvTranslator1: TIvTranslator;
    EditPasswort: TbsSkinPasswordEdit;
    bsBusinessSkinForm1: TbsBusinessSkinForm;
    procedure ButtonNummerClick(Sender: TObject);
    procedure ButtonReturnClick(Sender: TObject);
    procedure ButtonBackClick(Sender: TObject);
    procedure EditPasswortKeyPress(Sender: TObject; var Key: Char);
    procedure HemisphereButton12Click(Sender: TObject);
  private
    FTyp: TNummernblockTyp;
  public
    property Typ: TNummernblockTyp write FTyp;
    { Public-Deklarationen }
  protected
  end;

var
  fmNummernblock: TfmNummernblock;

implementation


{$R *.DFM}
uses DMDesign, DMBase;

//---------------------------------PRIVATE--------------------------------------

//---------------------------------PUBLIC---------------------------------------
//----------------------------------CLASS---------------------------------------

procedure TfmNummernblock.ButtonNummerClick(Sender: TObject);
begin
  SendMessage(EditPasswort.Handle, WM_Char,
    ord((Sender as THemisphereButton).Caption[1]), 0);
end;

procedure TfmNummernblock.ButtonBackClick(Sender: TObject);
begin
  SendMessage(EditPasswort.Handle, WM_Char, VK_Back, 0);
end;

procedure TfmNummernblock.ButtonReturnClick(Sender: TObject);
begin
  SendMessage(EditPasswort.Handle, WM_Char, VK_RETURN, 0);
end;

procedure TfmNummernblock.EditPasswortKeyPress(Sender: TObject;
  var Key: Char);
begin
  If key = #13 Then
  Begin
    if (EditPassWort.Text = DBase.SystemPassword) Then
      ModalResult := mrOK;
  End;
  If key = #27 Then
   ModalResult := mrCancel;
end;

procedure TfmNummernblock.HemisphereButton12Click(Sender: TObject);
begin
  SendMessage(EditPasswort.Handle, WM_Char, VK_ESCAPE, 0);
end;

end.
