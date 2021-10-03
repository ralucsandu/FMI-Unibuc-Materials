#include <iostream>
#include <string>
#include "Utilizator.hpp"
#include "Imprumut.hpp"
#include "Tranzactie.hpp"
#include "Cont.hpp"
#include "Admin.hpp"
#include "ATM.hpp"
#include "ATMextract.hpp"
#include "ATMdeposit.hpp"
#include "ImprumutCuDobandaFixa.hpp"
#include "ContDeEconomii.hpp"
#include "Interfata.hpp"
#include "MeniuInteractiv.hpp"
#include <fstream>
#include <set>
#include <vector>
#include <list>
#include <map>
using namespace std;

/*void test_utilizator_STL()///MAP
{

    map <string, string> Utilizatori;
    Utilizatori.insert(std::pair<string, string>("Sandu", "Raluca"));
    Utilizatori.insert(std::pair<string, string>("Dima", "Camelia"));
    cout << "Numar de utilizatori adaugati in MAP: " << Utilizatori.size() << endl;

    cout << endl << "Acestia au numele, respectiv prenumele: " << endl;

    for (map<string, string>::iterator it = Utilizatori.begin(); it != Utilizatori.end(); ++it)
    {
        cout << (*it).first << " " << (*it).second << endl;
    }
}*/

/*void test_cont_STL()  ///SET
{
    Cont a(123, 2),b(345, 1),c(124,8),d(2, 9);
    set<Cont> s;
    s.insert(a);
    s.insert(b);
    s.insert(c);
    s.insert(d);

    cout<<"ID-urile conturilor din baza de date sunt, ordonate alfabetic: ";
    for (auto cont:s)
        cout<<cont.getNumarCont()<<" ";
    cout<<"\n";
    cout << "Dupa stergerea contului cu numarul "<<c.getNumarCont() <<", ID-urile ramase sunt: ";
    s.erase(c);
    for (auto cont:s)
        cout<<cont.getNumarCont()<<" ";
}
*/
void test_utilizator()
{
    ofstream g2("utilizator.out");
    Utilizator raluca;
    cin>>raluca;
    g2<<raluca;
    /*char c[]= {"Sandu"};
    char c2[]= {"Dima"};
    char c3[]= {"Popescu"};
    int* conturi=new int[2];
    conturi[0]=1234;
    conturi[1]=1235;
    int conturi2[]= {1233, 1234, 1235, 1236};
    string date[4]= {"0748259400", "ralu_ioana_99@yahoo.com", "Str. Berlin", "Nr. 13"};
    string date1[4]= {"0336805571", "raluca.sandu5@s.unibuc.ro", "Drumul Timonierului", "Nr. 8"};
    Utilizator z(c3, "Elena", true, 12378.3, 0.3, 'A', "6010421150028", 3050.5, 4, conturi2, date1, 20.0);
    Utilizator u(c,"Raluca",false, 0, 0,'C', "6010400029600",2300.0,2,conturi,date, 23);
    Utilizator b("Popescu", "Ana", 'C', "601040029300", date1);
    Utilizator u1;
    u1=u;
    cout<<Utilizator::NumarUtilizatori<<"\n";
    cout<<z.getNume()<<"\n";
    u.setNume(c2);

    cout<<u.getNume()<<"\n";
    cout<<u.getImpozit()<<"\n";
    cout<<u.getNrConturi()<<"\n";
    /*
    int* cont=u.getConturi();
    cout<<*cont;
    for (int i=0; i<u.getNrConturi(); i++)
    cout<<*(u.getConturi()+i)<<"\n";
    for (int i=0; i<4; i++)
    cout<<*(u.getDatePersonale()+i)<<"\n";

    u.setConturi(conturi2,4);
    u.setPrenume("Adi");
    cout<<u.getPrenume()<<"\n";
    for (int i=0; i<u.getNrConturi(); i++)
    cout<<*(u.getConturi()+i)<<"\n";
    //u.citire();
    //u.afisare();
    */
    //Utilizator z;
    Utilizator x;
    //cout<<"\n";
    cin>>x;
    cout<<"\nSe apeleaza metoda din Interfata\n";
    x.afiseaza_date();
    cout<<endl;
    x.proiect();
    //cout<<x.inCateLuniSeVaPuteaRestituiImprumutul()<<"\n";
    cout<<"\n";
    cout<<x;
    //cout<<u;
    cout<<"\n";
    //cin>>z;
    //cout<<z;
    if(x.inCateLuniSeVaPuteaRestituiImprumutul()==1)
        cout<<"Utilizatorul isi va putea restitui imprumutul intr-o luna";
    else if (x.inCateLuniSeVaPuteaRestituiImprumutul()==0)
        cout<<"Utilizatorul nu are imprumuturi";
    else
        cout<<"Utilizatorul isi va putea restitui imprumutul in " << x.inCateLuniSeVaPuteaRestituiImprumutul()<< " luni";
    cout<<"\n";
    Utilizator test;
    //cout<<(x>=z);
    //test=z-555;
    //cout<<test.getSalariuMediu();

}

