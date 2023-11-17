{
  ������ � ������� ������� ��������� ��������� � �-���
}
unit myUtils;

interface

uses
  SysUtils, system.Hash, Classes,
  mimemess, mimepart, smtpsend,
  JvStringGrid,
  System.Variants, VCL.Grids, ComObj;

function MD5Hash(const Data: WideString): WideString;
// �������� ������ � ������
function SendEmailAndAttach(pHost, pSubject, pTo, pFrom, pTextBody, pHTMLBody,
  pLogin, pPassword, pFilePath: string): boolean;

  procedure AutoStringGridWidth(StringGrid: TJvStringGrid);

  procedure SaveStringGridToExcel(StringGrid: TStringGrid; const FileName: string);

implementation

//uses
//system.Hash;

{
  =================== �������� ���� ��� ������ ===================
}
function MD5Hash(const Data: WideString): WideString;
begin
  result := THashMD5.GetHashString(Data);
end;


// �������� ������ �� ���������
function SendEmailAndAttach(pHost, pSubject, pTo, pFrom, pTextBody, pHTMLBody,
  pLogin, pPassword, pFilePath: string): boolean;
var
  tmpMsg: TMimeMess; // ��������
  tmpStringList: TStringList; // ���������� ������
  tmpMIMEPart: TMimePart; // ����� ��������� (�� �������)
begin
  tmpMsg := TMimeMess.Create;
  tmpStringList := TStringList.Create;
  Result := False;
  try
    // Headers  ��������� ���������
    tmpMsg.Header.Subject := pSubject; // ���� ���������
    tmpMsg.Header.From := pFrom; // ��� � ����� �����������
    tmpMsg.Header.ToList.Add(pTo); // ��� � ����� ����������

    // MIMe Parts  ������� �������� �������
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

    // ������������ ����
    if pFilePath <> '' then
    tmpMsg.AddPartBinaryFromFile(pFilePath, tmpMIMEPart);

    // �������� � ����������
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
  ----- �������� ������ ������� -----
  AutoStringGridWidth(��� JvStringGrid);
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

procedure SaveStringGridToExcel(StringGrid: TStringGrid; const FileName: string);
var
  ExcelApp: OleVariant;
  ExcelWorkbook: OleVariant;
  ExcelWorksheet: OleVariant;
  i, j: Integer;
begin
  try
    ExcelApp := CreateOleObject('Excel.Application');
    ExcelApp.Visible := False; // ���������� True, ���� ������, ����� Excel ��� �������

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


end.
