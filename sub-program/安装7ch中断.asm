assume cs:codesg

codesg segment
	int7c:
		
		
	int7cEnd:
		nop

	start:
		mov ax,cs
		mov ds,ax
		mov si,offset int7c
		mov ax,0
		mov es,ax
		mov di,200h

		mov word ptr es:[7ch*4],200h
		mov word ptr es:[7ch*4+2],0

		mov cx,offset int7cEnd - offset int7c
		cld
		rep movsb

		mov ax,4c00h
		int 21h

codesg ends

end start