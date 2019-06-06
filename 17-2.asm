;ah传递功能号，0代表读，1代表写
; dx寄存器存放要读区扇区的逻辑分号
; es:bx指向存储读入数据或写数据的内存位置
assume cs:codesg

codesg segment
	int7c:
		push ax
		push dx
		push bx
		push cx

		push ax
		mov ax,dx
		mov dx,0
		mov cx,1440
		div cx ;面号ax = int(逻辑扇区号/1440)
		push ax

		mov ax,dx ;ax = rem(逻辑扇区号/1440)
		mov cx,18
		div cx ;磁道号al = int(rem(逻辑扇区号/1440)/18)
		mov ch,al	;设置磁道号 ---

		mov cl,ah
		inc cl	;设置扇区号 ---

		pop dx
		mov dh,dl	;设置面号 ---
		mov dl,0	;设置驱动器号 ---
		pop ax		;设置读写 ---
		add ah,2
		mov al,1	;设置要读写的扇区数 ---

		int 13h

		pop cx
		pop bx
		pop dx
		push ax
		iret
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
; dh放磁头号，也就是软盘的面号。 	2面
; ch放磁道号						80磁道
; cl放扇区号						18扇区，每个扇区512字节
; al放读取的扇区数
; dl放驱动器号，0为软驱A，1为软驱B





mov ah,1
mov dx,0
mov bx,0
mov es,bx
mov bx,250
int 7ch



