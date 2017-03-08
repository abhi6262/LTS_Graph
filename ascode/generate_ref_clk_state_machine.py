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

print "Clock nodes:", clock_nodes
print "Clock transition rel:", clock_tran_rel
print "\n\n"
print "Protocol nodes:", proto_nodes
print "Protocol transition rel:", proto_tran_rel

# proto_nodes is a list of lists which contains the list of the nodes of the protocols
# of interest
for i in range(len(proto_nodes)):
    ListStateMachineNodes = []
    for j in range(len(clock_nodes[0])):
        for k in range(len(proto_nodes[i])):
            state_name = proto_nodes[i][k][0] + ', ' + clock_nodes[0][j][0]
            ListStateMachineNodes.append(state_name)
    print "Total number of states in the enhanced protocol state machine:", len(ListStateMachineNodes)
    print "States of the enhanced state protocol state machine are:", ListStateMachineNodes
    StateMachineDict = {}
    InitState = tuple(proto_init_state[0][0] + clock_init_state[0][0])
    
    StatesExplored = []
    StatesYetToExplore = []
    StatesYetToExplore.append(InitState)
    print "Init State Queued:", InitState
        
    # Extending one protocol with the reference clock state machine
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

        EdgeOfProto = proto_tran_rel[0].get(tuple([StateNowExploring[0]]))
        EdgeOfClk = clock_tran_rel[0].get(tuple([StateNowExploring[1]]))
        # Case 1: The edge of the clock state machine is marked with 'True' only and no clock.
        # Then (w, ca) --> (w, ca'). There will be NO change in the state of the protocol state
        if len(EdgeOfClk) == 1 and EdgeOfClk.keys()[0] == 'True':
            NxtClockState = EdgeOfClk['True'][0][0]
            QStateToExplore = tuple([StateNowExploring[0]] + [NxtClockState])
            if QStateToExplore not in StatesExplored:
                StatesYetToExplore.append(QStateToExplore)
                print "Ref 1: New State Queued:", QStateToExplore
        # Case 2: The edge of the clock has one or more than one clock labeling along with 'True'
        else:
            CurrentClocks = EdgeOfClk.keys()
            CurrentProtoMsgs = EdgeOfProto.keys()
           
            for clock in CurrentClocks:
                # Case 2a: If the clock edge is 'True' then we just move on. Because there are other
                # clock labeling to take care off and to move the protocol state machine
                if clock == 'True':
                    continue
                else:
                # Case 2b: If the clock edge is sme legitimate clock other than 'True', its time 
                # to move to next state of the protocol state machine
                    for msg in CurrentProtoMsgs:
                        msgclk = msg[msg.find(':') + 1:]
                        NxtClkState = EdgeOfClk[clock][0][0]
                        # Case 2b.1: If the clock labeling of the protocol state machine and the clock
                        # state machine matches, then advance the protocol state machine and the clock 
                        # state machine
                        if clock == msgclk:
                            NxtProtoState = EdgeOfPtroto[msg][0][0]
                            QStateToExplore = tuple([NxtProtoState] + [NxtClkState])
                            if QStateToExplore not in StatesExplored:
                                StatesYetToExplore.append(QStateToExplore)
                                print "Ref 2: State Queued:", QStateToExplore
                        # Case 2b.2: If the clock labeling og the protocol state machine and the clock
                        # state machine does not match, then advance the clock state machine state but 
                        # not the state of the protocol state machine
                        else:
                            QStateToExplore = tuple([StateNowExploring[0]] + [NxtClockState])
                            if QStateToExplore not in StatesExplored:
                                StatesYetToExplore.append(QStateToExplore)
                                print "Ref 3: State Queued:", QStateToExplore

        print EdgeOfProto
        print EdgeOfClk
