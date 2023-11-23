unit uFrameStatistic;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Winapi.ShellAPI,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uFrameCustom,
  sFrameAdapter, DBGridEhImpExp,
  Vcl.StdCtrls, sLabel, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, EhLibVCL, GridsEh, DBAxisGridsEh, DBGridEh, Vcl.ComCtrls, Vcl.Mask,
  sMaskEdit, sCustomComboEdit, sToolEdit, Vcl.ExtCtrls, sPanel, Vcl.Buttons,
  Vcl.Grids, JvExGrids, JvStringGrid, System.Actions, Vcl.ActnList, Data.DB,
  Vcl.DBGrids;

type
  TfrmStatistic = class(TCustomInfoFrame)
    sPanel1: TsPanel;
    sPanel2: TsPanel;
    sLabelFX1: TsLabelFX;
    sLabelFX2: TsLabelFX;
    sPanel3: TsPanel;
    DBGridEh11: TDBGridEh;
    sDateEdit3: TsDateEdit;
    sDateEdit4: TsDateEdit;
    StringGrid: TJvStringGrid;
    ActionList1: TActionList;
    acCalck: TAction;
    Splitter1: TSplitter;
    btnSave: TBitBtn;
    acSaveExcel: TAction;
    btnCalck: TBitBtn;
    procedure sDateEdit3Change(Sender: TObject);
    procedure sDateEdit4Change(Sender: TObject);
    procedure acCalckUpdate(Sender: TObject);
    procedure StringGridDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure btnSaveClick(Sender: TObject);
    procedure acSaveExcelUpdate(Sender: TObject);
    procedure btnCalckClick(Sender: TObject);

  private
    { Private declarations }

  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses uDM, myBDUtils, myUtils, WinProcs, DateUtils, uMainForm, uMyExcel;

procedure TfrmStatistic.sDateEdit3Change(Sender: TObject);
var
  i: Integer;
begin
  inherited;

  sDateEdit4.Date := EncodeDate(YearOf(sDateEdit3.Date),
    MonthOf(sDateEdit3.Date), DaysInMonth(sDateEdit3.Date));

  Nachalo := sDateEdit3.Date;
  Konec := sDateEdit4.Date;

  DM.qCountQuery.Active := False;
  DM.qCountQuery.Params.ParamByName('ot').Value := sDateEdit3.Date;
  DM.qCountQuery.Params.ParamByName('do').Value := sDateEdit4.Date;
  DM.qCountQuery.Active := True;

  // Очистить StringGrid
  for i := 0 to StringGrid.RowCount do
    StringGrid.Rows[i].Clear;
  StringGrid.RowCount := 0;
  StringGrid.ColCount := 0;
end;

procedure TfrmStatistic.sDateEdit4Change(Sender: TObject);
begin
  inherited;
  DM.qCountQuery.Active := False;
  DM.qCountQuery.Params.ParamByName('do').Value := sDateEdit4.Date;
  DM.qCountQuery.Active := True;

  Konec := sDateEdit4.Date;
end;

procedure TfrmStatistic.StringGridDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
  text: string;
  Format: Word;
