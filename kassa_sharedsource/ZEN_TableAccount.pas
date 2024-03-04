unit ZEN_TableAccount; // #21823 Tischkonto zusammenzählen

interface

uses
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.Stan.Option,
  Classes,  // is needed for TPersistent
  System.JSON,
  DMBase;
const
  C_QueryTableAccount = 'SELECT tk.Tischkontoid, tk.Firma, tk.datum, tk.ArtikelID, tk.Menge, tk.Betrag, '
    + ' b1.PreisPlus as PreisPlus1, b1.PreisMinus as PreisMinus1, b1.BeilagenID as BeilagenID1, b1.Bezeichnung AS LookBeilage1, '
    + ' b2.PreisPlus as PreisPlus2, b2.PreisMinus as PreisMinus2, b2.BeilagenID as BeilagenID2, b2.Bezeichnung AS LookBeilage2, '
    + ' b3.PreisPlus as PreisPlus3, b3.PreisMinus as PreisMinus3, b3.BeilagenID as BeilagenID3, b3.Bezeichnung AS LookBeilage3, '
    + ' tk.BeilagenText '
    + 'FROM Hilf_Tischkonto tk '
    + ' LEFT OUTER JOIN Beilagen b1 ON tk.Firma = b1.Firma AND tk.BeilagenID1 = b1.BeilagenID '
    + ' LEFT OUTER JOIN Beilagen b2 ON tk.Firma = b2.Firma AND tk.BeilagenID2 = b2.BeilagenID '
    + ' LEFT OUTER JOIN Beilagen b3 ON tk.Firma = b3.Firma AND tk.BeilagenID3 = b3.BeilagenID '
    + 'WHERE tk.Firma = :pFirma AND tk.OffeneTischID = :pOffeneTischID '
    + 'order by tk.firma, tk.tischkontoid';

  C_InsertRechnungsKonto = 'insert into rechnungskonto ( '
    + ' firma, rechnungsid, datum, artikelid, leistungstext, menge, betrag, '
    + ' arrangementid, vonsammelrechnungsid, mwst, bonnr ) '
    + 'values ( '
    + ':firma,:rechnungsid,:datum,:artikelid,:leistungstext,:menge,:betrag, '
    + ':arrangementid,:vonsammelrechnungsid,:mwst,:bonnr ) ';

  C_QueryArticleExtras = 'select BEILAGENID, BEZEICHNUNG, PREISPLUS, PREISMINUS '
    + ' from BEILAGEN where FIRMA = :pFIRMA ';

