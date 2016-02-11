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
	row_t1 = withmeness[0]
	for row in withmeness:
		data = row[-1][:-1]
		data_t1 = row_t1[-1][:-1]
		evol=0
		if(float(data_t1)-float(data)>0):
			evol= -1 
		elif(float(data_t1)-float(data)<0):
			 evol= 1
		data_w.append([count,datetime.strptime(row[0].replace('"','')+' '+row[1].replace('"',''),'%Y-%m-%d %H:%M:%S:%f'), float(data), evol])
		count+=1
		row_t1=row
	return data_w
	
def rewrite_withmenssCSV():
	csvfileout = open('all_withmeness_r.csv', 'w')
	csvheader=("idx","datetime","child_id","child_name","session","fformation","alone","groupid","gender","chouchou","withmeness_value","evol")
	csvheadero=("idx","datetime","child_id","child_name","session","fformation","alone","groupid","gender","chouchou","withmeness_value","evol","new_w")
	writer = csv.DictWriter(csvfileout, csvheadero)
	writer.writeheader()
	csvfilein = open('all_withmeness.csv', 'r')
	reader = csv.DictReader(csvfilein, csvheader)
	count=1
	value = 0.5 
	print("enter")
	current_child =''
	current_session = ''
	current_index = 0
	for row in reader:
		row2=row
		
		if(count==1):
			current_child = row["child_id"]
			current_session = row["session"]
			count+=1
		elif(count>1):
			count+=1
			if(row["child_id"]!=current_child) or (row["session"]!=current_session) :
				value = 0.5 
				row["new_w"] = value
				current_child = row["child_id"]
				current_session = row["session"]
				current_index=0
				print(row["child_id"],row["session"])
			else:
				if(row["evol"]=='-1'):
					value = 0.9 * value 
				elif(row["evol"]=='1'):
					value = 0.9 * value + 0.1
				#print("prev data ",row["withmeness_value"])
				#print("new data", value)
				row2["new_w"] = value
		row2["idx"]=current_index
		current_index+=1
		writer.writerow(row2)
	csvfileout.close()
	csvfilein.close()
		
		

def recompute_withmeness(data):
	print(data[0][-2])
	#data[0][:-1] = 0.5
	value = 0.5 
	data[0][-2] = value
	for row in range(1,len(data)):
		if(data[row][-1]<0):
			value = 0.9 * value + 0.1
		elif(data[row][-1]>0):
			value = 0.9 * value 
		data[row][-2] = value
		print("prev data ",data[row][-2])
		print("new data", value)
	return data
		
	
def exportWithmeness_wfactors():
	'''
	Produce the file all_withmeness from all the files in attentionLogs starting with withmeness and from the session_info
	'''
	csvfileout = open('all_withmeness.csv', 'w')
	csvheader=("idx","datetime","child_id","child_name","session","fformation","alone","groupid","gender","chouchou","withmeness_value","evol")
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
					new_row = {"idx":row[0],"datetime":datetime.strftime(current_time,'%Y-%m-%d %H:%M:%S:%f'),"child_id":i[0],"child_name":i[1],"session":i[-5],"fformation":i[5],"alone":i[-4],"groupid":i[-3],"gender":i[-2],"chouchou":i[-1],"withmeness_value":row[2], "evol":row[3]}
					writer.writerow(new_row)
					#print(end_time)
	csvfileout.close()


def resample_withUF(wfname="withme_sorted.csv", uffname ="uf_sorted.csv"):
	'''
	takes the closest value of withmeness regarding the time of the user_feedback
	'''
	wcsvheader=("X","idx","datetime","child_id","child_name","session","fformation","alone","groupid","gender","chouchou","withmeness_value","evol","new_w")
	csvheader=("idx","datetime","child_id","child_name","session","fformation","alone","groupid","gender","chouchou","withmeness_value","evol","new_w","feedback")
	fcsvheader=("X","idx","datetime","child_id","child_name","session","fformation","alone","groupid","gender","chouchou","feedback")
	
	wcsvfilein = open(wfname, 'r')
	wreader = csv.DictReader(wcsvfilein, wcsvheader)
	fcsvfilein = open(uffname, 'r')
	freader = csv.DictReader(fcsvfilein, fcsvheader)
	next(freader, None)  # skip the headers
	next(wreader, None)  # skip the headers
	
	prev_time = datetime(1985, 7, 2, 12, 30) 
	ufrow = freader.next()
	u_time =  datetime.strptime(ufrow["datetime"], '%Y-%m-%d %H:%M:%S:%f')
	csvfileout = open('uf_withmeness.csv', 'w')
	writer = csv.DictWriter(csvfileout, csvheader)
	writer.writeheader()
	for wrow in wreader:
		print(wrow["datetime"])
		c_time = datetime.strptime(wrow["datetime"], '%Y-%m-%d %H:%M:%S:%f')
		while((u_time> prev_time) and (u_time<= c_time)):
			new_row = {"idx":ufrow["idx"],"datetime":datetime.strftime(c_time,'%Y-%m-%d %H:%M:%S:%f'),"child_id":wrow["child_id"],"child_name":wrow["child_name"],"session":wrow["session"],"fformation":wrow["fformation"],"alone":wrow["alone"],"groupid":wrow["groupid"],"gender":wrow["gender"],"chouchou":wrow["chouchou"],"withmeness_value":wrow["withmeness_value"], "evol":wrow["evol"],"new_w":wrow["new_w"],"feedback":ufrow["feedback"]}
			writer.writerow(new_row)
			ufrow = freader.next()
			u_time =  datetime.strptime(ufrow["datetime"], '%Y-%m-%d %H:%M:%S:%f')
		prev_time = c_time
	
	wcsvfilein.close()
	fcsvfilein.close()
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
	csvheader=("idx","datetime","child_id","child_name","session","fformation","alone","groupid","gender","chouchou","target")
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
				start_time = datetime.strptime(i[2]+' '+i[3], '%d.%m.%y %H:%M:%S.%f')
				end_time = datetime.strptime(i[2]+' '+i[6], '%d.%m.%y %H:%M:%S.%f')
				
				if(current_time>= start_time and  current_time<= end_time):
					new_row = {"idx":row[0],"datetime":datetime.strftime(current_time,'%Y-%m-%d %H:%M:%S:%f'),"child_id":i[0],"child_name":i[1],"session":i[-5],"fformation":i[5],"alone":i[-4],"groupid":i[-3],"gender":i[-2],"chouchou":i[-1],"target":row[2]}
					writer.writerow(new_row)
	csvfileout.close()
	
if __name__=="__main__":
	#exportWithmeness_wfactors()
	#rewrite_withmenssCSV()
	resample_withUF()
	#exportTargets_wfactors()
	
	
