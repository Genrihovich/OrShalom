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
