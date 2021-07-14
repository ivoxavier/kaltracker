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



def moduleState():
    return 'Python Module Imported'


mobile_path = '/home/phablet/Documents/kaltracker_exports'

file_ingestions = '/home/phablet/Documents/kaltracker_exports/kaltracker_ingestions.csv'

file_user = '/home/phablet/Documents/kaltracker_exports/kaltracker_user.csv'

file_weight_tracker = '/home/phablet/Documents/kaltracker_exports/kaltracker_weight_tracker.csv'

access_rights = 0o755

all_dir = [file_ingestions,file_user,file_weight_tracker]


def createPath():
    try:
        os.mkdir(mobile_path, access_rights)
    except:
        return 'create_path_failed'
    return 'path_created'


def deleteFile():
    for i in all_dir:
        try:
            os.remove(i)
        except:
            return 'file_not_deleted_or_not_existant'

    return 'file_deleted'


def createFile():
    for i in all_dir:

        try:
            each_file = open(i, 'w')
            each_file.close()
        except:
            return 'files_not_created'

    return 'files_created_and_cleaned'
    


def saveIngestions(query_ingestions):
    try:
        with open(file_ingestions, 'w') as csv_file:
            save_on_csv = csv.writer(csv_file)
            save_on_csv.writerow(["date","time","type","product_name","nutriscore_grade","kcal","fat","saturated","carbo","sugars","proteins"])
            save_on_csv.writerow([query_ingestions])
            csv_file.close()
            return 'file_saved'
    except:
        return 'file_not_saved'


def saveUser(query_user):
    try:
        with open(file_user, 'w') as csv_file:
            save_on_csv = csv.writer(csv_file)
            save_on_csv.writerow(["username","age","sex","weight","height","activity","goal"])
            save_on_csv.writerow([query_user])
            csv_file.close()
            return 'file_saved'
    except:
        return 'file_not_saved'


def saveWeight(query_weight_tracker):
    try:
        with open(file_weight_tracker, 'w') as csv_file:
            save_on_csv = csv.writer(csv_file)
            save_on_csv.writerow(["previous_weight","new_weight","new_weight_date"])
            save_on_csv.writerow([query_weight_tracker])
            csv_file.close()
            return 'file_saved'
    except:
        return 'file_not_saved'
