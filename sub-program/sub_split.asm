;func:	4位16进制数分割为4部分，每部分有一位
;参数:	数据源放在ax
;返回:	结果放在dh、dl、ah、al
split:	
	push bx
	push ax
	and ax,1111000011110000b
	mov cl,4
	chr ax,cl
	mov bx,ax	;第四位和第二位
	pop ax		;恢复ax
	and ax,0000111100001111b	;第三位和第一位
	;此时ah为第三位，al为第一位，bh为第四位，bl为第二位
	mov dh,bh
	mov dl,ah
	mov ax,bl

	pop bx
	ret