#########################################################################
#############################Abhishek Sharma#############################
########################Started: 9th Jun 2016############################
#########################Construction of LTS#############################
#########################################################################


import os
import sys
import ConfigParser
import ast

os.system('cls' if os.name == 'nt' else 'clear')

config = ConfigParser.RawConfigParser()
config.read('config.cfg')
listsysdict = [] #list of all dictionaries, where each sys dictionary corresponds to one protocol
listsysnodes = []
Protocols = ast.literal_eval(config.get('Configuration','Protocols')) #list of protocols, user input
Budget = config.getint('Configuration','Budget')

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
        for i in k:
            for j in k.get(i): #outgoing edge for one message at a time
                if i not in tempsys[temp]:
                    tempsys[temp][i] = []
                tempsys[temp][i].append(j+temp[len(temp)-1:])
                if (j+temp[len(temp)-1:]) not in sysnodes:
                    if (j+temp[len(temp)-1:]) not in queue:
                        queue.append(j+temp[len(temp)-1:])

        
        k = listsysdict[x].get(temp[len(temp)-1:]) #get the outgoing edges of a node in the tuple
        for i in k:
            for j in k.get(i): #outgoing edge for one message at a time
                if i not in tempsys[temp]:
                    tempsys[temp][i] = []
                tempsys[temp][i].append(temp[:len(temp)-1]+j)#treat j as a tuple element
                if (temp[:len(temp)-1]+j) not in sysnodes:
                    if (temp[:len(temp)-1]+j) not in queue:
                        queue.append(temp[:len(temp)-1]+j)

    sysnodes = tempsysnodes
    sys = tempsys
    tempsysnodes = []
    tempsys = {}

print "sysnodes: ", sysnodes
print "\n"
for i in sysnodes:
    print sys[i]
    print "\n"

        
