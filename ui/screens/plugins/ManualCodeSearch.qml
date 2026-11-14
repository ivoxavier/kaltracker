/*
 * 2022-2026  Ivo Xavier
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 * ...
 */


import QtQuick 2.9
import Lomiri.Components 1.3
import QtQuick.Layouts 1.3
import "../components"
import "../theme"

Item {
    id: manualSearchPage

    ColumnLayout {
        anchors.centerIn: parent
        width: parent.width - units.gu(6)
        spacing: units.gu(2)

        Icon {
            name: "edit" 
            Layout.preferredWidth: units.gu(8)
            Layout.preferredHeight: units.gu(8)
            color: LomiriColors.ash
            Layout.alignment: Qt.AlignHCenter
        }

        Label {
            text: i18n.tr("Manual Entry")
            font.pixelSize: units.gu(3)
            font.weight: Font.Light
            color: app_style.label.labelColor
            Layout.alignment: Qt.AlignHCenter
        }

        Label {
            text: i18n.tr("Type the numbers located under the barcode")
            font.pixelSize: units.gu(1.5)
            color: LomiriColors.ash
            Layout.alignment: Qt.AlignHCenter
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            Layout.bottomMargin: units.gu(2)
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: units.gu(1)
            
            LomiriShape {  
                Layout.fillWidth: true
                Layout.preferredHeight: units.gu(5)
                radius: "large"
                aspect: LomiriShape.Inset
                backgroundColor: app_style.shape.textInput.shapeColor
            
                TextField {
                    id: barcodeInput
                    anchors.fill: parent
                    horizontalAlignment: TextField.AlignHCenter
                    verticalAlignment: TextField.AlignVCenter
                    inputMethodHints: Qt.ImhDigitsOnly
                    color : app_style.label.labelColor 
                    placeholderText: i18n.tr("e.g. 5601234567890")
                    
                    onAccepted: {
                        if (barcodeInput.text.length > 0) {
                            scan_page.processBarcode(barcodeInput.text);
                        }
                    }
                }
            }

            Button {
                Layout.preferredWidth: units.gu(7)
                Layout.preferredHeight: units.gu(5)
                Layout.alignment: Qt.AlignCenter
                iconName: "find"
                enabled: barcodeInput.text.length > 0 
                color: enabled ? LomiriColors.green : app_style.button.actionButton.buttonColor
                onClicked: {
                    scan_page.processBarcode(barcodeInput.text);
                }
            }
        }
    }
}