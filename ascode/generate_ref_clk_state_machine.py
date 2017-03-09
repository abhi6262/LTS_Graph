import os
import sys as ss
import ConfigParser
import ast
import pickle
import networkx as nx
from matplotlib import pyplot as plt
import pydot as pd

os.system('cls' if os.name == 'nt' else 'clear')

config_clock = ConfigParser.RawConfigParser()
config_proto = ConfigParser.RawConfigParser()

config_clock.read('clock_config.cfg')
config_proto.read('config_mclock.cfg')

#
clock_nodes = []
clock_tran_rel = []
clock_init_state = []
clock_nodes.append(ast.literal_eval(config_clock.get('clock_state_machine', 'protocolnodes')))
clock_tran_rel.append(ast.literal_eval(config_clock.get('clock_state_machine', 'protocol')))
clock_init_state.append(ast.literal_eval(config_clock.get('clock_state_machine', 'initstate')))

# proto nodes will get the state nodes of the protocol and the proto_tran_rel will get
# the transition relation of the protocol from the configuration file. proto_nodes will be list of lists and proto_tran_rel wil be list of dictionaries. 
proto_nodes = []
proto_tran_rel = []
proto_init_state = []

Protocols = ast.literal_eval(config_proto.get('Configuration', 'Protocols'))

for i in range(len(Protocols)):
    proto_nodes.append(ast.literal_eval(config_proto.get(Protocols[i], 'protocolnodes')))
    proto_tran_rel.append(ast.literal_eval(config_proto.get(Protocols[i], 'protocol')))
    proto_init_state.append(ast.literal_eval(config_proto.get(Protocols[i], 'initstate')))

#print "Clock nodes:", clock_nodes
#print "Clock transition rel:", clock_tran_rel
#print "\n\n"
#print "Protocol nodes:", proto_nodes
#print "Protocol transition rel:", proto_tran_rel

# proto_nodes is a list of lists which contains the list of the nodes of the protocols
# of interest

Xtended_proto_cfg_file = open('Xtended_proto.cfg', 'w')
Xtended_proto_cfg_file.write('[Configuration]\n')

Xtended_proto_state_machine = {}

