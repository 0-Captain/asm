assume cs:code

a segment
  db 1,2,3,4,5,6,7,8
a ends

b segment
  db 1,2,3,4,5,6,7,8
b ends

c segment
  db 0,0,0,0,0,0,0,0
c ends

code segment
  start:  mov ax,a
          mov ds,ax
          
          mov bx,0

          mov cx,8
  s0:     mov al,[bx]
          add al,[bx+16]
          mov [bx+32],al
          inc bx
          loop s0

          mov ax,4c00h
          int 21h
code ends

end start