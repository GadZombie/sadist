{$F+}
Unit Timer;

INTERFACE
 procedure inicjujtimer;
 procedure zakoncztimer;
 procedure czekaj(ile: byte);

IMPLEMENTATION
uses dos;
var oldtimint : pointer;
    cloktick: byte;

procedure zwieksztimer(ilerazy: byte);
var a: word;
begin
  a := $ffff div ilerazy;
  port[$43] := $36;
  port[$40] := lo(a);
  port[$40] := hi(a);
end;

procedure sti;
inline($fb);

procedure cli;
inline($fa);

procedure calloldint(sub: pointer);
begin
  inline($9c/
         $ff/$5e/$06)
end;

procedure newtimint; interrupt;
begin
  calloldint(oldtimint);
  cloktick := cloktick + 1
end;

procedure inicjujtimer;
begin
  zwieksztimer(3);
  getintvec($1c, oldtimint);
  setintvec($1c, addr(newtimint));
  cloktick := 0;
  sti
end;

procedure zakoncztimer;
begin
  setintvec($1c, oldtimint);
  sti;
  zwieksztimer(1)
end;

procedure czekaj(ile: byte);

begin
  repeat until cloktick >= ile;
  cloktick := 0
end;

end.