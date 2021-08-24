'''

Episode Mining written by : Debjit Pal
Email ID: dpal2@illinois.edu
Institute: Univerisity of Illinois at Urbana-Champaign
Paper: Automatic Generation of System Level Assertions from Transaction Level Models, Lingyi Liu et. al 2014

'''
import pprint
from types import *

class EpisodeMining():
    def __init__(
            self,
            enabled = 1,
            window_length = 1,
            min_sup = 1,
            ):
        self.enabled = enabled
        self.window_length = window_length
        self.min_sup = min_sup

    def EventContainment(self, Pattern, Text):
        assert type(Pattern) is TupleType, "EventContainment: Expected \"Pattern\" Tuple Type. Received %r" % type(Pattern)
        assert type(Text) is TupleType, "EventContainment: Expected \"Text\" Tuple Type. Received %r" % type(Text)
        pos = 0
        offset = 0
        for i in range(len(Pattern)):
            try:
                offset = Text[pos:].index(Pattern[i])
            except ValueError:
                pos = -1
                #print Pattern, Text, '-1'
                return False
            pos = pos + offset + 1
            if pos == len(Text) and i < len(Pattern) - 1:
                #print Pattern, Text, '-1'
                return False
        #print Pattern, Text, '1'
        return True

    def GetEvents(self, Event_Seq, nxtStart, pointer):
        eventTuple = ()
        currPoint = nxtStart
        while True:
            #print currPoint
            if pointer >= len(Event_Seq):
                break
            currEventElements = Event_Seq[pointer].split('@')
            #print currEventElements
            currPoint = int(currEventElements[1])
            if currPoint > nxtStart + self.window_length:
                break
            eventTuple = eventTuple + tuple([currEventElements[0].lstrip().rstrip()])
            pointer = pointer + 1
        #print eventTuple
        return eventTuple, pointer
        
    def Freq_Check(self, Event_Set, Event_Seq, start_cycle, stop_cycle):
        '''
        Event Set: A Tuple
        Event Req: A Tuple
        '''
        FreqEpisode = {}
        pointer = 0
        nxtStart = start_cycle
        while nxtStart <= stop_cycle:
            eventTuple, pointer = self.GetEvents(Event_Seq, nxtStart, pointer)
            #print eventTuple
            if not eventTuple:
                nxtStart = nxtStart + self.window_length
                continue
            for event in Event_Set:
                #print event
                # A subtle change to handle non-tupletype and tuple type
                if type(event) is not TupleType:
                    event = tuple([event])
                #print event, eventTuple
                if self.EventContainment(event, eventTuple):
                    #print "Entered"
                    if event in FreqEpisode.keys():
                        FreqEpisode[event] = FreqEpisode[event] + 1
                    else:
                        FreqEpisode[event] = 1
            nxtStart = nxtStart + self.window_length
        # After all the Frequencies of the Event Episode are calculated make
        # another pass to see which Episode is more frequent using the min_sup 
        # value. Keep those Event Sequence which is frequent enough
        #print FreqEpisode
        for key in FreqEpisode.keys():
            if FreqEpisode[key] < self.min_sup:
                try:
                    del FreqEpisode[key]
                except KeyError:
                    pass
        return FreqEpisode


    def Cand_Gen(self, FreqEpisodesPrev):
        assert type(FreqEpisodesPrev) is ListType, "Cand_Gen: Expected \"FreqEpisodesPrev\" Tuple Type. Received %r" % type(FreqEpisodesPrev)
        EpisodeCurrent = []
        sizeOfFreqEpisode = len(FreqEpisodesPrev)
        #print sizeOfFreqEpisode
        for i in range(sizeOfFreqEpisode):
            for j in range(sizeOfFreqEpisode):
                if i == j:
                    continue
                iPostfix = self.GetPostfix(tuple(FreqEpisodesPrev[i]))
                jPostfix = self.GetPostfix(tuple(FreqEpisodesPrev[j]))
        
                iPrefix = self.GetPrefix(tuple(FreqEpisodesPrev[i]))
                jPrefix = self.GetPrefix(tuple(FreqEpisodesPrev[j]))
                
                # Considering Postfix of i and Prefix of j and concatenating i < j
                if iPostfix == jPrefix:
                    if FreqEpisodesPrev[j][-1] is not TupleType:
                        newTuple = tuple(FreqEpisodesPrev[i]) + tuple([FreqEpisodesPrev[j][-1]])
                    else:
                        newTuple = tuple(FreqEpisodesPrev[i]) + tuple(FreqEpisodesPrev[j][-1])
                    # print FreqEpisodesPrev[i], FreqEpisodesPrev[j][-1], newTuple
                    EpisodeCurrent.append(newTuple)
                # Considering Postfix of j and Prefix of i and concatenating j < i
                if jPostfix == iPrefix:
                    if FreqEpisodesPrev[i][-1] is not TupleType:
                        newTuple = tuple(FreqEpisodesPrev[j]) + tuple([FreqEpisodesPrev[i][-1]])
                    else:
                        newTuple = tuple(FreqEpisodesPrev[j]) + tuple(FreqEpisodesPrev[i][-1])
                    # print newTuple
                    EpisodeCurrent.append(newTuple)
        # list(set(A)) : This will convert the list in a SET of unique elements and will then convert it back to a list. So that if Prefix and PostFix 
        # calculation produce duplicate Candidates, they will be removed
        return list(set(EpisodeCurrent))

    def GetPrefix(self, Episode):
        '''
        Consider Episode as a tuple. Prefix is the Episode with its last element removed
        '''
        return Episode[:-1]

    def GetPostfix(self, Episode):
        '''
        Consider Episode as a lilst. Postfix is the Episode with its first element removed
        '''
        return Episode[1:]

    def GetPrefixSupport(self, Episode, FreqEpisode):
        '''
        Find the support of the prefix of an Episode
        '''
        return FreqEpisode[self.GetPrefix(Episode)]

    def EpisodeMine(self, Event_Set, Event_Seq, start_cycle, stop_cycle):
        '''
        Event_Set: A tuple enlistig all possible events
        Event_Seq: A tuple containing events that happened in the execution along with the
        cycle stamp in the format e:t
        '''
        # Dictionary to store frequent episode with the occurence frequency / support
        FreqEpisode = {}
        EpisodeConf = {}
        # Two more dictionaries to hold the current and the previous iteration Frequent
        # Episodes. LPrev holds the frequent episodes of the previous iteration
        # And the LCurr holds the frequent episodes of the current iteration
        LPrev = {}
        LCurr = {}
        index = 1
        LPrev = self.Freq_Check(Event_Set, Event_Seq, start_cycle, stop_cycle)
        FreqEpisode.update(LPrev)
        #print LPrev
        LCurr = LPrev
        #while index <= 2:
        while True:
            print "Mining Episodes for Iteration : " + str(index)
            CandCurr = self.Cand_Gen(LPrev.keys())
            LCurr = self.Freq_Check(CandCurr, Event_Seq, start_cycle, stop_cycle)
            if LCurr:
                #FreqEpisodei.append(tuple(LCurr.keys()))
                print "Total Frequent Episodes in current iteration: ", len(LCurr), "\n"
                pprint.pprint(LCurr)
                for key in LCurr.keys():
                    if FreqEpisode[self.GetPrefix(key)] == LCurr[key]:
                        currentKeyConf = {key:1.0}
                        EpisodeConf.update(currentKeyConf)
                        try:
                            del EpisodeConf[self.GetPrefix(key)]
                        except KeyError:
                            pass
                    else:
                        currentKeyConf = {key: LCurr[key] / float(FreqEpisode[self.GetPrefix(key)]) }
                        EpisodeConf.update(currentKeyConf)
                for key in LCurr.keys():
                    try:
                        del FreqEpisode[self.GetPrefix(key)]
                    except KeyError:
                        pass
                    try:
                        del FreqEpisode[self.GetPostfix(key)]
                    except KeyError:
                        pass
                FreqEpisode.update(LCurr)
            else:
                print "No more Frequent Episodes found in current iteration. Breaking at iteration: ", index, "\n\n"
                break
            LPrev = LCurr
            index = index + 1
        return FreqEpisode, EpisodeConf
