def MessageSel(buffer_width, listmsg, epsilon, message_group, sys):
    # Mcomm : ListType
    Mcomm = FindCommonMsgSegments(message_group)
    # Mtrace : DictType
    # Infocurr : FloatType
    Mtrace, Infocurr = FindMessages(sys, listmsg)
    # Ginc : ListType
    Ginc = GrIncluded(Mtrace, message_group)
    # Gninc : ListType
    Gninc = [item for item in message_group.keys() if item not in Ginc]
    # Mrem : ListType
    Mrem = [item for item in listmsg if item not in Mtrace.keys()]
    # Bufrem : IntType
    Bufrem = buffer_width - len(Mtrace)
    Mtrace = NewGrMessageSel(Mtrace, Bufrem, epsilon, Gninc, Mrem, Mcomm)
    
    Bufrem = buffer_width - len(Mtrace)
    Mtrace = AddMsgInExisting(Mtrace, Bufrem, epsilon, Ginc, Mrem, Mcomm)

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
	                       mp = ele:message_group[msg][ele]
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
	                       mp = ele:message_group[msg][ele]
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
            return Mtrace
        mp = {}
    return Mtrace

def AddMsgInExisting(Mtrace, Bufrem, epsilon, Ginc, Mrem, Mcomm):
    for msg in Mrem:
        if Bufrem > epsilon:
            Mtemp = Mtrace
            if m in Ginc:
                for key_ in message_group[m].keys():
                    if message_group[m][key_] <= Bufrem and key in Mcomm:
                        Mtemp.update(key:message_group[m][key_])
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
                        Mtemp.update(key:message_group[m][key_])
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
    for msg in Mrem.keys():
        Mtemp = Mtrace
        if Bufrem > epsilon:
            if Mrem[msg] <= Bufrem:
                Mtemp.update(msg:Mrem[msg])
                Infonew = FindMessages(sys, Mtemp.keys())
                if Infonew >= Infocurr:
                    Mtrace= Mtemp
                    Bufrem = len(Mtrace)
                    Infocurr = Infonew
                Mrem.remove(msg)
        else:
            return Mtrace
    return Mtrace
