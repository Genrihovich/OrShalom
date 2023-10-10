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
  DM.tZvitSnow.RefreshRecord;
end;

procedure TfrmDovidniky.btnImportClick(Sender: TObject);
var
  m, n, col, z: integer;
  CollectionNameTable: TDictionary<string, integer>;
  pole: String;
  poleDate: TDateTime;
begin
  try

    if uMyExcel.RunExcel(false, false) = true then
      // проверка на инсталл и запуск Excel
      DM.OpenDialog.Filter := 'Файлы MS Excel|*.xls;*.xlsx|';
    if not DM.OpenDialog.Execute then
      Exit;

    if uMyExcel.OpenWorkBook(DM.OpenDialog.FileName, false) then
    // открываем книгу Excel
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
      // ------------------------ конец пробега для  СТОЛБЦОВ --------------------

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

            MyExcel.Application.DisplayAlerts := false;
            StopExcel;
            CollectionNameTable.Clear;
            CollectionNameTable.Free;
            ShowMessage('Такі данні вже є в базі');
            myForm.ProgressBar.Visible := false;
            DM.tZvitSnow.RefreshRecord;
            Exit;
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
  except
    on E: EListError do
    begin
      CollectionNameTable.Free;
      // CleanOutTable('ZvitSnow'); // обнуляем таблицу
      DM.tZvitSnow.Active := false;
      ShowMessage('Не вірний формат файлу, нема необхідних полів');
      StopExcel;
    end;

  end;

end;

end.
