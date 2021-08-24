import os, sys
from types import *

from TreeNode import *
from PrefixSpan import *

Tree = Tree()
PrefixSpan = PrefixSpan()

class ModelBasedSearchTree():
    def __init__(
            self,
            enable = 1,
            ):
        self.enabled = 1

    def ModelBasedSearchTree(self, RootNode, min_sup, min_data_size_in_node):
        '''
        Can use PrefixSpan or PrefixSpanWithConstraints as Mining Algorithm
        The minimum support is specified normalized between 0 and 1.
        The absolute support threshold is calculated = min_sup * size of data examples in a Node
        '''
        Features = []
        # AllPatterns is a List
        AllPatterns = PrefixSpan.PrefixSpan(SeqPattern([], sys.maxint), RootNode.Data, min_sup * len(RootNode.Data))
        # BestPattern is a list expressing the Sequence choosen for the current Node splitting
        BestPattern = self.CalculateFitness(RootNode.Data, AllPatterns)
        RootNode.FeaturePattern = BestPattern
        Features.append(BestPattern)
        SDBFeatureSeg = self.SegregateData(BestPattern, RootNode.Data)
        RootNode.Left = Tree.createNode(SDBFeatureSeg['L'])
        RootNode.Right = Tree.createNode(SDBFeatureSeg['R'])
        # Recurse on the Left node
        if len(RootNode.Left.Data) > min_data_size_in_node:
            Feature = self.ModelBasedSearchTree(RootNode.Left, min_sup, min_data_size_in_node)
            Features.extend(Feature)
        else:
            print "Made a Left Leaf Node"

        # Recurse on the Right Node
        if len(RootNode.Right.Data) > min_data_size_in_node:
            Feature = self.ModelBasedSearchTree(RootNode.Right, min_sup, min_data_size_in_node)
            Features.extend(Feature)
        else:
            print "Made a Right Leaf Node"

        return Features


    def SegregateData(self, BestPattern, Data):
        '''
        This routine is meant to segregate the data into two parts. One part that contains the BestPattern
        and another part that does not contain the BestPattern
        '''
        assert type(BestPattern) is ListType, "SegregateData: Expected \"BestPattern\" List Type. Received %r" % type(SegregateData)
        assert type(Data) is ListType, "SegregateData: Expected \"Data\" List Type. Received %r", % type(Data)

        SDBFeatureSeg = {'L':[], 'R':[]}
        for len_ in range(len(Data)):
            if self.PatternContained(BestPattern, Data[len_]):
                SDBFeatureSeg.append(Data[len_])
            else:
                SDBFeatureSeg.append(Data[len_])
        return SDBFeatureSeg

    def PatternContained(self, BestPattern, Data):

        return False

    def CalculateFitness(self, Data, AllPatterns):
        assert type(Data) is ListType, "CalculateFitness: Expected \"Data\" List Type. Received %r" % type(Data)
        assert type(AllPatterns) is ListType, "CalculateFitness: Expected \"AllPatterns\" List Type. Received %r" % type(AllPatterns)
        SizeOfPatterns = len(AllPatterns)
        SizeOfData = len(Data)





