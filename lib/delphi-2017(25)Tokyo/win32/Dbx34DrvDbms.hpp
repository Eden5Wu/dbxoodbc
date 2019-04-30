// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'Dbx34DrvDbms.pas' rev: 32.00 (Windows)

#ifndef Dbx34drvdbmsHPP
#define Dbx34drvdbmsHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <System.SysUtils.hpp>
#include <System.Classes.hpp>
#include <Data.DBXCommon.hpp>
#include <Data.DBXDynalink.hpp>
#include <System.WideStrings.hpp>
#include <Data.DBXPlatform.hpp>
#include <Data.DBXMetaDataReader.hpp>
#include <Data.DBXMetaDataNames.hpp>
#include <Dbx34Drv.hpp>

//-- user supplied -----------------------------------------------------------

namespace Dbx34drvdbms
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TDBXOpenODBCMetaDataCommandFactoryOracle;
class DELPHICLASS TDBXOpenODBCMetaDataReaderOracle;
class DELPHICLASS TDBXOpenODBCMetaDataCommandFactoryMSSQL;
class DELPHICLASS TDBXOpenODBCMetaDataReaderMSSQL;
class DELPHICLASS TDBXOpenODBCMetaDataCommandFactoryMySQL;
class DELPHICLASS TDBXOpenODBCMetaDataReaderMySQL;
class DELPHICLASS TDBXOpenODBCMetaDataCommandFactorySybaseASA;
class DELPHICLASS TDBXOpenODBCMetaDataReaderSybaseASA;
class DELPHICLASS TDBXOpenODBCMetaDataCommandFactorySybaseASE;
class DELPHICLASS TDBXOpenODBCMetaDataReaderSybaseASE;
class DELPHICLASS TDBXOpenODBCMetaDataCommandFactoryDB2;
class DELPHICLASS TDBXOpenODBCMetaDataReaderDB2;
class DELPHICLASS TDBXOpenODBCMetaDataCommandFactoryInformix;
class DELPHICLASS TDBXOpenODBCMetaDataReaderInformix;
class DELPHICLASS TDBXOpenODBCMetaDataCommandFactoryDataStorage;
class DELPHICLASS TDBXOpenODBCMetaDataReaderDataStorage;
class DELPHICLASS TDBXOpenODBCMetaDataCommandFactoryFirebird;
class DELPHICLASS TDBXOpenODBCMetaDataReaderFirebird;
class DELPHICLASS TDBXOpenODBCMetaDataCommandFactoryInterbase;
class DELPHICLASS TDBXOpenODBCMetaDataReaderInterbase;
class DELPHICLASS TDBXOpenODBCMetaDataCommandFactorySQLite;
class DELPHICLASS TDBXOpenODBCMetaDataReaderSQLite;
class DELPHICLASS TDBXOpenODBCMetaDataCommandFactoryPostgreSQL;
class DELPHICLASS TDBXOpenODBCMetaDataReaderPostgreSQL;
//-- type declarations -------------------------------------------------------
#pragma pack(push,4)
class PASCALIMPLEMENTATION TDBXOpenODBCMetaDataCommandFactoryOracle : public Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom
{
	typedef Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom inherited;
	
protected:
	__classmethod virtual Dbx34drv::TDBXOpenODBCMetaDataReaderClass __fastcall GetMetaDataReaderClass();
public:
	/* TObject.Create */ inline __fastcall TDBXOpenODBCMetaDataCommandFactoryOracle(void) : Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TDBXOpenODBCMetaDataCommandFactoryOracle(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
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
	virtual Data::Dbxplatform::TDBXStringArray __fastcall GetReservedWords(void);
	virtual void __fastcall PopulateDataTypes(Data::Dbxplatform::TDBXObjectStore* const Hash, Data::Dbxplatform::TDBXArrayList* const Types, const Data::Dbxmetadatareader::TDBXDataTypeDescriptionArray Descr);
	virtual Data::Dbxmetadatareader::TDBXDataTypeDescriptionArray __fastcall GetDataTypeDescriptions(void);
public:
	/* TDBXOpenODBCMetaDataReader.Create */ inline __fastcall virtual TDBXOpenODBCMetaDataReaderOracle(void) : Dbx34drv::TDBXOpenODBCMetaDataReader() { }
	
public:
	/* TDBXBaseMetaDataReader.Destroy */ inline __fastcall virtual ~TDBXOpenODBCMetaDataReaderOracle(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TDBXOpenODBCMetaDataCommandFactoryMSSQL : public Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom
{
	typedef Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom inherited;
	
protected:
	__classmethod virtual Dbx34drv::TDBXOpenODBCMetaDataReaderClass __fastcall GetMetaDataReaderClass();
public:
	/* TObject.Create */ inline __fastcall TDBXOpenODBCMetaDataCommandFactoryMSSQL(void) : Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TDBXOpenODBCMetaDataCommandFactoryMSSQL(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TDBXOpenODBCMetaDataReaderMSSQL : public Dbx34drv::TDBXOpenODBCMetaDataReader
{
	typedef Dbx34drv::TDBXOpenODBCMetaDataReader inherited;
	
protected:
	virtual System::UnicodeString __fastcall GetProductName(void);
	virtual System::UnicodeString __fastcall GetSqlForTables(void);
	virtual System::UnicodeString __fastcall GetSqlForColumns(void);
	virtual System::UnicodeString __fastcall GetSqlForIndexes(void);
	virtual System::UnicodeString __fastcall GetSqlForIndexColumns(void);
	virtual Data::Dbxplatform::TDBXStringArray __fastcall GetReservedWords(void);
	virtual System::UnicodeString __fastcall GetSqlIdentifierQuotePrefix(void);
	virtual System::UnicodeString __fastcall GetSqlIdentifierQuoteSuffix(void);
	virtual System::UnicodeString __fastcall GetTableType(void);
	virtual System::UnicodeString __fastcall GetViewType(void);
	virtual System::UnicodeString __fastcall GetSystemTableType(void);
	virtual System::UnicodeString __fastcall GetSystemViewType(void);
	virtual System::UnicodeString __fastcall GetSynonymType(void);
	virtual Data::Dbxmetadatareader::TDBXDataTypeDescriptionArray __fastcall GetDataTypeDescriptions(void);
public:
	/* TDBXOpenODBCMetaDataReader.Create */ inline __fastcall virtual TDBXOpenODBCMetaDataReaderMSSQL(void) : Dbx34drv::TDBXOpenODBCMetaDataReader() { }
	
public:
	/* TDBXBaseMetaDataReader.Destroy */ inline __fastcall virtual ~TDBXOpenODBCMetaDataReaderMSSQL(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TDBXOpenODBCMetaDataCommandFactoryMySQL : public Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom
{
	typedef Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom inherited;
	
protected:
	__classmethod virtual Dbx34drv::TDBXOpenODBCMetaDataReaderClass __fastcall GetMetaDataReaderClass();
public:
	/* TObject.Create */ inline __fastcall TDBXOpenODBCMetaDataCommandFactoryMySQL(void) : Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TDBXOpenODBCMetaDataCommandFactoryMySQL(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TDBXOpenODBCMetaDataReaderMySQL : public Dbx34drv::TDBXOpenODBCMetaDataReader
{
	typedef Dbx34drv::TDBXOpenODBCMetaDataReader inherited;
	
private:
	#define TDBXOpenODBCMetaDataReaderMySQL_DefaultCharsetIsUnicode L"UnicodeEncoding"
	
	bool FDefaultCharSetIsUnicode;
	
public:
	__property bool DefaultCharSetUnicode = {read=FDefaultCharSetIsUnicode, nodefault};
	
protected:
	virtual void __fastcall SetContext(Data::Dbxmetadatareader::TDBXProviderContext* const Context);
	virtual void __fastcall PopulateDataTypes(Data::Dbxplatform::TDBXObjectStore* const Hash, Data::Dbxplatform::TDBXArrayList* const Types, const Data::Dbxmetadatareader::TDBXDataTypeDescriptionArray Descr);
	virtual System::UnicodeString __fastcall GetProductName(void);
	virtual System::UnicodeString __fastcall GetSqlForTables(void);
	virtual System::UnicodeString __fastcall GetSqlForColumns(void);
	virtual System::UnicodeString __fastcall GetSqlForIndexes(void);
	virtual System::UnicodeString __fastcall GetSqlForIndexColumns(void);
	virtual Data::Dbxplatform::TDBXStringArray __fastcall GetReservedWords(void);
	virtual System::UnicodeString __fastcall GetSqlIdentifierQuotePrefix(void);
	virtual System::UnicodeString __fastcall GetSqlIdentifierQuoteSuffix(void);
	virtual System::UnicodeString __fastcall GetSqlIdentifierQuoteChar(void);
	virtual System::UnicodeString __fastcall GetTableType(void);
	virtual bool __fastcall IsDescendingIndexColumnsSupported(void);
	virtual bool __fastcall IsUpperCaseIdentifiersSupported(void);
	virtual bool __fastcall IsMultipleCommandsSupported(void);
	virtual Data::Dbxmetadatareader::TDBXDataTypeDescriptionArray __fastcall GetDataTypeDescriptions(void);
public:
	/* TDBXOpenODBCMetaDataReader.Create */ inline __fastcall virtual TDBXOpenODBCMetaDataReaderMySQL(void) : Dbx34drv::TDBXOpenODBCMetaDataReader() { }
	
public:
	/* TDBXBaseMetaDataReader.Destroy */ inline __fastcall virtual ~TDBXOpenODBCMetaDataReaderMySQL(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TDBXOpenODBCMetaDataCommandFactorySybaseASA : public Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom
{
	typedef Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom inherited;
	
protected:
	__classmethod virtual Dbx34drv::TDBXOpenODBCMetaDataReaderClass __fastcall GetMetaDataReaderClass();
public:
	/* TObject.Create */ inline __fastcall TDBXOpenODBCMetaDataCommandFactorySybaseASA(void) : Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TDBXOpenODBCMetaDataCommandFactorySybaseASA(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
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
	virtual void __fastcall SetContext(Data::Dbxmetadatareader::TDBXProviderContext* const Context);
	virtual System::UnicodeString __fastcall GetProductName(void);
	virtual System::UnicodeString __fastcall GetSqlForTables(void);
	virtual System::UnicodeString __fastcall GetSqlForColumns(void);
	virtual System::UnicodeString __fastcall GetSqlForIndexes(void);
	virtual System::UnicodeString __fastcall GetSqlForIndexColumns(void);
	virtual Data::Dbxplatform::TDBXStringArray __fastcall GetReservedWords(void);
	virtual System::UnicodeString __fastcall GetTableType(void);
	virtual System::UnicodeString __fastcall GetViewType(void);
	virtual System::UnicodeString __fastcall GetSystemTableType(void);
	virtual System::UnicodeString __fastcall GetSystemViewType(void);
	virtual Data::Dbxmetadatareader::TDBXDataTypeDescriptionArray __fastcall GetDataTypeDescriptions(void);
	
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

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TDBXOpenODBCMetaDataCommandFactorySybaseASE : public Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom
{
	typedef Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom inherited;
	
protected:
	__classmethod virtual Dbx34drv::TDBXOpenODBCMetaDataReaderClass __fastcall GetMetaDataReaderClass();
public:
	/* TObject.Create */ inline __fastcall TDBXOpenODBCMetaDataCommandFactorySybaseASE(void) : Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TDBXOpenODBCMetaDataCommandFactorySybaseASE(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TDBXOpenODBCMetaDataReaderSybaseASE : public Dbx34drv::TDBXOpenODBCMetaDataReader
{
	typedef Dbx34drv::TDBXOpenODBCMetaDataReader inherited;
	
protected:
	virtual System::UnicodeString __fastcall GetProductName(void);
	virtual System::UnicodeString __fastcall GetSqlForTables(void);
	virtual System::UnicodeString __fastcall GetSqlForColumns(void);
	virtual System::UnicodeString __fastcall GetSqlForIndexes(void);
	virtual System::UnicodeString __fastcall GetSqlForIndexColumns(void);
	virtual Data::Dbxplatform::TDBXStringArray __fastcall GetReservedWords(void);
	virtual System::UnicodeString __fastcall GetTableType(void);
	virtual System::UnicodeString __fastcall GetViewType(void);
	virtual System::UnicodeString __fastcall GetSystemTableType(void);
	virtual Data::Dbxmetadatareader::TDBXDataTypeDescriptionArray __fastcall GetDataTypeDescriptions(void);
public:
	/* TDBXOpenODBCMetaDataReader.Create */ inline __fastcall virtual TDBXOpenODBCMetaDataReaderSybaseASE(void) : Dbx34drv::TDBXOpenODBCMetaDataReader() { }
	
public:
	/* TDBXBaseMetaDataReader.Destroy */ inline __fastcall virtual ~TDBXOpenODBCMetaDataReaderSybaseASE(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TDBXOpenODBCMetaDataCommandFactoryDB2 : public Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom
{
	typedef Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom inherited;
	
protected:
	__classmethod virtual Dbx34drv::TDBXOpenODBCMetaDataReaderClass __fastcall GetMetaDataReaderClass();
public:
	/* TObject.Create */ inline __fastcall TDBXOpenODBCMetaDataCommandFactoryDB2(void) : Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TDBXOpenODBCMetaDataCommandFactoryDB2(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TDBXOpenODBCMetaDataReaderDB2 : public Dbx34drv::TDBXOpenODBCMetaDataReader
{
	typedef Dbx34drv::TDBXOpenODBCMetaDataReader inherited;
	
protected:
	virtual System::UnicodeString __fastcall GetProductName(void);
	virtual System::UnicodeString __fastcall GetSqlForTables(void);
	virtual System::UnicodeString __fastcall GetSqlForColumns(void);
	virtual System::UnicodeString __fastcall GetSqlForIndexes(void);
	virtual System::UnicodeString __fastcall GetSqlForIndexColumns(void);
	virtual Data::Dbxplatform::TDBXStringArray __fastcall GetReservedWords(void);
	virtual System::UnicodeString __fastcall GetTableType(void);
	virtual System::UnicodeString __fastcall GetViewType(void);
	virtual System::UnicodeString __fastcall GetSystemTableType(void);
	virtual System::UnicodeString __fastcall GetSqlProcedureQuoteChar(void);
	virtual Data::Dbxmetadatareader::TDBXDataTypeDescriptionArray __fastcall GetDataTypeDescriptions(void);
public:
	/* TDBXOpenODBCMetaDataReader.Create */ inline __fastcall virtual TDBXOpenODBCMetaDataReaderDB2(void) : Dbx34drv::TDBXOpenODBCMetaDataReader() { }
	
public:
	/* TDBXBaseMetaDataReader.Destroy */ inline __fastcall virtual ~TDBXOpenODBCMetaDataReaderDB2(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TDBXOpenODBCMetaDataCommandFactoryInformix : public Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom
{
	typedef Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom inherited;
	
protected:
	__classmethod virtual Dbx34drv::TDBXOpenODBCMetaDataReaderClass __fastcall GetMetaDataReaderClass();
public:
	/* TObject.Create */ inline __fastcall TDBXOpenODBCMetaDataCommandFactoryInformix(void) : Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TDBXOpenODBCMetaDataCommandFactoryInformix(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TDBXOpenODBCMetaDataReaderInformix : public Dbx34drv::TDBXOpenODBCMetaDataReader
{
	typedef Dbx34drv::TDBXOpenODBCMetaDataReader inherited;
	
private:
	static const System::Int8 CharType = System::Int8(0x0);
	
	static const System::Int8 SmallintType = System::Int8(0x1);
	
	static const System::Int8 IntegerType = System::Int8(0x2);
	
	static const System::Int8 FloatType = System::Int8(0x3);
	
	static const System::Int8 SmallfloatType = System::Int8(0x4);
	
	static const System::Int8 DecimalType = System::Int8(0x5);
	
	static const System::Int8 SerialType = System::Int8(0x6);
	
	static const System::Int8 DateType = System::Int8(0x7);
	
	static const System::Int8 MoneyType = System::Int8(0x8);
	
	static const System::Int8 DatetimeType = System::Int8(0xa);
	
	static const System::Int8 ByteType = System::Int8(0xb);
	
	static const System::Int8 TextType = System::Int8(0xc);
	
	static const System::Int8 VarcharType = System::Int8(0xd);
	
	static const System::Int8 IntervalType = System::Int8(0xe);
	
	static const System::Int8 NcharType = System::Int8(0xf);
	
	static const System::Int8 NvarcharType = System::Int8(0x10);
	
	static const System::Int8 Int8_Type = System::Int8(0x11);
	
	static const System::Int8 Serial8_Type = System::Int8(0x12);
	
	static const System::Int8 LvarcharType = System::Int8(0x13);
	
	static const System::Int8 BooleanType = System::Int8(0x14);
	
	static const System::Int8 TypesCount = System::Int8(0x15);
	
	static const System::Int8 NullType = System::Int8(0x9);
	
	static const System::Int8 SetType = System::Int8(0x13);
	
	static const System::Int8 MultisetType = System::Int8(0x14);
	
	static const System::Int8 ListType = System::Int8(0x15);
	
	static const System::Int8 UnnamedRowType = System::Int8(0x16);
	
	static const System::Int8 VarOpaqueType = System::Int8(0x28);
	
	static const System::Int8 FixedOpaqueType = System::Int8(0x29);
	
	static const System::Word NullTypeFlag = System::Word(0x100);
	
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
	
	static const System::Int8 TokenCreate = System::Int8(0x33);
	
	static const System::Int8 TokenProcedure = System::Int8(0x34);
	
	static const System::Int8 TokenFunction = System::Int8(0x35);
	
	static const System::Int8 TokenReturning = System::Int8(0x36);
	
	static const System::Int8 TokenOut = System::Int8(0x37);
	
	static const System::Int8 TokenInout = System::Int8(0x38);
	
	static const System::Int8 TokenLike = System::Int8(0x39);
	
	static const System::Int8 TokenReferences = System::Int8(0x3a);
	
	static const System::Int8 TokenInt = System::Int8(0x3b);
	
	static const System::Int8 TokenDec = System::Int8(0x3c);
	
	static const System::Int8 TokenBigint = System::Int8(0x3d);
	
	static const System::Int8 TokenCharacter = System::Int8(0x3e);
	
	static const System::Int8 TokenVarying = System::Int8(0x3f);
	
	static const System::Int8 TokenReal = System::Int8(0x40);
	
	static const System::Int8 TokenDouble = System::Int8(0x41);
	
	static const System::Int8 TokenPrecision = System::Int8(0x42);
	
	static const System::Int8 TokenNumeric = System::Int8(0x43);
	
	static const System::Int8 TokenDefault = System::Int8(0x44);
	
	Data::Dbxmetadatareader::TDBXDataTypeDescriptionArray FAlltypes;
	
protected:
	Data::Dbxmetadatareader::TDBXDataTypeDescriptionArray __fastcall GetAllDataTypes(void);
	virtual System::UnicodeString __fastcall GetProductName(void);
	virtual System::UnicodeString __fastcall GetSqlForTables(void);
	virtual System::UnicodeString __fastcall GetSqlForColumns(void);
	virtual System::UnicodeString __fastcall GetSqlForIndexes(void);
	virtual System::UnicodeString __fastcall GetSqlForIndexColumns(void);
	virtual Data::Dbxplatform::TDBXStringArray __fastcall GetReservedWords(void);
	virtual System::UnicodeString __fastcall GetTableType(void);
	virtual System::UnicodeString __fastcall GetViewType(void);
	virtual System::UnicodeString __fastcall GetSystemTableType(void);
	virtual System::UnicodeString __fastcall GetSynonymType(void);
	virtual bool __fastcall IsUpperCaseIdentifiersSupported(void);
	virtual Data::Dbxmetadatareader::TDBXDataTypeDescriptionArray __fastcall GetDataTypeDescriptions(void);
	
public:
	__fastcall virtual ~TDBXOpenODBCMetaDataReaderInformix(void);
public:
	/* TDBXOpenODBCMetaDataReader.Create */ inline __fastcall virtual TDBXOpenODBCMetaDataReaderInformix(void) : Dbx34drv::TDBXOpenODBCMetaDataReader() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TDBXOpenODBCMetaDataCommandFactoryDataStorage : public Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom
{
	typedef Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom inherited;
	
protected:
	__classmethod virtual Dbx34drv::TDBXOpenODBCMetaDataReaderClass __fastcall GetMetaDataReaderClass();
public:
	/* TObject.Create */ inline __fastcall TDBXOpenODBCMetaDataCommandFactoryDataStorage(void) : Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TDBXOpenODBCMetaDataCommandFactoryDataStorage(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
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

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TDBXOpenODBCMetaDataCommandFactoryFirebird : public Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom
{
	typedef Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom inherited;
	
protected:
	__classmethod virtual Dbx34drv::TDBXOpenODBCMetaDataReaderClass __fastcall GetMetaDataReaderClass();
public:
	/* TObject.Create */ inline __fastcall TDBXOpenODBCMetaDataCommandFactoryFirebird(void) : Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TDBXOpenODBCMetaDataCommandFactoryFirebird(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TDBXOpenODBCMetaDataReaderFirebird : public Dbx34drv::TDBXOpenODBCMetaDataReader
{
	typedef Dbx34drv::TDBXOpenODBCMetaDataReader inherited;
	
public:
	static const System::Int8 CharType = System::Int8(0x0);
	
	static const System::Int8 VarcharType = System::Int8(0x1);
	
	static const System::Int8 IntegerType = System::Int8(0x2);
	
	static const System::Int8 SmallintType = System::Int8(0x3);
	
	static const System::Int8 FloatType = System::Int8(0x4);
	
	static const System::Int8 DoubleType = System::Int8(0x5);
	
	static const System::Int8 NumericType = System::Int8(0x6);
	
	static const System::Int8 DecimalType = System::Int8(0x7);
	
	static const System::Int8 DateType = System::Int8(0x8);
	
	static const System::Int8 TimeType = System::Int8(0x9);
	
	static const System::Int8 TimestampType = System::Int8(0xa);
	
	static const System::Int8 BlobType = System::Int8(0xb);
	
	static const System::Int8 BigintType = System::Int8(0xc);
	
	static const System::Int8 DefaultCharset = System::Int8(0x0);
	
	static const System::Int8 CharsetUnicodeFss = System::Int8(0x3);
	
	static const System::Int8 CharsetSjis208 = System::Int8(0x5);
	
	static const System::Int8 CharsetEucj208 = System::Int8(0x6);
	
	
private:
	static const System::Int8 TypesCount = System::Int8(0xd);
	
	#define TDBXOpenODBCMetaDataReaderFirebird_DefaultStringStart L"DEFAULT "
	
	#define TDBXOpenODBCMetaDataReaderFirebird_DefaultCharsetIsUnicode L"UnicodeEncoding"
	
	#define TDBXOpenODBCMetaDataReaderFirebird_QuoteCharacterEnabled L"QuoteCharEnabled"
	
	static const System::Int8 ColumnsFieldType = System::Int8(0x4);
	
	static const System::Int8 ColumnsSubtype = System::Int8(0xc);
	
	static const System::Int8 ParametersFieldType = System::Int8(0x5);
	
	static const System::Int8 ParametersSubtype = System::Int8(0xa);
	
	bool FDefaultCharSetIsUnicode;
	Data::Dbxmetadatareader::TDBXDataTypeDescriptionArray FAlltypes;
	
protected:
	Data::Dbxmetadatareader::TDBXDataTypeDescriptionArray __fastcall GetAllDataTypes(void);
	virtual void __fastcall SetContext(Data::Dbxmetadatareader::TDBXProviderContext* const Context);
	virtual System::UnicodeString __fastcall GetProductName(void);
	virtual System::UnicodeString __fastcall GetSqlForTables(void);
	virtual System::UnicodeString __fastcall GetSqlForColumns(void);
	virtual System::UnicodeString __fastcall GetSqlForIndexes(void);
	virtual System::UnicodeString __fastcall GetSqlForIndexColumns(void);
	virtual Data::Dbxplatform::TDBXStringArray __fastcall GetReservedWords(void);
	virtual bool __fastcall IsDescendingIndexColumnsSupported(void);
	virtual Data::Dbxmetadatareader::TDBXDataTypeDescriptionArray __fastcall GetDataTypeDescriptions(void);
	
public:
	__fastcall virtual ~TDBXOpenODBCMetaDataReaderFirebird(void);
public:
	/* TDBXOpenODBCMetaDataReader.Create */ inline __fastcall virtual TDBXOpenODBCMetaDataReaderFirebird(void) : Dbx34drv::TDBXOpenODBCMetaDataReader() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TDBXOpenODBCMetaDataCommandFactoryInterbase : public Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom
{
	typedef Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom inherited;
	
protected:
	__classmethod virtual Dbx34drv::TDBXOpenODBCMetaDataReaderClass __fastcall GetMetaDataReaderClass();
public:
	/* TObject.Create */ inline __fastcall TDBXOpenODBCMetaDataCommandFactoryInterbase(void) : Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TDBXOpenODBCMetaDataCommandFactoryInterbase(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TDBXOpenODBCMetaDataReaderInterbase : public Dbx34drv::TDBXOpenODBCMetaDataReader
{
	typedef Dbx34drv::TDBXOpenODBCMetaDataReader inherited;
	
public:
	static const System::Int8 CharType = System::Int8(0x0);
	
	static const System::Int8 VarcharType = System::Int8(0x1);
	
	static const System::Int8 IntegerType = System::Int8(0x2);
	
	static const System::Int8 SmallintType = System::Int8(0x3);
	
	static const System::Int8 FloatType = System::Int8(0x4);
	
	static const System::Int8 DoubleType = System::Int8(0x5);
	
	static const System::Int8 NumericType = System::Int8(0x6);
	
	static const System::Int8 DecimalType = System::Int8(0x7);
	
	static const System::Int8 DateType = System::Int8(0x8);
	
	static const System::Int8 TimeType = System::Int8(0x9);
	
	static const System::Int8 TimestampType = System::Int8(0xa);
	
	static const System::Int8 BlobType = System::Int8(0xb);
	
	static const System::Int8 BooleanType = System::Int8(0xc);
	
	static const System::Int8 DefaultCharset = System::Int8(0x0);
	
	static const System::Int8 CharsetUnicodeFss = System::Int8(0x3);
	
	static const System::Int8 CharsetSjis208 = System::Int8(0x5);
	
	static const System::Int8 CharsetEucj208 = System::Int8(0x6);
	
	
private:
	static const System::Int8 TypesCount = System::Int8(0xd);
	
	#define TDBXOpenODBCMetaDataReaderInterbase_DefaultStringStart L"DEFAULT "
	
	#define TDBXOpenODBCMetaDataReaderInterbase_DefaultCharsetIsUnicode L"UnicodeEncoding"
	
	#define TDBXOpenODBCMetaDataReaderInterbase_QuoteCharacterEnabled L"QuoteCharEnabled"
	
	static const System::Int8 ColumnsFieldType = System::Int8(0x4);
	
	static const System::Int8 ColumnsSubtype = System::Int8(0xc);
	
	static const System::Int8 ParametersFieldType = System::Int8(0x5);
	
	static const System::Int8 ParametersSubtype = System::Int8(0xa);
	
	bool FDefaultCharSetIsUnicode;
	Data::Dbxmetadatareader::TDBXDataTypeDescriptionArray FAlltypes;
	
protected:
	Data::Dbxmetadatareader::TDBXDataTypeDescriptionArray __fastcall GetAllDataTypes(void);
	virtual void __fastcall SetContext(Data::Dbxmetadatareader::TDBXProviderContext* const Context);
	virtual System::UnicodeString __fastcall GetProductName(void);
	virtual System::UnicodeString __fastcall GetSqlForTables(void);
	virtual System::UnicodeString __fastcall GetSqlForColumns(void);
	virtual System::UnicodeString __fastcall GetSqlForIndexes(void);
	virtual System::UnicodeString __fastcall GetSqlForIndexColumns(void);
	virtual Data::Dbxplatform::TDBXStringArray __fastcall GetReservedWords(void);
	virtual bool __fastcall IsDescendingIndexColumnsSupported(void);
	virtual Data::Dbxmetadatareader::TDBXDataTypeDescriptionArray __fastcall GetDataTypeDescriptions(void);
	
public:
	__fastcall virtual ~TDBXOpenODBCMetaDataReaderInterbase(void);
public:
	/* TDBXOpenODBCMetaDataReader.Create */ inline __fastcall virtual TDBXOpenODBCMetaDataReaderInterbase(void) : Dbx34drv::TDBXOpenODBCMetaDataReader() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TDBXOpenODBCMetaDataCommandFactorySQLite : public Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom
{
	typedef Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom inherited;
	
protected:
	__classmethod virtual Dbx34drv::TDBXOpenODBCMetaDataReaderClass __fastcall GetMetaDataReaderClass();
public:
	/* TObject.Create */ inline __fastcall TDBXOpenODBCMetaDataCommandFactorySQLite(void) : Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TDBXOpenODBCMetaDataCommandFactorySQLite(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
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

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TDBXOpenODBCMetaDataCommandFactoryPostgreSQL : public Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom
{
	typedef Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom inherited;
	
protected:
	__classmethod virtual Dbx34drv::TDBXOpenODBCMetaDataReaderClass __fastcall GetMetaDataReaderClass();
public:
	/* TObject.Create */ inline __fastcall TDBXOpenODBCMetaDataCommandFactoryPostgreSQL(void) : Dbx34drv::TDBXOpenODBCMetaDataCommandFactoryCustom() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TDBXOpenODBCMetaDataCommandFactoryPostgreSQL(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TDBXOpenODBCMetaDataReaderPostgreSQL : public Dbx34drv::TDBXOpenODBCMetaDataReader
{
	typedef Dbx34drv::TDBXOpenODBCMetaDataReader inherited;
	
protected:
	virtual System::UnicodeString __fastcall GetSqlForTables(void);
	virtual System::UnicodeString __fastcall GetSqlForColumns(void);
	virtual System::UnicodeString __fastcall GetSqlForIndexes(void);
	virtual System::UnicodeString __fastcall GetSqlForIndexColumns(void);
	virtual Data::Dbxplatform::TDBXStringArray __fastcall GetReservedWords(void);
public:
	/* TDBXOpenODBCMetaDataReader.Create */ inline __fastcall virtual TDBXOpenODBCMetaDataReaderPostgreSQL(void) : Dbx34drv::TDBXOpenODBCMetaDataReader() { }
	
public:
	/* TDBXBaseMetaDataReader.Destroy */ inline __fastcall virtual ~TDBXOpenODBCMetaDataReaderPostgreSQL(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Dbx34drvdbms */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_DBX34DRVDBMS)
using namespace Dbx34drvdbms;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Dbx34drvdbmsHPP
