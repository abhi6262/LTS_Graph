import os
import sys as ss
import itertools
import math
import ast
import pickle as pk
import ConfigParser
import re
from types import *

global_dict = {}

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
        #else:
            #print "No common message segments found in between Message Group: ", it[0], it[1], "\n"

    CommonMsgSegs = list(set(CommonMsgSegs))
    return CommonMsgSegs

def GrIncluded(Mtrace, message_group):
    '''
    Checked Ok. Working
    '''
    GrInTrace =  Mtrace.keys()
    MessageGrs = message_group.keys()
    GrIncluded = [item for item in MessageGrs if item in GrInTrace]
    return GrIncluded

def MessageSel(buffer_width, unique_message, listmsg, countlistmsg, epsilon, message_width, message_group, sys, x, x_y):
    # Mcomm : ListType
    Mcomm = FindCommonMsgSegments(message_group)
    print "Common Message Segments Mcomm: ", Mcomm, "\n"
   
    # Part 1: Selecting Messages such that information gain is maximized. (WITHOUT PACKING)
    # Mtrace : DictType
    # Infocurr : FloatType
    candidates = GetAllPossibleCandidates(unique_message, listmsg, message_width, buffer_width)
    #print "Candidates: ", candidates
    Mtrace, TotalBits, Infocurr = EvalMsgGroups(message_width, candidates, sysnodes, listmsg, countlistmsg, x, x_y)
    print "Current Messages To Trace: ", Mtrace, "\n", "Total Bit Width: ", TotalBits

    #Ginc : ListType
    Ginc = GrIncluded(Mtrace, message_group)
    print "Group Included: ", Ginc
    #Gninc : ListType
    Gninc = [item for item in message_group.keys() if item not in Ginc]
    print "Group Not Included: ", Gninc
    #Mrem : ListType
    #Mrem = [item for item in listmsg if item not in Mtrace.keys()]
    Mrem = [item for item in unique_message if item not in Mtrace.keys()]
    print "Message Set Remaining (Including any groups): ", Mrem
    # Bufrem : IntType
    Bufrem = buffer_width - TotalBits
    print "Remaining Buffer: ", Bufrem
    # End of Part 1 Processing

    # Part 2: Selecting any message group which has smaller messages that can be accomodated in the leftover buffer space
    Mtrace, TotalBits, Infocurr = NewGrMessageSel(Mtrace, Bufrem, epsilon, Gninc, Mrem, Mcomm, TotalBits, message_width, sysnodes, listmsg, countlistmsg, x, x_y, Infocurr, Ginc)
    print "Current Messages To Trace after NewGrMessageSel: ", Mtrace, "Total Bit Width: ", TotalBits
    
    Bufrem = buffer_width - TotalBits
    print "Remaining Buffer: ", Bufrem
    # Part 2: End of Part 2 Processing

    #Mtrace, TotalBits, Infocurr = AddMsgInExistingGr(Mtrace, Bufrem, epsilon, Ginc, Mrem, Mcomm, TotalBits, message_width, sysnodes, listmsg, countlistmsg, x, x_y, Infocurr)
    #print "Current Messages To Trace after AddMsgInExistingGr: ", Mtrace, "Total Bit Width: ", TotalBits

    #Bufrem = buffer_width - TotalBits
    #print "Remaining Buffer: ", Bufrem
    #Mtrace, TotalBits, Infocurr = AddStandAloneMsgs(Mtrace, Bufrem, epsilon, Mrem, TotalBits, message_width, sysnodes, listmsg, countlistmsg, x, x_y, Infocurr)
    #print "Current Mesages To Trace after AddStandAloneMsgs: ", Mtrace, "Total Bit Width: ", TotalBits

    return Mtrace

