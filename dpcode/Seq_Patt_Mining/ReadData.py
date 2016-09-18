'''
PrefixSpan Code written by: Debjit Pal
Email ID: dpal2@illinois.edu
Institute: University of Illinois at Urbana-Chmapaign
Paper: PrefixSpan: Mining Sequential Patterns Efficiently by Prefix-Projected Pattern Growth, Jian Pei, Jiawei Han
'''
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
