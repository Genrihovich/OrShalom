object fAutorize: TfAutorize
  Tag = 1
  Left = 0
  Top = 0
  BorderIcons = []
  Caption = #1040#1074#1090#1086#1088#1080#1079#1072#1094#1110#1103
  ClientHeight = 579
  ClientWidth = 281
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object panAutorize: TsPanel
    Left = 0
    Top = 69
    Width = 281
    Height = 122
    Align = alTop
    TabOrder = 0
    object wlabRegister: TsWebLabel
      Left = 167
      Top = 70
      Width = 102
      Height = 13
      Caption = #1047#1072#1088#1077#1108#1089#1090#1088#1091#1074#1072#1090#1080#1089#1103' ...'
      ParentFont = False
      OnClick = wlabRegisterClick
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
    object wlabEditUserData: TsWebLabel
      Left = 185
      Top = 89
      Width = 83
      Height = 13
      Caption = #1047#1084#1110#1085#1080#1090#1080' '#1076#1072#1085#1085#1110' ...'
      ParentFont = False
      OnClick = wlabEditUserDataClick
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
    object btnSignIn: TButton
      Left = 84
      Top = 85
      Width = 95
      Height = 25
      Action = acSignIn
      TabOrder = 0
    end
    object chPsw: TsCheckBox
      Left = 246
      Top = 47
      Width = 18
      Height = 16
      TabOrder = 3
      OnClick = chPswClick
    end
    object dbLComboUser: TDBLookupComboboxEh
      Left = 16
      Top = 6
      Width = 247
      Height = 21
      DynProps = <>
      DataField = ''
      EditButtons = <>
      KeyField = 'Id'
      ListField = 'fullName'
      ListSource = DM.dsUser
      TabOrder = 1
      Visible = True
      OnChange = dbLComboUserChange
    end
    object edPsw: TDBEditEh
      Left = 16
      Top = 44
      Width = 224
      Height = 21
      ControlLabel.Caption = #1053#1077' '#1074#1110#1088#1085#1110' '#1076#1072#1085#1085#1110
      ControlLabel.Font.Charset = DEFAULT_CHARSET
      ControlLabel.Font.Color = clRed
      ControlLabel.Font.Height = -11
      ControlLabel.Font.Name = 'Tahoma'
      ControlLabel.Font.Style = [fsBold]
      ControlLabel.ParentFont = False
      ControlLabelLocation.Position = lpAboveCenterEh
      DynProps = <>
      EditButtons = <>
      PasswordChar = '*'
      TabOrder = 2
      Visible = True
      OnKeyPress = edPswKeyPress
    end
  end
  object panRegister: TsPanel
    Left = 0
    Top = 191
    Width = 281
    Height = 156
    Align = alTop
    TabOrder = 1
    Visible = False
    object btnSave: TButton
      Left = 96
      Top = 128
      Width = 75
      Height = 25
      Action = acSave
      TabOrder = 5
    end
    object edEmail: TEsRegexEdit
      Left = 16
      Top = 72
      Width = 241
      Height = 21
      TabOrder = 2
      Text = 'email'
      Pattern = 
        '^(?!\.)(""([^""\r\\]|\\[""\r\\])*""|([-a-z0-9!#$%&'#39'*+/=?^_`{|}~]' +
        '|(?<!\.)\.)*)(?<!\.)@[a-z0-9][\w\.-]*[a-z0-9]\.[a-z][a-z\.]*[a-z' +
        ']$'
      AllowNeutral = True
      IndicateState = All
    end
    object edPswReg: TDBEditEh
      Left = 16
      Top = 101
      Width = 224
      Height = 21
      ControlLabel.Caption = #1053#1077' '#1074#1110#1088#1085#1110' '#1076#1072#1085#1085#1110
      ControlLabel.Font.Charset = DEFAULT_CHARSET
      ControlLabel.Font.Color = clRed
      ControlLabel.Font.Height = -11
      ControlLabel.Font.Name = 'Tahoma'
      ControlLabel.Font.Style = [fsBold]
      ControlLabel.ParentFont = False
      ControlLabelLocation.Position = lpBelowCenterEh
      DynProps = <>
      EditButtons = <>
      EmptyDataInfo.Text = #1055#1072#1088#1086#1083#1100
      TabOrder = 3
      Visible = True
    end
    object chPswReg: TsCheckBox
      Left = 246
      Top = 103
      Width = 18
      Height = 16
      Checked = True
      State = cbChecked
      TabOrder = 4
      OnClick = chPswRegClick
    end
    object edPIBregister: TDBEditEh
      Left = 16
      Top = 18
      Width = 241
      Height = 21
      ControlLabel.Caption = #1053#1077' '#1074#1110#1088#1085#1110' '#1076#1072#1085#1085#1110
      ControlLabel.Font.Charset = DEFAULT_CHARSET
      ControlLabel.Font.Color = clRed
      ControlLabel.Font.Height = -11
      ControlLabel.Font.Name = 'Tahoma'
      ControlLabel.Font.Style = [fsBold]
      ControlLabel.ParentFont = False
      ControlLabelLocation.Position = lpAboveCenterEh
      DynProps = <>
      EditButtons = <>
      EmptyDataInfo.Text = #1055'.'#1030'.'#1041'.'
      TabOrder = 0
      Visible = True
    end
    object edPosada: TDBEditEh
      Left = 16
      Top = 45
      Width = 241
      Height = 21
      ControlLabel.Caption = #1053#1077' '#1074#1110#1088#1085#1110' '#1076#1072#1085#1085#1110
      ControlLabel.Font.Charset = DEFAULT_CHARSET
      ControlLabel.Font.Color = clRed
      ControlLabel.Font.Height = -11
      ControlLabel.Font.Name = 'Tahoma'
      ControlLabel.Font.Style = [fsBold]
      ControlLabel.ParentFont = False
      ControlLabelLocation.Position = lpAboveCenterEh
      DynProps = <>
      EditButtons = <>
      EmptyDataInfo.Text = #1055#1086#1089#1072#1076#1072
      TabOrder = 1
      Visible = True
    end
  end
  object panBotton: TsPanel
    Left = 0
    Top = 0
    Width = 281
    Height = 69
    Align = alTop
    TabOrder = 2
    object Label1: TLabel
      Left = 16
      Top = 8
      Width = 141
      Height = 13
      Caption = #1047#39#1108#1076#1085#1072#1085#1085#1103' '#1079' '#1041#1072#1079#1086#1102' '#1044#1072#1085#1085#1080#1093' :'
    end
    object lbDBConnected: TLabel
      Left = 174
      Top = 8
      Width = 66
      Height = 13
      Caption = #1053#1077' '#1072#1082#1090#1080#1074#1085#1077
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object spBtnConnectBD: TSpeedButton
      Left = 240
      Top = 4
      Width = 23
      Height = 22
      Action = acConnected
      Flat = True
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
    end
    object DBcbRegion: TDBComboBoxEh
      Left = 16
      Top = 42
      Width = 240
      Height = 21
      DynProps = <>
      EmptyDataInfo.Text = #1042#1080#1073#1077#1088#1080' '#1088#1077#1075#1110#1086#1085
      EditButtons = <
        item
          Style = ebsPlusEh
          OnClick = DBComboBoxEh1EditButtons0Click
        end>
      TabOrder = 0
      Visible = True
      OnChange = DBcbRegionChange
    end
  end
  object BitBtn1: TBitBtn
    Left = 8
    Top = 608
    Width = 25
    Height = 25
    Action = acVisibleComponent
    TabOrder = 3
  end
  object panEditUserData: TsPanel
    Left = 0
    Top = 410
    Width = 281
    Height = 169
    Align = alClient
    TabOrder = 4
    Visible = False
    object dbLEditPIB: TDBEditEh
      Left = 24
      Top = 26
      Width = 241
      Height = 21
      ControlLabel.Caption = #1053#1077' '#1074#1110#1088#1085#1110' '#1076#1072#1085#1085#1110
      ControlLabel.Font.Charset = DEFAULT_CHARSET
      ControlLabel.Font.Color = clRed
      ControlLabel.Font.Height = -11
      ControlLabel.Font.Name = 'Tahoma'
      ControlLabel.Font.Style = [fsBold]
      ControlLabel.ParentFont = False
      ControlLabelLocation.Position = lpAboveCenterEh
      DynProps = <>
      EditButtons = <>
      EmptyDataInfo.Text = #1055'.'#1030'.'#1041'.'
      TabOrder = 0
      Visible = True
    end
    object dbLEditPosada: TDBEditEh
      Left = 24
      Top = 53
      Width = 241
      Height = 21
      ControlLabel.Caption = #1053#1077' '#1074#1110#1088#1085#1110' '#1076#1072#1085#1085#1110
      ControlLabel.Font.Charset = DEFAULT_CHARSET
      ControlLabel.Font.Color = clRed
      ControlLabel.Font.Height = -11
      ControlLabel.Font.Name = 'Tahoma'
      ControlLabel.Font.Style = [fsBold]
      ControlLabel.ParentFont = False
      ControlLabelLocation.Position = lpAboveCenterEh
      DynProps = <>
      EditButtons = <>
      EmptyDataInfo.Text = #1055#1086#1089#1072#1076#1072
      TabOrder = 1
      Visible = True
    end
    object edEmailEdit: TEsRegexEdit
      Left = 24
      Top = 80
      Width = 241
      Height = 21
      TabOrder = 2
      Text = 'email'
      Pattern = 
        '^(?!\.)(""([^""\r\\]|\\[""\r\\])*""|([-a-z0-9!#$%&'#39'*+/=?^_`{|}~]' +
        '|(?<!\.)\.)*)(?<!\.)@[a-z0-9][\w\.-]*[a-z0-9]\.[a-z][a-z\.]*[a-z' +
        ']$'
      AllowNeutral = True
      IndicateState = All
    end
    object edPSWEdit: TDBEditEh
      Left = 24
      Top = 109
      Width = 224
      Height = 21
      ControlLabel.Caption = #1053#1077' '#1074#1110#1088#1085#1110' '#1076#1072#1085#1085#1110
      ControlLabel.Font.Charset = DEFAULT_CHARSET
      ControlLabel.Font.Color = clRed
      ControlLabel.Font.Height = -11
      ControlLabel.Font.Name = 'Tahoma'
      ControlLabel.Font.Style = [fsBold]
      ControlLabel.ParentFont = False
      ControlLabelLocation.Position = lpBelowCenterEh
      DynProps = <>
      EditButtons = <>
      EmptyDataInfo.Text = #1042#1074#1077#1076#1110#1090#1100' '#1085#1086#1074#1080#1081' '#1087#1072#1088#1086#1083#1100
      TabOrder = 3
      Visible = True
    end
    object btnEditUserData: TButton
      Left = 104
      Top = 136
      Width = 75
      Height = 25
      Action = acEditUserData
      TabOrder = 4
    end
  end
  object BitBtn2: TBitBtn
    Left = 39
    Top = 608
    Width = 25
    Height = 25
    Action = acEditData
    Caption = 'acEditData'
    TabOrder = 5
  end
  object panKodDostupa: TsPanel
    Left = 0
    Top = 347
    Width = 281
    Height = 63
    Align = alTop
    TabOrder = 6
    Visible = False
    object sLabel1: TsLabel
      Left = 31
      Top = 6
      Width = 217
      Height = 13
      Caption = #1042#1074#1077#1076#1110#1090#1100' '#1082#1086#1076', '#1103#1082#1080#1081' '#1074#1110#1076#1087#1088#1072#1074#1080#1083#1080' '#1085#1072' '#1042#1072#1096' email'
    end
    object dblcodDostupa: TDBEditEh
      Left = 72
      Top = 34
      Width = 119
      Height = 21
      ControlLabel.Caption = #1053#1077' '#1074#1110#1088#1085#1080#1081' '#1082#1086#1076
      ControlLabel.Font.Charset = DEFAULT_CHARSET
      ControlLabel.Font.Color = clRed
      ControlLabel.Font.Height = -11
      ControlLabel.Font.Name = 'Tahoma'
      ControlLabel.Font.Style = [fsBold]
      ControlLabel.ParentFont = False
      ControlLabelLocation.Position = lpAboveCenterEh
      DynProps = <>
      EditButtons = <>
      EmptyDataInfo.Text = #1050#1086#1076' '#1076#1086#1089#1090#1091#1087#1072' '#1079' email'
      TabOrder = 0
      Visible = True
    end
    object btnDostup: TsBitBtn
      Left = 202
      Top = 32
      Width = 58
      Height = 25
      Action = acDostup
      Caption = 'OK'
      TabOrder = 1
    end
  end
  object ActionList1: TActionList
    Left = 24
    Top = 128
    object acConnected: TAction
      AutoCheck = True
      OnExecute = spBtnConnectBDClick
      OnUpdate = acConnectedUpdate
    end
    object acSignIn: TAction
      Caption = #1042#1093#1110#1076' '#1076#1086' '#1089#1080#1089#1090#1077#1084#1080
      OnExecute = btnSignInClick
      OnUpdate = acSignInUpdate
    end
    object acSave: TAction
      Caption = #1047#1073#1077#1088#1077#1075#1090#1080
      OnExecute = btnSaveClick
      OnUpdate = acSaveUpdate
    end
    object acVisibleComponent: TAction
      AutoCheck = True
      OnUpdate = acVisibleComponentUpdate
    end
    object acEditData: TAction
      Caption = 'acEditData'
      OnUpdate = acEditDataUpdate
    end
    object acDostup: TAction
      Caption = 'OK'
      OnExecute = btnDostupClick
      OnUpdate = acDostupUpdate
    end
    object acEditUserData: TAction
      Caption = #1047#1084#1110#1085#1080#1090#1080
      OnExecute = btnEditUserDataClick
      OnUpdate = acEditUserDataUpdate
    end
  end
  object sTitleBar1: TsTitleBar
    Items = <
      item
        Align = tbaRight
        FontData.Font.Charset = DEFAULT_CHARSET
        FontData.Font.Color = clWindowText
        FontData.Font.Height = -11
        FontData.Font.Name = 'Tahoma'
        FontData.Font.Style = []
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
        AutoSize = False
        StretchImage = True
        Spacing = 0
        Height = 20
        Width = 20
        Index = 0
        Name = 'TacTitleBarItemExit'
        OnClick = sTitleBar1Items0Click
      end
      item
        Align = tbaCenter
        Alignment = taCenter
        Caption = '-='#1040#1074#1090#1086#1088#1110#1079#1072#1094#1110#1103'=-'
        FontData.Font.Charset = DEFAULT_CHARSET
        FontData.Font.Color = clWindowText
        FontData.Font.Height = -11
        FontData.Font.Name = 'Tahoma'
        FontData.Font.Style = []
        Index = 1
        Name = 'TacTitleBarItem'
        Style = bsInfo
      end>
    Top = 1
  end
end
