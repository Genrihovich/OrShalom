unit uDM;

interface

uses
  System.SysUtils, System.Classes, Data.DB, DBAccess, Uni, UniProvider,
  MySQLUniProvider, MemDS, Vcl.Dialogs;

type
  TDM = class(TDataModule)
    UniConnection: TUniConnection;
    MySQLUniProvider: TMySQLUniProvider;
    tUser: TUniTable;
    tRegion: TUniTable;
    dsUser: TUniDataSource;
    dsRegion: TUniDataSource;
    qInsert: TUniQuery;
    qUser: TUniQuery;
    OpenDialog: TOpenDialog;
    qQuery: TUniQuery;
    tZvitSnow: TUniTable;
    dsZvit: TUniDataSource;
    dsCountQuery: TUniDataSource;
    qCountQuery: TUniQuery;
    tZvitSnowNumber: TStringField;
    tZvitSnowJDCID: TStringField;
    tZvitSnowKontakt: TStringField;
    tZvitSnowDateKontakta: TDateField;
    tZvitSnowTema: TStringField;
    tZvitSnowTypeKontakta: TStringField;
    tZvitSnowSostoyalsya: TStringField;
    tZvitSnowIspolnitel: TStringField;
    tZvitSnowTelephone: TStringField;
    tZvitSnowKurator: TStringField;
    qCountItems: TUniQuery;
    UniDataSource1: TUniDataSource;
    tZvitSnowmonthDate: TStringField;
    tZvitSnowYearDate: TStringField;
    qChart: TUniQuery;
    dsChart: TUniDataSource;
    tTraining: TUniTable;
    dsTraining: TUniDataSource;
    qTraining: TUniQuery;
    qClients: TUniQuery;
    dsClients: TUniDataSource;
    qEvents: TUniQuery;
    dsEvents: TUniDataSource;
    qFindClients: TUniQuery;
    dsFindClients: TUniDataSource;
    qEventBoss: TUniQuery;
    dsEventBoss: TUniDataSource;
    qClubs: TUniQuery;
    dsClubs: TUniDataSource;
    qRegions: TUniQuery;
    qKurators: TUniQuery;
    dsRegions: TUniDataSource;
    dsKurators: TUniDataSource;
    qUser_option: TUniQuery;
    dsUser_option: TUniDataSource;
    qSingleEvent: TUniQuery;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DM: TDM;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}
//psv Ayt&fP632#
end.
