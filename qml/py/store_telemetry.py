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
import sqlite3
import json



def moduleState():
    return 'Python Module Imported'

class ManageDW():

    access_rights = 0o755

    db_path = '/home/phablet/.local/share/kaltracker.ivoxavier/Databases/kaltracker_telemetry.sqlite'
    
    db_connection = sqlite3.connect(db_path)

    def dropTable():
        cursor = ManageDW.db_connection.cursor()
        sql_statement = "DROP TABLE IF EXISTS Telemetry"
        cursor.execute(sql_statement)
        ManageDW.db_connection.commit()
        cursor.close()
        return 'Table cleaned'


    def createTable():  
        cursor = ManageDW.db_connection.cursor()
        cursor.execute('''CREATE TABLE Telemetry(
        idTelemtry INTEGER PRIMARY KEY,
        time_spent TEXT)''')
        ManageDW.db_connection.commit()
        cursor.close()
        return 'db created'
    

    def saveTime(time_spent):
        cursor = ManageDW.db_connection.cursor()
        sql_statement = '''INSERT INTO Telemetry(
            time_spent)
            VALUES (?)'''
        cursor.execute(sql_statement, [time_spent])
        ManageDW.db_connection.commit()
        cursor.close()
        return 'spent_time save'

    def deleteTime():
        cursor = ManageDW.db_connection.cursor()
        sql_statement = '''DELETE FROM Telemetry'''
        cursor.execute(sql_statement)
        ManageDW.db_connection.commit()
        cursor.close()
        return 'spent_time save'
