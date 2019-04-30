{ base64.inc }

type
{ TAnsiStringStream }

{$IFDEF UNICODE}
  TAnsiStringStream = class(TStream)
  private
    FDataString: AnsiString;
    FPosition: Integer;
  protected
    procedure SetSize(NewSize: Longint); override;
  public
    constructor Create(const AString: AnsiString);
    function Read(var Buffer; Count: Longint): Longint; override;
    function ReadString(Count: Longint): AnsiString;
    function Seek(Offset: Longint; Origin: Word): Longint; override;
    function Write(const Buffer; Count: Longint): Longint; override;
    procedure WriteString(const AString: AnsiString);
    property DataString: AnsiString read FDataString;
  end;
{$ELSE}
  TAnsiStringStream = TStringStream;
{$ENDIF}

{$IFDEF UNICODE}

constructor TAnsiStringStream.Create(const AString: AnsiString);
begin
  inherited Create;
  FDataString := AString;
end;

function TAnsiStringStream.Read(var Buffer; Count: Longint): Longint;
begin
  Result := Length(FDataString) - FPosition;
  if Result > Count then Result := Count;
  Move(PAnsiChar(@FDataString[FPosition + 1])^, Buffer, Result);
  Inc(FPosition, Result);
end;

function TAnsiStringStream.Write(const Buffer; Count: Longint): Longint;
begin
  Result := Count;
  SetLength(FDataString, (FPosition + Result));
  Move(Buffer, PAnsiChar(@FDataString[FPosition + 1])^, Result);
  Inc(FPosition, Result);
end;

function TAnsiStringStream.Seek(Offset: Longint; Origin: Word): Longint;
begin
  case Origin of
    soFromBeginning: FPosition := Offset;
    soFromCurrent: FPosition := FPosition + Offset;
    soFromEnd: FPosition := Length(FDataString) - Offset;
  end;
  if FPosition > Length(FDataString) then
    FPosition := Length(FDataString)
  else if FPosition < 0 then FPosition := 0;
  Result := FPosition;
end;

function TAnsiStringStream.ReadString(Count: Longint): AnsiString;
var
  Len: Integer;
begin
  Len := Length(FDataString) - FPosition;
  if Len > Count then Len := Count;
  SetString(Result, PAnsiChar(@FDataString[FPosition + 1]), Len);
  Inc(FPosition, Len);
end;

procedure TAnsiStringStream.WriteString(const AString: AnsiString);
begin
  Write(PAnsiChar(AString)^, Length(AString));
end;

procedure TAnsiStringStream.SetSize(NewSize: Longint);
begin
  SetLength(FDataString, NewSize);
  if FPosition > NewSize then FPosition := NewSize;
end;

{$ENDIF UNICODE}

// Base64

const
  EncodeTable: array[0..63] of AnsiChar =
  'ABCDEFGHIJKLMNOPQRSTUVWXYZ' +
    'abcdefghijklmnopqrstuvwxyz' +
    '0123456789+/';

  DecodeTable: array[#0..#127] of Integer = (
    Byte('='), 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64,
    64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64,
    64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 62, 64, 64, 64, 63,
    52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 64, 64, 64, 64, 64, 64,
    64, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14,
    15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 64, 64, 64, 64, 64,
    64, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
    41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 64, 64, 64, 64, 64);

type
  PPacket = ^TPacket;
  TPacket = packed record
    case Integer of
      0: (b0, b1, b2, b3: Byte);
      1: (i: Integer);
      2: (a: array[0..3] of Byte);
      3: (C: array[0..3] of AnsiChar);
  end;

procedure EncodePacket(const Packet: TPacket; NumChars: Integer; OutBuf: PAnsiChar);
begin
  OutBuf[0] := EncodeTable[Packet.a[0] shr 2];
  OutBuf[1] := EncodeTable[((Packet.a[0] shl 4) or (Packet.a[1] shr 4)) and $0000003F];
  if NumChars < 2 then
    OutBuf[2] := '='
  else
    OutBuf[2] := EncodeTable[((Packet.a[1] shl 2) or (Packet.a[2] shr 6)) and $0000003F];
  if NumChars < 3 then
    OutBuf[3] := '='
  else
    OutBuf[3] := EncodeTable[Packet.a[2] and $0000003F];
end;

function DecodePacket(InBuf: PAnsiChar; var nChars: Integer): TPacket;
begin
  Result.a[0] := (DecodeTable[InBuf[0]] shl 2) or
    (DecodeTable[InBuf[1]] shr 4);
  nChars := 1;
  if InBuf[2] <> '=' then
  begin
    Inc(nChars);
    Result.a[1] := Byte((DecodeTable[InBuf[1]] shl 4) or (DecodeTable[InBuf[2]] shr 2));
  end;
  if InBuf[3] <> '=' then
  begin
    Inc(nChars);
    Result.a[2] := Byte((DecodeTable[InBuf[2]] shl 6) or DecodeTable[InBuf[3]]);
  end;
end;

procedure Base64EncodeStream(Input, Output: TStream; LineWidthLimit: Integer = -1);
type
  PInteger = ^Integer;
var
  InBuf: array[0..509] of Byte;
  OutBuf: array[0..1023] of AnsiChar;
  BufPtr: PAnsiChar;
  i, j, k, BytesRead: Integer;
  Packet: TPacket;
