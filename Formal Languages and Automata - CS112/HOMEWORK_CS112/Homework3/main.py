import sys
#laborator in lucru
list_all_states=[]
def get_section(name, list_data_doc):
    flag = False
    list_return = [] #lista returnare

    for line in list_data_doc: #mergem pe linie in document
        if line == name + ":": #verificam sctiunile
            flag = True
            continue
        if line == "end": #sfarsit de secventa
            flag = False
        if flag == True:
            list_return.append(line) #adaugam linia la lista returnata

    return list_return #returnam lista

def load_config_file(file_name):
    list_data_doc = [] #lista in care se vor pune liniile din document fara liniile cu comentarii
    error=0 #pentru a afisa cat mai exact eroarea
    f = open(file_name)

    for line in f: #pentru fiecare linie din fisier
        line = line.strip().lower() #pentru fiecare linie facem caracterele mici si le separam
        if len(line) > 0 and line[0] != "#": #daca nu este comentariu sau linie goala
            list_data_doc.append(line) #adaugam linia in lista_document

    list_sigma = get_section("sigma", list_data_doc)
    list_states = get_section("states", list_data_doc)
    list_transitions = get_section("transitions", list_data_doc)

    list_all_states=[] #lista in care punem toate starile
    for state in list_states: #stari in lista starilor
        temporal_state=state.split(",")
        list_temporal_state=[] #lista pentru fiecare stare in parte
        list_temporal_state.append(temporal_state[0])#simbolul starii
        start_state=0#verificam daca este stare de start
        final_state=0#verificam daca este stare de final
        for caracter in temporal_state[1:]:#cautam pentru fiecare stare de la pozitia 1 in colo
            if caracter=="f":
                final_state=1
            if caracter=="s":
                start_state=1
        list_temporal_state.append(start_state) #adaugam starea de start
        list_temporal_state.append(final_state) #adaugam starea de final
        list_all_states.append(list_temporal_state) #adaugam lista starii care contine starea si daca este stare de start sau finala

    list_states=[] #o golesc pentru a o repopula corect

    for state in list_all_states:
        list_states.append(state[0])#se ia doar prima valoare

    if len(list_sigma) == 0 or len(list_states) == 0 or len(list_transitions) == 0:#daca lipseste o sectiune
        error = 1

    transition_ok = True

    for trans in list_transitions:
        tmp = trans.split(",")#trebuie sa facem split pe tranzitii
        if tmp[0] not in list_states or tmp[1] not in list_sigma or tmp[2] not in list_states:#se verifica daca prima si ultima valoare sunt din stari iar cea din mijoc daca se afla in alfabet
            transition_ok = False

    if transition_ok == False:
        error = 2

    return error, list_sigma, list_all_states, list_transitions


def dfa_compute(input_string,list_sigma,list_states,list_transitions):

    for state in list_states:
        if state[1]==1:#cautam starea de start
            current_state = state[0] #in current_state salvam starea care se afla pe primapozitie
    position=0 #retin pozitia
    ok=1

    while position<len(input_string) and ok==1:
        position_copy=position
        for transition in list_transitions:
            if(position ==len(input_string)): #daca s-a atins pozitia continua
                continue
            temporal_transition = transition.split(",")
            #print(temporal_transition)
            if temporal_transition[0] == current_state and temporal_transition[1] == input_string[position]:#verificam daca starea este cea curenta si verificam daca valoarea din mijlocul tranzitiei este caracterul din input de la pozitia poz
                current_state = temporal_transition[2]# starea curenta devine starea in care s-a ajuns
                position += 1 #crestem pozitia
                #print(position)


        if position ==position_copy: #daca s-a blocat pe undeva
            print("Didn't reach final state")
            ok = 0

    if ok==1:#daca s-a terminat de parcurs sirul verificam daca starea in care s-a ajuns este finala
        ok=0
        for state in list_states:
            if state[0]==current_state and state[2]==1:
                print("Accepted")
                ok = 1
        if ok==0:
            print("Unaccepted")
    return ok

l_test = []
for state in list_all_states:
    l_test.append(state[0])

def pg4():
    nr=1
    for i in range(0,len(l_test)):
        nr=nr*2
    nrpart=0
    while nrpart<nr:
        poz=1
        tmp=[]
        aux=nrpart
        while aux!=0:
            if aux%2:
                tmp.append(l_test[poz-1])
            poz=poz+1
            aux=aux//2
        nrpart=nrpart+1
        print(tmp)
pg4()
'''def convert_nfa_dfa(list_sigma,list_states,list_transitions):
    list_states_dfa=[]
    list_sigma_dfa=[]
    list_transitions_dfa=[]
    print(list_sigma)
    list_sigma_dfa=list_sigma
    return  list_sigma_dfa

    #in laborator s-a specificat sa nu se ia in considerare tranzitiile cu epsilon (pentru a ne usura munca)
    #list_states_dfa.append(list_states[0])
    #list_states_dfa.append("s")
    '''
#main


error, list_sigma,list_states,list_transitions=load_config_file(sys.argv[1])
if error!=0:
    print("config file ",sys.argv[1],"is not valid error:", error)
    exit()
else:
    print("config file ", sys.argv[1],"is valid")
string_input="bba"
status_accept=dfa_compute(string_input,list_sigma,list_states,list_transitions)
print ("string",string_input,"status accept: ",status_accept)
print(list_sigma)
print(list_states)
print(list_transitions)
'''list_alf=[]
list_alf= convert_nfa_dfa(list_sigma,list_states,list_transitions)
print(list_alf)'''
