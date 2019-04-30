// CodeGear C++Builder
// Copyright (c) 1995, 2009 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'Dbx34drvdbms.pas' rev: 21.00

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
#include <Dbxdynalink.hpp>	// Pascal unit
#include <Widestrings.hpp>	// Pascal unit
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
	__classmethod virtual Dbx34drv::TDBXOpenODBCMetaDataReaderClass __fastcall GetMetaDataReaderClass();
public:
	/* TObject.Create */ inline __fastcall TDBXOpenODBCMetaDataCommandFactoryOracle(void) : Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TDBXOpenODBCMetaDataCommandFactoryOracle(void) { }
	
};


class DELPHICLASS TDBXOpenODBCMetaDataReaderOracle;
class PASCALIMPLEMENTATION TDBXOpenODBCMetaDataReaderOracle : public Dbx34drv::TDBXOpenODBCMetaDataReader
{
	typedef Dbx34drv::TDBXOpenODBCMetaDataReader inherited;
	
protected:
	virtual System::UnicodeString __fastcall GetProductName(void);
	virtual System::UnicodeString __fastcall GetSqlForSchemas(void);
	virtual System::UnicodeString __fastcall GetSqlForTables(void);
	virtual System::UnicodeString __fastcall GetSqlForColumns(void);
	virtual System::UnicodeString __fastcall GetSqlForIndexes(void);
	virtual System::UnicodeString __fastcall GetSqlForIndexColumns(void);
	virtual Dbxplatform::TDBXStringArray __fastcall GetReservedWords(void);
	virtual void __fastcall PopulateDataTypes(const Dbxplatform::TDBXObjectStore* Hash, const Dbxplatform::TDBXArrayList* Types, const Dbxmetadatareader::TDBXDataTypeDescriptionArray Descr);
	virtual Dbxmetadatareader::TDBXDataTypeDescriptionArray __fastcall GetDataTypeDescriptions(void);
public:
	/* TDBXOpenODBCMetaDataReader.Create */ inline __fastcall virtual TDBXOpenODBCMetaDataReaderOracle(void) : Dbx34drv::TDBXOpenODBCMetaDataReader() { }
	
public:
	/* TDBXBaseMetaDataReader.Destroy */ inline __fastcall virtual ~TDBXOpenODBCMetaDataReaderOracle(void) { }
	
};


class DELPHICLASS TDBXOpenODBCMetaDataCommandFactoryMSSQL;
class PASCALIMPLEMENTATION TDBXOpenODBCMetaDataCommandFactoryMSSQL : public Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom
{
	typedef Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom inherited;
	
protected:
	__classmethod virtual Dbx34drv::TDBXOpenODBCMetaDataReaderClass __fastcall GetMetaDataReaderClass();
public:
	/* TObject.Create */ inline __fastcall TDBXOpenODBCMetaDataCommandFactoryMSSQL(void) : Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TDBXOpenODBCMetaDataCommandFactoryMSSQL(void) { }
	
};


class DELPHICLASS TDBXOpenODBCMetaDataReaderMSSQL;
class PASCALIMPLEMENTATION TDBXOpenODBCMetaDataReaderMSSQL : public Dbx34drv::TDBXOpenODBCMetaDataReader
{
	typedef Dbx34drv::TDBXOpenODBCMetaDataReader inherited;
	
protected:
	virtual System::UnicodeString __fastcall GetProductName(void);
	virtual System::UnicodeString __fastcall GetSqlForTables(void);
	virtual System::UnicodeString __fastcall GetSqlForColumns(void);
	virtual System::UnicodeString __fastcall GetSqlForIndexes(void);
	virtual System::UnicodeString __fastcall GetSqlForIndexColumns(void);
	virtual Dbxplatform::TDBXStringArray __fastcall GetReservedWords(void);
	virtual System::UnicodeString __fastcall GetSqlIdentifierQuotePrefix(void);
	virtual System::UnicodeString __fastcall GetSqlIdentifierQuoteSuffix(void);
	virtual System::UnicodeString __fastcall GetTableType(void);
	virtual System::UnicodeString __fastcall GetViewType(void);
	virtual System::UnicodeString __fastcall GetSystemTableType(void);
	virtual System::UnicodeString __fastcall GetSystemViewType(void);
	virtual System::UnicodeString __fastcall GetSynonymType(void);
	virtual Dbxmetadatareader::TDBXDataTypeDescriptionArray __fastcall GetDataTypeDescriptions(void);
public:
	/* TDBXOpenODBCMetaDataReader.Create */ inline __fastcall virtual TDBXOpenODBCMetaDataReaderMSSQL(void) : Dbx34drv::TDBXOpenODBCMetaDataReader() { }
	
public:
	/* TDBXBaseMetaDataReader.Destroy */ inline __fastcall virtual ~TDBXOpenODBCMetaDataReaderMSSQL(void) { }
	
};


