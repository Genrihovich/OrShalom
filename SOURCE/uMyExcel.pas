{uMyExcel - модуль для выполнения основных операций с MS Excel

 Разработчик Vlad
 Сайт http://webdelphi.ru
 E-mail: vlad383@mail.ru

 Описание модуля:
 Вся работа ведется через переменную MyExcel
   [+] CheckExcelInstall - проверяет установлен ли Excel на компьютре
   [+] CheckExcelRun - проверяет есть ил запущенный экземпляр Excel и, если таковой
                   обнаруживается - получает ссылку на него для дальнейшей работы
   [+] RunExcel() - запускает Excel
       DisableAlerts - включает/отключает сообщения Excel (рекомендуется
                       использовать значение по-умолчанию);
       Visible - определяет будет ли показано окно Excel после открытия
   [+] StopExcel - останавливает Excel без каких-либо сохранений документа
   [+] AddWorkBook - добавляет рабочую книгу в запущенном Excel, если параметр
                 AutoRun=true, то сначала запускает Excel (если он не запущен)
                 и затем добавляет пустую книгу
   [+] GetAllWorkBooks - перечисляет все рабочие книги, которые открыты в данный
                     момент в Excel в список заносятся полные названия книг
   [+] SaveWorkBook - сохраняет рабочую книгу с индексом WBIndex в файл с названием
                  FileName (индекс первой открытой рабочей книги всегда 1)
   [+] OpenWorkBook - открывает файл рабочей книги FileName; Visible - определяет
                  будет ли окно Excel показано пользователю

 }
unit uMyExcel;

interface

uses ComObj, ActiveX, Variants, Windows, Messages, SysUtils, Classes, Vcl.Dialogs, System.UITypes;

const
ExcelApp = 'Excel.Application';
xlContinuous=1;
xlThin=2;
xlTop = -4160;
xlCenter = -4108;
xlDouble = -4119; //Двойная сплошная линия.


function CheckExcelInstall:boolean;
function CheckExcelRun: boolean;
function RunExcel(DisableAlerts:boolean=true; Visible: boolean=false): boolean;
function StopExcel:boolean;
function AddWorkBook(AutoRun:boolean=true):boolean;
function GetAllWorkBooks:TStringList;
function SaveWorkBook(FileName:TFileName; WBIndex:integer):boolean;
function OpenWorkBook(FileName:TFileName; Visible:boolean=true):boolean;
procedure ParametryStr;
procedure ParametryTabl(k:integer);
procedure ShapkaTabl;
procedure ParametryTablVedomost(I:Integer);
procedure DeleteWorkSheet(WorkBookName, WorkSheetName: Ansistring);
function WorkBookIndex(WorkBookName: Ansistring): integer;
function WorkSheetIndex(WorkBookName, WorkSheetName: Ansistring): integer;

var MyExcel: OleVariant;

implementation

//uses frMain;



function OpenWorkBook(FileName:TFileName; Visible:boolean=true):boolean;
begin
  try
    MyExcel.WorkBooks.Open(FileName);
    MyExcel.Visible:=Visible;
    Result:=true;
  except
    result:=false;
  end;
end;

function GetAllWorkBooks:TStringList;
var i:integer;
begin
try
  Result:=TStringList.Create;
  for i:=1 to MyExcel.WorkBooks.Count do
    Result.Add(MyExcel.WorkBooks.Item[i].FullName)
except
  MessageBox(0,'Ошибка перечисления открытых книг','Ошибка',MB_OK+MB_ICONERROR);
end;
end;

function SaveWorkBook(FileName:TFileName; WBIndex:integer):boolean;
begin
  try
    MyExcel.WorkBooks.Item[WBIndex].SaveAs(FileName);
    if MyExcel.WorkBooks.Item[WBIndex].Saved then
      Result:=true
    else
      Result:=false;
  except
    Result:=false;
  end;
end;

function AddWorkBook(AutoRun:boolean=true):boolean;
begin
  if CheckExcelRun then
    begin
      MyExcel.WorkBooks.Add;
      Result:=true;
    end
  else
    if AutoRun then
      begin
        RunExcel;
        MyExcel.WorkBooks.Add;
        Result:=true;
      end
    else
      Result:=false;
end;

function CheckExcelInstall:boolean;
var
  ClassID: TCLSID;
  Rez : HRESULT;
begin
  // Ищем CLSID OLE-объекта
  Rez := CLSIDFromProgID(PWideChar(WideString(ExcelApp)), ClassID);
  if Rez = S_OK then  // Объект найден
    Result := true
  else
    Result := false;
end;

function CheckExcelRun: boolean;
begin
  try
    MyExcel:=GetActiveOleObject(ExcelApp);
    Result:=True;
  except
    Result:=false;
  end;
end;

function RunExcel(DisableAlerts:boolean=true; Visible: boolean=false): boolean;
begin
try
  {проверяем установлен ли Excel}
 if CheckExcelInstall then
   begin
     MyExcel:=CreateOleObject(ExcelApp);
     //показывать/не показывать системные сообщения Excel (лучше не показывать)
     MyExcel.Application.EnableEvents:=DisableAlerts;
     MyExcel.Visible:=Visible;
     Result:=true;
   end
 else
   begin
     MessageBox(0,'Приложение MS Excel не установлено на этом компьютере','Ошибка',MB_OK+MB_ICONERROR);
     Result:=false;
   end;
except
  Result:=false;
end;
end;

function StopExcel:boolean;
begin
  try
    if MyExcel.Visible then MyExcel.Visible:=false;
    MyExcel.Quit;
    MyExcel:=Unassigned;
    Result:=True;
  except
    Result:=false;
  end;
end;

