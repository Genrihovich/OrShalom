unit uObchinaMenu;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, sBitBtn,
  sFrameAdapter;

type
  TfrmObchiaMenu = class(TFrame)
    sFrameAdapter1: TsFrameAdapter;
    btnVidomist: TsBitBtn;
    sBitBtn1: TsBitBtn;
    procedure btnVidomistClick(Sender: TObject);
    procedure sBitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmObchiaMenu: TfrmObchiaMenu;

implementation

{$R *.dfm}

uses uFrameObExport, uMainForm, uFrameObInputZahid;

procedure TfrmObchiaMenu.btnVidomistClick(Sender: TObject);
begin
myForm.CreateNewFrame(TfrmObExportData, Sender);
end;

procedure TfrmObchiaMenu.sBitBtn1Click(Sender: TObject);
begin  // общинка заходи  TfrmObInputZahid
 myForm.CreateNewFrame(TfrmObInputZahid, Sender);
end;

end.
