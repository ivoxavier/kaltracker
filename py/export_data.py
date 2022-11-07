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
import glob

class ExportData(): 

    def moduleState():
        return 'Python Module Imported'
    
    def cleanCSVFile():
        csv_list = [
        glob.CSV_USER,
        glob.CSV_INGESTIONS,
        glob.CSV_WEIGHT,
        glob.CSV_WATER
        ]
        
        for path in csv_list:
            try:
                os.remove(path)
            except Exception:
                pass
    
    def userTable():
        pyotherside.send('user_table_exporting')
        db = sqlite3.connect(glob.DBPATH)
        cursor = db.cursor()
        sql_statement = '''SELECT * FROM user'''
        cursor.execute(sql_statement)
        data = cursor.fetchall()
        with open(glob.CSV_USER, 'w') as f:
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
        pyotherside.send('user_ingestions_exporting')
        db = sqlite3.connect(glob.DBPATH)
        cursor = db.cursor()
        sql_statement = '''SELECT * FROM ingestions'''
        cursor.execute(sql_statement)
        data = cursor.fetchall()
        with open(glob.CSV_INGESTIONS, 'w') as f:
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
        pyotherside.send('user_water_exporting')
        db = sqlite3.connect(glob.DBPATH)
        cursor = db.cursor()
        sql_statement = '''SELECT * FROM water_tracker'''
        cursor.execute(sql_statement)
        data = cursor.fetchall()
        with open(glob.CSV_WATER, 'w') as f:
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
        pyotherside.send('user_weight_exporting')
        db = sqlite3.connect(glob.DBPATH)
        cursor = db.cursor()
        sql_statement = '''SELECT * FROM weight_tracker'''
        cursor.execute(sql_statement)
        data = cursor.fetchall()
        with open(glob.CSV_WEIGHT, 'w') as f:
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