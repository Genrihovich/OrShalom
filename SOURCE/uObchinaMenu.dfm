object frmObchiaMenu: TfrmObchiaMenu
  Left = 0
  Top = 0
  Width = 221
  Height = 127
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  ParentFont = False
  TabOrder = 0
  object btnVidomist: TsBitBtn
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 215
    Height = 25
    Align = alTop
    Caption = #1045#1082#1089#1087#1086#1088#1090' '#1076#1072#1085#1080#1093
    Default = True
    ModalResult = 1
    TabOrder = 0
    OnClick = btnVidomistClick
  end
  object sBitBtn1: TsBitBtn
    AlignWithMargins = True
    Left = 3
    Top = 34
    Width = 215
    Height = 25
    Align = alTop
    Caption = #1042#1085#1077#1089#1077#1085#1085#1103' '#1086#1073#1097#1080#1085#1085#1080#1093' '#1079#1072#1093#1086#1076#1110#1074
    Default = True
    ModalResult = 1
    TabOrder = 1
    OnClick = sBitBtn1Click
    ExplicitLeft = 6
    ExplicitTop = 11
  end
  object sFrameAdapter1: TsFrameAdapter
    Left = 160
    Top = 40
  end
end
