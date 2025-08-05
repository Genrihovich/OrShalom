unit uFrameObExport;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uFrameCustom, Vcl.StdCtrls,
  sFrameAdapter, sListBox, sCheckListBox, ShellAPI, Uni, DateUtils,
  DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, EhLibVCL,
  GridsEh, DBAxisGridsEh, DBGridEh, Vcl.ExtCtrls, sPanel, sLabel, sStoreUtils;

type
  TfrmObExportData = class(TCustomInfoFrame)
    btnImport: TButton;
    chkListBox: TsCheckListBox;
    panTop: TsPanel;
    panAll: TsPanel;
    DBGridEh1: TDBGridEh;
    labBackupText: TsLabelFX;
  private
    { Private declarations }
    procedure WMDropFiles(var Msg: TWMDropFiles); message WM_DROPFILES;
    procedure ConvertDropFile(fN: string);
    procedure ImportCsvFileToBD;
    function ParseDate(const S: string): TDateTime;

  public
    { Public declarations }
    procedure AfterCreation; override;
    procedure BeforeDestruct; virtual;
  end;

var
  frmObExportData: TfrmObExportData;

implementation

{$R *.dfm}

uses uDM, uMainForm, uAutorize;

{ TfrmObExportData }

procedure TfrmObExportData.AfterCreation;
var
  S: String;
begin
  inherited;
  DragAcceptFiles(Handle, true);
  myForm.lbInfo.Caption := 'Перетяни на форму вигружений із SNOW excel файл';

  S := sStoreUtils.ReadIniString('Caption', 'OldImportData', IniName);
  if S <> '' then
    labBackupText.Caption := S;

  DM.qClients.Active := false;
  DM.qClients.Active := true;

  // Запускаємо таймер для блимання повідомлення на формі
  myForm.TimerBlink.Enabled := true;

end;

procedure TfrmObExportData.BeforeDestruct;
begin
  DragAcceptFiles(Handle, false);
end;

procedure TfrmObExportData.ConvertDropFile(fN: string);
var
  ExePath, Params: string;
  SEI: TShellExecuteInfo;
  hProcess: THandle;
begin // Конвертація дроп файлу

  ExePath := ExtractFilePath(ParamStr(0)) + 'xlsxToCsv.exe';

  Params := '"' + myForm.lbInfo.Caption + '" "' + ExtractFilePath(ParamStr(0)) +
    'sys_user.csv"';
  // Params := '"C:\Users\Slaventy\Downloads\sys_user.xlsx" "C:\Users\Slaventy\Downloads\sys_user.csv"';

  myForm.lbInfo.Caption := 'Конвертація файлу: ' + myForm.lbInfo.Caption;

  ZeroMemory(@SEI, SizeOf(SEI));
  SEI.cbSize := SizeOf(SEI);
  SEI.fMask := SEE_MASK_NOCLOSEPROCESS;
  SEI.Wnd := 0;
  SEI.lpFile := PChar(ExePath);
  SEI.lpParameters := PChar(Params);
  SEI.lpDirectory := nil;
  SEI.nShow := SW_HIDE;

  if ShellExecuteEx(@SEI) then
  begin
    hProcess := SEI.hProcess;

    // Чекаємо, поки процес завершиться
    WaitForSingleObject(hProcess, INFINITE);
    CloseHandle(hProcess);

    chkListBox.Checked[0] := true;
    myForm.lbInfo.Caption := ExtractFilePath(ParamStr(0)) + 'sys_user.csv';

    // Вертаємо колір мітці та вимикаємо блимання
    myForm.TimerBlink.Enabled := false;
    myForm.lbInfo.Font.Color := clBlack;
    myForm.lbInfo.Repaint;

    // Імпортуємо CSV після завершення
    ImportCsvFileToBD;
    labBackupText.Caption := 'Останній імпорт - ' + DateToStr(Now);
    sStoreUtils.WriteIniStr('Caption', 'OldImportData',
      labBackupText.Caption, IniName);

  end
  else
  begin
    ShowMessage('Помилка запуску xlsxToCsv.exe!');
  end;

