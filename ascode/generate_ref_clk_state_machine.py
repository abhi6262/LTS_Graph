import os
import sys as ss
import ConfigParser
import ast
import pickle
import networkx as nx
from matplotlib import pyplot as plt
import pydot as pd
from generate_lockstep_state_machine import *

os.system('cls' if os.name == 'nt' else 'clear')

config_clock = ConfigParser.RawConfigParser()
config_proto = ConfigParser.RawConfigParser()

config_clock.read('clock_config.cfg')
config_proto.read('config_mclock.cfg')

# Getting clock details from the configuration file
clock_nodes = []
clock_tran_rel = []
clock_init_state = []

clock_nodes.append(ast.literal_eval(config_clock.get('clock_state_machine', 'protocolnodes')))
clock_tran_rel.append(ast.literal_eval(config_clock.get('clock_state_machine', 'protocol')))
clock_init_state.append(ast.literal_eval(config_clock.get('clock_state_machine', 'initstate')))

# proto nodes will get the state nodes of the protocol and the proto_tran_rel will get
# the transition relation of the protocol from the configuration file. 
# proto_nodes will be list of lists and proto_tran_rel wil be list of dictionaries. 
proto_nodes = {}
proto_tran_rel = {}
proto_init_state = {}

Protocols = ast.literal_eval(config_proto.get('Configuration', 'Protocols'))
print Protocols.keys()

for key in Protocols.keys():
    for comp in Protocols[key]:
        protocol_name = key + ':' + comp
        proto_nodes[protocol_name] = ast.literal_eval(config_proto.get(protocol_name, 'protocolnodes'))
        proto_tran_rel[protocol_name] = ast.literal_eval(config_proto.get(protocol_name, 'protocol'))
        proto_init_state[protocol_name] = ast.literal_eval(config_proto.get(protocol_name, 'initstate'))


#print proto_nodes
#print proto_init_state

Xtended_proto_cfg_file = open('./cfg/Xtended_proto.cfg', 'w')
Xtended_proto_cfg_file.write('[Configuration]\n')
#Xtended_proto_cfg_file.write('Protocols: ' + str(Protocols) + '\n')
Xtended_proto_cfg_file.write('Protocols: [' + ", ".join('\'' + key + '\'' for key in Protocols.keys()) + ']\n')
Xtended_proto_cfg_file.write('Clock_Nodes: ' + str(len(clock_nodes[0])) + '\n\n')

