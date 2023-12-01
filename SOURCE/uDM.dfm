object DM: TDM
  OldCreateOrder = False
  Height = 349
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
end
