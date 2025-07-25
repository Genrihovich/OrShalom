unit uAutorize;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.DBCtrls,
  DBGridEh, Vcl.Mask, DBCtrlsEh, DBLookupEh, sEdit, sCheckBox, sLabel,
  System.Actions, Vcl.ActnList, JvComponentBase, JvFormPlacement, Vcl.ExtCtrls,
  sPanel, dxGDIPlusClasses, JvExExtCtrls, JvImage, acTitleBar, ES.RegexControls,
  sBitBtn, Uni, Data.DB, MemDS, DBAccess;

type
  TfAutorize = class(TForm)
    btnSignIn: TButton;
    Label1: TLabel;
    lbDBConnected: TLabel;
    spBtnConnectBD: TSpeedButton;
    dbLComboUser: TDBLookupComboboxEh;
    chPsw: TsCheckBox;
    wlabRegister: TsWebLabel;
    ActionList1: TActionList;
    acConnected: TAction;
    edPsw: TDBEditEh;
    acSignIn: TAction;
    panAutorize: TsPanel;
    panRegister: TsPanel;
    btnSave: TButton;
    sTitleBar1: TsTitleBar;
    acSave: TAction;
    edEmail: TEsRegexEdit;
    edPswReg: TDBEditEh;
    chPswReg: TsCheckBox;
    panBotton: TsPanel;
    acVisibleComponent: TAction;
    BitBtn1: TBitBtn;
    edPIBregister: TDBEditEh;
    edPosada: TDBEditEh;
    wlabEditUserData: TsWebLabel;
    panEditUserData: TsPanel;
    BitBtn2: TBitBtn;
    acEditData: TAction;
    dbLEditPIB: TDBEditEh;
    dbLEditPosada: TDBEditEh;
    edEmailEdit: TEsRegexEdit;
    edPSWEdit: TDBEditEh;
    btnEditUserData: TButton;
    panKodDostupa: TsPanel;
    dblcodDostupa: TDBEditEh;
    sLabel1: TsLabel;
    btnDostup: TsBitBtn;
    acDostup: TAction;
    acEditUserData: TAction;
    DBcbRegion: TDBComboBoxEh;
    procedure btnSignInClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure spBtnConnectBDClick(Sender: TObject);
    procedure chPswClick(Sender: TObject);
    procedure acConnectedUpdate(Sender: TObject);
    procedure wlabRegisterClick(Sender: TObject);
    procedure acSignInUpdate(Sender: TObject);
    procedure edPswKeyPress(Sender: TObject; var Key: Char);
    procedure btnSaveClick(Sender: TObject);
    procedure sTitleBar1Items0Click(Sender: TObject);
    procedure acSaveUpdate(Sender: TObject);
    procedure acVisibleComponentUpdate(Sender: TObject);
    procedure chPswRegClick(Sender: TObject);
    procedure acEditDataUpdate(Sender: TObject);
    procedure wlabEditUserDataClick(Sender: TObject);
    procedure acDostupUpdate(Sender: TObject);
    procedure btnDostupClick(Sender: TObject);
    procedure btnEditUserDataClick(Sender: TObject);
    procedure acEditUserDataUpdate(Sender: TObject);
    procedure dbLComboUserChange(Sender: TObject);
    procedure DBComboBoxEh1EditButtons0Click(Sender: TObject;
      var Handled: Boolean);
    procedure DBcbRegionChange(Sender: TObject);
  private
    { Private declarations }
    function isConnectedBD: String;
    // активация всех таблиц
    procedure ActivateTableBD;
    // валидация поля
    function isValidRecord(table, pole, values: String;
      DBLComboEh: TDBLookupComboboxEh): Boolean;
    // проверка входа в программу логин и пароль ок
    function isOKdataUser(login, psw: String): Boolean;
    procedure LoadRegionsList;
    // отримувати ID за текстом.
    function GetRegionIDByName(const RegionName: string): Integer;
    // Отримати текст за ID
    function GetRegionNameByID(const RegionID: Integer): string;
    // функція має шукати role по fullName
    function GetRoleByFullName(const AFullName: string): string;

    function GetRegionInfoByID(RegionID: Integer): string;
  public
    { Public declarations }
  end;

