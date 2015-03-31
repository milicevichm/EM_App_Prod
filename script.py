# Script disaggregates REDD building data based on input arguments
# Author: Michael Milicevich
# Date: 16/02/2015

# command linen test variables to use:
# python disag_script.py 1 "fridge" "2011-05-01" "2011-05-02"

# import modules/dependencies
from __future__ import print_function, division
import sys
from dateutil import parser
import pandas as pd
from key_map import *
from nilmtk.metrics import *
from nilmtk import HDFDataStore, DataSet, TimeFrame, MeterGroup
from nilmtk.disaggregate import CombinatorialOptimisation
import warnings

redd_fp = '/home/mike/workspace/data/redd_data.h5'
output_fp = '/home/mike/workspace/data/redd_output.h5'
disag_fp = '/home/mike/workspace/data/disag_output.csv'
mains_fp = '/home/mike/workspace/data/mains_sum.csv'


#supress warnings to users console
warnings.filterwarnings("ignore")

# verify length of args, should be 5 corrsponding to:
#[0]: script name: disag_script.py
#[1]: Appliance to disaggregate: disag_appliances
#[2]: Beginning time/date: t1
#[3]: Ending time/date: t2

# Verify that the correct amount of input arguments have been entered
#if len(sys.argv) != 4:
#	sys.exit("Error: Incorrect amount of input arguments given. Script terminated.")

#load arguments into script
disag_appliance = sys.argv[1]
t1 = parser.parse(sys.argv[2])
t2 = parser.parse(sys.argv[3])


# to add:
#			1) load REDD data from database (SQL interface)*
#
#			*Cannot be implemented until database is setup in environment

# Verify input appliance exists in building
km = Key_Map(1)

# verify a real appliance has been entered
#if km.is_in_map(disag_appliance) == False:
#	sys.exit("An incorrect appliance name has been entered. Please ensure the entered name is exactly correct.")

redd_data = DataSet(redd_fp)

# load mains of the building
building_mains = redd_data.buildings[1].elec.mains()

#train disaggregation set
co = CombinatorialOptimisation()
training_set = redd_data.buildings[1].elec
co.train(training_set)

#set output datastore
outputData = HDFDataStore(output_fp,'w')


#disaggregate
co.disaggregate(building_mains,outputData)

#set sub-datastore for CSV outputs
output_csv_store = outputData.store.__getitem__(km.get_key(disag_appliance))

mains1 = redd_data.store.__getitem__(km.get_key("mains1"))
mains2 = redd_data.store.__getitem__(km.get_key("mains2"))

mains1 = mains1.fillna(value=0)
mains1 = mains1.resample("1min")

mains2 = mains2.fillna(value=0)
mains2 = mains2.resample("1min")

mains_sum = mains1 + mains2

#fill NA values with 0 for graphing 
output_csv_store = output_csv_store.fillna(value=0)

#set date parameters
output_csv_store = output_csv_store[t1:t2]
mains_sum = mains_sum[t1:t2]

#output to csv
output_csv1 = open(disag_fp,'w')
output_csv1.write(output_csv_store.to_csv())

output_csv2 = open(mains_fp,'w')
output_csv2.write(mains_sum.to_csv())

#Close open datastores
redd_data.store.close()
outputData.store.close()

flag = open('script_ran.txt','w')
flag.close()

sys.exit(100)

