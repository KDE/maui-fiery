import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.3

import Qt.labs.settings 1.0

import org.kde.kirigami 2.7 as Kirigami
import org.mauikit.controls 1.2 as Maui

import org.maui.sol 1.0 as Sol

import "views/browser"
import "views/widgets"
import "views/history"
import "views/home"

Maui.ApplicationWindow
{
    id: root
    title: _browserView.currentTab.title
    autoHideHeader: false

    readonly property var views : ({browser: 0, tabs: 1, history: 2})

    readonly property alias currentBrowser : _browserView.currentBrowser
    property bool editMode: false

    mainMenu: [Action
        {
            text: i18n("Settings")
            icon.name: "settings-configure"
            onTriggered: _settingsDialog.open()
        }]

    Settings
    {
        id: appSettings
        category: "Browser"

        property url homePage: "https://duckduckgo.com"
        property url searchEnginePage: "https://duckduckgo.com/?q="
        property color backgroundColor : root.Kirigami.Theme.backgroundColor

        property bool accelerated2dCanvasEnabled : true
        property bool allowGeolocationOnInsecureOrigins : false
        property bool allowRunningInsecureContent : false
        property bool allowWindowActivationFromJavaScript : false
        property bool autoLoadIconsForPage : true
        property bool autoLoadImages : true
        //        property bool defaultTextEncoding : string
        property bool dnsPrefetchEnabled : false
        property bool errorPageEnabled : true
        property bool focusOnNavigationEnabled : false
        property bool fullscreenSupportEnabled : false
        property bool hyperlinkAuditingEnabled : false
        property bool javascriptCanAccessClipboard : true
        property bool javascriptCanOpenWindows : true
        property bool javascriptCanPaste : true
        property bool javascriptEnabled : true
        property bool linksIncludedInFocusChain : true
        property bool localContentCanAccessFileUrls : true
        property bool localContentCanAccessRemoteUrls : false
        property bool localStorageEnabled : true
        property bool pdfViewerEnabled : true
        property bool playbackRequiresUserGesture : true
        property bool pluginsEnabled : false
        property bool printElementBackgrounds : true
        property bool screenCaptureEnabled : true
        property bool showScrollBars : true
        property bool spatialNavigationEnabled : false
        property bool touchIconsEnabled : false
        //        property bool unknownUrlSchemePolicy : WebEngineSettings::UnknownUrlSchemePolicy
        property bool webGLEnabled : true
        property bool  webRTCPublicInterfacesOnly : false

    }

    SettingsDialog
    {
        id: _settingsDialog
    }

    headBar.visible: _swipeView.currentIndex === views.browser

    headBar.leftContent:  [Maui.ToolActions
        {
            //        expanded: root.isWide
            autoExclusive: false
            checkable: false
            defaultIconName: "go-previous"

            Action
            {
                text: i18n("Previous")
                enabled: currentBrowser.canGoBack
                icon.name: "go-previous"
                onTriggered: currentBrowser.goBack()
            }

            Action
            {
                text: i18n("Next")
                enabled: currentBrowser.canGoForward
                icon.name: "go-next"
                onTriggered: currentBrowser.goForward()

            }
        },

        ToolButton
        {
            icon.name: "view-refresh"
            onClicked: currentBrowser.reload()
        }    ]

    footBar.visible: _swipeView.currentIndex !== views.browser

    Component
    {
        id: _navBarComponent

        NavigationBar
        {
            implicitWidth: 0
            position: _navBar1Loader.active ? ToolBar.Header :ToolBar.Footer
            mobile : !_navBar1Loader.active
        }
    }

    altHeader: !root.isWide
    headBar.forceCenterMiddleContent: false
    headBar.middleContent: Loader
    {
        id: _navBar1Loader
        visible: active
        active: root.width > Kirigami.Units.gridUnit * 40
        sourceComponent: _navBarComponent
        Layout.fillWidth: visible
        Layout.maximumWidth: visible ? 500 : 0
        Layout.minimumWidth: 0
    }

    page.headerColumn: Maui.ToolBar
    {
        visible: !_navBar1Loader.active && root.headBar.visible

        width: parent.width
        position: ToolBar.Header
        middleContent: Loader
        {
            visible: active
            active: !_navBar1Loader.active
            sourceComponent: _navBarComponent
            Layout.fillWidth: true
            Layout.minimumWidth: visible ? 150 : 0
        }
    }

    headBar.rightContent: [

        ToolButton
        {
            icon.name: "love"
            checked: Sol.Bookmarks.isBookmark(currentBrowser.url)
            checkable: true
            onClicked: Sol.Bookmarks.insertBookmark(currentBrowser.url, currentBrowser.title)
        },

        ToolButton
        {
            icon.name: "list-add"
            onClicked: _browserView.openTab("")
        },

        Maui.ToolButtonMenu
        {
            icon.name: "overflow-menu"

            MenuItem
            {
                text: i18n("New Tab")
                icon.name: "list-add"
                onTriggered: _browserView.openTab("")
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

        HistoryView
        {
            id : _historyView //recent and history && bookmarks
            Maui.AppView.title: i18n("Recent")
            Maui.AppView.iconName: "shallow-history"
        }

        HomeView
        {
            id : _homeView // downloads
            Maui.AppView.title: i18n("Home")
            Maui.AppView.iconName: "go-home"
        }
    }

}
