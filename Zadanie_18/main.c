#include <stdio.h>
#include <Windows.h>
wchar_t* ASCII_na_UTF16(char* znaki, int n);

int main() {

	char tab[] = "kotek";

	wchar_t* tabw=  ASCII_na_UTF16(tab, 5);

	MessageBox(0, tabw, tabw, 0);

	return 0;
}