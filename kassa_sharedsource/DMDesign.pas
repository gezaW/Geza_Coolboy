unit DMDesign;
// Hier wir das Design grundsätzlich definiert
// Die Compressed Skin Komponenten dienen dazu, 
// dass man einfach mehrere SkinData Komponenten verwenden kann

interface

uses
  SysUtils, Classes, BsSkinData, BsMessages, Dialogs, BsDialogs, Graphics, StdCtrls;

type
  TDlgResult = (drNone, drOK, drCancel, drAbort, drRetry, drIgnore,
    drYes, drNo, drAll, drNoToAll, drYesToAll, drHelp);

type
  TDataDesign = class(TDataModule)
    SkinDataOrange: TbsSkinData;
    SkinDataBlau: TbsSkinData;
    SkinDataGrau: TbsSkinData;
    BsSkinMessage: TbsSkinMessage;
    BsResourceStrData: TbsResourceStrData;
    BsCompressedStoredSkinOrange: TbsCompressedStoredSkin;
    BsCompressedStoredSkinBlau: TbsCompressedStoredSkin;
    BsCompressedStoredSkinGrau: TbsCompressedStoredSkin;
    BsSkinInputDialog: TbsSkinInputDialog;
  private
    FLoadDesign: Boolean;
    FLastColor: TColor;
    FLastFontColor: TColor;

    procedure SetLoadDesign(const PValue: Boolean);
    { Private-Deklarationen }
  public
    // Dient als Ersatz für ShowMessage
    procedure ShowMessageSkin(const Msg: string);
    function ShowMessageDlgSkin(const Msg: string; DlgType: TMsgDlgType;
      Buttons: TMsgDlgButtons; HelpCtx: Longint): Word;
    function ShowMessageDlgSkin2(const Msg, Caption: string;
      DlgType: TMsgDlgType; Buttons: TMsgDlgButtons; HelpCtx: Longint): Word;

    function ShowMessageInput(PCaption, PPrompt: string;
      var PValue: string): Boolean;

    procedure ComponentExit(pComponent: TObject);
    procedure ComponentEnter(pComponent: TObject);

    property LoadDesign: Boolean read FLoadDesign write SetLoadDesign;
  end;

var
  DataDesign: TDataDesign;

implementation

{$R *.dfm}

uses Forms, DMBase, TypInfo;

// ******************************************************************************
//
// ******************************************************************************
function TDataDesign.ShowMessageInput(PCaption, PPrompt: string;
  var PValue: string): Boolean;
begin
  Result := BsSkinInputDialog.InputQuery(PCaption, PPrompt, PValue)
end;

// ******************************************************************************
//
// ******************************************************************************
procedure TDataDesign.ShowMessageSkin(const Msg: string);
begin
  ShowMessageDlgSkin(Msg, MtConfirmation, [MbOK], 0);
end;

// ******************************************************************************
//
// ******************************************************************************
function TDataDesign.ShowMessageDlgSkin(const Msg: string; DlgType: TMsgDlgType;
  Buttons: TMsgDlgButtons; HelpCtx: Longint): Word;
begin
  Result := BsSkinMessage.MessageDlg(Msg, DlgType, Buttons, HelpCtx);
  if DBase.DebugModus > 1 then
    DBase.WriteToLog(
      StringReplace(Msg,sLineBreak, ' ', [rfReplaceAll]) +
      ' [DlgButton_'+copy(getenumname(Typeinfo(TDlgResult), result), 3)+']',
      FALSE);
end;

// ******************************************************************************
//
// ******************************************************************************
function TDataDesign.ShowMessageDlgSkin2(const Msg, Caption: string;
  DlgType: TMsgDlgType; Buttons: TMsgDlgButtons; HelpCtx: Longint): Word;
begin
  Result := BsSkinMessage.MessageDlg2(Msg, Caption, DlgType, Buttons, HelpCtx);
  if DBase.DebugModus > 1 then
    DBase.WriteToLog(
      StringReplace(Msg,sLineBreak, ' ', [rfReplaceAll]) +
      ' [DlgButton_'+copy(getenumname(Typeinfo(TDlgResult), result), 3)+']',
      FALSE);
end;

