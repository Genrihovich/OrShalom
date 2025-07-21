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
    ExplicitWidth = 618
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
    ExplicitWidth = 618
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
          FieldName = 'jdc_id'
          Footers = <>
          Width = 75
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = 'fio'
          Footers = <>
          Width = 200
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = 'vozrast'
          Footers = <>
          Width = 30
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = 'tip_klienta'
          Footers = <>
          Width = 89
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = 'data_rozhdeniya'
          Footers = <>
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = 'data_smerti'
          Footers = <>
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = 's_kem_prozhivaet'
          Footers = <>
          Width = 163
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = 'zhn'
          Footers = <>
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = 'evreyskoe_proiskhozhdenie'
          Footers = <>
          Width = 94
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = 'kurator'
          Footers = <>
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = 'organizatsii_uchastnika'
          Footers = <>
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = 'sr_dokhod_mp_khesed'
          Footers = <>
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = 'mestopolozhenie'
          Footers = <>
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = 'sr_dokhod_mp_det_deti'
          Footers = <>
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = 'mobile_phone'
          Footers = <>
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = 'pensiya'
          Footers = <>
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = 'kod_organizatsii_jdc'
          Footers = <>
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = 'adres_bez_goroda'
          Footers = <>
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = 'ne_mozhet_kartoy'
          Footers = <>
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = 'dop_parametry'
          Footers = <>
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = 'ne_raspisyvaetsya'
          Footers = <>
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = 'vpl_2014'
          Footers = <>
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = 'oblast'
          Footers = <>
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = 'rayon_goroda'
          Footers = <>
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = 'gorod_prozhivaniya'
          Footers = <>
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = 'gorod'
          Footers = <>
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = 'bie'
          Footers = <>
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = 'inn'
          Footers = <>
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = 'bzh'
          Footers = <>
          Width = 67
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = 'invalidnost'
          Footers = <>
          Width = 118
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = 'pol'
          Footers = <>
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = 'prichina_net_dokhoda'
          Footers = <>
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = 'dokhod_ne_predostavlen'
          Footers = <>
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = 'data_nachala'
          Footers = <>
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = 'bezhenets_vpl'
          Footers = <>
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = 'poluchaet_patronazh'
          Footers = <>
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = 'tip_uchastnika'
          Footers = <>
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = 'koordinator_patronazha'
          Footers = <>
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = 'domashniy_telefon'
          Footers = <>
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = 'osnovnaya_organizatsiya'
          Footers = <>
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = 'id_karta'
          Footers = <>
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = 'imeetsya_bank_karta'
          Footers = <>
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = 'srd_dokhod_chlen'
          Footers = <>
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = 'adres'
          Footers = <>
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = 'adres_sovpadaet'
          Footers = <>
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = 'poluchaet_mat_podderzhku'
          Footers = <>
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = 'smartfon'
          Footers = <>
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = 'projekty_jointech'
          Footers = <>
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = 'raschetnoe_kol_vo_chasov'
          Footers = <>
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = 'data_okonchaniya_invalidnosti'
          Footers = <>
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = 'stepen_podvizhnosti'
          Footers = <>
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = 'pravo_na_lik_subsidiyu'
          Footers = <>
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = 'fio_nats'
          Footers = <>
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = 'imya_otchestvo_nats'
          Footers = <>
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = 'uchastnik_vov'
          Footers = <>
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = 'uchastnik_boev'
          Footers = <>
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = 'obshchie_zametki'
          Footers = <>
        end>
      object RowDetailData: TRowDetailPanelControlEh
      end
    end
  end
  inherited sFrameAdapter1: TsFrameAdapter
    Left = 560
    Top = 8
  end
end
