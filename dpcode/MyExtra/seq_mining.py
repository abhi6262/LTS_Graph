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
import numpy as np


'''
1. Direct Mining of Discriminative and Essential Frequent Patterns via Model-based Tree (Wei Fan, Kun Zhang, Hong Cheng, Jing Gao, Jiawei Hanm 2008)
'''

class DiscriminativePattModelSearchTree(SequntialMiningWithConstraints):
    def __init__(
            self,
            enabled = 1,
            ):
        SequntialMiningWithConstraints.__init__(self)
        self.enabled = enabled
    
    def CalcInfoGain(self, C0, C1, P1, P0):
        '''
        C0 = Number of Negative Examples
        C1 = Number of Positive Examples
        P0 = Number of times a pattern alpha has happened in C0
        P1 = Number of times a pattern alpha has happened in C1
        '''
        infoGain = 0.0

        probC0 = 1.0 * C0 / (C0 + C1)
        probC1 = 1.0 * C1 / (C0 + C1)
        entropyC = probC0 * np.log(probC0) + probC1 * np.log(probC1)

        probX0 = 0
        probX1 = 1
        probC1X1 = 1.0 * P1 / (P1 + P0)
        probC0X1 = 1.0 * P0 / (P1 + P0)
        probC1X0 = 1.0 * (C1 - P1) / (C1 + C0 - P1 - P0) 
        probC0X0 = 1.0 * (C0 - P0) / (C1 + C0 - P1 - P0)
        
        # probX1 and probX0 need to be calculated
        infoGain = -entropyC + probX0 * (probC1X0 + probC0X0) + probX1 * (probC1X1 + probC0X1)

        return infoGain

    def BuildModelSearchTree():
        # Feature Set
        FS = []

        SeqPatt = SequntialMiningWithConstraints.SeqMine(DataSet, supp_thres)
        SeqPattInfoGain = {}
        # Evaluate the fitness of each pattern by calculating the info gain
        for pattern in SeqPatt:
            SeqPattInfoGain[pattern] = self.CalcInfoGain()
        # Choose the best pattern alpha as the feature to split
        maxInfoGain = -1.0
        patternMaxInfoGain = ''
        for key_ in SeqPattInfoGain.keys():
            if maxInfoGain < SeqPattInfoGain[key_]:
                patternMaxInfoGain = key_
                maxInfoGain = SeqPattInfoGain[key_]
        # Include the new pattern in the Global Feature Set
        if patternMaxInfoGain:
            FS.append(patternMaxInfoGain)




if __name__ == "__main__":
    ReadConstraints = ReadConstraints()
    DiscriminativePattModelSearchTree = DiscriminativePattModelSearchTree()
