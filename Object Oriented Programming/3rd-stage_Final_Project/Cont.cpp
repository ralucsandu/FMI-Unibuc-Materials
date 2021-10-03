#include "Cont.hpp"

#include <iostream>

bool Cont:: operator<(const Cont& c) const
{
    return numarCont<c.numarCont;
}
Cont::Cont(const Cont& account)
{
    this->numarCont=account.numarCont;
    this->idUtilizator=account.idUtilizator;
    this->soldCurent=new float;
    this->soldCurent=account.soldCurent;
    this->valuta=account.valuta;
    this->numarTranzactii = account.numarTranzactii;
    this->tranzactii=new Tranzactie[numarTranzactii];
    for(int i=0; i<account.numarTranzactii; i++)
        this->tranzactii[i]=account.tranzactii[i];
}
Cont::Cont()
{
    this->numarCont=0;
    this->idUtilizator=0;
    this->soldCurent=NULL;
    this->valuta="lei";
    this->numarTranzactii = 0;
    this->tranzactii=NULL;
}
Cont::Cont(long numarCont, int idUtilizator)
{
    this->numarCont=numarCont;
    this->idUtilizator=idUtilizator;
    this->soldCurent=NULL;
    this->valuta="lei";
    this->numarTranzactii = 0;
    this->tranzactii=NULL;
}
Cont::Cont(float* soldCurent, string valuta)
{
    this->soldCurent=new float;
    this->soldCurent[0]=soldCurent[0];
    this->valuta=valuta;
    this->numarCont=0;
    this->idUtilizator=0;
    this->numarTranzactii = 0;
    this->tranzactii=NULL;
}
istream& operator>>(istream& in, Cont& c)
{
    cout<<"Numarul contului: ";
    in>>c.numarCont;
    cout<<"ID-ul utilizatorului: ";
    in>>c.idUtilizator;
    cout<<"Soldul curent al contului este: ";
    if (c.soldCurent!=NULL)
        delete c.soldCurent;
    c.soldCurent=new float;
    in>>*(c.soldCurent);
    cout<<"Valuta: ";
    in>>c.valuta;
    cout << "Nr. tranzactii: ";
    in >> c.numarTranzactii;
    if(c.tranzactii!=NULL)
        delete[] c.tranzactii;
    c.tranzactii = new Tranzactie[c.numarTranzactii];
    for (int i =0; i < c.numarTranzactii; i++)
        in >> c.tranzactii[i];
    return in;
}
ostream& operator<<(ostream& out, const Cont& c)
{
    out<<"Numarul contului: "<<c.numarCont<<"\n";
    out<<"ID-ul utilizatorului: "<<c.idUtilizator<<"\n";
    out<<"Soldul curent este: "<<*(c.soldCurent)<<"\n";
    out<<"Valuta: "<<c.valuta;
    return out;
}
Tranzactie Cont::operator[](int index) //operatorul de indexare
{
    if(0<=index && index<this->numarTranzactii)
        return tranzactii[index];
    else
    {
        Tranzactie t;
        return t;
    }
}
Cont& Cont::operator=(const Cont& account)
{
    if(this!=&account)
    {
        if(this->soldCurent!=NULL)
            delete this->soldCurent;
        this->numarCont=account.numarCont;
        this->idUtilizator=account.idUtilizator;
        this->soldCurent=new float;
        this->soldCurent=account.soldCurent;
        this->valuta=account.valuta;
        this->numarTranzactii = account.numarTranzactii;
        this->tranzactii=new Tranzactie[numarTranzactii];
        for(int i=0; i<account.numarTranzactii; i++)
            this->tranzactii[i]=account.tranzactii[i];
    }
    return *this;
}

