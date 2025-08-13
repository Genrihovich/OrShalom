inherited frmObAnalitics: TfrmObAnalitics
  Width = 804
  Height = 580
  ParentFont = False
  ExplicitWidth = 804
  ExplicitHeight = 580
  object panTop: TsPanel [0]
    Left = 0
    Top = 0
    Width = 804
    Height = 41
    Align = alTop
    TabOrder = 0
    DesignSize = (
      804
      41)
    object sLabelFX1: TsLabelFX
      Left = 1
      Top = 9
      Width = 17
      Height = 21
      Caption = #1089':'
      Angle = 0
      Shadow.OffsetKeeper.LeftTop = -3
      Shadow.OffsetKeeper.RightBottom = 5
    end
    object sLabelFX2: TsLabelFX
      Left = 144
      Top = 9
      Width = 24
      Height = 21
      Caption = #1087#1086':'
      Angle = 0
      Shadow.OffsetKeeper.LeftTop = -3
      Shadow.OffsetKeeper.RightBottom = 5
    end
    object sDateEdit3: TsDateEdit
      Left = 22
      Top = 10
      Width = 111
      Height = 21
      EditMask = '!99/99/9999;1; '
      MaxLength = 10
      TabOrder = 0
      Text = '  .  .    '
      OnChange = sDateEdit3Change
    end
    object sDateEdit4: TsDateEdit
      Left = 172
      Top = 10
      Width = 133
      Height = 21
      EditMask = '!99/99/9999;1; '
      MaxLength = 10
      TabOrder = 1
      Text = '  .  .    '
      OnChange = sDateEdit4Change
    end
    object btnCalck: TBitBtn
      Left = 467
      Top = 10
      Width = 89
      Height = 25
      Action = acCalck
      Caption = #1056#1086#1079#1088#1072#1093#1091#1074#1072#1090#1080
      TabOrder = 2
    end
    object btnSave: TBitBtn
      Left = 665
      Top = 11
      Width = 131
      Height = 25
      Action = acSaveExcel
      Anchors = [akTop, akRight]
      Caption = #1047#1073#1077#1088#1077#1075#1090#1080' '#1074' Excel'
      TabOrder = 3
    end
    object cbPeriod: TsComboBox
      Left = 316
      Top = 11
      Width = 145
      Height = 21
      ItemIndex = -1
      TabOrder = 4
      Text = #1087#1077#1088#1110#1086#1076#1080
      OnChange = cbPeriodChange
      Items.Strings = (
        '1 '#1082#1074#1072#1088#1090#1072#1083
        '2 '#1082#1074#1072#1088#1090#1072#1083
        '3 '#1082#1074#1072#1088#1090#1072#1083
        '4 '#1082#1074#1072#1088#1090#1072#1083
        #1055#1110#1074' '#1088#1086#1082#1091
        #1056#1110#1082)
    end
  end
  object panAll: TsPanel [1]
    Left = 0
    Top = 41
    Width = 804
    Height = 539
    Align = alClient
    TabOrder = 1
    object Splitter1: TSplitter
      Left = 1
      Top = 161
      Width = 802
      Height = 3
      Cursor = crVSplit
      Align = alTop
      ExplicitWidth = 227
    end
    object DBGridEh1: TDBGridEh
      Left = 1
      Top = 1
      Width = 802
      Height = 160
      Align = alTop
      DataSource = DM.dsAnalitic
      DynProps = <>
      TabOrder = 0
      Columns = <
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = 'EventID'
          Footers = <>
          Width = 20
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = #1053#1072#1079#1074#1072'_'#1079#1072#1093#1086#1076#1091
          Footers = <>
          Width = 200
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
          FieldName = #1061#1090#1086'_'#1087#1088#1086#1074#1086#1076#1080#1074
          Footers = <>
          Width = 80
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = #1050#1110#1083#1100#1082#1110#1089#1090#1100'_'#1089#1090#1086#1088#1086#1085#1085#1110#1093
          Footers = <>
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = 'JDC ID'
          Footers = <>
          Width = 80
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = #1060#1048#1054
          Footers = <>
          Width = 200
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = #1042#1086#1079#1088#1072#1089#1090
          Footers = <>
          Width = 30
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = #1058#1080#1087' '#1082#1083#1080#1077#1085#1090#1072' ('#1076#1083#1103' '#1087#1086#1080#1089#1082#1072')'
          Footers = <>
          Width = 150
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = #1057#1086#1079#1076#1072#1085#1086
          Footers = <>
          Width = 80
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = #1053#1072#1079#1074#1072
          Footers = <>
          Width = 100
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = 'nameRegion'
          Footers = <>
          Width = 150
        end>
      object RowDetailData: TRowDetailPanelControlEh
      end
    end
    object StringGrid: TJvStringGrid
      Left = 1
      Top = 164
      Width = 802
      Height = 374
      Align = alClient
      ColCount = 8
      TabOrder = 1
      OnDrawCell = StringGridDrawCell
      Alignment = taLeftJustify
      FixedFont.Charset = DEFAULT_CHARSET
      FixedFont.Color = clWindowText
      FixedFont.Height = -11
      FixedFont.Name = 'Tahoma'
      FixedFont.Style = []
      ExplicitHeight = 276
    end
  end
  inherited sFrameAdapter1: TsFrameAdapter
    Top = 584
  end
  object ActionList1: TActionList
    Left = 736
    Top = 72
    object acCalck: TAction
      Caption = #1056#1086#1079#1088#1072#1093#1091#1074#1072#1090#1080
      OnExecute = btnCalckClick
      OnUpdate = acCalckUpdate
    end
    object acSaveExcel: TAction
      Caption = #1047#1073#1077#1088#1077#1075#1090#1080' '#1074' Excel'
      OnExecute = btnSaveClick
      OnUpdate = acSaveExcelUpdate
    end
  end
end
