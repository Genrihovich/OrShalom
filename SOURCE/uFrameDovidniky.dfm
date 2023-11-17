inherited frmDovidniky: TfrmDovidniky
  Width = 1063
  Height = 705
  ExplicitWidth = 1063
  ExplicitHeight = 705
  object sGradientPanel1: TsGradientPanel [0]
    Left = 0
    Top = 0
    Width = 1063
    Height = 41
    Align = alTop
    Caption = 'sGradientPanel1'
    ShowCaption = False
    TabOrder = 0
    OnClick = sGradientPanel1Click
    object btnImport: TBitBtn
      Left = 16
      Top = 6
      Width = 137
      Height = 25
      Caption = #1030#1084#1087#1086#1088#1090' '#1092#1072#1081#1083#1091' '#1079' SNOW'
      TabOrder = 0
      OnClick = btnImportClick
    end
    object BitBtn1: TBitBtn
      Left = 168
      Top = 6
      Width = 121
      Height = 25
      Caption = #1054#1095#1080#1089#1090#1080#1090#1080' '#1090#1072#1073#1083#1080#1094#1102
      Enabled = False
      TabOrder = 1
      OnClick = BitBtn1Click
    end
  end
  object sPanel1: TsPanel [1]
    Left = 0
    Top = 41
    Width = 1063
    Height = 664
    Align = alClient
    Caption = #1044#1086#1074#1110#1076#1085#1080#1082#1080
    TabOrder = 1
    object DBGridEh1: TDBGridEh
      Left = 1
      Top = 1
      Width = 1061
      Height = 662
      Align = alClient
      AutoFitColWidths = True
      DataSource = DM.dsZvit
      DynProps = <>
      TabOrder = 0
      Columns = <
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = 'Number'
          Footers = <>
          Width = 80
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = 'JDCID'
          Footers = <>
          Width = 80
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = 'Kontakt'
          Footers = <>
          Width = 200
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = 'DateKontakta'
          Footers = <>
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = 'Tema'
          Footers = <>
          Width = 150
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = 'TypeKontakta'
          Footers = <>
          Width = 100
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = 'Sostoyalsya'
          Footers = <>
          Width = 70
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = 'Ispolnitel'
          Footers = <>
          Width = 150
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = 'Telephone'
          Footers = <>
          Width = 80
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = 'Kurator'
          Footers = <>
          Width = 150
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = 'monthDate'
          Footers = <>
          Width = 50
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = 'YearDate'
          Footers = <>
          Width = 50
        end>
      object RowDetailData: TRowDetailPanelControlEh
      end
    end
  end
  inherited sFrameAdapter1: TsFrameAdapter
    Left = 976
    Top = 0
  end
end
