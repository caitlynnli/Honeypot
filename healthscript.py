#!/usr/bin/env python3
import gspread
from oauth2client.service_account import ServiceAccountCredentials
import os

# use creds to create a client to interact with the Google Drive and Google Sheets API
scope = ["https://spreadsheets.google.com/feeds",'https://www.googleapis.com/auth/spreadsheets',"https://www.googleapis.com/auth/drive.file","https://www.googleapis.com/auth/drive"]
creds = ServiceAccountCredentials.from_json_keyfile_name('/root/health_log_creds.json', scope)
client = gspread.authorize(creds)

# Put the name of your spreadsheet here
sheet = client.open("Health Log").sheet1

# Example of how to insert a row
index = 2

os.system("/root/bashscript.sh")

row = open("/root/outputrow.txt", 'r')

currentrow = [row.readline(), row.readline(), row.readline(), row.readline(), row.readline(), row.readline(), row.readline(), row.readline(), row.readline(), row.readline(), row.readline(), row.readline(), row.readline(), row.readline(), row.readline(), row.readline(), row.readline(), row.readline(), row.readline(), row.readline(), row.readline()]

sheet.insert_row(currentrow, index)
#os.remove("/root/outputrow.txt")

