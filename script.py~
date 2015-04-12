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
import csv
import time

t_start = time.time()

#home_dir = '/home/mike/workspace'
home_dir = '/home/group20' #for server implementation

redd_fp = home_dir+'/data/redd_data.h5'
output_fp = home_dir+'/data/redd_output.h5'
disag_fp = home_dir+'/data/disag_output.csv'
mains_fp = home_dir+'/data/mains_sum.csv'
f1_fp = home_dir+"/data/f1_results.csv"
pred_fp = home_dir+"/data/pred_results.csv"
total_en_fp = home_dir+"/data/total_energy.txt"
total_time_fp = home_dir+"/data/total_time.txt"

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

print (t1)

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
training_set = redd_data.buildings[1].elec.select_top_k(15)
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

#METRICS -------------------------------------------------



outputDataset = DataSet(output_fp)

t1_f = str(t1)+"-4:00"
t2_f = str(t2)+"-4:00"
#set time windows
redd_data.store.window = TimeFrame(start=t1_f, end=t2_f)
outputDataset.store.window = TimeFrame(start=t1_f, end=t2_f)


ground_truth = redd_data.buildings[1].elec
predictions = outputDataset.buildings[1].elec

disag_f1_score = f1_score(predictions,ground_truth)

f1_dict = {}
f1_dict['Fridge'] = disag_f1_score[0]
f1_dict['Dish Washer'] = disag_f1_score[1]
f1_dict['Sockets (1)'] = disag_f1_score[2]
f1_dict['Sockets (2)'] = disag_f1_score[3]
f1_dict['Lights (1)'] = disag_f1_score[4]
f1_dict['Microwave'] = disag_f1_score[5]
f1_dict['Unknown'] = disag_f1_score[6]
f1_dict['Sockets (3)'] = disag_f1_score[7]
f1_dict['Lights (2)'] = disag_f1_score[8]
f1_dict['Lights (3)'] = disag_f1_score[9]
f1_dict['Electric Oven'] = disag_f1_score[10]
f1_dict['Washer Dryer'] = disag_f1_score[11]

w = csv.writer(open(f1_fp,"wb"))
for key,value in f1_dict.items():
	w.writerow([key,value])

pred_total = 0

pred_dict = {}

pred_dict['Fridge'] = float(predictions.__getitem__(5).total_energy())
pred_dict['Dish Washer'] = float(predictions.__getitem__(6).total_energy())
pred_dict['Sockets (1)'] = float(predictions.__getitem__(7).total_energy())
pred_dict['Sockets (2)'] = float(predictions.__getitem__(8).total_energy())
pred_dict['Lights (1)'] = float(predictions.__getitem__(9).total_energy())
pred_dict['Microwave'] = float(predictions.__getitem__(11).total_energy())
pred_dict['Unknown'] = float(predictions.__getitem__(12).total_energy())
pred_dict['Sockets (3)'] = float(predictions.__getitem__(15).total_energy())
pred_dict['Lights (2)'] = float(predictions.__getitem__(17).total_energy())
pred_dict['Lights (3)'] = float(predictions.__getitem__(18).total_energy())
pred_dict['Electric Oven'] = float(predictions.__getitem__(3).total_energy())
pred_dict['Washer Dryer'] = float(predictions.__getitem__(10).total_energy())


for key,value in pred_dict.items():
 	pred_total = pred_total + value

w = csv.writer(open(pred_fp,"wb"))
for key,value in pred_dict.items():
	w.writerow([key,value])

f = open (total_en_fp,"w")
f.write(repr(pred_total))
f.close()

total_time = time.time() - t_start

f = open (total_time_fp,"w")
f.write(repr(total_time))
f.close()


#-------------------------------------------------------

#Close open datastores
redd_data.store.close()
outputData.store.close()

flag = open('script_ran.txt','w')
flag.close()

sys.exit(100)

