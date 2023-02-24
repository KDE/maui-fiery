import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.3

import org.mauikit.controls 1.3 as Maui

import org.maui.fiery 1.0 as Fiery

Maui.Page
{
    id: control

    background: null
    headBar.middleContent: Maui.SearchField
    {
        id: _entryField
        Layout.fillWidth: true
        Layout.maximumWidth: 500
        Layout.alignment: Qt.AlignCenter
    }

    Maui.ListBrowser
    {
        id: _listView
        anchors.fill: parent


        model: Maui.BaseModel
        {
            list: Fiery.Bookmarks
            filter: _entryField.text
            sort: "adddate"
            sortOrder: Qt.DescendingOrder
            recursiveFilteringEnabled: true
            sortCaseSensitivity: Qt.CaseInsensitive
            filterCaseSensitivity: Qt.CaseInsensitive
        }

        delegate:  Maui.ListBrowserDelegate
        {
            width: ListView.view.width
            label1.text: model.title
            tooltipText: model.url
            imageSource: model.icon.replace("image://favicon/", "")
            iconSizeHint: Maui.Style.iconSizes.medium
            onClicked:
            {
                _listView.currentIndex = index
                _browserView.openTab(model.url)
            }
        }

    }
}
