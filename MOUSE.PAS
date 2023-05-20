 Unit Mouse;

  Interface

   Procedure SetMouse(var M1,M2,M3,M4 : integer);

   Procedure ResetMouse;

   Procedure MouseShow;

   Procedure SetMickeys(DeltaX,DeltaY : integer);

   Procedure SetSpeedThreshold(Mickeys : integer);

   Procedure GetMousePosition(var Button,Horizontal,Vertical : integer);

   Procedure SetMousePosition(Horizontal,Vertical : integer);

   Procedure GetButtonPressed(Button: integer;var Stats,Count,X,Y : integer);

   Procedure GetButtonReleased(Button : integer;var Stats,Count,X,Y : integer);

   Procedure SetMouseHorizontalLimit(Min,Max : integer);

   Procedure SetMouseVerticalLimit(Min,Max : integer);

   Procedure MouseWindow(X1,Y1,X2,Y2 : integer);

   Procedure HideCursor;

   Procedure ShowCursor;

   Procedure MoveCursor;

   Function MousePresent:boolean;

  Implementation

  Var
     OldX,OldY,X,Y       ,
     M1,M2,M3,M4,Button  ,
     InfX,InfY,SupX,SupY : integer;
     SCurs               : array[0..109] of byte;
     Show,StartMouse     : boolean;
     DeltaX,DeltaY       : integer;
  Const
       Curs  :  array[0..109] of byte =
       (
          8,  0, 12,  0,
        127,128,127,128,127,128,127,128,
         63,128, 63,128, 63,128, 63,128,
         95,128, 95,128, 95,128, 95,128,
        111,128,111,128,111,128,111,128,
         87,128, 87,128, 87,128, 87,128,
         75,128, 75,128, 75,128, 75,128,
         69,128, 69,128, 69,128, 69,128,
         66,128, 66,128, 66,128, 66,128,
         71,128, 71,128, 71,128, 71,128,
         87,128, 87,128, 87,128, 87,128,
        115,128,115,128,115,128,115,128,
        251,128,251,128,251,128,251,128,
        249,128,249,128,249,128,249,128,
          0,  0
       );

 function MousePresent:boolean;
  const
       IRET = $CF;
  var
     mousevector  : ^byte absolute $0000:$00CC;
     present      : boolean;
  begin
   (* First, we have to check and see if the Microsoft driver is present. *)
   (* The  only  way  to  do it is to check if the interrupt vector table *)
   (* entry 33H is zero (DOS v2.x) or points to an IRET instruction  (DOS *)
   (* v3.x).  Ideally this should be done using a  DOS  call,  but  since *)
   (* Pascal  lacks  easy  methods  of setting up module dependencies, we *)
   (* will 'break the rules' this time.                                   *)

   if (mousevector = Ptr($0000,$0000)) or (mousevector^ = IRET) then
      present := false
   else  (* mouse driver is present *)
      begin
         asm
          xor ax,ax
          int $33
          or ax,ax
          jnz @@present
           xor bx,bx
           jmp @@set_present
          @@present:
           mov bl,1
          @@set_present:
           mov present,bl
         end;
      end;
    MousePresent:=present;
  end;

  Procedure SetMouse;
   Begin
        asm
           les di,M1
           mov ax,es:[di]
           les di,M2
           mov bx,es:[di]
           les di,M3
           mov cx,es:[di]
           les di,M4
           mov dx,es:[di]
           int $33
           les di,M1
           mov es:[di],ax
           les di,M2
           mov es:[di],bx
           les di,M3
           mov es:[di],cx
           les di,M4
           mov es:[di],dx
         End;
   End;

  Procedure ResetMouse;
   Begin
        Show:=false;
        StartMouse:=true;
        InfX:=0;
        SupX:=639;
        InfY:=0;
        SupY:=479;
        M1:=2; { HideMouseCursor }
        M2:=0;
        M3:=0;
        M4:=0;
        SetMouse(M1,M2,M3,M4);
   End;

  Procedure SetMickeys;
   Begin
        M1:=$0F;
        M3:=DeltaX;
        M4:=DeltaY;
        SetMouse(M1,M2,M3,M4);
   End;

  Procedure SetSpeedThreshold;
   Begin
        M1:=$13;
        M4:=Mickeys;
        SetMouse(M1,M2,M3,M4);
   End;

  Procedure GetMousePosition;
   Begin
        M1:=3;
        SetMouse(M1,Button,Horizontal,Vertical);
   End;

  Procedure SetMousePosition;
   Begin
        X:=Horizontal;
        Y:=Vertical;
        If StartMouse then
         Begin
              StartMouse:=false;
              OldX:=X;
              OldY:=Y;
         End;
        M1:=4;
        M2:=0;
        SetMouse(M1,M2,Horizontal,Vertical);
   End;

  Procedure GetButtonPressed;
   Begin
        M1:=$05;
        M2:=Button;
        SetMouse(M1,M2,M3,M4);
        Stats:=M1;
        Count:=M2;
        X:=M3;
        Y:=M4;
   End;

  Procedure GetButtonReleased;
   Begin
        M1:=$06;
        M2:=Button;
        SetMouse(M1,M2,M3,M4);
        Stats:=M1;
        Count:=M2;
        X:=M3;
        Y:=M4;
   End;

  Procedure SetMouseHorizontalLimit;
   Begin
        M1:=7;
        M2:=0;
        SetMouse(M1,M2,Min,Max);
   End;

  Procedure SetMouseVerticalLimit;
   Begin
        M1:=8;
        M2:=0;
        SetMouse(M1,M2,Min,Max);
   End;

  Procedure MouseWindow;
   Begin
        InfX:=X1;
        InfY:=Y1;
        SupX:=X2;
        SupY:=Y2;
        SetMouseHorizontalLimit(X1,X2);
        SetMouseVerticalLimit(Y1,Y2);
   End;

  Procedure HideCursor;
   Begin
        If Show then
         Begin
             { PutImage(OldX,OldY,SCurs,0);}
              Show:=false;
         End;
   End;

  procedure MouseShow;

       (*                        INT 33H, function 01H                    *)
       (* This procedure increments the cursor level counter and  if  the *)
       (* counter is zero, the cursor is displayed on the screen.         *)

  begin
   asm
     mov ax,1
     int $33
   end;
  end;

  Procedure ShowCursor;
   Begin
        If not Show then
         Begin
             { GetImage(X,Y,X+8,Y+12,SCurs);
              PutImage(X,Y,Curs,3);}
              Show:=true;
         End;
   End;

  Procedure MoveCursor;
   Begin
        GetMousePosition(Button,X,Y);
        If Show then
         If(OldX<>X) or (OldY<>Y) then
          Begin
             {  PutImage(OldX,OldY,SCurs,0);
               GetImage(X,Y,X+8,Y+12,SCurs);
               PutImage(X,Y,Curs,3);}
          End;
        OldX:=X;
        OldY:=Y;
   End;

  End.