assume cs:code

code segment
	start:
		mov ax,0100h
		mov cx,0007h
		int 10h

		mov ax,0100h
		mov cx,0607h
		int 10

		mov ax,4c00h
		int 21h
code ends
end start