def NewGrMessageSel(Mtrace, Bufrem, epsilon, Gninc, Mrem, Mcomm, TotalBits, message_width, sysnodes, listmsg, countlistmsg, x, x_y, Infocurr, Ginc):
    Mpcomm = []
    mp = {}
    for msg in Mrem:
        print "Mrem message: ", msg
        #print "Keys: ", message_group[msg].keys()
        Mtemp = Mtrace
        if Bufrem > epsilon:
           if msg in Gninc:
               ToDelEle = ''
               try:
                   Mpcomm = [item for item in Mcomm if item in message_group[msg].keys()]
               except KeyError:
                   pass
               print "Mpcomm: ", Mpcomm
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
	                       mp[msg] = message_group[msg][ele]
                               ToDelEle = ele
	                       currsize = message_group[msg][ele]
	               Mcomm.remove(ToDelEle)
	               del message_group[msg][ToDelEle]
	       else:
	           Mtilde = []
	           currsize = -1
                   for item in message_group[msg].keys():
                       try:
                           ItemWidth = message_group[msg][item]
                           if ItemWidth <= Bufrem:
                               Mtilde.append(item)
                       except KeyError:
                           pass
	           if Mtilde:
	               for ele in Mtilde:
	                   if message_group[msg][ele] > currsize:
	                       mp[msg] = message_group[msg][ele]
                               ToDelEle = ele
	                       currsize = message_group[msg][ele]
	               del message_group[msg][ToDelEle]
               print "mp: ", mp
	       Mtemp.update(mp)
               print "Mtemp: ", Mtemp
               # This done to get the indexed messages following the Mtemp.
               candidates = []
               for k in Mtemp.keys():
                   searchRegEx = re.compile(r'[0-9]_' + re.escape(k)).search
                   idx_msg = filterPick(listmsg, searchRegEx)
                   if idx_msg != []:
                       for idx_msg_ in idx_msg:
                           candidates.append(idx_msg_)
               print candidates
               # M and T are placeholder here
	       #M, T, Infonew = EvalMsgGroups(message_width, [tuple(Mtemp.keys())], sysnodes, listmsg, countlistmsg, x, x_y)
	       M, T, Infonew = EvalMsgGroups(message_width, [tuple(candidates)], sysnodes, listmsg, countlistmsg, x, x_y)
               print Infonew, Infocurr
               print mp
	       if Infonew >= Infocurr:
                   print "New gain"
                   Mtrace = Mtemp
                   if mp.keys():
                       TotalBits = TotalBits + mp[mp.keys()[0]]
                       Ginc.append(mp.keys()[0])
                       if mp.keys()[0] in global_dict.keys():
                           global_dict[mp.keys()[0]].extend(ToDelEle)
                       else:
                           global_dict[mp.keys()[0]] = [ToDelEle] 
	               Gninc = [item for item in Gninc if item not in mp.keys()]
                   Bufrem = buffer_width - TotalBits
	           Infocurr = Infonew
               else:
                   print "No modification to Mtrace made in NewGrMessageSel for msg: ", msg, "\n"
        else:
            return Mtrace, TotalBits, Infocurr
        mp = {}
    return Mtrace, TotalBits, Infocurr

def AddMsgInExistingGr(Mtrace, Bufrem, epsilon, Ginc, Mrem, Mcomm, TotalBits, message_width, sysnodes, listmsg, countlistmsg, x, x_y, Infocurr):
    mp = {}
    for msg in Mrem:
        if Bufrem > epsilon:
            Mtemp = Mtrace
            if msg in Ginc:
                for key_ in message_group[msg].keys():
                    if message_group[msg][key_] <= Bufrem and key_ in Mcomm:
                        print "Current key: ", key_, "Bufrem: ", Bufrem
                        mp[msg] = message_group[msg][key_]
                        Mtemp.update(mp)

                    # This done to get the indexed messages following the Mtemp.
                    candidates = []
                    for k in Mtemp.keys():
                        searchRegEx = re.compile(r'[0-9]_' + re.escape(k)).search
                        xMsg = filterPick(listmsg, searchRegEx)
                        if xMsg != []:
                            for idx_msg in xMsg:
                                candidates.append(idx_msg)

                    #M, T, Infonew = EvalMsgGroups(message_width, [tuple(Mtemp.keys())], sysnodes, listmsg, countlistmsg, x, x_y)
                    M, T, Infonew = EvalMsgGroups(message_width, [tuple(candidates)], sysnodes, listmsg, countlistmsg, x, x_y)
                    if Infonew >= Infocurr:
                        Mtrace = Mtemp
                        if mp.keys():
                            TotalBits = TotalBits + mp[mp.keys()[0]]
                        Bufrem = buffer_width - TotalBits
                        Infocurr = Infonew
                        if msg in global_dict.keys():
                            #print msg, key_
                            #print global_dict[msg]
                            #print message_group[msg][key_]
                            #global_dict[msg].extend(message_group[msg][key_])
                            global_dict[msg].extend([key_])
                    del message_group[msg][key_]
        else:
            return Mtrace, TotalBits, Infocurr
    for msg in Mrem:
        if Bufrem > epsilon:
            Mtemp = Mtrace
            if msg in Ginc:
                for key_ in message_group[msg].keys():
                    if message_group[m][key_] <= Bufrem:
                        mp[msg] = message_group[m][key_]
                        Mtemp.update(mp)
                    # This done to get the indexed messages following the Mtemp.
                    candidates = []
                    for k in Mtemp.keys():
                        searchRegEx = re.compile(r'[0-9]_' + re.escape(k)).search
                        xMsg = filterPick(listmsg, searchRegEx)
                        if xMsg != []:
                            for idx_msg in xMsg:
                                candidates.append(idx_msg)

                    #M, T, Infonew = EvalMsgGroups(message_width, [tuple(Mtemp.keys())], sysnodes, listmsg, countlistmsg, x, x_y)
                    M, T, Infonew = EvalMsgGroups(message_width, [tuple(candidates)], sysnodes, listmsg, countlistmsg, x, x_y)
                    if Infonew <= Infocurr:
                        Mtrace = Mtemp
                        TotalBits = TotalBits + mp[mp.keys()[0]]
                        Bufrem = buffer_width - TotalBits
                        Infocurr = Infonew
                    del message_group[m][key_]
                Mrem.remove(msg)
        else:
            return Mtrace, TotalBits, Infocurr
    return Mtrace, TotalBits, Infocurr

