uses crt;

var
a,nr:byte;
kod,odkod:string[10];
plik1,plik2:file;
wr,wr2:word;
buf:array[0..63] of byte;

begin
clrscr;

assign(plik1,'teksty.txt');reset(plik1,1);
assign(plik2,'teksty.kod');rewrite(plik2,1);
while not eof(plik1) do begin
      blockread(plik1,buf,64,wr);
      for a:=0 to 63 do buf[a]:=buf[a] xor 25;
      if wr=64 then blockwrite(plik2,buf,64,wr2)
               else blockwrite(plik2,buf,wr,wr2);
end;

close(plik1);
close(plik2);

end.