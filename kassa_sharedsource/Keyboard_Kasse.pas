unit Keyboard_Kasse;
(* ---------------------------------------------------------------------------
 Software Stylers  - GMS Touch 2003
  ----------------------------------------------------------------------------
  DATUM DER ERSTELLUNG       :
  ERSTELLER                  : Ulrich HUTTER
  BESCHREIBUNG DER UNIT      : Keyboard für den Bildschirm

   TABELLEN:

   ÄNDERUNGEN:

  -----------------------------------------------------------------------------
  Katschberg 423, 5582 St. Michael/i.Lg
 -----------------------------------------------------------------------------
 *)

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Mask, ComCtrls, IvDictio, IvMulti, IvAMulti, IvBinDic,
  RzButton, RzTabs, Vcl.Touch.Keyboard, Vcl.Touch.KeyboardTypes;


type
  TfmKeyboard_Kasse = class(TForm)
    ShapeShift: TShape;
    EditTouchText: TEdit;
    IvTranslator1: TIvTranslator;
    Panel1: TPanel;
    Panel2: TPanel;
    Label2: TLabel;
    LabelAktuelleEingabe: TLabel;
    TouchKeyboard1: TTouchKeyboard;
    Panel3: TPanel;
    procedure LabelLeertasteClick(Sender: TObject);
    procedure LabelBackSpaceClick(Sender: TObject);
    procedure LabelTabulatorClick(Sender: TObject);
    procedure LabelShiftClick(Sender: TObject);
    procedure LabelESCClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure LabelReturnAltClick(Sender: TObject);
    procedure LabelDeleteAllClick(Sender: TObject);
    procedure LabelLeftClick(Sender: TObject);
    procedure LabelRightClick(Sender: TObject);
    procedure LabelEndClick(Sender: TObject);
    procedure LabelPos1Click(Sender: TObject);
    procedure LabelCapsClick(Sender: TObject);
    procedure BitBtnOkClick(Sender: TObject);
    procedure EditTouchTextKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private-Deklarationen }
    CapsGedruckt : boolean; //ist caps-taste gedrückt..Großschreibung und umgekehrt
    ShiftGedruckt : boolean; //wurde die shift-taste vorher gedrückt
    AltGrGedruckt : Boolean;
  public
    function UseTouchKeyboard(pLabelCaption: string; var pEditTouchText: string;
      pTop: Integer; pLayout: TKeyboardLayout = 'Standard'):Boolean;
  end;

var
  aKeyArray: Array[1..65, 1..2] of String;
  fmKeyboard_Kasse: TfmKeyboard_Kasse;

implementation

uses dmbase;
{$R *.DFM}

//TouchKeyboard öffnen, Text schreiben, schließen und
//geschriebenen Text übergeben
function TfmKeyboard_Kasse.UseTouchKeyboard(pLabelCaption: string; var pEditTouchText: string;
  pTop: Integer; pLayout: TKeyboardLayout = 'Standard'):Boolean;
var
  aResult: integer;
  s: string;
begin
  s := lowercase(pLayout);
  if s = 'password' then
  begin
    EditTouchText.PasswordChar := '*';
    if strtointdef(DBase.SystemPassword, -1) <> -1 then
      TouchKeyboard1.layout := 'NumPad'
    else
      TouchKeyboard1.layout := 'Standard';
  end
  else if s = 'date' then
  begin
    EditTouchText.PasswordChar := #0;
    TouchKeyboard1.layout := 'NumPad';
  end
  else
  begin
    EditTouchText.PasswordChar := #0;
    TouchKeyboard1.layout := pLayout;
  end;

  LabelAktuelleEingabe.Caption := pLabelCaption;
  EditTouchText.Text := pEditTouchText;

  if lowercase(TouchKeyboard1.layout) = 'numpad' then
    Width := 320
  else
    Width := 780;

  Top := pTop + 10;
  Left := Trunc(Screen.Width / 2 - Width / 2);

  dbase.ApplicationProcessMessages;

  aResult := ShowModal;

  if s = 'password' then
  begin
    pEditTouchText := '';
    Result := (aResult = mrOK) and (trim(EditTouchText.Text) = DBase.SystemPassword);
  end
  else if s = 'date' then
  begin
    if (aResult = mrOK) then
    begin
      s := EditTouchText.Text;
      case Length(s) of
        0: s := FormatDateTime('dd.mm.yyyy', now);
        2: if StrToIntDef(s, -1) <> -1 then
          s := Format('%s.%s', [s, FormatDateTime('mm.yyyy', now)]);
        4: if StrToIntDef(s, -1) <> -1 then
          s := Format('%s.%s.%s', [Copy(s,1,2), Copy(s,3,2), FormatDateTime('yyyy', now)]);
        6: if StrToIntDef(s, -1) <> -1 then
          s := Format('%s.%s.%s%s', [Copy(s,1,2), Copy(s,3,2), Copy(FormatDateTime('yyyy', now),1,2), copy(s,5,2)]);
        8: if StrToIntDef(s, -1) <> -1 then
          s := Format('%s.%s.%s', [Copy(s,1,2), Copy(s,3,2), Copy(s,5,4)]);
        10: s := StringReplace(s, ',', '.', [rfReplaceAll]);
      end;

      pEditTouchText := DateToStr(StrToDateDef(s, now));
    end
    else
      pEditTouchText := '';
    Result := (aResult = mrOK);
  end
  else
  begin
    if (aResult = mrOK) then
      pEditTouchText := EditTouchText.Text
    else
      pEditTouchText := '';
    Result := (aResult = mrOK);
  end;
