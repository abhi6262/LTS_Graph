#########################################################################
#############################Abhishek Sharma#############################
########################Started: 20th Jun 2016###########################
###################Finding path and message sequence#####################
########################Finished: 20th Jun 2016##########################
#########################################################################


import os
import sys
import ast
import pickle

os.system('cls' if os.name == 'nt' else 'clear')

with open('ltsdump', 'rb') as f:
    sysnodes = pickle.load(f)
    sys = pickle.load(f)

f.close()

with open('msgdump', 'rb') as f:
    listmsg = pickle.load(f)
    max_candidate = pickle.load(f)

f.close()


#sample_path = [('far', '0'), ('far', '1'), ('near', '1'), ('near', '2'), ('near', '3'), ('near', '0'), ('in', '0'), ('in', '1'), ('in', '2'), ('in', '3')]
sample_path = [('a', 'd'), ('b', 'd'), ('b', 'e'), ('b', 'f'), ('c', 'f')]
all_msg = []
obs_msg = []

node = sample_path[0]

for next_node in sample_path[1:]:
    i = sys.get(node)
    for j in i:
        if next_node in i.get(j):
            all_msg.append(j)
            if j in max_candidate:
                obs_msg.append(j)
    node = next_node

print "path:", sample_path, "\n"
print "all message sequence:", all_msg, "\n"
print "max message candidate:", max_candidate, "\n"
print "observed message sequence:", obs_msg, "\n"
