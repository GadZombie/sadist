unit sadunit;

interface
uses wave,dos,mouse,crt,sad_rek,sad_graf,sad_var,xms;

PROCEDURE Get_Keyb_Int;interrupt;
PROCEDURE wczytaj_nowe_dzwieki(druzyna:byte);
PROCEDURE wczytaj_nowe_obrazki(nazwa:string;druzyna:byte);
PROCEDURE obrazki;
PROCEDURE obraz_myszy(numer:byte);
PROCEDURE pobr(xobr,yobr,numer,ktory,co,naco:integer;odwroc,dr:byte);
PROCEDURE sobr(xobr,yobr,numer,ktory:integer;odwroc,dr:byte);
PROCEDURE zmien_mysz;
PROCEDURE wstep;
PROCEDURE snieg_sypie;
PROCEDURE snieg_zmaz;
PROCEDURE snieg_pok;
PROCEDURE zmaz_miny;
PROCEDURE pok_miny;
PROCEDURE ruch_miny;
PROCEDURE nowamina(x,y,dx,dy:real);
PROCEDURE o_programie;
PROCEDURE nowakropla(msx,msy:integer;kolor:byte);
PROCEDURE nowysopel(msx,msy:integer;kolor:byte);
PROCEDURE resetuj_gory;
PROCEDURE losuj_gory;
PROCEDURE syfki_zmaz;
PROCEDURE syfki_pok;
PROCEDURE syfki;
PROCEDURE airstrike(msx,kier:integer);
PROCEDURE rysuj(Gx,Gy,z,kol,ekr:integer);
PROCEDURE wszystko_do_rysowania(ekr:byte);
PROCEDURE napisy_o_wybranym(jak:byte);
FUNCTION ile_wybr:byte;
FUNCTION ktory_wybr:byte;
PROCEDURE napisy_do_rysowania;
PROCEDURE napisy_broni;
PROCEDURE napisy;
PROCEDURE zmaz_ramke;
PROCEDURE zmaz_strz;
PROCEDURE postacie_zmaz;
PROCEDURE postacie_pok;
PROCEDURE sople_zmaz;
PROCEDURE zapis_na_koniec;
PROCEDURE winieta;
PROCEDURE strzal2(msx,msy,ksx,ksy:real;sila:byte;dzw:real);
PROCEDURE pociski2;
PROCEDURE ustaw_post(naco:byte);
PROCEDURE u_ile_wybr;
PROCEDURE sprawdz_zaznaczonych;
PROCEDURE zamknij;
PROCEDURE sople_pok;
PROCEDURE pok_strz;
PROCEDURE ekran_ukryty(co:byte);
PROCEDURE wczytaj;
PROCEDURE snajper(mx,my:integer);
PROCEDURE nowy(czywidok:byte);
PROCEDURE pierony(px,py:integer);
PROCEDURE pieron_w_tle(ile:byte);
PROCEDURE bomba_atomowa;
FUNCTION wpisz(wyr2:string;dlugosc:byte;m_x,m_y:word;spacja:boolean):string;
PROCEDURE guziki_w_rysowaniu;
PROCEDURE zaznacz_ramka;
PROCEDURE spr_ramke;
PROCEDURE spr_strz;
PROCEDURE guziki_strzelania;

implementation
{*}PROCEDURE Get_Keyb_Int;
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

{*}PROCEDURE wczytaj_nowe_dzwieki(druzyna:byte);
var
offst:longint;

begin
IF karta_muzyczna then begin
{if skas=1 then begin}
   _xms[druzyna].os:=0;
{   xmsfreemem(_xms_handler2);
a:=xmsgetmem(_xms_handler2,500000);
  if a<>0 then begin
     textmode(3);
     write(a);
     halt;
  end;
end;
 }