for key in Protocols.keys():

    Xtended_proto_cfg_file.write('[' + key + ']\n')

    Intermediate_proto_cfg_file = open('./cfg/Intermediate_proto.cfg', 'w')
    Intermediate_proto_cfg_file.write('[Configuration]\n')
    Intermediate_proto_cfg_file.write('Protocols:['  + ", ".join('\'' + key + ':' + ele + '\'' for ele in Protocols[key]) + ']\n')
    Intermediate_proto_cfg_file.write('Clock_Nodes: ' + str(len(clock_nodes[0])) + '\n\n')

    for comp in Protocols[key]:
        protocol_name = key + ':' + comp
        print "Enhancing protocol state machine:", protocol_name
        Intermediate_proto_state_machine = {}
        Intermediate_proto_cfg_file.write('[' + protocol_name + ']\n')
        ListStateMachineNodes = []
        for j in range(len(clock_nodes[0])):
            for k in range(len(proto_nodes[protocol_name])):
                state_name = proto_nodes[protocol_name][k][0] + ':' + clock_nodes[0][j][0]
                ListStateMachineNodes.append(state_name)
        print "Possible States of the enhanced state protocol state machine are:", ListStateMachineNodes
        InitState = tuple([proto_init_state[protocol_name][0][0] + ':' + clock_init_state[0][0][0]])
    
        StatesExplored = []
        StatesYetToExplore = []
        StatesYetToExplore.append(InitState)
        print "Init State Queued:", InitState, "\n"
        
        # Extending one protocol with the reference clock state machine
        while StatesYetToExplore:
            #print "States Yet to Explore: ", StatesYetToExplore
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

            EdgeOfProto = proto_tran_rel[protocol_name].get(tuple([StateNowExploring[0][:StateNowExploring[0].find(':')]]))
            # print "Edge of Proto State:", StateNowExploring[0][:StateNowExploring[0].find(':')], EdgeOfProto
            EdgeOfClk = clock_tran_rel[0].get(tuple([StateNowExploring[0][StateNowExploring[0].find(':')+1:]]))
            # print "Edge of Clock State:", StateNowExploring[0][StateNowExploring[0].find(':')+1:], EdgeOfClk

            # Case 1: The edge of the clock state machine is marked with 'True' only and no clock.
            # Then (w, ca) --> (w, ca'). There will be NO change in the state of the protocol state
            if len(EdgeOfClk) == 1 and EdgeOfClk.keys()[0] == 'True':
                tempdict = {}
                NextClockState = EdgeOfClk['True'][0][0]
                QStateToExplore = tuple([StateNowExploring[0][:StateNowExploring[0].find(':')] + ':' + NextClockState])
                tempdict['True'] = QStateToExplore
                # Reconstructing the transition relation in the extended transition system
                if StateNowExploring in Intermediate_proto_state_machine.keys():
                    Intermediate_proto_state_machine[StateNowExploring].update(tempdict)
                else:
                    Intermediate_proto_state_machine[StateNowExploring] = tempdict
                # A state just created can be in either of StatesExplored or in StatesYetToExplore but cannot be in both. If its not in both,
                # then it needs to be explored to find out reachable states and should be pushed in the StatesYetToExplore queue
                if QStateToExplore not in StatesExplored and QStateToExplore not in StatesYetToExplore:
                    StatesYetToExplore.append(QStateToExplore)
                    #print "Ref 1: New State Queued:", QStateToExplore, "\n\n"
                    # Case 2: The edge of the clock has more than one clock labeling with atleast one label being other than 'True'
                    # its time to move to next state of the protocol state machine
            else:
                CurrentClocks = EdgeOfClk.keys()
                CurrentProtoMsgs = EdgeOfProto.keys()
                NextClockState = EdgeOfClk[CurrentClocks[0]][0][0]
                for msg in CurrentProtoMsgs:
                    #print "Proto Message is:", msg[:msg.find(':')], " and clock is:", msg[msg.find(':') + 1:]
                    msgclk = msg[msg.find(':') + 1:]
                    #print "NextClockState is:", NextClockState
                    # Case 2.1: If the clock labeling of the protocol state machine and the clock
                    # state machine matches, then advance the protocol state machine and the clock 
                    # state machine
                    #print "msgclk:", msgclk
                    if msgclk in CurrentClocks:
                        tempdict = {}
                        #print "Solving: Case 2a.1\n"
                        NxtProtoState = EdgeOfProto[msg][0][0]
                        #print "NxtProtoState:", NxtProtoState, " and NextClockState:", NextClockState
                        QStateToExplore = tuple([NxtProtoState + ':' + NextClockState])
                        tempdict[msg[:msg.find(':')]] = QStateToExplore
                        #print "QStateToExplore:", QStateToExplore
                        #print "tempdict:", tempdict
                        # Reconstructing the transition relation in the extended transition system
                        if StateNowExploring in Intermediate_proto_state_machine.keys():
                            Intermediate_proto_state_machine[StateNowExploring].update(tempdict)
                        else:
                            Intermediate_proto_state_machine[StateNowExploring] = tempdict

                        if QStateToExplore not in StatesExplored and QStateToExplore not in StatesYetToExplore:
                            StatesYetToExplore.append(QStateToExplore)
                            #print "Ref 2: State Queued:", QStateToExplore, "\n\n"
                    # Case 2.2: If the clock labeling og the protocol state machine and the clock
                    # state machine does not match, then advance the clock state machine state but 
                    # not the state of the protocol state machine
                    else:
                        tempdict = {}
                        #print "Solving: Case 2a.2\n"
                        QStateToExplore = tuple([StateNowExploring[0][:StateNowExploring[0].find(':')] + ':' + NextClockState])
                        tempdict['True'] = QStateToExplore
                        #print "Case 2a.2 QStateToExplore:", QStateToExplore
                        # Reconstructing the transition relation in the extended transition system
                        if StateNowExploring in Intermediate_proto_state_machine.keys():
                            Intermediate_proto_state_machine[StateNowExploring].update(tempdict)
                        else:
                            Intermediate_proto_state_machine[StateNowExploring] = tempdict

                        if QStateToExplore not in StatesExplored and QStateToExplore not in StatesYetToExplore:
                            StatesYetToExplore.append(QStateToExplore)
                                    #print "Ref 3: State Queued:", QStateToExplore, "\n\n"

        protocol_states = ", ".join(str(tuple([i])) for i in ListStateMachineNodes) 
        Intermediate_proto_cfg_file.write('protocolnodes: [' + protocol_states + ']\n')
        Intermediate_proto_cfg_file.write('protocol:' + str(Intermediate_proto_state_machine) + '\n')
        Intermediate_proto_cfg_file.write('initstate: [' + str(tuple([InitState[0]])) + ']')
        Intermediate_proto_cfg_file.write("\n\n")
    
        #print Xtended_proto_state_machine.keys()

        Intermediate_state_machine_states = Intermediate_proto_state_machine.keys()
        extended_state_machine_graph = pd.Dot(graph_type = 'digraph')
        NodeDict = {}
        for i in ListStateMachineNodes:
            if i == InitState[0]:
                print "In graph If statement\n"
                NodeDict[i] = pd.Node(i.replace(':', '_'), style="filled", fillcolor="green")
            else:
                if tuple([i]) in Intermediate_state_machine_states:
                    NodeDict[i] = pd.Node(i.replace(':', '_'), style="filled", fillcolor="gray")
                else:
                    NodeDict[i] = pd.Node(i.replace(':', '_'), style="filled", fillcolor="red")
                    extended_state_machine_graph.add_node(NodeDict[i])
        #print NodeDict
        TotalNoEdges = 0 
        for i in ListStateMachineNodes:
            if tuple([i]) in Intermediate_state_machine_states:
                #print "i:", i
                for j in Intermediate_proto_state_machine[tuple([i])]:
                    #print "j:", j
                    for k in Intermediate_proto_state_machine[tuple([i])][j]:
                        #print "k:", k
                        TotalNoEdges = TotalNoEdges + 1
                        extended_state_machine_graph.add_edge(pd.Edge(NodeDict[i], NodeDict[k], label = j))

        extended_state_machine_graph.write_pdf("./pdf/" + protocol_name.replace(':', '_')+".pdf")
    
        print "\n"
        print '#' * 20
        print "Total Number of Possible States in the Enhanced State Machine of Protocol ", protocol_name, ": ",len(ListStateMachineNodes)
        print "Total Number of States in Enhanced State Machine of Protocol ", protocol_name, ": ", len(Intermediate_state_machine_states)
        print "Total Number of Edges  in Enhanced State Machine of Protocol ", protocol_name, ": ", TotalNoEdges
        print "Total Number of Unreachable states in the Enhanced State Machine of Protocol ", protocol_name, ": ", len(ListStateMachineNodes) - len(Intermediate_state_machine_states)
        print '#' * 20
        print "\n"
    
    Intermediate_proto_cfg_file.close() 
    Xtended_lts_machine, Initstate = construct_protocol('./cfg/Intermediate_proto.cfg', key)
    Xtended_lts_states = Xtended_lts_machine.keys()
   
    Xtended_lts_machine_init = []
    Xtended_lts_machine_init.append(tuple([Initstate[0].replace(':', '_', 1)]))
    draw_dot(Xtended_lts_machine, Xtended_lts_machine_init, 100, key)
    print "\n\n"
    
    Xtended_proto_cfg_file.write('protocolnodes: ' + str(Xtended_lts_states) + '\n')
    Xtended_proto_cfg_file.write('protocol: ' + str(Xtended_lts_machine) + '\n')
    Xtended_proto_cfg_file.write('initstate: ' + str([Initstate[0].replace(':', '_', 1)]) + '\n\n')

Xtended_proto_cfg_file.close()
