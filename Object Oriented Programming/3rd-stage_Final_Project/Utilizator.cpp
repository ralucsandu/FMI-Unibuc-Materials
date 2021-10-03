#include "Utilizator.hpp"

#include <iostream>

Utilizator::Utilizator(const Utilizator& user):IDutilizator(user.IDutilizator)
{
    this->numarConturi=user.numarConturi;
    this->Nume=new char[strlen(user.Nume)+1];
    strcpy(this->Nume, user.Nume);
    this->Prenume=user.Prenume;
    this->AreImprumuturi=user.AreImprumuturi;
    this->ValoareImprumut=user.ValoareImprumut;
    this->Procent=user.Procent;
    this->InitialaTata=user.InitialaTata;
    this->Cnp=user.Cnp;
    this->SalariuMediu=user.SalariuMediu;
    this->Impozit=user.Impozit;

    this->Conturi=new int[user.numarConturi];
    for(int i=0; i<user.numarConturi; i++)
        this->Conturi[i]=user.Conturi[i];
    this->DatePersonale=new string[4];
    for(int i=0; i<4; i++)
        this->DatePersonale[i]=user.DatePersonale[i];
}
Utilizator::Utilizator():IDutilizator(NumarUtilizatori++)
{
    this->numarConturi=0;
    this->Nume=new char[strlen("Necunoscut")+1];
    strcpy(this->Nume, "Necunoscut");
    this->Prenume="Necunoscut";
    this->Procent=0;
    this->ValoareImprumut=0;
    this->AreImprumuturi=false;
    this->InitialaTata='z';
    this->Cnp="0000000000000";
    this->SalariuMediu=0;
    this->Conturi=NULL;
    this->DatePersonale=NULL;
    this->Impozit=0;
}
Utilizator::Utilizator(char* Nume,string Prenume,bool AreImprumuturi,double ValoareImprumut, float Procent, char InitialaTata,
                       string Cnp,float SalariuMediu,int numarConturi,int* Conturi,
                       string* DatePersonale,double Impozit):IDutilizator(NumarUtilizatori)
{
    this->Nume=new char[strlen(Nume)+1];
    strcpy(this->Nume, Nume);
    this->Prenume=Prenume;
    this->AreImprumuturi=AreImprumuturi;
    this->ValoareImprumut=ValoareImprumut;
    this->Procent=Procent;
    this->InitialaTata=InitialaTata;
    this->Cnp=Cnp;
    this->SalariuMediu=SalariuMediu;
    this->Impozit=Impozit;
    NumarUtilizatori++;
    this->numarConturi=numarConturi;
    this->Conturi=new int[numarConturi];
    for(int i=0; i<numarConturi; i++)
        this->Conturi[i]=Conturi[i];
    this->DatePersonale=new string[4];
    for(int i=0; i<4; i++)
        this->DatePersonale[i]=DatePersonale[i];
    this->Impozit=Impozit;
}
Utilizator::Utilizator(char* Nume, string Prenume, char InitialaTata, string Cnp, string* DatePersonale):IDutilizator(NumarUtilizatori++)
{
    this->Nume=new char[strlen(Nume)+1];
    strcpy(this->Nume, Nume);
    this->Prenume=Prenume;
    this->InitialaTata=InitialaTata;
    this->Cnp=Cnp;
    this->DatePersonale=new string[4];
    for(int i=0; i<4; i++)
        this->DatePersonale[i]=DatePersonale[i];
    this->Procent=0;
    this->ValoareImprumut=0;
    this->AreImprumuturi=false;
    this->SalariuMediu=0;
    this->Conturi=NULL;
    this->Impozit=0;
    this->numarConturi=0;
}
istream& operator>>(istream& in, Utilizator& u)
{
    cout<<"Nume: ";
    char auxnume[50];
    in>>auxnume;
    if(u.Nume!=NULL)
        delete[] u.Nume;
    u.Nume=new char[strlen(auxnume)+1];
    strcpy(u.Nume, auxnume);
    cout<<"Prenume: ";
    in>>u.Prenume;
    cout<<"Are imprumuturi [Introduceti 1 sau 0: 1-da | 0-nu]: ";
    in>>u.AreImprumuturi;
    if(u.AreImprumuturi==1)
    {
        cout<<"Valoarea imprumutului este de: ";
        in>>u.ValoareImprumut;
    }
    cout<<"Initiala tatalui: ";
    in>>u.InitialaTata;
    cout<<"CNP: ";
    in>>u.Cnp;
    cout<<"Salariul mediu al utilizatorului(in lei): ";
    in>>u.SalariuMediu;
    if(u.AreImprumuturi==1)
    {
        cout<<"Procentul pe care vrea sa il economiseasca din salariu pentru a putea restitui imprumutul este de: ";
        in>>u.Procent;
    }

    cout<<"Cate conturi are utilizatorul? ";
    in>>u.numarConturi;
    cout<<"ID-urile conturilor sunt: ";
    if (u.Conturi!=NULL)
        delete[] u.Conturi;
    u.Conturi=new int[u.numarConturi];
    for(int i=0; i<u.numarConturi; i++)
        in>>u.Conturi[i];
    if(u.DatePersonale!=NULL)
        delete[] u.DatePersonale;
    u.DatePersonale=new string[4];
    cout<<"Numar de telefon: ";
    in>>u.DatePersonale[0];
    cout<<"Adresa de mail: ";
    in>>u.DatePersonale[1];
    cout<<"Strada: ";
    in>>u.DatePersonale[2];
    cout<<"Numarul strazii: ";
    in>>u.DatePersonale[3];
    cout<<"Cat % impozit plateste utilizatorul la stat? ";
    in>>u.Impozit;
    return in;
}
ostream& operator<<(ostream& out, const Utilizator& u)
{
    out<<"ID utilizator: "<<u.IDutilizator<<"\n";
    out<<"Nume: "<<u.Nume<<"\n";
    out<<"Prenume: "<<u.Prenume<<"\n";
    out<<"Utilizatorul are imprumuturi: ";
    if(u.AreImprumuturi ==0)
        out<<"Nu";
    else
        out<<"Da";
    out<<"\n";
    if (u.ValoareImprumut>0)
        out<<"Valoarea imprumutului este de: "<<u.ValoareImprumut<<"\n";
    out<<"Initiala tatalui: "<<u.InitialaTata<<"\n";
    out<<"CNP: "<<u.Cnp<<"\n";
    out<<"Salariul mediu al utilizatorului: "<<u.SalariuMediu<<" lei"<<"\n";
    out<<"Utilizatorul are: "<<u.numarConturi<<" conturi"<<"\n";
    out<<"ID-urile conturilor sunt: ";
    if(u.numarConturi>1)
    {
        for(int i=0; i<u.numarConturi; i++)
            out<<u.Conturi[i]<<",";
        out.seekp(-1, ios_base::end);
    }
    else
        out<<u.Conturi[0];

    out<<" ";
    out<<"\n";
    out<<"Numar de telefon: "<<u.DatePersonale[0]<<"\n";
    out<<"Adresa de mail: "<<u.DatePersonale[1]<<"\n";
    out<<"Strada si numarul: "<<u.DatePersonale[2]<<" "<<u.DatePersonale[3];
    out<<"\n";
    out<<"Utilizatorul cu ID-ul " <<u.IDutilizator<< " plateste "<<u.Impozit << "% impozit la stat";

    return out;
}
bool Utilizator:: operator>=(const Utilizator& u)
{
    if(this->SalariuMediu>=u.SalariuMediu)
        return true;
    return false;
}
bool Utilizator:: operator<=(const Utilizator& u)
{
    if(this->SalariuMediu<=u.SalariuMediu)
        return true;
    return false;
}
long Utilizator::NumarUtilizatori=0;

