# -*- coding: utf-8 -*-
"""
Created on Sat Jun 18 02:59:20 2016

@author: Debjit
"""

import numpy as np
import copy as cp
import pickle

# State Color labels while doing DFS Search
WHITE = 1
GRAY = 2
BLACK = 3
NIL = -1
PATH_FOUND_UNIQUE = [[]]

INFINITY = 100000
# Cormen Book Example Encoding of Adjacency Matrix and State Labels of the State
#G = [[0,1,0,1,0,0], [0,0,0,0,1,0], [0,0,0,0,1,1], [0,1,0,0,0,0], [0,0,0,1,0,0], [0,0,0,0,0,1]]
#STATE_LABELS = ['u','v','w','x','y','z']

# Railroad Transition example
#G = np.array([[0, 1, 0,0,0,0,0,0,0,0,0,0], [0,0,1,1,0,0,0,0,0,0,0,0], [0,0,0,0,1,0,0,0,0,0,0,0], [0,0,0,0,1,1,0,0,0,0,0,0], [0,0,0,0,0,0,1,0,0,0,0,0], [0,1,0,0,0,0,0,1,0,0,0,0], [1,0,0,0,0,0,0,0,1,0,0,0], [0,0,1,0,0,0,0,0,0,0,0,0], [0,0,0,0,0,0,0,0,0,1,1,0], [0,0,0,0,0,0,1,0,0,0,0,1], [0,0,0,0,0,0,0,0,0,0,0,1], [1, 0,0,0,0,0,0,0,0,0,0,0]])

#STATE_LABELS = ['far0up', 'near1up', 'near2down', 'in1up', 'in2down', 'far1up', 'far3down', 'far2down', 'near3down', 'in3down', 'near0up', 'in0up']

with open('ltsdump', 'rb') as f:
    STATE_LABELS = pickle.load(f)
    sys = pickle.load(f)
    G = np.array(pickle.load(f))

f.close()

#D = np.array([[0, 1, INFINITY,INFINITY,INFINITY,INFINITY,INFINITY,INFINITY,INFINITY,INFINITY,INFINITY,INFINITY], [INFINITY,0,1,1,INFINITY,INFINITY,INFINITY,INFINITY,INFINITY,INFINITY,INFINITY,INFINITY], [INFINITY,INFINITY,0,INFINITY,1,INFINITY,INFINITY,INFINITY,INFINITY,INFINITY,INFINITY,INFINITY], [INFINITY,INFINITY,INFINITY,0,1,1,INFINITY,INFINITY,INFINITY,INFINITY,INFINITY,INFINITY], [INFINITY,INFINITY,INFINITY,INFINITY,0,INFINITY,1,INFINITY,INFINITY,INFINITY,INFINITY,INFINITY], [INFINITY,1,INFINITY,INFINITY,INFINITY,0,INFINITY,1,INFINITY,INFINITY,INFINITY,INFINITY], [1,INFINITY,INFINITY,INFINITY,INFINITY,INFINITY,0,INFINITY,1,INFINITY,INFINITY,INFINITY], [INFINITY,INFINITY,1,INFINITY,INFINITY,INFINITY,INFINITY,0,INFINITY,INFINITY,INFINITY,INFINITY], [INFINITY,INFINITY,INFINITY,INFINITY,INFINITY,INFINITY,INFINITY,INFINITY,0,1,1,INFINITY], [INFINITY,INFINITY,INFINITY,INFINITY,INFINITY,INFINITY,1,INFINITY,INFINITY,0,INFINITY,1], [INFINITY,INFINITY,INFINITY,INFINITY,INFINITY,INFINITY,INFINITY,INFINITY,INFINITY,INFINITY,0,1], [1, INFINITY,INFINITY,INFINITY,INFINITY,INFINITY,INFINITY,INFINITY,INFINITY,INFINITY,INFINITY,0]])

D = np.array([[0, 3, 8, INFINITY, -4], [INFINITY, 0, INFINITY, 1, 7], [INFINITY, 4, 0, INFINITY, INFINITY], [2, INFINITY, -5, 0, INFINITY], [INFINITY, INFINITY, INFINITY, 6, 0]])

path_list = []

