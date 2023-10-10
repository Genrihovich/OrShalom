{
  Модуль в который собраны кастомные процедуры и ф-ции
}
unit myUtils;

interface

uses
  SysUtils, system.Hash, Classes,
  mimemess, mimepart, smtpsend,
  JvStringGrid;

function MD5Hash(const Data: WideString): WideString;
// отправка файлов в письме
function SendEmailAndAttach(pHost, pSubject, pTo, pFrom, pTextBody, pHTMLBody,
  pLogin, pPassword, pFilePath: string): boolean;

  procedure AutoStringGridWidth(StringGrid: TJvStringGrid);

implementation

//uses
//system.Hash;

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
  Result := False;
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
      Result := True;

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


end.
