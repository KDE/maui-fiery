import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtWebEngine
import QtCore

import org.mauikit.controls as Maui

import org.maui.fiery as Fiery

import "views"
import "views/widgets"

Maui.ApplicationWindow
{
    id: root
    title: browserView.currentTab.title

    readonly property var views : ({browser: 0, tabs: 1, history: 2})

    readonly property alias currentBrowser : _appView.currentBrowser
    readonly property alias browserView : _appView.browserView

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

        property string downloadsPath : browserView.profile.downloadPath

        property bool restoreSession: true
        property bool switchToTab: false
        property double zoomFactor

        property bool autoSave: false
    }

    Fiery.Surf
    {
        id: _surf
    }

    SettingsDialog
    {
        id: _settingsDialog
    }

    AppView
    {
        id: _appView
        anchors.fill: parent
    }

    Action
    {
        id: _openDownloadAction
        property url url
        text: i18n("Open")
        onTriggered: ()=> { Qt.openUrlExternally(url)}
    }

    Action
    {
        id: _acceptDownloadAction
        property var download
        text: i18n("Accept")
        onTriggered: () =>{ _acceptDownloadAction.download.resume() }

    }

    property WebEngineProfile profile: Fiery.FieryWebProfile
    {
        //            httpUserAgent: tabs.currentItem.userAgent.userAgent
        //            offTheRecord: tabs.privateTabsMode
        //            storageName: tabs.privateTabsMode ? "Private" : Settings.profile

        //            questionLoader: rootPage.questionLoader
        //            urlInterceptor: typeof AdblockUrlInterceptor !== "undefined" && AdblockUrlInterceptor

        onDownloadFinished: (download) =>
        {
            switch(download.state)
            {
                case WebEngineDownloadRequest.DownloadCompleted:
            {
                _openDownloadAction.url = "file://"+download.downloadDirectory+"/"+download.downloadFileName
                notify("dialog-warning", i18n("Download Finished"), i18n("File has been saved."), [_openDownloadAction])
            }
            }
        }

        //        onPresentNotification:
        //        {
        //            root.notify("dialog-question", notification.title, notification.message,  () =>{ notification.click() }, i18n("Accept"))
        //            notification.show()
        //        }
    }

    Connections
    {
        target: Fiery.DownloadsManager
        function onNewDownload(download)
        {
            _acceptDownloadAction.download = download
            root.notify("dialog-question", download.downloadFileName, i18n("Do you want to download and save this file?"), [_acceptDownloadAction])
        }
    }

    property Component windowComponent: Maui.BaseWindow
    {
        // Destroy on close to release the Window's QML resources.
        // Because it was created with a parent, it won't be garbage-collected.
        onClosing:
        {
            console.log("Closing new window")
            destroy()
        }

        visible: true

        property WebEngineView webView: _delegate.currentBrowser
        readonly property alias appView : _delegate

        AppView
        {
            id: _delegate
            anchors.fill: parent
        }
    }

    //The urls represent the split view, so it might be one or two.
    function newWindow(urls)
    {
        console.log("GOT", urls, urls[0])
        var newWindow = windowComponent.createObject(root)
        newWindow.webView.url = urls[0]

        if(urls[1])
        {
            newWindow.appView.browserView.openSplit(urls[1])
        }
    }
}
