program nop;

{$O+,D-,R-}

{ Relocation info stripped from file. }
const
  IMAGE_FILE_RELOCS_STRIPPED = $0001;
{$SetPEFlags IMAGE_FILE_RELOCS_STRIPPED}

begin
  { empty }
end.
