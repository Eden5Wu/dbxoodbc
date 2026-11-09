# Delphi Data Access Benchmark Suite

This directory contains the automated benchmark project used to produce the **Delphi Data Access Benchmark Report (2026 Edition)**.

## Evaluated Engines

The benchmark tests 5 major Delphi data access engines connecting to Microsoft SQL Server:
1. **DBXOODBC** (DbxOpenOdbc v4.2026, DBX4 Native)
2. **FireDAC** (`FireDAC.Phys.MSSQL`, Microsoft ODBC Driver 17/18)
3. **ADO / dbGo** (`Data.Win.ADODB`, OLE DB)
4. **EMBT DBX SNC** (Embarcadero Native DBX MSSQL, SQL Native Client 11)
5. **EMBT DBX ODBC** (Embarcadero Official Generic DBX ODBC, `Data.DBXOdbc`)

---

## How to Build and Run

### 1. Requirements
- Embarcadero Delphi 10.x / 11.x / 12.x (Enterprise edition recommended to compile FireDAC & DBX drivers)
- Microsoft ODBC Driver 17 or 18 for SQL Server
- A reachable Microsoft SQL Server instance

### 2. Configuration
Copy `bench_config.example.ini` to `bench_config.ini` in the same directory:
```bash
copy bench_config.example.ini bench_config.ini
```
Edit `bench_config.ini` with your database credentials. `bench_config.ini` is ignored by Git and will never be committed.

### 3. Compilation
Compile via command line using `dcc32` or open `BenchDataEngines.dpr` in the RAD Studio IDE:
```cmd
call "D:\RADStudio\22.0\bin\rsvars.bat"
dcc32.exe -Q -B -I"..\source" -U"..\source" BenchDataEngines.dpr
```

### 4. Execution
```cmd
BenchDataEngines.exe
```

If specific enterprise tables are not configured or do not exist in the target database, Scenarios 2–5 will be skipped gracefully while Scenario 1 (Synthetic Scalar) will always run.

