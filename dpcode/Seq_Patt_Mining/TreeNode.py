import os, sys

class Node():
    '''
    Node Class to be used in Tree Class
    Does not have any method other than the default init constructor
    '''
    def __init__(
            self,
            value
            ):
        self.Left = None
        self.Data = value
        self.Right = None
        self.FeaturePattern = None
        
# The tree is essentially a Binary Search Tree or BST
class Tree():
    '''
    Tree Class will provide the a complete Tree and some usual Tree functions
    '''
    def createNode(self, Data):
        '''
        Only creates an Empty node by calling the Node class and initiate the value of the
        node with user supplied Data
        '''
        return Node(Data)

    def insert(self, node, Data):
        '''
        1. If an empty node is supplied it will create a Node with supplied Data using createNode
        2. If a non-empty node is supplied, it will search the tree and will create a node and will put appropriate value in that node
        '''
        # Base Case
        if node is None:
            node = self.createNode(Data)
        # Recursive Build-Up Case
        if Data < node.Data:
            node.Left = self.insert(node.Left, Data)
        elif Data > node.Data:
            node.Right = self.insert(node.Right, Data)

        return node

    def search(self, node, Data):
        '''
        Search for the node with the user supplied Data
        '''
        # Base case
        if node is None or node.Data == Data:
            return node
        # Recursive search
        if node.Data < Data:
            return self.search(node.Right, Data)
        else:
            return self.search(node.Left, Data)

    def deleteNode(self, node, Data):
        '''
        Incomplete implementation. Can only delete leaf node now
        '''
        if node is None:
            return None

        if Data < node.Data:
            node.Left = self.deleteNode(node.Left, Data)
        elif Data > node.Data:
            node.Right = self.deleteNode(node.Right, Data)
        else:
            if node.Left is None and node.Right is None:
                del node
            if node.Left == None:
                temp = node.Right
                del node
                return temp
            if node.Right == None:
                temp = node.Left
                del node
                return temp

        return node

    def traverseInOrder(self, root):
        '''
        In-order traversal
        '''

        if root is not None:
            self.traverseInOrder(root.Left)
            print root.Data
            self.traverseInOrder(root.Right)

    def traversePreOrder(self, root):
        '''
        Pre-order traversal
        '''

        if root is not None:
            print root.Data
            self.traversePreOrder(root.Left)
            self.traversePreOrder(root.Right)

    def traversePostOrder(self, root):
        '''
        Post-order traversal
        '''

        if root is not None:
            self.traversePostOrder(root.Left)
            self.traversePostOrder(root.Right)
            print root.Data


#if __name__ == "__main__":
#    root = None
#    tree = Tree()
#    root = tree.insert(root, 'Asit')
#    tree.insert(root, 'Subhra')
#    tree.insert(root, 'Sanjukta')
#    tree.insert(root, 'Debjit')
#    tree.insert(root, 'Somnath')
#    tree.insert(root, 'Supan')
#    tree.insert(root, 'WhowillBe')
#
#    print "In PreOrder"
#    tree.traversePreOrder(root)
#
#    print "In PostOrder"
#    tree.traversePostOrder(root)
#
#    print "In InOrder"
#    tree.traverseInOrder(root)
#
#    deleteNode = tree.deleteNode(root, 'Sanjukta')
#    if deleteNode is not None:
#        print deleteNode.Data
