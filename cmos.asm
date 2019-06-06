assume cs:codesg

data segment
	db 10 dup(0)
data ends

codesg segment
	start:
		mov ax,data
		mov ds,ax
		mov si,0

		mov al,9
		out 70h,al
		in ax,71h

		mov al,8
		out 70h,al
		in al,71h
		push al

		mov al,7
		out 70h,al
		in al,71h
		push al

		mov al,4
		out 70h,al
		in ax,71h
		push ah
		push al

		mov al,2
		out 70h,al
		in ax,71h
		push ah
		push al

		mov al,0
		out 70h,al
		in ax,71h
		push ah
		push al

		mov ax,4c00h
		int 21h
codesg ends

end start