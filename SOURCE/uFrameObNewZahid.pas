unit uFrameObNewZahid;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Winapi.ShellAPI,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uFrameCustom, Vcl.StdCtrls,
  Vcl.ExtCtrls, sPanel, sFrameAdapter, DBGridEhGrouping, ToolCtrlsEh,
  DBGridEhToolCtrls, DynVarsEh, EhLibVCL, GridsEh, DBAxisGridsEh, DBGridEh,
  sEdit, sListBox, Vcl.Buttons, sBitBtn, Vcl.Mask, sMaskEdit, sCustomComboEdit,
  sToolEdit, DBCtrlsEh, DBLookupEh, System.Actions, Vcl.ActnList, Data.DB, Uni,
  sGroupBox, sLabel, sButton, sSplitter, JvAppStorage, JvAppIniStorage,
  JvComponentBase, JvFormPlacement, sStoreUtils;

type
  TfrmObNewZahid = class(TCustomInfoFrame)
    panDown: TsPanel;
    btnProvesty: TButton;
    panCenter: TsPanel;
    panTop: TsPanel;
    DBGridEh1: TDBGridEh;
    edFindClient: TsEdit;
    lbClients: TsListBox;
    sPanel1: TsPanel;
    bbtnDel: TsBitBtn;
    deZahid: TsDateEdit;
    edZahid: TsEdit;
    dblbBoss: TDBLookupComboboxEh;
    Label1: TLabel;
    dblbClubs: TDBLookupComboboxEh;
    Label2: TLabel;
    aclZahid: TActionList;
    acProvesty: TAction;
    acDeleteItem: TAction;
    edNoName: TsEdit;
    Label3: TLabel;
    sRadioGroup1: TsRadioGroup;
    labCount: TsWebLabel;
    btnSaveExcel: TsButton;
    acSaveExcel: TAction;
    panLeft: TsPanel;
    sSplitter1: TsSplitter;
    panRight: TsPanel;
    sPanel2: TsPanel;
    SaveDialog1: TSaveDialog;
    procedure btnProvestyClick(Sender: TObject);
    procedure edFindClientChange(Sender: TObject);
    procedure DBGridEh1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lbClientsDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure lbClientsDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure bbtnDelClick(Sender: TObject);
    procedure lbClientsDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure acProvestyUpdate(Sender: TObject);
    procedure acDeleteItemUpdate(Sender: TObject);
    procedure sRadioGroup1Change(Sender: TObject);
    procedure btnSaveExcelClick(Sender: TObject);
    procedure acSaveExcelUpdate(Sender: TObject);
    procedure sSplitter1CanResize(Sender: TObject; var NewSize: Integer;
      var Accept: Boolean); // >>> ДОДАНО
  private
    { Private declarations }
    procedure UpdateListBoxDisplay; // >>> ДОДАНО
    // знайти або вставити клуб і повернути його ID
    function GetOrCreateClubID(const ClubName: string): Integer;
    // Внести людей, які були на заході і сам захід в БД
    procedure InsertNewEvent(const EventName, DateStr, WhoConducted: string;
      ClubID, GuestsCount: Integer; lbClients: TsListBox);
    procedure InicialRegionalData;
    procedure LoadClients; // загрузка клієнтів згідно ролі і регіона
    function IsAdmin: Boolean;
    procedure ReloadClientList;

  public
    { Public declarations }
    procedure AfterCreation; override;
    procedure BeforeDestruct; override;
  end;

var
  frmObNewZahid: TfrmObNewZahid;

implementation

{$R *.dfm}

uses uDM, uFrameObInputZahid, uMainForm, uMyExcel, uAutorize;

procedure TfrmObNewZahid.acDeleteItemUpdate(Sender: TObject);
begin
  inherited;
  if (lbClients.Items.Count > 0) then
    bbtnDel.Enabled := true
  else
    bbtnDel.Enabled := false;
end;

