#ifndef IMPRUMUTCUDOBANDAFIXA_HPP_INCLUDED
#define IMPRUMUTCUDOBANDAFIXA_HPP_INCLUDED
#include "Imprumut.hpp"
#include<iostream>

using namespace std;

///mostenirea clasei Imprumut
class ImprumutCuDobandaFixa: public Imprumut
{
private:
    double dobandaAnuala;
    float valoareRata;
public:
    ImprumutCuDobandaFixa(); //constructorul fara parametri

    ImprumutCuDobandaFixa(float valoareImprumut, long idCont, double dobandaAnuala,
                          float valoareRata);
    ImprumutCuDobandaFixa(const ImprumutCuDobandaFixa& imp);
    ImprumutCuDobandaFixa& operator=(const ImprumutCuDobandaFixa& imp);
    friend ostream& operator<<(ostream& out, const ImprumutCuDobandaFixa& imp);
    friend istream& operator>>(istream& in, ImprumutCuDobandaFixa& imp);
    double getDobandaAnuala();
    float getValoareRata();
    void setDobandaAnuala(double dobandaAnuala);
    void setValoareRata(float valoareRata);

    ///Functionalitate: metoda pentru a determina valoarea dobandei lunare
    //pe care o plateste persoana in functie de valoarea imprumutului si de procentul
    //ce reprezinta dobanda anuala. Consideram pentru comoditate ca o luna are 30 de zile
    //iar un an 360(aceasta formula se foloseste si in practica de catre banci).
    float DobandaLunara();
    ~ImprumutCuDobandaFixa();
};

#endif // IMPRUMUTCUDOBANDAFIXA_HPP_INCLUDED
