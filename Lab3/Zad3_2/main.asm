.686
.model flat

extern __write : PROC
extern _ExitProcess@4 : PROC
extern __read : PROC

public _main

.data


obszar db 12 dup (?)
dziesiec dd 10 ; mno�nik


.code

wczytaj_do_EAX PROC
	; wczytywanie liczby dziesi�tnej z klawiatury � po
	; wprowadzeniu cyfr nale�y nacisn�� klawisz Enter
	; liczba po konwersji na posta� binarn� zostaje wpisana
	push ebx
	push ecx
	push edx
	; do rejestru EAX
	; max ilo�� znak�w wczytywanej liczby
	push dword PTR 12
	push dword PTR OFFSET obszar ; adres obszaru pami�ci
	push dword PTR 0; numer urz�dzenia (0 dla klawiatury)
	call __read ; odczytywanie znak�w z klawiatury
	; (dwa znaki podkre�lenia przed read)
	add esp, 12 ; usuni�cie parametr�w ze stosu
	; bie��ca warto�� przekszta�canej liczby przechowywana jest
	; w rejestrze EAX; przyjmujemy 0 jako warto�� pocz�tkow�
	mov eax, 0
	mov ebx, OFFSET obszar ; adres obszaru ze znakami
	pobieraj_znaki:
	mov cl, [ebx] ; pobranie kolejnej cyfry w kodzie
	; ASCII
	inc ebx ; zwi�kszenie indeksu
	cmp cl,10 ; sprawdzenie czy naci�ni�to Enter
	je byl_enter ; skok, gdy naci�ni�to Enter
	sub cl, 30H ; zamiana kodu ASCII na warto�� cyfry
	movzx ecx, cl ; przechowanie warto�ci cyfry w
	; rejestrze ECX
	; mno�enie wcze�niej obliczonej warto�ci razy 10
	mul dword PTR dziesiec
	add eax, ecx ; dodanie ostatnio odczytanej cyfry
	jmp pobieraj_znaki ; skok na pocz�tek p�tli
	byl_enter:
	; warto�� binarna wprowadzonej liczby znajduje si� teraz w rejestrze EAX
	 pop edx
	 pop ecx
	 pop ebx
	 ret
wczytaj_do_EAX ENDP

_main PROC
 call wczytaj_do_EAX
 
 push 0
 call _ExitProcess@4
_main ENDP
END