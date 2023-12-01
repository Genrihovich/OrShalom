unit uFrameDovidniky;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,

  uFrameCustom, Vcl.ComCtrls, sPanel, Vcl.ExtCtrls, sFrameAdapter,
  System.Generics.Collections, Vcl.StdCtrls, Vcl.Buttons, DBGridEhGrouping,
  ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, EhLibVCL, GridsEh, DBAxisGridsEh,
  DBGridEh, JvFormPlacement, JvAppStorage, JvComponentBase, JvAppIniStorage,
  sBitBtn;

type
  TfrmDovidniky = class(TCustomInfoFrame)
    sGradientPanel1: TsGradientPanel;
    sPanel1: TsPanel;
    btnImport: TBitBtn;
    DBGridEh1: TDBGridEh;
    BitBtn1: TBitBtn;
    dbGridTraining: TDBGridEh;
    Splitter1: TSplitter;
    btnTraining: TsBitBtn;
    procedure btnImportClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure sGradientPanel1Click(Sender: TObject);
    procedure btnTrainingClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses uMyExcel, uDM, uMainForm, myBDUtils;

procedure TfrmDovidniky.BitBtn1Click(Sender: TObject);
begin
  inherited;
  CleanOutTable('ZvitSnow');
  // DM.tZvitSnow.RefreshRecord;
  DBGridEh1.DataSource := nil;
  DM.tZvitSnow.Active := false;
  DM.tZvitSnow.Active := true;
  DBGridEh1.DataSource := DM.dsZvit;
end;

procedure TfrmDovidniky.btnImportClick(Sender: TObject);
var
  m, n, col, z, i: integer;
  CollectionNameTable: TDictionary<string, integer>;
  pole: String;
  poleDate: TDateTime;
  buttonSelected: integer;
  temp: Word;
