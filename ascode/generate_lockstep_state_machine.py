import os
import sys as ss
import ConfigParser
import ast
import pickle
import networkx as nx
from matplotlib import pyplot as plt
import pydot as pd

#os.system('cls' if os.name == 'nt' else 'clear')

def draw_dot(Interleaved_lts_machine, Interleaved_lts_machine_init, iter1, protocol_key):
    Interleaved_lts_graph = open('./dot/Interleaved_lts_graph_' + str(iter1) + '_' + protocol_key +'.dot', 'w') 
    Interleaved_lts_graph.write('digraph graphme {\n')
    Interleaved_lts_states = Interleaved_lts_machine.keys()
    #print Interleaved_lts_states
    #print Interleaved_lts_machine_init
    TotalNoEdges = 0
    for state in Interleaved_lts_states:
        #print "state: ", state
        if state == Interleaved_lts_machine_init[0]:
             Interleaved_lts_graph.write('\t\t' + state[0].replace(':', '_') + ' [style=\"filled\", fillcolor=\"green\"];')
        for j in Interleaved_lts_machine[state]:
            #print "j: ", j
            for k_ in Interleaved_lts_machine[state][j]:
                #print "k_: ", k_
                TotalNoEdges = TotalNoEdges + 1
                Interleaved_lts_graph.write('\t\t' + state[0].replace(':', '_') + ' -> ' + k_.replace(':', '_') + '[label=\"' + j + '\"];\n')
    Interleaved_lts_graph.write('}')
    if iter1 == 100: 
        print '#' * 20
        print "Total number of states: ", len(Interleaved_lts_states)
        print "Total number of edges: ", TotalNoEdges
        #print "States in Interleaved LTS: ", Interleaved_lts_states
        print '#' * 20


