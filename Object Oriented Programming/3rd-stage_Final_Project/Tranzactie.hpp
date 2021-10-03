#ifndef TRANZACTIE_HPP_INCLUDED
#define TRANZACTIE_HPP_INCLUDED
#include <iostream>
#include <stdlib.h>

using namespace std;

class Tranzactie
{
private:
    float valoareTranzactie;
    string dataTranzactie; //in formatul DD.MM.YYYY
    long idContCarePrimeste;
    long idContCareTrimite;
    int idTranzactie;
public:
//Constructorul de copiere:
    Tranzactie(const Tranzactie& tranz);
//Constructorul fara parametri:
    Tranzactie();
//Constructorul cu parametri:
    Tranzactie(float valoareTranzactie, int idTranzactie, string dataTranzactie);
    Tranzactie(long idContCarePrimeste, long idContCareTrimite);
    Tranzactie(float valoareTranzactie, string dataTranzactie, long idContCarePrimeste, long idContCareTrimite, int idTranzactie);
//Operatorul egal:
    Tranzactie& operator=(const Tranzactie& tranz);
//Operatorul  ==:
    bool operator==(const Tranzactie& t);
//Operatorul + la dreapta:
    Tranzactie operator+(float valoareAdaugata);
//Operatorul + la stanga:
    friend Tranzactie operator+(float valoareAdaugata, Tranzactie t);
//Operatorul << :
    friend ostream& operator<<(ostream& out, const Tranzactie& t);
//Operatorul >>:
    friend istream& operator>>(istream& in, Tranzactie& t);

//getters:
    float getValoareTranzactie();
    string getDataTranzactie();
    long getIDcontCareTrimite();
    long getIDcontCarePrimeste();
//setters:
    void setValoareTranzactie(float valoareTranzactie);
    void setDataTranzactie(string dataTranzactie);
    void setIDcontCareTrimite(long idContCareTrimite);
    void setIDcontCarePrimeste(long idContCarePrimeste);

///Functionalitate: metoda pentru convertirea unei tranzactii la string
    string convertToString();

//Destructorul:
    ~Tranzactie();
};
#endif // TRANZACTIE_HPP_INCLUDED
