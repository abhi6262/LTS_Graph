#########################################################################
#############################Abhishek Sharma#############################
########################Started: 13th Jun 2016###########################
########################Selection of messages############################
########################Finished: 14th Jun 2016##########################
#########################################################################


import os
import sys
import ConfigParser
import ast
import pickle
import itertools
import math
import csv

os.system('cls' if os.name == 'nt' else 'clear')

config = ConfigParser.RawConfigParser()
config.read('config.cfg')
message_width = ast.literal_eval(config.get('Configuration','Message_width'))
buffer_width = config.getint('Configuration','Buffer_width')
print "message width:", message_width, "\n"
print "buffer width in bits:", buffer_width, "\n"

with open('ltsdump', 'rb') as f:
    sysnodes = pickle.load(f)
    sys = pickle.load(f)

f.close()

c = ['grant', 'piowcrd', 'ncucpxreq', 'reqtot', 'readackcpxncuload', 'initdatatxfr', 'readreqpcx', 'datapacket', 'cpxncugnt']
print "candidate message set:", c, "\n"
    

###########################################################################
simulation_obs_msg = ['initdatatxfr', 'readreqpcx', 'readackcpxncuload', 'datapacket', 'reqtot', 'grant', 'datapacket', 'ncucpxreq', 'piowcrd', 'cpxncugnt']

obs_msg = []
unique_paths = {}
unique_paths_obs_msg = []

f=open('pathdump','rb')

for i in range(50000):
	sample_path = pickle.load(f)
	node = sample_path[0]

	for next_node in sample_path[1:]:
		i = sys.get(node)
		for j in i:
			if next_node in i.get(j):
				if j in c:
					obs_msg.append(j)
		node = next_node

	if (obs_msg not in unique_paths_obs_msg):
		unique_paths_obs_msg.append(obs_msg)
		unique_paths[unique_paths_obs_msg.index(obs_msg)] = []
		unique_paths[unique_paths_obs_msg.index(obs_msg)].append(sample_path)
	else:
		unique_paths[unique_paths_obs_msg.index(obs_msg)].append(sample_path)

	obs_msg = []
	
f.close()

print "######################################################\n"
print len(c), ": candidate:", c
print "\n", unique_paths_obs_msg
#print "\n", unique_paths
print "\nnumber of paths:", len(unique_paths[unique_paths_obs_msg.index(simulation_obs_msg)])
print "\n####################################################\n"
