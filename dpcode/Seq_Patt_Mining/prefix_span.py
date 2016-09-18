'''
PrefixSpan Code written by: Debjit Pal
Email ID: dpal2@illinois.edu
Institute: University of Illinois at Urbana-Chmapaign
Paper: PrefixSpan: Mining Sequential Patterns Efficiently by Prefix-Projected Pattern Growth, Jian Pei, Jiawei Han
'''

import sys
from PrefixSpan import *
from ReadData import *

if __name__ == "__main__":
    '''
    Main Functions. Creats instances of required classes
    '''
    ReadData = ReadData()
    PrefixSpan = PrefixSpan()
    # SDB will be a list of strings. Each string is an element/transaction/itemset of 
    # the sequence. Every element/transaction/itemset will have one or more than one
    # item
    SDB = ReadData.ReadEventSequence('SDB_Data.dat')
    SDB_ = []
    for key in SDB.keys():
        SDB_.append(SDB[key])
    # Algorithm 1 of Prefix Span Paper. Call PrefixSpan with Empty Sequence
    # AllPatterns stores all Sequential Pattern with their support
    AllPatterns = PrefixSpan.PrefixSpan(SeqPattern([], sys.maxint), SDB_, 2)
    # Used sorting help from here: https://wiki.python.org/moin/HowTo/Sorting
    AllPatternsSorted = sorted(AllPatterns, key=lambda Pattern: Pattern.Support, reverse=True)
    for Pattern_ in AllPatternsSorted:
        print ReadData.PrintPatternInStringFormat(Pattern_.Sequence) + ' :: Support : ' + str(Pattern_.Support)
