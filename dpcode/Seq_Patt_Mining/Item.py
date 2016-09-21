'''
PrefixSpan Code written by: Debjit Pal
Email ID: dpal2@illinois.edu
Institute: University of Illinois at Urbana-Chmapaign
Paper: PrefixSpan: Mining Sequential Patterns Efficiently by Prefix-Projected Pattern Growth, Jian Pei, Jiawei Han
'''

class Item():
    '''
    A Class (data structure) to hold the value of each transaction of the format Event @ Time.
    '''
    def __init__(
            self,
            Item,
            Time
            ):
        self.Item = Item
        self.Time = Time
