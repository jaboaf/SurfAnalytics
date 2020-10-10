import pandas as pd
import numpy as np
from scipy import stats
import json
import csv

eventNames = ['Gold Coast', 'Bells Beach', 'Rio Pro', 'Bali Pro', 'Margaret River',  'J-Bay Open',          'Tahiti', 'France', 'Peniche Pro', 'Pipe Masters']
eventIds = ['2647', '2671', '2705', '2714', '2686', '2747', '2774', '2803', '2825', '2856']
evtLocations = ['Australia' , 'Australia',  'Brazil','Indonesia',      'Australia','South Africa','French Polynesia', 'France',    'Portugal', 'United States']
getEvtOrig = dict(zip(eventNames,evtLocations))

getEvtOrigNC = {	'Gold Coast': 'Australia', 'Peniche Pro': 'Portugal', 'France': 'France', 'Rio Pro': 'Brazil',
				'Tahiti': 'French Polynesia', 'Pipe Masters': 'Hawaii', 'J-Bay Open': 'South Africa','Margaret River': 'Australia',
				'Bells Beach': 'Australia', 'Bali Pro': 'Indonesia', 'Fiji': 'Fiji', 'Trestles': 'United States'}

getEvtOrigCC = {	'Gold Coast': 'Australia', 'Peniche Pro': 'Portugal', 'France': 'France', 'Rio Pro': 'Brazil',
				'Tahiti': 'France', 'Pipe Masters': 'United States', 'J-Bay Open': 'South Africa', 'Margaret River': 'Australia',
				'Bells Beach': 'Australia', 'Bali Pro': 'Indonesia', 'Fiji': 'Fiji', 'Trestles': 'United States'}

fixOrigsNC = {'-1' : '-1',
			'Brazil':'Brazil', 'United':'United States', 'Australia':'Australia',
			'Basque':'Basque Country', 'France': 'France', 'Portugal': 'Portugal',
			'South' : 'South Africa' , 'Hawaii' : 'Hawaii', 'French': 'French Polynesia'}

fixOrigsCC = {'-1' : '-1',
			'Brazil':'Brazil', 'United':'United States', 'Australia':'Australia',
			'Basque':'Basque Country', 'France': 'France', 'Portugal': 'Portugal',
			'South' : 'South Africa' , 'Hawaii' : 'United States', 'French': 'France'}

NC = {}
CC = {'Hawaii' : 'United States', 'French Polynesia': 'France'}

def getScoLevel(sco):
	if sco < 0.1: return 'error'
	elif sco < 2: return 'poor'
	elif sco >=2 and sco < 4: return 'fair'
	elif sco >= 4 and sco < 6: return 'good'
	elif sco >= 6 and sco < 8: return 'very good'
	elif sco >=8 and sco <= 10: return 'excellent'
	else: return 'error'

def matchANDnoMatchScos(athleteOrigin, judgeOrigins, scores):
	missingScos = 0
	missingOrigs = 0
	yesMatchScos = []
	noMatchScos = []
	unsureMatchScos = []
	for i in range(5):
		if scores[i] >= 0.1:
			if judgeOrigins[i] == '-1':
				missingOrigs += 1
				unsureMatchScos.append(scores[i])
			elif judgeOrigins[i] == athleteOrigin:
				yesMatchScos.append(scores[i])
			else: # judgeOrigins[i] != athleteOrigin
				noMatchScos.append(scores[i])
		else:
			missingScos += 1
			if judgeOrigins[i] == '-1':
				missingOrigs += 1

	return [yesMatchScos, noMatchScos, unsureMatchScos, missingScos, missingOrigs]


dfPoints17 = pd.read_csv('2017Points.csv')
dfPoints18 = pd.read_csv('2018Points.csv')
dfPoints19 = pd.read_csv('2019Points.csv')

dfPoints = {'2017' : dfPoints17, '2018' : dfPoints18, '2019':dfPoints19}

with open('2017DoneData.txt') as json_file:
    data2017 = json.load(json_file)
with open('2018DoneData.txt') as json_file:
    data2018 = json.load(json_file)
with open('2019DoneData.txt') as json_file:
    data2019 = json.load(json_file)

data = {}
data.update(data2017)
data.update(data2018)
data.update(data2019)

for wId in data:
	if '-1' in data[wId]['subSco']: data[wId]['subScoDefect'] = True
	else: data[wId]['subScoDefect'] = False

	if '-1' in data[wId]['subScoOrig']: data[wId]['subScoOrigDefect'] = True
	else: data[wId]['subScoOrigDefect'] = False

	if data[wId]['evtName'] == 'Margaret River' and int(data[wId]['rnd'])>=2 and data[wId]['evtYear'] == '2017':
		data[wId]['evtOrig'] = 'Indonesia'
	else:	
		data[wId]['evtOrig'] = getEvtOrigNC[ data[wId]['evtName'] ]

	#data[wId]['subScoOrig'] = list(map(lambda x: fixOrigsNC[x], data[wId]['subScoOrig']))
	if data[wId]['athOrig'] in NC.keys(): data[wId]['athOrig'] = NC[data[wId]['athOrig']]
	data[wId]['subScoOrig'] = list(map(lambda x: fixOrigsNC[x], data[wId]['subScoOrig']))

	if data[wId]['evtOrig'] == data[wId]['athOrig']: data[wId]['atHome'] = True
	else: data[wId]['atHome'] = False

	yr = data[wId]['evtYear']
	col = 'before' + data[wId]['evtName']
	data[wId]['currentPoints'] = int(dfPoints[yr][dfPoints[yr]['name'] == data[wId]['athName'] ][ col ] )
	data[wId]['endingPoints'] = int(dfPoints[yr][dfPoints[yr]['name'] == data[wId]['athName'] ]['endOfSeason'] )

