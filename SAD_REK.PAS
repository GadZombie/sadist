unit sad_rek;

interface

uses dos;

type
  rekordy_typ = array [1 .. 10] of record imie: string[10];
data:
string[10];
czas:
string[8];
trup:
longint;
end;

const
  rek_naglow: string[17] = 'SADIST rekordy±²1';

var
  rekordy: ^rekordy_typ;
  wcz_rek_naglow: string[17];
  miejsce: byte;
  trupy: longint;
  imie_sadysty: string[15];
  ostatni, teraz, suma: record g, m, s, ss: word;
end;

PROCEDURE uloz_rek;
  PROCEDURE zapisz_rek;
    PROCEDURE wczytaj_rek;
      PROCEDURE sprawdz_rek;
        PROCEDURE aktualizuj_aktualny_rek;

implementation

{ * } PROCEDURE uloz_rek;
var
  pk: longint;
  juz: boolean;
  a: byte;
  wyr: string;
begin
  repeat
    juz := true;
    for a := 10 downto 2 do
    begin
      if rekordy^[a].trup > rekordy^[a - 1].trup then
      begin
        wyr := rekordy^[a].imie;
        rekordy^[a].imie := rekordy^[a - 1].imie;
        rekordy^[a - 1].imie := wyr;
        wyr := rekordy^[a].data;
        rekordy^[a].data := rekordy^[a - 1].data;
        rekordy^[a - 1].data := wyr;
        wyr := rekordy^[a].czas;
        rekordy^[a].czas := rekordy^[a - 1].czas;
        rekordy^[a - 1].czas := wyr;
        pk := rekordy^[a].trup;
        rekordy^[a].trup := rekordy^[a - 1].trup;
        rekordy^[a - 1].trup := pk;
        juz := false;
        if a = miejsce then
          dec(miejsce);
      end;
    end;
  until juz;
end;

{ * } PROCEDURE zapisz_rek;
var
  plik: file;
  a, b: byte;
  wyr: string;
begin
  assign(plik, 'sadist.hsc');
  filemode := 1;
{$I-}
  rewrite(plik, 1);
  if IOResult = 0 then
  begin
    blockwrite(plik, rek_naglow, sizeof(rek_naglow));
    { blockwrite(plik,rekordy^,sizeof(rekordy^)); <-- TAK BYLO PRZEDTEM :)
      A TAK JEST TERAZ : }
    for a := 10 downto 1 do
    begin
      wyr := '          ';
      for b := 1 to length(rekordy^[a].data) do
        wyr[b] := chr(ord(rekordy^[a].data[b]) xor 214);
      blockwrite(plik, wyr, 11);
      wyr := 'íííííííííí';
      for b := 1 to length(rekordy^[a].imie) do
        wyr[11 - b] := chr(ord(rekordy^[a].imie[b]) xor 205);
      blockwrite(plik, wyr, 11);
    end;
    for a := 10 downto 1 do
      blockwrite(plik, rekordy^[a].trup, sizeof(rekordy^[a].trup));
    for a := 1 to 10 do
    begin
      wyr := '........';
      for b := 1 to length(rekordy^[a].czas) do
        wyr[b] := chr(ord(rekordy^[a].czas[b]) xor 139);
      blockwrite(plik, wyr, 9);
    end;
    close(plik);
  end;
{$I+}
end;

{ * } PROCEDURE wczytaj_rek;
var
  plik: file;
  a, b: byte;
  wyr: string;
begin
  assign(plik, 'sadist.hsc');
  filemode := 0;
{$I-}
  reset(plik, 1);
  if IOResult = 0 then
  begin
    blockread(plik, wcz_rek_naglow, sizeof(wcz_rek_naglow));
    if wcz_rek_naglow <> rek_naglow then
    begin
      { tak bylo przedtem }
      seek(plik, 0);
      blockread(plik, rekordy^, sizeof(rekordy^));
    end
    else
    begin
      { a tak jest teraz }
      for a := 10 downto 1 do
      begin
        blockread(plik, wyr, 11);
        rekordy^[a].data := '';
        for b := 1 to 10 do
          rekordy^[a].data := rekordy^[a].data + chr(ord(wyr[b]) xor 214);
        blockread(plik, wyr, 11);
        rekordy^[a].imie := '';
        for b := 1 to 10 do
          insert(chr(ord(wyr[b]) xor 205), rekordy^[a].imie, 0);
      end;
      for a := 10 downto 1 do
        blockread(plik, rekordy^[a].trup, sizeof(rekordy^[a].trup));
      for a := 1 to 10 do
      begin
        blockread(plik, wyr, 9);
        rekordy^[a].czas := '';
        for b := 1 to 8 do
          rekordy^[a].czas := rekordy^[a].czas + chr(ord(wyr[b]) xor 139);
      end;
    end;
    close(plik);
  end
  else
  begin
    for a := 1 to 10 do
    begin
      rekordy^[a].imie := '----------';
      rekordy^[a].data := '--.--.----';
      rekordy^[a].czas := '--:--:--';
      rekordy^[a].trup := 0;
    end;
  end;
{$I+}
end;

{ * } PROCEDURE sprawdz_rek;
var
  a, b, c, d: word;
  wyr, wyr2: string;
begin
  if trupy > rekordy^[10].trup then
  begin
    rekordy^[10].trup := trupy;
    rekordy^[10].imie := imie_sadysty;
    getdate(a, b, c, d);
    str(c, wyr);
    while length(wyr) < 2 do
      insert('0', wyr, 1);
    str(b, wyr2);
    while length(wyr2) < 2 do
      insert('0', wyr2, 1);
    wyr := wyr + '.' + wyr2;
    str(a, wyr2);
    wyr := wyr + '.' + wyr2;
    rekordy^[10].data := wyr;
    str(suma.g, wyr);
    while length(wyr) < 2 do
      insert('0', wyr, 1);
    str(suma.m, wyr2);
    while length(wyr2) < 2 do
      insert('0', wyr2, 1);
    wyr := wyr + ':' + wyr2;
    str(suma.s, wyr2);
    while length(wyr2) < 2 do
      insert('0', wyr2, 1);
    wyr := wyr + ':' + wyr2;
    rekordy^[10].czas := wyr;
    miejsce := 10;
  end;
  uloz_rek;
end;

{ * } PROCEDURE aktualizuj_aktualny_rek;
var
  a, b, c, d: word;
  wyr, wyr2: string;
begin
  rekordy^[miejsce].trup := trupy;
  rekordy^[miejsce].imie := imie_sadysty;
  getdate(a, b, c, d);
  str(c, wyr);
  while length(wyr) < 2 do
    insert('0', wyr, 1);
  str(b, wyr2);
  while length(wyr2) < 2 do
    insert('0', wyr2, 1);
  wyr := wyr + '.' + wyr2;
  str(a, wyr2);
  wyr := wyr + '.' + wyr2;
  rekordy^[miejsce].data := wyr;
  str(suma.g, wyr);
  while length(wyr) < 2 do
    insert('0', wyr, 1);
  str(suma.m, wyr2);
  while length(wyr2) < 2 do
    insert('0', wyr2, 1);
  wyr := wyr + ':' + wyr2;
  str(suma.s, wyr2);
  while length(wyr2) < 2 do
    insert('0', wyr2, 1);
  wyr := wyr + ':' + wyr2;
  rekordy^[miejsce].czas := wyr;
  uloz_rek;
end;

end.