inherited frmObExportData: TfrmObExportData
  Width = 840
  Height = 480
  ParentFont = False
  ExplicitWidth = 840
  ExplicitHeight = 480
  object panTop: TsPanel [0]
    Left = 0
    Top = 0
    Width = 840
    Height = 49
    Align = alTop
    TabOrder = 0
    object labBackupText: TsLabelFX
      Left = 424
      Top = 17
      Width = 135
      Height = 21
      Caption = #1054#1089#1090#1072#1085#1085#1110#1081' '#1110#1084#1087#1086#1088#1090': ..........'
      Angle = 0
      Shadow.OffsetKeeper.LeftTop = -3
      Shadow.OffsetKeeper.RightBottom = 5
    end
    object btnImport: TButton
      Left = 3
      Top = 6
      Width = 161
      Height = 38
      Caption = #1045#1082#1089#1087#1086#1088#1090' Exls '#1074' '#1041#1072#1079#1091' '#1044#1072#1085#1080#1093
      Enabled = False
      TabOrder = 0
    end
    object chkListBox: TsCheckListBox
      Left = 170
      Top = 6
      Width = 239
      Height = 38
      BorderStyle = bsSingle
      Enabled = False
      Items.Strings = (
        #1050#1086#1085#1074#1077#1088#1090#1072#1094#1110#1103' xlsx '#1074' csv'
        #1045#1082#1089#1087#1086#1088#1090' '#1076#1072#1085#1080#1093' '#1091' '#1090#1072#1073#1083#1080#1094#1102' '#1085#1072' '#1093#1086#1089#1090#1080#1085#1075#1091)
      TabOrder = 1
    end
  end
  object panAll: TsPanel [1]
    Left = 0
    Top = 49
    Width = 840
    Height = 431
    Align = alClient
    TabOrder = 1
    object DBGridEh1: TDBGridEh
      Left = 1
      Top = 1
      Width = 838
      Height = 429
      Align = alClient
      DataSource = DM.dsClients
      DynProps = <>
      TabOrder = 0
      Columns = <
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = 'JDC ID'
          Footers = <>
          Width = 74
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = #1060#1048#1054
          Footers = <>
          Width = 204
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = #1042#1086#1079#1088#1072#1089#1090
          Footers = <>
          Width = 38
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = #1058#1080#1087' '#1082#1083#1080#1077#1085#1090#1072' ('#1076#1083#1103' '#1087#1086#1080#1089#1082#1072')'
          Footers = <>
          Width = 172
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = #1044#1072#1090#1072' '#1088#1086#1078#1076#1077#1085#1080#1103
          Footers = <>
          Width = 61
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = #1044#1072#1090#1072' '#1089#1084#1077#1088#1090#1080
          Footers = <>
          Width = 61
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = #1057' '#1082#1077#1084' '#1087#1088#1086#1078#1080#1074#1072#1077#1090
          Footers = <>
          Width = 156
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = #1046#1053
          Footers = <>
          Width = 55
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = #1045#1074#1088#1077#1081#1089#1082#1086#1077' '#1087#1088#1086#1080#1089#1093#1086#1078#1076#1077#1085#1080#1077
          Footers = <>
          Width = 86
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = #1050#1091#1088#1072#1090#1086#1088
          Footers = <>
          Width = 205
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = #1054#1088#1075#1072#1085#1080#1079#1072#1094#1080#1080' '#1091#1095#1072#1089#1090#1085#1080#1082#1072
          Footers = <>
          Width = 167
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = #1057#1088'. '#1076#1086#1093#1086#1076' '#1076#1083#1103' '#1052#1055' ('#1061#1077#1089#1077#1076')'
          Footers = <>
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = #1052#1077#1089#1090#1086#1087#1086#1083#1086#1078#1077#1085#1080#1077
          Footers = <>
          Width = 170
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = #1057#1088'. '#1076#1086#1093#1086#1076' '#1076#1083#1103' '#1052#1055' ('#1076#1077#1090#1089#1082#1080#1077' '#1087#1088#1086#1075#1088#1072#1084#1084#1099')'
          Footers = <>
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = #1052#1086#1073#1080#1083#1100#1085#1099#1081' '#1090#1077#1083#1077#1092#1086#1085
          Footers = <>
          Width = 111
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = #1055#1077#1085#1089#1080#1103
          Footers = <>
          Width = 61
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = #1050#1086#1076' '#1086#1088#1075#1072#1085#1080#1079#1072#1094#1080#1080' JDC'
          Footers = <>
          Width = 37
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = #1040#1076#1088#1077#1089' '#1073#1077#1079' '#1075#1086#1088#1086#1076#1072
          Footers = <>
          Width = 277
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = #1053#1077' '#1084#1086#1078#1077#1090' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100#1089#1103' '#1082#1072#1088#1090#1086#1081
          Footers = <>
          Width = 78
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = #1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1099#1077' '#1087#1072#1088#1072#1084#1077#1090#1088#1099
          Footers = <>
          Width = 1523
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = #1053#1077' '#1088#1072#1089#1087#1080#1089#1099#1074#1072#1077#1090#1089#1103
          Footers = <>
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = #1042#1055#1051' 2014'
          Footers = <>
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = #1054#1073#1083#1072#1089#1090#1100
          Footers = <>
          Width = 90
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = #1056#1072#1081#1086#1085' '#1075#1086#1088#1086#1076#1072
          Footers = <>
          Width = 124
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = #1043#1086#1088#1086#1076' '#1087#1088#1086#1078#1080#1074#1072#1085#1080#1103
          Footers = <>
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = #1043#1086#1088#1086#1076
          Footers = <>
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = 'BIE'
          Footers = <>
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = 'INN'
          Footers = <>
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = #1041#1046#1053
          Footers = <>
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = #1048#1085#1074#1072#1083#1080#1076#1085#1086#1089#1090#1100
          Footers = <>
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = #1055#1086#1083
          Footers = <>
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = #1055#1088#1080#1095#1080#1085#1072' '#1086#1090#1089#1091#1090#1089#1090#1074#1080#1103' '#1076#1072#1085#1085#1099#1093' '#1086' '#1076#1086#1093#1086#1076#1077
          Footers = <>
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = #1044#1086#1093#1086#1076' '#1085#1077' '#1087#1088#1077#1076#1086#1089#1090#1072#1074#1083#1077#1085
          Footers = <>
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = #1044#1072#1090#1072' '#1085#1072#1095#1072#1083#1072' '#1076#1077#1081#1089#1090#1074#1080#1103
          Footers = <>
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = #1041#1077#1078#1077#1085#1077#1094'/'#1042#1055#1051
          Footers = <>
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = #1055#1086#1083#1091#1095#1072#1077#1090' '#1087#1072#1090#1088#1086#1085#1072#1078
          Footers = <>
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = #1058#1080#1087' '#1091#1095#1072#1089#1090#1085#1080#1082#1072
          Footers = <>
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = #1050#1086#1086#1088#1076#1080#1085#1072#1090#1086#1088' '#1087#1072#1090#1088#1086#1085#1072#1078#1072
          Footers = <>
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = #1044#1086#1084#1072#1096#1085#1080#1081' '#1090#1077#1083#1077#1092#1086#1085
          Footers = <>
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = #1054#1089#1085#1086#1074#1085#1072#1103' '#1086#1088#1075#1072#1085#1080#1079#1072#1094#1080#1103
          Footers = <>
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = #1048#1076#1077#1085#1090#1080#1092#1080#1082#1072#1094#1080#1086#1085#1085#1072#1103' '#1082#1072#1088#1090#1072
          Footers = <>
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = #1048#1084#1077#1077#1090#1089#1103' '#1076#1077#1081#1089#1090#1074#1091#1102#1097#1072#1103' '#1073#1072#1085#1082#1086#1074#1089#1082#1072#1103' '#1082#1072#1088#1090#1072
          Footers = <>
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = #1057#1088#1077#1076#1085#1080#1081' '#1076#1086#1093#1086#1076' ('#1095#1083#1077#1085' '#1086#1073#1097#1080#1085#1099')'
          Footers = <>
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = #1040#1076#1088#1077#1089
          Footers = <>
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = #1040#1076#1088#1077#1089' '#1087#1088#1086#1078#1080#1074#1072#1085#1080#1103' '#1089#1086#1074#1087#1072#1076#1072#1077#1090' '#1089' '#1072#1076#1088#1077#1089#1086#1084' '#1087#1088#1086#1087#1080#1089#1082#1080
          Footers = <>
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = #1055#1086#1083#1091#1095#1072#1077#1090' '#1084#1072#1090#1077#1088#1080#1072#1083#1100#1085#1091#1102' '#1087#1086#1076#1076#1077#1088#1078#1082#1091
          Footers = <>
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = #1057#1084#1072#1088#1090#1092#1086#1085'/'#1076#1077#1074#1072#1081#1089
          Footers = <>
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = #1055#1088#1086#1077#1082#1090#1099' Jointech'
          Footers = <>
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = #1056#1072#1089#1095#1077#1090#1085#1086#1077' '#1082#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1095#1072#1089#1086#1074
          Footers = <>
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = #1044#1072#1090#1072' '#1086#1082#1086#1085#1095#1072#1085#1080#1103' '#1080#1085#1074#1072#1083#1080#1076#1085#1086#1089#1090#1080
          Footers = <>
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = #1057#1090#1077#1087#1077#1085#1100' '#1087#1086#1076#1074#1080#1078#1085#1086#1089#1090#1080
          Footers = <>
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = #1055#1088#1072#1074#1086' '#1085#1072' '#1087#1086#1083#1091#1095#1077#1085#1080#1077' '#1089#1091#1073#1089#1080#1076#1080#1080' '#1085#1072' '#1083#1077#1082#1072#1088#1089#1090#1074#1072
          Footers = <>
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = #1060#1048#1054'/'#1060#1072#1084#1080#1083#1080#1103' '#1085#1072' '#1085#1072#1094#1080#1086#1085#1072#1083#1100#1085#1086#1084' '#1103#1079#1099#1082#1077
          Footers = <>
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = #1048#1084#1103' '#1086#1090#1095#1077#1089#1090#1074#1086' '#1085#1072' '#1085#1072#1094#1080#1086#1085#1072#1083#1100#1085#1086#1084' '#1103#1079#1099#1082#1077
          Footers = <>
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = #1059#1095#1072#1089#1090#1085#1080#1082' '#1042#1054#1042' ('#1087#1088#1080#1088#1072#1074#1085#1077#1085#1085#1099#1081')'
          Footers = <>
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = #1059#1095#1072#1089#1090#1085#1080#1082' '#1073#1086#1077#1074#1099#1093' '#1076#1077#1081#1089#1090#1074#1080#1081
          Footers = <>
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = #1054#1073#1097#1080#1077' '#1087#1088#1080#1084#1077#1095#1072#1085#1080#1103
          Footers = <>
        end>
      object RowDetailData: TRowDetailPanelControlEh
      end
    end
  end
  inherited sFrameAdapter1: TsFrameAdapter
    Top = 88
  end
end
