'''
Created on Fev. 2015

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
	
def timetoCSV(fname):
	'''
	return the data_w array from a log csv file
	'''
	with open(fname) as myfile:
		logf = myfile.readlines()
		data_Rtime=[]
		data_Wtime=[]
		count=0
		for row in logf:
			row = row.split(' ')
			if(len(row)==3 and row[2].startswith("timeR")):
				data = row[2].split(':')
				data[-1] = data[-1].replace('\r\n','')
				t = float(data[-1].replace('"',''))/1000
				data_Rtime.append([count,datetime.strptime(row[0].replace('"','')+' '+row[1].replace('"',''),'%Y-%m-%d %H:%M:%S:%f'), t])
			elif(len(row)==3 and row[2].startswith("writeT")):
				data = row[2].split(':')
				data[-1] = data[-1].replace('\r\n','')
				t = float(data[-1].replace('"',''))/1000
				data_Wtime.append([count,datetime.strptime(row[0].replace('"','')+' '+row[1].replace('"',''),'%Y-%m-%d %H:%M:%S:%f'), t])
			count+=1
			#print(row)
	return data_Rtime,data_Wtime

def fuseData(data_Rtime, data_Wtime):
	print(len(data_Rtime), len(data_Wtime))
	data=[]
	
	if(len(data_Rtime)== len(data_Wtime) and len(data_Rtime)>0):
		count =0
		for rowR, rowW in zip(data_Rtime, data_Wtime):
			if(rowR[-1]<100 and rowW[-1]<200): #
				data.append([count,rowR[1],rowR[-1],rowW[-1]])
				count+=1
	return data
			

def exportFeedback_wfactors():
	csvfileout = open('all_timelogs.csv', 'w')
	csvheader=("idx","datetime","child_id","child_name","session","fformation","alone","groupid","gender","chouchou","responset","writingt")
	writer = csv.DictWriter(csvfileout, csvheader)
	writer.writeheader()
	info=readInfoFile()
	all_data=[]
	files_in_dir = os.listdir('./visionLog_activity/')
	for file_in_dir in files_in_dir:
		print(file_in_dir)
		data_Rtime, data_Wtime = timetoCSV('./visionLog_activity/'+file_in_dir)
		data_w = fuseData(data_Rtime, data_Wtime)
		all_data.append(data_w)
	for data in all_data:
		for row in data:
			current_time = row[1]
			for i in info:
				start_time = datetime.strptime(i[2]+' '+i[3], '%d.%m.%y %H:%M:%S.%f')
				end_time = datetime.strptime(i[2]+' '+i[6], '%d.%m.%y %H:%M:%S.%f')
				
				if(current_time>= start_time and  current_time<= end_time):
					new_row = {"idx":row[0],"datetime":datetime.strftime(current_time,'%Y-%m-%d %H:%M:%S:%f'),"child_id":i[0],"child_name":i[1],"session":i[-5],"fformation":i[5],"alone":i[-4],"groupid":i[-3],"gender":i[-2],"chouchou":i[-1],"responset":row[-2],"writingt":row[-1]}
					writer.writerow(new_row)
	csvfileout.close()
	
if __name__=="__main__":
	exportFeedback_wfactors()
