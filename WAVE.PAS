unit wave;
{****************************************************************************
** Demonstration of mixing multiple wave files using DMA                   **
**  by Steven H Don                                                        **
**                                                                         **
** For questions, feel free to e-mail me.                                  **
**                                                                         **
**    shd@earthling.net                                                    **
**    http://shd.home.ml.org                                               **
**                                                                         **
****************************************************************************}

interface

uses Dos, Crt,xms;

type WaveData = record
  SoundLength : Word;
{  Sample      : Pointer;}
  offset:longint;
end;
  costam2=array[0..32000] of byte;

var
  Temp      : Byte;
  CBuffer   : Word;    {Clear buffer indicator}
  DMABuffer : Pointer; {Pointer to DMA buffer}
  DMA       : Byte;    {The DMA channel}
  IRQ       : Byte;    {The IRQ level}
  OldIRQ    : Pointer; {Pointer to old interrupt routines}
  Base      : Word;    {Sound Blaster base address}
  costam:^costam2;

function ResetDSP(Test : Word) : Boolean;
procedure WriteDSP(Value : byte);
procedure StartPlayBack;
procedure ClearBuffer (Buffer : Word);
procedure MixVoice (Voice : WaveData;sz:real;gdzie:byte);
procedure LoadVoice (var Voice : WaveData; FileName : String;rozmiar:word;offset:longint;gdzie:byte);
procedure delVoice (var Voice : WaveData;ile:longint);
{procedure ConvertVoice (Voice : WaveData);}
procedure ServiceIRQ; interrupt;
procedure AssignBuffer;

implementation

{****************************************************************************
** Checks to see if a Sound Blaster exists at a given address, returns     **
** true if Sound Blaster found, false if not.                              **
****************************************************************************}
function ResetDSP(Test : Word) : Boolean;
begin
  {Reset the DSP}
  Port[Test + $6] := 1;
  Delay(10);
  Port[Test + $6] := 0;
  Delay(10);
  {Check if reset was succesfull}
  if (Port[Test + $E] and $80 = $80) and (Port[Test + $A] = $AA) then begin
    {DSP was found}
    ResetDSP := true;
    Base := Test;
  end else
    {No DSP was found}
    ResetDSP := false;
end;

{****************************************************************************
** Send a byte to the DSP (Digital Signal Processor) on the Sound Blaster  **
****************************************************************************}
procedure WriteDSP(Value : byte);
begin
  {Wait for the DSP to be ready to accept data}
  while Port[Base + $C] and $80 <> 0 do;
  {Send byte}
  Port[Base + $C] := value;
end;

{****************************************************************************
** Starts playback of the buffer. The DMA controller is programmed with    **
** a block length of 32K - the entire buffer. The DSP is instructed to     **
** play blocks of 8K and then generate an interrupt (which allows the      **
** program to clear the parts that have already been played)               **
****************************************************************************}
procedure StartPlayBack;
var
  LinearAddress : LongInt;
  Page, OffSet  : Word;

