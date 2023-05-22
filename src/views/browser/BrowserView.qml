import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import QtWebEngine 1.10

import org.mauikit.controls 1.3 as Maui

import org.maui.fiery 1.0 as Fiery

import "../widgets"

Maui.Page
{
    id: control
    property alias currentTab : _browserListView.currentItem
    readonly property WebEngineView currentBrowser : currentTab.currentItem.webView
    property alias listView: _browserListView
    property alias count: _browserListView.count
    readonly property alias model : _browserListView.contentModel
    property alias searchFieldVisible: control.footBar.visible


    headBar.visible: !root.isWide
    altHeader: true
    headBar.rightContent: Loader
    {
        asynchronous: true
        active: !root.isWide
        visible: active
        sourceComponent: _browserMenuComponent
    }

    headBar.leftContent: Loader
    {
        asynchronous: true
        active: !root.isWide
        visible: active
        sourceComponent: _navigationControlsComponent
    }

    footBar.visible: false
    footBar.middleContent: Maui.SearchField
    {
        id: _searchField

        Layout.maximumWidth: 500
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignHCenter
        onAccepted: control.currentBrowser.findText(text)
        onCleared: control.currentBrowser.findText("")
        actions: [

            Action
            {
                icon.name: "go-up"
                onTriggered:
                {
                    console.log("Find previous")
                    control.currentBrowser.findText(_searchField.text, WebEngineView.FindBackward)
                }
            },

            Action
            {
                icon.name: "go-down"
                onTriggered:
                {

                    console.log("Find next")

                    control.currentBrowser.findText(_searchField.text)
                }
            }
        ]
    }

    Shortcut
    {
        sequence: "Ctrl+K"
        onActivated: _navigationPopup.open()
    }

    Maui.Dialog
    {
        id: _navigationPopup

        maxHeight: 900
        maxWidth: 500
        hint: 1
        persistent: true
        headBar.visible: true
        page.altHeader: _browserListView.altTabBar

        onOpened:
        {
            _entryField.forceActiveFocus()
            _entryField.selectAll()
        }

        defaultButtons: false

        headBar.forceCenterMiddleContent: false
        headBar.middleContent: Maui.SearchField
        {
            id: _entryField
            Layout.fillWidth: true
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

                _navigationPopup.close()
            }

            Keys.forwardTo: _historyListView
        }


        stack: Maui.ListBrowser
        {
            id: _historyListView
            clip: true

            Layout.fillWidth: true
            Layout.fillHeight: true
            currentIndex: -1

            orientation: ListView.Vertical
            spacing: Maui.Style.space.medium

            flickable.header: ColumnLayout
            {
                width: parent.width
                spacing: _historyListView.spacing

                Maui.ListBrowserDelegate
                {
                    Layout.fillWidth: true
                    label1.text: _entryField.text
                    label2.text: i18n("Search on default search engine")

                    iconSource: "edit-find"
                    iconSizeHint: Maui.Style.iconSizes.medium

                    onClicked:
                    {
                        _browserView.openUrl(model.url)
                        _historyListView.close()
                    }
                }

                Maui.ListBrowserDelegate
                {
                    Layout.fillWidth: true
                    label1.text: _entryField.text
                    label2.text: i18n("Search on page.")

                    iconSource: "edit-find"
                    iconSizeHint: Maui.Style.iconSizes.medium

                    onClicked:
                    {
                         control.currentBrowser.findText(_entryField.text)
                        _historyListView.close()
                    }
                }
            }

            Keys.onEnterPressed:
            {
                _browserView.openUrl(_historyListView.currentItem.url)
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
                    _navigationPopup.close()
                }
            }
        }
    }

    Maui.TabView
    {
        id: _browserListView
        anchors.fill: parent
        holder.emoji: "qrc:/internet.svg"

        holder.title: i18n("Start Browsing")
        holder.body: i18n("Enter a new URL or open a recent site.")

        onNewTabClicked: openTab("")
        onCloseTabClicked: _browserListView.closeTab(index)

        menuActions: Action
        {
            text: i18n("Detach")
            onTriggered:
            {
                let index = _browserListView.menu.index
                console.log("TAB INDEX CLICKED", index)
                var urls = _browserListView.tabAt(index).urls
                console.log("TAB URLS CLICKED", urls)

                //                console.log("DEATCH TAB", urls)
                newWindow(urls)
                _browserListView.closeTab(index)
            }
        }

        tabViewButton : NavigationBar
        {
            tabView: _browserListView
        }

        tabBar.showNewTabButton: false
        tabBar.visible: true
        altTabBar: Maui.Handy.isMobile
        tabBar.rightContent: [
            Loader
            {
                asynchronous: true
                active: root.isWide
                visible: active
                sourceComponent: _browserMenuComponent
            },

            Maui.WindowControls {}
        ]

        tabBar.leftContent: Loader
        {
            asynchronous: true
            active: root.isWide
            visible: active
            sourceComponent: _navigationControlsComponent
        }
    }

    Component.onCompleted: openTab(appSettings.homePage)

    Component
    {
        id: _browserComponent

        BrowserLayout {}
    }

    Component
    {
        id: _navigationControlsComponent

        Row
        {
            spacing: control.headBar.spacing

            ToolButton
            {
                icon.name: _sideBarView.sideBar.visible ? "sidebar-collapse" : "sidebar-expand"
                onClicked: _sideBarView.sideBar.toggle()
                checked: _sideBarView.sideBar.visible
                visible: _sideBarView.sideBar.visible && !_sideBarView.sideBar.collapsed
                ToolTip.delay: 1000
                ToolTip.timeout: 5000
                ToolTip.visible: hovered
                ToolTip.text: i18n("Toggle sidebar")
            }

            Maui.ToolActions
            {
                display: ToolButton.IconOnly
                Action
                {
                    enabled: currentBrowser.canGoBack
                    onTriggered: currentBrowser.goBack()
                    text: i18n("Previous")

                    icon.name: "go-previous"
                }

                Action
                {
                    text: i18n("Next")
                    enabled: currentBrowser.canGoForward
                    icon.name: "go-next"
                    onTriggered: currentBrowser.goForward()
                }
            }

            ToolButton
            {
                text: _browserListView.count
                visible: _browserListView.count > 1
                onClicked: _browserListView.openOverview()
                icon.name: "view-group"
            }
        }
    }

    Component
    {
        id: _browserMenuComponent

        Row
        {
            spacing: control.headBar.spacing

            ToolButton
            {
                icon.name: "list-add"
                onClicked: control.openTab("")
            }

            ToolButton
            {
                icon.name: "view-refresh"
                onClicked: currentBrowser.reload()
            }

            Maui.ToolButtonMenu
            {
                icon.name: "overflow-menu"

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
                        text: i18n("Share")
                        icon.name: "edit-share"
                    }
                }

                Maui.ToolActions
                {
                    autoExclusive: false
                    checkable: false

                    Action
                    {
                        icon.name: "zoom-out"
                        onTriggered:
                        {
                            appSettings.zoomFactor = Math.max(appSettings.zoomFactor-0.25, 0.25)
                        }
                    }

                    Action
                    {
                        icon.name: "zoom-fit-page"
                        onTriggered:
                        {
                            appSettings.zoomFactor = 1.0
                        }
                    }

                    Action
                    {
                        icon.name: "zoom-in"
                        onTriggered:
                        {
                            appSettings.zoomFactor = Math.min(appSettings.zoomFactor+0.25, 5.0)
                        }
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
                    text: i18n("Bookmarks")
                    icon.name: "bookmarks"
                    onTriggered: openBookmarks()
                }

                MenuItem
                {
                    text: i18n("History")
                    icon.name: "deep-history"
                    onTriggered: openHistory()

                }

                MenuItem
                {
                    text: i18n("Downloads")
                    icon.name: "folder-downloads"
                    onTriggered: openDownloads()

                }

                MenuSeparator {}

                MenuItem
                {
                    text: i18n("Find In Page")
                    icon.name: "edit-find"
                    checked: _browserView.searchFieldVisible
                    onTriggered: _browserView.searchFieldVisible = !_browserView.searchFieldVisible
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

    function openEditMode()
    {
        _navigationPopup.open()
    }

    function findTab(path)
    {
        var index = browserIndex(path)

        if(index[0] >= 0 && index [1] >= 0)
        {

            _browserListView.currentIndex = index[0]

            var tab = control.model.get(index[0])
            tab.currentIndex = index[1]
            return true;
        }

        return false;
    }

    function browserIndex(path) //find the [tab, split] index for a path
    {
        if(path.length === 0)
        {
            return [-1, -1]
        }

        for(var i = 0; i < control.count; i++)
        {
            const tab =  control.model.get(i)
            for(var j = 0; j < tab.count; j++)
            {
                const browser = tab.model.get(j)
                if(browser.url.toString() === path)
                {
                    return [i, j]
                }
            }
        }
        return [-1,-1]
    }

    function openTab(path)
    {
        if(findTab(path))
        {
            return;
        }

        _browserListView.addTab(_browserComponent, {"url": _surf.formatUrl(path)}, !appSettings.switchToTab && path.length > 0);

        if(path.length === 0)
        {
            openEditMode()
        }

    }

    function openSplit(path)
    {
        console.log(currentTab.count)
        if(currentTab.count === 1)
        {
            currentTab.split(path)
            return
        }

        openTab(path)
    }

    function openUrl(path)
    {

        if(validURL(path))
        {
            control.currentBrowser.url = path
        }else
        {
            control.currentBrowser.url = appSettings.searchEnginePage+path
        }

        control.currentTab.forceActiveFocus()
    }

    function validURL(str)
    {
        var pattern = new RegExp('^(https?:\\/\\/)?'+ // protocol
                                 '((([a-z\\d]([a-z\\d-]*[a-z\\d])*)\\.)+[a-z]{2,}|'+ // domain name
                                 '((\\d{1,3}\\.){3}\\d{1,3}))'+ // OR ip (v4) address
                                 '(\\:\\d+)?(\\/[-a-z\\d%_.~+]*)*'+ // port and path
                                 '(\\?[;&a-z\\d%_.~+=-]*)?'+ // query string
                                 '(\\#[-a-z\\d_]*)?$','i'); // fragment locator
        return !!pattern.test(str);
    }

}