Cont operator+(Cont cont, const Tranzactie& tranzactie)
{
    Tranzactie* listaTranzactii;
    listaTranzactii = new Tranzactie[cont.numarTranzactii];
    for(int i=0; i<cont.numarTranzactii; i++)
        listaTranzactii[i] = cont.tranzactii[i];
    if(cont.tranzactii!=NULL)
        delete[] cont.tranzactii;
    cont.numarTranzactii++;
    cont.tranzactii = new Tranzactie[cont.numarTranzactii];
    for(int i=0; i<cont.numarTranzactii-1; i++)
        cont.tranzactii[i] = listaTranzactii[i];
    cont.tranzactii[cont.numarTranzactii-1]=tranzactie;
    return cont;
}
Cont operator+( const Tranzactie& tranzactie, const Cont& cont)
{
    Cont aux(cont);
    Tranzactie* listaAux;
    listaAux=new Tranzactie[aux.numarTranzactii];
    for(int i=0; i<aux.numarTranzactii; i++)
        listaAux[i]=aux.tranzactii[i];
    if(aux.tranzactii!=NULL)
        delete[] aux.tranzactii;
    aux.numarTranzactii++;
    aux.tranzactii=new Tranzactie[aux.numarTranzactii];
    for(int i=0; i<aux.numarTranzactii-1 ; i++)
        aux.tranzactii[i]=listaAux[i];
    aux.tranzactii[aux.numarTranzactii-1]=tranzactie;
    return aux;
}
float Cont::getSoldCurent()
{
    return *soldCurent;
}
int Cont::getNumarTranzactii()
{
    return numarTranzactii;
}
string Cont::getValuta()
{
    return this->valuta;
}
long Cont::getNumarCont()
{
    return this->numarCont;
}
int Cont::getIDutilizator()
{
    return this->idUtilizator;
}
void Cont::setSoldCurent(float* sold)
{
    if(this->soldCurent!=NULL)
        delete soldCurent;
    this->soldCurent=new float;
    *(this->soldCurent)=*sold;
}
void Cont::setValuta(string valuta)
{
    this->valuta=valuta;
}
void Cont::schimbValuta()
{
    double LeuToEuro=0.2046504, EuroToLeu=4.8865, LeuToDollar=0.24498, DollarToLeu=4.0821,
           LeuToLira=0.17559, LiraToLeu=5.6953, EuroToDollar=1.1971, DollarToEuro=0.83537;
    int cod;
    //1 pentru conversia din leu in euro
    //2 pentru conversia din euro in leu
    //3 pentru conversia din leu in dolar
    //4 pentru conversia din dolar in leu
    //5 pentru conversia din leu in lira
    //6 pentru conversia din lira in leu
    //7 pentru conversia din euro in dolar
    //8 pentru conversia din dolar in euro
    cout<<"Introduceti codul schimbului valutar astfel: "<<'\n'<<"1 pentru conversia din leu in euro"
        <<'\n'<<"2 pentru conversia din euro in leu"<<"\n"<<"3 pentru conversia din leu in dolar"
        <<'\n'<<"4 pentru conversia din dolar in leu"<<'\n'<<"5 pentru conversia din leu in lira"
        <<'\n'<<"6 pentru conversia din lira in leu"<<'\n'<<"7 pentru conversia din euro in dolar"
        <<'\n'<<"8 pentru conversia din dolar in euro";
    cout<<"\n";
    cin>>cod;
    switch (cod)
    {
    case 1:
        cout<<"Suma "<<*(soldCurent)<<" lei este echivalenta cu "<< *(soldCurent)*LeuToEuro << " euro";
        break;
    case 2:
        cout<<"Suma "<<*(soldCurent)<<" euro este echivalenta cu "<<*(soldCurent)*EuroToLeu<<" lei";
        break;
    case 3:
        cout<<"Suma "<<*(soldCurent)<<" lei este echivalenta cu "<<*(soldCurent)*LeuToDollar<<" dolari";
        break;
    case 4:
        cout<<"Suma "<<*(soldCurent)<<" dolari este echivalenta cu "<<*(soldCurent)*DollarToLeu<<" lei";
        break;
    case 5:
        cout<<"Suma "<<*(soldCurent)<<" lei este echivalenta cu "<<*(soldCurent)*LeuToLira<<" lire sterline";
        break;
    case 6:
        cout<<"Suma "<<*(soldCurent)<<" lire sterline este echivalenta cu "<<*(soldCurent)*LiraToLeu<<" lei";
        break;
    case 7:
        cout<<"Suma "<<*(soldCurent)<<" euro este echivalenta cu "<<*(soldCurent)*EuroToDollar<<" dolari";
        break;
    case 8:
        cout<<"Suma "<<*(soldCurent)<<" dolari este echivalenta cu "<<*(soldCurent)*DollarToEuro<<" euro";
        break;
    }
}
void Cont::ParcurgereTranzactie()
{
    for (int i=0; i<numarTranzactii; i++)
        cout<<tranzactii[i]<<"\n";
}
void Cont::getTranzactiiCareIes(Tranzactie tranzactiiCareIes[], int &numarTranzactiiCareIes)
{
    //cout << "numarTranzactii = " << numarTranzactii << "\n"; //am folosit asta pentru debugging
    numarTranzactiiCareIes = 0;
    for (int i = 0; i < numarTranzactii; i++)
    {
        //cout << "idcontcaretrimite = " << tranzactii[i].getIDcontCareTrimite() << " numarCont = " << numarCont <<"\n"; //am folosit asta pentru debugging
        if (tranzactii[i].getIDcontCareTrimite() == numarCont)
        {
            //cout << "gasit tranzactie care iese" << endl; //am folosit asta pentru debugging
            //cout << "Numar de tranzactii care ies din cont = " << numarTranzactiiCareIes << endl; //am folosit asta pentru debugging
            tranzactiiCareIes[numarTranzactiiCareIes] = tranzactii[i];
            numarTranzactiiCareIes++;
        }
    }
}
Cont::~Cont()
{
    if(this->soldCurent!=NULL)
        delete this->soldCurent;
    if(this->tranzactii!=NULL)
        delete[] this->tranzactii;
}
