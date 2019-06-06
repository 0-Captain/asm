assume cs:codesg
data segment
dw 0,0
data ends 

codesg segment
start:
	mov ax,0
	mov bh,0
	mov bl,1
loops:
	add al,bl
	inc bl
	push ax
	sub al,122
	and al,10000000b
	mov cx,ax
	pop ax
	jcxz ok
	jmp short loops
ok:
	mov dx,data
	mov ds,dx
	mov ds:[0],ax
	mov ds:[2],bx


	mov ax,4c00h
	int 21h
codesg ends

end start