{
  Модуль в который собраны кастомные процедуры и ф-ции работы с Базой данных
}
unit myBDUtils;

interface

uses
  System.Variants
  // , Winapi.Windows
  // , Winapi.Messages
    , System.SysUtils, System.Classes;

// есть ли запрашиваемые данные в таблице
function isAssetValue(table, pole, val: String): Boolean;
// вынуть значение из таблицы по данному полю
function PoleInSearchStr(table, pole, val, PoleSearch: string): String;
// добавить запись в таблицу
procedure InsertNewRecords(table, pole, val: String);
// Очистить таблицу от записей
procedure CleanOutTable(tabl: String);
// Очистка таблицы и обнуление индекса
procedure CleanOutTableAndIndex(tabl: String; pole: String);
// Очистка таблицы и обнуление индекса и установка с какой цыфры начинать счетчик
procedure CleanOutTableAndIndex0(tabl, pole, startNumber: String);
// Вытянуть список уникальных значений из поля таблицы
function SpisokPoley(tabl, pole: String): String;
function SpisokPoleyWhere(tabl, pole, pWhere: String): String;
// Подсчитать кол-во позиций в выборке
function CountRecordData(start, konec, ispolnitel, mTema, mType: String;
  groups: Boolean): String;

implementation

uses uDM, uMainForm;

