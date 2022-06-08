import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.3
import QtWebEngine 1.10

import org.mauikit.controls 1.3 as Maui

import org.maui.sol 1.0 as Sol

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
        holder.emoji: "qrc:/internet.svg"

        holder.title: i18n("Start Browsing")
        holder.body: i18n("Enter a new URL or open a recent site.")

        onNewTabClicked: control.openTab("")
        onCloseTabClicked: _browserListView.closeTab(index)
    }

    Component.onCompleted: openTab(appSettings.homePage)

    Component
    {
        id: _browserComponent

        Browser {}
    }

    function openTab(path)
    {
        _swipeView.currentIndex = views.browser
        _browserListView.addTab(_browserComponent, {"url": _surf.formatUrl(path)});
    }

    function openUrl(path)
    {
        _swipeView.currentIndex = views.browser

        if(validURL(path))
        {
            control.currentTab.url = path
        }else
        {
           control.currentTab.url = appSettings.searchEnginePage+path
        }

        control.currentTab.forceActiveFocus()
    }

    function validURL(str)
    {
      var pattern = new RegExp('^(https?:\\/\\/)?'+ // protocol
        '((([a-z\\d]([a-z\\d-]*[a-z\\d])*)\\.)+[a-z]{2,}|'+ // domain name
        '((\\d{1,3}\\.){3}\\d{1,3}))'+ // OR ip (v4) address
        '(\\:\\d+)?(\\/[-a-z\\d%_.~+]*)*'+ // port and path
        '(\\?[;&a-z\\d%_.~+=-]*)?'+ // query string
        '(\\#[-a-z\\d_]*)?$','i'); // fragment locator
      return !!pattern.test(str);
    }

}
