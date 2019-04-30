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
  DbxOpenOdbcCallback, Buttons, DBXpress;

const
  {$i login.inc}

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
    BLoadTables: TSpeedButton;
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
    procedure DSPUpdateError(Sender: TObject; DataSet: TCustomClientDataSet; E: EUpdateError; UpdateKind: TUpdateKind;
      var Response: TResolverResponse);
    procedure BLoadTablesClick(Sender: TObject);
    procedure SQLQueryAfterClose(DataSet: TDataSet);
  private
    { Private declarations }
    FConStorageFile: string;
    QuoteChar: string;
    SQLMonitor: TSQLMonitor;
    procedure CheckConnection();
  public
    { Public declarations }
    procedure print_dataset(D: TDataSet; ClearMemo: Boolean = True);
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses
  MidConst,
  dbx_constg, dbx_ora_connect,
  DbxOpenOdbcFuncs,
  DbxXXDrv; // { critical }

procedure TForm1.FormCreate(Sender: TObject);
begin
  {$IF CompilerVersion > 17.00}
  SQLQuery.GetMetadata := True;
  {$IFEND}
  FConStorageFile := ExtractFilePath(ParamStr(0))
    + 'connection-properties' + ConStorageVersion() + '.ini';
  QuoteChar := '"';
  {$IFDEF _MEMCHECK_}
  Caption := Caption + ' (MemCheck Mode)';
  {$ENDIF}
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

