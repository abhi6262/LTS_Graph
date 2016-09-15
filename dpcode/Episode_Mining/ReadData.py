import os, sys, time
import numpy as np
import pydot as pd
import numpy as np
from matplotlib import colors
import pprint
from types import *

class ReadData():
    def __init__(
            self,
            enabled = 1,
            ):
        self.enabled = enabled
    '''
    def ReadEventSet(self, EventFileName):
        Event_Set = ()
        with open(EventFileName) as f:
            for line in f:
                #print line.rstrip().lstrip()
                Event_Set = Event_Set + tuple([line.rstrip().lstrip()])
        f.close()
        return Event_Set
    '''
    def ReadEventSequence(self, EventSeqFile):
        Event_Set = ()
        Event_Seq = ()
        start_cycle = sys.maxint
        stop_cycle = 0
        with open(EventSeqFile) as f:
            for line in f:
                #print line.rstrip().lstrip()
                event_ = line[:line.index('@')].rstrip().lstrip()
                currCycle = int(line[line.index('@')+1:].lstrip().rstrip())
                try:
                    index = Event_Set.index(event_)
                except ValueError:
                    Event_Set = Event_Set + tuple([event_])
                start_cycle = currCycle if currCycle < start_cycle else start_cycle
                stop_cycle = currCycle if currCycle > stop_cycle else stop_cycle
                Event_Seq = Event_Seq + tuple([line.rstrip().lstrip()])
        f.close()
        return Event_Set, Event_Seq, start_cycle, stop_cycle
