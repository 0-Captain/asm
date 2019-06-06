assume cs:codesg
data segment
	db "1975", "1976", "1977", "1978", "1979", "1980", "1981", "1982", "1983", "1984", "1985", "1986", "1987", "1988", "1989", "1990", "1991", "1992", "1993", "1994", "1995"
	dd 16,22,382,1356,2390,8000,16000,24486,50065,97479,140417,197514,345980,590827,803530,1183000,1843000,2759000,3753000,4649000,5937000
	dw 3,7,9,13,28,38,130,220,476,778,1001,1442,2258,2793,4037,5635,8226,11542,11430,15257,17800
	db 21 dup (20h,20h,20h,20h)
data ends
table segment
	db 3360 dup (20h)
table ends
codesg segment
	start:	mov ax,data
			mov ds,ax
			mov ax,table
			mov es,ax
			mov bx,0
			mov si,0
			mov di,0
			mov cx,21
	input:
			mov dx,[0][si]		
			mov es:[di],dx
			add di,2
			mov dx,[0][si+2]
			mov es:[di],dx
			add di,7
			call dword_trans_10
			add di,13
			mov ax,[168][bx]
			call word_trans_10
			add di,9
			mov ax,[84][si]
			mov dx,[84][si+2]
			div word ptr [168][bx]
			call word_trans_10
			add di,5
			add si,4
			add bx,2
			add di,44
			loop input
			mov word ptr es:[di],0
			mov dh,05h
			mov dl,05h
			mov cl,02h
			mov ax,es
			mov ds,ax
			mov si,0
			call show_str
			mov   ax,4c00h   
			int   21h  
word_trans_10:
	push di
	push ax
	push bx
	push cx
	push dx
	mov bx,0
	transfrom:
		inc bx
		mov cx,10
		mov dx,0
		div cx
		push dx
		mov cx,ax
		jcxz over1
		jmp transfrom
	over1:
		mov cx,bx
		to_ascii1:
			pop ax
			add ax,30h
			mov es:[di],al
			inc di
			loop to_ascii1
	pop dx
	pop cx
	pop bx
	pop ax
	pop di
	ret
dword_trans_10:
	push di
	push ax
	push cx
	push bx
	push dx
	mov bx,0
	mov ax,[84][si]
	mov dx,[84][si+2]
	loop1:
	inc bx
	mov cx,10
	call divdw
	push cx
	clc
	add ax,dx
	adc ax,0
	mov cx,ax
	jcxz over2
	jmp loop1
	over2:
		mov cx,bx
		to_ascii2:
			pop ax
			add ax,30h
			mov es:[di],al
			inc di
			loop to_ascii2
	pop dx
	pop bx
	pop cx
	pop ax
	pop di
	ret 
divdw:
	push bx
	push ax
	mov ax,dx
	mov dx,0
	div cx
	pop bx
	push ax
	mov ax,bx
	div cx
	mov cx,dx
	pop dx
	pop bx
	ret
show_str: 
	push bx
	mov bl,cl
	push ax
	push di
	push cx
	push dx
	mov ax,0
	mov di,0
	mov cx,0
	mov al,160
	mul dh
	mov dh,0
	add ax,dx
	add ax,dx
	mov di,ax
	mov ax,0b800h
	mov es,ax
	show:
		mov cl,[si]
		mov es:[di],cl
		inc si
		inc di
		mov es:[di],bl
		inc di
		jcxz back
		jmp show
back:
	pop dx
	pop cx
	pop di
	pop ax
	pop bx
	ret
codesg ends
end start