begin
  if LineWidthLimit = 0 then
    LineWidthLimit := 75;
  k := 0;
  repeat
    BytesRead := Input.Read(InBuf, SizeOf(InBuf));
    i := 0;
    BufPtr := OutBuf;
    while i < BytesRead do
    begin
      if BytesRead - i < 3 then
        j := BytesRead - i
      else
        j := 3;
      Packet.i := 0;
      Packet.b0 := InBuf[i];
      if j > 1 then
        Packet.b1 := InBuf[i + 1];
      if j > 2 then
        Packet.b2 := InBuf[i + 2];
      EncodePacket(Packet, j, BufPtr);
      Inc(i, 3);
      Inc(BufPtr, 4);
      Inc(k, 4);
      if (LineWidthLimit > 0) and (k > LineWidthLimit) then
      begin
        BufPtr[0] := #$0D;
        BufPtr[1] := #$0A;
        Inc(BufPtr, 2);
        k := 0;
      end;
    end;
    Output.Write(OutBuf, BufPtr - PAnsiChar(@OutBuf));
  until BytesRead = 0;
end;

procedure Base64DecodeStream(Input, Output: TStream);
var
  InBuf: array[0..75] of AnsiChar;
  OutBuf: array[0..60] of Byte;
  InBufPtr, OutBufPtr: PAnsiChar;
  i, j, k, BytesRead: Integer;
  Packet: TPacket;

  procedure SkipWhite;
  var
    C: AnsiChar;
    NumRead: Integer;
  begin
    while True do
    begin
      NumRead := Input.Read(C, 1);
      if NumRead = 1 then
      begin
        if C in ['0'..'9', 'A'..'Z', 'a'..'z', '+', '/', '='] then
        begin
          Input.Position := Input.Position - 1;
          Break;
        end;
      end
      else
        Break;
    end;
  end;

  function ReadInput: Integer;
  var
    WhiteFound, EndReached: Boolean;
    CntRead, idx, IdxEnd: Integer;
  begin
    IdxEnd := 0;
    repeat
      WhiteFound := False;
      CntRead := Input.Read(InBuf[IdxEnd], (SizeOf(InBuf) - IdxEnd));
      EndReached := CntRead < (SizeOf(InBuf) - IdxEnd);
      idx := IdxEnd;
      IdxEnd := CntRead + IdxEnd;
      while (idx < IdxEnd) do
      begin
        if not (InBuf[idx] in ['0'..'9', 'A'..'Z', 'a'..'z', '+', '/', '=']) then
        begin
          Dec(IdxEnd);
          if idx < IdxEnd then
            Move(InBuf[idx + 1], InBuf[idx], IdxEnd - idx);
          WhiteFound := True;
        end
        else
          Inc(idx);
      end;
    until (not WhiteFound) or (EndReached);
    Result := IdxEnd;
  end;

begin
  repeat
    SkipWhite;
    {
    BytesRead := Input.Read(InBuf, SizeOf(InBuf));
    }
    BytesRead := ReadInput;
    InBufPtr := InBuf;
    OutBufPtr := @OutBuf;
    i := 0;
    while i < BytesRead do
    begin
      Packet := DecodePacket(InBufPtr, j);
      k := 0;
      while j > 0 do
      begin
        OutBufPtr^ := AnsiChar(Packet.a[k]);
        Inc(OutBufPtr);
        Dec(j);
        Inc(k);
      end;
      Inc(InBufPtr, 4);
      Inc(i, 4);
    end;
    Output.Write(OutBuf, OutBufPtr - PAnsiChar(@OutBuf));
  until BytesRead = 0;
end;

function Base64EncodeString(const Input: AnsiString; LineWidthLimit: Integer = -1): AnsiString;
//{$IFDEF D16_UP}
//  //Soap.EncdDecd.pas
//  //function  EncodeBase64(const Input: Pointer; Size: Integer): AnsiString;
//begin
//  Result := EncodeBase64(PAnsiChar(Input), Length(Input));
//end;
//{$ELSE}
var
  InStr, OutStr: TAnsiStringStream;
begin
  InStr := TAnsiStringStream.Create(Input);
  try
    OutStr := TAnsiStringStream.Create('');
    try
      Base64EncodeStream(InStr, OutStr, LineWidthLimit);
      Result := AnsiString(OutStr.DataString);
    finally
      OutStr.Free;
    end;
  finally
    InStr.Free;
  end;
end;
//{$ENDIF}


function Base64DecodeString(const Input: AnsiString): AnsiString;
//{$IFDEF D16_UP}
//  //Soap.EncdDecd.pas
//  //function  DecodeBase64(const Input: AnsiString): TBytes;
//var
//  B: TBytes;
//begin
//  B := DecodeBase64(Input);
//  SetLength(Result, Length(B));
//  Move(B[0], Result[1], Length(Result));
//end;
//{$ELSE}
var
  InStr, OutStr: TAnsiStringStream;
begin
  InStr := TAnsiStringStream.Create(Input);
  try
    OutStr := TAnsiStringStream.Create('');
    try
      Base64DecodeStream(InStr, OutStr);
      Result := AnsiString(OutStr.DataString);
    finally
      OutStr.Free;
    end;
  finally
    InStr.Free;
  end;
end;
//{$ENDIF}
