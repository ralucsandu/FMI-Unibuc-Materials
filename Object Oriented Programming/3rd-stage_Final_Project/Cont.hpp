#ifndef CONT_HPP_INCLUDED
#define CONT_HPP_INCLUDED
#include <iostream>
#include <math.h>
#include "Tranzactie.hpp"

using namespace std;

class Cont
{
protected:
    float* soldCurent;
    string valuta;
    int numarTranzactii;
    Tranzactie* tranzactii; ///HAS A
private:
    long numarCont;
    int idUtilizator;
public:
    bool operator<(const Cont& c) const;
//Constructorul de copiere:
    Cont(const Cont& account);
//Constructorul fara parametri:
    Cont();
//Constructorul cu parametri:
    Cont(long numarCont, int idUtilizator);
    Cont(float* soldCurent, string valuta);
//Operatorul egal:
    Cont& operator=(const Cont& account);
//Operatorul << :
    friend ostream& operator<<(ostream& out, const Cont& c);
//Operatorul >>:
    friend istream& operator>>(istream& in, Cont& c);
//Operatorul matematic +
    Cont& operator+(float valoare)
    {
        *(this->soldCurent)+=valoare;
        return *(this);
    }
//Operatorul matematic -
    Cont& operator-(float valoare)
    {
        *(this->soldCurent)-=valoare;
        return *(this);
    }
// Operator + : Cont + Tranzactie
    friend Cont operator+(Cont cont, const Tranzactie& tranzactie);
// Operator + : Tranzactie + Cont
    friend Cont operator+(const Tranzactie& tranzactie, const Cont& cont );
//Operatorul de indexare
    Tranzactie operator[](int index);
//getters:
    float getSoldCurent();
    string getValuta();
    int getNumarTranzactii();
    long getNumarCont();
    int getIDutilizator();
//setters:
    void setSoldCurent(float* soldCurent);
    void setValuta(string valuta);
    void ParcurgereTranzactie();
///Functionalitate: metoda pentru schimb valutar:
    void schimbValuta();
///Functionalitate: metoda pentru a determina tranzactiile care ies din cont (platile):
    void getTranzactiiCareIes(Tranzactie tranzactiiCareIes[], int &numarTranzactiiCareIes);
//destructorul:
    ~Cont();
};

#endif // CONT_HPP_INCLUDED
