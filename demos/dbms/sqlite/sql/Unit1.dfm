object Form1: TForm1
  Left = 264
  Top = 187
  Caption = 'dbxoodbc:: demo dbx access to SQLite'
  ClientHeight = 522
  ClientWidth = 675
  Color = clBtnFace
  Constraints.MinHeight = 480
  Constraints.MinWidth = 640
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    675
    522)
  PixelsPerInch = 96
  TextHeight = 13
  object sh1: TShape
    Left = 8
    Top = 7
    Width = 17
    Height = 17
    Brush.Color = clGray
  end
  object btn_connect: TButton
    Left = 8
    Top = 104
    Width = 75
    Height = 25
    Caption = 'ReConnect'
    TabOrder = 5
    OnClick = btn_connectClick
  end
  object btn_open_query: TButton
    Left = 8
    Top = 135
    Width = 75
    Height = 25
    Caption = 'Open Query'
    TabOrder = 8
    OnClick = btn_open_queryClick
  end
  object mem_sql_text: TMemo
    Left = 249
    Top = 28
    Width = 418
    Height = 101
    Anchors = [akLeft, akTop, akRight]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Lines.Strings = (
      'select * from "foo" where id>=:id')
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 4
  end
  object btn_query_exec: TButton
    Left = 170
    Top = 104
    Width = 75
    Height = 25
    Caption = 'Exec Query'
    TabOrder = 7
    OnClick = btn_query_execClick
  end
  object btn_cds_open: TButton
    Left = 89
    Top = 351
    Width = 75
    Height = 25
    Caption = 'Open CDS'
    TabOrder = 15
    OnClick = btn_cds_openClick
  end
  object dbnav1: TDBNavigator
    Left = 219
    Top = 495
    Width = 230
    Height = 25
    DataSource = DataSource
    Anchors = [akLeft, akBottom]
    TabOrder = 19
  end
  object btn_cds_close: TButton
    Left = 89
    Top = 382
    Width = 75
    Height = 25
    Caption = 'Close CDS'
    TabOrder = 16
    OnClick = btn_cds_closeClick
  end
  object btn_open_close: TButton
    Left = 89
    Top = 135
    Width = 75
    Height = 25
    Caption = 'Close Query'
    TabOrder = 9
    OnClick = btn_open_closeClick
  end
  object btn_disconnect: TButton
    Left = 89
    Top = 104
    Width = 75
    Height = 25
    Caption = 'Disconnect'
    TabOrder = 6
    OnClick = btn_disconnectClick
  end
  object btn_cds_apply: TButton
    Left = 89
    Top = 413
    Width = 75
    Height = 25
    Caption = 'Apply CDS'
    TabOrder = 17
    OnClick = btn_cds_applyClick
  end
  object chk_ansi_string: TCheckBox
    Left = 39
    Top = 25
    Width = 134
    Height = 17
    Caption = 'Ansi String Fields'
    TabOrder = 1
  end
  object chk_unicode_odbc: TCheckBox
    Left = 39
    Top = 4
    Width = 146
    Height = 17
    Caption = 'Unicode ODBC API'
    Checked = True
    State = cbChecked
    TabOrder = 0
  end
  object PC: TPageControl
    Left = 219
    Top = 333
    Width = 448
    Height = 160
    ActivePage = ts_grid
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 18
    object ts_grid: TTabSheet
      Caption = 'GRID'
      object grd1: TDBGrid
        Left = 0
        Top = 0
        Width = 440
        Height = 132
        Align = alClient
        DataSource = DataSource
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
      end
    end
    object ts_blob: TTabSheet
      Caption = 'BLOB'
      ImageIndex = 1
      object p1: TPanel
        Left = 0
        Top = 0
        Width = 440
        Height = 41
        Align = alTop
        TabOrder = 0
        object cbx_fields: TComboBox
          Left = 44
          Top = 8
          Width = 227
          Height = 21
          Style = csDropDownList
          ItemHeight = 0
          TabOrder = 0
          OnChange = cbx_fieldsChange
        end
        object txt1: TStaticText
          Left = 6
          Top = 12
          Width = 35
          Height = 17
          Caption = 'Fields:'
          TabOrder = 1
        end
      end
      object db_memo: TDBMemo
        Left = 0
        Top = 41
        Width = 440
        Height = 91
        Align = alClient
        DataSource = DataSource
        TabOrder = 1
      end
    end
  end
  object cbx_tables: TComboBox
    Left = 249
    Top = 3
    Width = 418
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    DropDownCount = 47
    ItemHeight = 13
    TabOrder = 3
    Text = 'foo'
    OnChange = cbx_tablesChange
    OnDblClick = cbx_tablesDblClick
    Items.Strings = (
      'foo')
  end
  object pc_log: TPageControl
    Left = 219
    Top = 135
    Width = 448
    Height = 192
    ActivePage = sh_mem_log
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 14
    OnChange = pc_log_Change
    object sh_mem_log: TTabSheet
      Caption = 'Log: Query'
      object mem_log: TMemo
        Left = 0
        Top = 0
        Width = 440
        Height = 164
        Align = alClient
        ScrollBars = ssBoth
        TabOrder = 0
      end
    end
    object sh_sql_monitor: TTabSheet
      Caption = 'Log: SQLMonitor'
      ImageIndex = 1
      object mem_sql_monitor: TMemo
        Left = 0
        Top = 0
        Width = 440
        Height = 164
        Align = alClient
        Color = clBlack
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clLime
        Font.Height = -13
        Font.Name = 'Lucida Console'
        Font.Style = []
        ParentFont = False
        ScrollBars = ssBoth
        TabOrder = 0
      end
    end
    object ts_params: TTabSheet
      Caption = 'SQL: Parameters'
      ImageIndex = 2
      object m_params: TMemo
        Left = 0
        Top = 0
        Width = 440
        Height = 164
        Align = alClient
        Lines.Strings = (
          '1')
        TabOrder = 0
      end
    end
  end
  object btn_open_table: TButton
    Left = 9
    Top = 164
    Width = 205
    Height = 26
    Caption = 'Open Table'
    TabOrder = 10
    OnClick = btn_open_tableClick
  end
  object btn_get_table_list: TButton
    Left = 8
    Top = 240
    Width = 205
    Height = 25
    Caption = 'Get Table List'
    TabOrder = 11
    OnClick = btn_get_table_listClick
  end
  object chk_direct_odbc: TCheckBox
    Left = 39
    Top = 46
    Width = 134
    Height = 17
    Caption = 'Direct ODBC'
    Checked = True
    State = cbChecked
    TabOrder = 2
  end
  object btn_clear_log_query: TButton
    Left = 8
    Top = 271
    Width = 205
    Height = 25
    Caption = 'Clear: Log Query'
    TabOrder = 12
    OnClick = btn_clear_log_query_Click
  end
  object btn_clear_log_sqlmonitor: TButton
    Left = 8
    Top = 302
    Width = 205
    Height = 25
    Caption = 'Clear: SQLMonitor'
    TabOrder = 13
    OnClick = btn_clear_log_sqlmonitor_Click
  end
  object chk_dbf: TCheckBox
    Left = 39
    Top = 64
    Width = 134
    Height = 16
    Caption = 'Connect to DBF'
    TabOrder = 20
  end
  object chk_conn_stg: TCheckBox
    Left = 39
    Top = 82
    Width = 166
    Height = 16
    Hint = 'User Connectin Storage File: "connection-properties?.ini"'
    Caption = 'User Connectin Storage File'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 21
  end
  object SQLConnection: TSQLConnection
    DriverName = 'DbxOpenOdbc'
    GetDriverFunc = 'getSQLDriverODBCW'
    LibraryName = 'dbxoodbc.dll'
    LoginPrompt = False
    Params.Strings = (
      'DbxOpenOdbc TransIsolation=ReadCommited'
      
        'Database=DRIVER={SQLite3 ODBC Driver};Database=C:\delphi\project' +
        's\personal\dbxoodbc\dev\dbxoodbc\demos\dbms\sqlite\db\dbdemos.sq' +
        'lite'
      'RowsetSize=20'
      'BlobSize=-1'
      'Trim Char=True'
      'Custom String=coLockMode=-1;coCatPrefix=Database'
      'DriverPackageLoader=TDBXDynalinkDriverLoaderOpenOdbc'
      'MetaDataPackageLoader=TDBXOpenODBCMetaDataCommandFactory'
      'DriverName=DbxOpenOdbc'
      'ProductName=DbxOpenOdbc')
    TableScope = [tsTable]
    VendorLib = 'sqlite3odbc.dll;odbc32.dll'
    AfterConnect = SQLConnectionAfterConnect
    AfterDisconnect = SQLConnectionAfterDisconnect
    Left = 148
    Top = 6
  end
  object SQLQuery: TSQLQuery
    AfterClose = SQLQueryAfterClose
    MaxBlobSize = -1
    Params = <>
    SQL.Strings = (
      'select * from '#1090#1072#1073#1083#1080#1094#1072'_'#1087#1088#1080#1084#1077#1088)
    SQLConnection = SQLConnection
    Left = 14
    Top = 194
  end
  object CDS: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'DSP'
    AfterOpen = CDSAfterOpen
    BeforeClose = CDSBeforeClose
    Left = 110
    Top = 198
  end
  object DSP: TDataSetProvider
    DataSet = SQLQuery
    UpdateMode = upWhereKeyOnly
    OnUpdateError = DSPUpdateError
    Left = 68
    Top = 196
  end
  object DataSource: TDataSource
    DataSet = CDS
    Left = 32
    Top = 372
  end
  object SQLTable: TSQLTable
    AfterClose = SQLQueryAfterClose
    MaxBlobSize = -1
    SQLConnection = SQLConnection
    TableName = 'foo'
    Left = 160
    Top = 196
  end
end
