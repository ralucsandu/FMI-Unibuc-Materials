#include "ATM.hpp"
#include <iostream>
using namespace std;

ATM::ATM()
{
    this->valoare=0;
    this->adresa[0]=" ";
    this->adresa[1]=" ";
    this->adresa[2]=" ";
}
ATM::ATM(float valoare, string adresa[3])
{
    this->valoare=valoare;
    for(int i=0; i<3; i++)
        this->adresa[i]=adresa[i];
}
ATM& ATM::operator=(const ATM& atm)
{
    if(this!=&atm)return *this;
    for(int i=0; i<3; i++)
        this->adresa[i]=atm.adresa[i];
    return *this;
}
ATM::ATM(const ATM& atm)
{
    this->valoare=atm.valoare;
    for(int i=0; i<3; i++)
        this->adresa[i]=atm.adresa[i];
}
ostream& ATM::AfisareVirtuala (ostream& out) const
{
    out<<"\nAdresa ATM-ului este: "<<'\n';
    out<<"  -Oras: "<< adresa[0]<<'\n';
    out<<"  -Strada: "<<adresa[1]<<'\n';
    out<<"  -Numarul strazii: "<<adresa[2];

    return out;
}
istream& ATM::CitireVirtuala(istream& in)
{
    cout<<"\nIntroduceti adresa ATM-ului: ";
    cout<<"\nIntroduceti orasul: ";
    in>>this->adresa[0];
    cout<<"Introduceti strada: ";
    in>>this->adresa[1];
    cout<<"Introduceti numarul strazii: ";
    in>>this->adresa[2];
    return in;
}
istream& operator>>(istream & in, ATM& atm)
{
    return atm.CitireVirtuala(in);
}
ostream& operator<<(ostream & out, const ATM& atm)
{
    return atm.AfisareVirtuala(out);
}
