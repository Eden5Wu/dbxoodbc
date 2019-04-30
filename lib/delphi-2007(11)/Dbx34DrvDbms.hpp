// CodeGear C++Builder
// Copyright (c) 1995, 2007 by CodeGear
// All rights reserved

// (DO NOT EDIT: machine generated header) 'Dbx34drvdbms.pas' rev: 11.00

#ifndef Dbx34drvdbmsHPP
#define Dbx34drvdbmsHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member functions
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <Sysinit.hpp>	// Pascal unit
#include <Windows.hpp>	// Pascal unit
#include <Sysutils.hpp>	// Pascal unit
#include <Classes.hpp>	// Pascal unit
#include <Dbxcommon.hpp>	// Pascal unit
#include <Widestrings.hpp>	// Pascal unit
#include <Dbxplatformutil.hpp>	// Pascal unit
#include <Dbxplatform.hpp>	// Pascal unit
#include <Dbxmetadatareader.hpp>	// Pascal unit
#include <Dbxmetadatanames.hpp>	// Pascal unit
#include <Dbx34drv.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Dbx34drvdbms
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TDBXOpenODBCMetaDataCommandFactoryOracle;
class PASCALIMPLEMENTATION TDBXOpenODBCMetaDataCommandFactoryOracle : public Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom 
{
	typedef Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom inherited;
	
protected:
	/* virtual class method */ virtual TMetaClass* __fastcall GetMetaDataReaderClass(TMetaClass* vmt);
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TDBXOpenODBCMetaDataCommandFactoryOracle(void) : Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TDBXOpenODBCMetaDataCommandFactoryOracle(void) { }
	#pragma option pop
	
};