class DELPHICLASS TDBXOpenODBCMetaDataCommandFactoryMySQL;
class PASCALIMPLEMENTATION TDBXOpenODBCMetaDataCommandFactoryMySQL : public Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom
{
	typedef Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom inherited;
	
protected:
	__classmethod virtual Dbx34drv::TDBXOpenODBCMetaDataReaderClass __fastcall GetMetaDataReaderClass();
public:
	/* TObject.Create */ inline __fastcall TDBXOpenODBCMetaDataCommandFactoryMySQL(void) : Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TDBXOpenODBCMetaDataCommandFactoryMySQL(void) { }
	
};


class DELPHICLASS TDBXOpenODBCMetaDataReaderMySQL;
class PASCALIMPLEMENTATION TDBXOpenODBCMetaDataReaderMySQL : public Dbx34drv::TDBXOpenODBCMetaDataReader
{
	typedef Dbx34drv::TDBXOpenODBCMetaDataReader inherited;
	
private:
	#define TDBXOpenODBCMetaDataReaderMySQL_DefaultCharsetIsUnicode L"UnicodeEncoding"
	
	bool FDefaultCharSetIsUnicode;
	
public:
	__property bool DefaultCharSetUnicode = {read=FDefaultCharSetIsUnicode, nodefault};
	
protected:
	virtual void __fastcall SetContext(const Dbxmetadatareader::TDBXProviderContext* Context);
	virtual void __fastcall PopulateDataTypes(const Dbxplatform::TDBXObjectStore* Hash, const Dbxplatform::TDBXArrayList* Types, const Dbxmetadatareader::TDBXDataTypeDescriptionArray Descr);
	virtual System::UnicodeString __fastcall GetProductName(void);
	virtual System::UnicodeString __fastcall GetSqlForTables(void);
	virtual System::UnicodeString __fastcall GetSqlForColumns(void);
	virtual System::UnicodeString __fastcall GetSqlForIndexes(void);
	virtual System::UnicodeString __fastcall GetSqlForIndexColumns(void);
	virtual Dbxplatform::TDBXStringArray __fastcall GetReservedWords(void);
	virtual System::UnicodeString __fastcall GetSqlIdentifierQuotePrefix(void);
	virtual System::UnicodeString __fastcall GetSqlIdentifierQuoteSuffix(void);
	virtual System::UnicodeString __fastcall GetSqlIdentifierQuoteChar(void);
	virtual System::UnicodeString __fastcall GetTableType(void);
	virtual bool __fastcall IsDescendingIndexColumnsSupported(void);
	virtual bool __fastcall IsUpperCaseIdentifiersSupported(void);
	virtual bool __fastcall IsMultipleCommandsSupported(void);
	virtual Dbxmetadatareader::TDBXDataTypeDescriptionArray __fastcall GetDataTypeDescriptions(void);
public:
	/* TDBXOpenODBCMetaDataReader.Create */ inline __fastcall virtual TDBXOpenODBCMetaDataReaderMySQL(void) : Dbx34drv::TDBXOpenODBCMetaDataReader() { }
	
public:
	/* TDBXBaseMetaDataReader.Destroy */ inline __fastcall virtual ~TDBXOpenODBCMetaDataReaderMySQL(void) { }
	
};


class DELPHICLASS TDBXOpenODBCMetaDataCommandFactorySybaseASA;
class PASCALIMPLEMENTATION TDBXOpenODBCMetaDataCommandFactorySybaseASA : public Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom
{
	typedef Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom inherited;
	
protected:
	__classmethod virtual Dbx34drv::TDBXOpenODBCMetaDataReaderClass __fastcall GetMetaDataReaderClass();
public:
	/* TObject.Create */ inline __fastcall TDBXOpenODBCMetaDataCommandFactorySybaseASA(void) : Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TDBXOpenODBCMetaDataCommandFactorySybaseASA(void) { }
	
};


class DELPHICLASS TDBXOpenODBCMetaDataReaderSybaseASA;
class PASCALIMPLEMENTATION TDBXOpenODBCMetaDataReaderSybaseASA : public Dbx34drv::TDBXOpenODBCMetaDataReader
{
	typedef Dbx34drv::TDBXOpenODBCMetaDataReader inherited;
	
private:
	#define TDBXOpenODBCMetaDataReaderSybaseASA_SupportsNLSDataTypePropertyName L"SupportsNLSDataType"
	
	#define TDBXOpenODBCMetaDataReaderSybaseASA_IsServerCharsetUTF8PropertyName L"IsServerCharsetUTF8"
	
	#define TDBXOpenODBCMetaDataReaderSybaseASA_IsCharUnicodePropertyName L"IsCharUnicode"
	
