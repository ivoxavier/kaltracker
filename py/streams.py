'''
 * 2023  Ivo Xavier
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * kaltracker is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 '''

import csv
import os
import sqlite3
import pyotherside
import dbus
import glob
import sql_statements

class Streams:

    @staticmethod
    def moduleState():
        return 'Python Module Imported'
    
    @staticmethod
    def kcal_consumption():
        db = sqlite3.connect(glob.DBPATH)
        cursor = db.cursor()
        cursor.execute(sql_statements.TOTAL_CAL)
        return cursor.fetchall()
    
    @staticmethod
    def days_without_reg():
        db = sqlite3.connect(glob.DBPATH)
        cursor = db.cursor()
        cursor.execute(sql_statements.DAYS_WITHOUT_REG)
        return cursor.fetchall()