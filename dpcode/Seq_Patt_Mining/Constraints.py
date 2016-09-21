'''
PrefixSpan Code written by: Debjit Pal
Email ID: dpal2@illinois.edu
Institute: University of Illinois at Urbana-Chmapaign
Paper: PrefixSpan: Mining Sequential Patterns Efficiently by Prefix-Projected Pattern Growth, Jian Pei, Jiawei Han
'''

import regex as rx

class Constraints():
    '''
    A Special Class Strcuture (Data Structure) which holds the Constraints, type of Constraints and if possible the support needed for a Sequence to be frequent wrt to a constraint
    '''
    def __init__(
            self,
            ConstraintID,
            # Constraint Type (As of now which we include: Gap, Duration, Item, Length)
            # elements[0]
            ConstraintType, 
            # Constraint Specific Support. (Optional)
            # elements[1]
            ConstraintSupport,
            # Particulary useful for Item Constraints. Specify the Items that needed in 
            # the Sequence. Also the Regular Expression in terms of the transaction will go in
            # this field as well
            # elements[2]
            ConstraintItems,
            # Particularly useful for Duration Constraint for time stamped sequence database.
            # Specify the max / min duration between first and last transaction in a pattern
            # elements[4]
            ConstraintDuration,
            # Particularly useful for Gap Constraint for time stamped sequence database.
            # Timestamp difference between every two adjacent transactions must be longer or shorter
            # than a give gap
            # elements[4]
            ConstraintGap,
            # Useful for Duration Constraint, Gap Constraint, Length, Item constraint
            # elements[3]
            ConstraintOperator,
            # Useful for Length Constraints. Expressing the number of transactions in a sequence
            # elements[2]
            ConstraintLength,
            # Useful for Regular Expression Constraints
            # elements[2]
            ConstraintRegExp
            ):
        self.ConstraintID = ConstraintID
        self.ConstraintType = ConstraintType
        self.ConstraintSupport = ConstraintSupport if ConstraintSupport != -1 else 2 
        
        self.ConstraintItems = []
        if ConstraintType == 'IT':
            for item in ConstraintItems:
                self.ConstraintItems.append(item)

        self.ConstraintDuration = ConstraintDuration if ConstraintDuration > 0 else -1
        self.ConstraintGap = ConstraintGap if ConstraintGap > 0  else -1
        self.ConstraintOperator = self.GetOpType(ConstraintOperator) if ConstraintOperator != None else None
        self.ConstraintLength = ConstraintLength if ConstraintLength > 0 else -1
        self.ConstraintRegExp = rx.compile(ConstraintRegExp) if ConstraintRegExp else None 

    def GetOpType(self, Op):
        return {
                '>=' : 'ge',
                '<=' : 'le',
                '>'  : 'gt',
                '<'  : 'lt',
                '==' : 'eq',
                'belong' : 'in',
                'not belong' : 'nin',
                'subset' : 'sset'
                }.get(Op, None)
