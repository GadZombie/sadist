{$F+,X+,D+,O-,G+}

{************************************************}
{*                                              *}
{* Nazwa modulu     :  XMS                      *}
{* Wersja           :  2.10                     *}
{* Kompilowane w    :  Turbo Pascal ver. 7.0    *}
{* Procesor         :  80286 i lepszy           *}
{* Co-procesor      :  niepotrzebny             *}
{* Autor            :  Buk Mariusz              *}
{* Data             :  06 I 1995                *}
{* Miejsce          :  Chorzow, Polska          *}
{*                                              *}
{* Opis:                                        *}
{*                                              *}
{*   Ta wersja modulu XMS pozwala na bardzo     *}
{*   prosta obsluge pamieci XMS i blokow UMB    *}
{*   oraz umozliwia stwierdzenie obecnosci      *}
{*   pamieci wyzszej HMA.                       *}
{*                                              *}
{************************************************}

Unit XMS;

interface


{ Funkcje obslugi pamieci rozszerzonej XMS. }

function IsXMS : Boolean;

function XMSVersion : Word;
function XMSDrvVersion : Word;

function XMSMaxAvail : LongInt;
function XMSMemAvail : LongInt;

function XMSGetMem(var Handle : Word; Size : LongInt): Byte;
function XMSFreeMem(var Handle : Word) : Byte;
function XMSChangeSize(Handle : Word; NewSize : LongInt) : Byte;

function XMS2XMS(SourceHandle : Word; SHandleOffset : LongInt;
  DestHandle : Word; DHandleOffset : LongInt; DataLength : LongInt) : Byte;
function XMS2Mem(SourceHandle : Word; SHandleOffset : LongInt; var Buf;
  DataLength : LongInt) : Byte;
function Mem2XMS(var Buf; DestHandle : Word; DHandleOffset : LongInt;
  DataLength : LongInt) : Byte;

function XMSBlockInfo(Handle : Word; var FreeHandles : Byte;
  var Size : LongInt) : Byte;

{ Funkcje nie opisane w ksiazce. }

function XMSLockBlock(Handle : Word) : Pointer;
function XMSUnLockBlock(Handle : Word) : Byte;


{ Funkcje obslugi blokow pamieci gornej UMB. }

function IsUMB : Boolean;

function UMBGetMem(var Seg : Word; Size : LongInt) : Byte;
function UMBFreeMem(var Seg : Word) : Byte;
function UMBChangeSize(Seg : Word; Size : LongInt) : Byte;

function UMBMaxAvail : LongInt;
function UMBGetMaxSize(Seg : Word) : LongInt;

function UMBSetAllocationStrategy(Strategy : Boolean) : Byte;
function UMBGetAllocationStrategy : Boolean;


{ Funkcja obslugi pamieci HMA. }

function IsHMA : Boolean;


{ Elementy obslugi bledow powstalych przy wspolpracy ze sterownikiem }
{ pamieci XMS.                                                       }

procedure XMSShowError(nr : Byte);
function XMSErrorMessage(nr : Byte) : string;


