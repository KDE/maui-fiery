import QtQuick 2.14
import QtQml 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.3

import org.kde.kirigami 2.14 as Kirigami
import org.mauikit.controls 1.3 as Maui

import org.maui.fiery 1.0 as Fiery

Item
{
    id: control

    implicitHeight: Maui.Style.rowHeight

    property int position: ToolBar.Header

    RowLayout
    {
        anchors.fill: parent
        spacing: 2

        AbstractButton
        {            
            Maui.Theme.colorSet: Maui.Theme.Button
            Maui.Theme.inherit: false

            enabled: currentBrowser.canGoBack()
            onClicked: currentBrowser.goBack()

            Layout.fillHeight: true
            implicitWidth: height

            contentItem: Item
            {
                Kirigami.Icon
                {
                    anchors.centerIn: parent
                    source: "go-previous"
                    color: Maui.Theme.textColor
                    width: Maui.Style.iconSizes.small
                    height: width
                }
            }

            background: Kirigami.ShadowedRectangle
            {
                color: Maui.Theme.backgroundColor
                corners
                {
                    topLeftRadius: Maui.Style.radiusV
                    topRightRadius: 0
                    bottomLeftRadius: Maui.Style.radiusV
                    bottomRightRadius: 0
                }
            }
        }

        AbstractButton
        {            
            Maui.Theme.colorSet: Maui.Theme.Button
            Maui.Theme.inherit: false

            Layout.fillWidth: true
            Layout.fillHeight: true
            hoverEnabled: true
            onClicked:
            {
                editMode = true
                _entryField.forceActiveFocus()
            }

            Maui.ProgressIndicator
            {
                id: _progress
                width: parent.width
                anchors.centerIn: parent
                visible: _browserView.currentBrowser.loading
            }

            Maui.TextField
            {
                id: _entryField
                visible: editMode
                anchors.fill: parent

                placeholderText: i18n("Search or enter URL")
                text: _browserView.currentTab.url

                activeFocusOnPress : true
                inputMethodHints: Qt.ImhUrlCharactersOnly  | Qt.ImhNoAutoUppercase

                onAccepted:
                {
                    _browserView.openUrl(text)
                    root.editMode = false
                }

                onPressed:
                {
                    _historyPopup.open()
                }

                onActiveFocusChanged:
                {
                    if(!_entryField.activeFocus)
                    {
                        root.editMode = false
                    }
                }

                Keys.forwardTo: _historyListView

                Popup
                {
                    id: _historyPopup

                    width: _entryField.width
                    height: Math.min(_historyListView.contentHeight + Maui.Style.space.big, root.height * 0.7)

                    Binding on visible
                    {
                        value: _entryField.activeFocus && root.editMode
                        restoreMode: Binding.RestoreBindingOrValue
                    }

                    parent: _entryField
                    y: control.position === ToolBar.Header ? parent.height + Maui.Style.space.medium : (0 - height - Maui.Style.space.medium )
                    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
                    clip: true
                    padding: 0

                    Maui.ListBrowser
                    {
                        id: _historyListView
                        width: parent.width
                        height: parent.height
                        anchors.centerIn:  parent
                        currentIndex: -1
                        orientation: ListView.Vertical
                        spacing: Maui.Style.space.medium
                        //                margins: 0

                        //                KeyNavigationWraps: true

                        onCurrentItemChanged:
                        {
                            _entryField.text = currentItem.label2.text
                        }

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

                            label1.text: model.title
                            label2.text: model.url
                            imageSource: model.icon.replace("image://favicon/", "")
                            template.imageSizeHint: Maui.Style.iconSizes.medium
                            onClicked:
                            {
                                _browserView.openUrl(model.url)
                                root.editMode = false
                            }
                        }
                    }
                }

                background: null
            }

            Maui.ListItemTemplate
            {
                visible: !editMode

                anchors.fill: parent
                leftLabels.spacing: 0
                label1.text:  _browserView.currentTab.title
                label1.horizontalAlignment: Qt.AlignHCenter
                label2.horizontalAlignment: Qt.AlignHCenter
                label2.font.pointSize: Maui.Style.fontSizes.small
                label2.text:  _browserView.currentTab.url
                label2.visible: parent.hovered
                imageSource:  _browserView.currentTab.iconName
                imageSizeHint: Maui.Style.iconSizes.medium
            }

            background: Rectangle
            {
                color : editMode ? _entryField.Maui.Theme.backgroundColor : Maui.Theme.backgroundColor
                border.color: editMode ? Maui.Theme.highlightColor : "transparent"

            }
        }

        AbstractButton
        {
            Layout.fillHeight: true
            implicitWidth: height

            Maui.Theme.colorSet: Maui.Theme.Button
            Maui.Theme.inherit: false

            onClicked: _browserMenu.show((width*0.5)-(_browserMenu.width *0.5), height+ Maui.Style.space.medium)
            contentItem: Item
            {
                Kirigami.Icon
                {
                    anchors.centerIn: parent
                    source: "overflow-menu"
                    color: Maui.Theme.textColor
                    width: Maui.Style.iconSizes.small
                    height: width
                }
            }

            background: Kirigami.ShadowedRectangle
            {
                color : _browserMenu.visible ? Maui.Theme.highlightColor : Maui.Theme.backgroundColor
                corners
                {
                    topLeftRadius: 0
                    topRightRadius: Maui.Style.radiusV
                    bottomLeftRadius: 0
                    bottomRightRadius: Maui.Style.radiusV
                }
            }

            Maui.ContextualMenu
            {
                id: _browserMenu

                Maui.MenuItemActionRow
                {
                    Action
                    {
                        icon.name: "love"
                        checked: Fiery.Bookmarks.isBookmark(currentBrowser.url)
                        checkable: true
                        onTriggered:  Fiery.Bookmarks.insertBookmark(currentBrowser.url, currentBrowser.title)
                    }

                    Action
                    {
                        text: i18n("Next")
                        enabled: currentBrowser.canGoForward
                        icon.name: "go-next"
                        onTriggered: currentBrowser.goForward()
                    }

                    Action
                    {
                        icon.name: "view-refresh"
                        onTriggered: currentBrowser.reload()
                    }
                }

                MenuItem
                {
                    text: i18n("New Tab")
                    icon.name: "list-add"
                    onTriggered: _browserView.openTab("")
                }

                MenuItem
                {
                    text: i18n("Incognito Tab")
                    icon.name: "actor"
                }

                MenuSeparator {}

                MenuItem
                {
                    text: i18n("History")
                    icon.name: "deep-history"
                    onTriggered:
                    {
                        _swipeView.currentIndex = 1
                    }
                }

                MenuItem
                {
                    text: i18n("Downloads")
                    icon.name: "folder-downloads"
                    onTriggered:
                    {
                        _swipeView.currentIndex = 2
                    }
                }

                MenuItem
                {
                    text: i18n("BookMarks")
                    icon.name: "bookmarks"
                    onTriggered:
                    {
                        _swipeView.currentIndex = 2
                    }
                }

                MenuSeparator {}

                Maui.MenuItemActionRow
                {
                Action
                {
                    text: i18n("Share")
                    icon.name: "edit-share"
                }

                Action
                {
                    text: i18n("BookMark")
                    icon.name: "draw-star"
                }

                Action
                {
                    text: i18n("Find")
                    icon.name: "edit-find"
                }
                }

                MenuSeparator {}


                MenuItem
                {
                    text: i18n("Settings")
                    icon.name: "settings-configure"
                    onTriggered: _settingsDialog.open()
                }

                MenuItem
                {
                    text: i18n("About")
                    icon.name: "documentinfo"
                    onTriggered: root.about()
                }
            }

        }
    }
}
