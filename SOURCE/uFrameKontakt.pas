unit uFrameKontakt;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  uFrameCustom, sFrameAdapter, Vcl.StdCtrls, Vcl.Buttons;

type
  TfrmKontakt = class(TCustomInfoFrame)
    BitBtn1: TBitBtn;
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TfrmKontakt.BitBtn1Click(Sender: TObject);
begin
  inherited;
//
end;

end.
