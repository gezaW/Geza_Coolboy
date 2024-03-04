unit DEPExport;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, AdvDateTimePicker, FolderDialog, AdvGlassButton, StdCtrls, AdvEdit, AdvEdBtn, AdvDirectoryEdit,
  W7Classes, W7ProgressBars, DB,
//  IBODataset, IB_Components, IB_Process, IB_DataScan, IB_Export,
//  IBCustomDataSet,
  DBClient, AdvSmoothProgressBar, W7Labels, ExtCtrls, bsSkinCtrls,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client;


type
  TfmDEPExport = class(TForm)
    PanelHeader: TPanel;
    ButtonCancel: TbsSkinButton;
    LabelFormCaption: TW7ActiveLabel;
    PanelFinanzDEPType: TPanel;
    RadioGroupFinazDEP: TRadioGroup;
    PanelZeitraum: TPanel;
    DateVon: TAdvDateTimePicker;
    DateBis: TAdvDateTimePicker;
    DirectorySave: TAdvDirectoryEdit;
    PanelFooter: TPanel;
    ProgressBarDEP: TAdvSmoothProgressBar;
    ButtonStartExport: TbsSkinButton;
    QueryDEP: TFDQuery;
    procedure ButtonStartExportClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ButtonCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    function ConvertStr(pString: string): string;
    procedure GMSDEP;
    procedure FiskaltrustDEP;
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  fmDEPExport: TfmDEPExport;

implementation

{$R *.dfm}

uses
  Utilities, DMDesign, global, DMFiskaltrust, DateUtils, DMBase;

function TfmDEPExport.ConvertStr(pString: string): string;
begin
  Result:= StringReplace(pString, ';', ',', [rfReplaceAll, rfIgnoreCase]);
end;


procedure TfmDEPExport.ButtonCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
  Close;
end;

procedure TfmDEPExport.ButtonStartExportClick(Sender: TObject);
begin
  ButtonStartExport.Enabled := FALSE;
  try
    if NOT DirectoryExists(DirectorySave.Text) Then
    begin
      DirectorySave.SetFocus;
      MessageDlg(DirectorySave.LabelCaption+' "'+DirectorySave.Text+'" existiert nicht!',
        mtWarning, [mbOK], 0);
      EXIT;
    end;

    if DateVon.Date > DateBis.Date Then
    begin
      DateVon.SetFocus;
      MessageDlg(DateVon.LabelCaption+' ist größer als '+DateBis.LabelCaption,
        mtWarning, [mbOK], 0);
      EXIT;
    end;

    if MessageDlg('Soll der Export jetzt gestartet werden?'+sLineBreak
                 +sLineBreak
                 +'Kann einige Minuten dauern!',
      mtConfirmation, [mbyes, mbno, mbcancel], 0) <> mrYes Then
      EXIT;

    if RadioGroupFinazDEP.ItemIndex = 1 then
      GMSDEP
    else
      FiskaltrustDEP;

    ModalResult := mrOk;
    Close;
  finally
    ButtonStartExport.enabled := TRUE;
  end;
end;

procedure TfmDEPExport.GMSDEP;
var
  FFile: System.Text;
  i: integer;
