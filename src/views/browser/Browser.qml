import QtQuick 2.14
import QtQml 2.12
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.3

import QtWebEngine 1.10
import org.mauikit.controls 1.3 as Maui
import org.maui.fiery 1.0 as Fiery

import "../home"

Maui.SplitViewItem
{
    id: control
    property alias url : _webView.url
    property alias webView : _webView
    readonly property string title : _webView.title.length ? _webView.title : "Fiery"
    readonly property string iconName: _webView.icon

    height: ListView.view.height
    width:  ListView.view.width

    Maui.TabViewInfo.tabTitle: title
    Maui.TabViewInfo.tabToolTipText:  _webView.url

    ActionsMenu
    {
        id: _menu
        webView: _webView
    }


    WebEngineView
    {
        id: _webView
        anchors.fill: parent

        profile: browserView.profile

        onContextMenuRequested: {
            request.accepted = true // Make sure QtWebEngine doesn't show its own context menu.
            _menu.request = request
            _menu.show()

            //                _menu.show()
        }

        onLoadingChanged:
        {
            if(loadRequest.status === WebEngineView.LoadSucceededStatus)
            {
                Fiery.History.appendUrl(control.url, control.title, control.iconName)
            }
        }

        onIconChanged: {
            console.log("ICON CHANGED", icon)
            if (icon)
            {
                Fiery.History.updateIcon(url, icon)
            }
        }

        onFindTextFinished: {
            //                   findInPageResultIndex = result.activeMatch;
            //                   findInPageResultCount = result.numberOfMatches;
        }

        onFileDialogRequested:
        {
            console.log("FILE DIALOG REQUESTED", request.mode, FileDialogRequest.FileModeSave)

        }


        settings.accelerated2dCanvasEnabled : appSettings.accelerated2dCanvasEnabled
        settings.allowGeolocationOnInsecureOrigins : appSettings.allowGeolocationOnInsecureOrigins
        settings.allowRunningInsecureContent : appSettings.allowRunningInsecureContent
        settings.allowWindowActivationFromJavaScript : appSettings.allowWindowActivationFromJavaScript
        settings.autoLoadImages : appSettings.autoLoadImages
        settings.dnsPrefetchEnabled : appSettings.dnsPrefetchEnabled
        settings.hyperlinkAuditingEnabled : appSettings.hyperlinkAuditingEnabled
        settings.javascriptCanAccessClipboard : appSettings.javascriptCanAccessClipboard
        settings.javascriptCanOpenWindows : appSettings.javascriptCanOpenWindows
        settings.javascriptCanPaste : appSettings.javascriptCanPaste
        settings.javascriptEnabled : appSettings.javascriptEnabled
        settings.linksIncludedInFocusChain : appSettings.linksIncludedInFocusChain
        settings.localContentCanAccessFileUrls : appSettings.localContentCanAccessFileUrls
        settings.localContentCanAccessRemoteUrls : appSettings.localContentCanAccessRemoteUrls
        settings.localStorageEnabled : appSettings.localStorageEnabled
        settings.pdfViewerEnabled : appSettings.pdfViewerEnabled
        settings.playbackRequiresUserGesture : appSettings.playbackRequiresUserGesture
        settings.pluginsEnabled : appSettings.pluginsEnabled
        settings.webGLEnabled : appSettings.webGLEnabled
        settings. webRTCPublicInterfacesOnly : appSettings.webRTCPublicInterfacesOnly
    }

    Maui.Holder
    {
        anchors.fill: parent
        visible: control.url.toString().length <= 0 || _webView.status === WebEngineView.LoadFailedStatus
        emoji: "qrc:/internet.svg"

        title: _webView.status === WebEngineView.LoadFailedStatus ? i18n("Error") : i18n("Start Browsing")
        body: i18n("Enter a new URL or open a recent site.")
    }

    Component.onCompleted:
    {
        if(!control.url || !control.url.length || !validURL(control.url))
        {
            //            _stackView.push(_startComponent)
        }
    }
}