type
  {*----------------------------------------------------------------------------
    class contains one single item (it has just an ID, nothing else)
    ---------------------------------------------------------------------------}
  TItem = class(TPersistent)
  private
    /// id of article or article extra
    FID: Integer;
  published
    property ID: Integer read FID write FID;
  end;

  {*----------------------------------------------------------------------------
    class contains one single product (article or extra-article)
    ---------------------------------------------------------------------------}
  TProduct = class(TItem)
  private
    /// short description of article or article extra
    FDescription: string;
  published
    property Description: string read FDescription write FDescription;
  end;

  {*----------------------------------------------------------------------------
    class contains one single extra-article
    ---------------------------------------------------------------------------}
  TArticleExtra = class(TProduct)
  private
    FPriceChange: Double;
    /// all functions
  published
    property PriceChange: Double read FPriceChange write FPriceChange;
  end;

  {*----------------------------------------------------------------------------
    type contains an array of article extra
    ---------------------------------------------------------------------------}
  TArticleExtras = array of TArticleExtra;

   {*----------------------------------------------------------------------------
    class contains an article extra group
    ---------------------------------------------------------------------------}
  TArticleExtraGroup = class(TProduct);

  {*----------------------------------------------------------------------------
    class contains list of article extras
    ---------------------------------------------------------------------------}
  TArticleExtraList = class(TList)
  private
    /// array of article extra
    FArticleExtras: TArticleExtras;
    function GetCount: Integer;
    procedure SetCount(const Value: Integer);
  published
    /// length of article extras (counter)
    property Count: Integer read GetCount write SetCount;
    property ArticleExtras: TArticleExtras read FArticleExtras write FArticleExtras;
  public
    constructor Create(pArticleExtras: TFDDataSet);
  end;

  {*----------------------------------------------------------------------------
    class contains one single article
    ---------------------------------------------------------------------------}
  TArticle = class(TProduct)
  private
    /// price per unit
    FPrice: Double;
  published
    property Price: Double read FPrice write FPrice;
  end;

  {*----------------------------------------------------------------------------
    type contains an array of article
    ---------------------------------------------------------------------------}
  TArticles = array of TArticle;

  {*----------------------------------------------------------------------------
    class contains one single table account entry
    ---------------------------------------------------------------------------}
  TTableAccountEntry = class(TPersistent)
  private
    /// id of table account entry
    FID: Integer;
    /// article
    FArticle: TArticle;
    /// quantity of article
    FQuantity: Double;
    /// price per unit
    FAmount: Double;
    /// extras tallied to this article
    FTableAccountExtras: Array of TArticleExtra;
    /// guid of device (Smartphone, iPad, ...) which had tallied this entry
    FDate: TDate;

    function GetExtrasCount: Integer;
    procedure SetExtrasCount(const Value: Integer);
    function GetTotal: Double;
    function GetExtrasHash: String;
  published
    property ID: Integer read FID write FID;
    property Article: TArticle read FArticle write FArticle;
    property Quantity: Double read FQuantity write FQuantity;
    property Amount: Double read FAmount write FAmount;
    property Date: TDate read FDate write FDate;
    /// length of table account extras (counter)
    property ExtrasCount: Integer read GetExtrasCount write SetExtrasCount;
    property ExtrasHash: String read GetExtrasHash;
  end;


  {*----------------------------------------------------------------------------
    class contains articles of a table account
    ---------------------------------------------------------------------------}
  TTableAccount = class(TPersistent)
  private
    FCompanyID: integer;
    FOpenTableID: integer;
    /// array of table account entries
    FTableAccountEntries: array of TTableAccountEntry;
    function GetEntriesCount: Integer;
    procedure SetEntriesCount(const Value: Integer);
    function GetTotal: Double;
    /// get table account from HILF_TischKonto
    procedure GetTableAccountFromHilfTischkonto(pFirma, pOffeneTischID: Integer);
    /// get table account from ZENM-JSON-String (DoBill)
    procedure GetTableAccountFromJSON(pFirma, pOffeneTischID: Integer; pJSArticles: TJsonValue);
    /// sum up quantities of same orders
    procedure CompressTableAccount;
    /// post table account to RechnungsKonto
    procedure PostTableAccountToRechnungskonto(pRechnungsID: integer);
  published
    /// length of table account entries (counter)
    property EntriesCount: Integer read GetEntriesCount write SetEntriesCount;
    /// total of table account entries
    property Total: Double read GetTotal;
  end;

procedure TransferTableAccountToReceiptAccount(pFirma, pOffeneTischID, pRechnungsID: Integer;
  pJSArticles: TJsonValue=nil);

implementation

uses
  IdGlobal, IdHash, IdHashMessageDigest,
  strutils, SysUtils,
  pglobal;

procedure TransferTableAccountToReceiptAccount(pFirma, pOffeneTischID, pRechnungsID: Integer;
  pJSArticles: TJsonValue=nil);
begin
  with TTableAccount.Create do
  try
    if pJSArticles=nil then // ZENK Kasse.exe
      GetTableAccountFromHilfTischkonto(pFirma, pOffeneTischID)
    else                    // ZENS.exe
      GetTableAccountFromJSON(pgl.Firma, pOffeneTischID, pJSArticles);

    CompressTableAccount;
    PostTableAccountToRechnungskonto(pRechnungsID);
  finally
    free;
  end;

end;

{ ArticleExtraList }

constructor TArticleExtraList.Create(pArticleExtras: TFDDataSet);
var
  i: Integer;
begin
	inherited Create;
  Count := 0;

  if pArticleExtras = nil then
    EXIT;

  Count := pArticleExtras.recordcount;

  // create array of article extra
  with pArticleExtras do
  begin
    while not Eof do
    begin
      i := RecNo - 1;
      // create each article extra and fill fields
      ArticleExtras[i] := TArticleExtra.Create;
      ArticleExtras[i].ID := FieldByName('ID').AsInteger;
      ArticleExtras[i].Description := trim(FieldByName('Description').AsString);
      Next;
    end;
  end;
