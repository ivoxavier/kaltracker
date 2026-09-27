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
import "../style"

Page {
    id: adminChatsPage
    objectName: 'AdminChatsPage'


    property string adminEmail: chat_support.currentEmail
    property var chatListModel: []
    property bool isLoading: false

    header: PageHeader {
        id: header
        title: i18n.tr("Support Chats")
        trailingActionBar.actions: [
            Action {
                iconName: "reload"
                text: i18n.tr("Refresh")
                onTriggered: {
                    isLoading = true
                    chat_support.verifySession()
                    chat_support.fetchAdminChatList()
                }
            }
        ]
    }

    BackgroundStyle {}

    ChatSupport {
        id: chat_support

        onAdminChatListLoaded: {
            isLoading = false
            chatListModel = chats
        }
    }

    Component.onCompleted: {
        isLoading = true
        chat_support.verifySession()
        chat_support.fetchAdminChatList()
    }

    ActivityIndicator {
        anchors.centerIn: parent
        running: isLoading && chatListModel.length === 0
        visible: running
    }

    Label {
        anchors.centerIn: parent
        visible: !isLoading && chatListModel.length === 0
        text: i18n.tr("No active user chats found.")
        color: theme.palette.normal.backgroundSecondaryText
    }

    ListView {
        id: chatsListView
        anchors {
            top: header.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        clip: true
        model: chatListModel

        delegate: ListItem {
            height: layout.height + (divider.visible ? divider.height : 0)
            
            ListItemLayout {
                id: layout
                
        
                title.text: (modelData.username || i18n.tr("User")) + " (" + modelData.user_email + ")"
                title.font.weight: Font.DemiBold
                subtitle.text: {
                    if (!modelData.last_message) return i18n.tr("No messages yet")
                    var prefix = (adminEmail !== "" && modelData.last_sender === adminEmail) ? i18n.tr("You: ") : ""
                    return prefix + modelData.last_message
                }

                Icon {
                    SlotsLayout.position: SlotsLayout.Leading
                    name: "contact"
                    height: units.gu(4)
                    width: units.gu(4)
                    color: modelData.is_subscribed ? theme.palette.normal.positive : theme.palette.normal.backgroundSecondaryText
                }

                Label {
                    SlotsLayout.position: SlotsLayout.Trailing
                    text: modelData.is_subscribed ? i18n.tr("PRO") : i18n.tr("FREE")
                    fontSize: "x-small"
                    font.weight: Font.Bold
                    color: modelData.is_subscribed ? theme.palette.normal.positive : theme.palette.normal.backgroundSecondaryText
                }

                ProgressionSlot {}
            }

            onClicked: {
                page_stack.push(chat_room_page, {
                    "targetUserEmail": modelData.user_email,
                    "targetUsername": modelData.username || modelData.user_email,
                    "myEmail": adminEmail
                })
            }
        }
    }
}