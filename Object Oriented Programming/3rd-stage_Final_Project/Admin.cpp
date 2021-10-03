#include "Admin.hpp"
#include <iostream>
#include <string.h>

using namespace std;

long Admin::numarAdmini=0;

Admin::Admin(const Admin& administrator):idAdmin(administrator.idAdmin)
{
    this->parola=administrator.parola;
}
Admin::Admin():idAdmin(numarAdmini++)
{
    this->parola="default";
}
Admin::Admin(string parola):idAdmin(numarAdmini)
{
    this->parola=parola;
    numarAdmini++;
}

istream& operator>>(istream& in, Admin& a)
{
    //cout<<"Parola: ";
    in>>a.parola;
    return in;
}

/*ifstream& operator>>(ifstream& in, Admin& a)
{
    in>>a.parola;  //parola mea, adica a administratorului bazei de date
    return in;
}*/

ostream& operator<<(ostream& out, const Admin& a)
{
    out<<"{ID admin: "<<a.idAdmin<<", Parola: "<<a.parola << "}";
    out<<endl;
    return out;
}

/*ofstream& operator<<(ofstream& out, const Admin& a)
{
    out<<"ID-ul administratorului bazei de date este: "<<a.idAdmin<<endl<<"Parola administratorului bazei de date este: "<<a.parola << "\n";
    return out;
}*/

// seteaza parola adminului curent la parola altui admin
Admin& Admin::operator=(const Admin& administrator)
{
    if(this!=&administrator)
    {
        this->parola=administrator.parola;
    }
    return *this;
}
string Admin::getParola()
{
    return this->parola;
}
void Admin::setParola(string parola)
{
    this->parola=parola;
}
bool Admin::verificaParola(string parolaDeVerificat)
{
    return parola == parolaDeVerificat;
}
void Admin:: afiseaza_date()
{
    string parolaAscunsa="*";
    int nrCaractereParola=parola.size();
    for(int i=1; i<nrCaractereParola; i++)
        parolaAscunsa.push_back('*');
    cout<<"Adminul are ID-ul "<< this->idAdmin<< " si parola " << parolaAscunsa;
}
Admin::~Admin()
{
}
