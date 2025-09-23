{
  Модуль в который собраны кастомные процедуры и ф-ции
}
unit myUtils;

interface

uses
  SysUtils, system.Hash, Classes,
  mimemess, mimepart, smtpsend,
  JvStringGrid,
  system.Variants, VCL.Grids, ComObj,
  Generics.Collections, Data.DB, Uni, sMemo, acProgressBar, sLabel,
  System.IniFiles;

type
TProgressCallback = reference to procedure(Pos: Integer);

  // Типи, які ми підтримуємо у Memo (для DB)
  TColType = (ctString, ctInteger, ctFloat, ctDate);

  // Опис одного поля з Memo
  TColMap = record
    ExcelHeader: string; // назва колонки в Excel
    DBName: string;      // ім’я поля у БД
    ColType: TColType;   // очікуваний тип
  end;

  TColMaps = TArray<TColMap>;


function MD5Hash(const Data: WideString): WideString;
// отправка файлов в письме
function SendEmailAndAttach(pHost, pSubject, pTo, pFrom, pTextBody, pHTMLBody,
  pLogin, pPassword, pFilePath: string): boolean;

procedure AutoStringGridWidth(StringGrid: TJvStringGrid);
procedure SaveStringGridToExcel(StringGrid: TStringGrid;
  const FileName: string);
// поиск по номеру столбца в екселе его буквенное значение
function CellsCharFind(index: Integer): String;

// Завантаження мапінгу з Memo
procedure LoadMemoToColMaps(Memo: TsMemo; out ColMaps: TColMaps;
  ProgressCallback: TProc<Integer> = nil);

//Читання Excel і відбір колонок (універсально)
function ReadExcelFileToDict(const FileName: string; const ColMaps: TColMaps;
  ProgressCallback: TProc<Integer> = nil): TArray<TDictionary<string,string>>;


//Експорт у CSV з лапками
procedure ExportToCSV(const FileName: string;
  Data: TArray<TDictionary<string,string>>;
  ProgressCallback: TProc<Integer> = nil);
procedure SplitString(const S: string; Delim: Char; out Parts: TArray<string>);


implementation

uses uFrameAdmExport;// system.Hash;

{
  =================== Создание хеша для пароля ===================
}
function MD5Hash(const Data: WideString): WideString;
begin
  result := THashMD5.GetHashString(Data);
end;

// отправка письма со вложением
function SendEmailAndAttach(pHost, pSubject, pTo, pFrom, pTextBody, pHTMLBody,
  pLogin, pPassword, pFilePath: string): boolean;
var
  tmpMsg: TMimeMess; // собщение
  tmpStringList: TStringList; // содержимое письма
  tmpMIMEPart: TMimePart; // части сообщения (на будущее)
begin
  tmpMsg := TMimeMess.Create;
  tmpStringList := TStringList.Create;
  result := False;
  try
    // Headers  Добавляем заголовки
    tmpMsg.Header.Subject := pSubject; // тема сообщения
    tmpMsg.Header.From := pFrom; // имя и адрес отправителя
    tmpMsg.Header.ToList.Add(pTo); // имя и адрес получателя

    // MIMe Parts  создаем корневой элемент
    tmpMIMEPart := tmpMsg.AddPartMultipart('alternate', nil);

    if Length(pTextBody) > 0 then
    begin
      tmpStringList.Text := pTextBody;
      tmpMsg.AddPartText(tmpStringList, tmpMIMEPart);
    end
    else
    begin
      tmpStringList.Text := pHTMLBody;
      tmpMsg.AddPartHTML(tmpStringList, tmpMIMEPart);
    end;

    // присоединяем файл
    if pFilePath <> '' then
      tmpMsg.AddPartBinaryFromFile(pFilePath, tmpMIMEPart);

    // кодируем и отправляем
    tmpMsg.EncodeMessage;
    if smtpsend.SendToRaw(pFrom, pTo, pHost, tmpMsg.Lines, pLogin, pPassword)
    then
      result := True;

  finally
    tmpMsg.Free;
    tmpStringList.Free;
  end;
end;

{
  ----- подгонка ширины колонок -----
  AutoStringGridWidth(имя JvStringGrid);
}
procedure AutoStringGridWidth(StringGrid: TJvStringGrid);
var
  X, Y, w: Integer;
  MaxWidth: Integer;
begin
  with StringGrid do
    // ClientHeight := DefaultRowHeight * RowCount + 5;
    with StringGrid do
    begin
      for X := 0 to ColCount - 1 do
      begin
        MaxWidth := 0;
        for Y := 0 to RowCount - 1 do
        begin
          w := Canvas.TextWidth(Cells[X, Y]);
          if w > MaxWidth then
            MaxWidth := w;
        end;
        ColWidths[X] := MaxWidth + 5;
      end;
    end;
end;

// SaveStringGridToExcel(StringGrid, ExtractFilePath(Application.ExeName) +'1111.xlsx');
procedure SaveStringGridToExcel(StringGrid: TStringGrid;
  const FileName: string);
