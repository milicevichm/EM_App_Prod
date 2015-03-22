require 'csv'
mains = CSV.read('/home/group20/data/redd_downs.csv')
disag = CSV.read('/home/group20/data/fridge_output.csv')

MAINS_CSV = mains[720..960]
DISAG_CSV = disag[720..960]