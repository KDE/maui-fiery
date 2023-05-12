import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.3
import QtWebEngine 1.7
import Qt.labs.settings 1.0

import org.mauikit.controls 1.3 as Maui

import org.maui.fiery 1.0 as Fiery

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

    property Component windowComponent: Maui.ApplicationWindow
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
        property alias appView : _delegate
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