var
  fAutorize: TfAutorize;
  IniName: string;
  oldName, oldEmail, oldPosada: string;

implementation

{$R *.dfm}

uses uDM, uMainForm, sStoreUtils, myUtils, myBDUtils;

procedure TfAutorize.ActivateTableBD;
begin
  with DM do
  begin
    tUser.Active := true;
    tRegion.Active := true;
  end;
end;

function TfAutorize.isConnectedBD: String;
begin
  with DM do
  begin
    if UniConnection.Connected then
    begin
      Result := 'Активне';
      lbDBConnected.Font.Color := clGreen;
      ActivateTableBD;
    end
    else
    begin
      Result := 'Не активне';
      lbDBConnected.Font.Color := clRed;
    end;
  end;
end;

function TfAutorize.isOKdataUser(login, psw: String): Boolean;
var
  bdPsw: string;
begin
  Result := False;
  // проверка входа в программу логин и пароль ок
  bdPsw := PoleInSearchStr('User', 'fullName', login, 'password');

  if bdPsw = psw then
    Result := true;
end;

function TfAutorize.isValidRecord(table, pole, values: String;
  DBLComboEh: TDBLookupComboboxEh): Boolean;
begin // -------------- валидация поля ------------------
  Result := true;
  if (values = '') then // пустое поле
  begin
    with DBLComboEh do
    begin
      ControlLabel.Visible := true;
      ControlLabel.Caption := 'Поле не може бути пустим';
      ControlLabel.Font.Color := clRed;
    end;
    Result := False;
  end
  else
  begin
    if isAssetValue(table, pole, values) then
    begin
      with DBLComboEh do
      begin
        ControlLabel.Visible := true;
        ControlLabel.Caption := 'Такі данні вже існують';
        ControlLabel.Font.Color := clRed;
      end;
      Result := False;
    end;
  end;
end;

procedure TfAutorize.LoadRegionsList;
var
  Q: TUniQuery;
begin
  DBcbRegion.Items.Clear;
  Q := TUniQuery.Create(nil);
  try
    Q.Connection := DM.UniConnection;
    Q.Close;
    Q.SQL.Text := 'SELECT NameRegion FROM Region ORDER BY NameRegion';
    Q.Open;
    while not Q.Eof do
    begin
      DBcbRegion.Items.Add(Q.FieldByName('NameRegion').AsString);
      Q.Next;
    end;
  finally
    Q.Free;
  end;
end;

procedure TfAutorize.FormActivate(Sender: TObject);
var
  s: String;
begin
  lbDBConnected.Caption := isConnectedBD;
  fAutorize.ClientHeight := 193;
  panRegister.Visible := False;

  // проверка на наличие записи
  s := sStoreUtils.ReadIniString('Autorize', 'Region', IniName);
  if s <> '' then
  begin
     DBcbRegion.Text := GetRegionNameByID(s.ToInteger()); // регион по сохранению
     NumRegion := s.ToInteger();
  end;

  LoadRegionsList;
end;

function TfAutorize.GetRegionIDByName(const RegionName: string): Integer;
var
  Q: TUniQuery;
begin
  Result := -1;
  Q := TUniQuery.Create(nil);
  try
    Q.Connection := DM.UniConnection;
    Q.SQL.Text := 'SELECT id_region FROM Region WHERE nameRegion = :p';
    Q.ParamByName('p').AsString := RegionName;
    Q.Open;
    if not Q.Eof then
      Result := Q.FieldByName('id_region').AsInteger;
  finally
    Q.Free;
  end;

end;

function TfAutorize.GetRegionInfoByID(RegionID: Integer): string;
var
  Q: TUniQuery;
  RegionName, KuratorName: string;
begin
  Result := '';
  Q := TUniQuery.Create(nil);
  try
    Q.Connection := DM.UniConnection; // Або твоя змінна з'єднання
    Q.SQL.Clear;
    Q.SQL.Add('SELECT');
    Q.SQL.Add('  R.`id_region`,');
    Q.SQL.Add('  R.`nameRegion`,');
    Q.SQL.Add('  R.`id_Kurator`,');
    Q.SQL.Add('  CL.`ФИО` AS `ПІБ_Куратора`');
    Q.SQL.Add('FROM `Region` R');
    Q.SQL.Add('LEFT JOIN `Clients` CL ON R.`id_Kurator` = CL.`JDC ID`');
    Q.SQL.Add('WHERE R.`id_region` = :RegionID;');

    Q.ParamByName('RegionID').AsInteger := RegionID;
    Q.Open;

    if not Q.IsEmpty then
    begin
     // RegionName := Q.FieldByName('nameRegion').AsString;
      KuratorName := Q.FieldByName('ПІБ_Куратора').AsString;
      Result := KuratorName;
    end;

  finally
    Q.Free;
  end;
