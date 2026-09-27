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
import Qt.labs.settings 1.0
import Lomiri.Components.ListItems 1.3 
import Lomiri.Components.Popups 1.3
import QtQuick.Controls.Suru 2.2
import ChatSupport 0.1
import "../components"
import "../style"

Page {
    id: manage_subscription_page
    objectName: 'ManageSubscriptionPage'

    property bool isLoggedIn: false
    property string currentUsername: ""
    property string currentEmail: ""
    property bool isSubscribed: false
    property bool isPaymentPending: false
    property string renewalDate: ""
    property string subscriptionPrice: chat_support.subscriptionPrice
    property bool isAuthenticating: false
    property string feedbackMessage: ""
    property bool feedbackIsError: false


    function getTranslatedMessage(code) {
        switch (code) {
        case "LOGIN_SUCCESS":
            return i18n.tr("Signed in successfully.")
        case "ACCOUNT_CREATED":
            return i18n.tr("Account created successfully.")
        case "ACCOUNT_DELETED":
            return i18n.tr("Your account has been permanently deleted.")
        case "INVALID_CREDENTIALS":
            return i18n.tr("Incorrect email or password. Please try again.")
        case "EMAIL_NOT_CONFIRMED":
            return i18n.tr("Please confirm your email address before signing in.")
        case "EMAIL_ALREADY_EXISTS":
            return i18n.tr("An account with this email already exists.")
        case "WEAK_PASSWORD":
            return i18n.tr("Password is too weak. Please use at least 6 characters.")
        case "NETWORK_ERROR":
            return i18n.tr("No internet connection. Please check your network and try again.")
        case "CONFIG_ERROR":
        case "SERVER_ERROR":
        case "DELETE_FAILED":
        default:
            return i18n.tr("Service temporarily unavailable. Please try again later.")
        }
    }



    header: PageHeader {
        title: i18n.tr("Chat Support")
        trailingActionBar.actions: [
            Action {
                iconName: "reload"
                text: i18n.tr("Refresh Status")
                visible: isLoggedIn
                onTriggered: {
                    chat_support.verifySession()
                    chat_support.fetchSubscriptionPrice()
                }
            }
        ]
    }

    BackgroundStyle {}

    ChatSupport {
        id: chat_support

        onLoginResult: {
            manage_subscription_page.isAuthenticating = false
            manage_subscription_page.feedbackIsError = !success
            manage_subscription_page.feedbackMessage = getTranslatedMessage(message)
        }

        onDeleteAccountResult: {
            manage_subscription_page.isAuthenticating = false
            manage_subscription_page.feedbackIsError = !success
            manage_subscription_page.feedbackMessage = getTranslatedMessage(message)
            if (success) {
                app_settings.is_chat_support_enabled = false
            }
        }

        onSessionChanged: {
            manage_subscription_page.isLoggedIn = chat_support.isAuthenticated
            manage_subscription_page.currentUsername = chat_support.currentUsername !== "" ? chat_support.currentUsername : chat_support.currentEmail
            manage_subscription_page.currentEmail = chat_support.currentEmail
            manage_subscription_page.isSubscribed = chat_support.isSubscribed
            manage_subscription_page.isPaymentPending = chat_support.isPaymentPending
            manage_subscription_page.renewalDate = chat_support.renewalDate

            if (!manage_subscription_page.isSubscribed) {
                app_settings.is_chat_support_enabled = false
            }
        }
    }

    onVisibleChanged: {
        if (visible) {
            chat_support.verifySession()
            chat_support.fetchSubscriptionPrice()
        }
    }

    Component {
        id: loginDialogComponent
        Dialog {
            id: loginDialog
            title: i18n.tr("Sign In")

            TextField {
                id: loginEmail
                placeholderText: i18n.tr("Email")
                inputMethodHints: Qt.ImhEmailCharactersOnly
            }

            TextField {
                id: loginPassword
                placeholderText: i18n.tr("Password")
                echoMode: TextInput.Password
            }

            Button {
                text: i18n.tr("Login")
                color: theme.palette.normal.focus
                onClicked: {
                    manage_subscription_page.feedbackMessage = ""
                    manage_subscription_page.isAuthenticating = true
                    chat_support.login(loginEmail.text.trim(), loginPassword.text)
                    PopupUtils.close(loginDialog)
                }
            }

            Button {
                text: i18n.tr("Cancel")
                onClicked: PopupUtils.close(loginDialog)
            }
        }
    }


    Component {
        id: deleteAccountDialogComponent
        Dialog {
            id: deleteDialog
            title: i18n.tr("Delete Account")
            text: i18n.tr("Are you sure you want to permanently delete your account and all chat history? This action cannot be undone.")

            Button {
                text: i18n.tr("Delete Permanently")
                color: theme.palette.normal.negative
                onClicked: {
                    chat_support.deleteAccount()
                    PopupUtils.close(deleteDialog)
                }
            }

            Button {
                text: i18n.tr("Cancel")
                onClicked: PopupUtils.close(deleteDialog)
            }
        }
    }


    Component {
        id: paymentDialogComponent
        Dialog {
            id: paymentDialog
            title: i18n.tr("Payment Instructions")
            text: i18n.tr("To activate your monthly Chat Support subscription (%1 / month), please complete the payment using the details below:").arg(manage_subscription_page.subscriptionPrice)

            LomiriShape {
                width: parent.width
                height: instructionsCol.height + units.gu(3)
                aspect: LomiriShape.Flat
                backgroundColor: theme.palette.normal.background

                Column {
                    id: instructionsCol
                    anchors {
                        top: parent.top
                        left: parent.left
                        right: parent.right
                        margins: units.gu(1.5)
                    }
                    spacing: units.gu(1)

                    Label {
                        width: parent.width
                        wrapMode: Text.WordWrap
                        font.weight: Font.DemiBold
                        text: i18n.tr("1. Send %1 via PayPal.").arg(manage_subscription_page.subscriptionPrice)
                    }

                    Label {
                        width: parent.width
                        wrapMode: Text.WordWrap
                        fontSize: "small"
                        text: i18n.tr("2. IMPORTANT: Include your account email (%1) in the payment note so we can identify your account.").arg(manage_subscription_page.currentEmail)
                    }

                    Label {
                        width: parent.width
                        wrapMode: Text.WordWrap
                        fontSize: "small"
                        color: theme.palette.normal.backgroundSecondaryText
                        text: i18n.tr("3. Click the button below after completing the transfer. Your subscription will be activated as soon as we verify the payment.")
                    }
                }
            }

            Button {
                text: i18n.tr("Open PayPal (%1)").arg(manage_subscription_page.subscriptionPrice)
                color: theme.palette.normal.focus
                enabled: chat_support.paypalPaymentUrl !== ""
                onClicked: {
                    Qt.openUrlExternally(chat_support.paypalPaymentUrl)
                }
            }

            Button {
                text: i18n.tr("I Have Made the Payment")
                color: theme.palette.normal.positive
                onClicked: {
                    chat_support.requestPaymentVerification()
                    PopupUtils.close(paymentDialog)
                }
            }

            Button {
                text: i18n.tr("Cancel")
                onClicked: PopupUtils.close(paymentDialog)
            }
        }
    }

    Flickable {
        anchors {
            top: parent.header.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        contentWidth: parent.width
        contentHeight: main_column.height + units.gu(4)
        clip: true

        ColumnLayout {
            id: main_column
            width: parent.width
            spacing: units.gu(1)

    
            RowLayout {
                Layout.fillWidth: true
                Layout.margins: units.gu(2)
                visible: isAuthenticating
                spacing: units.gu(1.5)

                ActivityIndicator {
                    running: isAuthenticating
                }
                Label {
                    text: i18n.tr("Signing in, please wait...")
                    color: app_style.label.labelColor
                }
            }

            
            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: feedback_card.height
                Layout.leftMargin: units.gu(2)
                Layout.rightMargin: units.gu(2)
                Layout.topMargin: units.gu(1)
                visible: feedbackMessage !== ""

                LomiriShape {
                    id: feedback_card
                    width: parent.width
                    height: feedback_row.height + units.gu(3)
                    aspect: LomiriShape.Flat
                    backgroundColor: feedbackIsError ? theme.palette.normal.negative : theme.palette.normal.positive

                    RowLayout {
                        id: feedback_row
                        anchors {
                            top: parent.top
                            left: parent.left
                            right: parent.right
                            margins: units.gu(1.5)
                        }
                        spacing: units.gu(1)

                        Icon {
                            name: feedbackIsError ? "dialog-warning-symbolic" : "tick"
                            width: units.gu(3)
                            height: units.gu(3)
                            color: "white"
                        }

                        Label {
                            text: feedbackMessage
                            color: "white"
                            wrapMode: Text.WordWrap
                            Layout.fillWidth: true
                            fontSize: "small"
                        }

                        Icon {
                            name: "close"
                            width: units.gu(2.5)
                            height: units.gu(2.5)
                            color: "white"
                            MouseArea {
                                anchors.fill: parent
                                onClicked: feedbackMessage = ""
                            }
                        }
                    }
                }
            }























            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: status_card.height
                Layout.margins: units.gu(2)

                LomiriShape {
                    id: status_card
                    width: parent.width
                    height: card_layout.height + units.gu(4)
                    aspect: LomiriShape.Flat
                    backgroundColor: {
                        if (isSubscribed) return theme.palette.normal.positive
                        if (isPaymentPending) return LomiriColors.orange
                        return theme.palette.normal.foreground
                    }

                    ColumnLayout {
                        id: card_layout
                        anchors {
                            top: parent.top
                            left: parent.left
                            right: parent.right
                            margins: units.gu(2)
                        }
                        spacing: units.gu(1.5)

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: units.gu(1.5)

                            Icon {
                                source: "../../assets/chat-support_icon.svg"
                                width: units.gu(4)
                                height: units.gu(4)
                                color: (isSubscribed || isPaymentPending) ? "white" : app_style.label.labelColor
                            }

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: units.gu(0.5)

                                Label {
                                    text: isLoggedIn ? currentUsername : i18n.tr("KalTracker Team")
                                    fontSize: "large"
                                    font.weight: Font.Bold
                                    color: (isSubscribed || isPaymentPending) ? "white" : app_style.label.labelColor
                                }

                                Label {
                                    text: {
                                        if (!isLoggedIn) return i18n.tr("Step 1: Account Required")
                                        if (isSubscribed) return i18n.tr("Monthly Subscription Active")
                                        if (isPaymentPending) return i18n.tr("Step 2: Verification Pending")
                                        return i18n.tr("Step 2: Payment Required (%1 / month)").arg(subscriptionPrice)
                                    }
                                    fontSize: "small"
                                    color: (isSubscribed || isPaymentPending) ? "white" : theme.palette.normal.backgroundSecondaryText
                                }
                            }
                        }

                        Label {
                            text: {
                                if (!isLoggedIn) return i18n.tr("Create an account or sign in to subscribe to Chat Support (%1 / month).").arg(subscriptionPrice)
                                if (isSubscribed) return i18n.tr("Monthly renewal date: %1").arg(renewalDate)
                                if (isPaymentPending) return i18n.tr("We are verifying your payment. Your subscription will be unlocked shortly.")
                                return i18n.tr("Complete your monthly subscription payment (%1) to unlock direct chat with our team.").arg(subscriptionPrice)
                            }
                            wrapMode: Text.WordWrap
                            Layout.fillWidth: true
                            color: (isSubscribed || isPaymentPending) ? "white" : theme.palette.normal.backgroundSecondaryText
                        }
                    }
                }
            }


            ListItemHeader {
                text_header.title.text: i18n.tr("1. Account")
                divider.visible: false
            }

            ListItem {
                divider.visible: false
                visible: !isLoggedIn
                ListItemLayout {
                    title.text: i18n.tr("Create Account")
                    title.color: app_style.label.labelColor
                    subtitle.text: i18n.tr("Register a new account for Chat Support")
                    Icon {
                        SlotsLayout.position: SlotsLayout.Leading
                        name: "contact-new"
                        height: units.gu(3.5)
                    }
                    ProgressionSlot {}
                }
                onClicked: {
                    page_stack.push(create_account_page)
                }
            }

            ListItem {
                divider.visible: false
                visible: !isLoggedIn
                ListItemLayout {
                    title.text: i18n.tr("Already have an account?")
                    title.color: app_style.label.labelColor
                    subtitle.text: i18n.tr("Sign in to check your subscription")
                    Icon {
                        SlotsLayout.position: SlotsLayout.Leading
                        name: "contact"
                        height: units.gu(3.5)
                    }
                    ProgressionSlot {}
                }
                onClicked: PopupUtils.open(loginDialogComponent)
            }

            ListItem {
                divider.visible: false
                visible: isLoggedIn
                ListItemLayout {
                    title.text: currentUsername
                    title.color: app_style.label.labelColor
                    subtitle.text: currentEmail
                    Icon {
                        SlotsLayout.position: SlotsLayout.Leading
                        name: "contact"
                        height: units.gu(3.5)
                    }
                    Button {
                        SlotsLayout.position: SlotsLayout.Trailing
                        text: i18n.tr("Logout")
                        onClicked: {
                            chat_support.logout()
                            app_settings.is_chat_support_enabled = false
                        }
                    }
                }
            }


            ListItem {
                divider.visible: false
                visible: isLoggedIn
                ListItemLayout {
                    title.text: i18n.tr("Delete Account")
                    title.color: theme.palette.normal.negative
                    subtitle.text: i18n.tr("Permanently remove your account and chat history")
                    Icon {
                        SlotsLayout.position: SlotsLayout.Leading
                        name: "delete"
                        color: theme.palette.normal.negative
                        height: units.gu(3.5)
                    }
                    ProgressionSlot {}
                }
                onClicked: PopupUtils.open(deleteAccountDialogComponent)
            }

    
            ListItemHeader {
                text_header.title.text: i18n.tr("2. Subscription & Payment")
                divider.visible: false
            }

            Column {
                Layout.fillWidth: true
                Layout.leftMargin: units.gu(2)
                Layout.rightMargin: units.gu(2)
                spacing: units.gu(1.5)

                Button {
                    width: parent.width
                    enabled: isLoggedIn && !isSubscribed && !isPaymentPending
                    text: {
                        if (isSubscribed) return i18n.tr("Subscription Active")
                        if (isPaymentPending) return i18n.tr("Awaiting Payment Approval...")
                        return i18n.tr("Subscribe (%1 / month)").arg(subscriptionPrice)
                    }
                    color: {
                        if (isSubscribed) return theme.palette.normal.positive
                        if (isPaymentPending) return LomiriColors.orange
                        return theme.palette.normal.focus
                    }
                    onClicked: {
                        PopupUtils.open(paymentDialogComponent)
                    }
                }
            }

        
            ListItemHeader {
                text_header.title.text: i18n.tr("3. Service Status")
                divider.visible: false
            }

            ListItem {
                divider.visible: false
                enabled: isLoggedIn && isSubscribed
                ListItemLayout {
                    title.text: i18n.tr("KalTracker Team")
                    title.color: app_style.label.labelColor
                    subtitle.text: (isLoggedIn && isSubscribed)
                        ? i18n.tr("Talk To Our Team")
                        : i18n.tr("Requires account and active subscription")

                    Icon {
                        SlotsLayout.position: SlotsLayout.Leading
                        source: "../../assets/chat-support_icon.svg"
                        height: units.gu(3.5)
                        opacity: (isLoggedIn && isSubscribed) ? 1.0 : 0.4
                    }

                    Switch {
                        checked: app_settings.is_chat_support_enabled
                        onClicked: app_settings.is_chat_support_enabled = !app_settings.is_chat_support_enabled
                    }
                }
            }
        }
    }
}