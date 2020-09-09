import QtQuick 2.0
import QtWebView 1.1

Item
{
    id: control
    property alias url : _webView.url
    readonly property string title : _webView.title.length ? _webView.title : "Sol-"


    height: _browserListView.height
    width: _browserListView.width

    WebView
    {
        id: _webView
        anchors.fill: parent
    }
}


