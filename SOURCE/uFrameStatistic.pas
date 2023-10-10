unit uFrameStatistic;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uFrameCustom,
  sFrameAdapter,
  Vcl.StdCtrls, sLabel, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, EhLibVCL, GridsEh, DBAxisGridsEh, DBGridEh, Vcl.ComCtrls, Vcl.Mask,
  sMaskEdit, sCustomComboEdit, sToolEdit, Vcl.ExtCtrls, sPanel, Vcl.Buttons,
  Vcl.Grids, JvExGrids, JvStringGrid, System.Actions, Vcl.ActnList;

type
  TfrmStatistic = class(TCustomInfoFrame)
    sPanel1: TsPanel;
    sPanel2: TsPanel;
    sLabelFX1: TsLabelFX;
    sLabelFX2: TsLabelFX;
    sPanel3: TsPanel;
    DBGridEh1: TDBGridEh;
    sDateEdit3: TsDateEdit;
    sDateEdit4: TsDateEdit;
    btnCalck: TBitBtn;
    StringGrid: TJvStringGrid;
    ActionList1: TActionList;
    acCalck: TAction;
    Label1: TLabel;
    Splitter1: TSplitter;
    BitBtn1: TBitBtn;
    procedure sDateEdit3Change(Sender: TObject);
    procedure sDateEdit4Change(Sender: TObject);
    procedure btnCalckClick(Sender: TObject);
    procedure acCalckUpdate(Sender: TObject);
    procedure StringGridDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }

  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses uDM, myBDUtils, myUtils, WinProcs, DateUtils;

procedure TfrmStatistic.sDateEdit3Change(Sender: TObject);
begin
  inherited;

  sDateEdit4.Date := EncodeDate(YearOf(sDateEdit3.Date),
    MonthOf(sDateEdit3.Date), DaysInMonth(sDateEdit3.Date));


  DM.qCountQuery.Active := False;
  DM.qCountQuery.Params.ParamByName('ot').Value := sDateEdit3.Date;
  DM.qCountQuery.Params.ParamByName('do').Value := sDateEdit4.Date;
  DM.qCountQuery.Active := True;
end;

procedure TfrmStatistic.sDateEdit4Change(Sender: TObject);
begin
  inherited;
  DM.qCountQuery.Active := False;
  DM.qCountQuery.Params.ParamByName('do').Value := sDateEdit4.Date;
  DM.qCountQuery.Active := True;
end;

procedure TfrmStatistic.StringGridDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
  text: string;
  Format: Word;
begin
  inherited;

  text := StringGrid.Cells[ACol, ARow];
  StringGrid.Canvas.Brush.Color := clWindow;
  StringGrid.Canvas.FillRect(Rect);

 // if ACol = 3 then Font.Style := [fsBold];
  if ((Acol= 3)) then
  begin
   StringGrid.Canvas.Brush.Color:=clCream;
   StringGrid.Canvas.Font.Style := StringGrid.Canvas.Font.Style + [fsBold];
//     StringGrid.Canvas.FillRect(Rect);
//  StringGrid.Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, StringGrid.Cells[ACol, ARow]);
  end;

  if ACol >= 3 then
    Format := DT_CENTER or DT_VCENTER or DT_SINGLELINE
    // ������ ������� - ��������� ������ �� ������
  else
    Format := DT_LEFT or DT_VCENTER or DT_SINGLELINE;

  if (ARow mod 2 = 0) and (ACol = 1) then
    Format := DT_RIGHT or DT_VCENTER or DT_SINGLELINE;

  StringGrid.Canvas.FillRect(Rect);
  DrawText(StringGrid.Canvas.Handle, PChar(text), Length(text), Rect, Format);



  // if ARow = 0 then
  // Format := DT_CENTER or DT_VCENTER or DT_SINGLELINE; // ������ ������ � ��������� ������ �� ������

  // StringGrid.Canvas.FillRect(Rect); // ����������� ������
  // StrPCopy(C, StringGrid.Cells[ACol, ARow]); // �������������� ������ � ������ PChar
  // WinProcs.DrawText(StringGrid.Canvas.Handle, C, StrLen(C), Rect, Format); // ����� ������
end;

procedure TfrmStatistic.acCalckUpdate(Sender: TObject);
begin
  inherited;
  if ( { (sDateEdit3.Date <> nil) and (sDateEdit4.Date <> '') or }
    (sDateEdit3.text <> sDateEdit4.text)) then
    btnCalck.Enabled := True
  else
    btnCalck.Enabled := False;
end;

procedure TfrmStatistic.BitBtn1Click(Sender: TObject);
begin
  inherited;
//StringGrid.Save(ExtractFilePath(Application.ExeName) +'1111.xlsx');
end;