class DELPHICLASS TDBXOpenODBCMetaDataReaderOracle;
class PASCALIMPLEMENTATION TDBXOpenODBCMetaDataReaderOracle : public Dbx34drv::TDBXOpenODBCMetaDataReader 
{
	typedef Dbx34drv::TDBXOpenODBCMetaDataReader inherited;
	
protected:
	virtual WideString __fastcall GetProductName();
	virtual WideString __fastcall GetSqlForSchemas();
	virtual WideString __fastcall GetSqlForTables();
	virtual WideString __fastcall GetSqlForColumns();
	virtual WideString __fastcall GetSqlForIndexes();
	virtual WideString __fastcall GetSqlForIndexColumns();
	virtual Dbxplatformutil::TDBXWideStringArray __fastcall GetReservedWords();
	virtual void __fastcall PopulateDataTypes(const Dbxplatformutil::TDBXObjectStore* Hash, const Dbxplatformutil::TDBXArrayList* Types, const Dbxmetadatareader::TDBXDataTypeDescriptionArray Descr);
	virtual Dbxmetadatareader::TDBXDataTypeDescriptionArray __fastcall GetDataTypeDescriptions();
public:
	#pragma option push -w-inl
	/* TDBXOpenODBCMetaDataReader.Create */ inline __fastcall virtual TDBXOpenODBCMetaDataReaderOracle(void) : Dbx34drv::TDBXOpenODBCMetaDataReader() { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TDBXBaseMetaDataReader.Destroy */ inline __fastcall virtual ~TDBXOpenODBCMetaDataReaderOracle(void) { }
	#pragma option pop
	
};


class DELPHICLASS TDBXOpenODBCMetaDataCommandFactoryMSSQL;
class PASCALIMPLEMENTATION TDBXOpenODBCMetaDataCommandFactoryMSSQL : public Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom 
{
	typedef Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom inherited;
	
protected:
	/* virtual class method */ virtual TMetaClass* __fastcall GetMetaDataReaderClass(TMetaClass* vmt);
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TDBXOpenODBCMetaDataCommandFactoryMSSQL(void) : Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TDBXOpenODBCMetaDataCommandFactoryMSSQL(void) { }
	#pragma option pop
	
};


class DELPHICLASS TDBXOpenODBCMetaDataReaderMSSQL;
class PASCALIMPLEMENTATION TDBXOpenODBCMetaDataReaderMSSQL : public Dbx34drv::TDBXOpenODBCMetaDataReader 
{
	typedef Dbx34drv::TDBXOpenODBCMetaDataReader inherited;
	
protected:
	virtual WideString __fastcall GetProductName();
	virtual WideString __fastcall GetSqlForTables();
	virtual WideString __fastcall GetSqlForColumns();
	virtual WideString __fastcall GetSqlForIndexes();
	virtual WideString __fastcall GetSqlForIndexColumns();
	virtual Dbxplatformutil::TDBXWideStringArray __fastcall GetReservedWords();
	virtual WideString __fastcall GetSqlIdentifierQuotePrefix();
	virtual WideString __fastcall GetSqlIdentifierQuoteSuffix();
	virtual WideString __fastcall GetTableType();
	virtual WideString __fastcall GetViewType();
	virtual WideString __fastcall GetSystemTableType();
	virtual WideString __fastcall GetSystemViewType();
	virtual WideString __fastcall GetSynonymType();
	virtual Dbxmetadatareader::TDBXDataTypeDescriptionArray __fastcall GetDataTypeDescriptions();
public:
	#pragma option push -w-inl
	/* TDBXOpenODBCMetaDataReader.Create */ inline __fastcall virtual TDBXOpenODBCMetaDataReaderMSSQL(void) : Dbx34drv::TDBXOpenODBCMetaDataReader() { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TDBXBaseMetaDataReader.Destroy */ inline __fastcall virtual ~TDBXOpenODBCMetaDataReaderMSSQL(void) { }
	#pragma option pop
	
};


class DELPHICLASS TDBXOpenODBCMetaDataCommandFactoryMySQL;
class PASCALIMPLEMENTATION TDBXOpenODBCMetaDataCommandFactoryMySQL : public Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom 
{
	typedef Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom inherited;
	
protected:
	/* virtual class method */ virtual TMetaClass* __fastcall GetMetaDataReaderClass(TMetaClass* vmt);
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TDBXOpenODBCMetaDataCommandFactoryMySQL(void) : Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TDBXOpenODBCMetaDataCommandFactoryMySQL(void) { }
	#pragma option pop
	
};


class DELPHICLASS TDBXOpenODBCMetaDataReaderMySQL;
class PASCALIMPLEMENTATION TDBXOpenODBCMetaDataReaderMySQL : public Dbx34drv::TDBXOpenODBCMetaDataReader 
{
	typedef Dbx34drv::TDBXOpenODBCMetaDataReader inherited;
	
private:
	AnsiString DefaultCharsetIsUnicode;
	bool FDefaultCharSetIsUnicode;
	
public:
	__property bool DefaultCharSetUnicode = {read=FDefaultCharSetIsUnicode, nodefault};
	
protected:
	virtual void __fastcall SetContext(const Dbxmetadatareader::TDBXProviderContext* Context);
	virtual void __fastcall PopulateDataTypes(const Dbxplatformutil::TDBXObjectStore* Hash, const Dbxplatformutil::TDBXArrayList* Types, const Dbxmetadatareader::TDBXDataTypeDescriptionArray Descr);
	virtual WideString __fastcall GetProductName();
	virtual WideString __fastcall GetSqlForTables();
	virtual WideString __fastcall GetSqlForColumns();
	virtual WideString __fastcall GetSqlForIndexes();
	virtual WideString __fastcall GetSqlForIndexColumns();
	virtual Dbxplatformutil::TDBXWideStringArray __fastcall GetReservedWords();
	virtual WideString __fastcall GetSqlIdentifierQuotePrefix();
	virtual WideString __fastcall GetSqlIdentifierQuoteSuffix();
	virtual WideString __fastcall GetSqlIdentifierQuoteChar();
	virtual WideString __fastcall GetTableType();
	virtual bool __fastcall IsDescendingIndexColumnsSupported(void);
	virtual bool __fastcall IsUpperCaseIdentifiersSupported(void);
	virtual bool __fastcall IsMultipleCommandsSupported(void);
	virtual Dbxmetadatareader::TDBXDataTypeDescriptionArray __fastcall GetDataTypeDescriptions();
public:
	#pragma option push -w-inl
	/* TDBXOpenODBCMetaDataReader.Create */ inline __fastcall virtual TDBXOpenODBCMetaDataReaderMySQL(void) : Dbx34drv::TDBXOpenODBCMetaDataReader() { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TDBXBaseMetaDataReader.Destroy */ inline __fastcall virtual ~TDBXOpenODBCMetaDataReaderMySQL(void) { }
	#pragma option pop
	
};


class DELPHICLASS TDBXOpenODBCMetaDataCommandFactorySybaseASA;
class PASCALIMPLEMENTATION TDBXOpenODBCMetaDataCommandFactorySybaseASA : public Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom 
{
	typedef Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom inherited;
	
protected:
	/* virtual class method */ virtual TMetaClass* __fastcall GetMetaDataReaderClass(TMetaClass* vmt);
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TDBXOpenODBCMetaDataCommandFactorySybaseASA(void) : Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TDBXOpenODBCMetaDataCommandFactorySybaseASA(void) { }
	#pragma option pop
	
};


class DELPHICLASS TDBXOpenODBCMetaDataReaderSybaseASA;
class PASCALIMPLEMENTATION TDBXOpenODBCMetaDataReaderSybaseASA : public Dbx34drv::TDBXOpenODBCMetaDataReader 
{
	typedef Dbx34drv::TDBXOpenODBCMetaDataReader inherited;
	
private:
	AnsiString SupportsNLSDataTypePropertyName;
	AnsiString IsServerCharsetUTF8PropertyName;
	AnsiString IsCharUnicodePropertyName;
	AnsiString UnicodeEncodingPropertyName;
	bool FSupportsNLSDataType;
	bool FIsServerCharsetUTF8;
	bool FIsCharUnicode;
	
protected:
	virtual void __fastcall SetContext(const Dbxmetadatareader::TDBXProviderContext* Context);
	virtual WideString __fastcall GetProductName();
	virtual WideString __fastcall GetSqlForTables();
	virtual WideString __fastcall GetSqlForColumns();
	virtual WideString __fastcall GetSqlForIndexes();
	virtual WideString __fastcall GetSqlForIndexColumns();
	virtual Dbxplatformutil::TDBXWideStringArray __fastcall GetReservedWords();
	virtual WideString __fastcall GetTableType();
	virtual WideString __fastcall GetViewType();
	virtual WideString __fastcall GetSystemTableType();
	virtual WideString __fastcall GetSystemViewType();
	virtual Dbxmetadatareader::TDBXDataTypeDescriptionArray __fastcall GetDataTypeDescriptions();
	
public:
	__property bool SupportsNLSDataType = {read=FSupportsNLSDataType, nodefault};
	__property bool IsServerCharsetUTF8 = {read=FIsServerCharsetUTF8, nodefault};
	__property bool IsCharUnicode = {read=FIsCharUnicode, nodefault};
	__property bool DefaultCharSetUnicode = {read=FIsServerCharsetUTF8, nodefault};
public:
	#pragma option push -w-inl
	/* TDBXOpenODBCMetaDataReader.Create */ inline __fastcall virtual TDBXOpenODBCMetaDataReaderSybaseASA(void) : Dbx34drv::TDBXOpenODBCMetaDataReader() { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TDBXBaseMetaDataReader.Destroy */ inline __fastcall virtual ~TDBXOpenODBCMetaDataReaderSybaseASA(void) { }
	#pragma option pop
	
};


class DELPHICLASS TDBXOpenODBCMetaDataCommandFactorySybaseASE;
class PASCALIMPLEMENTATION TDBXOpenODBCMetaDataCommandFactorySybaseASE : public Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom 
{
	typedef Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom inherited;
	
protected:
	/* virtual class method */ virtual TMetaClass* __fastcall GetMetaDataReaderClass(TMetaClass* vmt);
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TDBXOpenODBCMetaDataCommandFactorySybaseASE(void) : Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TDBXOpenODBCMetaDataCommandFactorySybaseASE(void) { }
	#pragma option pop
	
};


class DELPHICLASS TDBXOpenODBCMetaDataReaderSybaseASE;
class PASCALIMPLEMENTATION TDBXOpenODBCMetaDataReaderSybaseASE : public Dbx34drv::TDBXOpenODBCMetaDataReader 
{
	typedef Dbx34drv::TDBXOpenODBCMetaDataReader inherited;
	
protected:
	virtual WideString __fastcall GetProductName();
	virtual WideString __fastcall GetSqlForTables();
	virtual WideString __fastcall GetSqlForColumns();
	virtual WideString __fastcall GetSqlForIndexes();
	virtual WideString __fastcall GetSqlForIndexColumns();
	virtual Dbxplatformutil::TDBXWideStringArray __fastcall GetReservedWords();
	virtual WideString __fastcall GetTableType();
	virtual WideString __fastcall GetViewType();
	virtual WideString __fastcall GetSystemTableType();
	virtual Dbxmetadatareader::TDBXDataTypeDescriptionArray __fastcall GetDataTypeDescriptions();
public:
	#pragma option push -w-inl
	/* TDBXOpenODBCMetaDataReader.Create */ inline __fastcall virtual TDBXOpenODBCMetaDataReaderSybaseASE(void) : Dbx34drv::TDBXOpenODBCMetaDataReader() { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TDBXBaseMetaDataReader.Destroy */ inline __fastcall virtual ~TDBXOpenODBCMetaDataReaderSybaseASE(void) { }
	#pragma option pop
	
};


class DELPHICLASS TDBXOpenODBCMetaDataCommandFactoryDB2;
class PASCALIMPLEMENTATION TDBXOpenODBCMetaDataCommandFactoryDB2 : public Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom 
{
	typedef Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom inherited;
	
protected:
	/* virtual class method */ virtual TMetaClass* __fastcall GetMetaDataReaderClass(TMetaClass* vmt);
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TDBXOpenODBCMetaDataCommandFactoryDB2(void) : Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TDBXOpenODBCMetaDataCommandFactoryDB2(void) { }
	#pragma option pop
	
};


class DELPHICLASS TDBXOpenODBCMetaDataReaderDB2;
class PASCALIMPLEMENTATION TDBXOpenODBCMetaDataReaderDB2 : public Dbx34drv::TDBXOpenODBCMetaDataReader 
{
	typedef Dbx34drv::TDBXOpenODBCMetaDataReader inherited;
	
protected:
	virtual WideString __fastcall GetProductName();
	virtual WideString __fastcall GetSqlForTables();
	virtual WideString __fastcall GetSqlForColumns();
	virtual WideString __fastcall GetSqlForIndexes();
	virtual WideString __fastcall GetSqlForIndexColumns();
	virtual Dbxplatformutil::TDBXWideStringArray __fastcall GetReservedWords();
	virtual WideString __fastcall GetTableType();
	virtual WideString __fastcall GetViewType();
	virtual WideString __fastcall GetSystemTableType();
	virtual WideString __fastcall GetSqlProcedureQuoteChar();
	virtual Dbxmetadatareader::TDBXDataTypeDescriptionArray __fastcall GetDataTypeDescriptions();
public:
	#pragma option push -w-inl
	/* TDBXOpenODBCMetaDataReader.Create */ inline __fastcall virtual TDBXOpenODBCMetaDataReaderDB2(void) : Dbx34drv::TDBXOpenODBCMetaDataReader() { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TDBXBaseMetaDataReader.Destroy */ inline __fastcall virtual ~TDBXOpenODBCMetaDataReaderDB2(void) { }
	#pragma option pop
	
};


class DELPHICLASS TDBXOpenODBCMetaDataCommandFactoryInformix;
class PASCALIMPLEMENTATION TDBXOpenODBCMetaDataCommandFactoryInformix : public Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom 
{
	typedef Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom inherited;
	
protected:
	/* virtual class method */ virtual TMetaClass* __fastcall GetMetaDataReaderClass(TMetaClass* vmt);
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TDBXOpenODBCMetaDataCommandFactoryInformix(void) : Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TDBXOpenODBCMetaDataCommandFactoryInformix(void) { }
	#pragma option pop
	
};


class DELPHICLASS TDBXOpenODBCMetaDataReaderInformix;
class PASCALIMPLEMENTATION TDBXOpenODBCMetaDataReaderInformix : public Dbx34drv::TDBXOpenODBCMetaDataReader 
{
	typedef Dbx34drv::TDBXOpenODBCMetaDataReader inherited;
	
private:
	Shortint CharType;
	Shortint SmallintType;
	Shortint IntegerType;
	Shortint FloatType;
	Shortint SmallfloatType;
	Shortint DecimalType;
	Shortint SerialType;
	Shortint DateType;
	Shortint MoneyType;
	Shortint DatetimeType;
	Shortint ByteType;
	Shortint TextType;
	Shortint VarcharType;
	Shortint IntervalType;
	Shortint NcharType;
	Shortint NvarcharType;
	Shortint Int8_Type;
	Shortint Serial8_Type;
	Shortint LvarcharType;
	Shortint BooleanType;
	Shortint TypesCount;
	Shortint NullType;
	Shortint SetType;
	Shortint MultisetType;
	Shortint ListType;
	Shortint UnnamedRowType;
	Shortint VarOpaqueType;
	Shortint FixedOpaqueType;
	Word NullTypeFlag;
	AnsiString CharTypename;
	AnsiString VarcharTypename;
	AnsiString LvarcharTypename;
	AnsiString NcharTypename;
	AnsiString NvarcharTypename;
	AnsiString SmallintTypename;
	AnsiString IntegerTypename;
	AnsiString Int8_Typename;
	AnsiString FloatTypename;
	AnsiString SmallfloatTypename;
	AnsiString DecimalTypename;
	AnsiString SerialTypename;
	AnsiString Serial8_Typename;
	AnsiString DateTypename;
	AnsiString DatetimeTypename;
	AnsiString IntervalTypename;
	AnsiString MoneyTypename;
	AnsiString ByteTypename;
	AnsiString TextTypename;
	AnsiString BooleanTypename;
	AnsiString Returning;
	AnsiString In;
	AnsiString Out;
	AnsiString Inout;
	AnsiString Like;
	AnsiString References;
	AnsiString IntType;
	AnsiString DecType;
	AnsiString BigintType;
	AnsiString Character;
	AnsiString Varying;
	AnsiString RealType;
	AnsiString DoubleType;
	AnsiString Precision;
	AnsiString Numeric;
	AnsiString Default;
	AnsiString QuoteCharacterEnabled;
	Shortint TokenCreate;
	Shortint TokenProcedure;
	Shortint TokenFunction;
	Shortint TokenReturning;
	Shortint TokenOut;
	Shortint TokenInout;
	Shortint TokenLike;
	Shortint TokenReferences;
	Shortint TokenInt;
	Shortint TokenDec;
	Shortint TokenBigint;
	Shortint TokenCharacter;
	Shortint TokenVarying;
	Shortint TokenReal;
	Shortint TokenDouble;
	Shortint TokenPrecision;
	Shortint TokenNumeric;
	Shortint TokenDefault;
	DynamicArray<Dbxmetadatareader::TDBXDataTypeDescription* >  FAlltypes;
	
protected:
	Dbxmetadatareader::TDBXDataTypeDescriptionArray __fastcall GetAllDataTypes();
	virtual WideString __fastcall GetProductName();
	virtual WideString __fastcall GetSqlForTables();
	virtual WideString __fastcall GetSqlForColumns();
	virtual WideString __fastcall GetSqlForIndexes();
	virtual WideString __fastcall GetSqlForIndexColumns();
	virtual Dbxplatformutil::TDBXWideStringArray __fastcall GetReservedWords();
	virtual WideString __fastcall GetTableType();
	virtual WideString __fastcall GetViewType();
	virtual WideString __fastcall GetSystemTableType();
	virtual WideString __fastcall GetSynonymType();
	virtual bool __fastcall IsUpperCaseIdentifiersSupported(void);
	virtual Dbxmetadatareader::TDBXDataTypeDescriptionArray __fastcall GetDataTypeDescriptions();
	
public:
	__fastcall virtual ~TDBXOpenODBCMetaDataReaderInformix(void);
public:
	#pragma option push -w-inl
	/* TDBXOpenODBCMetaDataReader.Create */ inline __fastcall virtual TDBXOpenODBCMetaDataReaderInformix(void) : Dbx34drv::TDBXOpenODBCMetaDataReader() { }
	#pragma option pop
	
};


class DELPHICLASS TDBXOpenODBCMetaDataCommandFactoryDataStorage;
class PASCALIMPLEMENTATION TDBXOpenODBCMetaDataCommandFactoryDataStorage : public Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom 
{
	typedef Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom inherited;
	
protected:
	/* virtual class method */ virtual TMetaClass* __fastcall GetMetaDataReaderClass(TMetaClass* vmt);
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TDBXOpenODBCMetaDataCommandFactoryDataStorage(void) : Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TDBXOpenODBCMetaDataCommandFactoryDataStorage(void) { }
	#pragma option pop
	
};


class DELPHICLASS TDBXOpenODBCMetaDataReaderDataStorage;
class PASCALIMPLEMENTATION TDBXOpenODBCMetaDataReaderDataStorage : public Dbx34drv::TDBXOpenODBCMetaDataReader 
{
	typedef Dbx34drv::TDBXOpenODBCMetaDataReader inherited;
	
protected:
	virtual WideString __fastcall GetSqlForTables();
	virtual WideString __fastcall GetSqlForColumns();
	virtual WideString __fastcall GetSqlForIndexes();
	virtual WideString __fastcall GetSqlForIndexColumns();
public:
	#pragma option push -w-inl
	/* TDBXOpenODBCMetaDataReader.Create */ inline __fastcall virtual TDBXOpenODBCMetaDataReaderDataStorage(void) : Dbx34drv::TDBXOpenODBCMetaDataReader() { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TDBXBaseMetaDataReader.Destroy */ inline __fastcall virtual ~TDBXOpenODBCMetaDataReaderDataStorage(void) { }
	#pragma option pop
	
};


class DELPHICLASS TDBXOpenODBCMetaDataCommandFactoryFirebird;
class PASCALIMPLEMENTATION TDBXOpenODBCMetaDataCommandFactoryFirebird : public Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom 
{
	typedef Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom inherited;
	
protected:
	/* virtual class method */ virtual TMetaClass* __fastcall GetMetaDataReaderClass(TMetaClass* vmt);
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TDBXOpenODBCMetaDataCommandFactoryFirebird(void) : Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TDBXOpenODBCMetaDataCommandFactoryFirebird(void) { }
	#pragma option pop
	
};


class DELPHICLASS TDBXOpenODBCMetaDataReaderFirebird;
class PASCALIMPLEMENTATION TDBXOpenODBCMetaDataReaderFirebird : public Dbx34drv::TDBXOpenODBCMetaDataReader 
{
	typedef Dbx34drv::TDBXOpenODBCMetaDataReader inherited;
	
public:
	Shortint CharType;
	Shortint VarcharType;
	Shortint IntegerType;
	Shortint SmallintType;
	Shortint FloatType;
	Shortint DoubleType;
	Shortint NumericType;
	Shortint DecimalType;
	Shortint DateType;
	Shortint TimeType;
	Shortint TimestampType;
	Shortint BlobType;
	Shortint BigintType;
	Shortint DefaultCharset;
	Shortint CharsetUnicodeFss;
	Shortint CharsetSjis208;
	Shortint CharsetEucj208;
	
private:
	Shortint TypesCount;
	AnsiString DefaultStringStart;
	AnsiString DefaultCharsetIsUnicode;
	AnsiString QuoteCharacterEnabled;
	Shortint ColumnsFieldType;
	Shortint ColumnsSubtype;
	Shortint ParametersFieldType;
	Shortint ParametersSubtype;
	bool FDefaultCharSetIsUnicode;
	DynamicArray<Dbxmetadatareader::TDBXDataTypeDescription* >  FAlltypes;
	
protected:
	Dbxmetadatareader::TDBXDataTypeDescriptionArray __fastcall GetAllDataTypes();
	virtual void __fastcall SetContext(const Dbxmetadatareader::TDBXProviderContext* Context);
	virtual WideString __fastcall GetProductName();
	virtual WideString __fastcall GetSqlForTables();
	virtual WideString __fastcall GetSqlForColumns();
	virtual WideString __fastcall GetSqlForIndexes();
	virtual WideString __fastcall GetSqlForIndexColumns();
	virtual Dbxplatformutil::TDBXWideStringArray __fastcall GetReservedWords();
	virtual bool __fastcall IsDescendingIndexColumnsSupported(void);
	virtual Dbxmetadatareader::TDBXDataTypeDescriptionArray __fastcall GetDataTypeDescriptions();
	
public:
	__fastcall virtual ~TDBXOpenODBCMetaDataReaderFirebird(void);
public:
	#pragma option push -w-inl
	/* TDBXOpenODBCMetaDataReader.Create */ inline __fastcall virtual TDBXOpenODBCMetaDataReaderFirebird(void) : Dbx34drv::TDBXOpenODBCMetaDataReader() { }
	#pragma option pop
	
};


class DELPHICLASS TDBXOpenODBCMetaDataCommandFactoryInterbase;
class PASCALIMPLEMENTATION TDBXOpenODBCMetaDataCommandFactoryInterbase : public Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom 
{
	typedef Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom inherited;
	
protected:
	/* virtual class method */ virtual TMetaClass* __fastcall GetMetaDataReaderClass(TMetaClass* vmt);
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TDBXOpenODBCMetaDataCommandFactoryInterbase(void) : Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TDBXOpenODBCMetaDataCommandFactoryInterbase(void) { }
	#pragma option pop
	
};


class DELPHICLASS TDBXOpenODBCMetaDataReaderInterbase;
class PASCALIMPLEMENTATION TDBXOpenODBCMetaDataReaderInterbase : public Dbx34drv::TDBXOpenODBCMetaDataReader 
{
	typedef Dbx34drv::TDBXOpenODBCMetaDataReader inherited;
	
public:
	Shortint CharType;
	Shortint VarcharType;
	Shortint IntegerType;
	Shortint SmallintType;
	Shortint FloatType;
	Shortint DoubleType;
	Shortint NumericType;
	Shortint DecimalType;
	Shortint DateType;
	Shortint TimeType;
	Shortint TimestampType;
	Shortint BlobType;
	Shortint BooleanType;
	Shortint DefaultCharset;
	Shortint CharsetUnicodeFss;
	Shortint CharsetSjis208;
	Shortint CharsetEucj208;
	
private:
	Shortint TypesCount;
	AnsiString DefaultStringStart;
	AnsiString DefaultCharsetIsUnicode;
	AnsiString QuoteCharacterEnabled;
	Shortint ColumnsFieldType;
	Shortint ColumnsSubtype;
	Shortint ParametersFieldType;
	Shortint ParametersSubtype;
	bool FDefaultCharSetIsUnicode;
	DynamicArray<Dbxmetadatareader::TDBXDataTypeDescription* >  FAlltypes;
	
protected:
	Dbxmetadatareader::TDBXDataTypeDescriptionArray __fastcall GetAllDataTypes();
	virtual void __fastcall SetContext(const Dbxmetadatareader::TDBXProviderContext* Context);
	virtual WideString __fastcall GetProductName();
	virtual WideString __fastcall GetSqlForTables();
	virtual WideString __fastcall GetSqlForColumns();
	virtual WideString __fastcall GetSqlForIndexes();
	virtual WideString __fastcall GetSqlForIndexColumns();
	virtual Dbxplatformutil::TDBXWideStringArray __fastcall GetReservedWords();
	virtual bool __fastcall IsDescendingIndexColumnsSupported(void);
	virtual Dbxmetadatareader::TDBXDataTypeDescriptionArray __fastcall GetDataTypeDescriptions();
	
public:
	__fastcall virtual ~TDBXOpenODBCMetaDataReaderInterbase(void);
public:
	#pragma option push -w-inl
	/* TDBXOpenODBCMetaDataReader.Create */ inline __fastcall virtual TDBXOpenODBCMetaDataReaderInterbase(void) : Dbx34drv::TDBXOpenODBCMetaDataReader() { }
	#pragma option pop
	
};


class DELPHICLASS TDBXOpenODBCMetaDataCommandFactorySQLite;
class PASCALIMPLEMENTATION TDBXOpenODBCMetaDataCommandFactorySQLite : public Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom 
{
	typedef Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom inherited;
	
protected:
	/* virtual class method */ virtual TMetaClass* __fastcall GetMetaDataReaderClass(TMetaClass* vmt);
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TDBXOpenODBCMetaDataCommandFactorySQLite(void) : Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TDBXOpenODBCMetaDataCommandFactorySQLite(void) { }
	#pragma option pop
	
};


class DELPHICLASS TDBXOpenODBCMetaDataReaderSQLite;
class PASCALIMPLEMENTATION TDBXOpenODBCMetaDataReaderSQLite : public Dbx34drv::TDBXOpenODBCMetaDataReader 
{
	typedef Dbx34drv::TDBXOpenODBCMetaDataReader inherited;
	
protected:
	virtual WideString __fastcall GetSqlForTables();
public:
	#pragma option push -w-inl
	/* TDBXOpenODBCMetaDataReader.Create */ inline __fastcall virtual TDBXOpenODBCMetaDataReaderSQLite(void) : Dbx34drv::TDBXOpenODBCMetaDataReader() { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TDBXBaseMetaDataReader.Destroy */ inline __fastcall virtual ~TDBXOpenODBCMetaDataReaderSQLite(void) { }
	#pragma option pop
	
};


class DELPHICLASS TDBXOpenODBCMetaDataCommandFactoryPostgreSQL;
class PASCALIMPLEMENTATION TDBXOpenODBCMetaDataCommandFactoryPostgreSQL : public Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom 
{
	typedef Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom inherited;
	
protected:
	/* virtual class method */ virtual TMetaClass* __fastcall GetMetaDataReaderClass(TMetaClass* vmt);
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TDBXOpenODBCMetaDataCommandFactoryPostgreSQL(void) : Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TDBXOpenODBCMetaDataCommandFactoryPostgreSQL(void) { }
	#pragma option pop
	
};


class DELPHICLASS TDBXOpenODBCMetaDataReaderPostgreSQL;
class PASCALIMPLEMENTATION TDBXOpenODBCMetaDataReaderPostgreSQL : public Dbx34drv::TDBXOpenODBCMetaDataReader 
{
	typedef Dbx34drv::TDBXOpenODBCMetaDataReader inherited;
	
protected:
	virtual WideString __fastcall GetSqlForTables();
	virtual WideString __fastcall GetSqlForColumns();
	virtual WideString __fastcall GetSqlForIndexes();
	virtual WideString __fastcall GetSqlForIndexColumns();
	virtual Dbxplatformutil::TDBXWideStringArray __fastcall GetReservedWords();
public:
	#pragma option push -w-inl
	/* TDBXOpenODBCMetaDataReader.Create */ inline __fastcall virtual TDBXOpenODBCMetaDataReaderPostgreSQL(void) : Dbx34drv::TDBXOpenODBCMetaDataReader() { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TDBXBaseMetaDataReader.Destroy */ inline __fastcall virtual ~TDBXOpenODBCMetaDataReaderPostgreSQL(void) { }
	#pragma option pop
	
};


//-- var, const, procedure ---------------------------------------------------

}	/* namespace Dbx34drvdbms */
using namespace Dbx34drvdbms;
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Dbx34drvdbms
