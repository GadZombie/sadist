uses crt;

var
ustaw:record
      naglowek:string[14];
      nazwa_post:string[20];
      szyb_chod,
      s_bicia,
      s_poc,
      bije,
      strzela:byte;
      kol:array[242..244,0..2] of byte;
      waga:byte;
      end;
nazwa,nazwa_bez_roz:string;
plik,plik1:file;
obraz:array[0..63,0..9,0..9] of byte;
dzwieki:record
        nazwa:array[0..7] of string[12];
        rozmiar:array[0..7] of word;
        end;
a,nr,a1:integer;
b:byte;
buf:array[0..1023] of byte;
wr1,wr2:word;

begin
writeln;
writeln('Program do wyciagania poszczegolnych plikow z zestawow postaci do SADIST');
if paramcount=0 then begin
   writeln('Musisz podac nazwe pliku z zestawem postaci!! Np: DEPOST LUDZIE.SDP');
   halt;
end;

nazwa:=paramstr(1);

nazwa_bez_roz:=nazwa;
if pos('.',nazwa)=0 then begin
   writeln('Musisz podac nazwe pliku z rozszerzeniem! Np: DEPOST LUDZIE.SDP');
   halt;
end
   else
   while (pos('.',nazwa_bez_roz)>0) and (length(nazwa_bez_roz)>1) do begin
      delete(nazwa_bez_roz,length(nazwa_bez_roz),1);
   end;

{$I-}
assign(plik,nazwa);
filemode:=0;
reset(plik,1);
blockread(plik,ustaw,sizeof(ustaw));
blockread(plik,obraz,6400);
if not eof(plik) then blockread(plik,dzwieki,sizeof(dzwieki));
close(plik);
{$I+}
if IOResult=0 then writeln('Plik odczytany poprawnie')
              else begin writeln('Plik jest zly lub nie moze byc odczytany!');halt;end;
if ustaw.naglowek<>'SADIST-postaci' then begin
   writeln('To nie jest zestaw postaci!');halt;
end
   else writeln('Plik jest zestawem postaci');

{zapis obrazkow}
 write('Zapisuje plik z obrazkami: '+nazwa_bez_roz+'.OBR');
 {$I-}
 assign(plik,nazwa_bez_roz+'.OBR');
 filemode:=1;
 rewrite(plik,1);
 b:=10;
 blockwrite(plik,b,1);
 blockwrite(plik,b,1);
 blockwrite(plik,obraz,6400);
 close(plik);
 {$I+}
 if IOResult=0 then writeln('   - zapisane poprawnie')
               else writeln('   - blad przy zapisie !');
{zapis obrazkow}
{zapis wavow}
 {$I-}
 assign(plik,nazwa);
 filemode:=0;
 reset(plik,1);
 for nr:=0 to 7 do begin
 write('Zapisuje dzwiek ',1+nr,' - '+dzwieki.nazwa[nr]);

 assign(plik1,dzwieki.nazwa[nr]);
 filemode:=2;
 rewrite(plik1,1);

 wr1:=6571;
 if nr>0 then
    for a1:=0 to nr-1 do inc(wr1,dzwieki.rozmiar[a1]);
 seek(plik,wr1);

 a:=0;
 while (a<=dzwieki.rozmiar[nr]) and (not eof(plik)) do begin
     blockread(plik,buf,1024,wr1);
     if wr1=1024 then begin
        if dzwieki.rozmiar[nr]-a<1024 then
           blockwrite(plik1,buf,dzwieki.rozmiar[nr]-a,wr2)
           else blockwrite(plik1,buf,1024,wr2);
     end
                 else blockwrite(plik1,buf,wr1,wr2);
     inc(a,wr1);
 end;

 close(plik1);
 if IOResult=0 then writeln('   - zapisane poprawnie')
               else writeln('   - blad przy zapisie !');

 end;
 close(plik);
 {$I+}
{zapis wavow}

writeln('Gotowe!');
writeln;
writeln('(c) by S.K.GAD 14.07.1999.');

end.