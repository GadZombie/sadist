{$G+}
unit asmprocs;

INTERFACE

Procedure MaskPic(X,Y,Width,Height:integer; Maskcolor:byte; Sprite,Dest:Pointer);
Procedure MaskPic2(X,Y,Width,Height:integer; Maskcolor,color:byte; Sprite,Dest:Pointer);
Procedure FillChar(Var X; Count: Word; Value:Byte);
procedure Move (var source, dest; count: word);
procedure zoom(offs:word; source,dest:pointer);

procedure synchro;



IMPLEMENTATION

Procedure MaskPic(X,Y,Width,Height:integer; Maskcolor:byte; Sprite,
Dest:Pointer);
 Begin
  If (x <= -width) or (x >= 320) or (y <= -height) or (y >= 200) then exit;
 Asm
   PUSH  DS
   LDS   SI,Sprite
   MOV   AX,WIDTH
   MOV   DX,AX
   PUSH  DX
   ADD   AX,X
   PUSH  Width
   CMP   AX,320
   JG    @RightCut
   SUB   AX,X
   JC    @LeftCut
   JMP   @CheckBottom
 @RightCut:
   SUB   AX,Width
   SUB   AX,320
   NEG   AX
   MOV   Width,AX
   JMP   @CheckBottom
 @LeftCut:
   ADD   AX,X
   MOV   Width,AX
   SUB   DX,AX
   ADD   SI,DX
   XOR   BX,BX
   MOV   X,BX
 @CheckBottom:
   MOV   AX,Height
   ADD   AX,Y
   CMP   AX,200
   JG    @BottomCut
   SUB   AX,Y
   JC    @TopCut
   POP   BX
   JMP   @Display
 @BottomCut:
   POP   BX
   SUB   AX,Height
   SUB   AX,200
   NEG   AX
   MOV   Height,AX
   JMP   @Display
 @TopCut:
  ADD   AX,Y
  POP   BX
  PUSH  AX
  MOV   AX,Y
  NEG   AX
  IMUL  BX
  ADD   SI,AX
  POP   AX
  MOV   Height,AX
  MOV   BX,0
  MOV   Y,BX
 @Display:
   MOV   AX,320
   IMUL  [Y]
   MOV   DI,AX
   ADD   DI,X
   POP   DX
   MOV   BX,Width
   MOV   CX,Height
  @HeightLoop:
   PUSH  SI
   PUSH  DI
   PUSH  CX
   MOV   CX,BX
  @WidthLoop:
   MOV   AL,Byte Ptr [DS:SI]
   CMP   AL,Maskcolor
   JZ    @Skipped
   MOV   Byte Ptr [ES:DI],AL
  @Skipped:
   INC   SI
   INC   DI
   DEC   CX
   JNZ  @WidthLoop
   POP   CX
   POP   DI
   POP   SI
   ADD   DI,320
   ADD   SI,DX
   DEC   CX
   JNZ  @HeightLoop
   POP   DS
 End;
End;

Procedure MaskPic2(X,Y,Width,Height:integer; Maskcolor,color:byte; Sprite,
Dest:Pointer);
 Begin
  If (x <= -width) or (x >= 320) or (y <= -height) or (y >= 200) then exit;
 Asm
   PUSH  DS
   LDS   SI,Sprite
   MOV   AX,WIDTH
   MOV   DX,AX
   PUSH  DX
   ADD   AX,X
   PUSH  Width
   CMP   AX,320
   JG    @RightCut
   SUB   AX,X
   JC    @LeftCut
   JMP   @CheckBottom
 @RightCut:
   SUB   AX,Width
   SUB   AX,320
   NEG   AX
   MOV   Width,AX
   JMP   @CheckBottom
 @LeftCut:
   ADD   AX,X
   MOV   Width,AX
   SUB   DX,AX
   ADD   SI,DX
   XOR   BX,BX
   MOV   X,BX
 @CheckBottom:
   MOV   AX,Height
   ADD   AX,Y
   CMP   AX,200
   JG    @BottomCut
   SUB   AX,Y
   JC    @TopCut
   POP   BX
   JMP   @Display
 @BottomCut:
   POP   BX
   SUB   AX,Height
   SUB   AX,200
   NEG   AX
   MOV   Height,AX
   JMP   @Display
 @TopCut:
  ADD   AX,Y
  POP   BX
  PUSH  AX
  MOV   AX,Y
  NEG   AX
  IMUL  BX
  ADD   SI,AX
  POP   AX
  MOV   Height,AX
  MOV   BX,0
  MOV   Y,BX
 @Display:
   MOV   AX,320
   IMUL  [Y]
   MOV   DI,AX
   ADD   DI,X
   POP   DX
   MOV   BX,Width
   MOV   CX,Height
  @HeightLoop:
   PUSH  SI
   PUSH  DI
   PUSH  CX
   MOV   CX,BX
  @WidthLoop:
   MOV   AL,Byte Ptr [DS:SI]
   CMP   AL,Maskcolor
   JZ    @Skipped
   MOV   AL,color
   MOV   Byte Ptr [ES:DI],AL
  @Skipped:
   INC   SI
   INC   DI
   DEC   CX
   JNZ  @WidthLoop
   POP   CX
   POP   DI
   POP   SI
   ADD   DI,320
   ADD   SI,DX
   DEC   CX
   JNZ  @HeightLoop
   POP   DS
 End;
End;


Procedure FillChar(Var X; Count: Word; Value:Byte); Assembler;
Asm
  les di,x
  mov cx,Count
  shr cx,1
  mov al,value
  mov ah,al
  rep StoSW
  test count,1
  jz @end
  StoSB
@end:
end;

procedure Move (var source, dest; count: word); assembler;
  asm
   push ds
   lds  si,source
   les  di,dest
   mov  cx,count
   mov  ax,cx
   cld
   shr  cx,2
   db   66h
   rep  movsw
   mov  cl,al
   and  cl,3
   rep  movsb
   pop  ds
end;

procedure synchro; assembler;
 Asm
   MOV DX,$03DA
 @@1:
   IN  al,dx
   TEST Al,8
   JE @@1
 @@2:
   IN  al,dx
   TEST Al,8
   JNZ @@2
 End;

procedure zoom(offs:word; source,dest:pointer); assembler;
 asm
   PUSH   DS
   LES    DI,Source
   LDS 		SI,Dest
   XOR    BX,BX
   ADD    DI,offs
  @Height:
   MOV 		CX,160
  @Width:
   MOV    AL,byte ptr[ES:DI]
   MOV    AH,AL
   MOV    Word Ptr[DS:SI],AX
   PUSH   SI
   ADD    SI,320
   MOV    Word Ptr[DS:SI],AX
   POP    SI
   INC    DI
   INC    SI
   INC    SI
   DEC	  CX
   JCXZ  @H
   JMP   @Width
  @H:
   ADD    SI,320
	 ADD    DI,160
   INC    BX
   CMP    BX,100
	 JNE    @Height
   POP    DS
 end;
end.