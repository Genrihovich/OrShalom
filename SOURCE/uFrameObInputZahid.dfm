inherited frmObInputZahid: TfrmObInputZahid
  Width = 795
  Height = 345
  ParentFont = False
  ExplicitWidth = 795
  ExplicitHeight = 345
  object sPanel1: TsPanel [0]
    Left = 0
    Top = 0
    Width = 795
    Height = 41
    Align = alTop
    TabOrder = 0
    ExplicitWidth = 756
    object Button1: TButton
      Left = 8
      Top = 10
      Width = 75
      Height = 25
      Caption = #1053#1086#1074#1080#1081' '#1079#1072#1093#1110#1076
      TabOrder = 0
      OnClick = Button1Click
    end
  end
  object DBGridEh1: TDBGridEh [1]
    Left = 0
    Top = 41
    Width = 795
    Height = 304
    Align = alClient
    DataSource = DM.dsEvents
    DynProps = <>
    TabOrder = 1
    Columns = <
      item
        CellButtons = <>
        DynProps = <>
        EditButtons = <>
        FieldName = 'ID'
        Footers = <>
        Width = 17
      end
      item
        CellButtons = <>
        DynProps = <>
        EditButtons = <>
        FieldName = #1044#1072#1090#1072
        Footers = <>
      end
      item
        CellButtons = <>
        DynProps = <>
        EditButtons = <>
        FieldName = 'ClubName'
        Footers = <>
        Width = 161
      end
      item
        CellButtons = <>
        DynProps = <>
        EditButtons = <>
        FieldName = #1053#1072#1079#1074#1072'_'#1079#1072#1093#1086#1076#1091
        Footers = <>
        Width = 156
      end
      item
        CellButtons = <>
        DynProps = <>
        EditButtons = <>
        FieldName = #1055#1030#1041'_'#1093#1090#1086'_'#1087#1088#1086#1074#1086#1076#1080#1074
        Footers = <>
        Width = 172
      end
      item
        CellButtons = <>
        DynProps = <>
        EditButtons = <>
        FieldName = #1050#1110#1083#1100#1082#1110#1089#1090#1100'_'#1089#1090#1086#1088#1086#1085#1085#1110#1093
        Footers = <>
        Title.Caption = #1043#1086#1089#1090#1110
        Width = 32
      end
      item
        CellButtons = <>
        DynProps = <>
        EditButtons = <>
        FieldName = #1053#1072#1079#1074#1072'_'#1088#1077#1075#1110#1086#1085#1091
        Footers = <>
        Title.Caption = #1056#1077#1075#1110#1086#1085
        Width = 120
      end
      item
        CellButtons = <>
        DynProps = <>
        EditButtons = <>
        FieldName = 'id_region'
        Footers = <>
        Width = 30
      end>
    object RowDetailData: TRowDetailPanelControlEh
    end
  end
  inherited sFrameAdapter1: TsFrameAdapter
    Left = 16
    Top = 240
  end
end
