import QtQuick 2.14
import QtQml 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.3

import org.kde.kirigami 2.7 as Kirigami
import org.mauikit.controls 1.2 as Maui

import org.maui.sol 1.0 as Sol

Rectangle
{
    id: control

    implicitHeight: Maui.Style.rowHeight
    //    implicitWidth: 500
    readonly property color m_color : Qt.tint(root.Kirigami.Theme.textColor, Qt.rgba(root.Kirigami.Theme.backgroundColor.r, root.Kirigami.Theme.backgroundColor.g, root.Kirigami.Theme.backgroundColor.b, 0.6))

    radius: Maui.Style.radiusV
    color : editMode ? _entryField.Kirigami.Theme.backgroundColor : Qt.lighter(Kirigami.Theme.backgroundColor)

    border.color: editMode ? control.Kirigami.Theme.highlightColor : "transparent"
    clip: false

    property int position: ToolBar.Header
    property bool mobile: false

    ProgressBar
    {
        id: _progress
        width: parent.width
        anchors.centerIn: parent
        value: _browserView.currentBrowser.loadProgress
        visible: _browserView.currentBrowser.loading
        indeterminate: true

        contentItem: Item {
            x: _progress.leftPadding
            y: _progress.topPadding
            width: _progress.availableWidth
            height: _progress.availableHeight

            scale: _progress.mirrored ? -1 : 1

            Repeater {
                model: 2

                Rectangle {
                    property real offset: 0

                    x: (_progress.indeterminate ? offset * parent.width : 0)
                    y: (parent.height - height) / 2
                    width: offset * (parent.width - x)
                    height: 4

                    color: "violet"

                    SequentialAnimation on offset {
                        loops: Animation.Infinite
                        running: _progress.indeterminate && _progress.visible
                        PauseAnimation { duration: index ? 520 : 0 }
                        NumberAnimation {
                            easing.type: Easing.OutCubic
                            duration: 1240
                            from: 0
                            to: 1
                        }
                        PauseAnimation { duration: index ? 0 : 520 }
                    }
                }
            }
        }

        background: null
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
                    list: Sol.History
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

        //        Rectangle
        //        {
        //            parent: ApplicationWindow.overlay
        //            visible: _entryField.activeFocus
        //            color: "red"
        //            x: parent.x
        //            y: 200
        //            width: parent.width
        //            height: 200
        //        }
    }

    MouseArea
    {
        visible: !editMode
        anchors.fill: parent
        onClicked:
        {
            editMode = true
            _entryField.forceActiveFocus()
        }

        Maui.ListItemTemplate
        {
            anchors.fill: parent
            label1.text:  _browserView.currentTab.title
            label1.horizontalAlignment: Qt.AlignHCenter
            label2.horizontalAlignment: Qt.AlignHCenter
            label2.font.pointSize: Maui.Style.fontSizes.small
            label2.text:  _browserView.currentTab.url
            imageSource:  _browserView.currentTab.iconName
            imageSizeHint: Maui.Style.iconSizes.medium
        }
    }
}
