'''

Episode Mining written by : Debjit Pal
Email ID: dpal2@illinois.edu
Institute: Univerisity of Illinois at Urbana-Champaign
Paper: Automatic Generation of System Level Assertions from Transaction Level Models, Lingyi Liu et. al 2014

'''
# Example command lind options

# python episode_mining.py -w 15 -s 2 -m 0 -M 50 -E eventseq.txt
# python episode_mining.py -w 10000 -s 10 -E ../../buggy_message_log_files/Test1/interrupt_DMU_CORE_BLK_enable1_messages.log -p .

import os, sys
import argparse as agp
import pprint
# Importing my own module
from ReadData import ReadData
from DrawProtocolGraph import DrawProtocolGraph
from EpisodeMining import EpisodeMining
## To stop traceback
sys.tracebacklimit=0
print "\n"

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
    try:
        index = args.event_seq.rindex('/')
        log_dir = args.event_seq[:index]
        event_seq = [args.event_seq[index + 1:]]
    except ValueError:
        log_dir = '.'
        event_seq = [args.event_seq]
else:
    raise AssertionError("Specified Directory / File: " + args.event_seq + " not found\n")

pic_location = args.pic_location

if __name__ == "__main__":

    ReadData = ReadData()
    EpisodeMining = EpisodeMining(window_length = window_length, min_sup = min_sup)
    DrawProtocolGraph = DrawProtocolGraph(pic_location = pic_location)

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
        print "Set of All Frequent Episodes are: \n"
        pprint.pprint(FreqEpisode)
        #print "Confidence of the Frequent Episodes: ", EpisodeConf
        DrawProtocolGraph.DrawGraph(FreqEpisode, event_seq_)
