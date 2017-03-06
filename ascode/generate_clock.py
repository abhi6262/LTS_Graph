import os
import sys
import ConfigParser
import ast
import pickle
import networkx as nx
from matplotlib import pyplot as plt

os.system('cls' if os.name == 'nt' else 'clear')

def gcd(x, y):
    while(y):
        x, y = y, x % y

    return x

def lcm(x, y):
    lcm = (x*y) // gcd(x, y)
    return lcm


config = ConfigParser.RawConfigParser()
config.read('config_mclock.cfg')
Clocks = ast.literal_eval(config.get('Configuration', 'Clocks'))
RefClockFreq = 1
for key in Clocks.keys():
    RefClockFreq = lcm(RefClockFreq, Clocks[key]) 


print "Reference Clock Frequency is: ", RefClockFreq



