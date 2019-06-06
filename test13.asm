assume cs:codesg

codesg segment
	start:
		mov ax,cs
		mov ds,ax
		mov si,offset i1

		mov ax,0
		mov es,ax
		mov di,200h

		mov cx,offset i1end - offset i1
		cld
		rep movsb

		mov word ptr es:[4],200h
		mov word ptr es:[6],0

		mov ax,4c00h
		int 21h
	;中断程序
	i1:
		jmp short main
		db 4 dup(0)  	;一段数据空间
	main:
		push ax
		push si
		push bp
		push ds
		push cx
		push es
		push bx
		;将ds，si指向设定的数据空间
		mov si,offset i1 +2
		mov ax,cs
		mov ds,ax
		;向显示器送数据 
		;设置es:bx+di
		mov ax,0b800h
		mov es,ax
		mov bx,4*160+20
		;设置完成
		mov bp,sp
		mov ax,[bp+14]
		call split
		;将四位数据存到数据空间ds:si
		mov [si],dh
		mov [si+1],dl
		mov [si+2],ah
		mov [si+3],al;此时每一位数字占1byte放在ds:si
		;将数据空间中的4位byte型数据转换为数字的ascii码
		mov cx,4
	trans:
		call trans16
		inc si
		loop trans

		sub si,4
		mov cx,4
	sh:
		mov al,ds:[si]
		mov es:[bx+di],al 
		inc di
		inc si
		mov byte ptr es:[bx+di],6h
		inc di
		loop sh

		add di,160-8

		pop bx
		pop es
		pop cx
		pop ds
		pop bp
		pop si
		pop ax
		iret

;func:	4位16进制数分割为4部分，每部分有一位
;参数:	数据源放在ax
;返回:	结果放在dh、dl、ah、al
split:	
	push bx
	push cx

	push ax
	and ax,1111000011110000b
	mov ch,0
	mov cl,4
	shr ax,cl
	mov bx,ax	;第四位和第二位
	pop ax		;恢复ax
	and ax,0000111100001111b	;第三位和第一位
	;此时ah为第三位，al为第一位，bh为第四位，bl为第二位
	mov dh,bh
	mov dl,ah
	mov ah,bl

	pop cx
	pop bx
	ret

;将1位16进制数转换为其ascii码
;参数: ds:si
;返回: ds:si
trans16:
	add byte ptr ds:[si],30h
	cmp byte ptr ds:[si],39h
	ja s1 	;如果比39h大说明是a～f之间的数字，应该再加7
	jmp ok
	s1:
		add byte ptr ds:[si],7
	ok:
	ret

i1end:
	nop
codesg ends

end start







; assume cs:codesg

; codesg segment
; 	start:
; 		mov ax,cs
; 		mov ds,ax
; 		mov si,offset 

; 		mov ax,0
; 		mov es,ax
; 		mov di,200h

; 		mov cx,offset i1end - offset i1
	; 	cld
	; 	rep movsb

	; 	mov word ptr [7ch*4],200h
	; 	mov word ptr [7ch*4+2],0

	; 	mov ax,4c00h
	; 	int 21h

	; i1:

; 	i1end:
; 		nop

; codesg ends

; end start