procedure TfrmStatistic.btnCalckClick(Sender: TObject);
var
  Temas, Ispolnitel: TStringList;
  i, j, row, col, sum: Integer;
  tema, ispolnit, vid, nachalo, konec, fCount, pType: string;
begin // �����������
  inherited;
  nachalo := sDateEdit3.text;
  konec := sDateEdit4.text;

  StringGrid.ColCount := 4;
  StringGrid.RowCount := 2;
  // ------------------- ������ ������������ -------------------------
  Ispolnitel := TStringList.Create;
  Ispolnitel.CommaText := SpisokPoley('ZvitSnow', 'Ispolnitel');

  // ��������� �����
  StringGrid.Cells[0, 0] := '�';
  StringGrid.Cells[1, 0] := '��������';
  StringGrid.Cells[2, 0] := '�� ���.';

  StringGrid.Cells[3, 0] := FormatDateTime('mmmm', sDateEdit3.Date);
  row := 4;
  Application.ProcessMessages;

  for i := 0 to Ispolnitel.Count - 1 do
  begin

    StringGrid.Cells[row, 0] := Ispolnitel[i]; // ��� �����������
    StringGrid.ColCount := StringGrid.ColCount + 1; // �������� �������
    inc(row);
    Application.ProcessMessages;
  end;

  // --------------- ������ ��� -----------------------
  Temas := TStringList.Create;
  Temas.CommaText := SpisokPoley('ZvitSnow', 'Tema');

  i := 1;
  j := 0;

  while i <= Temas.Count * 4 do
  begin
    StringGrid.RowCount := StringGrid.RowCount + 4;
    StringGrid.Cells[1, i] := Temas[j];
    StringGrid.Cells[2, i] := '��������';

    StringGrid.Cells[1, i + 1] := '� �.�. ������';

    StringGrid.Cells[1, i + 2] := Temas[j];
    StringGrid.Cells[2, i + 2] := '���';

    StringGrid.Cells[1, i + 3] := '� �.�. ������';

    inc(i, 4);
    inc(j);
    Application.ProcessMessages;
  end;
  AutoStringGridWidth(StringGrid);

  // --------- �������� ---------------
  col := StringGrid.ColCount;
  row := StringGrid.RowCount;

  // i �������   j ������
  for j := 1 to row - 1 do // -- ������ -- (1 - ������ ��� 0-�����)
  begin
    for i := 4 to col - 1 do // --������� --- (4 - ������ ������������)
    begin
      tema := StringGrid.Cells[1, j];
      ispolnit := StringGrid.Cells[i, 0];
      vid := StringGrid.Cells[2, j];

      if (vid = '') or (vid = '���') then
        Break;

      if (tema <> '') and (ispolnit <> '') then
      begin
        // ��� �������� ������ ������ �������� ���
        if (tema = '� �.�. ������') then
          pType := '������� ������'
        else
          pType := '';

        fCount := CountRecordData(nachalo, konec, ispolnit, tema, pType, False);

        if fCount = '0' then
          StringGrid.Cells[i, j] := ''
        else
        begin
          // ������ ������ ���-�� ���������
          StringGrid.Cells[i, j] := fCount;


          // ������ ������ ���-�� ���������� ���������
          fCount := CountRecordData(nachalo, konec, ispolnit, tema,
            pType, True);
          if fCount <> '0' then
            StringGrid.Cells[i, j + 2] := fCount
          else
            StringGrid.Cells[i, j + 2] := '';


          // ������ ������ ���������
          pType := '������� ������';
          fCount := CountRecordData(nachalo, konec, ispolnit, tema,
            pType, False);
            if fCount <> '0' then
          StringGrid.Cells[i, j + 1] := fCount
          else
          StringGrid.Cells[i, j + 1] := '';


          // ������ ������ ���������� ���������
          if fCount <> '0' then
            fCount := CountRecordData(nachalo, konec, ispolnit, tema,
              pType, True);
          if fCount <> '0' then
          StringGrid.Cells[i, j + 3] := fCount
          else
          StringGrid.Cells[i, j + 3] := '';


          pType := '';
        end;
      end;
    end;
  end;
 Application.ProcessMessages;
  //������������ �����

  for j := 1 to row - 1 do // -- ������ -- (1 - ������ ��� 0-�����)
  begin
    sum := 0;
    for i := 4 to col - 1 do // --������� --- (4 - ������ ������������)
    begin
     if StringGrid.Cells[i, j] <> '' then
      Sum := sum + StringGrid.Cells[i, j].ToInteger();
    end;
    StringGrid.Cells[3, j] := sum.ToString;
  end;


  AutoStringGridWidth(StringGrid);
  Temas.Free;
  Ispolnitel.Free;
  StringGrid.ColWidths[3] := 80;
end;

end.
