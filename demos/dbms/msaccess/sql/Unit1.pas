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
  DefQuoteChar = '`';

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
    chk_dbf: TCheckBox;
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
    procedure cbx_tablesDblClick(Sender: TObject);
    procedure pc_log_Change(Sender: TObject);
  private
    { Private declarations }
    SQLMonitor: TSQLMonitor;
    FQuoteChar: string;
    procedure CheckConnection();
    procedure GenerateTableList;
  public
    { Public declarations }
    procedure print_dataset(D: TDataSet; ClearMemo: Boolean = True);
  end;

var
  Form1: TForm1;

implementation

uses
  dbx_dbf_connect, dbx_access_connect,
  DbxXXDrv; { critical }

{$R *.dfm}

function SetMemoScrollBarPos(AControl: TWinControl; Kind: TScrollBarKind;
  Position: Integer; bRedraw: Boolean = True): Boolean;
const
  cSBCode: array[Boolean] of integer = (WS_HSCROLL, WS_VSCROLL);
var
  vSBCode: Integer;
begin
  Result := (AControl <> nil) and (AControl.HandleAllocated);
  if not Result then
    Exit;
  vSBCode := cSBCode[Kind <> sbHorizontal];
  Result := (GetWindowLong(AControl.Handle, GWL_STYLE) and vSBCode) <> 0;
  if Result then
    SetScrollPos(AControl.Handle, vSBCode, Position, bRedraw);
end;

procedure TForm1.FormCreate(Sender: TObject);
{$IFDEF _MEMCHECK_}
//var
//  p: pointer;
{$ENDIF}
begin
  // test:
  //
  {$IFDEF _MEMCHECK_}
  //GetMem(p, 8196); // <=: test memory leak reporting
  //if p = nil then;
  Caption := Caption + ' (MemCheck Mode)';
  {$ENDIF}
  //
  // test.
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
{
procedure AccessConnect(SQLConnection: TSQLConnection;
  const mdb_file_name: string;
  const DNS_NAME: string = '';
  DirectOdbc: Boolean = True;
  LoginPrompt: Boolean = False;
  UserName: string = '';
  Password: string = '';
  const AdditionalOptions: string = '';
  bUnicodeOdbcApi: Boolean = False;
  bAnsiStringField: Boolean = True;
  bUnicodeDriver: Boolean = False
);
{}
  if not chk_dbf.Checked then
  begin
    //
    // MSACCESS
    //
    dbx_access_connect.AccessConnect(SQLConnection,
      // mdb_file_name:
        ExtractFilePath(ParamStr(0)) + 'dbdemos.mdb',
      // DNS_NAME
        '',
      // DirectOdbc
        chk_direct_odbc.Checked,
      // LoginPrompt
        False,
      // UserName
        '',
      // Password
        '',
      // AdditionalOptions
        'coEnableBCD=0',
      // bUnicodeOdbcApi
        chk_unicode_odbc.Checked,
      // bAnsiStringField
        chk_ansi_string.Checked,
      // bUnicodeDriver
        chk_unicode_dbx.Checked
    );
  end
  else
  begin
    //
    // DBF
    //
    dbx_dbf_connect.DBFConnect(SQLConnection,
      // dbf_file_name:
        //ExtractFilePath(ParamStr(0)) + 'dbdemos.xls',
        '..\..\dbf\db',
      // dns_name
        '',
      // DirectOdbc
        chk_direct_odbc.Checked,
      // LoginPrompt
        False,
      // UserName
        '',
      // Password
        '',
      // AdditionalOptions
        '',
      // bUnicodeOdbcApi
        chk_unicode_odbc.Checked,
      // bAnsiStringField
        chk_ansi_string.Checked,
      // bUnicodeDriver
        chk_unicode_dbx.Checked
    );
  end;
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

  //FQuoteChar := DefQuoteChar;

  //GenerateTableList;
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
    if mem_sql_monitor.Lines.Count > 1000 then
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

    //SetScrollPos(mem_sql_monitor.Handle, WS_VSCROLL, mem_sql_monitor.Lines.Count-1, True);
    //SetMemoScrollBarPos(mem_sql_monitor, sbVertical, mem_sql_monitor.Lines.Count);

  end;
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
  //if FQuoteChar <> '' then
  //  sObject := FQuoteChar + sObject + FQuoteChar;
  if (FQuoteChar <> '') and (Pos(FQuoteChar, sObject) <= 0) and (Pos(' ', sObject) > 0) then
  begin
    sObject := FQuoteChar
      //+ StringReplace(sObject, '.', FQuoteChar + '.' + FQuoteChar, [rfReplaceAll])
      + sObject
      + FQuoteChar;
  end;
  //
  mem_sql_text.Lines.Text := 'select t.* from ' + sObject + ' t'
    //+ #13'where rownum < 20'
  ;
end;

procedure TForm1.cbx_tablesDblClick(Sender: TObject);
begin
  cbx_tablesChange(cbx_tables);
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

procedure TForm1.pc_log_Change(Sender: TObject);
begin
  if pc_log.ActivePage = sh_sql_monitor then
  begin
    //SetScrollPos(mem_sql_monitor.Handle, WS_VSCROLL, mem_sql_monitor.Lines.Count, True);
    SetMemoScrollBarPos(mem_sql_monitor, sbVertical, mem_sql_monitor.Lines.Count);
  end;
end;

procedure TForm1.print_dataset(D: TDataSet; ClearMemo: Boolean = True);
const
  iColMaxCount = 17;
  iRowMaxCount = 7;
var
  iCol, iRow, i: Integer;
  s, v: string;
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
      begin
        s := '    ' + FieldName + ' = ';
        if not IsNull then
          v := '<' + DisplayText + '>'
        else
          v := '@<NULL>';
        s := s + v;;
      end;
      Add(s);
    end;

    D.Next;
  end;
end;

procedure TForm1.btn_open_tableClick(Sender: TObject);
var
  S: string;
begin
  pc_log.ActivePageIndex := 0;
  mem_log.Lines.Clear;
  CheckConnection();

  SQLTable.Close;

  S := Trim(cbx_tables.Text);
  if S <> '' then
    SQLTable.TableName := S;

  //SQLTable.GetMetadata := False;
  SQLTable.Open;
  print_dataset(SQLTable);
end;

procedure TForm1.btn_get_table_listClick(Sender: TObject);
begin
  GenerateTableList;
  CheckConnection();
end;

procedure TForm1.btn_clear_log_query_Click(Sender: TObject);
begin
  //
  // test:
  //
  {
  cds.fieldbyname('company').Clear;
  {}
  //
  // test.
  //
  mem_log.Lines.Clear;
end;

procedure TForm1.btn_clear_log_sqlmonitor_Click(Sender: TObject);
begin
  mem_sql_monitor.Lines.Clear;
end;

procedure TForm1.GenerateTableList;
var
  {$IF CompilerVersion >= 18.00}
  List: TWideStringList;
  {$ELSE}
  List: TStringList;
  {$IFEND}
  i: Integer;
  sSchemaName, sSaveTables: string;
begin
  sSaveTables := cbx_tables.Items.Text;
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
    cbx_tables.Items.Text := sSaveTables;
  cbx_tables.Items.EndUpdate;
  List.Free;
  cbx_tables.ItemIndex := 0;
  cbx_tablesChange(cbx_tables);
end;

end.
