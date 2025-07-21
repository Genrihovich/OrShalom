unit uFrameObInputZahid;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uFrameCustom, Vcl.ExtCtrls, sPanel,
  sFrameAdapter;

type
  TfrmObInputZahid = class(TCustomInfoFrame)
    sPanel1: TsPanel;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure AfterCreation; override;
    procedure BeforeDestruct; virtual;
  end;

var
  frmObInputZahid: TfrmObInputZahid;

implementation

{$R *.dfm}

uses uMainForm, uDM;

{ TfrmObInputZahid }

procedure TfrmObInputZahid.AfterCreation;
begin
  inherited;
  myForm.lbInfo.Caption := '';
end;

procedure TfrmObInputZahid.BeforeDestruct;
begin

end;

end.
