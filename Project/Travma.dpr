program Travma;

uses
  Vcl.Forms,
  uMainForm in '..\SOURCE\uMainForm.pas' {myForm},
  uFrameCustom in '..\SOURCE\uFrameCustom.pas' {CustomInfoFrame: TFrame},
  uMenu in '..\SOURCE\uMenu.pas' {frmMenu: TFrame},
  uFrameDovidniky in '..\SOURCE\uFrameDovidniky.pas' {frmDovidniky: TFrame},
  uFrameCharts in '..\SOURCE\uFrameCharts.pas' {frmCharts: TFrame},
  uFrameStatistic in '..\SOURCE\uFrameStatistic.pas' {frmStatistic: TFrame},
  uFrameKontakt in '..\SOURCE\uFrameKontakt.pas' {frmKontakt: TFrame},
  uDM in '..\SOURCE\uDM.pas' {DM: TDataModule},
  uAutorize in '..\SOURCE\uAutorize.pas' {fAutorize},
  myUtils in '..\SOURCE\myUtils.pas',
  myBDUtils in '..\SOURCE\myBDUtils.pas',
  uMyExcel in '..\SOURCE\uMyExcel.pas',
  uObchinaMenu in '..\SOURCE\uObchinaMenu.pas' {frmObchiaMenu: TFrame},
  uFrameObExport in '..\SOURCE\uFrameObExport.pas' {frmObExportData},
  uFrameObInputZahid in '..\SOURCE\uFrameObInputZahid.pas' {frmObInputZahid},
  uFrameObNewZahid in '..\SOURCE\uFrameObNewZahid.pas' {frmObNewZahid},
  uOptions in '..\SOURCE\uOptions.pas' {frmOption},
  uFrameObAnalitics in '..\SOURCE\uFrameObAnalitics.pas' {frmObAnalitics};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TfAutorize, fAutorize);
  Application.CreateForm(TmyForm, myForm);
  Application.Run;
end.