LoadVoice(VoiceData [14+(10*(druzyna-1))],'POSTACI\'+ostatnie_obr[druzyna]+'.sdp',dzwieki[druzyna].rozmiar[0],6571,druzyna);

offst:=6571+longint(dzwieki[druzyna].rozmiar[0]);
LoadVoice(VoiceData [15+(10*(druzyna-1))],'POSTACI\'+ostatnie_obr[druzyna]+'.sdp',dzwieki[druzyna].rozmiar[1],offst,druzyna);

offst:=6571+longint(dzwieki[druzyna].rozmiar[0])+longint(dzwieki[druzyna].rozmiar[1]);
LoadVoice(VoiceData [16+(10*(druzyna-1))],'POSTACI\'+ostatnie_obr[druzyna]+'.sdp',dzwieki[druzyna].rozmiar[2],offst,druzyna);

offst:=6571+longint(dzwieki[druzyna].rozmiar[0])+longint(dzwieki[druzyna].rozmiar[1])+
       longint(dzwieki[druzyna].rozmiar[2]);
LoadVoice(VoiceData [17+(10*(druzyna-1))],'POSTACI\'+ostatnie_obr[druzyna]+'.sdp',dzwieki[druzyna].rozmiar[3],offst,druzyna);

offst:=6571+longint(dzwieki[druzyna].rozmiar[0])+longint(dzwieki[druzyna].rozmiar[1])+
       longint(dzwieki[druzyna].rozmiar[2])+longint(dzwieki[druzyna].rozmiar[3]);
LoadVoice(VoiceData [19+(10*(druzyna-1))],'POSTACI\'+ostatnie_obr[druzyna]+'.sdp',dzwieki[druzyna].rozmiar[4],offst,druzyna);

offst:=6571+longint(dzwieki[druzyna].rozmiar[0])+longint(dzwieki[druzyna].rozmiar[1])+
       longint(dzwieki[druzyna].rozmiar[2])+longint(dzwieki[druzyna].rozmiar[3])+
       longint(dzwieki[druzyna].rozmiar[4]);
LoadVoice(VoiceData[21+(10*(druzyna-1))],'POSTACI\'+ostatnie_obr[druzyna]+'.sdp',dzwieki[druzyna].rozmiar[5],offst,druzyna);

offst:=6571+longint(dzwieki[druzyna].rozmiar[0])+longint(dzwieki[druzyna].rozmiar[1])+
       longint(dzwieki[druzyna].rozmiar[2])+longint(dzwieki[druzyna].rozmiar[3])+
       longint(dzwieki[druzyna].rozmiar[4])+longint(dzwieki[druzyna].rozmiar[5]);
LoadVoice(VoiceData[22+(10*(druzyna-1))],'POSTACI\'+ostatnie_obr[druzyna]+'.sdp',dzwieki[druzyna].rozmiar[6],offst,druzyna);

offst:=6571+longint(dzwieki[druzyna].rozmiar[0])+longint(dzwieki[druzyna].rozmiar[1])+
       longint(dzwieki[druzyna].rozmiar[2])+longint(dzwieki[druzyna].rozmiar[3])+
       longint(dzwieki[druzyna].rozmiar[4])+longint(dzwieki[druzyna].rozmiar[5])+
       longint(dzwieki[druzyna].rozmiar[6]);
LoadVoice(VoiceData[23+(10*(druzyna-1))],'POSTACI\'+ostatnie_obr[druzyna]+'.sdp',dzwieki[druzyna].rozmiar[7],offst,druzyna);

END;
end;

{*}PROCEDURE wczytaj_nowe_obrazki(nazwa:string;druzyna:byte);
var
plik:file;a,b,c:byte;
begin
assign(plik,'POSTACI\'+nazwa+'.sdp');filemode:=0;
reset(plik,1);
blockread(plik,ustaw[druzyna],51);
blockread(plik,obraz^[druzyna],6400);
blockread(plik,dzwieki[druzyna],120);
close(plik);

for a:=0 to 2 do begin
  for b:=0 to 2 do begin
    pal_gl[231+druzyna*3+a,b]:=ustaw[druzyna].kol[242+a,b];
  end;
end;
if druzyna>=1 then begin
   for a:=0 to 63 do begin
     for b:=0 to 9 do begin
       for c:=0 to 9 do begin
           if obraz^[druzyna,a,b,c] in [242..244] then
              obraz^[druzyna,a,b,c]:=obraz^[druzyna,a,b,c]+(3*(druzyna-1)-8);
{              inc(obraz^[2,a,b,c],3*(druzyna-1)-8);}
       end;
     end;
   end;
end;
for a:=1 to maxludzie do begin
    if post[1,a]=1 then begin
       if post[4,a]>=0 then post[4,a]:=(ustaw[trunc(post[10,a])+1].szyb_chod/150)
                       else post[4,a]:=-(ustaw[trunc(post[10,a])+1].szyb_chod/150);
    end;
end;
end;

{*}PROCEDURE obrazki;
var plik:file;b:byte;
begin
assign(plik,'sadist.dat');filemode:=0;
reset(plik,1);seek(plik,49); {fonty}
blockread(plik,fonty^,1770);close(plik);
{assign(plik,'sadist.dat');}
reset(plik,1);seek(plik,272286+2); {kowadlo}
blockread(plik,kowadlo_obr^,102);close(plik);
end;

{*}PROCEDURE obraz_myszy(numer:byte);
var plik:file;b:byte;
begin
filemode:=0;
assign(plik,'sadist.dat');reset(plik,1);
case numer of
0:begin
  seek(plik,1821);
  for b:=0 to 10 do blockread(plik,kursor[b],11);close(plik);
  myszka.r:=10;myszka.z:=5;
  end;
1:begin
  seek(plik,1944);
  blockread(plik,kursor,289);close(plik);
  myszka.r:=16;myszka.z:=8;
  end;
end;
end;

{*}PROCEDURE pobr(xobr,yobr,numer,ktory,co,naco:integer;odwroc,dr:byte);
var
xf,yf:byte;
linia:array[0..9] of byte;
begin
for yf:=0 to 9 do begin
   if (yobr+yf>=scr_y1) and (yobr+yf<=scr_y2) then begin
move2(scr^[yobr+yf,xobr],linia,10);
for xf:=0 to 9 do begin
    if odwroc=0 then begin
       if (obraz^[dr,numer-1,yf,xf]<>co) and (obraz^[dr,numer-1,yf,xf]<>0) then
          linia[xf]:=obraz^[dr,numer-1,yf,xf];
       if (obraz^[dr,numer-1,yf,xf]=co) and (obraz^[dr,numer-1,yf,xf]<>0) then
          linia[xf]:=naco;
    end
                else begin
       if (obraz^[dr,numer-1,yf,xf]<>co) and (obraz^[dr,numer-1,yf,xf]<>0) then
          linia[9-xf]:=obraz^[dr,numer-1,yf,xf];
       if (obraz^[dr,numer-1,yf,xf]=co) and (obraz^[dr,numer-1,yf,xf]<>0) then
          linia[9-xf]:=naco;
    end
end;
         if (xobr>=scr_x1) and (xobr<=scr_x2-10) then
            move2(linia,scr^[yobr+yf,xobr],10);
         if (xobr<scr_x1) and (scr_x1-xobr>0) and (10-(scr_x1-xobr)>0) then
            move2(linia[scr_x1-xobr],scr^[yobr+yf,scr_x1],10-(scr_x1-xobr));
         if (xobr>scr_x2-10) and (xobr<=scr_x2) then
            move2(linia,scr^[yobr+yf,xobr],scr_x2-xobr+1);
   end;
end;
end;

{*}PROCEDURE sobr(xobr,yobr,numer,ktory:integer;odwroc,dr:byte);
var xf,yf:byte;
begin
for yf:=0 to 9 do begin
for xf:=0 to 9 do begin
    if odwroc=0 then begin
       if (obraz^[dr,numer-1,yf,xf]<>0) then postm[ktory,yf+1,xf+1]:=getpix(xobr+xf,yobr+yf);
       if (postm[ktory,yf+1,xf+1]>=192) and (postm[ktory,yf+1,xf+1]<250) then postm[ktory,yf+1,xf+1]:=0;
    end
                else begin
       if (obraz^[dr,numer-1,yf,xf]<>0) then postm[ktory,yf+1,xf+1]:=getpix(xobr+9-xf,yobr+yf);
       if (postm[ktory,yf+1,xf+1]>=192) and (postm[ktory,yf+1,xf+1]<250) then postm[ktory,yf+1,xf+1]:=0;
    end;
end;end;
end;

{*}PROCEDURE zmien_mysz;
var xx,yy,xx2,yy2:byte;
begin
scr_y1:=0;
for yy:=0 to myszka.r do begin
for xx:=0 to myszka.r do begin
    if (jest_kursor) then putpix(mx+xx-myszka.z,my+yy-myszka.z,mkol[xx,yy],0);
end;end;
scr_y1:=11;
end;

{*}PROCEDURE wstep;
var bb,_port,karta:byte;plik2:file;
begin
   assign(plik,'dzwiek.cfg');
   filemode:=0;
   {$I-}
   Reset(plik);
   {$I+}
   if IOResult = 0 then begin
      read(plik,karta);
      read(plik,_port);
      read(plik,bb); DMA:=bb;
      read(plik,bb); IRQ:=bb;
      close(plik);
   end
    else begin
         writeln('Uruchom najpierw konfiguracje karty muzycznej!');
         halt;
    end;
  if karta = 1 then karta_muzyczna:=false
               else karta_muzyczna:=true;
 if karta_muzyczna then begin
     ResetDSP ($200 + _port shl 4);
  AssignBuffer;

  LoadVoice (VoiceData [0], 'sadist.dat'{blysk.wav'}   ,13468 ,3001  ,0);
  LoadVoice (VoiceData [1], 'sadist.dat'{boom2.wav'}   ,8636  ,16469 ,0);
  LoadVoice (VoiceData [2], 'sadist.dat'{jetflyby.wav'},23932 ,25105 ,0);
  LoadVoice (VoiceData [3], 'sadist.dat'{strzal.wav'}  ,2552  ,51724 ,0);
  LoadVoice (VoiceData [4], 'sadist.dat'{plum.wav'}    ,6694  ,151154,0);
  LoadVoice (VoiceData [5], 'sadist.dat'{miesko.wav'}  ,6252  ,222926,0);
  LoadVoice (VoiceData [6], 'sadist.dat'{atomowa.wav}  ,14688 ,136466,0);
  LoadVoice (VoiceData [7], 'sadist.dat'{ogien.wav}    ,7932  ,229178,0);
  LoadVoice (VoiceData [8], 'sadist.dat'{mina.wav'}    ,2027  ,49037 ,0);
  LoadVoice (VoiceData [9], 'sadist.dat'{pila2.wav'}   ,13324 ,251998,0);
  LoadVoice (VoiceData [10],'sadist.dat'{pip.wav'}     ,660   ,51064 ,0);
  LoadVoice (VoiceData [11],'sadist.dat'{pila1.wav}    ,14888 ,237110,0);
  LoadVoice (VoiceData [12],'sadist.dat'{sshot.wav}    ,4564  ,265322,0);
  LoadVoice (VoiceData [13],'sadist.dat'{kowadlo.wav}  ,2400  ,269886,0);

  case IRQ of
    2 : GetIntVec($71, OldIRQ);
   10 : GetIntVec($72, OldIRQ);
   11 : GetIntVec($73, OldIRQ);
  else
    GetIntVec (8 + IRQ, OldIRQ);
  end;
  case IRQ of
    2 : SetIntVec($71, Addr (ServiceIRQ));
   10 : SetIntVec($72, Addr (ServiceIRQ));
   11 : SetIntVec($73, Addr (ServiceIRQ));
  else
    SetIntVec (8 + IRQ, Addr (ServiceIRQ));
  end;
  case IRQ of
    2 : Port[$A1] := Port[$A1] and not 2;
   10 : Port[$A1] := Port[$A1] and not 4;
   11 : Port[$A1] := Port[$A1] and not 8;
  else
    Port[$21] := Port[$21] and not (1 shl IRQ);
  end;
  if IRQ in [2, 10, 11] then Port[$21] := Port[$21] and not 4;

  CBuffer := 3;
  StartPlayBack;
 end;
end;

{*}PROCEDURE wczytaj_obiekt(nr,odw:byte;mx,my:integer);
var
BMPFile:File;
Lines,a:Word;
count,b:byte;
rx,ry:longint;
z_przodu:byte;
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
str(nr,wyr);
Assign (BMPFile,'obiekt'+wyr+'.bmp');
filemode:=0;
Reset (BMPFile, 1);
BlockRead (BMPFile, Header, SizeOf (Header));
{seek(BMPFile,18);blockread(bmpfile,rx,4);blockread(bmpfile,ry,4);}
rx:=header.width;
ry:=header.height;
seek(BMPFile,1078);
lines := ry;odw:=random(2);z_przodu:=random(3);
while (lines >0) do begin
BlockRead (BMPFile, lin, rx);
for a:=0 to rx-1 do begin
    if odw=0 then b:=lin[a+1]
             else b:=lin[rx-a];
    if (b>0) and ((getpix(mx-trunc(rx/2)+a,(my+lines)-ry)<=15) or (z_przodu=0)) then
       putpix(mx-trunc(rx/2)+a,(my+lines)-ry,b,0);
end;
{BlockRead (BMPFile, scr^[(my+lines)-ry,mx-trunc(rx/2)], rx);}
{BlockRead (BMPFile, a, 2);}
dec (lines);
end;
close (BMPFile);

end;
(*
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
fillchar (scr^, 64000, 0);
for y:=0 to 199 do begin
    drawline(0,y,319,y,1+trunc(y div 14)+cien[y mod 14],2);
end;
scr_y1:=11;
yg:=random(50)+75;
dyg:=-2+random*4;
dlyg:=random(10);
case rodzaj_tla of
0:begin
  kolory_tla[1]:=162;
  kolory_tla[2]:=163;
  kolory_tla[3]:=164;
  kolory_tla[4]:=165;
  kolory_tla[5]:=166;
  end;
1:begin
  kolory_tla[1]:=178;
  kolory_tla[2]:=179;
  kolory_tla[3]:=180;
  kolory_tla[4]:=181;
  kolory_tla[5]:=182;
  end;
2:begin
  kolory_tla[1]:=26;
  kolory_tla[2]:=27;
  kolory_tla[3]:=28;
  kolory_tla[4]:=29;
  kolory_tla[5]:=30;
  end;
3:begin
  kolory_tla[1]:=18;
  kolory_tla[2]:=19;
  kolory_tla[3]:=20;
  kolory_tla[4]:=21;
  kolory_tla[5]:=20;
  end;
4:begin
  kolory_tla[1]:=41;
  kolory_tla[2]:=42;
  kolory_tla[3]:=43;
  kolory_tla[4]:=44;
  kolory_tla[5]:=45;
  end;
end;
if random(5)=0 then przep:=true else przep:=false;
textura:=random(7);

Assign (BMPFile,'brzeg1.bmp');
Reset (BMPFile, 1);
BlockRead (BMPFile, Header, SizeOf (Header));
rx:=header.width;
ry:=header.height;
seek(BMPFile,1078);
lines := rx;
{while (lines >0) do begin
BlockRead (BMPFile, lin, rx);
for aa:=0 to ry-1 do begin
    b:=lin[a+1];
    if (b>0) then putpix(a,(199-trunc(yg))+lines,b,0);
end;}

for a:=0 to 319 do begin
    if yg>0 then begin
    if (a>10) and (a<300) and (random(50)=0) then wczytaj_obiekt(random(7)+1,random(2),a,200-trunc(yg));
    if textura>0 then drawline(a,199,a,199-trunc(yg),kolory_tla[2],2)
    else begin
         drawline(a,199,a,199-trunc(yg/6),kolory_tla[1],2);
         drawline(a,199-trunc(yg/6),a,199-trunc(yg/4),kolory_tla[2],2);
         drawline(a,199-trunc(yg/4),a,199-trunc(yg/2.5),kolory_tla[3],2);
         drawline(a,199-trunc(yg/2.5),a,199-trunc(yg/1.5),kolory_tla[4],2);
         drawline(a,199-trunc(yg/1.5),a,199-trunc(yg),kolory_tla[5],2);
    end;
{    putpix(a,199-trunc(yg)+1,kolory_tla[3],0);
    putpix(a,199-trunc(yg),kolory_tla[1],0);}

BlockRead (BMPFile, lin, rx);
for aa:=0 to rx-1 do begin
    b:=lin[rx-aa];
    if (b>0) then putpix(a,(198-trunc(yg))+aa,b,0);
end;
dec(lines);
if lines=0 then begin
   seek(BMPFile,1078);
   lines := rx;
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


if textura>0 then begin
str(textura,wyr);
Assign (BMPFile,'textur'+wyr+'.bmp');
Reset (BMPFile, 1);
BlockRead (BMPFile, Header, SizeOf (Header));
rx:=header.width;
ry:=header.height;

mx:=0-random(40);my:=0-random(40);

while my<200 do begin
mx:=0;
while mx<320 do begin
seek(BMPFile,1078);
lines := ry;
while (lines >0) do begin
BlockRead (BMPFile, lin, rx);
for a:=0 to rx-1 do begin
    b:=lin[a+1];
    if (getpix(mx+a,(my+lines))=kolory_tla[2]) then
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



for a:=1 to maxludzie do begin
for yf:=1 to 10 do begin
for xf:=1 to 10 do begin
    postm[a,xf,yf]:=0;
end;end;
    post[1,a]:=0;
    post_zdycha[a]:=0;
end;
for a:=1 to 1000 do begin
    snieg^[a].jest:=false;
end;
end;*)

{*}PROCEDURE snieg_sypie;
var
t,pt:shortint;
rusz:boolean;
lx,ly:integer;
f1,f2,f3,f4,f5,f6,f7,f8:byte;
begin
if (snieg_mniej=0) and (snieg_wiecej=0) and (random(200)=0) then snieg_wiecej:=random(50);
if (snieg_mniej=0) and (snieg_wiecej=0) and (random(200)=1) then snieg_mniej:=random(50);

if random(3)=0 then begin
if (snieg_wiecej>0) then begin
   if mozebycsnieg<maxsnieg then inc(mozebycsnieg);
   dec(snieg_wiecej);
end;
if (snieg_mniej>0) then begin
   if mozebycsnieg>1 then dec(mozebycsnieg);
   dec(snieg_mniej);
end;
end;
if jest_sz_snieg then mozebycsnieg:=sz_snieg*5;
for a:=1 to maxsnieg do begin
    if snieg^[a].jest then begin
    if snieg^[a].kol in [208..212] then begin t:=random(3)-1;pt:=random(2);end;
    if snieg^[a].kol in [224..228] then begin
       t:=0;
       if random(7)<6 then pt:=1 else pt:=0;
    end;
       inc(pt,snieg^[a].plan);
    if (snieg^[a].plan=0) and ((getpix(snieg^[a].x+t,snieg^[a].y+pt)>15) and
       (getpix(snieg^[a].x+t,snieg^[a].y+pt)<192)) or (getpix(snieg^[a].x+t,snieg^[a].y+pt)>=250) then begin
       if snieg^[a].kol in [208..212] then begin
          rusz:=false;
          if (scr^[snieg^[a].y+1,snieg^[a].x]<=15) or
             ((getpix(snieg^[a].x,snieg^[a].y+1)>=192) and (getpix(snieg^[a].x,snieg^[a].y+1)<250)) then begin
             pt:=0;t:=1;rusz:=true;end;
          if (snieg^[a].y>=199) and (dziura_na_dole=0) then begin
             rusz:=false;snieg^[a].jest:=false;snieg^[a].y:=199;dec(ilsnieg);end;
          if (not rusz) and (snieg^[a].y>=11) then putpix(snieg^[a].x,snieg^[a].y,31-random(3),0);
       end;
       f1:=getpix(snieg^[a].x+1,snieg^[a].y);
       f2:=getpix(snieg^[a].x+1,snieg^[a].y+1);
       f3:=getpix(snieg^[a].x-1,snieg^[a].y);
       f4:=getpix(snieg^[a].x-1,snieg^[a].y+1);
       f5:=getpix(snieg^[a].x+2,snieg^[a].y);
       f6:=getpix(snieg^[a].x+2,snieg^[a].y+1);
       f7:=getpix(snieg^[a].x-2,snieg^[a].y);
       f8:=getpix(snieg^[a].x-2,snieg^[a].y+1);
       if snieg^[a].kol in [224..228] then begin
          rusz:=false;
          if ((f1<=15) or ((f1>=192) and (f1<250))) and
             ((f2<=15) or ((f2>=192) and (f2<250))) then begin
             snieg^[a].x:=snieg^[a].x+1;rusz:=true;end;
          if (not rusz) and ((f3<=15) or ((f3>=192) and (f3<250))) and
                            ((f4<=15) or ((f4>=192) and (f4<250))) then begin
             snieg^[a].x:=snieg^[a].x-1;rusz:=true;end;
          if (not rusz) and ((f5<=15) or ((f5>=192) and (f5<250))) and
                            ((f6<=15) or ((f6>=192) and (f6<250))) and
                            ((f1<=15) or ((f1>=192) and (f1<250))) then begin
             snieg^[a].x:=snieg^[a].x+1;rusz:=true;end;
          if (not rusz) and ((f7<=15) or ((f7>=192) and (f7<250))) and
                            ((f8<=15) or ((f8>=192) and (f8<250))) and
                            ((f3<=15) or ((f3>=192) and (f3<250))) then begin
             snieg^[a].x:=snieg^[a].x-1;rusz:=true;end;
          if (not rusz) and (snieg^[a].y>=11) then putpix(snieg^[a].x,snieg^[a].y,224+random(5),0);
       end;
       if not rusz then begin snieg^[a].jest:=false;dec(ilsnieg);end;
    end else begin
        snieg^[a].x:=snieg^[a].x+t;
{        if (snieg^[a].x<0) or (snieg^[a].x>319) then begin snieg^[a].jest:=false;dec(ilsnieg);end;}
        snieg^[a].y:=snieg^[a].y+pt;
        if (snieg^[a].y>=199) and (dziura_na_dole=0) then begin
           rusz:=false;
           snieg^[a].jest:=false;
           dec(ilsnieg);
           snieg^[a].y:=199;
           if snieg^[a].plan=0 then begin
              if snieg^[a].kol in [208..212] then putpix(snieg^[a].x,snieg^[a].y,31-random(3),0);
              if snieg^[a].kol in [224..228] then putpix(snieg^[a].x,snieg^[a].y,snieg^[a].kol,0);
           end;
        end;
        if (snieg^[a].y>=199) and (dziura_na_dole>0) then begin snieg^[a].jest:=false;dec(ilsnieg);end;
        if (snieg^[a].plan=0) and (snieg^[a].kol in [224..228]) and (sa_sople) then begin
       f1:=getpix(snieg^[a].x+1,snieg^[a].y);
       f2:=getpix(snieg^[a].x+1,snieg^[a].y+1);
       f3:=getpix(snieg^[a].x-1,snieg^[a].y);
       f4:=getpix(snieg^[a].x-1,snieg^[a].y+1);
       f5:=getpix(snieg^[a].x+2,snieg^[a].y);
       f6:=getpix(snieg^[a].x+2,snieg^[a].y+1);
       f7:=getpix(snieg^[a].x-2,snieg^[a].y);
       f8:=getpix(snieg^[a].x-2,snieg^[a].y+1);
           rusz:=false;
           if (((f3>15) and (f3<192)) or (f3>=250)) and (f4<=15) and (random(5)=0) then begin
              dec(snieg^[a].x);inc(snieg^[a].y);
              if random(10)=0 then begin
                 putpix(snieg^[a].x,snieg^[a].y,141-random(3),0);
                 snieg^[a].jest:=false;dec(ilsnieg);
              end;
              rusz:=true;
           end;
           if (not rusz) and ((f1>15) and ((f1<192) or (f1>=250))) and
                               (f2<=15) and (random(5)=0) then begin
              inc(snieg^[a].x);inc(snieg^[a].y);
              if random(10)=0 then begin
                 putpix(snieg^[a].x,snieg^[a].y,141-random(3),0);
                 snieg^[a].jest:=false;dec(ilsnieg);
              end;
           end;
        end;
        end;
    end else begin
             if (random(100-trunc(mozebycsnieg/10))=0) and (ilsnieg<mozebycsnieg) and (pada_snieg>0) then begin
                snieg^[a].x:=random(320);
                if (jest_2_plany) and (random(5)=0) then snieg^[a].plan:=1 else snieg^[a].plan:=0;
                snieg^[a].y:=0;
                if pada_snieg=1 then snieg^[a].kol:=224+random(5);
                if pada_snieg=2 then begin
                   if random(2)=0 then snieg^[a].kol:=224+random(5)
                                  else snieg^[a].kol:=208+random(5);
                end;
                if pada_snieg=3 then snieg^[a].kol:=208+random(5);
                snieg^[a].jest:=true;
                inc(ilsnieg);
             end;
             if (not snieg^[a].jest) and (sa_sople) and (random(4)=0) then begin
                lx:=random(320);ly:=11+random(188);
                if (getpix(lx,ly)>=139) and (getpix(lx,ly)<=141) and
                   ((getpix(lx,ly+1)<=15) or ((getpix(lx,ly+1)>=192) and (getpix(lx,ly+1)<250))) then begin
                   if random(5)=0 then putpix(lx,ly,0,0);
                   snieg^[a].x:=lx;
                   snieg^[a].y:=ly+1;
                   snieg^[a].kol:=224+random(5);
                   snieg^[a].plan:=0;
                   snieg^[a].jest:=true;
                   inc(ilsnieg);
                end;
             end;
             if (not snieg^[a].jest) then begin
                lx:=random(320);ly:=11+random(188);
                if (getpix(lx,ly)>=134) and (getpix(lx,ly)<=136) and
                   ((getpix(lx,ly-1)<=15) or ((getpix(lx,ly-1)>=192) and (getpix(lx,ly-1)<250))) then begin
                   putpix(lx,ly,0,0);
                   snieg^[a].x:=lx;
                   snieg^[a].y:=ly;
                   snieg^[a].kol:=224+random(5);
                   snieg^[a].plan:=0;
                   snieg^[a].jest:=true;
                   inc(ilsnieg);
                end;
             end;
             end;
end;
end;

{*}PROCEDURE snieg_zmaz;
var t:shortint;
begin
for a:=1 to maxsnieg do begin
    if snieg^[a].jest then begin
       if snieg^[a].plan=0 then putpix(snieg^[a].x,snieg^[a].y,0,0)
                           else putpix(snieg^[a].x,snieg^[a].y,snieg^[a].pod,0);
    end;
end;
end;

{*}PROCEDURE snieg_pok;
var t:shortint;h:byte;
begin
for a:=1 to maxsnieg do begin
    if (snieg^[a].jest) and (snieg^[a].plan=1) then snieg^[a].pod:=getpix(snieg^[a].x,snieg^[a].y);
end;
for a:=1 to maxsnieg do begin
    if snieg^[a].jest then begin
       if (random(50)=0) and (snieg^[a].plan=0) then begin
          h:=getpix(snieg^[a].x,snieg^[a].y);
          if (h>=229) and (h<=248) then bum(snieg^[a].x,snieg^[a].y,4,false,false,false,false,false,false,true);
       end;
       putpix(snieg^[a].x,snieg^[a].y,snieg^[a].kol,0);
    end;
end;
end;

{*}PROCEDURE zmaz_miny;
begin
for a:=1 to maxminy do begin
    if miny[a].jest then begin
       case miny[a].pozycja of
          0:begin
            putpix(trunc(miny[a].x)  ,trunc(miny[a].y),0,0);
            putpix(trunc(miny[a].x+1),trunc(miny[a].y),0,0);
            end;
          2:begin
            putpix(trunc(miny[a].x),trunc(miny[a].y-1),0,0);
            putpix(trunc(miny[a].x),trunc(miny[a].y),0,0);
            end;
          3:begin
            putpix(trunc(miny[a].x),trunc(miny[a].y-1),0,0);
            putpix(trunc(miny[a].x+1),trunc(miny[a].y),0,0);
            end;
          1:begin
            putpix(trunc(miny[a].x+1),trunc(miny[a].y-1),0,0);
            putpix(trunc(miny[a].x),trunc(miny[a].y),0,0);
            end;
       end;
    end;
end;
end;

{*}PROCEDURE pok_miny;
var r:byte;
begin
for a:=1 to maxminy do begin
    if miny[a].jest then begin
       if miny[a].bum=0 then begin
          case miny[a].pozycja of
             0:begin
               putpix(trunc(miny[a].x),trunc(miny[a].y),kol_min[miny[a].miga],0);
               putpix(trunc(miny[a].x+1),trunc(miny[a].y),kol_min[miny[a].miga],0);
               end;
             2:begin
               putpix(trunc(miny[a].x),trunc(miny[a].y-1),kol_min[miny[a].miga],0);
               putpix(trunc(miny[a].x),trunc(miny[a].y),kol_min[miny[a].miga],0);
               end;
             3:begin
               putpix(trunc(miny[a].x),trunc(miny[a].y-1),kol_min[miny[a].miga],0);
               putpix(trunc(miny[a].x+1),trunc(miny[a].y),kol_min[miny[a].miga],0);
               end;
             1:begin
               putpix(trunc(miny[a].x+1),trunc(miny[a].y-1),kol_min[miny[a].miga],0);
               putpix(trunc(miny[a].x),trunc(miny[a].y),kol_min[miny[a].miga],0);
               end;
          end;
       end
                        else begin
          case miny[a].pozycja of
             0:begin
               putpix(trunc(miny[a].x),trunc(miny[a].y),kol_min_bum[miny[a].miga],0);
               putpix(trunc(miny[a].x+1),trunc(miny[a].y),kol_min_bum[miny[a].miga],0);
               end;
             2:begin
               putpix(trunc(miny[a].x),trunc(miny[a].y-1),kol_min_bum[miny[a].miga],0);
               putpix(trunc(miny[a].x),trunc(miny[a].y),kol_min_bum[miny[a].miga],0);
               end;
             3:begin
               putpix(trunc(miny[a].x),trunc(miny[a].y-1),kol_min_bum[miny[a].miga],0);
               putpix(trunc(miny[a].x+1),trunc(miny[a].y),kol_min_bum[miny[a].miga],0);
               end;
             1:begin
               putpix(trunc(miny[a].x+1),trunc(miny[a].y-1),kol_min_bum[miny[a].miga],0);
               putpix(trunc(miny[a].x),trunc(miny[a].y),kol_min_bum[miny[a].miga],0);
               end;
          end;
       end;
    end;
end;
end;

{*}PROCEDURE ruch_miny;
var d,s,s2:byte;a:integer;
begin
il_min:=0;
for a:=1 to maxminy do begin
    if miny[a].jest then begin
       inc(il_min);
       if zmiana[1]=0 then inc(miny[a].miga);
       if ((miny[a].bum=0) and (miny[a].miga>20)) or
          ((miny[a].bum>0) and (miny[a].miga>15)) then miny[a].miga:=0;
       if (abs(miny[a].dy)<0.3) and (abs(miny[a].dx)<0.3) then miny[a].pozycja:=0
          else if zmiana[2]=0 then begin inc(miny[a].pozycja);if miny[a].pozycja>3 then miny[a].pozycja:=0;end;
       miny[a].x:=miny[a].x+miny[a].dx;
       miny[a].y:=miny[a].y+miny[a].dy;
       case miny[a].pozycja of
          0:begin
            s:=getpix(trunc(miny[a].x),trunc(miny[a].y));
            s2:=getpix(trunc(miny[a].x+1),trunc(miny[a].y));
            end;
          2:begin
            s:=getpix(trunc(miny[a].x),trunc(miny[a].y-1));
            s2:=getpix(trunc(miny[a].x),trunc(miny[a].y));
            end;
          3:begin
            s:=getpix(trunc(miny[a].x),trunc(miny[a].y-1));
            s2:=getpix(trunc(miny[a].x+1),trunc(miny[a].y));
            end;
          1:begin
            s:=getpix(trunc(miny[a].x),trunc(miny[a].y));
            s2:=getpix(trunc(miny[a].x+1),trunc(miny[a].y-1));
            end;
       end;
       if miny[a].y+1<0 then begin s:=0;s2:=0;end;
       if ((s <=15) or ((s >=192) and (s <250))) and
          ((s2<=15) or ((s2>=192) and (s2<250))) then
          if ((dziura_na_dole=0) and (trunc(miny[a].y)<>199)) or
             (dziura_na_dole>0) then miny[a].dy:=miny[a].dy+0.07;
       if (((s>15) and (s<192)) or (s>=250)) or
          (((s2>15) and (s2<192)) or (s2>=250)) or
          (miny[a].y>=199) and (dziura_na_dole=0) then begin
             miny[a].x:=miny[a].x-miny[a].dx;
             miny[a].y:=miny[a].y-miny[a].dy;
             if random(2)=0 then miny[a].dx:=-miny[a].dx/(1.4+(random/5))
                            else miny[a].dx:=miny[a].dx/(1.4+(random/5));
             if random(2)=0 then miny[a].dy:=-miny[a].dy/(1.4+(random/5))
                            else miny[a].dy:=miny[a].dy/(1.4+(random/5));
             if abs(miny[a].dy)>0.3 then graj_dzwiek(VoiceData [8],0.8+random/2,0);
       end;
       if miny[a].dx>0 then miny[a].dx:=miny[a].dx-0.01;
       if miny[a].dx<0 then miny[a].dx:=miny[a].dx+0.01;
       if (miny[a].dx>0) and (miny[a].dx<0.05) then miny[a].dx:=0;
       if (miny[a].dx<0) and (miny[a].dx>-0.05) then miny[a].dx:=0;
       if miny[a].dy>3 then miny[a].dy:=3;
       if miny[a].dy<-3 then miny[a].dy:=-3;
       if (miny[a].x<0) or (miny[a].x>319) then begin miny[a].jest:=false;if menu=2 then czm:=true;end;
       if (miny[a].y>=199) and (dziura_na_dole=1) then begin
          for d:=0 to 15 do
              nowysyf(miny[a].x,198,random-0.5,(-0.3-random/2)*abs(miny[a].dy/3),224,5,1);
          miny[a].jest:=false;czm:=true;
          if abs(miny[a].dy)>0.3 then graj_dzwiek(VoiceData [4],1.2+random/2,0);
          end;
       if (miny[a].y>=199) and (dziura_na_dole=3) then begin
          miny[a].jest:=false;czm:=true;
          end;
       if miny[a].bum>0 then begin
          inc(miny[a].bum);
          if miny[a].miga=0 then graj_dzwiek(voicedata[10],0.8,0);
       end;
       if (miny[a].bum>=150) or ((miny[a].y>=199) and (dziura_na_dole=2)) then begin
          bum(trunc(miny[a].x),trunc(miny[a].y),31+random(10),true,true,true,false,true,false,false);
          miny[a].jest:=false;
       end;
    end;
end;
end;

{*}PROCEDURE nowamina(x,y,dx,dy:real);
var a:byte;
begin
for a:=1 to maxminy do begin
    if not miny[a].jest then begin
       miny[a].jest:=true;
       miny[a].x:=x;
       miny[a].y:=y;
       miny[a].dx:=dx;
       miny[a].dy:=dy;
       miny[a].miga:=random(20);
       miny[a].bum:=0;
       miny[a].pozycja:=random(4);
       a:=maxminy;
    end;
end;
end;

{*}PROCEDURE o_programie;
var
juz:boolean;
gg:shortint;
kiedy_gg:word;
begin
tlo_menu;
pisz(145,33,'SADIST',79,0);
bar3(100,157,220,165,148,156,159);pisz(150,159,'WRoc',31,0);


pisz(124,108,'TEN PROGRAM TO',171,0);
pisz(130,115,'* FREEWARE *',175,0);

pisz(112,123,'COPYRIGHT 1998/1999',142,0);
pisz(104,130,'STUDIO KOMPUTEROWE GAD',143,0);

pisz(95 ,140,'E-MAIL:GADCGAD.KOTI.COM.PL',31,0);
pisz(85,147,'HTTP://GAD.KOTI.COM.PL/SADIST/',31,0);

putpix(147,141,31,0);putpix(148,142,31,0);putpix(147,142,31,0);putpix(148,144,31,0);putpix(148,143,154,0);

pobr(80 ,40 ,3 ,1,24,16 ,0,4);
pobr(85 ,80 ,5 ,1,24,79 ,1,1);
pobr(88 ,107,9 ,1,24,27 ,0,3);
pobr(82 ,136,36,1,24,167,0,1);
pobr(213,46 ,11,1,24,190,0,2);
pobr(232,62 ,31,1,24,140,0,3);
pobr(225,93 ,6 ,1,24,105,1,4);
pobr(230,120,18,1,24,127,1,2);
pobr(225,136,13,1,24,92 ,0,5);

juz:=false;
gg:=-1;kiedy_gg:=1;
repeat
klawisze;
mysz;

dec(kiedy_gg);
if kiedy_gg<=1 then begin
   inc(gg);if gg>23 then gg:=0;
   bar3(100,60,220,95,148,155,159);
   napisy_o_programie(gg,kiedy_gg);
end;

mysz2;
move (scr^, Mem [$A000:0000], 64000);
if (klik[1]) then begin
   wyb_przy_kur;
   if mysz_w(100,157,220,165) then juz:=true;
end;
if ((kl[1]) and (kl_wcisn[1]=0)) then begin juz:=true;kl_wcisn[1]:=1;end;
until ((kl[1]) and (kl_wcisn[1]=0)) or (juz);
Mabout:=false;
end;


{*}PROCEDURE nowakropla(msx,msy:integer;kolor:byte);
var a:word;
begin
for a:=1 to maxsnieg do begin
    if not snieg^[a].jest then begin
       snieg^[a].x:=msx;
       snieg^[a].y:=msy;
       snieg^[a].kol:=kolor;
       snieg^[a].jest:=true;
       snieg^[a].plan:=0;
       inc(ilsnieg);
       a:=maxsnieg;
    end;
end;
end;


{*}PROCEDURE nowysopel(msx,msy:integer;kolor:byte);
var a:word;
begin
for a:=1 to maxsople do begin
    if sop[1,a]=0 then begin
       sop[1,a]:=1;
       sop[2,a]:=msx;
       sop[3,a]:=msy;
       sop[4,a]:=kolor;
       a:=maxsople;
    end;
end;
end;

{*}PROCEDURE resetuj_gory;
begin
szczyt[0].y:=trunc(szczyt[0].y);
for a:=1 to maxszczyt-1 do begin
    szczyt[a].x:=trunc(a*(320/maxszczyt));
    szczyt[a].y:=szczyt[0].y;
end;
szczyt[maxszczyt].x:=319;szczyt[maxszczyt].y:=szczyt[0].y;
{rodzaj_tla:=0;}
end;

{*}PROCEDURE losuj_gory;
begin
szczyt[0].x:=0;
szczyt[0].y:=random(173)+1;
for a:=1 to maxszczyt-1 do begin
    szczyt[a].x:=trunc(a*(320/maxszczyt)-(160/maxszczyt-1)+random(trunc(320/maxszczyt-2)));
    szczyt[a].y:=szczyt[a-1].y-(16*(40/maxszczyt))+random(trunc(16*(80/maxszczyt)));
    if szczyt[a].y<1 then szczyt[a].y:=1;
    if szczyt[a].y>175 then szczyt[a].y:=175;
end;
szczyt[maxszczyt].x:=319;
szczyt[maxszczyt].y:=szczyt[maxszczyt-1].y-(16*(40/maxszczyt))+random(trunc(16*(80/maxszczyt)));
if szczyt[maxszczyt].y<1 then szczyt[maxszczyt].y:=1;
if szczyt[maxszczyt].y>175 then szczyt[maxszczyt].y:=175;
end;

{*}PROCEDURE syfki_zmaz;
var a,b,c:word;
begin
for a:=1 to maxsyf do begin
    if syf[a].jest=1 then begin
       putpix(round(syf[a].x),round(syf[a].y),0,0);
    end;
end;
end;

{*}PROCEDURE syfki_pok;
var a,b,c:word;
begin
for a:=1 to maxsyf do begin
    if syf[a].jest=1 then begin
       if ((syf[a].zmaz=1) and (syf[a].jest=1)) or
          (syf[a].zmaz=0) then putpix(round(syf[a].x),round(syf[a].y),round(syf[a].kol),0);
       if (syf[a].zmaz=0) and (syf[a].jest=0) then putpix(round(syf[a].x),round(syf[a].y),72+random(6),0);
    end;
end;
end;

{*}PROCEDURE syfki;
var
a,b,c:word;
nx,ny:real;
begin
for a:=1 to maxsyf do begin
    if syf[a].jest=1 then begin
       nx:=syf[a].dx;ny:=syf[a].dy;
       syf[a].x:=syf[a].x+syf[a].dx;
       syf[a].y:=syf[a].y+syf[a].dy;
       syf[a].dy:=syf[a].dy+0.03+(random/25);
       if syf[a].dx>0 then syf[a].dx:=syf[a].dx-0.002;
       if syf[a].dx<0 then syf[a].dx:=syf[a].dx+0.002;
       if ((syf[a].x<0) or (syf[a].x>319)) or ((syf[a].y>205) and (dziura_na_dole>0)) then syf[a].jest:=0;
       if syf[a].y>=0 then b:=getpix(round(syf[a].x),round(syf[a].y))
                      else b:=0;
       if (syf[a].y>=199) and (dziura_na_dole=0) then b:=16;
       if (syf[a].x<0) or (syf[a].x>319) then b:=0;
       if (syf[a].kol in [204..207]) and (b>=17) and (b<=191) then begin
          if b mod 16>0 then putpix(round(syf[a].x),round(syf[a].y),b-1,0);
       end;
       if (((b>15) and (b<192)) or ((b>=250) and (b<=251))) and (syf[a].zmaz=0) then syf[a].jest:=0;
       if (((b>15) and (b<192)) or ((b>=250) and (b<=251))) and {(syf[a].zmaz=1) and}
          (abs(syf[a].dx)<0.3) and (abs(syf[a].dy)<0.4) then syf[a].jest:=0;
       if (syf[a].kol in [213..219]) and (b in [229..248]) then begin
          if random(2)=0 then begin
             bum(round(syf[a].x),round(syf[a].y),3,false,false,false,false,true,false,false);
             syf[a].jest:=0;
          end;
       end;
       if (syf[a].kol>199) and (syf[a].kol<=207) and (b in [229..248]) then begin
             bum(round(syf[a].x),round(syf[a].y),3,false,false,false,false,false,true,false);
             syf[a].jest:=0;
       end;
       if (((b>15) and (b<192)) or ((b>=229) and (b<=251))) and (syf[a].zmaz=1) then begin
          if random(2)=0 then syf[a].dx:=-syf[a].dx/(1+random*2)
                         else syf[a].dx:=syf[a].dx/(1+random*2);
          if random(2)=0 then syf[a].dy:=-syf[a].dy/(1+random*2)
                         else syf[a].dy:=syf[a].dy/(1+random*2);
          syf[a].x:=syf[a].x-nx;
          syf[a].y:=syf[a].y-ny;
       end;
       if ((syf[a].zmaz=0) and (syf[a].jest=0)) then begin
          if (syf[a].x>=0) and (syf[a].x<=319) then putpix(round(syf[a].x),round(syf[a].y),round(syf[a].kol),0);
       end;
       if (syf[a].kol>192) and (syf[a].kol<=207) and (random(10)=0) then dec(syf[a].kol);
       if (syf[a].kol=192) then syf[a].jest:=0;
    end
     else begin
          c:=random(320);b:=random(188)+11;
          if (scr^[b,c] in [72..77]) then begin
            if (scr^[b+1,c]<16) then begin
             syf[a].jest:=1;
             syf[a].x:=c;
             syf[a].y:=b+1;
             syf[a].dx:=0;
             syf[a].dy:=0;
             syf[a].kol:=scr^[b,c];
             syf[a].zmaz:=0;
             if random(10)=0 then dec(scr^[b,c]);
            end
            else
             if random(2)=0 then begin
                if scr^[b,c]>72 then dec(scr^[b,c],1+random(2))
                                else dec(scr^[b,c],random(3)+1);
             end
                            else begin
                if (scr^[b+1,c]<128) or (scr^[b+1,c]>143) then scr^[b+1,c]:=scr^[b,c]-random(5)-1;
             end;
          end else
          if (kap_krew) and (scr^[b,c] in [16..191]) and
             ((scr^[b-1,c] in [0..15]) or
              (scr^[b+1,c] in [0..15]) or
              (scr^[b,c+1] in [0..15]) or
              (scr^[b,c-1] in [0..15])) then begin
              scr^[b,c]:=random(4)+74;
          end;
    end;
end;
end;

{*}PROCEDURE airstrike(msx,kier:integer);
var a,b:byte;
begin
graj_dzwiek(VoiceData [2],0.8+random/1.5,0);
for b:=1 to 8 do begin
for a:=1 to maxpoc do begin
    if poc[1,a]=0 then begin
       poc[1,a]:=1;
       poc[2,a]:=msx+(b*15-90)*kier;
       poc[3,a]:=-b*13;
       poc[4,a]:=1*kier;
       poc[5,a]:=1;
       poc[6,a]:=20;
       poc[7,a]:=0;
       poc_sek[a]:=0;
       poc_hom[a].jest:=false;
       a:=maxpoc;
    end;
end;
end;
end;

{*}PROCEDURE rysuj(Gx,Gy,z,kol,ekr:integer);
var
b,bb,c:integer;
begin
bb:=1;
while trunc(Gy-cos(bb/z*3)*z/3)<0 do inc(bb);
for b:=bb to z do begin
    for c:=trunc(Gx-sin(b/z*3)*z/2) to trunc(Gx+sin(b/z*3)*z/2) do begin
        putpix(c,trunc(Gy-cos(b/z*3)*z/3),kol,ekr);
    end;
end;
end;

{*}PROCEDURE wszystko_do_rysowania(ekr:byte);
var i1,i2:integer;
begin
if (guzik[2]) and (bron=3) and (my>10) then begin
   if rys_kol<=22 then begin
      case rys_grub of
        1:begin
         putpix(mx,my,0,ekr);
        end;
        2:begin
         putpix(mx,my,0,ekr);
         putpix(mx+1,my,0,ekr);
         putpix(mx,my+1,0,ekr);
         putpix(mx-1,my,0,ekr);
         putpix(mx,my-1,0,ekr);
        end;
        3..99:begin
         rysuj(mx,my,rys_grub,0,ekr);
        end;
      end;
   end;
end;
if ((guzik[1]) or (ekr=2)) and (bron=3) and (my>10) then begin
   if rys_kol<23 then begin
      case rys_grub of
        1:begin
         {a:=random(4);if rys_kol>=21 then a:=0;}
         putpix(mx,my,kolory[rys_kol],ekr);
        end;
        2:begin
         a:=random(4);if rys_kol>=21 then a:=0;
         putpix(mx,my,kolory[rys_kol]-a,ekr);
         putpix(mx+1,my,kolory[rys_kol]-a,ekr);
         putpix(mx,my+1,kolory[rys_kol]-a,ekr);
         putpix(mx-1,my,kolory[rys_kol]-a,ekr);
         putpix(mx,my-1,kolory[rys_kol]-a,ekr);
        end;
        3..30:begin
         if rys_kol<21 then begin
            a:=rys_grub;
            rysuj(mx,my,a           ,kolory[rys_kol]-3,ekr);
            if ekr<>2 then begin
               rysuj(mx,my,trunc(a*0.8),kolory[rys_kol]-2,ekr);
               rysuj(mx,my,trunc(a*0.6),kolory[rys_kol]-1,ekr);
               rysuj(mx,my,trunc(a*0.4),kolory[rys_kol],ekr);
            end;
         end
                       else begin
            a:=rys_grub;
            rysuj(mx,my,a           ,kolory[rys_kol],ekr);
         end;
        end;
      end;
   end;
   if rys_kol=23 then begin
     a:=random(5)+rys_grub;
     for a1:=0 to a do putpix(mx,my+a1,141-random(3),ekr);
   end;
end;
if ((klik[1]) or (ekr=2)) and (bron=3) and (rys_kol=24) and (my>10) then begin
   a:=190-random(8);
   for a1:=0 to rys_grub-1 do begin
       putpix(mx-3-a1*4,my-2-a1*3,a,ekr);
       putpix(mx-2-a1*4,my-2-a1*3,a,ekr);
       putpix(mx-1-a1*4,my-2-a1*3,a,ekr);
       putpix(mx  -a1*4,my-2-a1*3,a,ekr);
       putpix(mx-3-a1*4,my-1-a1*3,a,ekr);
       putpix(mx-2-a1*4,my-1-a1*3,a,ekr);
       putpix(mx-1-a1*4,my-1-a1*3,a,ekr);
       putpix(mx  -a1*4,my-1-a1*3,a,ekr);
       putpix(mx-3-a1*4,my  -a1*3,a,ekr);
       putpix(mx-2-a1*4,my  -a1*3,a,ekr);
       putpix(mx-1-a1*4,my  -a1*3,a,ekr);
       putpix(mx  -a1*4,my  -a1*3,a,ekr);
       putpix(mx-4-a1*4,my-2-a1*3,a,ekr);
   end;
end;
if ((klik[2]) or (ekr=2)) and (bron=3) and (rys_kol=24) and (my>10) then begin
   a:=190-random(8);
   for a1:=0 to rys_grub-1 do begin
       putpix(mx  +a1*4,my-2-a1*3,a,ekr);
       putpix(mx+1+a1*4,my-2-a1*3,a,ekr);
       putpix(mx+2+a1*4,my-2-a1*3,a,ekr);
       putpix(mx+3+a1*4,my-2-a1*3,a,ekr);
       putpix(mx  +a1*4,my-1-a1*3,a,ekr);
       putpix(mx+1+a1*4,my-1-a1*3,a,ekr);
       putpix(mx+2+a1*4,my-1-a1*3,a,ekr);
       putpix(mx+3+a1*4,my-1-a1*3,a,ekr);
       putpix(mx  +a1*4,my  -a1*3,a,ekr);
       putpix(mx+1+a1*4,my  -a1*3,a,ekr);
       putpix(mx+2+a1*4,my  -a1*3,a,ekr);
       putpix(mx+3+a1*4,my  -a1*3,a,ekr);
       putpix(mx+4+a1*4,my-2-a1*3,a,ekr);
   end;
end;
if ((klik[1]) or (klik[2]) or (ekr=2)) and (bron=3) and (rys_kol=27) and (my>10) then begin
   a:=185-random(4);
   if klik[2] then begin re:=1;a2:=0;end else begin re:=-1;a2:=1;end;
   for a1:=0 to rys_grub-1 do begin
       putpix(mx  +((a1+a2)*re)*4,my  ,a,ekr);
       putpix(mx  +((a1+a2)*re)*4,my+1,a-4,ekr);
       putpix(mx+1+((a1+a2)*re)*4,my  ,a,ekr);
       putpix(mx+1+((a1+a2)*re)*4,my+1,a-4,ekr);
       putpix(mx+2+((a1+a2)*re)*4,my  ,a,ekr);
       putpix(mx+2+((a1+a2)*re)*4,my+1,a-4,ekr);
       putpix(mx+3+((a1+a2)*re)*4,my  ,a,ekr);
       putpix(mx+3+((a1+a2)*re)*4,my+1,a-4,ekr);
   end;
end;
if ((klik[1]) or (klik[2]) or (ekr=2)) and (bron=3) and (rys_kol=26) and (my>10) then begin
   a:=25-random(4);
   if klik[2] then begin re:=1;a2:=0;end else begin re:=-1;a2:=1;end;
   for a1:=0 to rys_grub-1 do begin
       putpix(mx  +((a1+a2)*re)*4,my  ,a,ekr);
       putpix(mx+1+((a1+a2)*re)*4,my  ,a,ekr);
       putpix(mx+2+((a1+a2)*re)*4,my  ,a,ekr);
       putpix(mx+3+((a1+a2)*re)*4,my  ,a,ekr);
   end;
end;
if ((klik[1]) or (klik[2]) or (ekr=2)) and (bron=3) and (rys_kol=25) and (my>10) then begin
   a:=185-random(2);
   if klik[2] then begin re:=1;a2:=0;end else begin re:=-1;a2:=1;end;
   for a1:=0 to rys_grub-1 do begin
       putpix(mx  +((a1+a2)*4*re),my  ,a,ekr);
       putpix(mx  +((a1+a2)*4*re),my+1,a-4,ekr);
       putpix(mx+1+((a1+a2)*4*re),my  ,a,ekr);
       putpix(mx+1+((a1+a2)*4*re),my+1,a-4,ekr);
       putpix(mx+2+((a1+a2)*4*re),my  ,a,ekr);
       putpix(mx+2+((a1+a2)*4*re),my+1,a-4,ekr);
       putpix(mx+3+((a1+a2)*4*re),my  ,a,ekr);
       putpix(mx+3+((a1+a2)*4*re),my+1,a-4,ekr);

       putpix(mx+2+((a1+a2)*4*re),my-1,250,ekr);
       putpix(mx+2+((a1+a2)*4*re),my-2,250,ekr);
       putpix(mx+2+((a1+a2)*4*re),my-3,250,ekr);
       putpix(mx+2+((a1+a2)*4*re),my-4,250,ekr);
       putpix(mx  +((a1+a2)*4*re),my-5,251,ekr);
       putpix(mx+1+((a1+a2)*4*re),my-5,251,ekr);
       putpix(mx+2+((a1+a2)*4*re),my-5,251,ekr);
       putpix(mx+3+((a1+a2)*4*re),my-5,251,ekr);
   end;
end;
if ((klik[1]) or (klik[2]) or (ekr=2)) and (bron=3) and (rys_kol=28) and (my>10) then begin
   a:=185-random(4);
   if klik[2] then begin re:=1;a2:=0;end else begin re:=-1;a2:=1;end;
   for a1:=0 to rys_grub-1 do begin
       putpix(mx  ,my+((a1+a2)*4*re)  ,a,ekr);
       putpix(mx+1,my+((a1+a2)*4*re)  ,a-4,ekr);
       putpix(mx  ,my+((a1+a2)*4*re)+1,a,ekr);
       putpix(mx+1,my+((a1+a2)*4*re)+1,a-4,ekr);
       putpix(mx  ,my+((a1+a2)*4*re)+2,a,ekr);
       putpix(mx+1,my+((a1+a2)*4*re)+2,a-4,ekr);
       putpix(mx  ,my+((a1+a2)*4*re)+3,a,ekr);
       putpix(mx+1,my+((a1+a2)*4*re)+3,a-4,ekr);
   end;
end;
if ((klik[1]) or (klik[2]) or (ekr=2)) and (bron=3) and (rys_kol=29) and (my>10) then begin
   if klik[2] then begin re:=1;a2:=0;end else begin re:=-1;a2:=1;end;
   for a1:=0 to rys_grub-1 do begin
       putpix(mx  ,my+((a1+a2)*4*re)  ,251,ekr);
       putpix(mx+1,my+((a1+a2)*4*re)  ,251,ekr);
       putpix(mx  ,my+((a1+a2)*4*re)+1,251,ekr);
       putpix(mx+1,my+((a1+a2)*4*re)+1,251,ekr);
       putpix(mx  ,my+((a1+a2)*4*re)+2,251,ekr);
       putpix(mx+1,my+((a1+a2)*4*re)+2,251,ekr);
       putpix(mx  ,my+((a1+a2)*4*re)+3,251,ekr);
       putpix(mx+1,my+((a1+a2)*4*re)+3,251,ekr);
   end;
end;
if ((guzik[1]) or (guzik[2]) or (ekr=2)) and (bron=3) and (rys_kol=30) and (my>10) then begin
   if guzik[2] then re:=1 else re:=0;
   for i1:=my-trunc(rys_grub/2) to my+trunc((rys_grub+1)/2) do begin
       for i2:=mx-trunc(rys_grub/2) to mx+trunc((rys_grub+1)/2) do begin
      if zoom then begin
         if ekr=0 then PutPix (i2, i1, 24-re*24,0)
                  else begin
         PutPix (i2*2-pox*2,  i1*2-poy*2,  24-re*24,1);
         PutPix (i2*2-pox*2+1,i1*2-poy*2+1,24-re*24,1);
         end;
      end
         else PutPix (i2, i1, 24-re*24,ekr);
       end;
   end;
   drawline(mx-trunc(rys_grub/2),my+trunc((rys_grub+1)/2),
            mx+trunc((rys_grub+1)/2),my+trunc((rys_grub+1)/2),21-re*21,2+ekr);
   drawline(mx+trunc((rys_grub+1)/2),my-trunc(rys_grub/2),
            mx+trunc((rys_grub+1)/2),my+trunc((rys_grub+1)/2),21-re*21,2+ekr);
   drawline(mx-trunc(rys_grub/2),my-trunc(rys_grub/2),
            mx-trunc(rys_grub/2),my+trunc((rys_grub+1)/2),26-re*26,2+ekr);
   drawline(mx-trunc(rys_grub/2),my-trunc(rys_grub/2),
            mx+trunc((rys_grub+1)/2),my-trunc(rys_grub/2),26-re*26,2+ekr);
end;
end;

{*}FUNCTION ktory_wybr:byte;
var g:byte;
begin
g:=0;
for a:=1 to maxludzie do begin
    if wybrana_postac[a]=1 then begin g:=a;a:=maxludzie;end;
end;
ktory_wybr:=g;
end;

{*}PROCEDURE napisy_do_rysowania;
begin
if rob_obiekt_jest then pisz(230,2,'O',31,0)
                   else pisz(230,2,'R',31,0);
if rob_obiekt_jest then begin
   pisz(240,2,naz_obj[rob_obiekt_numr].nazwa,175,0);
end
   else begin
pisz(200,2,'**',kolory[rys_kol],0);
str(rys_grub,wyr);if length(wyr)<2 then insert('0',wyr,1);
pisz(215,2,wyr,175,0);
       case rys_kol of
         1..17:pisz(240,2,'ZIEMIA',175,0);
            18:pisz(240,2,'KREW',175,0);
            19:pisz(240,2,'METAL 1',175,0);
            20:pisz(240,2,'METAL 2',175,0);
            21:pisz(240,2,'TlO 1',175,0);
            22:pisz(240,2,'TlO 2',175,0);
            23:pisz(240,2,'SOPLE',175,0);
            24:pisz(240,2,'SCHODY',175,0);
            25:pisz(240,2,'MOST',175,0);
            26:pisz(240,2,'LINA POZIOMA',175,0);
            27:pisz(240,2,'DESKA POZIOMA',175,0);
            28:pisz(240,2,'BELKA PIONOWA',175,0);
            29:pisz(240,2,'BELKA PION.W TLE',175,0);
            30:pisz(240,2,'CEGlA',175,0);
       end;
end;
end;

{*}PROCEDURE napisy_broni;
var ax:byte;
begin
scr_y1:=0;
case bron of
     0:begin
       str(sila_broni,wyr);while length(wyr)<2 do insert('0',wyr,1);
       pisz(284,2,'SIlA:'+wyr,175,0);
       end;
     1:begin
       str(bron_odlamki,wyr);while length(wyr)<2 do insert('0',wyr,1);
       pisz(239,2,'ILOsc:'+wyr,175,0);
       str(sila_odlamki,wyr);while length(wyr)<2 do insert('0',wyr,1);
       pisz(284,2,'SIlA:'+wyr,175,0);
       end;
     2:begin
       str(kt_punkt_wyjscia,wyr);
       pisz(215,2,'DR.'+wyr,228+kt_punkt_wyjscia,0);
       if punkt_wyjscia[kt_punkt_wyjscia].gora then pisz(239,2,'BRAK',170,0)
                                else pisz(239,2,'JEST',175,0);
       case punkt_wyjscia[kt_punkt_wyjscia].kier of
           1:pisz(264,2,'L',175,0);
           2:pisz(264,2,'?',175,0);
           3:pisz(264,2,'P',175,0);
       end;
       if punkt_wyjscia[kt_punkt_wyjscia].szyb>0 then str(punkt_wyjscia[kt_punkt_wyjscia].szyb,wyr)
                                  else wyr:='?';
       pisz(274,2,wyr,175,0);
       case punkt_wyjscia[kt_punkt_wyjscia].jak of
           0:wyr:='???????';
           1..8:wyr:=co_robi_txt[punkt_wyjscia[kt_punkt_wyjscia].jak];
       end;
       pisz(284,2,wyr,175,0);
       end;
     3:napisy_do_rysowania;
   4,5,16:begin
       str(rodzaj_syfkow+1,wyr);
       pisz(275,2,'RODZAJ:'+wyr,175,0);
       end;
     8:begin
       str(dl_sopli+1,wyr);pisz(269,2,'DlUGOsc:'+wyr,175,0);
       end;
     9:begin
       str(druzyna_z_kursora+1,wyr);
       pisz(270,2,'DRUzYNA '+wyr,229+druzyna_z_kursora,0);
       pobr(255,0,1,1,24,229+druzyna_z_kursora,0,druzyna_z_kursora+1);
       end;
    11:begin
       pisz(204,2,'*ODPAL*',79,0);
       str(rodzaj_min+1,wyr);pisz(244,2,'RODZAJ:'+wyr,175,0);
       str(99-il_min,wyr);while length(wyr)<2 do insert('0',wyr,1);
       pisz(289,2,'MIN:'+wyr,175,0);
       end;
    12:begin
       str(sila_dziala,wyr);while length(wyr)<2 do insert('0',wyr,1);
       pisz(284,2,'SIlA:'+wyr,175,0);
       str(rodzaj_dziala+1,wyr);
       pisz(239,2,'RODZAJ:'+wyr,175,0);
       end;
    15:begin
       str(raca_dlug,wyr);pisz(244,2,'DlUGOsc LOTU:'+wyr,175,0);
       end;
    18:begin
       str(poc_hom_ust.sila,wyr);while length(wyr)<2 do insert('0',wyr,1);
       pisz(284,2,'SIlA:'+wyr,175,0);
       if poc_hom_ust.ustaw=1 then pisz(244,2,'*USTAW*',175,0)
                              else pisz(244,2,'*USTAW*',79,0);
       end;
end;

for ax:=0 to 9 do begin
    putpix(bronie_rev[bron]*10+ax,0,79,0);
    putpix(bronie_rev[bron]*10+ax,9,79,0);
    putpix(bronie_rev[bron]*10,ax,79,0);
    putpix(bronie_rev[bron]*10+9,ax,79,0);
end;
scr_y1:=11;
end;

{*}PROCEDURE napisy;
begin
scr_y1:=0;
str(strzelaja_do_siebie,wyr);pisz(7,2,wyr,79,0);
if not burza then siatka(21);
if pada_snieg in [0,3] then siatka(31);
if pada_snieg in [0,1] then siatka(41);
case dziura_na_dole of
     0:begin siatka(51);siatka(61);siatka(71);end;
     1:begin siatka(61);siatka(71);end;
     2:begin siatka(51);siatka(71);end;
     3:begin siatka(51);siatka(61);end;
end;
if not sa_sople then siatka(81);
if not kap_krew then siatka(91);
if not l_strzelaja then siatka(101);
if not l_bija then siatka(111);
if not smierc_wybuch then siatka(121);
if not wychodza_do_gory then siatka(131);
if not l_szaleni then siatka(141);
if not jest_dzwiek then siatka(151);
if not zoom then siatka(161);
for a:=1 to 5 do begin
    str(il_ludzi[a],wyr);while length(wyr)<2 do insert('0',wyr,1);pisz(210+a*20,0,wyr,228+a,0);
    str(max_ludzi[a],wyr);while length(wyr)<2 do insert('0',wyr,1);pisz(210+a*20,5,wyr,228+a,0);
    pobr(200+a*20,0,1,1,24,228+a,0,a);
end;
{str(il_nieb,wyr);while length(wyr)<2 do insert('0',wyr,1);pisz(298,5,wyr,241,0);
str(max_nieb,wyr);while length(wyr)<2 do insert('0',wyr,1);pisz(310,5,wyr,241,0);}
scr_y1:=11;
end;

{*}PROCEDURE napisy_o_wybranym(jak:byte);
var ax:byte;
begin
scr_y1:=0;
if ile_wybr=1 then begin
str(ktory_wybr,wyr);while length(wyr)<2 do insert('0',wyr,1);pisz(115,2,wyr,45,0);
str(trunc(post[9,ktory_wybr]),wyr);if wyr[1]='-' then wyr:='000';while length(wyr)<3 do insert('0',wyr,1);
    pisz(155,2,'SIlA:'+wyr,47,0);
pisz(130,2,'****',229+trunc(post[10,ktory_wybr]),0);
{if post[10,ktory_wybr]=0 then pisz(130,2,'****',240,0);}
{if post[10,ktory_wybr]=1 then pisz(130,2,'****',241,0);}
for ax:=0 to 9 do begin
    putpix(post_corobi[ktory_wybr]*10+ax,0,79,0);
    putpix(post_corobi[ktory_wybr]*10+ax,9,79,0);
    putpix(post_corobi[ktory_wybr]*10,ax,79,0);
    putpix(post_corobi[ktory_wybr]*10+9,ax,79,0);
end;
end;
if ile_wybr>1 then begin
str(ile_wybr,wyr);while length(wyr)<2 do insert('0',wyr,1);pisz(115,2,'ZAZNACZONYCH:'+wyr,45,0);
end;
scr_y1:=11;
end;

{*}FUNCTION ile_wybr:byte;
var g:byte;
begin
g:=0;
for a:=1 to maxludzie do begin
    if wybrana_postac[a]=1 then inc(g);
end;
ile_wybr:=g;
end;

{*}PROCEDURE zmaz_ramke;
var a:byte;
begin
if zazn_ramki then begin
   for a:=0 to gest_rmk-1 do begin
       putpix(trunc(ramka_wsp[1].x+a*((ramka_wsp[2].x-ramka_wsp[1].x)/gest_rmk)),
              ramka_wsp[1].y,ramka[1+a],0);
       putpix(ramka_wsp[2].x,
              trunc(ramka_wsp[1].y+a*((ramka_wsp[2].y-ramka_wsp[1].y)/gest_rmk)),ramka[1+gest_rmk+a],0);
       putpix(trunc(ramka_wsp[2].x-a*((ramka_wsp[2].x-ramka_wsp[1].x)/gest_rmk)),
              ramka_wsp[2].y,ramka[1+gest_rmk*2+a],0);
       putpix(ramka_wsp[1].x,
              trunc(ramka_wsp[2].y-a*((ramka_wsp[2].y-ramka_wsp[1].y)/gest_rmk)),ramka[1+gest_rmk*3+a],0);
   end;
end;
end;

{*}PROCEDURE zmaz_strz;
var a,x,y:byte;
begin
for a:=1 to maxludzie do begin
if wybrana_postac[a]=1 then begin
for y:=1 to 3 do begin
    for x:=1 to 3 do begin
        if strz[y,x]>0 then putpix(trunc(post[2,a]+3+x),trunc(post[3,a]-7+y),pod_strz[a,x,y],0);
    end;
end;
end;
end;
end;

{*}PROCEDURE postacie_zmaz;
var b:real;odw:byte;
begin
for a:=1 to maxludzie do begin
    if post[1,a]=1 then begin
       if post[4,a]>=0 then odw:=0;
       if post[4,a]<0 then odw:=1;
       if post_corobi[a] in [1,3,6,7] then begin
          b:=trunc(post[5,a])+1;
       end;
       if post_corobi[a] in [2] then begin
          b:=trunc(post[5,a])+5;
       end;
       if post_corobi[a] in [5] then begin
          b:=trunc(post[5,a])+17;
       end;
       if post_corobi[a] in [6,8] then begin
          b:=trunc(post[5,a])+53;
       end;
       if post_corobi[a] in [0] then b:=trunc(post[5,a])+13;
       if post_corobi[a] in [4] then b:=trunc(post[5,a])+33;
       if post_strzela[a].dl>0 then begin
          case post_strzela[a].jak of
              0:b:=28-trunc(post_strzela[a].dl/post_strzela[a].sz);
              1:b:=32-trunc(post_strzela[a].dl/post_strzela[a].sz);
              2:b:=52-trunc(post_strzela[a].dl/post_strzela[a].sz);
          end;
          if post_strzela[a].kier>=0 then odw:=0
                                     else odw:=1;
       end;
       if post_wychodzi[a]=1 then b:=trunc(post[5,a])+57;          {wspina sie}
       if post[8,a]=1 then b:=trunc(post[5,a])+9;
       if post[8,a]=3 then b:=trunc(post[5,a])+61;                  {macha rekami}
       if post[8,a]=2 then begin
          case post_rodzsmierc[a] of
               0:b:=trunc(post[5,a])+21;
               2:b:=trunc(post[5,a])+37;
               3:b:=trunc(post[5,a])+41;
               1:b:=trunc(post[5,a])+45;
          end;
       end;

       zobr(round(post[2,a]),round(post[3,a]),trunc(b),a,odw,trunc(post[10,a]+1));
{       if post[10,a]=0 then zobr(round(post[2,a]),round(post[3,a]),trunc(b),a,odw,1);
       if post[10,a]=1 then zobr(round(post[2,a]),round(post[3,a]),trunc(b),a,odw,2);}
    end;
end;
end;

{*}PROCEDURE postacie_pok;
var b:real;odw:byte;
begin
for a:=1 to maxludzie do begin
    if post[1,a]=1 then begin
       if post[4,a]>=0 then odw:=0;
       if post[4,a]<0 then odw:=1;
       if post_corobi[a] in [1,3,6,7] then begin
          b:=trunc(post[5,a])+1;
       end;
       if post_corobi[a] in [2] then begin
          b:=trunc(post[5,a])+5;
       end;
       if post_corobi[a] in [5] then begin
          b:=trunc(post[5,a])+17;
       end;
       if post_corobi[a] in [6,8] then begin
          b:=trunc(post[5,a])+53;
       end;
       if post_corobi[a] in [0] then b:=trunc(post[5,a])+13;
       if post_corobi[a] in [4] then b:=trunc(post[5,a])+33;
       if post_strzela[a].dl>0 then begin
          case post_strzela[a].jak of
              0:b:=28-trunc(post_strzela[a].dl/post_strzela[a].sz);
              1:b:=32-trunc(post_strzela[a].dl/post_strzela[a].sz);
              2:b:=52-trunc(post_strzela[a].dl/post_strzela[a].sz);
          end;
          if post_strzela[a].kier>=0 then odw:=0
                                     else odw:=1;
       end;
       if post_wychodzi[a]=1 then b:=trunc(post[5,a])+57;          {wspina sie}
       if post[8,a]=1 then b:=trunc(post[5,a])+9;
       if post[8,a]=3 then b:=trunc(post[5,a])+61;                  {macha rekami}
       if post[8,a]=2 then begin
          case post_rodzsmierc[a] of
               0:b:=trunc(post[5,a])+21;
               2:b:=trunc(post[5,a])+37;
               3:b:=trunc(post[5,a])+41;
               1:b:=trunc(post[5,a])+45;
          end;
       end;
       pobr(round(post[2,a]),round(post[3,a]),trunc(b),
            a,24,229+trunc(post[10,a]),odw,trunc(post[10,a]+1));
{       if post[10,a]=0 then pobr(round(post[2,a]),round(post[3,a]),trunc(b),a,24,240,odw,1);
       if post[10,a]=1 then pobr(round(post[2,a]),round(post[3,a]),trunc(b),a,24,241,odw,2);}
    end;
end;
end;

{*}PROCEDURE sople_zmaz;
var a,b,c:word;
begin
for a:=1 to maxsople do begin
    if sop[1,a]=1 then begin
       putpix(round(sop[2,a]),round(sop[3,a]),0,0);
    end;
end;
end;

{*}PROCEDURE zapis_na_koniec;
var
plik2:file;
wr:word;
b:byte;
begin
{   if (menu) or (sz_menu) then napisy(0);}
   if (ile_wybr>0) then napisy_o_wybranym(0);
{   if (my<10) and (ile_wybr=0) then sz_menu:=true else sz_menu:=false;}
   zmaz_miny;
   zmaz_kaw;
   zmaz_ramke;
   mysz;
   zmaz_strz;
   snieg_zmaz;
   syfki_zmaz;
   postacie_zmaz;
   for a:=1 to maxpoc do begin
       if poc[1,a]=1 then putpix(round(poc[2,a]),round(poc[3,a]),0,0);
   end;
   sople_zmaz;
   move (scr^, Mem [$A000:0000], 64000);

   assign(plik2,'_temp.sds');
   filemode:=1;
   rewrite(plik2);
   blockwrite(plik2,scr^,500,wr);
   close(plik2);

assign(plik,'sad_temp.tmp');
filemode:=0;
{$I-}
Reset(plik);
{$I+}
if IOResult = 0 then begin close(plik);erase(plik);end;

freemem(obraz,sizeof(obraz^));
freemem(fonty,sizeof(fonty^));
freemem(scr,sizeof(scr^));
freemem(scr2,sizeof(scr2^));
freemem(snieg,sizeof(snieg^));
freemem(menu_ikony,sizeof(menu_ikony^));
freemem(costam,sizeof(costam^));
freemem(rekordy,sizeof(rekordy^));
SetIntVec($9,Save_Int);
end;

{*}PROCEDURE winieta;
var
BMPFile:File;
Palette,pal2:Array [0..255,0..3] of Byte;
OffSet,Lines,Counter:Word;
reg:registers;
count:byte;
nic_:array[1..54] of byte;
a,b:byte;
zm:boolean;

begin
for a:=0 to 63 do begin
for b:=0 to 255 do begin
pal2[b,0]:=a;
pal2[b,1]:=trunc(a/6.3);
pal2[b,2]:=trunc(a/6.3);
end;
count:=port[$3DA];
while $8 and count<>0 do count:=port[$3DA];
while $8 and count=0 do count:=port[$3DA];
port[$3C8]:=0;
for count:=0 to 255 do begin
port[$3C9]:=pal2[count,0];
port[$3C9]:=pal2[count,1];
port[$3C9]:=pal2[count,2];
end;
end;

Assign (BMPFile,'sadist.dat');
filemode:=0;
Reset (BMPFile, 1);
{if random(2)=0 then }seek(BMPFile,54276);
{               else seek(BMPFile,119354);}
BlockRead (BMPFile, nic_, 54);
BlockRead (BMPFile, Palette, 1024);
for Counter := 0 to 255 do begin
    Palette[Counter,0] := Palette[Counter, 0] shr 2;pal2[counter,2]:=10;
    Palette[Counter,1] := Palette[Counter, 1] shr 2;pal2[counter,1]:=10;
    Palette[Counter,2] := Palette[Counter, 2] shr 2;pal2[counter,0]:=63;
end;
offset := (100 + 200 shr 1) * 320 + 160 - 320 shr 1;
lines := 0;
while (lines < 200) do begin
BlockRead (BMPFile, scr^[200-lines,0], 320);
dec (offset, 320);
inc (lines);
end;
close (BMPFile);

for a:=1 to 255 do begin
    pal2[a,0]:=63-palette[a,2];
    pal2[a,1]:=63-palette[a,1];
    pal2[a,2]:=63-palette[a,0];
end;
count:=port[$3DA];
while $8 and count<>0 do count:=port[$3DA];
while $8 and count=0 do count:=port[$3DA];
port[$3C8]:=0;
for count:=0 to 255 do begin
port[$3C9]:=pal2[count,0];
port[$3C9]:=pal2[count,1];
port[$3C9]:=pal2[count,2];
end;

case random(2) of
0:begin
  for a:=199 downto 0 do begin
      move2(scr^,mem[$A000:a*320],64000-(a*320));
      delay(1);
  end;
  end;
1:begin
  for a:=0 to 199 do begin
      for b:=199 downto a do begin
          move2(scr^[a],mem[$A000:b*320],320);
      end;
      delay(1);
  end;
  end;
end;

repeat
zm:=false;
for a:=0 to 255 do begin
    if pal2[a,0]>palette[a,2] then begin zm:=true;dec(pal2[a,0]);end;
    if pal2[a,0]<palette[a,2] then begin zm:=true;inc(pal2[a,0]);end;
    if pal2[a,1]>palette[a,1] then begin zm:=true;dec(pal2[a,1]);end;
    if pal2[a,1]<palette[a,1] then begin zm:=true;inc(pal2[a,1]);end;
    if pal2[a,2]>palette[a,0] then begin zm:=true;dec(pal2[a,2]);end;
    if pal2[a,2]<palette[a,0] then begin zm:=true;inc(pal2[a,2]);end;
end;
count:=port[$3DA];
while $8 and count<>0 do count:=port[$3DA];
while $8 and count=0 do count:=port[$3DA];
port[$3C8]:=0;
for count:=0 to 255 do begin
port[$3C9]:=pal2[count,0];
port[$3C9]:=pal2[count,1];
port[$3C9]:=pal2[count,2];
end;
until not zm;
end;

{*}PROCEDURE strzal2(msx,msy,ksx,ksy:real;sila:byte;dzw:real);
var a:byte;
begin
for a:=1 to 50 do begin
    if not poc2[a].jest then begin
       poc2[a].jest:=true;
       poc2[a].x:=msx;
       poc2[a].y:=msy;
       poc2[a].dx:=ksx;
       poc2[a].dy:=ksy;
       poc2[a].sila:=sila;
       a:=50;
    end;
end;
graj_dzwiek(VoiceData [3],dzw,0);
end;

{*}PROCEDURE pociski2;
var a,b,c,d:byte;
begin
for a:=1 to 50 do begin
    if poc2[a].jest then begin
       poc2[a].x:=poc2[a].x+poc2[a].dx;
       poc2[a].y:=poc2[a].y+poc2[a].dy;
       if (poc2[a].x<=0) or (poc2[a].x>=319) or (poc2[a].y<=0) then poc2[a].jest:=false;
       b:=getpix(trunc(poc2[a].x),trunc(poc2[a].y));
       if poc2[a].y>=199 then begin
          if dziura_na_dole=1 then begin
             for d:=0 to 5 do
                 nowysyf(poc2[a].x,198,(random/2)-0.25,-0.2-random/2,224,5,1);
             poc2[a].jest:=false;
             graj_dzwiek(VoiceData [4],1.2+random/2,0);
          end
          else
             if dziura_na_dole=3 then poc2[a].jest:=false
          else
             begin b:=21;poc2[a].y:=199;end;
       end;
       if ((b>15) and (b<192)) or ((b>=229) and (b<=248)) or ((b>=250) and (b<=251)) then begin
          if b in [240..249] then begin
             poc2[a].x:=poc2[a].x-poc2[a].dx;
             poc2[a].y:=poc2[a].y-poc2[a].dy;
             for c:=0 to 10 do
                 nowysyf(trunc(poc2[a].x+sin(((8+random(16))/5)*(6+random(trunc(poc2[a].sila/3))))),
                         trunc(poc2[a].y+cos(((8+random(16))/5)*(6+random(trunc(poc2[a].sila/3))))),
                        (random*2-1),random*4-2,72,6,0);
             if random(2)=0 then graj_dzwiek(VoiceData [14+random(3)+(10*trunc(post[10,a]))],0.8+random/3,1+trunc(post[10,a]));
          end;
          bum(trunc(poc2[a].x),trunc(poc2[a].y),trunc(poc2[a].sila),true,true,true,false,true,false,false);
          poc2[a].jest:=false;
          end;
    end;
end;
end;

{*}PROCEDURE ustaw_post(naco:byte);
begin
for a:=1 to maxludzie do begin
    if wybrana_postac[a]=1 then begin
       case naco of
            0..2,4..5,7..9:Npost_corobi[a]:=naco;
            6:begin
              if Npost_corobi[a]<>naco then
                 graj_dzwiek(VoiceData [22+(10*trunc(post[10,a]))],0.8+random/3,1+trunc(post[10,a]));
              Npost_corobi[a]:=naco;
              end;
            3:post_zawroc[a]:=1;
       end;
    end;
end;
czm:=true;
end;

{*}PROCEDURE u_ile_wybr;
begin
for a:=1 to maxludzie do begin
    wybrana_postac[a]:=0;
end;
czm:=true;
end;

{*}PROCEDURE sprawdz_zaznaczonych;
begin
zaznaczony:=0;
for a:=1 to maxludzie do begin
    if (post[1,a]=1) and
       (mx>=post[2,a]) and
       (mx<=post[2,a]+9) and
       (my>=post[3,a]) and
       (my<=post[3,a]+9) then begin zaznaczony:=a;a:=50;end;
end;
end;

{*}PROCEDURE zamknij;
begin
fadeout(63,10,10,0,1);
 if karta_muzyczna then begin
  WriteDSP ($D0);
  WriteDSP ($DA);
  FreeMem (DMABuffer, 32768);
  case IRQ of
    2 : SetIntVec($71, OldIRQ);
   10 : SetIntVec($72, OldIRQ);
   11 : SetIntVec($73, OldIRQ);
  else
    SetIntVec (8 + IRQ, OldIRQ);
  end;
  case IRQ of
    2 : Port[$A1] := Port[$A1] or 2;
   10 : Port[$A1] := Port[$A1] or 4;
   11 : Port[$A1] := Port[$A1] or 8;
  else
    Port[$21] := Port[$21] or (1 shl IRQ);
  end;
  if IRQ in [2, 10, 11] then Port[$21] := Port[$21] or 4;
 end;
asm
  mov ax, $3
  int $10
end;
setpal(0,63,10,10);
setpal(9,63,10,10);
setpal(10,63,10,10);
setpal(12,63,10,10);
setpal(14,63,10,10);
setpal(4,63,10,10);
napisy_na_koniec;
for a1:=0 to 6 do xmsfreemem(_xms[a1].h);
end;

{*}PROCEDURE sople_pok;
var a,b,c:word;
begin
for a:=1 to maxsople do begin
    if sop[1,a]=1 then begin
       putpix(round(sop[2,a]),round(sop[3,a]),round(sop[4,a]),0);
    end;
end;
end;

{*}PROCEDURE pok_strz;
var a,x,y:byte;
begin
for a:=1 to maxludzie do begin
if wybrana_postac[a]=1 then begin
for y:=1 to 3 do begin
    for x:=1 to 3 do begin
        if strz[y,x]>0 then begin
           putpix(trunc(post[2,a]+3+x),trunc(post[3,a]-7+y),strz[y,x],0);
        end;
    end;
end;
end;
end;
end;

{*}PROCEDURE ekran_ukryty(co:byte);
var plik:file;a:word;
BMPFile:File;
Palette,pal2:Array [0..255,0..3] of Byte;
Lines,Counter:Word;
count:byte;
nic_:array[1..54] of byte;
b:byte;
zm:boolean;
begin
case co of
     0:xms2mem(_xms[6].h,12800,scr^,64000); {pokaz zapamietane}
     1:mem2xms(scr^,_xms[6].h,12800,64000); {zapamietaj}
end;

if (co in [1,2]) and (jest_obrmenu) then begin
Assign (BMPFile,'sadist.dat');
filemode:=0;
Reset (BMPFile, 1);seek(BMPFile,158926);
lines := 0;
while (lines < 200) do begin
      BlockRead (BMPFile, scr^[199-lines,0], 320);
      inc (lines);
end;
close (BMPFile);
end;
end;

{*}PROCEDURE wczytaj;
var
plik2,spraw:file;
wr,licz_min:word;
DirInfo: SearchRec;
x:Integer;
b,b2,bb,il_plikow:byte;
pt,juz,anuluj:boolean;
nazwa_pliku:string[8];
begin
tlo_menu;pisz(145,33,'ODCZYT',79,0);
bar3(100,157,155,165,148,156,159);pisz(122,159,'OK',31,0);
bar3(165,157,220,165,148,156,159);pisz(178,159,'ANULUJ',31,0);
bar3(100,147,155,155,148,156,159);pisz(112,149,'WSTECZ',31,0);
bar3(165,147,220,155,148,156,159);pisz(180,149,'DALEJ',31,0);
FindFirst('TERENY\*.sds', Archive, DirInfo);
x:=0;il_plikow:=0;
while DosError = 0 do
begin
  inc(x);inc(il_plikow);
  wyr:=DirInfo.Name;
  bb:=length(wyr);for a:=bb downto bb-3 do wyr[a]:=' ';
  pliki[x]:=wyr;FindNext(DirInfo);
end;
repeat
a:=0;
for x:=1 to il_plikow-1 do begin
if pliki[x]>pliki[x+1] then begin a:=1;wyr:=pliki[x];pliki[x]:=pliki[x+1];pliki[x+1]:=wyr;end;
end;
until a=0;
x:=1;pt:=true;juz:=false;anuluj:=false;
assign(spraw,'TERENY\'+ostatni_plik+'.SDS');
filemode:=0;
{$I-}reset(spraw);{$I+}
if IOResult = 0 then begin nazwa_pliku:=ostatni_plik;close(spraw);end
                else nazwa_pliku:=pliki[1];
repeat
klawisze;
mysz;
mysz2;
move (scr^, Mem [$A000:0000], 64000);
if pt then begin
   bar3(130,46,190,128,148,156,159);
   for a:=1 to 12 do begin
       if a+x-1<=il_plikow then pisz(140,a*6+45,pliki[a+x-1],31,0);
   end;
   bar3(130,131,190,139,148,156,159);
   pisz(140,133,nazwa_pliku,47,0);
   pt:=false;
end;
if (guzik[2]) then begin
   if (mysz_w(165,147,220,155)) and (x<il_plikow-10) then begin inc(x);pt:=true;end;
   if (mysz_w(100,147,155,155)) and (x>1) then begin dec(x);pt:=true;end;
end;
if (klik[1]) then begin
   wyb_przy_kur;
   if (mysz_w(165,147,220,155)) and (x<il_plikow-10) then begin inc(x);pt:=true;end;
   if (mysz_w(100,147,155,155)) and (x>1) then begin dec(x);pt:=true;end;
   if (mysz_w(133,51,187,124)) and ((((my-51) div 6)+x)<=il_plikow) then begin
      nazwa_pliku:=pliki[((my-51) div 6)+x];
      pt:=true;
   end;
   if mysz_w(100,157,155,165) then juz:=true;
   if mysz_w(165,157,220,165) then anuluj:=true;
end;
if ((kl[1]) and (kl_wcisn[1]=0)) then begin anuluj:=true;kl_wcisn[1]:=1;end;

until (juz) or (anuluj);

if juz then begin
   ostatni_plik:=nazwa_pliku;
   for a:=1 to 10 do begin max_ludzi[a]:=0;il_ludzi[a]:=0;end;
   u_ile_wybr;
   ilsnieg:=0;
   for a:=1 to maxsnieg do snieg^[a].jest:=false;
   for a:=1 to maxsyf do syf[a].jest:=0;
   for a:=1 to maxpoc do poc[1,a]:=0;
   for a:=1 to 50 do poc2[a].jest:=false;
   for a:=1 to maxludzie do post[1,a]:=0;
   for a:=1 to maxsople do sop[1,a]:=0;
   for a:=1 to maxminy do miny[a].jest:=false;
   for a:=1 to maxkaw do kaw[a].jest:=false;
   {for a:=30 to 175 do move (scr_ukryty^[a,70], scr^[a,70], 180);}
   ekran_ukryty(0);
   assign(plik2,'TERENY\'+nazwa_pliku+'.sds');
   filemode:=0;
   reset(plik2,1);
   blockread(plik2,scr^,64000);

   if not eof(plik2) then begin blockread(plik2,b,1);if b=0 then burza:=false else burza:=true;end;
   if not eof(plik2) then begin blockread(plik2,b,1);pada_snieg:=b;end;
   if not eof(plik2) then begin blockread(plik2,b,1);dziura_na_dole:=b;end;
   if not eof(plik2) then begin blockread(plik2,b,1);niebo:=b;end;
   if not eof(plik2) then begin
      blockread(plik2,b,1);if b=0 then punkt_wyjscia[1].gora:=false else punkt_wyjscia[1].gora:=true;end;
   if not eof(plik2) then blockread(plik2,b,1);
   if not eof(plik2) then begin blockread(plik2,b2,1);punkt_wyjscia[1].x:=b*256+b2;end;
   if not eof(plik2) then begin blockread(plik2,b,1);punkt_wyjscia[1].y:=b;end;
   if not eof(plik2) then begin
      blockread(plik2,b,1);if b=0 then punkt_wyjscia[2].gora:=false else punkt_wyjscia[2].gora:=true;end;
   if not eof(plik2) then blockread(plik2,b,1);
   if not eof(plik2) then begin blockread(plik2,b2,1);punkt_wyjscia[2].x:=b*256+b2;end;
   if not eof(plik2) then begin blockread(plik2,b,1);punkt_wyjscia[2].y:=b;end;
   if not eof(plik2) then begin blockread(plik2,b,1);punkt_wyjscia[1].kier:=b;end;
   if not eof(plik2) then begin blockread(plik2,b,1);punkt_wyjscia[1].jak:=b;end;
   if not eof(plik2) then begin blockread(plik2,b,1);punkt_wyjscia[2].kier:=b;end;
   if not eof(plik2) then begin blockread(plik2,b,1);punkt_wyjscia[2].jak:=b;end;
   if not eof(plik2) then begin blockread(plik2,b,1);punkt_wyjscia[1].szyb:=b;end;
   if not eof(plik2) then begin blockread(plik2,b,1);punkt_wyjscia[1].kiedy:=b;end;
   if not eof(plik2) then begin blockread(plik2,b,1);punkt_wyjscia[2].szyb:=b;end;
   if not eof(plik2) then begin blockread(plik2,b,1);punkt_wyjscia[2].kiedy:=b;end;
   if not eof(plik2) then begin blockread(plik2,b,1);if b=0 then niebo_odwroc:=false else niebo_odwroc:=true;end;
   if not eof(plik2) then begin
      blockread(plik2,b,1);licz_min:=b;
      if licz_min>0 then begin
         for a:=1 to licz_min do begin
             if not eof(plik2) then blockread(plik2,b,1);
             if not eof(plik2) then begin blockread(plik2,b2,1);miny[a].x:=b*256+b2;end;
             if not eof(plik2) then begin
                blockread(plik2,b,1);miny[a].y:=b;
                miny[a].jest:=true;
                miny[a].dx:=0;
                miny[a].dy:=0;
                miny[a].miga:=random(20);
                miny[a].bum:=0;
                miny[a].pozycja:=random(4);
             end;
         end;
      end;
   end;
   if not eof(plik2) then blockread(plik2,punkt_wyjscia[3],30);
   close(plik2);
{   for a:=30 to 175 do move (scr^[a,70], scr_ukryty^[a,70], 180);}
   ekran_ukryty(1);
   zmien_niebo;
end;
Modczyt:=false;
end;

{*}PROCEDURE snajper(mx,my:integer);
var b:integer;
begin
for a:=maxludzie downto 1 do begin
    if post[1,a]=1 then begin
       if (mx>=post[2,a]+2) and (mx<=post[2,a]+7) and
          (my>=post[3,a]+2) and (my<=post[3,a]+7) then begin
           for b:=0 to 50 do
                 nowysyf(round(post[2,a]+sin(((8+random(16))/5)*(6+random(round(20/3))))),
                         round(post[3,a]+cos(((8+random(16))/5)*(6+random(round(20/3))))),
                        (random*2-1),random*4-2,72,6,0);
           if (post[2,a]+5>=mx) then post[7,a]:=post[7,a]+abs(30-(post[2,a]-mx))/23;
           if (post[2,a]+5<=mx) then post[7,a]:=post[7,a]-abs(30-abs(post[2,a]-mx))/23;
           if (post[3,a]+5>=my) then post[6,a]:=post[6,a]+abs(30-(post[3,a]-my))/23;
           if (post[3,a]+5<=my) then post[6,a]:=post[6,a]-abs(30-abs(post[3,a]-my))/23;

           post[9,a]:=post[9,a]-abs((50-(post[2,a]-mx))*(30-(post[3,a]-my)))/6;
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
              post_zdycha[a]:=post_zdycha[a]+trunc(abs((30-abs(post[2,a]-mx))*(30-abs(post[3,a]-my)))/7);
           end;
           graj_dzwiek(VoiceData [14+random(3)+(10*trunc(post[10,a]))],0.8+random/3,1+trunc(post[10,a]));
           a:=1;
           czm:=true;
       end;
    end;
end;
end;

{*}PROCEDURE nowy(czywidok:byte);
var
x,y:word;
xf,yf:byte;
begin
scr_y1:=0;
for a:=1 to 10 do begin max_ludzi[a]:=0;il_ludzi[a]:=0;end;
u_ile_wybr;
mozebycsnieg:=random(maxsnieg);ilsnieg:=0;
rodzaj_tla:=random(7);
if czywidok=1 then widok;
for a:=1 to maxludzie do begin
for yf:=1 to 10 do begin
for xf:=1 to 10 do begin
    postm[a,xf,yf]:=0;
end;end;
    post[1,a]:=0;
    post_zdycha[a]:=0;
end;
for a:=1 to maxsnieg do snieg^[a].jest:=false;
for a:=1 to maxsyf do syf[a].jest:=0;
for a:=1 to maxpoc do poc[1,a]:=0;
for a:=1 to 50 do poc2[a].jest:=false;
for a:=1 to maxsople do sop[1,a]:=0;
for a:=1 to maxminy do miny[a].jest:=false;
for a:=1 to maxkaw do kaw[a].jest:=false;
for a:=1 to 10 do kowadlo^[a].jest:=0;
Mnowy:=false;
scr_y1:=11;

{for a:=0 to 15 do begin
    pal_gl[a,0]:=pal_tlo[a,0];
    pal_gl[a,1]:=pal_tlo[a,1];
    pal_gl[a,2]:=pal_tlo[a,2];
end;}
cala_paleta(1,0);
klik[1]:=false;
klik[2]:=false;
guzik[1]:=false;
guzik[2]:=false;
end;

{*}PROCEDURE pierony(px,py:integer);
var
sx,sy,x,y,rozx,rozy:word;
c,d,e,ilroz,k1,k2,k3:byte;
roz:boolean;
stpal:paleta_typ;
begin
 if jestblysk then begin
  for a:=1 to 255 do begin
      stpal[a,0]:=pal_gl[a,0];
      stpal[a,1]:=pal_gl[a,1];
      stpal[a,2]:=pal_gl[a,2];
{      if a in [1..228,240..253] then begin}
         k1:=55-trunc((pal_gl[a,0]+pal_gl[a,1]+pal_gl[a,2])/4);
         k2:=63-trunc((pal_gl[a,0]+pal_gl[a,1]+pal_gl[a,2])/4);
         k3:=63-trunc((pal_gl[a,0]+pal_gl[a,1]+pal_gl[a,2])/4);
         pal_gl[a,0]:=k1;
         pal_gl[a,1]:=k2;
         pal_gl[a,2]:=k3;
{      end;}
  end;
  cala_paleta(1,0);
 end;
  graj_dzwiek(VoiceData [0],0.5+random,0);
  x:=px;
  y:=py;
  ilroz:=0;
  repeat
  roz:=false;
   repeat
   sx:=x;sy:=y;
   if (random(20)=0) and (ilroz<2) then begin rozx:=x;rozy:=y;roz:=true;inc(ilroz);end;
   inc(y,5+random(5));
   x:=x+random(11)-5;
   c:=getpix(x,y);
   if (y>=200) and (dziura_na_dole=0) then begin y:=199;c:=21;end;
      drawline(x-3,y,sx-3,sy,122,1);
      drawline(x+3,y,sx+3,sy,122,1);
      drawline(x-2,y,sx-2,sy,120,1);
      drawline(x+2,y,sx+2,sy,120,1);
      drawline(x-1,y,sx-1,sy,26,1);
      drawline(x+1,y,sx+1,sy,26,1);
      drawline(x,y,sx,sy,31,1);
   if ((c>15) and (c<192)) or ((c>=229) and (c<=248)) or ((c>=250) and (c<=251)) then begin
                 bum(x,y,40,true,true,true,false,true,false,false);
                 e:=random(20)+6;
                 for d:=1 to e do
                 nowysyf(round(x+sin(random(100))*random(20)),
                         round(y+cos(random(100))*random(20)),
                        (random*4-2),random*4-2,205,3,1);
                 y:=200;
                 end;
   until (y>=200) or (x<0) or (x>319);
  x:=rozx;y:=rozy;
  until not roz;
 if jestblysk then begin
  for a:=1 to 255 do begin
      pal_gl[a,0]:=stpal[a,0];
      pal_gl[a,1]:=stpal[a,1];
      pal_gl[a,2]:=stpal[a,2];
  end;
  cala_paleta(1,0);
 end;
 blysk_pioruna:=9;
end;

{*}PROCEDURE pieron_w_tle(ile:byte);
var
sx,sy,x,y,rozx,rozy:word;
c,d,e,ilroz,k1,k2,k3:byte;
roz:boolean;
stpal:paleta_typ;
begin
  for a:=1 to 15 do begin
      stpal[a,0]:=pal_gl[a,0];
      stpal[a,1]:=pal_gl[a,1];
      stpal[a,2]:=pal_gl[a,2];
      k1:=pal_gl[a,0]+trunc((((63-pal_gl[a,1])+(63-pal_gl[a,2]))/64)*ile);if k1>63 then k1:=63;
      k2:=pal_gl[a,1]+trunc((((63-pal_gl[a,0])+(63-pal_gl[a,2]))/64)*ile);if k2>63 then k2:=63;
      k3:=pal_gl[a,2]+trunc((((63-pal_gl[a,0])+(63-pal_gl[a,1]))/64)*ile);if k3>63 then k3:=63;
      pal_gl[a,0]:=k1;
      pal_gl[a,1]:=k2;
      pal_gl[a,2]:=k3;
  end;
port[$3C8]:=1;
for a:=1 to 15 do begin
    port[$3C9]:=pal_gl[a,0];
    port[$3C9]:=pal_gl[a,1];
    port[$3C9]:=pal_gl[a,2];
end;

  if ile=9 then graj_dzwiek(VoiceData [0],1.5+random/2,0);delay(10);
  for a:=1 to 15 do begin
      pal_gl[a,0]:=stpal[a,0];
      pal_gl[a,1]:=stpal[a,1];
      pal_gl[a,2]:=stpal[a,2];
  end;
end;

{*}PROCEDURE bomba_atomowa;
var
a,b:word;
begin
graj_dzwiek(VoiceData [6],2,0);
fadeout(63,63,63,0,3);

zmaz_strz;
postacie_zmaz;
snieg_zmaz;
sople_zmaz;
syfki_zmaz;
zmaz_kaw;
for a:=1 to maxpoc do
    if poc[1,a]=1 then begin
       putpix(round(poc[2,a]),round(poc[3,a]),0,0);
       poc[1,a]:=0;
    end;

for a:=1 to maxminy do begin
    if miny[a].jest then
          bum(trunc(miny[a].x),trunc(miny[a].y),31+random(10),true,true,true,false,false,false,false);
end;

bum(140+random(40),70+random(20),200+random(50),false,false,true,true,false,false,false);
bum(140+random(40),110+random(20),200+random(50),false,false,true,true,false,false,false);
ekrbum:=0;

for a:=1 to maxsyf do syf[a].jest:=0;

for b:=0 to 40 do begin
    for a:=1 to maxludzie do
        if post[1,a]=1 then nowysyf(post[2,a]+3+random(4),post[3,a]+3+random(4),random-0.5,-0.5-random,72,6,0);
    syfki_zmaz;
    syfki;
    syfki_pok;
end;

for a:=1 to maxludzie do if post[1,a]=1 then begin post[1,a]:=0;inc(trupy);end;

for a:=0 to 200 do begin
    syfki_zmaz;
    syfki;
    syfki_pok;
end;

syfki_zmaz;
for a:=1 to maxsyf do begin
       syf[a].x:=random(320);
       syf[a].y:=-random(300);
       syf[a].dx:=random*2-1;
       syf[a].dy:=random;
       syf[a].kol:=213+random(7);
       syf[a].jest:=1;
       syf[a].zmaz:=1;
end;

for a:=1 to maxsnieg do snieg^[a].jest:=false;
for a:=1 to 50 do poc2[a].jest:=false;
for a:=1 to maxludzie do post[1,a]:=0;
for a:=1 to maxsople do sop[1,a]:=0;
for a:=1 to maxminy do miny[a].jest:=false;
for a:=1 to maxkaw do kaw[a].jest:=false;
for a:=1 to 5 do il_ludzi[a]:=0;
for a:=1 to 10 do kowadlo^[a].jest:=0;

ilsnieg:=0;
if dziura_na_dole=1 then rysuj_wode;
if dziura_na_dole=2 then rysuj_ogien;
pokaz_ekran;
pokaz_ekran;
fadein(0,255,1,20,false);
czm:=true;
end;

{*}FUNCTION wpisz(wyr2:string;dlugosc:byte;m_x,m_y:word;spacja:boolean):string;
var
   sc,c,c1:byte;
   wyr3,wyr4:string;
   klw:char;
   a:integer;
begin
wolno_wyl_mysz:=false;
while (length(wyr2)>1) and (wyr2[length(wyr2)]=' ') do delete(wyr2,length(wyr2),1);
wyr4:=wyr2;
c:=length(wyr2);c1:=c;sc:=c;wyr3:='<inny>';
klw:=#255;
while keypressed do readkey;
repeat
mysz;
mysz2;
if (wyr3<>wyr2) or (c<>sc) then begin
   bar2(m_x-1,m_y+1,m_x+dlugosc*5,m_y+7,156);
   pisz(m_x,m_y+2,wyr2,47,0);
   drawline(m_x-1+c*5,m_y+1,m_x-1+c*5,m_y+7,111,0);
   wyr3:=wyr2;sc:=c;
end;
klw:=#255;
if keypressed then begin
   klw:=readkey;graj_dzwiek(VoiceData [3],1,0);
   if (klw<>#13) and (klw<>#8) and (klw<>#0) and (klw<>#255) and (klw<>#27) and
      (((klw<>#32) and (not spacja)) or (spacja)) and
      (c1<dlugosc) then begin
      if klw in [#97..#122] then klw:=chr(ord(klw)-32);
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
until (klw=#13) or (klw=#27);
if klw=#27 then wpisz:=wyr4
          else wpisz:=wyr2;
kl_wcisn[1]:=1;
wolno_wyl_mysz:=true;
end;

{*}PROCEDURE guziki_w_rysowaniu;
begin
IF NOT ROB_OBIEKT_JEST THEN BEGIN
if ((mx>=200) and (mx<210) and (my>=2) and (my<7) and (klik[1])) then begin
               inc(rys_kol);
               if rys_kol>30 then rys_kol:=1;
               czm:=true;
               end;
if ((mx>=200) and (mx<210) and (my>=2) and (my<7) and (klik[2])) then begin
               dec(rys_kol);
               if rys_kol<1 then rys_kol:=30;
               czm:=true;
               end;
if ((mx>=240) and (mx<315) and (my>=2) and (my<7) and (klik[1])) then begin
               if rys_kol>=18 then inc(rys_kol)
                              else rys_kol:=18;
               if rys_kol>30 then rys_kol:=1;
               czm:=true;
               end;
if ((mx>=240) and (mx<315) and (my>=2) and (my<7) and (klik[2])) then begin
               if rys_kol>=18 then dec(rys_kol)
                              else rys_kol:=30;
               if rys_kol<1 then rys_kol:=30;
               czm:=true;
               end;
if ((mx>=215) and (mx<225) and (my>=2) and (my<7) and (klik[1])) then begin
               inc(rys_grub);
               if rys_grub>30 then rys_grub:=1;
               czm:=true;
               end;
if ((mx>=215) and (mx<225) and (my>=2) and (my<7) and (klik[2])) then begin
               dec(rys_grub);
               if rys_grub<1 then rys_grub:=30;
               czm:=true;
               end;
END
   ELSE BEGIN
if ((mx>=240) and (mx<315) and (my>=2) and (my<7) and (klik[1])) then begin
               inc(rob_obiekt_numr);
               if (rob_obiekt_numr>29) then rob_obiekt_numr:=1;
               czm:=true;
               end;
if ((mx>=240) and (mx<315) and (my>=2) and (my<7) and (klik[2])) then begin
               dec(rob_obiekt_numr);
               if (rob_obiekt_numr<1) then rob_obiekt_numr:=33;
               czm:=true;
               end;

END;
if (mx>=230) and (mx<235) and (my>=2) and (my<7) and (klik[1]) then begin
               if rob_obiekt_jest then rob_obiekt_jest:=false
                                  else rob_obiekt_jest:=true;
               czm:=true;
               end;
end;

{*}PROCEDURE zaznacz_ramka;
var a:byte;x1:integer;
begin
if ramka_wsp[1].x>ramka_wsp[2].x then begin
   x1:=ramka_wsp[1].x;
   ramka_wsp[1].x:=ramka_wsp[2].x;
   ramka_wsp[2].x:=x1;
end;
if ramka_wsp[1].y>ramka_wsp[2].y then begin
   x1:=ramka_wsp[1].y;
   ramka_wsp[1].y:=ramka_wsp[2].y;
   ramka_wsp[2].y:=x1;
end;
u_ile_wybr;
for a:=1 to maxludzie do begin
    if (post[1,a]=1) and
       (post[2,a]+9>=ramka_wsp[1].x) and
       (post[3,a]+9>=ramka_wsp[1].y) and
       (post[2,a]+0<=ramka_wsp[2].x) and
       (post[3,a]+0<=ramka_wsp[2].y) then wybrana_postac[a]:=1;
end;
if ile_wybr>0 then begin menu:=0;czm:=true;end;
end;

{*}PROCEDURE spr_ramke;
var a:byte;
begin
if zazn_ramki then begin
   for a:=0 to gest_rmk-1 do begin
       ramka[1+a]:=getpix(trunc(ramka_wsp[1].x+a*((ramka_wsp[2].x-ramka_wsp[1].x)/gest_rmk)),
              ramka_wsp[1].y);
       ramka[1+gest_rmk+a]:=getpix(ramka_wsp[2].x,
              trunc(ramka_wsp[1].y+a*((ramka_wsp[2].y-ramka_wsp[1].y)/gest_rmk)));
       ramka[1+gest_rmk*2+a]:=getpix(trunc(ramka_wsp[2].x-a*((ramka_wsp[2].x-ramka_wsp[1].x)/gest_rmk)),
              ramka_wsp[2].y);
       ramka[1+gest_rmk*3+a]:=getpix(ramka_wsp[1].x,
              trunc(ramka_wsp[2].y-a*((ramka_wsp[2].y-ramka_wsp[1].y)/gest_rmk)));
   end;
end;
end;

{*}PROCEDURE spr_strz;
var a,x,y:byte;
begin
for a:=1 to maxludzie do begin
if wybrana_postac[a]=1 then begin
for y:=1 to 3 do begin
    for x:=1 to 3 do begin
        if strz[y,x]>0 then begin
           pod_strz[a,x,y]:=getpix(trunc(post[2,a]+3+x),trunc(post[3,a]-7+y));
        end;
    end;
end;
end;
end;
end;

{*}PROCEDURE guziki_strzelania;
var a,b:integer;
begin
if (klik[1]) and (my>10) then begin
   case bron of
        0:strzal(mx,my,trunc(sin(S_kier/5)*(S_sila/6)),trunc(cos(S_kier/5)*(S_sila/6)),sila_broni*6+3,0,true,true,6,0,false);
        1:strzal(mx,my,trunc(sin(S_kier/5)*(S_sila/6)),
                 trunc(cos(S_kier/5)*(S_sila/6)),10+bron_odlamki*3,1,true,true,6,0,false);
       11:begin
          if rodzaj_min=0 then
          nowamina(mx,my,trunc(sin(S_kier/5)*(S_sila/6)),trunc(cos(S_kier/5)*(S_sila/6)));
          czm:=true;
          end;
       13:begin graj_dzwiek(VoiceData [3],1,0);snajper(mx-1+random(3),my-1+random(3));end;
       14:airstrike(mx,1);
       15:begin
          strzal(mx,my,trunc(sin(S_kier/5)*(S_sila/6)),trunc(cos(S_kier/5)*(S_sila/6)),sila_broni*6+3,2,true,true,6,
                 sqr(raca_dlug+1)*3,false);
          graj_dzwiek(VoiceData [3],2,0);
          end;
       18:begin
          if poc_hom_ust.ustaw=0 then
             strzal(mx,my,trunc(sin(S_kier/5)*(S_sila/6)),trunc(cos(S_kier/5)*(S_sila/6)),
                    poc_hom_ust.sila*6+3,0,true,true,6,0,true)
             else begin
                  if zaznaczony=0 then begin
                     poc_hom_ust.ktory:=-1;
                     poc_hom_ust.x:=mx;
                     poc_hom_ust.y:=my;
                     end
                       else poc_hom_ust.ktory:=zaznaczony;
                  poc_hom_ust.ustaw:=0;
                  czm:=true;
                  end;
          end;
       19:begin
          b:=-1;
          for a:=1 to 10 do
              if kowadlo^[a].jest=0 then begin b:=a;a:=10;end;
          if b>0 then begin
             kowadlo^[b].x:=mx-8;
             kowadlo^[b].y:=my-3;
             kowadlo^[b].Sy:=my-3;
             kowadlo^[b].dy:=1;
             kowadlo^[b].jest:=1;
             kowadlo^[b].stoi:=1;
          end;
          end;
   end;
end;
if (mysz_w(170,0,179,9)) and (klik[1]) and (menu=1) then bomba_atomowa;
if (klik[2]) and (bron=14) and (my>10) then airstrike(mx,-1);

if (klik[2]) and (bron=9) and (my>10) then begin
   inc(druzyna_z_kursora);
   if druzyna_z_kursora>4 then druzyna_z_kursora:=0;
   czm:=true;
end;
if (klik[1]) and (bron=9) and (my>10) then begin
     for a:=1 to maxludzie do begin
         if post[1,a]=0 then begin
            for a1:=1 to 10 do begin
            for a2:=1 to 10 do begin
                postm[a,a2,a1]:=0;
            end;end;
            post[1,a]:=1;
            post[2,a]:=mx-4;
            post[3,a]:=my-4;
            post[4,a]:=random(2);
{4}         if post[4,a]=0 then post[4,a]:=-0.2 else post[4,a]:=0.2;
            post[5,a]:=random(4);
            post[6,a]:=2;
            post[7,a]:=0;
            post[8,a]:=1;
            post[9,a]:=200;
            post_pali[a]:=0;
            post[10,a]:=druzyna_z_kursora;
{            if post[10,a]=0 then inc(il_czerw)
                            else inc(il_nieb);}
            inc(il_ludzi[trunc(post[10,a])+1]);
            post_zdycha[a]:=0;
            post_naglowie[a]:=0;
            Npost_corobi[a]:=1;
            post_przenies[a]:=0;
            a:=maxludzie;
            czm:=true;
         end;
     end;
end;
if (bron=2) then begin
   if (guzik[1]) and (my>=11) then begin
      punkt_wyjscia[kt_punkt_wyjscia].x:=mx;punkt_wyjscia[kt_punkt_wyjscia].y:=my;
   end;
   if (klik[2]) and (my>=11) then begin
      inc(kt_punkt_wyjscia);
      if kt_punkt_wyjscia>5 then kt_punkt_wyjscia:=1;
      czm:=true;
   end;
end;
end;

end.