const

  { Stala HandleNull oznacza brak uchwytu. }

  HandleNull = 0;


  { Literal XMSRunWhenError wskazuje, czy blad operacji ma spowodowac }
  { uruchomienie procedury obslugi bledow sterownika pamieci XMS.     }
  {   TRUE  - reakcja taka ma miec miejsce                            }
  {   FALSE - zaniechanie w/w reakcji                                 }

  XMSRunWhenError : Boolean = False;


  { Stale bledow: }

  xmsOk                  = $00; { operacja przeprowadzona poprawnie }
  umbOk                  = $00; { operacja przeprowadzona poprawnie }
  xmsError               = $01; { brak sterownika lub pamieci XMS   }
  umbError               = $02; { brak dostepu do UMBs              }
  xmsInvalidNumber       = $80; { bledny numer funkcji              }
  xmsExistVDisk          = $81; { w pamieci rezyduje ster. VDisk    }
  xmsA20Error            = $82; { blad linii A20                    }
  xmsInternalError1      = $8E; { blad wewnetrzny sterownika        }
  xmsInternalError2      = $8F; { blad wewnetrzny sterownika        }
  xmsOutOfMemory         = $A0; { zbyt malo wolnej pamieci XMS      }
  xmsNoHandles           = $A1; { brak uchwytow                     }
  xmsInvalidHandle       = $A2; { bledny uchwyt                     }
  xmsInvalidSourceHandle = $A3; { bledny uchwyt zrodlowy            }
  xmsInvalidSourceOffset = $A4; { bledny adres zrodlowy             }
  xmsInvalidDestHandle   = $A5; { bledny uchwyt docelowy            }
  xmsInvalidDestOffset   = $A6; { bledny adres docelowy             }
  xmsInvalidDataLength   = $A7; { bledna dlugosc danych             }
  xmsMemoryError         = $A8; { obszary pamieci XMS nakladaja sie }
  xmsParityError         = $A9; { blad parzystosci                  }
  xmsBlockIsUnLocked     = $AA; { blok pamieci nie jest zablokowany }
  xmsBlockIsLocked       = $AB; { blok pamieci jest zablokowany     }
  xmsLocksOverflow       = $AC; { przepelnienie licznika blokad     }
  xmsLockError           = $AD; { blad przy probie zablokowania     }
  umbBlocksAreDestroyed  = $B0; { uszkodzona struktura nag. blok. p.}
  umbAvailableLowBlock   = $B1; { dostepny mniejszy blok UMB        }
  umbInvalidSegment      = $B2; { bledny adres segmentowy bloku UMB }


{ Stale wyboru strategii przydzialu bloku pamieci UMB. }

const
  NormalStrategy = False;    { normalna  }
  BestStrategy   = True;     { najlepsza }


{ Typ proceduralny XMSErrorProcedure uzywany jest przy deklarowaniu }
{ nowej procedury obslugi bledow.                                   }

type
  XMSErrorProcedure = procedure(nr : Byte);


{ Literal XMSErrProc wskazuje na procedure, ktora bedzie urucho- }
{ miona w celu obslugi bledu powstalego przy wspolpracy ze       }
{ sterownikiem pamieci XMS i nie tylko.                          }

const
  XMSErrProc : XMSErrorProcedure = XMSShowError;

var

  _xms:array[0..20] of record
                       h:word;
                       os:longint;
                       end;

implementation


{ --------------- }
{ OBIEKTY LOKALNE }
{ --------------- }


{ Typ uzywany wewnetrznie przez modul do transmisji danych. }

type
  DataTransfer = record
    DataLength   : LongInt;
    SourceHandle : Word;
    SourceOffset : Pointer;
    DestHandle   : Word;
    DestOffset   : Pointer;
  end;


{ zmienne: }

var
  XMSActive   : Boolean;        { wskaznik obecnosci sterownika pamieci XMS  }
  XMSFuncAddr : Pointer;        { adres sterownika pamieci XMS               }
  UMBExist    : Boolean;        { wskaznik obecnosci blokow pamieci UMB      }
  AllStrategy : Boolean;        { aktualnie wybrana strategia alok. pamieci  }
  TData       : DataTransfer;   { struktura niezbedna przy przesyl. danych   }


Function StrPas(P : PChar) : string; assembler;
asm
   push ds
   lds  si, p
   les  di, @Result
   inc  di
   mov  cx, 255
@hop:
   lodsb
   cmp  al, 00h
   je   @koniec
   stosb
   loop @hop
@koniec:
   mov  ax, 255
   sub  ax, cx
   les  di, @Result
   mov  byte ptr es:[di], al
   pop  ds
end;


{ Wykonanie funkcji sterownika pamieci XMS. }
{   We:                                     }
{     AH - numer funkcji                    }
{   Wy:                                     }
{     DX, AX - wynik funkcji                }
{     BL     - kod bledu (jesli AX=0)       }

