# DBX4 Remastered (dbxoodbc)

Pure Native Delphi dbExpress (DBX4) Driver for ODBC (Win32 & Win64)

[繁體中文說明文件](README_TW.md)

---

## Project Information

- **Driver Name**: `DbxOpenOdbc` (or `OpenOdbc`)
- **Version**: `4.2026.11.05` (DBX4 Remastered)
- **Architecture**: 100% Pure Pascal Native DBX4 (`Data.DBXCommon`)
- **Target OS**: Windows 32-bit (Win32) & 64-bit (Win64)
- **Supported Delphi Versions**: RAD Studio 2010, XE to 12 Athens, 13+
- **Original Project & Authors**: [Open DbExpress (SourceForge)](http://sourceforge.net/projects/open-dbexpress/) by Edward Benson, Vadim V. Lopushansky (2001-2012)
- **Remastered By**: Eden Wu (2019-2026) — Native DBX4 Architecture Refactoring
- **License**: GNU Lesser General Public License (LGPL) 2.1 or later
- **Repository**: [https://github.com/Eden5Wu/dbxoodbc](https://github.com/Eden5Wu/dbxoodbc)

---

## 1. Introduction for First-Time Engineers

**DBX4 Remastered** is a modern, lightweight, high-performance Delphi dbExpress (DBX4) driver for ODBC. 

If you are maintaining or modernizing Delphi database applications (such as ERP, MES, POS, or financial systems), this driver is designed to give you **instant, zero-friction database connectivity**:

### Why Choose DBX4 Remastered?
- **Zero External DLL Deployment**: No `dbxoodbc.dll`, `dbxadapter30.dll`, or third-party wrappers required. It talks directly to the standard Windows OS ODBC manager (`odbc32.dll`), which exists on every Windows machine.
- **Zero BPL Package Requirement**: You do **not** need to install any IDE packages (`.bpl`) to compile or deploy your application. Simply add the 3 source files to your project.
- **Dual Win32 & Win64 Support**: Compile seamlessly for both 32-bit and 64-bit Windows targets with the exact same codebase.
- **Drop-in ADO/OLE DB Replacement**: If you are migrating legacy ADO (`TADOConnection`) code to dbExpress, you can pass your existing ADO connection string directly. The driver translates it automatically.
- **Automatic Driver Detection & Modern Security**: Auto-detects and binds to the newest installed SQL Server ODBC driver on the client PC (ODBC Driver 18, 17, 13, 11, or SQL Native Client), with automatic SSL trust handling (`TrustServerCertificate=yes`) and fast TCP/IP.

---

## 2. Quick Start (Get Connected in 30 Seconds)

### Step 1: Add Source to Your Project
Add the `source/` folder to your project's **Search Path** (or directly include the 3 source files in your project):
- `source/OdbcApi.pas`
- `source/DbxOpenOdbcCore.pas`
- `source/DbxOpenOdbcDriver.pas`

### Step 2: Use the Driver Unit
In your form or DataModule unit, add `DbxOpenOdbcDriver` to the `uses` clause:

```delphi
uses
  Data.DB, Data.SqlExpr, DbxOpenOdbcDriver;
```

### Step 3: Configure TSQLConnection and Open

```delphi
procedure TForm1.ConnectDatabase;
var
  SQLConn: TSQLConnection;
  Query: TSQLQuery;
begin
  SQLConn := TSQLConnection.Create(nil);
  try
    SQLConn.DriverName := 'DbxOpenOdbc';
    SQLConn.GetDriverFunc := 'getSQLDriverODBCW';
    SQLConn.LibraryName := 'DbxOpenOdbcDriver';
    SQLConn.VendorLib := 'ODBC32.DLL';
    SQLConn.LoginPrompt := False;

    // Option A: Native ODBC Connection String
    SQLConn.Params.Values['ConnectionString'] :=
      'Driver={ODBC Driver 17 for SQL Server};Server=127.0.0.1;Database=ADBDEMOS;Uid=sa;Pwd=secret;';

    // Option B: ADO / OLE DB Connection String (Auto-translated!)
    // SQLConn.Params.Values['Database'] :=
    //   'Provider=SQLOLEDB;Data Source=127.0.0.1;Initial Catalog=ADBDEMOS;User ID=sa;Password=secret;';

    SQLConn.Open;

    // Execute query with standard TSQLQuery
    Query := TSQLQuery.Create(nil);
    try
      Query.SQLConnection := SQLConn;
      Query.SQL.Text := 'SELECT TOP 10 CustNo, Company FROM Customer';
      Query.Open;
      while not Query.Eof do
      begin
        Writeln(Query.FieldByName('Company').AsString);
        Query.Next;
      end;
    finally
      Query.Free;
    end;
  finally
    SQLConn.Free;
  end;
end;
```

---

## 3. Connection Strings & Smart Translation

### 3.1 Parameter Entry Points (Priority Order)
The driver inspects `TSQLConnection.Params` in the following priority order:
1. `SQLConnection.Params.Values['ConnectionString']` *(Recommended modern entry)*
2. `SQLConnection.Params.Values['Database']` *(Standard DBX fallback; also accepts full connection strings)*
3. `SQLConnection.Params.Values['Custom String']` *(Legacy 3.x compatibility)*

> **Note**: If `Database` or `Custom String` contains a full connection string (e.g. starts with `Provider=` or `Driver=`), it takes precedence, allowing legacy projects to work without modifying property names.

### 3.2 Automatic ADO/OLE DB Translation
You can directly pass an ADO connection string; the built-in translator maps parameters on the fly:

| ADO / OLE DB Keyword | Translated Native ODBC Equivalent | Purpose / Notes |
| :--- | :--- | :--- |
| `Provider=SQLOLEDB / MSOLEDBSQL / SQLNCLI...` | `Driver={Best Installed SQL Driver}` | Auto-detects newest installed modern driver |
| `Data Source=...` / `Address=...` | `Server=...` | Server host or IP and port |
| `Initial Catalog=...` | `Database=...` | Database name |
| `User ID=...` | `Uid=...` | Login username |
| `Password=...` | `Pwd=...` | Login password |
| `Integrated Security=SSPI` | `Trusted_Connection=yes` | Windows Integrated Authentication |
| `Application Name=...` / `Application_Name=...` | `APP=...` | Visible in SQL Server Profiler (`ApplicationName`) |
| `Workstation ID=...` | `WSID=...` | Visible in SQL Server Profiler (`HostName`) |

---

## 4. Extended Features & Driver Parameters

You can configure extended parameters either as **independent properties** in `SQLConnection.Params` or **embedded within the connection string**.

### 4.1 `TrimFixedChar` (Auto-Trim Fixed-Length Strings)
- **Description**: Automatically discards trailing spaces from fixed-length character columns (`CHAR`, `NCHAR`, and `ftFixedChar`).
- **Default**: `True`
- **Why You Need It**: SQL Server pads `CHAR(10)` with spaces (e.g., `'ABC       '`). Without trimming, Delphi string comparisons like `Field.AsString = 'ABC'` evaluate to `False`. Enabling this strips trailing whitespace so you don't have to call `Trim()` manually across your codebase.
- **Aliases**: `Trim Char`, `TrimChar`, `Trim Fixed Char`
- **Usage**:
  ```delphi
  SQLConnection1.Params.Values['TrimFixedChar'] := 'True'; // or 'False' to preserve spaces
  ```

### 4.2 `TrimVarChar` (Trim Variable-Length Strings)
- **Description**: Optionally discards trailing spaces from variable-length character columns (`VARCHAR`, `NVARCHAR`).
- **Default**: `False`
- **Why You Need It**: Variable-length strings do not have trailing spaces unless intentionally stored by users. Kept `False` by default to preserve whitespace formatting; set to `True` if dealing with legacy databases containing padded varchar data.
- **Aliases**: `Trim Var Char`
- **Usage**:
  ```delphi
  SQLConnection1.Params.Values['TrimVarChar'] := 'True';
  ```

### 4.3 `UseUnicode`
- **Description**: Enables or disables Unicode field mapping for character columns (`NCHAR`, `NVARCHAR`, `NTEXT`).
- **Default**: `True`
- **Options**:
  - `UseUnicode=True`:
    - `nchar` / `nvarchar` are mapped to `ftWideString` (`TWideStringField`).
    - `ntext` / `nvarchar(max)` are mapped to `ftWideMemo` (`TWideMemoField`).
  - `UseUnicode=False`:
    - `nchar` is mapped to `ftFixedChar` (`TStringField`).
    - `nvarchar` is mapped to `ftString` (`TStringField`).
    - `ntext` / `nvarchar(max)` are mapped to `ftMemo` (`TMemoField`).
    - Avoids `Type mismatch: expecting String actual WideString` errors on existing `.dfm` forms with persistent `TStringField` or `TMemoField` definitions.

- **Usage**:
  ```delphi
  SQLConnection1.Params.Values['UseUnicode'] := 'True';  // or 'False'
  ```

### 4.4 `MARS_Connection` (Multiple Active Result Sets)
- **Description**: Enables Multiple Active Result Sets for SQL Server connections.
- **Default**: Auto-enabled for SQL Server (`MARS_Connection=yes`)
- **Why You Need It**: In standard ODBC, an open query or unexhausted reader locks the connection, causing `[HY000] Connection is busy with results for another command` when attempting another query. With MARS enabled, multiple `TSQLQuery` datasets can be active and fetched concurrently on a single connection.

### 4.5 SQL Server Profiler & Telemetry Tracking
- **`APP` / `Application Name`**: Directly tags connection sessions in SQL Server Profiler (`ApplicationName` column) and `sys.dm_exec_sessions (program_name)`.
- **`WSID` / `Workstation ID`**: Directly tags connection sessions with client workstation names in SQL Server Profiler (`HostName` column).
- **Usage**:
  ```delphi
  SQLConnection1.Params.Values['ConnectionString'] := 
    'Driver={ODBC Driver 17 for SQL Server};Server=...;Database=...;APP=ERP_OrderSystem;WSID=PC_SALES01;';
  ```

---

## 5. SQL Server Data Type Mapping Reference

The driver maps SQL Server types to Delphi DBX4 types (`TDBXDataTypes`) and standard VCL `TField` classes as follows:

| SQL Server Type | Delphi Field Type (`TFieldType`) | VCL Field Class (`TField`) | Notes |
| :--- | :--- | :--- | :--- |
| **int** | `ftInteger` | `TIntegerField` | 32-bit integer |
| **bigint** | `ftLargeint` | `TLargeIntField` | Native 64-bit integer |
| **smallint** | `ftInteger` | `TIntegerField` | Promoted to 32-bit integer |
| **tinyint** | `ftSmallint` | `TSmallIntField` | 16-bit small integer |
| **bit** | `ftBoolean` | `TBooleanField` | Boolean |
| **decimal / numeric** | `ftFMTBcd` | `TFMTBCDField` | High-precision BCD arithmetic |
| **money / smallmoney** | `ftFMTBcd` | `TFMTBCDField` | Currency BCD representation |
| **float** | `ftFloat` | `TFloatField` | 64-bit double precision float |
| **real** | `ftSingle` | `TSingleField` | 32-bit single precision float |
| **datetime / smalldatetime** | `ftTimeStamp` | `TSQLTimeStampField` | Full date & millisecond timestamp |
| **date** | `ftDate` | `TDateField` | Date only |
| **time** | `ftTime` | `TTimeField` | Time only |
| **datetimeoffset** | `ftTimeStampOffset` | `TSQLTimeStampOffsetField` | Time zone offset support |
| **char** | `ftString` | `TStringField` | `FixedChar=True`; trimmed if `TrimFixedChar=True` |
| **varchar** | `ftString` | `TStringField` | Standard variable-length string |
| **text** | `ftMemo` | `TMemoField` | ANSI memo blob |
| **nchar** | `ftWideString` / `ftString` | `TWideStringField` / `TStringField` | Controlled by `UseUnicode` |
| **nvarchar** | `ftWideString` / `ftString` | `TWideStringField` / `TStringField` | Controlled by `UseUnicode` |
| **ntext** | `ftWideMemo` / `ftMemo` | `TWideMemoField` / `TMemoField` | Controlled by `UseUnicode` |
| **nvarchar(max)** | `ftWideMemo` | `TWideMemoField` | Streaming Unicode text blob |
| **binary** | `ftBytes` | `TBytesField` | Fixed-length byte buffer |
| **varbinary** | `ftVarBytes` | `TVarBytesField` | Variable-length byte buffer (size <= 8000) |
| **varbinary(max) / image** | `ftBlob` | `TBlobField` | Binary stream blob |
| **timestamp / rowversion** | `ftBytes` | `TBytesField` (Size = 8) | 8-byte row version |
| **uniqueidentifier** | `ftString` | `TStringField` (Size = 38) | GUID string representation |
| **sql_variant** | `ftString` | `TStringField` | Generic variant string |

---

## 6. Advanced Usage

### 6.1 Low-Level TDBXCommand & Parameterized Queries
You can use native `TDBXCommand` for maximum performance with standard `?` positional parameters:

```delphi
var
  Cmd: TDBXCommand;
  Reader: TDBXReader;
begin
  Cmd := SQLConn.DBXConnection.CreateCommand;
  try
    Cmd.CommandType := TDBXCommandTypes.DbxSQL;
    Cmd.Text := 'SELECT CustNo, Company FROM Customer WHERE Country = ? AND City = ?';

    // Prepare automatically queries parameter metadata
    Cmd.Prepare;
    Cmd.Parameters[0].Value.AsString := 'US';
    Cmd.Parameters[1].Value.AsString := 'New York';

    Reader := Cmd.ExecuteQuery;
    try
      while Reader.Next do
        Writeln(Format('%s: %s', [Reader.Values[0].AsString, Reader.Values[1].AsString]));
    finally
      Reader.Free;
    end;
  finally
    Cmd.Free;
  end;
end;
```

### 6.2 Multiple Result Sets (MRS) Batch Traversal
Process batch queries or stored procedures that return multiple result sets sequentially:

```delphi
var
  Cmd: TDBXCommand;
  Reader: TDBXReader;
  SetIndex: Integer;
begin
  Cmd := SQLConn.DBXConnection.CreateCommand;
  try
    Cmd.Text := 'SELECT 1 AS n; SELECT 2 AS n; SELECT 3 AS n;';
    Reader := Cmd.ExecuteQuery;
    SetIndex := 1;

    while Reader <> nil do
    begin
      try
        while Reader.Next do
          Writeln(Format('Result Set %d: value = %s', [SetIndex, Reader.Values[0].AsString]));
      finally
        Reader.Free;
      end;
      Reader := Cmd.GetNextReader; // Advances to next result set
      Inc(SetIndex);
    end;
  finally
    Cmd.Free;
  end;
end;
```

---

## 7. Troubleshooting & FAQ

#### Q1: Why do my `CHAR` fields have trailing spaces?
- **Answer**: By default, `TrimFixedChar` is enabled (`True`). If your connection overrides it with `TrimFixedChar=False`, trailing spaces are kept. Ensure `SQLConn.Params.Values['TrimFixedChar'] := 'True';` is set.

#### Q2: My existing form crashes with `Type mismatch: expecting String actual WideString`!
- **Answer**: Your `.dfm` has persistent `TStringField` definitions. Set `SQLConn.Params.Values['UseUnicode'] := 'False';`. The driver will map `nchar`/`nvarchar` columns to `TStringField` and `ntext` to `TMemoField`.

#### Q3: Why does `ODBC Driver 18 for SQL Server` report SSL certificate errors?
- **Answer**: Microsoft introduced mandatory SSL encryption in ODBC Driver 18+. DBX4 Remastered automatically appends `TrustServerCertificate=yes;` if you haven't configured a formal SSL certificate, avoiding connection failures out of the box.

#### Q4: Do I need to install or register any BPL packages?
- **Answer**: **No.** Including the 3 source files in your project is 100% sufficient for all runtime applications. Optional BPL packages under `packages/DataExplorer/` are solely for viewing tables inside the IDE's Data Explorer window at design time.

---

## 8. Directory Layout

```text
dbxoodbc/
├── source/               # Pure Pascal DBX4 core driver source (No external DLL)
│   ├── DbxOpenOdbcDriver.pas  # Driver registration, TDBXDriver & TDBXConnection classes
│   ├── DbxOpenOdbcCore.pas    # Command, statement, parameter, metadata & cursor engine
│   └── OdbcApi.pas            # Direct Windows ODBC 3.x API bindings (odbc32.dll)
├── ini/                  # Optional IDE configuration templates
│   ├── dbxdrivers.ini         # Driver registration settings template
│   └── dbxconnections.ini     # Connection profiles template
├── packages/             # Optional IDE Data Explorer integration packages
│   └── DataExplorer/          # Runtime package project & build scripts
├── demos/                # Connection units & test demos
│   └── connections/           # Pre-built sample connection units
├── tests/                # Automated verification suites
│   ├── mvp_test/              # CLI / IDE test suite (validates DBX4 without DB)
│   └── runtime_test/          # Full regression suite against live SQL Server
├── ChangesLog.Txt        # Version change history
├── README.md             # English documentation
└── README_TW.md          # Traditional Chinese documentation
```
