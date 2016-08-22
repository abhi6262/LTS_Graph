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

    def Freq_Check(self):


    def Cand_Gen(self):


    def NextFreqEpisode(self):


    def GetPrefix(self, Episode):


    def GetPostfix(self, Episode):


    def EpisodeMine(self):
        # Dictionary to store frequent episode with the occurence frequency / support
        FreqEpisode = {}
        index = 1
        LPrev = self.Freq_Check(Event_Seq)
        LCurr = LPrev
        while LCurr:
            print "Mining Episodes for Iteration : " + str(index)
            CandCurr = self.Cand_Gen(LPrev)
            LCurr = self.Freq_Check(CandCurr)
            FreqEpisode = self.NextFreqEpisode(FreqEpisode, LCurr)
            LPrev = LCurr
            index = index + 1
        return FreqEpisode





if __name__ == "__main__":
    print "Initializing Episode Mining with the following parameters:"
    print "Window length = " + str(window_length) + " Minimum Support = " + str(min_sup) + " Start Cycle = " + str(start_cycle) + " Stop Cycle = " + str(stop_cycle)
