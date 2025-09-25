unit uFrameObInputZahid;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Uni,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uFrameCustom, Vcl.ExtCtrls, sPanel,
  sFrameAdapter, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh,
  Vcl.StdCtrls, EhLibVCL, GridsEh, DBAxisGridsEh, DBGridEh, Vcl.Buttons,
  sBitBtn, System.UITypes, Data.DB, sSplitter;

type
  TfrmObInputZahid = class(TCustomInfoFrame)
    sPanel1: TsPanel;
    DBGridEh1: TDBGridEh;
    Button1: TButton;
    btnDeleteEven: TsBitBtn;
    DBGridEh2: TDBGridEh;
    sSplitter1: TsSplitter;
    procedure Button1Click(Sender: TObject);
    procedure btnDeleteEvenClick(Sender: TObject);
  private
    { Private declarations }

  public
    { Public declarations }
    procedure AfterCreation; override;
    procedure BeforeDestruct; virtual;
  end;

var
  frmObInputZahid: TfrmObInputZahid;

implementation

{$R *.dfm}

uses uMainForm, uDM, uFrameObNewZahid;

{ TfrmObInputZahid }

procedure TfrmObInputZahid.AfterCreation;
begin
  inherited;
  myForm.lbInfo.Caption := '';
  with DM.qEvents do
  begin
    SQL.Clear;

    if UserRole <> 0 then
    begin
      SQL.Add('SELECT E.`ID`, E.`Дата`, C.`Назва` AS `ClubName`, E.`Назва_заходу`,');
      SQL.Add('  CL.`ФИО` AS `ПІБ_хто_проводив`, E.`Кількість_сторонніх`, E.`id_region`, R.`nameRegion` AS `Назва_регіону`');
      SQL.Add('FROM `Events` E');
      SQL.Add('LEFT JOIN `Clubs` C ON E.`ClubID` = C.`ID`');
      SQL.Add('LEFT JOIN `admUch` CL ON E.`Хто_проводив` = CL.`JDC ID`');
      SQL.Add('LEFT JOIN `Region` R ON E.`id_region` = R.`id_region`');
      SQL.Add('WHERE E.`id_region` = :RegionID');
      SQL.Add('ORDER BY E.`Дата` DESC');

      ParamByName('RegionID').AsInteger := NumRegion; // або будь-яке значення
    end
    else
    begin // для адміна
      SQL.Add('SELECT E.`ID`, E.`Дата`, C.`Назва` AS `ClubName`, E.`Назва_заходу`,');
      SQL.Add('  CL.`ФИО` AS `ПІБ_хто_проводив`, E.`Кількість_сторонніх`, E.`id_region`, R.`nameRegion` AS `Назва_регіону`');
      SQL.Add('FROM `Events` E');
      SQL.Add('LEFT JOIN `Clubs` C ON E.`ClubID` = C.`ID`');
      SQL.Add('LEFT JOIN `admUch` CL ON E.`Хто_проводив` = CL.`JDC ID`');
      SQL.Add('LEFT JOIN `Region` R ON E.`id_region` = R.`id_region`');
      // SQL.Add('WHERE E.`id_region` = :RegionID');
      SQL.Add('ORDER BY E.`Дата` DESC');
    end;

    Open;
    if RecordCount = 0 then DM.QEventClients.Active := false;
  end;
end;

procedure TfrmObInputZahid.BeforeDestruct;
begin

end;

procedure TfrmObInputZahid.btnDeleteEvenClick(Sender: TObject);
var
  EventID: Integer;
  Answer: Integer;
  Q: TUniQuery;
begin
  // Перевірка: чи є обрана строка
  if not DBGridEh1.DataSource.DataSet.Active or DBGridEh1.DataSource.DataSet.IsEmpty
  then
  begin
    ShowMessage('Немає записів для видалення.');
    Exit;
  end;

  // Отримуємо ID з активного запису
  EventID := DBGridEh1.DataSource.DataSet.FieldByName('ID').AsInteger;

  // Підтвердження
  Answer := MessageDlg('Ви дійсно хочете видалити цей запис?', mtConfirmation,
    [mbYes, mbNo], 0);
  if Answer <> mrYes then
    Exit;

  // Створюємо локальний запит
  Q := TUniQuery.Create(nil);
  try
    Q.Connection := DM.UniConnection;

    // Видаляємо залежні записи, якщо потрібно
    Q.SQL.Text := 'DELETE FROM EventClients WHERE EventID = :ID';
    Q.ParamByName('ID').AsInteger := EventID;
    Q.ExecSQL;

    // Видаляємо саму подію
    Q.SQL.Text := 'DELETE FROM Events WHERE ID = :ID';
    Q.ParamByName('ID').AsInteger := EventID;
    Q.ExecSQL;

  finally
    Q.Free;
  end;

  // Оновлюємо основний запит, щоб оновити грід
  DM.qEvents.Close;
  DM.qEvents.Open;
end;

procedure TfrmObInputZahid.Button1Click(Sender: TObject);
begin
  inherited;
  myForm.CreateNewFrame(TfrmObNewZahid, Sender);
  myForm.TimerBlink.Enabled := true;
end;

end.