end;


function TArticleExtraList.GetCount: Integer;
begin
  Result := System.Length(FArticleExtras);
end;

procedure TArticleExtraList.SetCount(const Value: Integer);
begin
  System.SetLength(FArticleExtras, Value);
end;

{ TableAccount }

procedure TTableAccount.CompressTableAccount;
var i, x, r: integer;
begin
  // 26.04.2019 KL: #21823 bei DruckeNurBeilagenPreisaenderung alle anderen Beilagen eliminieren
  if pgl.BeilagenAufRechnung and pgl.DruckeNurBeilagenPreisaenderung then
    for i := Low(FTableAccountEntries) to High(FTableAccountEntries) do
      for x := FTableAccountEntries[i].ExtrasCount - 1 downto 0  do
        if (FTableAccountEntries[i].FTableAccountExtras[x].PriceChange = 0) then
        begin
          FTableAccountEntries[i].FTableAccountExtras[x].Free;
          FTableAccountEntries[i].FTableAccountExtras[x] := nil;
          for r := x to FTableAccountEntries[i].ExtrasCount-2 do // alle nachrücken
            FTableAccountEntries[i].FTableAccountExtras[r] := FTableAccountEntries[i].FTableAccountExtras[r+1];
          FTableAccountEntries[i].ExtrasCount :=  FTableAccountEntries[i].ExtrasCount - 1;   // und Anzahl verringern
        end;

  i := 0;
  while i < EntriesCount-1 do   // durchgehen vom Ersten bis zum Vorletzen
  begin
    x := i + 1;
    while x < EntriesCount do  // vergleichen mit dem Nächsten bis zum Letzen
    begin
      if (FTableAccountEntries[i].Article.id = FTableAccountEntries[x].Article.id)
      and (FTableAccountEntries[i].Amount = FTableAccountEntries[x].Amount)
      and (FTableAccountEntries[i].Date = FTableAccountEntries[x].Date)
      and (FTableAccountEntries[i].ExtrasCount = FTableAccountEntries[x].ExtrasCount)
      and (FTableAccountEntries[i].ExtrasHash = FTableAccountEntries[x].ExtrasHash) then
      begin
        // addieren
        FTableAccountEntries[i].Quantity := FTableAccountEntries[i].Quantity + FTableAccountEntries[x].Quantity;
        FTableAccountEntries[x].Free;
        FTableAccountEntries[x] := nil;
        for r := x to EntriesCount-2 do // alle nachrücken
          FTableAccountEntries[r] := FTableAccountEntries[r+1];
        EntriesCount := EntriesCount - 1;   // und Anzahl verringern
      end
      else
        inc(x);
    end;
    inc(i);
  end;
end;

function TTableAccount.GetEntriesCount: Integer;
begin
  Result := System.Length(FTableAccountEntries);
end;

procedure TTableAccount.GetTableAccountFromHilfTischkonto(pFirma,
  pOffeneTischID: Integer);
var
  i, x, y: integer;
  arrExtras: array of integer;
