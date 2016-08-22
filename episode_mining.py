import os, sys
import time
import argparse as agp

parser = agp.ArgumentParser(
        description='Episode Mining Code for Post-Silicon Traceability of Message Transactions\nAuthor: Debjit Pal\nEmail: dpal2@illinois.edu', formatter_class=agp.RawTextHelpFormatter
        )
parser.add_argument("-w", "--window-length", help="Length of the window in cycles", required=True)
parser.add_argument("-s", "--min-support", help="Minimum support value", required=True)
#The following two parameters to segregate the message trace to make sure we are not mining from traces which are not relevant#
parser.add_argument("-m", "--start-cycle", help="Start cycle of the trace", required=True)
parser.add_argument("-M", "--stop-cycle", help="End cycle of the trace", required=True)
args = parser.parse_args()


