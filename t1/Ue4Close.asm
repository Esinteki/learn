.586
.model flat, stdcall

extern FindWindowA@8:near
extern SendMessageA@16:near

includelib C:\masm32\lib\user32.lib

.data
	WndClass db "UnrealWindow",0

.code
start:
	
	push 0
	push offset WndClass
	call FindWindowA@8
	
	push 0
	push 0
	push 16
	push eax
	call SendMessageA@16
	
	push 0
	push offset WndClass
	call FindWindowA@8
	
	push 0
	push 0 
	push 2
	push eax
	call SendMessageA@16
	
	ret
	
end start

