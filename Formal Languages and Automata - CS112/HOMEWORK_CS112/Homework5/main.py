import sys
def get_section(name,l_gen):
    flag = False
    l_ret = []

    for line in l_gen:
        if line == name+':':
            flag = True
            continue #trece peste celelalte if-uri si se duce inapoi in for
        if line == "end":
            flag = False
        if flag == True:
                l_ret.append(line)
    return  l_ret

def validate(file_name):
    l_gen = []
    if len(file_name) > 1:
        f = open(file_name,'r')
    else:
        #0= totul e corect, 1= nu exista fisier, 2=nu avem sectiune, 3= tranzițiile au erori
        # 4= stari finale/initiale definite incorect
        return 1

    for line in f:
        line = line.strip().lower()
        if len(line) > 0:
            l_gen.append(line)

    l_states = get_section("states", l_gen)
    l_sigma = get_section("sigma", l_gen)
    l_gamma = get_section("gamma", l_gen)
    l_transitions = get_section("transitions", l_gen)

    if len(l_gamma)==0 or len(l_sigma) == 0 or len(l_states) == 0 or len(l_transitions) == 0:
        return 2

    l_start=[] #starea de start
    l_final=[] #stari finale
    l_states_aux=[] #se creeaza o lista care contine doar numele starilor, nu si tipul lor
    for state in l_states:
        state = state.split(" ")
        if len(state)>1:
            if state[1] == 's' and len(l_start) == 0:
                l_start.append(state[0])
            elif state[1] == 'f':
                l_final.append(state[0])
            else:
                return 4
        l_states_aux.append(state[0])
    l_states=l_states_aux
    #print(l_states) #afisari pt verificare
    #print(l_start)
    #print(l_final)

    if len(l_start) == 0 or len(l_final) == 0:
        return 4

    trans_ok = True
    for trans in l_transitions:
        tmp = trans.split(" ")

        if tmp[0] not in l_states or tmp[1] not in l_gamma or tmp[2] not in l_states or (tmp[3] not in l_gamma and tmp[3] != 'e') or (tmp[4] != 'l' and tmp[4] !='r') :
            trans_ok = False
            # daca primul element din tranzitie nu este in lista de stari sau
            # daca al doilea element nu se afla in limbajul de pe banda sau
            # daca al treilea element nu este in lista de stari sau
            # daca al patrulea element nu se afla in limbajul benzii si nu este nici 'e' ( nu se modifica banda) sau
            # daca ultimul element nu este l(left)  sau r (right)
            # inseamna ca tranzitia este incorecta
    if trans_ok == False:
        return 3
    else:
        return 0
 #0= totul e corect, 1= nu exista fisier, 2=nu avem sectiune, 3= tranzițiile au erori
        # 4= stari finale/initiale definite incorect

def load_config_file(file_name): # aceasta functie returneaza listele specifice unei masini Turing sau
                                 # mesajele corespunzatoare erorilor intalnite
    if validate(file_name) == 0:
        l_gen = []
        if len(file_name) > 1:
            f = open(file_name, 'r')

        for line in f:
            line = line.strip().lower()
            if len(line) > 0:
                l_gen.append(line)

        l_states = get_section("states", l_gen)
        l_sigma = get_section("sigma", l_gen)
        l_gamma = get_section("gamma", l_gen)
        l_transitions = get_section("transitions", l_gen)
        l_start = []
        l_final = []
        l_states_aux = []
        for state in l_states:
            state = state.split(" ")
            if len(state) > 1:
                if state[1] == 's' and len(l_start) == 0:
                    l_start.append(state[0])
                else:
                    if state[1] == 'f':
                        l_final.append(state[0])

            l_states_aux.append(state[0])
        l_states = l_states_aux
        print (l_start[0])
        return l_states,l_start,l_final,l_sigma,l_gamma,l_transitions


    elif validate(file_name) == 1:
        print("Invalid configuration file: Missing file")
        return
    elif validate(file_name) == 2:
        print("Invalid configuration file: Section missing")
        return
    elif validate(file_name) == 3:
        print("Invalid configuration file: Incorrect transitions")
        return
    else:
        print("Invalid configuration file: Incorrect start/final states")
        return

def turing_simulator(input_string, l_start, l_final, l_transitions):
    accept = l_final[0] #stare de accept
    reject = l_final[1] #stare de reject
    current_state = l_start[0] #se porneste de la starea de start
    tape = [x for x in input_string]
    tape.append('_') #se adauga spatiu pentru a verifica daca se ajunge in stare de accept
    i = 0 #index care arata unde este capul de citire/scriere al masinii
    while current_state != accept and current_state != reject:
        for trans in l_transitions:
            trans=trans.split()
            if trans[0] == current_state:
                if tape[i] == trans[1]: #daca s-a gasit o tranzitie din starea curenta cu simbolul la care s-a ajuns pe banda
                    current_state = trans[2]
                    if trans[3] != 'e':
                        tape[i] = trans[3]
                    if trans[4] == 'l' and i != 0: # daca ultimul element este l atunci se decremeneteaza indicele pentru a se deplasa spre stanga
                        i = i - 1
                    elif i < len(tape): #altfel se incrementeaza
                        i = i + 1
    if current_state == reject:
        return 'Rejected'
    if current_state == accept:
        return 'Accepted'


if load_config_file(sys.argv[1])!=None:
    l_states, l_start, l_final, l_sigma, l_gamma, l_transitions=load_config_file(sys.argv[1])
    input_string = '0000'
    result = turing_simulator(input_string,l_start, l_final, l_transitions)
    print(result)

#teste pentru functia validate
#er=validate(sys.argv[1])
'''if (er == 0 ):
    print("Valid configuration file")
elif er == 1:
    print("Invalid configuration file: Missing file")
elif er == 2:
    print("Invalid configuration file: Section missing")
elif er == 3:
    print("Invalid configuration file: Incorrect transitions")
else:
    print("Invalid configuration file: Incorrect start/final states")'''