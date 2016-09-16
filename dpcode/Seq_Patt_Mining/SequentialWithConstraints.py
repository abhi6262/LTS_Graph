import os, sys
import pprint
import re
import itertools import izip
import itertools import count
import numpy as np

'''
Let C be a constraint and alpha be a sequential pattern. The problem of constraint based
sequential pattern mining is to find the complete set of sequential patterns, denoted as SATCpatterns
satisfying a given constraint C
'''

class ReadConstraints():
    def __init__(
            self,
            enabled = 1,
            ):
        self.enabled = enabled

    def ReadDiffConstraints(self, constraint_file):
        gap_cons = {}
        gap_cons_count = 0
        dur_cons = {}
        dur_cons_count = 0
        reg_patt = {}
        reg_patt_count = 0
        wite open(constraint_file) as f:
            for line_no, line in izip(count(), f):
                if line[:2] == 'gap':
                    gap_cons_count = gap_cons_count + 1
                    gap_cons[gap_cons_count] = self.ReadGapCons(line)
                elif line[:2] == 'dur':
                    dur_cons_count = dur_cons_count + 1
                    dur_cons[dur_cons_count] = self.ReadDurCons(line)
                elif line[:2] == 'reg':
                    reg_patt_count = reg_patt_count + 1
                    reg_patt[reg_patt_count] = self.ReadRegPatt(line)
                else:
                    raise AssertionError(line + " @ Line No: " + line_no + " does not contain a valid constraint in " + constraint_file)
        f.close()
        return gap_cons, dur_cons, reg_patt

    def ReadGapCons(self, line):


    def ReadDurCons(self, line):


    def ReadRegPatt(self, line):

class SequntialMiningWithConstraints():
    def __init__(
            self,
            enabled = 1,
            ):
        self.enabled = enabled
    
    def SATC_(self, pattern):
        '''
        Returns true if a Sequential Pattern satisfy a given constraints C
        '''
        return True

    def SATC(self):
        '''
        Returns complete set of sequential patterns satisfying a given constraint C
        '''
        SATCpatterns = []
        for pattern in patterns:
            if self.SATC_(pattern):
                SATCpatterns.append(pattern)

        return SATCpatterns

    def PrunePattern(self):

        return True
