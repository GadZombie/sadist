uses crt, mouse, dos;

type
  Ekran = array [0 .. 199, 0 .. 319] of byte;
  fonty_tabl = array [0 .. 59, 1 .. 6, 1 .. 5] of byte;
  obrr = array [0 .. 63, 0 .. 9, 0 .. 9] of byte;
  paleta_typ = array [0 .. 255, 0 .. 2] of byte;

const
  Old_Int = $66;

var
  Scr: ^Ekran;
  fonty: ^fonty_tabl;
  obraz: ^obrr;
  pal: paleta_typ;
  plik: file;
  Smx, Smy, Smx2, Smy2, mx, my, mmx, mmy, button, a: integer;
  b: byte;
  mkol: array [0 .. 10, 0 .. 10] of byte;
  kursor: array [0 .. 10, 0 .. 10] of byte;
  guzik, Sguzik, klik: array [1 .. 2] of boolean;
  nazwa_obr, wyr, ostatni_plik: string;
  pliki: array [1 .. 255] of string[8];
  nazwy_wpl: array [1 .. 255] of string[20];
  ustaw: record naglowek: string[14];
  nazwa_post: string[20];
  szyb_chod, s_bicia, s_poc, bije, strzela: byte;
  kol: array [242 .. 244, 0 .. 2] of byte;
  waga: byte;
end;
Save_Int:
pointer;
Kl:
array [0 .. 127] of boolean;
dzwieki:
record nazwa: array [0 .. 7] of string[12];
rozmiar:
array [0 .. 7] of word;
end;

{ * } PROCEDURE Get_Keyb_Int;
interrupt;
begin
  asm
    in al,$60;
    xor cx,cx
    xor bx,bx
    mov bl,al
    and bl,$7F;
    test al,$80;
    jnz @@set
    inc cl;
  @@set:
    mov byte ptr[bx+Kl],cl;
    int Old_Int;
  end;
end;

{ * } PROCEDURE VGAScreen; assembler;
asm
  mov ax, $13
  int $10
end;

{ * } PROCEDURE Putpix(x, y: word; Kolor: byte);
begin
  if (x >= 0) and (x <= 319) and (y >= 0) and (y <= 199) then
    Scr^[y, x] := Kolor;
end;

{ * } FUNCTION Getpix(x, y: word): byte;
begin
  Getpix := Scr^[y, x];
end;

{ * } PROCEDURE cala_paleta;
var
  count: byte;
begin
  count := port[$3DA];
  while $8 and count <> 0 do
    count := port[$3DA];
  while $8 and count = 0 do
    count := port[$3DA];
  port[$3C8] := 0;
  for count := 0 to 255 do
  begin
    port[$3C9] := pal[count, 0];
    port[$3C9] := pal[count, 1];
    port[$3C9] := pal[count, 2];
  end;
end;

{ * } PROCEDURE wczytaj_pal;
var
  plik: file;
begin
  assign(plik, 'sadist.dat');
  filemode := 0;
  reset(plik, 1);
  seek(plik, 2233);
  for a := 0 to 255 do
  begin
    blockread(plik, pal[a], 3);
  end;
  close(plik);
end;

{ * } PROCEDURE pisz(xobr, yobr: integer; tekst: string; Kolor: integer; tlo: byte);
var
  xf, yf, numer, a: byte;
