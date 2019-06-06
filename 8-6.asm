assume cs:codesg

data segment
	db "1975", "1976", "1977", "1978", "1979", "1980", "1981", "1982", "1983", "1984", "1985", "1986", "1987", "1988", "1989", "1990", "1991", "1992", "1993", "1994", "1995"
	dd 16,22,382,1356,2390,8000,16000,24486,50065,97479,140417,197514,345980,590827,803530,1183000,1843000,2759000,3753000,4649000,5937000
	dw 3,7,9,13,28,38,130,220,476,778,1001,1442,2258,2793,4037,5635,8226,11542,11430,15257,17800
data ends

table segment
	db 21 dup ('year\tsumm\tne\t??\n')
table ends

;idata表示data段中的三个数组的基址，分别为0，84，168；si和bx为变址，其中si每次循环增加4，对应年份和收入，bx每次增加2对应员工数；
codesg segment
	start:	mov ax,data
			mov ds,ax
			mov ax,table
			mov es,ax

			mov bx,0
			mov si,0
			mov di,0

			mov cx,21
	input: 	;将年份移动到table
			mov dx,[0][si]		
			mov es:[di].0,dx
			mov dx,[0][si+2]
			mov es:[di].2,dx

			;移动收入
			mov dx,[84][si]		
			mov es:[di].5,dx
			mov dx,[84][si+2]
			mov es:[di].7,dx

			;移动雇员
			mov dx,[168][bx]	
			mov es:[di].0ah,dx

			;计算平均收入
			mov ax,es:[di].5
			mov dx,es:[di].7
			div word ptr es:[di].0ah
			mov es:[di].0dh,ax

			add si,4
			add bx,2
			add di,10h

			loop input

			mov   ax,4c00h   
			int   21h  
codesg ends

end start




