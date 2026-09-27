/*
 * 2022-2026  Ivo Xavier
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 */

import QtQuick 2.9
import Lomiri.Components 1.3
import QtQuick.Layouts 1.3
import ChatSupport 0.1
import "../components"
import "../style"

Page {
    id: createAccountPage
    objectName: 'CreateAccountPage'

    header: PageHeader {
        id: header
        title: i18n.tr("Create Account")
    }

    BackgroundStyle {}

    ChatSupport {
        id: chat_support

        onCreateAccountResult: {
            if (success) {
                app_settings.chat_user_email = emailInput.text.trim().toLowerCase()
                pageStack.pop()
            } else {
                console.log("Err:", message)
                errorLabel.text = message
                errorLabel.visible = true
            }
        }
    }


    ColumnLayout {
        spacing: units.gu(2)
        anchors {
            margins: units.gu(4)
            top: header.bottom
            left: parent.left
            right: parent.right
        }
        
        Label {
            id: errorLabel
            Layout.fillWidth: true
            color: LomiriColors.red
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
            visible: false 
        }

        TextField {
            id: emailInput
            Layout.fillWidth: true
            placeholderText: i18n.tr("Email")
            inputMethodHints: Qt.ImhEmailCharactersOnly
        }

        TextField {
            id: usernameInput
            Layout.fillWidth: true
            placeholderText: i18n.tr("Username")
        }

        TextField {
            id: passwordInput
            Layout.fillWidth: true
            placeholderText: i18n.tr("Password")
            echoMode: TextInput.Password
        }

        Button {
            Layout.fillWidth: true
            Layout.topMargin: units.gu(1)
            text: i18n.tr("Register")
            color: theme.palette.normal.positive
            
            onClicked: {
                errorLabel.visible = false
                
                if (emailInput.text !== "" && usernameInput.text !== "" && passwordInput.text !== "") {
                    chat_support.createAccount(emailInput.text, usernameInput.text, passwordInput.text)
                } else {
                    errorLabel.text = i18n.tr("Please fill in all fields.")
                    errorLabel.visible = true
                }
            }
        }
    }
}