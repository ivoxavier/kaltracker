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
import os


#return a message to confirm py has been loaded
def moduleState():
    return 'Python Module Imported'


mobile_path = '/home/phablet/Documents/kaltracker_exports'
file_name = '/home/phablet/Documents/kaltracker_exports/kaltracker_backup.csv'
access_rights = 0o755

def createPath():
    try:
        os.mkdir(mobile_path, access_rights)
        return 'path_created'
    except:
        return 'create_path_failed'


def createFile():
    try:
        with open(file_name, 'w') as create_file:
            file_writer = csv.writer(create_file)
            create_file.close()
            return 'file_created'
    except:
        return 'file_not_created'


def deleteCSV():
    try:
        os.remove(file_name)
        return 'file_deleted'
    except:
        return 'file_not_deleted'



def saveCSV(query):
    try:
        with open(file_name, 'w') as csv_file:
            save_on_csv = csv.writer(csv_file)
            save_on_csv.writerow(["date","time","type","product_name","kcal","fat","saturated","carbo","sugars","fiber","proteins","salt"])
            save_on_csv.writerow([query])
            csv_file.close()
            return 'file_saved'
    except:
        return 'file_not_saved'

