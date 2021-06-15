import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.3

import org.kde.kirigami 2.14 as Kirigami
import org.mauikit.controls 1.3 as Maui

import org.maui.sol 1.0 as Sol


Maui.Page
{
    id: control

    headBar.middleContent: Maui.TextField
    {
        id: _entryField
        Layout.fillWidth: true
        Layout.maximumWidth: 500
    }

    Maui.GridView
    {
        id: _listView
        anchors.fill: parent
        itemSize: 150
        itemHeight: 190

        model: Maui.BaseModel
        {
            list: Sol.Bookmarks
            filter: _entryField.text
            sort: "adddate"
            sortOrder: Qt.DescendingOrder
            recursiveFilteringEnabled: true
            sortCaseSensitivity: Qt.CaseInsensitive
            filterCaseSensitivity: Qt.CaseInsensitive
        }

        delegate: Maui.GridBrowserDelegate
        {
            width: GridView.view.cellWidth
            height: GridView.view.cellHeight
padding: Maui.Style.space.medium
            label1.text: model.title
            label2.text: model.url
            imageSource: model.icon.replace("image://favicon/", "")
//            template.imageSizeHint: Maui.Style.iconSizes.medium

            onClicked:
            {
                _listView.currentIndex = index
            }
        }
    }
}
