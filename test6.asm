assume cs:codeseg ds:dataseg ss:stackseg

stackseg segment
  dw  0, 0, 0, 0, 0, 0, 0, 0
stackseg ends

dataseg segment
  db '1. display      '
  db '2. borws        '
  db '3. replace      '
  db '4. modify       '
dataseg ends

codeseg segment
  start:  mov ax,dataseg
          mov ds,ax
          mov ax,stackseg
          mov ss,ax
          mov al,11011111b

          mov bx,0

          mov cx,4
  s0:     push cx
          mov cx,4
          mov si,3
  s1:     and [si],al
          inc si
          loop s1
          
          pop cx
          mov dx,ds
          add dx,1h
          mov ds,dx
          loop s0

          mov ax,4c00h
          int 21h

codeseg ends

end start