end;

function TfAutorize.GetRegionNameByID(const RegionID: Integer): string;
var
  Q: TUniQuery;
begin
  Result := '';
  Q := TUniQuery.Create(nil);
  try
    Q.Connection := DM.UniConnection;
    Q.SQL.Text := 'SELECT nameRegion FROM Region WHERE ID_region = :ID';
    Q.ParamByName('ID').AsInteger := RegionID;
    Q.Open;
    if not Q.Eof then
      Result := Q.FieldByName('nameRegion').AsString;
  finally
    Q.Free;
  end;
end;

function TfAutorize.GetRoleByFullName(const AFullName: string): string;
var
  Q: TUniQuery;
begin
  Result := ''; // якщо не знайдено
  Q := TUniQuery.Create(nil);
  try
    Q.Connection := DM.UniConnection; // заміни на свою змінну підключення
    Q.SQL.Text := 'SELECT role FROM User WHERE fullName = :fullName LIMIT 1';
    Q.ParamByName('fullName').AsString := AFullName;
    Q.Open;
    if not Q.IsEmpty then
      Result := Q.FieldByName('role').AsString;
  finally
    Q.Free;
  end;
end;

procedure TfAutorize.sTitleBar1Items0Click(Sender: TObject);
begin
  Application.Terminate;
end;

// ---------- экшн видимости компонент, когда нет соединения ------
procedure TfAutorize.acConnectedUpdate(Sender: TObject);
begin
  if DM.UniConnection.Connected = true then
  begin
    DBcbRegion.Enabled := true;
    dbLComboUser.Enabled := true;
    edPsw.Enabled := true;
    chPsw.Enabled := true;
    wlabRegister.Enabled := true;
    wlabEditUserData.Enabled := true;
    btnSignIn.Enabled := true;
    spBtnConnectBD.Visible := False;
  end
  else
  begin
    DBcbRegion.Enabled := False;
    dbLComboUser.Enabled := False;
    edPsw.Enabled := False;
    chPsw.Enabled := False;
    wlabRegister.Enabled := False;
    wlabEditUserData.Enabled := False;
    btnSignIn.Enabled := False;
    spBtnConnectBD.Visible := true;
  end;
end;

// ================= Кнопка подключиться к БД ==============
procedure TfAutorize.spBtnConnectBDClick(Sender: TObject);
begin
  DM.UniConnection.Connected := true;
  lbDBConnected.Caption := isConnectedBD;
end;
// ******************************************************************

// ===================== Выбор Региона ======================
procedure TfAutorize.acVisibleComponentUpdate(Sender: TObject);
begin
  // видимость полей выбора юзера от выбора региона
  if DBcbRegion.Text = '' then // Первый выбор
  begin
    chPsw.Enabled := False;
    panAutorize.Visible := False;
    BitBtn1.Enabled := False;
    fAutorize.ClientHeight := 74;
  end
  else
  begin // Регион выбирался
    chPsw.Enabled := true;

    BitBtn1.Enabled := true;

    if fAutorize.Tag = 1 then // Авторизация
    begin
      fAutorize.ClientHeight := 193;
      panAutorize.Visible := true;
    end;

    if fAutorize.Tag = 0 then // Регистрация
      fAutorize.ClientHeight := 230;

    if fAutorize.Tag = 2 then // код доступа
      fAutorize.ClientHeight := 138;

    if fAutorize.Tag = 3 then // редактировать данные
      fAutorize.ClientHeight := 240;

  end;
end;

procedure TfAutorize.DBComboBoxEh1EditButtons0Click(Sender: TObject;
  var Handled: Boolean);
var
  NewRegion: string;
  Q: TUniQuery;
