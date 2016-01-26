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

if __name__=="__main__":
	withmeness_fname = sys.argv[1]
	#attention_fname = sys.argv[2]
	withmenesslogtoCSV(withmeness_fname)
	
