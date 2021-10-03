#ifndef ADMIN_HPP_INCLUDED
#define ADMIN_HPP_INCLUDED
#include "Interfata.hpp"
#include <iostream>
#include <string.h>

using namespace std;

class Admin: public Interfata
{
private:
    const int idAdmin;
    string parola;
public:
    static long numarAdmini;
//Constructorul de copiere:
    Admin(const Admin& administrator);
//Constructorul fara parametri:
    Admin();
//Constructorul cu parametri:
    Admin(string parola);
//Operatorul egal:
    Admin& operator=(const Admin& administrator);
//Operatorul << :
    friend ostream& operator<<(ostream& out, const Admin& a);
    //friend ofstream& operator<<(ofstream& out, const Admin& a);
//Operatorul >>:
    friend istream& operator>>(istream& in, Admin& a);
    //friend ifstream& operator>>(ifstream& in, Admin& a);
//setter si getter pentru parola
    string getParola();
    void setParola(string parola);
///Functionalitate: metoda care testeaza daca parola introdusa de la tastatura corespunde cu parola adminului
    bool verificaParola(string parolaDeVerificat);
///Metoda care afiseaza ID-ul si parola unui admin, ascunzand parola(se vor afisa atatea stelute cate caractere are parola)
    void afiseaza_date();
//Destructorul:
    ~Admin();
};
#endif // ADMIN_HPP_INCLUDED
