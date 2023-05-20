unit sad_graf;
{$G+}
interface
uses crt,sad_rek,sad_var,wave,mouse,xms;

PROCEDURE nowe_move(var Source,Dest);
PROCEDURE nowe_moveK(var Source,Dest);
PROCEDURE Move2 (var source, dest; count: word);
PROCEDURE cala_paleta(jak,czek:byte);
PROCEDURE wczytaj_pal;
FUNCTION Getpix(x, y : word):byte;
PROCEDURE Putpix(x, y : word; Color,ekr : byte);
PROCEDURE DrawLine (x1, y1, x2, y2 : Integer; c,jak : Byte);
PROCEDURE drawcircle(x0,y0,r:integer;kolor:byte);
PROCEDURE bar2(x1, y1, x2, y2 : word;kolor:byte);
PROCEDURE bar3(x1, y1, x2, y2 : word;kolc,kol,kolj:byte);
PROCEDURE wielk_scr(x1,y1,x2,y2: word);
PROCEDURE Fadeout(r,g,b,sz,szybkosc:byte);
PROCEDURE Fadein(_od,_do,szybkosc,szyb:byte;zerowanie:boolean);
PROCEDURE SetPal(Col: byte; R, G, B: byte);
PROCEDURE pisz(xobr,yobr:integer;tekst:string;kolor:integer;tlo:byte);
PROCEDURE siatka(x:word);
PROCEDURE rysuj_wode;
PROCEDURE zmaz_wode;
PROCEDURE zmaz_ikony;
PROCEDURE napisy_na_koniec;
PROCEDURE schowaj_winiete;
PROCEDURE napisz_tekst;
PROCEDURE wczytaj_obiekt(nr,odw,textura,ekr,z_przodu:byte;mx,my:integer);
PROCEDURE widok;
PROCEDURE zrob_texture(textura:byte);
PROCEDURE rysowanie_obiektow(ekr:byte);
PROCEDURE napisy_o_programie(nr:byte;var dlug:word);
PROCEDURE wczytaj_ikony_z_plikow;
PROCEDURE wczytaj_ikony(numer:byte);
PROCEDURE pokaz_ikony;
PROCEDURE pokaz_ekran;
PROCEDURE pok_ramke;
PROCEDURE zmien_niebo;
PROCEDURE zobr(xobr,yobr,numer,ktory:integer;odwroc,dr:byte);
PROCEDURE sprawdz_mysz;
PROCEDURE mysz;
PROCEDURE mysz2;
FUNCTION mysz_w(x1,y1,x2,y2:integer):boolean;
PROCEDURE klawisze;
PROCEDURE graj_dzwiek (Voice : WaveData;sz:real;gdzie:byte);
PROCEDURE wyb_przy_kur;
PROCEDURE tlo_menu;
PROCEDURE pok_rekordy;
PROCEDURE zmaz_kaw;
PROCEDURE pok_kaw;
PROCEDURE ruch_kaw;
PROCEDURE nowykaw(x,y,dx,dy:real);
PROCEDURE nowysyf(msx,msy,ksx,ksy:real;kolor,ile,zmaz:byte);
PROCEDURE rysuj_ogien;
PROCEDURE bum(gx,gy,sila:integer;dzwiek,blysk,dziura,metal,wrzaski,zapala,gasi:boolean);
PROCEDURE ciecie;
{*}PROCEDURE wczytaj_obr_tla;
{*}PROCEDURE przerob_obr_nieba(jak:byte);
{*}PROCEDURE nowy_komentarz(xx,yy,dlug,txt:integer);
{*}PROCEDURE shot;
{*}PROCEDURE strzal(msx,msy,ksx,ksy,sila,jaki:real;dzwiek,dzwiek_wyb:boolean;druzyna:byte;sek:integer;hom:boolean);
{*}PROCEDURE pociski;
{*}PROCEDURE ruch_kowadla;
{*}PROCEDURE zmaz_kowadla;
{*}PROCEDURE pokaz_kowadla;
{*}PROCEDURE rozpoczecie_xms;
PROCEDURE sprawdz_kartoteki;
{*}PROCEDURE poczatek_programu;

implementation

{*}PROCEDURE nowe_move(var Source,Dest); assembler;
asm
   push       ds
   les        di,Dest
   lds        si,Source
   mov        cx,16000
   db 66h;    rep movsw
   pop        ds
end;

{*}PROCEDURE nowe_moveK(var Source,Dest); assembler;
asm
   push       ds
   les        di,Dest
   lds        si,Source
   mov        cx,800
   db 66h;    rep movsw
   pop        ds
end;

{*}PROCEDURE Move2 (var source, dest; count: word); assembler;
  asm
   push ds
   lds  si,source
   les  di,dest
   mov  cx,count
   mov  ax,cx
   cld
   shr  cx,2
   db   66h
   rep  movsw
   mov  cl,al
   and  cl,3
   rep  movsb
   pop  ds
end;


{*}PROCEDURE cala_paleta(jak,czek:byte);
var
count:byte;
begin
if czek=1 then begin
   count:=port[$3DA];
   while $8 and count<>0 do count:=port[$3DA];
   while $8 and count=0 do count:=port[$3DA];
end;
port[$3C8]:=0;
for count:=0 to 255 do begin
    case jak of
    0:begin
      port[$3C9]:=pal[count,0];
      port[$3C9]:=pal[count,1];
      port[$3C9]:=pal[count,2];
      end;
    1:begin
      port[$3C9]:=pal_gl[count,0];
      port[$3C9]:=pal_gl[count,1];
      port[$3C9]:=pal_gl[count,2];
      end;
    end;
end;
end;

{*}PROCEDURE wczytaj_pal;
var plik:file;
begin
assign(plik,'sadist.dat');
filemode:=0;
reset(plik,1);seek(plik,2233);
   for a:=0 to 255 do begin
       blockread(plik,pal_gl[a],3);
   end;
   pal:=pal_gl;
close(plik);
end;

{*}FUNCTION Getpix(x, y : word):byte;
begin
  if (x>=scr_x1) and (x<=scr_x2) and (y>=scr_y1) and (y<=scr_y2) then
     getpix:=Scr^[y, x]
     else getpix:=0;
end;

{*}PROCEDURE Putpix(x, y : word; Color,ekr : byte);
begin
  if (x>=scr_x1) and (x<=scr_x2) and (y>=scr_y1) and (y<=scr_y2) then begin
     if color>0 then begin
        case ekr of
        0:Scr^[y, x] := Color;
        1:mem[$A000:x+320*y]:=Color;
        2:begin
           if zoom then begin
              if (x*2-pox*2>=0) and (x*2-pox*2<=319) and (y*2-poy*2>=0) and (y*2-poy*2<=199) then begin
                 mem[$A000:x*2-pox*2+1+320*(y*2-poy*2+1)]:=color;
                 mem[$A000:x*2-pox*2+320*(y*2-poy*2)]:=color;
              end;
           end
              else mem[$A000:x+320*y]:=Color;
          end;
        end;
     end
                else begin
        if ekr=0 then begin
           if niebo>=17 then Scr^[y, x]:=scr2^[y,x]
                        else Scr^[y, x] := 1+(y div 14)+cien[y mod 14];
        end;
        if ekr=1 then mem[$A000:x+320*y]:=1+(y div 14)+cien[y mod 14];
     end;
  end;
end;

{*}PROCEDURE DrawLine (x1, y1, x2, y2 : Integer; c,jak : Byte);
var
  DeltaX, DeltaY, NumPixels, Counter,
  D, Dinc1, Dinc2,
  X, Xinc1, Xinc2,
  Y, Yinc1, Yinc2 : Integer;

begin
  DeltaX := abs (x2 - x1);
  DeltaY := abs (y2 - y1);
  if (DeltaX >= DeltaY) then begin
    NumPixels := Deltax + 1;
    D := (DeltaY shl 1) - DeltaX;
    Dinc1 := DeltaY shl 1;
    Dinc2 := (DeltaY - DeltaX) shl 1;
    Xinc1 := 1;
    Xinc2 := 1;
    Yinc1 := 0;
    Yinc2 := 1;
  end else begin
    NumPixels := DeltaY + 1;
    D := (DeltaX shl 1) - DeltaY;
    Dinc1 := DeltaX shl 1;
    Dinc2 := (DeltaX - DeltaY) shl 1;
    Xinc1 := 0;
    Xinc2 := 1;
    Yinc1 := 1;
    Yinc2 := 1;
  end;
  if x1 > x2 then begin
    Xinc1 := -Xinc1;
    Xinc2 := -Xinc2;
  end;
  if y1 > y2 then begin
    Yinc1 := -Yinc1;
    Yinc2 := -Yinc2;
  end;
  X := x1;
  Y := y1;
  for Counter := 1 to NumPixels do begin
     case jak of
     0:begin
      if zoom then begin
         PutPix (X*2-pox*2, Y*2-poy*2, c,0);
         PutPix (X*2-pox*2+1, Y*2-poy*2+1, c,0);
      end
         else PutPix (X, Y, c,0);
      end;
     1:begin
      if zoom then begin
         PutPix (X*2-pox*2, Y*2-poy*2, c,1);
         PutPix (X*2-pox*2+1, Y*2-poy*2+1, c,1);
      end
         else PutPix (X, Y, c,1);
      if (scr^[y,x]<144) or (scr^[y,x]>159) then putpix(x,y,0,0);
      end;
     2:PutPix (X, Y, c,0);
     3:PutPix (X, Y, c,1);
     4:begin
       if zoom then begin
         PutPix (X*2-pox*2, Y*2-poy*2, c,1);
         PutPix (X*2-pox*2+1, Y*2-poy*2+1, c,1);
       end
         else PutPix (X, Y, c,1);
       end;
     5:begin
       PutPix (X, Y, c,0);
       if random(3)=0 then PutPix (X-1+random(3), Y-1+random(3), c,0);
       end;
     end;
    if (D < 0) then begin
      inc (D, Dinc1);
      inc (X, Xinc1);
      inc (Y, Yinc1);
    end else begin
      inc (D, Dinc2);
      inc (X, Xinc2);
      inc (Y, Yinc2);
    end;
  end;
end;

{*}PROCEDURE drawcircle(x0,y0,r:integer;kolor:byte);
var x,y,d:integer;
begin
x:=0;
y:=r;
d:=3-2*r;
repeat
putpix(x0+x,y0+y,kolor,1);
putpix(x0+x,y0-y,kolor,1);
putpix(x0-x,y0+y,kolor,1);
putpix(x0-x,y0-y,kolor,1);
putpix(x0+y,y0+x,kolor,1);
putpix(x0+y,y0-x,kolor,1);
putpix(x0-y,y0+x,kolor,1);
putpix(x0-y,y0-x,kolor,1);
inc(x);
if d>=0 then begin dec(y);
d:=d+2*(2*x-2*y+1);
end
else
d:=d+2*(2*x+1)
until x>y;
end;

{*}PROCEDURE bar2(x1, y1, x2, y2 : word;kolor:byte);
var
  y : word;
begin
  for y := y1 to y2 do FillChar(Scr^[y, x1], x2-x1, kolor);
end;

{*}PROCEDURE bar3(x1, y1, x2, y2 : word;kolc,kol,kolj:byte);
var
  y : word;
