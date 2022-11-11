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

import os

SHAREPATH = "%s/kaltracker.ivoxavier/" % os.environ["XDG_DATA_HOME"]
DBPATH = SHAREPATH + "Databases/baabdb5fba30cf6014354be8893cdf5c.sqlite"
EXPORTPATH = SHAREPATH + "Export"
IMPORTPATH = SHAREPATH + "Import"


EXPORT_CSV_USER = EXPORTPATH + 'user_table.csv'
EXPORT_CSV_INGESTIONS = EXPORTPATH + 'ingestions_table.csv'
EXPORT_CSV_WEIGHT = EXPORTPATH + 'weight_tracker_table.csv'
EXPORT_CSV_WATER = EXPORTPATH + 'water_tracker_table.csv'
IMPORT_CSV_USER = IMPORTPATH + 'user_table.csv'
IMPORT_CSV_INGESTIONS = IMPORTPATH + 'ingestions_table.csv'
IMPORT_CSV_WEIGHT = IMPORTPATH + 'weight_tracker_table.csv'
IMPORT_CSV_WATER = IMPORTPATH + 'water_tracker_table.csv'

if not os.path.exists(EXPORTPATH):
    try:
        os.makedirs(EXPORTPATH)
    except Exception as e:
        print("Can't create dir:\n"+EXPORTPATH)

if not os.path.exists(IMPORTPATH):
    try:
        os.makedirs(IMPORTPATH)
    except Exception as e:
        print("Can't create dir:\n"+IMPORTPATH)