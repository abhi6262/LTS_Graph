class Constraints():
    '''
    A Special Class Strcuture (Data Structure) which holds the Constraints, type of Constraints and if possible the support needed for a Sequence to be frequent wrt to a constraint
    '''
    def __init__(
            self,
            ConstraintID,
            # Constraint Type (As of now which we include: Gap, Duration, Item, Length)
            ConstraintType,
            # Constraint Specific Support. (Optional)
            ConstraintSupport,
            # Particulary useful for Item Constraints. Specify the Items that needed in 
            # the Sequence. Also the Regular Expression in terms of the transaction will go in
            # this field as well
            ConstraintItems,
            # Particularly useful for Duration Constraint for time stamped sequence database.
            # Specify the max / min duration between first and last transaction in a pattern
            ConstraintDuration,
            # Particularly useful for Gap Constraint for time stamped sequence database.
            # Timestamp difference between every two adjacent transactions must be longer or shorter
            # than a give gap
            ConstraintGap,
            # Useful for Duration Constraint, Gap Constraint, Length, Item constraint
            ConstraintOperator
            ):
        self.ConstraintID = ConstraintID
        self.ConstraintType = ConstraintType
        self.ConstraintSupport = ConstraintSupport if ConstraintSupport != -1 else 2 
        
        self.ConstraintItems = []
        for item in ConstraintItems:
            self.ConstraintItems.append(list(item))

        self.ConstraintDuration = ConstraintDuration if ConstraintDuration > 0 else -1
        self.ConstraintGap = ConstraintGap if ConstraintGap > 0  else -1
        self.ConstraintOperator = self.GetOpType(ConstraintOperator)
    
    def GetOpType(self, Op):
        return {
                '>=' : 'ge',
                '<=' : 'le',
                '>'  : 'gt',
                '<'  : 'lt',
                }.get(Op, None)

