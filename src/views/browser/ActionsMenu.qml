import QtQuick 2.14
import QtQml 2.12
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.3

import QtWebEngine 1.10
import org.mauikit.controls 1.3 as Maui

Maui.ContextualMenu
{
    id: control
    property ContextMenuRequest request

    MenuItem
    {
        text: i18n("Open in new tab")
        onTriggered:
        {
            console.log(control.request.linkUrl)
            openTab(control.request.linkUrl)
        }
    }

    MenuItem
    {
        text: i18n("Download")
    }

    MenuItem
    {
        text: i18n("Inspect")
    }

    MenuItem
    {
        text: i18n("Search...")
    }
    MenuItem
    {
        text: i18n("Copy")
    }
    MenuItem
    {
        text: i18n("Copy link")
    }

}
