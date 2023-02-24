import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.3

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
    property bool editMode: false

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
                currentIndex: _sidebarSwipeView.currentIndex
                display: ToolButton.IconOnly
                Layout.alignment: Qt.AlignHCenter

                Action
                {
                    text: i18n("Home")
                    icon.name: "go-home"

                }


                Action
                {
                    text: i18n("Recent")
                    icon.name: "shallow-history"


                }
                Action
                {
                    text: i18n("Downloads")
                    icon.name: "folder-download"

                }
            }


            SwipeView
            {
                anchors.fill: parent
                id: _sidebarSwipeView
                currentIndex: _sidebarActions.currentIndex
                HomeView {}

                HistoryView {}

                Item{}
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


            headBar.rightContent: ToolButton
            {
                icon.name: "list-add"
                onClicked: _browserView.openTab("")
            }

            headBar.leftContent: ToolButton
            {
                icon.name: _sideBarView.sideBar.visible ? "sidebar-collapse" : "sidebar-expand"
                onClicked: _sideBarView.sideBar.toggle()
                checked: _sideBarView.sideBar.visible
                ToolTip.delay: 1000
                ToolTip.timeout: 5000
                ToolTip.visible: hovered
                ToolTip.text: i18n("Toggle sidebar")
            }
        }
    }
}
