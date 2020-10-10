import json
import numpy as np
from scipy import stats
from itertools import product

with open('CleanAllDataNC.txt') as jsfNC:
	dataNC = json.load(jsfNC)
with open('CleanAllDataCC.txt') as jsfCC:
	dataCC = json.load(jsfCC)

def getIndicies( tup , origs):
	a = tup[0]
	b = tup[1]
	if a == b:
		both = []
		for i in range(len(origs)):
			if origs[i] == a: both.append(i) 
		indicies =  [ (both[j] , both[k]) for j in range(len(both)-1) for k in range( j+1, len(both))]
		if (0,0) in indicies or (1,1) in indicies or (2,2) in indicies or (3,3) in indicies or (4,4) in indicies:
			print('HELLLLLLLLLLLLLLLLLLLLLPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP MMMMMMMMMMMMMMMMMMMMMEEEEEEEEEEEEEEEEEEEEEEEEE')
	else:
		ais = []
		bis = []
		for i in range(len(origs)):
			if origs[i] == a: ais.append(i)
			elif origs[i] == b: bis.append(i)
		indicies = product(ais,bis)

	return indicies

NCOrigs = ['Brazil', 'United States', 'Australia', 'France', 'Portugal', 'South Africa', 'Hawaii', 'French Polynesia']
CCOrigs = ['Brazil', 'United States', 'Australia', 'France', 'Portugal', 'South Africa']

print('SIMPLE T-TEST of Diff between a judge and ')
for ver in [ (dataNC, 'NC'), (dataCC, 'CC')]:
	data = ver[0]
	diffs = {}
	for wid in data:
		if data[wid]['athOrig'] in data[wid]['subScoOrig']:
			for i in range(5):
				if data[wid]['athOrig'] == data[wid]['subScoOrig'][i]:
					if data[wid]['athOrig'] in diffs.keys():
						diffs[ data[wid]['athOrig'] ] += [ data[wid]['subSco'][i] - data[wid]['noMatchMean'] ]
					else:
						diffs[ data[wid]['athOrig'] ] = [ data[wid]['subSco'][i] - data[wid]['noMatchMean'] ]
	print('THIS IS FOR' + ver[1] )
	for c in diffs:
		mean = np.mean(diffs[c])
		s = np.std(diffs[c])
		n = len(diffs[c])
		tval = mean / ( s / np.sqrt(n) )
		pval = stats.t.sf(np.abs(tval), n-1)*2
		print(c)
		print(' and diff has mean:'+str(mean)+'   stdev: '+ str(float(s))+'    obs: '+str(n)+'    tvalue: '+str(float(tval))+'    pvalue: ' +str(float(pval) ) )
		print('......................')


NCPairs = [(NCOrigs[i] , NCOrigs[j] ) for i in range( len(NCOrigs) ) for j in range( i , len(NCOrigs))]
CCPairs = [(CCOrigs[i] , CCOrigs[j] ) for i in range( len(CCOrigs) ) for j in range( i , len(CCOrigs))]

print('Typical Diff between relevant countries T-TEST of Diff between two judges and ')
for ver in [ (dataNC, 'NC', NCPairs), (dataCC, 'CC', CCPairs)]:
	data = ver[0]
	pairs = ver[2]
	diffs = {}
	for wid in data:
		for pair in pairs:
			if pair[0] in data[wid]['subScoOrig'] and pair[1] in data[wid]['subScoOrig'] and data[wid]['athOrig'] not in pair :
				if pair[0] == pair[1]:
					if data[wid]['subScoOrig'].count(pair[0]) >= 2:
						for indexPair in getIndicies( pair , data[wid]['subScoOrig'] ):
							if pair in diffs.keys():
								diffs[pair] += [ data[wid]['subSco'][indexPair[0]] - data[wid]['subSco'][indexPair[1]] ]
							else:
								diffs[pair] = [ data[wid]['subSco'][indexPair[0]] - data[wid]['subSco'][indexPair[1]] ]
				else:
					for indexPair in getIndicies( pair , data[wid]['subScoOrig'] ):
						if pair in diffs.keys():
							diffs[pair] += [ data[wid]['subSco'][indexPair[0]] - data[wid]['subSco'][indexPair[1]] ]
						else:
							diffs[pair] = [ data[wid]['subSco'][indexPair[0]] - data[wid]['subSco'][indexPair[1]] ]

	print('THIS IS FOR' + ver[1] )
	for p in diffs:
		mean = np.mean(diffs[p])
		s = np.std(diffs[p])
		n = len(diffs[p])
		tval = mean / ( s / np.sqrt(n) )
		pval = stats.t.sf(np.abs(tval), n-1)*2
		print(p)
		print(' and diff has mean:'+str(mean)+'   stdev: '+ str(float(s))+'    obs: '+str(n)+'    tvalue: '+str(float(tval))+'    pvalue: ' +str(float(pval) ) )
		print('......................')

print('SIGN TEST FOR Diff between relevant countries T-TEST of Diff between two judges -----------------------------------------')
for ver in [ (dataNC, 'NC', NCPairs), (dataCC, 'CC', CCPairs)]:
	data = ver[0]
	pairs = ver[2]
	signs = {}
	for wid in data:
		for pair in pairs:
			if pair[0] in data[wid]['subScoOrig'] and pair[1] in data[wid]['subScoOrig'] and data[wid]['athOrig'] not in pair :
				if pair[0] == pair[1]:
					if data[wid]['subScoOrig'].count(pair[0]) >= 2:
						for indexPair in getIndicies( pair , data[wid]['subScoOrig'] ):
							if data[wid]['subSco'][indexPair[0]] - data[wid]['subSco'][indexPair[1]] > 0: sign = 1
							elif data[wid]['subSco'][indexPair[0]] - data[wid]['subSco'][indexPair[1]] < 0: sign = -1
							else: sign = 0

							if pair in signs.keys(): signs[pair] += [ sign ]
							else: signs[pair] = [ sign ]
				else:
					for indexPair in getIndicies( pair , data[wid]['subScoOrig'] ):
						if data[wid]['subSco'][indexPair[0]] - data[wid]['subSco'][indexPair[1]] > 0: sign = 1
						elif data[wid]['subSco'][indexPair[0]] - data[wid]['subSco'][indexPair[1]] < 0: sign = -1
						else: sign = 0

						if pair in signs.keys(): signs[pair] += [ sign ]
						else: signs[pair] = [ sign ]

	print('THIS IS FOR' + ver[1] )
	for p in signs:
		pos = signs[p].count(1)
		neg = signs[p].count(-1)
		n = pos + neg
		pr = stats.binom.cdf(min(neg, n-neg) , n, .5)
		pr2 = stats.binom.cdf(min(pos, n-pos), n, .5)*2
		print(p)
		print(' and sign has n:' + str(n)+'   with # of pos: '+ str(pos)+'    and # of neg: '+str(neg)+'    so p-val is: '+str( float(pr) )+'  and pval2 is:' + str(float(pr2)) )
		print('......................')
