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
  try // Імпорт контактів травма центру
    DBGridEh1.DataSource := nil;

    if uMyExcel.RunExcel(false, false) = true then
      // проверка на инсталл и запуск Excel
      DM.OpenDialog.Filter := 'Файлы MS Excel|*.xls;*.xlsx|';
    if not DM.OpenDialog.Execute then
      Exit;

    if uMyExcel.OpenWorkBook(DM.OpenDialog.FileName, false) then
    // відкриваємо книгу Excel
    begin
      myForm.ProgressBar.Visible := true;
      MyExcel.ActiveWorkBook.Sheets[1];

      col := MyExcel.ActiveCell.SpecialCells($000000B).Column;
      // последняя заполненная колонка
      // ------------ пробежимся расставим индексы названий столбцов -------------

      CollectionNameTable := TDictionary<string, integer>.Create();
      for z := 1 to col do
      begin
        if not CollectionNameTable.ContainsKey(MyExcel.Cells[1, z].value) then
          CollectionNameTable.Add(MyExcel.Cells[1, z].value, z)
        else
          CollectionNameTable.Add(MyExcel.Cells[1, z].value + z.ToString, z);
      end;
      // ------------------------ конец пробега для СТОЛБЦОВ --------------------

      m := 2; // начинаем считывание со 2-й строки, оставляя заголовок колонки
      n := MyExcel.ActiveCell.SpecialCells($000000B).Row;
      // последняя заполненная строка
      n := n + 1;
      with DM, myForm do
      begin
        tZvitSnow.open;
        // CleanOutTable('ZvitSnow'); // обнуляем таблицу
        tZvitSnow.Last;

        ProgressBar.Min := 0;
        ProgressBar.Max := n;
        ProgressBar.Position := 1;

        while m <> n do // цикл внешний по записям EXCEL
        begin

          pole := MyExcel.Cells
            [m, StrToInt(CollectionNameTable.Items['Номер'].ToString)].value;

          if not isAssetValue('ZvitSnow', 'Number', pole) then
          begin

            tZvitSnow.Insert;

            tZvitSnow.FieldByName('Number').AsString :=
              MyExcel.Cells
              [m, StrToInt(CollectionNameTable.Items['Номер'].ToString)].value;

            tZvitSnow.FieldByName('JDCID').AsString :=
              MyExcel.Cells
              [m, StrToInt(CollectionNameTable.Items['JDC ID'].ToString)].value;

            tZvitSnow.FieldByName('Kontakt').AsString :=
              MyExcel.Cells
              [m, StrToInt(CollectionNameTable.Items['Участник контакта']
              .ToString)].value;

            poleDate := MyExcel.Cells
              [m, StrToInt(CollectionNameTable.Items['Дата контакта']
              .ToString)].value;

            tZvitSnow.FieldByName('DateKontakta').AsDateTime := poleDate;

            tZvitSnow.FieldByName('Tema').AsString :=
              MyExcel.Cells
              [m, StrToInt(CollectionNameTable.Items['Тема контакта']
              .ToString)].value;

            tZvitSnow.FieldByName('TypeKontakta').AsString :=
              MyExcel.Cells
              [m, StrToInt(CollectionNameTable.Items['Тип контакта']
              .ToString)].value;

            tZvitSnow.FieldByName('Sostoyalsya').AsString :=
              MyExcel.Cells
              [m, StrToInt(CollectionNameTable.Items['Состояние']
              .ToString)].value;

            tZvitSnow.FieldByName('Ispolnitel').AsString :=
              MyExcel.Cells
              [m, StrToInt(CollectionNameTable.Items['Исполнители']
              .ToString)].value;

            tZvitSnow.FieldByName('Telephone').AsString :=
              MyExcel.Cells
              [m, StrToInt(CollectionNameTable.Items['Мобильный телефон']
              .ToString)].value;

            tZvitSnow.FieldByName('Kurator').AsString :=
              MyExcel.Cells
              [m, StrToInt(CollectionNameTable.Items['Куратор']
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
            ShowMessage('Номер ' + pole + ' вже є в базі');

            { with CreateMessageDialog('Номер '+ pole +' вже є в базі', mtConfirmation,
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
              Caption := 'Вибір варіанта';
              ShowModal;



              finally
              Release;
              end;
              end;
              if buttonSelected = mrYes then ShowMessage('Была нажата OK');
              if buttonSelected = mrCancel
              then ShowMessage('Была нажата Cancel');
              if buttonSelected = mrAll then
              ShowMessage('Была нажата All'); }

            { temp:=MessageBox(handle, PChar('Номер '+ pole +' вже є в базі'), PChar('Обдумайте прежде!'), MB_YESNO+MB_ICONQUESTION);
              case temp of
              idyes: ShowMessage('Была нажата OK');
              idno: ShowMessage('Была нажата No');
              end; }

            // with MessageDlg('Номер '+ pole +' вже є в базі',mtCustom,
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
            // buttonSelected := MessageDlg('Номер '+ pole +' вже є в базі',mtCustom,
            // [mbYes,mbAll,mbCancel], 0);
            // if buttonSelected = mrYes then ShowMessage('Была нажата OK');
            // if buttonSelected = mrCancel then ShowMessage('Была нажата Cancel');
            // if buttonSelected = mrAll then ShowMessage('Была нажата All');

            // if buttonSelected = mrYes then ShowMessage('Была нажата OK');
            // if buttonSelected = mrCancel then ShowMessage('Была нажата Cancel');
            // if buttonSelected = mrAll then ShowMessage('Была нажата All');

            // myForm.ProgressBar.Visible := false;
            // DM.tZvitSnow.RefreshRecord;
            // Exit;
            Inc(m);
          end;

        end;
      end;

      ShowMessage('Завантаження даних УСПІШНО!!!');
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
      // CleanOutTable('ZvitSnow'); // обнуляем таблицу
      DM.tZvitSnow.Active := false;
      ShowMessage('Не вірний формат файлу, нема необхідних полів');
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
  inherited; // Імпорт тренінгів
  try
    begin
      dbGridTraining.DataSource := nil;

      if uMyExcel.RunExcel(false, false) = true then
        // проверка на инсталл и запуск Excel
        DM.OpenDialog.Filter := 'Файлы MS Excel|*.xls;*.xlsx|';
      if not DM.OpenDialog.Execute then
        Exit;
      // открываем книгу Excel
      if uMyExcel.OpenWorkBook(DM.OpenDialog.FileName, false) then

      begin

        myForm.ProgressBar.Visible := true;
        MyExcel.ActiveWorkBook.Sheets[1];

        // последняя заполненная колонка
        col := MyExcel.ActiveCell.SpecialCells($000000B).Column;

        // ------------ пробежимся расставим индексы названий столбцов -------------

        CollectionNameTable := TDictionary<string, integer>.Create();
        for z := 1 to col do
        begin
          if not CollectionNameTable.ContainsKey(MyExcel.Cells[1, z].value) then
            CollectionNameTable.Add(MyExcel.Cells[1, z].value, z)
          else
            CollectionNameTable.Add(MyExcel.Cells[1, z].value + z.ToString, z);
        end;

        m := 2; // начинаем считывание со 2-й строки, оставляя заголовок колонки
        n := MyExcel.ActiveCell.SpecialCells($000000B).Row;
        // последняя заполненная строка
        n := n + 1;
        with DM, myForm do
        begin

          tTraining.open;
          // CleanOutTable('ZvitSnow'); // обнуляем таблицу
          tTraining.Last;

          ProgressBar.Min := 0;
          ProgressBar.Max := n;
          ProgressBar.Position := 1;

          while m <> n do // цикл внешний по записям EXCEL
          begin
            pole := MyExcel.Cells
              [m, StrToInt(CollectionNameTable.Items['Основная организация']
              .ToString)].value;

            if pole = 'Хесед Бешт - Хмельницкий' then
            begin

              pdate := MyExcel.Cells
                [m, StrToInt(CollectionNameTable.Items['Дата'].ToString)].value;
              pMentor := MyExcel.Cells
                [m, StrToInt(CollectionNameTable.Items['Кто проводил обучение']
                .ToString)].value;
              pCount := MyExcel.Cells
                [m, StrToInt(CollectionNameTable.Items['Количество обученных']
                .ToString)].value;
              pOrg := MyExcel.Cells
                [m, StrToInt(CollectionNameTable.Items['Тип организации']
                .ToString)].value;
              pOrganiz := MyExcel.Cells
                [m, StrToInt(CollectionNameTable.Items['Основная организация']
                .ToString)].value;
              pNote := MyExcel.Cells
                [m, StrToInt(CollectionNameTable.Items['Примечание']
                .ToString)].value;

              if isAssetValues('Training', pdate, pMentor, pCount, pOrg,
                pOrganiz, pNote) <> true then
              begin

                tTraining.Insert;

                poleDate := MyExcel.Cells
                  [m, StrToInt(CollectionNameTable.Items['Дата']
                  .ToString)].value;

                tTraining.FieldByName('date_training').AsString :=
                  DatetoStr(poleDate);

                tTraining.FieldByName('Mentor').AsString :=
                  MyExcel.Cells
                  [m, StrToInt(CollectionNameTable.Items
                  ['Кто проводил обучение'].ToString)].value;

                tTraining.FieldByName('Count_trained').AsInteger :=
                  MyExcel.Cells
                  [m, StrToInt(CollectionNameTable.Items['Количество обученных']
                  .ToString)].value;

                tTraining.FieldByName('Note_Tema').AsString :=
                  MyExcel.Cells
                  [m, StrToInt(CollectionNameTable.Items['Примечание']
                  .ToString)].value;

                tTraining.FieldByName('Organization').AsString :=
                  MyExcel.Cells
                  [m, StrToInt(CollectionNameTable.Items['Основная организация']
                  .ToString)].value;

                tTraining.FieldByName('type_org').AsString :=
                  MyExcel.Cells
                  [m, StrToInt(CollectionNameTable.Items['Тип организации']
                  .ToString)].value;

                tTraining.Post;
                Inc(m);
                // Application.ProcessMessages;
                Sleep(25);
                ProgressBar.Position := m;
              end
              else
              begin
                ShowMessage('Данні вже є в базі');
                Inc(m);
                ProgressBar.Position := m;
              end;

            end;

          end;

        end;

      end;

    end;
    ShowMessage('Завантаження даних УСПІШНО!!!');

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
      // CleanOutTable('ZvitSnow'); // обнуляем таблицу
      DM.tTraining.Active := false;
      ShowMessage('Не вірний формат файлу, нема необхідних полів');
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
