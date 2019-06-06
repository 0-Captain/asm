assume cs:codesg, ds:data
data segment
        db 'abCDefgHijkLmnOpqRstuVwXYZ'
data ends

codesg segment
start:
	mov ax,data
	mov ds,ax
	mov bx,0

	mov cx,26
s:	
	push cx
	mov cl,[bx]
	mov ch,0
	and  cl,00100000b;cx为0说明为大写，否则为小写
	jcxz s1
	and byte ptr [bx],11011111b
	jmp short ok
s1:
	or byte ptr [bx],00100000b
ok:	
	inc bx
	pop cx
	loop s
	
	mov ax,4c00h
	int 21h
codesg ends

end start