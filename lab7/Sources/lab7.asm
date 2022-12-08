.386
.model flat, stdcall
option casemap :none
	include D:\masm32\include\windows.inc
	include D:\masm32\include\masm32.inc
	include D:\masm32\include\kernel32.inc	
	include D:\masm32\macros\macros.asm
	includelib D:\masm32\lib\masm32.lib
	includelib D:\masm32\lib\kernel32.lib

.data
	a dd ?
	b dd ?
	cc dd ?
	d dd ?
	e dd ?
	f dd ?
	g dd ?
	h dd ?
	k dd ?
	m dd ?
	result dd ?
	
	bufferKey db 256 dup(?)
	number dd ?
	
	equation db "(a + b)/c + d/e + (f + gh)/k + m", 13, 10
	variables db "abcdefghkm"
	string db " : "
	answer db "Result: "
	reverseAnswerNumber db 16 dup(?)
	errorString db "Error. Division by 0.", 13, 10
	nullString db "0"
	newLine db 13, 10
	i dd ?
	j dd ?
	zero dd ?
	output db ?
	
	stdout dd ?
	stdin dd ?
	nWrite dd ?
	nRead dd ?
	
.code
	start:
		invoke GetStdHandle, -10
		mov stdin, eax
		invoke GetStdHandle, -11
		mov stdout, eax
		
		invoke WriteConsoleA, stdout, ADDR equation, SIZEOF equation, ADDR nWrite, 0
		
		lea esi, a
		mov i, 0
		
		Numbers:
			call EnterNumber
			mov [esi], eax
			add esi, 4
			
			inc i
		cmp i, 10
			jne Numbers
		
		cmp cc, 0
			je PrintError
		cmp e, 0
			je PrintError
		cmp k, 0
			je PrintError
		jmp Continue
		PrintError:
			invoke WriteConsoleA, stdout, ADDR errorString, SIZEOF errorString, ADDR nWrite, 0
			exit
		Continue:
		
		mov eax, a
		add eax, b
		mov ebx, cc
		mov edx, 0
		div ebx ; (a + b)/c
		
		mov result, eax
		
		mov eax, d
		mov ebx, e
		mov edx, 0
		div ebx ; d/e
		
		add result, eax
		
		mov eax, g
		mov ebx, h
		mul ebx
		add eax, f
		mov ebx, k
		mov edx, 0
		div ebx ; (f + gh)/k
		
		add result, eax
		
		mov eax, m
		add result, eax
		
		invoke WriteConsoleA, stdout, ADDR answer, SIZEOF answer, addr nWrite, 0
		
		cmp result, 0
			jne SkipNull
			
		invoke WriteConsoleA, stdout, ADDR nullString, 1, ADDR nWrite, 0
		jmp GoOut
		SkipNull:
			
		mov eax, result
		mov number, eax
		mov i, 0
		
		ReverseAnswer:
			mov eax, number
			mov ebx, 10
			mov edx, 0
			div ebx
			mov number, eax
			
			mov eax, i
			mov bl, 30h
			add bl, dl
			mov [reverseAnswerNumber + eax], bl
			
			inc i
		cmp i, 16
			jne ReverseAnswer
		
		mov i, 15
		mov zero, 1
		PrintAnswer:
			mov eax, i
			
			mov dl, [reverseAnswerNumber + eax]
			cmp dl, 30h
				jne justAdd
			cmp zero, 0
				je justAdd
			dec i
			jmp PrintAnswer
			
			justAdd:
			mov output, dl
			invoke WriteConsoleA, stdout, ADDR output, SIZEOF output, ADDR nWrite, 0
			mov zero, 0
			dec i
		cmp i, 0
			jge PrintAnswer
		
		GoOut:
		invoke WriteConsoleA, stdout, ADDR newLine, SIZEOF newLine, ADDR nWrite, 0
		
		exit


		EnterNumber proc
			mov eax, i
			mov dl, [variables + eax]
			mov [string], dl
			
			invoke WriteConsoleA, stdout, ADDR string, SIZEOF string, ADDR nWrite, 0
			
			mov j, 0
			mov number, 0
			
			OneNumber:
				invoke ReadConsoleInput, stdin, ADDR bufferKey, 256, ADDR nRead
				
				cmp [bufferKey+04d], 1h
					jne OneNumber
				cmp [bufferKey+14d], 0Dh
					jne EndCheck
					cmp j, 1
						jge NumberEnd
				EndCheck:
				cmp [bufferKey+14d], 0
					je OneNumber
				cmp [bufferKey+14d], 30h
					jl OneNumber
				cmp [bufferKey+14d], 39h
					jg OneNumber
				
				mov eax, number
				mov ebx, 10
				mul ebx
				mov number, eax
				
				mov eax, 0
				mov al, [bufferKey+14d]
				sub al, 30h
				add number, eax
				
				invoke WriteConsoleA, stdout, offset [bufferKey+14d], 1, ADDR nWrite, 0
				
				inc j
			cmp j, 4
				jne OneNumber
				
			NumberEnd:
			
			invoke WriteConsoleA, stdout, ADDR newLine, SIZEOF newLine, ADDR nWrite, 0
			
			mov eax, number
		ret
		EnterNumber endp
	
		invoke ExitProcess, 0
	end start