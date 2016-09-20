'''
PrefixSpan Code written by: Debjit Pal
Email ID: dpal2@illinois.edu
Institute: University of Illinois at Urbana-Chmapaign
Paper: PrefixSpan: Mining Sequential Patterns Efficiently by Prefix-Projected Pattern Growth, Jian Pei, Jiawei Han
'''

import sys
import argparse as agp
import regex as rx
from PrefixSpan import *
from ReadData import *

#sys.tracebacklimit = 0
print "\n"

parser = agp.ArgumentParser(
        description='\nSequential Pattern Mining Code using PrefixSpan as the Algorith.\nAuthor: Debjit Pal\nEmail: dpal2@illinois.edu', formatter_class=agp.RawTextHelpFormatter
        )
parser.add_argument("-s", "--min-support", help="Minimum support value", type=int, dest="min_sup", required=True)
# Still need to decide one thing, since each simulation is one transactional database and we 
# are going to segregate the simulation log based on the failure symptoms (talk technical !! ;))
# then how to handle the ReadData class. As of now since we are building the code, we can 
# go with our present approach of having all the transactions in one file.
# Possibly we can identify director containing all the logs having same failure symptom
# or we can give a single file name. Needs to figure out
parser.add_argument("-E", "--event-seq", help="File containing events that happened during execution", dest="event_seq", required=True)
parser.add_argument("-C", "--constraints-file", help="File containing the constraints for Sequential Mining", dest="constraints_file")
args = parser.parse_args()

min_sup = args.min_sup
event_seq = args.event_seq
constraints_file = args.constraints_file

if __name__ == "__main__":
    '''
    Main Functions. Creats instances of required classes
    '''
    ReadData = ReadData()
    PrefixSpan = PrefixSpan()
    # SDB will be a list of strings. Each string is an element/transaction/itemset of 
    # the sequence. Every element/transaction/itemset will have one or more than one
    # item
    Constraints = []
    SDB = ReadData.ReadEventSequence(event_seq)
    if constraints_file is not None:
        Constraints = ReadData.ReadConstraints(constraints_file)
    if constraints_file is not None:
        for Constraint in Constraints:
            print Constraint.ConstraintID, Constraint.ConstraintType, Constraint.ConstraintItems, Constraint.ConstraintOperator, Constraint.ConstraintDuration, Constraint.ConstraintLength, Constraint.ConstraintRegExp
    SDB_ = []
    for key in SDB.keys():
        SDB_.append(SDB[key])

    # Algorithm 1 of Prefix Span Paper. Call PrefixSpan with Empty Sequence
    # AllPatterns stores all Sequential Pattern with their support
    AllPatterns = []
    if constraints_file is not None:
        AllPatterns = PrefixSpan.PrefixSpanWithConstraints(SeqPattern([], sys.maxint), SDB_, min_sup, Constraints)
    else:
        AllPatterns = PrefixSpan.PrefixSpan(SeqPattern([], sys.maxint), SDB_, min_sup)
    # Used sorting help from here: https://wiki.python.org/moin/HowTo/Sorting
    AllPatternsSorted = sorted(AllPatterns, key=lambda Pattern: Pattern.Support, reverse=True)
    for Pattern_ in AllPatternsSorted:
        print ReadData.PrintPatternInStringFormat(Pattern_.Sequence, 1) + ' :: Support : ' + str(Pattern_.Support)