begin
  for a := 1 to length(tekst) do
  begin
    for yf := 0 to 5 do
    begin
      for xf := 0 to 4 do
      begin
        case tekst[a] of
          'A':
            numer := 0;
          'B':
            numer := 1;
          'C':
            numer := 2;
          'D':
            numer := 3;
          'E':
            numer := 4;
          'F':
            numer := 5;
          'G':
            numer := 6;
          'H':
            numer := 7;
          'I':
            numer := 8;
          'J':
            numer := 9;
          'K':
            numer := 10;
          'L':
            numer := 11;
          'M':
            numer := 12;
          'N':
            numer := 13;
          'O':
            numer := 14;
          'P':
            numer := 15;
          'Q':
            numer := 16;
          'R':
            numer := 17;
          'S':
            numer := 18;
          'T':
            numer := 19;
          'U':
            numer := 20;
          'V':
            numer := 21;
          'W':
            numer := 22;
          'X':
            numer := 23;
          'Y':
            numer := 24;
          'Z':
            numer := 25;
          '1':
            numer := 26;
          '2':
            numer := 27;
          '3':
            numer := 28;
          '4':
            numer := 29;
          '5':
            numer := 30;
          '6':
            numer := 31;
          '7':
            numer := 32;
          '8':
            numer := 33;
          '9':
            numer := 34;
          '0':
            numer := 35;
          'a':
            numer := 36;
          'c':
            numer := 37;
          'e':
            numer := 38;
          'l':
            numer := 39;
          'n':
            numer := 40;
          'o':
            numer := 41;
          's':
            numer := 42;
          'x':
            numer := 43;
          'z':
            numer := 44;
          '.':
            numer := 45;
          ',':
            numer := 46;
          ':':
            numer := 47;
          '!':
            numer := 48;
          '"':
            numer := 49;
          '-':
            numer := 50;
          '?':
            numer := 51;
          '''':
            numer := 52;
          '(':
            numer := 53;
          ')':
            numer := 54;
          '/':
            numer := 55;
          '+':
            numer := 56;
          '*':
            numer := 57;
          '_':
            numer := 58;
        end;
        if (tlo = 1) and ((fonty^[numer, yf + 1, xf + 1] = 0) or (tekst[a] = ' ')) then
          Putpix(xobr + xf + (a - 1) * 5, yobr + yf, 0);
        if (fonty^[numer, yf + 1, xf + 1] > 0) and (tekst[a] <> ' ') then
          Putpix(xobr + xf + (a - 1) * 5, yobr + yf, Kolor);
      end;
    end;
  end;
end;

{ * } PROCEDURE DrawLine(x1, y1, x2, y2: integer; c: byte);
var
  DeltaX, DeltaY, NumPixels, Counter, D, Dinc1, Dinc2, x, Xinc1, Xinc2, y, Yinc1, Yinc2: integer;

begin
  DeltaX := abs(x2 - x1);
  DeltaY := abs(y2 - y1);
  if (DeltaX >= DeltaY) then
  begin
    NumPixels := DeltaX + 1;
    D := (DeltaY shl 1) - DeltaX;
    Dinc1 := DeltaY shl 1;
    Dinc2 := (DeltaY - DeltaX) shl 1;
    Xinc1 := 1;
    Xinc2 := 1;
    Yinc1 := 0;
    Yinc2 := 1;
  end
  else
  begin
    NumPixels := DeltaY + 1;
    D := (DeltaX shl 1) - DeltaY;
    Dinc1 := DeltaX shl 1;
    Dinc2 := (DeltaX - DeltaY) shl 1;
    Xinc1 := 0;
    Xinc2 := 1;
    Yinc1 := 1;
    Yinc2 := 1;
  end;
  if x1 > x2 then
  begin
    Xinc1 := -Xinc1;
    Xinc2 := -Xinc2;
  end;
  if y1 > y2 then
  begin
    Yinc1 := -Yinc1;
    Yinc2 := -Yinc2;
  end;
  x := x1;
  y := y1;
  for Counter := 1 to NumPixels do
  begin
    Putpix(x, y, c);
    if (D < 0) then
    begin
      inc(D, Dinc1);
      inc(x, Xinc1);
      inc(y, Yinc1);
    end
    else
    begin
      inc(D, Dinc2);
      inc(x, Xinc2);
      inc(y, Yinc2);
    end;
  end;
end;

{ * } PROCEDURE barEm(x1, y1, x2, y2: word; Kolor: byte);
var
  y: word;
begin
  DrawLine(x1, y1, x2, y1, Kolor);
  DrawLine(x2, y1, x2, y2, Kolor);
  DrawLine(x2, y2, x1, y2, Kolor);
  DrawLine(x1, y2, x1, y1, Kolor);
end;

{ * } PROCEDURE bar2d(x1, y1, x2, y2: word; Kolor: byte);
var
  y: word;
begin
  for y := y1 to y2 do
    FillChar(Scr^[y, x1], x2 - x1 + 1, Kolor);
end;

{ * } PROCEDURE bar3d(x1, y1, x2, y2: word; kolj, kol, kolc: byte);
var
  y: word;
begin
  for y := y1 to y2 do
  begin
    if (y > y1) and (y < y2) then
    begin
      FillChar(Scr^[y, x1 + 1], x2 - x1, kol);
      Scr^[y, x1] := kolj;
      Scr^[y, x2] := kolc;
    end;
    if (y = y1) then
      FillChar(Scr^[y, x1], x2 - x1 + 1, kolj);
    if (y = y2) then
    begin
      FillChar(Scr^[y, x1 + 1], x2 - x1, kolc);
      Scr^[y, x1] := kolj;
    end;
  end;
end;

{ * } PROCEDURE sprawdz_mysz;
begin
  Smx := mmx;
  Smy := mmy;
  GetMousePosition(button, mmx, mmy);
  Smx2 := mmx;
  Smy2 := mmy;
  if button = 0 then
  begin
    Sguzik[1] := guzik[1];
    Sguzik[2] := guzik[2];
    guzik[1] := false;
    guzik[2] := false;
  end;
  if button = 1 then
  begin
    Sguzik[1] := guzik[1];
    Sguzik[2] := guzik[2];
    guzik[1] := true;
    guzik[2] := false;
  end;
  if button = 2 then
  begin
    Sguzik[1] := guzik[1];
    Sguzik[2] := guzik[2];
    guzik[1] := false;
    guzik[2] := true;
  end;
  if button = 3 then
  begin
    Sguzik[1] := guzik[1];
    Sguzik[2] := guzik[2];
    guzik[1] := true;
    guzik[2] := true;
  end;
  if (not Sguzik[1]) and (guzik[1]) then
    klik[1] := true
  else
    klik[1] := false;
  if (not Sguzik[2]) and (guzik[2]) then
    klik[2] := true
  else
    klik[2] := false;
end;

{ * } PROCEDURE mysz;
var
  xx, yy, xx2, yy2: byte;
begin
  sprawdz_mysz;
  for yy := 0 to 10 do
  begin
    for xx := 0 to 10 do
    begin
      if (kursor[yy, xx] <> 0) and (Getpix(mx + xx - 5, my + yy - 5) <> kursor[yy, xx]) then
      begin
        for yy2 := 0 to 10 do
        begin
          for xx2 := 0 to 10 do
          begin
            if (Getpix(mx + xx2 - 5, my + yy2 - 5) <> kursor[yy2, xx2]) then
              mkol[xx2, yy2] := Getpix(mx + xx2 - 5, my + yy2 - 5);
          end;
        end;
        xx := 10;
        yy := 10;
      end;
    end;
  end;
  for yy := 0 to 10 do
  begin
    for xx := 0 to 10 do
    begin
      if (kursor[yy, xx] <> 0) then
        Putpix(mx + xx - 5, my + yy - 5, mkol[xx, yy]);
    end;
  end;
end;

{ * } PROCEDURE mysz2;
var
  xx, yy, xx2, yy2: byte;
begin
  mx := round(mmx / 2);
  my := round(mmy / 4);
  for yy := 0 to 10 do
  begin
    for xx := 0 to 10 do
    begin
      mkol[xx, yy] := Getpix(mx + xx - 5, my + yy - 5);
      if kursor[yy, xx] <> 0 then
        Putpix(mx + xx - 5, my + yy - 5, kursor[yy, xx]);
    end;
  end;
end;

{ * } FUNCTION mysz_w(x1, y1, x2, y2: integer): boolean;
begin
  if (mx >= x1) and (mx <= x2) and (my >= y1) and (my <= y2) then
    mysz_w := true
  else
    mysz_w := false;
end;

{ * } PROCEDURE pobr(xobr, yobr, numer, co, naco: integer; odwroc: byte);
var
  xf, yf: byte;
begin
  for yf := 0 to 9 do
  begin
    for xf := 0 to 9 do
    begin
      if (obraz^[numer - 1, yf, xf] <> co) and (obraz^[numer - 1, yf, xf] <> 0) then
        Putpix(xobr + xf, yobr + yf, obraz^[numer - 1, yf, xf]);
      if (obraz^[numer - 1, yf, xf] = co) and (obraz^[numer - 1, yf, xf] <> 0) then
        Putpix(xobr + xf, yobr + yf, naco);
    end;
  end;
end;

{ * } FUNCTION wpisz(wyr2: string; illit: byte; _x, _y, tlo: integer): string;
var
  sc, c, c1: byte;
  wyr3, wyr4: string;
  klw: char;
  a: integer;
begin
  while (length(wyr2) > 1) and (wyr2[length(wyr2)] = ' ') do
    delete(wyr2, length(wyr2), 1);
  wyr4 := wyr2;
  c := length(wyr2);
  c1 := c;
  sc := c;
  wyr3 := '<inny>';
  klw := #255;
  while keypressed do
    readkey;
  repeat
    mysz;
    mysz2;
    if (wyr3 <> wyr2) or (c <> sc) then
    begin
      bar2d(_x - 1, _y, _x + illit * 5, _y + 5, tlo);
      pisz(_x, _y, wyr2, 47, 0);
      DrawLine(_x - 1 + c * 5, _y, _x - 1 + c * 5, _y + 5, 111);
      wyr3 := wyr2;
      sc := c;
    end;
    klw := #255;
    if keypressed then
    begin
      klw := readkey;
      if (klw <> #13) and (klw <> #8) and (klw <> #0) and (klw <> #255) and (klw <> #27) and (c1 < illit) then
      begin
        if klw in [#97 .. #122] then
          klw := chr(ord(klw) - 32);
        if ((Kl[54]) or (Kl[42])) and (klw in ['A', 'C', 'E', 'L', 'N', 'O', 'S', 'Z', 'X']) then
          klw := chr(ord(klw) + 32);
        insert(klw, wyr2, c + 1);
        inc(c);
        inc(c1);
        klw := #255;
      end;
      if (klw = #8) and (c >= 1) then
      begin
        delete(wyr2, c, 1);
        dec(c);
        dec(c1);
        klw := #255;
      end;
      if klw = #0 then
      begin
        klw := readkey;
        if (klw = #75) and (c > 0) then
          dec(c);
        if (klw = #77) and (c < c1) then
          inc(c);
        if (klw = #83) and (c < c1) then
        begin
          for a := c + 1 to c1 do
            wyr2[a] := wyr2[a + 1];
          delete(wyr2, c1, 1);
          dec(c1);
        end;
        klw := #255;
      end;
    end;
    move(Scr^, Mem[$A000: 0000], 64000);
  until (klw = #13) or (klw = #27);
  if klw = #27 then
    wpisz := wyr4
  else
    wpisz := wyr2;
  while keypressed do
    readkey;
  DrawLine(_x - 1 + c * 5, _y, _x - 1 + c * 5, _y + 5, tlo);
  mysz;
end;

{ * } PROCEDURE wczytaj_obrazki_plik(nazwa: string);
begin
  assign(plik, nazwa + '.obr');
  filemode := 0;
  reset(plik, 1);
  blockread(plik, b, 1);
  blockread(plik, b, 1);
  blockread(plik, obraz^, filesize(plik) - 2);
  close(plik);
end;

{ * } PROCEDURE wczytaj_obrazki;
var
  plik2, spraw: file;
  wr, licz_min: word;
  DirInfo: SearchRec;
  x: integer;
  b, b2, bb, il_plikow: byte;
  pt, juz, anuluj: boolean;
  nazwa_pliku: string[8];
begin
  bar3d(70, 30, 250, 175, 159, 153, 148);
  pisz(123, 35, 'WCZYTAJ OBRAZKI', 79, 0);
  bar3d(100, 157, 155, 165, 159, 156, 148);
  pisz(122, 159, 'OK', 31, 0);
  bar3d(165, 157, 220, 165, 159, 156, 148);
  pisz(178, 159, 'ANULUJ', 31, 0);
  bar3d(100, 147, 155, 155, 159, 156, 148);
  pisz(112, 149, 'WSTECZ', 31, 0);
  bar3d(165, 147, 220, 155, 159, 156, 148);
  pisz(180, 149, 'DALEJ', 31, 0);
  FindFirst('*.obr', Archive, DirInfo);
  x := 0;
  il_plikow := 0;
  while DosError = 0 do
  begin
    inc(x);
    inc(il_plikow);
    wyr := DirInfo.Name;
    bb := length(wyr);
    for a := bb downto bb - 3 do
      wyr[a] := ' ';
    pliki[x] := wyr;
    FindNext(DirInfo);
  end;
  repeat
    a := 0;
    for x := 1 to il_plikow - 1 do
    begin
      if pliki[x] > pliki[x + 1] then
      begin
        a := 1;
        wyr := pliki[x];
        pliki[x] := pliki[x + 1];
        pliki[x + 1] := wyr;
      end;
    end;
  until a = 0;
  x := 1;
  pt := true;
  juz := false;
  anuluj := false;
  if il_plikow > 0 then
    nazwa_pliku := pliki[1]
  else
    nazwa_pliku := '';
  repeat
    mysz;
    mysz2;
    move(Scr^, Mem[$A000: 0000], 64000);
    if pt then
    begin
      bar3d(130, 46, 190, 128, 148, 156, 159);
      for a := 1 to 12 do
      begin
        if a + x - 1 <= il_plikow then
          pisz(140, a * 6 + 45, pliki[a + x - 1], 31, 0);
      end;
      bar3d(130, 131, 190, 139, 148, 156, 159);
      pisz(140, 133, nazwa_pliku, 47, 0);
      pt := false;
    end;
    if (guzik[2]) then
    begin
      if (mysz_w(165, 147, 220, 155)) and (x < il_plikow - 10) then
      begin
        inc(x);
        pt := true;
      end;
      if (mysz_w(100, 147, 155, 155)) and (x > 1) then
      begin
        dec(x);
        pt := true;
      end;
    end;
    if (klik[1]) then
    begin
      if (mysz_w(165, 147, 220, 155)) and (x < il_plikow - 10) then
      begin
        inc(x);
        pt := true;
      end;
      if (mysz_w(100, 147, 155, 155)) and (x > 1) then
      begin
        dec(x);
        pt := true;
      end;
      if (mysz_w(133, 51, 187, 124)) and ((((my - 51) div 6) + x) <= il_plikow) then
      begin
        nazwa_pliku := pliki[((my - 51) div 6) + x];
        pt := true;
      end;
      if mysz_w(100, 157, 155, 165) then
        juz := true;
      if mysz_w(165, 157, 220, 165) then
        anuluj := true;
    end;
  until (juz) or (anuluj);

  if juz then
  begin
    wczytaj_obrazki_plik(nazwa_pliku);
    nazwa_obr := nazwa_pliku;
  end;
  bar2d(70, 30, 250, 175, 153);
  while keypressed do
    readkey;
end;

{ * } PROCEDURE wczytaj_wave(numer_wave: byte);
var
  plik2, spraw: file;
  wr, licz_min: word;
  DirInfo: SearchRec;
  x: integer;
  b, b2, bb, il_plikow: byte;
  pt, juz, anuluj: boolean;
  nazwa_pliku: string[8];
  Attr: word;
begin
  bar3d(70, 30, 250, 175, 159, 153, 148);
  pisz(123, 35, 'WCZYTAJ DxWIeKI', 79, 0);
  bar3d(100, 157, 155, 165, 159, 156, 148);
  pisz(122, 159, 'OK', 31, 0);
  bar3d(165, 157, 220, 165, 159, 156, 148);
  pisz(178, 159, 'ANULUJ', 31, 0);
  bar3d(100, 147, 155, 155, 159, 156, 148);
  pisz(112, 149, 'WSTECZ', 31, 0);
  bar3d(165, 147, 220, 155, 159, 156, 148);
  pisz(180, 149, 'DALEJ', 31, 0);
  FindFirst('*.wav', Archive, DirInfo);
  x := 0;
  il_plikow := 0;
  while DosError = 0 do
  begin
    inc(x);
    inc(il_plikow);
    wyr := DirInfo.Name;
    bb := length(wyr);
    for a := bb downto bb - 3 do
      wyr[a] := ' ';
    while length(wyr) < 8 do
      wyr := wyr + ' ';
    pliki[x] := wyr;
    FindNext(DirInfo);
  end;
  repeat
    a := 0;
    for x := 1 to il_plikow - 1 do
    begin
      if pliki[x] > pliki[x + 1] then
      begin
        a := 1;
        wyr := pliki[x];
        pliki[x] := pliki[x + 1];
        pliki[x + 1] := wyr;
      end;
    end;
  until a = 0;
  x := 1;
  pt := true;
  juz := false;
  anuluj := false;
  nazwa_pliku := pliki[1];
  repeat
    mysz;
    mysz2;
    move(Scr^, Mem[$A000: 0000], 64000);
    if pt then
    begin
      bar3d(130, 46, 190, 128, 148, 156, 159);
      for a := 1 to 12 do
      begin
        if a + x - 1 <= il_plikow then
          pisz(140, a * 6 + 45, pliki[a + x - 1], 31, 0);
      end;
      bar3d(130, 131, 190, 139, 148, 156, 159);
      pisz(140, 133, nazwa_pliku, 47, 0);
      pt := false;
    end;
    if (guzik[2]) then
    begin
      if (mysz_w(165, 147, 220, 155)) and (x < il_plikow - 10) then
      begin
        inc(x);
        pt := true;
      end;
      if (mysz_w(100, 147, 155, 155)) and (x > 1) then
      begin
        dec(x);
        pt := true;
      end;
    end;
    if (klik[1]) then
    begin
      if (mysz_w(165, 147, 220, 155)) and (x < il_plikow - 10) then
      begin
        inc(x);
        pt := true;
      end;
      if (mysz_w(100, 147, 155, 155)) and (x > 1) then
      begin
        dec(x);
        pt := true;
      end;
      if (mysz_w(133, 51, 187, 124)) and ((((my - 51) div 6) + x) <= il_plikow) then
      begin
        nazwa_pliku := pliki[((my - 51) div 6) + x];
        pt := true;
      end;
      if mysz_w(100, 157, 155, 165) then
        juz := true;
      if mysz_w(165, 157, 220, 165) then
        anuluj := true;
    end;
  until (juz) or (anuluj);

  if juz then
  begin
    dzwieki.nazwa[numer_wave] := nazwa_pliku + '.WAV';
    FindFirst(nazwa_pliku + '.WAV', Archive, DirInfo);
    dzwieki.rozmiar[numer_wave] := DirInfo.size;
  end;
  bar2d(70, 30, 250, 175, 153);
  while keypressed do
    readkey;
end;

{ * } PROCEDURE zapis_postaci;
var
  plik2, plik_d: file;
  wr, licz_min: word;
  b, b2: byte;
  DirInfo: SearchRec;
  x, ior: integer;
  bb, il_plikow: byte;
  pt, juz, anuluj: boolean;
  nazwa_pliku: string[8];

  NumRead, NumWritten: word;
  Buf: array [1 .. 2048] of char;

begin
  bar3d(70, 30, 250, 175, 159, 153, 148);
  pisz(125, 35, 'ZAPISZ POSTACI', 79, 0);
  bar3d(100, 157, 155, 165, 159, 156, 148);
  pisz(122, 159, 'OK', 31, 0);
  bar3d(165, 157, 220, 165, 159, 156, 148);
  pisz(178, 159, 'ANULUJ', 31, 0);
  bar3d(100, 147, 155, 155, 159, 156, 148);
  pisz(112, 149, 'WSTECZ', 31, 0);
  bar3d(165, 147, 220, 155, 159, 156, 148);
  pisz(180, 149, 'DALEJ', 31, 0);
  FindFirst('POSTACI\*.sdp', Archive, DirInfo);
  x := 0;
  il_plikow := 0;
  while DosError = 0 do
  begin
    inc(x);
    inc(il_plikow);
    wyr := DirInfo.Name;
    bb := length(wyr);
    for a := bb downto bb - 3 do
      wyr[a] := ' ';
    pliki[x] := wyr;
    FindNext(DirInfo);
  end;
  repeat
    a := 0;
    for x := 1 to il_plikow - 1 do
    begin
      if pliki[x] > pliki[x + 1] then
      begin
        a := 1;
        wyr := pliki[x];
        pliki[x] := pliki[x + 1];
        pliki[x + 1] := wyr;
      end;
    end;
  until a = 0;

  for x := 1 to il_plikow do
  begin
    assign(plik, 'POSTACI\' + pliki[x] + '.SDP');
    filemode := 0;
    reset(plik, 1);
    blockread(plik, nazwy_wpl[x], 15);
    blockread(plik, nazwy_wpl[x], 21);
    close(plik);
  end;

  x := 1;
  pt := true;
  juz := false;
  anuluj := false;
  nazwa_pliku := ostatni_plik;
  repeat
    mysz;
    mysz2;
    move(Scr^, Mem[$A000: 0000], 64000);
    if pt then
    begin
      bar3d(80, 46, 240, 128, 148, 156, 159);
      for a := 1 to 12 do
      begin
        if a + x - 1 <= il_plikow then
        begin
          pisz(85, a * 6 + 45, pliki[a + x - 1], 31, 0);
          pisz(135, a * 6 + 45, nazwy_wpl[a + x - 1], 111, 0);
        end;
      end;
      bar3d(130, 131, 190, 139, 148, 156, 159);
      pisz(140, 133, nazwa_pliku, 47, 0);
      pt := false;
    end;
    if (guzik[2]) then
    begin
      if (mysz_w(165, 147, 220, 155)) and (x < il_plikow - 10) then
      begin
        inc(x);
        pt := true;
      end;
      if (mysz_w(100, 147, 155, 155)) and (x > 1) then
      begin
        dec(x);
        pt := true;
      end;
    end;
    if (klik[1]) then
    begin
      if (mysz_w(165, 147, 220, 155)) and (x < il_plikow - 10) then
      begin
        inc(x);
        pt := true;
      end;
      if (mysz_w(100, 147, 155, 155)) and (x > 1) then
      begin
        dec(x);
        pt := true;
      end;
      if (mysz_w(80, 51, 240, 124)) and ((((my - 51) div 6) + x) <= il_plikow) then
      begin
        nazwa_pliku := pliki[((my - 51) div 6) + x];
        pt := true;
      end;
      if mysz_w(130, 131, 190, 139) then
      begin
        nazwa_pliku := wpisz(nazwa_pliku, 8, 140, 133, 156);
        pt := true;
      end;
      if mysz_w(100, 157, 155, 165) then
        juz := true;
      if mysz_w(165, 157, 220, 165) then
        anuluj := true;
    end;

  until (juz) or (anuluj);

  if juz then
  begin
    ostatni_plik := nazwa_pliku;
    for a := 242 to 244 do
    begin
      for b := 0 to 2 do
      begin
        ustaw.kol[a, b] := pal[a, b];
      end;
    end;
    assign(plik, 'POSTACI\' + nazwa_pliku + '.SDP');
    filemode := 1;
{$I-}
    rewrite(plik, 1);
{$I+}
    ior := IOResult;
    if ior = 0 then
    begin
      blockwrite(plik, ustaw, sizeof(ustaw));
      blockwrite(plik, obraz^, sizeof(obraz^));
      blockwrite(plik, dzwieki, sizeof(dzwieki));
      for a := 0 to 7 do
      begin
        assign(plik_d, dzwieki.nazwa[a]);
        filemode := 2;
        reset(plik_d, 1);
        repeat
          blockread(plik_d, Buf, sizeof(Buf), NumRead);
          blockwrite(plik, Buf, NumRead, NumWritten);
        until (NumRead = 0) or (NumWritten <> NumRead);
        close(plik_d);
      end;
      close(plik);
    end
    else if ior = 5 then
    begin
      bar3d(70, 90, 250, 110, 159, 153, 148);
      pisz(95, 98, 'USUn ZABEZPIECZENIE PLIKU!', 175, 0);
      move(Scr^, Mem[$A000: 0000], 64000);
      repeat
        mysz;
        mysz2;
        move(Scr^, Mem[$A000: 0000], 64000);
      until klik[1];
      mysz;
    end
    else
    begin
      bar3d(70, 90, 250, 110, 159, 153, 148);
      pisz(95, 98, 'BlaD PRZY ZAPISIE POSTACI!', 175, 0);
      move(Scr^, Mem[$A000: 0000], 64000);
      repeat
        mysz;
        mysz2;
        move(Scr^, Mem[$A000: 0000], 64000);
      until klik[1];
      mysz;
    end;
  end;
  bar2d(70, 30, 250, 175, 153);
  while keypressed do
    readkey;
end;

{ * } PROCEDURE wczytaj_postaci;
var
  plik2, spraw: file;
  wr, licz_min: word;
  b, b2: byte;
  DirInfo: SearchRec;
  x: integer;
  bb, il_plikow: byte;
  pt, juz, anuluj: boolean;
  nazwa_pliku: string[8];
begin
  bar3d(70, 30, 250, 175, 159, 153, 148);
  pisz(123, 35, 'WCZYTAJ POSTACI', 79, 0);
  bar3d(100, 157, 155, 165, 159, 156, 148);
  pisz(122, 159, 'OK', 31, 0);
  bar3d(165, 157, 220, 165, 159, 156, 148);
  pisz(178, 159, 'ANULUJ', 31, 0);
  bar3d(100, 147, 155, 155, 159, 156, 148);
  pisz(112, 149, 'WSTECZ', 31, 0);
  bar3d(165, 147, 220, 155, 159, 156, 148);
  pisz(180, 149, 'DALEJ', 31, 0);
  FindFirst('POSTACI\*.sdp', Archive, DirInfo);
  x := 0;
  il_plikow := 0;
  while DosError = 0 do
  begin
    inc(x);
    inc(il_plikow);
    wyr := DirInfo.Name;
    bb := length(wyr);
    for a := bb downto bb - 3 do
      wyr[a] := ' ';
    pliki[x] := wyr;
    FindNext(DirInfo);
  end;
  repeat
    a := 0;
    for x := 1 to il_plikow - 1 do
    begin
      if pliki[x] > pliki[x + 1] then
      begin
        a := 1;
        wyr := pliki[x];
        pliki[x] := pliki[x + 1];
        pliki[x + 1] := wyr;
      end;
    end;
  until a = 0;

  for x := 1 to il_plikow do
  begin
    assign(plik, 'POSTACI\' + pliki[x] + '.SDP');
    filemode := 0;
    reset(plik, 1);
    blockread(plik, nazwy_wpl[x], 15);
    blockread(plik, nazwy_wpl[x], 21);
    close(plik);
  end;

  x := 1;
  pt := true;
  juz := false;
  anuluj := false;
{$I-}reset(spraw); {$I+}
  if IOResult = 0 then
  begin
    nazwa_pliku := ostatni_plik;
    close(spraw);
  end
  else
    nazwa_pliku := pliki[1];
  repeat
    mysz;
    mysz2;
    move(Scr^, Mem[$A000: 0000], 64000);
    if pt then
    begin
      bar3d(80, 46, 240, 128, 148, 156, 159);
      for a := 1 to 12 do
      begin
        if a + x - 1 <= il_plikow then
        begin
          pisz(85, a * 6 + 45, pliki[a + x - 1], 31, 0);
          pisz(135, a * 6 + 45, nazwy_wpl[a + x - 1], 111, 0);
        end;
      end;
      bar3d(130, 131, 190, 139, 148, 156, 159);
      pisz(140, 133, nazwa_pliku, 47, 0);
      pt := false;
    end;
    if (guzik[2]) then
    begin
      if (mysz_w(165, 147, 220, 155)) and (x < il_plikow - 10) then
      begin
        inc(x);
        pt := true;
      end;
      if (mysz_w(100, 147, 155, 155)) and (x > 1) then
      begin
        dec(x);
        pt := true;
      end;
    end;
    if (klik[1]) then
    begin
      if (mysz_w(165, 147, 220, 155)) and (x < il_plikow - 10) then
      begin
        inc(x);
        pt := true;
      end;
      if (mysz_w(100, 147, 155, 155)) and (x > 1) then
      begin
        dec(x);
        pt := true;
      end;
      if (mysz_w(80, 51, 240, 124)) and ((((my - 51) div 6) + x) <= il_plikow) then
      begin
        nazwa_pliku := pliki[((my - 51) div 6) + x];
        pt := true;
      end;
      if mysz_w(100, 157, 155, 165) then
        juz := true;
      if mysz_w(165, 157, 220, 165) then
        anuluj := true;
    end;

  until (juz) or (anuluj);

  if juz then
  begin
    ostatni_plik := nazwa_pliku;
    assign(plik, 'POSTACI\' + nazwa_pliku + '.SDP');
    filemode := 0;
    reset(plik, 1);
    blockread(plik, ustaw, sizeof(ustaw));
    blockread(plik, obraz^, 6400);
    if not eof(plik) then
      blockread(plik, dzwieki, sizeof(dzwieki));
    close(plik);
    for a := 242 to 244 do
    begin
      for b := 0 to 2 do
      begin
        pal[a, b] := ustaw.kol[a, b];
      end;
    end;
    cala_paleta;
  end;
  bar2d(70, 30, 250, 175, 153);
  while keypressed do
    readkey;
end;

{ * } PROCEDURE pokaz_obrazki;
begin
  bar3d(273, 20, 317, 196, 159, 144, 148);
  for b := 1 to 16 do
  begin
    for a := 1 to 4 do
    begin
      pobr((a - 1) * 11 + 274, 10 + b * 11, a + ((b - 1) * 4), 24, 241, 0);
    end;
  end;
  bar3d(273, 11, 317, 19, 159, 153, 148);
  pisz(276, 13, nazwa_obr, 31, 0);
end;

{ * } PROCEDURE pokaz_tlo;
begin
  bar3d(0, 9, 319, 199, 159, 153, 148);
  bar3d(0, 0, 319, 8, 159, 153, 148);
  bar3d(0, 0, 8, 8, 159, 153, 148);
  DrawLine(1, 1, 7, 7, 79);
  DrawLine(7, 1, 1, 7, 79);
  pisz(12, 2, 'EDYTOR POSTACI DO PROGRAMU        VER.1.1', 47, 0);
  pisz(147, 2, 'SADIST', 79, 0);
  pisz(244, 2, '(C)1999 S.K.GAD', 175, 0);

  bar3d(0, 191, 79, 199, 159, 153, 148);
  pisz(4, 193, 'WCZYTAJ POSTACI', 79, 0);
  bar3d(80, 191, 155, 199, 159, 153, 148);
  pisz(84, 193, 'ZAPISZ POSTACI', 79, 0);
  bar3d(156, 191, 234, 199, 159, 153, 148);
  pisz(159, 193, 'WCZYTAJ OBRAZKI', 79, 0);
end;

{ * } PROCEDURE odswiez_suwaki;
begin
  for a := 0 to 2 do
  begin
    for b := 0 to 67 do
      DrawLine(31 + b, 73 + a * 10, 31 + b, 77 + a * 10, trunc(64 + b / 4.2));
    for b := 0 to 67 do
      DrawLine(111 + b, 73 + a * 10, 111 + b, 77 + a * 10, trunc(160 + b / 4.2));
    for b := 0 to 67 do
      DrawLine(191 + b, 73 + a * 10, 191 + b, 77 + a * 10, trunc(112 + b / 4.2));
    bar3d(31 + pal[242 + a, 0], 73 + a * 10, 35 + pal[242 + a, 0], 77 + a * 10, 140, 137, 130);
    bar3d(111 + pal[242 + a, 1], 73 + a * 10, 115 + pal[242 + a, 1], 77 + a * 10, 140, 137, 130);
    bar3d(191 + pal[242 + a, 2], 73 + a * 10, 195 + pal[242 + a, 2], 77 + a * 10, 140, 137, 130);
  end;
  for b := 0 to 105 do
    DrawLine(60 + b, 23, 60 + b, 27, trunc(32 + b / 6.56));
  bar3d(60 + ustaw.szyb_chod, 23, 64 + ustaw.szyb_chod, 27, 140, 137, 130);
  for b := 0 to 105 do
    DrawLine(60 + b, 43, 60 + b, 47, trunc(32 + b / 6.56));
  bar3d(60 + ustaw.s_bicia, 43, 64 + ustaw.s_bicia, 47, 140, 137, 130);
  for b := 0 to 105 do
    DrawLine(60 + b, 63, 60 + b, 67, trunc(32 + b / 6.56));
  bar3d(60 + ustaw.s_poc, 63, 64 + ustaw.s_poc, 67, 140, 137, 130);
  for b := 0 to 105 do
    DrawLine(60 + b, 103, 60 + b, 107, trunc(32 + b / 6.56));
  bar3d(60 + ustaw.waga, 103, 64 + ustaw.waga, 107, 140, 137, 130);
  pisz(44, 13, ustaw.nazwa_post, 47, 0);
  pisz(4, 33, 'BIJE SIe', 82 + ustaw.bije * 13, 0);
  pisz(4, 53, 'STRZELA', 82 + ustaw.strzela * 13, 0);

  for a := 0 to 7 do
  begin
    bar3d(5, 118 + a * 9, 69, 126 + a * 9, 159, 153, 148);
    bar3d(70, 118 + a * 9, 100, 126 + a * 9, 159, 153, 148);
    pisz(8, 120 + a * 9, dzwieki.nazwa[a], 175, 0);
    str(dzwieki.rozmiar[a], wyr);
    pisz(73, 120 + a * 9, wyr, 175, 0);
  end;
end;

{ * } PROCEDURE pokaz_ustawienia;
begin
  bar3d(2, 11, 167, 19, 159, 153, 148);
  pisz(4, 13, 'NAZWA: (                    )', 31, 0);
  bar3d(2, 21, 167, 29, 159, 153, 148);
  pisz(4, 23, 'SZYB.CHODZ.', 31, 0);
  bar3d(59, 22, 165, 28, 159, 153, 148);
  bar3d(2, 31, 167, 39, 159, 153, 148);
  bar3d(2, 41, 167, 49, 159, 153, 148);
  pisz(4, 43, 'SIlA BICIA ', 31, 0);
  bar3d(59, 42, 165, 48, 159, 153, 148);
  bar3d(2, 51, 167, 59, 159, 153, 148);
  bar3d(2, 61, 167, 69, 159, 153, 148);
  pisz(4, 63, 'SIlA POCIS.', 31, 0);
  bar3d(59, 62, 165, 68, 159, 153, 148);
  bar3d(2, 101, 167, 109, 159, 153, 148);
  pisz(4, 103, 'WAGA', 31, 0);
  bar3d(59, 102, 165, 108, 159, 153, 148);
  for a := 0 to 2 do
  begin
    bar3d(2, 71 + a * 10, 260, 79 + a * 10, 159, 153, 148);
    str(242 + a, wyr);
    pisz(4, 73 + a * 10, wyr, 31, 0);
    pisz(24, 73 + a * 10, 'R', 79, 0);
    bar3d(30, 72 + a * 10, 99, 78 + a * 10, 159, 153, 148);
    pisz(104, 73 + a * 10, 'G', 175, 0);
    bar3d(110, 72 + a * 10, 179, 78 + a * 10, 159, 153, 148);
    pisz(184, 73 + a * 10, 'B', 127, 0);
    bar3d(190, 72 + a * 10, 259, 78 + a * 10, 159, 153, 148);
  end;

  for a := 0 to 7 do
  begin
    bar3d(5, 118 + a * 9, 69, 126 + a * 9, 159, 153, 148);
    bar3d(70, 118 + a * 9, 100, 126 + a * 9, 159, 153, 148);
    pisz(8, 120 + a * 9, dzwieki.nazwa[a], 175, 0);
    str(dzwieki.rozmiar[a], wyr);
    pisz(73, 120 + a * 9, wyr, 175, 0);
  end;
  bar3d(3, 114, 230, 190, 159, 153, 148);
  bar2d(8, 114, 43, 114, 153);
  pisz(10, 111, 'DxWIeKI', 170, 0);
  pisz(103, 120, 'WRZASK KIEDY OBERWIE 1', 170, 0);
  pisz(103, 129, 'WRZASK KIEDY OBERWIE 2', 170, 0);
  pisz(103, 138, 'WRZASK KIEDY OBERWIE 3', 170, 0);
  pisz(103, 147, 'WRZASK PRZY sMIERCI', 170, 0);
  pisz(103, 156, 'STeKNIeCIE PRZY UPADKU', 170, 0);
  pisz(103, 165, 'UDERZENIE/KOPNIeCIE', 170, 0);
  pisz(103, 174, 'WRZASK PRZY PANICE', 170, 0);
  pisz(103, 183, 'STRZELANIE', 170, 0);
end;

{ * } PROCEDURE glowny_program;
begin
  repeat
    mysz;
    if klik[1] then
    begin
      if mysz_w(156, 191, 234, 199) then
      begin
        wczytaj_obrazki;
        pokaz_obrazki;
        pokaz_ustawienia;
      end;
      if mysz_w(44, 12, 143, 18) then
      begin
        wyr := ustaw.nazwa_post;
        ustaw.nazwa_post := wpisz(ustaw.nazwa_post, 20, 44, 13, 153);
        if ustaw.nazwa_post <> wyr then
        begin
          wyr := ustaw.nazwa_post;
          ustaw.nazwa_post := '                    ';
          ustaw.nazwa_post := wyr;
        end;
      end;
      if mysz_w(2, 31, 167, 39) then
      begin
        if ustaw.bije = 0 then
          ustaw.bije := 1
        else
          ustaw.bije := 0;
      end;
      if mysz_w(2, 51, 167, 59) then
      begin
        if ustaw.strzela = 0 then
          ustaw.strzela := 1
        else
          ustaw.strzela := 0;
      end;

      if mysz_w(0, 191, 79, 199) then
      begin
        wczytaj_postaci;
        pokaz_obrazki;
        pokaz_ustawienia;
      end;
      if mysz_w(80, 191, 155, 199) then
      begin
        if (dzwieki.nazwa[0] <> '') and (dzwieki.nazwa[1] <> '') and (dzwieki.nazwa[2] <> '') and
          (dzwieki.nazwa[3] <> '') and (dzwieki.nazwa[4] <> '') and (dzwieki.nazwa[5] <> '') and
          (dzwieki.nazwa[6] <> '') and (dzwieki.nazwa[7] <> '') then
        begin
          zapis_postaci;
          pokaz_obrazki;
          pokaz_ustawienia;
        end
        else
        begin
          mysz2;
          bar3d(70, 90, 250, 110, 159, 153, 148);
          pisz(80, 98, 'USTAWIENIA POSTACI NIEKOMPLETNE!', 175, 0);
          move(Scr^, Mem[$A000: 0000], 64000);
          repeat
            mysz;
            mysz2;
            move(Scr^, Mem[$A000: 0000], 64000);
          until klik[1];
          mysz;
          bar2d(70, 30, 250, 175, 153);
          pokaz_obrazki;
          pokaz_ustawienia;
        end;
      end;

      for a := 0 to 7 do
      begin
        if mysz_w(5, 118 + a * 9, 79, 126 + a * 9) then
        begin
          wczytaj_wave(a);
          pokaz_obrazki;
          pokaz_ustawienia;
        end;
      end;
    end;
    if guzik[1] then
    begin
      for a := 0 to 2 do
      begin
        for b := 0 to 2 do
        begin
          if mysz_w(33 + b * 80, 72 + a * 10, 96 + b * 80, 78 + a * 10) then
          begin
            pal[242 + a, b] := mx - (33 + b * 80);
            cala_paleta;
          end;
        end;
      end;
      if mysz_w(62, 22, 162, 28) then
        ustaw.szyb_chod := mx - 62;
      if mysz_w(62, 42, 162, 48) then
        ustaw.s_bicia := mx - 62;
      if mysz_w(62, 62, 162, 68) then
        ustaw.s_poc := mx - 62;
      if mysz_w(62, 102, 162, 108) then
        ustaw.waga := mx - 62;
    end;
    odswiez_suwaki;

    mysz2;
    move(Scr^, Mem[$A000: 0000], 64000);
  until (klik[1]) and (mysz_w(0, 0, 8, 8));
end;

{ * } BEGIN
  if not mousepresent then
  begin
    writeln('Ten program wymaga myszy!');
    halt;
  end;
  VGAScreen;
  getmem(Scr, sizeof(Scr^));
  getmem(obraz, sizeof(obraz^));
  getmem(fonty, sizeof(fonty^));
  GetIntVec($9, Save_Int);
  SetIntVec(Old_Int, Save_Int);
  FillChar(Kl, sizeof(Kl), 0);
  SetIntVec($9, @Get_Keyb_Int);
  assign(plik, 'sadist.dat');
  filemode := 0;
  reset(plik, 1);
  seek(plik, 1821);
  blockread(plik, kursor, 121);
  close(plik);
  assign(plik, 'sadist.dat');
  reset(plik, 1);
  seek(plik, 49);
  blockread(plik, fonty^, 1770);
  close(plik);
  wczytaj_pal;
  cala_paleta;
  ustaw.naglowek := 'SADIST-postaci';
  nazwa_obr := '';
  FillChar(obraz^, sizeof(obraz^), 0);

  mousewindow(0, 0, 319 * 2, 199 * 4);
  SetMickeys(4, 3);
  setmouseposition(319, 199 * 2);

  pokaz_tlo;
  pokaz_ustawienia;
  pokaz_obrazki;

  glowny_program;
  SetIntVec($9, Save_Int);
  asm
    mov ax, $3
    int $10
  end;

end.