	#define TDBXOpenODBCMetaDataReaderSybaseASA_UnicodeEncodingPropertyName L"UnicodeEncoding"
	
	bool FSupportsNLSDataType;
	bool FIsServerCharsetUTF8;
	bool FIsCharUnicode;
	
protected:
	virtual void __fastcall SetContext(const Dbxmetadatareader::TDBXProviderContext* Context);
	virtual System::UnicodeString __fastcall GetProductName(void);
	virtual System::UnicodeString __fastcall GetSqlForTables(void);
	virtual System::UnicodeString __fastcall GetSqlForColumns(void);
	virtual System::UnicodeString __fastcall GetSqlForIndexes(void);
	virtual System::UnicodeString __fastcall GetSqlForIndexColumns(void);
	virtual Dbxplatform::TDBXStringArray __fastcall GetReservedWords(void);
	virtual System::UnicodeString __fastcall GetTableType(void);
	virtual System::UnicodeString __fastcall GetViewType(void);
	virtual System::UnicodeString __fastcall GetSystemTableType(void);
	virtual System::UnicodeString __fastcall GetSystemViewType(void);
	virtual Dbxmetadatareader::TDBXDataTypeDescriptionArray __fastcall GetDataTypeDescriptions(void);
	
public:
	__property bool SupportsNLSDataType = {read=FSupportsNLSDataType, nodefault};
	__property bool IsServerCharsetUTF8 = {read=FIsServerCharsetUTF8, nodefault};
	__property bool IsCharUnicode = {read=FIsCharUnicode, nodefault};
	__property bool DefaultCharSetUnicode = {read=FIsServerCharsetUTF8, nodefault};
public:
	/* TDBXOpenODBCMetaDataReader.Create */ inline __fastcall virtual TDBXOpenODBCMetaDataReaderSybaseASA(void) : Dbx34drv::TDBXOpenODBCMetaDataReader() { }
	
public:
	/* TDBXBaseMetaDataReader.Destroy */ inline __fastcall virtual ~TDBXOpenODBCMetaDataReaderSybaseASA(void) { }
	
};


class DELPHICLASS TDBXOpenODBCMetaDataCommandFactorySybaseASE;
class PASCALIMPLEMENTATION TDBXOpenODBCMetaDataCommandFactorySybaseASE : public Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom
{
	typedef Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom inherited;
	
protected:
	__classmethod virtual Dbx34drv::TDBXOpenODBCMetaDataReaderClass __fastcall GetMetaDataReaderClass();
public:
	/* TObject.Create */ inline __fastcall TDBXOpenODBCMetaDataCommandFactorySybaseASE(void) : Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TDBXOpenODBCMetaDataCommandFactorySybaseASE(void) { }
	
};


class DELPHICLASS TDBXOpenODBCMetaDataReaderSybaseASE;
class PASCALIMPLEMENTATION TDBXOpenODBCMetaDataReaderSybaseASE : public Dbx34drv::TDBXOpenODBCMetaDataReader
{
	typedef Dbx34drv::TDBXOpenODBCMetaDataReader inherited;
	
protected:
	virtual System::UnicodeString __fastcall GetProductName(void);
	virtual System::UnicodeString __fastcall GetSqlForTables(void);
	virtual System::UnicodeString __fastcall GetSqlForColumns(void);
	virtual System::UnicodeString __fastcall GetSqlForIndexes(void);
	virtual System::UnicodeString __fastcall GetSqlForIndexColumns(void);
	virtual Dbxplatform::TDBXStringArray __fastcall GetReservedWords(void);
	virtual System::UnicodeString __fastcall GetTableType(void);
	virtual System::UnicodeString __fastcall GetViewType(void);
	virtual System::UnicodeString __fastcall GetSystemTableType(void);
	virtual Dbxmetadatareader::TDBXDataTypeDescriptionArray __fastcall GetDataTypeDescriptions(void);
public:
	/* TDBXOpenODBCMetaDataReader.Create */ inline __fastcall virtual TDBXOpenODBCMetaDataReaderSybaseASE(void) : Dbx34drv::TDBXOpenODBCMetaDataReader() { }
	
public:
	/* TDBXBaseMetaDataReader.Destroy */ inline __fastcall virtual ~TDBXOpenODBCMetaDataReaderSybaseASE(void) { }
	
};


class DELPHICLASS TDBXOpenODBCMetaDataCommandFactoryDB2;
class PASCALIMPLEMENTATION TDBXOpenODBCMetaDataCommandFactoryDB2 : public Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom
{
	typedef Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom inherited;
	
protected:
	__classmethod virtual Dbx34drv::TDBXOpenODBCMetaDataReaderClass __fastcall GetMetaDataReaderClass();
public:
	/* TObject.Create */ inline __fastcall TDBXOpenODBCMetaDataCommandFactoryDB2(void) : Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TDBXOpenODBCMetaDataCommandFactoryDB2(void) { }
	
};


