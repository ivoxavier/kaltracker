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

class ImportData():
    files_exists = []
    file_integrity = []

    def moduleState():
        return 'Python Module Imported'
    
    def filesExists():
        global files_exists
        files_exists.append(0) if not os.path.exists(glob.IMPORT_CSV_USER) else files_exists.append(1)
        files_exists.append(0) if not os.path.exists(glob.IMPORT_CSV_INGESTIONS) else files_exists.append(1)
        files_exists.append(0) if not os.path.exists(glob.IMPORT_CSV_WEIGHT) else files_exists.append(1)
        files_exists.append(0) if not os.path.exists(glob.IMPORT_CSV_WATER) else files_exists.append(1)
        return True if sum(files_exists) == 4 else False

    def emptyBD():
        db = sqlite3.connect(glob.DBPATH)
        cursor = db.cursor()
        sql_statements = ['''DELETE FROM water_tracker''',
        '''DELETE FROM user''',
        '''DELETE FROM ingestions''',
        '''DELETE FROM weight_tracker''',
        '''DELETE FROM user_foods_list''',
        '''DELETE FROM notes''']
        for statement in sql_statements:
            cursor.execute(statement)
        return True

    def validHeaders():
        global file_integrity
        with open(glob.IMPORT_CSV_USER, 'r') as csv_user:
            reader = csv.reader(csv_user)
            header = [row for row in reader][0]
            file_integrity.append(1) if header == ['id','age','sex_at_birth',
            'weight','height','activity',
            'rec_cal','ap_lo','ap_hi'] else file_integrity.append(0)
        with open(glob.IMPORT_CSV_INGESTIONS, 'r') as csv_ingestions:
            reader = csv.reader(csv_ingestions)
            header = [row for row in reader][0]
            file_integrity.append(1) if header == ['id','id_user','name',
            'nutriscore','cal','fat',
            'carbo','protein','date','meal'] else file_integrity.append(0)
        with open(glob.IMPORT_CSV_WEIGHT, 'r') as csv_weight:
            reader = csv.reader(csv_weight)
            header = [row for row in reader][0]
            file_integrity.append(1) if header == ['id','id_user','weight','date'] else file_integrity.append(0)
        with open(glob.IMPORT_CSV_WATER, 'r') as csv_water:
            reader = csv.reader(csv_water)
            header = [row for row in reader][0]
            file_integrity.append(1) if header == ['id','id_user','cups','date'] else file_integrity.append(0)
        return True if sum(file_integrity) == 4 else False

    def loadData():
        user_insert_statement = "INSERT INTO user (id,age,sex_at_birth,weight,height,activity,rec_cal,ap_lo,ap_hi) \
            VALUES(?,?,?,?,?,?,?,?,?)"
        ingestions_insert_statement = "INSERT INTO ingestions (id,id_user,name,nutriscore,cal,fat,carbo,protein,date,meal) \
            VALUES(?,?,?,?,?,?,?,?,?,?)"
        weight_insert_statement = "INSERT INTO weight_tracker (id,id_user,weight,date) VALUES(?,?,?,?)"
        water_insert_statement = "INSERT INTO water_tracker (id,id_user,cups,date) VALUES(?,?,?,?)"  
        db = sqlite3.connect(glob.DBPATH)
        cursor = db.cursor()    
        with open(glob.IMPORT_CSV_USER, 'r') as csv_user:
            reader = csv.reader(csv_user)
            file = [row for row in reader][1:]
            for row in file:
                try:
                    #csv index columns
                    cursor.execute(user_insert_statement,[row[0],row[1],row[2],
                    row[3],row[4],row[5],row[6],
                    row[7],row[8]])
                    db.commit()
                except Exception as e:
                    #pyotherside.send()
                    print(e)
        with open(glob.IMPORT_CSV_INGESTIONS, 'r') as csv_ingestions:
            reader = csv.reader(csv_ingestions)
            file = [row for row in reader][1:]
            for row in file:
                try:
                    #csv index columns
                    cursor.execute(ingestions_insert_statement,[row[0],row[1],row[2],
                    row[3],row[4],row[5],row[6],
                    row[7],row[8],row[9]])
                    db.commit()
                except Exception as e:
                    #pyotherside.send()
                    print(e)
        with open(glob.IMPORT_CSV_WEIGHT, 'r') as csv_weight:
            reader = csv.reader(csv_weight)
            file = [row for row in reader][1:]
            for row in file:
                try:
                    #csv index columns
                    cursor.execute(weight_insert_statement,[row[0],row[1],row[2],row[3]])
                    db.commit()
                except Exception as e:
                    #pyotherside.send()
                    print(e)
        with open(glob.IMPORT_CSV_WATER, 'r') as csv_water:
            reader = csv.reader(csv_water)
            file = [row for row in reader][1:]
            for row in file:
                try:
                    #csv index columns
                    cursor.execute(water_insert_statement,[row[0],row[1],row[2],row[3]])
                    db.commit()
                except Exception as e:
                    #pyotherside.send()
                    print(e)
            

import_data = ImportData()