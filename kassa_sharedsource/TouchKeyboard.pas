unit TouchKeyboard;
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
  RzButton, Vcl.Touch.Keyboard;

type
  TfmTouchKeyboard = class(TForm)
    ShapeShift: TShape;
    EditTouchText: TEdit;
    IvTranslator1: TIvTranslator;
    Panel1: TPanel;
    Panel2: TPanel;
    Label2: TLabel;
    LabelAktuelleEingabe: TLabel;
    TouchKeyboard1: TTouchKeyboard;
    procedure LabelLeertasteClick(Sender: TObject);
    procedure LabelBackSpaceClick(Sender: TObject);
    procedure LabelTabulatorClick(Sender: TObject);
    procedure LabelShiftClick(Sender: TObject);
    procedure LabelESCClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure LabelClick(Sender: TObject);
    procedure LabelReturnAltClick(Sender: TObject);
    procedure LabelLeftClick(Sender: TObject);
    procedure LabelRightClick(Sender: TObject);
    procedure LabelEndClick(Sender: TObject);
    procedure LabelPos1Click(Sender: TObject);
    procedure LabelCapsClick(Sender: TObject);
    procedure EditTouchTextKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure BitBtnOkClick(Sender: TObject);
    procedure KeyButton65Click(Sender: TObject);
    procedure KeyButton61Click(Sender: TObject);
    procedure KeyButton62Click(Sender: TObject);
  private
    { Private-Deklarationen }
    CapsGedruckt: boolean;
    // ist caps-taste gedrückt..Großschreibung und umgekehrt
    ShiftGedruckt: boolean; // wurde die shift-taste vorher gedrückt
    AltGrGedruckt: boolean;
  public
    function UseTouchKeyboard(pLabelCaption: string; var pEditTouchText: string;
      pTop: Integer): boolean;
  end;

var
  aKeyArray: Array [1 .. 65, 1 .. 2] of String;
  fmTouchKeyboard: TfmTouchKeyboard;

implementation

// uses Global;//, SendText, Arbeitszeit, DatenanlageTasten, utilities;
{$R *.DFM}

// TouchKeyboard öffnen, Text schreiben, schließen und
// geschriebenen Text übergeben
function TfmTouchKeyboard.UseTouchKeyboard(pLabelCaption: string;
  var pEditTouchText: string; pTop: Integer): boolean;
begin
  Result := FALSE;
  try
    EditTouchText.Text := pEditTouchText;
    LabelAktuelleEingabe.Caption := pLabelCaption;
    Top := pTop + 10;

    ShowModal;
    if ModalResult = mrOK then
    begin
      pEditTouchText := EditTouchText.Text;
      Result := TRUE;
    end
    else
    begin
      pEditTouchText := '';
      Result := FALSE;
    end;
  except
    on E: Exception do
      Showmessage(Format(Translate('Problem mit Touch-Keyboard! [%s]'),
        [E.Message]));
  end;
end;

// Abschluß mittels Return-Taste
procedure TfmTouchKeyboard.LabelReturnAltClick(Sender: TObject);
begin
end;

// Gesmates Display löschen
procedure TfmTouchKeyboard.FormShow(Sender: TObject);
begin
end;

// BackSpace
procedure TfmTouchKeyboard.LabelBackSpaceClick(Sender: TObject);

begin
end;

// Cursor nach links
procedure TfmTouchKeyboard.LabelLeftClick(Sender: TObject);
begin
  EditTouchText.SelStart := EditTouchText.SelStart - 1;
end;

// Cursor nach rechts
procedure TfmTouchKeyboard.LabelRightClick(Sender: TObject);
begin
  EditTouchText.SelStart := EditTouchText.SelStart + 1;
end;

// Cursor an StringEnde
procedure TfmTouchKeyboard.LabelEndClick(Sender: TObject);
begin
  EditTouchText.SelStart := Length(EditTouchText.Text);
