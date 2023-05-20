uses crt;

const
rek_naglow:string[17]='SADIST rekordy±²1';
var
plik:file;
a,b:byte;
wcz_rek_naglow:string[17];
rekordy:array[1..10] of record
        imie:string[10];
        data:string[10];
        czas:string[8];
        trup:longint;
        end;
wyr:string;

begin
clrscr;
assign(plik,'sadist.hsc');
filemode:=0;
{$I-}
reset(plik,1);
{if IOResult = 0 then begin
   blockread(plik,rekordy,sizeof(rekordy));
   close(plik);
end else begin}
if IOResult = 0 then begin
   blockread(plik,wcz_rek_naglow,sizeof(wcz_rek_naglow));
   if wcz_rek_naglow<>rek_naglow then begin
      {tak bylo przedtem}
      seek(plik,0);
      blockread(plik,rekordy,sizeof(rekordy));
   end else begin
      {a tak jest teraz}
      for a:=10 downto 1 do begin
          blockread(plik,wyr,11); rekordy[a].data:='';
          for b:=1 to 10 do rekordy[a].data:=rekordy[a].data+chr(ord(wyr[b]) xor 214);
          blockread(plik,wyr,11); rekordy[a].imie:='';
          for b:=1 to 10 do
              insert(chr(ord(wyr[b]) xor 205),rekordy[a].imie,0);
      end;
      for a:=10 downto 1 do
          blockread(plik,rekordy[a].trup,sizeof(rekordy[a].trup));
      for a:=1 to 10 do begin
          blockread(plik,wyr,9); rekordy[a].czas:='';
          for b:=1 to 8 do rekordy[a].czas:=rekordy[a].czas+chr(ord(wyr[b]) xor 139);
      end;
   end;
   close(plik);
end else begin
    writeln('Brak pliku!');
    halt(0);
end;
{$I+}

writeln('³imie       ³trupow  ³czas     ³w dniu');
for a:=1 to 10 do begin
   gotoxy(1,2+a);write('³',rekordy[a].imie);
   str(rekordy[a].trup,wyr);while length(wyr)<7 do insert('0',wyr,1);
   gotoxy(13,2+a);write('³',wyr);
   gotoxy(22,2+a);write('³',rekordy[a].czas);
   gotoxy(32,2+a);writeln('³',rekordy[a].data);
end;

end.