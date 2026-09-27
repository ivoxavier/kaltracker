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

    property bool isSubmitting: false
    property bool isSuccess: false
    property string statusMessage: ""

    function getTranslatedMessage(code) {
        switch (code) {
        case "ACCOUNT_CREATED":
            return i18n.tr("Account created successfully.")
        case "EMAIL_ALREADY_EXISTS":
            return i18n.tr("An account with this email already exists.")
        case "WEAK_PASSWORD":
            return i18n.tr("Password is too weak. Please use at least 6 characters.")
        case "NETWORK_ERROR":
            return i18n.tr("No internet connection. Please check your network and try again.")
        case "REGISTRATION_FAILED":
            return i18n.tr("Could not create account. Please verify your details and try again.")
        case "CONFIG_ERROR":
        case "SERVER_ERROR":
        default:
            return i18n.tr("Service temporarily unavailable. Please try again later.")
        }
    }

    header: PageHeader {
        id: header
        title: i18n.tr("Create Account")
    }

    BackgroundStyle {}

    Timer {
        id: successPopTimer
        interval: 1200
        repeat: false
        onTriggered: page_stack.pop()
    }

    ChatSupport {
        id: chat_support

        onCreateAccountResult: {
            createAccountPage.isSubmitting = false
            createAccountPage.isSuccess = success
            createAccountPage.statusMessage = getTranslatedMessage(message)

            if (success) {
                successPopTimer.start()
            } else {
                console.log("CreateAccount Error Code:", message)
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
        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: feedback_card.height
            visible: statusMessage !== ""

            LomiriShape {
                id: feedback_card
                width: parent.width
                height: feedback_row.height + units.gu(3)
                aspect: LomiriShape.Flat
                backgroundColor: isSuccess ? theme.palette.normal.positive : theme.palette.normal.negative

                Behavior on opacity {
                    LomiriNumberAnimation { duration: LomiriAnimation.FastDuration }
                }

                RowLayout {
                    id: feedback_row
                    anchors {
                        top: parent.top
                        left: parent.left
                        right: parent.right
                        margins: units.gu(1.5)
                    }
                    spacing: units.gu(1.5)

                    Icon {
                        name: isSuccess ? "tick" : "dialog-warning-symbolic"
                        width: units.gu(3)
                        height: units.gu(3)
                        color: "white"
                    }

                    Label {
                        text: statusMessage
                        color: "white"
                        wrapMode: Text.WordWrap
                        Layout.fillWidth: true
                        fontSize: "small"
                    }
                }
            }
        }

        TextField {
            id: emailInput
            Layout.fillWidth: true
            enabled: !isSubmitting && !isSuccess
            placeholderText: i18n.tr("Email")
            inputMethodHints: Qt.ImhEmailCharactersOnly
        }

        TextField {
            id: usernameInput
            Layout.fillWidth: true
            enabled: !isSubmitting && !isSuccess
            placeholderText: i18n.tr("Username")
        }

        TextField {
            id: passwordInput
            Layout.fillWidth: true
            enabled: !isSubmitting && !isSuccess
            placeholderText: i18n.tr("Password")
            echoMode: TextInput.Password
        }

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: units.gu(1)
            visible: isSubmitting
            spacing: units.gu(1.5)

            ActivityIndicator {
                running: isSubmitting
            }

            Label {
                text: i18n.tr("Creating your account...")
                color: app_style.label.labelColor
            }
        }

        Button {
            Layout.fillWidth: true
            Layout.topMargin: units.gu(1)
            enabled: !isSubmitting && !isSuccess
            text: isSubmitting ? i18n.tr("Please wait...") : i18n.tr("Register")
            color: theme.palette.normal.positive

            onClicked: {
                Qt.inputMethod.hide()
                statusMessage = ""
                isSuccess = false

                var email = emailInput.text.trim().toLowerCase()
                var username = usernameInput.text.trim()
                var password = passwordInput.text

                if (email !== "" && username !== "" && password !== "") {
                    isSubmitting = true
                    chat_support.createAccount(email, username, password)
                } else {
                    statusMessage = i18n.tr("Please fill in all fields.")
                }
            }
        }
    }
}