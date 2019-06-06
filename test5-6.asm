assume cs:code

a segment
  dw 1,2,3,4,5,6,7,8,9,0ah,0bh,0ch,0dh,0eh,0fh,0ffh
a ends

b segment
  dw 0,0,0,0,0,0,0,0
b ends

code segment
  start:  mov ax,a
          mov ds,ax
          mov bx,0
          mov si,20h

          mov cx,8
  s0:     push [bx]
          inc bx
          inc bx
          loop s0

          mov cx,8
  s1:     pop [si]
          inc si
          inc si
          loop s1


          mov ax,4c00h
          int 21h
code ends

end start