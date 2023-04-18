import QtQuick 2.14
import QtQml 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.3

import org.mauikit.controls 1.3 as Maui

import org.maui.fiery 1.0 as Fiery

Item
{
    id: control
    property bool editMode: false

    implicitHeight: _button.implicitHeight

    property int position: ToolBar.Header

    Button
    {
        id:_button
        visible: !control.editMode

        anchors.fill: parent

        onClicked:
        {
            editMode = true
            _entryField.forceActiveFocus()
        }

        contentItem: Item
        {
            implicitHeight: _template.implicitHeight
            Maui.ProgressIndicator
            {
                id: _progress
                width: parent.width
                anchors.centerIn: parent
                visible: _browserView.currentBrowser.loading
            }

            Maui.ListItemTemplate
            {
                id: _template
                anchors.fill: parent
                leftLabels.spacing: 0
                label1.text: _button.hovered ?  _browserView.currentBrowser.url : _browserView.currentBrowser.title
                label1.horizontalAlignment: Qt.AlignHCenter

                imageSource:  _browserView.currentBrowser.icon
                imageSizeHint: Maui.Style.iconSize
                iconSizeHint: Maui.Style.iconSize

                iconVisible: true
            }
        }
    }

    Maui.TextFieldPopup
    {
        id: _entryField
        visible: control.editMode
        anchors.fill: parent

        placeholderText: i18n("Search or enter URL")
        text: currentBrowser.url

        activeFocusOnPress : true
        inputMethodHints: Qt.ImhUrlCharactersOnly  | Qt.ImhNoAutoUppercase

        onAccepted:
        {
            if(text.length > 0)
                _browserView.openUrl(text)
            else
            {
                _browserView.openUrl(_historyListView.currentItem.url)
            }

            _entryField.close()
        }

        onClosed:
        {
            control.editMode = false
        }

        Keys.forwardTo: _historyListView


        Maui.ListBrowser
        {
            id: _historyListView
            clip: true

            width: parent.width
            height: parent.height

            currentIndex: -1

            orientation: ListView.Vertical
            spacing: Maui.Style.space.medium

            flickable.header: Maui.ListBrowserDelegate
            {
                width: ListView.view.width

                label1.text: _entryField.text
                label2.text: i18n("Search on default search engine")

                iconSource: "edit-find"
                iconSizeHint: Maui.Style.iconSizes.medium

                onClicked:
                {
                    _browserView.openUrl(model.url)
                    root.editMode = false
                }
            }

            model: Maui.BaseModel
            {
                list: Fiery.History
                filter: _entryField.text
                sort: "adddate"
                sortOrder: Qt.AscendingOrder
                recursiveFilteringEnabled: true
                sortCaseSensitivity: Qt.CaseInsensitive
                filterCaseSensitivity: Qt.CaseInsensitive
            }

            delegate: Maui.ListBrowserDelegate
            {
                width: ListView.view.width
                property string url : model.url
                label1.text: model.title
                label2.text: model.url
                imageSource: model.icon.replace("image://favicon/", "")
                template.imageSizeHint: Maui.Style.iconSizes.medium
                onClicked:
                {
                    _browserView.openUrl(model.url)
                    _entryField.close()
                }
            }
        }
    }
    function openEditMode()
    {
        editMode = true
        _entryField.forceActiveFocus()
    }
}