class DELPHICLASS TDBXOpenODBCMetaDataReaderDB2;
class PASCALIMPLEMENTATION TDBXOpenODBCMetaDataReaderDB2 : public Dbx34drv::TDBXOpenODBCMetaDataReader
{
	typedef Dbx34drv::TDBXOpenODBCMetaDataReader inherited;
	
protected:
	virtual System::UnicodeString __fastcall GetProductName(void);
	virtual System::UnicodeString __fastcall GetSqlForTables(void);
	virtual System::UnicodeString __fastcall GetSqlForColumns(void);
	virtual System::UnicodeString __fastcall GetSqlForIndexes(void);
	virtual System::UnicodeString __fastcall GetSqlForIndexColumns(void);
	virtual Dbxplatform::TDBXStringArray __fastcall GetReservedWords(void);
	virtual System::UnicodeString __fastcall GetTableType(void);
	virtual System::UnicodeString __fastcall GetViewType(void);
	virtual System::UnicodeString __fastcall GetSystemTableType(void);
	virtual System::UnicodeString __fastcall GetSqlProcedureQuoteChar(void);
	virtual Dbxmetadatareader::TDBXDataTypeDescriptionArray __fastcall GetDataTypeDescriptions(void);
public:
	/* TDBXOpenODBCMetaDataReader.Create */ inline __fastcall virtual TDBXOpenODBCMetaDataReaderDB2(void) : Dbx34drv::TDBXOpenODBCMetaDataReader() { }
	
public:
	/* TDBXBaseMetaDataReader.Destroy */ inline __fastcall virtual ~TDBXOpenODBCMetaDataReaderDB2(void) { }
	
};


class DELPHICLASS TDBXOpenODBCMetaDataCommandFactoryInformix;
class PASCALIMPLEMENTATION TDBXOpenODBCMetaDataCommandFactoryInformix : public Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom
{
	typedef Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom inherited;
	
protected:
	__classmethod virtual Dbx34drv::TDBXOpenODBCMetaDataReaderClass __fastcall GetMetaDataReaderClass();
public:
	/* TObject.Create */ inline __fastcall TDBXOpenODBCMetaDataCommandFactoryInformix(void) : Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TDBXOpenODBCMetaDataCommandFactoryInformix(void) { }
	
};


class DELPHICLASS TDBXOpenODBCMetaDataReaderInformix;
class PASCALIMPLEMENTATION TDBXOpenODBCMetaDataReaderInformix : public Dbx34drv::TDBXOpenODBCMetaDataReader
{
	typedef Dbx34drv::TDBXOpenODBCMetaDataReader inherited;
	
private:
	static const ShortInt CharType = 0x0;
	
	static const ShortInt SmallintType = 0x1;
	
	static const ShortInt IntegerType = 0x2;
	
	static const ShortInt FloatType = 0x3;
	
	static const ShortInt SmallfloatType = 0x4;
	
	static const ShortInt DecimalType = 0x5;
	
	static const ShortInt SerialType = 0x6;
	
	static const ShortInt DateType = 0x7;
	
	static const ShortInt MoneyType = 0x8;
	
	static const ShortInt DatetimeType = 0xa;
	
	static const ShortInt ByteType = 0xb;
	
	static const ShortInt TextType = 0xc;
	
	static const ShortInt VarcharType = 0xd;
	
	static const ShortInt IntervalType = 0xe;
	
	static const ShortInt NcharType = 0xf;
	
	static const ShortInt NvarcharType = 0x10;
	
	static const ShortInt Int8_Type = 0x11;
	
	static const ShortInt Serial8_Type = 0x12;
	
	static const ShortInt LvarcharType = 0x13;
	
	static const ShortInt BooleanType = 0x14;
	
	static const ShortInt TypesCount = 0x15;
	
	static const ShortInt NullType = 0x9;
	
	static const ShortInt SetType = 0x13;
	
	static const ShortInt MultisetType = 0x14;
	
	static const ShortInt ListType = 0x15;
	
	static const ShortInt UnnamedRowType = 0x16;
	
	static const ShortInt VarOpaqueType = 0x28;
	
	static const ShortInt FixedOpaqueType = 0x29;
	
	static const Word NullTypeFlag = 0x100;
	
	#define TDBXOpenODBCMetaDataReaderInformix_CharTypename L"CHAR"
	
	#define TDBXOpenODBCMetaDataReaderInformix_VarcharTypename L"VARCHAR"
	
	#define TDBXOpenODBCMetaDataReaderInformix_LvarcharTypename L"LVARCHAR"
	
	#define TDBXOpenODBCMetaDataReaderInformix_NcharTypename L"NCHAR"
	
	#define TDBXOpenODBCMetaDataReaderInformix_NvarcharTypename L"NVARCHAR"
	
