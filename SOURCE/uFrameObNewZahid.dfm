inherited frmObNewZahid: TfrmObNewZahid
  Width = 946
  Height = 501
  ParentFont = False
  ExplicitWidth = 946
  ExplicitHeight = 501
  object panCenter: TsPanel [0]
    Left = 0
    Top = 41
    Width = 946
    Height = 419
    Align = alClient
    TabOrder = 0
    object sSplitter1: TsSplitter
      Left = 313
      Top = 1
      Width = 9
      Height = 417
      OnCanResize = sSplitter1CanResize
      ExplicitLeft = 318
      ExplicitTop = 2
      ExplicitHeight = 415
    end
    object panLeft: TsPanel
      Left = 1
      Top = 1
      Width = 312
      Height = 417
      Align = alLeft
      TabOrder = 0
      object DBGridEh1: TDBGridEh
        Left = 1
        Top = 1
        Width = 310
        Height = 415
        Align = alClient
        AutoFitColWidths = True
        DataSource = DM.dsFindClients
        DynProps = <>
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnMouseDown = DBGridEh1MouseDown
        Columns = <
          item
            CellButtons = <>
            DynProps = <>
            EditButtons = <>
            FieldName = #1060#1048#1054
            Footers = <>
            Width = 300
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
    end
    object sPanel2: TsPanel
      Left = 322
      Top = 1
      Width = 623
      Height = 417
      Align = alClient
      TabOrder = 1
      object panRight: TsPanel
        Left = 274
        Top = 1
        Width = 348
        Height = 415
        Align = alRight
        TabOrder = 0
        object Label1: TLabel
          Left = 125
          Top = 0
          Width = 113
          Height = 19
          Caption = #1042#1110#1076#1087#1086#1074#1110#1076#1072#1083#1100#1085#1080#1081
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object Label2: TLabel
          Left = 131
          Top = 155
          Width = 95
          Height = 19
          Caption = #1053#1072#1079#1074#1072' '#1082#1083#1091#1073#1091':'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object Label3: TLabel
          Left = 24
          Top = 215
          Width = 221
          Height = 38
          Caption = #1050#1110#1083#1100#1082#1110#1089#1090#1100' '#1079#1072#1087#1088#1086#1096#1077#1085#1080#1093' '#1083#1102#1076#1077#1081', '#1103#1082#1080#1093' '#1085#1077#1084#1072' '#1091' '#1089#1087#1080#1089#1082#1091' '#1082#1083#1110#1108#1085#1090#1110#1074
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          WordWrap = True
        end
        object dblbBoss: TDBLookupComboboxEh
          Left = 16
          Top = 24
          Width = 329
          Height = 27
          DynProps = <>
          DataField = ''
          EmptyDataInfo.Text = #1061#1090#1086' '#1087#1088#1086#1074#1086#1076#1080#1074', '#1074#1110#1076#1087#1086#1074#1110#1076#1072#1083#1100#1085#1080#1081' '#1079#1072' '#1079#1072#1093#1110#1076
          EditButtons = <>
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Tahoma'
          Font.Style = []
          KeyField = 'JDC ID'
          ListField = #1060#1048#1054
          ListSource = DM.dsClients
          ParentFont = False
          Style = csDropDownEh
          TabOrder = 0
          Visible = True
        end
        object dblbClubs: TDBLookupComboboxEh
          Left = 16
          Top = 178
          Width = 329
          Height = 27
          DynProps = <>
          DataField = ''
          EmptyDataInfo.Text = #1053#1072#1079#1074#1072' '#1082#1083#1091#1073#1091' '#1072#1073#1086' '#1089#1087#1110#1083#1100#1085#1086#1090#1080
          EditButtons = <>
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Tahoma'
          Font.Style = []
          KeyField = #1053#1072#1079#1074#1072
          ListField = #1053#1072#1079#1074#1072
          ListSource = DM.dsClubs
          ParentFont = False
          Style = csDropDownEh
          TabOrder = 1
          Visible = True
        end
        object deZahid: TsDateEdit
          Left = 16
          Top = 70
          Width = 329
          Height = 27
          EditMask = '!99/99/9999;1; '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Tahoma'
          Font.Style = []
          MaxLength = 10
          ParentFont = False
          TabOrder = 2
          Text = '  .  .    '
          BoundLabel.Active = True
          BoundLabel.EnabledAlways = True
          BoundLabel.ParentFont = False
          BoundLabel.Caption = #1044#1072#1090#1072' '#1079#1072#1093#1086#1076#1091
          BoundLabel.Layout = sclTopCenter
        end
        object edNoName: TsEdit
          Left = 256
          Top = 223
          Width = 89
          Height = 27
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
        end
        object edZahid: TsEdit
          Left = 16
          Top = 126
          Width = 329
          Height = 27
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
          BoundLabel.Active = True
          BoundLabel.ParentFont = False
          BoundLabel.Caption = #1058#1077#1084#1072' '#1079#1072#1093#1086#1076#1091
          BoundLabel.Layout = sclTopCenter
        end
        object ProgressBar: TsProgressBar
          Left = 1
          Top = 397
          Width = 346
          Height = 17
          Align = alBottom
          TabOrder = 5
          Visible = False
          ExplicitLeft = 198
          ExplicitTop = 376
          ExplicitWidth = 150
        end
      end
      object sPanel1: TsPanel
        Left = 1
        Top = 1
        Width = 273
        Height = 415
        Align = alClient
        TabOrder = 1
        object lbClients: TsListBox
          AlignWithMargins = True
          Left = 11
          Top = 4
          Width = 258
          Height = 407
          Margins.Left = 10
          Style = lbOwnerDrawFixed
          Align = alClient
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = 'Tahoma'
          Font.Style = []
          ItemHeight = 20
          ParentFont = False
          TabOrder = 0
          OnDragDrop = lbClientsDragDrop
          OnDragOver = lbClientsDragOver
          BoundLabel.ParentFont = False
          BoundLabel.Font.Charset = DEFAULT_CHARSET
          BoundLabel.Font.Color = clWindowText
          BoundLabel.Font.Height = -16
          BoundLabel.Font.Name = 'Tahoma'
          BoundLabel.Font.Style = []
        end
      end
    end
  end
  object panTop: TsPanel [1]
    Left = 0
    Top = 0
    Width = 946
    Height = 41
    Align = alTop
    TabOrder = 1
    object edFindClient: TsEdit
      Left = 13
      Top = 8
      Width = 281
      Height = 27
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      TextHint = #1055#1086#1096#1091#1082' '#1082#1083#1110#1108#1085#1090#1072
      OnChange = edFindClientChange
    end
    object bbtnDel: TsBitBtn
      Left = 582
      Top = 10
      Width = 25
      Height = 25
      Action = acDeleteItem
      Glyph.Data = {
        36040000424D3604000000000000360000002800000010000000100000000100
        2000000000000004000000000000000000000000000000000000000000000000
        0000000000020000000C05031A46110852AB190C76E31D0E89FF1C0E89FF190C
        76E4120852AD06031B4D0000000E000000030000000000000000000000000000
        000301010519130A55A9211593FF2225AEFF2430C2FF2535CBFF2535CCFF2430
        C3FF2225AFFF211594FF140B58B20101051E0000000400000000000000020101
        03151C1270CD2522A6FF2D3DCCFF394BD3FF3445D1FF2939CDFF2839CDFF3344
        D0FF394AD4FF2D3CCDFF2523A8FF1C1270D20101051D00000003000000091912
        5BA72A27AAFF2F41D0FF3541C7FF2726ABFF3137BCFF384AD3FF384BD3FF3137
        BCFF2726ABFF3540C7FF2E40D0FF2927ACFF1A115EB10000000D08061C3D3129
        A2FD2C3CCCFF3842C6FF5F5DBDFFEDEDF8FF8B89CEFF3337B9FF3437B9FF8B89
        CEFFEDEDF8FF5F5DBDFF3741C6FF2B3ACDFF3028A4FF0907204A1E185F9F373B
        BCFF3042D0FF2621A5FFECE7ECFFF5EBE4FFF8F2EEFF9491D1FF9491D1FFF8F1
        EDFFF3E9E2FFECE6EBFF2621A5FF2E3FCFFF343ABEFF201A66B0312A92E03542
        CBFF3446D1FF2C2FB5FF8070ADFFEBDBD3FFF4EAE4FFF7F2EDFFF8F1EDFFF4E9
        E2FFEADAD1FF7F6FACFF2B2EB5FF3144D0FF3040CBFF312A95E53E37AEFA3648
        D0FF374AD3FF3A4ED5FF3234B4FF8A7FB9FFF6ECE7FFF5ECE6FFF4EBE5FFF6EB
        E5FF897DB8FF3233B4FF384BD3FF3547D2FF3446D1FF3E37AEFA453FB4FA4557
        D7FF3B50D5FF4C5FDAFF4343B7FF9189C7FFF7EFE9FFF6EEE9FFF6EFE8FFF7ED
        E8FF9087C5FF4242B7FF495DD8FF394CD4FF3F52D4FF443FB3FA403DA1DC5967
        DAFF5B6EDDFF4F4DBAFF8F89CAFFFBF6F4FFF7F1ECFFEDE1D9FFEDE0D9FFF7F0
        EAFFFAF5F2FF8F89CAFF4E4DB9FF576ADCFF5765D9FF403EA4E12E2D70987C85
        DDFF8798E8FF291D9BFFE5DADEFFF6EEEBFFEDDFDAFF816EA9FF816EA9FFEDDF
        D8FFF4ECE7FFE5D9DCFF291D9BFF8494E7FF7A81DDFF33317BAC111125356768
        D0FC9EACEDFF686FCEFF5646A1FFCCB6BCFF7A68A8FF4C4AB6FF4D4BB7FF7A68
        A8FFCBB5BCFF5646A1FF666DCCFF9BAAEEFF696CD0FD1212273F000000043B3B
        79977D84DFFFA5B6F1FF6D74D0FF2D219BFF5151B9FF8EA2ECFF8EA1ECFF5252
        BBFF2D219BFF6B72D0FFA2B3F0FF8086E0FF404183A700000008000000010303
        050C4E509DBC8087E2FFAEBDF3FFA3B6F1FF9DAFF0FF95A9EEFF95A8EEFF9BAD
        EFFFA2B3F0FFACBCF3FF838AE3FF4F52A0C10303051100000002000000000000
        000100000005323464797378D9F8929CEAFFA1AEEFFFB0BFF3FFB0BFF4FFA2AE
        EFFF939DE9FF7479DAF83234647D000000080000000200000000000000000000
        000000000000000000031213232D40437D935D61B5D07378DFFC7378DFFC5D61
        B5D040437D951212223000000004000000010000000000000000}
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
    end
    object sRadioGroup1: TsRadioGroup
      Left = 325
      Top = -6
      Width = 251
      Height = 41
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      CaptionLayout = clTopCenter
      Columns = 3
      Items.Strings = (
        #1059#1089#1110
        #1050#1083#1110#1108#1085#1090#1080
        #1044#1110#1090#1080)
      OnChange = sRadioGroup1Change
    end
  end
  object panDown: TsPanel [2]
    Left = 0
    Top = 460
    Width = 946
    Height = 41
    Align = alBottom
    TabOrder = 2
    DesignSize = (
      946
      41)
    object labCount: TsWebLabel
      Left = 13
      Top = 16
      Width = 3
      Height = 13
      ParentFont = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      HoverFont.Charset = DEFAULT_CHARSET
      HoverFont.Color = clWindowText
      HoverFont.Height = -11
      HoverFont.Name = 'Tahoma'
      HoverFont.Style = []
    end
    object btnProvesty: TButton
      Left = 784
      Top = 6
      Width = 153
      Height = 25
      Action = acProvesty
      Anchors = [akRight, akBottom]
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object btnSaveExcel: TsButton
      Left = 325
      Top = 6
      Width = 436
      Height = 25
      Action = acSaveExcel
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
  end
  inherited sFrameAdapter1: TsFrameAdapter
    Left = 24
    Top = 464
  end
  object aclZahid: TActionList
    Left = 80
    Top = 465
    object acProvesty: TAction
      Caption = #1055#1088#1086#1074#1077#1089#1090#1080' '#1047#1072#1093#1110#1076
      OnExecute = btnProvestyClick
      OnUpdate = acProvestyUpdate
    end
    object acDeleteItem: TAction
      OnExecute = bbtnDelClick
      OnUpdate = acDeleteItemUpdate
    end
    object acSaveExcel: TAction
      AutoCheck = True
      Caption = #1047#1073#1077#1088#1077#1075#1090#1080' '#1089#1087#1080#1089#1086#1082' '#1074' Excel'
      OnExecute = btnSaveExcelClick
      OnUpdate = acSaveExcelUpdate
    end
  end
  object SaveDialog1: TSaveDialog
    Left = 408
    Top = 24
  end
end
