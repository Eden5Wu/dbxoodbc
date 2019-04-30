unit Unit1;

  { Delphi 6/7/2005/2006/2007/2009/2010/2011(XE)/2012(XE2) }

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DB, SqlExpr,
  ExtCtrls, FMTBcd, DBClient, DBCtrls, Grids, DBGrids, Provider, ComCtrls,
  {.$IF CompilerVersion > 17.00}
  WideStrings,
  {.$IFEND}
  DbxOpenOdbcCallback, DBXpress;

const
  mssql_server = 'mssql-host';
  mssql_database = 'dbxoodbc';
  mssql_user_name = 'user1';
  mssql_user_pswd = 'pwd1';

type
  TForm1 = class(TForm)
    SQLConnection: TSQLConnection;
    btn_connect: TButton;
    sh1: TShape;
    SQLQuery: TSQLQuery;
    btn_open_query: TButton;
    CDS: TClientDataSet;
    mem_sql_text: TMemo;
    btn_query_exec: TButton;
    btn_cds_open: TButton;
    DSP: TDataSetProvider;
    DataSource: TDataSource;
    dbnav1: TDBNavigator;
    btn_cds_close: TButton;
    btn_open_close: TButton;
    btn_disconnect: TButton;
    btn_cds_apply: TButton;
    chk_unicode_dbx: TCheckBox;
    chk_ansi_string: TCheckBox;
    chk_unicode_odbc: TCheckBox;
    PC: TPageControl;
    ts_grid: TTabSheet;
    ts_blob: TTabSheet;
    grd1: TDBGrid;
    p1: TPanel;
    db_memo: TDBMemo;
    cbx_fields: TComboBox;
    txt1: TStaticText;
    cbx_tables: TComboBox;
    pc_log: TPageControl;
    sh_mem_log: TTabSheet;
    mem_log: TMemo;
    sh_sql_monitor: TTabSheet;
    mem_sql_monitor: TMemo;
    SQLTable: TSQLTable;
    btn_open_table: TButton;
    btn_get_table_list: TButton;
    chk_direct_odbc: TCheckBox;
    btn_clear_log_query: TButton;
    btn_clear_log_sqlmonitor: TButton;
    chk_msdriver: TCheckBox;
    BTest: TButton;
    SQLQuery1: TSQLQuery;
    ts_params: TTabSheet;
    m_params: TMemo;
    procedure BTestClick(Sender: TObject);
    procedure btn_connectClick(Sender: TObject);
    procedure SQLConnectionAfterConnect(Sender: TObject);
    procedure SQLConnectionAfterDisconnect(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btn_open_queryClick(Sender: TObject);
    procedure btn_query_execClick(Sender: TObject);
    procedure btn_cds_openClick(Sender: TObject);
    procedure btn_open_closeClick(Sender: TObject);
    procedure btn_cds_closeClick(Sender: TObject);
    procedure btn_disconnectClick(Sender: TObject);
    procedure btn_cds_applyClick(Sender: TObject);
    procedure CDSBeforeClose(DataSet: TDataSet);
    procedure CDSAfterOpen(DataSet: TDataSet);
    procedure cbx_fieldsChange(Sender: TObject);
    procedure cbx_tablesChange(Sender: TObject);
    procedure SQLMonitorTrace(Sender: TObject; TraceInfo: TDBXTraceInfo; var LogTrace: Boolean);
    procedure btn_open_tableClick(Sender: TObject);
    procedure btn_get_table_listClick(Sender: TObject);
    procedure btn_clear_log_query_Click(Sender: TObject);
    procedure btn_clear_log_sqlmonitor_Click(Sender: TObject);
  private
    { Private declarations }
    //QuoteChar: string;
    SQLMonitor: TSQLMonitor;
    procedure CheckConnection();
    procedure GenerateTableList;
    procedure UpdateQueryText;
  public
    { Public declarations }
    procedure print_dataset(D: TDataSet; ClearMemo: Boolean = True);
  end;

var
  Form1: TForm1;

implementation

uses
  dbx_constg, dbx_mssql_connect,
  {$IF CompilerVersion >= 18.50}
  DBXCommon,
  {$IFEND}
  //DbxOpenOdbcFuncs,
  DbxXXDrv; // { critical }

{$R *.dfm}

procedure TForm1.BTestClick(Sender: TObject);

  procedure test_20111129();
  (*
    CREATE TABLE [dbo].[tbl_obj] (
      [objno] varchar(12) NOT NULL,
      [objnm] varchar(128) NULL,
      CONSTRAINT [pk_imp1] PRIMARY KEY CLUSTERED ([objno])
    )
    ON [PRIMARY]
    GO
  *)
  var
    qy: TSQLQuery;
    dsp: TDataSetProvider;
    cds: TClientDataSet;
    iTemp, iTemp2, iColUseRang, iRowUseRang:Integer;
    sObjNo, sObjNM{, sSQLCommand, sSQLCommand1}: string;
  begin
    qy := TSQLQuery.Create(nil);
    try
      qy.SQLConnection := SQLConnection;
      dsp := TDataSetProvider.Create(qy);
      dsp.Name := 'dspobj';
      dsp.DataSet := qy;
      cds := TClientDataSet.Create(qy);
      //cds.ProviderName := dsp.Name;
      cds.SetProvider(dsp);

      //iColUseRang := MsExcelWorkSheet.UsedRange.Columns.Count;
      //iRowUseRang := MsExcelWorkSheet.UsedRange.Rows.Count;
      iColUseRang := 0;
      iRowUseRang := 5;

      qy.SQL.Text := 'select * from tbl_obj';
      cds.Open;

      for iTemp := 1{RowNumber} to iRowUseRang do
      begin
        //sObjNo := Trim(MsExcelWorkSheet.Cells.Item[iTemp, 1].Value);
        //sObjNM := Trim(MsExcelWorkSheet.Cells.Item[iTemp, 2].Value);
        iTemp2 := iTemp;
        if iTemp2 = 4 then
          iTemp2 := 3; // test edit
        sObjNo := Format('cell[%d,%d]', [iTemp2, iColUseRang+1]);
        sObjNM := Format('cell[%d,%d]', [iTemp2, iColUseRang+2]);
        if (sObjNo = '') then
          Continue;
        if cds.Locate('objno', sObjNo, []) then
          cds.Edit
        else
        cds.Append;
        cds.Fields.Fields[0].AsString := sObjNo;
        cds.Fields.Fields[1].AsString := sObjNM;
        cds.Post;
      end;

      cds.ApplyUpdates(0);
    finally
      FreeAndNil(qy);
    end;
  end;

  procedure test_20111119();
  (*
    CREATE TABLE [dbo].[table4] (
      [i1] int NOT NULL,
      [i2] int NULL,
      CONSTRAINT [pk_tab4_i1] PRIMARY KEY CLUSTERED ([i1])
    )
    ON [PRIMARY]
    GO
  //*)
  var
    i, j: Integer;
    {$IF CompilerVersion >= 18.50}
    Transaction: {DBXCommon.pas}TDBXTransaction;
    {$ELSE}
    TransDesc: TTransactionDesc;
    {$IFEND}
  begin
    SQLQuery1.SQL.Text := 'delete from table4';
    SQLQuery1.ExecSQL();

    {$IF CompilerVersion >= 18.50}
    Transaction := SQLConnection.BeginTransaction;
    {$ELSE}
    with TransDesc do
    begin
      TransactionID    := 0;
      GlobalID         := 0;
      IsolationLevel   := xilREADCOMMITTED;
      CustomIsolation  := 0;
    end;
    SQLConnection.StartTransaction(TransDesc);
    {$IFEND}

    try
      SQLQuery1.SQL.Text := 'INSERT INTO table4(i1, i2) VALUES(:i1, :i2) ';
      //SQLQuery1.SQL.Text := 'INSERT INTO table4(i1) VALUES(:i1) ';
      SQLQuery1.Prepared := True;
      for i:=0 to 100 do
      begin
        for j := 0 to SQLQuery1.Params.Count-1 do
          SQLQuery1.Params.Items[j].AsInteger := i;
        SQLQuery1.ExecSQL();
      end;
      //SQLConnection.CommitFreeAndNil(Transaction);
    finally
      if SQLConnection.InTransaction then
      {$IF CompilerVersion >= 18.50}
        SQLConnection.RollbackFreeAndNil(Transaction);
      {$ELSE}
        SQLConnection.Rollback(TransDesc);
      {$IFEND}
    end;
  end;

begin
  if not SQLConnection.Connected then
     Exit;

  test_20111129();
  //test_20111119();
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  SQLConnection.GetDriverFunc := 'getSQLDriverODBCAW';
  {$IF CompilerVersion >= 18.00}
  SQLConnection.GetDriverFunc := 'getSQLDriverODBCW';
  {$IF CompilerVersion >= 18.50}
  chk_unicode_dbx.Checked := True;
  chk_unicode_dbx.Enabled := False;
  //SQLConnection.GetDriverFunc := 'getSQLDriverODBCW';
  {$ELSE}
  chk_unicode_dbx.Checked := True;
  chk_unicode_dbx.Enabled := True;
  {$IFEND}
  {$ELSE}
  chk_unicode_dbx.Checked := False;
  chk_unicode_dbx.Enabled := False;
  {$IFEND}

  SQLMonitor := TSQLMonitor.Create(Self);
  SQLMonitor.OnTrace := SQLMonitorTrace;
  SQLMonitor.SQLConnection := SQLConnection;

  SQLMonitor.Active := True;
  //SQLMonitor.Active := False;

//  if not SQLConnection.Connected then
//    SQLConnection.Connected := SQLConnectionLoadProperties(SQLConnection,
//      {ConStorageFile:} ExtractFilePath(ParamStr(0))
//      + '..\connect\connection-properties' + ConStorageVersion() + '.ini');

  if not SQLConnection.Connected then
    SQLConnectionAfterDisconnect(SQLConnection)
  else
    SQLConnectionAfterConnect(SQLConnection);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  cds.Close;
  SQLConnection.Connected := False;
end;

procedure TForm1.GenerateTableList;
var
  {$IF CompilerVersion >= 18.00}
  List: TWideStringList;
  {$ELSE}
  List: TStringList;
  {$IFEND}
  i: Integer;
  sSchemaName: string;
begin
  cbx_tables.Items.Clear;
  {$IF CompilerVersion >= 18.00}
  List := TWideStringList.Create;
  {$ELSE}
  List := TStringList.Create;
  {$IFEND}
  try
    cbx_tables.Items.BeginUpdate;
    sSchemaName := '';
    //{$IF CompilerVersion >= 18.00}
    //  sSchemaName := '?';//#0; // Delphi 2007 bug.
    //{$IFEND}
    SQLConnection.GetTableNames(List{$IF CompilerVersion >= 15.00}, sSchemaName{$IFEND});
    {$IF CompilerVersion < 17.00}
    List.Sort;
    {$IFEND}
    for i := 0 to List.Count-1 do
    begin
      // Delphi 2007 Down: List[i] - contained correctly table name, but mem_log is not unicode...
      cbx_tables.Items.Add(List[i]);
    end;
  except
    Application.HandleException(Self);
  end;
  if cbx_tables.Items.Count = 0 then
    cbx_tables.Items.Text := 'foo';
  cbx_tables.Items.EndUpdate;
  List.Free;
  cbx_tables.ItemIndex := 0;
  cbx_tablesChange(cbx_tables);
end;

procedure TForm1.btn_connectClick(Sender: TObject);
begin
  SQLConnection.Connected := False;
  SQLConnection.Connected := SQLConnectionLoadProperties(SQLConnection,
    {ConStorageFile:} ExtractFilePath(ParamStr(0))
    + '..\connect\connection-properties' + ConStorageVersion() + '.ini');

//
//TODO:
//

  //
  //if ora_tns_name = '' then
  //  raise Exception.Create('It is necessary to set TNS.'
  //    + #13#10'TNS must be indicated in a file like "C:\Oracle\9.2.0.6\network\ADMIN\tnsnames.ora"');
  //
  //dbx_ora_connect.OracleConnect(
  //  SQLConnection,
  //  {TNS=} ora_tns_name,
  //  {User=} ora_user_name,
  //  {Password=} ora_user_pswd,
  //  {MicrosoftDriver=} chk_msdriver.Checked,
  //  {DirectOdbc=} True,
  //  {LoginPrompt=} ora_user_pswd = '',
  //  {DNS=}'',
  //  {AdditionalOptions=}'' // 'coMetaData=0'
  //);
//ExcelConnect(SQLConnectioná
  //const xls_file_name: string;
  //const dns_name: string = '';
  //bAutoCreate: Boolean = True;
  //DirectOdbc: Boolean = True;
  //LoginPrompt: Boolean = False;
  //UserName: string = '';
  //Password: string = '';
  //const AdditionalOptions: string = '';
  //bUnicodeOdbcApi: Boolean = False;
  //bAnsiStringField: Boolean = True;
  //bUnicodeDriver: Boolean = False
//);

end;

procedure TForm1.CDSAfterOpen(DataSet: TDataSet);
var
  i: Integer;
  F: TField;
begin
  for i := 0 to CDS.FieldCount - 1 do
  begin
    F := CDS.Fields[i];
    if F.Size > 64 then
      F.DisplayWidth := 64;
  end;
  cbx_fields.Items.Clear;
  for i := 0 to CDS.FieldCount - 1 do
    cbx_fields.Items.Add(CDS.Fields[i].FieldName);
end;

procedure TForm1.CDSBeforeClose(DataSet: TDataSet);
begin
  db_memo.DataField := '';
  cbx_fields.ItemIndex := -1;
  cbx_fields.Items.Clear;
  cbx_fields.Text := '';
end;

procedure TForm1.CheckConnection();
begin
  if not SQLConnection.Connected then
    SQLConnection.Connected := True;
end;

procedure TForm1.btn_disconnectClick(Sender: TObject);
begin
  cds.Close;
  SQLConnection.Connected := False;
end;

procedure TForm1.SQLConnectionAfterConnect(Sender: TObject);
begin
  sh1.Brush.Color := clRed;

  chk_unicode_odbc.Enabled := False;
  chk_ansi_string.Enabled := False;
  chk_unicode_dbx.Enabled := False;

  btn_query_exec.Enabled := True;
  btn_open_query.Enabled := True;
  btn_open_close.Enabled := True;

  btn_get_table_list.Enabled := True;
  btn_open_table.Enabled := True;

  btn_cds_open.Enabled := True;
  btn_cds_close.Enabled := True;
  btn_cds_apply.Enabled := True;

  GenerateTableList();
end;

procedure TForm1.SQLConnectionAfterDisconnect(Sender: TObject);
begin
  if not (csDestroying in ComponentState) then
  begin
    sh1.Brush.Color := clGray;

    chk_unicode_odbc.Enabled := True;
    chk_ansi_string.Enabled := True;
    chk_unicode_dbx.Enabled := True;

    btn_query_exec.Enabled := False;
    btn_open_query.Enabled := False;
    btn_open_close.Enabled := False;

    btn_get_table_list.Enabled := False;
    btn_open_table.Enabled := False;

    btn_cds_open.Enabled := False;
    btn_cds_close.Enabled := False;
    btn_cds_apply.Enabled := False;
  end;
end;

//
// SQLMonitor bugs:
//
//   Delphi 2007: not tracced connect/disconnect events (adapter cleared callback info)
//

procedure TForm1.SQLMonitorTrace(Sender: TObject; TraceInfo: TDBXTraceInfo; var LogTrace: Boolean);
var
  iTraceFlag: Integer;
  sTraceFlag, sTraceMessage: string;
begin
  if LogTrace then
  begin
    // compact log
    if mem_sql_monitor.Lines.Count > 5000{1000} then
    begin
      with mem_sql_monitor.Lines do
      begin
        BeginUpdate;
        while Count >500 do
          Delete(0);
        EndUpdate;
      end;
    end;
    // append log new information
    DbxOpenOdbcCallback.DecodeTraceInfo(TraceInfo, iTraceFlag, sTraceFlag, sTraceMessage);

    mem_sql_monitor.Lines.Add('---- ---- ---- ---- ---- ---- ---- ----');
    mem_sql_monitor.Lines.Add(Format('Monitor Active: %d; TraceFlag: ( %3d: %s ); Message: %s', [
      Integer(SqlMonitor.Active), iTraceFlag, sTraceFlag,
      StringReplace(sTraceMessage, #13#10, ' ', [rfReplaceAll])]));
  end;
end;

procedure TForm1.UpdateQueryText;
var
  i: Integer;
begin
  SQLQuery.Close;
  //SQLQuery.SQL.Text := '';
  //SQLQuery.Params.Clear;
  SQLQuery.SQL.Text := mem_sql_text.Lines.Text;
  i := SQLQuery.Params.Count;
  if i > 0 then
  begin
    for i := 0 to i-1 do
    begin
      with SQLQuery.Params.Items[i] do
      begin
        Clear;
        if i < m_params.Lines.Count then
          SQLQuery.Params.Items[i].AsString := m_params.Lines[i];
      end;
    end;
  end;
end;

procedure TForm1.btn_query_execClick(Sender: TObject);
begin
  mem_log.Lines.Clear;
  CheckConnection();

  UpdateQueryText();
  SQLQuery.ExecSQL;
end;

procedure TForm1.cbx_fieldsChange(Sender: TObject);
begin
  db_memo.DataField := '';
  if cbx_fields.ItemIndex >= 0 then
    db_memo.DataField := cbx_fields.Text;
end;

procedure TForm1.cbx_tablesChange(Sender: TObject);
var
  sObject: string;
begin
  sObject := cbx_tables.Text;
  sObject := 'select t.* from ' + sObject + ' t';
  mem_sql_text.Lines.Text := sObject;
end;

procedure TForm1.btn_open_queryClick(Sender: TObject);
begin
  pc_log.ActivePageIndex := 0;
  mem_log.Lines.Clear;
  CheckConnection();

  UpdateQueryText();
  SQLQuery.Open;
  print_dataset(SQLQuery);
end;

procedure TForm1.btn_open_closeClick(Sender: TObject);
begin
  SQLQuery.Close;
  mem_log.Lines.Clear;
end;

procedure TForm1.btn_cds_openClick(Sender: TObject);
begin
  mem_log.Lines.Clear;
  cds.Close;
  CheckConnection();
  UpdateQueryText();
  cds.Open;
end;

procedure TForm1.btn_cds_applyClick(Sender: TObject);
begin
  CheckConnection();
  if not cds.Active then
    raise Exception.Create('CDS is not open');
  cds.ApplyUpdates(0);
end;

procedure TForm1.btn_cds_closeClick(Sender: TObject);
begin
  mem_log.Lines.Clear;
  cds.Close;
  SQLQuery.Close;
end;

procedure TForm1.print_dataset(D: TDataSet; ClearMemo: Boolean = True);
const
  iColMaxCount = 17;
  iRowMaxCount = 7;
var
  iCol, iRow, i: Integer;
  s: string;
begin
  if ClearMemo then
    mem_log.Lines.Clear;

  iCol := D.FieldCount-1;
  if iCol > iColMaxCount-1 then
    iCol := iColMaxCount-1;
  iRow := 0;

  while (not D.Eof) and (iRow < iRowMaxCount) do with mem_log.Lines do
  begin
    Inc(iRow);

    Add('-----------------------------');
    Add(Format('  Row num %d: values', [iRow]));
    Add('-----------------------------');
    for i := 0 to iCol do
    begin
      with D.Fields[i] do
        S := '    ' + FieldName + ' = ' + DisplayText;
      Add(S);
    end;

    D.Next;
  end;
end;

procedure TForm1.btn_open_tableClick(Sender: TObject);
begin
  pc_log.ActivePageIndex := 0;
  mem_log.Lines.Clear;
  CheckConnection();

  SQLTable.Close;
  //SQLTable.GetMetadata := False;
  SQLTable.Open;
  print_dataset(SQLTable);
end;

procedure TForm1.btn_get_table_listClick(Sender: TObject);
begin
  CheckConnection();
  GenerateTableList();
end;

procedure TForm1.btn_clear_log_query_Click(Sender: TObject);
begin
  mem_log.Lines.Clear;
end;

procedure TForm1.btn_clear_log_sqlmonitor_Click(Sender: TObject);
begin
  mem_sql_monitor.Lines.Clear;
end;

end.
