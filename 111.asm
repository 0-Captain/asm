assume cs:codesg

codesg segment
db  'welCOMe'
start:
	mov ax,cs
	mov ds,ax
	mov bx,0
	mov cx,7
 s1:
	push cx
	mov al,[bx]
	and al,00100000b
	mov cx,00100001b
	mov ah,0
	sub cx,ax
	loop s2
	mov al,[bx]
	and al,11011111b
	mov [bx],al
	pop cx
	inc bx
	loop s1
	jmp s3
    s2:
	mov al,[bx]
	or al,00100000b
	mov [bx],al
	pop cx
	inc bx
	loop s1
	s3:
mov ax,4c00h
int 21h
codesg ends

end start