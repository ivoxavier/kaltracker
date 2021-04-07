import QtQuick 2.7
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3


Dialog {
    id: operationErrorDialog
    property string msg;
    property color  labelColor;
    title: i18n.tr("Operation Result")
    Label{
        text: i18n.tr(msg)
        color: labelColor
    }
    Button {
        text: "Close"
        onClicked:
           PopupUtils.close(operationErrorDialog)
    }
}
