import QtQuick 2.9
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3

Dialog {
       id: aboutProductDialogue
       title: i18n.tr("About")
       text: "KalTracker version: "+root.appVersion+"<br/>Stores your food and drink ingestion<br/><br/>Ivo Xavier 2020-2021©"

       Button {
           text: "Back"
           onClicked: PopupUtils.close(aboutProductDialogue)
       }
}
