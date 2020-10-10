import json
import numpy as np
from scipy import stats
from itertools import product

with open('CleanAllDataNC.txt') as jsfNC:
	dataNC = json.load(jsfNC)
with open('CleanAllDataCC.txt') as jsfCC:
	dataCC = json.load(jsfCC)

NCOrigs = ['Brazil', 'United States', 'Australia', 'France', 'Portugal', 'South Africa', 'Hawaii', 'French Polynesia']
CCOrigs = ['Brazil', 'United States', 'Australia', 'France', 'Portugal', 'South Africa']

NCPairs = [(NCOrigs[i] , NCOrigs[j] ) for i in range( len(NCOrigs) ) for j in range( i , len(NCOrigs))]
CCPairs = [(CCOrigs[i] , CCOrigs[j] ) for i in range( len(CCOrigs) ) for j in range( i , len(CCOrigs))]

def trimmedMean(scores):
	if len(scores) == 5:
		return (np.sum(scores) - min(scores) - max(scores) ) / (len(scores) - 2)

trimEff = []
list(dataCC.keys())[0]
dataCC['471385']

list(dataCC.values())[0]
trimEff = []
heatTrimEff = dict.fromkeys( set(map(lambda x: x['heatId'], dataCC.values() )) , {'trimEff':[], 'placeDiff':[] } )
len(heatTrimEff)

for wave in dataCC.values():
	if len(wave['validSubScos']) == 5:
		heatTrimEff[ wave['heatId'] ] += [ np.mean(wave['validSubScos']) - trimmedMean(wave['validSubScos']) ]

absTrimEff = list(map(abs, trimEff))

for ht in heatTrimEff:
	ht
