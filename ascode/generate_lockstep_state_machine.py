import os
import sys
import ConfigParser
import ast
import pickle
import networkxx as nx
from matplotlib import pyplot as plt
import pydot as pd

os.system('cls' if os.name == 'nt' else 'clear')

config_proto = ConfigParser.RawConfigParser()
config_proto.read('Xtended_proto.cfg')

proto_nodes = []
proto_tran_rel = []
proto_init_state = []

Protocols = ast.litera_eval(config_proto.get('Configuration', 'Protocols'))
Clock_nodes = ast.literal_eval(config_proto.get('Configuration', 'Clock_Nodes'))

Clock_States = []
for i in range(Clock_nodes):
    cstate = 'CS_'+ i
    Clock_States.append(cstate)

for i in range(len(Protocols)):
    proto_nodes.append(ast.literal_eval(config_proto.get(Protocols[i], 'protocolnodes')))
    proto_tran_rel.append(ast.literal_eval(config_proto.get(Protocols[i], 'protocol')))
    proto_init_state.append(ast.literal_eval(config_proto.get(Protocols[i], 'initstate')))

Interleaved_lockstep_lts_file = open('Interleaved_lockstep_lts.cfg', 'w')
Interleaved_lockstep_lts_file.write('[Configuration]\n')