for iter1 in range(len(proto_nodes)):
    Xtended_proto_cfg_file.write('[' + Protocols[iter1] + ']\n')
    ListStateMachineNodes = []
    for j in range(len(clock_nodes[0])):
        for k in range(len(proto_nodes[i])):
            state_name = proto_nodes[iter1][k][0] + ':' + clock_nodes[0][j][0]
            ListStateMachineNodes.append(state_name)
    print "Total number of states in the enhanced protocol state machine:", len(ListStateMachineNodes)
    print "States of the enhanced state protocol state machine are:", ListStateMachineNodes
    print "\n\n"
    StateMachineDict = {}
    InitState = tuple([proto_init_state[0][0][0] + ':' + clock_init_state[0][0][0]])
    
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
        #print "States explored:", StatesExplored, "\n\n"
        try:
            assert (len(StatesYetToExplore) + len(StatesExplored)) <= len(ListStateMachineNodes)
            #assert len(StatesExplored) <= len(ListStateMachineNodes)
        except AssertionError:
            print "Number of States Yet to Explore: ", len(StatesYetToExplore)
            print "Number of States Explored: ", len(StatesExplored)
            print "Number of total States in the new state machine: ", len(ListStateMachineNodes)
            ss.exit(1)

        EdgeOfProto = proto_tran_rel[0].get(tuple([StateNowExploring[0][:StateNowExploring[0].find(':')]]))
        #print "Edge of Proto State:", StateNowExploring[0][:StateNowExploring[0].find(':')], EdgeOfProto
        EdgeOfClk = clock_tran_rel[0].get(tuple([StateNowExploring[0][StateNowExploring[0].find(':')+1:]]))
        #print "Edge of Clock State:", StateNowExploring[0][StateNowExploring[0].find(':')+1:], EdgeOfClk
        #print "\n"
        # Case 1: The edge of the clock state machine is marked with 'True' only and no clock.
        # Then (w, ca) --> (w, ca'). There will be NO change in the state of the protocol state
        if len(EdgeOfClk) == 1 and EdgeOfClk.keys()[0] == 'True':
            tempdict = {}
            NextClockState = EdgeOfClk['True'][0][0]
            QStateToExplore = tuple([StateNowExploring[0][:StateNowExploring[0].find(':')] + ':' + NextClockState])
            tempdict['True'] = QStateToExplore
            # Reconstructing the transition relation in the extended transition system
            if StateNowExploring in Xtended_proto_state_machine.keys():
                Xtended_proto_state_machine[StateNowExploring].update(tempdict)
            else:
                Xtended_proto_state_machine[StateNowExploring] = tempdict
           
            if QStateToExplore not in StatesExplored and QStateToExplore not in StatesYetToExplore:
                StatesYetToExplore.append(QStateToExplore)
                #print "Ref 1: New State Queued:", QStateToExplore, "\n\n"
        # Case 2: The edge of the clock has one or more than one clock labeling along with 'True'
        else:
            CurrentClocks = EdgeOfClk.keys()
            CurrentProtoMsgs = EdgeOfProto.keys()
            #print "Current clocks found:", CurrentClocks
            #print "Current proto messages found:", CurrentProtoMsgs
            NextClockState = EdgeOfClk[CurrentClocks[0]][0][0]
            #for clock in CurrentClocks:
                #print "Current clock tick is:", clock
                #if clock != 'True':
                # Case 2a: If the clock edge is sme legitimate clock other than 'True', its time 
                # to move to next state of the protocol state machine
            for msg in CurrentProtoMsgs:
                #print "Proto Message is:", msg[:msg.find(':')], " and clock is:", msg[msg.find(':') + 1:]
                msgclk = msg[msg.find(':') + 1:]
                #print "NextClockState is:", NextClockState
                # Case 2a.1: If the clock labeling of the protocol state machine and the clock
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
                    if StateNowExploring in Xtended_proto_state_machine.keys():
                        Xtended_proto_state_machine[StateNowExploring].update(tempdict)
                    else:
                        Xtended_proto_state_machine[StateNowExploring] = tempdict

                    if QStateToExplore not in StatesExplored and QStateToExplore not in StatesYetToExplore:
                        StatesYetToExplore.append(QStateToExplore)
                        #print "Ref 2: State Queued:", QStateToExplore, "\n\n"
                # Case 2a.2: If the clock labeling og the protocol state machine and the clock
                # state machine does not match, then advance the clock state machine state but 
                # not the state of the protocol state machine
                else:
                    tempdict = {}
                    #print "Solving: Case 2a.2\n"
                    QStateToExplore = tuple([StateNowExploring[0][:StateNowExploring[0].find(':')] + ':' + NextClockState])
                    tempdict['True'] = QStateToExplore
                    #print "Case 2a.2 QStateToExplore:", QStateToExplore
                    # Reconstructing the transition relation in the extended transition system
                    if StateNowExploring in Xtended_proto_state_machine.keys():
                        Xtended_proto_state_machine[StateNowExploring].update(tempdict)
                    else:
                        Xtended_proto_state_machine[StateNowExploring] = tempdict

                    if QStateToExplore not in StatesExplored and QStateToExplore not in StatesYetToExplore:
                        StatesYetToExplore.append(QStateToExplore)
                        #print "Ref 3: State Queued:", QStateToExplore, "\n\n"

    protocol_states = ", ".join(str(tuple([i])) for i in ListStateMachineNodes) 
    Xtended_proto_cfg_file.write('protocolnodes: [' + protocol_states + ']\n')
    Xtended_proto_cfg_file.write('protocol:' + str(Xtended_proto_state_machine) + '\n')
    Xtended_proto_cfg_file.write('initstate: [' + str(tuple([InitState[0]])) + ']')
    
    #print Xtended_proto_state_machine.keys()

    extended_state_machine_graph = pd.Dot(graph_type = 'digraph')
    NodeDict = {}
    for i in ListStateMachineNodes:
        NodeDict[i] = pd.Node(i.replace(':', '_'), style="filled", fillcolor="gray")
        extended_state_machine_graph.add_node(NodeDict[i])
    #print NodeDict
    Xtended_state_machine_states = Xtended_proto_state_machine.keys()
    for i in ListStateMachineNodes:
        if tuple([i]) in Xtended_state_machine_states:
            #print "i:", i
            for j in Xtended_proto_state_machine[tuple([i])]:
                #print "j:", j
                for k in Xtended_proto_state_machine[tuple([i])][j]:
                    #print "k:", k
                    extended_state_machine_graph.add_edge(pd.Edge(NodeDict[i], NodeDict[k], label = j))

    extended_state_machine_graph.write_pdf(Protocols[iter1]+".pdf")
    extended_state_machine_graph.write_png(Protocols[iter1]+".png")
        
Xtended_proto_cfg_file.close()
