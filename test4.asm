assume cs:codesg

codesg segment

    mov ax,0020h
    mov ds,ax
    mov bx,0
    mov cx,0040h
  s:mov ds:[bx],bl
    inc bx
    loop s

    mov ax,4c00h
    int 21h


codesg ends

end