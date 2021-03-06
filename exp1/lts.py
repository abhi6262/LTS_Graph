#########################################################################
#############################Abhishek Sharma#############################
########################Started: 9th Jun 2016############################
#########################Construction of LTS#############################
#######################Finished: 11th Jun 2016###########################
#########################################################################


import os
import sys
import ConfigParser
import ast
import pickle
from matplotlib import pyplot as plt
import networkx as nx

os.system('cls' if os.name == 'nt' else 'clear')

config = ConfigParser.RawConfigParser()
config.read('../config.cfg')
listsysdict = [] #list of all dictionaries, where each sys dictionary corresponds to one protocol
listsysnodes = []
Protocols = ast.literal_eval(config.get('Configuration','Protocols')) #list of protocols, user input

for i in range(len(Protocols)):
    listsysnodes.append(ast.literal_eval(config.get(Protocols[i],'protocolnodes')))
    listsysdict.append(ast.literal_eval(config.get(Protocols[i],'protocol')))


sysnodes = listsysnodes[0] #dictionary for constructed LTS
queue = [] #to keep new nodes which are found in the construction process
sys = listsysdict[0] #list of nodes for constructed LTS
tempsysnodes = []
tempsys = {}

for x in range(1,len(Protocols)):
    temp1 = sysnodes[0]+listsysnodes[x][0] #starting node of intermediate LTS and next protocol
    queue.append(temp1)

    while queue:
        temp = queue.pop() #pop one node on wueue and add its outgoing edges
        tempsysnodes.append(temp) 
        tempsys[temp] = {} 

        k = sys.get(temp[:len(temp)-1]) #get the outgoing edges of a node in the tuple
        if k: #check if there are any outgoing edges
            for i in k:
                for j in k.get(i): #outgoing edge for one message at a time
                    if i not in tempsys[temp]:
                        tempsys[temp][i] = []
                    tempsys[temp][i].append(j+temp[len(temp)-1:])
                    if (j+temp[len(temp)-1:]) not in tempsysnodes:
                        if (j+temp[len(temp)-1:]) not in queue:
                            queue.append(j+temp[len(temp)-1:])
            
        k = listsysdict[x].get(temp[len(temp)-1:]) #get the outgoing edges of a node in the tuple
        if k: #check if there are any outgoing edges
            for i in k:
                for j in k.get(i): #outgoing edge for one message at a time
                    if i not in tempsys[temp]:
                        tempsys[temp][i] = []
                    tempsys[temp][i].append(temp[:len(temp)-1]+j)#treat j as a tuple element
                    if (temp[:len(temp)-1]+j) not in tempsysnodes:
                        if (temp[:len(temp)-1]+j) not in queue:
                            queue.append(temp[:len(temp)-1]+j)
    sysnodes = tempsysnodes
    sys = tempsys
    tempsysnodes = []
    tempsys = {}

print "number of nodes:", len(sysnodes)
#print "sysnodes: ", sysnodes
print "\n"
for i in sysnodes:
    if i in sys:
        print i, ":", sys.get(i), "\n"

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

nodes_list = [('mon_1', 'cpu_1', 'xbar_1'), ('mon_1', 'cpu_1', 'xbar_2'), ('mon_1', 'cpu_1', 'xbar_3'), ('mon_1', 'cpu_1', 'xbar_4'), ('mon_1', 'cpu_1', 'xbar_5'), ('mon_1', 'cpu_1', 'xbar_6'), ('mon_1', 'cpu_2', 'xbar_6'), ('mon_1', 'cpu_3', 'xbar_6'), ('mon_1', 'cpu_4', 'xbar_6'), ('mon_1', 'cpu_5', 'xbar_6'), ('mon_1', 'cpu_6', 'xbar_6'), ('mon_1', 'cpu_7', 'xbar_6'), ('mon_1', 'cpu_8', 'xbar_6'), ('mon_1', 'cpu_9', 'xbar_6'), ('mon_2', 'cpu_9', 'xbar_6'), ('mon_3', 'cpu_9', 'xbar_6'), ('mon_4', 'cpu_9', 'xbar_6'), ('mon_5', 'cpu_9', 'xbar_6'), ('mon_6', 'cpu_9', 'xbar_6'), ('mon_7', 'cpu_9', 'xbar_6'), ('mon_8', 'cpu_9', 'xbar_6')]

G = nx.Graph()
for i in sysnodes:
    if i in nodes_list:
        G.add_node(sysnodes.index(i))
        G.node[sysnodes.index(i)]['state'] = i

for i in sysnodes:
    if i in nodes_list:
        for j in sys[i]:
            for k in sys[i][j]:
                if k in nodes_list:
                    G.add_edge(sysnodes.index(i),sysnodes.index(k))
                    G.edge[sysnodes.index(i)][sysnodes.index(k)]['msg'] = j

pos = nx.circular_layout(G, scale=10)
nx.draw(G,pos,font_size=1)
node_labels = nx.get_node_attributes(G,'state')
nx.draw_networkx_labels(G, pos, labels = node_labels)
edge_labels = nx.get_edge_attributes(G,'msg')
nx.draw_networkx_edge_labels(G, pos, labels = edge_labels)
plt.savefig('lts.png')
plt.show()