begin
  FCompanyID := pFirma;
  FOpenTableID := pOffeneTischID;

  with TFDQuery.Create(Dbase.connectionZEN) do
  try
    Connection := DBase.ConnectionZEN;
    FetchOptions.Mode := fmAll;
    Connection.Connected := True;

    SQL.Text := C_QueryTableAccount;
    ParamByName('pFirma').AsInteger := FCompanyID;
    ParamByName('pOffeneTischID').AsInteger := FOpenTableID;
    open;
    if IsEmpty then
      exit;

    // (1) count article orders (article extras dont have an article-id)
    i := 0;
    while not Eof do
    begin
      if not FieldByName('ARTIKELID').IsNull then
        Inc(i);
      next;
    end;
    EntriesCount := i; // is not the same as "RecordCount", because article extras are not included!

    // (2) count article extras
    System.SetLength(arrExtras, i);
    first;
    i := -1;
    while not Eof do
    begin
      if NOT FieldByName('ARTIKELID').IsNull then // article
      begin
        Inc(i);
        arrExtras[i] := 0;
      end;

      if i >= 0 then// article extra
      begin
        if FieldByName('BEILAGENID1').AsInteger < 0 then
        begin   // modifier and article extra
          Inc(arrExtras[i]);
        end
        else
        begin   // article extra with no modifier #6594
          for x := 1 to 3 do
            if (NOT FieldByName('BEILAGENID'+IntToStr(x)).IsNull)
            and (FieldByName('BEILAGENID'+IntToStr(x)).AsInteger > 0) then
              Inc(arrExtras[i]);
        end;
      end;
      next;
    end;

    // (3) fill our table account
    first;
    i := -1; // set counter for article orders
    x := -1; // set counter for article extras
    while not Eof do
    begin
      if NOT FieldByName('ARTIKELID').IsNull then // article
      begin
        Inc(i);
        FTableAccountEntries[i] := TTableAccountEntry.Create;
        with FTableAccountEntries[i] do
        begin
          ID := FieldByName('TISCHKONTOID').AsInteger;
          Date := fieldbyname('Datum').AsDateTime;
          Article := TArticle.Create;
          Article.ID := FieldByName('ARTIKELID').AsInteger;
          Quantity := FieldByName('MENGE').AsFloat;
          Amount := FieldByName('BETRAG').AsFloat;
          ExtrasCount := arrExtras[i];
        end;
        x := -1; // reset index for article extras
      end;

      if i >= 0 then// article extra
      begin
        with FTableAccountEntries[i] do
        begin
          if FieldByName('BEILAGENID1').AsInteger < 0 then
          begin   // modifier and article extra
            Inc(x);
            FTableAccountExtras[x] := TArticleExtra.Create;
            FTableAccountExtras[x].ID := FieldByName('BEILAGENID2').AsInteger;
            Case FieldByName('BEILAGENID1').AsInteger of
              -1:
              begin // free text
                FTableAccountExtras[x].PriceChange := 0;
                FTableAccountExtras[x].Description := FieldByName('BEILAGENTEXT').AsString;
              end;
              -2:
              begin // "mit" price increases
                FTableAccountExtras[x].PriceChange := StrToFloat(Format(
                  '%.2f', [FieldByName('PreisPlus2').AsFloat]));
                FTableAccountExtras[x].Description := FieldByName('LOOKBEILAGE2').AsString;
              end;
              -3:
              begin // "ohne" price decreases
                FTableAccountExtras[x].PriceChange := StrToFloat(Format(
                  '%.2f', [FieldByName('PreisMinus2').AsFloat]));
                FTableAccountExtras[x].Description := FieldByName('LOOKBEILAGE2').AsString;
              end;
              -6:
              begin // "statt" price replacement
                FTableAccountExtras[x].PriceChange := StrToFloat(Format(
                  '%.2f', [FieldByName('PreisMinus2').AsFloat + FieldByName('PreisPlus3').AsFloat]));
                FTableAccountExtras[x].Description := FieldByName('LOOKBEILAGE1').AsString +
                  ' ' + FieldByName('LOOKBEILAGE2').AsString + ' ' + FieldByName('LOOKBEILAGE3').AsString;
              end;
              else
              begin // "4:mehr, 5:weniger"
                FTableAccountExtras[x].PriceChange := 0;
                FTableAccountExtras[x].Description := FieldByName('LOOKBEILAGE1').AsString +
                  ' ' + FieldByName('LOOKBEILAGE2').AsString;
              end;

            end;

            if FTableAccountExtras[x].PriceChange <> 0 then
              FTableAccountExtras[x].Description := Format('(%s) %s',
                [formatfloat('###,##0.##', FTableAccountExtras[x].PriceChange), FTableAccountExtras[x].Description]);

          end
          else
          begin   // article extra with no modifier get standard modifier "mit"
            for y := 1 to 3 do
              if (NOT FieldByName('BEILAGENID'+IntToStr(y)).IsNull)
              and (FieldByName('BEILAGENID'+IntToStr(y)).AsInteger > 0) then
              begin
                Inc(x);
                FTableAccountExtras[x] := TArticleExtra.Create;
                FTableAccountExtras[x].ID := FieldByName('BEILAGENID'+inttostr(y)).AsInteger;
                FTableAccountExtras[x].PriceChange := StrToFloat(Format(
                  '%.2f', [FieldByName('PreisPlus'+inttostr(y)).AsFloat]));
                FTableAccountExtras[x].Description := FieldByName('LOOKBEILAGE'+inttostr(y)).AsString;

                if FTableAccountExtras[x].PriceChange <> 0 then
                  FTableAccountExtras[x].Description := Format('(%s) %s',
                    [formatfloat('###,##0.##', FTableAccountExtras[x].PriceChange), FTableAccountExtras[x].Description]);
              end;
          end;
        end;
      end;
      Next;
    end;

  finally
    free;
  end;