	#define TDBXOpenODBCMetaDataReaderInformix_SmallintTypename L"SMALLINT"
	
	#define TDBXOpenODBCMetaDataReaderInformix_IntegerTypename L"INTEGER"
	
	#define TDBXOpenODBCMetaDataReaderInformix_Int8_Typename L"INT8"
	
	#define TDBXOpenODBCMetaDataReaderInformix_FloatTypename L"FLOAT"
	
	#define TDBXOpenODBCMetaDataReaderInformix_SmallfloatTypename L"SMALLFLOAT"
	
	#define TDBXOpenODBCMetaDataReaderInformix_DecimalTypename L"DECIMAL"
	
	#define TDBXOpenODBCMetaDataReaderInformix_SerialTypename L"SERIAL"
	
	#define TDBXOpenODBCMetaDataReaderInformix_Serial8_Typename L"SERIAL8"
	
	#define TDBXOpenODBCMetaDataReaderInformix_DateTypename L"DATE"
	
	#define TDBXOpenODBCMetaDataReaderInformix_DatetimeTypename L"DATETIME"
	
	#define TDBXOpenODBCMetaDataReaderInformix_IntervalTypename L"INTERVAL"
	
	#define TDBXOpenODBCMetaDataReaderInformix_MoneyTypename L"MONEY"
	
	#define TDBXOpenODBCMetaDataReaderInformix_ByteTypename L"BYTE"
	
	#define TDBXOpenODBCMetaDataReaderInformix_TextTypename L"TEXT"
	
	#define TDBXOpenODBCMetaDataReaderInformix_BooleanTypename L"BOOLEAN"
	
	#define TDBXOpenODBCMetaDataReaderInformix_Returning L"RETURNING"
	
	#define TDBXOpenODBCMetaDataReaderInformix_In L"IN"
	
	#define TDBXOpenODBCMetaDataReaderInformix_Out L"OUT"
	
	#define TDBXOpenODBCMetaDataReaderInformix_Inout L"INOUT"
	
	#define TDBXOpenODBCMetaDataReaderInformix_Like L"LIKE"
	
	#define TDBXOpenODBCMetaDataReaderInformix_References L"REFERENCES"
	
	#define TDBXOpenODBCMetaDataReaderInformix_IntType L"INT"
	
	#define TDBXOpenODBCMetaDataReaderInformix_DecType L"DEC"
	
	#define TDBXOpenODBCMetaDataReaderInformix_BigintType L"BIGINT"
	
	#define TDBXOpenODBCMetaDataReaderInformix_Character L"CHARACTER"
	
	#define TDBXOpenODBCMetaDataReaderInformix_Varying L"VARYING"
	
	#define TDBXOpenODBCMetaDataReaderInformix_RealType L"REAL"
	
	#define TDBXOpenODBCMetaDataReaderInformix_DoubleType L"DOUBLE"
	
	#define TDBXOpenODBCMetaDataReaderInformix_Precision L"PRECISION"
	
	#define TDBXOpenODBCMetaDataReaderInformix_Numeric L"NUMERIC"
	
	#define TDBXOpenODBCMetaDataReaderInformix_Default L"DEFAULT"
	
	#define TDBXOpenODBCMetaDataReaderInformix_QuoteCharacterEnabled L"QuoteCharEnabled"
	
	static const ShortInt TokenCreate = 0x33;
	
	static const ShortInt TokenProcedure = 0x34;
	
	static const ShortInt TokenFunction = 0x35;
	
	static const ShortInt TokenReturning = 0x36;
	
	static const ShortInt TokenOut = 0x37;
	
	static const ShortInt TokenInout = 0x38;
	
	static const ShortInt TokenLike = 0x39;
	
	static const ShortInt TokenReferences = 0x3a;
	
	static const ShortInt TokenInt = 0x3b;
	
	static const ShortInt TokenDec = 0x3c;
	
	static const ShortInt TokenBigint = 0x3d;
	
	static const ShortInt TokenCharacter = 0x3e;
	
	static const ShortInt TokenVarying = 0x3f;
	
	static const ShortInt TokenReal = 0x40;
	
	static const ShortInt TokenDouble = 0x41;
	
	static const ShortInt TokenPrecision = 0x42;
	
	static const ShortInt TokenNumeric = 0x43;
	
	static const ShortInt TokenDefault = 0x44;
	
