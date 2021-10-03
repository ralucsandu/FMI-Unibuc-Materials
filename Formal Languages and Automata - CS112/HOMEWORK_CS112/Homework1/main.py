import sys

def get_section(name, list_data_doc):# se preiau sectiunile din fisier si se retin intr-o lista
    flag = False
    list_return = []

    for line in list_data_doc:
        if line == name + ":":
            flag = True
            continue
        if line == "end":
            flag = False
        if flag == True:
            list_return.append(line)

    return list_return

def load_config_file(file_name): #se pune fiecare sectiune in lista ei
    list_data_doc = [] #lista datelor din document
    error=0
    f = open(file_name)

    for line in f:
        line = line.strip().lower()
        if len(line) > 0 and line[0] != "#":
            list_data_doc.append(line)

    list_sigma = get_section("sigma", list_data_doc)
    list_states = get_section("states", list_data_doc)
    list_transitions = get_section("transitions", list_data_doc)

    list_all_states=[]
    for state in list_states:
        temporal_state=state.split(",")
        list_temporal_state=[] #lista pentru fiecare stare in parte
        list_temporal_state.append(temporal_state[0])#simbolul starii
        start_state=0
        final_state=0
        for caracter in temporal_state[1:]:
            if caracter=="f":
                final_state=1
            if caracter=="s":
                start_state=1
        list_temporal_state.append(start_state)
        list_temporal_state.append(final_state)
        list_all_states.append(list_temporal_state)

    list_states=[] #se goleste pentru a o repopula corect

    for state in list_all_states:
        list_states.append(state[0])#se ia doar prima valoare

    if len(list_sigma) == 0 or len(list_states) == 0 or len(list_transitions) == 0:
        error = 1

    transition_ok = True

    for trans in list_transitions:
        tmp = trans.split(",")
        if tmp[0] not in list_states or tmp[1] not in list_sigma or tmp[2] not in list_states:
            transition_ok = False

    if transition_ok == False:
        error = 2

    return error, list_sigma, list_all_states, list_transitions

#main
error, list_sigma,list_states,list_transitions=load_config_file(sys.argv[1])
if error!=0:
    print("config file ",sys.argv[1],"is not valid error:", error)
    exit()
else:
    print("config file ", sys.argv[1],"is valid")