{ ======= есть ли запрашиваемые данные в таблице ========
  table - в какой таблице искать,
  pole - в каком поле таблицы искать,
  val -  по данному значению поиск
}
function isAssetValue(table, pole, val: String): Boolean;
begin
  with DM do
  begin
    qInsert.Active := False;
    qInsert.SQL.Clear;
    qInsert.SQL.Text := 'SELECT * FROM ' + table + ' WHERE ' + pole + ' = ''' +
      val + '''';
    qInsert.Active := true;
    if qInsert.RecordCount > 0 then
      Result := true
    else
      Result := False;
  end;
end;

{ ============ Значение из Таблицы ===============
  table - в какой таблице искать,
  pole - в каком поле таблицы искать,
  val -  по данному значению поиск,
  PoleSearch - столбец в котором находятся нужные данные
}
function PoleInSearchStr(table, pole, val, PoleSearch: string): String;
begin
  // вынуть значение из таблицы по данному полю
  with DM.qInsert do
  begin
    Active := False;
    SQL.Clear;
    SQL.Text := 'SELECT * FROM ' + table + ' WHERE ' + pole + ' = ''' +
      val + '''';
    Active := true;
    if RecordCount > 0 then
      Result := FieldByName(PoleSearch).AsString
    else
      Result := null;
  end;
end;

{ ============ Добавить запись в таблицу ===============
  table - в какую таблицу,
  pole - в какое поле таблицы вставить,
  val -  значение вставки
}
procedure InsertNewRecords(table, pole, val: String);
begin
  // -------------- добавить запись в таблицу ----------------
  with DM do
  begin
    qInsert.Active := False;
    qInsert.SQL.Clear;
    qInsert.SQL.Text := 'insert into ' + table + ' (' + pole +
      ') VALUES (:param)';
    qInsert.ParamByName('param').AsString := val;
    qInsert.Execute;
  end;
end;

{ ============ Очистить таблицу ===============
  tabl - в какую таблицу
}
procedure CleanOutTable(tabl: String);
begin // Очистить таблицу от записей
  with DM.qQuery do
  begin
    Close;
    SQL.Clear;
    SQL.Text := 'Delete From ' + tabl;
    ExecSQL;
    Close;
  end;
end;

{ ============ Очистить таблицу и индекс ===============
  tabl - в какую таблицу,
  pole - ключевое поле по которому сброс
}
procedure CleanOutTableAndIndex(tabl: String; pole: String);
var
  s: string;
begin
  with DM.qQuery do
  begin
    Close; // обнуляем индекс таблицы pole - ключевое поле по которому сброс
    SQL.Clear;
    SQL.Add('Alter Table ' + tabl + '  Alter Column ' + pole + ' Counter(1,1)');
    s := SQL.Text;
    ExecSQL;
    Close;
    CleanOutTable(tabl); // очищаем таблицу
  end;
end;

{ ===== Очистка таблицы и обнуление индекса и установка счетчика ======
  tabl - в какую таблицу,
  pole - ключевое поле по которому сброс
  startNumber - с какой цыфры начинать счетчик
}
// Очистка таблицы и обнуление индекса и установка с какой цыфры начинать счетчик
procedure CleanOutTableAndIndex0(tabl, pole, startNumber: String);
begin
  with DM.qQuery do
  begin
    Close; // обнуляем индекс таблицы pole - ключевое поле по которому сброс
    SQL.Clear;
    SQL.Add('Alter Table ' + tabl + '  Alter Column ' + pole + ' Counter(' +
      startNumber + ',1)');
    ExecSQL;
    Close;
    CleanOutTable(tabl); // очищаем таблицу
  end;
end;

// Вытянуть список уникальных значений из поля таблицы
function SpisokPoley(tabl, pole: String): String;
var
  i, r: integer;
  spisok: TStringList;
  s: string;
begin
  with DM.qCountItems do
  begin
    SQL.Clear;
    SQL.Text := 'select ' + pole + ' From ZvitSnow WHERE DateKontakta Between :ot and :do Group by ' + pole + ' ;';
    Prepare;
    Params.ParamByName('do').AsDateTime := Konec;
    Params.ParamByName('ot').AsDateTime := Nachalo;

    s := SQL.Text;
    ExecSQL;

    r := RecordCount;
    if RecordCount > 0 then
    begin
      spisok := TStringList.create;
      First;
      for i := 0 to RecordCount - 1 do
      begin
        s := FieldByName(pole).AsString;
        if s <> '' then
          spisok.Add(FieldByName(pole).AsString);

        next;
      end;

      Result := spisok.DelimitedText;
      spisok.free;
    end
    else
      Result := null;
    Close;
  end;
end;

// Вытянуть список уникальных значений из поля таблицы с условием
function SpisokPoleyWhere(tabl, pole, pWhere: String): String;
var
  i, r: integer;
  spisok: TStringList;
  s: string;
begin
  with DM.qCountItems do
  begin
      SQL.Clear;

    SQL.Text := 'SELECT `'+pole+'` FROM `'+tabl+'` WHERE (`DateKontakta` BETWEEN :ot and :do) and `Tema`= :vidPoslugy Group By `'+pole+'`;';
    Prepare;
    Params.ParamByName('ot').AsDateTime := Nachalo;
    Params.ParamByName('do').AsDateTime := Konec;
    Params.ParamByName('vidPoslugy').AsString := pWhere;

    s := SQL.Text;
    ExecSQL;

    r := RecordCount;
    if RecordCount > 0 then
    begin
      spisok := TStringList.create;
      First;
      for i := 0 to RecordCount - 1 do
      begin
        s := FieldByName(pole).AsString;
        if s <> '' then
          spisok.Add(FieldByName(pole).AsString);

        next;
      end;

      Result := spisok.DelimitedText;
      spisok.free;
    end
    else
      Result := null;
    Close;
  end;
end;

// Подсчитать кол-во позиций в выборке
{
 start - старт периода запроса
 konec - конец периода запроса
 ispolnitel - по ком запрос
 mTema - вид услуги
 mType - тип контакта
 groups: Boolean - группировать по контакту или нет
}
function CountRecordData(start, konec, ispolnitel, mTema, mType: String;
  groups: Boolean): String;
begin
  with DM.qCountItems do
  begin
    Active := False;
    SQL.Clear;
    if (groups = False) then
      SQL.Text :=
        'SELECT * FROM ZvitSnow WHERE (DateKontakta Between :pOt and :pDo) AND (Ispolnitel = :pIspol) AND (Sostoyalsya = :pStat) AND (Tema = :pTema) AND (TypeKontakta = :pType)';

    if (groups = true) then
      SQL.Text :=
        'SELECT * FROM ZvitSnow WHERE (DateKontakta Between :pOt and :pDo) AND (Ispolnitel = :pIspol) AND (Sostoyalsya = :pStat) AND (Tema = :pTema) AND (TypeKontakta = :pType) GROUP BY Kontakt';

    ParamByName('pOt').AsString := FormatDateTime('YYYY-MM-DD',
      StrToDate(start));
    ParamByName('pDo').AsString := FormatDateTime('YYYY-MM-DD',
      StrToDate(konec));
    ParamByName('pStat').AsString := 'Состоялся';
    ParamByName('pIspol').AsString := ispolnitel;
    ParamByName('pTema').AsString := mTema;
    ParamByName('pType').AsString := mType;
    Active := true;
    Result := IntToStr(RecordCount);
  end;
end;

end.