begin
  with QueryDEP do
  try
    Close;
    ParamByName('VonDatum').AsDate := DateVon.Date;
    ParamByName('BisDatum').AsDate := DateBis.Date;
    Open;

    i := recordcount;
    if i < 1 Then
    begin
      DateVon.SetFocus;
      MessageDlg('KEINE Datensätze gefunden!',
        mtInformation, [mbOK], 0);
      Close;
      EXIT;
    end;

    if MessageDlg(format('Sollen %d Datensätze exportiert werden?', [i]),
      mtConfirmation, [mbyes, mbno, mbcancel], 0) <> mrYes Then
    begin
      Close;
      EXIT;
    end;

    ProgressBarDEP.Maximum := i;
    ProgressBarDEP.Position := 0;

    // 27.01.2016 KL: BackSlash hat gefehlt
    AssignFile(FFile, DirectorySave.Text
      +'\GMS_DEP_'+FormatDateTime('yyyy.mm.dd', DateVon.Date)
         +'_'+FormatDateTime('yyyy.mm.dd', DateBis.Date)+'.csv');
    Rewrite(FFile);

    writeln(FFile,
        'Rechnungs-Nr.;'+
        'Menge;'+
        'Bezeichnung;'+
        'Einzelbetrag;'+
        'Gesamtbetrag;'+
        'Nachlass;'+
        'MWST;'+
        'Tisch;'+
        'Kellner;'+
        'Hauptgruppe;'+
        'Gast;'+
        'Ort;'+
        'Datum;'+
        'Uhrzeit;'+
        'Kasse;'+
        'Art;'
    );

    while NOT EOF  do
    begin
      ProgressBarDEP.Next;
      dbase.ApplicationProcessMessages;

      // Leistungen (Artikel bzw. Bonierung) schreiben
      if (FieldByName('ZahlwegsID').AsInteger = 0) and (FieldByName('RechnungskontoID').AsInteger <> 0) then
        writeln(FFile,
          IntToStr(FieldByName('RECHNUNGSNUMMER').AsInteger)+';'+
          Format('%.0n', [FieldByName('Menge').AsFloat])+';'+
          FieldByName('Artikel').AsString+';'+
          Format('%.2n', [FieldByName('Betrag').AsFloat])+';'+
          Format('%.2n', [FieldByName('Gesamtbetrag').AsFloat])+';'+
          ';'+
          FieldByName('MWST').AsString+';'+
          FieldByName('Tisch').AsString+';'+
          FieldByName('Kellner').AsString+';'+
          FieldByName('Hauptgruppe').AsString+';'+
          ';'+
          ';'+
          FormatDateTime('dd.mm.yyyy', FieldByName('Datum').AsDateTime)+';'+
          ';'+
          IntToStr(FieldByName('KasseID').AsInteger)+';'+
          'Artikel;')

      else // Zahlwege schreiben
        writeln(FFile,
          IntToStr(FieldByName('RECHNUNGSNUMMER').AsInteger)+';'+
          '1;'+
          FieldByName('Zahlweg').AsString+';'+
          Format('%.2n', [FieldByName('Betrag').AsFloat])+';'+
          Format('%.2n', [FieldByName('Zahlungsbetrag').AsFloat])+';'+
          FloatToStr(FieldByName('Nachlass').AsFloat)+';'+
          ';'+
          FieldByName('Tisch').AsString+';'+
          FieldByName('Kellner').AsString+';'+
          ';'+
          FieldByName('Gast').AsString+';'+
          FieldByName('Ort').AsString+';'+
          FormatDateTime('dd.mm.yyyy', FieldByName('Datum').AsDateTime)+';'+
          FormatDateTime('hh:nn:ss', FieldByName('Zeit').AsDateTime)+';'+
          IntToStr(FieldByName('KasseID').AsInteger)+';'+
          'Zahlung;');

      Next;
    end;

    CloseFile(FFile);
    MessageDlg(format('%d Datensätze wurden exportiert!', [i]),
        mtInformation, [mbOK], 0);

    Close;
  except on E: Exception do
    DataDesign.ShowMessageSkin('GMS-DEP-Export: '+e.Message);
  end;
end;


procedure TfmDEPExport.FiskaltrustDEP;
var aFileName: string;
begin
  aFileName := DataFiskaltrust.ExportJournal(1, trunc(DateVon.DateTime), incday(trunc(DateBis.DateTime), 1), DirectorySave.Text);
  if aFileName = '' then
    MessageDlg('Fiskaltrust DEP konnte nicht exportiert werden!',
      mtInformation, [mbOK], 0)
  else
    MessageDlg('Fiskaltrust DEP exportiert nach '+sLineBreak
      +aFileName,
      mtInformation, [mbOK], 0);
end;

procedure TfmDEPExport.FormCreate(Sender: TObject);
begin
  DBase.SetDefaulftConnection(Self);

  if gl.Fiskaltrust then
  begin
    RadioGroupFinazDEP.ItemIndex := 0;
    PanelFinanzDEPType.Visible := TRUE;
  end
  else
  begin
    RadioGroupFinazDEP.ItemIndex := 1;
    PanelFinanzDEPType.Visible := FALSE;
  end;
end;

procedure TfmDEPExport.FormShow(Sender: TObject);
begin
  DateVon.Date := IncMonth(date, -1);
  DateBis.Date := date;
  DirectorySave.Text := ExtractFilePath(ParamStr(0));
end;

end.
