uses crt,wave;

const
kart_wyb:array[1..2] of string=
                    ((' Bez karty '),
                     (' Sound Blaster '));
port_wyb:array[1..9] of string=
                    ((' 210h '),
                     (' 220h '),
                     (' 230h '),
                     (' 240h '),
                     (' 250h '),
                     (' 260h '),
                     (' 270h '),
                     (' 280h '),
                     (' 290h '));
dma_wyb:array[1..9] of string=
                    ((' 1 '),
                     (' 2 '),
                     (' 3 '),
                     (' 4 '),
                     (' 5 '),
                     (' 6 '),
                     (' 7 '),
                     (' 8 '),
                     (' 9 '));
irq_wyb:array[1..9] of string=
                    ((' 1 '),
                     (' 2 '),
                     (' 3 '),
                     (' 4 '),
                     (' 5 '),
                     (' 6 '),
                     (' 7 '),
                     (' 8 '),
                     (' 9 '));
max_wyb:array[1..4] of byte=(2,9,9,9);

var
kl:char;
a,x,y,z:integer;
wyb,Swyb:array[1..4] of byte;
wyr:string;
odswiez,ok,wyjscie:boolean;
plik:file of byte;
bb:byte;

{*}PROCEDURE pisz(x,y,kl,kt:byte;tekst:string);
begin
gotoxy(x,y);
textbackground(kt);textcolor(kl);
write(tekst);
end;

{*}PROCEDURE pisz_sz(x,y,kl,kt:byte;tekst:string);
var a:byte;
begin
textbackground(kt);textcolor(kl);
for a:=0 to trunc(length(tekst)/2) do begin
    gotoxy(x+trunc(length(tekst)/2)-a,y);write(tekst[trunc(length(tekst)/2)-a+1]);
    gotoxy(x+trunc(length(tekst)/2)+a,y);write(tekst[trunc(length(tekst)/2)+a+1]);
    delay(10);
end;
end;

{*}BEGIN
asm
   mov ah,01h
   mov ch,9
   mov cl,0
   int 10h
end;

textbackground(0);clrscr;
textbackground(1);
for z:=0 to 11 do begin
    for y:=13-z to 13+z do begin
        for x:=40-z*3 to 40+z*3 do begin
            gotoxy(1+x,y);write(' ');
        end;
    end;
    delay(10);
end;
  temp:=9;
  for Temp := 1 to 8 do begin
    if Temp <> 7 then
    if ResetDSP ($200 + Temp shl 4) then Break;
  end;

pisz_sz(8,2,15,4,'(c)GAD              USTAWIANIE KARTY MUZYCZNEJ              ver.1.1');
pisz_sz(8,24,15,4,'              Enter - zatwierdzenie , ESC - anulowanie             ');

pisz(22,24,31,4,'Enter');
pisz(46,24,31,4,'ESC');

str(temp,wyr);
pisz_sz(33,4,14,6,' Sound Blaster ');
if temp=9 then pisz(32,5,14,4,' nie znaleziony. ')
          else pisz(27,5,14,2,' znaleziony w porcie 2'+wyr+'0h. ');

wyb[1]:=1;  {KART}
wyb[2]:=1;  {PORT}
wyb[4]:=1;  {DMA}
wyb[3]:=1;  {IRQ}
x:=0;odswiez:=true;

   assign(plik,'dzwiek.cfg');
   {$I-}
   Reset(plik);
   {$I+}
   if IOResult = 0 then begin
      read(plik,wyb[1]);
      read(plik,wyb[2]);
      read(plik,wyb[4]);
      read(plik,wyb[3]);
      close(plik);
   end;

for a:=1 to 4 do Swyb[a]:=wyb[a];

for a:=1 to max_wyb[1] do pisz(15,8+a,7,0,kart_wyb[a]);
                            pisz(15,8+wyb[1],7,2,kart_wyb[wyb[1]]);
for a:=1 to max_wyb[2] do pisz(38,8+a,7,0,port_wyb[a]);
                            pisz(38,8+wyb[2],7,2,port_wyb[wyb[2]]);
for a:=1 to max_wyb[4] do pisz(58,8+a,7,0,dma_wyb[a]);
                           pisz(58,8+wyb[4],7,2,dma_wyb[wyb[4]]);
for a:=1 to max_wyb[3] do pisz(49,8+a,7,0,irq_wyb[a]);
                           pisz(49,8+wyb[3],7,2,irq_wyb[wyb[3]]);
