'''
Created on 20 nov. 2015

@author: wafajohal
'''
import numpy as np
import sys
import pickle
import datetime
import matplotlib.pyplot as plt
import os
import csv
from datetime import datetime, date, time


def readInfoFile(fname='sessions_info.csv'):
	'''
	Return session info in np array
	format : ChildID	name	Date	Timeofstart	WordCondition	Spatialcondition	Timeend	ScreenShotwords	Session	alone	groupid
	'''
	info = np.genfromtxt(open(fname, 'r'), dtype=None, delimiter=",", skip_header=1)
	print(info[9])
	return info

#################### with me ness
def withmenesslogtoCSV(fname):
	'''
	return the data_w array from a withmeness csv file
	'''
	withmeness = np.genfromtxt(open(fname, 'r'), dtype=None, delimiter=" ", skip_header=1)
	data_w=[]
	count=0
	for row in withmeness:
		data = row[-1]
		data = data[:-1]
		data_w.append([count,datetime.strptime(row[0].replace('"','')+' '+row[1].replace('"',''),'%Y-%m-%d %H:%M:%S:%f'), float(data)])
		count+=1
	return data_w
	
def exportWithmeness_wfactors():
	'''
	Produce the file all_withmeness from all the files in attentionLogs starting with withmeness and from the session_info
	'''
	csvfileout = open('all_withmeness.csv', 'w')
	csvheader=("idx","datetime","child_id","child_name","session","fformation","alone","groupid","withmeness_value")
	writer = csv.DictWriter(csvfileout, csvheader)
	writer.writeheader()
	
	all_data=[]
	files_in_dir = os.listdir('./attentionLog/')
	for file_in_dir in files_in_dir:
		print(file_in_dir)
		if(file_in_dir.find("withmeness")==0):
			data_w = withmenesslogtoCSV('./attentionLog/'+file_in_dir)
			all_data.append(data_w)

	info=readInfoFile()
	for data in all_data:
		for row in data:
			current_time = row[1]
			for i in info:
				#print(i)
				start_time = datetime.strptime(i[2]+' '+i[3], '%d.%m.%y %H:%M:%S.%f')
				end_time = datetime.strptime(i[2]+' '+i[6], '%d.%m.%y %H:%M:%S.%f')
				if(current_time>= start_time and  current_time<= end_time):
					#print(start_time)
					print(datetime.strftime(current_time,'%Y-%m-%d %H:%M:%S:%f'),i[0], i[1],i[-1],i[5], i[9],i[10],row[2])
					new_row = {"idx":row[0],"datetime":datetime.strftime(current_time,'%Y-%m-%d %H:%M:%S:%f'),"child_id":i[0],"child_name":i[1],"session":i[-1],"fformation":i[5],"withmeness_value":row[2]}
					writer.writerow(new_row)
					#print(end_time)
	csvfileout.close()


###########targets
def targetslogtoCSV(fname):
	'''
	return the data_w array from a attention csv file
	'''
	attention = np.genfromtxt(open(fname, 'r'), dtype=None, delimiter=" ", skip_header=1)
	data_w=[]
	count=0
	for row in attention:
		data = row[-1]
		data = data[2:-1].split('/')
		for t in data:
			data_w.append([count,datetime.strptime(row[0].replace('"','')+' '+row[1].replace('"',''),'%Y-%m-%d %H:%M:%S:%f'), t])
		count+=1
	return data_w

def exportTargets_wfactors():
	csvfileout = open('all_targets.csv', 'w')
	csvheader=("idx","datetime","child_id","child_name","session","fformation","alone","groupid","target")
	writer = csv.DictWriter(csvfileout, csvheader)
	writer.writeheader()
	info=readInfoFile()
	all_data=[]
	files_in_dir = os.listdir('./attentionLog/')
	for file_in_dir in files_in_dir:
		print(file_in_dir)
		if(file_in_dir.find("attention")==0):
			data_w = targetslogtoCSV('./attentionLog/'+file_in_dir)
			all_data.append(data_w)
	
	for data in all_data:
		for row in data:
			current_time = row[1]
			for i in info:
				#print(i)
				start_time = datetime.strptime(i[2]+' '+i[3], '%d.%m.%y %H:%M:%S.%f')
				end_time = datetime.strptime(i[2]+' '+i[6], '%d.%m.%y %H:%M:%S.%f')
				if(current_time>= start_time and  current_time<= end_time):
					#print(start_time)
					print(datetime.strftime(current_time,'%Y-%m-%d %H:%M:%S:%f'),i[0], i[1],i[-1],i[5], i[9],i[10],row[2])
					new_row = {"idx":row[0],"datetime":datetime.strftime(current_time,'%Y-%m-%d %H:%M:%S:%f'),"child_id":i[0],"child_name":i[1],"session":i[-1],"fformation":i[5],"target":row[2]}
					writer.writerow(new_row)
					#print(end_time)
	csvfileout.close()
	
if __name__=="__main__":
	#exportWithmeness_wfactors()
	exportTargets_wfactors()
	
