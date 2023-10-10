inherited frmStatistic: TfrmStatistic
  Width = 1087
  Height = 505
  ExplicitWidth = 1087
  ExplicitHeight = 505
  object Splitter1: TSplitter [0]
    Left = 0
    Top = 225
    Width = 1087
    Height = 3
    Cursor = crVSplit
    Align = alTop
    ExplicitWidth = 280
  end
  object sPanel1: TsPanel [1]
    Left = 0
    Top = 0
    Width = 1087
    Height = 33
    Align = alTop
    TabOrder = 0
    object sLabelFX1: TsLabelFX
      Left = 3
      Top = 7
      Width = 13
      Height = 17
      Caption = #1089':'
      Angle = 0
      Shadow.OffsetKeeper.LeftTop = -1
      Shadow.OffsetKeeper.RightBottom = 3
    end
    object sLabelFX2: TsLabelFX
      Left = 146
      Top = 7
      Width = 20
      Height = 17
      Caption = #1087#1086':'
      Angle = 0
      Shadow.OffsetKeeper.LeftTop = -1
      Shadow.OffsetKeeper.RightBottom = 3
    end
    object Label1: TLabel
      Left = 736
      Top = 8
      Width = 31
      Height = 13
      Caption = 'Label1'
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
    object btnCalck: TBitBtn
      Left = 311
      Top = 3
      Width = 75
      Height = 25
      Action = acCalck
      Caption = #1056#1086#1079#1088#1072#1093#1091#1074#1072#1090#1080
      Enabled = False
      TabOrder = 2
    end
    object BitBtn1: TBitBtn
      Left = 984
      Top = 3
      Width = 75
      Height = 25
      Caption = 'BitBtn1'
      TabOrder = 3
      OnClick = BitBtn1Click
    end
  end
  object sPanel2: TsPanel [2]
    Left = 0
    Top = 33
    Width = 1087
    Height = 192
    Align = alTop
    TabOrder = 1
    object DBGridEh1: TDBGridEh
      Left = 1
      Top = 1
      Width = 1085
      Height = 190
      Align = alClient
      DataSource = DM.dsCountQuery
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
    Top = 228
    Width = 1087
    Height = 277
    Align = alClient
    TabOrder = 2
    object StringGrid: TJvStringGrid
      Left = 1
      Top = 1
      Width = 1085
      Height = 275
      Align = alClient
      ColCount = 4
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
  end
  inherited sFrameAdapter1: TsFrameAdapter
    Left = 656
    Top = 0
  end
  object ActionList1: TActionList
    Left = 864
    Top = 128
    object acCalck: TAction
      Caption = #1056#1086#1079#1088#1072#1093#1091#1074#1072#1090#1080
      OnExecute = btnCalckClick
      OnUpdate = acCalckUpdate
    end
  end
end
