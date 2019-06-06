;找到当前屏幕中所有显示为“a”的字符，并把它的属性变为闪烁黑底红字
;当前屏幕的内容在内存中的地址为b8000h开始的4000字节空间,即0fa0h个字节,即7d0个字
assume cs:codesg

codesg segment
start:
	mov ax,0b800h
	mov ds,ax
	mov bx,0
	mov dl,10000100b

	mov cx,7d0h
loops:
	push cx

	mov ch,0
	mov cl,[bx]
	sub cx,61h
	jcxz chgcolor
	jmp short ok
chgcolor:
	mov [bx+1],dl
ok:
	add bx,2

	pop cx
	loop loops

	mov ax,4c00h
	int 21h
codesg ends

end start