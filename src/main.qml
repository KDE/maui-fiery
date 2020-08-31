import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.3
import org.kde.kirigami 2.7 as Kirigami
import org.kde.mauikit 1.2 as Maui
import QtWebView 1.1

Maui.ApplicationWindow
{
    id: root

    Maui.App.description: i18n("Nota allows you to edit text files.")
    Maui.App.handleAccounts: false


    Maui.Doodle
    {
        id: _doodleDialog
    }


    mainMenu: [

        MenuItem
        {
            text: i18n("Settings")
            icon.name: "settings-configure"
        },

        MenuItem
        {
            text: "Load plugin"
            icon.name: "plugin"
            onTriggered: _pluginLoader.open()
        }
    ]

    Component
    {
        id: _fileDialogComponent
        Maui.FileDialog
        {
            settings.onlyDirs: false
            settings.filterType: Maui.FMList.TEXT
            settings.sortBy: Maui.FMList.MODIFIED
            mode: modes.OPEN
        }
    }

    headBar.leftContent:  Maui.ToolActions
    {
        expanded: true
        autoExclusive: false
        checkable: false

        Action
        {
            text: i18n("Previous")
            icon.name: "go-previous"
        }

        Action
        {
            text: i18n("Next")
            icon.name: "go-next"
        }
    }

    headBar.middleContent: Maui.TextField
    {
        Layout.fillWidth: true
        onAccepted: _webView.url = text
    }

    headBar.rightContent: [
        ToolButton
        {
            icon.name: "tab-new"
        },

        ToolButton
        {
            icon.name: "document-download"
        }
    ]

    DropArea
    {
        id: _dropArea
        property var urls : []
        anchors.fill: parent
        onDropped:
        {
            if(drop.urls)
            {
                var m_urls = drop.urls.join(",")
                _dropArea.urls = m_urls.split(",")
                Nota.Nota.requestFiles( _dropArea.urls )
            }
        }
    }

//    Component.onCompleted:if(root.defaultBlankFile)
//    {
//        editorView.openTab("")
//    }


 WebView
 {
     id: _webView
     anchors.fill: parent
 }

}