begin
  NewRegion := Trim(DBcbRegion.Text);
  if NewRegion = '' then
    Exit;

  Q := TUniQuery.Create(nil);

  try
    Q.Connection := DM.UniConnection;
    Q.SQL.Text := 'SELECT COUNT(*) FROM Region WHERE nameRegion = :p';
    Q.ParamByName('p').AsString := NewRegion;
    Q.Open;

    if Q.Fields[0].AsInteger = 0 then
    begin
      Q.Close;
      Q.SQL.Text := 'INSERT INTO Region (nameRegion) VALUES (:p)';
      Q.ParamByName('p').AsString := NewRegion;
      Q.ExecSQL;
      LoadRegionsList;
    end;
    Handled := true;

  finally
    Q.Free;
  end;

end;

procedure TfAutorize.DBcbRegionChange(Sender: TObject);
var
  RegionID: Integer;
begin
  RegionID := GetRegionIDByName(DBcbRegion.Text);
  if RegionID > 0 then
  begin
    with DM do
    begin
      qUser.Active := False;
      qUser.SQL.Text := 'SELECT * FROM  User WHERE id_region = :param';
      qUser.ParamByName('param').AsInteger := RegionID;
      qUser.Execute;;
    end;

    sStoreUtils.WriteIniStr('Autorize', 'Region', RegionID.ToString, IniName);
  end;
end;


procedure TfAutorize.dbLComboUserChange(Sender: TObject);
begin
  // Фокус на поле пароля перевести
  edPsw.SetFocus;
end;

// *********************************************************************

// =============== Видимость пароля =======================
procedure TfAutorize.chPswClick(Sender: TObject);
begin
  if chPsw.Checked = true then
  begin
    edPsw.PasswordChar := #0;
    chPsw.Checked := true;
  end
  else
  begin
    edPsw.PasswordChar := '*';
    chPsw.Checked := False;
  end;
  lbDBConnected.Font.Color := clGreen;
end;

// ========================== Кнопка Входа в прогу ==========================
procedure TfAutorize.acSignInUpdate(Sender: TObject);
begin
  if (DBcbRegion.Text <> '') and (dbLComboUser.Text <> '') and
    (edPsw.Text <> '') then
    btnSignIn.Enabled := true
  else
    btnSignIn.Enabled := False;
end;

procedure TfAutorize.btnSignInClick(Sender: TObject);
var
  Q: TUniQuery;
begin // ---------- Проверка логина, если все ОК то впустить ------------
  if isOKdataUser(dbLComboUser.Text, MD5Hash(edPsw.Text)) = true then
  begin
    edPsw.ControlLabel.Visible := False;
    // первоначально прячем подсказку об ошибке

    // ----- запоминаем глобально данные сессии -----
    MyName := dbLComboUser.Text;
    MyRegion := DBcbRegion.Text;
    NumRegion := GetRegionIDByName(DBcbRegion.Text);
    UserRole := GetRoleByFullName(MyName);
    Kurator := GetRegionInfoByID(NumRegion);
    sStoreUtils.WriteIniStr('Autorize', 'Region', NumRegion.ToString, IniName);

    // ----- отримуємо роль користувача -----
    Q := TUniQuery.Create(nil);
    try
      Q.Connection := DM.UniConnection;
      Q.SQL.Text := 'SELECT Role FROM User WHERE fullName = :name';
      Q.ParamByName('name').AsString := MyName;
      Q.Open;

      if not Q.IsEmpty then
        UserRole := Q.FieldByName('Role').Value
      else
        UserRole := Null; // якщо не знайдено
    finally
      Q.Free;
    end;

    // Прячем авторизационную форму а лучше ее удалить из памяти
    fAutorize.Visible := False;
    myForm.Visible := true; // Показываем главную форму
    myForm.StatusBar.Panels[0].Text := MyName + ' - ' + MyRegion + ' регіон';
  end
  else
  begin // если валидация не прошла
    edPsw.ControlLabel.Visible := true;
    edPsw.ControlLabel.Font.Color := clRed;
    edPsw.Text := '';
  end;
end;

// ***********************************************************************
procedure TfAutorize.edPswKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    btnSignIn.Click;
    Key := #0;
  end;
end;

