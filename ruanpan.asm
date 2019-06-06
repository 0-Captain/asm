assume cs:code

code segment

	ruanpan:
	mov ax,0b800h
	mov es,ax
	mov bx,0

	mov ax,0231h
	s:
	mov es:[bx],ax
	add bx,2 
	jmp s



setup:
mov ax,cs
mov es,ax
mov bx,offset ruanpan

mov ah,3
mov al,1
mov ch,0
mov cl,1
mov dl,0
mov dh,0
int 13h


mov ax,4c00h
int 21h

code ends

end setup









