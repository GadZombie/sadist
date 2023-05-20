{$M $4000,0,150000 }
uses crt,dos;

type
Ekran=array [0..199, 0..319] of byte;
GDRHeader=record
  naglowek:array[0..3] of char;
  RX,RY:word;
  pal:array[0..255,0..2] of byte;
end;
fonty_tabl=array[0..59,1..6,1..5] of byte;

const
skok1:array[1..15] of byte=(0, 1,1, 2,2,2, 3,3,3,3, 2,2,2, 1,1);
skok2:array[1..15] of byte=(3,3,3,3, 2,2,2, 1,1, 0, 1,1, 2,2,2);

var
Scr,tlo:^Ekran;
pal,pal_gl:array[0..255,0..2] of byte;
fonty:^fonty_tabl;
instalujemy:boolean;

plik:File;
a,b:byte;
GDRHead:GDRHeader;

{*}PROCEDURE trybtext; assembler;
asm
  mov ax, $3
  int $10
end;

{*}PROCEDURE trybgraf; assembler;
asm
  mov ax, $13
  int $10
end;

{*}PROCEDURE move2(var Source,Dest); assembler;
asm
  push       ds
  les        di,Dest
  lds        si,Source
  mov        cx,16000
  db 66h;    rep movsw
  pop        ds
end;

{*}PROCEDURE cala_paleta;
var
count:byte;
begin
count:=port[$3DA];
while $8 and count<>0 do count:=port[$3DA];
while $8 and count=0 do count:=port[$3DA];
port[$3C8]:=0;
for count:=0 to 255 do begin
port[$3C9]:=pal[count,0];
port[$3C9]:=pal[count,1];
port[$3C9]:=pal[count,2];
end;
end;

{*}PROCEDURE Fadein2(_od,_do,szybkosc,szyb:byte;zerowanie:boolean);
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
cala_paleta;
while keypressed do readkey;
delay(szyb);
until not zm;
end;

{*}PROCEDURE Fadeout2(_od,_do,r,g,b,sz,szybkosc:byte);
var
a,c:byte;
zm:boolean;
begin
{pal:=pal_gl;}
repeat
zm:=false;
for a:=_od to _do do begin
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
cala_paleta;
while keypressed do readkey;
delay(sz);
until not zm;
end;

{*}PROCEDURE zciemnij;
var
a,c,d:byte;
begin
pal:=pal_gl;
for d:=0 to 15 do begin
for a:=0 to 252 do begin
    if pal[a,0]>0 then dec(pal[a,0]);
    if pal[a,1]>0 then dec(pal[a,1]);
    if pal[a,2]>0 then dec(pal[a,2]);
end;
cala_paleta;
delay(40);
while keypressed do readkey;
end;
end;

{*}PROCEDURE rozjasnij;
var
a,c,d:byte;
begin
{pal:=pal_gl;}
for d:=0 to 63 do begin
for a:=0 to 252 do begin
    if pal[a,0]<pal_gl[a,0] then inc(pal[a,0]);
    if pal[a,1]<pal_gl[a,1] then inc(pal[a,1]);
    if pal[a,2]<pal_gl[a,2] then inc(pal[a,2]);
end;
cala_paleta;
delay(20);
while keypressed do readkey;
end;
end;

{*}PROCEDURE Putpix(x, y : word; Kolor : byte);
begin
  Scr^[y, x] := Kolor;
end;

{*}FUNCTION Getpix(x, y : word):byte;
begin
  getpix:=Scr^[y, x];
end;

{*}PROCEDURE DrawLine (x1, y1, x2, y2 : Integer; c : Byte);
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
    PutPix (X, Y, c);
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

{*}PROCEDURE bar(x1,y1,x2,y2:word;kolor:byte);
var
  y : word;
begin
  for y := y1 to y2 do FillChar(Scr^[y, x1], x2-x1+1, kolor);
end;

{*}PROCEDURE Ebar(x1,y1,x2,y2:word;kolor:byte);
begin
  drawline(x1,y1,x1,y2,kolor);
  drawline(x2,y1,x2,y2,kolor);
  FillChar(Scr^[y1, x1], x2-x1+1, kolor);
  FillChar(Scr^[y2, x1], x2-x1+1, kolor);