	Dbxmetadatareader::TDBXDataTypeDescriptionArray FAlltypes;
	
protected:
	Dbxmetadatareader::TDBXDataTypeDescriptionArray __fastcall GetAllDataTypes(void);
	virtual System::UnicodeString __fastcall GetProductName(void);
	virtual System::UnicodeString __fastcall GetSqlForTables(void);
	virtual System::UnicodeString __fastcall GetSqlForColumns(void);
	virtual System::UnicodeString __fastcall GetSqlForIndexes(void);
	virtual System::UnicodeString __fastcall GetSqlForIndexColumns(void);
	virtual Dbxplatform::TDBXStringArray __fastcall GetReservedWords(void);
	virtual System::UnicodeString __fastcall GetTableType(void);
	virtual System::UnicodeString __fastcall GetViewType(void);
	virtual System::UnicodeString __fastcall GetSystemTableType(void);
	virtual System::UnicodeString __fastcall GetSynonymType(void);
	virtual bool __fastcall IsUpperCaseIdentifiersSupported(void);
	virtual Dbxmetadatareader::TDBXDataTypeDescriptionArray __fastcall GetDataTypeDescriptions(void);
	
public:
	__fastcall virtual ~TDBXOpenODBCMetaDataReaderInformix(void);
public:
	/* TDBXOpenODBCMetaDataReader.Create */ inline __fastcall virtual TDBXOpenODBCMetaDataReaderInformix(void) : Dbx34drv::TDBXOpenODBCMetaDataReader() { }
	
};


class DELPHICLASS TDBXOpenODBCMetaDataCommandFactoryDataStorage;
class PASCALIMPLEMENTATION TDBXOpenODBCMetaDataCommandFactoryDataStorage : public Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom
{
	typedef Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom inherited;
	
protected:
	__classmethod virtual Dbx34drv::TDBXOpenODBCMetaDataReaderClass __fastcall GetMetaDataReaderClass();
public:
	/* TObject.Create */ inline __fastcall TDBXOpenODBCMetaDataCommandFactoryDataStorage(void) : Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TDBXOpenODBCMetaDataCommandFactoryDataStorage(void) { }
	
};


class DELPHICLASS TDBXOpenODBCMetaDataReaderDataStorage;
class PASCALIMPLEMENTATION TDBXOpenODBCMetaDataReaderDataStorage : public Dbx34drv::TDBXOpenODBCMetaDataReader
{
	typedef Dbx34drv::TDBXOpenODBCMetaDataReader inherited;
	
protected:
	virtual System::UnicodeString __fastcall GetSqlForTables(void);
	virtual System::UnicodeString __fastcall GetSqlForColumns(void);
	virtual System::UnicodeString __fastcall GetSqlForIndexes(void);
	virtual System::UnicodeString __fastcall GetSqlForIndexColumns(void);
public:
	/* TDBXOpenODBCMetaDataReader.Create */ inline __fastcall virtual TDBXOpenODBCMetaDataReaderDataStorage(void) : Dbx34drv::TDBXOpenODBCMetaDataReader() { }
	
public:
	/* TDBXBaseMetaDataReader.Destroy */ inline __fastcall virtual ~TDBXOpenODBCMetaDataReaderDataStorage(void) { }
	
};


class DELPHICLASS TDBXOpenODBCMetaDataCommandFactoryFirebird;
class PASCALIMPLEMENTATION TDBXOpenODBCMetaDataCommandFactoryFirebird : public Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom
{
	typedef Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom inherited;
	
protected:
	__classmethod virtual Dbx34drv::TDBXOpenODBCMetaDataReaderClass __fastcall GetMetaDataReaderClass();
public:
	/* TObject.Create */ inline __fastcall TDBXOpenODBCMetaDataCommandFactoryFirebird(void) : Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TDBXOpenODBCMetaDataCommandFactoryFirebird(void) { }
	
};


class DELPHICLASS TDBXOpenODBCMetaDataReaderFirebird;
class PASCALIMPLEMENTATION TDBXOpenODBCMetaDataReaderFirebird : public Dbx34drv::TDBXOpenODBCMetaDataReader
{
	typedef Dbx34drv::TDBXOpenODBCMetaDataReader inherited;
	
public:
	static const ShortInt CharType = 0x0;
	
	static const ShortInt VarcharType = 0x1;
	
	static const ShortInt IntegerType = 0x2;
	
	static const ShortInt SmallintType = 0x3;
	
	static const ShortInt FloatType = 0x4;
	
	static const ShortInt DoubleType = 0x5;
	
	static const ShortInt NumericType = 0x6;
	
	static const ShortInt DecimalType = 0x7;
	
	static const ShortInt DateType = 0x8;
	
	static const ShortInt TimeType = 0x9;
	
	static const ShortInt TimestampType = 0xa;
	
	static const ShortInt BlobType = 0xb;
	
	static const ShortInt BigintType = 0xc;
	
	static const ShortInt DefaultCharset = 0x0;
	
	static const ShortInt CharsetUnicodeFss = 0x3;
	
	static const ShortInt CharsetSjis208 = 0x5;
	
	static const ShortInt CharsetEucj208 = 0x6;
	
	
private:
	static const ShortInt TypesCount = 0xd;
	
