.8086
assume cs:codesg

data segment
	db "welcome to masm!"
data ends

color segment
	db 00,71h,02h,24h,00
color ends

stack segment
	db 32 dup (0) 
stack ends

codesg segment
			
	start: 	;初始化栈段
			mov ax,stack
			mov ss,ax
			mov sp,32
			;输入color中的数据
			mov ax,color
			mov ds,ax
			mov bx,0

			mov al,[bx]
			mov ah,0
			push ax
			inc bx
			mov ax,0

	input:	mov al,[bx]
			push ax
			inc bx
			mov cx,ax
			jcxz begin
			jmp short input
			


			;初始化ds，es->data,ss
	begin:	mov ax,0b874h
			mov ds,ax
			mov di,000ah

			mov ax,data
			mov es,ax
			pop si

	next: 	pop dx ;dx中的dl存颜色,
			mov cx,dx
			;判断是否结束，0代表结束
			jcxz end1
			;判断结束，还原cx

			mov ax,ds
			add ax,10
			mov ds,ax
			mov di,000ah
			mov si,0

			mov cx,16
			jmp short show

	show:	;放字母
			mov al,es:[si]
			mov ds:[di],al
			inc si
			inc di
			;放颜色
			mov [di],dl
			inc di
			loop show

			jmp short next

	end1:   mov ax,4c00h
			int 21h


codesg ends

end start