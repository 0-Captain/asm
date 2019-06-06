; 功能：获取屏幕上输入的字符放在ax，但不影响正常9号中断
; 1.保存原来的9号中断向量到200h，设置新的9号中断向量为0:210h中断号为80h, 
; 2.新的9号中段中先调用原先的9号中断（现在的80h中断），然后int16h获取键盘输入的字符并放入ax，然后再次调用80h中断完成字符的显示等功能，
; 返回值在ax中，ah为颜色等，al为ascii码
assume cs:codesg

codesg segment
	int9:
		int 80h

		mov ah,0
		int 16h ;返回值在ax，al为ascii码，ah为扫描码
		; mov bl,2
		; mov cx,5
		; mov bh,0
		; mov ah,0ah
		; int 10hcvcc

		iret

	int9End:
		nop

	start:
		mov ax,cs
		mov ds,ax
		mov si,offset int9
		mov ax,0
		mov es,ax
		mov di,200h

		; 1
		push es:[9*4]
		push es:[9*4+2]
		pop es:[di+2]
		pop es:[di]
		; 2
		cli
		mov word ptr es:[9*4],210h
		mov word ptr es:[9*4+2],0			
		sti

		add di,10h
		mov cx,offset int9End - offset int9
		cld
		rep movsb

		mov ax,4c00h
		int 21h

codesg ends

end start