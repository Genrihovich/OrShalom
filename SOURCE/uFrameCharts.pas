unit uFrameCharts;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  uFrameCustom, sFrameAdapter, Vcl.StdCtrls, Vcl.Buttons, VclTee.TeeGDIPlus,
  VCLTee.TeEngine, Vcl.ExtCtrls, VCLTee.TeeProcs, VCLTee.Chart, JvExControls,
  JvChart, Data.DB, VCLTee.Series, sPanel, VCLTee.DBChart, Vcl.Grids,
  Vcl.DBGrids, VCLTee.TeeDBCrossTab, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, dxSkinsCore, dxSkinsDefaultPainters, dxorgced,
  dxorgchr, dxdborgc, VCLTee.TeeData;

type
  TfrmCharts = class(TCustomInfoFrame)
    DBChart1: TDBChart;
    sPanel1: TsPanel;
    DBGrid1: TDBGrid;
    DBCrossTabSource1: TDBCrossTabSource;
    DBCrossTabSource2: TDBCrossTabSource;
    DBCrossTabSource3: TDBCrossTabSource;
    Series1: TFastLineSeries;
    ChartDataSet1: TChartDataSet;
    ChartDataSet1Series1Color: TIntegerField;
    ChartDataSet1Series1X: TFloatField;
    ChartDataSet1Series1Y: TFloatField;
    ChartDataSet1Series1Label: TStringField;
    ChartDataSet1Series2Color: TIntegerField;
    ChartDataSet1Series2X: TFloatField;
    ChartDataSet1Series2Y: TFloatField;
    ChartDataSet1Series2Label: TStringField;
    ChartDataSet1Series3Color: TIntegerField;
    ChartDataSet1Series3X: TFloatField;
    ChartDataSet1Series3Y: TFloatField;
    ChartDataSet1Series3Label: TStringField;
    ChartDataSet1Series4Color: TIntegerField;
    ChartDataSet1Series4X: TFloatField;
    ChartDataSet1Series4Y: TFloatField;
    ChartDataSet1Series4Label: TStringField;
    ChartDataSet1Series5Color: TIntegerField;
    ChartDataSet1Series5X: TFloatField;
    ChartDataSet1Series5Y: TFloatField;
    ChartDataSet1Series5Label: TStringField;
    ChartDataSet1Series6Color: TIntegerField;
    ChartDataSet1Series6X: TFloatField;
    ChartDataSet1Series6Y: TFloatField;
    ChartDataSet1Series6Label: TStringField;
    ChartDataSet1Series7Color: TIntegerField;
    ChartDataSet1Series7X: TFloatField;
    ChartDataSet1Series7Y: TFloatField;
    ChartDataSet1Series7Label: TStringField;
    ChartDataSet1Series8Color: TIntegerField;
    ChartDataSet1Series8X: TFloatField;
    ChartDataSet1Series8Y: TFloatField;
    ChartDataSet1Series8Label: TStringField;
    ChartDataSet1Series9Color: TIntegerField;
    ChartDataSet1Series9X: TFloatField;
    ChartDataSet1Series9Y: TFloatField;
    ChartDataSet1Series9Label: TStringField;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses uDM;

end.
