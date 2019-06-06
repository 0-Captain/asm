assume cs:codesg

codesg segment
	start:
		; mov ax,0
		; mov es,ax
		; mov word ptr es:[4],200h
		; mov word ptr es:[6],0
		
		pushf
		pop ax
		or ah,1
		push ax
		popf

		mov ax,0
		add ax,ax
		add ax,ax
		add ax,ax
		add ax,ax
		add ax,ax

		mov ax,4c00h
		int 21h
codesg ends

end start