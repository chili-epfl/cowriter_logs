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

def userfeedbacktoCSV(fname):
	'''
	return the data_w array from a attention csv file
	'''
	with open(fname) as myfile:
		logf = myfile.readlines()
		data_w=[]
		count=0
		for row in logf:
			row = row.split(' ')
			if(len(row)==3 and row[2].startswith("user_feedback")):
				feedback = row[2].split(':')
				feedback[-1] = feedback[-1].replace('\r\n','')
				print(repr(feedback[-1]))
				data_w.append([count,datetime.strptime(row[0].replace('"','')+' '+row[1].replace('"',''),'%Y-%m-%d %H:%M:%S:%f'), feedback[-1].replace('"','')])
			count+=1
			#print(row)
	return data_w

def exportFeedback_wfactors():
	csvfileout = open('all_userfeeback.csv', 'w')
	csvheader=("idx","datetime","child_id","child_name","session","fformation","alone","groupid","gender","chouchou","feedback")
	writer = csv.DictWriter(csvfileout, csvheader)
	writer.writeheader()
	info=readInfoFile()
	all_data=[]
	files_in_dir = os.listdir('./visionLog_activity/')
	for file_in_dir in files_in_dir:
		print(file_in_dir)
		data_w = userfeedbacktoCSV('./visionLog_activity/'+file_in_dir)
		all_data.append(data_w)
	
	for data in all_data:
		for row in data:
			current_time = row[1]
			for i in info:
				start_time = datetime.strptime(i[2]+' '+i[3], '%d.%m.%y %H:%M:%S.%f')
				end_time = datetime.strptime(i[2]+' '+i[6], '%d.%m.%y %H:%M:%S.%f')
				
				if(current_time>= start_time and  current_time<= end_time):
					new_row = {"idx":row[0],"datetime":datetime.strftime(current_time,'%Y-%m-%d %H:%M:%S:%f'),"child_id":i[0],"child_name":i[1],"session":i[-5],"fformation":i[5],"alone":i[-4],"groupid":i[-3],"gender":i[-2],"chouchou":i[-1],"feedback":row[-1]}
					writer.writerow(new_row)
	csvfileout.close()
	
if __name__=="__main__":
	exportFeedback_wfactors()
