object frmMenu: TfrmMenu
  Left = 0
  Top = 0
  Width = 221
  Height = 127
  TabOrder = 0
  object btnVidomist: TsBitBtn
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 215
    Height = 25
    Align = alTop
    Caption = #1044#1086#1074#1110#1076#1085#1080#1082#1080
    Default = True
    ModalResult = 1
    TabOrder = 0
    OnClick = btnVidomistClick
  end
  object btnSLG: TsBitBtn
    AlignWithMargins = True
    Left = 3
    Top = 34
    Width = 215
    Height = 25
    Align = alTop
    Caption = #1042#1085#1077#1089#1090#1080' '#1082#1086#1085#1090#1072#1082#1090
    TabOrder = 1
    OnClick = btnSLGClick
  end
  object btnNalogy: TsBitBtn
    AlignWithMargins = True
    Left = 3
    Top = 65
    Width = 215
    Height = 25
    Align = alTop
    Caption = #1057#1090#1072#1090#1080#1089#1090#1080#1082#1072
    TabOrder = 2
    OnClick = btnNalogyClick
  end
  object btnChart: TsBitBtn
    AlignWithMargins = True
    Left = 3
    Top = 96
    Width = 215
    Height = 25
    Align = alTop
    Caption = #1043#1088#1072#1092#1110#1082#1080
    TabOrder = 3
    OnClick = btnChartClick
  end
  object sFrameAdapter1: TsFrameAdapter
    Left = 160
    Top = 40
  end
end
