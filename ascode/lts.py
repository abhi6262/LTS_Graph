#########################################################################
#############################Abhishek Sharma#############################
########################Started: 9th Jun 2016############################
#########################Construction of LTS#############################
#######################Finished: 11th Jun 2016###########################
#########################################################################


import os
import sys as ss
import ConfigParser
import ast
import pickle
from matplotlib import pyplot as plt
import networkx as nx
import pydot as pd

os.system('cls' if os.name == 'nt' else 'clear')

config = ConfigParser.RawConfigParser()
config.read('../config.cfg')
listsysdict_ = [] #list of all dictionaries, where each sys dictionary corresponds to one protocol
listsysnodes_ = []
listsysinstance_ = []
listsysatoms_ = [] 
Protocols = ast.literal_eval(config.get('Configuration','Protocols')) #list of protocols, user input

for i in range(len(Protocols)):
    listsysinstance_.append(ast.literal_eval(config.get(Protocols[i], 'noofinstances')))
    listsysnodes_.append(ast.literal_eval(config.get(Protocols[i], 'protocolnodes')))
    listsysatoms_.append(ast.literal_eval(config.get(Protocols[i], 'protocolatom')))
    listsysdict_.append(ast.literal_eval(config.get(Protocols[i], 'protocol')))

#print listsysinstance_
#print listsysnodes_ 
#print listsysatoms_

Elab_proto_cfg_file = open('./cfg/Elab_proto.cfg', 'w')
Elab_proto_cfg_file.write('[Configuration]\n')
Elab_proto_cfg_file.write('Protocols: [')
for i in range(len(Protocols)):
    Elab_proto_cfg_file.write(", ".join('\'' + str(j) + '_' + Protocols[i] + '\'' for j in range(listsysinstance_[i])))
    if i < len(Protocols) - 1:
        Elab_proto_cfg_file.write(', ')
Elab_proto_cfg_file.write(']\n\n')

for i in range(len(Protocols)):
    for j in range(listsysinstance_[i]):
        Elab_proto_cfg_file.write('[' + str(j) + '_' + Protocols[i] + ']\n')
        Elab_proto_cfg_file.write('protocolnodes: [')
        proto_states = listsysnodes_[i]
        Elab_proto_cfg_file.write(", ".join(str(tuple([str(j) + '_' + state[0]])) for state in proto_states))
        Elab_proto_cfg_file.write(']\n')
        
        Elab_proto_cfg_file.write('protocolatom: [')
        atom_states = listsysatoms_[i]
        Elab_proto_cfg_file.write(", ".join(str(tuple([str(j) + '_' + state[0]])) for state in atom_states))
        Elab_proto_cfg_file.write(']\n')

        Elab_proto_cfg_file.write('protocol: ')
        idx_protocol_delta = {}
        protocol_delta = listsysdict_[i]
        for key in protocol_delta.keys():
            idx_key = tuple([str(j) + '_' + key[0]])
            transition = protocol_delta[key]
            idx_transition = {}
            for msg in transition.keys():
                nxt_state = transition[msg]
                idx_msg = str(j) + '_' + msg
                idx_nxt_state = tuple([str(j) + '_' + nxt_state[0][0]])
                idx_transition[idx_msg] = [idx_nxt_state]
            idx_protocol_delta[idx_key] = idx_transition

        Elab_proto_cfg_file.write(str(idx_protocol_delta))
        Elab_proto_cfg_file.write('\n')
        
        Elab_proto_cfg_file.write('\n')

Elab_proto_cfg_file.close()

config_elab = ConfigParser.RawConfigParser()
config_elab.read('./cfg/Elab_proto.cfg')
listsysdict = []
listsysnodes = []
listsysatom = []
Protocols = ast.literal_eval(config_elab.get('Configuration', 'Protocols'))

for i in range(len(Protocols)):
    listsysnodes.append(ast.literal_eval(config_elab.get(Protocols[i], 'protocolnodes')))
    listsysdict.append(ast.literal_eval(config_elab.get(Protocols[i], 'protocol')))
    listsysatom.append(ast.literal_eval(config_elab.get(Protocols[i], 'protocolatom')))

#print listsysnodes
#print listsysdict