var
  ExcelApp: OleVariant;
  ExcelWorkbook: OleVariant;
  ExcelWorksheet: OleVariant;
  i, j: Integer;
begin
  try
    ExcelApp := CreateOleObject('Excel.Application');
    ExcelApp.Visible := False;
    // Установите True, если хотите, чтобы Excel был видимым

    ExcelWorkbook := ExcelApp.Workbooks.Add;
    ExcelWorksheet := ExcelWorkbook.Worksheets[1];

    for i := 0 to StringGrid.RowCount - 1 do
      for j := 0 to StringGrid.ColCount - 1 do
        ExcelWorksheet.Cells[i + 1, j + 1] := StringGrid.Cells[j, i];

    ExcelWorkbook.SaveAs(FileName);
  finally
    ExcelWorkbook.Close;
    ExcelApp.Quit;
    ExcelApp := Unassigned;
  end;
end;

// поиск по номеру столбца в екселе его буквенное значение
function CellsCharFind(index: Integer): String;
var
  collection: TDictionary<Integer, string>;
begin
  collection := TDictionary<Integer, string>.Create();
  try
    collection.Add(1, 'A');
    collection.Add(2, 'B');
    collection.Add(3, 'C');
    collection.Add(4, 'D');
    collection.Add(5, 'E');
    collection.Add(6, 'F');
    collection.Add(7, 'G');
    collection.Add(8, 'H');
    collection.Add(9, 'I');
    collection.Add(10, 'J');
    collection.Add(11, 'K');
    collection.Add(12, 'L');
    collection.Add(13, 'M');
    collection.Add(14, 'N');
    collection.Add(15, 'O');
    collection.Add(16, 'P');
    collection.Add(17, 'Q');
    collection.Add(18, 'R');
    collection.Add(19, 'S');
    collection.Add(20, 'T');
    collection.Add(21, 'U');
    collection.Add(22, 'V');
    collection.Add(23, 'W');
    collection.Add(24, 'X');
    collection.Add(25, 'Y');
    collection.Add(26, 'Z');
    collection.Add(27, 'AA');
    collection.Add(28, 'AB');
    collection.Add(29, 'AC');
    collection.Add(30, 'AD');
    collection.Add(31, 'AE');
    collection.Add(32, 'AF');
    collection.Add(33, 'AG');
    collection.Add(34, 'AH');
    collection.Add(35, 'AI');
    collection.Add(36, 'AJ');
    collection.Add(37, 'AK');
    collection.Add(38, 'AL');
    collection.Add(39, 'AM');
    collection.Add(40, 'AN');
    collection.Add(41, 'AO');
    collection.Add(42, 'AP');
    collection.Add(43, 'AQ');
    collection.Add(44, 'AR');
    collection.Add(45, 'AS');
    collection.Add(46, 'AT');
    collection.Add(47, 'AU');
    collection.Add(48, 'AV');
    collection.Add(49, 'AW');
    collection.Add(50, 'AX');
    collection.Add(51, 'AY');
    collection.Add(52, 'AZ');
    collection.Add(53, 'BA');
    collection.Add(54, 'BB');

    if collection.ContainsKey(index) then
      result := collection[index]
    else
      result := 'Ключ не найден';
  finally
    collection.Free;
  end;
end;


// для  LoadMemoToColMaps поддержка кирилиці
procedure SplitString(const S: string; Delim: Char; out Parts: TArray<string>);
var
  P: Integer;
begin
  SetLength(Parts, 0);
  P := Pos(Delim, S);
  if P > 0 then
  begin
    SetLength(Parts, 2);
    Parts[0] := Copy(S, 1, P - 1);
    Parts[1] := Copy(S, P + 1, Length(S));
  end
  else
  begin
    SetLength(Parts, 1);
    Parts[0] := S;
  end;
end;

// Завантаження мапінгу з Memo
procedure LoadMemoToColMaps(Memo: TsMemo; out ColMaps: TColMaps;
  ProgressCallback: TProc<Integer> = nil);
var
  i: Integer;
  parts, subParts: TArray<string>;
  col: TColMap;
  sType, sLine: string;
begin
  SetLength(ColMaps, Memo.Lines.Count);

  for i := 0 to Memo.Lines.Count - 1 do
  begin
    sLine := Memo.Lines[i]; // Unicode Delphi 10.3

    // Розбиваємо на ExcelHeader = DBName[:Type]
    SplitString(sLine, '=', parts);
    col.ExcelHeader := Trim(parts[0]);

    if Length(parts) > 1 then
      SplitString(parts[1], ':', subParts)
    else
    begin
      SetLength(subParts, 1);
      subParts[0] := '';
    end;

    // Якщо після = нічого немає, беремо ExcelHeader як DBName
    if Trim(subParts[0]) = '' then
      col.DBName := col.ExcelHeader
    else
      col.DBName := Trim(subParts[0]);

    // Визначаємо тип
    if Length(subParts) > 1 then
    begin
      sType := LowerCase(Trim(subParts[1]));
      if sType = 'integer' then
        col.ColType := ctInteger
      else if sType = 'float' then
        col.ColType := ctFloat
      else if sType = 'date' then
        col.ColType := ctDate
      else
        col.ColType := ctString;
    end
    else
      col.ColType := ctString;

    ColMaps[i] := col;

     // 🔹 Оновлюємо прогрес
    if Assigned(ProgressCallback) then
      ProgressCallback(Round((i+1) / Memo.Lines.Count * 100));
  end;
