'''
PrefixSpan Code written by: Debjit Pal
Email ID: dpal2@illinois.edu
Institute: University of Illinois at Urbana-Chmapaign
Paper: PrefixSpan: Mining Sequential Patterns Efficiently by Prefix-Projected Pattern Growth, Jian Pei, Jiawei Han
'''

import os, sys, pprint
from types import *

# Used to identify the item taken in prefix from an element of a sequence containing more than one item
UNDERSCORE = '_'

class ReadData():
    def __init__(
           self,
           enabled = 1,
           ):
        self.enabled = enabled
    
    def ReadEventSequence(self, EventSeqFile):
        '''
        Returns a Sequence Database in a dictionary format where each entry in dictionary is
        of the format SID:Data
        '''
        SDB = {}
        SID = 1
        with open(EventSeqFile) as f:
            for line in f:
                elements = line.lstrip().rstrip().split(',')
                SDB[SID] = elements
                SID = SID + 1
        return SDB

class PrefixSpan():
    def __init__(
            self,
            enabled = 1,
            ):
        self.enabled = enabled

    def FindSeqPatterns(self, SDB):
        assert type(SDB) is DictType, "FindSeqPatterns: Expected \"SDB\" Dict Type. Received %r" % type(SDB) 
        try:
            assert(len(SDB))
        except AssertionError:
            print "SDB is empty"
        # SeqPatterns is a Dictionary storing "local frquent patterns" along with its support
        SeqPatterns = {}

        for key_ in SDB.keys():
            # Consider one sequence
            Sequence = SDB[key_]
            # print Sequence
            # Consider one transaction in a sequence

            # Finding Length 1 Sequence
            UniqueItemSeenSoFarInThisSequence = []
            for element in Sequence:
                # Consider every item in a transaction
                for item in element:
                    if item == ' ':
                        continue
                    if item not in UniqueItemSeenSoFarInThisSequence:
                        UniqueItemSeenSoFarInThisSequence.append(item)
                        if item not in SeqPatterns.keys():
                            SeqPatterns[item] = 1
                        else:
                            SeqPatterns[item] = SeqPatterns[item] + 1

        return SeqPatterns

    def FindProjectedDataBase(self, SeqPatterns, SDB):
        assert type(SDB) is DictType, "FindProjectedDataBase: Expected \"SDB\" Dict Type. Received %r" % type(SDB)
        assert type(SeqPatterns) is ListType, "FindProjectedDataBase: Expected \"SeqPatterns\" List Type. Received %r" % type(SeqPatterns)
        return True


    def GeneratePrefix(self, SeqPatterns, LocalFreqItems):
        assert type(SeqPatterns) is ListType, "GeneratePrefix: Expected \"SeqPatterns\" List Type. Received %r" % type(SeqPatterns)
        assert type(LocalFreqItems) is DictType, "GeneratePrefix: Expected \"LocalFreqItems\" Dict Type. Received %r" % type(LocalFreqItems)

        return True


    def PrefixSpan(self, SDB, SeqPatterns, min_sup):
        assert type(SDB) is DictType, "PrefixSpan: Expected \"SDB\" Dict Type. Received %r" % type(SDB)
        assert type(SeqPatterns) is ListType, "PrefixSpan: Expected \"SeqPatterns\" List Type. Received %r" % type(SeqPatterns)
        assert type(min_sup) is IntType, "PrefixSpan: Expected \"min_sup\" Int Type. Received %r" % type(min_sup)




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
    #pprint.pprint(SDB)
    SeqPatterns = PrefixSpan.FindSeqPatterns(SDB)
    pprint.pprint(SeqPatterns)


