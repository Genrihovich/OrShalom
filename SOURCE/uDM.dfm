object DM: TDM
  OldCreateOrder = False
  Height = 577
  Width = 406
  object UniConnection: TUniConnection
    ProviderName = 'MySQL'
    Port = 3306
    Database = 'hesed_travma'
    Username = 'hesed_travma'
    Server = 'hesed.mysql.ukraine.com.ua'
    Connected = True
    Left = 32
    Top = 16
    EncryptedPassword = 'BEFF86FF8BFFD9FF99FFAFFFC9FFCCFFCDFFDCFF'
  end
  object MySQLUniProvider: TMySQLUniProvider
    Left = 128
    Top = 16
  end
  object tUser: TUniTable
    TableName = 'User'
    Connection = UniConnection
    Left = 16
    Top = 72
  end
  object tRegion: TUniTable
    TableName = 'Region'
    Connection = UniConnection
    Left = 64
    Top = 72
  end
  object dsUser: TUniDataSource
    DataSet = qUser
    Left = 16
    Top = 168
  end
  object dsRegion: TUniDataSource
    DataSet = tRegion
    Left = 64
    Top = 120
  end
  object qInsert: TUniQuery
    SQLRecCount.Strings = (
      'SELECT COUNT(*) FROM Region')
    Connection = UniConnection
    SQL.Strings = (
      'SELECT * FROM Region WHERE nameRegion = '#39#1061#1084#1077#1083#1100#1085#1080#1094#1100#1082#1080#1081#39)
    Left = 216
    Top = 72
  end
  object qUser: TUniQuery
    SQLRecCount.Strings = (
      'SELECT COUNT(*) FROM Region')
    Connection = UniConnection
    SQL.Strings = (
      'SELECT * FROM User WHERE id_region = '#39'1'#39)
    Active = True
    Left = 16
    Top = 120
  end
  object OpenDialog: TOpenDialog
    Left = 208
    Top = 16
  end
  object qQuery: TUniQuery
    SQLRecCount.Strings = (
      'SELECT COUNT(*) FROM Region')
    Connection = UniConnection
    SQL.Strings = (
      'SELECT * FROM Region WHERE nameRegion = '#39#1061#1084#1077#1083#1100#1085#1080#1094#1100#1082#1080#1081#39)
    Left = 168
    Top = 72
  end
  object tZvitSnow: TUniTable
    TableName = 'ZvitSnow'
    Connection = UniConnection
    Active = True
    Left = 112
    Top = 72
    object tZvitSnowNumber: TStringField
      FieldName = 'Number'
      Required = True
    end
    object tZvitSnowJDCID: TStringField
      FieldName = 'JDCID'
      Required = True
    end
    object tZvitSnowKontakt: TStringField
      FieldName = 'Kontakt'
      Required = True
      Size = 250
    end
    object tZvitSnowDateKontakta: TDateField
      FieldName = 'DateKontakta'
      Required = True
    end
    object tZvitSnowTema: TStringField
      FieldName = 'Tema'
      Required = True
      Size = 200
    end
    object tZvitSnowTypeKontakta: TStringField
      FieldName = 'TypeKontakta'
      Required = True
      Size = 150
    end
    object tZvitSnowSostoyalsya: TStringField
      FieldName = 'Sostoyalsya'
      Required = True
      Size = 50
    end
    object tZvitSnowIspolnitel: TStringField
      FieldName = 'Ispolnitel'
      Required = True
      Size = 250
    end
    object tZvitSnowTelephone: TStringField
      FieldName = 'Telephone'
      Required = True
    end
    object tZvitSnowKurator: TStringField
      FieldName = 'Kurator'
      Required = True
      Size = 250
    end
    object tZvitSnowmonthDate: TStringField
      FieldName = 'monthDate'
      Required = True
      Size = 10
    end
    object tZvitSnowYearDate: TStringField
      FieldName = 'YearDate'
      Required = True
      Size = 5
    end
  end
  object dsZvit: TUniDataSource
    DataSet = tZvitSnow
    Left = 112
    Top = 120
  end
  object dsCountQuery: TUniDataSource
    DataSet = qCountQuery
    Left = 144
    Top = 272
  end
  object qCountQuery: TUniQuery
    SQLRecCount.Strings = (
      
        'SELECT COUNT(*) FROM ZvitSnow WHERE DateKontakta Between :ot and' +
        ' :do')
    Connection = UniConnection
    SQL.Strings = (
      'SELECT * FROM ZvitSnow WHERE DateKontakta Between :ot and :do')
    Left = 144
    Top = 224
    ParamData = <
      item
        DataType = ftDateTime
        Name = 'ot'
        Value = 45078d
      end
      item
        DataType = ftDateTime
        Name = 'do'
        Value = 45107d
      end>
  end
  object qCountItems: TUniQuery
    Connection = UniConnection
    SQL.Strings = (
      
        'select Ispolnitel From ZvitSnow WHERE DateKontakta Between :ot a' +
        'nd :do  Group by Ispolnitel')
    MasterSource = dsCountQuery
    Left = 64
    Top = 224
    ParamData = <
      item
        DataType = ftDateTime
        Name = 'ot'
        Value = 45139d
      end
      item
        DataType = ftDateTime
        Name = 'do'
        Value = 45169d
      end>
  end
  object UniDataSource1: TUniDataSource
    DataSet = qCountItems
    Left = 64
    Top = 272
  end
  object qChart: TUniQuery
    Connection = UniConnection
    SQL.Strings = (
      'select monthDate, Ispolnitel, Count(*) as Num'
      'From ZvitSnow '
      'where YearDate = 2023 and Sostoyalsya = '#39#1057#1086#1089#1090#1086#1103#1083#1089#1103#39
      'Group By monthDate, Ispolnitel'
      'Order By monthDate')
    Active = True
    Left = 160
    Top = 120
  end
  object dsChart: TUniDataSource
    DataSet = qChart
    Left = 160
    Top = 176
  end
  object tTraining: TUniTable
    TableName = 'Training'
    Connection = UniConnection
    Left = 272
    Top = 72
  end
  object dsTraining: TUniDataSource
    DataSet = tTraining
    Left = 272
    Top = 128
  end
  object qTraining: TUniQuery
    SQLRecCount.Strings = (
      
        'SELECT COUNT(*) FROM ZvitSnow WHERE DateKontakta Between :ot and' +
        ' :do')
    Connection = UniConnection
    SQL.Strings = (
      'SELECT * FROM ZvitSnow WHERE DateKontakta Between :ot and :do')
    Left = 272
    Top = 176
    ParamData = <
      item
        DataType = ftDateTime
        Name = 'ot'
        Value = 45078d
      end
      item
        DataType = ftDateTime
        Name = 'do'
        Value = 45107d
      end>
  end
  object qClients: TUniQuery
    Connection = UniConnection
    SQL.Strings = (
      'SELECT * FROM `Clients` WHERE `'#1058#1080#1087' '#1082#1083#1080#1077#1085#1090#1072' ('#1076#1083#1103' '#1087#1086#1080#1089#1082#1072')`<> '#39#39';')
    Active = True
    Left = 24
    Top = 344
  end
  object dsClients: TUniDataSource
    DataSet = qClients
    Left = 24
    Top = 400
  end
  object qEvents: TUniQuery
    Connection = UniConnection
    SQL.Strings = (
      'SELECT'
      '  E.`ID`,'
      '  E.`'#1044#1072#1090#1072'`,'
      '  C.`'#1053#1072#1079#1074#1072'` AS `ClubName`, '
      '  E.`'#1053#1072#1079#1074#1072'_'#1079#1072#1093#1086#1076#1091'`,'
      '  CL.`'#1060#1048#1054'` AS `'#1055#1030#1041'_'#1093#1090#1086'_'#1087#1088#1086#1074#1086#1076#1080#1074'`,'
      '  E.`'#1050#1110#1083#1100#1082#1110#1089#1090#1100'_'#1089#1090#1086#1088#1086#1085#1085#1110#1093'`,'
      '  E.`id_region`,'
      '  R.`nameRegion` AS `'#1053#1072#1079#1074#1072'_'#1088#1077#1075#1110#1086#1085#1091'`'
      'FROM `Events` E'
      'LEFT JOIN `Clubs` C ON E.`ClubID` = C.`ID`'
      'LEFT JOIN `Clients` CL ON E.`'#1061#1090#1086'_'#1087#1088#1086#1074#1086#1076#1080#1074'` = CL.`JDC ID`'
      'LEFT JOIN `Region` R ON E.`id_region` = R.`id_region`'
      '/*WHERE E.`id_region` = :RegionID*/'
      'ORDER BY E.`'#1044#1072#1090#1072'` DESC;')
    Active = True
    Left = 80
    Top = 344
  end
  object dsEvents: TUniDataSource
    DataSet = qEvents
    Left = 80
    Top = 400
  end
  object qFindClients: TUniQuery
    Connection = UniConnection
    SQL.Strings = (
      'SELECT * FROM `Clients` WHERE `'#1058#1080#1087' '#1082#1083#1080#1077#1085#1090#1072' ('#1076#1083#1103' '#1087#1086#1080#1089#1082#1072')`<> '#39#39';')
    Active = True
    Left = 136
    Top = 344
  end
  object dsFindClients: TUniDataSource
    DataSet = qFindClients
    Left = 136
    Top = 400
  end
  object qEventBoss: TUniQuery
    Connection = UniConnection
    SQL.Strings = (
      'select * from `Clients`')
    Active = True
    Left = 200
    Top = 344
  end
  object dsEventBoss: TUniDataSource
    DataSet = qEventBoss
    Left = 200
    Top = 400
  end
  object qClubs: TUniQuery
    Connection = UniConnection
    SQL.Strings = (
      'select * from `Clubs`')
    Active = True
    Left = 256
    Top = 344
  end
  object dsClubs: TUniDataSource
    DataSet = qClubs
    Left = 248
    Top = 400
  end
  object qRegions: TUniQuery
    Connection = UniConnection
    SQL.Strings = (
      'select * from Region')
    Active = True
    Left = 16
    Top = 456
  end
  object qKurators: TUniQuery
    Connection = UniConnection
    SQL.Strings = (
      'SELECT '
      '  C1.`'#1050#1091#1088#1072#1090#1086#1088'`,'
      '  C2.`JDC ID`'
      'FROM '
      '  Clients C1'
      'JOIN '
      '  Clients C2 ON C1.`'#1050#1091#1088#1072#1090#1086#1088'` = C2.`'#1060#1048#1054'`'
      'WHERE '
      '  C1.`'#1050#1091#1088#1072#1090#1086#1088'` <> '#39#39' '
      '  AND C1.`'#1054#1089#1085#1086#1074#1085#1072#1103' '#1086#1088#1075#1072#1085#1080#1079#1072#1094#1080#1103'` = '#39#1061#1077#1089#1077#1076' '#1041#1077#1096#1090' - '#1061#1084#1077#1083#1100#1085#1080#1094#1082#1080#1081#39' '
      '  AND C1.`'#1058#1080#1087' '#1082#1083#1080#1077#1085#1090#1072' ('#1076#1083#1103' '#1087#1086#1080#1089#1082#1072')` <> '#39#39
      'GROUP BY '
      '  C1.`'#1050#1091#1088#1072#1090#1086#1088'`, C2.`JDC ID`'
      'ORDER BY '
      '  C1.`'#1050#1091#1088#1072#1090#1086#1088'`;')
    Active = True
    Left = 80
    Top = 456
  end
  object dsRegions: TUniDataSource
    DataSet = qRegions
    Left = 16
    Top = 512
  end
  object dsKurators: TUniDataSource
    DataSet = qKurators
    Left = 72
    Top = 512
  end
  object qUser_option: TUniQuery
    Connection = UniConnection
    SQL.Strings = (
      'select * from User')
    Active = True
    Left = 152
    Top = 456
  end
  object dsUser_option: TUniDataSource
    DataSet = qUser_option
    Left = 152
    Top = 512
  end
end
