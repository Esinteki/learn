#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>
#include <stdlib.h>
#include <Windows.h>

extern "C"
{
	void sayHello();
	void MsgBox(TCHAR *Text);
}

void main()
{
	printf("Hello, what is your name?\n");
	sayHello();

	return;
}

void MsgBox(TCHAR *Text)
{

	
	//printf((const char *)Text);
	

	MessageBox(NULL, (LPCSTR)Text, TEXT("Window"), MB_OK);
	
	
	return;
}

extern "C"
void* readName()
{
	char* name = (char*)calloc(1, 255);
	scanf("%s", name);
	while (getchar() != '\n');
   
	return name;
}


