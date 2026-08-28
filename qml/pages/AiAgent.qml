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
import "../logicalFields"
import "../../js/GetData.js" as GetData
import "../../js/UserTable.js" as UserData
import AiAgents 0.1
import InternetChecker 0.1

Page {
    id: ai_agent
    objectName: 'AiAgent'

    header: PageHeader {
        title: i18n.tr("Your Agent")
    }

    ListModel {id: chatModel}

    property string systemContextPrompt: ""
    property string pendingUserMessage: ""

    InternetChecker {
        id: internetChecker
        onInternetStatusChanged: {
            if (isConnected) {
                var activeProvider = "gemini";
                var apiKey = app_settings.agent_gemini_key; 
                var modelName = app_settings.agent_gemini_model;
                aiBackend.sendMessage(activeProvider, apiKey, modelName, systemContextPrompt, pendingUserMessage);
                pendingUserMessage = "";
            } else {
                if (chatModel.get(chatModel.count - 1).role === "agent_loading") {
                    chatModel.remove(chatModel.count - 1);
                }
                chatModel.append({"role": "agent", "text": i18n.tr("Error: No internet connection. Please check your network and try again.")});
                pendingUserMessage = "";
            }
        }
    }

    AskYourAgent {
        id: aiBackend
        onResponseReceived: function(response) {
            if (chatModel.get(chatModel.count - 1).role === "agent_loading") {
                chatModel.remove(chatModel.count - 1);
            }
            chatModel.append({"role": "agent", "text": response});
        }
        onErrorOccurred: function(error) {
            if (chatModel.get(chatModel.count - 1).role === "agent_loading") {
                chatModel.remove(chatModel.count - 1);
            }
            chatModel.append({"role": "agent", "text": i18n.tr("Error: ") + error});
        }
    }

    Component.onCompleted: {
        buildSystemContext();
        chatModel.append({"role": "agent", "text": i18n.tr("Hello! I have analyzed your health and nutrition data. What would you like to know today?")});
    }

    function buildSystemContext() {
        var sex = UserData.getSexAtBirth() == "0" ? "M" : "W";
        var age = UserData.getAge();
        var goal = UserData.getGoal();
        var weight = UserData.getWeight();
        var height = UserData.getHeight();
        var activity = UserData.getActivity() == "0" ? "Very Light" :  UserData.getActivity() == "1" ?
        "Light" :  UserData.getActivity() == "2" ? "Moderate" : "Heavy";
        var ap_hi = UserData.getApHi();
        var ap_lo = UserData.getApLo();
        var weightHistory = GetData.getWeightTracker();

        systemContextPrompt = "You are a health and nutrition AI assistant inside the Kaltracker app. " +
                      "Here is the user's current data context:\n" +
                      "- Sex: " + sex + "\n" +
                      "- Age: " + age + " years\n" +
                      "- Height: " + height + " cm\n" +
                      "- Current Weight: " + weight + " kg\n" +
                      "- Activity Level: " + activity + "\n" +
                      "- Target Daily Calories: " + goal + " kcal\n" +
                      "- Blood Pressure (Sys/Dia): " + ap_hi + "/" + ap_lo + "\n" +
                      "- Weight History over time (kg): " + weightHistory.join(", ") + "\n\n" +
                      "Answer the user's questions taking these metrics into account. Keep answers concise and helpful.";
    }

    function sendMessage() {
        if (messageInput.text.trim() === "") return;

        pendingUserMessage = messageInput.text;
        chatModel.append({"role": "user", "text": pendingUserMessage});
        messageInput.text = "";
        chatModel.append({"role": "agent_loading", "text": i18n.tr("Thinking...")});
        internetChecker.checkInternetConnection();
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
                chatView.positionViewAtEnd();
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
                    anchors.left: (model.role === "agent" || model.role === "agent_loading") ? parent.left : undefined

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
                    placeholderText: i18n.tr("Ask a question...")
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