print('done w first for loop')

for wId in data:
	data[wId]['subSco'] = [ round(float(x) , 1) for x in data[wId]['subSco'] ]

	#separating sub scos into list of match scos and list of noMatch scos
	info = matchANDnoMatchScos(data[wId]['athOrig'], data[wId]['subScoOrig'], data[wId]['subSco'])
	data[wId]['matchSubScos'] = info[0]
	data[wId]['matches'] = len(info[0])

	data[wId]['noMatchSubScos'] = info[1]
	data[wId]['noMatches'] = len(info[1])

	data[wId]['validSubScos'] = info[0] + info[1] + info[2]
	data[wId]['nSubScos'] = 5 - info[3]
	data[wId]['nJudOrigs'] = 5 - info[4]

	if data[wId]['matches'] >= 1:
		data[wId]['matchMean'] = np.mean(data[wId]['matchSubScos'])
		data[wId]['matchVar'] = np.var(data[wId]['matchSubScos'])
	else:
		data[wId]['matchMean'] = -1
		data[wId]['matchVar'] = -1

	if data[wId]['noMatches'] >= 1:
		data[wId]['noMatchMean'] = np.mean(data[wId]['noMatchSubScos'])
		data[wId]['noMatchVar'] = np.var(data[wId]['noMatchSubScos'])
	else:
		data[wId]['noMatchMean'] = -1
		data[wId]['noMatchVar'] = -1

	if data[wId]['nSubScos'] >= 1:
		data[wId]['subScoMean'] = np.mean(data[wId]['validSubScos'])
		data[wId]['subScoVar'] = np.var(data[wId]['validSubScos'])
	else:
		data[wId]['subScoMean'] = -1
		data[wId]['subScoVar'] = -1
	
	if data[wId]['nSubScos'] == 5:
		trimmed = sorted(data[wId]['validSubScos'])[1:-1]
		data[wId]['actualSco'] = round(np.mean(trimmed), 2)
		data[wId]['actualScoVar'] = np.var(trimmed)
	elif data[wId]['nSubScos'] == 3:
		data[wId]['actualSco'] = round(np.mean(data[wId]['validSubScos']), 2)
		data[wId]['actualScoVar'] = np.var(data[wId]['validSubScos'])
	else:
		data[wId]['actualSco'] = -1
		data[wId]['actualScoVar'] = -1

	data[wId]['actualScoLevel'] = getScoLevel( data[wId]['actualSco'] )


df = pd.DataFrame.from_dict(data, orient='index')
print(df['athOrig'].value_counts())

cols = [	'evtYear',
			'evtName',
			'evtId',
			'evtOrig',
			'atHome',
			'rnd',
			'rndId',
			'heat',
			'heatId',
			'athName',
			'athId',
			'athOrig',
			'currentPoints',
			'endingPoints',
			'matches',
			'noMatches',
			'nSubScos',
			'nJudOrigs',
			'matchMean',
			'matchVar',
			'noMatchMean',
			'noMatchVar',
			'subScoMean',
			'subScoVar',
			'actualSco',
			'actualScoVar',
			'actualScoLevel',
			'subScoDefect',
			'subScoOrigDefect']


f = open("CleanAllDataNC.csv", "w")

head = 'waveId,'
for col in cols:
	head += col + ','

headers = head + '\n'
f.write(headers)

for waveId in data:
	f.write(waveId + ',')
	for col in cols:
		f.write(str(data[waveId][col]) + ',')
	f.write('\n')

f.close()

with open('CleanAllDataNC.txt', 'w') as outfile:
    json.dump(data, outfile)

print('orig defects ---------------')
print(df['subScoOrigDefect'].value_counts() )
print('sco defects ---------------')
print(df['subScoDefect'].value_counts() )

#---------------------------------------------------
'''
	tempMatch = []
	tempNonMatch = []

	for i in range(5):
		
		if dictSurfer[waveId]['athOrig'] == dictSurfer[waveId]['subScoOrig'][i]:
			tempMatch.append(dictSurfer[waveId]['subSco'][i])
		else:
			tempNonMatch.append(dictSurfer[waveId]['subSco'][i])

	print(tempMatch)
	print(tempNonMatch)
	match.append(np.mean(tempMatch))
	nonMatch.append(np.mean(tempNonMatch))

print(str(stats.ttest_ind(match, nonMatch, equal_var=False)))
'''