begin
  try // ������ �������� ������ ������
    DBGridEh1.DataSource := nil;

    if uMyExcel.RunExcel(false, false) = true then
      // �������� �� ������� � ������ Excel
      DM.OpenDialog.Filter := '����� MS Excel|*.xls;*.xlsx|';
    if not DM.OpenDialog.Execute then
      Exit;

    if uMyExcel.OpenWorkBook(DM.OpenDialog.FileName, false) then
    // ��������� ����� Excel
    begin
      myForm.ProgressBar.Visible := true;
      MyExcel.ActiveWorkBook.Sheets[1];

      col := MyExcel.ActiveCell.SpecialCells($000000B).Column;
      // ��������� ����������� �������
      // ------------ ���������� ��������� ������� �������� �������� -------------

      CollectionNameTable := TDictionary<string, integer>.Create();
      for z := 1 to col do
      begin
        if not CollectionNameTable.ContainsKey(MyExcel.Cells[1, z].value) then
          CollectionNameTable.Add(MyExcel.Cells[1, z].value, z)
        else
          CollectionNameTable.Add(MyExcel.Cells[1, z].value + z.ToString, z);
      end;
      // ------------------------ ����� ������� ���  �������� --------------------

      m := 2; // �������� ���������� �� 2-� ������, �������� ��������� �������
      n := MyExcel.ActiveCell.SpecialCells($000000B).Row;
      // ��������� ����������� ������
      n := n + 1;
      with DM, myForm do
      begin
        tZvitSnow.open;
        // CleanOutTable('ZvitSnow'); // �������� �������
        tZvitSnow.Last;

        ProgressBar.Min := 0;
        ProgressBar.Max := n;
        ProgressBar.Position := 1;

        while m <> n do // ���� ������� �� ������� EXCEL
        begin

          pole := MyExcel.Cells
            [m, StrToInt(CollectionNameTable.Items['�����'].ToString)].value;

          if not isAssetValue('ZvitSnow', 'Number', pole) then
          begin

            tZvitSnow.Insert;

            tZvitSnow.FieldByName('Number').AsString :=
              MyExcel.Cells
              [m, StrToInt(CollectionNameTable.Items['�����'].ToString)].value;

            tZvitSnow.FieldByName('JDCID').AsString :=
              MyExcel.Cells
              [m, StrToInt(CollectionNameTable.Items['JDC ID'].ToString)].value;

            tZvitSnow.FieldByName('Kontakt').AsString :=
              MyExcel.Cells
              [m, StrToInt(CollectionNameTable.Items['�������� ��������']
              .ToString)].value;

            poleDate := MyExcel.Cells
              [m, StrToInt(CollectionNameTable.Items['���� ��������']
              .ToString)].value;

            tZvitSnow.FieldByName('DateKontakta').AsDateTime := poleDate;

            tZvitSnow.FieldByName('Tema').AsString :=
              MyExcel.Cells
              [m, StrToInt(CollectionNameTable.Items['���� ��������']
              .ToString)].value;

            tZvitSnow.FieldByName('TypeKontakta').AsString :=
              MyExcel.Cells
              [m, StrToInt(CollectionNameTable.Items['��� ��������']
              .ToString)].value;

            tZvitSnow.FieldByName('Sostoyalsya').AsString :=
              MyExcel.Cells
              [m, StrToInt(CollectionNameTable.Items['���������']
              .ToString)].value;

            tZvitSnow.FieldByName('Ispolnitel').AsString :=
              MyExcel.Cells
              [m, StrToInt(CollectionNameTable.Items['�����������']
              .ToString)].value;

            tZvitSnow.FieldByName('Telephone').AsString :=
              MyExcel.Cells
              [m, StrToInt(CollectionNameTable.Items['��������� �������']
              .ToString)].value;

            tZvitSnow.FieldByName('Kurator').AsString :=
              MyExcel.Cells
              [m, StrToInt(CollectionNameTable.Items['�������']
              .ToString)].value;

            tZvitSnow.FieldByName('monthDate').AsString :=
              FormatDateTime('mm', poleDate);

            tZvitSnow.FieldByName('YearDate').AsString :=
              FormatDateTime('yyyy', poleDate);

            tZvitSnow.Post;
            Inc(m);
            // Application.ProcessMessages;
            Sleep(25);
            ProgressBar.Position := m;
          end
          else
          begin

            // MyExcel.Application.DisplayAlerts := false;
            // StopExcel;
            // CollectionNameTable.Clear;
            // CollectionNameTable.Free;
            ShowMessage('����� ' + pole + ' ��� � � ���');

            { with CreateMessageDialog('����� '+ pole +' ��� � � ���', mtConfirmation,
              [mbYes,mbAll,mbCancel]) do
              begin
              try
              for i := 0 to componentcount - 1 do
              begin
              if components[i].classname = 'TButton' then
              begin
              if (components[i] as TButton).modalResult = mrYes then (components[i] as TButton).caption := 'OldYes';
              if (components[i] as TButton).modalResult = mrCancel then (components[i] as TButton).caption := 'OldmrCancel';
              if (components[i] as TButton).modalResult = mrAll then (components[i] as TButton).caption := 'OldmrAll';
              end;
              end;
              Caption := '���� �������';
              ShowModal;



              finally
              Release;
              end;
              end;
              if buttonSelected = mrYes  then  ShowMessage('���� ������ OK');
              if buttonSelected = mrCancel
              then ShowMessage('���� ������ Cancel');
              if buttonSelected = mrAll then
              ShowMessage('���� ������ All'); }

            { temp:=MessageBox(handle, PChar('����� '+ pole +' ��� � � ���'), PChar('��������� ������!'), MB_YESNO+MB_ICONQUESTION);
              case temp of
              idyes: ShowMessage('���� ������ OK');
              idno: ShowMessage('���� ������ No');
              end; }

            // with MessageDlg('����� '+ pole +' ��� � � ���',mtCustom,
            // [mbYes,mbAll,mbCancel], 0) do
            // begin
            //
            // try
            // for i := 0 to componentcount - 1 do
            // begin
            // if components[i].classname = 'TButton' then
            // if (components[i] as TButton).modalResult = mrYes then (components[i] as TButton).caption := 'OldYes';
            // if (components[i] as TButton).modalResult = mrCancel then (components[i] as TButton).caption := 'OldmrCancel';
            // if (components[i] as TButton).modalResult = mrAll then (components[i] as TButton).caption := 'OldmrAll';
            // end;
            // finally
            // Release;
            // end;
            // end;
            // buttonSelected := MessageDlg('����� '+ pole +' ��� � � ���',mtCustom,
            // [mbYes,mbAll,mbCancel], 0);
            // if buttonSelected = mrYes  then  ShowMessage('���� ������ OK');
            // if buttonSelected = mrCancel then ShowMessage('���� ������ Cancel');
            // if buttonSelected = mrAll then ShowMessage('���� ������ All');

            // if buttonSelected = mrYes  then  ShowMessage('���� ������ OK');
            // if buttonSelected = mrCancel then ShowMessage('���� ������ Cancel');
            // if buttonSelected = mrAll then ShowMessage('���� ������ All');

            // myForm.ProgressBar.Visible := false;
            // DM.tZvitSnow.RefreshRecord;
            // Exit;
            Inc(m);
          end;

        end;
      end;

      ShowMessage('������������ ����� ��ϲ���!!!');
    end;

    MyExcel.Application.DisplayAlerts := false;
    StopExcel;
    CollectionNameTable.Clear;
    CollectionNameTable.Free;
    // DM.tZvitSnow.Active := false;
    myForm.ProgressBar.Visible := false;
    DM.tZvitSnow.RefreshRecord;
    DBGridEh1.DataSource := DM.dsZvit;
  except
    on E: EListError do
    begin
      CollectionNameTable.Free;
      // CleanOutTable('ZvitSnow'); // �������� �������
      DM.tZvitSnow.Active := false;
      ShowMessage('�� ����� ������ �����, ���� ���������� ����');
      StopExcel;
      DBGridEh1.DataSource := DM.dsZvit;
    end;

  end;

