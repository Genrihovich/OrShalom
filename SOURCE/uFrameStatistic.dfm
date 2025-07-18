inherited frmStatistic: TfrmStatistic
  Width = 1087
  Height = 505
  ExplicitWidth = 1087
  ExplicitHeight = 505
  object Splitter1: TSplitter [0]
    Left = 0
    Top = 145
    Width = 1087
    Height = 3
    Cursor = crVSplit
    Align = alTop
    ExplicitTop = 225
    ExplicitWidth = 280
  end
  object sPanel1: TsPanel [1]
    Left = 0
    Top = 0
    Width = 1087
    Height = 33
    Align = alTop
    TabOrder = 0
    DesignSize = (
      1087
      33)
    object sLabelFX1: TsLabelFX
      Left = 1
      Top = 5
      Width = 17
      Height = 21
      Caption = #1089':'
      Angle = 0
      Shadow.OffsetKeeper.LeftTop = -3
      Shadow.OffsetKeeper.RightBottom = 5
    end
    object sLabelFX2: TsLabelFX
      Left = 144
      Top = 5
      Width = 24
      Height = 21
      Caption = #1087#1086':'
      Angle = 0
      Shadow.OffsetKeeper.LeftTop = -3
      Shadow.OffsetKeeper.RightBottom = 5
    end
    object sDateEdit3: TsDateEdit
      Left = 22
      Top = 6
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
      Top = 6
      Width = 133
      Height = 21
      EditMask = '!99/99/9999;1; '
      MaxLength = 10
      TabOrder = 1
      Text = '  .  .    '
      OnChange = sDateEdit4Change
    end
    object btnSave: TBitBtn
      Left = 944
      Top = 3
      Width = 131
      Height = 25
      Action = acSaveExcel
      Anchors = [akTop, akRight]
      Caption = #1047#1073#1077#1088#1077#1075#1090#1080' '#1074' Excel'
      TabOrder = 2
    end
    object btnCalck: TBitBtn
      Left = 311
      Top = 3
      Width = 89
      Height = 25
      Action = acCalck
      Caption = #1056#1086#1079#1088#1072#1093#1091#1074#1072#1090#1080
      TabOrder = 3
    end
  end
  object sPanel2: TsPanel [2]
    Left = 0
    Top = 33
    Width = 1087
    Height = 112
    Align = alTop
    TabOrder = 1
    object DBGridEh11: TDBGridEh
      Left = 1
      Top = 1
      Width = 1085
      Height = 110
      Align = alClient
      DataSource = DM.dsCountQuery
      DynProps = <>
      TabOrder = 0
      TitleParams.MultiTitle = True
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
          Width = 120
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = 'Sostoyalsya'
          Footers = <>
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
        end>
      object RowDetailData: TRowDetailPanelControlEh
      end
    end
  end
  object sPanel3: TsPanel [3]
    Left = 0
    Top = 148
    Width = 1087
    Height = 357
    Align = alClient
    TabOrder = 2
    object Splitter2: TSplitter
      Left = 1
      Top = 205
      Width = 1085
      Height = 3
      Cursor = crVSplit
      Align = alBottom
      ExplicitTop = 177
      ExplicitWidth = 139
    end
    object StringGrid: TJvStringGrid
      Left = 1
      Top = 1
      Width = 1085
      Height = 204
      Align = alClient
      ColCount = 4
      DefaultDrawing = False
      FixedCols = 0
      RowCount = 2
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSizing]
      TabOrder = 0
      OnDrawCell = StringGridDrawCell
      Alignment = taLeftJustify
      FixedFont.Charset = DEFAULT_CHARSET
      FixedFont.Color = clWindowText
      FixedFont.Height = -11
      FixedFont.Name = 'Tahoma'
      FixedFont.Style = []
    end
    object strGridTraining: TStringGrid
      Left = 1
      Top = 208
      Width = 1085
      Height = 148
      Align = alBottom
      ColCount = 1
      DefaultDrawing = False
      FixedCols = 0
      RowCount = 1
      FixedRows = 0
      TabOrder = 1
      OnDrawCell = strGridTrainingDrawCell
    end
  end
  inherited sFrameAdapter1: TsFrameAdapter
    Left = 664
    Top = 64
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
