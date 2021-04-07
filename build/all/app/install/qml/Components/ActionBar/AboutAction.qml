import QtQuick 2.9
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3


Action{
        id: infoApp
        iconName: "info"
        text: i18n.tr("About")
        onTriggered: PopupUtils.open(aboutDialog)
}

