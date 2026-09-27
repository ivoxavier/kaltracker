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

Page {
    id: chatRoomPage
    objectName: 'ChatRoomPage'

    // Propriedades passadas ao abrir a página
    property string targetUserEmail: ""   // Sempre o email do cliente (dono da conversa)
    property string targetUsername: i18n.tr("KalTracker Team") // Nome a mostrar no topo
    property string myEmail: ""           // Email de quem está a usar a app (cliente ou admin)

    property var messagesModel: []

    header: PageHeader {
        id: header
        title: targetUsername
        subtitle: targetUserEmail
        trailingActionBar.actions: [
            Action {
                iconName: "reload"
                text: i18n.tr("Refresh")
                onTriggered: chat_support.fetchMessages(targetUserEmail)
            }
        ]
    }

    ChatSupport {
        id: chat_support

        onMessagesLoaded: {
            var previousCount = messagesModel.length
            messagesModel = messages
            
            // Faz scroll para a última mensagem se chegaram mensagens novas
            if (messages.length > previousCount) {
                Qt.callLater(function() {
                    messagesListView.positionViewAtEnd()
                })
            }
        }

        onMessageSent: {
            sendButton.enabled = true
            if (success) {
                messageInput.text = ""
            }
        }
    }

    // Atualiza a conversa automaticamente a cada 5 segundos
    Timer {
        id: pollTimer
        interval: 5000
        running: chatRoomPage.visible && targetUserEmail !== ""
        repeat: true
        onTriggered: chat_support.fetchMessages(targetUserEmail)
    }

    Component.onCompleted: {
        if (targetUserEmail !== "") {
            chat_support.fetchMessages(targetUserEmail)
        }
    }

    // Lista de Mensagens (Balões de Chat)
    ListView {
        id: messagesListView
        anchors {
            top: header.bottom
            left: parent.left
            right: parent.right
            bottom: inputBar.top
            margins: units.gu(1.5)
        }
        spacing: units.gu(1.2)
        clip: true
        model: messagesModel

        delegate: Item {
            width: messagesListView.width
            height: bubble.height

            // Verifica se a mensagem foi enviada por quem tem sessão iniciada
            property bool isMe: modelData.sender_email === myEmail

            LomiriShape {
                id: bubble
                width: Math.min(msgColumn.implicitWidth + units.gu(3), messagesListView.width * 0.78)
                height: msgColumn.implicitHeight + units.gu(2)
                aspect: LomiriShape.Flat
                
                anchors.right: isMe ? parent.right : undefined
                anchors.left: isMe ? undefined : parent.left

                backgroundColor: isMe ? theme.palette.normal.focus : theme.palette.normal.foreground

                Column {
                    id: msgColumn
                    anchors {
                        fill: parent
                        margins: units.gu(1)
                    }
                    spacing: units.gu(0.5)

                    Label {
                        width: parent.width
                        text: modelData.message || ""
                        wrapMode: Text.WordWrap
                        color: isMe ? "white" : theme.palette.normal.backgroundText
                    }

                    Label {
                        anchors.right: parent.right
                        // Formata a hora a partir do created_at do Supabase (HH:mm)
                        text: modelData.created_at ? Qt.formatTime(new Date(modelData.created_at), "hh:mm") : ""
                        fontSize: "xx-small"
                        color: isMe ? "#E0E0E0" : theme.palette.normal.backgroundSecondaryText
                    }
                }
            }
        }
    }

    // Barra inferior para escrever e enviar mensagem
    Rectangle {
        id: inputBar
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        height: units.gu(7)
        color: theme.palette.normal.background

        // Linha divisória subtil no topo da barra
        Rectangle {
            anchors.top: parent.top
            width: parent.width
            height: units.dp(1)
            color: theme.palette.normal.base
        }

        RowLayout {
            anchors {
                fill: parent
                leftMargin: units.gu(1.5)
                rightMargin: units.gu(1.5)
            }
            spacing: units.gu(1)

            TextField {
                id: messageInput
                Layout.fillWidth: true
                placeholderText: i18n.tr("Write a message...")
                onAccepted: sendButton.clicked()
            }

            Button {
                id: sendButton
                text: i18n.tr("Send")
                color: theme.palette.normal.positive
                enabled: messageInput.text.trim() !== ""
                onClicked: {
                    var cleanText = messageInput.text.trim()
                    if (cleanText !== "") {
                        sendButton.enabled = false
                        chat_support.sendMessage(targetUserEmail, myEmail, cleanText)
                    }
                }
            }
        }
    }
}