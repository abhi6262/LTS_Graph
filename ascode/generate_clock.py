import os
import sys
import ConfigParser
import ast
import pickle
import networkx as nx
from matplotlib import pyplot as plt
import pydot as pd

os.system('cls' if os.name == 'nt' else 'clear')


def gcd(x, y):
    while(y):
        x, y = y, x % y

    return x

def lcm(x, y):
    lcm = (x*y) // gcd(x, y)
    return lcm


# Config file should mention the frequency ratio of
# the component protocol clocks. Rest should be taken care
# of by the code itself

config = ConfigParser.RawConfigParser()
config.read('config_mclock.cfg')
Clocks = ast.literal_eval(config.get('Configuration', 'Clocks'))
RefClockFreq = 1
NumberOfStates = 1
for key in Clocks.keys():
    RefClockFreq = lcm(RefClockFreq, Clocks[key]) 
NumberOfStates = RefClockFreq

# A dictionary that holds how often a clocks tick should happen.
# in other words, this dictionary holds after how many states, a 
# clock tick should happen. Higher the frequency of the clock,
# lower will be the number of states between two successive occurence of
# the same clock

Clocks_ = {}
for key in Clocks.keys():
    Clocks_[key] = RefClockFreq / Clocks[key]

ListClkNodes = []
for i in range(NumberOfStates):
    state_name = 'CS_' + str(i)
    ListClkNodes.append(state_name)

clock_cfg_file = open('clock_config.cfg', 'w')
clock_cfg_file.write('[Configuration]\n')
clock_cfg_file.write('[clock_state_machine]\n')
clk_states = ", ".join(str(tuple([i])) for i in ListClkNodes)
protocol_dict = {}
for i in range(NumberOfStates):
    if i == NumberOfStates -1:
        for key in Clocks_.keys():
            tempdict = {}
            if (i + 1) % Clocks_[key] == 0:
                tempdict[key] = [tuple([ListClkNodes[0]])]
            else:
                tempdict['True'] = [tuple([ListClkNodes[0]])]

            if tuple([ListClkNodes[i]]) in protocol_dict.keys():
                protocol_dict[tuple([ListClkNodes[i]])].update(tempdict)
            else:
                protocol_dict[tuple([ListClkNodes[i]])] = tempdict
    else:     
        for key in Clocks_.keys():
            tempdict = {}
            if (i + 1) % Clocks_[key] == 0:
                tempdict[key] = [tuple([ListClkNodes[i+1]])]
            else:
                tempdict['True'] = [tuple([ListClkNodes[i+1]])]

            if tuple([ListClkNodes[i]]) in protocol_dict.keys():
                protocol_dict[tuple([ListClkNodes[i]])].update(tempdict)
            else:
                protocol_dict[tuple([ListClkNodes[i]])] = tempdict


#for key in protocol_dict.keys():
#    contains = protocol_dict[key]
#    if 'True' in contains.keys() and len(contains.keys()) > 1:
#        del(contains['True'])
#    protocol_dict[key] = contains

clock_cfg_file.write('protocolnodes: [' + clk_states + ']\n')
clock_cfg_file.write('protocol:' + str(protocol_dict) + '\n')
clock_cfg_file.write('initstate: [' + str(tuple([ListClkNodes[0]])) + ']')
clock_cfg_file.close()

print "Reference Clock Frequency is: ", RefClockFreq

clock_graph = pd.Dot(graph_type = 'digraph')
NodeDict = {}
for i in ListClkNodes:
    if i == ListClkNodes[0]:
        NodeDict[i] = pd.Node(i, style="filled", fillcolor="green")
    else:
        NodeDict[i] = pd.Node(i, style="filled", fillcolor="gray")

    clock_graph.add_node(NodeDict[i])

for i in ListClkNodes:
    for j in protocol_dict[tuple([i])]:
        for k in protocol_dict[tuple([i])][j]:
            clock_graph.add_edge(pd.Edge(NodeDict[i], NodeDict[k[0]], label=j ))


clock_graph.write_pdf("clock_state_machine.pdf")
clock_graph.write_png("clock_state_machine.png")
