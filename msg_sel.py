#########################################################################
#############################Abhishek Sharma#############################
########################Started: 13th Jun 2016###########################
########################Selection of messages############################
########################Finished: ??th Jun 2016##########################
#########################################################################


import os
import sys
import ConfigParser
import ast
import pickle
import itertools
import math

os.system('cls' if os.name == 'nt' else 'clear')

config = ConfigParser.RawConfigParser()
config.read('config.cfg')
Budget = config.getint('Configuration','Budget')

with open('ltsdump', 'rb') as f:
    sysnodes = pickle.load(f)
    sys = pickle.load(f)

f.close()

print "sysnodes: ", sysnodes, "\n", "lensysnodes: ", len(sysnodes), "\n"
#for i in sysnodes:
#    print i, ":", sys[i]
#    print "\n"

######################Mutual Informatio################################
#natural logarithm
def mut_info(x_dis, y_dis, xy_dis):
    mi_xy = 0.0
    for i in range(len(x_dis)):
        for j in range(len(y_dis)):
            if xy_dis[i][j] != 0:
                mi_xy += xy_dis[i][j] * (math.log(xy_dis[i][j]/(x_dis[i]*y_dis[j])))

    return mi_xy;

#######################################################################

x = [float(1)/len(sysnodes)] * len(sysnodes)
print "x:", x, "\n"

listmsg = []
countlistmsg = []
for i in sys:
    for j in sys.get(i):
        if j not in listmsg:
            listmsg.append(j)
            countlistmsg.append(0)
        countlistmsg[listmsg.index(j)] += len(sys[i][j])

x_y = [[0 for j in range(len(listmsg))] for i in range(len(sysnodes))]
#print "x_y:", x_y, "\n"

for k in sys:
#    print "k:", k, "\n"
    for j in sys.get(k):
#        print "j:", j, "\n"
        for i in sys[k].get(j):
#            print "i:", i, "\n"
            x_y[sysnodes.index(i)][listmsg.index(j)] += 1
#            print "x_y[][]:", x_y[sysnodes.index(i)][listmsg.index(j)], "\n"

#print "x_y:", x_y, "\n"

print "list of messages:", listmsg, "\n"
print "count of messages:", countlistmsg, "\n"
candidates = []
info_candidates = {}
for i in itertools.combinations(listmsg, Budget):
    candidates.append(i)

#print candidates
max_info = 0

for c in candidates:
    print "=================================================================\n"
    print candidates.index(c)+1, ":candidate:", c, "\n"
    y = [0 for i in range(Budget)]
    xy = [[0 for i in range(len(c))] for j in range(len(sysnodes))]
    tempsum = 0
    for m in c:
        y[c.index(m)] += countlistmsg[listmsg.index(m)]
        tempsum += y[c.index(m)]
    for m in c:
        y[c.index(m)] = y[c.index(m)]/float(tempsum)
    print "y:", y, "\n"
    for i in range(len(sysnodes)):
        for m in c:
#            print i
#            print m
#            print listmsg.index(m)
#            print y[c.index(m)]
#            print countlistmsg[listmsg.index(m)]
#            print x_y[i][listmsg.index(m)]
            xy[i][c.index(m)] = (x_y[i][listmsg.index(m)]/float(countlistmsg[listmsg.index(m)])) * y[c.index(m)]

    print "xy:", xy, "\n"

    info_candidates[c] = mut_info(x, y, xy)
    print "info_candidate:", info_candidates[c], "\n"
    if (info_candidates[c] > max_info):
        max_info = info_candidates[c]
        max_candidate = c

print "================================================================="
print "*****************************************************************"
print "================================================================="
print "max_info:", max_info, "max_candidate:", max_candidate, "\n"
    
        
