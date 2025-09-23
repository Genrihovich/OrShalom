inherited frmOption: TfrmOption
  Width = 704
  Height = 489
  ParentFont = False
  ExplicitWidth = 704
  ExplicitHeight = 489
  object pRegion: TsPanel [0]
    Left = 0
    Top = 0
    Width = 704
    Height = 249
    Align = alTop
    TabOrder = 0
    object sLabelFX2: TsLabelFX
      Left = 1
      Top = 1
      Width = 702
      Height = 21
      Align = alTop
      Alignment = taCenter
      Caption = #1055#1077#1088#1077#1084#1110#1089#1090#1080#1090#1080' '#1087#1088#1110#1079#1074#1080#1097#1077' '#1082#1091#1088#1072#1090#1086#1088#1072' '#1085#1072' '#1088#1077#1075#1110#1086#1085
      Angle = 0
      Shadow.OffsetKeeper.LeftTop = -3
      Shadow.OffsetKeeper.RightBottom = 5
      ExplicitWidth = 219
    end
    object sPanel3: TsPanel
      Left = 1
      Top = 22
      Width = 702
      Height = 226
      Align = alClient
      TabOrder = 0
      object dbGridKurators: TDBGridEh
        Left = 372
        Top = 1
        Width = 329
        Height = 224
        Align = alRight
        DataSource = DM.dsKurators
        DragMode = dmAutomatic
        DynProps = <>
        TabOrder = 0
        OnMouseDown = dbGridKuratorsMouseDown
        Columns = <
          item
            CellButtons = <>
            DynProps = <>
            EditButtons = <>
            FieldName = #1050#1091#1088#1072#1090#1086#1088
            Footers = <>
            Width = 200
          end
          item
            CellButtons = <>
            DynProps = <>
            EditButtons = <>
            FieldName = 'JDC ID'
            Footers = <>
            Width = 80
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
      object dbGridRegion: TDBGridEh
        AlignWithMargins = True
        Left = 4
        Top = 4
        Width = 348
        Height = 218
        Margins.Right = 20
        Align = alClient
        DataSource = DM.dsRegions
        DynProps = <>
        TabOrder = 1
        OnDragDrop = dbGridRegionDragDrop
        OnDragOver = dbGridRegionDragOver
        Columns = <
          item
            Alignment = taCenter
            CellButtons = <>
            DynProps = <>
            EditButtons = <>
            FieldName = 'id'
            Footers = <>
            Title.Alignment = taCenter
            Width = 30
          end
          item
            CellButtons = <>
            DynProps = <>
            EditButtons = <>
            FieldName = 'nameRegion'
            Footers = <>
            Title.Caption = #1056#1077#1075#1110#1086#1085
            Width = 140
          end
          item
            Alignment = taCenter
            CellButtons = <>
            DynProps = <>
            EditButtons = <>
            FieldName = 'id_Kurator'
            Footers = <>
            Title.Alignment = taCenter
            Title.Caption = 'id '#1050#1091#1088#1072#1090#1086#1088#1072
            Width = 80
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
    end
  end
  object sPanel1: TsPanel [1]
    Left = 0
    Top = 454
    Width = 704
    Height = 35
    Align = alBottom
    TabOrder = 1
    object btnClearEvent: TButton
      Left = 16
      Top = 4
      Width = 249
      Height = 25
      Caption = #1054#1095#1080#1097#1077#1085#1085#1103' '#1090#1072#1073#1083#1080#1094#1100' '#1047#1072#1093#1086#1076#1110#1074' '#1079' '#1091#1095#1072#1089#1085#1080#1082#1072#1084#1080
      TabOrder = 0
      OnClick = btnClearEventClick
    end
  end
  object pRoll: TsPanel [2]
    Left = 0
    Top = 249
    Width = 704
    Height = 205
    Align = alClient
    TabOrder = 2
    object sLabelFX1: TsLabelFX
      Left = 1
      Top = 1
      Width = 702
      Height = 21
      Align = alTop
      Alignment = taCenter
      Caption = #1055#1077#1088#1077#1084#1110#1089#1090#1080#1090#1080' '#1087#1086#1079#1080#1094#1110#1102' '#1088#1086#1083#1110' '#1085#1072' '#1087#1088#1110#1079#1074#1080#1097#1077' '#1082#1086#1088#1080#1089#1090#1091#1074#1072#1095#1072
      Angle = 0
      Shadow.OffsetKeeper.LeftTop = -3
      Shadow.OffsetKeeper.RightBottom = 5
      ExplicitWidth = 268
    end
    object sPanel2: TsPanel
      Left = 1
      Top = 22
      Width = 702
      Height = 182
      Align = alClient
      TabOrder = 0
      object dbGridUsers: TDBGridEh
        AlignWithMargins = True
        Left = 4
        Top = 4
        Width = 516
        Height = 174
        Margins.Right = 20
        Align = alClient
        DataSource = DM.dsUser_option
        DynProps = <>
        TabOrder = 0
        OnDragDrop = dbGridUsersDragDrop
        OnDragOver = dbGridUsersDragOver
        Columns = <
          item
            Alignment = taCenter
            CellButtons = <>
            DynProps = <>
            EditButtons = <>
            FieldName = 'Id'
            Footers = <>
            Title.Alignment = taCenter
            Width = 25
          end
          item
            CellButtons = <>
            DynProps = <>
            EditButtons = <>
            FieldName = 'fullName'
            Footers = <>
            Title.Caption = #1055#1030#1041' '#1082#1086#1088#1080#1089#1090#1091#1074#1072#1095#1072
            Width = 200
          end
          item
            CellButtons = <>
            DynProps = <>
            EditButtons = <>
            FieldName = 'posada'
            Footers = <>
            Title.Caption = #1055#1086#1089#1072#1076#1072
            Width = 100
          end
          item
            Alignment = taCenter
            CellButtons = <>
            DynProps = <>
            EditButtons = <>
            FieldName = 'role'
            Footers = <>
            Title.Alignment = taCenter
            Title.Caption = #1044#1086#1089#1090#1091#1087
          end
          item
            Alignment = taCenter
            CellButtons = <>
            DynProps = <>
            EditButtons = <>
            FieldName = 'id_region'
            Footers = <>
            Title.Alignment = taCenter
            Title.Caption = 'id '#1056#1077#1075#1110#1086#1085#1072
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
      object lbRole: TsListBox
        Left = 540
        Top = 1
        Width = 161
        Height = 180
        Align = alRight
        Items.Strings = (
          '0 - '#1040#1076#1084#1110#1085#1110#1089#1090#1088#1072#1090#1086#1088
          '1 - '#1058#1088#1072#1074#1084#1072' '#1062#1077#1085#1090#1088
          '2 - '#1054#1073#1097#1080#1085#1085#1110' '#1087#1088#1086#1075#1088#1072#1084#1084#1080
          '3 - '#1058#1088#1072#1074#1084#1072' & '#1054#1073#1097#1080#1085#1072
          '4 - '#1042#1086#1083#1086#1085#1090#1077#1088' '#1050#1086#1084#39#1102#1085#1110#1090#1110)
        TabOrder = 1
      end
    end
  end
  inherited sFrameAdapter1: TsFrameAdapter
    Left = 320
    Top = 8
  end
end
