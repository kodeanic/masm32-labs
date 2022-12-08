.386
.model flat, stdcall
option casemap :none
	include D:\masm32\include\user32.inc
	include D:\masm32\include\kernel32.inc
	includelib D:\masm32\lib\user32.lib
	includelib D:\masm32\lib\kernel32.lib

BSIZE equ 63

.data
	stdout dd ?
	buf db BSIZE dup(?)
	nWritten dd ?
	
	a dd 2
	y dd ?
	y1 dd ?
	y2 dd ?
	x dd 0
	
	ifmt db "If X = %d, then y1 = %d, y2 = %d and y = %d", 10, 13

	
.code
	start:
		invoke GetStdHandle, -11
		mov stdout, eax
		
		CYCL:
			cmp x, 16
				je Exit
			
			mov eax, a
			cmp x, eax ; сравнение a и x
				jle ElsePart ; переход если меньше или равно
			cmp x, 0 ; сравнение x и 0
				jle ElsePart0
			add eax, x
				jmp EndOfIf
			ElsePart0:
			sub eax, x
				jmp EndOfIf
			ElsePart:
				sub eax, 7
			EndOfIf:
				mov y1, eax
			
			mov ebx, a
			cmp ebx, 3
				jle ElsePart2
			mov ebx, a
			mov eax, 3
			mul ebx
			mov ebx, eax
				jmp EndOfIf2
			ElsePart2:
				mov ebx, 11
			EndOfIf2:
				mov y2, ebx
			
			mov ecx, x
			mov eax, y1
			mov ebx, y2
			
			mov edx, eax
			sub edx, ebx
				
			invoke wsprintf, ADDR buf, ADDR ifmt, ecx, eax, ebx, edx
			invoke WriteConsoleA, stdout, ADDR buf, SIZEOF ifmt, ADDR nWritten, 0

			inc x
			jmp CYCL
		Exit:

        invoke ExitProcess, 0
	end start
