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

# Gets the sum of calories registered in the app (returns 0 instead of None if empty)
TOTAL_CAL = "SELECT COALESCE(SUM(cal), 0) FROM ingestions"

# To verify if there have been ingestions in the app in the last 5 days
DAYS_WITHOUT_REG = "SELECT COUNT(*) FROM ingestions WHERE DATE(date) > DATE('now', '-5 day')"

