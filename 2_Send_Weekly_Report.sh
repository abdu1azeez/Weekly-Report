#!/usr/bin/python

#**************************************************************************************************************************************************************
# Script Version: Version 5.0
# Owner: M Abdul Azeez Muqthar (06121Z)
# Program name: 2_Send_Weekly_Report
# Release Date: 23-Apr-2019
# Credits: Source languages used - Python, Html, Bash
# Version 5.0 updates: Process has been simplified ,html output is generated and report file is attached.
#
# Input:  From Service Now files
# Output: Mail Report, Monthly_Report.xlsx and Email
#
#**************************************************************************************************************************************************************
#
#
#************************************************************* Please refrain from editing this file **********************************************************

import pandas as pd
import numpy as np
import glob
import subprocess
import os
import sys
from datetime import date, timedelta, datetime








to_address = "elijosep@in.ibm.com, vp.shetty@in.ibm.com"					# To Address
cc_address = ""								# CC Address	Enter your email address in between the quotes













date = datetime.today().date()

start_date = date + timedelta(-date.weekday(), weeks=-1)

end_date = date + timedelta(-date.weekday() - 1)

subject = 'Weekly analysis of Incidents /Change requests/Service Requests from ' + start_date.strftime('%d-%b-%y') + ' to ' + end_date.strftime('%d-%b-%y')


incident_columns = sorted([u'Number', u'Priority', u'Affected Date', u'Company', u'State', u'Resolved', u'Category', u'Assignment group', u'Assigned to', u'Resolved by', u'Work notes', u'Short description', u'Breached Resolution Time', u'Type'])

columns = ['Number' , 'Short description','Priority', 'Category', 'Affected Date', 'Company', 'State', 'Assigned to', 'Resolved by', 'Work notes']

sr_columns = columns[:]
sr_columns.remove('Category')

change_columns = sorted([u'Number', u'Company', u'Short description', u'Approval', u'Type', u'State', u'Planned start date', u'Planned end date', u'Assigned to'])

incident_files_count = int(subprocess.check_output('ls ./Input/|grep incident*|wc -l', shell=True).strip('\n'))
change_files_count = int(subprocess.check_output('ls ./Input/|grep change*|wc -l', shell=True).strip('\n'))

os.system('cd ./Input/; c=0;for f in incident*.xlsx; do ((c++));  mv "$f" incident\("$c"\).xlsx ; done > /dev/null 2>&1')	
os.system('cd ./Input/; c=0;for f in change*.xlsx; do ((c++));  mv "$f" change\("$c"\).xlsx ; done > /dev/null 2>&1')

duplicate_incidents = os.popen('cd Input; [ `diff -q incident\(1\).xlsx incident\(2\).xlsx|wc -l` = 0 ] || [ `diff -q incident\(2\).xlsx incident\(3\).xlsx|wc -l` = 0 ] || [ `diff -q incident\(1\).xlsx incident\(3\).xlsx|wc -l` = 0 ] && echo True || echo False').read().strip('\n')
duplicate_changes = os.popen('cd Input; [ `diff -q change\(1\).xlsx change\(2\).xlsx|wc -l` = 0 ] || [ `diff -q change\(2\).xlsx change\(3\).xlsx|wc -l` = 0 ] || [ `diff -q change\(1\).xlsx change\(3\).xlsx|wc -l` = 0 ] && echo True || echo False').read().strip('\n')

if (incident_files_count != 3):
	print('Terminated: Download incident files of all three regions')

elif (change_files_count != 3):
	print('Terminated: Download change files of all three regions')

elif (duplicate_incidents == 'True'):
	print('Terminated: Duplicate Incidents found')

elif (duplicate_changes == 'True'):
	print('Terminated: Duplicate Changes found')

