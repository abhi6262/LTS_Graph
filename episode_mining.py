#python episode_mining.py -w 15 -s 2 -m 0 -M 50 -e event.txt -E eventseq.txt
import os, sys
import time
import argparse as agp
import numpy as np
from types import *

parser = agp.ArgumentParser(
        description='Episode Mining Code for Post-Silicon Traceability of Message Transactions\nAuthor: Debjit Pal\nEmail: dpal2@illinois.edu', formatter_class=agp.RawTextHelpFormatter
        )
parser.add_argument("-w", "--window-length", help="Length of the window in cycles", type=int, dest="window_length", required=True)
parser.add_argument("-s", "--min-support", help="Minimum support value", type=int, dest="min_sup", required=True)
#The following two parameters to segregate the message trace to make sure we are not mining from traces which are not relevant#
parser.add_argument("-m", "--start-cycle", help="Start cycle of the trace",  type=int, dest="start_cycle",required=True)
parser.add_argument("-M", "--stop-cycle", help="End cycle of the trace", type=int, dest="stop_cycle", required=True)
parser.add_argument("-e", "--event-all", help="File containing all possible events", dest="event_all", required=True)
parser.add_argument("-E", "--event-seq", help="File containing Events happened during execution", dest="event_seq", required=True)
args = parser.parse_args()

# Variables holding the runtime options
window_length = args.window_length
min_sup = args.min_sup
start_cycle = args.start_cycle
stop_cycle = args.stop_cycle
event_all = args.event_all
event_seq = args.event_seq

class EpisodeMining():
    def __init__(
            self,
            enabled = 1,
            ):
        self.enabled = enabled

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
            if currPoint > nxtStart + window_length:
                break
            eventTuple = eventTuple + tuple([currEventElements[0].lstrip().rstrip()])
            pointer = pointer + 1
        #print eventTuple
        return eventTuple, pointer
        
    def Freq_Check(self, Event_Set, Event_Seq):
        '''
        Event Set: A Tuple
        Event Req: A Tuple
        '''
        FreqEpisode = {}
        pointer = 0
        nxtStart = start_cycle
        while nxtStart <= stop_cycle:
            eventTuple, pointer = self.GetEvents(Event_Seq, nxtStart, pointer)
            for event in Event_Set:
                print tuple(event) , eventTuple, tuple(event) < eventTuple
                if set(event) <= set(eventTuple):
                #if event < eventTuple:
                    if event in FreqEpisode.keys():
                        FreqEpisode[event] = FreqEpisode[event] + 1
                    else:
                        FreqEpisode[event] = 1
            nxtStart = nxtStart + window_length
        # After all the Frequencies of the Event Episode are calculated make
        # another pass to see which Episode is more frequent using the min_sup 
        # value. Keep those Event Sequence which is frequent enough
        #print FreqEpisode
        for key in FreqEpisode.keys():
            if FreqEpisode[key] < min_sup:
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
                    newTuple = tuple(FreqEpisodesPrev[i]) + tuple(FreqEpisodesPrev[j][-1])
                    EpisodeCurrent.append(newTuple)
                # Considering Postfix of j and Prefix of i and concatenating j < i
                if jPostfix == iPrefix:
                    newTuple = tuple(FreqEpisodesPrev[j]) + tuple(FreqEpisodesPrev[i][-1])
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

    def EpisodeMine(self, Event_Set, Event_Seq):
        '''
        Event_Set: A tuple enlistig all possible events
        Event_Seq: A tuple containing events that happened in the execution along with the
        cycle stamp in the format e:t
        '''
        # Dictionary to store frequent episode with the occurence frequency / support
        FreqEpisode = []
        # Two more dictionaries to hold the current and the previous iteration Frequent
        # Episodes. LPrev holds the frequent episodes of the previous iteration
        # And the LCurr holds the frequent episodes of the current iteration
        LPrev = {}
        LCurr = {}
        index = 1
        LPrev = self.Freq_Check(Event_Set, Event_Seq)
        #print LPrev
        LCurr = LPrev
        while index <= 3:
            print "Mining Episodes for Iteration : " + str(index)
            CandCurr = self.Cand_Gen(LPrev.keys())
            LCurr = self.Freq_Check(CandCurr, Event_Seq)
            print LCurr
            if LCurr:
                FreqEpisode.append(LCurr.keys())
            else:
                break
            LPrev = LCurr
            index = index + 1
        return FreqEpisode


class ReadData():
    def __init__(
            self,
            enabled = 1,
            ):
        self.enabled = enabled

    def ReadEventSet(self, EventFileName):
        Event_Set = ()
        with open(EventFileName) as f:
            for line in f:
                #print line.rstrip().lstrip()
                Event_Set = Event_Set + tuple([line.rstrip().lstrip()])
        f.close()
        return Event_Set

    def ReadEventSequence(self, EventSeqFile):
        Event_Seq = ()
        with open(EventSeqFile) as f:
            for line in f:
                #print line.rstrip().lstrip()
                Event_Seq = Event_Seq + tuple([line.rstrip().lstrip()])
        f.close()
        return Event_Seq


if __name__ == "__main__":

    ReadData = ReadData()
    EpisodeMining = EpisodeMining()

    print "Initializing Episode Mining with the following parameters:"
    print "Window length = " + str(window_length) + " Minimum Support = " + str(min_sup) + " Start Cycle = " + str(start_cycle) + " Stop Cycle = " + str(stop_cycle)
    Event_Set = ReadData.ReadEventSet(event_all)
    Event_Seq = ReadData.ReadEventSequence(event_seq)

    #FreqEpisode = EpisodeMining.Freq_Check(Event_Set, Event_Seq)
    #EpisodeCurrent = EpisodeMining.Cand_Gen(FreqEpisode.keys())
    FreqEpisode = EpisodeMining.EpisodeMine(Event_Set, Event_Seq)
    print "Set of All Frequent Episodes are: ", FreqEpisode

