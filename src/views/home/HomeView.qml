import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.3

import org.mauikit.controls 1.3 as Maui

import org.maui.fiery 1.0 as Fiery

Maui.Page
{
    id: control

    headBar.middleContent: Maui.SearchField
    {
        id: _entryField
        Layout.fillWidth: true
        Layout.maximumWidth: 500
        Layout.alignment: Qt.AlignCenter
    }

    Maui.GridBrowser
    {
        id: _listView
        anchors.fill: parent
        itemSize: 150
        itemHeight: 190

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

        delegate: Item
        {
            width: GridView.view.cellWidth
            height: GridView.view.cellHeight
            Maui.GridBrowserDelegate
            {
               anchors.fill: parent
               anchors.margins: Maui.Style.space.medium
                label1.text: model.title
                label2.text: model.url
                imageSource: model.icon.replace("image://favicon/", "")
                            template.imageSizeHint: Maui.Style.iconSizes.large
template.labelSizeHint: 64
                onClicked:
                {
                    _listView.currentIndex = index
                }
            }
        }
    }
}