begin
  for y := y1 to y2 do begin
      if (y>y1) and (y<y2) then begin FillChar(Scr^[y, x1+1], x2-x1-1, kol);scr^[y,x1]:=kolj;scr^[y,x2-1]:=kolc;end;
      if (y=y1) then begin FillChar(Scr^[y, x1+1], x2-x1-2, kolj);
         scr^[y,x2-1]:=157;scr^[y,x1]:=137;end;
      if (y=y2) then begin FillChar(Scr^[y, x1+1], x2-x1-2, kolc);
         scr^[y,x1]:=157;scr^[y,x2-1]:=151;end;
  end;
end;

{*}PROCEDURE wielk_scr(x1,y1,x2,y2: word);
begin
  scr_x1:=x1;
  scr_y1:=y1;
  scr_x2:=x2;
  scr_y2:=y2;
  if scr_x2>319 then scr_x2:=319;
  if scr_y2>199 then scr_y2:=199;
end;

{*}PROCEDURE Fadeout(r,g,b,sz,szybkosc:byte);
var
a,c:byte;
zm:boolean;
begin
pal:=pal_gl;
repeat
zm:=false;
for a:=0 to 255 do begin
    for c:=1 to szybkosc do begin
    if pal[a,0]>r then begin zm:=true;dec(pal[a,0]);end;
    if pal[a,0]<r then begin zm:=true;inc(pal[a,0]);end;
    end;
    for c:=1 to szybkosc do begin
    if pal[a,1]>g then begin zm:=true;dec(pal[a,1]);end;
    if pal[a,1]<g then begin zm:=true;inc(pal[a,1]);end;
    end;
    for c:=1 to szybkosc do begin
    if pal[a,2]>b then begin zm:=true;dec(pal[a,2]);end;
    if pal[a,2]<b then begin zm:=true;inc(pal[a,2]);end;
    end;
end;
cala_paleta(0,1);
delay(sz);
until not zm;
end;

{*}PROCEDURE Fadein(_od,_do,szybkosc,szyb:byte;zerowanie:boolean);
var
a,b:byte;
zm:boolean;
begin
repeat
zm:=false;
for a:=_od to _do do begin
    for b:=1 to szybkosc do begin
        if pal[a,0]<pal_gl[a,0] then begin zm:=true;inc(pal[a,0]);end;
        if pal[a,0]>pal_gl[a,0] then begin zm:=true;dec(pal[a,0]);end;
    end;
    for b:=1 to szybkosc do begin
        if pal[a,1]<pal_gl[a,1] then begin zm:=true;inc(pal[a,1]);end;
        if pal[a,1]>pal_gl[a,1] then begin zm:=true;dec(pal[a,1]);end;
    end;
    for b:=1 to szybkosc do begin
        if pal[a,2]<pal_gl[a,2] then begin zm:=true;inc(pal[a,2]);end;
        if pal[a,2]>pal_gl[a,2] then begin zm:=true;dec(pal[a,2]);end;
    end;
end;
cala_paleta(0,1);
delay(szyb);
until not zm;
end;

{*}PROCEDURE SetPal(Col: byte; R, G, B: byte);
begin
   Port[$3C8] := Col;
   Port[$3C9] := R;
   Port[$3C9] := G;
   Port[$3C9] := B;
end;