repeat
if (Swyb[1]<>wyb[1]) or ((odswiez) and (x=0)) then begin {KARTA}
   pisz(15,7,13,5,' KARTA ');
   pisz(38,7,7,0,' PORT ');
   pisz(48,7,7,0,' IRQ ');
   pisz(57,7,7,0,' DMA ');
   pisz(15,8+Swyb[1],7,0,kart_wyb[Swyb[1]]);
   pisz(15,8+wyb[1],10,2,kart_wyb[wyb[1]]);
   pisz(38,8+wyb[2],8,2,port_wyb[wyb[2]]);
   pisz(58,8+wyb[4],8,2,dma_wyb[wyb[4]]);
   pisz(49,8+wyb[3],8,2,irq_wyb[wyb[3]]);
   Swyb[1]:=wyb[1];
end;
if (Swyb[2]<>wyb[2]) or ((odswiez) and (x=1)) then begin {PORT}
   pisz(15,7,7,0,' KARTA ');
   pisz(38,7,13,5,' PORT ');
   pisz(48,7,7,0,' IRQ ');
   pisz(57,7,7,0,' DMA ');
   pisz(15,8+wyb[1],8,2,kart_wyb[wyb[1]]);
   pisz(38,8+Swyb[2],7,0,port_wyb[Swyb[2]]);
   pisz(38,8+wyb[2],10,2,port_wyb[wyb[2]]);
   pisz(58,8+wyb[4],8,2,dma_wyb[wyb[4]]);
   pisz(49,8+wyb[3],8,2,irq_wyb[wyb[3]]);
   Swyb[2]:=wyb[2];
end;
if (Swyb[3]<>wyb[3]) or ((odswiez) and (x=2)) then begin {IRQ}
   pisz(15,7,7,0,' KARTA ');
   pisz(38,7,7,0,' PORT ');
   pisz(48,7,13,5,' IRQ ');
   pisz(57,7,7,0,' DMA ');
   pisz(15,8+wyb[1],8,2,kart_wyb[wyb[1]]);
   pisz(38,8+wyb[2],8,2,port_wyb[wyb[2]]);
   pisz(58,8+wyb[4],8,2,dma_wyb[wyb[4]]);
   pisz(49,8+Swyb[3],7,0,irq_wyb[Swyb[3]]);
   pisz(49,8+wyb[3],10,2,irq_wyb[wyb[3]]);
   Swyb[3]:=wyb[3];
end;
if (Swyb[4]<>wyb[4]) or ((odswiez) and (x=3)) then begin {DMA}
   pisz(15,7,7,0,' KARTA ');
   pisz(38,7,7,0,' PORT ');
   pisz(48,7,7,0,' IRQ ');
   pisz(57,7,13,5,' DMA ');
   pisz(15,8+wyb[1],8,2,kart_wyb[wyb[1]]);
   pisz(38,8+wyb[2],8,2,port_wyb[wyb[2]]);
   pisz(58,8+Swyb[4],7,0,dma_wyb[Swyb[4]]);
   pisz(58,8+wyb[4],10,2,dma_wyb[wyb[4]]);
   pisz(49,8+wyb[3],8,2,irq_wyb[wyb[3]]);
   Swyb[4]:=wyb[4];
end;
odswiez:=false;
if keypressed then begin
   kl:=readkey;
   if kl=#0 then begin
      kl:=readkey;
      if (kl=#72) then begin
         if wyb[x+1]>1 then dec(wyb[x+1]);
      end;
      if (kl=#80) then begin
         if wyb[x+1]<max_wyb[x+1] then inc(wyb[x+1]);
      end;
      if (kl=#75) and (x>0) then begin dec(x);odswiez:=true;end;
      if (kl=#77) and (x<3) then begin inc(x);odswiez:=true;end;

   end;
   if kl=#27 then wyjscie:=true;
   if kl=#13 then ok:=true;
end;
until (ok) or (wyjscie);

if ok then begin
   assign(plik,'dzwiek.cfg');
   {$I-}
   Rewrite(plik);
   {$I+}
   if IOResult = 0 then begin
      write(plik,wyb[1]);
      write(plik,wyb[2]);
      write(plik,wyb[4]);
      write(plik,wyb[3]);
      close(plik);
   end;
end;
textbackground(0);textcolor(7);
clrscr;
writeln;
if ok then writeln('Konfiguracja zapisana poprawnie')
      else writeln('Konfiguracja nie zapisana');
asm
   mov ah,01h
   mov ch,8
   mov cl,9
   int 10h
end;
END.