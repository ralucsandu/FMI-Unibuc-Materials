#include "ATMextract.hpp"
#include <iostream>
using namespace std;

void ATMextract::MakeTransaction(Cont& cont)
{
    cout<<"Suma inainte de extragere din cont este: ";
    cout<<cont.getSoldCurent()<<'\n';
    cout<<"Introduceti suma pe care vreti sa o extrageti din cont: ";
    cin>>this->valoare;
    if(valoare<=cont.getSoldCurent())
    {
        float suma=cont.getSoldCurent()-valoare;
        cont.setSoldCurent(&suma);
        cout<<"Extragerea a fost realizata cu succes de la ATM-ul cu adresa " <<this->adresa[0]<< ", " <<this->adresa[1]<<'\n';
        cout<<"Soldul curent este acum: ";
        cout<<cont.getSoldCurent();
    }
    else
        cout<<"Extragerea nu se poate realiza.";
}
ATMextract::ATMextract():ATM() {}
ATMextract::ATMextract(const ATMextract& atm)
{
    for(int i=0; i<3; i++)
        this->adresa[i]=atm.adresa[i];
}
ATMextract::ATMextract(string adresa[3])
{
    for(int i=0; i<3; i++)
        this->adresa[i]=adresa[i];
}
ATMextract& ATMextract::operator=(const ATMextract& atm)
{
    if(this!=&atm) return *this;
    for(int i=0; i<3; i++)
        this->adresa[i]=atm.adresa[i];
    return *this;
}
ATMextract::~ATMextract()
{
}
istream& ATMextract::CitireVirtuala(istream& in)
{
    ATM::CitireVirtuala(in);
    return in;
}
ostream& ATMextract::AfisareVirtuala(ostream& out)const
{
    ATM::AfisareVirtuala(out);
    return out;
}
