import os
import sys as ss
import itertools
import math
import ast, ast
import pickle as pk
import ConfigParser
from types import *


def FindCommonMsgSegments(message_group):
    '''
    Checked Ok. Working
    '''
    CommonMsgSegs = []
    KeyCombinations = itertools.combinations(message_group.keys(), 2)
    for it in KeyCombinations:
        item0 = message_group[it[0]].keys()
        item1 = message_group[it[1]].keys()
        common = [item for item in item0 if item in item1]
        if common:
            print "Common message segments found in between Message Group: ", it[0], it[1], "\n"
            CommonMsgSegs.extend(common)
        else:
            print "No common message segments found in between Message Group: ", it[0], it[1], "\n"

    CommonMsgSegs = list(set(CommonMsgSegs))
    return CommonMsgSegs

def GrIncluded(Mtrace, message_group):
    GrInTrace =  Mtrace.keys()
    MessageGrs = message_group.keys()
    GrIncluded = [item for item in MessageGrs if item in GrInTrace]
    return GrIncluded

def MessageSel(buffer_width, listmsg, countlistmsg, epsilon, message_width, message_group, sys, x, x_y):
    # Mcomm : ListType
    Mcomm = FindCommonMsgSegments(message_group)
    print "Common Message Segments Mcomm: ", Mcomm, "\n"
    # Mtrace : DictType
    # Infocurr : FloatType
    candidates = GetAllPossibleCandidates(listmsg, message_width, buffer_width)
    Mtrace, TotalBits, Infocurr = EvalMsgGroups(message_width, candidates, sysnodes, listmsg, countlistmsg, x, x_y)
    print "Current Messages To Trace: ", Mtrace, "Total Bit Width: ", TotalBits
    # Ginc : ListType
    Ginc = GrIncluded(Mtrace, message_group)
    print "Group Included: ", Ginc
    # Gninc : ListType
    Gninc = [item for item in message_group.keys() if item not in Ginc]
    print "Group Not Included: ", Gninc
    # Mrem : ListType
    Mrem = [item for item in listmsg if item not in Mtrace.keys()]
    print "Message Set Remaining (Including any groups): ", Mrem
    ss.exit(0)
    # Bufrem : IntType
    Bufrem = buffer_width - len(Mtrace)
    Mtrace = NewGrMessageSel(Mtrace, Bufrem, epsilon, Gninc, Mrem, Mcomm)
    
    Bufrem = buffer_width - len(Mtrace)
    Mtrace = AddMsgInExistingGr(Mtrace, Bufrem, epsilon, Ginc, Mrem, Mcomm)

    Bufrem = buffer_width - len(Mtrace)
    Mtrace = AddStandAloneMsgs(Mtrace, Bufrem, epsilon)

    return Mtrace

def NewGrMessageSel(Mtrace, Bufrem, epsilon, Gninc, Mrem, Mcomm):
    Mpcomm = []
    mp = {}
    for msg in Mrem:
        Mtemp = Mtrace
        if Bufrem > epsilon:
           if msg in Gninc:
               try:
                   Mpcomm = [item for item in Mcomm if item in message_group[msg].keys()]
               except KeyError:
                   pass
	       if Mpcomm:
	           Mtilde = []
	           currsize = -1
	           for item in Mpcomm:
	               try:
	                   ItemWidth = message_group[msg][item]
	                   if ItemWidth <= Bufrem:
	                       Mtilde.append(item)
	               except KeyError:
	                   pass
	           if Mtilde:
	               for ele in Mtilde:
	                   if message_group[msg][ele] > currsize:
	                       mp[ele] = message_group[msg][ele]
	                       currsize = message_group[msg][ele]
	               Mcomm.remove(mp.keys()[0])
	       else:
	           Mtilde = []
	           currsize = -1
	           try:
	               Mtilde = message_group[msg].keys()
	           except KeyError:
	               pass
	           
	           if Mtilde:
	               for ele in Mtilde:
	                   if message_group[msg][ele] > currsize:
	                       mp[ele] = message_group[msg][ele]
	                       currsize = message_group[msg][ele]
	               del message_group[msg][mp.keys()[0]]
	       Mtemp.update(mp)
	       Infonew = FindMessages(sys, Mtemp.keys())
	       if Infonew > Infocurr:
                   Mtrace = Mtemp
                   Bufrem = len(Mtrace)
	           Infocurr = Infonew
	           Ginc.append(mp.keys()[0])
	           Gninc = [item for item in Gninc if item not in mp.keys()]
               else:
                   print "No modification to Mtrace made in NewGrMessageSel\n"
        else:
            return Mtrace
        mp = {}
    return Mtrace

def AddMsgInExistingGr(Mtrace, Bufrem, epsilon, Ginc, Mrem, Mcomm):
    mp = {}
    for msg in Mrem:
        if Bufrem > epsilon:
            Mtemp = Mtrace
            if m in Ginc:
                for key_ in message_group[m].keys():
                    if message_group[m][key_] <= Bufrem and key in Mcomm:
                        mp[key] = message_group[m][key_]
                        Mtemp.update(mp)
                    Infonew = FindMessages(sys, Mtemp.keys())
                    if Infonew >= Infocurr:
                        Mtrace = Mtemp
                        Bufrem = len(Mtrace)
                        Infocurr = Infonew
                    del message_group[m][key_]
        else:
            return Mtrace
    for msg in Mrem:
        if Bufrem > epsilon:
            Mtemp = Mtrace
            if msg in Ginc:
                for key_ in message_group[m].keys():
                    if message_group[m][key_] <= Bufrem:
                        mp[key] = message_group[m][key_]
                        Mtemp.update(mp)
                    Infonew = FindMessages(sys, Mtemp.keys())
                    if Infonew >= Infocurr:
                        Mtrace = Mtemp
                        Bufrem = len(Mtrace)
                        Infocurr = Infonew
                    del message_group[m][key_]
                Mrem.remove(msg)
        else:
            return Mtrace
    return Mtrace