else:

	incident_data = pd.DataFrame()
	for f, region in zip(glob.glob('./Input/incident*'), ['AP', 'EU', 'NA']):
	   df = pd.read_excel(f)
	   if (sorted(df.columns) != incident_columns):
		sys.exit('Fields ' + str(list(set(incident_columns).difference(df.columns))[:]) + ' not found in ' + region + ' region')
	   incident_data = incident_data.append(df, ignore_index=True)
	
	o = incident_data.select_dtypes(include=['object']).columns.tolist()
	incident_data[o] = incident_data[o].fillna('')

	for col in o:
	    incident_data[col] = incident_data[col].apply(lambda x: x.encode('ascii','ignore'))

	incident_writer = pd.ExcelWriter('./Input/Incidents.xlsx', engine='xlsxwriter')
	incident_data.to_excel(incident_writer, sheet_name='Sheet1', index = False)
	incident_writer.save()
	os.system('rm -rf ./Input/incident*')


	change_data = pd.DataFrame()
	for f, region in zip(glob.glob('./Input/change*'), ['AP', 'EU', 'NA']):
	   df = pd.read_excel(f)
	   if (sorted(df.columns) != change_columns):
		sys.exit('Fields ' + str(list(set(change_columns).difference(df.columns))[:]) + ' not found in ' + region + ' region')
	   change_data = change_data.append(df, ignore_index=True)

	o = change_data.select_dtypes(include=['object']).columns.tolist()
	change_data[o] = change_data[o].fillna('')

	for col in o:
	    change_data[col] = change_data[col].apply(lambda x: x.encode('ascii','ignore'))

	change_writer = pd.ExcelWriter('./Input/Changes.xlsx', engine='xlsxwriter')
	change_data.sort_values(by = 'Planned start date', inplace= True)
	change_data.to_excel(change_writer, sheet_name='Sheet1', index = False)
	change_writer.save()
	os.system('rm -rf ./Input/change*')
	
	
	incident_data['Work notes'].fillna('', inplace=True)
	incident_data['Work notes'] = incident_data['Work notes'].apply(lambda x: x.split('\n\n')[0])

	incident_data['Work notes'] = incident_data['Work notes'].apply(lambda x: x.replace('\n', '<br/>').replace('(Work notes)', '<br/>'))
	
	incident_data['Affected Only Date'] = incident_data['Affected Date'].apply(lambda x: x.date())


	f = open('./Output/Mail_Report.html', 'w+')

	f.write("<html>\n<head>\n<title>Weekly Report</title>\n</head>\n<body>")
	
	f.close()


	f = open('./Output/Mail_Report.html', 'a+')

	f.write('<p>Hi,</p>\n')

	f.write('<br/>\nWeekly Report has been generated.<br/>\n<br/>\n Kindly check the attachment section\n')

	f.write('\n<br/><br/><br/>\n*** This is an automatically generated email, please do not reply ***')

	f.write('</body></html>')

	f.close()


	report_writer = pd.ExcelWriter('./Output/Weekly_Report_'+ start_date.strftime('%d-%b-%y') + '_to_' + end_date.strftime('%d-%b-%y') +'.xlsx', engine='xlsxwriter')

	incident_data['Work notes'] = incident_data['Work notes'].apply(lambda x: x.replace('<br/>', ' '))

	incident_data[incident_data['Type'] == 'Incident'][columns].sort_values(by = 'Affected Date', ascending = False).to_excel(report_writer, sheet_name= 'Incidents', index = False)

	incident_data[incident_data['Type'] == 'Service Request'][sr_columns].sort_values(by = 'Affected Date', ascending = False).to_excel(report_writer, sheet_name= 'Service Requests', index = False)	

	change_data.to_excel(report_writer, sheet_name= 'Changes', index = False)


	report_writer.save()

	os.system("if [ `ps aux|grep postfix|wc -l` -lt 4 ]; then sudo start postfix; fi")
	os.system("gio open ./Output/Mail_Report.html")
	od.system("rm -rf ./Output/Weekly_Report* ")
	os.system("""echo 'Do you want to mail it? [Y/N]'; read answer;  if [ "$answer" != "${answer#[Yy]}" ] ;then cat ./Output/Mail_Report.html |/usr/local/bin/mutt -e 'set content_type=text/html' -s '""" + subject +"' -a ./Output/Weekly_Report* -c '"+ cc_address + "' -- " + to_address + ";echo 'Mail Sent'; else echo 'Mail not sent'; fi")
	os.system("rm -rf ./Input/Incidents.xlsx ./Input/Changes.xlsx; sleep 3")
	