procedure ParametryStr;
begin
      MyExcel.ActiveSheet.PageSetup.Orientation:= 2;
      MyExcel.ActiveSheet.PageSetup.LeftMargin:= MyExcel.Application.InchesToPoints(0.30);
      MyExcel.ActiveSheet.PageSetup.RightMargin:= MyExcel.Application.InchesToPoints(0.20);
      MyExcel.ActiveSheet.PageSetup.TopMargin:= MyExcel.Application.InchesToPoints(0.44);
      MyExcel.ActiveSheet.PageSetup.BottomMargin:= MyExcel.Application.InchesToPoints(0.44);
//      MyExcel.ActiveSheet.PageSetup.FitToPagesWide := 2;
//      MyExcel.ActiveSheet.PageSetup.FitToPagesTall := 2;

end;

procedure ParametryTabl(k:integer);
var
 ExcelApp : Variant;
begin
               ExcelApp := MyExcel.ActiveWorkBook.WorkSheets[k].columns;
             ExcelApp.columns[1].columnwidth := 3.17;
             //  ExcelApp.columns[1].AutoFit;
             ExcelApp.columns[1].HorizontalAlignment := 3;
             ExcelApp.columns[2].columnwidth := 2.43;
             ExcelApp.columns[2].HorizontalAlignment := 3;
             ExcelApp.columns[3].columnwidth := 6.14;
             ExcelApp.columns[4].columnwidth := 10.57;
             ExcelApp.columns[5].columnwidth := 6.29;
             ExcelApp.columns[5].HorizontalAlignment := 3;
             ExcelApp.columns[6].columnwidth := 30.57;
             ExcelApp.columns[7].columnwidth := 12.57;
             ExcelApp.columns[7].NumberFormat := '0.00" грн."';
             ExcelApp.columns[8].columnwidth := 14.14;
             ExcelApp.columns[8].HorizontalAlignment := 3;
             ExcelApp.columns[8].NumberFormat := 'dd.mm.yyyy';  //'ДД.ММ.ГГГГ';
             ExcelApp.columns[9].columnwidth := 14.14;
             ExcelApp.columns[9].NumberFormat := 'dd.mm.yyyy';
             ExcelApp.columns[9].HorizontalAlignment := 3;
             ExcelApp.columns[10].columnwidth := 14.43;

             ExcelApp.columns[10].NumberFormat := '0.00" грн."';
             ExcelApp.columns[11].columnwidth := 17.71;
end;

procedure ParametryTablVedomost(I:Integer);
var
 ExcelApp : Variant;
begin
   ExcelApp := MyExcel.ActiveWorkBook.WorkSheets[i].columns;
   ExcelApp.columns[1].columnwidth := 5;
             //  ExcelApp.columns[1].AutoFit;
   ExcelApp.columns[1].HorizontalAlignment := 3;
   ExcelApp.columns[2].columnwidth := 5.14;
   ExcelApp.columns[2].HorizontalAlignment := 3;
   ExcelApp.columns[3].columnwidth := 10.43;
   ExcelApp.columns[4].columnwidth := 23.86;
   ExcelApp.columns[5].columnwidth := 6.29;
   ExcelApp.columns[5].HorizontalAlignment := 3;
   ExcelApp.columns[6].columnwidth := 44.71;
   ExcelApp.columns[7].columnwidth := 19.86;
   ExcelApp.columns[7].NumberFormat := '0.00" грн."';
   ExcelApp.columns[8].columnwidth := 18.57;
   ExcelApp.columns[8].HorizontalAlignment := 3;
end;


procedure ShapkaTabl;
begin
  MyExcel.Selection.Borders.LineStyle:=xlContinuous;             //границы
  MyExcel.Selection.Borders.Weight:=xlThin;                     // показать

  MyExcel.Selection.HorizontalAlignment :=3;
  MyExcel.Selection.VerticalAlignment := 2;

  MyExcel.Selection.Font.Name:='Calibri';
  MyExcel.Selection.Font.Size:=14;
  MyExcel.Selection.WrapText:=true;     //вкл перенос по словам

  MyExcel.Selection.Borders[9].LineStyle:=9;
end;


procedure DeleteWorkSheet(WorkBookName, WorkSheetName: Ansistring);
var
  k, j: integer;
begin
  if VarIsEmpty(MyExcel) = false then
  begin
    k := WorkBookIndex(WorkBookName);
    MyExcel.DisplayAlerts := false;
    j := WorkSheetIndex(WorkBookName, WorkSheetName);
    if j <> 0 then
      MyExcel.Workbooks[k].Sheets[j].Delete
    else
      MessageDlg('Листа с таким именем в этой книге нет.', mtWarning, [mbOk],
        0);
  end;
end;


function WorkBookIndex(WorkBookName: Ansistring): integer;
var
  i, n: integer;
begin
  //проверка на наличие книги с этим именем
  n := 0;
  if VarIsEmpty(MyExcel) = false then
    for i := 1 to MyExcel.WorkBooks.Count do
      if MyExcel.WorkBooks[i].FullName = WorkBookName then
      begin
        n := i;
        break;
      end;
  WorkBookIndex := n;
end;


function WorkSheetIndex(WorkBookName, WorkSheetName: Ansistring): integer;
var
  i, k, n: integer;
begin
  //проверка на наличие листа с этим именем в книге с этим именем
  n := 0;
  if VarIsEmpty(MyExcel) = false then
  begin
    k := WorkBookIndex(WorkBookName);
    for i := 1 to MyExcel.WorkBooks[k].Sheets.Count do
      if MyExcel.WorkBooks[k].Sheets[i].Name = WorkSheetName then
      begin
        n := i;
        break;
      end;
  end;
  WorkSheetIndex := n;
end;


end.

