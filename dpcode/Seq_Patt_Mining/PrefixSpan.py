'''
PrefixSpan Code written by: Debjit Pal
Email ID: dpal2@illinois.edu
Institute: University of Illinois at Urbana-Chmapaign
Paper: PrefixSpan: Mining Sequential Patterns Efficiently by Prefix-Projected Pattern Growth, Jian Pei, Jiawei Han
'''

import os, sys, pprint
from types import *
import regex as rx

from ReadData import *

# Used to identify the item taken in prefix from an element of a sequence containing more than one item
UNDERSCORE = '_'
ReadData = ReadData()

class SeqPattern():
    '''
    A Special Class Structure (Data Structure) which holds the Sequence and its Support
    '''
    def __init__(
            self,
            Sequence,
            Support
            ):
        self.Sequence = []
        for element in Sequence:
            self.Sequence.append(list(element))
        self.Support = Support
        self.Length = len(self.Sequence)

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
        self.Length = len(self.Sequence)

class PrefixSpan():
    '''
    Main PrefixSpan algorithm class implementing PrefixSpan algorithm
    '''
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
            #print "SDB is empty"
            return []
        # FreqItems is a List storing "local frquent patterns" in form of SeqPattern
        FreqItems = []
        # For frequent items coming from single item transaction
        Items = {}
        # For Frequent items coming from multiple item transaction
        Items_ = {}
        # Stores the LastItem of the LastElement in the Pattern Sequence
        LastElement = []
        
        # Similar reasoning why using LastElement while finding Frequent Element of the new Projected Database
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
      
        # Throwing away any item which has support less than user specified minimum support i.e. not Frequent Item
        # This one is for items coming from multiple item transaction
        FreqItems.extend([SeqPattern([[UNDERSCORE, Pattern]], Support)
                            for Pattern, Support in Items_.iteritems()
                            if Support >= min_sup])
        # Throwing away any item which has support less than user specified minimum support i.e. not Frequent Item
        # This one is for item coming from single item transaction
        FreqItems.extend([SeqPattern([[Pattern]], Support)
                            for Pattern, Support in Items.iteritems()
                            if Support >= min_sup])

        # Sorting frequent items in terms of Support 
        # Used sorting help from here: https://wiki.python.org/moin/HowTo/Sorting
        SortedList = sorted(FreqItems, key = lambda Pattern: Pattern.Support)

        return SortedList

    def FindProjectedDataBase(self, Pattern, SDB):
        assert type(SDB) is ListType, "FindProjectedDataBase: Expected \"SDB\" List Type. Received %r" % type(SDB)
        assert type(Pattern.Sequence) is ListType, "FindProjectedDataBase: Expected \"Pattern\" List Type. Received %r" % type(Pattern)
        # Since we are dealing with incremental projected database, we only consider
        # Last Element (if single item in pattern) / or Last item of an element of Sequence
        ProjectedDataBase = []
        LastElementOfPattern = Pattern.Sequence[-1]
        LastItemOfLastElementOfPattern = LastElementOfPattern[-1]
        
        for Sequence in SDB:
            ProjectedSDB = []
            for element in Sequence:
                # Going from <a> to <(ab)> using the (_b) Sequence.
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
                # If Prefix found Find the Projected Database
                if FoundPrefix:
                    ElementIndex = Sequence.index(element)
                    LastItemOfLastElementOfPatternIndex = element.index(LastItemOfLastElementOfPattern)
                    # Handling a transaction containing a single item / a transaction containing multiple items
                    # and the last item of the transaction is included in the prefix already
                    if LastItemOfLastElementOfPatternIndex == len(element) - 1:
                        ProjectedSDB = Sequence[ElementIndex + 1:]
                    # handling a transaction containing multiple items and any other item but not the last item 
                    # is included in the prefix already
                    else:
                        ProjectedSDB = Sequence[ElementIndex:]
                        elementModified = element[LastItemOfLastElementOfPatternIndex:]
                        elementModified[0] = UNDERSCORE
                        ProjectedSDB[0] = elementModified
                        #print "From Else: ", ProjectedSDB
                    break
            if ProjectedSDB:
                ProjectedDataBase.append(ProjectedSDB)
        #print ProjectedDataBase, "\n\n"
        return ProjectedDataBase


    def PrefixSpan(self, Pattern, SDB, min_sup):
        '''
        Main Routine of PrefixSpan Algorithm
        '''
        AllPatterns = []
        assert type(SDB) is ListType, "PrefixSpan: Expected \"SDB\" List Type. Received %r" % type(SDB)
        assert type(min_sup) is IntType, "PrefixSpan: Expected \"min_sup\" Int Type. Received %r" % type(min_sup)
        # Step 1: Scan S / alpha once, find the set of frequent items b
        FreqItems = self.FindFreqItems(Pattern, SDB, min_sup)
        for Item_ in FreqItems:
            # Initialize a Sequential Pattern with Current Sequence Pattern and its Support
            SeqPattern_ = SeqPattern(Pattern.Sequence, Pattern.Support)
            # Assemble b to the last element of Sequence to form a new Sequential Pattern
            # Append <b> to current Sequential Pattern to form a new Sequential Pattern
            SeqPattern_.Append(Item_)
            # Output all new Patterns 
            AllPatterns.append(SeqPattern_)
            print "New Pattern Appended: " + ReadData.PrintPatternInStringFormat(SeqPattern_.Sequence, 1) + " Support: " + str(SeqPattern_.Support) + "\n"
            # For each new Sequential Pattern, construct a projected database
            ProjectedDataBase = self.FindProjectedDataBase(SeqPattern_, SDB)
            # Recursively call PrefixSpan with the new Sequential Pattern, new Projected Database and the
            # minimum support value
            NewPatterns = self.PrefixSpan(SeqPattern_, ProjectedDataBase, min_sup)
            # On return from all recursive call, return all Sequential Pattern to main
            AllPatterns.extend(NewPatterns)
        
        return AllPatterns

    def PrefixSpanWithConstraints(self, Pattern, SDB, min_sup, Constraint):
        '''
        Main Routine of PrefixSpan with Constraints Algorithm
        '''
        AllPatterns = []
        assert type(SDB) is ListType, "PrefixSpanWithConstraints: Expected \"SDB\" List Type. Received %r" % type(SDB)
        assert type(min_sup) is IntType, "PrefixSpanWithConstraints: Expected \"min_sup\" Int Type. Received %r" % type(min_sup)
        # Step 1: Find length 1 patterns and reomve irrelevant sequences
        FreqItems = self.FindFreqItems(Pattern, SDB, min_sup)
        for Item_ in FreqItems:
            #print "Working with Item_: ", Item_.Sequence
            # Initialize a Sequential Pattern with Current Sequence Pattern and Its Support
            SeqPattern_ = SeqPattern(Pattern.Sequence, Pattern.Support)
            # Assemble b to the last element of Sequence Pattern to form a new Sequential pattern
            # Append <b> to current Sequential Pattern to form a new Sequential Pattern
            SeqPattern_.Append(Item_)
            # Before outputting a pattern check whether it satisifes the constraint. If it satisfies the constraint
            # push it in AllPatterns for further growth else throw it off.
            SequenceNow = ReadData.PrintPatternInStringFormat(SeqPattern_.Sequence, 0)
            Match = ''
            if Constraint.ConstraintType == 'RE':
                Prog = Constraint.ConstraintRegExp
                Match = True if Prog.match(SequenceNow, partial=True) is not None else False
                if Match:
                    AllPatterns.append(SeqPattern_)
                else:
                    continue
            # For each new Sequential Pattern, construct a projected database
            ProjectedDataBase = self.FindProjectedDataBase(SeqPattern_, SDB)
            # Recursively call PrefixSpan with the new Sequential Pattern, new Projected Database and the
            # minimum support value
            NewPatterns = self.PrefixSpanWithConstraints(SeqPattern_, ProjectedDataBase, min_sup, Constraint)
            # On return from all recursive call, return all Sequential Pattern to main
            AllPatterns.extend(NewPatterns)
       
        return AllPatterns

    '''
    def SatLength(self, SeqPattern_, Constraint):
        CLength = int(Constraint.ConstraintLength)
        COp = Constraint.ConstraintOperator
        if COp == 'ge':
            return SeqPattern_.Length >= CLength
        elif COp == 'le':
            return SeqPattern_.Length <= CLength
        elif COp == 'gt':
            return SeqPattern_.Length > CLength
        elif COp == 'lt':
            return SeqPattern_.Length < CLength
        elif COp == 'eq':
            return SeqPattern_.Length == CLength
        else:
            print "Length Constraint has an Operator: " + COp + " and its unknown to me."
            return False
    '''
