import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.3

import org.kde.kirigami 2.7 as Kirigami
import org.mauikit.controls 1.3 as Maui

Maui.Page
{
    id: control
    property alias currentTab : _browserListView.currentItem
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

    }

    function openTab(path)
    {
        _swipeView.currentIndex = views.browser

        var component = Qt.createComponent("qrc:/views/browser/Browser.qml");
        if (component.status === Component.Ready)
        {
            _browserListView.addTab(component, {"url": path});
            _browserListView.currentIndex = _browserListView.count -1
        }
    }

}
