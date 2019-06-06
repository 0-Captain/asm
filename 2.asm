mov ax,1000H
mov ds,ax
mov bx,0000H
mov ax,3e88H
mov [bx],ax
inc bx
inc bx
mov [bx],ah
mov ah,0  0088
inc bx
mov [bx],ax
inc bx
mov [bx],ax
mov ax,ds:[1]
inc bx
inc bx
mov [bx],ax

88 3e 3e 88 00