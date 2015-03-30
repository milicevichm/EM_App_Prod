import sys, time

from dateutil import parser
import pandas as pd
from key_map import *
from nilmtk import HDFDataStore, DataSet, TimeFrame, MeterGroup
from nilmtk.disaggregate import CombinatorialOptimisation
import warnings


time.sleep(1)

name = 'worked.txt'

arguments = sys.argv[1]+" "+ sys.argv[2] +" "+ sys.argv[3]

file = open(name,'w')
file.write(arguments)
file.close()


sys.exit(100)