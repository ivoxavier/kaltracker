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

#gets the sum of calories registed in the app
TOTAL_CAL = 'SELECT SUM(cal) FROM ingestions'

#to verify if has been ingestions in the app
DAYS_WITHOUT_REG = "SELECT COUNT(*) FROM ingestions WHERE DATE(date) > DATE('now', '-5 day')"

