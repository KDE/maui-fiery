import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.3
import QtWebEngine 1.10

import org.kde.kirigami 2.7 as Kirigami
import org.mauikit.controls 1.3 as Maui

Maui.Page
{
    id: control
    property alias currentTab : _browserListView.currentItem
    readonly property WebEngineView currentBrowser : _browserListView.currentItem.webView
    property alias listView: _browserListView
    property alias count: _browserListView.count
    readonly property alias model : _browserListView.contentModel

    headBar.visible: false

    Maui.TabView
    {
        id: _browserListView
        anchors.fill: parent
mobile: true
        holder.emoji: "qrc:/internet.svg"

        holder.title: i18n("Start Browsing")
        holder.body: i18n("Enter a new URL or open a recent site.")

        onNewTabClicked: control.openTab("")

    }

    Component.onCompleted: openTab("https://duckduckgo.com")

    Component
    {
        id: _browserComponent

        Browser
        {

        }
    }

    function openTab(path)
    {
        _swipeView.currentIndex = views.browser
        _browserListView.addTab(_browserComponent, {"url": path});
    }

    function openUrl(path)
    {
        _swipeView.currentIndex = views.browser

        if(validURL(path))
        {
            control.currentTab.url = path
        }else
        {
           control.currentTab.url = "https://duckduckgo.com/?q="+path
        }

        control.currentTab.forceActiveFocus()
    }

    function validURL(str) {
      var pattern = new RegExp('^(https?:\\/\\/)?'+ // protocol
        '((([a-z\\d]([a-z\\d-]*[a-z\\d])*)\\.)+[a-z]{2,}|'+ // domain name
        '((\\d{1,3}\\.){3}\\d{1,3}))'+ // OR ip (v4) address
        '(\\:\\d+)?(\\/[-a-z\\d%_.~+]*)*'+ // port and path
        '(\\?[;&a-z\\d%_.~+=-]*)?'+ // query string
        '(\\#[-a-z\\d_]*)?$','i'); // fragment locator
      return !!pattern.test(str);
    }

}
