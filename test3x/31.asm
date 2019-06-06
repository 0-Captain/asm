;将程序设置为单步中断的处理程序，单步中断的中断类型码
assume cs:codesg

codesg segment
start:
	mov ax,0b800h
	mov ds,ax
	mov bx,0

	mov cx,7d0h
loops:
	push cx
	mov byte ptr [bx+1],0

	mov ch,0
	mov cl,[bx]
	cmp cx,7bh
	jb blow1
	jmp short max
	blow1: 
		cmp cx,60h
		ja above1 
		jmp short max
	above1:
		mov byte ptr [bx+1],4
		jmp short ok

	max:
	cmp cx,5bh
	jb blow2
	jmp short ok
	blow2: 
		cmp cx,40h
		ja above2
		jmp short ok
	above2:
		mov byte ptr [bx+1],2

		; and cx,01100000b
		; cmp cx,01000000b
		; ; sub cx,01000000b
		; je chgcolor1
		; ja chgcolor2

	; mov byte ptr [bx+1],0

	; jmp short ok
; chgcolor1:
; 	mov byte ptr [bx+1],2
; 	jmp short ok
; chgcolor2:
; 	mov byte ptr [bx+1],4

ok:
	add bx,2

	pop cx
	loop loops

	mov ax,4c00h
	int 21h
codesg ends

end start