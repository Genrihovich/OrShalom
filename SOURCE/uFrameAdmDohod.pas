unit uFrameAdmDohod;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  uFrameCustom, sToolEdit, Vcl.StdCtrls, Vcl.Mask, sMaskEdit, sCustomComboEdit,
  Vcl.ComCtrls, sListView, acShellCtrls, Vcl.ExtCtrls, sPanel, sFrameAdapter,
  sStoreUtils, System.Actions, Vcl.ActnList, Vcl.Buttons, sBitBtn, sEdit, sMemo,
  Vcl.Grids, JvExGrids, JvStringGrid, ShellCtrls, sComboBox, System.JSON,
  System.IOUtils, Uni, ComObj, sCheckBox, Winapi.ShellAPI, DateUtils, Data.DB,
  Vcl.DBGrids, acDBGrid, sLabel;

type
  TfrmAdmDohod = class(TCustomInfoFrame)
    sPanel1: TsPanel;
    ssLvFiles: TsShellListView;
    sDirEdit: TsDirectoryEdit;
    sFnEdit: TsFilenameEdit;
    spTop: TsPanel;
    btnStart: TsBitBtn;
    ActionList: TActionList;
    acBtnStart: TAction;
    btnOk: TsBitBtn;
    spAll: TsPanel;
    acOk: TAction;
    spJSON: TsPanel;
    memJSON: TsMemo;
    sedJDCID: TsEdit;
    StrGrDohod: TJvStringGrid;
    cbTypeDohod: TsComboBox;
    sedFindFIO: TsEdit;
    cbPIB: TsComboBox;
    btnParse: TsBitBtn;
    cbCost: TsComboBox;
    btnSearch: TsBitBtn;
    acReParse: TAction;
    acReSearch: TAction;
    btnExportExcel: TsBitBtn;
    acExportExcel: TAction;
    btnRefresh: TsBitBtn;
    chbAuto: TsCheckBox;
    sdeStart: TsDateEdit;
    btnExportDebtors: TBitBtn;
    lblTotalAll: TsLabel;
    lblTotalDone: TsLabel;
    lblTotalLeft: TsLabel;
    sDBGrid1: TsDBGrid;
    procedure sDirEditChange(Sender: TObject);
    procedure sFnEditChange(Sender: TObject);
    procedure acBtnStartUpdate(Sender: TObject);
    procedure btnStartClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure acOkUpdate(Sender: TObject);
    procedure cbPIBChange(Sender: TObject);
    procedure btnParseClick(Sender: TObject);
    procedure acReParseUpdate(Sender: TObject);
    procedure btnSearchClick(Sender: TObject);
    procedure acReSearchUpdate(Sender: TObject);
    procedure acExportExcelUpdate(Sender: TObject);
    procedure btnExportExcelClick(Sender: TObject);
    procedure bnRefreshClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure sdeStartChange(Sender: TObject);
    procedure btnExportDebtorsClick(Sender: TObject);
  private
    { Private declarations }
    FCurrentFileIndex: Integer; // Поточний індекс файла у списку
    function RunPythonScript(const AScriptPath, AInputFilePath: string): string;
    function GetItemFullPath(AIndex: Integer): string;
    function MapIncomeType(const ARawType: string): string;
    procedure ProcessCurrentFile;
    procedure InitGridDohod;
    procedure ParseJsonToFieldsFromMemo;
    procedure FindJDCIDByFIO(const AFIO: string);
    procedure ArchiveProcessedFile(const ASourceFilePath, AFIO: string);
    procedure RecheckFIO(const AFIO: string);
    procedure CheckAutoClickOk;
    procedure UpdateAnalytics;
  public
    { Public declarations }
    procedure AfterCreation; override;
    procedure BeforeDestruct; override;
  end;

implementation

{$R *.dfm}

uses uAutorize, myUtils, uDM, uMainForm;

{ TfrmAdmDohod }

procedure TfrmAdmDohod.AfterCreation;
var
  s: string;
begin
  inherited;
  FCurrentFileIndex := -1;
  // 1. Явно вказуємо тип з acShellCtrls
  ssLvFiles.ObjectTypes := [acShellCtrls.otNonFolders];

  s := sStoreUtils.ReadIniString('Dohod', 'PathScript', IniName);
  if s <> '' then
    sFnEdit.Text := s;

  s := sStoreUtils.ReadIniString('Dohod', 'PathScan', IniName);
  if s <> '' then
  begin
    sDirEdit.Text := s;
    ssLvFiles.Root := sDirEdit.Text;
  end;

  // spJSON
  s := sStoreUtils.ReadIniString('Dohod', 'DataInputDohod', IniName);
  if s <> '' then
    sdeStart.Text := s;

  InitGridDohod;
  UpdateAnalytics;

lblTotalLeft.UseSkinColor := False; // Вимикаємо колір скину
lblTotalLeft.Font.Color := clBlue;
end;

procedure TfrmAdmDohod.BeforeDestruct;
begin
  inherited;
end;

procedure TfrmAdmDohod.InitGridDohod;
begin
  with StrGrDohod do
  begin
    Cells[0, 0] := 'JDCID';
    Cells[1, 0] := 'ПІБ';
    Cells[2, 0] := 'Тип доходу';
    Cells[3, 0] := 'Сума';
  end;

end;

// ------------------- Update -------------------
procedure TfrmAdmDohod.acBtnStartUpdate(Sender: TObject);
begin
  inherited;
  btnStart.Enabled := (ssLvFiles.Items.Count > 0) and FileExists(sFnEdit.Text);
end;

procedure TfrmAdmDohod.acExportExcelUpdate(Sender: TObject);
begin
  inherited;
  // Кнопка активна, якщо RowCount > 2
  // АБО якщо рядків 2, але перший робочий рядок не порожній

  { btnExportExcel.Enabled := (StrGrDohod.RowCount > 2) or
    ((StrGrDohod.RowCount = 2) and (Trim(StrGrDohod.Cells[0, 1]) <> '')); }

  if (StrGrDohod.RowCount > 2) or
    ((StrGrDohod.RowCount = 2) and (Trim(StrGrDohod.Cells[0, 1]) <> '')) then
  begin
    btnExportExcel.Enabled := true;
    if memJSON.Tag = 0 then
    begin
      memJSON.Tag := 1;
      btnParseClick(Self);
    end;

  end
  else
    btnExportExcel.Enabled := false;