procedure TForm1.btn_connectClick(Sender: TObject);
begin
  if ora_tns_name = '' then
    raise Exception.Create('It is necessary to set TNS.'
      + #13#10'TNS must be indicated in a file like "C:\Oracle\9.2.0.6\network\ADMIN\tnsnames.ora"');

  if FileExists(FConStorageFile) then
  begin
    SQLConnection.Connected := False;
    SQLConnection.Connected := SQLConnectionLoadProperties(SQLConnection, FConStorageFile);
    Exit;
  end;

  dbx_ora_connect.OracleConnect(
    SQLConnection,
    {TNS=} ora_tns_name,
    {User=} ora_user_name,
    {Password=} ora_user_pswd,
    {MicrosoftDriver=} chk_msdriver.Checked,
    {DirectOdbc=} True,
    {LoginPrompt=} ora_user_pswd = '',
    {DNS=}'',
    {AdditionalOptions=}'' // 'coMetaData=0'
  );
  SQLConnectionSaveProperties(SQLConnection, FConStorageFile);
end;

procedure TForm1.CDSAfterOpen(DataSet: TDataSet);
var
  i: Integer;
  F: TField;
begin
  {$IF CompilerVersion > 17.00}
  if SQLQuery.GetMetadata then
    dsp.UpdateMode := upWhereKeyOnly
  else
    dsp.UpdateMode := upWhereAll;
  {$ELSE}
  dsp.UpdateMode := upWhereKeyOnly;
  {$IFEND}
  //
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

procedure TForm1.DSPUpdateError(Sender: TObject; DataSet: TCustomClientDataSet; E: EUpdateError;
  UpdateKind: TUpdateKind; var Response: TResolverResponse);
var
  P: TDataSetProvider;
begin
   P := Sender as TDataSetProvider;
   if (P.UpdateMode = upWhereKeyOnly) and (E.Message = MidConst.SNoKeySpecified) then
   begin
     // Unable to find record.  No key specified
     P.UpdateMode := upWhereAll;
     Response := rrApply;
   end;
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

  BLoadTables.Enabled := True;
  //BLoadTablesClick(nil);
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

    BLoadTables.Enabled := False;
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

type
  TCustomSQLDataSetAccess = class(TCustomSQLDataSet);

procedure TForm1.SQLQueryAfterClose(DataSet: TDataSet);
begin
  //
  // TODO: fix "SqlExpr.pas" for clear cached IndexDefs;
  //
  if DataSet is TCustomSQLDataSet then
    TCustomSQLDataSetAccess(DataSet).ClearIndexDefs;
end;

procedure TForm1.btn_query_execClick(Sender: TObject);
begin
  mem_log.Lines.Clear;
  CheckConnection();

  SQLQuery.Close;
  SQLQuery.SQL.Text := mem_sql_text.Lines.Text;
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
  //if QuoteChar <> '' then
  //  sObject := QuoteChar + sObject + QuoteChar;
  if (QuoteChar <> '') and (Pos(QuoteChar, sObject) <= 0) and (Pos(' ', sObject) > 0) then
  begin
    sObject := QuoteChar
      + StringReplace(sObject, '.', QuoteChar + '.' + QuoteChar, [rfReplaceAll])
      + QuoteChar;
  end;
  //
  mem_sql_text.Lines.Text := 'select t.* from ' + sObject + ' t'
  {$IF CompilerVersion >= 18.50}
    + #13'where rownum < 20'
  {$IFEND}
  ;
end;

procedure TForm1.btn_open_queryClick(Sender: TObject);
begin
  pc_log.ActivePageIndex := 0;
  mem_log.Lines.Clear;
  CheckConnection();

  SQLQuery.Close;
  SQLQuery.SQL.Text := mem_sql_text.Lines.Text;
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
  SQLQuery.Close;
  SQLQuery.SQL.Text := mem_sql_text.Lines.Text;
  cds.Open;
end;

procedure TForm1.BLoadTablesClick(Sender: TObject);
  //
  procedure generate_queries();
  var
    {$IF CompilerVersion >= 18.00}
    List: TWideStringList;
    {$ELSE}
    List: TStringList;
    {$IFEND}
    i: Integer;
    sOldList, sOldText, sSchemaName: string;
  begin
    sOldList := cbx_tables.Items.Text;
    sOldText := cbx_tables.Text;
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
      //  sSchemaName := #0; // Delphi 2007 bug.
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
    begin
      cbx_tables.Items.Text := sOldList;
      cbx_tables.Text := sOldText;
    end;
    cbx_tables.Items.EndUpdate;
    List.Free;
    if (cbx_tables.ItemIndex < 0) and (cbx_tables.Items.Count > 0) then
      cbx_tables.ItemIndex := 0;
    //
    cbx_tablesChange(cbx_tables);
  end;
  //
begin
  if SQLConnection.Connected then
    generate_queries();
end;

procedure TForm1.btn_cds_applyClick(Sender: TObject);
begin
  CheckConnection();
  if not cds.Active then
    raise Exception.Create('CDS is not open');
  //
  // test: "when GatMetadata = False":
  //
  //dsp.UpdateMode := upWhereKeyOnly;
  //
  // test.
  //
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

  if D.Eof then
  begin
    with mem_log.Lines do
      Add('** is empty **');
    Exit;
  end;

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
var
  S: string;
begin
  CheckConnection();

  SQLTable.Close;

  S := Trim(cbx_tables.Text);
  if S <> '' then
    SQLTable.TableName := S;

  if SQLTable.TableName <> '' then
  begin
    pc_log.ActivePageIndex := 0;
    mem_log.Lines.Clear;
    //
    //SQLTable.GetMetadata := False;
    SQLTable.Open;
    print_dataset(SQLTable);
  end;
end;

procedure TForm1.btn_get_table_listClick(Sender: TObject);
var
  {$IF CompilerVersion >= 18.00}
  List: TWideStringList;
  {$ELSE}
  List: TStringList;
  {$IFEND}
  i: Integer;
  sSchemaName: string;
begin
  CheckConnection();
  {$IF CompilerVersion >= 18.00}
  List := TWideStringList.Create;
  {$ELSE}
  List := TStringList.Create;
  {$IFEND}
  try
    sSchemaName := '';
    //{$IF CompilerVersion >= 18.00}
    //  sSchemaName := #0; // Delphi 2007 bug.
    //{$IFEND}
    SQLConnection.GetTableNames(List{$IF CompilerVersion >= 15.00}, sSchemaName{$IFEND});
    {$IF CompilerVersion < 17.00}
    List.Sort;
    {$IFEND}
    mem_log.Lines.Add('** Read Tables begin:');
    mem_log.Lines.BeginUpdate;
    try
      for i := 0 to List.Count-1 do
      begin
        // Delphi 2007 Down: List[i] - contained correctly table name, but mem_log is not unicode...
        mem_log.Lines.Add(List[i]);
      end;
      mem_log.Lines.Add('** Read Tables end.');
    finally
      mem_log.Lines.EndUpdate;
    end;
  finally
    List.Free;
  end;
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