class SearchAlgorithm():
    def __init__(
        self,
        enabled = 1,
    ):
        self.enabled = enabled
    
    def all_path(self, G, src, dst):
        '''
        A modified version of usual DFS. It can find all simple paths between a 'src' and a 'dst' node
        Acceps the graph in an adjacency matrix format
        '''
        sizeG = len(G)
        color = np.zeros((sizeG), dtype=int)
        for vertex in range(sizeG):
            color[vertex] = WHITE

        src_index = STATE_LABELS.index(src)
        dst_index = STATE_LABELS.index(dst)

        self.all_path_dfs(G, src_index, dst_index, color)

    def all_path_dfs(self, G, src, dst, color):
        '''
        The actual recursive find all path dfs helper routine. The trick is once you are done with finding all paths from an
        an intermediate node, set that up as white node so that any other path that shares that node can be taken out
        '''
        path_list.append(src)
        color[src] = BLACK
        if src == dst:
            PATH_LABELS = []
            for index in range(len(path_list)):
                PATH_LABELS.append(STATE_LABELS[path_list[index]])
            print PATH_LABELS
            with open('pathdump', 'ab') as f:
                pickle.dump(PATH_LABELS,f)
            f.close()
            return 0

        for it in range(len(G)):
            if G[src][it]:
                if color[it] == WHITE:
                    self.all_path_dfs(G, it, dst, color)
                    # The tricky line. Set the just visited intermediate node to WHITE so that any other path
                    # that shares this node can be taken out
                    color[it] = WHITE
                    path_list.pop()

    def dfs(self, G):
        '''
        G is an Adjacency Matrix of a Directed Graph
        It does DFS on G and prints unique path
        '''
        sizeG = len(G)
        color = np.zeros((sizeG), dtype=int)
        Pi = np.zeros((sizeG), dtype=int)
        for vertex in range(sizeG):
            color[vertex] = WHITE
            Pi[vertex] = NIL
        
        for vertex in range(sizeG):
            if color[vertex] == WHITE:
                self.dfs_visit(G, vertex, color, Pi)
    
    def dfs_visit(self, G, vertex, color, Pi):
        '''
        Helper subroutine for the usual DFS
        '''
        color[vertex] = GRAY
        for node in range(len(G)):
            if G[vertex][node]:
                if color[node] == WHITE:
                    Pi[node] = vertex
                    self.dfs_visit(G, node, color, Pi)
        color[vertex] = BLACK
        self.print_path(G, vertex, Pi)
        
    def print_path(self, G, vertex, Pi):
        '''
        Print path for usual DFS traversal
        '''
        path = [vertex]
        while Pi[vertex] != NIL:
            prev_vertex = Pi[vertex]
            path.append(prev_vertex)
            vertex = prev_vertex
        path.reverse()
        PATH_LABELS = []
        for index in range(len(path)):
            PATH_LABELS.append(STATE_LABELS[path[index]])
        APPEND = 1
        for it in range(len(PATH_FOUND_UNIQUE)):
            if self.contained(path, PATH_FOUND_UNIQUE[it]):
                APPEND = 0
                break
        if APPEND:
            print "Unique Path Found: ", PATH_LABELS
            PATH_FOUND_UNIQUE.append(path)
        return 0
    
    def contained(self, candidate, container):
        '''
        Checking unique path containment
        '''
        temp = container[:]
        try:
            for v in candidate:
                temp.remove(v)
            return True
        except ValueError:
            return False
            
class PathAlgorithm():
    def __init__(
        self,
        enabled = 1,
    ):
        self.enabled = enabled
    
    def floyd_warshall_init(self, D):
        '''
        Initializes the PiM matrix for the predecessor
        '''
        PiM = np.ones((len(D), len(D)), dtype=int)
        for i in range(len(D)):
            for j in range(len(D)):
                if i == j or D[i][j] == INFINITY:
                    PiM[i][j] = NIL
                else:
                    PiM[i][j] = i
        return self.floyd_warshall(D, PiM)
    
    def floyd_warshall(self, D, PiM):
        '''
        Actual calculation of the all pair shortest path happens 
        in this routine
        It returns the D matix with the D[i][j] = shortest path nodes while
        going from node i to node j
        '''
        for k in range(len(D)):
            prevD = cp.copy(D)
            prevPi = cp.copy(PiM)
            for i in range(len(D)):
                for j in range(len(D)):
                    D[i][j] = self.minimum(prevD[i][j], prevD[i][k] + prevD[k][j])
                    if prevD[i][j] <= prevD[i][k] + prevD[k][j]:
                        PiM[i][j] = prevPi[i][j]
                    elif prevD[i][j] > prevD[i][k] + prevD[k][j]:
                        PiM[i][j] = prevPi[k][j]
        return D
    
    def minimum(self, a, b):
        '''
        A small helper function
        '''
        return b if a>=b else a

class StringMatchingAlgorithm():
    def __init__(
        self,
        enabled = 1,
    ):
        self.enabled = enabled
    
    def naive_string_matching(self, Text, Pattern):
        '''
        Naive String Matching Algorithm of High Complexity        
        '''
        n = len(Text)
        m = len(Pattern)
        for pos in range(n - m):
            if P == Text[pos:pos+m]:
                return pos
        return -1
    
    def knuth_morris_pratt(self, Text, Pattern):
        '''
        An effcient substring matching routine implementing Knuth-Morris-Pratt Algorithm
        '''
        n = len(Text)
        m = len(Pattern)
        Pi = self.compute_prefix_function(Pattern)
        q = 0
        for i in range(n):
            while q > 0 and Pattern[q + 1] != Text[i]:
                q = Pi[q]
            if P[q + 1] == Text[i]:
                q =q + 1
            if q == m:
                print "Pattern occurs with shift: ", i - m
                q = Pi[q]
        
    def compute_prefix_function(self, Pattern):
        Pi = []
        m = len(Pattern)
        Pi[0] = 0
        k = 0
        for q in range(2, m):
            while k > 0 and Pattern[k + 1] != Pattern[q]:
                k = Pi[k]
            if Pattern[k + 1] == Pattern[q]:
                k = k + 1
            Pi[q] = k
        return Pi
            

        
if __name__ =="__main__":
    Search = SearchAlgorithm()
    Search.all_path(G, ('piow_1', 'pior_1', 'mon_1'), ('piow_3', 'pior_7', 'mon_8'))
#    Search.all_path(G, 'far1up', 'in0up')
    print "\n" 
    Path = PathAlgorithm()
    print "The all pair shortest possible path matrix is: \n", Path.floyd_warshall_init(D)
    #Search.dfs(G)
