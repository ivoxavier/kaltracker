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
import pyotherside
import glob

class ExportData:
    @staticmethod
    def moduleState():
        return 'Python Module Imported'
    
    @staticmethod
    def createFiles():
        db = sqlite3.connect(glob.DBPATH)
        cursor = db.cursor()
        files_exported = []

        user_sql_statement = '''SELECT * FROM user'''
        ingestions_sql_statement = '''SELECT * FROM ingestions'''
        water_sql_statement = '''SELECT * FROM water_tracker'''
        weight_sql_statement = '''SELECT * FROM weight_tracker'''

        csv_list = [
            glob.EXPORT_CSV_USER,
            glob.EXPORT_CSV_INGESTIONS,
            glob.EXPORT_CSV_WEIGHT,
            glob.EXPORT_CSV_WATER
        ]

        for path in csv_list:
            try:
                os.remove(path)
            except Exception:
                pass

        cursor.execute(user_sql_statement)
        user_data = cursor.fetchall()
        with open(glob.EXPORT_CSV_USER, 'w', newline='') as f:
            writer = csv.writer(f)
            writer.writerow(['id', 'age', 'sex_at_birth', 'weight', 'height', 'activity', 'rec_cal', 'ap_lo', 'ap_hi'])
            writer.writerows(user_data)
        files_exported.append(1)

        cursor.execute(ingestions_sql_statement)
        ingestions_data = cursor.fetchall()
        with open(glob.EXPORT_CSV_INGESTIONS, 'w', newline='') as f:
            writer = csv.writer(f)
            writer.writerow(['id', 'id_user', 'name', 'nutriscore', 'cal', 'fat', 'carbo', 'protein', 'date', 'meal'])
            writer.writerows(ingestions_data)
        files_exported.append(1)

        cursor.execute(water_sql_statement)
        water_data = cursor.fetchall()
        with open(glob.EXPORT_CSV_WATER, 'w', newline='') as f:
            writer = csv.writer(f)
            writer.writerow(['id', 'id_user', 'cups', 'date'])
            writer.writerows(water_data)
        files_exported.append(1)

        cursor.execute(weight_sql_statement)
        weight_data = cursor.fetchall()
        with open(glob.EXPORT_CSV_WEIGHT, 'w', newline='') as f:
            writer = csv.writer(f)
            writer.writerow(['id', 'id_user', 'weight', 'date'])
            writer.writerows(weight_data)
        files_exported.append(1)

        db.close()

        if sum(files_exported) == 4:
            pyotherside.send("files_export_success")
        else:
            pyotherside.send("files_export_fail")

class ImportData:
    @staticmethod
    def moduleState():
        return 'Python Module Imported'
    
    @staticmethod
    def filesExists():
        file_paths = [
            glob.IMPORT_CSV_USER,
            glob.IMPORT_CSV_INGESTIONS,
            glob.IMPORT_CSV_WEIGHT,
            glob.IMPORT_CSV_WATER
        ]
        headers_expected = [
            ['id', 'age', 'sex_at_birth', 'weight', 'height', 'activity', 'rec_cal', 'ap_lo', 'ap_hi'],
            ['id', 'id_user', 'name', 'nutriscore', 'cal', 'fat', 'carbo', 'protein', 'date', 'meal'],
            ['id', 'id_user', 'weight', 'date'],
            ['id', 'id_user', 'cups', 'date']
        ]
        files_exists = []
        file_integrity = []

        for path, header_expected in zip(file_paths, headers_expected):
            exists = os.path.exists(path)
            files_exists.append(1 if exists else 0)

            if exists:
                with open(path, 'r') as f:
                    reader = csv.reader(f)
                    header = next(reader)
                    file_integrity.append(1 if header == header_expected else 0)

        if sum(files_exists) == 4:
            if sum(file_integrity) == 4:
                pyotherside.send("file_verification_success")
            else:
                pyotherside.send("file_verification_fail")
        else:
            return 0

    @staticmethod
    def loadData():
        db = sqlite3.connect(glob.DBPATH)
        cursor = db.cursor()
        files_loaded = []

        sql_statements = [
            '''DELETE FROM water_tracker''',
            '''DELETE FROM user''',
            '''DELETE FROM ingestions''',
            '''DELETE FROM weight_tracker''',
            '''DELETE FROM user_foods_list''',
            '''DELETE FROM notes'''
        ]
        for statement in sql_statements:
            cursor.execute(statement)

        with open(glob.IMPORT_CSV_USER, 'r') as csv_user:
            reader = csv.reader(csv_user)
            next(reader)  # Skip header
            cursor.executemany(
                "INSERT INTO user (id, age, sex_at_birth, weight, height, activity, rec_cal, ap_lo, ap_hi) "
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)",
                reader
            )
            db.commit()
        files_loaded.append(1)

        with open(glob.IMPORT_CSV_INGESTIONS, 'r') as csv_ingestions:
            reader = csv.reader(csv_ingestions)
            next(reader)  # Skip header
            cursor.executemany(
                "INSERT INTO ingestions (id, id_user, name, nutriscore, cal, fat, carbo, protein, date, meal) "
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
                reader
            )
            db.commit()
        files_loaded.append(1)

        with open(glob.IMPORT_CSV_WEIGHT, 'r') as csv_weight:
            reader = csv.reader(csv_weight)
            next(reader)  # Skip header
            cursor.executemany(
                "INSERT INTO weight_tracker (id, id_user, weight, date) VALUES (?, ?, ?, ?)",
                reader
            )
            db.commit()
        files_loaded.append(1)

        with open(glob.IMPORT_CSV_WATER, 'r') as csv_water:
            reader = csv.reader(csv_water)
            next(reader)  # Skip header
            cursor.executemany(
                "INSERT INTO water_tracker (id, id_user, cups, date) VALUES (?, ?, ?, ?)",
                reader
            )
            db.commit()
        files_loaded.append(1)

        db.close()

        if sum(files_loaded) == 4:
            pyotherside.send("load_success")
        else:
            pyotherside.send("load_fail")

export_data = ExportData()
import_data = ImportData()