end;

procedure TTableAccount.GetTableAccountFromJSON(pFirma,
  pOffeneTischID: Integer; pJSArticles: TJsonValue);
var
  i, x: integer;
  arrExtras: array of integer;
  aJsArticle, aJsExtra : TJSONValue;

begin
  FCompanyID := pFirma;
  FOpenTableID := pOffeneTischID;

  if (pJSArticles = nil)
  or (pJSArticles.ToJSON = '[]') then
    exit;


  with TFDQuery.Create(Dbase.connectionZEN) do
  try
    Connection := DBase.ConnectionZEN;
    FetchOptions.Mode := fmAll;
    Connection.Connected := True;

    SQL.Text := C_QueryArticleExtras;
    ParamByName('pFirma').AsInteger := FCompanyID;
    open;

    // (1) count article orders
    i := 0;
    for aJsArticle in TJSONArray(pJSArticles) do
      if GetJsonInteger(aJsArticle, 'articleid') <> 0 then
        Inc(i);

    EntriesCount := i;

    // (2) count article extras
    System.SetLength(arrExtras, i);
    i := -1;
    for aJsArticle in TJSONArray(pJSArticles) do
    begin
      if GetJsonInteger(aJsArticle, 'articleid') <> 0 then
      begin
        Inc(i);
        arrExtras[i] := 0;
        if GetJsonArray(aJsArticle, 'articleextras') <> '[]' then
          for aJsExtra in TJSONArray(TJSONObject.ParseJSONValue(GetJsonArray(aJsArticle, 'articleextras'))) do
            inc(arrExtras[i]);
      end;
    end;

    // (3) fill our table account
    i := -1; // set counter for article orders
    for aJsArticle in TJSONArray(pJSArticles) do
    begin
      if GetJsonInteger(aJsArticle, 'articleid') <> 0 then
      begin
        Inc(i);

        FTableAccountEntries[i] := TTableAccountEntry.Create;
        with FTableAccountEntries[i] do
        begin
          // article
          ID := i+1; //FieldByName('TISCHKONTOID').AsInteger;
          Date := pgl.Datum; // fieldbyname('Datum').AsDateTime;
          Article := TArticle.Create;
          Article.ID := GetJsonInteger(aJsArticle, 'articleid');
          Quantity := GetJsonFloat(aJsArticle, 'quantity');
          Amount := GetJsonFloat(aJsArticle, 'price');

          // article extras
          ExtrasCount := arrExtras[i];
          x := -1; // set counter for article extras
          if arrExtras[i] > 0 then
          begin
            for aJsExtra in TJSONArray(TJSONObject.ParseJSONValue(GetJsonArray(aJsArticle, 'articleextras'))) do
            //for aJsExtra in TJSONArray(GetJsonString(aJsArticle, 'articleextras')) do
            begin
              Inc(x);
              FTableAccountExtras[x] := TArticleExtra.Create;
              FTableAccountExtras[x].ID := GetJsonInteger(aJsExtra, 'articleextraid2');
              first;
              if Locate('BeilagenID', FTableAccountExtras[x].ID , []) then
              begin
                Case GetJsonInteger(aJsExtra, 'articleextraid1') of
                  -1:
                  begin // free text
                    FTableAccountExtras[x].PriceChange := 0;
                    FTableAccountExtras[x].Description := GetJsonString(aJsExtra, 'articleextratext');
                  end;
                  -2:
                  begin // "mit" price increases
                    FTableAccountExtras[x].PriceChange := StrToFloat(Format(
                      '%.2f', [FieldByName('PreisPlus').AsFloat]));
                    FTableAccountExtras[x].Description := FieldByName('Bezeichnung').AsString;
                  end;
                  -3:
                  begin // "ohne" price decreases
                    FTableAccountExtras[x].PriceChange := StrToFloat(Format(
                      '%.2f', [FieldByName('PreisMinus').AsFloat]));
                    FTableAccountExtras[x].Description := FieldByName('Bezeichnung').AsString;
                  end;
                  else
                  begin // "4:mehr, 5:weniger, 6:statt"
                    FTableAccountExtras[x].PriceChange := 0;
                    FTableAccountExtras[x].Description := FieldByName('Bezeichnung').AsString;
                  end
                end;
              end
              else
              begin // Beilage nicht gefunden
                FTableAccountExtras[x].PriceChange := 0;
                FTableAccountExtras[x].Description := 'Beilage nicht gefunden';
              end;
            end;

            if FTableAccountExtras[x].PriceChange <> 0 then
              FTableAccountExtras[x].Description := Format('(%s) %s',
                [formatfloat('###,##0.##', FTableAccountExtras[x].PriceChange), FTableAccountExtras[x].Description]);
          end;
        end;
      end;
    end;
  finally
    free;
  end;

