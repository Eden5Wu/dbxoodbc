object Form1: TForm1
  Left = 277
  Top = 188
  Caption = 'dbxoodbc:: demo dbx access to MS ACCESS'
  ClientHeight = 757
  ClientWidth = 1017
  Color = clBtnFace
  Constraints.MinHeight = 628
  Constraints.MinWidth = 837
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    1017
    757)
  PixelsPerInch = 120
  TextHeight = 17
  object sh1: TShape
    Left = 10
    Top = 9
    Width = 23
    Height = 22
    Brush.Color = clGray
  end
  object btn_connect: TButton
    Left = 10
    Top = 136
    Width = 99
    Height = 33
    Caption = 'ReConnect'
    TabOrder = 6
    OnClick = btn_connectClick
  end
  object btn_open_query: TButton
    Left = 10
    Top = 177
    Width = 99
    Height = 32
    Caption = 'Open Query'
    TabOrder = 9
    OnClick = btn_open_queryClick
  end
  object mem_sql_text: TMemo
    Left = 328
    Top = 37
    Width = 684
    Height = 132
    Anchors = [akLeft, akTop, akRight]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = []
    Lines.Strings = (
      'select * from dbx_test_char')
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 5
  end
  object btn_query_exec: TButton
    Left = 222
    Top = 136
    Width = 98
    Height = 33
    Caption = 'Exec Query'
    TabOrder = 8
    OnClick = btn_query_execClick
  end
  object btn_cds_open: TButton
    Left = 116
    Top = 459
    Width = 98
    Height = 33
    Caption = 'Open CDS'
    TabOrder = 16
    OnClick = btn_cds_openClick
  end
  object dbnav1: TDBNavigator
    Left = 228
    Top = 722
    Width = 300
    Height = 33
    DataSource = DataSource
    Anchors = [akLeft, akBottom]
    TabOrder = 20
  end
  object btn_cds_close: TButton
    Left = 116
    Top = 500
    Width = 98
    Height = 32
    Caption = 'Close CDS'
    TabOrder = 17
    OnClick = btn_cds_closeClick
  end
  object btn_open_close: TButton
    Left = 116
    Top = 177
    Width = 98
    Height = 32
    Caption = 'Close Query'
    TabOrder = 10
    OnClick = btn_open_closeClick
  end
  object btn_disconnect: TButton
    Left = 116
    Top = 136
    Width = 98
    Height = 33
    Caption = 'Disconnect'
    TabOrder = 7
    OnClick = btn_disconnectClick
  end
  object btn_cds_apply: TButton
    Left = 116
    Top = 540
    Width = 98
    Height = 33
    Caption = 'Apply CDS'
    TabOrder = 18
    OnClick = btn_cds_applyClick
  end
  object chk_unicode_dbx: TCheckBox
    Left = 51
    Top = 5
    Width = 191
    Height = 22
    Caption = 'Unicode DBX ( DBX 3.0 )'
    Checked = True
    Enabled = False
    State = cbChecked
    TabOrder = 0
  end
  object chk_ansi_string: TCheckBox
    Left = 51
    Top = 61
    Width = 175
    Height = 23
    Caption = 'Ansi String Fields'
    TabOrder = 2
  end
  object chk_unicode_odbc: TCheckBox
    Left = 51
    Top = 34
    Width = 191
    Height = 22
    Caption = 'Unicode ODBC API'
    Checked = True
    State = cbChecked
    TabOrder = 1
  end
  object PC: TPageControl
    Left = 222
    Top = 435
    Width = 790
    Height = 283
    ActivePage = ts_grid
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 19
    object ts_grid: TTabSheet
      Caption = 'GRID'
      object grd1: TDBGrid
        Left = 0
        Top = 0
        Width = 782
        Height = 251
        Align = alClient
        DataSource = DataSource
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -14
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
        Width = 782
        Height = 54
        Align = alTop
        TabOrder = 0
        object cbx_fields: TComboBox
          Left = 58
          Top = 10
          Width = 296
          Height = 25
          Style = csDropDownList
          TabOrder = 0
          OnChange = cbx_fieldsChange
        end
        object txt1: TStaticText
          Left = 8
          Top = 16
          Width = 41
          Height = 21
          Caption = 'Fields:'
          TabOrder = 1
        end
      end
      object db_memo: TDBMemo
        Left = 0
        Top = 54
        Width = 782
        Height = 197
        Align = alClient
        DataSource = DataSource
        TabOrder = 1
      end
    end
  end
  object cbx_tables: TComboBox
    Left = 328
    Top = 4
    Width = 684
    Height = 25
    Anchors = [akLeft, akTop, akRight]
    DropDownCount = 47
    TabOrder = 4
    Text = 'dbx_test_char'
    OnChange = cbx_tablesChange
    OnDblClick = cbx_tablesDblClick
    Items.Strings = (
      'country'
      'customer'
      'dbx_test_char'
      'dbx_test_long'
      'dbx_test_short'
      'dbx_test_varchar'
      'employee'
      'items'
      '?')
  end
  object pc_log: TPageControl
    Left = 282
    Top = 182
    Width = 730
    Height = 248
    ActivePage = sh_mem_log
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 15
    OnChange = pc_log_Change
    object sh_mem_log: TTabSheet
      Caption = 'Log: Query'
      object mem_log: TMemo
        Left = 0
        Top = 0
        Width = 722
        Height = 216
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
        Width = 722
        Height = 216
        Align = alClient
        Color = clBlack
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clLime
        Font.Height = -17
        Font.Name = 'Lucida Console'
        Font.Style = []
        ParentFont = False
        ScrollBars = ssBoth
        TabOrder = 0
      end
    end
  end
  object btn_open_table: TButton
    Left = 12
    Top = 214
    Width = 268
    Height = 34
    Caption = 'Open Table'
    TabOrder = 11
    OnClick = btn_open_tableClick
  end
  object btn_get_table_list: TButton
    Left = 10
    Top = 314
    Width = 269
    Height = 33
    Caption = 'Get Table List'
    TabOrder = 12
    OnClick = btn_get_table_listClick
  end
  object chk_direct_odbc: TCheckBox
    Left = 51
    Top = 89
    Width = 175
    Height = 22
    Caption = 'Direct ODBC'
    Checked = True
    State = cbChecked
    TabOrder = 3
  end
  object btn_clear_log_query: TButton
    Left = 10
    Top = 354
    Width = 269
    Height = 33
    Caption = 'Clear: Log Query'
    TabOrder = 13
    OnClick = btn_clear_log_query_Click
  end
  object btn_clear_log_sqlmonitor: TButton
    Left = 10
    Top = 395
    Width = 269
    Height = 33
    Caption = 'Clear: SQLMonitor'
    TabOrder = 14
    OnClick = btn_clear_log_sqlmonitor_Click
  end
  object chk_dbf: TCheckBox
    Left = 51
    Top = 112
    Width = 175
    Height = 21
    Caption = 'Connect to DBF'
    TabOrder = 21
  end
  object SQLConnection: TSQLConnection
    DriverName = 'DbxOpenOdbc'
    GetDriverFunc = 'getSQLDriverODBCAW'
    LibraryName = 'C:\delphi\2007\projects\bpl\dbxoodbc.dll'
    LoginPrompt = False
    Params.Strings = (
      'DbxOpenOdbc TransIsolation=ReadCommited'
      
        'Database=DRIVER={Microsoft Access Driver (*.mdb)};DefaultDir=C:\' +
        'delphi\projects\personal\dbxoodbc\dev\dbxoodbc\demos\dbms\msacc' +
        'ess\sql;DriverId=25;FIL=MS Access'
      'RowsetSize=20'
      'BlobSize=-1'
      'Trim Char=True'
      'Custom String=coLockMode=-1;coCatPrefix=DefaultDir')
    TableScope = [tsTable]
    VendorLib = 'odbcjt32.dll;odbc32.dll'
    AfterConnect = SQLConnectionAfterConnect
    AfterDisconnect = SQLConnectionAfterDisconnect
    Left = 152
    Top = 28
  end
  object SQLQuery: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQL.Strings = (
      'select * from '#1090#1072#1073#1083#1080#1094#1072'_'#1087#1088#1080#1084#1077#1088)
    SQLConnection = SQLConnection
    Left = 30
    Top = 114
  end
  object CDS: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'DSP'
    AfterOpen = CDSAfterOpen
    BeforeClose = CDSBeforeClose
    Left = 30
    Top = 306
  end
  object DSP: TDataSetProvider
    DataSet = SQLQuery
    Left = 32
    Top = 164
  end
  object DataSource: TDataSource
    DataSet = CDS
    Left = 32
    Top = 372
  end
  object SQLTable: TSQLTable
    MaxBlobSize = -1
    SQLConnection = SQLConnection
    TableName = 'dbx_test_char'
    Left = 44
    Top = 248
  end
end
