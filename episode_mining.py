import os, sys
import time
import argparse as agp
import numpy as np

parser = agp.ArgumentParser(
        description='Episode Mining Code for Post-Silicon Traceability of Message Transactions\nAuthor: Debjit Pal\nEmail: dpal2@illinois.edu', formatter_class=agp.RawTextHelpFormatter
        )
parser.add_argument("-w", "--window-length", help="Length of the window in cycles", required=True)
parser.add_argument("-s", "--min-support", help="Minimum support value", required=True)
#The following two parameters to segregate the message trace to make sure we are not mining from traces which are not relevant#
parser.add_argument("-m", "--start-cycle", help="Start cycle of the trace", required=True)
parser.add_argument("-M", "--stop-cycle", help="End cycle of the trace", required=True)
args = parser.parse_args()

# Variables holding the runtime options
window_length = args.window-length
min_sup = args.min-support
start_cycle = args.start-cycle
stop_cycle = args.stop_cycle

class EpisodeMining():
    def __init__(
            self,
            enabled = 1,
            ):
        self.enabled = enabled

    def Freq_Check(self, Event_Set, Event_Seq):
        FreqEpisode = {}
        pointer = start_cycle
        nxtStart = 0
        while pointer <= stop_cycle:
            eventTuple, nxtStart = self.GetEvents(Event_Set, nxtStart)
            for event in Event_Set:
                if set(event) < set(eventTuple):
                    if event in FreqEpisode.keys():
                        FreqEpisode[event] = FreqEpisode[event] + 1
                    else:
                        FreqEpisode[event] = 1
            pointer = pointer + window_length
        # After all the Frequencies of the Event Episode are calculated make
        # another pass to see which Episode is more frequent using the min_sup 
        # value. Keep those Event Sequence which is frequent enough
        for key in FreqEpisode.keys():
            if FreqEpisode[key] < min_sup:
                try:
                    del FreqEpisode[key]
                except KeyError:
                    pass
        return FreqEpisode


    def Cand_Gen(self, FreqEpisodesPrev):
        EpisodeCurrent = []
        sizeOfFreqEpisode = len(FreqEpisodesPrev)
        for i in range(sizeOfFreqEpisode):
            for j in range(sizeOfFreqEpisode):
                if i == j:
                    continue
                # Considering Postfix of i and Prefix of j and concatenating i < j
                if self.GetPostfix(FreqEpisodesPrev[i]) == self.GetPrefix(FreqEpisodesPrev[j]):
                    newTuple = FreqEpisodesPrev[i] + tuple(FreqEpisodesPrev[j][-1])
                    EpisodeCurrent.append(newTuple)
                # Considering Postfix of j and Prefix of i and concatenating j < i
                if self.GetPostfix(FreqEpisodesPrev[j]) == self.GetPrefix(FreqEpisodesPrev[i]):
                    newTuple = FreqEpisodesPrev[j] + tuple(FreqEpisodesPrev[i][-1])
                    EpisodeCurrent.append(newTuple)
        return EpisodeCurrent


    def NextFreqEpisode(self):
        return 1


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
        FreqEpisode = {}
        # Two more dictionaries to hold the current and the previous iteration Frequent
        # Episodes. LPrev holds the frequent episodes of the previous iteration
        # And the LCurr holds the frequent episodes of the current iteration
        LPrev = {}
        LCurr = {}
        index = 1
        LPrev = self.Freq_Check(Event_Set, Event_Seq)
        LCurr = LPrev
        while LCurr:
            print "Mining Episodes for Iteration : " + str(index)
            CandCurr = self.Cand_Gen(LPrev.keys())
            LCurr = self.Freq_Check(CandCurr)
            FreqEpisode = self.NextFreqEpisode(FreqEpisode, LCurr.keys())
            LPrev = LCurr
            index = index + 1
        return FreqEpisode





if __name__ == "__main__":
    print "Initializing Episode Mining with the following parameters:"
    print "Window length = " + str(window_length) + " Minimum Support = " + str(min_sup) + " Start Cycle = " + str(start_cycle) + " Stop Cycle = " + str(stop_cycle)