end;


//Abschluß mittels Return-Taste
procedure TfmKeyboard_Kasse.LabelReturnAltClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;

//Gesmates Display löschen
procedure TfmKeyboard_Kasse.LabelDeleteAllClick(Sender: TObject);
begin
  if MessageDlg(Translate('Gesamtes Display löschen?'), mtConfirmation, [mbYes, mbNo], 0)=
    mrYes then EditTouchText.Clear;
end;


procedure TfmKeyboard_Kasse.FormShow(Sender: TObject);
begin
  ShapeShift.Brush.Color := clMenu;
  CapsGedruckt := FALSE; //Kleinschreibung = default
  ShiftGedruckt := FALSE; //kein shift vorher gedrückt = default
  EditTouchText.SelStart := length(EditTouchText.Text);
  EditTouchText.SelLength := 0;
end;


//BackSpace
procedure TfmKeyboard_Kasse.LabelBackSpaceClick(Sender: TObject);
var AHilfString : string;
    APosition : integer;
begin
  AHilfString := EditTouchText.Text;
  APosition := EditTouchText.SelStart;
  Delete(AHilfString, EditTouchText.SelStart, 1);
  EditTouchText.Text := AHilfString;
  EditTouchText.SelStart := APosition-1;
end;

//Cursor nach links
procedure TfmKeyboard_Kasse.LabelLeftClick(Sender: TObject);
begin
  EditTouchText.SelStart := EditTouchText.SelStart - 1;
end;

//Cursor nach rechts
procedure TfmKeyboard_Kasse.LabelRightClick(Sender: TObject);
begin
  EditTouchText.SelStart := EditTouchText.SelStart + 1;
end;

//Cursor an StringEnde
procedure TfmKeyboard_Kasse.LabelEndClick(Sender: TObject);
begin
  EditTouchText.SelStart := Length(EditTouchText.Text);
end;

//Cursor an Stringanfang
procedure TfmKeyboard_Kasse.LabelPos1Click(Sender: TObject);
begin
  EditTouchText.SelStart := 0;
end;

(********************* einzelne Tastenzuweisungen ****************************)
procedure TfmKeyboard_Kasse.LabelShiftClick(Sender: TObject);
begin
  ShiftGedruckt := Not ShiftGedruckt;
end;

procedure TfmKeyboard_Kasse.LabelLeertasteClick(Sender: TObject);
begin
  EditTouchText.SelText := ' ';
end;

procedure TfmKeyboard_Kasse.LabelTabulatorClick(Sender: TObject);
begin
   EditTouchText.SelText := #9;
end;

procedure TfmKeyboard_Kasse.LabelESCClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfmKeyboard_Kasse.LabelCapsClick(Sender: TObject);
begin
  //Rotes Licht aktivieren bzw. deaktivieren
  if ShapeShift.Brush.Color = clMenu then ShapeShift.Brush.Color := clRed
                                     else ShapeShift.Brush.Color := clMenu;
  CapsGedruckt := not CapsGedruckt; //jeweilige Umkehrung des Zustandes
end;


procedure TfmKeyboard_Kasse.EditTouchTextKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key  of
    13: BitBtnOkClick(Sender);
    27: LabelESCClick(Sender);
  end;
end;

procedure TfmKeyboard_Kasse.BitBtnOkClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;

end.