end;

{*}PROCEDURE pisz(xobr,yobr:integer;tekst:string;kolor:integer;tlo:byte);
var xf,yf,numer,a:byte;
begin
for a:=1 to length(tekst) do begin
    for yf:=0 to 5 do begin
        for xf:=0 to 4 do begin
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
                 '\':numer:=57;
                 '_':numer:=58;
            end;
            if (tlo=1) and ((fonty^[numer,yf+1,xf+1]=0) or (tekst[a]=' ')) then putpix(xobr+xf+(a-1)*5,yobr+yf,0);
            if (fonty^[numer,yf+1,xf+1]>0) and (tekst[a]<>' ') then putpix(xobr+xf+(a-1)*5,yobr+yf,kolor);
        end;
    end;
end;
end;

{*}PROCEDURE piszC(xobr,yobr:integer;tekst:string;wys:byte);
begin
pisz(xobr,yobr,tekst,254,0);
pisz(xobr-wys,yobr-wys,tekst,253,0);
end;

{*}PROCEDURE wczytaj_fonty;
begin
assign(plik,{'font.obr'}paramstr(0));reset(plik,1);seek(plik,filesize(plik)-66548+2);
blockread(plik,fonty^,1770);close(plik);
end;

{*}FUNCTION wpisz(wyr2:string;illit,ile_widac:byte;_x,_y:integer):string;
var
   sc,c,c1,migkurs:byte;
   wyr3,wyr4:string;
   klw:char;
   a,b,gdzie_widac:integer;
