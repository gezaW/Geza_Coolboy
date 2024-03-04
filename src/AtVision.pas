unit AtVision;

interface
  uses
    System.JSON,
    DataSnap.DSProviderDataModuleAdapter;

type
  API = class(TDSServerModule)
    private


    public

    function checkIn(pParams: TJSONObject): TJSONObject;

  end;

  var
  restApi : Api;

implementation



{ API }

function API.checkIn(pParams: TJSONObject): TJSONObject;
begin

end;

end.