void test_imprumut()
{
    /*Imprumut imp(3495.59, 1234);
    cout<<imp.getIdCont()<<"\n";
    cout<<"Valoarea initiala a imprumutului(in lei) este de: "<<imp.getValoareImprumut()<<"\n";
    imp.setValoareImprumut(200.45);
    cout<<"Valoarea imprumutului(in lei) dupa folosirea setter-ului este de: "<<imp.getValoareImprumut();
    Imprumut impr;
    cin>>impr;
    cout<<"\n";
    cout<<impr;*/

    // 5 ani, 9 luni, 3 zile
    Imprumut j(1204.89, 1119);
    Imprumut i("5,9,3", 234.5);
    cout<<i.getDurata() << "\n";
    --i;
    cout<<i.getDurata() << "\n";
    cout<<i.CandTrebuieReturnat();
    cout<<"\n";

    cout<<"Valoarea imprumutului ca numar intreg este "<<(int)j<<" lei";
    cout<<"\n";
}
void test_ImprumutCuDobandaFixa()
{
    ImprumutCuDobandaFixa imp;
    cin>>imp;
    //imp.setDobandaAnuala(2);
    cout<<imp;
    if(imp.DobandaLunara()!=false)
        cout<<"\nDobanda lunara pe care trebuie sa o plateasca utilizatorul care a facut imprumutul este de "<<imp.DobandaLunara()<<" lei";
    else
        cout<<"\nUtilizatorul nu are imprumuturi";
    cout<<"\n";

}
void test_cont()
{
    Cont c(1234,98);
    cout<<"ID-ul utilizatorului este "<< c.getIDutilizator()<<"\n";
    cout<<"Numarul contului este "<< c.getNumarCont()<<"\n";
    float sold[1]= {1293.0};
    Cont x(sold, "lei");
    cout<<"Soldul curent al contului este "<< x.getSoldCurent()<<"\n";
    cout<<"Valuta initiala este: "<<x.getValuta()<<"\n";
    x.schimbValuta();
    cout<<"\n";
    x.setValuta("lire");
    cout<<"Valuta dupa folositrea setter-ului este: "<<x.getValuta();
    cout<<"\n";
    //Cont x;
    //cin>>x;
    /*cout<<x-20;
    cout<<x+20;*/
    /*cout<<x;
    cout<<"\n";
    Cont y;
    cin>>y;
    x=y;
    cout<<"\n";
    cout<<x;*/
}
void test_ContDeEconomii() ///vector
{
    ContDeEconomii e;
    cin>>e;
    e.ParcurgereTranzactie();
    cout<<endl;
    e.calculeazaRoundUp();

    /*vector <Cont*> listaConturi;
    ContDeEconomii e1;
    ContDeEconomii e2;
    cin>>e1>>e2;
    listaConturi.push_back(&e1);
    listaConturi.push_back(&e2);
    cout <<"Informatiile referitoare la conturile introduse sunt urmatoarele:\n\n";
    for(auto ir=listaConturi.begin(); ir!=listaConturi.end(); ir++)
        cout<<"-ID cont: "<<(*ir)->getNumarCont()<<"\n"<<"-Sold curent initial cont: "<<(*ir)->getSoldCurent()<<"\n"<<"-Valuta: "<<(*ir)->getValuta()<<"\n-----------\n";*/
}
void test_admin()
{
    ifstream f1("admin.in");
    ofstream g1("admin.out");

    Admin a;
    f1>>a;
    g1<<a;

    Admin b;
    cout<<"Introduceti parola adminului citit de la tastatura: ";
    cin>>b;
    g1<<b;

    /*Admin aux;
    Admin x;
    x.proiect();
    cout<<"\n";
    Admin y;
    string parola = "";
    cout << "Citim parola primului admin:"<<"\n";
    cin>>x;
    cout << "x = " << x << "\n";
    cout<<"Parola curenta este: "<<x.getParola()<<"\n";
    x.setParola("245g");
    cout<<"Parola dupa folosirea setter-ului ar fi: "<< x.getParola();
    cout<<"\n";
    cout<<"\n";
    cout << "Citim parola celui de-al doilea admin:"<<"\n";
    cin >> y;
    cout << "y = " << y << "\n";
    cout<<"\n";
    cout << "Schimbam parola lui x astfel incat sa fie aceeasi cu a lui y"<<"\n";
    cout<<"\n";
    aux = x;
    x=y;
    cout << "x ar trebui sa fie de forma " << x << "\n";
    cout<<"\n";
    cout << "Introduceti noua parola a lui x: ";
    cin >> parola;
    if (x.verificaParola(parola)!=0)
        cout << "Parola introdusa este corecta";
    else
        cout << "Parola introdusa este gresita";
    cout<<"\n";
    cout<<endl;
    x.afiseaza_date();

    }
    */
}
void test_tranzactie()
{
    //Tranzactie t(256.4, 12345, "01.04.2001");
    //Tranzactie u(891.5, 23456, "02.06.1920");
    Tranzactie t(259.4, "01.03.2021", 1110, 2220, 123456);
    Tranzactie u(256.4, "20.03.2021", 1111, 2222, 123456);
    t.setIDcontCarePrimeste(219);
    t.setIDcontCareTrimite(300);
    cout<<t.getValoareTranzactie();
    cout<<"\n";
    cout<<t.getDataTranzactie();
    cout<<"\n";
    cout<< t.convertToString();
    cout<<"\n";
    Tranzactie raspuns;
    raspuns = 100.2+ t;
    cout<<raspuns.getValoareTranzactie();
    cout<<"\n";
    Cont c;
    cout<<c.getNumarTranzactii();
    c=c+t;
    cout<<c.getNumarTranzactii();
    cout<<"\n";
    c=c+raspuns;
    cout<<c.getNumarTranzactii();
    c=c+t;
    c=u+c;
    c.ParcurgereTranzactie();
    cout<<"\n";
    cout<<(t==u)<<"\n";
    Tranzactie aux;
    int index=1;
    if (c[index]==aux)
        cout<<"Tranzactia nu exista";
    else
        cout<<c[index];
    cout<<"\n";
    cout<<"\n";
    Tranzactie x;
    cin>>x;
    cout<<"\n";
    cout<<x;
}