	#define TDBXOpenODBCMetaDataReaderFirebird_DefaultStringStart L"DEFAULT "
	
	#define TDBXOpenODBCMetaDataReaderFirebird_DefaultCharsetIsUnicode L"UnicodeEncoding"
	
	#define TDBXOpenODBCMetaDataReaderFirebird_QuoteCharacterEnabled L"QuoteCharEnabled"
	
	static const ShortInt ColumnsFieldType = 0x4;
	
	static const ShortInt ColumnsSubtype = 0xc;
	
	static const ShortInt ParametersFieldType = 0x5;
	
	static const ShortInt ParametersSubtype = 0xa;
	
	bool FDefaultCharSetIsUnicode;
	Dbxmetadatareader::TDBXDataTypeDescriptionArray FAlltypes;
	
protected:
	Dbxmetadatareader::TDBXDataTypeDescriptionArray __fastcall GetAllDataTypes(void);
	virtual void __fastcall SetContext(const Dbxmetadatareader::TDBXProviderContext* Context);
	virtual System::UnicodeString __fastcall GetProductName(void);
	virtual System::UnicodeString __fastcall GetSqlForTables(void);
	virtual System::UnicodeString __fastcall GetSqlForColumns(void);
	virtual System::UnicodeString __fastcall GetSqlForIndexes(void);
	virtual System::UnicodeString __fastcall GetSqlForIndexColumns(void);
	virtual Dbxplatform::TDBXStringArray __fastcall GetReservedWords(void);
	virtual bool __fastcall IsDescendingIndexColumnsSupported(void);
	virtual Dbxmetadatareader::TDBXDataTypeDescriptionArray __fastcall GetDataTypeDescriptions(void);
	
public:
	__fastcall virtual ~TDBXOpenODBCMetaDataReaderFirebird(void);
public:
	/* TDBXOpenODBCMetaDataReader.Create */ inline __fastcall virtual TDBXOpenODBCMetaDataReaderFirebird(void) : Dbx34drv::TDBXOpenODBCMetaDataReader() { }
	
};


class DELPHICLASS TDBXOpenODBCMetaDataCommandFactoryInterbase;
class PASCALIMPLEMENTATION TDBXOpenODBCMetaDataCommandFactoryInterbase : public Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom
{
	typedef Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom inherited;
	
protected:
	__classmethod virtual Dbx34drv::TDBXOpenODBCMetaDataReaderClass __fastcall GetMetaDataReaderClass();
public:
	/* TObject.Create */ inline __fastcall TDBXOpenODBCMetaDataCommandFactoryInterbase(void) : Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TDBXOpenODBCMetaDataCommandFactoryInterbase(void) { }
	
};


class DELPHICLASS TDBXOpenODBCMetaDataReaderInterbase;
class PASCALIMPLEMENTATION TDBXOpenODBCMetaDataReaderInterbase : public Dbx34drv::TDBXOpenODBCMetaDataReader
{
	typedef Dbx34drv::TDBXOpenODBCMetaDataReader inherited;
	
public:
	static const ShortInt CharType = 0x0;
	
	static const ShortInt VarcharType = 0x1;
	
	static const ShortInt IntegerType = 0x2;
	
	static const ShortInt SmallintType = 0x3;
	
	static const ShortInt FloatType = 0x4;
	
	static const ShortInt DoubleType = 0x5;
	
	static const ShortInt NumericType = 0x6;
	
	static const ShortInt DecimalType = 0x7;
	
	static const ShortInt DateType = 0x8;
	
	static const ShortInt TimeType = 0x9;
	
	static const ShortInt TimestampType = 0xa;
	
	static const ShortInt BlobType = 0xb;
	
	static const ShortInt BooleanType = 0xc;
	
	static const ShortInt DefaultCharset = 0x0;
	
	static const ShortInt CharsetUnicodeFss = 0x3;
	
	static const ShortInt CharsetSjis208 = 0x5;
	
	static const ShortInt CharsetEucj208 = 0x6;
	
	
private:
	static const ShortInt TypesCount = 0xd;
	
	#define TDBXOpenODBCMetaDataReaderInterbase_DefaultStringStart L"DEFAULT "
	
	#define TDBXOpenODBCMetaDataReaderInterbase_DefaultCharsetIsUnicode L"UnicodeEncoding"
	
	#define TDBXOpenODBCMetaDataReaderInterbase_QuoteCharacterEnabled L"QuoteCharEnabled"
	
	static const ShortInt ColumnsFieldType = 0x4;
	
	static const ShortInt ColumnsSubtype = 0xc;
	
	static const ShortInt ParametersFieldType = 0x5;
	
	static const ShortInt ParametersSubtype = 0xa;
	
