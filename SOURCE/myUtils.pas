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
  Generics.Collections;

function MD5Hash(const Data: WideString): WideString;
// отправка файлов в письме
function SendEmailAndAttach(pHost, pSubject, pTo, pFrom, pTextBody, pHTMLBody,
  pLogin, pPassword, pFilePath: string): boolean;

procedure AutoStringGridWidth(StringGrid: TJvStringGrid);
procedure SaveStringGridToExcel(StringGrid: TStringGrid;
  const FileName: string);
// поиск по номеру столбца в екселе его буквенное значение
function CellsCharFind(index: Integer): String;

implementation

// uses
// system.Hash;

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

end.