end;

function TTableAccount.GetTotal: Double;
var
  i: Integer;
  aTotal: Double;
begin
  aTotal := 0;
  for i := 0 To EntriesCount - 1 do
    aTotal := aTotal + FTableAccountEntries[i].GetTotal;
  Result := RoundDouble(aTotal); // always round total to 2 digits
end;

procedure TTableAccount.PostTableAccountToRechnungskonto(pRechnungsID: integer);
var
  i, x: Integer;
  aOffTischID: integer;
  aBonNr: integer;
begin
  aBonNr := 100;
  with TFDQuery.Create(DBase.ConnectionZEN) do
  try
    Connection := DBase.ConnectionZEN;
    FetchOptions.Mode := fmAll;
    Connection.Connected := True;
    SQL.Text := C_InsertRechnungsKonto;

    for i := Low(FTableAccountEntries) to High(FTableAccountEntries) do
    begin
      inc(aBonNr);
      close;
      ParamByName('Firma').AsInteger := FCompanyID;
      ParamByName('RechnungsID').AsInteger := pRechnungsID;
      ParamByName('Datum').AsDateTime := FTableAccountEntries[i].Date;
      ParamByName('ArtikelID').AsInteger := FTableAccountEntries[i].Article.ID;
      ParamByName('Menge').AsFloat := FTableAccountEntries[i].Quantity;
      ParamByName('Betrag').AsFloat := FTableAccountEntries[i].Amount;
      ParamByName('LeistungsText').AsString := '';
      ParamByName('Bonnr').AsInteger := aBonNr;
      ExecSQL;
      // Beilagen
      for x := 0 to FTableAccountEntries[i].ExtrasCount - 1 do
      begin
        inc(aBonNr); // KL: #21823: ist aus altem KassenCode, ich würde bei Beilagen nicht erhöhen
        ParamByName('Menge').AsFloat := 0;
        ParamByName('Betrag').AsFloat := 0;
        ParamByName('LeistungsText').AsString :=
          LeftStr(FTableAccountEntries[i].FTableAccountExtras[x].Description, 35);
        ParamByName('Bonnr').AsInteger := aBonNr;
        ExecSQL;
      end;
    end;
  finally
    free;
  end;

end;

procedure TTableAccount.SetEntriesCount(const Value: Integer);
begin
  System.SetLength(FTableAccountEntries, Value);
end;


{ Article }


{ TableAccountExtra }


{ TableAccountEntry }

function TTableAccountEntry.GetExtrasCount: Integer;
begin
  Result := System.Length(FTableAccountExtras);
end;

function TTableAccountEntry.GetExtrasHash: String;
var i: integer;
begin
  Result := '';
  for i := Low(FTableAccountExtras) to High(FTableAccountExtras) do
    with TIdHashMessageDigest5.Create do
    try
      Result := HashStringAsHex(Result + format('%d %s %.2f',
        [FTableAccountExtras[i].ID, FTableAccountExtras[i].Description, FTableAccountExtras[i].PriceChange]));
    finally
      Free;
    end;
end;

function TTableAccountEntry.GetTotal: Double;
begin
  Result := FQuantity * FAmount;
end;

procedure TTableAccountEntry.SetExtrasCount(const Value: Integer);
begin
  System.SetLength(FTableAccountExtras, Value);
end;

end.
