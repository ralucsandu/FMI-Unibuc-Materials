#include "ImprumutCuDobandaFixa.hpp"
#include <iostream>
using namespace std;

ImprumutCuDobandaFixa::ImprumutCuDobandaFixa():Imprumut() //constructorul fara parametri
{
    this->valoareRata=0;
    this->dobandaAnuala=0;
}
ImprumutCuDobandaFixa::ImprumutCuDobandaFixa(float valoareImprumut, long idCont, double dobandaAnuala,
        float valoareRata): Imprumut(valoareImprumut, idCont)
{
    this->valoareRata=valoareRata;
    this->dobandaAnuala=dobandaAnuala;
}
ImprumutCuDobandaFixa::ImprumutCuDobandaFixa(const ImprumutCuDobandaFixa& imp):Imprumut(imp)
{
    this->valoareRata=imp.valoareRata;
    this->dobandaAnuala=imp.dobandaAnuala;
}
ImprumutCuDobandaFixa&ImprumutCuDobandaFixa:: operator=(const ImprumutCuDobandaFixa& imp)
{
    if(this!=&imp)
    {
        Imprumut::operator=(imp);
        this->valoareRata=imp.valoareRata;
        this->dobandaAnuala=imp.dobandaAnuala;
    }
    return *this;
}
ostream& operator<<(ostream& out, const ImprumutCuDobandaFixa& imp)
{
    out<<(Imprumut&)imp;
    out<<"\nRata lunara(lei): "<<imp.valoareRata<<"\n";
    out<<"Dobanda anuala: "<<imp.dobandaAnuala<<"\n";
    return out;
}
istream& operator>>(istream& in, ImprumutCuDobandaFixa& imp)
{
    cout<<"Valoare imprumut: ";
    in>>imp.valoareImprumut;
    cout<<"\nRata lunara(lei) ce trebuie platita: ";
    in>>imp.valoareRata;
    cout<<"Dobanda anuala(procent de tipul 0.x): ";
    in>>imp.dobandaAnuala;
    cout<<"\n";
    return in;
}
double ImprumutCuDobandaFixa::getDobandaAnuala()
{
    return this->dobandaAnuala;
}
float ImprumutCuDobandaFixa::getValoareRata()
{
    return this->valoareRata;
}
void ImprumutCuDobandaFixa::setDobandaAnuala(double dobandaAnuala)
{
    this->dobandaAnuala=dobandaAnuala;
}
void ImprumutCuDobandaFixa::setValoareRata(float valoareRata)
{
    this->valoareRata=valoareRata;
}
float ImprumutCuDobandaFixa::DobandaLunara()
{
    return (valoareImprumut*dobandaAnuala*30)/360;
}
ImprumutCuDobandaFixa::~ImprumutCuDobandaFixa()
{
}
