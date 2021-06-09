'''
 * 2021  Ivo Xavier
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * kaltracker is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 '''
import csv
import sqlite3
import os

#return a message to confirm py has been loaded
def moduleState():
    return 'Python Module Imported'

full_path = os.path.expanduser("~")
path = '%s/Documents/kaltracker_exports' % full_path
file_name = '%s/Documents/kaltracker_exports/kaltracker_backup.csv' % full_path
device_type = None
access_rights = 0o755



#check if path exists
path_exists = None
def createPath():
    os.mkdir(path, access_rights)

if (os.path.isdir(path)):
    path_exists = True
else:
    path_exists = False
    createPath()

#checks if file exists
file_exists = None
def createFile():
    with open('/home/phablet/Documents/kaltracker_exports/kaltracker_backup.csv', 'wb') as create_file:
        file_writer = csv.writer(create_file, delimiter = ',', quoting=csv.QUOTE_MINIMAL)
        file_writer.writerow(['date','type','name','kcal'])
        create_file.close()

if (os.path.isfile(file_name)):
    file_exists = True
else:
    file_exists = False
    createFile()

def saveCSV(query):
    with open('/home/phablet/Documents/kaltracker_exports/kaltracker_backup.csv', 'w') as csv_file:
        save_on_csv = csv.writer(csv_file)
        save_on_csv.writerow(query)
        csv_file.close()
    return 'Backup created'