Function ExecFunc : Word; near; assembler;
asm
  CALL  dword ptr [XMSFuncAddr]          { wywolanie funkcji sterownika   }
  AND   AX, AX                           { tymczasowy kod wyjscia : xmsOk }
  MOV   AL, xmsOk
  JNZ   @dalej                           { jesli ok to zakoncz            }
  CMP   [XMSRunWhenError], 00h           { jesli mozna wywolac procedure  }
  JE    @d1                              {   obslugi bledow to zrob to    }
  PUSH  BX
  PUSH  DX
  PUSH  BX
  CALL  dword ptr [XMSErrProc]
  POP   DX
  POP   BX

  @d1:
  MOV   AL, BL                           { do AL - kod bledu              }

  @dalej:
end;


{ Przetestowanie obecnosci pamieci XMS i sterownika tej pamieci. }
{ W razie bledu uruchomienie odpowiedniej procedury informujacej }
{ o bledzie (jesli zmienna XMSRunWhenError=True). Funkcja zwraca }
{ xmsError lub xmsOk. ZF=1 jesli blad.                           }

Function TestXMS : Byte; near; assembler;
asm
  XOR   AL, AL                           { tymczasowy kod wyjscia : xmsOk   }
  CMP   [XMSActive], AL                  { jesli ok to zakoncz              }
  PUSHF
  JNE   @dalej

  CMP   [XMSRunWhenError], AL            { jesli mozna wywolac procedure    }
  JE    @d1                              {   obslugi bledow to zrob to,     }
  MOV   AL, xmsError                     {   a wynikiem funkcji niech       }
  PUSH  AX
  CALL  dword ptr [XMSErrProc]
  @d1:
  MOV   AL, xmsError                     {   bedzie xmsError                }

  @dalej:
  POPF
end;


{ Funkcja testujaca obecnosc blokow pamieci gornej UMB i w razie }
{ niepowodzenia obslugujaca powstaly blad.                       }
{ Funkcja zwraca kod bledu i ustawia ZF jezeli jest blad.        }

Function TestUMB : Byte; near; assembler;
asm
  XOR   AL, AL                           { tymczasowy kod wyjscia : umbOk   }
  CMP   [UMBExist], AL                   { jesli ok to zakoncz              }
  PUSHF
  JNE   @dalej

  CMP   [XMSRunWhenError], AL            { jesli mozna wywolac procedure    }
  JE    @d1                              {   obslugi bledow to zrob to,     }
  MOV   AL, umbError                     {   a wynikiem funkcji niech       }
  PUSH  AX
  CALL  dword ptr [XMSErrProc]
  @d1:
  MOV   AL, umbError                     {   bedzie umbError                }

  @dalej:
  POPF
end;


{ Przeliczenie kodu zwroconego przez DOS na kod bledu sterownika XMS. }

Function CalcCode : Word; near; assembler;
asm
  PUSHF
  JNC   @dalej
  MOV   BX, AX
  XOR   AX, AX
  ADD   BX, 169d
  PUSH  BX
  CMP   [XMSRunWhenError], 00h           { jesli mozna wywolac procedure    }
  JE    @d1                              {   obslugi bledow to zrob to,     }
  PUSH  BX                               {   a wynikiem funkcji niech       }
  CALL  dword ptr [XMSErrProc]
  @d1:
  POP   AX                               {   kod bledu                      }
  @dalej:
  POPF
end;


{ Funkcja przesylajaca dane.          }
{ Zwraca kod bledu lub wartosc xmsOk. }

Function Move(DataLength : LongInt; SourceHandle : Word;
  SourceOffset : Pointer; DestHandle : Word; DestOffset : Pointer) : Byte;
  near; assembler;