{*}PROCEDURE pisz(xobr,yobr:integer;tekst:string;kolor:integer;tlo:byte);
var
xf,yf,numer,a:byte;
linia:array[0..4] of byte;
xxobr:integer;
begin
for a:=1 to length(tekst) do begin
    case tekst[a] of
                 'A':numer:=0;
                 'B':numer:=1;
                 'C':numer:=2;
                 'D':numer:=3;
                 'E':numer:=4;
                 'F':numer:=5;
                 'G':numer:=6;
                 'H':numer:=7;
                 'I':numer:=8;
                 'J':numer:=9;
                 'K':numer:=10;
                 'L':numer:=11;
                 'M':numer:=12;
                 'N':numer:=13;
                 'O':numer:=14;
                 'P':numer:=15;
                 'Q':numer:=16;
                 'R':numer:=17;
                 'S':numer:=18;
                 'T':numer:=19;
                 'U':numer:=20;
                 'V':numer:=21;
                 'W':numer:=22;
                 'X':numer:=23;
                 'Y':numer:=24;
                 'Z':numer:=25;
                 '1':numer:=26;
                 '2':numer:=27;
                 '3':numer:=28;
                 '4':numer:=29;
                 '5':numer:=30;
                 '6':numer:=31;
                 '7':numer:=32;
                 '8':numer:=33;
                 '9':numer:=34;
                 '0':numer:=35;
                 'a':numer:=36;
                 'c':numer:=37;
                 'e':numer:=38;
                 'l':numer:=39;
                 'n':numer:=40;
                 'o':numer:=41;
                 's':numer:=42;
                 'x':numer:=43;
                 'z':numer:=44;
                 '.':numer:=45;
                 ',':numer:=46;
                 ':':numer:=47;
                 '!':numer:=48;
                 '"':numer:=49;
                 '-':numer:=50;
                 '?':numer:=51;
                '''':numer:=52;
                 '(':numer:=53;
                 ')':numer:=54;
                 '/':numer:=55;
                 '+':numer:=56;
                 '*':numer:=57;
                 '_':numer:=58;
    end;
    xxobr:=xobr+(a-1)*5;
    for yf:=0 to 5 do begin
        if (yobr+yf>=scr_y1) and (yobr+yf<=scr_y2) then begin
           move2(scr^[yobr+yf,xxobr],linia,5);
        for xf:=0 to 4 do begin
            if (tlo=1) and ((fonty^[numer,yf+1,xf+1]=0) or (tekst[a]=' ')) then
               linia[xf]:=0;
            if (fonty^[numer,yf+1,xf+1]>0) and (tekst[a]<>' ') then
               linia[xf]:=kolor;
        end;
         if (xobr>=scr_x1) and (xobr<=scr_x2-5) then
            move2(linia,scr^[yobr+yf,xxobr],5);
         if (xobr<scr_x1) and (scr_x1-xxobr>0) and (5-(scr_x1-xxobr)>0) then
            move2(linia[scr_x1-xxobr],scr^[yobr+yf,scr_x1],5-(scr_x1-xxobr));
         if (xobr>scr_x2-5) and (xxobr<=scr_x2) then
            move2(linia,scr^[yobr+yf,xxobr],scr_x2-xxobr+1);
        end;
    end;
end;
end;


{*}PROCEDURE siatka(x:word);
var ax,ay:byte;
begin
ax:=0;ay:=1;
repeat
   repeat
      putpix(x+ax,ay,17,0);
      inc(ax,2);
   until ax>=8;
   inc(ay);
   if (ay/2)=trunc(ay/2) then ax:=1 else ax:=0;
until ay>=9;
end;

{*}PROCEDURE rysuj_wode;
var
a:word;
b,c,d:byte;
begin
for a:=0 to 319 do begin
    b:=getpix(a,199);
    if (b<=15) or ((b>=224) and (b<=228)) or ((b>=202) and (b<=207)) then begin
       c:=getpix(a,199);c:=c+random(3)-1;
       d:=getpix(a-1,199);
       if (d>=224) and (d<=228) then begin
          if c<d-1 then c:=d-1;
          if c>d+1 then c:=d+1;
       end;
       if c<224 then c:=224;
       if c>228 then c:=228;
       putpix(a,199,c,0);
    end;
end;

end;

{*}PROCEDURE zmaz_wode;
var
a:word;
b:byte;
begin
for a:=0 to 319 do begin
    b:=getpix(a,199);
    if b in [0..15,192..207,224..228] then putpix(a,199,0,0);
end;

end;

{*}PROCEDURE zmaz_ikony;
var
Lines:Word;
count:byte;
begin
scr_y1:=0;
for count:=0 to 9 do for lines:=0 to 319 do putpix(lines,count,0,0);
scr_y1:=11;
end;

{*}PROCEDURE napisy_na_koniec;
var b:byte;
begin
writeln;
writeln;
textcolor(4);textbackground(0);
gotoxy(25,wherey);writeln('Üßßßß ÜßßßÜ ÛßßßÜ Û Üßßßß ßßÛßß');
gotoxy(26,wherey);writeln('ßßßÜ ÛÜÜÜÛ Û   Û Û  ßßßÜ   Û');
gotoxy(25,wherey);writeln('ßßßß  ß   ß ßßßß  ß ßßßß    ß');
textcolor(28);
gotoxy(36,wherey);writeln('FREEWARE');
writeln;
textcolor(10);
gotoxy(18,wherey);writeln('Copyright 1998/1999 by Studio Komputerowe GAD');
gotoxy(29,wherey);writeln('http://gad.koti.com.pl/');

gotoxy(29,wherey+1);writeln('Oficjalna Strona SADIST');
gotoxy(26,wherey);writeln('http://gad.koti.com.pl/sadist/');
writeln;
textcolor(14);
gotoxy(23,wherey);writeln('Dzieki za uzywanie tego programu !');
textcolor(9);
gotoxy(29,wherey);writeln('A jakie wrazenia ??? ;)');
writeln;
textcolor(12);
gotoxy(9,wherey);write('Specjalne podziekowania dla');
textcolor(14);write(' XaN''a');
textcolor(12);writeln(', ktory pomogl mi przyspieszyc');
gotoxy(17,wherey);writeln('dzialanie SADISTa, przy uzyciu assemblera :)))');

textcolor(4);
gotoxy(13,wherey+1);writeln('Podziekowania i pozdrowienia otrzymuja (alfabetycznie):');
gotoxy(10,wherey+1);writeln('Arael, Sebastian A.Dusza, HaOBe, Korneliusz Jarzebski, Kris82');
gotoxy(12,wherey);  writeln('Liar, Jakub Maciejek, Pioter, Grzegorz Zawojski, Ziutass');

textcolor(7);
writeln;
for a:=63 downto 0 do begin
    { R 63 , G 10 , B 10  }
{ 0}setpal(0 ,a,trunc(a/6.3),trunc(a/6.3));
{ 4}setpal(4 ,42+trunc(a/3),trunc(a/6.3),trunc(a/6.3));
{ 9}setpal(57,21+trunc(a/1.465116279),21-trunc(a/5.727272727),63-trunc(a/1.188679245));
{10}setpal(58,21+trunc(a/1.465116279),63-a,21-trunc(a/5.727272727));
{12}setpal(60,63,21-trunc(a/5.727272727),21-trunc(a/5.727272727));
{14}setpal(62,63,63-a,21-trunc(a/5.727272727));
    delay(20);
end;
end;

{*}PROCEDURE schowaj_winiete;
var a,b:integer;c:byte;
begin
c:=random(2)+1;
case c of
   1:begin
     for a:=0 to 199 do begin
         if a>0 then fillchar(mem[$A000:(a-1)*320],320,0);
         move2(scr^,mem[$A000:a*320],64000-(a*320));
         delay(1);
     end;
     end;
   2:begin
     for b:=1 to 320 do begin
         for a:=0 to 199 do begin
             if a mod 2=0 then begin
                move2(scr^[a],mem[$A000:a*320+b],320-b);
                mem[$A000:a*320+b-1]:=0;
             end else begin
                move2(scr^[a,b-1],mem[$A000:a*320],320-b);
                mem[$A000:a*320+(320-b)]:=0;
             end;
         end;
         delay(1);
     end;
     end;
end;
end;

{*}PROCEDURE napisz_tekst;
var
plik:file;ofs:word;
napis:array[0..56] of char;
wyr2:string;
begin
pisz(135,32,'* SADIST *',79,0);
str(trupy,wyr);
pisz(79,177,'TRUPoW:'+wyr,16,0);
pisz(81,177,'TRUPoW:'+wyr,16,0);
pisz(80,176,'TRUPoW:'+wyr,16,0);
pisz(80,178,'TRUPoW:'+wyr,16,0);
pisz(80,177,'TRUPoW:'+wyr,175,0);

str(suma.g,wyr);if length(wyr)<2 then insert('0',wyr,1);
str(suma.m,wyr2);if length(wyr2)<2 then insert('0',wyr2,1); wyr:=wyr+':'+wyr2;
str(suma.s,wyr2);if length(wyr2)<2 then insert('0',wyr2,1); wyr:=wyr+':'+wyr2;
pisz(201,177,wyr,16,0);
pisz(199,177,wyr,16,0);
pisz(200,178,wyr,16,0);
pisz(200,176,wyr,16,0);
pisz(200,177,wyr,175,0);

assign(plik,'sadist.dat'{'teksty.kod'});
filemode:=0;
reset(plik,1);
ofs:=0;
case trupy of
     1  ..100 :ofs:=0;
     101..250 :ofs:=61;
     251..500 :ofs:=122;
     501..700 :ofs:=183;
     701..900 :ofs:=244;
     901..1100:ofs:=305;
    1101..1300:ofs:=366;
    1301..1500:ofs:=427;
    1501..1700:ofs:=488;
    1701..1900:ofs:=549;
    1901..2100:ofs:=610;
    2101..2800:ofs:=671;
    2801..3500:ofs:=732;
    3501..4500:ofs:=793;
    4501..6000:ofs:=854;
    6001..8000:ofs:=915;
   8001..10000:ofs:=976;
  10001..15000:ofs:=1037;
  15001..20000:ofs:=1098;
    else if trupy>=20001 then ofs:=1159;
end;
seek(plik,ofs+272391);
wyr:='                                                         ';
blockread(plik,napis,57);
if trupy>0 then
   for a:=0 to 56 do wyr[a+1]:=chr(ord(napis[a]) xor 25);
while ((wyr[length(wyr)]=' ') and (length(wyr)>0)) or
      (length(wyr)>57) do delete(wyr,length(wyr),1);
pisz(161-trunc(length(wyr)*2.5),184,wyr,16,0);
pisz(159-trunc(length(wyr)*2.5),184,wyr,16,0);
pisz(160-trunc(length(wyr)*2.5),183,wyr,16,0);
pisz(160-trunc(length(wyr)*2.5),185,wyr,16,0);
pisz(160-trunc(length(wyr)*2.5),184,wyr,175,0);
close(plik);
end;


{*}PROCEDURE wczytaj_obiekt(nr,odw,textura,ekr,z_przodu:byte;mx,my:integer);
var
BMPFile:File;
Lines,a:Word;
count,b:byte;
rx,ry:longint;
{z_przodu:byte;}
lin:array[1..320] of byte;
Header : record
  bfType           : Word;
  bfSize,
  bfReserved,
  bfOffBits,
  biSize,
  Width,
  Height         : LongInt;
  biPlanes,
  biBitCount       : Word;
  biCompression,
  biSizeImage,
  biXPelsPerMeter,
  biYPelsPerMeter,
  biClrUsed,
  biClrImportant   : LongInt;
end;

begin
Assign (BMPFile,'graf.dat');
filemode:=0;
Reset (BMPFile, 1);seek(BMPFile,schemat[textura].obiekt[nr]);
BlockRead (BMPFile, Header, SizeOf (Header));
rx:=header.width;
ry:=header.height;
seek(BMPFile,1078+schemat[textura].obiekt[nr]);
lines := ry;
while (lines >0) do begin
BlockRead (BMPFile, lin, rx);
for a:=0 to rx-1 do begin
    if odw=0 then b:=lin[a+1]
             else b:=lin[rx-a];
    if (b>0) and ((getpix(mx-trunc(rx/2)+a,(my+lines)-ry)<=15) or (z_przodu=0)) then
       putpix(mx-trunc(rx/2)+a,(my+lines)-ry,b,ekr);
end;
dec (lines);
end;
close (BMPFile);

end;

{*}PROCEDURE widok;
var xf,yf,rodz:byte;x,y:word;
dlyg:integer;
yg,dyg:real;
przep:boolean;

BMPFile:File;
Lines,a,aa:Word;
count,b,textura:byte;
rx,ry:longint;
mx,my:integer;
lin:array[1..320] of byte;
Header : record
  bfType           : Word;
  bfSize,
  bfReserved,
  bfOffBits,
  biSize,
  Width,
  Height         : LongInt;
  biPlanes,
  biBitCount       : Word;
  biCompression,
  biSizeImage,
  biXPelsPerMeter,
  biYPelsPerMeter,
  biClrUsed,
  biClrImportant   : LongInt;
end;

begin
if niebo>=17 then nowe_move(scr2^,scr^) else
   for y:=0 to 199 do drawline(0,y,319,y,1+trunc(y div 14)+cien[y mod 14],2);

scr_y1:=11;
yg:=random(50)+75;
dyg:=-2+random*4;
dlyg:=random(10);
if random(5)=0 then przep:=true else przep:=false;
textura:=random(7)+1;

Assign (BMPFile,'graf.dat');
filemode:=0;
Reset (BMPFile, 1);seek(BMPFile,schemat[textura].brzeg);
BlockRead (BMPFile, Header, SizeOf (Header));
rx:=header.width;
ry:=header.height;
seek(BMPFile,1078+schemat[textura].brzeg);
lines := ry;

for a:=0 to 319 do begin
    if yg>0 then begin
    if (a>10) and (a<300) and (random(50)=0) then
       wczytaj_obiekt(random(schemat[textura].il_obiekt)+1,random(2),textura,0,1,a,198-trunc(yg)+random(4));
    drawline(a,199,a,199-trunc(yg),253,2);

BlockRead (BMPFile, lin, rx);
for aa:=0 to rx-1 do begin
    b:=lin[rx-aa];
    if (b>0) then putpix(a,(198-trunc(yg))+aa,b,0);
end;
dec(lines);
if lines=0 then begin
   seek(BMPFile,1078+schemat[textura].brzeg);
   lines := ry;
end;

    end;
    yg:=yg+dyg;
    dec(dlyg);
    if dlyg<=0 then begin
                    dyg:=dyg-1+random*2;
                    dlyg:=random(20);
                    end;
    if (not przep) and (yg<50) then begin yg:=50;dyg:=random;end;
    if (przep) and (yg<-50) then begin yg:=-50;dyg:=random;end;
    if yg>150 then begin yg:=150;dyg:=-random;end;
end;

close (BMPFile);

if textura>0 then zrob_texture(textura);

end;

{*}PROCEDURE zrob_texture(textura:byte);
var xf,yf,rodz:byte;x,y:word;
BMPFile:File;
Lines:Word;
b:byte;
rx,ry:longint;
mx,my,Pmx:integer;
lin:array[1..320] of byte;
Header : record
  bfType           : Word;
  bfSize,
  bfReserved,
  bfOffBits,
  biSize,
  Width,
  Height         : LongInt;
  biPlanes,
  biBitCount       : Word;
  biCompression,
  biSizeImage,
  biXPelsPerMeter,
  biYPelsPerMeter,
  biClrUsed,
  biClrImportant   : LongInt;
end;

begin

Assign (BMPFile,'graf.dat');
filemode:=0;
Reset (BMPFile, 1);seek(BMPFile,schemat[textura].textura);
BlockRead (BMPFile, Header, SizeOf (Header));
rx:=header.width;
ry:=header.height;

Pmx:=-random(40);my:=-random(40);

while my<200 do begin
mx:=Pmx;
while mx<320 do begin
seek(BMPFile,1078+schemat[textura].textura);
lines := ry;
while (lines >0) do begin
BlockRead (BMPFile, lin, rx);
for a:=0 to rx-1 do begin
    b:=lin[a+1];
    if (getpix(mx+a,(my+lines))=253) then
        putpix(mx+a,(my+lines),b,0);
end;
dec (lines);
end;
inc(mx,rx);
end;
inc(my,ry);
end;

close (BMPFile);
end;

{*}PROCEDURE rysowanie_obiektow(ekr:byte);
begin
if ((klik[1]) or (ekr=2)) and (bron=3) and (my>10) then begin
       wczytaj_obiekt(naz_obj[rob_obiekt_numr].ob,ord(rob_obiekt_odwr),naz_obj[rob_obiekt_numr].tex,ekr,0,mx,my);
end;
if (klik[2]) and (ekr=2) and (my>10) then begin
               if rob_obiekt_odwr then rob_obiekt_odwr:=false
                                  else rob_obiekt_odwr:=true;
end;
end;

{*}PROCEDURE napisy_o_programie(nr:byte;var dlug:word);
begin
case nr of
     0:begin
       pisz(145,70, 'SADIST',79,0);
       pisz(140,80, 'AUTORZY:',47,0);
       dlug:=250;
       end;
     1:begin
       pisz(140,70, 'PROGRAM:',77,0);
       pisz(109,80, 'GRZEGORZ "GAD" DROZD',47,0);
       dlug:=500;
       end;
     2:begin
       pisz(120,70, 'POMYSlY I POMOC:',77,0);
       pisz(117,80, 'GRZEGORZ ZAWOJSKI',47,0);
       dlug:=500;
       end;
     3:begin
       pisz(140,64, 'GRAFIKA:',77,0);
       pisz(109,72, 'GRZEGORZ "GAD" DROZD',47,0);
       pisz(124,79, 'JAKUB MACIEJEK',47,0);
       pisz(114,86, 'SEBASTIAN A. DUSZA',47,0);
       dlug:=500;
       end;
     4:begin
       pisz(117,65, 'RYSUNKI TYTUlOWE:',77,0);
       pisz(114,75, 'SEBASTIAN A. DUSZA',47,0);
       pisz(124,85, 'JAKUB MACIEJEK',47,0);
       dlug:=500;
       end;
     5:begin
       pisz(140,70, 'DxWIeKI:',77,0);
       pisz(109,80, 'GRZEGORZ "GAD" DROZD',47,0);
       dlug:=500;
       end;
     6:begin
       pisz(128,68, 'PODZIeKOWANIA',77,0);
       pisz(125,75, 'I POZDROWIENIA',77,0);
       pisz(133,82, 'OTRZYMUJa :',77,0);
       dlug:=200;
       end;
     7:begin
       pisz(152,64, 'XAN',47,0);
       pisz(105,72, 'POMOC PRZY PAMIeCI XMS',140,0);
       pisz(117,79, 'I PARe USPRAWNIEn',140,0);
       pisz(140,86, 'W KODZIE',140,0);
       dlug:=300;
       end;
     8:begin
       pisz(125,70, 'CHARLES ATTARD',47,0);
       pisz(128,80, 'UNIT DO MYSZY',140,0);
       dlug:=150;
       end;
     9:begin
       pisz(130,70, 'STEVEN H.DON',47,0);
       pisz(128,80, 'UNIT DO WAVoW',140,0);
       dlug:=150;
       end;
    10:begin
       pisz(124,70, 'JAKUB MACIEJEK',47,0);
       pisz(118,80, 'GRAFIKA I POMYSlY',140,0);
       dlug:=150;
       end;
    11:begin
       pisz(114,70, 'SEBASTIAN A. DUSZA',47,0);
       pisz(118,80, 'GRAFIKA I POMYSlY',140,0);
       dlug:=150;
       end;
    12:begin pisz(118,75, 'POMYSlY DALI TEz:',140,0);dlug:=200;end;
    13:begin pisz(147,75, 'ARAEL',47,0);dlug:=100;end;
    14:begin pisz(147,75, 'HAOBE',47,0);dlug:=100;end;
    15:begin pisz(110,75, 'KORNELIUSZ JARZeBSKI',47,0);dlug:=100;end;
    16:begin pisz(145,75, 'KRIS82',47,0);dlug:=100;end;
    17:begin pisz(150,75, 'LIAR',47,0);dlug:=100;end;
    18:begin pisz(145,75, 'PIOTER',47,0);dlug:=100;end;
    19:begin pisz(142,75, 'ZIUTASS',47,0);dlug:=100;end;
    20:begin
       pisz(124,70,'TEN PROGRAM TO',171,0);
       pisz(130,80,'* FREEWARE *',175,0);
       dlug:=500;
       end;
    21:begin
       pisz(103,67,'OFICJALNA STRONA SADIST',77,0);
       pisz(143,76,'HTTP://',47,0);
       pisz(103,82,'GAD.KOTI.COM.PL/SADIST/',47,0);
       dlug:=1000;
       end;
    22:begin
       pisz(120,65,'OFICJALNA STRONA',77,0);
       pisz(140,75,'S.K. GAD',175,0);
       pisz(103,85,'HTTP://GAD.KOTI.COM.PL/',47,0);
       dlug:=1000;
       end;
    23:begin
       pisz(113,70,'PISZ NA ADRES EMAIL',75,0);
       pisz(113,80,'GADCGAD.KOTI.COM.PL',47,0);
       putpix(130,81,47,0);putpix(131,82,47,0);putpix(130,82,47,0);putpix(131,84,47,0);putpix(131,83,155,0);
       dlug:=1000;
       end;
end;
end;

{*}PROCEDURE wczytaj_ikony_z_plikow;
var
BMPFile:File;
Lines:Word;
count,numer:byte;
wyr:string;
begin
str(numer,wyr);
Assign (BMPFile,'sadist.dat');
filemode:=0;
Reset (BMPFile, 1);

for numer:=1 to 4 do begin
    seek(BMPFile,1078+119354+((numer-1)*4278));
    lines := 0;
    while (lines < 10) do begin
       BlockRead (BMPFile, menu_ikony^[9-lines], 320);
       inc (lines);
    end;
    mem2xms(menu_ikony^,_xms[6].h,(numer-1)*3200,3200);
end;
close (BMPFile);
end;

{*}PROCEDURE wczytaj_ikony(numer:byte);
begin
xms2mem(_xms[6].h,(numer-1)*3200,menu_ikony^,3200);
end;

{*}PROCEDURE pokaz_ikony;
begin
nowe_moveK(menu_ikony^,scr^);
end;

procedure zoomm(offs:word; source,dest:pointer); assembler;
 asm
   PUSH   DS
   LES    DI,Source
   LDS 		SI,Dest
   XOR    BX,BX
   ADD    DI,offs
  @Height:
   MOV 		CX,160
  @Width:
   MOV    AL,byte ptr[ES:DI]
   MOV    AH,AL
   MOV    Word Ptr DS:[SI],AX
{   PUSH   SI
   ADD    SI,320}
   MOV    Word Ptr DS:[SI+320],AX
{   POP    SI}
   INC    DI
   INC    SI
   INC    SI
   DEC	  CX
   JCXZ  @H
   JMP   @Width
  @H:
   ADD    SI,320
	 ADD    DI,160
   INC    BX
   CMP    BX,100
	 JNE    @Height
   POP    DS
 end;

{*}PROCEDURE pokaz_ekran;
var a22:integer;
begin

if komentarz.dl>0 then begin
{   xms2mem(_xms[9].h,word(y*320),linia,320);}
   mem2xms(scr^[komentarz.y],_xms[6].h,76800,1920);
   pisz(komentarz.x,komentarz.y,komentarz.jaki,96+komentarz.dl div 6,0);
end;

if zoom then begin
   if ekrbum>0 then begin
      a2:=trunc(random(trunc(ekrbum/2))-(ekrbum/4));a22:=a2*320;
      if a2>=0 then begin
         fillchar(mem[$A000:0000],a2*320,0);
{         for a:=0 to 99-a2 do
             for a1:=0 to 159 do
                   fillchar(
                        Mem [$A000:a1*2+a*640+po1+a22],2,
                        scr^[poy+a,pox+a1]);}
         zoomm(pox+poy*320,addr(scr^),@mem[$A000:0]);


      end
         else begin
         fillchar(mem[$A000:64000-320*abs(a2)],abs(a2)*320,0);
{         for a:=0 to 99-abs(a2) do
             for a1:=0 to 159 do
                   fillchar(
                        Mem [$A000:a1*2+a*640+po1],2,
                        scr^[poy+a+abs(a2),pox+a1]);}
         zoomm(pox+(poy+abs(a2))*320,addr(scr^),@mem[$A000:0]);
      end;
   end
      else begin
{           for a:=0 to 99 do
               for a1:=0 to 159 do
                   fillchar(
                        Mem [$A000:a1*2+a*640+po1],2,
                        scr^[poy+a,pox+a1]);}
         zoomm(pox+poy*320,addr(scr^),@mem[$A000:0]);
      end;
inc(po1,320);if po1>=640 then po1:=0;
end
   else begin
        if ekrbum>0 then begin
           a:=trunc(random(trunc(ekrbum/4))-(ekrbum/8));
           if a>=0 then begin
              move(scr^,mem[$A000:0000+a*320],64000-a*320);
              fillchar(mem[$A000:0000],a*320,0);
           end
             else begin
              move(scr^[abs(a)],mem[$A000:0000],64000-abs(a)*320);
              fillchar(mem[$A000:64000-320*abs(a)],abs(a)*320,0);
           end;
        end
           else begin
           nowe_move(scr^,mem[$A000:0000]);
           {move(scr^,mem[$A000:0000],64000);}
           end;
   end;

if komentarz.dl>0 then begin
   xms2mem(_xms[6].h,76800,scr^[komentarz.y],1920);
end;

end;

{*}PROCEDURE pok_ramke;
var a:byte;
begin
if zazn_ramki then begin
   for a:=0 to gest_rmk-1 do begin
       putpix(trunc(ramka_wsp[1].x+a*((ramka_wsp[2].x-ramka_wsp[1].x)/gest_rmk)),
              ramka_wsp[1].y,111,0);
       putpix(ramka_wsp[2].x,
              trunc(ramka_wsp[1].y+a*((ramka_wsp[2].y-ramka_wsp[1].y)/gest_rmk)),111,0);
       putpix(trunc(ramka_wsp[2].x-a*((ramka_wsp[2].x-ramka_wsp[1].x)/gest_rmk)),
              ramka_wsp[2].y,111,0);
       putpix(ramka_wsp[1].x,
              trunc(ramka_wsp[2].y-a*((ramka_wsp[2].y-ramka_wsp[1].y)/gest_rmk)),111,0);
   end;
end;
end;

{*}PROCEDURE zmien_niebo;
var a:byte;
begin
if niebo<=16 then begin
for a:=1 to 15 do begin
    if not niebo_odwroc then begin
       pal_gl[a,0]:=nieba[niebo,a,0];
       pal_gl[a,1]:=nieba[niebo,a,1];
       pal_gl[a,2]:=nieba[niebo,a,2];
    end
                        else begin
       pal_gl[a,0]:=nieba[niebo,16-a,0];
       pal_gl[a,1]:=nieba[niebo,16-a,1];
       pal_gl[a,2]:=nieba[niebo,16-a,2];
    end;
    pal[a]:=pal_gl[a];
end;
if niebo in [0,16] then przerob_obr_nieba(1);
cala_paleta(1,1);
end
else begin
     wczytaj_obr_tla;
     przerob_obr_nieba(0);
     cala_paleta(1,0);
end;
end;

{*}PROCEDURE zobr(xobr,yobr,numer,ktory:integer;odwroc,dr:byte);
var xf,yf:byte;
begin
for yf:=0 to 9 do begin
for xf:=0 to 9 do begin
    if odwroc=0 then begin
       if (obraz^[dr,numer-1,yf,xf]<>0) then putpix(xobr+xf,yobr+yf,postm[ktory,yf+1,xf+1],0);
    end
                else begin
       if (obraz^[dr,numer-1,yf,xf]<>0) then putpix(xobr+9-xf,yobr+yf,postm[ktory,yf+1,xf+1],0);
    end;
end;end;
end;

{*}PROCEDURE tlo_menu;
var b,Sx1,Sx2,Sy1,Sy2:integer;
BMPFile:File;
Lines:Word;
linia:array[0..319] of byte;

begin
Sx1:=scr_x1;Sy1:=scr_y1;Sx2:=scr_x2;Sy2:=scr_y2;
wielk_scr(71,31,248,174);
bar3(70,30,250,175,148,154,159);

if (jest_obrmenu) then begin
Assign (BMPFile,'sadist.dat');
filemode:=0;
Reset (BMPFile, 1);seek(BMPFile,158926);
lines := 0;
while (lines < 200) do begin
      BlockRead (BMPFile, linia, 320);
{      for a:=70 to 250 do if (a+lines) mod 2=0 then linia[a]:=154;}
      if (199-lines) in [30..175] then
         move (linia[70], scr^[199-lines,70], 180);
      inc (lines);
end;
close (BMPFile);
end
   else begin
for b:=0 to 9 do begin
    for a:=0 to 12 do begin
        zobr(75+a*15-5+random(10),
             35+b*15-5+random(10),
             random(56)+1,1,random(2),random(2)+1);
    end;
end;
for b:=31 to 174 do begin
    for a:=71 to 248 do begin
        if getpix(a,b)<>154 then putpix(a,b,152-random(3),0);
    end;
end;
    end;
wielk_scr(Sx1,Sy1,Sx2,Sy2);
end;

{*}PROCEDURE klawisze;
begin
for a:=0 to 127 do begin
    if (kl_wcisn[a]=1) and (not kl[a]) then kl_wcisn[a]:=0;
end;
end;

{*}PROCEDURE graj_dzwiek (Voice : WaveData;sz:real;gdzie:byte);
begin
if (karta_muzyczna) and (jest_dzwiek) then MixVoice (Voice,sz,gdzie);
end;

{*}PROCEDURE wyb_przy_kur;
begin
for a:=1 to 15 do begin
    drawcircle(mx,my,trunc(a/1.5),207-a);
end;
graj_dzwiek(voicedata[1],0.5+random,0);delay(20);
end;

{*}FUNCTION mysz_w(x1,y1,x2,y2:integer):boolean;
begin
if (mx>=x1) and (mx<=x2) and (my>=y1) and (my<=y2) then mysz_w:=true
                                                   else mysz_w:=false;
end;

{*}PROCEDURE sprawdz_mysz;
begin
Smx:=mmx;Smy:=mmy;
GetMousePosition(button,mmx,mmy);
Smx2:=mmx;Smy2:=mmy;
if (guzik[2]) and ((bron in [0,1,4,5,11,12,15,16,18]) or (trzyma_shift)) then begin
   setMousePosition(Smx,Smy);mmx:=Smx;mmy:=Smy;end;
if button=0 then begin Sguzik[1]:=guzik[1];Sguzik[2]:=guzik[2];guzik[1]:=false;guzik[2]:=false;end;
if button=1 then begin Sguzik[1]:=guzik[1];Sguzik[2]:=guzik[2];guzik[1]:=true ;guzik[2]:=false;end;
if button=2 then begin Sguzik[1]:=guzik[1];Sguzik[2]:=guzik[2];guzik[1]:=false;guzik[2]:=true ;end;
if button=3 then begin Sguzik[1]:=guzik[1];Sguzik[2]:=guzik[2];guzik[1]:=true ;guzik[2]:=true ;end;
if (not Sguzik[1]) and (guzik[1]) then klik[1]:=true
                                  else klik[1]:=false;
if (not Sguzik[2]) and (guzik[2]) then klik[2]:=true
                                  else klik[2]:=false;
end;

{*}PROCEDURE mysz;
var xx,yy,xx2,yy2:byte;
begin
scr_y1:=0;
sprawdz_mysz;
for yy:=0 to myszka.r do begin
for xx:=0 to myszka.r do begin
if (kursor[yy,xx]<>0) and (getpix(mx+xx-myszka.z,my+yy-myszka.z)<>kursor[yy,xx]) then begin
   for yy2:=0 to myszka.r do begin
   for xx2:=0 to myszka.r do begin
       if (getpix(mx+xx2-myszka.z,my+yy2-myszka.z)<>kursor[yy2,xx2]) then
          mkol[xx2,yy2]:=getpix(mx+xx2-myszka.z,my+yy2-myszka.z);
   end;end;
   xx:=myszka.r;yy:=myszka.r;
end;
end;end;
for yy:=0 to myszka.r do begin
for xx:=0 to myszka.r do begin
    if (jest_kursor) and (kursor[yy,xx]<>0) then putpix(mx+xx-myszka.z,my+yy-myszka.z,mkol[xx,yy],0);
end;end;
if (kl[45]) and (kl_wcisn[45]=0) and (wolno_wyl_mysz) then begin
   kl_wcisn[45]:=1;
   if jest_kursor then jest_kursor:=false
                  else jest_kursor:=true;
end;
scr_y1:=11;
end;

{*}PROCEDURE mysz2;
var xx,yy,xx2,yy2:byte;
lmx,lmy:integer;
begin
scr_y1:=0;
if (bron=17) then begin _Smx2:=mx;_Smy2:=my;end;
lmx:=mx;lmy:=my;
mx:=round(mmx/2);my:=round(mmy/4);
Zmx:=mx-lmx;
Zmy:=my-lmy;
for yy:=0 to myszka.r do begin
for xx:=0 to myszka.r do begin
    mkol[xx,yy]:=getpix(mx+xx-myszka.z,my+yy-myszka.z);
    if kursor[yy,xx]<>0 then begin
       if (zaznaczony=0) and (kursor[yy,xx]=252) then kursor[yy,xx]:=254;
       if (zaznaczony>0) and (kursor[yy,xx]=254) then kursor[yy,xx]:=252;
       if (jest_kursor) then putpix(mx+xx-myszka.z,my+yy-myszka.z,kursor[yy,xx],0);
    end;
end;end;
scr_y1:=11;
end;


{*}PROCEDURE pok_rekordy;
var juz:boolean;a:byte;
begin
if miejsce=11 then sprawdz_rek
              else aktualizuj_aktualny_rek;
tlo_menu;pisz(117,33,'NAJWIeKSI SADYsCI',79,0);
bar3(100,157,220,165,148,156,159);pisz(150,159,'WRoc',31,0);
juz:=false;

pisz( 86,48,'IMIe',175,0);
pisz(125,48,'TRUPoW',79,0);
pisz(158,48,'W CZASIE',143,0);
pisz(209,48,'W DNIU',47,0);
drawline(71,55,248,55,157,0);
drawline(71,56,248,56,150,0);
if miejsce<=10 then begin
   drawline(71,49+miejsce*9,248,49+miejsce*9,119,0);
   drawline(71,50+miejsce*9,248,50+miejsce*9,120,0);
   drawline(71,51+miejsce*9,248,51+miejsce*9,121,0);
   drawline(71,52+miejsce*9,248,52+miejsce*9,122,0);
   drawline(71,53+miejsce*9,248,53+miejsce*9,121,0);
   drawline(71,54+miejsce*9,248,54+miejsce*9,120,0);
   drawline(71,55+miejsce*9,248,55+miejsce*9,119,0);
end;
for a:=1 to 10 do begin
   pisz(71,50+a*9,rekordy^[a].imie,175+1-a,0);
   str(rekordy^[a].trup,wyr);while length(wyr)<7 do insert('0',wyr,1);
   pisz(122,50+a*9,wyr,79+1-a,0);
   pisz(158,50+a*9,rekordy^[a].czas,143+1-a,0);
   pisz(199,50+a*9,rekordy^[a].data,47+1-a,0);
end;

repeat
klawisze;
if (klik[1]) then begin
   wyb_przy_kur;
   if (mysz_w(100,157,220,165)) then juz:=true;
end;
mysz;
mysz2;
move (scr^, Mem [$A000:0000], 64000);

if ((kl[1]) and (kl_wcisn[1]=0)) then begin juz:=true;kl_wcisn[1]:=1;end;
until juz;
Mpok_rekordy:=false;
end;


{*}PROCEDURE zmaz_kaw;
var r:byte;
begin
for a:=1 to maxkaw do begin
    if kaw[a].jest then begin
       if kaw[a].kol[1]>0 then putpix(trunc(kaw[a].x-1),trunc(kaw[a].y-1),kaw[a].pod[1],0);
       if kaw[a].kol[2]>0 then putpix(trunc(kaw[a].x),trunc(kaw[a].y-1),kaw[a].pod[2],0);
       if kaw[a].kol[3]>0 then putpix(trunc(kaw[a].x-1),trunc(kaw[a].y),kaw[a].pod[3],0);
       if kaw[a].kol[4]>0 then putpix(trunc(kaw[a].x),trunc(kaw[a].y),kaw[a].pod[4],0);
    end;
end;
end;

{*}PROCEDURE pok_kaw;
var r:byte;
begin
for a:=1 to maxkaw do begin
    if kaw[a].jest then begin
       if kaw[a].kol[1]>0 then putpix(trunc(kaw[a].x-1),trunc(kaw[a].y-1),kaw[a].kol[1],0);
       if kaw[a].kol[2]>0 then putpix(trunc(kaw[a].x),trunc(kaw[a].y-1),kaw[a].kol[2],0);
       if kaw[a].kol[3]>0 then putpix(trunc(kaw[a].x-1),trunc(kaw[a].y),kaw[a].kol[3],0);
       if kaw[a].kol[4]>0 then putpix(trunc(kaw[a].x),trunc(kaw[a].y),kaw[a].kol[4],0);
       if kaw[a].znik then kaw[a].jest:=false;
    end;
end;
end;

{*}PROCEDURE ruch_kaw;
var d,s1,s2,s3,s4:byte;a,ox1,oy1:integer;
begin
il_min:=0;
for a:=1 to maxkaw do begin
    if kaw[a].jest then begin
      if ((kaw[a].sx<>trunc(kaw[a].x)) or (kaw[a].sy<>trunc(kaw[a].y))) then begin
          for a1:=1 to maxminy do begin
              if miny[a1].jest then begin
              if (kaw[a].x+1>=miny[a1].x) and (kaw[a].x<=miny[a1].x) and
                 (kaw[a].y+1>=miny[a1].y) and (kaw[a].y<=miny[a1].y) then begin
                 if miny[a1].bum<130 then miny[a1].bum:=130;
              end;
              end;
          end;

        if (random(30-kaw[a].jeszcze_krew)=0) then
           nowysyf(trunc(kaw[a].x)-random(2),trunc(kaw[a].y),
                   {(random/4)-0.125,random/4-0.125}0,0,72,6,0);
        if (kaw[a].jeszcze_krew>0) and (random(30)=0) then dec(kaw[a].jeszcze_krew);
        if zmiana[2]=0 then begin
          d:=kaw[a].kol[1];
          kaw[a].kol[1]:=kaw[a].kol[2];
          kaw[a].kol[2]:=kaw[a].kol[4];
          kaw[a].kol[4]:=kaw[a].kol[3];
          kaw[a].kol[3]:=d;
        end;
      end;
       kaw[a].sx:=trunc(kaw[a].x);
       kaw[a].sy:=trunc(kaw[a].y);
       kaw[a].x:=kaw[a].x+kaw[a].dx;
       kaw[a].y:=kaw[a].y+kaw[a].dy;
       if kaw[a].kol[1]>0 then s1:=getpix(trunc(kaw[a].x-1),trunc(kaw[a].y-1))
                          else s1:=0;
       if kaw[a].kol[2]>0 then s2:=getpix(trunc(kaw[a].x),trunc(kaw[a].y-1))
                          else s2:=0;
       if kaw[a].kol[3]>0 then s3:=getpix(trunc(kaw[a].x-1),trunc(kaw[a].y))
                          else s3:=0;
       if kaw[a].kol[4]>0 then s4:=getpix(trunc(kaw[a].x),trunc(kaw[a].y))
                          else s4:=0;
       if kaw[a].y+1<0 then begin s1:=0;s2:=0;s3:=0;s4:=0;end;
       if ((s1<=15) or ((s1>=192) and (s1<250))) and
          ((s2<=15) or ((s2>=192) and (s2<250))) and
          ((s3<=15) or ((s3>=192) and (s3<250))) and
          ((s4<=15) or ((s4>=192) and (s4<250))) then begin
          if ((dziura_na_dole=0) and (trunc(kaw[a].y)<>199)) or
             (dziura_na_dole>0) then kaw[a].dy:=kaw[a].dy+0.04;end;
       if (((s1>15) and (s1<192)) or (s1>=250)) or
          (((s2>15) and (s2<192)) or (s2>=250)) or
          (((s3>15) and (s3<192)) or (s3>=250)) or
          (((s4>15) and (s4<192)) or (s4>=250)) or
          (kaw[a].y>=199) and (dziura_na_dole=0) then begin
             kaw[a].x:=kaw[a].x-kaw[a].dx;
             kaw[a].y:=kaw[a].y-kaw[a].dy;
             if random(2)=0 then kaw[a].dx:=-kaw[a].dx/(1.3+(random/5))
                            else kaw[a].dx:=kaw[a].dx/(1.3+(random/5));
             if random(2)=0 then kaw[a].dy:=-kaw[a].dy/(2+(random/5))
                            else kaw[a].dy:=kaw[a].dy/(2+(random/5));
             if (abs(kaw[a].dx)>0.2) or (abs(kaw[a].dy)>0.2) then
             for d:=0 to 3 do begin
                 ox1:=trunc(kaw[a].x)-random(2);
                 oy1:=trunc(kaw[a].y)-random(2);
                 if getpix(ox1,oy1)<=15 then
                 nowysyf(ox1,oy1,
                         ((random*kaw[a].dx)*2)-kaw[a].dx,
                         ((random*kaw[a].dy)*2)-kaw[a].dy,
                         72,6,0);
             end;
             if abs(kaw[a].dy)>0.3 then graj_dzwiek(VoiceData [5],0.8+random/2,0);
       end;
       if kaw[a].dx>0 then kaw[a].dx:=kaw[a].dx-0.001;
       if kaw[a].dx<0 then kaw[a].dx:=kaw[a].dx+0.001;
       if kaw[a].dy>5 then kaw[a].dy:=5;
       if kaw[a].dy<-5 then kaw[a].dy:=-5;
       if (kaw[a].x<0) or (kaw[a].x>319) then kaw[a].jest:=false;
       if (kaw[a].y>=199) and (dziura_na_dole=1) then begin
          for d:=0 to 15 do
              nowysyf(kaw[a].x,198,random/1.5-0.333,(-0.3-random/3)*abs(kaw[a].dy/3),224,5,1);
          kaw[a].jest:=false;
          if abs(kaw[a].dy)>0.3 then graj_dzwiek(VoiceData [4],1.2+random/2,0);
          end;
       if (kaw[a].y>=199) and (dziura_na_dole=3) then kaw[a].jest:=false;
       if (kaw[a].y>=199) and (dziura_na_dole=2) then begin
          kaw[a].jest:=false;
          graj_dzwiek(VoiceData [7],0.7+random/2,0);
       end;
       if (kaw[a].sx=trunc(kaw[a].x)) and (kaw[a].sy=trunc(kaw[a].y)) then inc(kaw[a].stoi)
          else kaw[a].stoi:=0;
       if kaw[a].stoi>=50 then begin
          kaw[a].znik:=true;
          if (kaw[a].kol[1]>0) and (kaw[a].kol[3]=0) and (getpix(trunc(kaw[a].x-1),trunc(kaw[a].y))<=15) then begin
             kaw[a].kol[3]:=kaw[a].kol[1];
             kaw[a].kol[1]:=0;
          end;
          if (kaw[a].kol[2]>0) and (kaw[a].kol[4]=0) and (getpix(trunc(kaw[a].x),trunc(kaw[a].y))<=15) then begin
             kaw[a].kol[4]:=kaw[a].kol[2];
             kaw[a].kol[2]:=0;
          end;
       end;
    end;
end;
end;

{*}PROCEDURE nowykaw(x,y,dx,dy:real);
var a,b:byte;
begin
for a:=1 to maxkaw do begin
    if not kaw[a].jest then begin
       kaw[a].jest:=true;
       kaw[a].x:=x;
       kaw[a].y:=y;
       kaw[a].dx:=dx;
       kaw[a].dy:=dy;
       kaw[a].znik:=false;
       kaw[a].stoi:=0;
       kaw[a].pod[1]:=0;
       kaw[a].kol[1]:=random(4)+67;
       kaw[a].jeszcze_krew:=28-random(10);
       for b:=2 to 4 do begin
           kaw[a].pod[b]:=0;
           if random(3)>0 then kaw[a].kol[b]:=random(4)+67
                          else kaw[a].kol[b]:=0;
       end;
       a:=maxkaw;
    end;
end;
end;

{*}PROCEDURE nowysyf(msx,msy,ksx,ksy:real;kolor,ile,zmaz:byte);
var a:word;
begin
for a:=1 to maxsyf do begin
    if syf[a].jest=0 then begin
       syf[a].jest:=1;
       syf[a].x:=msx;
       syf[a].y:=msy;
       syf[a].dx:=ksx;
       syf[a].dy:=ksy;
       syf[a].kol:=random(ile)+kolor;
       syf[a].zmaz:=zmaz;
       a:=maxsyf;
    end;
end;
end;

{*}PROCEDURE rysuj_ogien;
var
a:word;
b,c,d:byte;
begin
for a:=0 to 319 do begin
    b:=getpix(a,199);
    if (b<=15) or ((b>=202) and (b<=207)) or ((b>=224) and (b<=228))  then begin
       c:=getpix(a,199);c:=c+random(3)-1;
       d:=getpix(a-1,199);
       if (d>=202) and (d<=207) then begin
          if c<d-1 then c:=d-1;
          if c>d+1 then c:=d+1;
       end;
       if c<202 then c:=202;
       if c>207 then c:=207;
       putpix(a,199,c,0);
       if random(10)=0 then nowysyf(a,199,0,-random/2.5,205,3,1)
          else
       if random(500)=0 then nowysyf(a,199,random/2-0.25,-random*0.8-0.3,205,3,1);
    end;
end;

end;

{*}PROCEDURE bum(gx,gy,sila:integer;dzwiek,blysk,dziura,metal,wrzaski,zapala,gasi:boolean);
var
xf,yf,kat,ile_krwi,piks:byte;
b1,b2:shortint;
krok,s1,s2:real;
b,bb,c,d,a:integer;
begin
if not gasi then begin
if dzwiek then graj_dzwiek(VoiceData [1],0.5+sila/50+random/10,0);
if blysk then begin
   krok:=15/sila;
   for a:=1 to sila do begin
      if zoom then begin
         drawcircle(gx*2-pox*2,gy*2-poy*2,trunc(a/1.5)*2,207-trunc(krok*a));
         drawcircle(gx*2-pox*2+1,gy*2-poy*2,trunc(a/1.5)*2,207-trunc(krok*a));
         drawcircle(gx*2-pox*2,gy*2-poy*2+1,trunc(a/1.5)*2,207-trunc(krok*a));
         drawcircle(gx*2-pox*2+1,gy*2-poy*2+1,trunc(a/1.5)*2,207-trunc(krok*a));
         end
              else drawcircle(gx,gy,trunc(a/1.5),207-trunc(krok*a));
   end;
end;
bb:=1;
if (dziura) and (Gy>=0) then begin
   while trunc(Gy-cos(bb/sila*3)*sila/3)<0 do inc(bb);
   for b:=bb to sila do begin
    b1:=random(3)-1;b2:=random(3)-1;
    for c:=trunc(Gx-sin(b/sila*3)*sila/2)+b1 to trunc(Gx+sin(b/sila*3)*sila/2)+b2 do begin
        piks:=getpix(c,trunc(Gy-cos(b/sila*3)*sila/3));
        if piks in [229..248] then piks:=0;
        if (random(3)=0) and (piks>15) then begin
                 s1:=(random)*(sila/12)-(sila/24);
                 s2:=(random)*(sila/12)-(sila/24);
                 if (s1>0) and (s1<0.5) then s1:=0.5;
                 if (s1<0) and (s1>-0.5) then s1:=-0.5;
                 if (s2>0) and (s2<0.5) then s2:=0.5;
                 if (s2<0) and (s2>-0.5) then s2:=-0.5;
                if (piks<144) or ((piks>159) and (piks<=248)) or ((piks>=250) and (piks<=251)) then
                 nowysyf(c,trunc(Gy-cos(b/sila*3)*sila/3),
                         s1,s2
                         ,piks,1,1);
        end;
        if ((not metal) and ((piks<144) or (piks>159))) or (metal) then putpix(c,trunc(Gy-cos(b/sila*3)*sila/3),0,0);
    end;
   end;
end;
end;
for a:=1 to maxludzie do begin
    if post[1,a]=1 then begin
       if (post[2,a]+5>=gx-sila) and (post[2,a]+5<=gx+sila) and
          (post[3,a]+5>=gy-sila) and (post[3,a]+5<=gy+sila) then begin
          if not gasi then begin
           ile_krwi:=10+trunc(((sila-(post[2,a]-gx))/20)*((sila-(post[3,a]-gy))/20));
           if (not zapala) or ((zapala) and (sila>7)) then begin
           for d:=0 to ile_krwi do
                 nowysyf(round(post[2,a]+5+sin(((8+random(16))/5)*(6+random(round(sila/3))))),
                         round(post[3,a]+5+cos(((8+random(16))/5)*(6+random(round(sila/3))))),
                        (random*2-1),random*4-2,72,6,0);
           if (post[2,a]+5>=gx) then post[7,a]:=post[7,a]+abs(sila-(post[2,a]-gx))/20;
           if (post[2,a]+5<=gx) then post[7,a]:=post[7,a]-abs(sila-abs(post[2,a]-gx))/20;
           if (post[3,a]+5>=gy) then post[6,a]:=post[6,a]+abs(sila-(post[3,a]-gy))/20;
           if (post[3,a]+5<=gy) then post[6,a]:=post[6,a]-abs(sila-abs(post[3,a]-gy))/20;
           end;
           post[9,a]:=post[9,a]-abs((sila-abs(post[2,a]-gx))*(sila-(post[3,a]-gy)))/20;
           if post[9,a]<=0 then begin
              if post_zdycha[a]=0 then begin
                 post_zdycha[a]:=1;czm:=true;
                 post_rodzsmierc[a]:=random(4);
          if miesko then
          case post_rodzsmierc[a] of
               1:nowykaw(post[2,a]+4,post[3,a]+4,random*3*(post[4,a]/post[4,a]),random-0.5);
               2:begin
                 nowykaw(post[2,a]+4,post[3,a]+4,random*3*(post[4,a]/post[4,a]),random-0.5);
                 nowykaw(post[2,a]+4,post[3,a]+4,random*-3*(post[4,a]/post[4,a]),random-0.5);
                 end;
               3:nowykaw(post[2,a]+4,post[3,a]+4,-random-0.3,random-0.5);
          end;
              end;
              if post_zdycha[a]>0 then
              post_zdycha[a]:=post_zdycha[a]+trunc(abs((sila-abs(post[2,a]-gx))*(sila-abs(post[3,a]-gy)))/20);
           end;
           if (wrzaski) and (random(2)=0) then
              graj_dzwiek(VoiceData [14+random(3)+(10*trunc(post[10,a]))],0.8+random/3,1+trunc(post[10,a]));
           if dziura then begin
              for yf:=1 to 10 do begin
              for xf:=1 to 10 do begin
                  postm[a,xf,yf]:=0;
              end;end;
           end;
          end;
           if zapala then post_pali[a]:=1;
           if gasi then post_pali[a]:=0;
          end;
    end;
end;
if not gasi then begin
for a:=1 to maxminy do begin
    if miny[a].jest then begin
       if (miny[a].x>=gx-sila) and (miny[a].x<=gx+sila) and
          (miny[a].y>=gy-sila) and (miny[a].y<=gy+sila) then begin
           if (miny[a].x>=gx) then miny[a].dx:=miny[a].dx+abs(sila-(miny[a].x-gx))/(18+random*9);
           if (miny[a].x<=gx) then miny[a].dx:=miny[a].dx-abs(sila-abs(miny[a].x-gx))/(18+random*9);
           if (miny[a].y>=gy) then miny[a].dy:=miny[a].dy+abs(sila-(miny[a].y-gy))/(18+random*9);
           if (miny[a].y<=gy) then miny[a].dy:=miny[a].dy-abs(sila-abs(miny[a].y-gy))/(18+random*9);
           if miny[a].bum=0 then miny[a].bum:=1+random(10);
          end;
    end;
end;
for a:=1 to maxkaw do begin
    if kaw[a].jest then begin
       if (kaw[a].x>=gx-sila) and (kaw[a].x<=gx+sila) and
          (kaw[a].y>=gy-sila) and (kaw[a].y<=gy+sila) then begin
           if (kaw[a].x>=gx) then kaw[a].dx:=kaw[a].dx+abs(sila-(kaw[a].x-gx))/(38+random*9);
           if (kaw[a].x<=gx) then kaw[a].dx:=kaw[a].dx-abs(sila-abs(kaw[a].x-gx))/(38+random*9);
           if (kaw[a].y>=gy) then kaw[a].dy:=kaw[a].dy+abs(sila-(kaw[a].y-gy))/(38+random*9);
           if (kaw[a].y<=gy) then kaw[a].dy:=kaw[a].dy-abs(sila-abs(kaw[a].y-gy))/(38+random*9);
          end;
    end;
end;
if jestekrbum then ekrbum:=trunc(sila/2);
czm:=true;
end;
end;

{*}PROCEDURE ciecie;
var b:byte;
begin
b:=getpix(mx,my);
if (b>=16) then begin
   bum(mx,my,7,false,false,false,false,true,false,false);
   nowysyf(mx,my,random*2-1,random*2-1,getpix(mx,my),1,1);
   drawline(_Smx2,_Smy2,mx,my,0,5);
{   nowysyf(mx-1+random(3),my-1+random(3),random*2-1,random*2-1,getpix(mx,my),1,1);}

   if (b in [229..248]) and (random(10)=0) then nowykaw(mx,my,random*4-2,random*4-2);
end;
end;


{*}PROCEDURE wczytaj_obr_tla;
var
BMPFile:File;
Palette:Array [0..16,0..3] of Byte;
Lines,Counter:Word;
count:byte;
linia:array[0..319] of byte;
a,b:byte;
zm:boolean;
a1:integer;

begin
{str(niebo-16,wyr);}
Assign (BMPFile,'graf.dat');
filemode:=0;
Reset (BMPFile, 1);
{!}seek(BMPFile,205829+54+(32118*(longint(niebo-17))));{!}
BlockRead (BMPFile, Palette, 64);
lines := 0;
while (lines <200) and (not eof(bmpfile)) do begin
BlockRead (BMPFile, linia, 160);
for a1:=159 downto 0 do begin
    scr2^[199-lines,a1*2]:=linia[a1] div 16;
    scr2^[199-lines,1+a1*2]:=linia[a1] mod 16;
end;
inc (lines);
end;
close (BMPFile);

for a:=1 to 15 do begin
    pal_gl[a,0]:=palette[a,2] shr 2;
    pal_gl[a,1]:=palette[a,1] shr 2;
    pal_gl[a,2]:=palette[a,0] shr 2;
end;
end;

{*}PROCEDURE przerob_obr_nieba(jak:byte);
var
linia:array[0..319] of byte;
x,y:integer;
xf,yf:byte;
begin
for y:=0 to 199 do begin
    xms2mem(_xms[6].h,12800+longint(y)*320,linia,320);
    for x:=0 to 319 do begin
        if (linia[x]>=1) and (linia[x]<=15) then begin
           case jak of
                0:begin
                  linia[x]:=Scr2^[y,x];
                  end;
                1:linia[x]:=1+(y div 14)+cien[y mod 14];
           end;
        end;
    end;
    mem2xms(linia,_xms[6].h,12800+longint(y)*320,320);
end;

for y:=0 to 199 do begin
    for x:=0 to 319 do begin
        if (Scr^[y,x]>=1) and (Scr^[y,x]<=15) then begin
           case jak of
                0:begin
                  Scr^[y,x]:=Scr2^[y,x];
                  end;
                1:Scr^[y,x]:=1+(y div 14)+cien[y mod 14];
           end;
        end;
    end;
end;

for a:=1 to maxludzie do begin
    for yf:=1 to 10 do begin
        for xf:=1 to 10 do begin
            if postm[a,xf,yf]<=15 then postm[a,xf,yf]:=0;
        end;
    end;
end;

for a:=1 to 50 do begin
    for yf:=1 to 3 do begin
        for xf:=1 to 3 do begin
            if pod_strz[a,xf,yf]<=15 then pod_strz[a,xf,yf]:=0;
        end;
    end;
end;

for a:=1 to maxkaw do begin
    for xf:=1 to 4 do begin
        if kaw[a].pod[xf]<=15 then kaw[a].pod[xf]:=0;
    end;
end;

for a:=1 to maxsnieg do begin
    if snieg^[a].pod<=15 then snieg^[a].pod:=0;
end;

for a:=1 to 5 do begin
    if punkt_wyjscia[a].pod<=15 then punkt_wyjscia[a].pod:=0;
end;

if pod_celow<=15 then pod_celow:=0;

case niebo of
     0..16:for a:=1 to 7 do drawline(159,42+a,169,42+a,a*2,2);
     else
for a:=1 to 7 do begin
    for a1:=1 to 11 do begin
        putpix(158+a1,42+a,scr2^[trunc(a*28.3),trunc(a1*28.3)],0);
    end;
end;
end;

end;

{*}PROCEDURE nowy_komentarz(xx,yy,dlug,txt:integer);
begin
with komentarz do begin
     case txt of
        -1:jaki:='POCISK';
        -2:jaki:='GRANAT ODlAMKOWY';
        -3:jaki:='POCISK SAMONAPROWADZAJaCY';
        -4:jaki:='DZIAlO MASZYNOWE';
        -5:jaki:='BROn SNAJPERSKA';
        -6:jaki:='MINA';
        -7:jaki:='NALOT BOMBOWY';
        -8:jaki:='PIlA';
        -9:jaki:='RACA';
       -10:jaki:='KOWADlO';
       -11:jaki:='KREW';
       -12:jaki:='KAMYKI';
       -13:jaki:='ISKRY';
       -14:jaki:='sNIEG';
       -15:jaki:='DESZCZ';
       -16:jaki:='SOPLE';
       -17:jaki:='PIORUNY';
       -18:jaki:='POSTACI';
       -19:jaki:='PUNKTY WYJsCIA';
       -20:jaki:='RYSOWANIE';

       -52..-51:jaki:='AGRESJA';
       -53:jaki:='BURZA';
       -54:jaki:='DESZCZ';
       -55:jaki:='sNIEG';
       -56:jaki:='WODA';
       -57:jaki:='OGIEn';
       -58:jaki:='PRZEPAsc';
       -59:jaki:='SOPLE';
       -60:jaki:='HORROR';
       -61:jaki:='STRZELAJa';
       -62:jaki:='BIJa SIe';
       -63:jaki:='WYBUCH PRZY sMIERCI';
       -64:jaki:='WYCHODZa DO GoRY';
       -65:jaki:='SZALENI LUDZIE';
       -66:jaki:='DxWIeK';
       -67:jaki:='ZOOM';
       -68:jaki:='BOMBA ATOMOWA';

      -101:jaki:='SToJ';
      -102:jaki:='IDx';
      -103:jaki:='BIEGNIJ';
      -104:jaki:='ZAWRoc';
      -105:jaki:='BLOKUJ';
      -106:jaki:='KOP';
      -107:jaki:='PANIKA';
      -108:jaki:='sMIERc';
      -109:jaki:='+50 SIlY';
      -110:jaki:='ODZNACZ';

      -150:jaki:='DRUzYNA 1';
      -151:jaki:='DRUzYNA 2';
      -152:jaki:='DRUzYNA 3';
      -153:jaki:='DRUzYNA 4';
      -154:jaki:='DRUzYNA 5';

        0..50:begin
              str(txt+3,jaki);
              jaki:=jaki+' X COMBO';
              end;
     end;
     dl:=dlug;
     x:=xx-trunc(length(jaki)*2.5);
     y:=yy;
     if x<0 then x:=0;
     if x+length(jaki)*5>320 then x:=trunc(320-length(jaki)*5);
     if y<11 then y:=11;
     if y>192 then y:=192;
end;

end;

{*}PROCEDURE shot;
type
  pcxheader_rec = Record
    manufacturer   : Byte;
    version        : Byte;
    encoding       : Byte;
    bitsperpixel : Byte;
    xmin, ymin     : integer;
    xmax, ymax     : integer;
    hres, vres     : integer;
    paltte        : Array [0..47] of Byte;
    reserved       : Byte;
    Nplanes  : Byte;
    Bytesperline : integer;
    paletteType   : integer;
    filler         : Array [0..57] of Byte;
  end;

var
 header:pcxheader_rec;
 f:file;
 i,j,gdziebufor,numer:word;
 kolor:byte;
 ilosc:byte;
 bufor:array[0..500] of byte;
 pall:paleta_typ;

procedure zapisz;
begin
 ilosc:=ilosc or (128+64);
 bufor[gdziebufor]:=ilosc;inc(gdziebufor);
 bufor[gdziebufor]:=kolor;inc(gdziebufor);
 ilosc:=1;
end;

begin
 gdziebufor:=0;fillchar(bufor,sizeof(bufor),0);
 {getpalette(paleta);}
 with header do begin
   manufacturer:=10;
   version:=5;
   encoding:=1;
   bitsperpixel:=8;
   xmin:=0;
   ymin:=0;
   xmax:=319;
   ymax:=189;
   hres:=300;
   vres:=300;
   nplanes:=1;
   bytesperline:=320;
   paletteType:=0;
   fillchar(filler,sizeof(filler),0);
 end;

 numer:=0;

 repeat
 str(numer,wyr);while length(wyr)<3 do insert('0',wyr,1);
 assign(f,'sshot'+wyr+'.pcx');
 {$I-}
 reset(f);
 close(f);
 {$I+}
 a:=IOResult;
 inc(numer);
 until (a<>0) or (numer>=999);

 assign(f,'sshot'+wyr+'.pcx');
 {$I-}
 rewrite(f,1);
 blockwrite(f,header,sizeof(header));
 kolor:=mem[$A000:3200];
 ilosc:=1;
 for i:=3201 to 63999 do begin
     if kolor=mem[$A000:i] then begin
        inc(ilosc);
        if ilosc=63 then begin
           ilosc:=ilosc-1;
           zapisz;
        end;
     end
        else begin
        if (kolor<64) and (ilosc=1) then begin bufor[gdziebufor]:=kolor;inc(gdziebufor);end
                                    else zapisz;
        kolor:=mem[$A000:i];
        end;
     if gdziebufor>=400 then begin blockwrite(f,bufor,gdziebufor);gdziebufor:=0;end;
 end;
 zapisz;
 blockwrite(f,bufor,gdziebufor);
 kolor:=12;
 blockwrite(f,kolor,1);
 for i := 0 to 255 do begin
     pall[i,0]:=pal_gl[i,0] shl 2;
     pall[i,1]:=pal_gl[i,1] shl 2;
     pall[i,2]:=pal_gl[i,2] shl 2;
 end;
 blockwrite(f,pall,sizeof(pall));
 close(f);
 {$I+}
end;

{*}PROCEDURE strzal(msx,msy,ksx,ksy,sila,jaki:real;dzwiek,dzwiek_wyb:boolean;druzyna:byte;sek:integer;hom:boolean);
var a:byte;
begin
for a:=1 to maxpoc do begin
    if poc[1,a]=0 then begin
       poc[1,a]:=1;
       poc[2,a]:=msx;
       poc[3,a]:=msy;
       poc[4,a]:=ksx;
       poc[5,a]:=ksy;
       poc[6,a]:=sila;
       poc[7,a]:=jaki;
       poc_sek[a]:=sek;
       poc_dzw[a]:=dzwiek;
       if hom then begin
          poc_hom[a].x:=poc_hom_ust.x;
          poc_hom[a].y:=poc_hom_ust.y;
          poc_hom[a].dl:=0;
          poc_hom[a].ktory:=poc_hom_ust.ktory;
          poc_hom[a].jest:=true;
       end
          else poc_hom[a].jest:=false;
       a:=maxpoc;
    end;
end;
if (dzwiek_wyb) {and (random(2)=0)} then begin
   case druzyna of
        6:graj_dzwiek(VoiceData [3],1,0);
        0..5:graj_dzwiek(VoiceData [23+(10*(druzyna))],1,1+druzyna);
   end;
end;
end;

{*}PROCEDURE pociski;
var a,b,c,d:byte;
begin
for a:=1 to maxpoc do begin
    if poc[1,a]=1 then begin
       if (poc_hom[a].ktory>0) and (poc_hom[a].jest) then begin
          if post[1,poc_hom[a].ktory]=1 then begin
             poc_hom[a].x:=trunc(post[2,poc_hom[a].ktory])+5;
             poc_hom[a].y:=trunc(post[3,poc_hom[a].ktory])+5;
             end
          else begin
               poc_hom[a].jest:=false;
               poc_hom[a].ktory:=-1;
               poc_hom_ust.ktory:=-1
               end;
       end;
       putpix(round(poc[2,a]),round(poc[3,a]),0,0);
       if poc_sek[a]>1 then begin
          dec(poc_sek[a]);
          if random(3)=0 then
             nowysyf(trunc(poc[2,a]),trunc(poc[3,a]),random-0.5,random-0.5,205,3,1);
       end;

       if poc_hom[a].jest then begin
          if (poc[2,a]<poc_hom[a].x) and (poc[4,a]<2) then poc[4,a]:=poc[4,a]+0.2*(random/4+0.75);
          if (poc[2,a]>poc_hom[a].x) and (poc[4,a]>-2) then poc[4,a]:=poc[4,a]-0.2*(random/4+0.75);
          if (poc[3,a]<poc_hom[a].y) and (poc[5,a]<2) then poc[5,a]:=poc[5,a]+0.2*(random/4+0.75);
          if (poc[3,a]>poc_hom[a].y) and (poc[5,a]>-2) then poc[5,a]:=poc[5,a]-0.2*(random/4+0.75);
          inc(poc_hom[a].dl);
          if poc_hom[a].dl>500 then poc_hom[a].jest:=false;
       end;

       poc[2,a]:=poc[2,a]+poc[4,a];
       poc[3,a]:=poc[3,a]+poc[5,a];
       if not poc_hom[a].jest then begin
          poc[5,a]:=poc[5,a]+0.05;
          if poc[4,a]>0 then poc[4,a]:=poc[4,a]-0.01;
          if poc[4,a]<0 then poc[4,a]:=poc[4,a]+0.01;
          if (poc[2,a]<0) or (poc[2,a]>319) then poc[1,a]:=0;
       end;
       if (poc_hom[a].jest) and ((poc[2,a]<-100) or (poc[2,a]>419)) then poc[1,a]:=0;
       if poc[3,a]>=0 then b:=getpix(round(poc[2,a]),round(poc[3,a]))
                      else b:=0;
       if (poc[2,a]<0) or (poc[2,a]>319) then b:=0;
       if poc[3,a]>=199 then begin
          if dziura_na_dole=1 then begin
             for d:=0 to 5 do
                 nowysyf(poc[2,a],198,(random/2)-0.25,-0.2-random/2,224,5,1);
             graj_dzwiek(VoiceData [4],1.2+random/2,0);
             poc[1,a]:=0
          end
             else
                if dziura_na_dole=3 then poc[1,a]:=0
                            else begin b:=21;poc[3,a]:=199;end;
       end;
       if (((b>15) and (b<192)) or ((b>=229) and (b<=248)) or ((b>=250) and (b<=251))) or
          ((poc[7,a]=2) and (poc_sek[a]=1)) then begin
          if poc[7,a]=1 then begin
             for c:=1 to bron_odlamki do
                 strzal(round(poc[2,a]),round(poc[3,a]),random*4-2,-random*3,sila_odlamki*3+3,0,true,false,6,0,false);
          end;
          if b in [229..248] then begin
             for c:=0 to 10+(trunc((((poc[6,a]-(post[2,a]-poc[2,a]))/10)*((poc[6,a]-(post[3,a]-poc[3,a]))/10))/15)) do
                 nowysyf(round(poc[2,a]+sin(((8+random(16))/5)*(6+random(round(poc[6,a]/3))))),
                         round(poc[3,a]+cos(((8+random(16))/5)*(6+random(round(poc[6,a]/3))))),
                        (random*2-1),random*4-2,72,6,0);
             if random(2)=0 then graj_dzwiek(VoiceData [14+random(3)+(10*trunc(post[10,a]))],0.8+random/3,1+trunc(post[10,a]));
                                          end
           else begin
           end;
          if poc[7,a]=2 then begin
             bum(round(poc[2,a]),round(poc[3,a]),5,true,true,true,false,true,true,false);
             for b:=1 to 50 do begin
              nowysyf(poc[2,a]-poc[4,a],poc[3,a]-poc[5,a],
                      (sin((b/50)*6.28))*2,(cos((b/50)*6.28))*2-1,
                      205,3,1);
             end;
             if poc_sek[a]=1 then blysk_pioruna:=8;
             end
                else
             bum(round(poc[2,a]),round(poc[3,a]),round(poc[6,a]),poc_dzw[a],true,true,false,true,false,false);
          poc[1,a]:=0;
       end;
       if poc[1,a]=1 then putpix(round(poc[2,a]),round(poc[3,a]),249,0);
    end;
end;
end;

{*}PROCEDURE ruch_kowadla;
var a,xf,yf,d,e,gp:byte;
begin
for a:=1 to 10 do begin
    if kowadlo^[a].jest=1 then begin
       kowadlo^[a].Sy:=kowadlo^[a].y;
       if kowadlo^[a].dy<3 then kowadlo^[a].dy:=kowadlo^[a].dy+0.1;
       if kowadlo^[a].dy<1 then kowadlo^[a].dy:=1;
       kowadlo^[a].y:=kowadlo^[a].y+kowadlo^[a].dy;

       if (kowadlo^[a].y>=200) and (dziura_na_dole>0) then begin
          if dziura_na_dole=1 then begin
             for d:=0 to 30 do
                 nowysyf(kowadlo^[a].x+random(17),198,random-0.5,-0.4-random,224,5,1);
             graj_dzwiek(VoiceData [4],1.2+random/2,0);
          end;
          kowadlo^[a].jest:=2;
       end;
       if kowadlo^[a].jest=1 then begin
          if kowadlo^[a].stoi<=5 then begin
          for d:=1 to maxludzie do
              if post[1,d]=1 then begin
                 if (post[2,d]>=kowadlo^[a].x-5) and (post[2,d]<=kowadlo^[a].x+10) and
                    (post[3,d]>=kowadlo^[a].y-4) and (post[3,d]<=kowadlo^[a].y+7) then begin
                    post[9,d]:=0;
                    post_zdycha[d]:=254;
                 end;
              end;
          for d:=1 to maxminy do begin
              if miny[d].jest then begin
                 if (miny[d].x>=kowadlo^[a].x+1) and
                    (miny[d].x<=kowadlo^[a].x+16) and
                    (miny[d].y>=kowadlo^[a].y) and
                    (miny[d].y<=kowadlo^[a].y+7) then miny[d].bum:=150;
              end;
          end;
          end;
          e:=0;
          for d:=1 to 14 do begin
              gp:=getpix(kowadlo^[a].x+1+d,trunc(kowadlo^[a].y+5));
              if ((gp>=16) and (gp<=191)) or ((gp>=250) and (gp<=251)) or
                 ((kowadlo^[a].y>=195) and (dziura_na_dole=0)) then inc(e);
          end;
          if (e>0) and (kowadlo^[a].stoi=0) then graj_dzwiek(VoiceData [13],0.9+random/5,0);
          if e=0 then kowadlo^[a].stoi:=0;
          if e in [1..3] then begin
             for d:=1 to 14 do begin
                 gp:=getpix(kowadlo^[a].x+1+d,trunc(kowadlo^[a].y+5));
              if ((gp>=16) and (gp<=191)) or ((gp>=250) and (gp<=251)) then
                 nowysyf(kowadlo^[a].x+1+d,trunc(kowadlo^[a].y+5),
                         random*2-1,random*2-1,
                         getpix(kowadlo^[a].x+1+d,trunc(kowadlo^[a].y+5)),1,1);
             end;
          end;
          if e>=4 then begin
             kowadlo^[a].y:=kowadlo^[a].y-kowadlo^[a].dy;
             kowadlo^[a].dy:=kowadlo^[a].dy/2;
             inc(kowadlo^[a].stoi);d:=14;
          end;

          if kowadlo^[a].stoi>=50 then begin
             kowadlo^[a].jest:=0;
          end;
       end;

    end;
end;
end;


{*}PROCEDURE zmaz_kowadla;
var a,xf,yf:byte;
begin
for a:=1 to 10 do begin
    if kowadlo^[a].jest>0 then begin
       for yf:=0 to 5 do begin
           for xf:=0 to 16 do begin
               if (kowadlo_obr^[yf+1,xf+1]<>0) then
                  putpix(kowadlo^[a].x+xf,trunc(kowadlo^[a].Sy+yf),0,0);
           end;
       end;
       if kowadlo^[a].jest=2 then kowadlo^[a].jest:=0;
    end;
end;
end;

{*}PROCEDURE pokaz_kowadla;
var a,xf,yf:byte;
begin
for a:=1 to 10 do begin
    if kowadlo^[a].jest=1 then begin
       for yf:=0 to 5 do begin
           for xf:=0 to 16 do begin
               if (kowadlo_obr^[yf+1,xf+1]<>0) then
                  putpix(kowadlo^[a].x+xf,trunc(kowadlo^[a].y+yf),kowadlo_obr^[yf+1,xf+1],0);
           end;
       end;
    end;
end;
end;



{*}PROCEDURE rozpoczecie_xms;
begin
_xms[0].os:=0;

{0 - pamiec dla dzwiekow glownych}
a:=xmsgetmem(_xms[0].h,200000);
if a<>0 then begin textmode(3);write('Brakuje pamieci XMS !!!');halt;end;
{1..5 - pamiec dla zestawow postaci}
for a1:=1 to 5 do begin
    a:=xmsgetmem(_xms[a1].h,150000);
    if a<>0 then begin textmode(3);write('Brakuje pamieci XMS !!!');halt;end;
end;
{6 - pamiec dla obrazkow menu}
{6 + 12800 - pamiec na zapamietany obraz przy menuESC}
{6 + 76800 - pamiec na tlo pod komentarzami}
a:=xmsgetmem(_xms[6].h,78720);
if a<>0 then begin textmode(3);write('Brakuje pamieci XMS !!!');halt;end;
{8 - pamiec na obiekty do rysowania (drzewa itd)}
(*a:=xmsgetmem(_xms[8].h,200000);
if a<>0 then begin textmode(3);write('Brakuje pamieci XMS !!!');halt;end;*)

getmem(obraz,sizeof(obraz^));
getmem(fonty,sizeof(fonty^));
getmem(scr,sizeof(scr^));wielk_scr(0,0,319,199);fillchar (scr^, 64000, 0);
getmem(scr2,sizeof(scr2^));fillchar (scr2^, 64000, 0);
{getmem(scr_ukryty,sizeof(scr_ukryty^));fillchar (scr_ukryty^, 64000, 0);}
getmem(snieg,sizeof(snieg^));
getmem(menu_ikony,sizeof(menu_ikony^));
getmem(costam,sizeof(costam^));
getmem(rekordy,sizeof(rekordy^));

getmem(kowadlo,sizeof(kowadlo^));
getmem(kowadlo_obr,sizeof(kowadlo_obr^));
for a:=1 to 10 do kowadlo^[a].jest:=0;
end;

{*}PROCEDURE sprawdz_kartoteki;
begin
assign(plik,'dzwiek.cfg');
filemode:=0;
{$I-}
Reset(plik);
{$I+}
if IOResult <> 0 then begin
   writeln('Uruchom najpierw konfiguracje karty muzycznej! (USTAW.EXE)');
   halt;
end;
{$I-}
chdir('POSTACI');
if IOResult <> 0 then mkdir('POSTACI')
                 else chdir('..');
chdir('TERENY');
if IOResult <> 0 then mkdir('TERENY')
                 else chdir('..');
end;

{*}PROCEDURE poczatek_programu;
begin
randomize;
checkbreak:=false;
sprawdz_kartoteki;
asm
  mov ax, $13
  int $10
end;
rozpoczecie_xms;
end;

end.