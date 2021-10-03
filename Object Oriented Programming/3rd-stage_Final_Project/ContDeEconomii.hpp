#ifndef CONTDEECONOMII_HPP_INCLUDED
#define CONTDEECONOMII_HPP_INCLUDED
#include "Cont.hpp"
#include <iostream>
using namespace std;

///mostenirea clasei Cont
class ContDeEconomii: public Cont
{
private:
    double soldContEconomii;
public:
    ContDeEconomii();
    ContDeEconomii(double soldContEconomii);
    ContDeEconomii(const ContDeEconomii& c);
    ContDeEconomii& operator=(const ContDeEconomii& c);
    friend ostream& operator<<(ostream& out, const ContDeEconomii& c);
    //operatorul >> nu este necesar, deoarece ne folosim de cel existent in clasa Cont
    ///Functionalitate: metoda pentru a adauga bani in contul de economii de fiecare data cand utilizatorul face o plata
    ///Se va face o tranzactie de tip ROUND-UP - idee inspirata din aplicatia ING Bank
    void calculeazaRoundUp(); // calculeaza round-up
    ~ContDeEconomii();
};
#endif // CONTDEECONOMII_HPP_INCLUDED
