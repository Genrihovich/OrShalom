inherited frmAdmDohod: TfrmAdmDohod
  Width = 1119
  Height = 540
  ExplicitWidth = 1119
  ExplicitHeight = 540
  object sPanel1: TsPanel [0]
    Left = 0
    Top = 41
    Width = 265
    Height = 499
    Align = alLeft
    TabOrder = 0
    ExplicitHeight = 498
    object ssLvFiles: TsShellListView
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 257
      Height = 443
      Align = alClient
      ReadOnly = False
      GridLines = True
      Sorted = True
      HideSelection = False
      TabOrder = 0
      ViewStyle = vsList
      ObjectTypes = [otNonFolders]
      Root = 'rfMyComputer'
      ShowExt = seSystem
      ExplicitHeight = 442
    end
    object btnStart: TsBitBtn
      Left = 1
      Top = 450
      Width = 263
      Height = 48
      Action = acBtnStart
      Align = alBottom
      Caption = #1057#1090#1072#1088#1090
      TabOrder = 1
      ExplicitTop = 449
    end
  end
  object spTop: TsPanel [1]
    Left = 0
    Top = 0
    Width = 1119
    Height = 41
    Align = alTop
    TabOrder = 1
    ExplicitWidth = 1007
    DesignSize = (
      1119
      41)
    object sDirEdit: TsDirectoryEdit
      Left = 4
      Top = 6
      Width = 237
      Height = 21
      MaxLength = 255
      TabOrder = 0
      Text = ''
      OnChange = sDirEditChange
      CheckOnExit = True
      BoundLabel.Active = True
      BoundLabel.Caption = #1064#1083#1103#1093' '#1076#1086' '#1087#1072#1087#1082#1080' '#1079#1110' '#1089#1082#1072#1085#1072#1084#1080
      BoundLabel.Layout = sclBottomCenter
      Root = 'rfDesktop'
    end
    object sFnEdit: TsFilenameEdit
      Left = 274
      Top = 6
      Width = 249
      Height = 21
      MaxLength = 255
      TabOrder = 1
      Text = ''
      OnChange = sFnEditChange
      CheckOnExit = True
      BoundLabel.Active = True
      BoundLabel.Caption = #1064#1083#1103#1093' '#1076#1086' '#1089#1082#1088#1080#1087#1090#1072' '#1085#1072' '#1087#1072#1081#1090#1086#1085
      BoundLabel.Layout = sclBottomCenter
    end
    object btnParse: TsBitBtn
      Left = 660
      Top = 10
      Width = 77
      Height = 25
      Action = acReParse
      Caption = #1055#1077#1088#1077#1087#1072#1088#1089#1080#1090#1080
      TabOrder = 2
    end
    object btnSearch: TsBitBtn
      Left = 571
      Top = 10
      Width = 75
      Height = 25
      Action = acReSearch
      Caption = #1055#1077#1088#1077#1087#1086#1096#1091#1082
      TabOrder = 3
    end
    object btnExportExcel: TsBitBtn
      Left = 975
      Top = 10
      Width = 113
      Height = 25
      Action = acExportExcel
      Anchors = [akTop, akRight]
      Caption = #1045#1082#1089#1087#1086#1088#1090' '#1074' Excel'
      TabOrder = 4
    end
    object btnRefresh: TsBitBtn
      Left = 243
      Top = 6
      Width = 25
      Height = 25
      Glyph.Data = {
        36040000424D3604000000000000360000002800000010000000100000000100
        2000000000000004000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        00000000000000000000000000030000000B00000013000000190000001A0000
        00140000000B0000000300000000000000000000000000000000000000000000
        000000000000000000060402011C4827118B7C431ED2A65927FFA55927FF7E44
        1ED442230F7B0100000F0000000E000000070000000000000000000000000000
        000000000005120A05348A4F26DDC58A53FFDCB37CFFEFD298FFEFD198FFB676
        43FF2E1A0C62100904398F5127E10E05013A0000000600000000000000000000
        0002040201198D552BDCD1A169FFF1D6A5FFCE9E6EFFC08656FFBD8251FF613A
        1DA6000000227D4B26CBE2B97BFF5F290FCF0101001900000003000000000000
        00074C2F1B82C99765FFECD2A3FFB98154FB5238238A120C07300F0A06270201
        01194C2F1B88CE9D66FFF6DC9BFFBA8657FF3F1C0C910000000D000000000000
        000A8C5B36D0E3C598FFCB9D75FF573B258C0000000C00000003000000062014
        0C43BD875AFBF8E5BCFFF8DFA5FFF7E4BAFFA16540FC1C0E074C000000080000
        0014B37A4BFAF5E6BDFFBC8356FF0D0704300000000C00000003000000079666
        3FD5B87D4DFFBB8153FFF2D9A1FFB87D4DFFB87C4DFF9C6941DE845331D3A263
        3BFFBB8557FFF6E7BFFFBF8B5EFFA06238FF87522FDC00000006000000020000
        000B0D08042FA1653CFFF4DEAEFFB68155FA000000180000000A1F170F34C79D
        75FBFBF5DCFFFCF3CCFFFAF4DAFFB3855FFB21150C4100000004000000020000
        0009492C1886BA8B5EFFE7CEA7FF926B48CB0000000900000000000000045540
        2D77DDC1A2FFFDF7D9FFD4B598FF5037227F0202010C0D08041F110A05274B2D
        1986A1683EFAF3E4C3FFD8B692FF533F2C780000000400000000000000000000
        00058F6F50BCEFE1CDFF886343C20202010D58382091A3693CFFA66F43FFBE94
        6DFFF4E9D1FFE3CAADFFA47E5BD60504030E0000000100000000000000000000
        0001130F0B1DAB8863DA18130E242C1E1248B78B63FDF8F3E2FFF9F3E4FFEDDE
        C7FFDCC1A1FFA3815ED215110C22000000020000000000000000000000000000
        000000000001000000010101000342301E629A7B5CC2C6A078F9C6A078F9997B
        5DC3564634710504030A00000001000000000000000000000000000000000000
        0000000000000000000000000000000000010000000200000002000000020000
        0002000000010000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000}
      TabOrder = 5
      OnClick = btnRefreshClick
    end
    object chbAuto: TsCheckBox
      Left = 747
      Top = 16
      Width = 94
      Height = 15
      Hint = #1040#1074#1090#1086#1084#1072#1090#1080#1095#1085#1086' '#1086#1073#1088#1086#1073#1083#1103#1090#1080
      Caption = #1040#1074#1090#1086#1084#1072#1090#1080#1095#1085#1086
      ParentShowHint = False
      ShowHint = True
      TabOrder = 6
    end
    object sdeStart: TsDateEdit
      Left = 862
      Top = 14
      Width = 96
      Height = 21
      Anchors = [akTop, akRight]
      EditMask = '!99/99/9999;1; '
      MaxLength = 10
      TabOrder = 7
      Text = '19.10.2026'
      OnChange = sdeStartChange
      BoundLabel.Active = True
      BoundLabel.Caption = #1044#1072#1090#1072' '#1079#1072#1085#1077#1089#1077#1085#1085#1103' '#1076#1086#1093#1086#1076#1110#1074
      BoundLabel.Layout = sclTopCenter
      Date = 46314.000000000000000000
    end
  end
  object spAll: TsPanel [2]
    Left = 552
    Top = 41
    Width = 567
    Height = 499
    Align = alClient
    TabOrder = 2
    ExplicitWidth = 455
    ExplicitHeight = 498
    DesignSize = (
      567
      499)
    object spJSON: TsPanel
      Left = 1
      Top = 1
      Width = 565
      Height = 232
      Align = alTop
      TabOrder = 0
      ExplicitLeft = 6
      ExplicitTop = 0
      ExplicitWidth = 453
      DesignSize = (
        565
        232)
      object lblTotalAll: TsLabel
        Left = 215
        Top = 182
        Width = 45
        Height = 13
        Anchors = [akTop, akRight]
        Caption = 'lblTotalAll'
      end
      object lblTotalDone: TsLabel
        Left = 399
        Top = 182
        Width = 59
        Height = 13
        Anchors = [akTop, akRight]
        Caption = 'lblTotalDone'
      end
      object lblTotalLeft: TsLabel
        Left = 231
        Top = 205
        Width = 53
        Height = 13
        Anchors = [akTop, akRight]
        Caption = 'lblTotalLeft'
        Color = clRed
        ParentColor = False
        ParentFont = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
      end
      object btnOk: TsBitBtn
        Left = 10
        Top = 194
        Width = 193
        Height = 34
        Action = acOk
        Caption = #1044#1072#1085#1110' '#1074#1110#1088#1085#1110
        TabOrder = 0
      end
      object sedJDCID: TsEdit
        Left = 8
        Top = 88
        Width = 201
        Height = 21
        TabOrder = 1
        BoundLabel.Active = True
        BoundLabel.Caption = 'JDCID'
        BoundLabel.Layout = sclTopCenter
      end
      object cbTypeDohod: TsComboBox
        Left = 8
        Top = 129
        Width = 201
        Height = 21
        BoundLabel.Active = True
        BoundLabel.Caption = #1058#1080#1087' '#1076#1086#1093#1086#1076#1091
        BoundLabel.Layout = sclTopCenter
        ItemIndex = -1
        TabOrder = 2
        Items.Strings = (
          #1055#1077#1085#1089#1080#1103
          #1047#1072#1088#1072#1073#1086#1090#1085#1072#1103' '#1087#1083#1072#1090#1072
          #1055#1086#1089#1086#1073#1080#1077
          #1044#1086#1093#1086#1076' '#1086#1090' '#1095#1072#1089#1090#1085#1086#1075#1086' '#1073#1080#1079#1085#1077#1089#1072
          #1040#1083#1080#1084#1077#1085#1090#1099
          #1055#1086#1084#1086#1097#1100' '#1080#1079' '#1076#1088#1091#1075#1080#1093' '#1080#1089#1090#1086#1095#1085#1080#1082#1086#1074)
      end
      object sedFindFIO: TsEdit
        Left = 8
        Top = 14
        Width = 201
        Height = 21
        TabOrder = 3
        BoundLabel.Active = True
        BoundLabel.EnabledAlways = True
        BoundLabel.Caption = #1087#1086#1096#1091#1082#1086#1074#1077' '#1060#1048#1054
        BoundLabel.Layout = sclTopCenter
      end
      object cbPIB: TsComboBox
        Left = 8
        Top = 49
        Width = 200
        Height = 21
        BoundLabel.Active = True
        BoundLabel.Caption = #1055'.'#1030'.'#1041'.'
        BoundLabel.Layout = sclTopCenter
        ItemIndex = -1
        TabOrder = 4
        OnChange = cbPIBChange
      end
      object cbCost: TsComboBox
        Left = 8
        Top = 167
        Width = 201
        Height = 21
        BoundLabel.Active = True
        BoundLabel.Caption = #1057#1091#1084#1084#1072
        BoundLabel.Layout = sclTopCenter
        ItemIndex = -1
        TabOrder = 5
      end
      object btnExportDebtors: TBitBtn
        Left = 428
        Top = 201
        Width = 131
        Height = 25
        Anchors = [akTop, akRight]
        Caption = #1061#1090#1086' '#1085#1077' '#1087#1088#1077#1085#1110#1089' '#1089#1087#1088#1072#1074#1082#1080
        TabOrder = 6
        OnClick = btnExportDebtorsClick
      end
    end
    object StrGrDohod: TJvStringGrid
      Left = 1
      Top = 233
      Width = 565
      Height = 265
      Align = alClient
      ColCount = 4
      FixedCols = 0
      RowCount = 2
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
      TabOrder = 1
      Alignment = taLeftJustify
      FixedFont.Charset = DEFAULT_CHARSET
      FixedFont.Color = clWindowText
      FixedFont.Height = -11
      FixedFont.Name = 'Tahoma'
      FixedFont.Style = []
      ExplicitWidth = 453
      ExplicitHeight = 264
    end
    object sDBGrid1: TsDBGrid
      Left = 224
      Top = 6
      Width = 337
      Height = 171
      Anchors = [akTop, akRight]
      Color = 15921906
      DataSource = DM.dsStat
      DrawingStyle = gdsGradient
      GradientEndColor = 13353918
      GradientStartColor = 14539223
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 2
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      Columns = <
        item
          Expanded = False
          FieldName = #1050#1091#1088#1072#1090#1086#1088
          Width = 140
          Visible = True
        end
        item
          Expanded = False
          FieldName = #1042#1089#1100#1086#1075#1086
          Width = 40
          Visible = True
        end
        item
          Expanded = False
          FieldName = #1055#1086#1076#1072#1083#1080
          Width = 40
          Visible = True
        end
        item
          Expanded = False
          FieldName = #1041#1086#1088#1078#1085#1080#1082#1080
          Width = 40
          Visible = True
        end
        item
          Expanded = False
          FieldName = #1042#1110#1076#1089#1086#1090#1086#1082
          Width = 40
          Visible = True
        end>
    end
  end
  object memJSON: TsMemo [3]
    Left = 265
    Top = 41
    Width = 287
    Height = 499
    Align = alLeft
    ScrollBars = ssVertical
    TabOrder = 3
    ExplicitHeight = 498
  end
  inherited sFrameAdapter1: TsFrameAdapter
    Left = 976
    Top = 728
  end
  object ActionList: TActionList
    Left = 40
    Top = 248
    object acBtnStart: TAction
      Caption = #1057#1090#1072#1088#1090
      OnExecute = btnStartClick
      OnUpdate = acBtnStartUpdate
    end
    object acOk: TAction
      Caption = #1044#1072#1085#1110' '#1074#1110#1088#1085#1110
      OnExecute = btnOkClick
      OnUpdate = acOkUpdate
    end
    object acReParse: TAction
      Caption = #1055#1077#1088#1077#1087#1072#1088#1089#1080#1090#1080
      OnExecute = btnParseClick
      OnUpdate = acReParseUpdate
    end
    object acReSearch: TAction
      Caption = #1055#1077#1088#1077#1087#1086#1096#1091#1082
      OnExecute = btnSearchClick
      OnUpdate = acReSearchUpdate
    end
    object acExportExcel: TAction
      Caption = #1045#1082#1089#1087#1086#1088#1090' '#1074' Excel'
      OnExecute = btnExportExcelClick
      OnUpdate = acExportExcelUpdate
    end
  end
end
