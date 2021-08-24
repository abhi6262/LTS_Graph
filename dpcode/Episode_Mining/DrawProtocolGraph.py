'''

Episode Mining written by : Debjit Pal
Email ID: dpal2@illinois.edu
Institute: Univerisity of Illinois at Urbana-Champaign
Paper: Automatic Generation of System Level Assertions from Transaction Level Models, Lingyi Liu et. al 2014

'''
import sys
import pydot as pd
from matplotlib import colors
from types import *

colors_ = colors.cnames

class DrawProtocolGraph():
    def __init__(
            self,
            enabled = 1,
            pic_location = '.',
            ):
        self.enabled = enabled
        self.pic_location = pic_location

    def DrawGraph(self, FrequentEpisodes, event_seq):
        assert type(FrequentEpisodes) is DictType, "DrawGraph: Expected \"FrequentEpisodes\" ListType. received %r" % type(FrequentEpisodes)
        EdgeList, NodeDict = self.GenerateNodeAndEdge(FrequentEpisodes)

        graph = pd.Dot(graph_type = 'digraph')
        
        ## Add all the nodes in the graph
        for key_ in NodeDict.keys():
            graph.add_node(NodeDict[key_])

        ## Add all the edges in the graph
        for edge in EdgeList:
            graph.add_edge(pd.Edge(NodeDict[edge[0]], NodeDict[edge[1]], label=edge[2], labelfontcolor=colors_['brown'], fontsize="9.0", color=colors_['maroon'], penwidth=edge[3]))

        diag_name = event_seq[:event_seq.find('.')]
        name_of_png_file = self.pic_location + "/" + diag_name + ".png"
        graph.write_png(name_of_png_file)

        
    def GenerateNodeAndEdge(self, FrequentEpisodes):
        # Create The Graph as the list of the pair of the nodes connected by an edge
        EdgeList = []
        NodeDict = {}
        maxSupport, minSupport = self.FindMaxMin(FrequentEpisodes)
        for episode in FrequentEpisodes.keys():
            ## To handle the pen width in the protocol graph we are making the edge width proportional to the 
            ## support that an edge has
            episodeSupport = FrequentEpisodes[episode]
            assert type(episode) is TupleType, "DrawGraph: Expected \"episode\" TupleType. received %r" % type(episode)
            for element in episode:
                Length = len(element)
                subelement = element[1:Length-1].split(',')
                if subelement[0] not in NodeDict.keys():
                    NodeDict[subelement[0]] = pd.Node(subelement[0], fillcolor=colors_['dodgerblue'], style="filled")
                if subelement[1] not in NodeDict.keys():
                    NodeDict[subelement[1]] = pd.Node(subelement[1], fillcolor=colors_['dodgerblue'], style="filled")
                edge = tuple([subelement[0], subelement[1], subelement[3], 1.0 * episodeSupport / (maxSupport - minSupport)])
                EdgeList.append(edge)

        return EdgeList, NodeDict

    def FindMaxMin(self, FrequentEpisodes):
        maxSupport, minSupport = 0, sys.maxint
        for key_ in FrequentEpisodes.keys():
            maxSupport = FrequentEpisodes[key_] if FrequentEpisodes[key_] > maxSupport else maxSupport
            minSupport = FrequentEpisodes[key_] if FrequentEpisodes[key_] < minSupport else minSupport

        return maxSupport, minSupport
