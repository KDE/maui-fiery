import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.3
import org.kde.kirigami 2.7 as Kirigami
import org.kde.mauikit 1.2 as Maui

import QtQml.Models 2.3

Maui.Page
{
    id: control
    property alias currentTab : _browserListView.currentItem
    property alias listView: _browserListView
    property alias count: _browserListView.count
    readonly property alias model : _browserModel

    ObjectModel
    {
        id: _browserModel
    }

    header: Maui.TabBar
    {
        id: _tabBar
        visible: _browserListView.count > 1
        width: parent.width
        position: TabBar.Header
        currentIndex : _browserListView.currentIndex
        onNewTabClicked: openTab("")

        Repeater
        {
            id: _repeater
            model: _browserModel.count

            Maui.TabButton
            {
                id: _tabButton
                readonly property int index_ : index
                implicitHeight: _tabBar.implicitHeight
                implicitWidth: Math.max(parent.width / _repeater.count, 120)
                checked: index === _tabBar.currentIndex

                text: _browserModel.get(index).title

                onClicked: _browserListView.currentIndex = index
                onCloseClicked:
                {
//                    if( _browserModel.get(model.index).editor.document.modified)
//                    {
//                        _saveDialog.fileIndex = model.index
//                        _saveDialog.open()
//                    }
//                    else
//                        closeTab(model.index)
                }

//                Maui.Dialog
//                {
//                    id: _saveDialog
//                    property int fileIndex
//                    page.padding: Maui.Style.space.huge
//                    title: i18n("Save file")
//                    message: i18n(String("This file has been modified, you can save your changes now or discard them.\n")) + _browserModel.get(_tabButton.index).path

//                    acceptButton.text: i18n("Save")
//                    rejectButton.text: i18n("Discard")

//                    onAccepted:
//                    {
//                        _browserModel.get(fileIndex).saveFile(_browserModel.get(fileIndex).path, fileIndex)
//                        closeTab(fileIndex)
//                        _saveDialog.close()
//                    }

//                    onRejected:
//                    {
//                        _saveDialog.close()
//                        closeTab(fileIndex)
//                    }
//                }
            }
        }
    }

    Maui.Holder
    {
        id: _holder
        visible: !_browserListView.count
        emoji: "qrc:/img/document-edit.svg"
        emojiSize: Maui.Style.iconSizes.huge
        isMask: true
        onActionTriggered: openTab("")
        title: i18n("Create a new document")
        body: i18n("You can create a new document by clicking the New File button, or here.<br>
        Alternative you can open existing files from the left places sidebar or by clicking the Open button")
    }

    ListView
    {
        id: _browserListView
        anchors.fill: parent
        orientation: ListView.Horizontal
        model: _browserModel
        snapMode: ListView.SnapOneItem
        spacing: 0
//        interactive: Maui.Handy.isTouch && count > 1
        highlightFollowsCurrentItem: true
        highlightMoveDuration: 0
        highlightResizeDuration : 0
        onMovementEnded: currentIndex = indexAt(contentX, contentY)
        clip: true
    }

    function openTab(path)
    {
        _swipeView.currentIndex = views.browser

        var component = Qt.createComponent("qrc:/views/browser/Browser.qml");
        if (component.status === Component.Ready)
        {
            _browserModel.append(component.createObject(_browserModel, {"url": path}));

            _browserListView.currentIndex = _browserModel.count - 1
        }
    }

    function closeTab(index)
    {
//        console.log("CLOSING FILE", index, _editorList.count, _browserModel.count)
//        _editorList.remove(index)
//        _browserModel.remove(index)
//        console.log("CLOSING FILE", index, _editorList.count, _browserModel.count)
    }

}
