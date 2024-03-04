unit ColorDialog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TGMSColorDialog = class(TCommonDialog)
  private
    FColor: TColor;
  public
    procedure AfterConstruction; override;
    property Color: TColor read FColor write FColor;
    function Execute: Boolean; override;
  end;

type
  TColorForm = class(TForm)
    ShapeA1: TShape;
    ShapeA2: TShape;
    ShapeA3: TShape;
    ShapeA4: TShape;
    ShapeA5: TShape;
    ShapeA6: TShape;
    ShapeB1: TShape;
    ShapeB2: TShape;
    ShapeB3: TShape;
    ShapeB4: TShape;
    ShapeB5: TShape;
    ShapeB6: TShape;
    ShapeC1: TShape;
    ShapeC2: TShape;
    ShapeC3: TShape;
    ShapeC4: TShape;
    ShapeC5: TShape;
    ShapeC6: TShape;
    ShapeD6: TShape;
    ShapeD5: TShape;
    ShapeD4: TShape;
    ShapeD3: TShape;
    ShapeD2: TShape;
    ShapeD1: TShape;
    ShapeE6: TShape;
    ShapeE5: TShape;
    ShapeE4: TShape;
    ShapeE3: TShape;
    ShapeE2: TShape;
    ShapeE1: TShape;
    Label1: TLabel;
    MoreColorsButton: TButton;
    ColorDialog: TColorDialog;
    OkButton: TButton;
    CancelButton: TButton;
    procedure FormCreate(Sender: TObject);
    procedure ShapeA1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MoreColorsButtonClick(Sender: TObject);
  private
    FSelectedShape: TShape;
    FColor: TColor;
    function GetColor: TColor;
    procedure SetColor(const Value: TColor);
    procedure SelectShape(const pShape: TShape);
    { Private declarations }
  public
    property Color: TColor read GetColor write SetColor;
  end;

function PickColor(var pColor: TColor): Boolean;

implementation

{$R *.dfm}

function PickColor(var pColor: TColor): Boolean;
var
  aCustomColor: TGMSColorDialog;
begin
  Result := False;
  aCustomColor := TGMSColorDialog.Create(Application.MainForm);
  try
    aCustomColor.Color := pColor;
    if aCustomColor.Execute then
    begin
      pColor := aCustomColor.Color;
      Result := True;
    end;
  finally
    FreeAndNil(aCustomColor);
  end;
end;

{ TGMSColorDialog }

procedure TGMSColorDialog.AfterConstruction;
begin
  inherited;
  Color := clBlack;
end;

function TGMSColorDialog.Execute: Boolean;
var
  aForm: TColorForm;
begin
  aForm := TColorForm.Create(Owner);
  try
    aForm.Color := Color;
    Result := (aForm.ShowModal = mrOk);
    Color := aForm.Color;
  finally
    FreeAndNil(aForm);
  end;
end;

{ TColorForm }

procedure TColorForm.FormCreate(Sender: TObject);
begin
  FColor := clBlack;
end;

function TColorForm.GetColor: TColor;
begin
  Result := FColor;
end;

procedure TColorForm.MoreColorsButtonClick(Sender: TObject);
begin
  ColorDialog.Color := FColor;
  if ColorDialog.Execute then
  begin
    FColor := ColorDialog.Color;
    ModalResult := mrOk;
  end;
end;

procedure TColorForm.SelectShape(const pShape: TShape);
begin
  if Assigned(FSelectedShape) then
    FSelectedShape.Pen.Width := 1;
  FSelectedShape := pShape;
  pShape.Pen.Width := 3;
  FColor := pShape.Brush.Color;
end;

procedure TColorForm.SetColor(const Value: TColor);
var
  i: Integer;
begin
  for i := 0 to ControlCount - 1 do
  begin
    if Controls[i] is TShape then
    begin
      if (Controls[i] as TShape).Brush.Color = Value then
      begin
        SelectShape(Controls[i] as TShape);
        break;
      end;
    end;
  end;
  FColor := Value;
end;

procedure TColorForm.ShapeA1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Sender is TShape then
    SelectShape(Sender as TShape);
end;

end.
