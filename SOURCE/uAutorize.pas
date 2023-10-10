unit uAutorize;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.DBCtrls,
  DBGridEh, Vcl.Mask, DBCtrlsEh, DBLookupEh, sEdit, sCheckBox, sLabel,
  System.Actions, Vcl.ActnList, JvComponentBase, JvFormPlacement, Vcl.ExtCtrls,
  sPanel, dxGDIPlusClasses, JvExExtCtrls, JvImage, acTitleBar, ES.RegexControls,
  sBitBtn;

type
  TfAutorize = class(TForm)
    btnSignIn: TButton;
    Label1: TLabel;
    lbDBConnected: TLabel;
    spBtnConnectBD: TSpeedButton;
    dbLComboRegion: TDBLookupComboboxEh;
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
    procedure btnSignInClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure spBtnConnectBDClick(Sender: TObject);
    procedure DBLookupComboboxEh7EditButtons0Click(Sender: TObject;
      var Handled: Boolean);
    procedure chPswClick(Sender: TObject);
    procedure dbLComboRegionChange(Sender: TObject);
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

procedure TfAutorize.FormActivate(Sender: TObject);
var
  s: String;
begin
  lbDBConnected.Caption := isConnectedBD;
  fAutorize.ClientHeight := 193;
  panRegister.Visible := False;

  s := sStoreUtils.ReadIniString('Autorize', 'Region', IniName);
  // проверка на наличие записи
  if s <> '' then
    dbLComboRegion.KeyValue := s; // регион по сохранению
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
    dbLComboRegion.Enabled := true;
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
    dbLComboRegion.Enabled := False;
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
  if dbLComboRegion.Text = '' then
  begin
    chPsw.Enabled := False;
    panAutorize.Visible := False;
    BitBtn1.Enabled := False;
    fAutorize.ClientHeight := 74;
  end
  else
  begin
    chPsw.Enabled := true;

    BitBtn1.Enabled := true;
    if fAutorize.Tag = 1 then
    begin
      fAutorize.ClientHeight := 193;
      panAutorize.Visible := true;
    end;
    if fAutorize.Tag = 0 then
      fAutorize.ClientHeight := 230;
    if fAutorize.Tag = 2 then
      fAutorize.ClientHeight := 430;
  end;
end;

procedure TfAutorize.DBLookupComboboxEh7EditButtons0Click(Sender: TObject;
  var Handled: Boolean);
var
  val: String;
begin
  // добавить новое название региона
  if isValidRecord('Region', 'nameRegion', dbLComboRegion.Text, dbLComboRegion)
    = true then
  begin // если новый регион то добавить
    val := dbLComboRegion.Text;
    InsertNewRecords('Region', 'nameRegion', Trim(dbLComboRegion.Text));
    // вставить значение в комбобокс для отображения
    dbLComboRegion.Text := val;
  end;

  DM.tRegion.Close;
  DM.tRegion.Open;
end;

procedure TfAutorize.dbLComboRegionChange(Sender: TObject);
begin
  with DM do
  begin
    qUser.Active := False;
    qUser.SQL.Clear;
    qUser.SQL.Text := 'SELECT * FROM  User WHERE id_region = :param';
    qUser.ParamByName('param').AsInteger := dbLComboRegion.KeyValue;
    qUser.Execute;
  end;
  sStoreUtils.WriteIniStr('Autorize', 'Region',
    dbLComboRegion.KeyValue, IniName);
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
  if (dbLComboRegion.Text <> '') and (dbLComboUser.Text <> '') and
    (edPsw.Text <> '') then
    btnSignIn.Enabled := true
  else
    btnSignIn.Enabled := False;
end;

procedure TfAutorize.btnSignInClick(Sender: TObject);
begin // ---------- Проверка логина, если все ОК то впустить ------------
  if isOKdataUser(dbLComboUser.Text, MD5Hash(edPsw.Text)) = true then
  begin
    edPsw.ControlLabel.Visible := False;
    // первоначально прячем подсказку об ошибке

    // ----- запоминаем глобально данные сессии -----
    MyName := dbLComboUser.Text;
    MyRegion := dbLComboRegion.Text;
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
  fAutorize.Tag := 2;
end;

// --------- экшн кнопки Сохранить РЕДАКТИРУЕМЫЕ данные -----------------
procedure TfAutorize.acEditUserDataUpdate(Sender: TObject);
begin
  if (dbLEditPIB.Text <> oldName) or (dbLEditPosada.Text <> oldPosada) or
    ((edEmailEdit.Text <> oldEmail) and (edEmailEdit.IsValid)) { or
    (edPSWEdit.Text <> '') } then
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
  region: integer;
begin // ---- Зарегистрироваться --------

  MyName := edPIBregister.Text;
  posada := edPosada.Text;
  mail := edEmail.Text;
  region := dbLComboRegion.KeyValue;

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
