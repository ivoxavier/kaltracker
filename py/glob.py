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

CSV_USER = SHAREPATH + 'kaltracker_user_table.csv'
CSV_INGESTIONS = SHAREPATH + 'kaltracker_ingestions_table.csv'
CSV_WEIGHT = SHAREPATH + 'kaltracker_weight_tracker_table.csv'
CSV_WATER = SHAREPATH + 'kaltracker_water_tracker_table.csv'