

float avg_wd(int n, void* tablica, void* wagi);


int main() {


	float tab[5] = { 2.1, 3.2, 3.23, 3, 1.97 };
	float wagi[5] = { 2.3, 1.5, 4.2, 9.0, 4.4 };

	float wynik = avg_wd(5, tab, wagi);

	return 0;
}