import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.3
import QtWebEngine 1.7
import Qt.labs.settings 1.0

import org.mauikit.controls 1.3 as Maui

import org.maui.fiery 1.0 as Fiery

import "views/browser"
import "views/widgets"
import "views/history"
import "views/home"

Maui.ApplicationWindow
{
    id: root
    title: _browserView.currentTab.title

    readonly property var views : ({browser: 0, tabs: 1, history: 2})

    readonly property alias currentBrowser : _browserView.currentBrowser
    readonly property alias browserView : _browserView

    Settings
    {
        id: appSettings
        category: "Browser"

        property url homePage: "https://duckduckgo.com"
        property url searchEnginePage: "https://duckduckgo.com/?q="
        property color backgroundColor : root.Maui.Theme.backgroundColor

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

    Fiery.Surf
    {
        id: _surf
    }

    SettingsDialog
    {
        id: _settingsDialog
    }

    Maui.SideBarView
    {
        id: _sideBarView
        anchors.fill: parent
        sideBar.autoShow: false
        sideBar.autoHide: true
        sideBar.preferredWidth: 400
        sideBar.content: Maui.Page
        {
            anchors.fill: parent
            Maui.Theme.colorSet: Maui.Theme.Window
            Maui.Theme.inherit: false

            headBar.middleContent: Maui.ToolActions
            {
                id: _sidebarActions
                autoExclusive: true

                display: ToolButton.IconOnly
                Layout.alignment: Qt.AlignHCenter

                Action
                {
                    text: i18n("Home")
                    icon.name: "go-home"
                    checked: _sidebarSwipeView.currentIndex === 0
                    onTriggered: _sidebarSwipeView.currentIndex = 0
                }

                Action
                {
                    text: i18n("Recent")
                    icon.name: "shallow-history"
                    checked: _sidebarSwipeView.currentIndex === 1
                    onTriggered: _sidebarSwipeView.currentIndex = 1
                }

                Action
                {
                    text: i18n("Downloads")
                    icon.name: "folder-download"
                    checked: _sidebarSwipeView.currentIndex === 2
                    onTriggered: _sidebarSwipeView.currentIndex = 2
                }
            }


            SwipeView
            {
                anchors.fill: parent
                id: _sidebarSwipeView

                HomeView {}

                HistoryView {}

                Maui.Page
                {

                    Maui.ListBrowser
                    {
                        anchors.fill: parent
                        model: Fiery.DownloadsManager.model

                        delegate: Maui.ListBrowserDelegate
                        {
                            id: _downloadDelegate

                            width: ListView.view.width

                            label1.text: model.name
                            label2.text: model.url
                            iconSource: download.state === WebEngineDownloadItem.DownloadCompleted ? model.filePath : model.icon

                            property WebEngineDownloadItem download : model.download

                            onClicked: Qt.openUrlExternally(model.filePath)

                            ToolButton
                            {

                                visible: !_downloadDelegate.download.isPaused && _downloadDelegate.download.state === WebEngineDownloadItem.DownloadInProgress
                                text: i18n("Pause")
                                icon.name: "media-playback-pause"
                                onClicked: _downloadDelegate.download.pause()
                            }

                            ToolButton
                            {
                                visible: _downloadDelegate.download.isPaused && _downloadDelegate.download.state === WebEngineDownloadItem.DownloadInProgress
                                text: i18n("Continue")
                                icon.name: "media-playback-start"
                                onClicked: _downloadDelegate.download.resume();
                            }

                            ToolButton
                            {
                                icon.name: _downloadDelegate.download.state === WebEngineDownloadItem.DownloadInProgress ? "dialog-cancel" : "list-remove"
                            }

                        }
                    }
                }
            }
        }

        BrowserView
        {
            id: _browserView

            anchors.fill: parent
            showCSDControls: true


            autoHideHeader: false

            altHeader: Maui.Handy.isMobile
            headBar.forceCenterMiddleContent: width > 1000
            headBar.middleContent: NavigationBar
            {
                id: _navBar
                position: _browserView.headBar.position
                Layout.fillWidth: true
                Layout.maximumWidth: 500
                Layout.alignment:Qt.AlignCenter
            }


            headBar.rightContent: [ToolButton
                {
                    icon.name: "list-add"
                    onClicked: _browserView.openTab("")
                },
                Maui.ToolButtonMenu
                {
                    id: _browserMenu

                    icon.name: "overflow-menu"


                    Maui.MenuItemActionRow
                    {
                        Action
                        {
                            icon.name: "love"
                            checked: Fiery.Bookmarks.isBookmark(currentBrowser.url)
                            checkable: true
                            onTriggered:  Fiery.Bookmarks.insertBookmark(currentBrowser.url, currentBrowser.title)
                        }

                        Action
                        {
                            text: i18n("Next")
                            enabled: currentBrowser.canGoForward
                            icon.name: "go-next"
                            onTriggered: currentBrowser.goForward()
                        }

                        Action
                        {
                            icon.name: "view-refresh"
                            onTriggered: currentBrowser.reload()
                        }
                    }

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
                            _sidebarSwipeView.currentIndex = 1
                        }
                    }

                    MenuItem
                    {
                        text: i18n("Downloads")
                        icon.name: "folder-downloads"
                        onTriggered:
                        {
                            _sidebarSwipeView.currentIndex = 2
                        }
                    }

                    MenuItem
                    {
                        text: i18n("Bookmarks")
                        icon.name: "bookmarks"
                        onTriggered:
                        {
                            _sidebarSwipeView.currentIndex = 2
                        }
                    }

                    MenuSeparator {}

                    Maui.MenuItemActionRow
                    {
                        Action
                        {
                            text: i18n("Share")
                            icon.name: "edit-share"
                        }


                    }

                    MenuItem
                    {
                        text: i18n("Find In Page")
                        icon.name: "edit-find"
                        checked: _browserView.searchFieldVisible
                        onTriggered: _browserView.searchFieldVisible = !_browserView.searchFieldVisible
                    }

                    MenuSeparator {}


                    MenuItem
                    {
                        text: i18n("Settings")
                        icon.name: "settings-configure"
                        onTriggered: _settingsDialog.open()
                    }

                    MenuItem
                    {
                        text: i18n("About")
                        icon.name: "documentinfo"
                        onTriggered: root.about()
                    }


                }
            ]

            headBar.leftContent: [ToolButton
                {
                    icon.name: _sideBarView.sideBar.visible ? "sidebar-collapse" : "sidebar-expand"
                    onClicked: _sideBarView.sideBar.toggle()
                    checked: _sideBarView.sideBar.visible
                    ToolTip.delay: 1000
                    ToolTip.timeout: 5000
                    ToolTip.visible: hovered
                    ToolTip.text: i18n("Toggle sidebar")
                },

                ToolButton
                {

                    enabled: currentBrowser.canGoBack
                    onClicked: currentBrowser.goBack()

                    icon.name: "go-previous"

                }
            ]
        }
    }
}
