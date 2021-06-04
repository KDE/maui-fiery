import QtQuick 2.14
import QtQml 2.12
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.3

 import QtWebEngine 1.10
import org.mauikit.controls 1.3 as Maui

Item
{
    id: control
    property alias url : _webView.url
    property alias webView : _webView
    readonly property string title : _webView.title.length ? _webView.title : "Sol-"
     readonly property string iconName: _webView.icon
    height: ListView.view.height
    width:  ListView.view.width

    Maui.TabViewInfo.tabTitle: title
    Maui.TabViewInfo.tabToolTipText:  _webView.url

Maui.ContextualMenu
{
    id: _menu
        property ContextMenuRequest request
    MenuItem
    {
        text: i18n("Open in new tab")
        onTriggered:
        {
            console.log(_menu.request.linkUrl)
            openTab(_menu.request.linkUrl)
        }
    }

    MenuItem
    {
        text: i18n("Download")
    }

    MenuItem
    {
        text: i18n("Inspect")
    }

    MenuItem
    {
        text: i18n("Search...")
    }
    MenuItem
    {
        text: i18n("Copy")
    }
    MenuItem
    {
        text: i18n("Copy link")
    }

}

    WebEngineView
    {
        id: _webView
        anchors.fill: parent

        onContextMenuRequested: {
               request.accepted = true // Make sure QtWebEngine doesn't show its own context menu.
               _menu.request = request
               _menu.open(request.x, request.y)
           }

    }
}


