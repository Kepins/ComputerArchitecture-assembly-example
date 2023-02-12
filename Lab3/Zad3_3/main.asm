.686
.model flat

extern __write : PROC
extern _ExitProcess@4 : PROC
extern __read : PROC

public _main

.data

znaki db 12 dup (?)
obszar db 12 dup (?)
dziesiec dd 10 ; mno¿nik

.code

wczytaj_do_EAX PROC
	; wczytywanie liczby dziesiêtnej z klawiatury – po
	; wprowadzeniu cyfr nale¿y nacisn¹æ klawisz Enter
	; liczba po konwersji na postaæ binarn¹ zostaje wpisana
	push ebx
	push ecx
	push edx
	; do rejestru EAX
	; max iloœæ znaków wczytywanej liczby
	push dword PTR 12
	push dword PTR OFFSET obszar ; adres obszaru pamiêci
	push dword PTR 0; numer urz¹dzenia (0 dla klawiatury)
	call __read ; odczytywanie znaków z klawiatury
	; (dwa znaki podkreœlenia przed read)
	add esp, 12 ; usuniêcie parametrów ze stosu
	; bie¿¹ca wartoœæ przekszta³canej liczby przechowywana jest
	; w rejestrze EAX; przyjmujemy 0 jako wartoœæ pocz¹tkow¹
	mov eax, 0
	mov ebx, OFFSET obszar ; adres obszaru ze znakami
	pobieraj_znaki:
	mov cl, [ebx] ; pobranie kolejnej cyfry w kodzie
	; ASCII
	inc ebx ; zwiêkszenie indeksu
	cmp cl,10 ; sprawdzenie czy naciœniêto Enter
	je byl_enter ; skok, gdy naciœniêto Enter
	sub cl, 30H ; zamiana kodu ASCII na wartoœæ cyfry
	movzx ecx, cl ; przechowanie wartoœci cyfry w
	; rejestrze ECX
	; mno¿enie wczeœniej obliczonej wartoœci razy 10
	mul dword PTR dziesiec
	add eax, ecx ; dodanie ostatnio odczytanej cyfry
	jmp pobieraj_znaki ; skok na pocz¹tek pêtli
	byl_enter:
	; wartoœæ binarna wprowadzonej liczby znajduje siê teraz w rejestrze EAX
	 pop edx
	 pop ecx
	 pop ebx
	 ret
wczytaj_do_EAX ENDP


wyswietl_EAX PROC
 pusha

 mov esi, 10 ; indeks w tablicy 'znaki'
 mov ebx, 10 ; dzielnik równy 10

konwersja:
 mov edx, 0 ; zerowanie starszej czêœci dzielnej
 div ebx ; dzielenie przez 10, reszta w EDX,
 ; iloraz w EAX
 add dl, 30H ; zamiana reszty z dzielenia na kod
 ; ASCII
 mov znaki [esi], dl; zapisanie cyfry w kodzie ASCII
 dec esi ; zmniejszenie indeksu
 cmp eax, 0 ; sprawdzenie czy iloraz = 0
 jne konwersja ; skok, gdy iloraz niezerowy
 
 ; wype³nienie pozosta³ych bajtów spacjami i wpisanie
 ; znaków nowego wiersza
wypeln:
 or esi, esi
 jz wyswietl ; skok, gdy ESI = 0
 mov byte PTR znaki [esi], 20H ; kod spacji
 dec esi ; zmniejszenie indeksu
 jmp wypeln

wyswietl:
 mov byte PTR znaki [0], 0AH ; kod nowego wiersza
 mov byte PTR znaki [11], 0AH ; kod nowego wiersza
 ; wyœwietlenie cyfr na ekranie
 push dword PTR 12 ; liczba wyœwietlanych znaków
 push dword PTR OFFSET znaki ; adres wyœw. obszaru
 push dword PTR 1; numer urz¹dzenia (ekran ma numer 1)
 call __write ; wyœwietlenie liczby na ekranie
 add esp, 12 ; usuniêcie parametrów ze stosu

 popa
 ret
wyswietl_EAX ENDP


_main PROC

 call wczytaj_do_EAX
 mul EAX
 call wyswietl_EAX

 push 0
 call _ExitProcess@4
_main ENDP
END