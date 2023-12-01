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
  sMonthCalendar, acProgressBar, VclTee.TeeGDIPlus, VCLTee.TeEngine,
  VCLTee.TeeProcs, VCLTee.Chart;

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
    procedure sFrameBar1Items0CreateFrame(Sender: TObject;
      var Frame: TCustomFrame);
    procedure FormShow(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);

  private
    { Private declarations }
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
  MyName, MyRegion: String;
  Nachalo, Konec: TDateTime; //начало и конец периодов для выборки
  IspolnitelCount, mentorCount: Integer; //кол-во исполнителей для отчета в ексель

implementation

{$R *.dfm}

uses uMenu, uDM, uAutorize;

{ TForm2 }



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
  if Assigned(fAutorize) then fAutorize.Close;
end;



procedure TmyForm.FormCreate(Sender: TObject);
begin
  // перед созданием сделаем авторизацию
//  Timer.Enabled := True; // Запускаем таймер для скрытия основного окна
  // блок ini файла
    IniName := ExtractFilePath(Application.ExeName) + 'options.ini';  // присвоить переменной имя ини файла
      with ProgressBar do
  begin
    parent := statusBar;
    Position := 1;
    statusBar.Panels[1].Style := psOwnerDraw;
  end;
end;

procedure TmyForm.CreateNewFrame(FrameType: TFrameClass; Sender: TObject);
begin
  if Assigned(CurrentFrame) then
    OldFrame := CurrentFrame;

  if OldFrame <> nil then
  begin // Выгрузить если существует
    if OldFrame is FrameType then
      FreeAndNil(OldFrame);
  end;
  CurrentFrame := FrameType.Create(myForm);
  myForm.UpdateFrame(Sender);
end;



procedure TmyForm.FormShow(Sender: TObject);
begin
  if not FormShowed then
  begin
    AppLoading := True;
    FormShowed := True; // предотвращение повторной инициализации
     // Открываем первый элемент панели фрейма (TfrmMenu)
    sFrameBar1.OpenItem(0, False { Без анимации } );
    // Пример доступа к фрейму (нажмите на spdBtn_CurrSkin)
//    TfrmMenu(sFrameBar1.Items[0].Frame).btnVidomist.OnClick(TfrmMenu(sFrameBar1.Items[0].Frame).btnVidomist);
//    GenerateSkinsList;  // Поиск доступных скинов
    AppLoading := False;
  end;
end;

procedure TmyForm.sFrameBar1Items0CreateFrame(Sender: TObject;
  var Frame: TCustomFrame);
begin
  Frame := TfrmMenu.Create(nil);
  sSkinManager1.UpdateScale(Frame);
end;



procedure TmyForm.UpdateFrame(Sender: TObject);
begin
  if Assigned(CurrentFrame) then
  begin
    CurrentFrame.Visible := False;
    // Устанавливаем положение нового фрейма
    CurrentFrame.Align := alClient;
    CurrentFrame.Parent := panConteiner;
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
