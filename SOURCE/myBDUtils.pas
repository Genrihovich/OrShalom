{
  ������ � ������� ������� ��������� ��������� � �-��� ������ � ����� ������
}
unit myBDUtils;

interface

uses
  System.Variants
  // , Winapi.Windows
  // , Winapi.Messages
    , System.SysUtils, System.Classes;

type
  TMyResult = record
    vstrech: Integer;
    people: Integer;
  end;

  // ���� �� ������������� ������ � �������
function isAssetValue(table, pole, val: String): Boolean;
// ec�� �� ����� ������ - ������ ���������� - � �������
function isAssetValues(table, pdate, pMentor, pCount, pOrg, pOrganiz,
  pNote: String): Boolean;
// ������ �������� �� ������� �� ������� ����
function PoleInSearchStr(table, pole, val, PoleSearch: string): String;
// �������� ������ � �������
procedure InsertNewRecords(table, pole, val: String);
// �������� ������� �� �������
procedure CleanOutTable(tabl: String);
// ������� ������� � ��������� �������
procedure CleanOutTableAndIndex(tabl: String; pole: String);
// ������� ������� � ��������� ������� � ��������� � ����� ����� �������� �������
procedure CleanOutTableAndIndex0(tabl, pole, startNumber: String);
// �������� ������ ���������� �������� �� ���� �������
function SpisokPoley(tabl, pole, poleDate: String): String;
// �������� ������ ���������� �������� �� ���� ������� � ��������
function SpisokPoleyWhere(tabl, pole, pWhere: String): String;
// ���������� ���-�� ������� � �������
function CountRecordData(start, konec, ispolnitel, mTema, mType: String;
  groups: Boolean): String;

function PodschetZapros(table, pdate, pMentor, pTypeOrg, pCount: String)
  : TMyResult;

implementation

uses uDM, uMainForm;

