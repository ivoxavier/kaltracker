/*
 * 2022-2023  Ivo Xavier
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
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.9
import Lomiri.Components 1.3
import Qt.labs.settings 1.0
import Lomiri.PushNotifications 0.1

PushClient {
    id: pushClient

    appId: "kaltracker.ivoxavier_kaltracker"
    //onTokenChanged: console.log("TOKEN", pushClient.token)

    //onCountChanged: console.log("count: " + count)


    function sendPush(title, body){
            var req = new XMLHttpRequest();
            req.open("post", "https://push.ubports.com/notify", true);
            req.setRequestHeader("Content-type", "application/json");
            req.onreadystatechange = function() {
                    if ( req.readyState === XMLHttpRequest.DONE ) {
                                    console.log("push notification: ", req.responseText);
                                    var ans = JSON.parse(req.responseText);
                                    if(ans.error){
                                        console.log("push notification error: ", ans.error)
                                    }
                    }
            }
            var approxExpire = new Date ();
            approxExpire.setUTCMinutes(approxExpire.getUTCMinutes()+10);
            var jsonData = JSON.stringify({
                    "appid" : appId,
                    "expire_on": approxExpire.toISOString(),
                    "token": app_settings.token,
                    "data": {
                            "notification": {
                                    "card": {
                                            "icon": 'info',
                                            "summary": title,
                                            "body": body,
                                            "popup": true,
                                            "persist": true
                                    },
                                    "vibrate": true,
                                    "sound": true
                            }
                    }
            })
            req.send(jsonData);
            console.log("AQJI",pushClient.token)
    }
}