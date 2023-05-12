import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.3
import QtWebEngine 1.10

import org.mauikit.controls 1.3 as Maui

import org.maui.fiery 1.0 as Fiery

Maui.Page
{
    id: control
    property alias currentTab : _browserListView.currentItem
    readonly property WebEngineView currentBrowser : currentTab.currentItem.webView
    property alias listView: _browserListView
    property alias count: _browserListView.count
    readonly property alias model : _browserListView.contentModel
    property alias searchFieldVisible: _searchField.visible

    property WebEngineProfile profile: Fiery.FieryWebProfile
    {
        //            httpUserAgent: tabs.currentItem.userAgent.userAgent
        //            offTheRecord: tabs.privateTabsMode
        //            storageName: tabs.privateTabsMode ? "Private" : Settings.profile

        //            questionLoader: rootPage.questionLoader
        //            urlInterceptor: typeof AdblockUrlInterceptor !== "undefined" && AdblockUrlInterceptor
    }



    footBar.middleContent: Maui.SearchField
    {
        id: _searchField
        visible: false
        Layout.maximumWidth: 500
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignHCenter
        onAccepted:  control.currentBrowser.findText(text)
        onCleared:  control.currentBrowser.findText("")
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

    Maui.TabView
    {
        id: _browserListView
        anchors.fill: parent
        holder.emoji: "qrc:/internet.svg"

        holder.title: i18n("Start Browsing")
        holder.body: i18n("Enter a new URL or open a recent site.")

        onNewTabClicked: control.openTab("")
        onCloseTabClicked: _browserListView.closeTab(index)
    }

    Component.onCompleted: openTab(appSettings.homePage)

    Component
    {
        id: _browserComponent

        BrowserLayout {}
    }

    function findTab(path) : Boolean
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

                                _browserListView.addTab(_browserComponent, {"url": _surf.formatUrl(path)});

                                    if(path.length === 0)
                                    {
                                        _navBar.openEditMode();
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
