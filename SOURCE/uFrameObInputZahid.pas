unit uFrameObInputZahid;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uFrameCustom, Vcl.ExtCtrls, sPanel,
  sFrameAdapter, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh,
  Vcl.StdCtrls, EhLibVCL, GridsEh, DBAxisGridsEh, DBGridEh;

type
  TfrmObInputZahid = class(TCustomInfoFrame)
    sPanel1: TsPanel;
    DBGridEh1: TDBGridEh;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
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

uses uMainForm, uDM, uFrameObNewZahid;

{ TfrmObInputZahid }

procedure TfrmObInputZahid.AfterCreation;
begin
  inherited;
  myForm.lbInfo.Caption := '';
  with DM.qEvents do
  begin
    SQL.Clear;

    if UserRole <> 0 then
    begin
      SQL.Add('SELECT E.`ID`, E.`����`, C.`�����` AS `ClubName`, E.`�����_������`,');
      SQL.Add('  CL.`���` AS `ϲ�_���_��������`, E.`ʳ������_��������`, E.`id_region`, R.`nameRegion` AS `�����_������`');
      SQL.Add('FROM `Events` E');
      SQL.Add('LEFT JOIN `Clubs` C ON E.`ClubID` = C.`ID`');
      SQL.Add('LEFT JOIN `Clients` CL ON E.`���_��������` = CL.`JDC ID`');
      SQL.Add('LEFT JOIN `Region` R ON E.`id_region` = R.`id_region`');
      SQL.Add('WHERE E.`id_region` = :RegionID');
      SQL.Add('ORDER BY E.`����` DESC');

      ParamByName('RegionID').AsInteger := NumRegion; // ��� ����-��� ��������
    end
    else
    begin   // ��� �����
      SQL.Add('SELECT E.`ID`, E.`����`, C.`�����` AS `ClubName`, E.`�����_������`,');
      SQL.Add('  CL.`���` AS `ϲ�_���_��������`, E.`ʳ������_��������`, E.`id_region`, R.`nameRegion` AS `�����_������`');
      SQL.Add('FROM `Events` E');
      SQL.Add('LEFT JOIN `Clubs` C ON E.`ClubID` = C.`ID`');
      SQL.Add('LEFT JOIN `Clients` CL ON E.`���_��������` = CL.`JDC ID`');
      SQL.Add('LEFT JOIN `Region` R ON E.`id_region` = R.`id_region`');
//      SQL.Add('WHERE E.`id_region` = :RegionID');
      SQL.Add('ORDER BY E.`����` DESC');
    end;

    Open;
  end;
end;

procedure TfrmObInputZahid.BeforeDestruct;
begin

end;

procedure TfrmObInputZahid.Button1Click(Sender: TObject);
begin
  inherited;
  myForm.CreateNewFrame(TfrmObNewZahid, Sender);
  myForm.TimerBlink.Enabled := true;
end;

end.
