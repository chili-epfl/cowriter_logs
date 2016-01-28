'''
Created on 20 nov. 2015

@author: wafajohal
'''
import numpy as np
import sys
import pickle
import time
import datetime
import matplotlib.pyplot as plt


LABELS = ['sbs','f2f']

#################### with me ness
def withmenesslogtoCSV(fname):
	#'"2016-01-25' '10:25:44:145227"' '"withmeness:' '0.5"']
    withmeness = np.genfromtxt(open(fname, 'r'), dtype=None, delimiter=" ", skip_header=1)
    #attention = np.genfromtxt(open(attention_fname, 'r'), dtype=None, delimiter=' ', skip_header=1)
    print(withmeness[0,-1])
    #todo copy all floats in new array or replace and print
    data_w=[]
    for row in withmeness:
		print(row)
		data = row[-1]
		data = data[:-1]
		print(data)
		data_w.append(float(data))
    #print(datetime.datetime.strptime(withmeness[0,0],'%Y-%m-%d' ))
    plt.plot(data_w)
    plt.ylabel('some numbers')
    plt.show()

def parseVisionLog(fname):
	#visionLogs = np.genfromtxt(open(fname, 'r'), dtype=None, delimiter=" ", skip_header=1)
	score=[]
	wordscores=[]
	wordlist=[]
	currentwordid=-1
	currentletterid = 0
	with open(fname) as f:
		for line in f:
			line = line.replace('"','')
			row = line.split(' ')
			#print(row)
			if(len(row)>=3 and line.find('word:')>0):
				row[2]= row[2].replace('\r\n','')
				data = row[2].split(':')
				wordlist.append(data[1])
				currentwordid +=1
				currentletterid=0
				print(wordlist)
			if(len(row)>=3 and line.find('user_feedback')>0):
				row[2]= row[2].replace('\r\n','')
				data = row[2].split(':')
				#print(data)
			if(len(row)>=4 and line.find('score')>0):
				s = row[-1].replace('\r\n','')
				print(currentletterid, s)
				word=wordlist[currentwordid]
				letter = word[currentletterid]
				print((letter,s))
				score.append((letter,s))
				currentletterid+=1
				
				
	plt.plot(np.array(score).reshape(3, -1))
	print(np.array(score).reshape(3,-1))
	plt.ylabel('some numbers')
	plt.show()
    
    
	def getScores(fname):
		wordlist = []
		scoreslist=[]
		with open(fname) as f:
			for line in f:
				line = line.replace('"','')
				row = line.split(' ')
				#print(row)
				if(len(row)>=3 and line.find('word:')>0):# new word detected
					row[2]= row[2].replace('\r\n','')
					data = row[2].split(':')
					wordlist.append((data[1],[]))# add word to the list of word
				if(len(row)>=4 and line.find('score')>0):# score detected
					s = row[-1].replace('\r\n','')
					print(s)
					wordlist[-1][0]
					
    
	def show_stat_letter(letter_data):
		letter_data['a'].score
		letter_data['a'].demo_path_variation
		letter_data['a'].learned_path_variation
		plt.plot(np.array(score).reshape(3, -1))
		print(np.array(score).reshape(3,-1))
		plt.ylabel('some numbers')
		plt.show()
		
	#def stat_per_demo(demo_data):
		#response_time
		#writing_time
		#avg_score
		#feedback
	
	def lettersEvolution(letter):
		'''
		compares the demos of the letter with the previous using compare from stroke package
		'''
		print("todo")


if __name__=="__main__":
	#withmeness_fname = sys.argv[1]
	#attention_fname = sys.argv[2]
	#withmenesslogtoCSV(withmeness_fname)
	parseVisionLog(sys.argv[1])
	