def AddStandAloneMsgs(Mtrace, Bufrem, epsilon, Mrem, TotalBits, message_width, sysnodes, listmsg, countlistmsg, x, x_y, Infocurr):
    mp = {}
    for msg in Mrem:
        Mtemp = Mtrace
        if Bufrem > epsilon:
            if message_width[msg] <= Bufrem:
                mp[msg] = Mrem[msg]
                Mtemp.update(mp)
                # This done to get the indexed messages following the Mtemp.
                candidates = []
                for k in Mtemp.keys():
                    searchRegEx = re.compile(r'[0-9]_' + re.escape(k)).search
                    xMsg = filterPick(listmsg, searchRegEx)
                    if xMsg != []:
                        for idx_msg in xMsg:
                            candidates.append(idx_msg)

                #M, T, Infonew = EvalMsgGroups(message_width, [tuple(Mtemp.keys())], sysnodes, listmsg, countlistmsg, x, x_y)
                M, T, Infonew = EvalMsgGroups(message_width, [tuple(candidates)], sysnodes, listmsg, countlistmsg, x, x_y)
                if Infonew <= Infocurr:
                    Mtrace= Mtemp
                    TotalBits = TotalBits + mp[mp.keys()[0]]
                    Bufrem = buffer_width - TotalBits
                    Infocurr = Infonew
                Mrem.remove(msg)
        else:
            return Mtrace, TotalBits, Infocurr
    return Mtrace, TotalBits, Infocurr

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

def filterPick(listmsg, searchRegEx):
    return [ l for l in listmsg for m in (searchRegEx(l),) if m ]

def GetAllPossibleCandidates(unique_message, listmsg, message_width, buffer_width):
    candidates = []
    msg_width_sum = 0
    ''' 
    for j in range(2,len(listmsg)+1):
        for i in itertools.combinations(listmsg, j):
            for k in i:
                msg_width_sum += message_width[k]
            #print "i:", i, "Width: ", msg_width_sum, "\n"
            if (msg_width_sum <= buffer_width):
                candidates.append(i)
            msg_width_sum = 0
    '''
    for j in range(2, len(unique_message) + 1):
        for i in itertools.combinations(unique_message, j):
            #print i
            candidates_ = []
            for k in i:
                msg_width_sum += message_width[k]
            if msg_width_sum <= buffer_width:
                for k in i:
                    searchRegEx = re.compile(r'[0-9]_' + re.escape(k)).search
                    idx_msg = filterPick(listmsg, searchRegEx)
                    if idx_msg != []:
                        for idx_msg_ in idx_msg:
                            candidates_.append(idx_msg_)
            if candidates_ != []:
                candidates.append(tuple(candidates_))
            msg_width_sum = 0
    return candidates