end;

// Cursor an Stringanfang
procedure TfmTouchKeyboard.LabelPos1Click(Sender: TObject);
begin
  EditTouchText.SelStart := 0;
end;

(* ******************** einzelne Tastenzuweisungen *************************** *)
procedure TfmTouchKeyboard.LabelShiftClick(Sender: TObject);
begin
  { ShiftGedruckt := Not ShiftGedruckt;

    KeyButton51.Pressed := ShiftGedruckt;
    KeyButton54.Pressed := ShiftGedruckt; }
end;

procedure TfmTouchKeyboard.LabelLeertasteClick(Sender: TObject);
begin
  EditTouchText.SelText := ' ';
end;

procedure TfmTouchKeyboard.LabelTabulatorClick(Sender: TObject);
begin
  EditTouchText.SelText := #9;
end;

procedure TfmTouchKeyboard.LabelESCClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfmTouchKeyboard.LabelClick(Sender: TObject);
var
  aKey: String;
begin
  { if (AnsiUppercase((Sender as TKeyButton).Caption) <>
    AnsiUppercase((Sender as TKeyButton).Caption2)) then
    begin
    if CapsGedruckt <> Shiftgedruckt then
    aKey := (Sender as TKeyButton).Caption2
    else
    aKey := (Sender as TKeyButton).Caption;
    end
    else
    begin
    if CapsGedruckt <> Shiftgedruckt then
    aKey := (Sender as TKeyButton).Caption
    else
    aKey := (Sender as TKeyButton).Caption2;
    end; }

  { if aKey = '^' then
    aOldKey := aKey
    else
    begin
    if aOldKey <> '' then
    begin
    if aKey = 'A' then aKey := 'Â';
    if aKey = 'E' then aKey := 'Ê';
    if aKey = 'O' then aKey := 'Ô';
    if aKey = 'U' then aKey := 'Û';
    if aKey = 'I' then aKey := 'Î';
    if aKey = 'a' then aKey := 'â';
    if aKey = 'e' then aKey := 'ê';
    if aKey = 'o' then aKey := 'ô';
    if aKey = 'u' then aKey := 'û';
    if aKey = 'i' then aKey := 'î';
    end; }

  { if akey = '&&' then
    aKey := '&';

    EditTouchText.SelText := aKey; }
  { aOldKey := '';
    end; }

  { ShiftGedruckt := FALSE;
    KeyButton51.Pressed := ShiftGedruckt;
    KeyButton54.Pressed := ShiftGedruckt;

    if AltGrGedruckt then
    KeyButton65Click(Sender); }
end;

procedure TfmTouchKeyboard.LabelCapsClick(Sender: TObject);
begin
  { //Rotes Licht aktivieren bzw. deaktivieren
    if ShapeShift.Brush.Color = clMenu then ShapeShift.Brush.Color := clRed
    else ShapeShift.Brush.Color := clMenu;
    CapsGedruckt := not CapsGedruckt; //jeweilige Umkehrung des Zustandes

    KeyButton43.Pressed := CapsGedruckt; }
end;

procedure TfmTouchKeyboard.EditTouchTextKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
    BitBtnOkClick(Sender);
  if Key = #27 then
    LabelESCClick(Sender);

end;