procedure TfrmObNewZahid.acProvestyUpdate(Sender: TObject);
begin
  inherited;
  if (lbClients.Items.Count > 0) and (dblbBoss.Text <> '') and
    (dblbClubs.Text <> '') and (deZahid.Text <> '') and (edZahid.Text <> '')
  then
    btnProvesty.Enabled := true
  else
    btnProvesty.Enabled := false;
end;

procedure TfrmObNewZahid.acSaveExcelUpdate(Sender: TObject);
begin
  inherited;
  if (lbClients.Items.Count > 0) then
    btnSaveExcel.Enabled := true
  else
    btnSaveExcel.Enabled := false;
end;

procedure TfrmObNewZahid.AfterCreation;
var
  S: String;
begin
  inherited;
//  frmObNewZahid.JvFormStorage1.RestoreFormPlacement; // завантаження
  if EventID = 0 then
  begin
    DBGridEh1.DragMode := dmAutomatic;
    lbClients.DragMode := dmManual;
    lbClients.Style := lbOwnerDrawFixed; // >>> ЗМІНА для кастомного малювання
    lbClients.OnDrawItem := lbClientsDrawItem; // >>> ДОДАНО
    myForm.lbInfo.Caption := 'Перетягни ПІБ у список';
    InicialRegionalData; // віставляєм згідно регіону список людей
    sRadioGroup1.ItemIndex := 0;

  end
  else
  begin
    myForm.lbInfo.Caption := 'редагування';

  end;
   S := sStoreUtils.ReadIniString('panLeft', 'Width', IniName);
  if S <> '' then
    panLeft.Width := S.ToInteger;


end;

procedure TfrmObNewZahid.BeforeDestruct;
var // при закритті форми — звільняємо пам’ять
  i: Integer;
begin
  for i := 0 to lbClients.Items.Count - 1 do
    if Assigned(lbClients.Items.Objects[i]) then
      StrDispose(PChar(lbClients.Items.Objects[i]));

 // frmObNewZahid.JvFormStorage1.SaveFormPlacement; // збереження


end;

procedure TfrmObNewZahid.edFindClientChange(Sender: TObject);
var
  a1, a2: String;
