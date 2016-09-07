'''

Episode Mining written by : Debjit Pal
Email ID: dpal2@illinois.edu
Institute: Univerisity of Illinois at Urbana-Champaign
Paper: Automatic Generation of System Level Assertions from Transaction Level Models, Lingyi Liu et. al 2014

'''

#python episode_mining.py -w 15 -s 2 -m 0 -M 50 -E eventseq.txt
import os, sys
import time
import argparse as agp
import numpy as np
from types import *
# Replacing networkx and matplotlib for drawing directed graph. Networkx and Matplotlib
# did not give the desired result
import pydot as pd
from matplotlib import colors 


parser = agp.ArgumentParser(
        description='\nEpisode Mining Code for Post-Silicon Traceability of Message Transactions\nAuthor: Debjit Pal\nEmail: dpal2@illinois.edu', formatter_class=agp.RawTextHelpFormatter
        )
parser.add_argument("-w", "--window-length", help="Length of the window in cycles", type=int, dest="window_length", required=True)
parser.add_argument("-s", "--min-support", help="Minimum support value", type=int, dest="min_sup", required=True)
#The following two parameters to segregate the message trace to make sure we are not mining from traces which are not relevant#
parser.add_argument("-m", "--start-cycle", help="Start cycle of the trace",  type=int, dest="start_cycle", default=0)
parser.add_argument("-M", "--stop-cycle", help="End cycle of the trace", type=int, dest="stop_cycle", default=sys.maxint)
parser.add_argument("-E", "--event-seq", help="Directory / File containing Events happened during execution", dest="event_seq", required=True)
parser.add_argument("-p", "--pic-location", help="Protocol Figure Dump Location", dest="pic_location", required=True)
args = parser.parse_args()

# Variables holding the runtime options
window_length = args.window_length
min_sup = args.min_sup
start_cycle = args.start_cycle
stop_cycle = args.stop_cycle
## To identify is it for all files in a directory or just one file.
## Single argument should do all of them at once
if os.path.isdir(args.event_seq):
    log_dir = args.event_seq
    event_seq = os.listdir(args.event_seq)
elif os.path.isfile(args.event_seq):
    event_seq = [args.event_seq]
pic_location = args.pic_location

colors_ = colors.cnames

class EpisodeMining():
    def __init__(
            self,
            enabled = 1,
            ):
        self.enabled = enabled

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
            if currPoint > nxtStart + window_length:
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
                nxtStart = nxtStart + window_length
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
                print "Total Frequent Episodes in current oteration: ", len(LCurr), "::", LCurr, "\n\n"
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

class DrawProtocolGraph():
    def __init__(
            self,
            enabled = 1
            ):
        self.enabled = enabled

    def DrawGraph(self, FrequentEpisodes, event_seq):
        assert type(FrequentEpisodes) is DictType, "DrawGraph: Expected \"FrequentEpisodes\" ListType. received %r" % type(FrequentEpisodes)
        EdgeList, NodeDict = self.GenerateNodeAndEdge(FrequentEpisodes)

        graph = pd.Dot(graph_type = 'digraph')
        
        ## Add all the nodes in the graph
        for key_ in NodeDict.keys():
            graph.add_node(NodeDict[key_])

        ## Add all the edges in the graph
        for edge in EdgeList:
            graph.add_edge(pd.Edge(NodeDict[edge[0]], NodeDict[edge[1]], label=edge[2], labelfontcolor=colors_['brown'], fontsize="9.0", color=colors_['maroon'], penwidth=edge[3]))

        diag_name = event_seq[:event_seq.find('.')]
        name_of_png_file = pic_location + "/" + diag_name + ".png"
        graph.write_png(name_of_png_file)

        
    def GenerateNodeAndEdge(self, FrequentEpisodes):
        # Create The Graph as the list of the pair of the nodes connected by an edge
        EdgeList = []
        NodeDict = {}
        maxSupport, minSupport = self.FindMaxMin(FrequentEpisodes)
        for episode in FrequentEpisodes.keys():
            ## To handle the pen width in the protocol graph we are making the edge width proportional to the 
            ## support that an edge has
            episodeSupport = FrequentEpisodes[episode]
            assert type(episode) is TupleType, "DrawGraph: Expected \"episode\" TupleType. received %r" % type(episode)
            for element in episode:
                Length = len(element)
                subelement = element[1:Length-1].split(',')
                if subelement[0] not in NodeDict.keys():
                    NodeDict[subelement[0]] = pd.Node(subelement[0], fillcolor=colors_['dodgerblue'], style="filled")
                if subelement[1] not in NodeDict.keys():
                    NodeDict[subelement[1]] = pd.Node(subelement[1], fillcolor=colors_['dodgerblue'], style="filled")
                edge = tuple([subelement[0], subelement[1], subelement[3], 1.0 * episodeSupport / (maxSupport - minSupport)])
                EdgeList.append(edge)

        return EdgeList, NodeDict

    def FindMaxMin(self, FrequentEpisodes):
        maxSupport, minSupport = 0, sys.maxint
        for key_ in FrequentEpisodes.keys():
            maxSupport = FrequentEpisodes[key_] if FrequentEpisodes[key_] > maxSupport else maxSupport
            minSupport = FrequentEpisodes[key_] if FrequentEpisodes[key_] < minSupport else minSupport

        return maxSupport, minSupport

if __name__ == "__main__":

    ReadData = ReadData()
    EpisodeMining = EpisodeMining()
    DrawProtocolGraph = DrawProtocolGraph()

    # Event_Set = ReadData.ReadEventSet(event_all)
    for event_seq_ in event_seq:
        print "Reading Data from file: ", os.path.join(log_dir, event_seq_)
        Event_Set, Event_Seq, start_cycle, stop_cycle = ReadData.ReadEventSequence(os.path.join(log_dir, event_seq_))
        # print Event_Set

        print "Initializing Episode Mining with the following parameters:"
        print "Window length = " + str(window_length) + " Minimum Support = " + str(min_sup) + " Start Cycle = " + str(start_cycle) + " Stop Cycle = " + str(stop_cycle) + "\n"
        #FreqEpisode = EpisodeMining.Freq_Check(Event_Set, Event_Seq)
        #EpisodeCurrent = EpisodeMining.Cand_Gen(FreqEpisode.keys())
        FreqEpisode, EpisodeConf = EpisodeMining.EpisodeMine(Event_Set, Event_Seq, start_cycle, stop_cycle)
        print "Set of All Frequent Episodes are: ", FreqEpisode, "\n" 
        print "Confidence of the Frequent Episodes: ", EpisodeConf
        DrawProtocolGraph.DrawGraph(FreqEpisode, event_seq_)
