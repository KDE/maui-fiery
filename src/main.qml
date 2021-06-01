import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.3
import org.kde.kirigami 2.7 as Kirigami
import org.mauikit.controls 1.2 as Maui

import "views/browser"

Maui.ApplicationWindow
{
    id: root
    title: _browserView.currentTab.title
    autoHideHeader: false

    readonly property var views : ({browser: 0, tabs: 1, history: 2})

readonly property bool entryFocused : !root.isWide && _entryField.activeFocus

    headBar.leftContent:  Maui.ToolActions
    {
        expanded: root.isWide
        autoExclusive: false
        checkable: false
        visible: !entryFocused
        defaultIconName: "go-previous"

        Action
        {
            text: i18n("Previous")
            icon.name: "go-previous"
        }

        Action
        {
            text: i18n("Next")
            icon.name: "go-next"
        }
    }

    Component
    {
        id: _entryFieldComponent
        Maui.TextField
        {
            placeholderText: i18n("Search or enter URL")
            text: _browserView.currentTab.url
            onAccepted: _browserView.openUrl(text)
        }
    }

//    page.showTitle: !root.isWide
//    page.title: root.title
    footBar.visible: _swipeView.currentIndex !== views.browser
//    footBar.middleContent: Loader
//    {
//        visible: active
//        active: !root.isWide
//        Layout.fillWidth: true
//        sourceComponent: _entryFieldComponent
//    }

    headBar.middleContent: Maui.TextField
    {
        id: _entryField
        Layout.fillWidth: true
        Layout.maximumWidth: 500
        placeholderText: i18n("Search or enter URL")
        text: _browserView.currentTab.url
        onAccepted: _browserView.openUrl(text)

        actions: Action
        {
            icon.name: "love"
        }
    }

    headBar.rightContent: [

        ToolButton
        {
            visible: !entryFocused
            icon.name: "list-add"
            onClicked: _browserView.openTab("")
        },

        Maui.ToolButtonMenu
        {
            visible: !entryFocused
            icon.name: "overflow-menu"

            MenuItem
            {
                text: i18n("New Tab")
                icon.name: "list-add"
            }

            MenuItem
            {
                text: i18n("Incognito Tab")
                icon.name: "actor"
            }

            MenuSeparator {}

            MenuItem
            {
                text: i18n("History")
                icon.name: "deep-history"
                onTriggered:
                {
                    _swipeView.currentIndex = 1
                }
            }

            MenuItem
            {
                text: i18n("Downloads")
                icon.name: "folder-downloads"
                onTriggered:
                {
                    _swipeView.currentIndex = 2
                }
            }

            MenuItem
            {
                text: i18n("BookMarks")
                icon.name: "bookmarks"
                onTriggered:
                {
                    _swipeView.currentIndex = 2
                }
            }

            MenuItem
            {
                text: i18n("Recent")
                icon.name: "document-open-recent"
                onTriggered:
                {
                    _swipeView.currentIndex = 1
                }
            }

            MenuSeparator {}
            MenuItem
            {
                text: i18n("Share")
                icon.name: "edit-share"
            }

            MenuItem
            {
                text: i18n("BookMark")
                icon.name: "bookmarks"
            }

            MenuItem
            {
                text: i18n("Find")
                icon.name: "edit-find"
            }
        }
    ]

    Maui.AppViews
    {
        id: _swipeView
        anchors.fill: parent
        currentIndex: views.browser
        toolbar: root.footBar

        BrowserView
        {
            id: _browserView
            Maui.AppView.title: i18n("Browser")
            Maui.AppView.iconName: "internet-web-browser"
        }

        Item
        {
            id : _historyView //recent and history
            Maui.AppView.title: i18n("Recent")
            Maui.AppView.iconName: "shallow-history"
        }

        Item
        {
            id : _homeView // bookmarks & downloads
            Maui.AppView.title: i18n("Home")
            Maui.AppView.iconName: "go-home"
        }
    }

}
