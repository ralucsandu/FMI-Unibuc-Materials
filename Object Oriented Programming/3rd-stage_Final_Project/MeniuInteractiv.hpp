#ifndef MENIUINTERACTIV_HPP_INCLUDED
#define MENIUINTERACTIV_HPP_INCLUDED
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
#include <set>
#include <vector>
#include <list>
#include <map>
#include <iostream>
#include <fstream>
class MeniuInteractiv
{
private:
    static MeniuInteractiv *obiect;
public:
    static MeniuInteractiv* getInstance()
    {
        if(!obiect)
            obiect=new MeniuInteractiv();
        return obiect;
    }
///Functie TEMPLATE
    template <class Type>
    void sortare(Type v[], int n)
    {
        for(int i=0; i<n; i++)
            for(int j=i+1; j<n; j++)
                if(v[i]> v[j])
                    swap(v[i], v[j]);
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
    void meniu()
    {
        ///STL-uri
        list <Utilizator*> ListaUtilizatori;
        vector <Admin*> VectorAdmini;
        map <int,Imprumut> MapImprumuturi;
        set <Cont*> SetConturi;
        list <Tranzactie*> ListaTranzactii;

        int k=1;
        int cheie=0;
        while(k==1)
        {
            Admin x;
            x.proiect();
            cout<<"\nApasati una din urmatoarele taste:\n";
            cout<<"--------------------------------------------------\n";
            cout<<"1 : Import utilizator\n";
            cout<<"2 : Export utilizator\n";
            cout<<"3 : Functionalitate utilizator\n";
            cout<<"4 : Import admin\n";
            cout<<"5 : Citeste admin din fisier\n";
            cout<<"6 : Export admin\n";
            cout<<"7 : Functionalitate admin\n";
            cout<<"8 : Import imprumut\n";
            cout<<"9 : Export imprumut\n";
            cout<<"10 : Functionalitate imprumut\n";
            cout<<"11 : Testeaza functie TEMPLATE\n";
            cout<<"12 : Import cont\n";
            cout<<"13 : Export cont\n";
            cout<<"14 : Functionalitate cont\n";
            cout<<"15 : Testeaza ContDeEconomii\n";
            cout<<"16 : Import tranzactie\n";
            cout<<"17 : Export tranzactie\n";
            cout<<"18 : Functionalitate tranzactie\n";
            cout<<"19 : Functionalitate ATM\n";
            cout<<"20 : Testeaza ATM extragere\n";
            cout<<"21 : Testeaza ATM depunere\n";
            cout<<"22 : Testeaza ImprumutCuDobandaFixa\n";
            cout<<"23 : EXIT\n\n";
            int comanda;
            cin>>comanda;
            switch(comanda)
            {
            case 1:
            {
                Utilizator* u=new Utilizator;
                cin>>*u;
                ListaUtilizatori.push_back(u);
                cout<<"Importul a fost realizat cu succes!\n";
                break;
            }
            case 2:
            {
                ofstream g2("utilizator.out");
                list <Utilizator*>::iterator it;
                for(it=ListaUtilizatori.begin(); it!=ListaUtilizatori.end(); ++it)
                    g2<<*(*it)<<"\n\n";
                cout<<"Exportul s-a realizat cu succes! Verificati fisierul de iesire!\n\n";
                g2.close();
                break;
            }
            case 3:
            {
                list <Utilizator*>::iterator it;
                for(it=ListaUtilizatori.begin(); it!=ListaUtilizatori.end(); ++it)
                    if((*it)->inCateLuniSeVaPuteaRestituiImprumutul()==1)
                        cout<<"Utilizatorul isi va putea restitui imprumutul intr-o luna\n";
                    else if ((*it)->inCateLuniSeVaPuteaRestituiImprumutul()==0)
                        cout<<"Utilizatorul nu are imprumuturi\n";
                    else
                        cout<<"Utilizatorul isi va putea restitui imprumutul in " << (*it)->inCateLuniSeVaPuteaRestituiImprumutul()<< " luni\n";
                cout<<endl;
                break;
            }
            case 4:
            {
                Admin* a=new Admin;
                cout<<"Introduceti parola adminului: ";
                cin>>*a;
                VectorAdmini.push_back(a);
                cout<<"Importul a fost realizat cu succes!\n";
                break;
            }
            case 5:
            {
                ifstream f1("admin.in");
                ofstream g1("admin.out");
                Admin a;
                f1>>a;
                cout<<"Parola adminului citit din fisier a fost introdusa cu succes, iar in fisierul de iesire se vor afisa datele acestuia!\n\n";
                g1<<a;
                Admin b;
                cout<<"Introduceti parola adminului citit de la tastatura: ";
                cin>>b;
                g1<<b;
                cout<<"\nAdminii au fost adaugati cu succes!\n\nVerificati fisierul de iesire pentru a vedea datele acestora!\n\n";
                f1.close();
                g1.close();
                break;
            }
            case 6:
            {
                ofstream g1("admin.out");
                for(auto ir=VectorAdmini.begin(); ir!=VectorAdmini.end(); ++ir)
                    g1<<(*(*ir));
                cout<<"Exportul s-a realizat cu succes!\n\n";
                g1.close();
                break;
            }
            case 7:
            {
                Admin aux;
                Admin x;
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
                cout << "Citim parola celui de-al doilea admin:\n";
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
                cout<<"\n";
                if (x.verificaParola(parola)!=0)
                    cout << "Parola introdusa este corecta\n";
                else
                    cout << "Parola introdusa este gresita\n";
                cout<<endl;
                x.afiseaza_date();
                cout<<"\n";
                break;
            }
            case 8:
            {
                Imprumut i;
                cin>>i;
                MapImprumuturi.insert(pair<int,Imprumut>(cheie++,i));
                cout<<"Importul a fost realizat cu succes!\n\n";
                break;
            }
            case 9:
            {
                ofstream g3("imprumut.out");
                map<int, Imprumut>::iterator iter;
                for (iter=MapImprumuturi.begin(); iter!=MapImprumuturi.end(); ++iter)
                {
                    g3<<"Valoare cheie map: "<<iter->first<<endl<<iter->second<<endl;
                    g3<<endl;
                }
                cout<<"Exportul s-a realizat cu succes!\n\n";
                g3.close();
                break;
            }
            case 10:
            {
                map<int, Imprumut>::iterator iter;
                for (iter=MapImprumuturi.begin(); iter!=MapImprumuturi.end(); ++iter)
                {
                    Imprumut imp;
                    imp=iter->second;
                    cout<<imp.CandTrebuieReturnat()<<"\n";
                }
                cout<<endl;
                break;
            }
            case 11:
            {
                cout<<"Se vor ordona crescator dupa valoare imprumuturile date prin constructor. Rezultatul obtinut este: \n\n";
                Imprumut v[4];
                v[0]=Imprumut(123, 0);
                v[1]=Imprumut(32134, 1);
                v[2]=Imprumut(500,2);
                v[3]=Imprumut(100, 3);
                sortare<Imprumut>(v,4);
                for(int i=0; i<4; i++)
                    cout<<v[i]<<"\n\n";
                break;
            }
            case 12:
            {
                Cont* con=new Cont;
                cin>>*con;
                SetConturi.insert(con);
                cout<<"Importul a fost realizat cu succes!\n\n";
                break;
            }
            case 13:
            {
                ofstream g4("cont.out");
                set<Cont*>::iterator itr;
                for (itr=SetConturi.begin(); itr!=SetConturi.end(); ++itr)
                    g4<<*(*itr)<<"\n\n";
                cout<<"Exportul s-a realizat cu succes!\n\n";
                g4.close();
                break;
            }
            case 14:
            {
                cout<<"Se va realiza un schimb valutar!\n";
                set<Cont*>::iterator itr;
                for (itr=SetConturi.begin(); itr!=SetConturi.end(); ++itr)
                    (*itr)->schimbValuta();
                cout<<"\n";
                break;
            }
            case 15:
            {
                test_ContDeEconomii();
                cout<<"\n\n";
                break;
            }
            case 16:
            {
                Tranzactie* tr=new Tranzactie;
                cin>>*tr;
                ListaTranzactii.push_back(tr);
                cout<<"Importul a fost realizat cu succes!\n\n";
                break;
            }
            case 17:
            {
                ofstream g5("tranzactie.out");
                list <Tranzactie*>::iterator it;
                for(it=ListaTranzactii.begin(); it!=ListaTranzactii.end(); ++it)
                    g5<<*(*it)<<"\n\n";
                g5.close();
                cout<<"Exportul s-a realizat cu succes!\n\n";
                break;
            }
            case 18:
            {
                list <Tranzactie*>::iterator it;
                for(it=ListaTranzactii.begin(); it!=ListaTranzactii.end(); ++it)
                    cout<<(*it)->convertToString()<<"\n";
                cout<<endl;
                break;
            }
            case 19:
            {
                list <ATM*> listaATMuri;
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
                        cout<<endl;
                        nr++;
                        break;
                    }
                    case 2:
                    {
                        ATMdeposit* atmD = new ATMdeposit;
                        listaATMuri.push_front(atmD);
                        cin>>*atmD;
                        cout<<endl;
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
                        cout<<"Ati cerut iesirea din functie!\n\n";
                        k=0;
                        break;
                    }
                    }
                }
                listaATMuri.clear(); //dezalocam memoria
                break;
            }
            case 20:
            {
                test_ATMextract();
                cout<<"\n\n";
                break;
            }
            case 21:
            {
                test_ATMdeposit();
                cout<<"\n\n";
                break;
            }
            case 22:
            {
                test_ImprumutCuDobandaFixa();
                cout<<"\n\n";
                break;
            }
            case 23:
            {
                cout<<"Ati cerut iesirea din meniul interactiv!";
                k=0;
                break;
            }
            }
        }
    }
};
MeniuInteractiv* MeniuInteractiv::obiect=0;

#endif // MENIUINTERACTIV_HPP_INCLUDED