begin
  inherited; // Пошук клієнта по полю

  if edFindClient.Text <> '' then
  begin
    a1 := '%' + edFindClient.Text + '%';
    a2 := QuotedStr(a1);
    with DM.qFindClients do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT `ФИО`, `JDC ID` FROM `Clients`');
      SQL.Add('WHERE `ФИО` LIKE :name');
      SQL.Add(' AND `Тип клиента (для поиска)`<> '''' ');

      if not IsAdmin then
        SQL.Add('AND `Куратор` = :KurName');

      case sRadioGroup1.ItemIndex of
        0:
          ; // ВСІ
        1:
          SQL.Add('AND `Тип клиента (для поиска)` LIKE ''%Клиент Хеседа%''');
        2:
          begin
            SQL.Clear;
            SQL.Add('SELECT * FROM `Clients`');
            SQL.Add('WHERE `ФИО` LIKE :name');
            SQL.Add('AND `Возраст` BETWEEN 0 AND 17');
            SQL.Add('AND `Тип клиента (для поиска)` <> ''''');
            if not IsAdmin then
              SQL.Add('AND `Куратор` = :KurName');
          end;
      end;

      SQL.Add('ORDER BY `ФИО`');
      ParamByName('name').AsString := '%' + edFindClient.Text + '%';

      if SQL.Text.Contains(':KurName') then
        ParamByName('KurName').AsString := Kurator;

      Open;
      labCount.Caption := IntToStr(RecordCount);
    end;
  end;
end;

function TfrmObNewZahid.GetOrCreateClubID(const ClubName: string): Integer;
var // знайти або вставити клуб і повернути його ID
  Q: TUniQuery;
begin
  Result := 0;
  Q := TUniQuery.Create(nil);
  try
    Q.Connection := DM.UniConnection;

    // 1. Пошук клубу
    Q.SQL.Text := 'SELECT ID FROM Clubs WHERE Назва = :club_name LIMIT 1';
    Q.ParamByName('club_name').AsString := ClubName;
    Q.Open;

    if not Q.IsEmpty then
    begin
      Result := Q.FieldByName('ID').AsInteger;
      Exit;
    end;

    // 2. Якщо не знайдено — вставити новий клуб
    Q.Close;
    Q.SQL.Text :=
      'INSERT INTO Clubs (Назва, id_region) VALUES (:club_name, :id_region)';
    Q.ParamByName('club_name').AsString := ClubName;
    Q.ParamByName('id_region').AsInteger := NumRegion;
    Q.ExecSQL;

    // 3. Отримати ID останнього вставленого запису
    Q.SQL.Text := 'SELECT LAST_INSERT_ID() AS ID';
    Q.Open;
    if not Q.IsEmpty then
      Result := Q.FieldByName('ID').AsInteger;

  finally
    Q.Free;
  end;
end;

procedure TfrmObNewZahid.InicialRegionalData;
begin
  with DM do
  begin
    if UserRole <> 0 then
    begin
      qFindClients.Close;
      qFindClients.SQL.Clear;
      qFindClients.SQL.Add
        ('SELECT * FROM `Clients` WHERE `Тип клиента (для поиска)`<> '''' and `Куратор` = :KurName;');
      qFindClients.ParamByName('KurName').AsString := Kurator;
      qFindClients.Open;
      labCount.Caption := IntToStr(qFindClients.RecordCount);

      qClients.Close;
      qClients.SQL.Clear;
      qClients.SQL.Add
        ('SELECT * FROM `Clients` WHERE `Тип клиента (для поиска)`<> '''' and `Куратор` = :KurName;');
      qClients.ParamByName('KurName').AsString := Kurator;
      qClients.Open;

      qClubs.Close;
      qClubs.SQL.Clear;
      qClubs.SQL.Add('SELECT * FROM `Clubs` WHERE `id_region` = :IdRegion;');
      qClubs.ParamByName('IdRegion').AsInteger := NumRegion;
      qClubs.Open;

    end
    else
    begin // для адміна показ всього
      qFindClients.Close;
      qFindClients.SQL.Clear;
      qFindClients.SQL.Add
        ('SELECT * FROM `Clients` WHERE `Тип клиента (для поиска)`<> '''';');
      qFindClients.Open;
      labCount.Caption := IntToStr(qFindClients.RecordCount);

      qClients.Close;
      qClients.SQL.Clear;
      qClients.SQL.Add
        ('SELECT * FROM `Clients` WHERE `Тип клиента (для поиска)`<> '''';');
      qClients.Open;

      qClubs.Close;
      qClubs.SQL.Clear;
      qClubs.SQL.Add('SELECT * FROM `Clubs`;');
      qClubs.Open;

    end;
  end;
end;

procedure TfrmObNewZahid.InsertNewEvent(const EventName, DateStr,
  WhoConducted: string; ClubID, GuestsCount: Integer; lbClients: TsListBox);
var
  Q: TUniQuery;
  EventID: Integer;
  i: Integer;
  ClientID: string;
begin
  Q := TUniQuery.Create(nil);
  try
    Q.Connection := DM.UniConnection;

    // Крок 1 — вставка нової події
    Q.SQL.Text := 'INSERT INTO Events ' +
      '(`Назва_заходу`, `Дата`, `Хто_проводив`, `ClubID`, `Кількість_сторонніх`, `id_region`) '
      + 'VALUES (:name, :date, :who, :club, :guests, :region)';
    Q.ParamByName('name').AsString := EventName;
    Q.ParamByName('date').AsDate := StrToDate(DateStr);
    Q.ParamByName('who').AsString := WhoConducted;
    Q.ParamByName('club').AsInteger := ClubID;
    Q.ParamByName('guests').AsInteger := GuestsCount;
    Q.ParamByName('region').AsInteger := NumRegion;
    Q.ExecSQL;

    // Крок 2 — отримуємо ID нової події
    Q.SQL.Text := 'SELECT LAST_INSERT_ID()';
    Q.Open;
    EventID := Q.Fields[0].AsInteger;
    Q.Close;

    // Крок 3 — додаємо клієнтів до EventClients
    for i := 0 to lbClients.Items.Count - 1 do
    begin
      // ClientID := Trim(lbClients.Items[i]);
      ClientID := string(lbClients.Items.Objects[i]);
      if ClientID = '' then
        Continue;

      try
        Q.SQL.Text :=
          'INSERT IGNORE INTO EventClients (EventID, ClientID) VALUES (:event_id, :client_id)';
        Q.ParamByName('event_id').AsInteger := EventID;
        Q.ParamByName('client_id').AsString := ClientID;
        Q.ExecSQL;
      except
        on E: Exception do
          ShowMessage('Помилка при додаванні клієнта "' + ClientID + '": ' +
            E.Message);
      end;
    end;

  finally
    Q.Free;
  end;
end;

function TfrmObNewZahid.IsAdmin: Boolean;
begin
  // Перевірка, чи UserRole не є Null і чи дорівнює 0 (тобто адміністратор)
  Result := (not VarIsNull(UserRole)) and (UserRole = 0);
end;

procedure TfrmObNewZahid.DBGridEh1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
// Процедура реагує на натискання миші по DBGridEh1
// Якщо ліва кнопка миші натиснута — запускаємо операцію перетягування
begin
  inherited;
  if Button = mbLeft then
    DBGridEh1.BeginDrag(false);
end;

procedure TfrmObNewZahid.lbClientsDragOver(Sender, Source: TObject;
  X, Y: Integer; State: TDragState; var Accept: Boolean);
// Ця процедура викликається, коли об’єкт перетягується над lbClients
// Перевіряємо, чи джерело перетягування — саме DBGridEh1
begin
  inherited;
  Accept := Source = DBGridEh1;
end;

procedure TfrmObNewZahid.bbtnDelClick(Sender: TObject);
var
  idx: Integer;
begin
  idx := lbClients.ItemIndex;
  if (idx >= 0) and (idx < lbClients.Items.Count) then
  begin
    lbClients.Items.Delete(idx);
    UpdateListBoxDisplay; // >>> ДОДАНО оновлення нумерації
  end;
end;

// =============================================================================
procedure TfrmObNewZahid.lbClientsDragDrop(Sender, Source: TObject;
  X, Y: Integer);
// Ця процедура викликається, коли об’єкт "скидається" у lbClients
// Отримуємо значення поля ФИО з поточного рядка DBGridEh1 і додаємо його до списку
var
  fio, jdcID: String;
  i: Integer;
  alreadyExists: Boolean;
begin
  if Source = DBGridEh1 then
  begin
    // Отримуємо дані з активного рядка
    fio := DBGridEh1.DataSource.DataSet.FieldByName('ФИО').AsString;
    jdcID := DBGridEh1.DataSource.DataSet.FieldByName('JDC ID').AsString;

    alreadyExists := false;

    // >>> Перевірка чи такий JDC ID вже є у списку
    for i := 0 to lbClients.Items.Count - 1 do
    begin
      if string(PChar(lbClients.Items.Objects[i])) = jdcID then
      begin
        alreadyExists := true;
        lbClients.ItemIndex := i;
        lbClients.SetFocus;
        UpdateListBoxDisplay; // перемалювати
        ShowMessage('Клієнт "' + lbClients.Items[i] +
          '" вже доданий до списку.');
        Exit;
      end;
    end;

    // Якщо такого ще немає — додаємо
    // Додаємо у список, зберігаючи JDC ID
    lbClients.Items.AddObject(fio, TObject(Pointer(StrNew(PChar(jdcID)))));
    edFindClient.Text := '';

    // Повторно завантажуємо клієнтів (з урахуванням ролі)
    ReloadClientList;
    sRadioGroup1Change(Sender);
    // Оновлення нумерації
    UpdateListBoxDisplay;

    // Повертаємо фокус на поле пошуку
    edFindClient.SetFocus;
  end;
end;
// ==============================================================================

procedure TfrmObNewZahid.UpdateListBoxDisplay;
begin
  lbClients.Invalidate; // >>> ДОДАНО примусове перемалювання для нумерації
end;

procedure TfrmObNewZahid.lbClientsDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
// >>> ДОДАНО: кастомне малювання з нумерацією
var
  s: String;
begin
  with (Control as TListBox).Canvas do
  begin
    FillRect(Rect);
    s := Format('%d. %s', [Index + 1, lbClients.Items[Index]]);
    TextOut(Rect.Left + 4, Rect.Top + 1, s);
  end;
end;

procedure TfrmObNewZahid.LoadClients;
var
  IsAdmin: Boolean;
  queryBase: TStringList;
begin
  IsAdmin := false; // ← додай це перед першим використанням
  IsAdmin := IsAdmin; // використовуємо функцію
  queryBase := TStringList.Create;
  try
    queryBase.Add('SELECT * FROM `Clients`');
    queryBase.Add('WHERE `Тип клиента (для поиска)` <> ''''');

    if not IsAdmin then
      queryBase.Add('AND `Куратор` = :KurName');

    case sRadioGroup1.ItemIndex of
      1:
        queryBase.Add
          ('AND `Тип клиента (для поиска)` LIKE ''%Клиент Хеседа%''');
      2:
        begin
          queryBase.Clear;
          queryBase.Add('SELECT * FROM `Clients`');
          queryBase.Add('WHERE `Возраст` BETWEEN 0 AND 17');
          if not IsAdmin then
            queryBase.Add('AND `Куратор` = :KurName');
        end;
    end;

    with DM.qFindClients do
    begin
      Close;
      SQL.Text := queryBase.Text;
      if not IsAdmin then
        ParamByName('KurName').AsString := Kurator;
      Open;
    end;

    labCount.Caption := IntToStr(DM.qFindClients.RecordCount);
  finally
    queryBase.Free;
  end;