begin
  inherited;
  // перенос в ячейке текста
  // StringGrid.DefaultDrawing := False;  треба виставіть

  with Sender as TStringGrid do
  begin
    Canvas.FillRect(Rect);
    if (ARow = 0) then // d 1-ой строке перенос текста и по центру
      DrawText(Canvas.Handle, PChar(Cells[ACol, ARow]),
        Length(Cells[ACol, ARow]), Rect, DT_VCENTER or DT_WORDBREAK or
        DT_EXPANDTABS or DT_CENTER or DT_BOTTOM)
    else
      DrawText(Canvas.Handle, PChar(Cells[ACol, ARow]),
        Length(Cells[ACol, ARow]), Rect, DT_CENTER or DT_VCENTER or
        DT_SINGLELINE);

    if (ARow > 0) then // 2-ой строке просто по центру текст
    begin
      text := StringGrid.Cells[ACol, ARow];
      Format := DT_CENTER or DT_VCENTER or DT_SINGLELINE;
      DrawText(StringGrid.Canvas.Handle, PChar(text), Length(text),
        Rect, Format);
    end;

  end;


  // StringGrid.Canvas.FillRect(Rect);

  { text := StringGrid.Cells[ACol, ARow];
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
    // первый столбец - положение текста по центру
    else
    Format := DT_LEFT or DT_VCENTER or DT_SINGLELINE;

    if (ARow mod 2 = 0) and (ACol = 1) then
    Format := DT_RIGHT or DT_VCENTER or DT_SINGLELINE;

    StringGrid.Canvas.FillRect(Rect);
    DrawText(StringGrid.Canvas.Handle, PChar(text), Length(text), Rect, Format);



    // if ARow = 0 then
    // Format := DT_CENTER or DT_VCENTER or DT_SINGLELINE; // первая строка – положение текста по центру

    // StringGrid.Canvas.FillRect(Rect); // перерисовка ячейки
    // StrPCopy(C, StringGrid.Cells[ACol, ARow]); // преобразование строки в формат PChar
    // WinProcs.DrawText(StringGrid.Canvas.Handle, C, StrLen(C), Rect, Format); // вывод текста }
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

procedure TfrmStatistic.acSaveExcelUpdate(Sender: TObject);
begin
  if (StringGrid.RowCount > 3) then
    btnSave.Enabled := True
  else
    btnSave.Enabled := False;

end;

procedure TfrmStatistic.btnCalckClick(Sender: TObject);
var
  TypeContact, VidPosluga, Ispolnitel: TStringList;
  i, j, row, col, sumContact, sumClient: Integer;
  fCount, vidPoslOld, vidPosl, ispolnit, typeCont, ContClient: String;
begin
  inherited;
  StringGrid.ColCount := 4;
  StringGrid.RowCount := 2;
  // ------------------- список Исполнителей -------------------------
  Ispolnitel := TStringList.Create;
  Ispolnitel.CommaText := SpisokPoley('ZvitSnow', 'Ispolnitel');
  IspolnitelCount := Ispolnitel.Count;
  // --------------- список вида услуг -----------------------
  VidPosluga := TStringList.Create;
  VidPosluga.CommaText := SpisokPoley('ZvitSnow', 'Tema');
  // --------------- список типа контактов -----------------------
  TypeContact := TStringList.Create;
  // TypeContact.CommaText := SpisokPoley('ZvitSnow', 'TypeKontakta');

  StringGrid.RowHeights[0] := StringGrid.DefaultRowHeight * 2;

  // Тайтл таблицы
  StringGrid.Cells[0, 0] := 'Вид услуги';
  StringGrid.ColWidths[0] := 140;
  StringGrid.Cells[1, 0] := 'Тип контакта';
  StringGrid.ColWidths[1] := 120;
  StringGrid.Cells[2, 0] := 'Всего контактов';
  StringGrid.Cells[3, 0] := 'Всего клиентов';
  col := 4;
  Application.ProcessMessages;

  for i := 0 to Ispolnitel.Count - 1 do
  begin
    StringGrid.Cells[col, 0] := Ispolnitel[i]; // ФИО Исполнителя
    StringGrid.ColCount := StringGrid.ColCount + 1; // добавить колонку
    StringGrid.Cells[col, 1] := 'контакт';
    inc(col);
    Application.ProcessMessages;
    StringGrid.Cells[col, 0] := Ispolnitel[i]; // ФИО Исполнителя
    StringGrid.ColCount := StringGrid.ColCount + 1; // добавить колонку
    StringGrid.Cells[col, 1] := 'клиент';
    inc(col);
    Application.ProcessMessages;
  end;

  // -------------- заполняем услугами таблицу -----------------
  row := StringGrid.RowCount;
  for i := 0 to VidPosluga.Count - 1 do
  begin
    StringGrid.RowCount := row + 1; // добавляем строку
    StringGrid.Cells[0, row] := VidPosluga[i];
    Application.ProcessMessages;

    // загружаем список типов контактов для данной услуги
    TypeContact.CommaText := SpisokPoleyWhere('ZvitSnow', 'TypeKontakta',
      VidPosluga[i]);
    Application.ProcessMessages;

    for j := 0 to TypeContact.Count - 1 do
    begin
      StringGrid.RowCount := row + 1; // добавляем строку
      StringGrid.Cells[1, row] := TypeContact[j];
      Application.ProcessMessages;
      inc(row);
    end;
    inc(row);
    Application.ProcessMessages;
  end;

  // --------- Считаем количества ---------------
  col := StringGrid.ColCount;
  row := StringGrid.RowCount;

  // i колонка   j строка
  for j := 2 to row - 1 do // -- строка -- (2 - потому что 0-шапка 1-контакты)
  begin
    sumContact := 0;
    sumClient := 0;
    for i := 4 to col - 1 do // --столбец --- (4 - начало Исполнителей)
    begin

      vidPosl := StringGrid.Cells[0, j];
      if vidPosl = '' then
        vidPosl := vidPoslOld;

      typeCont := StringGrid.Cells[1, j];
      ispolnit := StringGrid.Cells[i, 0];
      ContClient := StringGrid.Cells[i, 1];

      if (typeCont = '') then
        Break;

      if (vidPosl <> '') and (ispolnit <> '') then
      begin
        // если для клиента то группируем
        if ContClient = 'контакт' then
        begin
          fCount := CountRecordData(DateTimeToStr(Nachalo),
            DateTimeToStr(Konec), ispolnit, vidPosl, typeCont, False);
          sumContact := sumContact + fCount.ToInteger();
          StringGrid.Cells[2, j] := sumContact.ToString;
        end;

        if ContClient = 'клиент' then
        begin
          fCount := CountRecordData(DateTimeToStr(Nachalo),
            DateTimeToStr(Konec), ispolnit, vidPosl, typeCont, True);
          sumClient := sumClient + fCount.ToInteger();
          StringGrid.Cells[3, j] := sumClient.ToString;
        end;

        if fCount <> '0' then
          StringGrid.Cells[i, j] := fCount;
        Application.ProcessMessages;
      end;
      vidPoslOld := vidPosl;
    end;
  end;

  VidPosluga.Free;
  Ispolnitel.Free;
  TypeContact.Free;
end;

procedure TfrmStatistic.btnSaveClick(Sender: TObject);
var
  Sheets, ExcelApp: Variant;
  i, j, endColumn, colum, rowStart, rowEnd, Rows: Integer;
  DirectoryNow, FileNameS: String;
  StrEndColumnSylka, RangeSylka, FIO, Formula, Formula2: string;
  NewBlock: Boolean;
begin
  try
    myForm.ProgressBar.Visible := True;
    myForm.ProgressBar.Min := 0;
    myForm.ProgressBar.Max := StringGrid.RowCount;
    myForm.ProgressBar.Position := 1;

    if uMyExcel.RunExcel(False, False) = True then
      MyExcel.Workbooks.Add; // добавляем новую книгу
    // MyExcel.ReferenceStyle := -4150; // Устанавливаем формат ссылок на R1C1 для этой книги

    Sheets := MyExcel.Worksheets.Add;
    Sheets.name := 'TravmaCentr';
    ParametryStr; // Парметры страницы
    Sheets.PageSetup.PrintTitleRows := '$2:$2';

    // Параметры таблицы ( цифра номер столбца ) ширины столбцов
    ExcelApp := MyExcel.ActiveWorkBook.Worksheets[1].columns;

    ExcelApp.columns[1].columnwidth := 16.43;
    ExcelApp.columns[2].columnwidth := 19.71;
    ExcelApp.columns[3].columnwidth := 4.29;
    ExcelApp.columns[4].columnwidth := 4.57;
    ExcelApp.columns[5].columnwidth := 3.29;
    ExcelApp.columns[6].columnwidth := 3.29;

    // IspolnitelCount
    for i := 1 to IspolnitelCount * 2 do
      ExcelApp.columns[6 + i].columnwidth := 7;

    endColumn := 6 + (IspolnitelCount * 2);

    // ............ буква последнего столбца .........
    StrEndColumnSylka := CellsCharFind(endColumn);

    // ============= Выделяем и обьединяем ==================

    // ------------ 1-я строка ------------------------
    MyExcel.ActiveWorkBook.Worksheets[1].Range
      ['A1:' + StrEndColumnSylka + '1'].Select;
    MyExcel.ActiveWorkBook.Worksheets[1].Range
      ['A1:' + StrEndColumnSylka + '1'].Merge;
    MyExcel.Selection.HorizontalAlignment := xlCenter;
    MyExcel.Selection.Font.name := 'Calibri';
    MyExcel.Selection.Font.Size := 14;
    MyExcel.Selection.Font.Bold := True;
    MyExcel.ActiveWorkBook.Worksheets[1].Cells[1, 1] :=
      'Сводный отчет центра травмы с ' + DateTimeToStr(Nachalo) + ' по ' +
      DateTimeToStr(Konec);

    // ----------------- Шапка таблицы --------------------------------------
    ExcelApp := MyExcel.ActiveWorkBook.Worksheets[1].Rows;

    ExcelApp.Rows[3].RowHeight := 15.75;
    ExcelApp.Rows[4].RowHeight := 40.50;
    ExcelApp.Rows[5].RowHeight := 15.00;

    MyExcel.ActiveWorkBook.Worksheets[1].Range['A3:A5'].Select;
    MyExcel.ActiveWorkBook.Worksheets[1].Range['A3:A5'].Merge;
    MyExcel.Selection.HorizontalAlignment := xlCenter;
    MyExcel.Selection.VerticalAlignment := xlCenter;
    MyExcel.ActiveWorkBook.Worksheets[1].Cells[3, 1] := 'Вид услуги';

    MyExcel.ActiveWorkBook.Worksheets[1].Range['B3:B5'].Select;
    MyExcel.ActiveWorkBook.Worksheets[1].Range['B3:B5'].Merge;
    MyExcel.Selection.HorizontalAlignment := xlCenter;
    MyExcel.Selection.VerticalAlignment := xlCenter;
    MyExcel.ActiveWorkBook.Worksheets[1].Cells[3, 2] := 'Тип контакта';

    MyExcel.ActiveWorkBook.Worksheets[1].Range['C3:D3'].Select;
    MyExcel.ActiveWorkBook.Worksheets[1].Range['C3:D3'].Merge;
    MyExcel.Selection.HorizontalAlignment := xlCenter;
    MyExcel.ActiveWorkBook.Worksheets[1].Cells[3, 3] := 'Всего';

    MyExcel.ActiveWorkBook.Worksheets[1].Range['D4:D5'].Select;
    MyExcel.ActiveWorkBook.Worksheets[1].Range['D4:D5'].Merge;
    MyExcel.Selection.Orientation := 90;
    MyExcel.Selection.HorizontalAlignment := xlCenter;
    MyExcel.Selection.VerticalAlignment := xlCenter;
    MyExcel.ActiveWorkBook.Worksheets[1].Cells[4, 4] := 'клиентов';

    MyExcel.ActiveWorkBook.Worksheets[1].Range['C4:C5'].Select;
    MyExcel.ActiveWorkBook.Worksheets[1].Range['C4:C5'].Merge;
    MyExcel.Selection.Orientation := 90;
    MyExcel.Selection.HorizontalAlignment := xlCenter;
    MyExcel.Selection.VerticalAlignment := xlCenter;
    MyExcel.ActiveWorkBook.Worksheets[1].Cells[4, 3] := 'контактов';

    MyExcel.ActiveWorkBook.Worksheets[1].Range['E3:E5'].Select;
    MyExcel.ActiveWorkBook.Worksheets[1].Range['E3:E5'].Merge;
    MyExcel.Selection.Orientation := 90;
    MyExcel.Selection.HorizontalAlignment := xlCenter;
    MyExcel.Selection.VerticalAlignment := xlCenter;
    MyExcel.ActiveWorkBook.Worksheets[1].Cells[3, 5] := 'контакт';

    MyExcel.ActiveWorkBook.Worksheets[1].Range['F3:F5'].Select;
    MyExcel.ActiveWorkBook.Worksheets[1].Range['F3:F5'].Merge;
    MyExcel.Selection.Orientation := 90;
    MyExcel.Selection.HorizontalAlignment := xlCenter;
    MyExcel.Selection.VerticalAlignment := xlCenter;
    MyExcel.ActiveWorkBook.Worksheets[1].Cells[3, 6] := 'клиент';

    MyExcel.ActiveWorkBook.Worksheets[1].Range
      ['G3:' + StrEndColumnSylka + '3'].Select;
    MyExcel.ActiveWorkBook.Worksheets[1].Range
      ['G3:' + StrEndColumnSylka + '3'].Merge;

    MyExcel.Selection.HorizontalAlignment := xlCenter;
    // MyExcel.Selection.Interior.ColorIndex := 24;
    MyExcel.Selection.Interior.Color := RGB(221, 235, 247);
    MyExcel.ActiveWorkBook.Worksheets[1].Cells[3, 7] := 'Исполнители';

    colum := 7; // с какой колонки начинаються исполнители
    FIO := '';
    for i := 4 to StringGrid.ColCount do
    begin
      if FIO <> StringGrid.Cells[i, 0] then
      begin
        MyExcel.ActiveWorkBook.Worksheets[1].Cells[4, colum] :=
          StringGrid.Cells[i, 0];
        MyExcel.Selection.Font.Bold := True;

      end;

      MyExcel.ActiveWorkBook.Worksheets[1].Cells[5, colum] :=
        StringGrid.Cells[i, 1];

      if StringGrid.Cells[i, 1] = 'клиент' then
      begin
        // обединим ФИО в одно
        RangeSylka := CellsCharFind(colum - 1) + '4:' +
          CellsCharFind(colum) + '4';

        MyExcel.ActiveWorkBook.Worksheets[1].Range[RangeSylka].Select;
        MyExcel.ActiveWorkBook.Worksheets[1].Range[RangeSylka].Merge;
        MyExcel.Selection.HorizontalAlignment := xlCenter;
        MyExcel.Selection.VerticalAlignment := xlCenter;
        MyExcel.ActiveWorkBook.Worksheets[1].Range[RangeSylka].WrapText := True;
        MyExcel.Selection.Font.Bold := True;

        // разукраска ячейки
        MyExcel.ActiveWorkBook.Worksheets[1].Cells[5, colum].Select;
        MyExcel.Selection.Interior.Color := RGB(252, 228, 214);
      end;
      inc(colum);
      FIO := StringGrid.Cells[i, 0];
    end;

    // Границы
    RangeSylka := 'A3:' + StrEndColumnSylka + '5';

    MyExcel.ActiveWorkBook.Worksheets[1].Range[RangeSylka].Select;
    MyExcel.Selection.Borders.LineStyle := xlContinuous; // границы
    MyExcel.Selection.Borders.Weight := xlThin; // создать сетку
    // вокруг жирная рамка
    MyExcel.ActiveWorkBook.Worksheets[1].Range[RangeSylka].BorderAround
      (xlContinuous, xlMedium, EmptyParam, EmptyParam);
    MyExcel.ActiveWorkBook.Worksheets[1].Range['G3:' + StrEndColumnSylka + '3']
      .BorderAround(xlContinuous, xlMedium, EmptyParam, EmptyParam);

    MyExcel.Selection.Borders[9].LineStyle := 9; // двойная линия внизу шапки

    // ------------------------- Заполняем данными ----------------------------
    rowStart := 6; // запоминаем стартовую строку
    rowEnd := 0;
    Rows := 0;
    for i := 1 to StringGrid.RowCount - 1 do // строки
    begin
      inc(Rows);
      NewBlock := False;
      for j := 0 to StringGrid.ColCount - 1 do // столбцы
      begin
        if j > 0 then // делаем пустую строку для подбивки данных
        begin
          if j > 1 then // смещаем на два столбца
          begin
            MyExcel.Cells[i + 6, j + 3] := StringGrid.Cells[j, i + 1];
            MyExcel.Cells[i + 6, j + 3].Select;
            MyExcel.Selection.HorizontalAlignment := xlCenter;
            MyExcel.Selection.VerticalAlignment := xlCenter;

            FIO := MyExcel.Cells[5, j + 3];

            if FIO = 'клиент' then
              MyExcel.Selection.Interior.Color := RGB(252, 228, 214);
          end
          else
          begin
            if StringGrid.Cells[j, i + 1] = '' then
            begin
              NewBlock := True;
              Break;
            end
            else
              // контакт
              MyExcel.Cells[i + 6, j + 1] := StringGrid.Cells[j, i + 1];
          end;

        end
        else
        begin // услуга
          MyExcel.Cells[i + 5, j + 1] := StringGrid.Cells[j, i + 1];
          MyExcel.Cells[i + 5, j + 1].WrapText := True;
        end;
      end;

      if NewBlock = True then
      begin // обрамляем блок услуг
        rowEnd := rowStart + Rows - 1;

        // Обьединяем ячейки Услуги
        RangeSylka := 'A' + rowStart.ToString + ':' + 'A' + rowEnd.ToString;
        MyExcel.ActiveWorkBook.Worksheets[1].Range[RangeSylka].Select;
        MyExcel.ActiveWorkBook.Worksheets[1].Range[RangeSylka].Merge;
        MyExcel.Selection.HorizontalAlignment := xlCenter;
        MyExcel.Selection.VerticalAlignment := xlCenter;
        // Всего
        if Rows = 2 then
        begin
          Formula := '=SUM(E' + (rowStart + 1).ToString + ')';
          Formula2 := '=SUM(F' + (rowStart + 1).ToString + ')';
        end
        else
        begin
          Formula := '=SUM(E' + (rowStart + 1).ToString + ':E' +
            rowEnd.ToString + ')';
          Formula2 := '=SUM(F' + (rowStart + 1).ToString + ':F' +
            rowEnd.ToString + ')';
        end;
        MyExcel.Cells[rowStart, 3].Formula := Formula;
        MyExcel.Cells[rowStart, 3].Select;
        MyExcel.Selection.HorizontalAlignment := xlCenter;
        MyExcel.Selection.Font.Bold := True;

        MyExcel.Cells[rowStart, 4].Formula := Formula2;
        MyExcel.Cells[rowStart, 4].Select;
        MyExcel.Selection.HorizontalAlignment := xlCenter;
        MyExcel.Selection.Font.Bold := True;

        ExcelApp.Rows[rowStart].RowHeight := 15.75;

        // границы
        RangeSylka := 'A' + rowStart.ToString + ':' + StrEndColumnSylka +
          rowEnd.ToString;
        MyExcel.ActiveWorkBook.Worksheets[1].Range[RangeSylka].Select;
        MyExcel.Selection.Borders.LineStyle := xlContinuous; // границы
        MyExcel.Selection.Borders.Weight := xlThin; // создать сетку
        MyExcel.ActiveWorkBook.Worksheets[1].Range[RangeSylka].BorderAround
          (xlContinuous, xlMedium, EmptyParam, EmptyParam);

        rowStart := rowEnd + 1;
        rowEnd := 0;
        NewBlock := False;
        Rows := 0;
      end;
      myForm.ProgressBar.Position := i;
    end;

    // проставляем формулы
    rowEnd := MyExcel.ActiveCell.SpecialCells($000000B).row;
    // последняя заполненная строка
    for i := 3 to endColumn do
    begin
      if (i < 5) or (i > 6) then
      begin
        Formula := '=SUM(' + CellsCharFind(i) + '6:' + CellsCharFind(i) +
          rowEnd.ToString + ')';

        MyExcel.Cells[rowEnd + 1, i].Formula := Formula;
        MyExcel.Cells[rowEnd + 1, i].Select;
        MyExcel.Selection.HorizontalAlignment := xlCenter;
        MyExcel.Selection.Font.Bold := True;
      end;
    end;

    // обводим рамки жирным по исполнителям
    for i := 7 to endColumn do
    begin
      if (i mod 2) <> 0 then
      begin
        RangeSylka := CellsCharFind(i) + '4:' + CellsCharFind(i + 1) +
          rowEnd.ToString;
        MyExcel.ActiveWorkBook.Worksheets[1].Range[RangeSylka].Select;
        MyExcel.ActiveWorkBook.Worksheets[1].Range[RangeSylka].BorderAround
          (xlContinuous, xlMedium, EmptyParam, EmptyParam);
      end;
    end;

    DirectoryNow := ExtractFilePath(ParamStr(0)) + 'Отчеты\';

    if not DirectoryExists('DirectoryNow') then
      ForceDirectories(DirectoryNow);

    FileNameS := DirectoryNow + 'ТЦ_' + DateTimeToStr(Nachalo) + '-' +
      DateTimeToStr(Konec) + '_' + FormatDateTime('dd.mm.yyyy hh_mm_ss', Now)
      + '.xlsx';

    if uMyExcel.SaveWorkBook(FileNameS, 1) = True then
    begin
      ShowMessage('Все ОК');
      myForm.ProgressBar.Visible := False;
    end;
    Sheets := unassigned;
    ExcelApp := unassigned;
    uMyExcel.StopExcel;
    ShellExecute(Handle, 'open', PWideChar(DirectoryNow), nil, nil,
      SW_SHOWNORMAL);

  except
    on E: Exception do
    begin
      Sheets := unassigned;
      ExcelApp := unassigned;
      uMyExcel.StopExcel;
      myForm.ProgressBar.Visible := False;
    end;
  end;

end;

end.