end;

procedure TfrmAdmDohod.acOkUpdate(Sender: TObject);
begin
  inherited;
  if (cbPIB.Text <> '') and (sedJDCID.Text <> '') and (cbCost.Text <> '') and
    (cbTypeDohod.Text <> '') then
    btnOk.Enabled := true
  else
    btnOk.Enabled := false;
end;

procedure TfrmAdmDohod.acReParseUpdate(Sender: TObject);
var
  s: string;
begin
  inherited;
  s := Trim(memJSON.Text);

  // Кнопка активна, якщо є текст і він НЕ починається зі слів "Обробка файла:"
  btnParse.Enabled := (s <> '') and not s.StartsWith('Обробка файла:', true);
end;

procedure TfrmAdmDohod.acReSearchUpdate(Sender: TObject);
begin
  inherited;
  if (sedFindFIO.Text <> '') then
    btnSearch.Enabled := true
  else
    btnSearch.Enabled := false;

end;
// ============================================================================

{ Тіпізація пенсія - Пенсия }
function TfrmAdmDohod.MapIncomeType(const ARawType: string): string;
var
  CleanType: string;
begin
  // AnsiLowerCase коректно переводить кирилицю у нижній регістр
  CleanType := AnsiLowerCase(Trim(ARawType));

  // Видаляємо можливі переноси рядків з JSON
  CleanType := StringReplace(CleanType, #13, '', [rfReplaceAll]);
  CleanType := StringReplace(CleanType, #10, '', [rfReplaceAll]);

  // Зіставлення українських / неформатованих назв із пунктами ComboBox
  if (CleanType = 'пенсія') or (CleanType = 'пенсия') then
    Result := 'Пенсия'
  else if (CleanType = 'заробітна плата') or (CleanType = 'зарплата') or
    (CleanType = 'заработная плата') then
    Result := 'Заработная плата'
  else if (CleanType = 'пособие') or (CleanType = 'допомога') or
    (CleanType = 'соц. помощь') then
    Result := 'Пособие'
  else if (CleanType = 'доход от частного бизнеса') or
    (CleanType = 'дохід від бізнесу') or (CleanType = 'фоп') then
    Result := 'Доход от частного бизнеса'
  else if (CleanType = 'алименты') or (CleanType = 'аліменти') then
    Result := 'Алименты'
  else if (CleanType = 'помощь из других источников') or
    (CleanType = 'допомога з інших джерел') or (CleanType = 'інше') then
    Result := 'Помощь из других источников'
  else
    Result := ARawType; // Якщо збігів немає, повертаємо як є
end;

{ Отримання повного шляху до обраного файла зі списку }
function TfrmAdmDohod.GetItemFullPath(AIndex: Integer): string;
var
  FolderPath: string;
begin
  Result := '';
  if (AIndex >= 0) and (AIndex < ssLvFiles.Items.Count) then
  begin
    FolderPath := IncludeTrailingPathDelimiter(sDirEdit.Text);
    // 2. Явний доступ через Item[AIndex]
    Result := FolderPath + ssLvFiles.Items.Item[AIndex].Caption;
  end;
end;

{ Виклик Python-скрипта та перехоплення JSON }
function TfrmAdmDohod.RunPythonScript(const AScriptPath, AInputFilePath
  : string): string;
var
  SA: TSecurityAttributes;
  SI: TStartupInfo;
  PI: TProcessInformation;
  StdOutRead, StdOutWrite: THandle;
  CommandLine: string;
  Buffer: array [0 .. 4095] of AnsiChar;
  BytesRead: DWORD;
  StringStream: TStringStream;
  TotalBytesAvailable: DWORD;
begin
  Result := '';

  SA.nLength := SizeOf(TSecurityAttributes);
  SA.bInheritHandle := true;
  SA.lpSecurityDescriptor := nil;

  if not CreatePipe(StdOutRead, StdOutWrite, @SA, 0) then
    Exit;
  try
    SetHandleInformation(StdOutRead, HANDLE_FLAG_INHERIT, 0);

    FillChar(SI, SizeOf(TStartupInfo), 0);
    SI.cb := SizeOf(TStartupInfo);
    SI.dwFlags := STARTF_USESTDHANDLES or STARTF_USESHOWWINDOW;
    SI.wShowWindow := SW_HIDE;
    SI.hStdOutput := StdOutWrite;
    SI.hStdError := StdOutWrite;

    CommandLine := Format('python "%s" "%s"', [AScriptPath, AInputFilePath]);

    if CreateProcess(nil, PChar(CommandLine), nil, nil, true, CREATE_NO_WINDOW,
      nil, nil, SI, PI) then
    begin
      CloseHandle(StdOutWrite);
      // Закриваємо хендл запису в батьківському процесі

      StringStream := TStringStream.Create('', TEncoding.UTF8);
      try
        // Чекаємо завершення процесу, не блокуючи головний потік Windows
        while WaitForSingleObject(PI.hProcess, 50) = WAIT_TIMEOUT do
        begin
          // Прокачуємо чергу повідомлень Windows, щоб форма не "зависала"
          Application.ProcessMessages;
        end;

        // Зчитуємо весь вивід із Pipe після завершення процесу
        while PeekNamedPipe(StdOutRead, nil, 0, nil, @TotalBytesAvailable, nil)
          and (TotalBytesAvailable > 0) do
        begin
          if ReadFile(StdOutRead, Buffer, SizeOf(Buffer) - 1, BytesRead, nil)
            and (BytesRead > 0) then
          begin
            Buffer[BytesRead] := #0;
            StringStream.WriteBuffer(Buffer[0], BytesRead);
          end;
        end;

        Result := StringStream.DataString;
      finally
        StringStream.Free;
      end;

      CloseHandle(PI.hProcess);
      CloseHandle(PI.hThread);
    end;
  finally
    CloseHandle(StdOutRead);
  end;
end;

// ---------  RecheckFIO   ------------
procedure TfrmAdmDohod.RecheckFIO(const AFIO: string);
var
  q: TUniQuery;
  CleanFIO, SearchPattern, CurrentFIO: string;
begin
  CleanFIO := Trim(AFIO);

  if sedFindFIO.Text <> CleanFIO then
    sedFindFIO.Text := CleanFIO;

  // memPIBvariant.Lines.Clear;
  cbPIB.Items.Clear;

  if CleanFIO = '' then
  begin
    cbPIB.Text := '';
    sedJDCID.Text := '';
    cbPIB.Text := '';
    Exit;
  end;

  SearchPattern := '%' + StringReplace(CleanFIO, ' ', '%',
    [rfReplaceAll]) + '%';

  q := TUniQuery.Create(nil);
  try
    q.Connection := DM.UniConnection;

    q.SQL.Text := 'SELECT `JDC ID`, `ФИО` FROM admUch ' + 'WHERE `ФИО` LIKE ' +
      QuotedStr(SearchPattern) + ' ' + 'ORDER BY `ФИО`';
    q.Open;

    if q.RecordCount = 1 then
    begin
      // 🟢 1 варіант: заповнюємо всі поля
      sedJDCID.Text := q.FieldByName('JDC ID').AsString;
      cbPIB.Text := q.FieldByName('ФИО').AsString;

      cbPIB.Items.Add(q.FieldByName('ФИО').AsString);
      cbPIB.ItemIndex := 0;

      // memPIBvariant.Lines.Add(Format('%s - %s', [q.FieldByName('JDC ID').AsString, q.FieldByName('ФИО').AsString]));
    end
    else if q.RecordCount > 1 then
    begin
      // 🟡 Декілька варіантів: додаємо їх у cbPIB і відкриваємо список
      sedJDCID.Text := '';
      cbPIB.Text := Format('-- Оберіть із %d варіантів --', [q.RecordCount]);

      while not q.Eof do
      begin
        CurrentFIO := q.FieldByName('ФИО').AsString;

        cbPIB.Items.Add(CurrentFIO);
        // memPIBvariant.Lines.Add(Format('%s - %s', [q.FieldByName('JDC ID').AsString, CurrentFIO]));

        q.Next;
      end;

      // Програмно відкриваємо випадаючий список ComboBox для вибору
      cbPIB.DroppedDown := true;
    end
    else
    begin
      // 🔴 Нічого не знайдено
      sedJDCID.Text := '';

      cbPIB.Text := CleanFIO;
    end;

    q.Close;
  finally
    q.Free;
  end;
end;

// ------------------- ParseJsonToFieldsFromMemo ----------------------
procedure TfrmAdmDohod.ParseJsonToFieldsFromMemo;
var
  JsonStr, ValStr, FoundPIB, SelectedAmountStr: string;
  JsonValue: TJSONValue;
  JsonObj, DetailObj: TJSONObject;
  JsonArr: TJSONArray;
  i, ItemIdx: Integer;
  SelectedAmountNum, AmountNum: Double;
begin
  JsonStr := Trim(memJSON.Lines.Text);

  // 1. Очищення від UTF-8 BOM (якщо файл був збережений з BOM)
  if (Length(JsonStr) > 0) and (JsonStr[1] = #$FEFF) then
    Delete(JsonStr, 1, 1);

  JsonStr := Trim(JsonStr);

  // 2. Перевірка на наявність тексту
  if JsonStr = '' then
  begin
    ShowMessage('Поле memJSON порожнє!');
    Exit;
  end;

  // 3. Безпечний парсинг JSON
  JsonValue := TJSONObject.ParseJSONValue(JsonStr);
  if not(JsonValue is TJSONObject) then
  begin
    FreeAndNil(JsonValue);
    ShowMessage('Помилка: текст у memJSON не є валидним JSON-об''єктом!');
    Exit;
  end;

  JsonObj := JsonValue as TJSONObject;
  try
    // Очищаємо cbCost перед новим заповненням
    cbCost.Items.Clear;

    // --- 1. ПІБ -> sedFindFIO + Пошук у БД admUch ---
    if JsonObj.TryGetValue<string>('pib_ru', FoundPIB) then
    begin
      sedFindFIO.Text := FoundPIB;
      RecheckFIO(FoundPIB);
    end
    else
    begin
      sedFindFIO.Text := '';
      cbPIB.Text := '';
      sedJDCID.Text := '';
    end;

    // --- 2. СУМА -> cbCost ---
    if JsonObj.TryGetValue<Double>('selected_amount', SelectedAmountNum) then
      SelectedAmountStr := FloatToStr(SelectedAmountNum)
    else if not JsonObj.TryGetValue<string>('selected_amount', SelectedAmountStr)
    then
      SelectedAmountStr := '';

    if JsonObj.TryGetValue<TJSONArray>('monthly_details', JsonArr) then
    begin
      for i := 0 to JsonArr.Count - 1 do
      begin
        if JsonArr.Items[i] is TJSONObject then
        begin
          DetailObj := JsonArr.Items[i] as TJSONObject;

          if DetailObj.TryGetValue<Double>('amount', AmountNum) then
            ValStr := FloatToStr(AmountNum)
          else if not DetailObj.TryGetValue<string>('amount', ValStr) then
            ValStr := '';

          if (ValStr <> '') and (cbCost.Items.IndexOf(ValStr) = -1) then
            cbCost.Items.Add(ValStr);
        end;
      end;
    end;

    if (SelectedAmountStr <> '') and
      (cbCost.Items.IndexOf(SelectedAmountStr) = -1) then
      cbCost.Items.Add(SelectedAmountStr);

    if SelectedAmountStr <> '' then
    begin
      ItemIdx := cbCost.Items.IndexOf(SelectedAmountStr);
      if ItemIdx <> -1 then
        cbCost.ItemIndex := ItemIdx
      else
        cbCost.Text := SelectedAmountStr;
    end
    else
    begin
      cbCost.ItemIndex := -1;
      cbCost.Text := '';
    end;

    // --- 3. ТИП ДОХОДУ -> cbTypeDohod ---
    if JsonObj.TryGetValue<string>('income_type', ValStr) then
    begin
      // Очищаємо від пробілів та спецсимволів
      ValStr := Trim(ValStr);
      ValStr := StringReplace(ValStr, #13, '', [rfReplaceAll]);
      ValStr := StringReplace(ValStr, #10, '', [rfReplaceAll]);

      // Мапимо в нормалізований вигляд ("пенсія" -> "Пенсия")
      // Нормалізація через AnsiLowerCase в MapIncomeType
      ValStr := MapIncomeType(ValStr);

      // Шукаємо в елементах ComboBox без урахування регістру
      ItemIdx := -1;
      for i := 0 to cbTypeDohod.Items.Count - 1 do
      begin
        if AnsiSameText(cbTypeDohod.Items[i], ValStr) then
        begin
          ItemIdx := i;
          Break;
        end;
      end;

      if ItemIdx <> -1 then
      begin
        cbTypeDohod.ItemIndex := ItemIdx;
        // Примусово оновлюємо відображення тексту в ComboBox
        cbTypeDohod.Text := cbTypeDohod.Items[ItemIdx];
      end
      else
        cbTypeDohod.Text := ValStr;
    end
    else
    begin
      cbTypeDohod.ItemIndex := -1;
      cbTypeDohod.Text := '';
    end;
    CheckAutoClickOk;

  finally
    JsonObj.Free;
  end;
end;

// ------------------------------------------

{ Обробка поточного файла }
procedure TfrmAdmDohod.ProcessCurrentFile;
var
  ScriptPath, InputFilePath, ResultJsonPath: string;
begin
  if (FCurrentFileIndex < 0) or (FCurrentFileIndex >= ssLvFiles.Items.Count)
  then
  begin
    ShowMessage('Усі файли успішно оброблено!');
    memJSON.Clear;
    Exit;
  end;

  ScriptPath := Trim(sFnEdit.Text);
  if not FileExists(ScriptPath) then
  begin
    ShowMessage('Вкажіть коректний шлях до Python-скрипта!');
    Exit;
  end;

  InputFilePath := GetItemFullPath(FCurrentFileIndex);
  if not FileExists(InputFilePath) then
  begin
    ShowMessage('Не вдалося знайти файл: ' + InputFilePath);
    Exit;
  end;

  // Підсвічуємо поточний файл у списку
  ssLvFiles.ItemIndex := FCurrentFileIndex;
  if Assigned(ssLvFiles.Selected) then
    ssLvFiles.Selected.MakeVisible(false);

  memJSON.Lines.Text := 'Обробка файла: ' +
    ExtractFileName(InputFilePath) + '...';

  Application.ProcessMessages;

  // 1. Запускаємо Python-скрипт і чекаємо виконання
  RunPythonScript(ScriptPath, InputFilePath);

  // 2. Визначаємо шлях до result.json
  ResultJsonPath := ExtractFilePath(ScriptPath) + 'result.json';
  if not FileExists(ResultJsonPath) then
    ResultJsonPath := ExtractFilePath(InputFilePath) + 'result.json';

  // 3. Якщо result.json існує — завантажуємо в memJSON і розкладаємо по полях
  if FileExists(ResultJsonPath) then
  begin
    memJSON.Lines.LoadFromFile(ResultJsonPath, TEncoding.UTF8);

    // Примусово оновлюємо інтерфейс, щоб memJSON встиг обробити текст
    Application.ProcessMessages;

    // Розпаршуємо дані з завантаженого memJSON
    ParseJsonToFieldsFromMemo;
  end
  else
  begin
    memJSON.Lines.Text := 'Помилка: файл result.json не знайдено!';
  end;
end;

// --------- кнопка Старт ---------------
procedure TfrmAdmDohod.btnStartClick(Sender: TObject);
begin
  if ssLvFiles.Items.Count = 0 then
  begin
    ShowMessage('Список файлів порожній! Збережи в Excel');
    Exit;
  end;

  FCurrentFileIndex := 0;
  ProcessCurrentFile;
end;

// --------- кнопка ОК / Наступний ---------------
procedure TfrmAdmDohod.btnOkClick(Sender: TObject);
var
  NewRow: Integer;
  CurrentFilePath: string;
  jdc, pib, tDoh, cena: String;
begin
  jdc := Trim(sedJDCID.Text);
  pib := Trim(cbPIB.Text);
  tDoh := Trim(cbTypeDohod.Text);
  cena := Trim(cbCost.Text);

  sedJDCID.Text := '';
  cbPIB.Text := '';
  cbTypeDohod.Text := '';
  cbCost.Text := '';
  sedFindFIO.Text := '';
  Application.ProcessMessages;

  if FCurrentFileIndex < 0 then
  begin
    btnStartClick(Sender);
    Exit;
  end;

  // 1. Визначаємо індекс для нового рядка
  // Якщо перший рядок даних порожній — використовуємо його, інакше додаємо новий
  if (StrGrDohod.RowCount = 2) and (StrGrDohod.Cells[0, 1] = '') and
    (StrGrDohod.Cells[1, 1] = '') then
    NewRow := 1
  else
  begin
    NewRow := StrGrDohod.RowCount;
    StrGrDohod.RowCount := StrGrDohod.RowCount + 1;
  end;

  // 2. Записуємо значення з полів у новий рядок
  StrGrDohod.Cells[0, NewRow] := jdc;
  StrGrDohod.Cells[1, NewRow] := pib;
  StrGrDohod.Cells[2, NewRow] := tDoh;
  StrGrDohod.Cells[3, NewRow] := cena;

  // 3. 🟢 ПРОКРУТКА ДО ОСТАННЬОГО РЯДКА:
  StrGrDohod.Row := NewRow; // Встановлюємо активний рядок на новостворений
  // StrGrDohod.TopRow := StrGrDohod.RowCount - 1; // Прокручуємо скролбар до низу

  // 4. ДІЮЧИЙ ФАЙЛ: перейменовуємо та переміщуємо в папку Обработанное_дата
  CurrentFilePath := GetItemFullPath(FCurrentFileIndex);
  ArchiveProcessedFile(CurrentFilePath, pib);

  // 5. Переходимо до наступного файла

  Inc(FCurrentFileIndex);
  ProcessCurrentFile;
  AdjustGridColumnWidths(StrGrDohod);

  // обнуляємо для кнопки Перепрасити
  memJSON.Tag := 0;

end;

// ---------- кнопка Перепарсити ---------------------
procedure TfrmAdmDohod.btnParseClick(Sender: TObject);
begin
  inherited;
  ParseJsonToFieldsFromMemo;
end;

// --------------перепошук --------------------
procedure TfrmAdmDohod.btnSearchClick(Sender: TObject);
begin
  inherited;
  // Перераховуємо дані з БД по відкоригованому ПІБ
  RecheckFIO(sedFindFIO.Text);
end;

// ------------ Рефреш кнопки для файлів ----------------
procedure TfrmAdmDohod.bnRefreshClick(Sender: TObject);
begin
  inherited;

end;

// ------------------- Боржники довідок ---------------------
procedure TfrmAdmDohod.btnExportDebtorsClick(Sender: TObject);
var
  q: TUniQuery;
  ExcelApp, Workbook, Sheet: OleVariant;
  NextYear, Row, AddedCount, TotalRecords: Integer;
  TargetFolder, CurrentDateTimeStr, SavePath: string;
begin
  // 1. Визначаємо наступний рік від поточного (наприклад, 2027)
  NextYear := YearOf(Date) + 1;

  // 2. Створюємо та налаштовуємо TUniQuery
  q := TUniQuery.Create(nil);
  try
    q.Connection := DM.UniConnection;

    // SQL-запит із доданими полями "Город проживания" та "Адрес без города"
    q.SQL.Text := 'SELECT ' + '  u.`JDC ID`, ' + '  u.`ФИО`, ' +
      '  u.`Куратор`, ' + '  u.`Тип участника`, ' +
    // Поле розкоментовано та додано до SELECT
      '  u.`Город проживания`, ' + '  u.`Адрес без города` ' + 'FROM admUch u '
      + 'LEFT JOIN Dohods d ' + '  ON u.`JDC ID` = d.`JDC ID` ' +
      ' AND d.`Рік заповнення` = :NextYear ' +
      'WHERE u.`Тип участника` LIKE ''%Клиент Хеседа%'' ' +
      '  AND u.`Основная организация` = ''Хесед Бешт - Хмельницкий'' ' +
      '  AND d.`JDC ID` IS NULL ' + // Означає, що в Dohods запису немає
      'ORDER BY u.`Куратор`, u.`ФИО`;';

    q.ParamByName('NextYear').AsInteger := NextYear;
    q.Open;

    if q.IsEmpty then
    begin
      ShowMessage(Format('Боржників довідок на %d рік не знайдено!',
        [NextYear]));
      Exit;
    end;

    // 3. Формуємо папку та назву файлу
    TargetFolder := ExtractFilePath(ParamStr(0)) + 'Доход\';
    if not DirectoryExists(TargetFolder) then
      ForceDirectories(TargetFolder);

    CurrentDateTimeStr := FormatDateTime('dd.mm.yyyy_hh-nn-ss', Now);
    SavePath := TargetFolder + Format('Боржники довідок на %s.xlsx',
      [CurrentDateTimeStr]);

    // 4. Налаштування та активація ProgressBar
    TotalRecords := q.RecordCount;
    myForm.ProgressBar.Min := 0;
    myForm.ProgressBar.Max := TotalRecords;
    myForm.ProgressBar.Position := 0;
    myForm.ProgressBar.Visible := true;
    Application.ProcessMessages; // Оновлюємо інтерфейс

    // 5. Запускаємо Excel
    try
      ExcelApp := CreateOleObject('Excel.Application');
      ExcelApp.Visible := false;
      ExcelApp.DisplayAlerts := false;
    except
      on E: Exception do
      begin
        myForm.ProgressBar.Visible := false; // Ховаємо ProgressBar при помилці
        ShowMessage('Помилка запуску MS Excel: ' + E.Message);
        Exit;
      end;
    end;

    try
      Workbook := ExcelApp.Workbooks.Add;
      Sheet := Workbook.Worksheets[1];

      // Форматування колонки JDC ID як текстової, щоб зберегти провідні нулі
      Sheet.Columns[1].NumberFormat := '@';

      // Формуємо шапку таблиці
      Sheet.Cells[1, 1].Value := 'JDC ID';
      Sheet.Cells[1, 2].Value := 'ФИО';
      Sheet.Cells[1, 3].Value := 'Куратор';

      // Sheet.Cells[1, 4].Value := 'Дата рождения';
      // Sheet.Cells[1, 5].Value := 'Основная организация';
      Sheet.Cells[1, 4].Value := 'Тип участника';
      Sheet.Cells[1, 5].Value := 'Город проживания';
      Sheet.Cells[1, 6].Value := 'Адрес без города';

      // Стилізуємо шапку (жирний шрифт)
      Sheet.Range['A1', 'G1'].Font.Bold := true;

      Row := 2;
      AddedCount := 0;

      while not q.Eof do
      begin
        Sheet.Cells[Row, 1].NumberFormat := '@';
        Sheet.Cells[Row, 1].Value := q.FieldByName('JDC ID').AsString;
        Sheet.Cells[Row, 2].Value := q.FieldByName('ФИО').AsString;
        Sheet.Cells[Row, 3].Value := q.FieldByName('Куратор').AsString;

        // if not q.FieldByName('Дата рождения').IsNull then
        // Sheet.Cells[Row, 4].Value := q.FieldByName('Дата рождения').AsDateTime;

        Sheet.Cells[Row, 4].Value := q.FieldByName('Тип участника').AsString;
        Sheet.Cells[Row, 5].Value := q.FieldByName('Город проживания').AsString;
        Sheet.Cells[Row, 6].Value := q.FieldByName('Адрес без города').AsString;

        Inc(Row);
        Inc(AddedCount);

        // Оновлюємо ProgressBar
        myForm.ProgressBar.Position := AddedCount;
        Application.ProcessMessages;

        q.Next;
      end;

      // Автопідбір ширини колонок
      Sheet.Columns.AutoFit;

      // Зберігаємо Excel-файл
      Workbook.SaveAs(SavePath);
      Workbook.Close;
      ExcelApp.Quit;

      ShowMessage(Format('Формування завершено!' + sLineBreak +
        'Знайдено боржників: %d' + sLineBreak + 'Файл збережено: %s',
        [AddedCount, SavePath]));

      // Відкриваємо папку з результатом
      ShellExecute(Handle, 'open', PWideChar(TargetFolder), nil, nil,
        SW_SHOWNORMAL);

    finally
      // Ховаємо ProgressBar та вивільняємо об'єкти Excel
      myForm.ProgressBar.Visible := false;
      Sheet := Unassigned;
      Workbook := Unassigned;
      ExcelApp := Unassigned;
    end;

  finally
    q.Free;
  end;
end;

// -------------- Експорт в Ексель -------------------------
procedure TfrmAdmDohod.btnExportExcelClick(Sender: TObject);
var
  ExcelApp, Workbook, Sheet: OleVariant;
  TargetFolder, TemplatePath, SavePath, CurrentDateTimeStr: string;
  GridRow, ExcelRow, Col, AddedCount: Integer;
  HasData: Boolean;
  ValueStr: string;
  NextYear: Integer;
  SumValue: Double;
  StrSum: string;
  FS: TFormatSettings;
  q: TUniQuery;
begin
  // 1. Перевіряємо наявність даних у таблиці
  HasData := false;
  for GridRow := 1 to StrGrDohod.RowCount - 1 do
  begin
    if Trim(StrGrDohod.Cells[0, GridRow]) <> '' then
    begin
      HasData := true;
      Break;
    end;
  end;

  if not HasData then
  begin
    ShowMessage('Немає даних для експорту!');
    Exit;
  end;

  // 2. Перевіряємо заповнення дати початку дії
  if sdeStart.Date = 0 then
  begin
    ShowMessage('Вкажіть дату початку дії (sdeStart)!');
    sdeStart.SetFocus;
    Exit;
  end;

  // 3. Формуємо шлях до папки "Доходы"
  TargetFolder := ExtractFilePath(ParamStr(0)) + 'Доходы\';
  if not DirectoryExists(TargetFolder) then
    ForceDirectories(TargetFolder);

  TemplatePath := ExtractFilePath(ParamStr(0)) + 'Доходы - шаблон.xlsx';
  if not FileExists(TemplatePath) then
  begin
    ShowMessage('Не знайдено файл шаблону Excel: ' + TemplatePath);
    Exit;
  end;

  CurrentDateTimeStr := FormatDateTime('dd.mm.yyyy_hh-nn-ss', Now);
  SavePath := TargetFolder + Format('Доходы_%s.xlsx', [CurrentDateTimeStr]);

  // =========================================================================
  // ЕТАП 1: ФОРМУВАННЯ ТА ЗБЕРЕЖЕННЯ EXCEL (Без змін)
  // =========================================================================
  try
    ExcelApp := CreateOleObject('Excel.Application');
    ExcelApp.Visible := false;
    ExcelApp.DisplayAlerts := false;
  except
    on E: Exception do
    begin
      ShowMessage('Помилка запуску MS Excel: ' + E.Message);
      Exit;
    end;
  end;

  try
    Workbook := ExcelApp.Workbooks.Open(TemplatePath);
    Sheet := Workbook.Worksheets[1];

    // Встановлюємо текстовий формат (@) для першої колонки (JDC ID)
    Sheet.Columns[1].NumberFormat := '@';

    ExcelRow := 2; // Починаємо з 2-го рядка

    for GridRow := 1 to StrGrDohod.RowCount - 1 do
    begin
      if Trim(StrGrDohod.Cells[0, GridRow]) = '' then
        Continue;

      for Col := 0 to 3 do
      begin
        ValueStr := Trim(StrGrDohod.Cells[Col, GridRow]);

        if Col = 0 then
        begin
          Sheet.Cells[ExcelRow, Col + 1].NumberFormat := '@';
          Sheet.Cells[ExcelRow, Col + 1].Value := ValueStr;
        end
        else
          Sheet.Cells[ExcelRow, Col + 1].Value := ValueStr;
      end;

      Inc(ExcelRow);
    end;

    Workbook.SaveAs(SavePath);
    Workbook.Close;
    ExcelApp.Quit;

  finally
    Sheet := Unassigned;
    Workbook := Unassigned;
    ExcelApp := Unassigned;
  end;

  // =========================================================================
  // ЕТАП 2: ЗАПИС У MYSQL ЧЕРЕЗ DM.UniConnection ТА TUniQuery
  // =========================================================================
  NextYear := YearOf(Date) + 1; // Обчислюємо наступний рік від поточного
  AddedCount := 0;

  GetLocaleFormatSettings(0, FS);
  FS.DecimalSeparator := '.';

  q := TUniQuery.Create(nil);
  try
    q.Connection := DM.UniConnection;

    // Відкриваємо транзакцію для прискорення масової вставки
    if not DM.UniConnection.InTransaction then
      DM.UniConnection.StartTransaction;

    try
      q.SQL.Text := 'INSERT INTO Dohods (' +
        '  `JDC ID`, `ФИО`, `Тип дохода`, `Сумма`, ' +
        '  `Дата начала действия`, `Документы проверены`, ' +
        '  `Источник данных`, `Примечание`, `Рік заповнення`' + ') VALUES (' +
        '  :JDC_ID, :FIO, :TypeDohod, :Summa, ' + '  :StartDate, :DocsChecked, '
        + '  :Source, :Note, :FillYear' + ')';

      for GridRow := 1 to StrGrDohod.RowCount - 1 do
      begin
        if Trim(StrGrDohod.Cells[0, GridRow]) = '' then
          Continue;

        // Очищаємо суму від пробілів та некоректних роздільників
        StrSum := Trim(StrGrDohod.Cells[3, GridRow]);
        StrSum := StringReplace(StrSum, ' ', '', [rfReplaceAll]);
        StrSum := StringReplace(StrSum, ',', '.', [rfReplaceAll]);
        SumValue := StrToFloatDef(StrSum, 0.0, FS);

        // Передаємо параметри у TUniQuery
        q.ParamByName('JDC_ID').AsString := Trim(StrGrDohod.Cells[0, GridRow]);
        q.ParamByName('FIO').AsString := Trim(StrGrDohod.Cells[1, GridRow]);
        q.ParamByName('TypeDohod').AsString :=
          Trim(StrGrDohod.Cells[2, GridRow]);
        q.ParamByName('Summa').AsFloat := SumValue;
        q.ParamByName('StartDate').AsDate := sdeStart.Date;
        q.ParamByName('DocsChecked').AsInteger := 1;
        q.ParamByName('Source').AsString := 'Документ';
        q.ParamByName('Note').AsString := 'из импорта';
        q.ParamByName('FillYear').AsInteger := NextYear;

        q.ExecSQL;
        Inc(AddedCount);
      end;

      // Фіксуємо транзакцію після додавання всіх рядків
      if DM.UniConnection.InTransaction then
        DM.UniConnection.Commit;

      // Фінальний звіт
      ShowMessage('Дані успішно опрацьовано!' + sLineBreak +
        '1. Збережено в Excel: ' + SavePath + sLineBreak +
        Format('2. Додано в базу MySQL: %d записів (Рік: %d)',
        [AddedCount, NextYear]));

      ShellExecute(Handle, 'open', PWideChar(TargetFolder), nil, nil,
        SW_SHOWNORMAL);

    except
      on E: Exception do
      begin
        if DM.UniConnection.InTransaction then
          DM.UniConnection.Rollback;
        ShowMessage('Excel створено, але виникла помилка запису в MySQL: ' +
          E.Message);
      end;
    end;

  finally
    q.Free; // Гарантовано звільняємо пам'ять
    UpdateAnalytics;
  end;
end;

procedure TfrmAdmDohod.cbPIBChange(Sender: TObject);
begin
  // Спрацьовує тільки якщо обрано конкретний елемент із випадаючого списку
  if cbPIB.ItemIndex <> -1 then
  begin
    // Запускаємо пошук за точним обраним ПІБ
    RecheckFIO(cbPIB.Items[cbPIB.ItemIndex]);
  end;
end;

procedure TfrmAdmDohod.CheckAutoClickOk;
begin
  // Перевіряємо, чи увімкнено автонатискання
  if not chbAuto.Checked then
    Exit;

  // Перевіряємо, чи всі поля непорожні
  if (Trim(sedJDCID.Text) <> '') and (Trim(cbPIB.Text) <> '') and
    (Trim(cbTypeDohod.Text) <> '') and (Trim(cbCost.Text) <> '') then
  begin
    // Викликаємо натискання кнопки btnOk
    btnOk.Click;
  end;
end;

procedure TfrmAdmDohod.btnRefreshClick(Sender: TObject);
begin
  inherited;
  ssLvFiles.Refresh;
  // Перевіряємо, чи список не порожній після оновлення
  if ssLvFiles.Items.Count > 0 then

    ssLvFiles.ItemIndex := 0; // Встановлюємо фокус на перший елемент
end;

procedure TfrmAdmDohod.sdeStartChange(Sender: TObject);
begin
  inherited;
  sStoreUtils.WriteIniStr('Dohod', 'DataInputDohod', sdeStart.Text, IniName);
end;

procedure TfrmAdmDohod.sDirEditChange(Sender: TObject);
begin
  inherited;
  ssLvFiles.Root := sDirEdit.Text;
  sStoreUtils.WriteIniStr('Dohod', 'PathScan', sDirEdit.Text, IniName);
end;

procedure TfrmAdmDohod.sFnEditChange(Sender: TObject);
begin
  inherited;
  sStoreUtils.WriteIniStr('Dohod', 'PathScript', sFnEdit.Text, IniName);
end;

procedure TfrmAdmDohod.UpdateAnalytics;
var
  NextYear: Integer;
  TotalAll, TotalDone, TotalLeft: Integer;
begin
  NextYear := YearOf(Date) + 1;
  with DM do
  begin
    qStat.Close;
    qStat.SQL.Text := 'SELECT ' + '  u.`Куратор`, ' +
      '  COUNT(u.`JDC ID`) AS `Всього`, ' + '  COUNT(d.`JDC ID`) AS `Подали`, '
      + '  (COUNT(u.`JDC ID`) - COUNT(d.`JDC ID`)) AS `Боржники`, ' +
      '  ROUND((COUNT(d.`JDC ID`) / COUNT(u.`JDC ID`)) * 100, 1) AS `Відсоток` '
      + 'FROM admUch u ' + 'LEFT JOIN Dohods d ' +
      '  ON u.`JDC ID` = d.`JDC ID` ' + ' AND d.`Рік заповнення` = :NextYear ' +
      'WHERE u.`Тип участника` LIKE ''%Клиент Хеседа%'' ' +
      '  AND u.`Основная организация` = ''Хесед Бешт - Хмельницкий'' ' +
      'GROUP BY u.`Куратор` ' + 'ORDER BY u.`Куратор`;';

    qStat.ParamByName('NextYear').AsInteger := NextYear;
    qStat.Open;
    // Формат відображення: 0.0 означає один знак після коми + знак %
  TNumericField(qStat.FieldByName('Відсоток')).DisplayFormat := '0.0"%"';

    // Підраховуємо підсумки по всьому Хеседу
    TotalAll := 0;
    TotalDone := 0;

    qStat.First;
    while not qStat.Eof do
    begin
      Inc(TotalAll, qStat.FieldByName('Всього').AsInteger);
      Inc(TotalDone, qStat.FieldByName('Подали').AsInteger);
      qStat.Next;
    end;

    TotalLeft := TotalAll - TotalDone;

    // Виводимо підсумкові значення на TLabel
    lblTotalAll.Caption := Format('Всього підопічних: %d', [TotalAll]);
    lblTotalDone.Caption := Format('Подали довідки: %d', [TotalDone]);
    lblTotalLeft.Caption := Format('Залишилось боржників: %d', [TotalLeft]);
  end;
end;

procedure TfrmAdmDohod.ArchiveProcessedFile(const ASourceFilePath,
  AFIO: string);
var
  BaseDir, TargetDir, CleanFIO, FileExt, NewFileName, TargetFilePath,
    ShortFIO: string;
  CurrentYear: string;
begin
  if not FileExists(ASourceFilePath) then
    Exit;

  // 1. Формуємо папку "Обработанное_ДАТА" у поточній директорії сканування
  BaseDir := IncludeTrailingPathDelimiter(sDirEdit.Text);
  TargetDir := BaseDir + 'Обработанное_' + FormatDateTime('dd.mm.yyyy', Date);

  // Створюємо папку, якщо її ще немає
  if not DirectoryExists(TargetDir) then
    ForceDirectories(TargetDir);

  // 2. Скорочуємо ПІБ до ініціалів
  ShortFIO := MakeShortFIO(AFIO);

  // 2. Очищаємо ПІБ від символів, які заборонені в назвах файлів Windows
  CleanFIO := StringReplace(ShortFIO, '\', '_', [rfReplaceAll]);
  CleanFIO := StringReplace(CleanFIO, '/', '_', [rfReplaceAll]);
  CleanFIO := StringReplace(CleanFIO, ':', '_', [rfReplaceAll]);
  CleanFIO := StringReplace(CleanFIO, '*', '_', [rfReplaceAll]);
  CleanFIO := StringReplace(CleanFIO, '?', '_', [rfReplaceAll]);
  CleanFIO := StringReplace(CleanFIO, '"', '_', [rfReplaceAll]);
  CleanFIO := StringReplace(CleanFIO, '<', '_', [rfReplaceAll]);
  CleanFIO := StringReplace(CleanFIO, '>', '_', [rfReplaceAll]);
  CleanFIO := StringReplace(CleanFIO, '|', '_', [rfReplaceAll]);

  // 3. Формуємо нове ім'я файла: Dohod_ПІБ_2026.pdf
  CurrentYear := FormatDateTime('yyyy', Date);
  FileExt := ExtractFileExt(ASourceFilePath);
  // зберігаємо оригінальне розширення (.pdf, .jpg тощо)

  NewFileName := Format('Dohod_%s_%s%s', [CleanFIO, CurrentYear, FileExt]);
  TargetFilePath := IncludeTrailingPathDelimiter(TargetDir) + NewFileName;

  // 4. Переміщуємо або копіюємо файл у нову папку
  // MoveFile переміщує файл (видаляючи його з початкової папки, щоб він не мозолив очі у списку)
  if FileExists(TargetFilePath) then
    DeleteFile(TargetFilePath);
  // Захист від перезапису, якщо файл вже існував

  MoveFile(PChar(ASourceFilePath), PChar(TargetFilePath));
end;

// ----------------------------------------
procedure TfrmAdmDohod.FindJDCIDByFIO(const AFIO: string);
var
  q: TUniQuery;
  CleanFIO, SearchPattern: string;
begin
  CleanFIO := Trim(AFIO);

  // Очищаємо мемо варіантів перед новим пошуком
  // memPIBvariant.Lines.Clear;

  if CleanFIO = '' then
  begin
    cbPIB.Text := '';
    sedJDCID.Text := '';
    Exit;
  end;

  // Формуємо шаблон для LIKE (замінюємо внутрішні пробіли на % для гнучкого пошуку)
  // Наприклад: "Кузнецов Павел" -> "Кузнецов%Павел%"
  SearchPattern := '%' + StringReplace(CleanFIO, ' ', '%',
    [rfReplaceAll]) + '%';

  q := TUniQuery.Create(nil);
  try
    q.Connection := DM.UniConnection; // Ваше підключення

    // Шукаємо за допомогою LIKE
    q.SQL.Text := 'SELECT `JDC ID`, `ФИО` FROM admUch ' + 'WHERE `ФИО` LIKE ' +
      QuotedStr(SearchPattern) + ' ' + 'ORDER BY `ФИО`';
    q.Open;

    if q.RecordCount = 1 then
    begin
      // 🟢 Точно 1 збіг — одразу заповнюємо робочі поля
      sedJDCID.Text := q.FieldByName('JDC ID').AsString;
      cbPIB.Text := q.FieldByName('ФИО').AsString;

      // Також дублюємо в мемо для наочності
      // memPIBvariant.Lines.Add(Format('%s - %s', [q.FieldByName('JDC ID').AsString, q.FieldByName('ФИО').AsString]));
    end
    else if q.RecordCount > 1 then
    begin
      // 🟡 Декілька варіантів — виводимо всі в memPIBvariant і очищаємо точний вибір
      sedJDCID.Text := '';
      cbPIB.Text := CleanFIO + Format(' (знайдено варіантів: %d)',
        [q.RecordCount]);

      while not q.Eof do
      begin
        // memPIBvariant.Lines.Add(Format('%s - %s', [q.FieldByName('JDC ID').AsString, q.FieldByName('ФИО').AsString]));
        q.Next;
      end;
    end
    else
    begin
      // 🔴 Нічого не знайдено
      sedJDCID.Text := '';
      cbPIB.Text := CleanFIO + ' (не знайдено в БД)';
    end;

    q.Close;
  finally
    q.Free;
  end;
end;

end.