end;



procedure TfrmObNewZahid.ReloadClientList;
begin
  with DM.qFindClients do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT `ФИО`, `JDC ID` FROM `Clients`');
    SQL.Add('WHERE `Тип клиента (для поиска)` <> ''''');

    // Якщо користувач не адміністратор — обмежити по куратору
    if not IsAdmin then
      SQL.Add('AND `Куратор` = :KurName');

    SQL.Add('ORDER BY `ФИО`');

    if not IsAdmin then
      ParamByName('KurName').AsString := Kurator;

    Open;
  end;
end;



procedure TfrmObNewZahid.sRadioGroup1Change(Sender: TObject);
begin
  inherited;

  with DM.qFindClients do
  begin
    Close;
    SQL.Clear;

    // Базовий запит
    SQL.Add('SELECT * FROM `Clients`');
    SQL.Add('WHERE `Тип клиента (для поиска)` <> ''''');

    if not IsAdmin then
      SQL.Add('AND `Куратор` = :KurName');

    case sRadioGroup1.ItemIndex of
      0:
        ; // ВСІ
      1:
        SQL.Add('AND `Тип клиента (для поиска)` LIKE ''%Клиент Хеседа%''');
      2:
        begin
          SQL.Clear;
          SQL.Add('SELECT * FROM `Clients`');
          SQL.Add('WHERE `Возраст` BETWEEN 0 AND 17');
          SQL.Add('AND `Тип клиента (для поиска)` <> ''''');
          if not IsAdmin then
            SQL.Add('AND `Куратор` = :KurName');
        end;
    end;

    if SQL.Text.Contains(':KurName') then
      ParamByName('KurName').AsString := Kurator;

    Open;
    labCount.Caption := IntToStr(RecordCount);
  end;
end;

procedure TfrmObNewZahid.sSplitter1CanResize(Sender: TObject;
  var NewSize: Integer; var Accept: Boolean);
begin
  inherited;
 sStoreUtils.WriteIniStr('panLeft', 'Width',
      panLeft.Width.ToString, IniName);
end;

procedure TfrmObNewZahid.btnProvestyClick(Sender: TObject);
begin
  inherited; // Внести захід
  // Внести членов заходу
  InsertNewEvent(edZahid.Text, DateToStr(deZahid.Date), dblbBoss.KeyValue,
    GetOrCreateClubID(dblbClubs.Text), StrToIntDef(edNoName.Text, 0),
    lbClients);
  with DM do
  begin
    qEvents.Active := false;
    qEvents.Active := true;
    qClubs.Active := false;
    qClubs.Active := true;
  end;

  myForm.CreateNewFrame(TfrmObInputZahid, Sender);
  myForm.TimerBlink.Enabled := false; // відміняємо мигання мітки
end;

procedure TfrmObNewZahid.btnSaveExcelClick(Sender: TObject);
var
  Sheets, ExcelApp: Variant;
  i: Integer;
  jdcID, fio: String;
  DirectoryNow, FileNameS: String;
begin
  try
    // добавляем новую книгу
    if uMyExcel.RunExcel(false, false) = true then
      MyExcel.Workbooks.Add;

    // Sheets := MyExcel.Worksheets.Add;
    Sheets := MyExcel.Worksheets[1];
    Sheets.name := 'Spisok';
    ParametryStr; // Парметры страницы
    Sheets.PageSetup.PrintTitleRows := '$2:$2';

    // Параметры таблицы ( цифра номер столбца ) ширины столбцов
    ExcelApp := MyExcel.ActiveWorkBook.Worksheets[1].columns;

    ExcelApp.columns[2].columnwidth := 15;
    ExcelApp.columns[2].NumberFormat := '@';

    ExcelApp.columns[1].HorizontalAlignment := xlCenter;
    ExcelApp.columns[1].VerticalAlignment := xlCenter;

    // Заголовки колонок
    ExcelApp.Cells[1, 1] := '№';
    ExcelApp.Cells[1, 2] := 'JDC ID';
    ExcelApp.Cells[1, 3] := 'ПІБ';

    // Запис даних з lbClients
    for i := 0 to lbClients.Items.Count - 1 do
    begin
      fio := lbClients.Items[i];
      jdcID := string(PChar(lbClients.Items.Objects[i]));

      ExcelApp.Cells[i + 2, 1] := i + 1; // №
      ExcelApp.Cells[i + 2, 2] := jdcID; // JDC ID
      ExcelApp.Cells[i + 2, 3] := fio; // ПІБ
    end;

    // Автопідбір ширини колонок
    ExcelApp.columns.AutoFit;

    DirectoryNow := ExtractFilePath(ParamStr(0)) + 'Списки\';
    if not DirectoryExists('DirectoryNow') then
      ForceDirectories(DirectoryNow);

    FileNameS := DirectoryNow + 'Общіна_' + DateTimeToStr(Nachalo) + '-' +
      DateTimeToStr(Konec) + '_' + FormatDateTime('dd.mm.yyyy hh_mm_ss', Now)
      + '.xlsx';

    if uMyExcel.SaveWorkBook(FileNameS, 1) = true then
      ShowMessage('Експорт завершено успішно!');

    Sheets := unassigned;
    ExcelApp := unassigned;
    uMyExcel.StopExcel;
    ShellExecute(Handle, 'open', PWideChar(DirectoryNow), nil, nil,
      SW_SHOWNORMAL);

  except
    on E: Exception do
    begin
      ShowMessage('Помилка експорту: ' + E.Message);
      Sheets := unassigned;
      ExcelApp := unassigned;
      uMyExcel.StopExcel;
    end;
  end;

end;

end.
