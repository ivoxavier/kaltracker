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
import subprocess
#import glob

class Streams:
    @staticmethod
    def moduleState():
        #os.system("notify-send 'ahahah' 'asdasdas'")
        #subprocess.Popen("/usr/bin/dbus-send asdasdasd")
        subprocess.Popen("/usr/bin/gdbus call --session --dest org.freedesktop.Notifications --object-path /org/freedesktop/Notifications --method org.freedesktop.Notifications.Notify", shell=True)
        title = "My Notification"
        message = "This is a notification triggered by Python without any additional packages or notify-send!"
        #subprocess.run(["dbus-send", "--session", "--dest=org.freedesktop.Notifications",
        #            "--type=method_call", "/org/freedesktop/DBus",
        #            "org.freedesktop.DBus.Notify", "string:kaltracker.ivoxavier",
        #            "uint32:0", "", "string:{}".format(title), "string:{}".format(message),
        #            "array:string:''", "dict:string:string:''", "int32:-1"], check=True)
        #subprocess.run(['echo', 'Notification Title: This is a notification message'])
        return 'Streams Module Imported'
    
     ## Push PUSH_Notification
        #json_bat = "\'\"{\\\"message\\\": \\\"foobar\\\", \\\"notification\\\":{\\\"card\\\": {\\\"summary\\\": \\\"" + self.BATT_Per_print + "\\\", \\\"body\\\": \\\"" + "Please disconnect your charger" + "\\\", \\\"popup\\\": true, \\\"persist\\\": true}, \\\"sound\\\": true, \\\"vibrate\\\": {\\\"pattern\\\": [200, 100], \\\"duration\\\": 200,\\\"repeat\\\": 2 }}}\"\'"
        #subprocess.Popen("/usr/bin/gdbus call --session --dest com.ubuntu.Postal --object-path /com/ubuntu/Postal/indicator_2eupower_2eernesst --method com.ubuntu.Postal.Post indicator.upower.ernesst_indicator-upower " +  json_bat, shell=True)
        #logger.debug("Notification sent for" + self.BATT_Per_print)
    