end;



//Читання Excel і відбір колонок (універсально)
function ReadExcelFileToDict(const FileName: string; const ColMaps: TColMaps;
  ProgressCallback: TProc<Integer> = nil): TArray<TDictionary<string,string>>;
var
  ExcelApp, Workbook, Sheet: Variant;
  Row, Col, LastRow, LastCol, i: Integer;
  RowData: TDictionary<string, string>;
  DataList: TArray<TDictionary<string, string>>;
  HeaderMap: TDictionary<string, Integer>;
  ColName: string;
  Pos: Integer;
begin
  ExcelApp := CreateOleObject('Excel.Application');
  ExcelApp.Visible := False;
  Workbook := ExcelApp.Workbooks.Open(FileName);
  Sheet := Workbook.Sheets[1];

  LastRow := Sheet.UsedRange.Rows.Count;
  LastCol := Sheet.UsedRange.Columns.Count;

  HeaderMap := TDictionary<string, Integer>.Create;
  try
    // Зчитуємо заголовки Excel
    for Col := 1 to LastCol do
    begin
      ColName := VarToStr(Sheet.Cells[1, Col].Value);
      HeaderMap.AddOrSetValue(ColName, Col);
    end;

    // Зчитуємо дані
    SetLength(DataList, LastRow - 1);
    for Row := 2 to LastRow do
    begin
      RowData := TDictionary<string, string>.Create;
      for i := 0 to High(ColMaps) do
      begin
        if HeaderMap.ContainsKey(ColMaps[i].ExcelHeader) then
          RowData.Add(ColMaps[i].DBName, VarToStr(Sheet.Cells[Row, HeaderMap[ColMaps[i].ExcelHeader]].Value))
        else
          RowData.Add(ColMaps[i].DBName, '');
      end;
      DataList[Row - 2] := RowData;

          // Оновлення прогресбару через callback
      if Assigned(ProgressCallback) then
      begin
        Pos := Round((Row - 1) / (LastRow - 1) * 100);
        ProgressCallback(Pos);
      end;

    end;

  finally
    HeaderMap.Free;
    Workbook.Close(False);
    ExcelApp.Quit;
  end;

  Result := DataList;
end;



//Експорт у CSV з лапками і очищенням переносів рядків
procedure ExportToCSV(const FileName: string;
  Data: TArray<TDictionary<string,string>>;
  ProgressCallback: TProc<Integer> = nil);
var
  SW: TStreamWriter;
  Row: TDictionary<string,string>;
  Line, Value: string;
  i, j: Integer;
  Keys: TArray<string>;
//  Lines: TStringList;
begin
  if Length(Data) = 0 then Exit;

  Keys := Data[0].Keys.ToArray; //масив назв колонок

  if FileExists(FileName) then
    DeleteFile(FileName); // видаляємо, якщо файл існує



 //   Lines := TStringList.Create;



  SW := TStreamWriter.Create(FileName, False, TEncoding.UTF8);
  try
    // Заголовок
    Line := '';
    for i := 0 to High(Keys) do
    begin
      Line := Line + '"' + Keys[i] + '"';
      if i < High(Keys) then
        Line := Line + ',';
    end;
    SW.WriteLine(Line);

    // Дані
    for i := 0 to High(Data) do
    begin
      Row := Data[i];
      Line := '';
      for j := 0 to High(Keys) do
      begin
        Value := Row[Keys[j]];

        // --- Очищення лапок і переносів рядків ---
        Value := StringReplace(Value, '"', '""', [rfReplaceAll]);
        Value := StringReplace(Value, sLineBreak, ' ', [rfReplaceAll]);
        Value := StringReplace(Value, #13, ' ', [rfReplaceAll]);
        Value := StringReplace(Value, #10, ' ', [rfReplaceAll]);

        Line := Line + '"' + Value + '"';
        if j < High(Keys) then
          Line := Line + ',';
      end;

      SW.WriteLine(Line);



    //  Lines.Add(Line);

          // Якщо потрібно, можна ще окремо зберегти у лог
    // Lines.SaveToFile('debug_lines.txt', TEncoding.UTF8);

      // Оновлюємо прогрес
      if Assigned(ProgressCallback) then
        ProgressCallback(Round(i / High(Data) * 100));
    end;

  finally
    SW.Free;
  //  Lines.Free;
  end;
end;




end.
