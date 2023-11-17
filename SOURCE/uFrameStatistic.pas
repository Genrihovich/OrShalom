unit uFrameStatistic;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes,
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

uses uDM, myBDUtils, myUtils, WinProcs, DateUtils, uMainForm;

procedure TfrmStatistic.sDateEdit3Change(Sender: TObject);
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
  // --------------- список вида услуг -----------------------
  VidPosluga := TStringList.Create;
  VidPosluga.CommaText := SpisokPoley('ZvitSnow', 'Tema');
  // --------------- список типа контактов -----------------------
  TypeContact := TStringList.Create;
  TypeContact.CommaText := SpisokPoley('ZvitSnow', 'TypeKontakta');

  StringGrid.RowHeights[0] := StringGrid.DefaultRowHeight * 2;

  // Тайтл таблицы
  StringGrid.Cells[0, 0] := 'Вид услуги';
  StringGrid.ColWidths[0] := 140;
  StringGrid.Cells[1, 0] := 'Тип контакта';
  StringGrid.ColWidths[1] := 120;
  StringGrid.Cells[2, 0] := 'Всего контактов';
  StringGrid.Cells[3, 0] := 'Всего клиентов';
  col := 4;

  for i := 0 to Ispolnitel.Count - 1 do
  begin
    StringGrid.Cells[col, 0] := Ispolnitel[i]; // ФИО Исполнителя
    StringGrid.ColCount := StringGrid.ColCount + 1; // добавить колонку
    StringGrid.Cells[col, 1] := 'контакт';
    inc(col);
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

    // загружаем список типов контактов для данной услуги
    TypeContact.CommaText := SpisokPoleyWhere('ZvitSnow', 'TypeKontakta',
      VidPosluga[i]);

    for j := 0 to TypeContact.Count - 1 do
    begin
      StringGrid.RowCount := row + 1; // добавляем строку
      StringGrid.Cells[1, row] := TypeContact[j];
      Application.ProcessMessages;
      inc(row);
    end;
    inc(row);
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
begin
  inherited;
  // StringGrid.Save(ExtractFilePath(Application.ExeName) +'1111.xlsx');
  // StringGrid.SaveToFile(ExtractFilePath(Application.ExeName) +'1111.xlsx');
  // SaveStringGridToExcel(StringGrid, ExtractFilePath(Application.ExeName) +'1111.xlsx');

  // SaveDBGridEhToExportFile(TDBGridEhExportAsXLS, DBGridEh, 'd:\1111.xls', False);
  // SaveDBGridEhToExportFile(TDBGridEhExportAsOLEXLS, OtherZvit,'c:\temp\file1.xlsx',true);
  // SaveDBGridEhToExportFile(TDBGridEhExportAsOLEXLS, DBGridEh,'c:\temp\file1.xlsx',true);
end;

end.
