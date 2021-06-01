import QtQuick 2.14
import QtQml 2.12
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.3

import QtWebView 1.1
import org.mauikit.controls 1.3 as Maui

Item
{
    id: control
    property alias url : _webView.url
    readonly property string title : _webView.title.length ? _webView.title : "Sol-"

    height: ListView.view.height
    width:  ListView.view.width

    Maui.TabViewInfo.tabTitle: title
    Maui.TabViewInfo.tabToolTipText:  _webView.url

    WebView
    {
        id: _webView
        anchors.fill: parent
    }
}