// -------------- экшн видимости метки редактирования данных юзера -----
procedure TfAutorize.acEditDataUpdate(Sender: TObject);
begin
  if dbLComboUser.Text = '' then
    wlabEditUserData.Visible := False
  else
    wlabEditUserData.Visible := true;
end;

// ----------- экшн видимости кнопки Доступа --------------------------
procedure TfAutorize.acDostupUpdate(Sender: TObject);
begin
  if dblcodDostupa.Text = '' then
    btnDostup.Enabled := False
  else
    btnDostup.Enabled := true;
end;

procedure TfAutorize.btnDostupClick(Sender: TObject);
begin
  if dblcodDostupa.Tag.ToString = Trim(dblcodDostupa.Text) then
  begin // совпадают код с мыла и введенный код

    panEditUserData.Visible := true; // показываем форму редактирования
    panKodDostupa.Visible := False; // скрываем форму кода доступа

    // Заполняем данными из формы
    dbLEditPIB.Text := dbLComboUser.Text;
    dbLEditPosada.Text := PoleInSearchStr('User', 'fullName', dbLComboUser.Text,
      'posada');
    edEmailEdit.Text := PoleInSearchStr('User', 'fullName',
      dbLComboUser.Text, 'email');
    edPSWEdit.Text := '';
    // сохраним старые значения для проверки
    oldName := dbLComboUser.Text;
    oldEmail := edEmailEdit.Text;
    oldPosada := dbLEditPosada.Text;
    fAutorize.Tag := 3;
  end
  else
  begin
    dblcodDostupa.ControlLabel.Visible := true;
    dblcodDostupa.ControlLabel.Font.Color := clRed;
  end;
end;

// ================= редактировать данные пользователя ===================
procedure TfAutorize.wlabEditUserDataClick(Sender: TObject);
var
  nPIB, nMail: string;
  codDostupa: string;
begin
  // отправляем код доступа на емейл
  nPIB := dbLComboUser.Text;
  nMail := PoleInSearchStr('User', 'fullName', nPIB, 'email');
  codDostupa := Random(1000000).ToString();
  dblcodDostupa.Tag := codDostupa.ToInteger();

  // отправить письмо
  if SendEmailAndAttach('mail.ukraine.com.ua', // хост   mail.ukraine.com.ua
    'код доступа', // тема письма
    '"' + nPIB + '" <' + nMail + '>', // получатель
    '"Интек" <admin@hesedbesht.org.ua>', // откуда
    'Код доступа до програми: ' + codDostupa, '', // Тело письма в HTML
    'admin@hesedbesht.org.ua', // логин
    'zv238kcu', // пароль
    '' // путь к файлу
    ) then
  begin
    ShowMessage('Код доступа для ' + nPIB + ' Відправлений!!!');
  end
  else
  begin
    ShowMessage('Код доступа для ' + nPIB + ' НЕ відправлений!!!');
  end;

  panKodDostupa.Visible := true;
  panAutorize.Visible := False;
  fAutorize.Tag := 2; // Код доступа
end;

// --------- экшн кнопки Сохранить РЕДАКТИРУЕМЫЕ данные -----------------
procedure TfAutorize.acEditUserDataUpdate(Sender: TObject);
begin
  if (dbLEditPIB.Text <> oldName) or (dbLEditPosada.Text <> oldPosada) or
    ((edEmailEdit.Text <> oldEmail) and (edEmailEdit.IsValid)) or
    (edPSWEdit.Text <> '') then
    btnEditUserData.Enabled := true
  else
    btnEditUserData.Enabled := False;
end;

procedure TfAutorize.btnEditUserDataClick(Sender: TObject);
var
  nPIB, nPosada, nEmail, nPsw, nId: string;