// ******************************************************************************
// Design aus den Skins laden
// ******************************************************************************
procedure TDataDesign.ComponentEnter(pComponent: TObject);
begin
  if pComponent is TEdit then
  begin
    FLastColor := TEdit(pComponent).Color;
    FLastFontColor := TEdit(pComponent).Font.Color;
    TEdit(pComponent).Color := clWhite;
    TEdit(pComponent).font.Color := clNavy;
//    createcaret(TEdit(pComponent).Handle,0,5,16);
//    showcaret(TEdit(pComponent).Handle);
  end;
end;

procedure TDataDesign.ComponentExit(pComponent: TObject);
begin
  if pComponent is TEdit then
  begin
    TEdit(pComponent).Color := FLastColor;
    TEdit(pComponent).Font.Color := FLastFontColor;
  end;
end;

procedure TDataDesign.SetLoadDesign(const PValue: Boolean);
var
  APfad, AAppPfad: string;
  I: Integer;
begin
  FLoadDesign := PValue;
  if PValue then
  begin
    // passendes Verzeichnis für Skin suchen
    AAppPfad := ExtractFileDir(Application.ExeName);
    APfad := AAppPfad + '\Skins\';
    if DBase.DAS then
    begin
      if not Fileexists(APfad + 'DAS.skn') then
      begin
        APfad := AAppPfad + '\..\Skins\';
        if not Fileexists(APfad + 'DAS.skn') then
        begin
          APfad := AAppPfad + '\..\..\Skins\';
          if not Fileexists(APfad + 'DAS.skn') then
            APfad := AAppPfad + '\..\..\..\Skins\';
        end
      end;
      if Fileexists(APfad + 'DAS.skn') then
      begin
        BsCompressedStoredSkinOrange.LoadFromCompressFile(APfad + 'DAS.skn');
        // Dieses Load muss noch extra aufgerufen werden, da sonst die Skinkomponenten
        // in dem Datamodul nicht funktionieren
        SkinDataOrange.LoadCompressedStoredSkin(BsCompressedStoredSkinOrange);
        SkinDataBlau.LoadCompressedStoredSkin(BsCompressedStoredSkinOrange);
        SkinDataGrau.LoadCompressedStoredSkin(BsCompressedStoredSkinOrange);
      end;
    end
    else
    begin
      if not Fileexists(APfad + 'GMS_Orange.skn') then
      begin
        APfad := AAppPfad + '\..\Skins\';
        if not Fileexists(APfad + 'GMS_Orange.skn') then
        begin
          APfad := AAppPfad + '\..\..\Skins\';
          if not Fileexists(APfad + 'GMS_Orange.skn') then
            APfad := AAppPfad + '\..\..\..\Skins\';
        end
      end;

      I := 0;
      repeat
        try
          if Fileexists(APfad + 'GMS_Orange.skn') then
            BsCompressedStoredSkinOrange.LoadFromCompressFile
              (APfad + 'GMS_Orange.skn')
          else if Fileexists(APfad + 'GMS_Orange.ini') then
            BsCompressedStoredSkinOrange.LoadFromIniFile
              (APfad + 'GMS_Orange.ini');

          if Fileexists(APfad + 'GMS_Blau.skn') then
            BsCompressedStoredSkinBlau.LoadFromCompressFile
              (APfad + 'GMS_Blau.skn')
          else if Fileexists(APfad + 'GMS_Blau.ini') then
            BsCompressedStoredSkinBlau.LoadFromIniFile(APfad + 'GMS_Blau.ini');

          if Fileexists(APfad + 'GMS_Grau.skn') then
            BsCompressedStoredSkinGrau.LoadFromCompressFile
              (APfad + 'GMS_Grau.skn')
          else if Fileexists(APfad + 'GMS_Grau.ini') then
            BsCompressedStoredSkinGrau.LoadFromIniFile(APfad + 'GMS_Grau.ini');

          I := 0;
        except
          Inc(I);
          Sleep(Random(100));
        end;
      until (I = 0) or (I = 5);
      // Dieses Load muss noch extra aufgerufen werden, da sonst die Skinkomponenten
      // in dem Datamodul nicht funktionieren
      SkinDataOrange.LoadCompressedStoredSkin(BsCompressedStoredSkinOrange);
      SkinDataBlau.LoadCompressedStoredSkin(BsCompressedStoredSkinBlau);
      SkinDataGrau.LoadCompressedStoredSkin(BsCompressedStoredSkinGrau);
    end;
  end;
end;

end.