void test_atm()
{
    /*ATMextract atmE;
    ATMdeposit atmD;
    cin>>atmE;
    cin>>atmD;
    list <ATM*> listaATMuri;
    listaATMuri.push_back(&atmE);
    listaATMuri.push_front(&atmD);
    list <ATM*>::iterator it;
    for(it=listaATMuri.begin(); it!=listaATMuri.end(); it++)
         cout<<*(*it)<<endl;*/

    list <ATM*> listaATMuri; ///varianta echivalenta cu cea comentata de mai jos, de acesta data folosind LIST din STL
    list <ATM*>::iterator it;
    int k=1;
    int nr=0;
    while(k==1)
    {
        cout<<"Apasati o tasta(1-ATM extragere, 2-ATM depunere, 3-Afiseaza ATM-uri, 4-STOP): ";
        int comanda;
        cin>> comanda;
        switch(comanda)
        {
        case 1:
        {
            ATMextract* atmE = new ATMextract;
            listaATMuri.push_back(atmE);
            cin>>*atmE;
            nr++;
            break;
        }
        case 2:
        {
            ATMdeposit* atmD = new ATMdeposit;
            listaATMuri.push_front(atmD);
            cin>>*atmD;
            nr++;
            break;
        }
        case 3:
        {
            if(nr==0)
                cout<<"Momentan nu ati introdus niciun ATM!";
            else
                for(it=listaATMuri.begin(); it!=listaATMuri.end(); ++it)
                    cout<<*(*it)<<endl;
            break;
        }
        case 4:
        {
            k=0;
            break;
        }

        }

    }
    listaATMuri.clear();


    /* ATM *listaATMuri[100];
     int k=1;
     int i=0;
     while(k==1)
     {
         cout<<"Apasati o tasta(1-ATM extragere, 2-ATM depunere, 3-Afiseaza ATM-uri, 4-STOP, ): ";
         int comanda;
         cin>> comanda;
         switch(comanda)
         {
         case 1:
         {
             listaATMuri[i]=new ATMextract();
             cin>>*listaATMuri[i];
             i++;
             break;
         }
         case 2:
         {
             listaATMuri[i]=new ATMdeposit();
             cin>>*listaATMuri[i];
             i++;
             break;
         }

         case 3:
         {
             if(i==0)
                 cout<<"Momentan nu ati introdus niciun ATM!";
             else
                 for(int j=0; j<i; j++)
                     cout<<*listaATMuri[j];

         }
         case 4:
         {
             k=0;
             break;
         }
         }
     }
     */
}
void test_ATMextract()
{
    string adresa1[2]= {"Bucuresti", "Drumul Timonierului Nr. 8"};
    ATMextract b=ATMextract(adresa1);
    float* sold1=new float{2500.0f};
    Cont c1(sold1, "lei");
    b.MakeTransaction(c1);
    delete sold1;
}

void test_ATMdeposit()
{
    string adresa[2]= {"Galati", "Strada Berlin Nr. 13"};
    ATMdeposit a=ATMdeposit(adresa);
    float* sold = new float{1293.0f};
    Cont c(sold, "lei");
    a.MakeTransaction(c);
    delete sold;
}
int main()
{
    MeniuInteractiv *meniulinteractiv=meniulinteractiv->getInstance();
    meniulinteractiv->meniu();
    return 0;
}