end;

procedure TfrmObExportData.WMDropFiles(var Msg: TWMDropFiles);
const
  maxlen = 254;
var
  h: THandle;
  pchr: array [0 .. maxlen] of char;
  fname: string;
begin
  h := Msg.Drop;
  DragQueryFile(h, 0, pchr, maxlen);
  fname := string(pchr);

  if lowercase(extractfileext(fname)) = '.xlsx' then
  begin
    // Ім'я дроп файлу
    myForm.lbInfo.Caption := fname;
    ConvertDropFile(fname);
    RenameFile(ExtractFilePath(ParamStr(0)) + 'sys_user.csv',
      ExtractFilePath(ParamStr(0)) + '_sys_user.csv')
  end;
  DragFinish(h);
end;

procedure TfrmObExportData.ImportCsvFileToBD;
var
  SL: TStringList;
  Line: string;
  Fields: TArray<string>;
  i: Integer;
  Q: TUniQuery;
  dt: TDateTime;
begin
  SL := TStringList.Create;
  Q := TUniQuery.Create(nil);
  myForm.lbInfo.Caption := 'Заносимо данні у Базу Даних .....';
  btnImport.Enabled := true;
  try
    DM.qClients.Active := false;
    Q.Connection := DM.UniConnection;
    SL.LoadFromFile(ExtractFilePath(ParamStr(0)) + 'sys_user.csv',
      TEncoding.UTF8);

    myForm.ProgressBar.Visible := true;
    myForm.ProgressBar.Min := 0;
    myForm.ProgressBar.Max := SL.Count - 1;
    myForm.ProgressBar.Position := 0;

    for i := 1 to SL.Count - 1 do
    begin
      myForm.ProgressBar.Position := i;
      btnImport.Caption := i.ToString;
      Application.ProcessMessages;

      Line := SL[i];
      Fields := Line.Split([';']);

      // Перевірка: якщо рядок має менше 58 полів — пропустити
      if Length(Fields) < 58 then
      begin
        ShowMessage('Рядок ' + IntToStr(i + 1) + ' має недостатньо полів (' +
          IntToStr(Length(Fields)) + ' замість 58). Пропускається.');
        Continue;
      end;

      Q.SQL.Text := 'INSERT INTO Clients (' +
        '`Создано`,`JDC ID`, `ФИО`, `Возраст`, `Тип клиента (для поиска)`, `Дата рождения`, `Дата смерти`, '
        + '`С кем проживает`, `ЖН`, `Еврейское происхождение`, `Куратор`, `Организации участника`, '
        + '`Ср. доход для МП (Хесед)`, `Местоположение`, `Ср. доход для МП (детские программы)`, '
        + '`Мобильный телефон`, `Пенсия`, `Код организации JDC`, `Адрес без города`, '
        + '`Не может пользоваться картой`, `Дополнительные параметры`, `Не расписывается`, '
        + '`ВПЛ 2014`, `Область`, `Район города`, `Город проживания`, `Город`, `BIE`, `INN`, `БЖН`, '
        + '`Инвалидность`, `Пол`, `Причина отсутствия данных о доходе`, `Доход не предоставлен`, '
        + '`Дата начала действия`, `Беженец/ВПЛ`, `Получает патронаж`, `Тип участника`, '
        + '`Координатор патронажа`, `Домашний телефон`, `Основная организация`, `Идентификационная карта`, '
        + '`Имеется действующая банковская карта`, `Средний доход (член общины)`, `Адрес`, '
        + '`Адрес проживания совпадает с адресом прописки`, `Получает материальную поддержку`, '
        + '`Смартфон/девайс`, `Проекты Jointech`, `Расчетное количество часов`, '
        + '`Дата окончания инвалидности`, `Степень подвижности`, `Право на получение субсидии на лекарства`, '
        + '`ФИО/Фамилия на национальном языке`, `Имя отчество на национальном языке`, `Участник ВОВ (приравненный)`, '
        + '`Участник боевых действий`,  `Общие примечания`' + ') VALUES (' +
        ':data_sozdano, :jdc_id, :fio, :vozrast, :tip_klienta, :data_rozhdeniya, :data_smerti, :s_kem_prozhivaet, :zhn, '
        + ':evreyskoe_proiskhozhdenie, :kurator, :organizatsii_uchastnika, :sr_dokhod_mp_khesed, :mestopolozhenie, '
        + ':sr_dokhod_mp_det_deti, :mobile_phone, :pensiya, :kod_organizatsii_jdc, :adres_bez_goroda, '
        + ':ne_mozhet_kartoy, :dop_parametry, :ne_raspisyvaetsya, :vpl_2014, :oblast, :rayon_goroda, :gorod_prozhivaniya, '
        + ':gorod, :bie, :inn, :bzh, :invalidnost, :pol, :prichina_net_dokhoda, :dokhod_ne_predostavlen, '
        + ':data_nachala, :bezhenets_vpl, :poluchaet_patronazh, :tip_uchastnika, :koordinator_patronazha, '
        + ':domashniy_telefon, :osnovnaya_organizatsiya, :id_karta, :imeetsya_bank_karta, :srd_dokhod_chlen, :adres, '
        + ':adres_sovpadaet, :poluchaet_mat_podderzhku, :smartfon, :projekty_jointech, :raschetnoe_kol_vo_chasov, '
        + ':data_okonchaniya_invalidnosti, :stepen_podvizhnosti, :pravo_na_lik_subsidiyu, :fio_nats, :imya_otchestvo_nats, '
        + ':uchastnik_vov, :uchastnik_boev, :obshchie_zametki' +
        ') ON DUPLICATE KEY UPDATE ' +
        '`Создано`=VALUES(`Создано`), `ФИО`=VALUES(`ФИО`), `Возраст`=VALUES(`Возраст`), `Тип клиента (для поиска)`=VALUES(`Тип клиента (для поиска)`), '
        + '`Дата рождения`=VALUES(`Дата рождения`), `Дата смерти`=VALUES(`Дата смерти`), `С кем проживает`=VALUES(`С кем проживает`), '
        + '`ЖН`=VALUES(`ЖН`), `Еврейское происхождение`=VALUES(`Еврейское происхождение`), `Куратор`=VALUES(`Куратор`), '
        + '`Организации участника`=VALUES(`Организации участника`), `Ср. доход для МП (Хесед)`=VALUES(`Ср. доход для МП (Хесед)`), '
        + '`Местоположение`=VALUES(`Местоположение`), `Ср. доход для МП (детские программы)`=VALUES(`Ср. доход для МП (детские программы)`), '
        + '`Мобильный телефон`=VALUES(`Мобильный телефон`), `Пенсия`=VALUES(`Пенсия`), `Код организации JDC`=VALUES(`Код организации JDC`), '
        + '`Адрес без города`=VALUES(`Адрес без города`), `Не может пользоваться картой`=VALUES(`Не может пользоваться картой`), '
        + '`Дополнительные параметры`=VALUES(`Дополнительные параметры`), `Не расписывается`=VALUES(`Не расписывается`), '
        + '`ВПЛ 2014`=VALUES(`ВПЛ 2014`), `Область`=VALUES(`Область`), `Район города`=VALUES(`Район города`), '
        + '`Город проживания`=VALUES(`Город проживания`), `Город`=VALUES(`Город`), `BIE`=VALUES(`BIE`), `INN`=VALUES(`INN`), '
        + '`БЖН`=VALUES(`БЖН`), `Инвалидность`=VALUES(`Инвалидность`), `Пол`=VALUES(`Пол`), '
        + '`Причина отсутствия данных о доходе`=VALUES(`Причина отсутствия данных о доходе`), `Доход не предоставлен`=VALUES(`Доход не предоставлен`), '
        + '`Дата начала действия`=VALUES(`Дата начала действия`), `Беженец/ВПЛ`=VALUES(`Беженец/ВПЛ`), `Получает патронаж`=VALUES(`Получает патронаж`), '
        + '`Тип участника`=VALUES(`Тип участника`), `Координатор патронажа`=VALUES(`Координатор патронажа`), '
        + '`Домашний телефон`=VALUES(`Домашний телефон`), `Основная организация`=VALUES(`Основная организация`), '
        + '`Идентификационная карта`=VALUES(`Идентификационная карта`), `Имеется действующая банковская карта`=VALUES(`Имеется действующая банковская карта`), '
        + '`Средний доход (член общины)`=VALUES(`Средний доход (член общины)`), `Адрес`=VALUES(`Адрес`), '
        + '`Адрес проживания совпадает с адресом прописки`=VALUES(`Адрес проживания совпадает с адресом прописки`), '
        + '`Получает материальную поддержку`=VALUES(`Получает материальную поддержку`), `Смартфон/девайс`=VALUES(`Смартфон/девайс`), '
        + '`Проекты Jointech`=VALUES(`Проекты Jointech`), `Расчетное количество часов`=VALUES(`Расчетное количество часов`), '
        + '`Дата окончания инвалидности`=VALUES(`Дата окончания инвалидности`), `Степень подвижности`=VALUES(`Степень подвижности`), '
        + '`Право на получение субсидии на лекарства`=VALUES(`Право на получение субсидии на лекарства`), '
        + '`ФИО/Фамилия на национальном языке`=VALUES(`ФИО/Фамилия на национальном языке`), `Имя отчество на национальном языке`=VALUES(`Имя отчество на национальном языке`), '
        + '`Участник ВОВ (приравненный)`=VALUES(`Участник ВОВ (приравненный)`), `Участник боевых действий`=VALUES(`Участник боевых действий`), '
        + ' `Общие примечания`=VALUES(`Общие примечания`)';

      // Присвоєння параметрів

      try
        dt := ParseDate(Fields[14]);
        Q.ParamByName('data_sozdano').AsDate := DateOf(dt);
      except
        Q.ParamByName('data_sozdano').Clear;
      end;

      Q.ParamByName('jdc_id').AsString := Fields[0];
      Q.ParamByName('fio').AsString := Fields[1];
      Q.ParamByName('vozrast').AsInteger := StrToIntDef(Fields[2], 0);
      Q.ParamByName('tip_klienta').AsString := Fields[3];

      try
        dt := ParseDate(Fields[4]);
        Q.ParamByName('data_rozhdeniya').AsDate := DateOf(dt);
      except
        Q.ParamByName('data_rozhdeniya').Clear;
      end;

      try
        dt := ParseDate(Fields[5]);
        Q.ParamByName('data_smerti').AsDate := DateOf(dt);
      except
        Q.ParamByName('data_smerti').Clear;
      end;

      Q.ParamByName('s_kem_prozhivaet').AsString := Fields[6];
      Q.ParamByName('zhn').AsString := Fields[7];
      Q.ParamByName('evreyskoe_proiskhozhdenie').AsString := Fields[8];
      Q.ParamByName('kurator').AsString := Fields[9];
      Q.ParamByName('organizatsii_uchastnika').AsString := Fields[10];
      Q.ParamByName('sr_dokhod_mp_khesed').AsFloat :=
        StrToFloatDef(Fields[11], 0);
      Q.ParamByName('mestopolozhenie').AsString := Fields[12];
      Q.ParamByName('sr_dokhod_mp_det_deti').AsFloat :=
        StrToFloatDef(Fields[13], 0);
      Q.ParamByName('mobile_phone').AsString := Fields[15];
      Q.ParamByName('pensiya').AsFloat := StrToFloatDef(Fields[16], 0);
      Q.ParamByName('kod_organizatsii_jdc').AsInteger :=
        StrToIntDef(Fields[17], 0);
      Q.ParamByName('adres_bez_goroda').AsString := Fields[18];
      Q.ParamByName('ne_mozhet_kartoy').AsString := Fields[19];
      Q.ParamByName('dop_parametry').AsString := Fields[20];
      Q.ParamByName('ne_raspisyvaetsya').AsString := Fields[21];
      Q.ParamByName('vpl_2014').AsString := Fields[22];
      Q.ParamByName('oblast').AsString := Fields[23];
      Q.ParamByName('rayon_goroda').AsString := Fields[24];
      Q.ParamByName('gorod_prozhivaniya').AsString := Fields[25];
      Q.ParamByName('gorod').AsString := Fields[26];
      Q.ParamByName('bie').AsString := Fields[27];
      Q.ParamByName('inn').AsString := Fields[28];
      Q.ParamByName('bzh').AsString := Fields[29];
      Q.ParamByName('invalidnost').AsString := Fields[30];
      Q.ParamByName('pol').AsString := Fields[31];
      Q.ParamByName('prichina_net_dokhoda').AsString := Fields[32];
      Q.ParamByName('dokhod_ne_predostavlen').AsString := Fields[33];

      try
        dt := ParseDate(Fields[34]);
        Q.ParamByName('data_nachala').AsDate := DateOf(dt);
      except
        Q.ParamByName('data_nachala').Clear;
      end;

      Q.ParamByName('bezhenets_vpl').AsString := Fields[35];
      Q.ParamByName('poluchaet_patronazh').AsString := Fields[36];
      Q.ParamByName('tip_uchastnika').AsString := Fields[37];
      Q.ParamByName('koordinator_patronazha').AsString := Fields[38];
      Q.ParamByName('domashniy_telefon').AsString := Fields[39];
      Q.ParamByName('osnovnaya_organizatsiya').AsString := Fields[40];
      Q.ParamByName('id_karta').AsFloat := StrToFloatDef(Fields[41], 0);
      Q.ParamByName('imeetsya_bank_karta').AsString := Fields[42];
      Q.ParamByName('srd_dokhod_chlen').AsFloat := StrToFloatDef(Fields[43], 0);
      Q.ParamByName('adres').AsString := Fields[44];
      Q.ParamByName('adres_sovpadaet').AsString := Fields[45];
      Q.ParamByName('poluchaet_mat_podderzhku').AsString := Fields[46];
      Q.ParamByName('smartfon').AsString := Fields[47];
      Q.ParamByName('projekty_jointech').AsFloat :=
        StrToFloatDef(Fields[48], 0);
      Q.ParamByName('raschetnoe_kol_vo_chasov').AsFloat :=
        StrToFloatDef(Fields[49], 0);

      try
        dt := ParseDate(Fields[50]);
        Q.ParamByName('data_okonchaniya_invalidnosti').AsDate := DateOf(dt);
      except
        Q.ParamByName('data_okonchaniya_invalidnosti').Clear;
      end;

      Q.ParamByName('stepen_podvizhnosti').AsString := Fields[51];
      Q.ParamByName('pravo_na_lik_subsidiyu').AsString := Fields[52];
      Q.ParamByName('fio_nats').AsString := Fields[53];
      Q.ParamByName('imya_otchestvo_nats').AsString := Fields[54];
      Q.ParamByName('uchastnik_vov').AsString := Fields[55];
      Q.ParamByName('uchastnik_boev').AsString := Fields[56];
      Q.ParamByName('obshchie_zametki').AsString := Fields[57];

      // Виконання SQL
      Q.ExecSQL;
    end;
    myForm.lbInfo.Caption := (i - 1).ToString + ' - Імпортовано в Базу Даних';
    ShowMessage('Імпорт завершено!');
  finally
    Q.Free;
    SL.Free;
    myForm.ProgressBar.Position := 0;
    myForm.ProgressBar.Visible := false;
    btnImport.Caption := 'Експорт Exls в Базу Даних';
    chkListBox.Checked[1] := true;
    btnImport.Enabled := false;
    DM.qClients.Active := false;
    DM.qClients.Active := true;
  end;

end;

function TfrmObExportData.ParseDate(const S: string): TDateTime;
var
  FS: TFormatSettings;
begin
  FS := TFormatSettings.Create;
  FS.DateSeparator := '-';
  FS.TimeSeparator := ':';
  FS.ShortDateFormat := 'yyyy-MM-dd';
  FS.LongTimeFormat := 'hh:nn:ss';

  if not TryStrToDateTime(S, Result, FS) then
    raise Exception.Create('Invalid date format: ' + S);
end;

end.
