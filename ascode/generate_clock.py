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


config = ConfigParser.RawConfigParser()
config.read('config_mclock.cfg')
Clocks = ast.literal_eval(config.get('Configuration', 'Clocks'))
RefClockFreq = 1
NumberOfStates = 1
for key in Clocks.keys():
    RefClockFreq = lcm(RefClockFreq, Clocks[key]) 
NumberOfStates = RefClockFreq

ListClkNodes = []
for i in range(NumberOfStates):
    state_name = 'CS_' + str(i)
    ListClkNodes.append(state_name)

adj_mat = [[0 for j in range(NumberOfStates)] for i in range(NumberOfStates)]
for i in range(NumberOfStates):
    if i == NumberOfStates - 1:
        adj_mat[i][0] = 1
    else:
        adj_mat[i][i+1] = 1


clock_cfg_file = open('clock_config.cfg', 'w')
clock_cfg_file.write('[clock_state_machine]\n')
clk_states = ", ".join(str(tuple([i])) for i in ListClkNodes)
protocol_dict = {}
for i in range(NumberOfStates):
    if i == NumberOfStates -1:
        for key in Clocks.keys():
            tempdict = {}
            if (i + 1) % Clocks[key] == 0:
                tempdict[key] = [tuple([ListClkNodes[0]])]
            else:
                tempdict['True'] = [tuple([ListClkNodes[0]])]

            if tuple([ListClkNodes[i]]) in protocol_dict.keys():
                protocol_dict[tuple([ListClkNodes[i]])].update(tempdict)
            else:
                protocol_dict[tuple([ListClkNodes[i]])] = tempdict
    else:     
        for key in Clocks.keys():
            tempdict = {}
            if (i + 1) % Clocks[key] == 0:
                tempdict[key] = [tuple([ListClkNodes[i+1]])]
            else:
                tempdict['True'] = [tuple([ListClkNodes[i+1]])]

            if tuple([ListClkNodes[i]]) in protocol_dict.keys():
                protocol_dict[tuple([ListClkNodes[i]])].update(tempdict)
            else:
                protocol_dict[tuple([ListClkNodes[i]])] = tempdict


for key in protocol_dict.keys():
    contains = protocol_dict[key]
    if 'True' in contains.keys() and len(contains.keys()) > 1:
        del(contains['True'])
    protocol_dict[key] = contains

clock_cfg_file.write('protocolnodes: [' + clk_states + ']\n')
clock_cfg_file.write('protocol:' + str(protocol_dict))
clock_cfg_file.close()

print "Reference Clock Frequency is: ", RefClockFreq
print "Clock State Machine States are: ", ListClkNodes
print "Adjacent Matrix is: ", adj_mat