char* Utilizator::getNume()
{
    return this->Nume;
}
string Utilizator::getPrenume()
{
    return this->Prenume;
}
int Utilizator::getIDutilizator()
{
    return this->IDutilizator;
}
bool Utilizator::getAreImprumuturi()
{
    return this->AreImprumuturi;
}
double Utilizator::getValoareImprumut()
{
    return this->ValoareImprumut;
}
float Utilizator::getProcent()
{
    return this->Procent;
}
char Utilizator::getInitialaTata()
{
    return this->InitialaTata;
}
string Utilizator::getCnp()
{
    return this->Cnp;
}
float Utilizator::getSalariuMediu()
{
    return this->SalariuMediu;
}
int* Utilizator::getConturi()
{
    return this-> Conturi;
}
int Utilizator::getNrConturi()
{
    return numarConturi;
}
string* Utilizator::getDatePersonale()
{
    return this->DatePersonale;
}
double Utilizator::getImpozit()
{
    return this->Impozit;
}
void Utilizator::setNume(char* Nume)
{
    if (this->Nume!=NULL)
        delete[] this->Nume;
    this->Nume=new char[strlen(Nume)+1];
    strcpy(this->Nume, Nume);
}
void Utilizator::setPrenume(string Prenume)
{
    this->Prenume=Prenume;
}
void Utilizator::setAreImprumuturi(bool AreImprumuturi)
{
    this->AreImprumuturi=AreImprumuturi;
}
void Utilizator::setValoareImprumut(double ValoareImprumut)
{
    this->ValoareImprumut=ValoareImprumut;
}
void Utilizator::setProcent(float Procent)
{
    this->Procent=Procent;
}
void Utilizator::setInitialaTata(char InitialaTata)
{
    this->InitialaTata=InitialaTata;
}
void Utilizator::setCnp(string Cnp)
{
    this->Cnp=Cnp;
}
void Utilizator::setSalariuMediu(float SalariuMediu)
{
    this->SalariuMediu=SalariuMediu;
}
void Utilizator::setConturi(int* conturi, int nr)
{
    this->numarConturi=nr;
    if(this->Conturi!=NULL)
        delete[] Conturi;
    this->Conturi=new int[nr];
    for(int i=0; i<nr; i++)
        this->Conturi[i]=conturi[i];
}
void Utilizator::setDatePersonale(string* date)
{
    if(this->DatePersonale!=NULL)
        delete[] DatePersonale;
    this->DatePersonale=new string[4];
    for(int i=0; i<4; i++)
        this->DatePersonale[i]=date[i];
}
void Utilizator::setImpozit(double Impozit)
{
    this->Impozit=Impozit;
}
Utilizator Utilizator::operator*(int valoareInmultita)
{
    Utilizator inmultire(*this);
    inmultire.SalariuMediu=inmultire.SalariuMediu*valoareInmultita;
    return inmultire;
}
Utilizator Utilizator::operator-(float valoareScazuta) //in cazul in care unui utilizator i se micsoreaza salariul
{
    Utilizator diferenta(*this);
    diferenta.SalariuMediu=diferenta.SalariuMediu-valoareScazuta;
    return diferenta;
}
Utilizator& Utilizator::operator=(const Utilizator& user)
{
    if(this!=&user)
    {
        if(this->Nume!=NULL)
            delete[] this->Nume;
        if(this->Conturi!=NULL)
            delete[] this->Conturi;

        if(this->DatePersonale!=NULL)
            delete[] this->DatePersonale;

        this->Nume=new char[strlen(user.Nume)+1];
        strcpy(this->Nume, user.Nume);

        this->Prenume=user.Prenume;
        this->AreImprumuturi=user.AreImprumuturi;
        this->ValoareImprumut=user.ValoareImprumut;
        this->Procent=user.Procent;
        this->InitialaTata=user.InitialaTata;
        this->Cnp=user.Cnp;
        this->SalariuMediu=user.SalariuMediu;
        this->Impozit=user.Impozit;

        this->Conturi=new int[user.numarConturi];
        for(int i=0; i<user.numarConturi; i++)
            this->Conturi[i]=user.Conturi[i];

        this->DatePersonale=new string[4];
        for(int i=0; i<4; i++)
            this->DatePersonale[i]=user.DatePersonale[i];
    }
    return *this;
}
int Utilizator:: inCateLuniSeVaPuteaRestituiImprumutul()
{
    if(ValoareImprumut>0)
        return ValoareImprumut/(Procent*SalariuMediu)+1;
    return false;
}
void Utilizator::afiseaza_date()
{
    cout<<"ID utilizator: "<<this->IDutilizator;
    cout<<"Nume: "<<this->Nume<<"\n";
    cout<<"Prenume: "<<this->Prenume<<"\n";
    cout<<"Initiala tatalui: "<<this->InitialaTata<<"\n";
    cout<<"CNP: "<<this->Cnp<<"\n";
    cout<<"Numar de telefon: "<<this->DatePersonale[0]<<"\n";
    cout<<"Adresa de mail: "<<this->DatePersonale[1]<<"\n";
    cout<<"Strada si numarul: "<<this->DatePersonale[2]<<" "<<this->DatePersonale[3]<<"\n";
}
void Utilizator::citire()
{
    cout<<"Nume: ";
    char auxnume[50];
    cin>>auxnume;
    if(this->Nume!=NULL)
        delete[] this->Nume;
    this->Nume=new char[strlen(auxnume)+1];
    strcpy(this->Nume, auxnume);
    cout<<"Prenume: ";
    cin>>this->Prenume;
    cout<<"Are imprumuturi [Introduceti 1 sau 0: 1-da | 0-nu]: ";
    cin>>this->AreImprumuturi;
    cout<<"Valoarea imprumutului: ";
    cin>>this->ValoareImprumut;
    cout<<"In fiecare luna utilizatorul va economisi urmatorul procent din salariu: ";
    cin>>this->Procent;
    cout<<"Initiala tatalui: ";
    cin>>this->InitialaTata;
    cout<<"CNP: ";
    cin>>this->Cnp;
    cout<<"Salariul mediu al utilizatorului(in lei): ";
    cin>>this->SalariuMediu;
    cout<<"Cate conturi are utilizatorul?";
    cin>>this->numarConturi;
    if(this->numarConturi!=0)
        cout<<"ID-urile conturilor sunt: ";
    if (this->Conturi!=NULL)
        delete[] this->Conturi;
    this->Conturi=new int[this->numarConturi];
    for(int i=0; i<this->numarConturi; i++)
        cin>>this->Conturi[i];
    cout<<"Numar de telefon: ";
    cin>>this->DatePersonale[0];
    cout<<"Adresa de mail: ";
    cin>>this->DatePersonale[1];
    cout<<"Strada si numarul: ";
    cin>>this->DatePersonale[2]>>this->DatePersonale[3];
    cout<<"Cat impozit plateste utilizatorul la stat?";
    cin>>this->Impozit;
}
void Utilizator::afisare()
{
    cout<<"ID utilizator: "<<this->IDutilizator;
    cout<<"Nume: "<<this->Nume<<"\n";
    cout<<"Prenume: "<<this->Prenume<<"\n";
    cout<<"Utilizatorul are imprumuturi: ";
    if(this->AreImprumuturi ==0)
        cout<<"Nu";
    else
        cout<<"Da";
    cout<<"\n";
    cout<<"Persoana are imprumuturi in valoare de(lei): "<<this->ValoareImprumut<<"\n";
    cout<<"Initiala tatalui: "<<this->InitialaTata<<"\n";
    cout<<"CNP: "<<this->Cnp<<"\n";
    cout<<"Salariul mediu al utilizatorului: "<<this->SalariuMediu<<" lei"<<"\n";
    cout<<"Utilizatorul are: "<<this->numarConturi<<" conturi"<<"\n";
    cout<<"ID-urile conturilor sunt: ";
    for(int i=0; i<this->numarConturi; i++)
        cout<<this->Conturi[i]<<",";
    cout<<'\b';
    cout<<" ";
    cout<<"\n";
    cout<<"Numar de telefon: "<<this->DatePersonale[0]<<"\n";
    cout<<"Adresa de mail: "<<this->DatePersonale[1]<<"\n";
    cout<<"Strada si numarul: "<<this->DatePersonale[2]<<" "<<this->DatePersonale[3];
    cout<<"\n";
    cout<<"Utilizatorul plateste "<<this->Impozit << "% impozit la stat";
}
Utilizator::~Utilizator()
{
    if(this->Nume!=NULL)
        delete[] this->Nume;
    if(this->Conturi!=NULL)
        delete[] this->Conturi;
    if(this->DatePersonale!=NULL)
        delete[] this->DatePersonale;
}
