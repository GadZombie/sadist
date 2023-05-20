uses dos;

var
pliko,plikz:file;
plik_:file;
c,b,a:byte;
nazwa,wyr:string;
DirInfo: SearchRec;

begin
nazwa:='!pomoc.txt';

assign(pliko,nazwa); reset(pliko,1);
assign(plikz,'sadist.pmc'); rewrite(plikz,1);

repeat
   blockread(pliko,b,1);
   c:=255-b;
   if c<>245 then blockwrite(plikz,c,1);
until eof(pliko);

close(pliko);
close(plikz);
{assign(plik_,nazwa);erase(plik_);
assign(plik_,'nowe.txt');rename(plik_,nazwa);}

writeln('Plik "'+nazwa+'" zapisany pomyslnie!');
FindFirst('sadist.pmc', anyfile, DirInfo);
writeln('Plik zajmuje ',dirinfo.size,' b.');

end.