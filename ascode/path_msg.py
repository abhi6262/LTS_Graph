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
#sample_path = [('a', 'd'), ('b', 'd'), ('b', 'e'), ('b', 'f'), ('c', 'f')]
all_msg = []
obs_msg = []
unique_paths = {}
unique_paths_all_msg = []
unique_paths_obs_msg = []

f=open('pathdump','rb')

for i in range(10000):
    sample_path = pickle.load(f)
    node = sample_path[0]

    for next_node in sample_path[1:]:
        i = sys.get(node)
        for j in i:
            if next_node in i.get(j):
                all_msg.append(j)
                if j in max_candidate[max(max_candidate)]:
                    obs_msg.append(j)
        node = next_node

    if (obs_msg not in unique_paths_obs_msg):
        unique_paths_all_msg.append(all_msg)
        unique_paths_obs_msg.append(obs_msg)
        unique_paths[unique_paths_obs_msg.index(obs_msg)] = []
        unique_paths[unique_paths_obs_msg.index(obs_msg)].append(sample_path)
    else:
        unique_paths[unique_paths_obs_msg.index(obs_msg)].append(sample_path)

    all_msg = []
    obs_msg = []

paths_max = 0
for i in range(len(unique_paths_obs_msg)):
    #print "path:", sample_path, "\n"
    #print "all message sequence:", all_msg, "\n"
    #print "max message candidate:", max_candidate, "\n"
    print "############################################################\n"
    print "observed message sequence:", unique_paths_obs_msg[i], "\n"
    print "number of paths for the message sequence = ", len(unique_paths[i]), "\n"
    print "paths for the message sequence:\n"
    for j in unique_paths[i]:
        print j, "\n"
    print "############################################################\n"
    if (len(unique_paths[i]) > paths_max):
        paths_max = len(unique_paths[i])

print "number of unique message sequences:", len(unique_paths_obs_msg), "\n"
print "maximum number of paths for a single message sequence = ", paths_max, "\n"

f.close()
