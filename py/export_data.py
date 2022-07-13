'''
 * 2022  Ivo Xavier
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
import sqlite3
import time
import pyotherside

class ExportData(): 

    global mobile_path
    mobile_path = "%s/kaltracker.ivoxavier/" % os.environ["XDG_DATA_HOME"]

    global db_path
    db_path = "%s/kaltracker.ivoxavier/Databases/baabdb5fba30cf6014354be8893cdf5c.sqlite" % os.environ["XDG_DATA_HOME"]

    global csv_ingestions_table
    csv_ingestions_table = mobile_path + 'kaltracker_ingestions_table.csv'

    global csv_user_table
    csv_user_table = mobile_path + 'kaltracker_user_table.csv'

    global csv_weight_tracker_table
    csv_weight_tracker_table = mobile_path + 'kaltracker_weight_tracker_table.csv'

    global csv_water_tracker_table
    csv_water_tracker_table = mobile_path + 'kaltracker_water_tracker_table.csv'
    
    def moduleState():
        return 'Python Module Imported'
    

    def createCSVFile():
        global mobile_path, csv_ingestions_table, csv_user_table, csv_weight_tracker_table, csv_water_tracker_table
        all_files = [csv_user_table,
        csv_ingestions_table,
        csv_water_tracker_table,
        csv_weight_tracker_table]
        
        for i in all_files:
            try:
                os.remove(i)
            except FileExistsError:
                return 'file_not_deleted_or_not_existant'
        
        for i in all_files:
            try:
                each_file = open(i, 'w')
                each_file.close()
            except FileExistsError:
                return 'file_not_deleted_or_not_existant'
        return 'file_deleted'

    
    
    def userTable():
        global db_path, csv_user_table
        pyotherside.send('user_table_exporting')
        db = sqlite3.connect(db_path)
        cursor = db.cursor()
        sql_statement = '''SELECT * FROM user'''
        cursor.execute(sql_statement)
        data = cursor.fetchall()
        with open(csv_user_table, 'w') as f:
            writer = csv.writer(f)
            writer.writerow(['id',
            'age',
            'sex_at_birth',
            'weight',
            'height',
            'activity',
            'rec_cal',
            'ap_lo',
            'ap_hi'
            ])
            writer.writerows(data)
        cursor.close()
        time.sleep(1)
        pyotherside.send('user_table_exported')
  
    def ingestionsTable():
        global db_path, csv_ingestions_table 
        pyotherside.send('user_ingestions_exporting')
        db = sqlite3.connect(db_path)
        cursor = db.cursor()
        sql_statement = '''SELECT * FROM ingestions'''
        cursor.execute(sql_statement)
        data = cursor.fetchall()
        with open(csv_ingestions_table, 'w') as f:
            writer = csv.writer(f)
            writer.writerow(['id',
            'id_user',
            'name',
            'nutriscore',
            'cal',
            'fat',
            'carbo',
            'protein',
            'date',
            'meal'
            ])
            writer.writerows(data)
        cursor.close()
        time.sleep(1)
        pyotherside.send('user_ingestions_exported')

    def waterTable():
        global db_path, csv_water_tracker_table 
        pyotherside.send('user_water_exporting')
        db = sqlite3.connect(db_path)
        cursor = db.cursor()
        sql_statement = '''SELECT * FROM water_tracker'''
        cursor.execute(sql_statement)
        data = cursor.fetchall()
        with open(csv_water_tracker_table, 'w') as f:
            writer = csv.writer(f)
            writer.writerow(['id',
            'id_user',
            'cups',
            'date'])
            writer.writerows(data)
        cursor.close()
        time.sleep(1)
        pyotherside.send('user_water_exported')
    
    def weightTable():
        global db_path, csv_weight_tracker_table 
        pyotherside.send('user_weight_exporting')
        db = sqlite3.connect(db_path)
        cursor = db.cursor()
        sql_statement = '''SELECT * FROM weight_tracker'''
        cursor.execute(sql_statement)
        data = cursor.fetchall()
        with open(csv_weight_tracker_table, 'w') as f:
            writer = csv.writer(f)
            writer.writerow(['id',
            'id_user',
            'weight',
            'date'])
            writer.writerows(data)
        cursor.close()
        time.sleep(1)
        pyotherside.send('user_weight_exported')
    
export_data = ExportData()