asm
  CALL  TestXMS                                  { jesli blad to zakoncz }
  JZ    @dalej

  MOV   AX, word ptr [DataLength]                { ustal                 }
  TEST  AX, 01h                                  {   poprawiona          }
  JZ    @ok
  INC   AX
  @ok:                                           {   dlugosc danych      }
  MOV   word ptr [TData.DataLength], AX
  MOV   AX, word ptr [DataLength+2]
  MOV   word ptr [TData.DataLength+2], AX
  MOV   AX, [SourceHandle]                       { ustal SourceHandle    }
  MOV   [TData.SourceHandle], AX
  MOV   AX, [DestHandle]                         { ustal DestHandle      }
  MOV   [TData.DestHandle], AX
  MOV   AX, word ptr [SourceOffset]              { ustal SourceOffset    }
  MOV   word ptr [TData.SourceOffset], AX
  MOV   AX, word ptr [SourceOffset+2]
  MOV   word ptr [TData.SourceOffset+2], AX
  MOV   AX, word ptr [DestOffset]                { ustal DestOffset      }
  MOV   word ptr [TData.DestOffset], AX
  MOV   AX, word ptr [DestOffset+2]
  MOV   word ptr [TData.DestOffset+2], AX
  LEA   SI, [TData]
  MOV   AH, 0bh                                  { nr funkcji            }
  CALL  ExecFunc                                 { wywolaj transfer      }

  @dalej:
end;


{ ---------------- }
{ OBIEKTY GLOBALNE }
{ ---------------- }


{ ---------------------------------------------------------------------- }
{ FUNKCJA TESTOWANIA OBECNOSCI STEROWNIKA PAMIECI XMS                    }
{ ---------------------------------------------------------------------- }


Function IsXMS : Boolean; assembler;
asm
  MOV   AL, [XMSActive]
end;


{ ---------------------------------------------------------------------- }
{ FUNKCJE TESTOWANIA WERSJI XMS                                          }
{ ---------------------------------------------------------------------- }


{ Pobranie wersji XMS w postaci kodu BCD  }
{ (np. wartosc 0235H oznacza wersje 2.35). }

Function XMSVersion : Word; assembler;
asm
  CALL  TestXMS
  MOV   AX, 00h
  JZ    @dalej

  CALL  ExecFunc

  @dalej:
end;


{ Pobranie wewnetrznej wersji programu obslugi XMS w postaci kodu BCD. }

Function XMSDrvVersion : Word; assembler;
asm
  CALL  TestXMS
  MOV   AX, 00h
  JZ    @dalej

  MOV   AH, 00h
  CALL  ExecFunc
  MOV   AX, BX

  @dalej:
end;


{ --------------------------------------------------------------------- }
{ FUNKCJE UMOZLIWIAJACE DOSTARCZENIE INFORMACJI O DOSTEPNEJ PAMIECI XMS }
{ --------------------------------------------------------------------- }


{ Pobranie wielkosci najwiekszego wolnego bloku w bajtach. }

Function XMSMaxAvail : LongInt; assembler;
asm
  CALL  TestXMS             { jesli blad to zakoncz }
  MOV   AX, 00h
  MOV   DX, AX
  JZ    @dalej

  MOV   AH, 08h             { pobierz rozmiar        }
  CALL  ExecFunc            { najwiekszego ciaglego  }
  MOV   DX, AX              { bloku pamieci XMS      }

  SHL   AX, 0ah             { konwersja do bajtow   }
  SHR   DX, 06h

  @dalej:
end;


{ Pobranie maksymalnej ilosci wolnej pamieci w bajtach. }

Function XMSMemAvail : LongInt; assembler;
asm
  CALL  TestXMS            { jesli blad to zakoncz   }
  MOV   AX, 00h
  JZ    @dalej

  MOV   AH, 08h             { pobierz calkowita ilosc }
  CALL  ExecFunc            {   wolnej pamieci        }
  MOV   AX, DX

  SHL   AX, 0ah             { konwersja do bajtow     }
  SHR   DX, 06h

  @dalej:
end;


{ -------------------------------------- }
{ FUNKCJE OPERUJACE NA BLOKU PAMIECI XMS }
{ -------------------------------------- }


{ Przydzielenie bloku pamieci XMS identyfikowanego przez Handle       }
{ o wielkosci Size bajtow.                                            }

Function XMSGetMem(var Handle : Word; Size : LongInt) : Byte; assembler;
asm
  LES   BX, [Handle]                      { zapisz do uchwytu wartosc }
  MOV   word ptr ES:[BX], HandleNull      {   HandleNull              }
  CALL  TestXMS                           { jesli blad to zakoncz     }
  JZ    @dalej

  XOR   BL, BL
  MOV   DX, word ptr [Size]               { konwersja do kB           }
  TEST  DX, 03ffh
  JNZ   @d1
  INC   BL
  @d1:
  SHR   DX, 0ah
  MOV   AX, word ptr [Size+2]
  SHL   AX, 06h
  OR    DX, AX
  AND   BL, BL
  JNZ   @d2
  INC   DX
  @d2:

  MOV   AH, 09h
  CALL  ExecFunc                         { przydziel pamiec          }
  LES   BX, [Handle]
  MOV   ES:[BX], DX                      { uaktualnij uchwyt         }

  @dalej:
end;


{ Zwolnienie bloku pamieci identyfikowanego przez Handle. }

Function XMSFreeMem(var Handle : Word) : Byte; assembler;
asm
  LES   AX, [Handle]
  CALL  TestXMS                          { jesli blad to zakoncz     }
  JZ    @dalej

  MOV   AH, 0ah
  LES   BX, [Handle]
  MOV   DX, ES:[BX]
  CALL  ExecFunc                         { zwolnij pamiec            }

  @dalej:
  LES   BX, [Handle]                     { zapisz do uchwytu wartosc }
  MOV   word ptr ES:[BX], HandleNull     {   HandleNull              }
end;


{ Funkcja zmieniajaca rozmiar bloku identyfikowanego przez Handle. }

Function XMSChangeSize(Handle : Word; NewSize : LongInt) : Byte; assembler;
asm
  CALL  TestXMS
  JZ    @dalej

  XOR   DL, DL
  MOV   BX, word ptr [NewSize]           { konwersja do kB           }
  TEST  BX, 03ffh
  JNZ   @d1
  INC   DL
  @d1:
  SHR   BX, 0ah
  MOV   AX, word ptr [NewSize+2]
  SHL   AX, 06h
  OR    BX, AX
  AND   DL, DL
  JNZ   @d2
  INC   BX
  @d2:

  MOV   DX, [Handle]
  MOV   AH, 0fh                       { pobierz informacje }
  CALL  ExecFunc

  @dalej:
end;


{ --------------------------------------------------------- }
{ FUNKCJE UMOZLIWIAJACE TRANSMISJE DANYCH DO/Z PAMIECI XMS. }
{ --------------------------------------------------------- }


{ Kopiowanie danych z pamieci XMS do pamieci XMS. }

Function XMS2XMS(SourceHandle : Word; SHandleOffset : LongInt;
  DestHandle : Word; DHandleOffset : LongInt; DataLength : LongInt) : Byte;
begin
  if (DestHandle=HandleNull) or (SourceHandle=HandleNull) then
    begin
      if XMSRunWhenError then XMSErrProc(xmsInvalidHandle);
      XMS2XMS:=xmsInvalidHandle
    end
   else
    XMS2XMS:=Move(DataLength, SourceHandle, Pointer(SHandleOffset),
      DestHandle, Pointer(DHandleOffset))
end;


{ Kopiowanie danych z pamieci XMS do pamieci konwencjonalnej. }

Function XMS2Mem(SourceHandle : Word; SHandleOffset : LongInt; var Buf;
  DataLength : LongInt) : Byte;