begin
  // Update d BD
  nPIB := dbLEditPIB.Text;
  nPosada := dbLEditPosada.Text;
  nEmail := edEmailEdit.Text;
  nPsw := MD5Hash(edPSWEdit.Text);
  nId := dbLComboUser.KeyValue;
  with DM do
  begin
    qInsert.Active := False;
    qInsert.SQL.Clear;

    if edPSWEdit.Text = '' then
      qInsert.SQL.Text :=
        'UPDATE User SET fullName= :name, posada= :posada, email= :email WHERE Id = :id'
    else
      qInsert.SQL.Text :=
        'UPDATE User SET fullName= :name, posada= :posada, email= :email, password= :password WHERE Id = :id';
    qInsert.ParamByName('name').AsString := nPIB;
    qInsert.ParamByName('posada').AsString := nPosada;
    qInsert.ParamByName('email').AsString := nEmail;
    if edPSWEdit.Text <> '' then
      qInsert.ParamByName('password').AsString := nPsw;
    qInsert.ParamByName('id').AsString := nId;
    qInsert.ExecSQL;
    qUser.RefreshRecord;
  end;

  dbLComboUser.Text := nPIB;
  fAutorize.Tag := 1;
  panEditUserData.Visible := False;
  panAutorize.Visible := true;
end;

// =============== Регистрация нового пользователя ===========================
procedure TfAutorize.wlabRegisterClick(Sender: TObject);
begin
  // вызов формы регистрации
  fAutorize.Tag := 0;
  panAutorize.Visible := False;
  panRegister.Visible := true;
end;

procedure TfAutorize.chPswRegClick(Sender: TObject);
begin
  if chPswReg.Checked = true then
  begin
    edPswReg.PasswordChar := #0;
    chPswReg.Checked := true;
  end
  else
  begin
    edPswReg.PasswordChar := '*';
    chPswReg.Checked := False;
  end;
end;

// =================== Сохранить кнопка нового пользователя =============
procedure TfAutorize.acSaveUpdate(Sender: TObject);
begin
  // апдейт екшена на сохранение нового юзера
  if (edEmail.IsValid) and (edPIBregister.Text <> '') and (edPosada.Text <> '')
    and (edPswReg.Text <> '') then
    btnSave.Enabled := true
  else
    btnSave.Enabled := False;
end;

procedure TfAutorize.btnSaveClick(Sender: TObject);
var
  MyName, posada, mail, psw: string;
  region: Integer;
begin // ---- Зарегистрироваться --------

  MyName := edPIBregister.Text;
  posada := edPosada.Text;
  mail := edEmail.Text;
  region := GetRegionIDByName(DBcbRegion.Text);


  // ========= проверка на валидность данніх =====
  if isAssetValue('User', 'fullName', MyName) then
  begin // если найден такой юзер
    with edPIBregister do
    begin
      ControlLabel.Visible := true;
      ControlLabel.Caption := 'Такий користувач вже існує';
      ControlLabel.Font.Color := clRed;
    end;

  end
  else
  begin
    if isAssetValue('User', 'email', mail) then
    begin // найдена почта
      with edPIBregister do
      begin
        ControlLabel.Visible := true;
        ControlLabel.Caption := 'Введена пошта вже існує';
        ControlLabel.Font.Color := clRed;
      end;
    end
    else
    begin // юзер новый
      psw := MD5Hash(edPswReg.Text);

      if MessageDlg('Дані коректні?  ' + chr(13) + 'Регіон: - ' +
        region.ToString + chr(13) + 'ПІБ: - ' + MyName + chr(13) + 'Посада: - '
        + posada + chr(13) + 'Email: - ' + mail + chr(13) + 'Пароль: - ' +
        edPswReg.Text + '', mtConfirmation, [mbYes, mbNo], 0, mbYes) = mrYes
      then
      begin
        // Вносим данные в базу данных
        with DM do
        begin
          qInsert.Active := False;
          qInsert.SQL.Clear;
          qInsert.SQL.Text :=
            'insert into User (`fullName`, `posada`, `email`, `password`, `id_region`) VALUES (:pName, :pPosada, :pEmail, :pPsw, :pRegion)';
          qInsert.ParamByName('pName').AsString := MyName;
          qInsert.ParamByName('pPosada').AsString := posada;
          qInsert.ParamByName('pEmail').AsString := mail;
          qInsert.ParamByName('pPsw').AsString := psw;
          qInsert.ParamByName('pRegion').AsInteger := region;

          qInsert.Execute;
          qUser.Active := False;
          qUser.Active := true;
        end;
        dbLComboUser.Text := MyName;
        fAutorize.Tag := 1;
        panRegister.Visible := False;
        panAutorize.Visible := true;
      end;

    end;
  end;
end;

end.
