//
// search:  DBX*MetaDataReader.pas
//

interface

//
// {%T%}
//

type
  TDBXOpenODBCMetaDataCommandFactory{%T%} = class(TDBXOpenODBCMetaDataCommandFactoryCustom)
  protected
    class function GetMetaDataReaderClass: TDBXOpenODBCMetaDataReaderClass; override;
  end;

  TDBXOpenODBCMetaDataReader{%T%} = class(TDBXOpenODBCMetaDataReader)
  protected
    function GetProductName: UnicodeString; override;
    function GetSqlForTables: UnicodeString; override;
    function GetSqlForColumns: UnicodeString; override;
    function GetSqlForIndexes: UnicodeString; override;
    function GetSqlForIndexColumns: UnicodeString; override;
    function GetReservedWords: TDBXStringArray; override;
    //
    (*function GetSqlIdentifierQuotePrefix: UnicodeString; override;
    function GetSqlIdentifierQuoteSuffix: UnicodeString; override;
    function GetTableType: UnicodeString; override;
    function GetViewType: UnicodeString; override;
    function GetSystemTableType: UnicodeString; override;
    function GetSystemViewType: UnicodeString; override;
    function GetSynonymType: UnicodeString; override;
    function IsLowerCaseIdentifiersSupported: Boolean; override;
    function IsUpperCaseIdentifiersSupported: Boolean; override;
    function IsQuotedIdentifiersSupported: Boolean; override;
    function IsDescendingIndexSupported: Boolean; override;
    function IsDescendingIndexColumnsSupported: Boolean; override;
    function GetSqlIdentifierQuoteChar: UnicodeString; override;
    function GetSqlProcedureQuoteChar: UnicodeString; override;
    function IsMultipleCommandsSupported: Boolean; override;
    function IsTransactionsSupported: Boolean; override;
    function IsNestedTransactionsSupported: Boolean; override;
    function IsSetRowSizeSupported: Boolean;  override;
    //function GetDataTypeDescriptions: TDBXDataTypeDescriptionArray; override;
    //*)
  end;

implementation

//
// {%T%}
//

{ TDBXOpenODBCMetaDataCommandFactory{%T%} }

class function TDBXOpenODBCMetaDataCommandFactory{%T%}.GetMetaDataReaderClass: TDBXOpenODBCMetaDataReaderClass;
begin
  Result := TDBXOpenODBCMetaDataReader{%T%};
end;

{ TDBXOpenODBCMetaDataReader{%T%} }

function TDBXOpenODBCMetaDataReader{%T%}.GetProductName: UnicodeString;
begin {Result := ''; Exit; {@dbg}
  Result := '';
end;

function TDBXOpenODBCMetaDataReader{%T%}.GetSqlForTables: UnicodeString;
begin {Result := ''; Exit; {@dbg}
  Result := '';
end;

function TDBXOpenODBCMetaDataReader{%T%}.GetSqlForColumns: UnicodeString;
begin {Result := ''; Exit; {@dbg}
  Result := '';
end;

function TDBXOpenODBCMetaDataReader{%T%}.GetSqlForIndexes: UnicodeString;
begin {Result := ''; Exit; {@dbg}
  Result := '';
end;

function TDBXOpenODBCMetaDataReader{%T%}.GetSqlForIndexColumns: UnicodeString;
begin {Result := ''; Exit; {@dbg}
  Result := '';
end;

function TDBXOpenODBCMetaDataReader{%T%}.GetReservedWords: TDBXStringArray;
var
  Words: TDBXStringArray;
begin {Result := nil; Exit; {@dbg}
  Result := nil;
  {SetLength(Words, 1);
  Words[0] := 'SELECT';
  Result := Words;{}
end;

(*function TDBXOpenODBCMetaDataReader{%T%}.GetSqlIdentifierQuotePrefix: UnicodeString;
begin {Result := ''; Exit; {@dbg}
  inherited;
end;

function TDBXOpenODBCMetaDataReader{%T%}.GetSqlIdentifierQuoteSuffix: UnicodeString;
begin {Result := ''; Exit; {@dbg}
  inherited;
end;

function TDBXOpenODBCMetaDataReader{%T%}.GetTableType: UnicodeString;
begin {inherited; Exit; {@dbg}
  if not fDbxMode then
    Result := 'TABLE'
  else
    Result := inherited GetTableType;
end;

function TDBXOpenODBCMetaDataReader{%T%}.GetViewType: UnicodeString;
begin {inherited; Exit; {@dbg}
  if not fDbxMode then
    Result := 'VIEW'
  else
    Result := inherited GetViewType;
end;

function TDBXOpenODBCMetaDataReader{%T%}.GetSystemTableType: UnicodeString;
begin {inherited; Exit; {@dbg}
  if not fDbxMode then
    Result := 'SYSTEM TABLE'
  else
    Result := inherited GetSystemTableType;
end;

function TDBXOpenODBCMetaDataReader{%T%}.GetSystemViewType: UnicodeString;
begin {inherited; Exit; {@dbg}
  if not fDbxMode then
    Result := 'SYSTEM VIEW'
  else
    Result := inherited GetSystemViewType;
end;

function TDBXOpenODBCMetaDataReader{%T%}.GetSynonymType: UnicodeString;
begin {inherited; Exit; {@dbg}
  if not fDbxMode then
    Result := 'SYNONUM'
  else
    Result := inherited GetSynonymType;
end;

function TDBXOpenODBCMetaDataReader{%T%}.IsLowerCaseIdentifiersSupported: Boolean;
begin {Result := True; Exit; {@dbg}
  Result := True;
end;

function TDBXOpenODBCMetaDataReader{%T%}.IsUpperCaseIdentifiersSupported: Boolean;
begin {Result := True; Exit; {@dbg}
  inherited;
end;

function TDBXOpenODBCMetaDataReader{%T%}.IsQuotedIdentifiersSupported: Boolean;
begin {Result := True; Exit; {@dbg}
  inherited;
end;

function TDBXOpenODBCMetaDataReader{%T%}.IsDescendingIndexSupported: Boolean;
begin {Result := True; Exit; {@dbg}
  inherited;
end;

function TDBXOpenODBCMetaDataReader{%T%}.IsDescendingIndexColumnsSupported: Boolean;
begin {Result := True; Exit; {@dbg}
  inherited;
end;

function TDBXOpenODBCMetaDataReader{%T%}.GetSqlIdentifierQuoteChar: UnicodeString;
begin {Result := ''; Exit; {@dbg}
  inherited;
end;

function TDBXOpenODBCMetaDataReader{%T%}.GetSqlProcedureQuoteChar: UnicodeString;
begin {Result := ''; Exit; {@dbg}
  inherited;
end;

function TDBXOpenODBCMetaDataReader{%T%}.IsMultipleCommandsSupported: Boolean;
begin {Result := True; Exit; {@dbg}
  inherited;
end;

function TDBXOpenODBCMetaDataReader{%T%}.IsTransactionsSupported: Boolean;
begin {Result := True; Exit; {@dbg}
  inherited;
end;

function TDBXOpenODBCMetaDataReader{%T%}.IsNestedTransactionsSupported: Boolean;
begin {Result := False; Exit; {@dbg}
  Result := False;
end;

function TDBXOpenODBCMetaDataReader{%T%}.IsSetRowSizeSupported: Boolean;
begin {Result := True; Exit; {@dbg}
  Result := True;
end;

//function TDBXOpenODBCMetaDataReader{%T%}.GetDataTypeDescriptions: TDBXDataTypeDescriptionArray;
//begin
// ...
//end;
//*)

initialization
//
// {%T%}
//
  TDBXOpenODBCMetaDataCommandFactory{%T%}.RegisterMetaDataCommandFactory;
finalization
//
// {%T%}
//
  TDBXOpenODBCMetaDataCommandFactory{%T%}.UnRegisterMetaDataCommandFactory;