def EvalMsgGroups(message_width, candidates, sysnodes, listmsg, countlistmsg, x, x_y):
    '''
    Working
    '''
    max_info = {}
    max_candidate = {}
    info_candidates = {}
    totaledges = 0
    for ele in range(len(countlistmsg)):
        totaledges = totaledges + countlistmsg[ele]
    for c in candidates:
        #print c
        if len(c) not in max_info:
            max_candidate[len(c)] = c
            max_info[len(c)] = 0
        #print "=================================================================\n"
        #print candidates.index(c)+1, ":candidate:", c, "\n"
        y = [0 for i in range(len(c))]
        xy = [[0 for i in range(len(c))] for j in range(len(sysnodes))]
        #tempsum = 0
        for m in c:
            y[c.index(m)] += countlistmsg[listmsg.index(m)]
            #tempsum += y[c.index(m)]
        for m in c:
            #y[c.index(m)] = y[c.index(m)]/float(tempsum)
            y[c.index(m)] = y[c.index(m)]/float(totaledges)
        #print "y:", y, "\n"
        for i in range(len(sysnodes)):
            for m in c:
                xy[i][c.index(m)] = (x_y[i][listmsg.index(m)]/float(countlistmsg[listmsg.index(m)])) * y[c.index(m)]

        #print "x: ", x
        info_candidates[c] = mut_info(x, y, xy)
        #print info_candidates[c]
        #print "info_candidate:", info_candidates[c], "\n"
        if (info_candidates[c] > max_info[len(c)]):
            max_info[len(c)] = info_candidates[c]
            max_candidate[len(c)] = c
        
    MaxEle = max(max_candidate.keys())
    #print "MaxEle: ", MaxEle
    Infocurr = max_info[MaxEle]
    #print "Infocurr: ", Infocurr
    Mtrace = {}
    TotalBits = 0
    MsgConsidered = []
    for msg in max_candidate[MaxEle]:
        msg_ = msg[msg.find('_') + 1:]
        if msg_ not in MsgConsidered:
            Mtrace[msg_] = message_width[msg_]
            TotalBits = TotalBits + Mtrace[msg_]
            MsgConsidered.append(msg_)

    return Mtrace, TotalBits, Infocurr
            

def ReadConfig(configfile, ldumpfile, Elab_proto):
    '''
    Working
    '''
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
    
    config_elab = ConfigParser.RawConfigParser()
    config_elab.read(Elab_proto)
    unique_message = ast.literal_eval(config_elab.get('Messages', 'UniqueMsg'))

    return message_width, buffer_width, message_group, unique_message, sys, sysnodes


if __name__ == "__main__":
    
    message_width, buffer_width, message_group, unique_message, sys, sysnodes = ReadConfig('../config.cfg', 'ltsdump', './cfg/Elab_proto.cfg')
    print "Message Width: ", message_width, "\n\n", "Buffer Width: ", buffer_width, "\n\n", "Message Group: ", message_group, "\n\n", "Unique Messages: ", unique_message, "\n\n"
    x = CalculateStateProb(sysnodes)
    #print x
    listmsg, countlistmsg = CalcMessageInLTS(sys, sysnodes)
    #print listmsg, countlistmsg
    x_y = CalculateStateMsgJointProb(sys, sysnodes, listmsg)
    #print x_y
    #print len(x_y)
    #ss.exit(0)
    MtraceFinal = MessageSel(buffer_width, unique_message, listmsg, countlistmsg, 0, message_width, message_group, sys, x, x_y) 
    print "\n\n"
    print "Final set of messages to be traced: ", MtraceFinal
    print "\n\n"
    #print global_dict

    #MtraceFinal = {}
    #MtraceFinal['RxInfo'] = 1

    # Part 4: Code for flow specification coverage
    totalState = 0
    msgGrid = []
    for msg_ in MtraceFinal.keys():
        searchRegEx = re.compile(r'[0-9]_' + re.escape(msg_)).search
        idx_msg = filterPick(listmsg, searchRegEx)
        for idx_msg_ in idx_msg:
            msgGrid.append(idx_msg_)
    for state in x_y:
        for msg in msgGrid:
            if state[listmsg.index(msg)] != 0:
                totalState = totalState + 1
                break

    '''
    for list_ in x_y:
        print "List_: ", list_
        for msg_ in MtraceFinal.keys():
            searchRegEx = re.compile(r'[0-9]_' + re.escape(msg_)).search
            xMsg = filterPick(listmsg, searchRegEx)
            print "xMsg: ", xMsg
            for msg in xMsg:
                if list_[listmsg.index(msg)] != 0:
                    totalState = totalState + 1
                    break
    '''
    
    print "Total States: ", len(sysnodes)
    print "Total States Reachable: ", totalState
    print "Total Space Coverage: ", float(totalState)/float(len(sysnodes))


