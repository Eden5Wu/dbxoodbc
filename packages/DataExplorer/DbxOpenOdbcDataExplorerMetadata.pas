unit DbxOpenOdbcDataExplorerMetadata;

interface

uses
  System.SysUtils,
  System.Classes,
  Data.DBXCommon,
  Data.DBXCommonTable,
  Data.DBXMetaDataNames,
  Data.DBXMetaDataReader,
  Data.DBXMetaDataWriter,
  Data.DBXMetaDataWriterFactory,
  Data.DBXMetaDataCommandFactory;

type
  { 自訂 MetaDataReader：實作 GetCollection 針對各資料庫物件之 DbxMetaData 命令 }
  TDBXOpenOdbcMetaDataReader = class(TDBXBaseMetaDataReader)
  private
    function ExecuteMetadataCommand(const CommandStr, CollectionName: string;
      const TargetColumns: TDBXValueTypeArray): TDBXTable;
  public
    function FetchCatalogs: TDBXTable; override;
    function FetchSchemas(const Catalog: string): TDBXTable; override;
    function FetchTables(const Catalog: string; const Schema: string;
      const TableName: string; const TableType: string): TDBXTable; override;
    function FetchViews(const Catalog: string; const Schema: string;
      const View: string): TDBXTable; override;
    function FetchSynonyms(const Catalog: string; const Schema: string;
      const Synonym: string): TDBXTable; override;
    function FetchColumns(const Catalog: string; const Schema: string;
      const Table: string): TDBXTable; override;
    function FetchIndexes(const Catalog: string; const Schema: string;
      const Table: string): TDBXTable; override;
    function FetchIndexColumns(const Catalog: string; const Schema: string;
      const Table: string; const Index: string): TDBXTable; override;
    function FetchForeignKeys(const Catalog: string; const Schema: string;
      const Table: string): TDBXTable; override;
    function FetchForeignKeyColumns(const Catalog: string; const Schema: string;
      const Table: string; const ForeignKeyName: string; const PrimaryCatalog: string;
      const PrimarySchema: string; const PrimaryTable: string;
      const PrimaryKeyName: string): TDBXTable; override;
    function FetchProcedures(const Catalog: string; const Schema: string;
      const ProcedureName: string; const ProcedureType: string): TDBXTable; override;
    function FetchProcedureParameters(const Catalog: string; const Schema: string;
      const Proc: string; const Parameter: string): TDBXTable; override;
  end;

  { 自訂 MetaDataWriter：供 TDBXMetaDataWriterFactory 註冊工廠 }
  TDBXOpenOdbcMetaDataWriter = class(TDBXBaseMetaDataWriter)
  public
    procedure Open; override;
  end;

implementation

uses
  Data.DBXDBReaders;

procedure DbgLog(const S: string);
begin
  if IsConsole then
    Writeln(S);
end;

{ TDBXOpenOdbcMetaDataWriter }

procedure TDBXOpenOdbcMetaDataWriter.Open;
begin
  if FReader = nil then
    FReader := TDBXOpenOdbcMetaDataReader.Create;
end;

{ TDBXOpenOdbcMetaDataReader }

function TDBXOpenOdbcMetaDataReader.ExecuteMetadataCommand(
  const CommandStr, CollectionName: string; const TargetColumns: TDBXValueTypeArray): TDBXTable;
var
  Conn: TDBXConnection;
  Cmd: TDBXCommand;
  Reader: TDBXReader;
  MemTable: TDBXMemoryTable;
  I, SrcOrd, FetchedCount: Integer;
  ColName: string;
