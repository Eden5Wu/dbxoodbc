# ODBC Driver Capability Probing & Benchmark Suite

This directory contains standalone diagnostic and benchmarking utilities used to evaluate ODBC driver fetch behaviors and column binding optimizations.

## Tools Overview

1. **`ProbeOdbcDriverCaps.dpr`**
   - Probes live `SQL_GETDATA_EXTENSIONS` bitmask from the underlying driver using `SQLGetInfoW`.
   - Inspects support for `SQL_GD_ANY_COLUMN`, `SQL_GD_ANY_ORDER`, `SQL_GD_BLOCK`, and `SQL_GD_BOUND`.

2. **`TestOdbcOrderRestriction.dpr`**
   - Tests driver conformance regarding ordinal binding order:
     - Case 1: Bound column precedes unbound column (valid).
     - Case 2: Unbound column precedes bound column (`SQLState 24000: Invalid cursor state` on SQL Server).
     - Case 3: Out-of-order `SQLGetData` calls (`SQLState 07009: Invalid Descriptor Index`).

3. **`TestOdbcBoundTruncation.dpr`**
   - Tests whether truncated data on a bound column can be recovered via `SQLGetData`.
   - On Microsoft SQL Server ODBC driver, calling `SQLGetData` on an already bound column fails with `SQLState 07009` (`SQL_GD_BOUND = FALSE`).

4. **`BenchBindColComparison.dpr`**
   - Live performance comparison between `UseBindCol=0` (pure `SQLGetData`) and `UseBindCol=1` (contiguous bound-prefix `SQLBindCol`).
   - Measures:
     - Pure `TDBXReader` iteration throughput.
     - Full DataSnap VCL pipeline (`TSQLQuery` -> `TDataSetProvider` -> `TClientDataSet.Open`).
     - Field-by-field value integrity across all columns.

## How to Run

Set the `DBXOODBC_TEST_CONNECTION` environment variable or pass the connection string as a command-line argument:

```cmd
set DBXOODBC_TEST_CONNECTION=Driver={ODBC Driver 17 for SQL Server};Server=localhost;Database=TestDB;Trusted_Connection=yes;MARS_Connection=yes;

dcc32.exe -Q -B -U"..\..\source" BenchBindColComparison.dpr
BenchBindColComparison.exe
```