def AddStandAloneMsgs(Mtrace, bufrem, epsilon):
    mp = {}
    for msg in Mrem.keys():
        Mtemp = Mtrace
        if Bufrem > epsilon:
            if Mrem[msg] <= Bufrem:
                mp[msg] = Mrem[msg]
                Mtemp.update(mp)
                Infonew = FindMessages(sys, Mtemp.keys())
                if Infonew >= Infocurr:
                    Mtrace= Mtemp
                    Bufrem = len(Mtrace)
                    Infocurr = Infonew
                Mrem.remove(msg)
        else:
            return Mtrace
    return Mtrace

################## This portion onwards code from Abhishek's file ####################

def mut_info(x_dis, y_dis, xy_dis):
    mi_xy = 0.0
    for i in range(len(x_dis)):
        for j in range(len(y_dis)):
            if xy_dis[i][j] != 0:
                mi_xy += xy_dis[i][j] * (math.log(xy_dis[i][j]/(x_dis[i]*y_dis[j])))
    return mi_xy

def CalculateStateProb(sysnodes):
    x = [float(1)/len(sysnodes)] * len(sysnodes)
    return x

def CalcMessageInLTS(sys, sysnodes):
    listmsg = []
    countlistmsg = []
    for i in sys:
        for j in sys.get(i):
            if j not in listmsg:
                listmsg.append(j)
                countlistmsg.append(0)
            countlistmsg[listmsg.index(j)] += len(sys[i][j])
    return listmsg, countlistmsg

def CalculateStateMsgJointProb(sys, sysnodes, listmsg):
    x_y = [[0 for j in range(len(listmsg))] for i in range(len(sysnodes))]
    for k in sys:
        for j in sys.get(k):
            for i in sys[k].get(j):
                x_y[sysnodes.index(i)][listmsg.index(j)] += 1

    return x_y

def GetAllPossibleCandidates(listmsg, message_width, buffer_width):
    candidates = []
    msg_width_sum = 0
    for j in range(2,len(listmsg)+1):
        for i in itertools.combinations(listmsg, j):
            for k in i:
                msg_width_sum += message_width[k]
            #print "i:", i, "Width: ", msg_width_sum, "\n"
            if (msg_width_sum <= buffer_width):
                candidates.append(i)
            msg_width_sum = 0
    return candidates

def EvalMsgGroups(message_width, candidates, sysnodes, listmsg, countlistmsg, x, x_y):
    max_info = {}
    max_candidate = {}
    info_candidates = {}
    for c in candidates:
        if len(c) not in max_info:
            max_candidate[len(c)] = c
            max_info[len(c)] = 0
        #print "=================================================================\n"
        #print candidates.index(c)+1, ":candidate:", c, "\n"
        y = [0 for i in range(len(c))]
        xy = [[0 for i in range(len(c))] for j in range(len(sysnodes))]
        tempsum = 0
        for m in c:
            y[c.index(m)] += countlistmsg[listmsg.index(m)]
            tempsum += y[c.index(m)]
        for m in c:
            y[c.index(m)] = y[c.index(m)]/float(tempsum)
        #print "y:", y, "\n"
        for i in range(len(sysnodes)):
            for m in c:
                xy[i][c.index(m)] = (x_y[i][listmsg.index(m)]/float(countlistmsg[listmsg.index(m)])) * y[c.index(m)]

        info_candidates[c] = mut_info(x, y, xy)
        #print "info_candidate:", info_candidates[c], "\n"
        if (info_candidates[c] > max_info[len(c)]):
            max_info[len(c)] = info_candidates[c]
            max_candidate[len(c)] = c
        
    MaxEle = max(max_candidate.keys())
    Infocurr = max_info[MaxEle]
    Mtrace = {}
    TotalBits = 0
    for msg in max_candidate[MaxEle]:
        Mtrace[msg] = message_width[msg]
        TotalBits = TotalBits + Mtrace[msg]

    return Mtrace, TotalBits, Infocurr
            

def ReadConfig(configfile, ldumpfile):
    os.system('cls' if os.name == 'nt' else 'clear')
    config = ConfigParser.RawConfigParser()
    config.read(configfile)
    message_width = ast.literal_eval(config.get('Configuration', 'Message_width'))
    buffer_width = config.getint('Configuration', 'Buffer_width')
    message_group = ast.literal_eval(config.get('Configuration', 'Message_group'))

    with open(ldumpfile, 'rb') as f:
        sysnodes = pk.load(f)
        sys = pk.load(f)
    f.close()

    return message_width, buffer_width, message_group, sys, sysnodes


if __name__ == "__main__":
    
    message_width, buffer_width, message_group, sys, sysnodes = ReadConfig('../config.cfg', 'ltsdump')
    print "Message Width: ", message_width, "\n\n", "Buffer Width: ", buffer_width, "\n\n", "Message Group: ", message_group, "\n\n"
    x = CalculateStateProb(sysnodes)
    listmsg, countlistmsg = CalcMessageInLTS(sys, sysnodes)
    x_y = CalculateStateMsgJointProb(sys, sysnodes, listmsg)
    MtraceFinal = MessageSel(buffer_width, listmsg, countlistmsg, 2, message_width, message_group, sys, x, x_y) 

