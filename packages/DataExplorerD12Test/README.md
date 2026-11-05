# DbxOpenOdbc Delphi 12 Data Explorer Regression Test Suite

This directory contains the completed and verified functional regression test suite for **DbxOpenOdbc Native DBX4 Driver** on **Delphi 12 Community Edition (CE)** and **Professional / Enterprise / Architect** editions.

## Background

On Delphi 12 Community Edition and Professional editions, official enterprise metadata DCUs (such as `Data.DBXMSSQLMetaData.dcu`) are not provided by Embarcadero. When connecting to Microsoft SQL Server via Data Explorer, the IDE previously raised:
```text
Cannot load metadata for microsoft sql server. add driver unit to your uses (dbxinterbase or dbxdb2 or dbxmssql...)
```

This regression test package verifies the custom metadata adapter (`DbxOpenOdbcDataExplorerMetadata.pas`) that resolves this issue without relying on official enterprise units or modifying the core driver runtime.

## Validated Capabilities

The following test stages have been validated:
1. **Console Functional Tests**: Verified direct DBX command execution.
2. **Standalone BPL Dynamic Loading**: `DataExplorerBplLoaderTest.exe` links only to runtime packages (`rtl`, `dbrtl`, `dbexpress`), dynamically loads `DbxOpenOdbcDataExplorerD12Test290.bpl` via `LoadPackage`, and verifies registration in `TClassRegistry`.
3. **Metadata Provider Collections**: Verified collection fetching:
   - `GetTables`: 65 records fetched with Schema, TableName, and TableType.
   - `GetViews`: 1 record (`v_CustomerOrders`) with `ViewName` mapped.
   - `GetColumns`: 8 columns for sample table `biolife` with type and precision metadata.
   - `GetProcedures`: 2 records (`fn_GetCustomerCount`, `sp_GetCustomerOrders`).
4. **Delphi 12 IDE Data Explorer**: Fully expands `Tables`, `Views`, and `Procedures` nodes in the RAD Studio Data Explorer window without exceptions.

## Key Technical Findings

1. **Quoted Identifiers**: Data Explorer wraps table names in double quotes (`dbo."biolife"`) via `TDBXMetaDataProvider.QuoteIdentifierIfNeeded`. Because `TDBXBaseMetaDataReader.IsLowerCaseIdentifiersSupported` defaults to `False` in dbExpress, lowercase/mixed-case names are identified as non-standard SQL identifiers and protected with `SqlIdentifierQuoteChar` (`"`).
2. **Case-Insensitive Alphabetical Sorting**: Verified in official Delphi source code [`Data.SqlExpr.pas` L3174-L3185](file:///D:/RADStudio/22.0/source/data/dbx/Data.SqlExpr.pas#L3174-L3185). `TSQLConnection.OpenSchema` loads schema records into a `TStringList` (`ISList`) and explicitly configures:
   ```pascal
   ISList.CaseSensitive := False;
   ISList.Duplicates := dupIgnore;
   ISList.Sorted := True;
   ```
   Combined with the driver's underlying `ORDER BY s.name, o.name`, this guarantees consistent A-Z dictionary sorting in Data Explorer.
3. **BPL Lifecycle in IDE**: `TDBXMetaDataWriterFactory.UnRegisterWriter` removes the class from `TClassRegistry` but leaves the dialect key in the private dictionary `FProviderRegistry` (Delphi RTL bug). Packages should remain loaded for the duration of the IDE session rather than being repeatedly dynamically unloaded and reloaded.

## Directory Structure

| File | Purpose |
|---|---|
| `DbxOpenOdbcDataExplorerMetadata.pas` | Custom metadata reader and writer adapter registering `'Microsoft SQL Server'` |
| `DbxOpenOdbcDataExplorerD12Test.dpk` | Test package definition (`{$LIBSUFFIX '290'}`) |
| `DbxOpenOdbcDataExplorerD12Test.dproj` | Test package MSBuild project |
| `DbxOpenOdbcDataExplorerD12Test.res` | Package resource file |
| `DataExplorerBplLoaderTest.dpr` | Standalone loader test program (dynamic `LoadPackage` validation) |
| `DataExplorerBplLoaderTest.dproj` | Loader test project configured with `<UsePackages>true</UsePackages>` |
| `BuildAndRunTest.ps1` | PowerShell build and test automation script |
| `BuildAndRunTest.bat` | Command-line one-click execution wrapper |

## Running the Regression Tests

### Prerequisites
- Delphi 12 (Athens) Community Edition, Professional, Enterprise, or Architect (Win32 target).
- Microsoft SQL Server with sample database (e.g. `DBDEMOS`).

### Option A: Command Prompt (One-Click)
```cmd
cd /d packages\DataExplorerD12Test
set DBXOODBC_TEST_CONN=Driver={ODBC Driver 17 for SQL Server};Server=127.0.0.1;Database=DBDEMOS;Trusted_Connection=yes;
BuildAndRunTest.bat
```

### Option B: Delphi IDE
1. Open `DbxOpenOdbcDataExplorerD12Test.dproj` in RAD Studio, select `Win32` + `Release`, and press **Shift + F9** (Build).
2. Open `DataExplorerBplLoaderTest.dproj`, select `Win32` + `Release`, and press **Shift + F9** (Build).
3. Run `bin\Win32\Release\DataExplorerBplLoaderTest.exe` with connection string arguments.

