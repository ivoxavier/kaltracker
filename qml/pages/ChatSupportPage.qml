/*
 * 2022-2026  Ivo Xavier
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 */

import QtQuick 2.9
import QtQuick.Layouts 1.3
import Lomiri.Components 1.3
import Lomiri.Components.Popups 1.3
import Lomiri.Components.Pickers 1.3
import Lomiri.Components.ListItems 1.3
import QtQuick.LocalStorage 2.12
import QtQuick.Controls.Suru 2.2
import "../components"
import "../style"
import ChatSupport 0.1
import InternetChecker 0.1

Page {
    id: chat_support
    objectName: 'ChatSupport'

    // Se vier da AdminChatsPage usa o email passado; se vier do KalTracker usa o email guardado nas settings
    property string targetUserEmail: app_settings.chat_user_email || ""
    property string myEmail: app_settings.chat_user_email || ""
    property string pendingUserMessage: ""

    header: PageHeader {
        title: i18n.tr("Chat Support")
        trailingActionBar.actions: [
            Action {
                iconName: "reload"
                text: i18n.tr("Refresh")
                onTriggered: supabaseBackend.fetchMessages(targetUserEmail)
            }
        ]
    }

    BackgroundStyle {}

    ListModel {
        id: chatModel
    }

    ChatSupport {
        id: supabaseBackend

        onMessagesLoaded: {
            chatModel.clear()
            for (var i = 0; i < messages.length; i++) {
                var msg = messages[i]
                chatModel.append({
                    "role": (msg.sender_email === myEmail) ? "user" : "agent",
                    "text": msg.message || ""
                })
            }
        }

        onMessageSent: {
            if (!success) {
                chatModel.append({
                    "role": "agent",
                    "text": i18n.tr("Error: Could not send message.")
                })
            }
        }
    }

    InternetChecker {
        id: internetChecker
        onInternetStatusChanged: {
            if (isConnected) {
                if (pendingUserMessage !== "") {
                    supabaseBackend.sendMessage(targetUserEmail, myEmail, pendingUserMessage)
                    pendingUserMessage = ""
                }
            } else {
                chatModel.append({
                    "role": "agent",
                    "text": i18n.tr("Error: No internet connection. Please check your network and try again.")
                })
                pendingUserMessage = ""
            }
        }
    }

    // Atualiza as mensagens a cada 5 segundos enquanto a página está visível
    Timer {
        interval: 5000
        running: chat_support.visible && targetUserEmail !== ""
        repeat: true
        onTriggered: supabaseBackend.fetchMessages(targetUserEmail)
    }

    Component.onCompleted: {
        if (targetUserEmail !== "") {
            supabaseBackend.fetchMessages(targetUserEmail)
        }
    }

    function sendMessage() {
        if (messageInput.text.trim() === "") return

        pendingUserMessage = messageInput.text.trim()
        chatModel.append({"role": "user", "text": pendingUserMessage})
        messageInput.text = ""
        internetChecker.checkInternetConnection()
    }

    ColumnLayout {
        anchors.top: parent.header.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        spacing: 0

        ListView {
            id: chatView
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.margins: units.gu(2)
            model: chatModel
            spacing: units.gu(2)
            clip: true
            
            onCountChanged: {
                chatView.positionViewAtEnd()
            }

            delegate: Item {
                width: chatView.width
                height: bubble.height

                Rectangle {
                    id: bubble
                    width: msgText.width + units.gu(4)
                    height: msgText.height + units.gu(2)
                    radius: units.gu(1.5)
                    color: model.role === "user" ? theme.palette.normal.focus : Qt.rgba(0.5, 0.5, 0.5, 0.2)
                    anchors.right: model.role === "user" ? parent.right : undefined
                    anchors.left: model.role !== "user" ? parent.left : undefined

                    Label {
                        id: msgText
                        text: model.text
                        wrapMode: Text.Wrap
                        width: Math.min(implicitWidth, chatView.width * 0.8 - units.gu(4))
                        anchors.centerIn: parent
                        color: model.role === "user" ? "white" : theme.palette.normal.baseText
                    }
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            height: inputLayout.height + units.gu(2)
            color: theme.palette.normal.background

            RowLayout {
                id: inputLayout
                anchors.centerIn: parent
                width: parent.width - units.gu(4)
                spacing: units.gu(2)

                TextField {
                    id: messageInput
                    Layout.fillWidth: true
                    placeholderText: i18n.tr("Write a message...")
                    onAccepted: sendMessage()
                }
                Button {
                    text: i18n.tr("Send")
                    color: theme.palette.normal.focus
                    onClicked: sendMessage()
                }
            }
        }
    }
}