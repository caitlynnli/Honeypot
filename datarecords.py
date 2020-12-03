import gspread
from oauth2client.service_account import ServiceAccountCredentials

# use creds to create a client to interact with the Google Drive and Google Sheets API
scope = ["https://spreadsheets.google.com/feeds",'https://www.googleapis.com/auth/spreadsheets',"https://www.googleapis.com/auth/drive.file","https://www.googleapis.com/auth/drive"]
creds = ServiceAccountCredentials.from_json_keyfile_name('data_recording_creds.json', scope)
client = gspread.authorize(creds)

# Put the name of your spreadsheet here
sheet = client.open("Data Records").sheet1

# Example of how to insert a row
index = 1

file = open('attacker_data.txt', 'r')
file1= open('attacker_data.txt', 'r')
lines = file.readlines()

count = 0
for line in lines:
    
