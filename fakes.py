#!/usr/bin/python3

from faker import Faker
import pandas as pd
from random import randint
import hashlib
import sys

fake = Faker()

names = [(fake.name()) for i in range(100)]
emails = [(fake.email()) for i in range(100)]
passwords = [(fake.password(length = randint(10, 20))) for i in range(100)]

hashedpwords = []

#sha256 hashing
for p in passwords:
    hashedpwords.append(hashlib.sha256(p.encode()).hexdigest())

namesdf = pd.DataFrame(names)
emailsdf = pd.DataFrame(emails)
passwordsdf = pd.DataFrame(hashedpwords)

namesdf.columns = ['Employee Names']
emailsdf.columns = ['Employee Emails']
passwordsdf.columns = ['Employee Passwords']

dir = str(sys.argv[1])
namesdf.to_csv(dir + 'names/names2_2/names3_5/names.csv')
emailsdf.to_csv(dir + 'emails/emails2_1/emails3_2/emails.csv') 
passwordsdf.to_csv(dir + 'passwords/passwords2_3/passwords3_9/passwords.csv') 

