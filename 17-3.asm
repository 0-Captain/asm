assume cs:code

code segment
	start:

	getstr:
		push ax
	getstrs:
		mov ah,0
		int 16h
		cmp al,20h ;ascii码小于20说明不是字符
		jb nochar
		mov ah,0
		call charstack
		mov ah,2
		call charstack
		jmp getstrs

; 参数：ah=功能号；	0表示入栈，1表示出栈，2表示显示。
; 对于0号功能：al放入栈字符
; 对于1号功能：al为返回的字符
; 对于2号功能：dh，dl为在屏幕上显示的行与列
charstack:
	jmp short charstart

	table dw charpush,charpop,charshow
	top dw 0

	charstart:
		push bx
		push dx
		push di
		push es

		cmp ah,2
		ja sret

		

	sret:
		pop es
		pop di
		pop dx
		pop dx
		ret

code ends

end start