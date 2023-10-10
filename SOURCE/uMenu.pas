unit uMenu;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons,
  sBitBtn, sFrameAdapter;

type
  TfrmMenu = class(TFrame)
    btnVidomist: TsBitBtn;
    btnSLG: TsBitBtn;
    btnNalogy: TsBitBtn;
    sFrameAdapter1: TsFrameAdapter;
    btnChart: TsBitBtn;
    procedure btnVidomistClick(Sender: TObject);
    procedure btnSLGClick(Sender: TObject);
    procedure btnNalogyClick(Sender: TObject);
    procedure btnChartClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses uFrameDovidniky, uMainForm, uFrameKontakt, uFrameStatistic, uFrameCharts;

procedure TfrmMenu.btnChartClick(Sender: TObject);
begin
 myForm.CreateNewFrame(TfrmCharts, Sender);
end;

procedure TfrmMenu.btnNalogyClick(Sender: TObject);
begin
  myForm.CreateNewFrame(TfrmStatistic, Sender);
end;

procedure TfrmMenu.btnSLGClick(Sender: TObject);
begin
  myForm.CreateNewFrame(TfrmKontakt, Sender);
end;

procedure TfrmMenu.btnVidomistClick(Sender: TObject);
begin
  myForm.CreateNewFrame(TfrmDovidniky, Sender);
end;

end.
