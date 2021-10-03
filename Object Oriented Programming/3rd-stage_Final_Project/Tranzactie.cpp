#include "Tranzactie.hpp"
#include <iostream>
#include <stdlib.h>

Tranzactie::Tranzactie(const Tranzactie& tranz)
{
    this->valoareTranzactie=tranz.valoareTranzactie;
    this->dataTranzactie=tranz.dataTranzactie;
    this->idContCarePrimeste=tranz.idContCarePrimeste;
    this->idContCareTrimite=tranz.idContCareTrimite;
    this->idTranzactie=tranz.idTranzactie;
}
Tranzactie::Tranzactie()
{
    this->valoareTranzactie=0;
    this->dataTranzactie="00.00.0000";
    this->idContCarePrimeste=0;
    this->idContCareTrimite=0;
    this->idTranzactie=0;
}
Tranzactie::Tranzactie(float valoareTranzactie, string dataTranzactie, long idContCarePrimeste, long idContCareTrimite, int idTranzactie)
{
    this->valoareTranzactie=valoareTranzactie;
    this->dataTranzactie=dataTranzactie;
    this->idContCarePrimeste=idContCarePrimeste;
    this->idContCareTrimite=idContCareTrimite;
    this->idTranzactie=idTranzactie;
}
Tranzactie::Tranzactie(float valoareTranzactie, int idTranzactie, string dataTranzactie)
{
    this->valoareTranzactie=valoareTranzactie;
    this->dataTranzactie=dataTranzactie;
    this->idTranzactie=idTranzactie;
    this->idContCarePrimeste=0;
    this->idContCareTrimite=0;
}
Tranzactie::Tranzactie(long idContCarePrimeste, long idContCareTrimite)
{
    this->idContCarePrimeste=idContCarePrimeste;
    this->idContCareTrimite=idContCareTrimite;
    this->valoareTranzactie=0;
    this->dataTranzactie="00.00.0000";
    this->idTranzactie=0;
}
Tranzactie& Tranzactie::operator=(const Tranzactie& tranz)
{
    if(this!=&tranz)
    {
        this->valoareTranzactie=tranz.valoareTranzactie;
        this->dataTranzactie=tranz.dataTranzactie;
        this->idContCarePrimeste=tranz.idContCarePrimeste;
        this->idContCareTrimite=tranz.idContCareTrimite;
        this->idTranzactie=tranz.idTranzactie;
    }
    return *this;
}
bool Tranzactie:: operator==(const Tranzactie& t)
{
    if(this->idTranzactie==t.idTranzactie && this->valoareTranzactie==t.valoareTranzactie
            && this->dataTranzactie==t.dataTranzactie)
        return true;
    return false;
}
Tranzactie Tranzactie::operator+(float valoareAdaugata)
{
    Tranzactie suma(*this);
    suma.valoareTranzactie=suma.valoareTranzactie+valoareAdaugata;
    return suma;
}
Tranzactie operator+(float valoareAdaugata, Tranzactie t)
{
    t.valoareTranzactie=valoareAdaugata+t.valoareTranzactie;
    return t;
}
istream& operator>>(istream& in, Tranzactie& t)
{
    cout<<"Valoarea tranzactiei: ";
    in>>t.valoareTranzactie;
    cout<<"Data la care s-a efectuat tranzactia: ";
    in>>t.dataTranzactie;
    cout<<"ID-ul contului care a primit banii: ";
    in>>t.idContCarePrimeste;
    cout<<"ID-ul contului care a trimis banii: ";
    in>>t.idContCareTrimite;
    cout<<"ID-ul tranzactiei: ";
    in>>t.idTranzactie;
    return in;
}
ostream& operator<<(ostream& out, const Tranzactie& t)
{
    out<<"Valoarea tranzactiei: "<<t.valoareTranzactie<<endl;
    out<<"Data la care s-a efectuat tranzactia este: "<<t.dataTranzactie<<endl;
    out<<"ID-ul contului care a primit banii este: "<<t.idContCarePrimeste<<endl;
    out<<"ID-ul contului care a trimis banii este: "<<t.idContCareTrimite<<endl;
    out<<"ID-ul tranzactiei este: "<<t.idTranzactie;
    return out;
}
float Tranzactie:: getValoareTranzactie()
{
    return this->valoareTranzactie;
}
string Tranzactie::getDataTranzactie()
{
    return this->dataTranzactie;
}
long Tranzactie::getIDcontCareTrimite()
{
    return idContCareTrimite;
}
long Tranzactie::getIDcontCarePrimeste()
{
    return idContCarePrimeste;
}
void Tranzactie::setValoareTranzactie(float valoareTranzactie)
{
    this->valoareTranzactie=valoareTranzactie;
}
void Tranzactie::setDataTranzactie(string dataTranzactie)
{
    this->dataTranzactie=dataTranzactie;
}
void Tranzactie::setIDcontCareTrimite(long idContCareTrimite)
{
    this->idContCareTrimite = idContCareTrimite;
}
void Tranzactie::setIDcontCarePrimeste(long idContCarePrimeste)
{
    this->idContCarePrimeste = idContCarePrimeste;
}
string Tranzactie::convertToString()
{
    char sir[255] = "";
    //varianta 1:
    sprintf(sir, "In data de %s contul cu ID-ul %ld a primit %.2f lei de la contul cu ID-ul %ld",
            dataTranzactie.c_str(), idContCarePrimeste, valoareTranzactie, idContCareTrimite);

    return sir;

    //varianta 2:
    /*return "In data de " + dataTranzactie + " contul cu ID-ul " + to_string(idContCarePrimeste)
         + " a primit " + to_string(valoareTranzactie) + " lei de la contul cu ID-ul " + to_string(idContCareTrimite);*/
}
Tranzactie::~Tranzactie()
{
}