def construct_protocol(protocol_config_file, protocol_key):

	config_proto = ConfigParser.RawConfigParser()
	#config_proto.read('Xtended_proto.cfg')
	config_proto.read(protocol_config_file)
	
	proto_nodes = []
	proto_tran_rel = []
	proto_init_state = []
	
	Protocols = ast.literal_eval(config_proto.get('Configuration', 'Protocols'))
	Clock_nodes = ast.literal_eval(config_proto.get('Configuration', 'Clock_Nodes'))
	
	Clock_States = []
	for i in range(Clock_nodes):
	    cstate = 'CS_'+ str(i)
	    Clock_States.append(cstate)
	
	for i in range(len(Protocols)):
	    proto_nodes.append(ast.literal_eval(config_proto.get(Protocols[i], 'protocolnodes')))
	    proto_tran_rel.append(ast.literal_eval(config_proto.get(Protocols[i], 'protocol')))
	    proto_init_state.append(ast.literal_eval(config_proto.get(Protocols[i], 'initstate')))
	
	Interleaved_lockstep_lts_file = open('./cfg/Interleaved_lockstep_lts.cfg', 'w')
	Interleaved_lockstep_lts_file.write('[Configuration]\n')
	
	Interleaved_lts_machine = {}
	Interleaved_lts_machine = proto_tran_rel[0]
	#print Interleaved_lts_machine
	Interleaved_lts_machine_init = proto_init_state[0]
	#print Interleaved_lts_machine_init
	
	for iter1 in range(1, len(proto_tran_rel)):
	    ListStateMachineNodes = []
	    TempMachine_1 = {}
	    
	    TempMachine_2 = proto_tran_rel[iter1]
	    TempMachine_2_init = proto_init_state[iter1]
	    
	    Interleaved_lts_machine_keys = Interleaved_lts_machine.keys()
	    #print Interleaved_lts_machine_keys
	    TempMachine_2_keys = TempMachine_2.keys()
	    for i in range(len(Interleaved_lts_machine_keys)):
	        for j in range(len(TempMachine_2_keys)):
	            clkstate_1 = Interleaved_lts_machine_keys[i][0][Interleaved_lts_machine_keys[i][0].find(':') + 1:]
	            clkstate_2 = TempMachine_2_keys[j][0][TempMachine_2_keys[j][0].find(':') + 1:]
	            if clkstate_1 == clkstate_2:
	                newstate = Interleaved_lts_machine_keys[i][0][:Interleaved_lts_machine_keys[i][0].find(':')] + ':' + TempMachine_2_keys[j][0][:TempMachine_2_keys[j][0].find(':')] + ':' + clkstate_1
	                ListStateMachineNodes.append(newstate)
	
	    #print "States in interleaved LTS:", ListStateMachineNodes
	    #print "Total number of states in interleaved LTS:", len(ListStateMachineNodes)
	   
	    Initstate = tuple([Interleaved_lts_machine_init[0][0][:Interleaved_lts_machine_init[0][0].find(':')] + ':' + TempMachine_2_init[0][0][:TempMachine_2_init[0][0].find(':')] + ':' + Interleaved_lts_machine_init[0][0][Interleaved_lts_machine_init[0][0].find(':') + 1:]])
	
	    StatesExplored = []
	    StatesYetToExplore = []
	    StatesYetToExplore.append(Initstate)
	    print "Init state queued:", Initstate
	
	    # Calculating constrained product of the two state machine under consideration
	    while StatesYetToExplore:
	        StateNowExploring = StatesYetToExplore.pop()
	        print "Current State being Explored: ", StateNowExploring
	        StatesExplored.append(StateNowExploring)
	        try:
	            assert (len(StatesYetToExplore) + len(StatesExplored)) <= len(ListStateMachineNodes)
	        except AssertionError:
	            print "Number of States Yet to Explore: ", len(StatesYetToExplore)
	            print "Number of States Explored: ", len(StatesExplored)
	            print "Number of total States in the new state machine: ", len(ListStateMachineNodes)
	            ss.exit(1)
	        
	        Interleaved_lts_machine_state = StateNowExploring[0][:StateNowExploring[0].find(':')]
	        #print Interleaved_lts_machine_state
	        Interleaved_lts_machine_clkstate =  StateNowExploring[0][StateNowExploring[0].rfind(':') + 1:]
	        EdgeOf_Interleaved_lts_machine = Interleaved_lts_machine[tuple([Interleaved_lts_machine_state + ':' + Interleaved_lts_machine_clkstate])]
	        #print EdgeOf_Interleaved_lts_machine
	
	        TempMachine_2_state = StateNowExploring[0][StateNowExploring[0].find(':') + 1:StateNowExploring[0].rfind(':')]
	        TempMachine_2_clkstate = StateNowExploring[0][StateNowExploring[0].rfind(':') + 1:]
	        EdgeOf_TempMachine_2 = TempMachine_2[tuple([TempMachine_2_state + ':' + TempMachine_2_clkstate])]
	        #print EdgeOf_TempMachine_2
	        
	        for msg_i in EdgeOf_Interleaved_lts_machine.keys():
	            for msg_t in EdgeOf_TempMachine_2.keys():
	                NextState_of_Interleaved = EdgeOf_Interleaved_lts_machine[msg_i][0]
	                NextState_of_TempMachine_2 = EdgeOf_TempMachine_2[msg_t][0]
	                if NextState_of_Interleaved[NextState_of_Interleaved.find(':') + 1:] == NextState_of_TempMachine_2[NextState_of_TempMachine_2.find(':') + 1:]:
	                    ComposedMsg = ''
	                    if msg_i == 'True' and msg_t == 'True':
	                        ComposedMsg = 'True'
	                    elif msg_i == 'True' and msg_t != 'True':
	                        ComposedMsg = msg_t
	                    elif msg_i != 'True' and msg_t == 'True':
	                        ComposedMsg = msg_i
	                    elif msg_i != 'True' and msg_t != 'True':
	                        ComposedMsg = msg_i + ' & ' + msg_t
	                    
	                    #print ComposedMsg
	                    QStateToExplore = tuple([NextState_of_Interleaved[:NextState_of_Interleaved.find(':')] + ':' + NextState_of_TempMachine_2[:NextState_of_TempMachine_2.find(':')] + ':' + NextState_of_Interleaved[NextState_of_Interleaved.find(':') + 1:]])
	                    tempdict = {}
	                    tempdict[ComposedMsg] = tuple([QStateToExplore[0].replace(':', '_', 1)])
	                    
	                    if StateNowExploring in TempMachine_1.keys():
	                        TempMachine_1[StateNowExploring].update(tempdict)
	                    else:
	                        TempMachine_1[StateNowExploring] = tempdict
	
	                    if QStateToExplore not in StatesExplored and QStateToExplore not in StatesYetToExplore:
	                        StatesYetToExplore.append(QStateToExplore)
	    
	    Interleaved_lts_machine = {}
	    for key in TempMachine_1.keys():
	        newkey = key[0].replace(':', '_', 1)
	        Interleaved_lts_machine[tuple([newkey])] = TempMachine_1[key]
	   
	    Interleaved_lts_machine_init = []
	    Interleaved_lts_machine_init.append(tuple([Initstate[0].replace(':', '_', 1)]))
	    print "\n"
	    print "Initial state of the Interleaved state machine now: ", Interleaved_lts_machine_init, '\n'
	    print '#' * 20, 'Iteration: ', (iter1 - 1), ' complete ', '#' * 20, '\n'
	    draw_dot(Interleaved_lts_machine, Interleaved_lts_machine_init, iter1, protocol_key)
	    
	#Interleaved_lts_states = Interleaved_lts_machine.keys()
	
	#print "\n\n"
	
	#Interleaved_lockstep_lts_file.write('protocolnodes: ' + str(Interleaved_lts_states) + '\n')
	#Interleaved_lockstep_lts_file.write('protocol: ' + str(Interleaved_lts_machine) + '\n')
	#Interleaved_lockstep_lts_file.write('initstate: ' + str([Initstate[0].replace(':', '_', 1)]) + '\n')
	#Interleaved_lockstep_lts_file.close()
        return Interleaved_lts_machine, Initstate

#Interleaved_lts_graph = pd.Dot(graph_type = 'digraph')
#NodeDict = {}
#for i in Interleaved_lts_states:
#    if i[0] == Initstate[0].replace(':', '_', 1):
#        NodeDict[i] = pd.Node(i[0].replace(':', '_'), style="filled", fillcolor="green")
#    else:
#        NodeDict[i] = pd.Node(i[0].replace(':', '_'), style="filled", fillcolor="gray")
#    Interleaved_lts_graph.add_node(NodeDict[i])
#
##print "NodeDict Keys: ", NodeDict.keys()
#
#TotalNoEdges = 0
#for state in Interleaved_lts_states:
#    #print "state: ", state
#    for j in Interleaved_lts_machine[state]:
#        #print "j: ", j
#        for k_ in Interleaved_lts_machine[state][j]:
#            #print k_
#            #k = k_.replace(':', '_')
#            TotalNoEdges = TotalNoEdges + 1
#            Interleaved_lts_graph.add_edge(pd.Edge(NodeDict[state], NodeDict[tuple([k_])], label = j))


#Interleaved_lts_graph.write_png('Interleaved_lockstep_lts.png')
