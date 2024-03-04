unit TokenUnit;

interface

implementation

uses
  ServerIntf, System.JSON, JOSE.Core.JWS, JOSE.Core.JWT, JOSE.Core.JWK, Resources,
  System.SysUtils, System.DateUtils, JOSE.Core.JWA,
  Spring.Container;

type
  TJWTToken = class(TInterfacedObject, IJWTToken)
  private
    FToken: string;
    procedure SetToken(const pToken: string);
    function GetToken: string;
  public
    function CreateToken(pCustomClaims: TJSONObject; pIssuedAt: TDateTime = 0;
      pNotBefore: TDateTime = 0; pExpiration: TDateTime = 0; const pIssuer: string = '';
      const pSecretKey: string = ''): string;
    function CheckToken(const pToken: string; out pErrorMessage: string): Boolean; overload;
    function CheckToken(out pErrorMessage: string): Boolean; overload;
    function GetCustomClaimsValue(pName: string): string;
    property Token: string read GetToken write SetToken;
  end;

{ TJWTToken }

function TJWTToken.CheckToken(const pToken: string;
  out pErrorMessage: string): Boolean;
var
  aJWS: TJWS;
  aJWK: TJWK;
  aJWT: TJWT;
begin
  pErrorMessage := '';
  Result := False;
  aJWK := TJWK.Create(cSecretKeyForToken);
  try
    aJWT := TJWT.Create;
    try
      aJWS := TJWS.Create(aJWT);
      try
        aJWS.SkipKeyValidation := True;
        aJWS.SetKey(aJWK);
        try
          aJWS.CompactToken := pToken;
          aJWS.VerifySignature;
        except
          on E: Exception do
          begin
            pErrorMessage := E.Message;
            Exit;
          end;
        end;
        if aJWT.Verified = False then
        begin
          pErrorMessage := cErrorIncorrectToken;
          Exit;
        end;

        if aJWT.Claims.NotBefore > Now then
        begin
          pErrorMessage := cErrorTokenNotActive;
          Exit;
        end;
        if aJWT.Claims.Expiration < Now then
        begin
          pErrorMessage := cErrorTokenIsExpired;
          Exit;
        end;

        Result := True;
      finally
        FreeAndNil(aJWS);
      end;
    finally
      FreeAndNil(aJWT);
    end;
  finally
    FreeAndNil(aJWK);
  end;
end;

function TJWTToken.CheckToken(out pErrorMessage: string): Boolean;
begin
  Result := CheckToken(Token, pErrorMessage);
end;

function TJWTToken.CreateToken(pCustomClaims: TJSONObject; pIssuedAt,
  pNotBefore, pExpiration: TDateTime; const pIssuer: string;
  const pSecretKey: string): string;
var
  aJWS: TJWS;
  aJWK: TJWK;
  aJWT: TJWT;
begin
  aJWT := TJWT.Create;
  try
    aJWS := TJWS.Create(aJWT);
    try
      if pSecretKey <> '' then
        aJWK := TJWK.Create(pSecretKey)
      else
        aJWK := TJWK.Create(cSecretKeyForToken);
      try
        aJWT.Claims.JSON := pCustomClaims;
        if pIssuedAt = 0 then
          aJWT.Claims.IssuedAt := Now
        else
          aJWT.Claims.IssuedAt := pIssuedAt;
        if pNotBefore = 0 then
          aJWT.Claims.NotBefore := aJWT.Claims.IssuedAt
        else
          aJWT.Claims.NotBefore := pNotBefore;
        if aJWT.Claims.Expiration = 0 then
          aJWT.Claims.Expiration := IncMinute(aJWT.Claims.IssuedAt, cTokenExpirationTerm)
        else
          aJWT.Claims.Expiration := pExpiration;
        if aJWT.Claims.Issuer = '' then
          aJWT.Claims.Issuer := cTokenIssuerName
        else
          aJWT.Claims.Issuer := pIssuer;
        aJWS.SkipKeyValidation := True;
        aJWS.Sign(aJWK, TJOSEAlgorithmId.HS256);
        Result := aJWS.Header + '.' + aJWS.Payload + '.' + aJWS.Signature;
      finally
        FreeAndNil(aJWK);
      end;
    finally
      FreeAndNil(aJWS);
    end;
  finally
    FreeAndNil(aJWT);
  end;
end;

function TJWTToken.GetCustomClaimsValue(pName: string): string;
var
  aJWT: TJWT;
  aJWS: TJWS;
  aJWK: TJWK;
begin
  aJWK := TJWK.Create(cSecretKeyForToken);
  try
    aJWT := TJWT.Create;
    try
      aJWS := TJWS.Create(aJWT);
      try
        aJWS.SkipKeyValidation := True;
        aJWS.SetKey(aJWK);
        aJWS.CompactToken := Token;
        if pName <> '' then
          Result := aJWT.Claims.JSON.GetValue(pName).Value
        else
          Result := aJWT.Claims.JSON.ToJSON;
      finally
        FreeAndNil(aJWS);
      end;
    finally
      FreeAndNil(aJWT);
    end;
  finally
    FreeAndNil(aJWK);
  end;
end;

function TJWTToken.GetToken: string;
begin
  Result := FToken;
end;

procedure TJWTToken.SetToken(const pToken: string);
begin
  FToken := pToken;
end;

initialization

begin
  Spring.Container.GlobalContainer.RegisterType<TJWTToken>.Implements<IJWTToken>;
  Spring.Container.GlobalContainer.Build;
end;


end.
