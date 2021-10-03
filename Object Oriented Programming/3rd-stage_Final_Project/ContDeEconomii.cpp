#include "ContDeEconomii.hpp"
#include <iostream>
using namespace std;

ContDeEconomii::ContDeEconomii():Cont()
{
    this->soldContEconomii=0;
}
ContDeEconomii::ContDeEconomii(double soldContEconomii): Cont(soldCurent, valuta)
{
    this->soldContEconomii=soldContEconomii;
}
ContDeEconomii::ContDeEconomii(const ContDeEconomii& c):Cont(c)
{
    this->soldContEconomii=c.soldContEconomii;
}
ContDeEconomii&ContDeEconomii::operator=(const ContDeEconomii& c)
{
    if(this!=&c)
    {
        Cont::operator=(c);
        this->soldContEconomii=c.soldContEconomii;
    }
    return *this;
}
ostream& operator<<(ostream& out, const ContDeEconomii& c)
{
    out<<(Cont&)c;
    out<<"\nSoldul curent al contului de economii(lei), dupa round-up-uri: "<<c.soldContEconomii<<'\n';
    return out;
}
void ContDeEconomii::calculeazaRoundUp() // calculeaza round-up
{
    Tranzactie tranzactiiCareIes[numarTranzactii];
    int numarTranzactiiCareIes = 0;
    int vremEconomisire = 2;
    getTranzactiiCareIes(tranzactiiCareIes, numarTranzactiiCareIes);

    cout << "Numar de tranzactii care ies = " << numarTranzactiiCareIes << endl;

    float total_round_up = 0;

    for (int i=0; i<numarTranzactiiCareIes; i++)
    {
        total_round_up += (5-int(tranzactiiCareIes[i].getValoareTranzactie()) % 5);
        *soldCurent-=tranzactiiCareIes[i].getValoareTranzactie();
    }
    cout<<"Utilizatorul ar putea economisi "<<total_round_up<<" "<<valuta<<"\n";
    cout<<"Doriti economisirea? (1-da, 2-nu) ";
    cin >> vremEconomisire;

    if (vremEconomisire == 1)
    {
        soldContEconomii += total_round_up;
        *soldCurent -= total_round_up;
        cout<<"Dupa ROUND-up, soldul contului de economii va fi de "<< soldContEconomii<<"\n";
        cout <<"Dupa realizarea platilor si transferarea banilor din contul curent in contul de economii prin ROUND-up, soldul contului curent va fi de "<<*soldCurent<< " "<<valuta<<"\n";
    }
}
ContDeEconomii::~ContDeEconomii()
{
}
