.386
.model flat, stdcall
option casemap :none
	include D:\masm32\include\user32.inc
	include D:\masm32\include\kernel32.inc
	includelib D:\masm32\lib\user32.lib
	includelib D:\masm32\lib\kernel32.lib

BSIZE equ 31

.data
	stdout dd ?
	buf db BSIZE dup(?)
	nWritten dd ?
	
	a dd 10 ; 1010
	b dd 5 ;  0101
	c1 dd 3 ; 0011
	d dd 1 ;  0001
	e dd 8 ;  1000
	f dd 4 ;  0100
	g1 dd 2 ; 0010
	h dd 9 ;  1001
	k dd 0 ;  0000
	g dd 15 ; 1111
	m dd 7 ;  0111
	
	ifmt db "Result: %d", 0
	
	equation db "(a + b | c) + d + e & f + (h | k + g) & m", 13, 10
	
.code
	start:
		invoke GetStdHandle, -11
		mov stdout, eax
		invoke WriteConsoleA, stdout, ADDR equation, sizeof equation, ADDR nWritten, 0
		
		mov eax, b
		or eax, c1 ; 00111
		add eax, a ; 10001
		add eax, d ; 10010
		
		mov ebx, e
		and ebx, f ; 00000
		
		mov ecx, h
		or ecx, k  ; 01001
		add ecx, g1 ;01011
		and ecx, m ; 00011
		
		add eax, ebx ;10010
		add eax, ecx ;10101
		
		invoke wsprintf, ADDR buf, ADDR ifmt, eax
        invoke WriteConsoleA, stdout, ADDR buf, 11, ADDR nWritten, 0

        invoke ExitProcess, 0
	end start
