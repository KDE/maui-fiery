import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.3
import org.kde.kirigami 2.7 as Kirigami
import org.mauikit.controls 1.2 as Maui

import "views/browser"

Maui.ApplicationWindow
{
    id: root

    Maui.App.handleAccounts: false

    autoHideHeader: true

    readonly property var views : ({browser: 0, tabs: 1, history: 2})

//    Component
//    {
//        id: _fileDialogComponent
//        Maui.FileDialog
//        {
//            settings.onlyDirs: false
//            settings.filterType: Maui.FMList.TEXT
//            settings.sortBy: Maui.FMList.MODIFIED
//            mode: modes.OPEN
//        }
//    }

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
        onAccepted:
        {
            if(_browserView.currentTab)
            {
                _browserView.currentTab.url = text
            }else
            {
                if(validURL(text))
                {
                }else
                {
                    _browserView.openTab("https://duckduckgo.com/?q="+text)
                }
            }
        }
    }

    headBar.rightContent: [
        ToolButton
        {
            icon.name: "tab-new"
            onClicked: _browserView.openTab("")
        },

        ToolButton
        {
            icon.name: "document-download"
        }
    ]

    Maui.AppViews
    {
        id: _swipeView
        anchors.fill: parent
        currentIndex: views.browser

        BrowserView
        {
            id: _browserView
        }
    }


        function validURL(str) {
          var pattern = new RegExp('^(https?:\\/\\/)?'+ // protocol
            '((([a-z\\d]([a-z\\d-]*[a-z\\d])*)\\.)+[a-z]{2,}|'+ // domain name
            '((\\d{1,3}\\.){3}\\d{1,3}))'+ // OR ip (v4) address
            '(\\:\\d+)?(\\/[-a-z\\d%_.~+]*)*'+ // port and path
            '(\\?[;&a-z\\d%_.~+=-]*)?'+ // query string
            '(\\#[-a-z\\d_]*)?$','i'); // fragment locator
          return !!pattern.test(str);
        }


}
