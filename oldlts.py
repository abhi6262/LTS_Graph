#########################################################################
#############################Abhishek Sharma#############################
########################Started: 9th Jun 2016############################
#########################Construction of LTS#############################
#########################################################################


import os
import sys

os.system('cls' if os.name == 'nt' else 'clear')

sys1nodes = ['far', 'near', 'in']
sys1 = {}
sys1['far'] = {}
sys1['far']['approach'] = ['near'];
sys1['near'] = {}
sys1['near']['enter'] = ['in'];
sys1['in'] = {}
sys1['in']['exit'] = ['far'];

sys2nodes = ['0', '1', '2', '3']
sys2 = {}
sys2['0'] = {}
sys2['0']['approach'] = ['1'];
sys2['1'] = {}
sys2['1']['lower'] = ['2'];
sys2['2'] = {}
sys2['2']['exit'] = ['3'];
sys2['3'] = {}
sys2['3']['rais'] = ['0'];

#print sys1
#print sys2

sysnodes = []
queue = []
sys = {}

temp = sys1nodes[0],sys2nodes[0]
queue.append(temp)

while queue:
    temp = queue.pop()
    sysnodes.append(temp)
    sys[temp] = {}
    for j in len(temp):
    k = sys1.get(temp[0])
    for i in k:
        for j in k.get(i):
            if i not in sys[temp]:
                sys[temp][i] = []
            sys[temp][i].append((j,temp[1]))
            if (j,temp[1]) not in sysnodes:
                if (j,temp[1]) not in queue:
                    queue.append((j,temp[1]))

    k = sys2.get(temp[1])
    for i in k:
        for j in k.get(i):
            if i not in sys[temp]:
                sys[temp][i] = []
            sys[temp][i].append((temp[0],j))
            if (temp[0],j) not in sysnodes:
                if (temp[0],j) not in queue:
                    queue.append((temp[0],j))

print "queue: ", queue
print "\n"
print "sysnodes: ", sysnodes
print "\n"
for i in sysnodes:
    print sys[i]
    print "\n"

        
