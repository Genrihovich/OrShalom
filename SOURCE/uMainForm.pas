// чтоб фреймы показывались Delphi IDE, надо поменять *dfm object на inherited
unit uMainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, uFrameCustom,
  JvAppStorage, JvAppIniStorage,
  JvComponentBase, JvFormPlacement, acTitleBar, sSkinManager, sSkinProvider,
  Vcl.Controls, Vcl.StdCtrls, Vcl.ComCtrls, sComboBoxes, sLabel, JvExExtCtrls,
  JvExtComponent, JvClock, dxGDIPlusClasses, ES.BaseControls, ES.Images,
  Vcl.ExtCtrls, sPanel, sStatusBar, Vcl.Forms, sScrollBox, sFrameBar, sSplitter,
  sMonthCalendar, acProgressBar, VclTee.TeeGDIPlus, VclTee.TeEngine,
  VclTee.TeeProcs, VclTee.Chart, Uni, Dialogs;

type
  TFrameClass = class of TCustomInfoFrame;

  TmyForm = class(TForm)
    sFrameBar1: TsFrameBar;
    StatusBar: TsStatusBar;
    sSplitter1: TsSplitter;
    panConteiner: TsPanel;
    sPanel2: TsPanel;
    sGradientPanel2: TsGradientPanel;
    EsImage1: TEsImage;
    JvClock1: TJvClock;
    sPanel1: TsPanel;
    sLabelFX1: TsLabelFX;
    sSkinSelector1: TsSkinSelector;
    sSkinManager1: TsSkinManager;
    sTitleBar1: TsTitleBar;
    JvFormStorage1: TJvFormStorage;
    JvAppIniFileStorage1: TJvAppIniFileStorage;
    sMonthCalendar1: TsMonthCalendar;
    Timer: TTimer;
    ProgressBar: TsProgressBar;
    TimerBlink: TTimer;
    lbInfo: TLabel;
    procedure FormShow(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure TimerBlinkTimer(Sender: TObject);
    procedure sFrameBar1Items0Click(Sender: TObject);
    procedure sFrameBar1Items1CreateFrame(Sender: TObject;
      var Frame: TCustomFrame);
    procedure sFrameBar1Items2CreateFrame(Sender: TObject;
      var Frame: TCustomFrame);
    procedure sFrameBar1Items0CreateFrame(Sender: TObject;
      var Frame: TCustomFrame);
    procedure sFrameBar1Items3CreateFrame(Sender: TObject;
      var Frame: TCustomFrame);

  private
    { Private declarations }
    //Процедура перевірки ролі
    procedure ApplyUserRoleAccess;

  public
    { Public declarations }
    myFrame: TFrame;
    // --------------------
    procedure CreateNewFrame(FrameType: TFrameClass; Sender: TObject = nil);
    procedure UpdateFrame(Sender: TObject = nil);
    procedure UpdateFrameControls;
    // ----------------------
  end;

var
  myForm: TmyForm;
  OldFrame, CurrentFrame: TCustomInfoFrame;
  AppLoading: boolean = False; // Запретить анимацию кадра во время загрузки
  // приложения
  FormShowed: boolean = False; // Эта переменная используется при инициализации
  // первой формы в событии OnShow. Используется для предотвращения повторной
  // инициализации после каждого воссоздания формы. Событие Form.OnShow
  // обрабатывается после каждого переключения в режим со скинами или без скинов.
  MyName, MyRegion, Kurator: String;
  CurrentUserID: String; // id редактируемого
  NumRegion: Integer; // id регионга сессии
  UserRole: Variant; // може бути Null - роль юзера (права доступу)
  isAdmin, isVolonter: Boolean;
  Nachalo, Konec: TDateTime; // начало и конец периодов для выборки
  IspolnitelCount, mentorCount: Integer;
  // кол-во исполнителей для отчета в ексель
  DotCount: Integer = 0; // для таймера с точками
  EventID: Integer; // id редактируемого евента
implementation

{$R *.dfm}

uses uMenu, uDM, uAutorize, uObchinaMenu, uOptions, uAdminMenu;

{ TForm2 }

procedure TmyForm.TimerBlinkTimer(Sender: TObject);
begin // lbInfo
  if lbInfo.Tag = 0 then
  begin
    lbInfo.Font.Color := clRed;
    lbInfo.Tag := 1;
  end
  else
  begin
    lbInfo.Font.Color := clWhite;
    lbInfo.Tag := 0;
  end;
  lbInfo.Repaint; // важливо для оновлення!
end;

procedure TmyForm.TimerTimer(Sender: TObject);
begin
  { Показываем окно авторизации }
  myForm.Hide;
  Timer.Enabled := False;
  fAutorize := TfAutorize.Create(Application);
  fAutorize.Show;
end;

procedure TmyForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Assigned(fAutorize) then
    fAutorize.Close;
end;

procedure TmyForm.FormCreate(Sender: TObject);
begin
  // перед созданием сделаем авторизацию
  // Timer.Enabled := True; // Запускаем таймер для скрытия основного окна
  // блок ini файла
  IniName := ExtractFilePath(Application.ExeName) + 'options.ini';
  // присвоить переменной имя ини файла
  with ProgressBar do
  begin
    parent := StatusBar;
    Position := 1;
    StatusBar.Panels[1].Style := psOwnerDraw;
  end;
  // не показувати фрейм під кнопкою
  sFrameBar1.Items[0].Frame := nil;

end;


procedure TmyForm.ApplyUserRoleAccess;
var
  RoleInt: Integer;
begin
  // Приховуємо все за замовчуванням
  sFrameBar1.Items[0].Visible := True;
  sFrameBar1.Items[1].Visible := False;
  sFrameBar1.Items[2].Visible := False;

  // Якщо роль не визначена — лише пункт 0
  if VarIsNull(UserRole) then
    Exit;

  // Конвертуємо Variant до Integer
  RoleInt := VarAsType(UserRole, varInteger);

  case RoleInt of
    0: begin
      // Адмін — всі пункти
      sFrameBar1.Items[0].Visible := True;
      sFrameBar1.Items[1].Visible := True;
      sFrameBar1.Items[2].Visible := True;
      sFrameBar1.Items[3].Visible := True;
    end;
    1: begin
      sFrameBar1.Items[1].Visible := True;
      sFrameBar1.Items[3].Visible := False;
    end;
    2: begin
      sFrameBar1.Items[2].Visible := True;
      sFrameBar1.Items[0].Visible := False;
      sFrameBar1.Items[3].Visible := False;
    end;
    3: begin
      sFrameBar1.Items[1].Visible := True;
      sFrameBar1.Items[2].Visible := True;
      sFrameBar1.Items[3].Visible := False;
    end;
    4: begin  // для волонтерів
      sFrameBar1.Items[2].Visible := True;
      sFrameBar1.Items[0].Visible := False;
      sFrameBar1.Items[3].Visible := False;
    end;
  end;
end;

procedure TmyForm.CreateNewFrame(FrameType: TFrameClass; Sender: TObject);
begin
  // Якщо поточний фрейм існує — запам'ятати його як старий
  if Assigned(CurrentFrame) then
    OldFrame := CurrentFrame;

   // Якщо старий фрейм такого ж типу — знищити його
  if OldFrame <> nil then
  begin // Выгрузить если существует
    if OldFrame is FrameType then
      FreeAndNil(OldFrame);
  end;

  CurrentFrame := FrameType.Create(myForm);

 // Оновлюємо зовнішній вигляд/назву і т.п.
  myForm.UpdateFrame(Sender);
end;

procedure TmyForm.FormShow(Sender: TObject);
begin
  if not FormShowed then
  begin
    AppLoading := True;
    FormShowed := True; // предотвращение повторной инициализации

    // Открываем первый элемент панели фрейма (TfrmMenu)
    // sFrameBar1.OpenItem(0, False { Без анимации } );

    // Пример доступа к фрейму (нажмите на spdBtn_CurrSkin)
    // TfrmMenu(sFrameBar1.Items[0].Frame).btnVidomist.OnClick(TfrmMenu(sFrameBar1.Items[0].Frame).btnVidomist);
    // GenerateSkinsList;  // Поиск доступных скинов


      // ✅ ПЕРЕВІРКА РОЛІ ЮЗЕРА
  ApplyUserRoleAccess;

    AppLoading := False;

  end;
end;



procedure TmyForm.sFrameBar1Items0Click(Sender: TObject);

begin // Настройки
  CreateNewFrame(TfrmOption, Sender);
end;

procedure TmyForm.sFrameBar1Items0CreateFrame(Sender: TObject;
  var Frame: TCustomFrame);
begin
// Не показивать фрейм
  sFrameBar1.Items[0].Frame := nil;
end;

procedure TmyForm.sFrameBar1Items1CreateFrame(Sender: TObject;
  var Frame: TCustomFrame);
begin    // Травмацентр
  Frame := TfrmMenu.Create(nil);

  EsImage1.Visible := true;
  lbInfo.Caption := '';
  sSkinManager1.UpdateScale(Frame);
end;

procedure TmyForm.sFrameBar1Items2CreateFrame(Sender: TObject;
  var Frame: TCustomFrame);
  var
  ObFrame: TfrmObchiaMenu;
begin   // Община
  ObFrame := TfrmObchiaMenu.Create(nil);
  Frame := ObFrame; // Присвоєння в Frame для sFrameBar1
  // Виклик перевірки прав
  ObFrame.ApplyPermissions;
 // Інші налаштування
  EsImage1.Visible := false;
  sSkinManager1.UpdateScale(Frame);
end;

procedure TmyForm.sFrameBar1Items3CreateFrame(Sender: TObject;
  var Frame: TCustomFrame);
begin   //Адміністрування
  Frame := TfrmAdminMenu.Create(nil);

//  EsImage1.Visible := true;
//  lbInfo.Caption := '';
  sSkinManager1.UpdateScale(Frame);
end;

procedure TmyForm.UpdateFrame(Sender: TObject);
begin
  if Assigned(CurrentFrame) then
  begin
    CurrentFrame.Visible := False;
    // Устанавливаем положение нового фрейма
    CurrentFrame.Align := alClient;
    CurrentFrame.parent := panConteiner;
    UpdateFrameControls;
    // если Animated и sSkinManager1.Active, а не AppLoading, тогда начинаем
    CurrentFrame.SendToBack;
    CurrentFrame.Visible := True;
    if Assigned(OldFrame) then
      OldFrame.Visible := False;
  end
  else
  begin
    CurrentFrame.Visible := True;
{$IFNDEF DELPHI_XE}
    CurrentFrame.Repaint;
    // Перекрасить графические элементы управления, обходной путь для старой проблемы обновления Delphi
{$ENDIF}
  end;
  if Assigned(OldFrame) then
    FreeAndNil(OldFrame);
end;

procedure TmyForm.UpdateFrameControls;
begin
  if CurrentFrame <> nil then
    CurrentFrame.AfterCreation;
end;

end.
