unit uFrameObAnalitics;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uFrameCustom, sFrameAdapter,
  Vcl.ExtCtrls, sPanel, Vcl.StdCtrls, Vcl.Buttons, Vcl.Mask, sMaskEdit,
  sCustomComboEdit, sToolEdit, sLabel, DBGridEhGrouping, ToolCtrlsEh,
  DBGridEhToolCtrls, DynVarsEh, Vcl.Grids, JvExGrids, JvStringGrid, EhLibVCL,
  GridsEh, DBAxisGridsEh, DBGridEh, System.DateUtils, Math, Uni, System.Actions,
  Vcl.ActnList, sComboBox, Winapi.ShellAPI;

type
  TfrmObAnalitics = class(TCustomInfoFrame)
    panTop: TsPanel;
    panAll: TsPanel;
    sLabelFX1: TsLabelFX;
    sDateEdit3: TsDateEdit;
    sLabelFX2: TsLabelFX;
    sDateEdit4: TsDateEdit;
    btnCalck: TBitBtn;
    DBGridEh1: TDBGridEh;
    Splitter1: TSplitter;
    StringGrid: TJvStringGrid;
    btnSave: TBitBtn;
    ActionList1: TActionList;
    acCalck: TAction;
    acSaveExcel: TAction;
    cbPeriod: TsComboBox;
    procedure sDateEdit3Change(Sender: TObject);
    procedure sDateEdit4Change(Sender: TObject);
    procedure StringGridDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure btnCalckClick(Sender: TObject);
    procedure acCalckUpdate(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure acSaveExcelUpdate(Sender: TObject);
    procedure cbPeriodChange(Sender: TObject);
  private
    { Private declarations }
    procedure InitGrid;
    procedure AdjustGridColumnWidths(Grid: TJvStringGrid);
    procedure LoadAgeGroupsToGrid;
    procedure CalculateHesedBeshtColumn(StringGrid: TJvStringGrid);

  public
    { Public declarations }
    procedure AfterCreation; override;
    // procedure BeforeDestruct; virtual;
  end;

var
  frmObAnalitics: TfrmObAnalitics;

implementation

{$R *.dfm}

uses uDM, uMainForm, uMyExcel;

procedure TfrmObAnalitics.acCalckUpdate(Sender: TObject);
begin
  inherited;
  if (sDateEdit3.Text <> '') and (sDateEdit4.Text <> '') and
    not DBGridEh1.DataSource.DataSet.IsEmpty and
    (sDateEdit3.Date <> sDateEdit4.Date) then
    btnCalck.Enabled := True
  else
    btnCalck.Enabled := False;

end;

procedure TfrmObAnalitics.acSaveExcelUpdate(Sender: TObject);
begin
  inherited;
  if (StringGrid.Cells[1, 1] <> '') then
    btnSave.Enabled := True
  else
    btnSave.Enabled := False;
end;

procedure TfrmObAnalitics.AdjustGridColumnWidths(Grid: TJvStringGrid);
var
  i, j, MaxTextWidth: Integer;
  CellText: string;
begin
  Grid.Canvas.Font.Assign(Grid.Font);

  for i := 0 to Grid.ColCount - 1 do
  begin
    MaxTextWidth := Grid.Canvas.TextWidth(Grid.Cells[i, 0]); // заголовок

    // якщо це перша колонка — перевір ще назви рядків (наприклад, перші 6)
    if i = 0 then
    begin
      for j := 1 to Min(11, Grid.RowCount - 1) do
      begin
        CellText := Grid.Cells[i, j];
        MaxTextWidth := Max(MaxTextWidth, Grid.Canvas.TextWidth(CellText));
      end;
    end;

    Grid.ColWidths[i] := MaxTextWidth + 20; // запас
  end;
end;

procedure TfrmObAnalitics.AfterCreation;
begin
  inherited;
  InitGrid;
end;

procedure TfrmObAnalitics.btnCalckClick(Sender: TObject);
begin
  inherited;
  LoadAgeGroupsToGrid;
  // Після завантаження всіх даних — підрахувати колонку "ХеседБешт"
  CalculateHesedBeshtColumn(StringGrid);
end;

procedure TfrmObAnalitics.InitGrid;
begin
  with StringGrid do
  begin
    // Встановлення кількості стовпців і рядків
    ColCount := 9; // 1 назви рядків + 8 стовпців
    RowCount := 12; // 1 заголовок + 11 рядків

    // Фіксація верхнього рядка і першого стовпця
    FixedRows := 1;
    FixedCols := 1;

    Cells[0, 0] := ''; // кутова клітинка

    // Заповнення шапки стовпців
    Cells[1, 0] := 'ХеседБешт'; // Без регіону
    Cells[2, 0] := 'Хмельницький';
    Cells[3, 0] := 'Тернопільський';
    Cells[4, 0] := 'Кам`янець-Подільський';
    Cells[5, 0] := 'Луцький';
    Cells[6, 0] := 'Рівенський';
    Cells[7, 0] := 'Північний';
    Cells[8, 0] := 'Малі регіони';

    // Заповнення назв рядків
    Cells[0, 1] := '0 - 6';
    Cells[0, 2] := '7 - 12';
    Cells[0, 3] := '13 - 17';
    Cells[0, 4] := '18 - 30';
    Cells[0, 5] := '31 - 59';
    Cells[0, 6] := '60+';
    Cells[0, 7] := 'Унікальних';
    Cells[0, 8] := 'Нових уч-ків';
    Cells[0, 9] := 'Активних';
    Cells[0, 10] := 'Мультіпрограмних';
    Cells[0, 11] := 'Не анкетованих';

    DefaultDrawing := False;
    AdjustGridColumnWidths(StringGrid);
  end;

end;

procedure TfrmObAnalitics.sDateEdit3Change(Sender: TObject);
var
  i: Integer;
begin
  inherited;
  sDateEdit4.Date := EncodeDate(YearOf(sDateEdit3.Date),
    MonthOf(sDateEdit3.Date), DaysInMonth(sDateEdit3.Date));

  Nachalo := sDateEdit3.Date;
  Konec := sDateEdit4.Date;

  DM.qAnalitic.Active := False;
  DM.qAnalitic.Params.ParamByName('ot').Value := sDateEdit3.Date;
  DM.qAnalitic.Params.ParamByName('do').Value := sDateEdit4.Date;
  DM.qAnalitic.Active := True;

  // Очистить StringGrid и strGridTraining
  for i := 0 to StringGrid.RowCount do
    StringGrid.Rows[i].Clear;
  StringGrid.RowCount := 0;
  StringGrid.ColCount := 0;
  InitGrid; // ініціалізація Гріда
end;

procedure TfrmObAnalitics.sDateEdit4Change(Sender: TObject);
begin
  inherited;
  DM.qAnalitic.Active := False;
  DM.qAnalitic.Params.ParamByName('do').Value := sDateEdit4.Date;
  DM.qAnalitic.Active := True;

  Konec := sDateEdit4.Date;
end;

procedure TfrmObAnalitics.StringGridDrawCell(Sender: TObject;
  ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  Text: string;
  DrawFlags, HesedBeshtCol, i: Integer;
begin
  HesedBeshtCol := -1;

  // Знайти колонку з назвою "ХеседБешт"
  for i := 1 to StringGrid.ColCount - 1 do
    if StringGrid.Cells[i, 0] = 'ХеседБешт' then
    begin
      HesedBeshtCol := i;
      Break;
    end;

  with (Sender as TStringGrid).Canvas do
  begin
    // Зміна кольору фону для стовпця "ХеседБешт"
    if ACol = HesedBeshtCol then
      Brush.Color := $00FFE0E0 // Світло-рожевий (можна змінити)
    else
      Brush.Color := clWindow; // Звичайний білий фон

    FillRect(Rect); // Очистити клітинку з обраним фоном

    Text := StringGrid.Cells[ACol, ARow];

    // Центрування тексту
    DrawFlags := DT_CENTER or DT_VCENTER or DT_SINGLELINE;

    // Жирний шрифт для шапки або першого стовпця
    if (ARow = 0) or (ACol = 0) then
      Font.Style := [fsBold]
    else
      Font.Style := [];

    DrawText(Handle, PChar(Text), Length(Text), Rect, DrawFlags);
  end;

end;

procedure TfrmObAnalitics.LoadAgeGroupsToGrid;
var
  Q: TUniQuery;
  ColIndex, c: Integer;
  RegionName: string;
begin
  Q := TUniQuery.Create(nil);
  try
    Q.Connection := DM.UniConnection;
    Q.Close;
    Q.SQL.Text := 'SELECT ' +
      '  IFNULL(R.nameRegion, ''Без регіону'') AS Назва_регіону, ' +
      '  COUNT(DISTINCT CASE WHEN C.Возраст BETWEEN 0 AND 6 THEN C.`JDC ID` END) AS Вік_0_6, '
      + '  COUNT(DISTINCT CASE WHEN C.Возраст BETWEEN 7 AND 12 THEN C.`JDC ID` END) AS Вік_7_12, '
      + '  COUNT(DISTINCT CASE WHEN C.Возраст BETWEEN 13 AND 17 THEN C.`JDC ID` END) AS Вік_13_17, '
      + '  COUNT(DISTINCT CASE WHEN C.Возраст BETWEEN 18 AND 30 THEN C.`JDC ID` END) AS Вік_18_30, '
      + '  COUNT(DISTINCT CASE WHEN C.Возраст BETWEEN 31 AND 59 THEN C.`JDC ID` END) AS Вік_31_59, '
      + '  COUNT(DISTINCT CASE WHEN C.Возраст BETWEEN 60 AND 120 THEN C.`JDC ID` END) AS Вік_60_120, '
      + '  COUNT(DISTINCT C.`JDC ID`) AS Унікальні_клієнти ' + 'FROM Events E '
      + 'LEFT JOIN EventClients EC ON E.ID = EC.EventID ' +
      'LEFT JOIN admUch C ON EC.ClientID = C.`JDC ID` ' +
      'LEFT JOIN Region R ON E.id_region = R.id_region ' +
      'WHERE (E.id_region IN (1,2,3,4,5,6) OR E.id_region IS NULL) ' +
      '  AND E.`Дата` BETWEEN :ot AND :do ' + 'GROUP BY R.nameRegion ' +
      'ORDER BY R.nameRegion';

    Q.ParamByName('ot').AsDate := Nachalo;
    Q.ParamByName('do').AsDate := Konec;
    Q.Open;

    while not Q.Eof do
    begin
      RegionName := Q.FieldByName('Назва_регіону').AsString;

      // Шукаємо колонку по назві регіону (у шапці StringGrid.Cells[Col, 0])
      ColIndex := -1;
      for c := 1 to StringGrid.ColCount - 1 do
        if StringGrid.Cells[c, 0] = RegionName then
        begin
          ColIndex := c;
          Break;
        end;

      if ColIndex <> -1 then
      begin
        // Записуємо значення в рядки 1..7 (вікові групи і унікальні)
        StringGrid.Cells[ColIndex, 1] := Q.FieldByName('Вік_0_6').AsString;
        StringGrid.Cells[ColIndex, 2] := Q.FieldByName('Вік_7_12').AsString;
        StringGrid.Cells[ColIndex, 3] := Q.FieldByName('Вік_13_17').AsString;
        StringGrid.Cells[ColIndex, 4] := Q.FieldByName('Вік_18_30').AsString;
        StringGrid.Cells[ColIndex, 5] := Q.FieldByName('Вік_31_59').AsString;
        StringGrid.Cells[ColIndex, 6] := Q.FieldByName('Вік_60_120').AsString;
        StringGrid.Cells[ColIndex, 7] :=
          Q.FieldByName('Унікальні_клієнти').AsString;
        // StringGrid.Cells[ColIndex, 11] := Q.FieldByName('Кількість_сторонніх').AsString; // ← новий рядок

      end;
      Q.Next;
    end;

    // ==== "Нові клієнти за регіонами" ==========
    Q.Close;
    Q.SQL.Text := 'SELECT ' +
      '  IFNULL(R.nameRegion, ''Без регіону'') AS Назва_регіону, ' +
      '  COUNT(DISTINCT C.`JDC ID`) AS Нові_клієнти ' + 'FROM admUch C ' +
      'JOIN EventClients EC ON C.`JDC ID` = EC.ClientID ' +
      'JOIN Events E ON EC.EventID = E.ID ' +
      'LEFT JOIN Region R ON E.id_region = R.id_region ' +
      'WHERE C.`Создано` BETWEEN :ot AND :do ' +
      '  AND E.`Дата` BETWEEN :ot AND :do ' +
      '  AND (E.id_region IN (1,2,3,4,5,6) OR E.id_region IS NULL) ' +
      'GROUP BY R.nameRegion ' + 'ORDER BY R.nameRegion';

    Q.ParamByName('ot').AsDate := Nachalo;
    Q.ParamByName('do').AsDate := Konec;
    Q.Open;
    while not Q.Eof do
    begin
      RegionName := Q.FieldByName('Назва_регіону').AsString;

      // Шукаємо колонку по назві регіону
      ColIndex := -1;
      for c := 1 to StringGrid.ColCount - 1 do
        if StringGrid.Cells[c, 0] = RegionName then
        begin
          ColIndex := c;
          Break;
        end;

      if ColIndex <> -1 then
        StringGrid.Cells[ColIndex, 8] := Q.FieldByName('Нові_клієнти').AsString;

      Q.Next;
    end;

    // ======= "Активні клієнти (2+ заходів) за регіонами", ========
    Q.Close;
    Q.SQL.Text := 'SELECT ' +
      '  IFNULL(R.nameRegion, ''Без регіону'') AS Назва_регіону, ' +
      '  COUNT(*) AS Активні_клієнти ' + 'FROM ( ' +
      '  SELECT EC.ClientID, E.id_region ' + '  FROM EventClients EC ' +
      '  JOIN Events E ON EC.EventID = E.ID ' +
      '  WHERE E.`Дата` BETWEEN :ot AND :do ' +
      '    AND (E.id_region IN (1,2,3,4,5,6) OR E.id_region IS NULL) ' +
      '  GROUP BY EC.ClientID, E.id_region ' +
      '  HAVING COUNT(DISTINCT E.ID) >= 2 ' + ') AS sub ' +
      'LEFT JOIN Region R ON sub.id_region = R.id_region ' +
      'GROUP BY R.nameRegion ' + 'ORDER BY R.nameRegion';

    Q.ParamByName('ot').AsDate := Nachalo;
    Q.ParamByName('do').AsDate := Konec;
    Q.Open;
    while not Q.Eof do
    begin
      RegionName := Q.FieldByName('Назва_регіону').AsString;

      // Шукаємо колонку в шапці StringGrid по назві регіону
      ColIndex := -1;
      for c := 1 to StringGrid.ColCount - 1 do
        if StringGrid.Cells[c, 0] = RegionName then
        begin
          ColIndex := c;
          Break;
        end;

      if ColIndex <> -1 then
        StringGrid.Cells[ColIndex, 9] :=
          Q.FieldByName('Активні_клієнти').AsString;

      Q.Next;
    end;
    // ========= "Мультипрограмні клієнти (2+ клуби) за регіонами" ==============
    Q.Close;
    Q.SQL.Text := 'SELECT ' +
      '  IFNULL(R.nameRegion, ''Без регіону'') AS Назва_регіону, ' +
      '  COUNT(*) AS Мультипрограмні_клієнти ' + 'FROM ( ' +
      '  SELECT EC.ClientID, E.id_region ' + '  FROM EventClients EC ' +
      '  JOIN Events E ON EC.EventID = E.ID ' +
      '  WHERE E.`Дата` BETWEEN :ot AND :do ' +
      '    AND (E.id_region IN (1,2,3,4,5,6) OR E.id_region IS NULL) ' +
      '  GROUP BY EC.ClientID, E.id_region ' +
      '  HAVING COUNT(DISTINCT E.ClubID) >= 2 ' + ') AS sub ' +
      'LEFT JOIN Region R ON sub.id_region = R.id_region ' +
      'GROUP BY R.nameRegion ' + 'ORDER BY R.nameRegion';

    Q.ParamByName('ot').AsDate := Nachalo;
    Q.ParamByName('do').AsDate := Konec;
    Q.Open;

    while not Q.Eof do
    begin
      RegionName := Q.FieldByName('Назва_регіону').AsString;

      // Знаходимо колонку по назві регіону
      ColIndex := -1;
      for c := 1 to StringGrid.ColCount - 1 do
        if StringGrid.Cells[c, 0] = RegionName then
        begin
          ColIndex := c;
          Break;
        end;

      if ColIndex <> -1 then
        StringGrid.Cells[ColIndex, 10] :=
          Q.FieldByName('Мультипрограмні_клієнти').AsString;
      Q.Next;
    end;
    // ========= "Не анкетовані клієнти за регіонами" ==============
    Q.Close;
    Q.SQL.Text := 'SELECT ' +
      '  IFNULL(R.nameRegion, ''Без регіону'') AS Назва_регіону, ' +
      '  SUM(IFNULL(E.Кількість_сторонніх, 0)) AS Кількість_сторонніх ' +
      'FROM Events E ' + 'LEFT JOIN Region R ON E.id_region = R.id_region ' +
      'WHERE (E.id_region IN (1,2,3,4,5,6) OR E.id_region IS NULL) ' +
      '  AND E.`Дата` BETWEEN :ot AND :do ' + 'GROUP BY R.nameRegion ' +
      'ORDER BY R.nameRegion';

    Q.ParamByName('ot').AsDate := Nachalo;
    Q.ParamByName('do').AsDate := Konec;
    Q.Open;

    while not Q.Eof do
    begin
      RegionName := Q.FieldByName('Назва_регіону').AsString;

      // Знаходимо колонку по назві регіону
      ColIndex := -1;
      for c := 1 to StringGrid.ColCount - 1 do
        if StringGrid.Cells[c, 0] = RegionName then
        begin
          ColIndex := c;
          Break;
        end;

      if ColIndex <> -1 then
        StringGrid.Cells[ColIndex, 11] :=
        // припустимо, що 9-й рядок для "Кількість_сторонніх"
          Q.FieldByName('Кількість_сторонніх').AsString;

      Q.Next;
    end;

  finally
    Q.Free;
  end;
end;

procedure TfrmObAnalitics.CalculateHesedBeshtColumn(StringGrid: TJvStringGrid);
var
  Row, Col: Integer;
  Sum: Integer;
  ValueStr: string;
begin
  // Рядки 1 до 10 (бо 0 — заголовок)
  for Row := 1 to StringGrid.RowCount - 1 do
  begin
    Sum := 0;

    // Проходимо всі стовпці крім 0 (назви) та 1 ("ХеседБешт")
    for Col := 2 to StringGrid.ColCount - 1 do
    begin
      ValueStr := StringGrid.Cells[Col, Row];
      if Trim(ValueStr) <> '' then
        Inc(Sum, StrToIntDef(ValueStr, 0));
    end;

    // Записуємо суму в колонку "ХеседБешт"
    StringGrid.Cells[1, Row] := IntToStr(Sum);
  end;
end;

procedure TfrmObAnalitics.cbPeriodChange(Sender: TObject);
var
  Year, Month, Day: Word;
  StartDate, EndDate: TDate;
begin
  DecodeDate(Date, Year, Month, Day); // поточний рік

  case cbPeriod.ItemIndex of
    0: // 1 квартал
      begin
        StartDate := EncodeDate(Year, 1, 1);
        EndDate := EncodeDate(Year, 3, 31);
      end;
    1: // 2 квартал
      begin
        StartDate := EncodeDate(Year, 4, 1);
        EndDate := EncodeDate(Year, 6, 30);
      end;
    2: // 3 квартал
      begin
        StartDate := EncodeDate(Year, 7, 1);
        EndDate := EncodeDate(Year, 9, 30);
      end;
    3: // 4 квартал
      begin
        StartDate := EncodeDate(Year, 10, 1);
        EndDate := EncodeDate(Year, 12, 31);
      end;
    4: // Пів року
      begin
        StartDate := EncodeDate(Year, 1, 1);
        EndDate := EncodeDate(Year, 6, 30);
      end;
    5: // Рік
      begin
        StartDate := EncodeDate(Year, 1, 1);
        EndDate := EncodeDate(Year, 12, 31);
      end;
  else
    Exit;
  end;

  sDateEdit3.Date := StartDate;
  sDateEdit4.Date := EndDate;
end;

procedure TfrmObAnalitics.btnSaveClick(Sender: TObject);
var
  Sheets, ExcelApp: Variant;
  i, j: Integer;
  DirectoryNow, FileNameS: String;
begin
  try
    myForm.ProgressBar.Visible := True;
    myForm.ProgressBar.Min := 0;
    myForm.ProgressBar.Max := StringGrid.RowCount;
    myForm.ProgressBar.Position := 1;

    if uMyExcel.RunExcel(False, False) = True then
      MyExcel.Workbooks.Add; // добавляем новую книгу
    Sheets := MyExcel.Worksheets.Add;
    Sheets.name := 'Analitics';
    ParametryStr; // Парметры страницы
    Sheets.PageSetup.PrintTitleRows := '$2:$2';

    // Параметры таблицы ( цифра номер столбца ) ширины столбцов
    ExcelApp := MyExcel.ActiveWorkBook.Worksheets[1].columns;
    ExcelApp.columns[1].columnwidth := 20;
    ExcelApp.columns[2].columnwidth := 20;
    ExcelApp.columns[3].columnwidth := 20;
    ExcelApp.columns[4].columnwidth := 20;
    ExcelApp.columns[5].columnwidth := 20;
    ExcelApp.columns[6].columnwidth := 20;
    ExcelApp.columns[7].columnwidth := 20;
    ExcelApp.columns[8].columnwidth := 20;
    ExcelApp.columns[9].columnwidth := 20;

    // ------------ 1-я строка ------------------------
    MyExcel.ActiveWorkBook.Worksheets[1].Range['A1:I1'].Select;
    MyExcel.ActiveWorkBook.Worksheets[1].Range['A1:I1'].Merge;
    MyExcel.Selection.HorizontalAlignment := xlCenter;
    MyExcel.Selection.Font.name := 'Calibri';
    MyExcel.Selection.Font.Size := 16;
    MyExcel.Selection.Font.Bold := True;
    MyExcel.ActiveWorkBook.Worksheets[1].Cells[1, 1] :=
      'Аналітика общинних програм по регіонах ХБФ "ХеседБешт" на  ' +
      DateTimeToStr(Now) + ' за період: ' + cbPeriod.Text;

    // ----------------- Шапка таблицы --------------------------------------
    ExcelApp := MyExcel.ActiveWorkBook.Worksheets[1].Rows;

    MyExcel.ActiveWorkBook.Worksheets[1].Range['A3:I14'].Select;
    MyExcel.Selection.HorizontalAlignment := xlCenter;
    MyExcel.Selection.VerticalAlignment := xlCenter;
    MyExcel.Selection.Font.Size := 10;

    MyExcel.Selection.Borders.LineStyle := xlContinuous; // границы
    MyExcel.Selection.Borders.Weight := xlThin; // показать

    MyExcel.ActiveWorkBook.Worksheets[1].Range['A3:I3'].Select;
    MyExcel.Selection.Font.Bold := True;
    MyExcel.Selection.Borders[9].LineStyle := 9; // Двойная линия

    for i := 0 to StringGrid.RowCount - 1 do // строки
      for j := 0 to StringGrid.ColCount - 1 do // столбцы
      begin
        MyExcel.Cells[i + 3, j + 1] := StringGrid.Cells[j, i];
      end;

    DirectoryNow := ExtractFilePath(ParamStr(0)) + 'Община\Аналитика\';

    if not DirectoryExists('DirectoryNow') then
      ForceDirectories(DirectoryNow);
    // ForceDirectories(ExtractFilePath(Application.ExeName) + '/folder1/folder2/newfolder');

    FileNameS := DirectoryNow + 'АО_' + FormatDateTime('dd.mm.yyyy hh_mm_ss',
      Now) + '.xlsx';

    uMyExcel.SaveWorkBook(FileNameS, 1);

    Sheets := unassigned;
    ExcelApp := unassigned;
    uMyExcel.StopExcel;
    myForm.ProgressBar.Visible := False;
    ShowMessage('Данные экспортированы и сохранены в файл');

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
