#!/usr/bin/python3
import json
import gspread
import argparse
import os
from oauth2client.service_account import ServiceAccountCredentials

# Finds the first empty row of the worksheet.
def find_next_row(worksheet):
    val_list = worksheet.col_values(1)
    row_num = 1
    for row in val_list:
        if row == '':
            return row_num
        row_num += 1
    return row_num

#Authenticates the user to be able to use the sheet
def authenticate(key):
	json_key = json.load(open(key))
	scope = ['https://spreadsheets.google.com/feeds']
	credentials = SignedJwtAssertionCredentials(json_key['project@hacs200-project.iam.gserviceaccount.com'], json_key['\nMIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQDHkRJQgTeLiKeE\naaZ6/glJ3IJDsIct4L1ZOezblrUJc1qThuwQuGMZC3m9WneOaJV/zKeJ5tAs3Pgi\nO716sZw3+YH6IwZo8Yxb8e/wpC6g6oi4K1w0uHQIQh51q+XpIrsZ5L/nYZl9/a+k\n7vGYkUFQAb6Wdjz+VPBc2pb7/0X3ZGTgXRy0yhgUbbTiL0ELR7kZQCuarx8hkJVP\nCi0FNOp0fr0pCCs3UXRr2HxGNnP5na23MWTVkXij+QfgV8Ibmp8PWjNn9FcZDGKZ\nqoy59fGe4fEXMv514UoP/HasI8n+bCWZDyXcK0JQTtELChhd+DclvaDglLRYmzuz\nk0GAPA3hAgMBAAECggEAAPtGA3QElEDGz3rpi7SmJ7aC7tb2bekAur3zMUf2JKbB\nl59+l70gbPtxIizzZkA+GVPQsHfx0YFWDcJiIIaxGwFffJ3MJptRh749N4ochJlt\nX2KEiz8rqu1lqEnWe/q6FYWE1XGAchiGUvcDOdnftVyyKvFH7tmiGQLQ4p+9y1qx\nKXLi6zcPEbfpQoRCUaRQAL4xMIOiJskhVYYGMl9grEYciffL0ccTLwFypKgkOPsT\nzKOGhLfwPUaIR71TOgVlIBVWuXNN5dpjOpixb022yibk/UUdjWwK53KKLOKXVHJS\n00i0lUtsXZmMxIZJHl0G5Xuxjo5zyTB6Pnvf/0kDdQKBgQDqEx4Gj0tJBsSDW1hP\nb3Z5BkE1XzM+eR4Rowhf/GtCBOtsVskCiSFQhsB8326+/N5J3rpWCr17NiGxErID\nIT5PtoHi9r1tfTVn2sAyCghL+vdVfBRQjI6qOEwc5gtxcILgfzhzvacaTtFmgr/9\ncg1+orC/U28a5KJbI0tZoW4fjwKBgQDaQnx6ZqNhoSJ1wO8qV0dXD+3OwVD9tf1n\n4oXcmndJ7+EIOG769G1TN/vzI/kLMbiudkExA6X1lPBP+A3QcLvDc3rAEExYJL8W\njkQTNggL71o24CH/Sb5gtfrGxcBIYB9TLc1FUARLMoiCCOizbHaPVl7q4h61iPEe\nzqoBbCpDjwKBgQCi5Tr4BbC22WbYozEJ1t/zyU6H/gCDcXZjf7nMUrWx9AqCEsNA\naH4utBgwzq0bbI6licLTLhY/MKSxvfj0BKaAgtpRQLUDBSetZqZqLGEpvzVw4DCi\n/a4q95LAabd88neiE+cNZOZtgHxpgoRptH1/q2ilPUMMzB/QnPdLIPSqMQKBgQCK\nNI2UCEguuxUSEXCglBHFjH2ebYU2krX6wVLYZStiMzaAuRN1b6+Gga3VwZKixwJV\n3uXa/p9pSb1+NemxcqFC224ADpH5QpOJ2d47d/xSambq1rRQbkbSAInisjfW3J8Z\nUaho2olNgJs2FCQd8XGFxEBoZXTiqOteAalfKzn7+wKBgQCfMeqJNRiSTh9PjNc2\nAV542aERHh5zz86twXQ2qeeUZagIGphuPW20Qw2lfn2+ZkolDgruhGvYbKA++C/v\n2N81thAcCw9tjJ9u8l41qKlQWYqU15cdu70HUaN1uBVWeIXIRHQPyKgasHyp+/eB\n7a8BlIQARMYmnz+F1JDBbBG9xw==\n'].encode(), scope)
	gc = gspread.authorize(credentials)
	return gc

def main():
	#parse arguments

	parser = argparse.ArgumentParser(prog="log")
	parser.add_argument("-k", "--key", required=True, help="The json key file needed for authentication")
	parser.add_argument("-s", "--sheet", required=True, help="The URL of the google sheet")
	parser.add_argument("-d", "--data", required=True, help="Data to update the sheet with, separated by commas")
	parser.add_argument("-w", "--worksheet", help="Worksheet name - only if you are using a sheet that isn't the first sheet")
	parser.add_argument("-D", "--delimiter", help="Delimiter if you want to use something other than commas")

	args = parser.parse_args()
	
	#just in case... we'll write it ti this file.

	file = open("/logging/log.txt", "a+")
	file.write(args.data)
	file.write("\n")
	file.close()

	try:

		auth = authenticate(str(args.key))

		spread = auth.open_by_url(str(args.sheet))

		if(args.worksheet == None):
			wks = spread.sheet1
		else:
			wks = spread.worksheet(str(args.worksheet))
		
		startCol = 'A'
		startRow = str(find_next_row(wks))
		wrap = 0
		if(args.delimiter == None):
			for segment in args.data.split(','):
				if(startCol == 'Z'):
					wrap = 1
					wks.update_acell(str(startCol) + startRow, segment)
					startCol = 'A'
				elif (wrap == 1):
					wks.update_acell("A" + str(startCol) + startRow, segment)
					startCol = chr(ord(startCol) + 1)
				else:
					wks.update_acell(str(startCol) + startRow, segment)
					startCol = chr(ord(startCol) + 1)

				
		else:
			for segment in args.data.split(args.delimiter):
				wks.update_acell(str(startCol) + startRow, segment)
				startCol = chr(ord(startCol) + 1)
		
		print("Successfully updated!")
	#ICOF
	except Exception as e:
		print("Error:")
		print(e)

main()
