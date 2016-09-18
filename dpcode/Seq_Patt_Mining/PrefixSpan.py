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
                itemSet = []
                for e in elements:
                    itemSet.append(e.split())
                SDB[SID] = itemSet
                SID = SID + 1
        return SDB

    def PrintPatternInStringFormat(self, Pattern):
        '''
        Take Patterns in List of Lists format and convert them to a String Format for easy understanding
        '''
        stringToPrint = '<'
        for element in Pattern:
            if len(element) == 1:
                stringToPrint = stringToPrint + element[0]
            else:
                stringToPrint = stringToPrint + '('
                for item in element:
                    stringToPrint = stringToPrint + item
                stringToPrint = stringToPrint + ')'
        stringToPrint = stringToPrint + '>'
        return stringToPrint

class SeqPattern():
    def __init__(
            self,
            Sequence,
            Support
            ):
        self.Sequence = []
        for element in Sequence:
            self.Sequence.append(list(element))
        self.Support = Support

    def Append(self, Pattern):
        if Pattern.Sequence[0][0] == UNDERSCORE:
            FirstElement = Pattern.Sequence[0]
            FirstElement.remove(UNDERSCORE)
            # Need to understand this
            self.Sequence[-1].extend(FirstElement)
            self.Sequence.extend(Pattern.Sequence[1:])
        else:
            self.Sequence.extend(Pattern.Sequence)
        self.Support = min(self.Support, Pattern.Support)

class PrefixSpan():
    def __init__(
            self,
            enabled = 1,
            ):
        self.enabled = enabled

    def FindFreqItems(self, Pattern, SDB, min_sup):
        assert type(SDB) is ListType, "FindSeqPatterns: Expected \"SDB\" List Type. Received %r" % type(SDB) 
        try:
            assert(len(SDB))
        except AssertionError:
            print "SDB is empty"
            return []
        # FreqItems is a List storing "local frquent patterns"
        FreqItems = []
        Items = {}
        Items_ = {}
        # Stores the LastItem of the LastElement in the Pattern Sequence
        LastElement = []

        try:
            assert(len(Pattern.Sequence))
            LastElement = Pattern.Sequence[-1]
        except AssertionError:
            LastElement = []

        for Sequence in SDB:
            
            IsPrefix = True
            for item in LastElement:
                if item not in Sequence[0]:
                    IsPrefix = False
                    break
            if IsPrefix and len(LastElement) > 0:
                Index = Sequence[0].index(LastElement[-1])
                if Index < len(Sequence[0]) - 1:
                    for item in Sequence[0][Index + 1:]:
                        if item in Items_.keys():
                            Items_[item] = Items_[item] + 1
                        else:
                            Items_[item] = 1
            
            if UNDERSCORE in Sequence[0]:
                for item in Sequence[0][1:]:
                    if item in Items_.keys():
                        Items_[item] = Items_[item] + 1
                    else:
                        Items_[item] = 1
                Sequence = Sequence[1:]

            UniqueItemSeenSoFarInThisSequence = []
            for element in Sequence:
                # Consider every item in a transaction
                for item in element:
                    if item not in UniqueItemSeenSoFarInThisSequence:
                        UniqueItemSeenSoFarInThisSequence.append(item)
                        if item in Items.keys():
                            Items[item] = Items[item] + 1
                        else:
                            Items[item] = 1
       
        FreqItems.extend([SeqPattern([[UNDERSCORE, Pattern]], Support)
                            for Pattern, Support in Items_.iteritems()
                            if Support >= min_sup])

        FreqItems.extend([SeqPattern([[Pattern]], Support)
                            for Pattern, Support in Items.iteritems()
                            if Support >= min_sup])

        
        SortedList = sorted(FreqItems, key = lambda Pattern: Pattern.Support)

        return SortedList

    def FindProjectedDataBase(self, Pattern, SDB):
        assert type(SDB) is ListType, "FindProjectedDataBase: Expected \"SDB\" List Type. Received %r" % type(SDB)
        assert type(Pattern.Sequence) is ListType, "FindProjectedDataBase: Expected \"Pattern\" List Type. Received %r" % type(Pattern)
        # The following dictionary will contain the Sequences as the key and the projected database
        # as the value of ket
        #print "Received Database: ", pprint.pprint(SDB)
        ProjectedDataBase = []
        LastElementOfPattern = Pattern.Sequence[-1]
        LastItemOfLastElementOfPattern = LastElementOfPattern[-1]
        #print "LastElementOfPattern: ", LastElementOfPattern
        #print "LastItemOfLastElementOfPattern: ", LastItemOfLastElementOfPattern
        for Sequence in SDB:
            #print "Sequence: ", Sequence
            ProjectedSDB = []
            for element in Sequence:
                #print "Element: ", element
                FoundPrefix = False
                if UNDERSCORE in element:
                    if LastItemOfLastElementOfPattern in element and len(LastElementOfPattern) > 1:
                        FoundPrefix = True
                else:
                    FoundPrefix = True
                    for item in LastElementOfPattern:
                        if item not in element:
                            FoundPrefix = False
                            break

                if FoundPrefix:
                    ElementIndex = Sequence.index(element)
                    #print ElementIndex
                    LastItemOfLastElementOfPatternIndex = element.index(LastItemOfLastElementOfPattern)
                    #print LastItemOfLastElementOfPatternIndex
                    if LastItemOfLastElementOfPatternIndex == len(element) - 1:
                        ProjectedSDB = Sequence[ElementIndex + 1:]
                        #print "From If: ", ProjectedSDB
                    else:
                        ProjectedSDB = Sequence[ElementIndex:]
                        elementModified = element[LastItemOfLastElementOfPatternIndex:]
                        elementModified[0] = UNDERSCORE
                        ProjectedSDB[0] = elementModified
                        #print "From Else: ", ProjectedSDB
                    break
            if ProjectedSDB:
                ProjectedDataBase.append(ProjectedSDB)

        return ProjectedDataBase


    def PrefixSpan(self, Pattern, SDB, min_sup):
        AllPatterns = []
        assert type(SDB) is ListType, "PrefixSpan: Expected \"SDB\" List Type. Received %r" % type(SDB)
        assert type(min_sup) is IntType, "PrefixSpan: Expected \"min_sup\" Int Type. Received %r" % type(min_sup)
        
        FreqItems = self.FindFreqItems(Pattern, SDB, min_sup)
        for Item_ in FreqItems:
            SeqPattern_ = SeqPattern(Pattern.Sequence, Pattern.Support)
            SeqPattern_.Append(Item_)
            AllPatterns.append(SeqPattern_)

            ProjectedDataBase = self.FindProjectedDataBase(SeqPattern_, SDB)
            NewPatterns = self.PrefixSpan(SeqPattern_, ProjectedDataBase, min_sup)
            AllPatterns.extend(NewPatterns)
        
        return AllPatterns


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
    AllPatterns = PrefixSpan.PrefixSpan(SeqPattern([], sys.maxint), SDB_, 3)
    for Pattern_ in AllPatterns:
        print ReadData.PrintPatternInStringFormat(Pattern_.Sequence) + ' :: Support : ' + str(Pattern_.Support) 
