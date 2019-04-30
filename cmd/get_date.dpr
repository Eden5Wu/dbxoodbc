// (c) "Vadim V.Lopushansky"<pult@ukr.net>, Kiev 2002 Year.
// Version 1.00

program get_date;

{$APPTYPE CONSOLE}
{$B-}
//{$O-,D+}
{$O+,D-,R-}

uses
  SysUtils;

{-------------------------------------------------------------------------------------------------}

const
  cVersion = '2007.06.14';

{ Relocation info stripped from file. }
const
  IMAGE_FILE_RELOCS_STRIPPED = $0001;
{$SetPEFlags IMAGE_FILE_RELOCS_STRIPPED}

{-------------------------------------------------------------------------------------------------}

var
  Year, Month, Day: Word;
  Hour, Min, Sec, MSec, i, p: Word;
  f:String; // input format
  ft :String = 'YMDhms';// template

function AddLeadZero(W:WORD; Len:WORD):String;
begin
    Result := IntToStr(W);
    for Len:=Len-1 DownTo Length(Result) do begin
        Result := '0'+Result;
    end;
end;

begin
  if (ParamCount=0)or(ParamStr(1)='/?') then begin
     WriteLn('usage as: getDate.exe [[Y][M][D][h][m][s]]   [/set|/?|/t]');
     WriteLn;
     WriteLn('   Y  - year');
     WriteLn('   M  - month');
     WriteLn('   D  - day');
     WriteLn('   h  - hours');
     WriteLn('   m  - minutes');
     WriteLn('   s  - second');
     WriteLn;
     WriteLn('   /set - print as envinronment');
     WriteLn;
     WriteLn('   /?   - print help');
     WriteLn;
     WriteLn('   /t   - print current full date as fixed format: "yyyy-MM-dd hh:mm:ss"');
     WriteLn;
     WriteLn('  examples:');
     WriteLn('   getDate.exe Y');
     WriteLn('   getDate.exe Y /set');
     WriteLn('   getDate.exe Y /set >current.bat');
     WriteLn('   getDate.exe');
     WriteLn('   getDate.exe YMDhms /set');
     WriteLn('   getDate.exe YMDhms /set >current.bat');

     Halt(1);

  end else if ParamStr(1)='/t' then begin

    ShortDateFormat := 'yyyy-MM-dd';
    LongTimeFormat  := 'hh:mm:ss';

    f := DateToStr( Date ) +' '+ TimeToStr(Time);
    WriteLn(f);

  end else begin

      DecodeDate(SysUtils.Date, Year, Month, Day);
      DecodeTime(SysUtils.Time, Hour, Min, Sec, MSec);

      if (ParamStr(2)='/set')or(ParamStr(1)='/set') then begin
        if (ParamStr(1)<>'/set')
        then f := ParamStr(1)
        else f:=ft;
        for i:=1 to Length(f) do begin
            p:=pos(f[i], ft);
            if p>0 then begin
                Delete(ft,p,1);
                case f[i] of
                    'Y': WriteLn('set _year=',  Year);
                    'M': WriteLn('set _month=', AddLeadZero(Month,2));
                    'D': WriteLn('set _day=',   AddLeadZero(Day,2));
                    'h': WriteLn('set _hour=',  AddLeadZero(Hour,2));
                    'm': WriteLn('set _min=',   AddLeadZero(Min,2));
                    's': WriteLn('set _sec=',   AddLeadZero(Sec,2));
                end;
            end else begin
               WriteLn('ERROR : unknown symbol "'+f[i]+'" in format :"'+f+'"');
               Halt(1);
            end;
        end;
      end else begin
        if ParamCount=0
        then f := ft
        else f := ParamStr(1);
        for i:=1 to Length(f) do begin
            p:=pos(f[i], ft);
            if p>0 then begin
                Delete(ft,p,1);
                case f[i] of
                    'Y': WriteLn(Year);
                    'M': WriteLn(AddLeadZero(Month,2));
                    'D': WriteLn(AddLeadZero(Day,2));
                    'h': WriteLn(AddLeadZero(Hour,2));
                    'm': WriteLn(AddLeadZero(Min,2));
                    's': WriteLn(AddLeadZero(Sec,2));
                end;
            end else begin
                WriteLn('ERROR : unknown symbol "'+f[i]+'" in format :"'+f+'"');
                Halt(1);
            end;
        end;
      end;
  end;
end.
