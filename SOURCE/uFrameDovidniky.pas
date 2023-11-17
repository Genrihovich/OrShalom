unit uFrameDovidniky;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,

  uFrameCustom, Vcl.ComCtrls, sPanel, Vcl.ExtCtrls, sFrameAdapter,
  System.Generics.Collections, Vcl.StdCtrls, Vcl.Buttons, DBGridEhGrouping,
  ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, EhLibVCL, GridsEh, DBAxisGridsEh,
  DBGridEh, JvFormPlacement, JvAppStorage, JvComponentBase, JvAppIniStorage;

type
  TfrmDovidniky = class(TCustomInfoFrame)
    sGradientPanel1: TsGradientPanel;
    sPanel1: TsPanel;
    btnImport: TBitBtn;
    DBGridEh1: TDBGridEh;
    BitBtn1: TBitBtn;
    procedure btnImportClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure sGradientPanel1Click(Sender: TObject);
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
 DBGridEh1.DataSource:= nil;
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
  buttonSelected : Integer;
  temp:Word;
begin
  try
  DBGridEh1.DataSource:= nil;

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
            ShowMessage('����� '+ pole +' ��� � � ���');



          {  with CreateMessageDialog('����� '+ pole +' ��� � � ���', mtConfirmation,
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
                                        end;}

//          with MessageDlg('����� '+ pole +' ��� � � ���',mtCustom,
//                              [mbYes,mbAll,mbCancel], 0) do
//            begin
//
//              try
//               for i := 0 to componentcount - 1 do
//               begin
//                if components[i].classname = 'TButton' then
//                if (components[i] as TButton).modalResult = mrYes then (components[i] as TButton).caption := 'OldYes';
//                if (components[i] as TButton).modalResult = mrCancel then (components[i] as TButton).caption := 'OldmrCancel';
//                if (components[i] as TButton).modalResult = mrAll then (components[i] as TButton).caption := 'OldmrAll';
//               end;
//              finally
//               Release;
//              end;
//            end;
//            buttonSelected := MessageDlg('����� '+ pole +' ��� � � ���',mtCustom,
//                              [mbYes,mbAll,mbCancel], 0);
//            if buttonSelected = mrYes  then  ShowMessage('���� ������ OK');
//            if buttonSelected = mrCancel then ShowMessage('���� ������ Cancel');
//            if buttonSelected = mrAll then ShowMessage('���� ������ All');

//            if buttonSelected = mrYes  then  ShowMessage('���� ������ OK');
//            if buttonSelected = mrCancel then ShowMessage('���� ������ Cancel');
//            if buttonSelected = mrAll then ShowMessage('���� ������ All');

           // myForm.ProgressBar.Visible := false;
          //  DM.tZvitSnow.RefreshRecord;
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

procedure TfrmDovidniky.sGradientPanel1Click(Sender: TObject);
begin
  inherited;
BitBtn1.Enabled:= true;
end;

end.
