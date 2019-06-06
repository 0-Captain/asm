assume cs:codesg
a segment
	dd 0123h,0456h,0789h,0abch
a ends

b segment
	dw 10h,20h,10h,20h
b ends

c segment
	dw 0,0,0,0
c ends

codesg segment
start:
	mov ax,a
	mov ds,ax
	mov bx,10h
	mov ax,c
	mov es,ax
	;a->ds:0 b->ds:bx c:es:0
	mov si,0
	mov di,0
	mov cx,4
loop1:
	mov ax,[si]
	mov dx,[si+2]
	add si,4
	div word ptr [bx]
	add bx,2
	mov es:[di],ax
	add di,2
	loop loop1

	mov ax,4c00h
	int 21h


codesg ends

end start