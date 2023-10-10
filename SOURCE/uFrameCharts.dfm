inherited frmCharts: TfrmCharts
  Width = 895
  Height = 673
  ExplicitWidth = 895
  ExplicitHeight = 673
  object DBChart1: TDBChart [0]
    Left = 0
    Top = 41
    Width = 895
    Height = 394
    Foot.Text.Strings = (
      #1084#1110#1089#1103#1094#1103)
    Title.Text.Strings = (
      'TDBChart')
    BottomAxis.Items = {
      07000000010454657874120600000041045604470435043D044C040001045465
      787412050000003B044E044204380439040556616C7565050000000000000080
      FF3F0001045465787412080000003104350440043504370435043D044C040556
      616C756505000000000000008000400001045465787412070000003A04320456
      04420435043D044C040556616C75650500000000000000C00040000104546578
      741207000000420440043004320435043D044C040556616C7565050000000000
      0000800140000104546578741207000000470435044004320435043D044C0405
      56616C75650500000000000000A001400001045465787412060000003B043804
      3F0435043D044C040556616C75650500000000000000C0014000}
    DepthAxis.Automatic = False
    DepthAxis.AutomaticMinimum = False
    DepthAxis.AxisValuesFormat = '0'
    DepthAxis.Minimum = 1.000000000000000000
    DepthAxis.Items = {
      07000000010454657874142E000000D0A1D18BD181D0BAD0BE20D09DD0B0D182
      D0B0D0BBD0B8D18F20D09DD0B8D0BAD0BED0BBD0B0D0B5D0B2D0BDD0B0055661
      6C75650500D0344DD3344DC3014000010454657874142C000000D093D0B8D0BB
      D18CD0B1D0B5D180D0B320D093D0B0D0BBD0B8D0BDD0B020D09BD18CD0B2D0BE
      D0B2D0BDD0B00556616C75650500D0344DD3344DA3014000010454657874142A
      000000D09ED0BBD0B5D0B9D0BDD0B8D0BA20D095D0BBD0B5D0BDD0B020D098D0
      B3D0BED180D0B5D0B2D0BDD0B00556616C75650500D0344DD3344D8301400001
      0454657874142C000000D09AD0BED181D0B8D18ED0BA20D095D0BBD0B5D0BDD0
      B020D09DD0B8D0BAD0BED0BBD0B0D0B5D0B2D0BDD0B00556616C75650500A069
      9AA6699AC6004000010454657874143C000000D09CD0B0D182D0B2D0B8D0B9D1
      87D183D0BA20D0A2D0B0D182D18CD18FD0BDD0B020D092D0BBD0B0D0B4D0B8D1
      81D0BBD0B0D0B2D0BED0B2D0BDD0B00556616C75650500A0699AA6699A860040
      00010454657874142E000000D092D0BBD0B0D181D0BDD0BED0B2D0B020D090D0
      BBD0BBD0B020D090D180D0BAD0B0D0B4D18CD0B5D0B2D0BDD0B00556616C7565
      050040D3344DD3348DFF3F000104546578741428000000D09BD18FD181D0BAD0
      B020D09ED0BAD181D0B0D0BDD0B020D09FD0B5D182D180D0BED0B2D0BDD0B005
      56616C7565050000344DD3344DD3FB3F00}
    LeftAxis.Axis.Color = clDefault
    LeftAxis.Grid.Style = psDot
    LeftAxis.GridCentered = True
    LeftAxis.Logarithmic = True
    LeftAxis.MaximumRound = True
    LeftAxis.Title.Caption = #1050#1110#1083#1100#1082#1110#1089#1090#1100' '#1082#1086#1085#1090#1072#1082#1090#1110#1074
    Legend.FontSeriesColor = True
    Legend.LegendStyle = lsSeries
    Legend.Title.Text.Strings = (
      #1042#1080#1082#1086#1085#1072#1074#1094#1110)
    Legend.VertSpacing = 5
    RightAxis.ExactDateTime = False
    View3DOptions.Elevation = 315
    View3DOptions.Orthogonal = False
    View3DOptions.Perspective = 0
    View3DOptions.Rotation = 360
    Zoom.Animated = True
    Align = alTop
    TabOrder = 0
    DefaultCanvas = 'TGDIPlusCanvas'
    PrintMargins = (
      15
      27
      15
      27)
    ColorPaletteIndex = 4
    object Series1: TFastLineSeries
      Selected.Hover.Visible = True
      Active = False
      Marks.Visible = True
      Marks.Style = smsXValue
      Marks.Callout.Length = 20
      DataSource = DBCrossTabSource3
      XLabelsSource = 'monthDate'
      LinePen.Color = clBlue
      Stairs = True
      TreatNulls = tnDontPaint
      XValues.Name = 'X'
      XValues.Order = loAscending
      XValues.ValueSource = 'Num'
      YValues.Name = 'Y'
      YValues.Order = loNone
      YValues.ValueSource = 'Num'
    end
  end
  object sPanel1: TsPanel [1]
    Left = 0
    Top = 0
    Width = 895
    Height = 41
    Align = alTop
    Caption = 'sPanel1'
    TabOrder = 1
  end
  object DBGrid1: TDBGrid [2]
    Left = 3
    Top = 507
    Width = 374
    Height = 150
    DataSource = DM.dsChart
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'Number'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'monthDate'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'YearDate'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Sostoyalsya'
        Width = 100
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Ispolnitel'
        Width = 150
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Num'
        Visible = True
      end>
  end
  object DBCrossTabSource1: TDBCrossTabSource
    Formula = gfCount
    GroupField = 'Ispolnitel'
    LabelField = 'Ispolnitel'
    ValueField = 'Ispolnitel'
    DataSet = DM.qChart
  end
  object DBCrossTabSource2: TDBCrossTabSource
    Formula = gfMax
    GroupField = 'Ispolnitel'
    HideSeries = False
    LabelField = 'monthDate'
    ValueField = 'Num'
    DataSet = DM.qChart
  end
  object DBCrossTabSource3: TDBCrossTabSource
    Active = True
    Formula = gfMax
    GroupField = 'Ispolnitel'
    LabelField = 'monthDate'
    Series = Series1
    ValueField = 'Num'
    DataSet = DM.qChart
  end
  object ChartDataSet1: TChartDataSet
    Active = True
    Chart = DBChart1
    Left = 480
    Top = 488
    object ChartDataSet1Series1Color: TIntegerField
      FieldName = 'Series1.Color'
    end
    object ChartDataSet1Series1X: TFloatField
      FieldName = 'Series1.X'
    end
    object ChartDataSet1Series1Y: TFloatField
      FieldName = 'Series1.Y'
    end
    object ChartDataSet1Series1Label: TStringField
      FieldName = 'Series1.Label'
      Size = 128
    end
    object ChartDataSet1Series2Color: TIntegerField
      FieldName = 'Series2.Color'
    end
    object ChartDataSet1Series2X: TFloatField
      FieldName = 'Series2.X'
    end
    object ChartDataSet1Series2Y: TFloatField
      FieldName = 'Series2.Y'
    end
    object ChartDataSet1Series2Label: TStringField
      FieldName = 'Series2.Label'
      Size = 128
    end
    object ChartDataSet1Series3Color: TIntegerField
      FieldName = 'Series3.Color'
    end
    object ChartDataSet1Series3X: TFloatField
      FieldName = 'Series3.X'
    end
    object ChartDataSet1Series3Y: TFloatField
      FieldName = 'Series3.Y'
    end
    object ChartDataSet1Series3Label: TStringField
      FieldName = 'Series3.Label'
      Size = 128
    end
    object ChartDataSet1Series4Color: TIntegerField
      FieldName = 'Series4.Color'
    end
    object ChartDataSet1Series4X: TFloatField
      FieldName = 'Series4.X'
    end
    object ChartDataSet1Series4Y: TFloatField
      FieldName = 'Series4.Y'
    end
    object ChartDataSet1Series4Label: TStringField
      FieldName = 'Series4.Label'
      Size = 128
    end
    object ChartDataSet1Series5Color: TIntegerField
      FieldName = 'Series5.Color'
    end
    object ChartDataSet1Series5X: TFloatField
      FieldName = 'Series5.X'
    end
    object ChartDataSet1Series5Y: TFloatField
      FieldName = 'Series5.Y'
    end
    object ChartDataSet1Series5Label: TStringField
      FieldName = 'Series5.Label'
      Size = 128
    end
    object ChartDataSet1Series6Color: TIntegerField
      FieldName = 'Series6.Color'
    end
    object ChartDataSet1Series6X: TFloatField
      FieldName = 'Series6.X'
    end
    object ChartDataSet1Series6Y: TFloatField
      FieldName = 'Series6.Y'
    end
    object ChartDataSet1Series6Label: TStringField
      FieldName = 'Series6.Label'
      Size = 128
    end
    object ChartDataSet1Series7Color: TIntegerField
      FieldName = 'Series7.Color'
    end
    object ChartDataSet1Series7X: TFloatField
      FieldName = 'Series7.X'
    end
    object ChartDataSet1Series7Y: TFloatField
      FieldName = 'Series7.Y'
    end
    object ChartDataSet1Series7Label: TStringField
      FieldName = 'Series7.Label'
      Size = 128
    end
    object ChartDataSet1Series8Color: TIntegerField
      FieldName = 'Series8.Color'
    end
    object ChartDataSet1Series8X: TFloatField
      FieldName = 'Series8.X'
    end
    object ChartDataSet1Series8Y: TFloatField
      FieldName = 'Series8.Y'
    end
    object ChartDataSet1Series8Label: TStringField
      FieldName = 'Series8.Label'
      Size = 128
    end
    object ChartDataSet1Series9Color: TIntegerField
      FieldName = 'Series9.Color'
    end
    object ChartDataSet1Series9X: TFloatField
      FieldName = 'Series9.X'
    end
    object ChartDataSet1Series9Y: TFloatField
      FieldName = 'Series9.Y'
    end
    object ChartDataSet1Series9Label: TStringField
      FieldName = 'Series9.Label'
      Size = 128
    end
  end
end
