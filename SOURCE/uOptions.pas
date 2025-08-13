unit uOptions;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uFrameCustom, Vcl.ExtCtrls, sPanel,
  sFrameAdapter, Uni, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, Vcl.StdCtrls, sLabel, EhLibVCL, GridsEh, DBAxisGridsEh, DBGridEh, DB,
  sListBox, System.UITypes;

type
  TfrmOption = class(TCustomInfoFrame)
    pRegion: TsPanel;
    dbGridRegion: TDBGridEh;
    dbGridKurators: TDBGridEh;
    pRoll: TsPanel;
    dbGridUsers: TDBGridEh;
    lbRole: TsListBox;
    sLabelFX1: TsLabelFX;
    sLabelFX2: TsLabelFX;
    btnClearEvent: TButton;
    sPanel1: TsPanel;
    sPanel2: TsPanel;
    sPanel3: TsPanel;
    procedure dbGridRegionDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure dbGridRegionDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure dbGridKuratorsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure dbGridUsersDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure dbGridUsersDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure btnClearEventClick(Sender: TObject);
  private
    { Private declarations }

  public
    { Public declarations }
        procedure AfterCreation; override;
    procedure BeforeDestruct; override;
  end;

var
  frmOption: TfrmOption;

implementation

{$R *.dfm}

uses uDM;

procedure TfrmOption.AfterCreation;
begin
  inherited;
    dbGridRegion.OnDragOver := dbGridRegionDragOver;
  dbGridRegion.OnDragDrop := dbGridRegionDragDrop;
  // drag&drop Option
  lbRole.DragMode := dmAutomatic;
  with DM do
  begin
    qUser_option.Close;
    qUser_option.Open;
  end;
end;

procedure TfrmOption.BeforeDestruct;
begin
  inherited;

end;

procedure TfrmOption.btnClearEventClick(Sender: TObject);
var
  Q: TUniQuery;
begin
  if MessageDlg('�� ����� ������ �������� �� ������ � ������� ���?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    Q := TUniQuery.Create(nil);
    try
      Q.Connection := DM.UniConnection;

      // ��������� ������ �� EventClients
      Q.SQL.Text := 'DELETE FROM EventClients';
      Q.ExecSQL;

      // ��������� ������ �� Events
      Q.SQL.Text := 'DELETE FROM Events';
      Q.ExecSQL;

      // �������� AUTO_INCREMENT ��� ������� Events
      Q.SQL.Text := 'ALTER TABLE Events AUTO_INCREMENT = 1';
      Q.ExecSQL;

      // (�������) �������� AUTO_INCREMENT ��� ������� EventClients, ���� ��� � ��� ID
      // Q.SQL.Text := 'ALTER TABLE EventClients AUTO_INCREMENT = 1';
      // Q.ExecSQL;

      // ��������� DBGridEh (���� ���������� �� ������)
    {  if Assigned(qEventList) then
      begin
        qEventList.Close;
        qEventList.Open;
      end; }

      ShowMessage('��� ������ �������.');
    finally
      Q.Free;
    end;
  end;
end;

procedure TfrmOption.dbGridKuratorsMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
    if Button = mbLeft then
    dbGridKurators.BeginDrag(False);
end;

procedure TfrmOption.dbGridRegionDragDrop(Sender, Source: TObject; X,
  Y: Integer);
var
  KuratorID: string;
  RegionID: Integer;
  Q: TUniQuery;
  Cell: TGridCoord;
  Bookmark: TBookmark;
begin
 if Source = dbGridKurators then
  begin
    // �������� JDC ID � �������� ������
    KuratorID := dbGridKurators.DataSource.DataSet.FieldByName('JDC ID').AsString;

    // ��������� ������� � ���
    Cell := dbGridRegion.MouseCoord(X, Y);

    // ����������, �� ��������� � ����� ����� (�����)
    if (Cell.Y >= 1) and (Cell.Y <= dbGridRegion.DataSource.DataSet.RecordCount) then
    begin
      // �������� ������� ������� (�� ������ �������)
      Bookmark := dbGridRegion.DataSource.DataSet.GetBookmark;
      try
        // ���������� �� ���������� ������
        dbGridRegion.DataSource.DataSet.First;
        dbGridRegion.DataSource.DataSet.MoveBy(Cell.Y - 1);

        // �������� ID ������
        RegionID := dbGridRegion.DataSource.DataSet.FieldByName('id_region').AsInteger;

        // ��������� � ���
        Q := TUniQuery.Create(nil);
        try
          Q.Connection := DM.UniConnection;
          Q.SQL.Text := 'UPDATE Region SET id_Kurator = :kurator WHERE id_region = :region';
          Q.ParamByName('kurator').AsString := KuratorID;
          Q.ParamByName('region').AsInteger := RegionID;
          Q.ExecSQL;
        finally
          Q.Free;
        end;

        // ������� �����������
        dbGridRegion.DataSource.DataSet.Refresh;
      finally
        dbGridRegion.DataSource.DataSet.GotoBookmark(Bookmark);
        dbGridRegion.DataSource.DataSet.FreeBookmark(Bookmark);
      end;
    end;
  end;
end;

procedure TfrmOption.dbGridRegionDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  inherited;
  Accept := (Source = dbGridKurators); // �������� ���� �� ��������
end;



procedure TfrmOption.dbGridUsersDragDrop(Sender, Source: TObject; X,
  Y: Integer);
var
  RoleIndex: Integer;
  Grid: TDBGridEh;
  Bookmark: TBookmark;
  TargetRow: Integer;
  //TargetRec: Integer;
begin
  if Source = lbRole then
  begin
    RoleIndex := lbRole.ItemIndex;
    if RoleIndex < 0 then Exit;

    Grid := dbGridUsers;

    // �������� ������� �������
    Bookmark := Grid.DataSource.DataSet.GetBookmark;
    try
      // ��������� ���������� ���� � ������� ����
      TargetRow := Grid.MouseCoord(X, Y).Y;

      // ���� ������ ����� ���������
      if TargetRow > 0 then
      begin
        // �������� ��������� ����� ������
//        TargetRec := Grid.DataSource.DataSet.RecNo;

        // ����������� �� �������� �����
        Grid.DataSource.DataSet.MoveBy(TargetRow - 1);

        // ��������� ���� Role
        Grid.DataSource.DataSet.Edit;
        Grid.DataSource.DataSet.FieldByName('Role').AsInteger := RoleIndex;
        Grid.DataSource.DataSet.Post;
      end;
    finally
      Grid.DataSource.DataSet.GotoBookmark(Bookmark);
      Grid.DataSource.DataSet.FreeBookmark(Bookmark);
    end;
  end;
end;

procedure TfrmOption.dbGridUsersDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  Accept := Source = lbRole;  // �������� ����� ������������� � lbRole
end;

end.