	bool FDefaultCharSetIsUnicode;
	Dbxmetadatareader::TDBXDataTypeDescriptionArray FAlltypes;
	
protected:
	Dbxmetadatareader::TDBXDataTypeDescriptionArray __fastcall GetAllDataTypes(void);
	virtual void __fastcall SetContext(const Dbxmetadatareader::TDBXProviderContext* Context);
	virtual System::UnicodeString __fastcall GetProductName(void);
	virtual System::UnicodeString __fastcall GetSqlForTables(void);
	virtual System::UnicodeString __fastcall GetSqlForColumns(void);
	virtual System::UnicodeString __fastcall GetSqlForIndexes(void);
	virtual System::UnicodeString __fastcall GetSqlForIndexColumns(void);
	virtual Dbxplatform::TDBXStringArray __fastcall GetReservedWords(void);
	virtual bool __fastcall IsDescendingIndexColumnsSupported(void);
	virtual Dbxmetadatareader::TDBXDataTypeDescriptionArray __fastcall GetDataTypeDescriptions(void);
	
public:
	__fastcall virtual ~TDBXOpenODBCMetaDataReaderInterbase(void);
public:
	/* TDBXOpenODBCMetaDataReader.Create */ inline __fastcall virtual TDBXOpenODBCMetaDataReaderInterbase(void) : Dbx34drv::TDBXOpenODBCMetaDataReader() { }
	
};


class DELPHICLASS TDBXOpenODBCMetaDataCommandFactorySQLite;
class PASCALIMPLEMENTATION TDBXOpenODBCMetaDataCommandFactorySQLite : public Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom
{
	typedef Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom inherited;
	
protected:
	__classmethod virtual Dbx34drv::TDBXOpenODBCMetaDataReaderClass __fastcall GetMetaDataReaderClass();
public:
	/* TObject.Create */ inline __fastcall TDBXOpenODBCMetaDataCommandFactorySQLite(void) : Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TDBXOpenODBCMetaDataCommandFactorySQLite(void) { }
	
};


class DELPHICLASS TDBXOpenODBCMetaDataReaderSQLite;
class PASCALIMPLEMENTATION TDBXOpenODBCMetaDataReaderSQLite : public Dbx34drv::TDBXOpenODBCMetaDataReader
{
	typedef Dbx34drv::TDBXOpenODBCMetaDataReader inherited;
	
protected:
	virtual System::UnicodeString __fastcall GetSqlForTables(void);
public:
	/* TDBXOpenODBCMetaDataReader.Create */ inline __fastcall virtual TDBXOpenODBCMetaDataReaderSQLite(void) : Dbx34drv::TDBXOpenODBCMetaDataReader() { }
	
public:
	/* TDBXBaseMetaDataReader.Destroy */ inline __fastcall virtual ~TDBXOpenODBCMetaDataReaderSQLite(void) { }
	
};


class DELPHICLASS TDBXOpenODBCMetaDataCommandFactoryPostgreSQL;
class PASCALIMPLEMENTATION TDBXOpenODBCMetaDataCommandFactoryPostgreSQL : public Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom
{
	typedef Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom inherited;
	
protected:
	__classmethod virtual Dbx34drv::TDBXOpenODBCMetaDataReaderClass __fastcall GetMetaDataReaderClass();
public:
	/* TObject.Create */ inline __fastcall TDBXOpenODBCMetaDataCommandFactoryPostgreSQL(void) : Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TDBXOpenODBCMetaDataCommandFactoryPostgreSQL(void) { }
	
};


class DELPHICLASS TDBXOpenODBCMetaDataReaderPostgreSQL;
class PASCALIMPLEMENTATION TDBXOpenODBCMetaDataReaderPostgreSQL : public Dbx34drv::TDBXOpenODBCMetaDataReader
{
	typedef Dbx34drv::TDBXOpenODBCMetaDataReader inherited;
	
protected:
	virtual System::UnicodeString __fastcall GetSqlForTables(void);
	virtual System::UnicodeString __fastcall GetSqlForColumns(void);
	virtual System::UnicodeString __fastcall GetSqlForIndexes(void);
	virtual System::UnicodeString __fastcall GetSqlForIndexColumns(void);
	virtual Dbxplatform::TDBXStringArray __fastcall GetReservedWords(void);
public:
	/* TDBXOpenODBCMetaDataReader.Create */ inline __fastcall virtual TDBXOpenODBCMetaDataReaderPostgreSQL(void) : Dbx34drv::TDBXOpenODBCMetaDataReader() { }
	
public:
	/* TDBXBaseMetaDataReader.Destroy */ inline __fastcall virtual ~TDBXOpenODBCMetaDataReaderPostgreSQL(void) { }
	
};


//-- var, const, procedure ---------------------------------------------------

}	/* namespace Dbx34drvdbms */
using namespace Dbx34drvdbms;
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Dbx34drvdbmsHPP
