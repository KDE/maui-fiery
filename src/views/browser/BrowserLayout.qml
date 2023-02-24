import QtQuick 2.14
import QtQuick.Controls 2.14

import org.mauikit.controls 1.3 as Maui
import org.mauikit.filebrowsing 1.3 as FB

Item
{
    id: control

    height: ListView.view.height
    width: ListView.view.width

    Maui.TabViewInfo.tabTitle: title
    Maui.TabViewInfo.tabToolTipText:  currentItem.url

    property url url

    property alias currentIndex : _splitView.currentIndex
    property alias orientation : _splitView.orientation

    readonly property alias count : _splitView.count
    readonly property alias currentItem : _splitView.currentItem
    readonly property alias model : _splitView.contentModel
    readonly property string title : count === 2 ?  model.get(0).title + "  -  " + model.get(1).title : currentItem.title

    readonly property alias browser : _splitView.currentItem

    Keys.enabled: true
    Keys.onPressed:
    {
        if(event.key === Qt.Key_F3)
        {
            if(control.count === 2)
            {
                pop()
                return
            }//close the inactive split

            split("")
            event.accepted = true
        }

        if((event.key === Qt.Key_Space) && (event.modifiers & Qt.ControlModifier))
        {
            tabView.findTab()
            event.accepted = true
        }


        if(event.key === Qt.Key_F4)
        {
            control.terminalVisible = !control.terminalVisible
            event.accepted = true
        }
    }

        Maui.SplitView
        {
            id: _splitView

            anchors.fill: parent
            orientation: Qt.Horizontal

            Component.onCompleted: split(control.url)
        }

    Component
    {
        id: _browserComponent
        Browser
        {

        }
    }

    function split(path)
    {
               if(_splitView.count === 2)
        {
            return
        }

        _splitView.addSplit(_browserComponent, {'url': path})
    }

    function pop()
    {
        if(_splitView.count === 1)
        {
            return //can not pop all the browsers, leave at leats 1
        }

        closeSplit(_splitView.currentIndex === 1 ? 0 : 1)
    }

    function closeSplit(index) //closes a split but triggering a warning before
    {
        if(index >= _splitView.count)
        {
            return
        }

        const item = _splitView.itemAt(index)
        if( item.editor.document.modified)
        {
            _dialogLoader.sourceComponent = _unsavedDialogComponent
            dialog.callback = function () { destroyItem(index) }
            dialog.open()
            return
        } else
        {
            destroyItem(index)
        }
    }

    function destroyItem(index) //deestroys a split view withouth warning
    {
        _splitView.closeSplit(index)
    }
}


