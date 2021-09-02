.386
.model flat,stdcall

option casemap:none
include \masm32\include\windows.inc
include \masm32\include\user32.inc
include \masm32\include\kernel32.inc
include \masm32\include\gdi32.inc
includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\gdi32.lib


WinMain proto :DWORD, :DWORD, :DWORD, :DWORD


RGB macro red,green,blue
        xor eax,eax
        mov ah,blue
        shl eax,8
        mov ah,green
        mov al,red
endm


.data
ClassName db "SimpleWinClass",0
AppName db "MyWindow",0
AnyText  db "Black and red - 'You victim to assembler circumstances too' ",0
FontName db "script",0

.data?
hInstance HINSTANCE ?
CommandLine LPSTR ?

.code
start:
    invoke GetModuleHandle, NULL
    mov hInstance, eax
    invoke GetCommandLine
    mov CommandLine, eax
    invoke WinMain, hInstance, NULL, CommandLine, SW_SHOWDEFAULT
    invoke ExitProcess, eax


WinMain proc hInst:HINSTANCE, hPrevInst:HINSTANCE, CmdLine:LPSTR, CmdShow:DWORD
    LOCAL wc:WNDCLASSEX
    LOCAL msg:MSG
    LOCAL hwnd:HWND

    mov  wc.cbSize, SIZEOF WNDCLASSEX
    mov  wc.style, CS_HREDRAW or CS_VREDRAW
    mov  wc.lpfnWndProc, OFFSET WndProc
    mov  wc.cbClsExtra, NULL
    mov  wc.cbWndExtra, NULL
    push hInstance
    mov  wc.hbrBackground,COLOR_WINDOW+1
    mov  wc.lpszMenuName,NULL
    mov  wc.lpszClassName,OFFSET ClassName
    invoke LoadIcon,NULL,IDI_APPLICATION
    mov  wc.hIcon,eax
    mov  wc.hIconSm,eax
    invoke LoadCursor,NULL,IDC_ARROW
    mov  wc.hCursor,eax
    invoke RegisterClassEx, addr wc

    invoke CreateWindowEx, NULL, ADDR ClassName, ADDR AppName, WS_OVERLAPPEDWINDOW,\
                           CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT,\
                           NULL, NULL, hInst, NULL

    mov hwnd, eax
    invoke ShowWindow, hwnd, SW_SHOWNORMAL
    invoke UpdateWindow, hwnd

    .WHILE TRUE
        invoke GetMessage, ADDR msg, NULL, 0, 0

    .BREAK .IF (!eax)
        invoke TranslateMessage, ADDR msg
        invoke DispatchMessage, ADDR msg
  
    .ENDW
        mov eax, msg.wParam
        ret
       
WinMain endp

WndProc proc hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam
   LOCAL hdc:HDC
   LOCAL ps:PAINTSTRUCT
   LOCAL hfont:HFONT
   
   .IF uMsg == WM_DESTROY
        invoke PostQuitMessage, NULL

   .ELSEIF uMsg == WM_PAINT
        invoke BeginPaint, hWnd, ADDR ps
        mov hdc, eax
        invoke CreateFont, 70, 30, 0, 0, 80, 0, 0, 0, OEM_CHARSET, OUT_DEFAULT_PRECIS, CLIP_DEFAULT_PRECIS,\
                           DEFAULT_QUALITY, DEFAULT_PITCH, ADDR FontName

        invoke SelectObject, hdc, eax
        mov hfont, eax
        RGB 0, 0, 0
        
        invoke SetTextColor, hdc, eax
        RGB 255, 0, 0
        
        invoke SetBkColor, hdc, eax
        invoke TextOut, hdc, 0, 0, ADDR AnyText, SIZEOF AnyText
        invoke SelectObject, hdc, hfont

        invoke EndPaint, hWnd, ADDR ps
        
   .ELSE
        invoke DefWindowProc,hWnd, uMsg, wParam, lParam
        ret

   .ENDIF
        xor eax, eax
        ret
   
WndProc endp
end start