procedure TfmTouchKeyboard.FormCreate(Sender: TObject);
begin
  // ScreenScale(self);

  // Zuweisung der Caption2 - wegen Multilizer-Übersetzung
  { KeyButton1.Caption2 := Translate('!');
    KeyButton2.Caption2 := Translate('@');
    KeyButton3.Caption2 := Translate('#');
    KeyButton4.Caption2 := Translate('$');
    KeyButton5.Caption2 := Translate('%');
    KeyButton6.Caption2 := Translate('^');
    KeyButton7.Caption2 := Translate('&');
    KeyButton8.Caption2 := Translate('*');
    KeyButton9.Caption2 := Translate('(');
    KeyButton10.Caption2 := Translate(')');
    KeyButton11.Caption2 := Translate('{');
    KeyButton13.Caption2 := Translate(' }         { ');
    KeyButton14.Caption2 := Translate('"');
    KeyButton15.Caption2 := Translate('?');
    KeyButton16.Caption2 := Translate('ß');
    KeyButton17.Caption2 := Translate('r');
    KeyButton18.Caption2 := Translate('z');
    KeyButton19.Caption2 := Translate('t');
    KeyButton20.Caption2 := Translate('e');
    KeyButton21.Caption2 := Translate('w');
    KeyButton22.Caption2 := Translate('q');
    KeyButton24.Caption2 := Translate('u');
    KeyButton25.Caption2 := Translate('i');
    KeyButton26.Caption2 := Translate('o');
    KeyButton27.Caption2 := Translate('p');
    KeyButton28.Caption2 := Translate('ü');
    KeyButton29.Caption2 := Translate('+');
    KeyButton31.Caption2 := Translate('a');
    KeyButton32.Caption2 := Translate('s');
    KeyButton33.Caption2 := Translate('d');
    KeyButton34.Caption2 := Translate('f');
    KeyButton35.Caption2 := Translate('g');
    KeyButton36.Caption2 := Translate('h');
    KeyButton37.Caption2 := Translate('j');
    KeyButton38.Caption2 := Translate('k');
    KeyButton39.Caption2 := Translate('l');
    KeyButton40.Caption2 := Translate('ö');
    KeyButton41.Caption2 := Translate('ä');
    KeyButton44.Caption2 := Translate('y');
    KeyButton45.Caption2 := Translate('x');
    KeyButton46.Caption2 := Translate('c');
    KeyButton47.Caption2 := Translate('v');
    KeyButton48.Caption2 := Translate('b');
    KeyButton49.Caption2 := Translate('n');
    KeyButton50.Caption2 := Translate('m');
    KeyButton52.Caption2 := Translate('<');
    KeyButton53.Caption2 := Translate('>');
    KeyButton55.Caption2 := Translate(':');
    KeyButton56.Caption2 := Translate('_');
    KeyButton57.Caption2 := Translate('|'); }

  // Zuweisung der Caption3 (Alt Gr) - wegen Multilizer-Übersetzung
  // DARF NICHT DIREKT IN DIE CAPTION3-EIGENSCHAFT GESCHRIEBEN WERDEN
  // WEGEN ABFRAGE AUF AltGr
  { KeyButton1.Caption3 := Translate('AltGr_!');
    KeyButton2.Caption3 := Translate('²');
    KeyButton3.Caption3 := Translate('³');
    KeyButton4.Caption3 := Translate('AltGr_$');
    KeyButton5.Caption3 := Translate('¼');
    KeyButton6.Caption3 := Translate('½');
    KeyButton7.Caption3 := Translate('¾');
    KeyButton8.Caption3 := Translate('AltGr_*');
    KeyButton9.Caption3 := Translate('AltGr_(');
    KeyButton10.Caption3 := Translate('AltGr_)'); }
  // KeyButton11.Caption3 := Translate('AltGr_{');
  // KeyButton13.Caption3 := Translate('AltGr_}');
  { KeyButton14.Caption3 := Translate('AltGr_"');
    KeyButton15.Caption3 := Translate('AltGr_?');
    KeyButton16.Caption3 := Translate('\');
    KeyButton17.Caption3 := Translate('®');
    KeyButton18.Caption3 := Translate('AltGr_z');
    KeyButton19.Caption3 := Translate('AltGr_t');
    KeyButton20.Caption3 := Translate('€');
    KeyButton21.Caption3 := Translate('AltGr_w');
    KeyButton22.Caption3 := Translate('AltGr_q');
    KeyButton24.Caption3 := Translate('AltGr_u');
    KeyButton25.Caption3 := Translate('AltGr_i');
    KeyButton26.Caption3 := Translate('AltGr_o');
    KeyButton27.Caption3 := Translate('AltGr_p');
    KeyButton28.Caption3 := Translate('AltGr_ü');
    KeyButton29.Caption3 := Translate('~');
    KeyButton31.Caption3 := Translate('AltGr_a');
    KeyButton32.Caption3 := Translate('AltGr_s');
    KeyButton33.Caption3 := Translate('AltGr_d');
    KeyButton34.Caption3 := Translate('AltGr_f');
    KeyButton35.Caption3 := Translate('AltGr_g');
    KeyButton36.Caption3 := Translate('AltGr_h');
    KeyButton37.Caption3 := Translate('AltGr_j');
    KeyButton38.Caption3 := Translate('AltGr_k');
    KeyButton39.Caption3 := Translate('AltGr_l');
    KeyButton40.Caption3 := Translate('AltGr_ö');
    KeyButton41.Caption3 := Translate('AltGr_ä');
    KeyButton44.Caption3 := Translate('AltGr_y');
    KeyButton45.Caption3 := Translate('AltGr_x');
    KeyButton46.Caption3 := Translate('©');
    KeyButton47.Caption3 := Translate('AltGr_v');
    KeyButton48.Caption3 := Translate('AltGr_b');
    KeyButton49.Caption3 := Translate('AltGr_n');
    KeyButton50.Caption3 := Translate('µ');
    KeyButton52.Caption3 := Translate('AltGr_<');
    KeyButton53.Caption3 := Translate('AltGr_>');
    KeyButton55.Caption3 := Translate('AltGr_:');
    KeyButton56.Caption3 := Translate('AltGr__');
    KeyButton57.Caption3 := Translate('AltGr_|'); }
end;

procedure TfmTouchKeyboard.BitBtnOkClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TfmTouchKeyboard.KeyButton65Click(Sender: TObject);
var
  aKey: TComponent;
  i: Integer;
begin
  { AltGrGedruckt := not AltGrGedruckt;
    KeyButton65.Pressed := AltGrGedruckt;

    If AltGrGedruckt then
    begin
    for i := 1 to 65 do
    begin
    aKey := findComponent('KeyButton' + IntToStr(i));

    if ((aKey as TKeyButton).Caption2 <> '') then
    begin
    aKeyArray[i, 1] := (aKey as TKeyButton).Caption;
    aKeyArray[i, 2] := (aKey as TKeyButton).Caption2;

    if (Pos('AltGr_', Translate((aKey as TKeyButton).Caption3)) > 0) then
    begin
    (aKey as TKeyButton).Caption := '';
    (aKey as TKeyButton).Caption2 := '';
    end
    else
    begin
    (aKey as TKeyButton).Caption := (aKey as TKeyButton).Caption3;
    (aKey as TKeyButton).Caption2 := (aKey as TKeyButton).Caption;
    end
    end
    end
    end
    else
    begin
    for i := 1 to 65 do
    begin
    aKey := findComponent('KeyButton' + IntToStr(i));

    if aKeyArray[i, 1] <> '' then
    begin
    (aKey as TKeyButton).Caption := aKeyArray[i, 1];
    (aKey as TKeyButton).Caption2 := aKeyArray[i, 2];
    end
    end
    end; }
end;

procedure TfmTouchKeyboard.KeyButton61Click(Sender: TObject);
// var AZeile : Integer;
begin
  // If (fmSendText <> nil) And (fmSendText.Visible) Then
  // begin
  // //Eine Zeile nach oben im Memofeld und Text ausgeben
  // with fmSendText.MemoNachricht do
  // begin
  // //aktuelle Zeile herausfinden
  // AZeile := SendMessage(Handle, EM_LINEFROMCHAR, SelStart, 0);
  // //Text der oberen Zeile ausgeben
  // if AZeile > 0 then //damit Cursor-Anfang nicht unterschritten wird (-1)
  // EditTouchText.Text := Lines[AZeile-1];
  // //Cursor im Memofeld setzen
  // SelStart := SendMessage(Handle, EM_LINEINDEX, AZeile-1, 0);
  // end;
  // end else If (fmArbeitszeit <> nil) And (fmArbeitszeit.Visible) Then
  // begin
  // //Eine Zeile nach oben im Memofeld und Text ausgeben
  // with fmArbeitszeit.MemoBemerkung do
  // begin
  // //aktuelle Zeile herausfinden
  // AZeile := SendMessage(Handle, EM_LINEFROMCHAR, SelStart, 0);
  // //Text der oberen Zeile ausgeben
  // if AZeile > 0 then //damit Cursor-Anfang nicht unterschritten wird (-1)
  // EditTouchText.Text := Lines[AZeile-1];
  // //Cursor im Memofeld setzen
  // SelStart := SendMessage(Handle, EM_LINEINDEX, AZeile-1, 0);
  // end;
  // end else if gl.Datenanlage and fmAnlageTasten.Panelmain.Visible then
  // begin
  // //Eine Zeile nach oben im Memofeld und Text ausgeben
  // with fmAnlageTasten.MemoText do
  // begin
  // //aktuelle Zeile herausfinden
  // AZeile := SendMessage(Handle, EM_LINEFROMCHAR, SelStart, 0);
  // //Text der oberen Zeile ausgeben
  // if AZeile > 0 then //damit Cursor-Anfang nicht unterschritten wird (-1)
  // EditTouchText.Text := Lines[AZeile-1];
  // //Cursor im Memofeld setzen
  // SelStart := SendMessage(Handle, EM_LINEINDEX, AZeile-1, 0);
  // end;
  // end;
end;

procedure TfmTouchKeyboard.KeyButton62Click(Sender: TObject);
// var AZeile : Integer;
begin
  // If (fmSendText <> nil) And (fmSendText.Visible) Then
  // begin
  // //Eine Zeile nach unten im Memofeld und Text ausgeben
  // with fmSendText.MemoNachricht do
  // begin
  // //aktuelle Zeile herausfinden
  // AZeile := SendMessage(Handle, EM_LINEFROMCHAR, SelStart, 0);
  // //Text der darunter liegenden Zeile ausgeben
  // EditTouchText.Text := Lines[AZeile + 1];
  // //Cursor im Memofeld setzen
  // SelStart := SendMessage(Handle, EM_LINEINDEX, AZeile+1, 0);
  // end;
  // end else If (fmArbeitszeit <> nil) And (fmArbeitszeit.Visible) Then
  // begin
  // //Eine Zeile nach unten im Memofeld und Text ausgeben
  // with fmArbeitszeit.MemoBemerkung do
  // begin
  // //aktuelle Zeile herausfinden
  // AZeile := SendMessage(Handle, EM_LINEFROMCHAR, SelStart, 0);
  // //Text der darunter liegenden Zeile ausgeben
  // EditTouchText.Text := Lines[AZeile + 1];
  // //Cursor im Memofeld setzen
  // SelStart := SendMessage(Handle, EM_LINEINDEX, AZeile+1, 0);
  // end;
  // end else if gl.Datenanlage and fmAnlageTasten.Panelmain.Visible then
  // begin
  // //Eine Zeile nach oben im Memofeld und Text ausgeben
  // with fmAnlageTasten.MemoText do
  // begin
  // //aktuelle Zeile herausfinden
  // AZeile := SendMessage(Handle, EM_LINEFROMCHAR, SelStart, 0);
  // //Text der darunter liegenden Zeile ausgeben
  // EditTouchText.Text := Lines[AZeile + 1];
  // //Cursor im Memofeld setzen
  // SelStart := SendMessage(Handle, EM_LINEINDEX, AZeile+1, 0);
  // end;
  // end;
end;

end.
