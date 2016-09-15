'''

Sequential Pattern Mining written by : Debjit Pal
Email ID: dpal2@illinois.edu
Institute: Univerisity of Illinois at Urbana-Champaign
Papers:
    1. Direct Mining of Discriminative and Essential Frequent Patterns via Model-based Tree (Wei Fan, Kun Zhang, Hong Cheng, Jing Gao, Jiawei Hanm 2008)
    2. Constrained Frequent Pattern Mining: A Pattern-Growth View (Jian Pei, Jiawei Han, 2002)
    3. Mining Sequential Patterns with Constraints in Large Databases (Jian Pei, Jiawei Han, Wei Wang, 2002)

'''

import os, sys
import pprint
import re
import itertools import izip
import itertools import count
import argparse as agp


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


class DiscriminativePattModelSearchTree():
    def __init__(
            self,
            enabled = 1,
            ):
        self.enabled = enabled


if __name__ == "__main__":
    DiscriminativePattModelSearchTree = DiscriminativePattModelSearchTree()
    SequntialMiningWithConstraints = SequntialMiningWithConstraints()
    ReadConstraints = ReadConstraints()
