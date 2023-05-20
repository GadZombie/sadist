{$F+}
Unit Timer;

INTERFACE

procedure inicjujtimer;
procedure zakoncztimer;
procedure czekaj(ile: byte);

IMPLEMENTATION

uses dos;

var
  oldtimint: pointer;
  cloktick: byte;

procedure zwieksztimer(ilerazy: byte);
var
  a: word;
begin
  a := $FFFF div ilerazy;
  port[$43] := $36;
  port[$40] := lo(a);
  port[$40] := hi(a);
end;

procedure sti;
inline($FB);

procedure cli;
inline($FA);

procedure calloldint(sub: pointer);
begin
  inline($9C / $FF / $5E / $06)
end;

procedure newtimint;
interrupt;
begin
  calloldint(oldtimint);
  cloktick := cloktick + 1
end;

procedure inicjujtimer;
begin
  zwieksztimer(3);
  getintvec($1C, oldtimint);
  setintvec($1C, addr(newtimint));
  cloktick := 0;
  sti
end;

procedure zakoncztimer;
begin
  setintvec($1C, oldtimint);
  sti;
  zwieksztimer(1)
end;

procedure czekaj(ile: byte);

begin
  repeat
  until cloktick >= ile;
  cloktick := 0
end;

end.