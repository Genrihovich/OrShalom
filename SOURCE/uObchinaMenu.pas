unit uObchinaMenu;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, sBitBtn,
  sFrameAdapter;

type
  TfrmObchiaMenu = class(TFrame)
    sFrameAdapter1: TsFrameAdapter;
    btnExportData: TsBitBtn;
    btnObchinaEvents: TsBitBtn;
    btnAnalitic: TsBitBtn;
    procedure btnExportDataClick(Sender: TObject);
    procedure btnObchinaEventsClick(Sender: TObject);
    procedure btnAnaliticClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
    procedure ApplyPermissions;

  end;

var
  frmObchiaMenu: TfrmObchiaMenu;

implementation

{$R *.dfm}

uses uFrameObExport, uMainForm, uFrameObInputZahid, uFrameObAnalitics;




procedure TfrmObchiaMenu.ApplyPermissions;
var
  RoleInt: Integer;
begin
  if not VarIsNull(UserRole) then
  begin
    RoleInt := VarAsType(UserRole, varInteger);
    if (RoleInt = 2) or (RoleInt = 4) then
    begin
      btnExportData.Visible := False;
      btnAnalitic.Visible := False;
    end;
  end;
end;

procedure TfrmObchiaMenu.btnAnaliticClick(Sender: TObject);
begin //Аналітіка
 myForm.CreateNewFrame(TfrmObAnalitics, Sender);
end;

procedure TfrmObchiaMenu.btnExportDataClick(Sender: TObject);
begin
myForm.CreateNewFrame(TfrmObExportData, Sender);
end;

procedure TfrmObchiaMenu.btnObchinaEventsClick(Sender: TObject);
begin  // общинка заходи  TfrmObInputZahid
 myForm.CreateNewFrame(TfrmObInputZahid, Sender);
end;

end.