begin
  if SourceHandle=HandleNull then
    begin
      if XMSRunWhenError then XMSErrProc(xmsInvalidSourceHandle);
      XMS2Mem:=xmsInvalidSourceHandle
    end
   else
    XMS2Mem:=Move(DataLength, SourceHandle, Pointer(SHandleOffset),
      HandleNull, @Buf)
end;


{ Kopiowanie danych z pamieci konwencjonalnej do pamieci XMS. }

Function Mem2XMS(var Buf; DestHandle : Word; DHandleOffset : LongInt;
  DataLength : LongInt) : Byte;
begin
  if DestHandle=HandleNull then
    begin
      if XMSRunWhenError then XMSErrProc(xmsInvalidDestHandle);
      Mem2XMS:=xmsInvalidDestHandle
    end
   else
    Mem2XMS:=Move(DataLength, HandleNull, @Buf, DestHandle,
      Pointer(DHandleOffset))
end;


{ ----------------------------------------------- }
{ FUNKCJA PODAJACA INFORMACJE O BLOKU PAMIECI XMS }
{ ----------------------------------------------- }


Function XMSBlockInfo(Handle : Word; var FreeHandles : Byte;
  var Size : LongInt) : Byte; assembler;
asm
  CALL  TestXMS
  JZ    @dalej

  MOV   DX, [Handle]
  MOV   AH, 0eh                       { pobierz informacje }
  CALL  ExecFunc

  PUSH  AX

  LES   BX, [FreeHandles]
  MOV   byte ptr ES:[BX], BL

  MOV   AX, DX
  SHL   AX, 0ah                       { konwersja do bajtow     }
  SHR   DX, 06h

  LES   BX, [Size]
  MOV   word ptr ES:[BX], AX
  MOV   word ptr ES:[BX+2], DX

  POP   AX

  @dalej:
end;


{ ---------------------------------------------- }
{ FUNKCJE NIE OPISANE OBSLUGI BLOKOW PAMIECI XMS }
{ ---------------------------------------------- }


{ Zablokowanie bloku pamieci. Funkcja zwraca adres liniowy bloku. }

function XMSLockBlock(Handle : Word) : Pointer; assembler;
asm
  CALL  TestXMS                          { jesli blad to zakoncz     }
  JNZ   @ok
  XOR   DX, DX
  XOR   AX, AX
  JMP   @koniec
@ok:

  MOV   AH, 0ch
  MOV   DX, [Handle]
  CALL  ExecFunc                         { zablokuj blok             }

  MOV   AX, BX

@koniec:
end;


{ Odblokowanie bloku pamieci. Funkcja zwraca kod bledu. }

function XMSUnLockBlock(Handle : Word) : Byte; assembler;
asm
  CALL  TestXMS                          { jesli blad to zakoncz     }
  JZ    @dalej

  MOV   AH, 0dh
  MOV   DX, [Handle]
  CALL  ExecFunc                         { odblokuj blok             }

@dalej:
end;


{ ----------------------------------------- }
{ FUNKCJE OBSLUGI BLOKOW PAMIECI GORNEJ UMB }
{ ----------------------------------------- }


{ Sprawdzenie istnienia blokow pamieci gornej UMB. }

Function IsUMB : Boolean; assembler;
asm
  MOV   AL, [UMBExist]
end;


{ Przydzielenie bloku pamieci UMB. }

Function UMBGetMem(var Seg : Word; Size : LongInt) : Byte; assembler;
var
  strat : Word;