{ ======= ���� �� ������������� ������ � ������� ========
  table - � ����� ������� ������,
  pole - � ����� ���� ������� ������,
  val -  �� ������� �������� �����
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

// ec�� �� ����� ������ - ������ ���������� - � �������
function isAssetValues(table, pdate, pMentor, pCount, pOrg, pOrganiz,
  pNote: String): Boolean;
var
  s: string;
begin
  with DM.qInsert do
  begin
    Active := False;
    SQL.Clear;
    SQL.Text := 'SELECT * FROM `' + table +
      '` WHERE `date_training`=:date and `Mentor`=:mentor and `Count_trained`=:countTr and `type_org` =:tOrg and`Organization`=:org and `Note_Tema`=:note';
    Prepare;
    Params.ParamByName('date').AsDate := StrToDate(pdate);
    Params.ParamByName('mentor').AsString := pMentor;
    Params.ParamByName('countTr').AsInteger := pCount.toInteger;
    Params.ParamByName('tOrg').AsString := pOrg;
    Params.ParamByName('org').AsString := pOrganiz;
    Params.ParamByName('tOrg').AsString := pOrg;
    Params.ParamByName('note').AsString := pNote;

    s := SQL.Text;
    ExecSQL;

    if RecordCount > 0 then
      Result := true
    else
      Result := False;
  end;
end;

{ ============ �������� �� ������� ===============
  table - � ����� ������� ������,
  pole - � ����� ���� ������� ������,
  val -  �� ������� �������� �����,
  PoleSearch - ������� � ������� ��������� ������ ������
}
function PoleInSearchStr(table, pole, val, PoleSearch: string): String;
begin
  // ������ �������� �� ������� �� ������� ����
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

{ ============ �������� ������ � ������� ===============
  table - � ����� �������,
  pole - � ����� ���� ������� ��������,
  val -  �������� �������
}
procedure InsertNewRecords(table, pole, val: String);
begin
  // -------------- �������� ������ � ������� ----------------
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

{ ============ �������� ������� ===============
  tabl - � ����� �������
}
procedure CleanOutTable(tabl: String);
begin // �������� ������� �� �������
  with DM.qQuery do
  begin
    Close;
    SQL.Clear;
    SQL.Text := 'Delete From ' + tabl;
    ExecSQL;
    Close;
  end;
end;

{ ============ �������� ������� � ������ ===============
  tabl - � ����� �������,
  pole - �������� ���� �� �������� �����
}
procedure CleanOutTableAndIndex(tabl: String; pole: String);
var
  s: string;
begin
  with DM.qQuery do
  begin
    Close; // �������� ������ ������� pole - �������� ���� �� �������� �����
    SQL.Clear;
    SQL.Add('Alter Table ' + tabl + '  Alter Column ' + pole + ' Counter(1,1)');
    s := SQL.Text;
    ExecSQL;
    Close;
    CleanOutTable(tabl); // ������� �������
  end;
end;

{ ===== ������� ������� � ��������� ������� � ��������� �������� ======
  tabl - � ����� �������,
  pole - �������� ���� �� �������� �����
  startNumber - � ����� ����� �������� �������
}
// ������� ������� � ��������� ������� � ��������� � ����� ����� �������� �������
procedure CleanOutTableAndIndex0(tabl, pole, startNumber: String);
begin
  with DM.qQuery do
  begin
    Close; // �������� ������ ������� pole - �������� ���� �� �������� �����
    SQL.Clear;
    SQL.Add('Alter Table ' + tabl + '  Alter Column ' + pole + ' Counter(' +
      startNumber + ',1)');
    ExecSQL;
    Close;
    CleanOutTable(tabl); // ������� �������
  end;
end;

// �������� ������ ���������� �������� �� ���� �������
function SpisokPoley(tabl, pole, poleDate: String): String;
var
  i: Integer;
  spisok: TStringList;
  s: string;
begin
  with DM.qCountItems do
  begin
    SQL.Clear;
    SQL.Text := 'select ' + pole + ' From ' + tabl + ' WHERE ' + poleDate +
      ' Between :ot and :do Group by ' + pole + ' ;';
    Prepare;
    Params.ParamByName('do').AsDateTime := konec;
    Params.ParamByName('ot').AsDateTime := Nachalo;

    s := SQL.Text;
    ExecSQL;

//    r := RecordCount;
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

// �������� ������ ���������� �������� �� ���� ������� � ��������
function SpisokPoleyWhere(tabl, pole, pWhere: String): String;
var
  i: Integer;
  spisok: TStringList;
  s: string;
begin
  with DM.qCountItems do
  begin
    SQL.Clear;

    SQL.Text := 'SELECT `' + pole + '` FROM `' + tabl +
      '` WHERE (`DateKontakta` BETWEEN :ot and :do) and `Tema`= :vidPoslugy Group By `'
      + pole + '`;';
    Prepare;
    Params.ParamByName('ot').AsDateTime := Nachalo;
    Params.ParamByName('do').AsDateTime := konec;
    Params.ParamByName('vidPoslugy').AsString := pWhere;

    s := SQL.Text;
    ExecSQL;

//    r := RecordCount;
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

// ���������� ���-�� ������� � �������
{
  start - ����� ������� �������
  konec - ����� ������� �������
  ispolnitel - �� ��� ������
  mTema - ��� ������
  mType - ��� ��������
  groups: Boolean - ������������ �� �������� ��� ���
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
    ParamByName('pStat').AsString := '���������';
    ParamByName('pIspol').AsString := ispolnitel;
    ParamByName('pTema').AsString := mTema;
    ParamByName('pType').AsString := mType;
    Active := true;
    Result := IntToStr(RecordCount);
  end;
end;

function PodschetZapros(table, pdate, pMentor, pTypeOrg, pCount: String)
  : TMyResult;
var
  i: Integer;
begin
  with DM.qTraining do
  begin
    Active := False;
    SQL.Clear;
    SQL.Text := 'SELECT * FROM `' + table + '` WHERE (`' + pdate +
      '` Between :pOt and :pDo) and (`Mentor`=:mentor) and (`type_org` =:tOrg)';

    Prepare;
    ParamByName('pOt').AsString := FormatDateTime('YYYY-MM-DD', Nachalo);
    ParamByName('pDo').AsString := FormatDateTime('YYYY-MM-DD', konec);
    ParamByName('mentor').AsString := pMentor;
    ParamByName('tOrg').AsString := pTypeOrg;
    Active := true;

    Result.vstrech := RecordCount;
    Result.people := 0;

    for i := 0 to RecordCount - 1 do
    begin
      Result.people := Result.people + FieldByName(pCount).AsInteger;
      next;
    end;

  end;
end;

end.