begin
  Result := nil;
  if Context = nil then Exit;

  Conn := TDBXDataExpressProviderContext(Context).Connection;
  if Conn = nil then Exit;

  Cmd := Conn.CreateCommand;
  try
    Cmd.CommandType := TDBXCommandTypes.DbxMetaData;
    Cmd.Text := CommandStr;
    DbgLog('  [DEBUG] Executing DbxMetaData: "' + CommandStr + '"');

    Reader := Cmd.ExecuteQuery;
    if Reader <> nil then
    begin
      try
        DbgLog('  [DEBUG] Reader ColumnCount: ' + IntToStr(Reader.ColumnCount));

        MemTable := TDBXMemoryTable.Create;
        MemTable.DBXTableName := CollectionName;
        MemTable.Columns := TargetColumns;

        FetchedCount := 0;
        while Reader.Next do
        begin
          Inc(FetchedCount);
          MemTable.Insert;

          // 依目標欄位名稱進行映射填充
          for I := 0 to Length(TargetColumns) - 1 do
          begin
            ColName := TargetColumns[I].Name;
            SrcOrd := Reader.GetOrdinal(ColName);

            // 若目標是 ViewName，但來源是 TableName，進行名稱容錯
            if (SrcOrd < 0) and SameText(ColName, 'ViewName') then
              SrcOrd := Reader.GetOrdinal('TableName');

            // 若依名稱找不到，且索引在來源範圍內，則依索引對齊
            if (SrcOrd < 0) and (I < Reader.ColumnCount) then
              SrcOrd := I;

            if (SrcOrd >= 0) and (not Reader.Value[SrcOrd].IsNull) then
              MemTable.Value[I].SetValue(Reader.Value[SrcOrd])
            else
              MemTable.Value[I].SetNull;
          end;
          MemTable.Post;
        end;

        DbgLog('  [DEBUG] Reader rows fetched: ' + IntToStr(FetchedCount));
        MemTable.First; // 重置游標至第 1 筆
        Result := MemTable;
      finally
        Reader.Free;
      end;
    end;
  finally
    Cmd.Free;
  end;
end;

function TDBXOpenOdbcMetaDataReader.FetchCatalogs: TDBXTable;
begin
  Result := ExecuteMetadataCommand(TDBXMetaDataCommands.GetCatalogs,
    TDBXMetaDataCollectionName.Catalogs, TDBXMetaDataCollectionColumns.CreateCatalogsColumns);
end;

function TDBXOpenOdbcMetaDataReader.FetchSchemas(const Catalog: string): TDBXTable;
begin
  Result := ExecuteMetadataCommand(TDBXMetaDataCommands.GetSchemas + ' ' + Catalog,
    TDBXMetaDataCollectionName.Schemas, TDBXMetaDataCollectionColumns.CreateSchemasColumns);
end;

function TDBXOpenOdbcMetaDataReader.FetchTables(const Catalog, Schema, TableName, TableType: string): TDBXTable;
var
  Cmd: string;
begin
  Cmd := TDBXMetaDataCommands.GetTables;
  // 若有指定 TableName，才帶入 TableName
  if TableName <> '' then
    Cmd := Cmd + ' ' + TableName;

  Result := ExecuteMetadataCommand(Cmd,
    TDBXMetaDataCollectionName.Tables, TDBXMetaDataCollectionColumns.CreateTablesColumns);
end;

function TDBXOpenOdbcMetaDataReader.FetchViews(const Catalog, Schema, View: string): TDBXTable;
var
  Cmd: string;
begin
  Cmd := TDBXMetaDataCommands.GetViews;
  if View <> '' then
    Cmd := Cmd + ' ' + View;

  // 使用 CreateViewsColumns，官方定義欄位為 CatalogName, SchemaName, ViewName, ViewDefinition
  Result := ExecuteMetadataCommand(Cmd,
    TDBXMetaDataCollectionName.Views, TDBXMetaDataCollectionColumns.CreateViewsColumns);
end;

function TDBXOpenOdbcMetaDataReader.FetchProcedures(const Catalog, Schema, ProcedureName, ProcedureType: string): TDBXTable;
var
  Cmd: string;
begin
  Cmd := TDBXMetaDataCommands.GetProcedures;
  if ProcedureName <> '' then
    Cmd := Cmd + ' ' + ProcedureName
  else
    Cmd := Cmd + ' %';

  Result := ExecuteMetadataCommand(Cmd,
    TDBXMetaDataCollectionName.Procedures, TDBXMetaDataCollectionColumns.CreateProceduresColumns);
end;

function TDBXOpenOdbcMetaDataReader.FetchSynonyms(const Catalog, Schema, Synonym: string): TDBXTable;
var
  Cmd: string;
begin
  Cmd := TDBXMetaDataCommands.GetSynonyms;
  if (Catalog <> '') or (Schema <> '') or (Synonym <> '') then
    Cmd := Cmd + ' ' + Catalog + '.' + Schema + '.' + Synonym;

  Result := ExecuteMetadataCommand(Cmd,
    TDBXMetaDataCollectionName.Synonyms, TDBXMetaDataCollectionColumns.CreateSynonymsColumns);
end;

function TDBXOpenOdbcMetaDataReader.FetchColumns(const Catalog, Schema, Table: string): TDBXTable;
var
  Cmd: string;
