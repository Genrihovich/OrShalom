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
    sBitBtn1: TsBitBtn;
    procedure btnExportDataClick(Sender: TObject);
    procedure sBitBtn1Click(Sender: TObject);

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

uses uFrameObExport, uMainForm, uFrameObInputZahid;




procedure TfrmObchiaMenu.ApplyPermissions;
var
  RoleInt: Integer;
begin
  if not VarIsNull(UserRole) then
  begin
    RoleInt := VarAsType(UserRole, varInteger);
    if RoleInt = 2 then
      btnExportData.Visible := False;
  end;
end;

procedure TfrmObchiaMenu.btnExportDataClick(Sender: TObject);
begin
myForm.CreateNewFrame(TfrmObExportData, Sender);
end;

procedure TfrmObchiaMenu.sBitBtn1Click(Sender: TObject);
begin  // общинка заходи  TfrmObInputZahid
 myForm.CreateNewFrame(TfrmObInputZahid, Sender);
end;

end.
