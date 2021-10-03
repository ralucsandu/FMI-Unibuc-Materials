#include "Imprumut.hpp"
#include <iostream>
#include <ctime>
#include <cstring>

Imprumut::Imprumut(const Imprumut& loan)
{
    this->valoareImprumut=loan.valoareImprumut;
    this->idCont=loan.idCont;
    this->durata=loan.durata;
    this->sumaAchitata=loan.sumaAchitata;
}
Imprumut::Imprumut()
{
    this->valoareImprumut=0;
    this->idCont=0;
    this->durata="0,0,0";
    this->sumaAchitata=0;
}
Imprumut::Imprumut(float valoareImprumut, long idCont)
{
    this->valoareImprumut=valoareImprumut;
    this->idCont=idCont;
    this->durata="";
    this->sumaAchitata=0;
}
Imprumut::Imprumut(string durata, double sumaAchitata)
{
    this->durata=durata;
    this->sumaAchitata=sumaAchitata;
    this->valoareImprumut=0;
    this->idCont=0;
}
Imprumut& Imprumut::operator=(const Imprumut& loan)
{
    if(this!=&loan)
    {
        this->valoareImprumut=loan.valoareImprumut;
        this->idCont=loan.idCont;
        this->durata=loan.durata;
        this->sumaAchitata=loan.sumaAchitata;
    }
    return *this;
}
istream& operator>>(istream& in, Imprumut& i)
{
    cout<<"Valoare imprumut(in lei): ";
    in>>i.valoareImprumut;
    cout<<"ID-ul contului care a primit imprumutul: ";
    in>>i.idCont;
    cout<<"Durata(format numar ani,numar luni,numar zile) maxima de restituire a imprumutului: ";
    in>>i.durata;
    cout<<"Suma achitata momentan(in lei): ";
    in>>i.sumaAchitata;
    return in;
}
ostream& operator<<(ostream& out, const Imprumut& i)
{
    out<<"Valoare imprumut: "<<i.valoareImprumut<<" lei\n";
    out<<"ID-ul contului care a primit imprumutul este: "<<i.idCont<<"\n";
    if(i.durata!="")
        out<<"Durata(in ani,luni,zile) maxima de restituire a imprumutului: "<<i.durata<<"\n";
    if(i.sumaAchitata!=0)
    out<<"Suma achitata momentan: "<<i.sumaAchitata<<" lei";
    return out;
}
Imprumut::operator int() //operatorul cast explicit, converteste valoarea imprumutului din float in int
{
    return (int)this->valoareImprumut;
}
float Imprumut::getValoareImprumut()
{
    return this->valoareImprumut;
}
long Imprumut::getIdCont()
{
    return this->idCont;
}
string Imprumut::getDurata()
{
    return this->durata;
}
double Imprumut::getSumaAchitata()
{
    return this->sumaAchitata;
}
void Imprumut::setDurata(string durata)
{
    this->durata=durata;
}
void Imprumut::setSumaAchitata(double sumaAchitata)
{
    this->sumaAchitata=sumaAchitata;
}
void Imprumut::setValoareImprumut(float valoareImprumut)
{
    this->valoareImprumut=valoareImprumut;
}
string Imprumut::CandTrebuieReturnat() //metoda pentru a determina la ce data trebuie returnat imprumutul facut
{
    // extragem ziua, luna, anul din data curenta
    time_t t = time(0);
    tm *now = localtime(&t);

    int ziCurenta = now->tm_mday;
    int lunaCurenta = now->tm_mon + 1;
    int anulCurent = now->tm_year + 1900;

    cout << "Ziua curenta = " << ziCurenta << ", Luna curenta = " << lunaCurenta << ", Anul curent = " << anulCurent << "\n";

    // extragem numarul de ani, luni, zile din durata imprumutului
    int aniRamasi, luniRamase, zileRamase;
    getZileLuniAniDurata(zileRamase, luniRamase, aniRamasi);

    cout << "Numar de ani ramasi = " << aniRamasi << ", Numar de luni ramase = " << luniRamase << ", Numar de zile ramase = " << zileRamase << "\n";

    // calculam ziua, luna si anul pana la care trebuie returnat creditul
    int ziDeReturnat = ziCurenta + zileRamase;
    int lunaDeReturnat = lunaCurenta + luniRamase;
    int anDeReturnat = anulCurent + aniRamasi;

    if (ziDeReturnat > 30) //pentru ca am presupus ca fiecare luna are 30 de zile
    {
        ziDeReturnat = ziDeReturnat % 30;
        lunaDeReturnat++;
    }
    if (lunaDeReturnat > 12)
    {
        lunaDeReturnat = lunaDeReturnat % 12;
        anDeReturnat++;
    }
    cout<<"Imprumutul trebuie returnat la data de ";
    return to_string(ziDeReturnat) + "/" + to_string(lunaDeReturnat) + "/" + to_string(anDeReturnat);

}
void Imprumut::getZileLuniAniDurata(int &zile, int &luni, int &ani)
{
    // extragem numarul de ani, luni, zile din durata creditului
    // durata.c_str() intoarce un const char*
    // strtok() distruge sirul de caractere, nu se poate folosi pe std::string sau pe const char*
    // copiem sirul durata in variabila auxDurata
    int aniRamasi, luniRamase, zileRamase;
    char *auxDurata = strdup(durata.c_str()); //strdup se foloseste penru a duplica un sir
    char *p = strtok(auxDurata, ",");
    ani = atoi(p);
    p = strtok(NULL, ",");
    luni = atoi(p);
    p = strtok(NULL, ",");
    zile = atoi(p);
}
Imprumut::~Imprumut()
{
}