begin
  Cmd := TDBXMetaDataCommands.GetColumns;
  if (Catalog <> '') or (Schema <> '') or (Table <> '') then
    Cmd := Cmd + ' ' + Catalog + '.' + Schema + '.' + Table;

  Result := ExecuteMetadataCommand(Cmd,
    TDBXMetaDataCollectionName.Columns, TDBXMetaDataCollectionColumns.CreateColumnsColumns);
end;

function TDBXOpenOdbcMetaDataReader.FetchIndexes(const Catalog, Schema, Table: string): TDBXTable;
var
  Cmd: string;
begin
  Cmd := TDBXMetaDataCommands.GetIndexes;
  if (Catalog <> '') or (Schema <> '') or (Table <> '') then
    Cmd := Cmd + ' ' + Catalog + '.' + Schema + '.' + Table;

  Result := ExecuteMetadataCommand(Cmd,
    TDBXMetaDataCollectionName.Indexes, TDBXMetaDataCollectionColumns.CreateIndexesColumns);
end;

function TDBXOpenOdbcMetaDataReader.FetchIndexColumns(const Catalog, Schema, Table, Index: string): TDBXTable;
var
  Cmd: string;
begin
  Cmd := TDBXMetaDataCommands.GetIndexColumns;
  if (Catalog <> '') or (Schema <> '') or (Table <> '') then
    Cmd := Cmd + ' ' + Catalog + '.' + Schema + '.' + Table;
  if Index <> '' then
    Cmd := Cmd + ' ' + Index;

  Result := ExecuteMetadataCommand(Cmd,
    TDBXMetaDataCollectionName.IndexColumns, TDBXMetaDataCollectionColumns.CreateIndexColumnsColumns);
end;

function TDBXOpenOdbcMetaDataReader.FetchForeignKeys(const Catalog, Schema, Table: string): TDBXTable;
var
  Cmd: string;
begin
  Cmd := TDBXMetaDataCommands.GetForeignKeys;
  if (Catalog <> '') or (Schema <> '') or (Table <> '') then
    Cmd := Cmd + ' ' + Catalog + '.' + Schema + '.' + Table;

  Result := ExecuteMetadataCommand(Cmd,
    TDBXMetaDataCollectionName.ForeignKeys, TDBXMetaDataCollectionColumns.CreateForeignKeysColumns);
end;

function TDBXOpenOdbcMetaDataReader.FetchForeignKeyColumns(const Catalog, Schema, Table,
  ForeignKeyName, PrimaryCatalog, PrimarySchema, PrimaryTable, PrimaryKeyName: string): TDBXTable;
var
  Cmd: string;
begin
  Cmd := TDBXMetaDataCommands.GetForeignKeyColumns;
  if (Catalog <> '') or (Schema <> '') or (Table <> '') then
    Cmd := Cmd + ' ' + Catalog + '.' + Schema + '.' + Table;
  if ForeignKeyName <> '' then
    Cmd := Cmd + ' ' + ForeignKeyName;

  Result := ExecuteMetadataCommand(Cmd,
    TDBXMetaDataCollectionName.ForeignKeyColumns, TDBXMetaDataCollectionColumns.CreateForeignKeyColumnsColumns);
end;

function TDBXOpenOdbcMetaDataReader.FetchProcedureParameters(const Catalog, Schema, Proc, Parameter: string): TDBXTable;
var
  Cmd: string;
begin
  Cmd := TDBXMetaDataCommands.GetProcedureParameters;
  if (Catalog <> '') or (Schema <> '') or (Proc <> '') then
    Cmd := Cmd + ' ' + Catalog + '.' + Schema + '.' + Proc;
  if Parameter <> '' then
    Cmd := Cmd + ' ' + Parameter;

  Result := ExecuteMetadataCommand(Cmd,
    TDBXMetaDataCollectionName.ProcedureParameters, TDBXMetaDataCollectionColumns.CreateProcedureParametersColumns);
end;

initialization
  // 在套件載入時向工廠註冊 Microsoft SQL Server 寫入器
  TDBXMetaDataWriterFactory.RegisterWriter('Microsoft SQL Server', TDBXOpenOdbcMetaDataWriter);

finalization
  TDBXMetaDataWriterFactory.UnRegisterWriter('Microsoft SQL Server', TDBXOpenOdbcMetaDataWriter);

end.
