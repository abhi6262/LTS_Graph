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
        self.left = None
        self.data = value
        self.right = None
        
# The tree is essentially a Binary Search Tree or BST
class Tree():
    '''
    Tree Class will provide the a complete Tree and some usual Tree functions
    '''
    def createNode(self, data):
        '''
        Only creates an Empty node by calling the Node class and initiate the value of the
        node with user supplied data
        '''
        return Node(data)

    def insert(self, node, data):
        '''
        1. If an empty node is supplied it will create a Node with supplied data using createNode
        2. If a non-empty node is supplied, it will search the tree and will create a node and will put appropriate value in that node
        '''
        # Base Case
        if node is None:
            node = self.createNode(data)
        # Recursive Build-Up Case
        if data < node.data:
            node.left = self.insert(node.left, data)
        elif data > node.data:
            node.right = self.insert(node.right, data)

        return node

    def search(self, node, data):
        '''
        Search for the node with the user supplied data
        '''
        # Base case
        if node is None or node.data == data:
            return node
        # Recursive search
        if node.data < data:
            return self.search(node.right, data)
        else:
            return self.search(node.left, data)

    def deleteNode(self, node, data):
        '''
        Incomplete implementation. Can only delete leaf node now
        '''
        if node is None:
            return None

        if data < node.data:
            node.left = self.deleteNode(node.left, data)
        elif data > node.data:
            node.right = self.deleteNode(node.right, data)
        else:
            if node.left is None and node.right is None:
                del node
            if node.left == None:
                temp = node.right
                del node
                return temp
            if node.right == None:
                temp = node.left
                del node
                return temp

        return node

    def traverseInOrder(self, root):
        '''
        In-order traversal
        '''

        if root is not None:
            self.traverseInOrder(root.left)
            print root.data
            self.traverseInOrder(root.right)

    def traversePreOrder(self, root):
        '''
        Pre-order traversal
        '''

        if root is not None:
            print root.data
            self.traversePreOrder(root.left)
            self.traversePreOrder(root.right)

    def traversePostOrder(self, root):
        '''
        Post-order traversal
        '''

        if root is not None:
            self.traversePostOrder(root.left)
            self.traversePostOrder(root.right)
            print root.data


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
#        print deleteNode.data