end;

procedure TfrmDovidniky.btnTrainingClick(Sender: TObject);
var
  m, n, col, z, i: integer;
  CollectionNameTable: TDictionary<string, integer>;
  poleDate: TDate;
  pole: String;
  pdate, pMentor, pCount, pOrg, pOrganiz, pNote: String;
begin
  inherited; // ������ �������
  try
    begin
      dbGridTraining.DataSource := nil;

      if uMyExcel.RunExcel(false, false) = true then
        // �������� �� ������� � ������ Excel
        DM.OpenDialog.Filter := '����� MS Excel|*.xls;*.xlsx|';
      if not DM.OpenDialog.Execute then
        Exit;
      // ��������� ����� Excel
      if uMyExcel.OpenWorkBook(DM.OpenDialog.FileName, false) then

      begin

        myForm.ProgressBar.Visible := true;
        MyExcel.ActiveWorkBook.Sheets[1];

        // ��������� ����������� �������
        col := MyExcel.ActiveCell.SpecialCells($000000B).Column;

        // ------------ ���������� ��������� ������� �������� �������� -------------

        CollectionNameTable := TDictionary<string, integer>.Create();
        for z := 1 to col do
        begin
          if not CollectionNameTable.ContainsKey(MyExcel.Cells[1, z].value) then
            CollectionNameTable.Add(MyExcel.Cells[1, z].value, z)
          else
            CollectionNameTable.Add(MyExcel.Cells[1, z].value + z.ToString, z);
        end;

        m := 2; // �������� ���������� �� 2-� ������, �������� ��������� �������
        n := MyExcel.ActiveCell.SpecialCells($000000B).Row;
        // ��������� ����������� ������
        n := n + 1;
        with DM, myForm do
        begin

          tTraining.open;
          // CleanOutTable('ZvitSnow'); // �������� �������
          tTraining.Last;

          ProgressBar.Min := 0;
          ProgressBar.Max := n;
          ProgressBar.Position := 1;

          while m <> n do // ���� ������� �� ������� EXCEL
          begin
            pole := MyExcel.Cells
              [m, StrToInt(CollectionNameTable.Items['�������� �����������']
              .ToString)].value;

            if pole = '����� ���� - �����������' then
            begin

              pdate := MyExcel.Cells
                [m, StrToInt(CollectionNameTable.Items['����'].ToString)].value;
              pMentor := MyExcel.Cells
                [m, StrToInt(CollectionNameTable.Items['��� �������� ��������']
                .ToString)].value;
              pCount := MyExcel.Cells
                [m, StrToInt(CollectionNameTable.Items['���������� ���������']
                .ToString)].value;
              pOrg := MyExcel.Cells
                [m, StrToInt(CollectionNameTable.Items['��� �����������']
                .ToString)].value;
              pOrganiz := MyExcel.Cells
                [m, StrToInt(CollectionNameTable.Items['�������� �����������']
                .ToString)].value;
              pNote := MyExcel.Cells
                [m, StrToInt(CollectionNameTable.Items['����������']
                .ToString)].value;

              if isAssetValues('Training', pdate, pMentor, pCount, pOrg,
                pOrganiz, pNote) <> true then
              begin

                tTraining.Insert;

                poleDate := MyExcel.Cells
                  [m, StrToInt(CollectionNameTable.Items['����']
                  .ToString)].value;

                tTraining.FieldByName('date_training').AsString :=
                  DatetoStr(poleDate);

                tTraining.FieldByName('Mentor').AsString :=
                  MyExcel.Cells
                  [m, StrToInt(CollectionNameTable.Items
                  ['��� �������� ��������'].ToString)].value;

                tTraining.FieldByName('Count_trained').AsInteger :=
                  MyExcel.Cells
                  [m, StrToInt(CollectionNameTable.Items['���������� ���������']
                  .ToString)].value;

                tTraining.FieldByName('Note_Tema').AsString :=
                  MyExcel.Cells
                  [m, StrToInt(CollectionNameTable.Items['����������']
                  .ToString)].value;

                tTraining.FieldByName('Organization').AsString :=
                  MyExcel.Cells
                  [m, StrToInt(CollectionNameTable.Items['�������� �����������']
                  .ToString)].value;

                tTraining.FieldByName('type_org').AsString :=
                  MyExcel.Cells
                  [m, StrToInt(CollectionNameTable.Items['��� �����������']
                  .ToString)].value;

                tTraining.Post;
                Inc(m);
                // Application.ProcessMessages;
                Sleep(25);
                ProgressBar.Position := m;
              end
              else
              begin
              ShowMessage('���� ��� � � ���');
              Inc(m);
              ProgressBar.Position := m;
              end;

            end;

          end;

        end;

      end;

    end;
    ShowMessage('������������ ����� ��ϲ���!!!');

    MyExcel.Application.DisplayAlerts := false;
    StopExcel;
    CollectionNameTable.Clear;
    CollectionNameTable.Free;
    // DM.tZvitSnow.Active := false;
    myForm.ProgressBar.Visible := false;
    DM.tTraining.RefreshRecord;
    dbGridTraining.DataSource := DM.dsTraining;

  except
    on E: Exception do
    begin
      CollectionNameTable.Free;
      // CleanOutTable('ZvitSnow'); // �������� �������
      DM.tTraining.Active := false;
      ShowMessage('�� ����� ������ �����, ���� ���������� ����');
      StopExcel;
      dbGridTraining.DataSource := DM.dsTraining;
    end;
  end;

end;

procedure TfrmDovidniky.sGradientPanel1Click(Sender: TObject);
begin
  inherited;
  BitBtn1.Enabled := true;
end;

end.
