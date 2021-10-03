#include "ATMdeposit.hpp"
#include <iostream>
using namespace std;

void ATMdeposit::MakeTransaction(Cont& cont)
{
    cout<<"Suma din cont inainte de depunere  este: ";
    cout<<cont.getSoldCurent()<<'\n';
    cout<<"Introduceti suma pe care vreti sa o depuneti in cont: ";
    cin>>this->valoare;
    if(valoare>0)
    {
        float suma=cont.getSoldCurent()+valoare;
        cont.setSoldCurent(&suma);
        cout<<"Depunerea a fost realizata cu succes la ATM-ul cu adresa " <<this->adresa[0]<< ", " <<this->adresa[1]<<'\n';
        cout<<"Soldul curent este acum: ";
        cout<<cont.getSoldCurent();
    }
    else
        cout<<"Depunerea nu se poate realiza.";
}
ATMdeposit::ATMdeposit():ATM() {}
ATMdeposit::ATMdeposit(const ATMdeposit& atm)
{
    for(int i=0; i<3; i++)
        this->adresa[i]=atm.adresa[i];
}
ATMdeposit::ATMdeposit(string adresa[3])
{
    for(int i=0; i<3; i++)
        this->adresa[i]=adresa[i];
}
ATMdeposit& ATMdeposit::operator=(const ATMdeposit& atm)
{
    if(this!=&atm) return *this;
    for(int i=0; i<3; i++)
        this->adresa[i]=atm.adresa[i];
    return *this;
}
ATMdeposit::~ATMdeposit()
{
}
istream& ATMdeposit::CitireVirtuala(istream& in)
{
    ATM::CitireVirtuala(in);
    return in;
}
ostream& ATMdeposit::AfisareVirtuala(ostream& out)const
{
    ATM::AfisareVirtuala(out);
    return out;
}