begin
  WriteDSP($D1);             {DSP-command D1h - Enable speaker, required
                             on older SB's}
  WriteDSP($40);             {DSP-command 40h - Set sample frequency}
  WriteDSP(165);             {Write time constant for 11025Hz}
  {
    The time constant is calculated as follows:
       (65536 - (256000000 div frequency)) shr 8
  }

  {Convert pointer to linear address}
  LinearAddress := Seg (DMABuffer^);
  LinearAddress := LinearAddress shl 4 + Ofs (DMABuffer^);
  Page := LinearAddress shr 16;  {Calculate page}
  OffSet := LinearAddress and $FFFF; {Calculate offset in the page}
  Port[$0A] := 4 or DMA;     {Mask DMA channel}
  Port[$0C] := 0;            {Clear byte pointer}
  Port[$0B] := $58 or DMA;   {Set mode}
  {
    The mode consists of the following:
    $58+x = binary 01 01 10 xx
                   |  |  |  |
                   |  |  |  +- DMA channel
                   |  |  +---- Read operation (the DSP reads from memory)
                   |  +------- Auto init mode
                   +---------- Block mode
  }
  Port[DMA shl 1] := Lo(OffSet);   {Write the offset to the DMA controller}
  Port[DMA shl 1] := Hi(OffSet);

  case DMA of
    0 : Port[$87] := Page;             {Write the page to the DMA controller}
    1 : Port[$83] := Page;             {Write the page to the DMA controller}
    3 : Port[$82] := Page;             {Write the page to the DMA controller}
  end;

  Port[DMA shl 1 + 1] := $FF;          {Set the block length to $7FFF = 32 Kbyte}
  Port[DMA shl 1 + 1] := $7F;

  Port[$0A] := DMA;          {Unmask DMA channel}

  WriteDSP($48);             {DSP-command 48h - Set block length}
  WriteDSP($FF);             {Set the block length to $1FFF = 8 Kbyte}
  WriteDSP($1F);
  WriteDSP($1C);             {DSP-command 1Ch - Start auto-init playback}
end;

{****************************************************************************
** Clears an 8K part of the DMA buffer                                     **
****************************************************************************}
procedure ClearBuffer (Buffer : Word);
begin
  {Fill an 8K block in the DMA buffer with 128's - silence}
  FillChar (Mem [Seg(DMABuffer^):Ofs(DMABuffer^) + Buffer shl 13], 8192, 128);
end;

{****************************************************************************
** Mixes a sample with the contents of the DMA buffer                      **
****************************************************************************}
procedure MixVoice (Voice : WaveData;sz:real;gdzie:byte);
var
  Counter, OffSet, DMAPointer : Word;

begin
  {Read DMA pointer from DMA controller}
  DMAPointer := Port [1 + DMA shl 1];
  DMAPointer := DMAPointer + Port [1 + DMA shl 1] shl 8;
  {
    DMAPointer contains amount that remains to be played.
    This is convert to the offset of the current sample
  }
  DMAPointer := $7FFF - DMAPointer;

  OffSet := DMAPointer;

  xms2mem(_xms[gdzie].h,voice.offset,costam^,voice.soundlength);

  for Counter := 0 to trunc(Voice.SoundLength*sz) do begin
    {Mix byte}
    inc (Mem [Seg(DMABuffer^):Ofs(DMABuffer^)+OffSet],
         costam^[trunc(Counter/sz)]);

{   inc (Mem [Seg(DMABuffer^):Ofs(DMABuffer^)+OffSet],
         Mem [Seg(Voice.Sample^):Ofs(Voice.Sample^)+trunc(Counter/sz)]);}

    inc(OffSet);                {Move on to next byte}
    OffSet := OffSet and $7FFF; {Keep it in the 32K range}
  end;
end;

{****************************************************************************
** Loads a wave file into memory. This procedure treats any file as a      **
** standard 11025Hz, 8bit, mono .WAV file. It doesn't perform any error    **
** checking.                                                               **
****************************************************************************}
procedure LoadVoice (var Voice : WaveData; FileName : String;rozmiar:word;offset:longint;gdzie:byte);
var
  WAVFile : File;
  a:word;
  er:byte;

begin
  Assign (WAVFile, FileName); {Open the file}
  filemode:=0;
  Reset (WAVFile, 1);

  {Return length of file for sound length minus 48 bytes for .WAV header}
  Voice.SoundLength := rozmiar - 48;

{  GetMem (Voice.Sample, Voice.SoundLength); {Assign memory}
  Seek (WAVFile, offset+46);                       {Skip the header}

  fillchar(costam^,sizeof(costam^),0);

  {Load the sample data}
  BlockRead (WAVFile, costam^, Voice.SoundLength + 2);

  for a := 0 to Voice.SoundLength do costam^[a]:=costam^[a] shr 2 - 32;

{    Mem [Seg(Voice.Sample^):Ofs(Voice.Sample^)+OffSet] := (
    Mem [Seg(Voice.Sample^):Ofs(Voice.Sample^)+OffSet] shr 2) - 32;}


  er:=mem2xms(costam^,_xms[gdzie].h,_xms[gdzie].os,Voice.SoundLength);
  if er<>0 then begin
     textmode(3);
     write(er);
     halt;
  end;

  Voice.offset:=_xms[gdzie].os;
  inc(_xms[gdzie].os,Voice.SoundLength);

  Close (WAVFile); {Close the file}
end;


procedure delVoice;
begin
{  freemem(Voice.Sample,ile);}
end;

{****************************************************************************
** Converts a wave file so it can be mixed easily                          **
****************************************************************************}
procedure ConvertVoice (Voice : WaveData);
var
  OffSet : Word;

begin
  {for each sample, decrease sample value to avoid overflow}
{  for OffSet := 0 to Voice.SoundLength do
    Mem [Seg(Voice.Sample^):Ofs(Voice.Sample^)+OffSet] := (
    Mem [Seg(Voice.Sample^):Ofs(Voice.Sample^)+OffSet] shr 2) - 32;}
end;

{****************************************************************************
** IRQ service routine - this is called when the DSP has finished playing  **
** a block                                                                 **
****************************************************************************}
procedure ServiceIRQ;
var
  Temp : Byte;

begin
  {Relieve DSP}
  Temp := Port[$22E];
  {Acknowledge hardware interrupt}
  Port [$20] := $20;
  {Acknowledge cascade interrupt for IRQ 2 and 10}
  if IRQ in [2, 10] then Port [$A0] := $20;
  {Increase pointer to clear buffer and keep it in the range 0..3}
  CBuffer := (CBuffer + 1) and 3;
  {Clear buffer}
  ClearBuffer (CBuffer);
end;

{****************************************************************************
** This procedure allocates 32K of memory to the DMA buffer and makes sure **
** that no page boundary is crossed                                        **
****************************************************************************}
procedure AssignBuffer;
var
  TempBuf       : Pointer; {Temporary pointer}
  LinearAddress : LongInt;
  Page1, Page2  : Word;

begin
  {Assign 32K of memory}
  GetMem (TempBuf, 32768);

  {Calculate linear address}
  LinearAddress := Seg (TempBuf^);
  LinearAddress := LinearAddress shl 4 + Ofs (TempBuf^);
  {Calculate page at start of buffer}
  Page1 := LinearAddress shr 16;
  {Calculate page at end of buffer}
  Page2 := (LinearAddress + 32767) shr 16;

  {Check to see if a page boundary is crossed}
  if (Page1 <> Page2) then begin
    {If so, assign another part of memory to the buffer}
    GetMem (DMABuffer, 32768);
    FreeMem (TempBuf, 32768);
  end else begin
    {otherwise, use the part we've already allocated}
    DMABuffer := TempBuf;
  end;

  FillChar (DMABuffer^, $8000, 128); {Clear DMA buffer}
end;

end.