begin
while (length(wyr2)>1) and (wyr2[length(wyr2)]=' ') do delete(wyr2,length(wyr2),1);
wyr4:=wyr2;
c:=length(wyr2);c1:=c;sc:=c;wyr3:='<inny>';
klw:=#255;gdzie_widac:=0;migkurs:=0;
while keypressed do readkey;
repeat
if c<gdzie_widac then gdzie_widac:=c;
if c>gdzie_widac+ile_widac then gdzie_widac:=c-ile_widac;
inc(migkurs);if migkurs>=40 then migkurs:=0;
{if (wyr3<>wyr2) or (c<>sc) then begin}
   bar(_x-1,_y-1,_x+ile_widac*5+1,_y+6,255);
   if migkurs<20 then begin
      drawline(_x+(c-gdzie_widac)*5,_y,_x+(c-gdzie_widac)*5,_y+6,254);
      drawline(_x-1+(c-gdzie_widac)*5,_y-1,_x-1+(c-gdzie_widac)*5,_y+5,252);
   end;
         for b:=gdzie_widac to gdzie_widac+ile_widac-1 do
             if b+1<=length(wyr2) then piszC(_x+(b-gdzie_widac)*5+1,_y+1,wyr2[b+1],1);
   wyr3:=wyr2;sc:=c;
{end;}
klw:=#255;
if keypressed then begin
   klw:=readkey;
   if (klw<>#13) and (klw<>#8) and (klw<>#0) and (klw<>#255) and (klw<>#27) and (c1<illit) then begin
      if klw in [#97..#122] then klw:=chr(ord(klw)-32);
{      if ((kl[54]) or (kl[42])) and (klw in ['A','C','E','L','N','O','S','Z','X']) then klw:=chr(ord(klw)+32);}
      insert(klw,wyr2,c+1);inc(c);inc(c1);klw:=#255;
   end;
   if (klw=#8) and (c>=1) then begin
      delete(wyr2,c,1);
      dec(c);dec(c1);klw:=#255;
   end;
   if klw=#0 then begin
      klw:=readkey;
      if (klw=#75) and (c>0) then dec(c);
      if (klw=#77) and (c<c1) then inc(c);
      if (klw=#83) and (c<c1) then begin
         for a:=c+1 to c1 do wyr2[a]:=wyr2[a+1];
         delete(wyr2,c1,1);
         dec(c1);
      end;
      klw:=#255;
   end;
end;
move (scr^, Mem [$A000:0000], 64000);
    a:=port[$3DA];
    while $8 and a<>0 do a:=port[$3DA];
    while $8 and a=0 do a:=port[$3DA];
until (klw=#13) or (klw=#27);
if klw=#27 then wpisz:='<chyba Nie za BaRdzO chCe se to InStAlOwAc>'
           else wpisz:=wyr2;
while keypressed do readkey;
drawline(_x-1+c*5,_y-1,_x-1+c*5,_y+5,255);
drawline(_x+(c-gdzie_widac)*5,_y,_x+(c-gdzie_widac)*5,_y+6,255);
end;



{------------------------------------------------------------------------}

{*}PROCEDURE wczytaj_gdr;
var b:byte;
begin
{Assign (plik,'untit3.gdr');}
assign(plik,paramstr(0));
{Reset(plik, 1);}
reset(plik,1);seek(plik,filesize(plik)-64776);

blockread(plik,GDRHead,sizeof(GDRHead));


for b:=0 to 63 do begin
    a:=port[$3DA];
    while $8 and a<>0 do a:=port[$3DA];
    while $8 and a=0 do a:=port[$3DA];
    port[$3C8]:=0;
    for a:=0 to 255 do begin
        port[$3C9]:=b; pal[a,0]:=b;
        port[$3C9]:=0; pal[a,1]:=0;
        port[$3C9]:=0; pal[a,2]:=0;
    end;
    inc(b);
end;

for a:=0 to 255 do begin
    pal_gl[a,0]:=GDRHead.pal[a,0];
    pal_gl[a,1]:=GDRHead.pal[a,1];
    pal_gl[a,2]:=GDRHead.pal[a,2];
end;

pal_gl[255,0]:=40; pal_gl[255,1]:=40; pal_gl[255,2]:=40;
pal_gl[254,0]:=20; pal_gl[254,1]:=20; pal_gl[254,2]:=20;
pal_gl[253,0]:=63; pal_gl[253,1]:=63; pal_gl[253,2]:=63;
pal_gl[252,0]:=00; pal_gl[252,1]:=00; pal_gl[252,2]:=63;


for a:=0 to GDRHead.RY-1 do begin
    blockread(plik,tlo^[a],GDRHead.RX);
end;
close(plik);
move2(tlo^,Scr^);
end;

{*}PROCEDURE okienko;
begin
for a:=0 to 50 do begin
    move2(tlo^,Scr^);
    bar(160-a*2,200-a*3-a div 2,160+a*2,200-a*3+a div 2,255);
    Ebar(160-a*2,200-a*3-a div 2,160+a*2,200-a*3+a div 2,252);
    move2(Scr^,mem[$A000:0000]);
    delay(2);
end;
for a:=0 to 15 do begin
    move2(tlo^,Scr^);
    bar(60-a*2,25-a*2+a*3,260+a*2,75+a*2+a*3,255);
    Ebar(60-a*2,25-a*2+a*3,260+a*2,75+a*2+a*3,252);
    move2(Scr^,mem[$A000:0000]);
    delay(2);
end;
end;

{*}PROCEDURE wyjscie;
begin
for a:=15 downto 0 do begin
    move2(tlo^,Scr^);
    bar(60-a*2,25-a*2+a*3,260+a*2,75+a*2+a*3,255);
    Ebar(60-a*2,25-a*2+a*3,260+a*2,75+a*2+a*3,252);
    move2(Scr^,mem[$A000:0000]);
    delay(2);
end;
for a:=50 downto 0 do begin
    move2(tlo^,Scr^);
    bar(160-a*2,200-a*3-a div 2,160+a*2,200-a*3+a div 2,255);
    Ebar(160-a*2,200-a*3-a div 2,160+a*2,200-a*3+a div 2,252);
    move2(Scr^,mem[$A000:0000]);
    delay(2);
end;
Fadeout2(0,255,0,0,0,0,1);
end;

{*}PROCEDURE poczatek;
begin
trybgraf;
getmem(scr,sizeof(scr^));
getmem(tlo,sizeof(tlo^));
getmem(fonty,sizeof(fonty^));
filemode:=0;
wczytaj_fonty;

wczytaj_gdr;

move(Scr^,mem[$A000:0000],64000);

Fadein2(0,255,1,0,false);
readkey;
okienko;
end;

{*}PROCEDURE dzialaj;
var x1:integer;kl:char;
begin
Fadeout2(253,253,40,40,40,0,63);
pisz(92,55,'SADIST: INSTALACJA PROGRAMU',253,0);

move2(Scr^,mem[$A000:0000]);
Fadein2(253,253,1,10,false);


piszC(160,80,'KONTYNUACJA',0);
piszC(160,100,'WYJsCIE',0);

piszC(125,80,'ENTER:',0);
piszC(135,100,'ESC:',0);
move2(Scr^,mem[$A000:0000]);

zciemnij;

for a:=0 to 2 do begin
    bar(90,52,230,62,255);
    piszC(92,55,'SADIST: INSTALACJA PROGRAMU',a);
    move2(Scr^,mem[$A000:0000]);
    delay(50);
end;

piszC(160,80,'KONTYNUACJA',1);
piszC(160,100,'WYJsCIE',1);

piszC(125,80,'ENTER:',0);
piszC(135,100,'ESC:',1);
move2(Scr^,mem[$A000:0000]);

x1:=0;
repeat
   repeat
      inc(x1);if x1>=16 then x1:=1;
      bar(115,70,158,110,255);
      piszC(125,80,'ENTER:',skok1[x1]);
      piszC(135,100,'ESC:',skok2[x1]);
      move2(Scr^,mem[$A000:0000]);
      delay(50);
   until keypressed;
   kl:=readkey;
   while keypressed do readkey;
until kl in [#13,#27];

instalujemy:=false;

if kl=#13 then instalujemy:=true;
end;

{*}PROCEDURE instalacja;
var katalog:string;
begin
for a:=1 downto 0 do begin
    bar(90,42,250,110,255);
    piszC(92,55,'SADIST: INSTALACJA PROGRAMU',a);
    piszC(160,80,'KONTYNUACJA',a);
    piszC(160,100,'WYJsCIE',a);
    piszC(125,80,'ENTER:',a);
    piszC(135,100,'ESC:',a);
    move2(Scr^,mem[$A000:0000]);
    delay(50);
end;
Fadeout2(253,254,40,40,40,10,1);

bar(31,41,289,149,255);

piszC(80,63,'PODAJ sCIEzKe DO KATALOGU, GDZIE',1);
piszC(90,73,'SADIST MA BYc ZAINSTALOWANY:',1);
move2(Scr^,mem[$A000:0000]);
Fadein2(253,254,1,10,false);

katalog:=wpisz('C:\GRY\SADIST\',200,50,35,100);

if katalog='<chyba Nie za BaRdzO chCe se to InStAlOwAc>' then exit;

{piszC(35,100,katalog,1);}
move2(Scr^,mem[$A000:0000]);
wyjscie;
Fadeout2(0,255,0,0,0,0,1);
trybtext;

swapvectors;
Exec('pkunzip.exe', '-d -o SADIST.ZIP '+katalog);
SwapVectors;

trybgraf;

move2(tlo^,Scr^);
fadeout2(0,255,0,0,0,0,63);
move2(Scr^,mem[$A000:0000]);
Fadein2(0,255,1,0,false);
okienko;

Fadeout2(253,254,40,40,40,0,63);

piszC(92,77,'SADIST ZOSTAl ZAINSTALOWANY',1);
piszC(140,90,'DZIeKUJe',1);
piszC(115,106,'zYCZe MIlEJ ZABAWY',1);
move2(Scr^,mem[$A000:0000]);
Fadein2(253,254,1,10,false);
while keypressed do readkey;
readkey;
Fadeout2(253,254,40,40,40,10,1);
end;

{*}PROCEDURE koniec;
begin
freemem(scr,sizeof(scr^));
freemem(tlo,sizeof(tlo^));
freemem(fonty,sizeof(fonty^));
trybtext;
writeln('SADIST instalator');
writeln('(c) 1999 Studio Komputerowe GAD');
writeln('http://gad.koti.com.pl/   email: gad@gad.koti.com.pl');
writeln('Oficjalna Strona SADIST: http://gad.koti.com.pl/sadist/');
while keypressed do readkey;
end;

{*}BEGIN
poczatek;
dzialaj;
if instalujemy then instalacja;
wyjscie;
koniec;
end.