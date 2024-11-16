import QtQuick 2.14
import QtQml 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.3
import QtWebEngine 1.10

import org.mauikit.controls 1.3 as Maui

import org.maui.fiery 1.0 as Fiery

Maui.TabViewButton
{
    id: control

    property int position: control.TabBar.position

    readonly property WebEngineView webView : control.tabView.contentModel.get(control.mindex).browser.webView

    onClicked:
    {
       if(control.mindex === control.tabView.currentIndex)
       {
          openEditMode()
       }else
       {
           control.tabView.setCurrentIndex(control.mindex)
       }
    }

    onRightClicked:
    {
        control.tabView.openTabMenu(control.mindex)
    }

    //    text: control.hovered ? control.webView.url : control.webView.title

    icon.source:  control.webView.icon
    icon.color: "transparent"

    Maui.ProgressIndicator
    {
        id: _progress
        width: parent.width
        anchors.bottom: parent.bottom
        visible: webView.loading

    }
}
