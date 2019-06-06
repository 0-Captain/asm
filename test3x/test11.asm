assume cs:codesg

datasg segment
	db "Beginner's All-purpose Symbolic instruction Code.", 0
datasg ends

codesg segment
	begin:
		mov ax,datasg
		mov ds,ax
		mov si,0
		call letterc

		mov ax,4c00h
		int 21h

	letterc:
		push si

		trans:
			cmp byte ptr [si],0
			je ok
			and byte ptr [si],01011111b
			inc si
			jmp short trans
		ok:
		pop si
		ret
codesg ends

end begin