asm
  LES   BX, [&Seg]                      { zapisz do segmentu wartosc 0 }
  MOV   word ptr ES:[BX], 00h

  CALL  TestUMB                         { jesli blad to zakoncz     }
  JZ    @dalej

  MOV   AX, 5800h                       { zapamietaj i zmien        }
  INT   21h                             { strategie przydzialu      }
  MOV   [strat], AX                     { pamieci                   }
  MOV   AX, 5801h
  MOV   BX, 0040h
  ADD   BL, [AllStrategy]
  INT   21h

  XOR   DL, DL
  MOV   BX, word ptr [Size]             { konwersja do paragrafu    }
  TEST  BX, 0fh
  JZ    @d1
  INC   DL
  @d1:
  SHR   BX, 04h
  MOV   AX, word ptr [Size+2]
  SHL   AX, 0ch
  OR    BX, AX
  AND   DL, DL
  JZ    @d2
  INC   BX
  @d2:

  MOV   AH, 48h
  INT   21h                              { przydziel pamiec          }
  CALL  CalcCode
  PUSH  AX
  JC    @d3
  LES   SI, [&Seg]
  MOV   ES:[SI], AX                      { zapisz adres segmentu     }
  POP   AX
  XOR   AX, AX
  PUSH  AX
  @d3:
  MOV   AX, 5801h                        { przywroc strategie        }
  MOV   BX, [strat]
  INT   21h
  POP   AX

  @dalej:
end;


{ Zwolnienie bloku pamieci UMB. }

Function UMBFreeMem(var Seg : Word) : Byte; assembler;
asm
  CALL  TestUMB
  JZ    @dalej

  LES   BX, [&Seg]
  MOV   ES, word ptr ES:[BX]
  MOV   AH, 49h
  INT   21h
  CALL  CalcCode
  JC    @dalej

  LES   BX, [&Seg]                      { zapisz do segmentu wartosc 0 }
  MOV   word ptr ES:[BX], 00h
  XOR   AX, AX

  @dalej:
end;


{ Pobranie najwiekszego wolnego bloku pamieci UMB. }

Function UMBMaxAvail : LongInt; assembler;
asm
  CALL  TestUMB                         { jesli blad to zakoncz     }
  MOV   AX, 00h
  MOV   DX, AX
  JZ    @dalej

  MOV   BX, 0ffffh
  MOV   AH, 48h
  INT   21h                             { sprawdz przydzial pamieci }
  JNC   @d1
  CMP   AX, 08h
  JE    @d1
  CALL  CalcCode
  XOR   AX, AX
  XOR   DX, DX
  JMP   @dalej

  @d1:
  MOV   AX, BX
  MOV   DX, AX
  SHL   AX, 04h                         { konwersja do bajtow     }
  SHR   DX, 0ch

  @dalej:
end;


{ Zmiana dlugosci bloku pamieci gornej. }

Function UMBChangeSize(Seg : Word; Size : LongInt) : Byte; assembler;
asm
  CALL  TestUMB                         { jesli blad to zakoncz     }
  JZ    @dalej

  XOR   DL, DL
  MOV   BX, word ptr [Size]             { konwersja do paragrafu    }
  TEST  BX, 0fh
  JZ    @d1
  INC   DL
  @d1:
  SHR   BX, 04h
  MOV   AX, word ptr [Size+2]
  SHL   AX, 0ch
  OR    BX, AX
  AND   DL, DL
  JZ    @d2
  INC   BX
  @d2:

  MOV   AH, 4Ah
  MOV   ES, [&seg]
  INT   21h                              { zmien rozmiar bloku       }
  CALL  CalcCode
  JC    @dalej
  XOR   AL, AL

  @dalej:
end;


{ Pobranie maksymalnej wielkosci mozliwej dla danego bloku. }

Function UMBGetMaxSize(Seg : Word) : LongInt; assembler;
asm
  CALL  TestUMB                         { jesli blad to zakoncz     }
  JZ    @dalej

  MOV   AH, 4Ah
  MOV   ES, [&seg]
  MOV   BX, 0ffffh
  INT   21h                              { sprawdz zmieniony rozmiar }
  JNC   @d1                              { bloku                     }
  CMP   AX, 08h
  JE    @d1
  CALL  CalcCode
  XOR   AX, AX
  XOR   DX, DX
  JMP   @dalej

  @d1:
  MOV   AX, BX
  MOV   DX, AX

  SHL   AX, 04h                          { konwersja do bajtow }
  SHR   DX, 0ch

  @dalej:
end;


{ Zmiana strategii przydzialu bloku pamieci gornej UMB. }

Function UMBSetAllocationStrategy(Strategy : Boolean) : Byte; assembler;
asm
  MOV   AL, [Strategy]
  MOV   [AllStrategy], AL
end;


{ Pobranie aktualnie obowiazujacej strategii. }

Function UMBGetAllocationStrategy : Boolean; assembler;
asm
  MOV   AL, [AllStrategy]
end;


{ -------------------------------------------------- }
{ FUNKCJA SPRAWDZAJACA ISTNIENIE PAMIECI WYZSZEJ HMA }
{ -------------------------------------------------- }


Function IsHMA : Boolean; assembler;
asm
  CALL  TestXMS
  MOV   AX, 00h
  JZ    @dalej

  CALL  ExecFunc
  MOV   AL, DL

  @dalej:
end;


{ ----------------------------------------------------------------------- }
{ FUNKCJE OBSLUGUJACE BLEDY POWSTALE PRZY WSPOLPRACY ZE STER. PAMIECI XMS }
{ ----------------------------------------------------------------------- }


{ Standardowa procedura obslugi bledow.                              }
{ Wypisuje ona komunikat o bledzie, jesli ten bedzie rozny od xmsOk. }

Procedure XMSShowError(nr : Byte);
var
  mess : string;
begin
  if nr<>xmsOk then
    begin
      mess:=XMSErrorMessage(nr)+'.';
      mess[1]:=UpCase(mess[1]);
      WriteLn(#$07, mess)
    end
end;


{ Funkcja, ktorej rezultatem jest lancuch z komunikatem o bledzie nr NR. }

Function XMSErrorMessage(nr : Byte) : string;
const
  Message : array [0..24] of PChar =
    ('',
     '',
     '',
     '',
     '',
     '',
     '',
     '',
     '',
     '',
     '',
     '',
     '',
     '',
     '',
     '',
     '',
     '',
     '',
     '',
     '',
     '',
     '',
     '',
     '');
begin
  case nr of
    xmsOk, xmsError, umbError                : ;
    xmsInvalidNumber..xmsA20Error            : Dec(nr, xmsInvalidNumber-$03);
    xmsInternalError1, xmsInternalError2     : nr:=6;
    xmsOutOfMemory..xmsLockError             : Dec(nr, xmsOutOfMemory-$07);
    umbBlocksAreDestroyed..umbInvalidSegment : Dec(nr, umbBlocksAreDestroyed-$15)
    else                                       nr:=24
  end;
  XMSErrorMessage:=StrPas(Message[nr])
end;


{ --------------------------------------------------------------------------}


begin
  asm
    MOV   AX, 5803h               { proba dolaczenia blokow UMB               }
    MOV   BX, 01h                 {  w przypadku bledu zapisanie do zmiennej  }
    MOV   [UMBExist], 00h         {  UMBExist wartosci False, w przeciwnym -  }
    INT   21h                     {  True                                     }
    JC    @dalej
    MOV   [UMBExist], 01h
    MOV   [AllStrategy], 00h
    @dalej:
    MOV   [XMSActive], 00h      { jesli istnieje pamiec XMS i w pamieci     }
    MOV   AX, 4300h             {   rezyduje jej sterownik to wpisz jego    }
    INT   2fh                   {   adres pod zmienna XMSFuncAddr i ustaw   }
    CMP   AL, 80h               {   zmienna XMSActive (=True), w przeciwnym }
    JNE   @error                {   przypadku wyzeruj zmienna XMSActive     }
    MOV   [XMSActive], 01h      {   (=False)                                }
    MOV   AX, 4310h
    INT   2fh
    MOV   word ptr [XMSFuncAddr], BX
    MOV   word ptr [XMSFuncAddr+2], ES
    @error:
  end
end.
