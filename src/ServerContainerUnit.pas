unit ServerContainerUnit;

interface

uses System.SysUtils, System.Classes,
  Datasnap.DSServer, Datasnap.DSCommonServer,
  Datasnap.DSClientMetadata, Datasnap.DSHTTPServiceProxyDispatcher,
  Datasnap.DSProxyJavaAndroid, Datasnap.DSProxyJavaBlackBerry,
  Datasnap.DSProxyObjectiveCiOS, Datasnap.DSProxyCsharpSilverlight,
  Datasnap.DSProxyFreePascal_iOS,
  IPPeerServer, IPPeerAPI, Datasnap.DSAuth,
  ServerIntf, Spring.Container, Spring.Services, IdBaseComponent, IdComponent, IdCustomTCPServer, IdQotdServer;

type
  TServerContainer1 = class(TDataModule)
    DSServer1: TDSServer;
    DSAuthenticationManager1: TDSAuthenticationManager;
    DSServerClassAPI: TDSServerClass;
    DSServerClassCD: TDSServerClass;
    DSServerClassEF: TDSServerClass;

    procedure DSServerClassAPIGetClass(DSServerClass: TDSServerClass;
      var PersistentClass: TPersistentClass);
    procedure DSAuthenticationManager1UserAuthorize(Sender: TObject;
      EventObject: TDSAuthorizeEventObject; var valid: Boolean);
    procedure DSAuthenticationManager1UserAuthenticate(Sender: TObject;
      const Protocol, Context, User, Password: string; var valid: Boolean;
      UserRoles: TStrings);
    procedure DSServerClassCDGetClass(DSServerClass: TDSServerClass; var PersistentClass: TPersistentClass);
    procedure DSServerClassEFGetClass(DSServerClass: TDSServerClass; var PersistentClass: TPersistentClass);
  private
    { Private-Deklarationen }
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

function DSServer: TDSServer;
function DSAuthenticationManager: TDSAuthenticationManager;

implementation


{$R *.dfm}

uses
  ServerMethodsUnit, Logging, ServerCashDeskUnit, ServerExternFunctions;

var
  FModule: TComponent;
  FDSServer: TDSServer;
  FDSAuthenticationManager: TDSAuthenticationManager;
  FChecker: IRestChecker;

function DSServer: TDSServer;
begin
  Result := FDSServer;
end;

function DSAuthenticationManager: TDSAuthenticationManager;
begin
  Result := FDSAuthenticationManager;
end;

constructor TServerContainer1.Create(AOwner: TComponent);
begin
  inherited;

  FDSServer := DSServer1;
  FDSAuthenticationManager := DSAuthenticationManager1;
end;

destructor TServerContainer1.Destroy;
begin
  inherited;
  FDSServer := nil;
  FDSAuthenticationManager := nil;
end;

procedure TServerContainer1.DSServerClassAPIGetClass(
  DSServerClass: TDSServerClass; var PersistentClass: TPersistentClass);
begin
  PersistentClass := ServerMethodsUnit.TAPI;
end;


procedure TServerContainer1.DSServerClassCDGetClass(DSServerClass: TDSServerClass;
  var PersistentClass: TPersistentClass);
begin
    PersistentClass := ServerCashDeskUnit.TCD;
end;

procedure TServerContainer1.DSServerClassEFGetClass(DSServerClass: TDSServerClass;
  var PersistentClass: TPersistentClass);
begin
  PersistentClass := ServerExternFunctions.TEF;
end;

procedure TServerContainer1.DSAuthenticationManager1UserAuthenticate(
  Sender: TObject; const Protocol, Context, User, Password: string;
  var valid: Boolean; UserRoles: TStrings);
begin
//  if not dbase.IsDebug then
  FChecker := Spring.Services.ServiceLocator.GetService<IRestChecker>;
  Log.WriteToLog('Admin', 0, '<TServerContainer> Check Incomming User: ' + User,lmtLogin);
    valid:= false;
    if FChecker.CheckUser(User, Password)  then valid := True;

  { TODO : Validieren Sie den Client-Benutzer und das Passwort.
    Wenn eine rollenbasierte Autorisierung erforderlich ist, fügen Sie dem Parameter UserRoles Rollennamen hinzu  }
  // valid := True;
end;

procedure TServerContainer1.DSAuthenticationManager1UserAuthorize(
  Sender: TObject; EventObject: TDSAuthorizeEventObject;
  var valid: Boolean);
begin
  { TODO : Autorisieren Sie einen Benutzer zum Ausführen einer Methode.
    Verwenden Sie Werte von EventObject, wie z.B. UserName, UserRoles, AuthorizedRoles und DeniedRoles.
    Verwenden Sie DSAuthenticationManager1.Roles zum Definieren von 'Authorized'- und 'Denied'-Rollen
    für bestimmte Servermethoden. }
  valid := True;
end;

initialization
  FModule := TServerContainer1.Create(nil);
finalization
  FModule.Free;
end.

