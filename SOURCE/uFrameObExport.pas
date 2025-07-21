unit uFrameObExport;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uFrameCustom, Vcl.StdCtrls,
  sFrameAdapter, sListBox, sCheckListBox, ShellAPI, Uni, DateUtils,
  DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, EhLibVCL,
  GridsEh, DBAxisGridsEh, DBGridEh, Vcl.ExtCtrls, sPanel;

type
  TfrmObExportData = class(TCustomInfoFrame)
    btnImport: TButton;
    chkListBox: TsCheckListBox;
    panTop: TsPanel;
    panAll: TsPanel;
    DBGridEh1: TDBGridEh;
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

uses uDM, uMainForm;

{ TfrmObExportData }

procedure TfrmObExportData.AfterCreation;
begin
  inherited;
  DragAcceptFiles(Handle, true);
  myForm.lbInfo.Caption := 'Перетяни на форму вигружений із SNOW excel файл';
end;

procedure TfrmObExportData.BeforeDestruct;
begin
  DragAcceptFiles(Handle, False);
end;

procedure TfrmObExportData.ConvertDropFile(fN: string);
var
  ExePath, Params: string;
begin // Конвертація дроп файлу

  ExePath := ExtractFilePath(ParamStr(0)) + 'xlsxToCsv.exe';
  Params := '"' + myForm.lbInfo.Caption + '" "' + ExtractFilePath(ParamStr(0)) + 'sys_user.csv"';
 // Params := '"C:\Users\Slaventy\Downloads\sys_user.xlsx" "C:\Users\Slaventy\Downloads\sys_user.csv"';

  myForm.lbInfo.Caption := 'Конвертація файлу: ' + myForm.lbInfo.Caption;
  ShellExecute(0, 'open', PChar(ExePath), PChar(Params), nil, SW_SHOW);
  chkListBox.Checked[0] := true;
  myForm.lbInfo.Caption := ExtractFilePath(ParamStr(0)) + 'sys_user.csv"';
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
    ImportCsvFileToBD;
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
    SL.LoadFromFile(ExtractFilePath(ParamStr(0)) + 'sys_user.csv', TEncoding.UTF8);

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

      // Перевірка: якщо рядок має менше 57 полів — пропустити
      if Length(Fields) < 57 then
      begin
        ShowMessage('Рядок ' + IntToStr(i + 1) + ' має недостатньо полів (' +
          IntToStr(Length(Fields)) + ' замість 57). Пропускається.');
        Continue;
      end;

      Q.SQL.Text := 'INSERT INTO Clients (' +
        'jdc_id, fio, vozrast, tip_klienta, data_rozhdeniya, data_smerti, s_kem_prozhivaet, zhn, '
        + 'evreyskoe_proiskhozhdenie, kurator, organizatsii_uchastnika, sr_dokhod_mp_khesed, '
        + 'mestopolozhenie, sr_dokhod_mp_det_deti, mobile_phone, pensiya, kod_organizatsii_jdc, '
        + 'adres_bez_goroda, ne_mozhet_kartoy, dop_parametry, ne_raspisyvaetsya, vpl_2014, oblast, '
        + 'rayon_goroda, gorod_prozhivaniya, gorod, bie, inn, bzh, invalidnost, pol, '
        + 'prichina_net_dokhoda, dokhod_ne_predostavlen, data_nachala, bezhenets_vpl, '
        + 'poluchaet_patronazh, tip_uchastnika, koordinator_patronazha, domashniy_telefon, '
        + 'osnovnaya_organizatsiya, id_karta, imeetsya_bank_karta, srd_dokhod_chlen, adres, '
        + 'adres_sovpadaet, poluchaet_mat_podderzhku, smartfon, projekty_jointech, '
        + 'raschetnoe_kol_vo_chasov, data_okonchaniya_invalidnosti, stepen_podvizhnosti, '
        + 'pravo_na_lik_subsidiyu, fio_nats, imya_otchestvo_nats, uchastnik_vov, uchastnik_boev, obshchie_zametki'
        + ') VALUES (' +
        ':jdc_id, :fio, :vozrast, :tip_klienta, :data_rozhdeniya, :data_smerti, :s_kem_prozhivaet, :zhn, '
        + ':evreyskoe_proiskhozhdenie, :kurator, :organizatsii_uchastnika, :sr_dokhod_mp_khesed, '
        + ':mestopolozhenie, :sr_dokhod_mp_det_deti, :mobile_phone, :pensiya, :kod_organizatsii_jdc, '
        + ':adres_bez_goroda, :ne_mozhet_kartoy, :dop_parametry, :ne_raspisyvaetsya, :vpl_2014, :oblast, '
        + ':rayon_goroda, :gorod_prozhivaniya, :gorod, :bie, :inn, :bzh, :invalidnost, :pol, '
        + ':prichina_net_dokhoda, :dokhod_ne_predostavlen, :data_nachala, :bezhenets_vpl, '
        + ':poluchaet_patronazh, :tip_uchastnika, :koordinator_patronazha, :domashniy_telefon, '
        + ':osnovnaya_organizatsiya, :id_karta, :imeetsya_bank_karta, :srd_dokhod_chlen, :adres, '
        + ':adres_sovpadaet, :poluchaet_mat_podderzhku, :smartfon, :projekty_jointech, '
        + ':raschetnoe_kol_vo_chasov, :data_okonchaniya_invalidnosti, :stepen_podvizhnosti, ' +
        ':pravo_na_lik_subsidiyu, :fio_nats, :imya_otchestvo_nats, :uchastnik_vov, :uchastnik_boev, :obshchie_zametki' +
        ') ON DUPLICATE KEY UPDATE ' +
        'fio=VALUES(fio), vozrast=VALUES(vozrast), tip_klienta=VALUES(tip_klienta), ' +
        'data_rozhdeniya=VALUES(data_rozhdeniya), data_smerti=VALUES(data_smerti), ' +
        's_kem_prozhivaet=VALUES(s_kem_prozhivaet), zhn=VALUES(zhn), ' +
        'evreyskoe_proiskhozhdenie=VALUES(evreyskoe_proiskhozhdenie), kurator=VALUES(kurator), ' +
        'organizatsii_uchastnika=VALUES(organizatsii_uchastnika), ' +
        'sr_dokhod_mp_khesed=VALUES(sr_dokhod_mp_khesed), ' +
        'mestopolozhenie=VALUES(mestopolozhenie), sr_dokhod_mp_det_deti=VALUES(sr_dokhod_mp_det_deti), ' +
        'mobile_phone=VALUES(mobile_phone), pensiya=VALUES(pensiya), kod_organizatsii_jdc=VALUES(kod_organizatsii_jdc), ' +
        'adres_bez_goroda=VALUES(adres_bez_goroda), ne_mozhet_kartoy=VALUES(ne_mozhet_kartoy), ' +
        'dop_parametry=VALUES(dop_parametry), ne_raspisyvaetsya=VALUES(ne_raspisyvaetsya), vpl_2014=VALUES(vpl_2014), ' +
        'oblast=VALUES(oblast), rayon_goroda=VALUES(rayon_goroda), gorod_prozhivaniya=VALUES(gorod_prozhivaniya), ' +
        'gorod=VALUES(gorod), bie=VALUES(bie), inn=VALUES(inn), bzh=VALUES(bzh), invalidnost=VALUES(invalidnost), ' +
        'pol=VALUES(pol), prichina_net_dokhoda=VALUES(prichina_net_dokhoda), dokhod_ne_predostavlen=VALUES(dokhod_ne_predostavlen), ' +
        'data_nachala=VALUES(data_nachala), bezhenets_vpl=VALUES(bezhenets_vpl), poluchaet_patronazh=VALUES(poluchaet_patronazh), ' +
        'tip_uchastnika=VALUES(tip_uchastnika), koordinator_patronazha=VALUES(koordinator_patronazha), domashniy_telefon=VALUES(domashniy_telefon), ' +
        'osnovnaya_organizatsiya=VALUES(osnovnaya_organizatsiya), id_karta=VALUES(id_karta), imeetsya_bank_karta=VALUES(imeetsya_bank_karta), ' +
        'srd_dokhod_chlen=VALUES(srd_dokhod_chlen), adres=VALUES(adres), adres_sovpadaet=VALUES(adres_sovpadaet), ' +
        'poluchaet_mat_podderzhku=VALUES(poluchaet_mat_podderzhku), smartfon=VALUES(smartfon), projekty_jointech=VALUES(projekty_jointech), ' +
        'raschetnoe_kol_vo_chasov=VALUES(raschetnoe_kol_vo_chasov), data_okonchaniya_invalidnosti=VALUES(data_okonchaniya_invalidnosti), ' +
        'stepen_podvizhnosti=VALUES(stepen_podvizhnosti), pravo_na_lik_subsidiyu=VALUES(pravo_na_lik_subsidiyu), fio_nats=VALUES(fio_nats), ' +
        'imya_otchestvo_nats=VALUES(imya_otchestvo_nats), uchastnik_vov=VALUES(uchastnik_vov), uchastnik_boev=VALUES(uchastnik_boev), ' +
        'obshchie_zametki=VALUES(obshchie_zametki)';






      // Присвоєння параметрів
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
      Q.ParamByName('mobile_phone').AsString := Fields[14];
      Q.ParamByName('pensiya').AsFloat := StrToFloatDef(Fields[15], 0);
      Q.ParamByName('kod_organizatsii_jdc').AsInteger :=
        StrToIntDef(Fields[16], 0);
      Q.ParamByName('adres_bez_goroda').AsString := Fields[17];
      Q.ParamByName('ne_mozhet_kartoy').AsString := Fields[18];
      Q.ParamByName('dop_parametry').AsString := Fields[19];
      Q.ParamByName('ne_raspisyvaetsya').AsString := Fields[20];
      Q.ParamByName('vpl_2014').AsString := Fields[21];
      Q.ParamByName('oblast').AsString := Fields[22];
      Q.ParamByName('rayon_goroda').AsString := Fields[23];
      Q.ParamByName('gorod_prozhivaniya').AsString := Fields[24];
      Q.ParamByName('gorod').AsString := Fields[25];
      Q.ParamByName('bie').AsString := Fields[26];
      Q.ParamByName('inn').AsString := Fields[27];
      Q.ParamByName('bzh').AsString := Fields[28];
      Q.ParamByName('invalidnost').AsString := Fields[29];
      Q.ParamByName('pol').AsString := Fields[30];
      Q.ParamByName('prichina_net_dokhoda').AsString := Fields[31];
      Q.ParamByName('dokhod_ne_predostavlen').AsString := Fields[32];


      try
        dt := ParseDate(Fields[33]);
        Q.ParamByName('data_nachala').AsDate := DateOf(dt);
      except
        Q.ParamByName('data_nachala').Clear;
      end;

      Q.ParamByName('bezhenets_vpl').AsString := Fields[34];
      Q.ParamByName('poluchaet_patronazh').AsString := Fields[35];
      Q.ParamByName('tip_uchastnika').AsString := Fields[36];
      Q.ParamByName('koordinator_patronazha').AsString := Fields[37];
      Q.ParamByName('domashniy_telefon').AsString := Fields[38];
      Q.ParamByName('osnovnaya_organizatsiya').AsString := Fields[39];
      Q.ParamByName('id_karta').AsFloat := StrToFloatDef(Fields[40], 0);
      Q.ParamByName('imeetsya_bank_karta').AsString := Fields[41];
      Q.ParamByName('srd_dokhod_chlen').AsFloat := StrToFloatDef(Fields[42], 0);
      Q.ParamByName('adres').AsString := Fields[43];
      Q.ParamByName('adres_sovpadaet').AsString := Fields[44];
      Q.ParamByName('poluchaet_mat_podderzhku').AsString := Fields[45];
      Q.ParamByName('smartfon').AsString := Fields[46];
      Q.ParamByName('projekty_jointech').AsFloat :=
        StrToFloatDef(Fields[47], 0);
      Q.ParamByName('raschetnoe_kol_vo_chasov').AsFloat :=
        StrToFloatDef(Fields[48], 0);

      try
        dt := ParseDate(Fields[49]);
        Q.ParamByName('data_okonchaniya_invalidnosti').AsDate := DateOf(dt);
      except
        Q.ParamByName('data_okonchaniya_invalidnosti').Clear;
      end;

      Q.ParamByName('stepen_podvizhnosti').AsString := Fields[50];
      Q.ParamByName('pravo_na_lik_subsidiyu').AsString := Fields[51];
      Q.ParamByName('fio_nats').AsString := Fields[52];
      Q.ParamByName('imya_otchestvo_nats').AsString := Fields[53];
      Q.ParamByName('uchastnik_vov').AsString := Fields[54];
      Q.ParamByName('uchastnik_boev').AsString := Fields[55];
      Q.ParamByName('obshchie_zametki').AsString := Fields[56];

      // Виконання SQL
      Q.ExecSQL;
    end;
    myForm.lbInfo.Caption := i.ToString + ' - Імпортовано в Базу Даних';
    ShowMessage('Імпорт завершено!');
  finally
    Q.Free;
    SL.Free;
    myForm.ProgressBar.Position := 0;
    myForm.ProgressBar.Visible := false;
    btnImport.Caption := 'Експорт Exls в Базу Даних';
    chkListBox.Checked[1] := true;
    btnImport.Enabled := false;
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
