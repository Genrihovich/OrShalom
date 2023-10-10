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

// ���� �� ������������� ������ � �������
function isAssetValue(table, pole, val: String): Boolean;
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
function SpisokPoley(tabl, pole: String): String;
// ���������� ���-�� ������� � �������
function CountRecordData(start, konec, ispolnitel, mTema, mType: String;
  groups: Boolean): String;

implementation

uses uDM;

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
function SpisokPoley(tabl, pole: String): String;
var
  i, r: integer;
  spisok: TStringList;
  s: string;
begin
  with DM.qCountItems do
  begin
    Close;
    SQL.Clear;
    SQL.Text := 'select ' + pole + ' From ' + tabl + ' Group By ' + pole;
    s := SQL.Text;
    ExecSQL;
    // select Tema From ZvitSnow Group By Tema
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

// ���������� ���-�� ������� � �������
function CountRecordData(start, konec, ispolnitel, mTema, mType: String;
  groups: Boolean): String;
begin
  with DM.qCountItems do
  begin
    Active := False;
    SQL.Clear;
    if (mType = '') and (groups = False) then
      SQL.Text :=
        'SELECT * FROM ZvitSnow WHERE (DateKontakta Between :pOt and :pDo) AND (Ispolnitel = :pIspol) AND (Sostoyalsya = :pStat) AND (Tema = :pTema)';

    if (mType = '') and (groups = true) then
      SQL.Text :=
        'SELECT * FROM ZvitSnow WHERE (DateKontakta Between :pOt and :pDo) AND (Ispolnitel = :pIspol) AND (Sostoyalsya = :pStat) AND (Tema = :pTema) GROUP BY Kontakt';

    if (mType <> '') and (groups = False) then
    begin
      SQL.Text :=
        'SELECT * FROM ZvitSnow WHERE (DateKontakta Between :pOt and :pDo) AND (Ispolnitel = :pIspol) AND (Sostoyalsya = :pStat) AND (Tema = :pTema) AND (TypeKontakta = :pType)';
      ParamByName('pType').AsString := mType;
    end;

    if (mType <> '') and (groups = true) then
    begin
      SQL.Text :=
        'SELECT * FROM ZvitSnow WHERE (DateKontakta Between :pOt and :pDo) AND (Ispolnitel = :pIspol) AND (Sostoyalsya = :pStat) AND (Tema = :pTema) AND (TypeKontakta = :pType) GROUP BY Kontakt';
      ParamByName('pType').AsString := mType;
    end;

    ParamByName('pOt').AsString := FormatDateTime('YYYY-MM-DD',
      StrToDate(start));
    ParamByName('pDo').AsString := FormatDateTime('YYYY-MM-DD',
      StrToDate(konec));
    ParamByName('pStat').AsString := '���������';
    ParamByName('pIspol').AsString := ispolnitel;
    ParamByName('pTema').AsString := mTema;
    Active := true;
    Result := IntToStr(RecordCount);
  end;
end;

end.