sysnodes = listsysnodes[0] #dictionary for constructed LTS
queue = [] #to keep new nodes which are found in the construction process
sys = listsysdict[0] #list of nodes for constructed LTS
atoms = listsysatom[0]
tempsysnodes = []
tempatom = []
tempsys = {}
#print "Sys:", sys
#print atoms
for x in range(1,len(Protocols)):
    temp1 = sysnodes[0]+listsysnodes[x][0] #starting node of intermediate LTS and next protocol
    queue.append(temp1)

    while queue:
        temp = queue.pop() #pop one node on wueue and add its outgoing edges
        #print "Temp", temp[len(temp)-1:]
        tempsysnodes.append(temp) 
        tempsys[temp] = {} 

        k = sys.get(temp[:len(temp)-1]) #get the outgoing edges of a node in the tuple
        #print "From sys:", k
        if k: #check if there are any outgoing edges
            for i in k:
                for j in k.get(i): #outgoing edge for one message at a time
                    if i not in tempsys[temp]:
                        tempsys[temp][i] = []
                    #print j+temp[len(temp)-1:]
                    #if j not in atoms
                    #print "1. Changed state (J): ", j
                    #print "1. Unchanged state :", temp[len(temp)-1:]
                    if temp[len(temp) - 1:] not in listsysatom[x]:
                        #print "1. Entered\n"
                        tempsys[temp][i].append(j+temp[len(temp)-1:])
                        if (j+temp[len(temp)-1:]) not in tempsysnodes:
                            if (j+temp[len(temp)-1:]) not in queue:
                                queue.append(j+temp[len(temp)-1:])
                    else:
                        if j+temp[len(temp)-1:] not in tempatom:
                            tempatom.append(j+temp[len(temp)-1:])
            
        k = listsysdict[x].get(temp[len(temp)-1:]) #get the outgoing edges of a node in the tuple
        #print "From listsysdict:", k
        if k: #check if there are any outgoing edges
            for i in k:
                for j in k.get(i): #outgoing edge for one message at a time
                    if i not in tempsys[temp]:
                        tempsys[temp][i] = []
                    #print "2. Changed state (J): ", j
                    #print "2. Unchanged state :", temp[:len(temp)-1]
                    if temp[:len(temp) - 1] not in atoms:
                        #print "2. Entered\n"
                        tempsys[temp][i].append(temp[:len(temp)-1]+j)#treat j as a tuple element
                        if (temp[:len(temp)-1]+j) not in tempsysnodes:
                            if (temp[:len(temp)-1]+j) not in queue:
                                queue.append(temp[:len(temp)-1]+j)
                    else:
                        if temp[:len(temp)-1]+j not in tempatom:
                            tempatom.append(temp[:len(temp)-1]+j)
    sysnodes = tempsysnodes
    sys = tempsys
    atoms = tempatom
    tempsysnodes = []
    tempatom = []
    tempsys = {}

    #print "x:", x
    #print "Sys at the end of for loop:", sys
    #print "\n"
    #print "SysNodes at the end of for loop:", sysnodes
    #print "\n"

#ss.exit(0)

print "number of nodes:", len(sysnodes)
print "\n"
print "Sys at the end of for loop:", sys
print "\n"
print "SysNodes at the end of for loop:", sysnodes
print "\n"
print "Critical sysnodes excluded at the end of for loop:", atoms
print "\n"

ss.exit(0)

#print "sysnodes: ", sysnodes
#print "\n"
#for i in sysnodes:
#    if i in sys:
#        print i, ":", sys.get(i), "\n"

adj = [[0 for j in range(len(sysnodes))] for i in range(len(sysnodes))]
for i in sysnodes:
    #print i
    #print i, ":", sys[i], "\n"
    for j in sys.get(i):
        #print "j", j, "\n"
        for l in sys[i].get(j):
            adj[sysnodes.index(i)][sysnodes.index(l)] = 1

#print "adj:", adj, "\n"    

with open('ltsdump', 'wb') as f:
    pickle.dump(sysnodes, f)
    pickle.dump(sys, f)
    pickle.dump(adj,f)

f.close()

'''
G = nx.DiGraph()
for i in sysnodes:
    G.add_node(sysnodes.index(i))
    G.node[sysnodes.index(i)]['state'] = i

for i in sysnodes:
    for j in sys[i]:
        for k in sys[i][j]:
            G.add_edge(sysnodes.index(i),sysnodes.index(k))
            G.edge[sysnodes.index(i)][sysnodes.index(k)]['msg'] = j

pos = nx.spring_layout(G)
nx.draw(G,pos)
node_labels = nx.get_node_attributes(G,'state')
nx.draw_networkx_labels(G, pos, labels = node_labels)
edge_labels = nx.get_edge_attributes(G,'msg')
nx.draw_networkx_edge_labels(G, pos, labels = edge_labels)
plt.savefig('lts.png')
plt.show()
'''
#graph =  pd.Dot(graph_type = 'digraph')
### Add all nodes in the graph
#NodeDict = {}
#nodeNumber = 0
#node_file_name = open('node_mapping.txt', 'w')
#for i in sysnodes:
#    nodeNumber = nodeNumber + 1
#    NodeDict[i] = pd.Node(str(nodeNumber), style="filled", fillcolor="blue")
#    graph.add_node(NodeDict[i])
#    node_file_name.write(str(i) + " : " + str(nodeNumber) + "\n")
#
#node_file_name.close()
#
#for i in sysnodes:
#    for j in sys[i]:
#        for k in sys[i][j]:
#            graph.add_edge(pd.Edge(NodeDict[i], NodeDict[k], label=j))

#graph.write_pdf("./pdf/lts.pdf")
#graph.write_png("lts.png")
