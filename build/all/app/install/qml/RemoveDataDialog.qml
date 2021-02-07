import QtQuick 2.7
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import QtQuick.LocalStorage 2.0
import "./js/DataBase.js" as DataBase

Dialog {
    id: dataBaseEraserDialog
    text: "<b>"+i18n.tr("Do you want to erase all your data ?")

    Rectangle {
        id: rectangleDialog
        width: 180;
        height: 50
        Item{
            Column{
                spacing: units.gu(1)
                Row{
                    spacing: units.gu(8)
            
                    Button {
                        id: closeButton
                        text: i18n.tr("Close")
                        onClicked: PopupUtils.close(dataBaseEraserDialog)
                    }
                    Button {
                        id: importButton
                        text: "Delete"
                        color: UbuntuColors.orange
                        onClicked: {
                            var rowsDeleted = DataBase.deleteAllIngestions();
                            deleteOperationResult.text = i18n.tr("Done, succesfully removed "+rowsDeleted+" values")
                            deleteOperationResult.color = UbuntuColors.green
                        }
                    }
                }
                Row{
                    Label{
                        id: deleteOperationResult
                    }
                }
            }
        }
    }
}
