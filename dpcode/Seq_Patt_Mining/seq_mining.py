import os, sys
import pprint
import re


class ReadConstraints():
    def __init__(
            sele,
            enabled = 1,
            ):
        self.enabled = enabled

    def ReadDiffConstraints(self, constraint_file):
        gap_cons = {}
        dur_cons = {}
        reg_patt = {}

