import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.3
import QtWebEngine 1.7
import Qt.labs.settings 1.0

import org.mauikit.controls 1.3 as Maui

import org.maui.fiery 1.0 as Fiery

import "browser"
import "widgets"
import "history"
import "home"

Maui.SideBarView
{
    id: _sideBarView

    readonly property alias currentBrowser : _browserView.currentBrowser
    readonly property alias browserView : _browserView

    sideBar.autoShow: false
    sideBar.autoHide: true
    sideBar.preferredWidth: 400

    sideBar.content: Maui.Page
    {
        anchors.fill: parent
        Maui.Theme.colorSet: Maui.Theme.Window
        Maui.Theme.inherit: false

        headBar.middleContent: Maui.ToolActions
        {
            id: _sidebarActions
            autoExclusive: true

            display: ToolButton.IconOnly
            Layout.alignment: Qt.AlignHCenter

            Action
            {
                text: i18n("Home")
                icon.name: "go-home"
                checked: _sidebarSwipeView.currentIndex === 0
                onTriggered: _sidebarSwipeView.currentIndex = 0
            }

            Action
            {
                text: i18n("Recent")
                icon.name: "shallow-history"
                checked: _sidebarSwipeView.currentIndex === 1
                onTriggered: _sidebarSwipeView.currentIndex = 1
            }

            Action
            {
                text: i18n("Downloads")
                icon.name: "folder-download"
                checked: _sidebarSwipeView.currentIndex === 2
                onTriggered: _sidebarSwipeView.currentIndex = 2
            }
        }

        SwipeView
        {
            anchors.fill: parent
            id: _sidebarSwipeView

            Loader
            {
                active: visible
                asynchronous: true
                sourceComponent:  HomeView {}
            }


            Loader
            {
                active: visible
                asynchronous: true
                sourceComponent: HistoryView {}
            }


            Loader
            {
                active: visible
                asynchronous: true
                sourceComponent:  Maui.Page
                {

                    Maui.ListBrowser
                    {
                        anchors.fill: parent
                        model: Fiery.DownloadsManager.model

                        holder.title: i18n("Downloads")
                        holder.body: i18n("Your downloads will be listed in here.")
                        holder.emoji: "download"
                        holder.visible: count === 0

                        delegate: Maui.ListBrowserDelegate
                        {
                            id: _downloadDelegate

                            width: ListView.view.width

                            label1.text: model.name
                            label2.text: model.url
                            iconSource: download.state === WebEngineDownloadItem.DownloadCompleted ? model.filePath : model.icon

                            property WebEngineDownloadItem download : model.download

                            onClicked: Qt.openUrlExternally(model.filePath)

                            ToolButton
                            {

                                visible: !_downloadDelegate.download.isPaused && _downloadDelegate.download.state === WebEngineDownloadItem.DownloadInProgress
                                text: i18n("Pause")
                                icon.name: "media-playback-pause"
                                onClicked: _downloadDelegate.download.pause()
                            }

                            ToolButton
                            {
                                visible: _downloadDelegate.download.isPaused && _downloadDelegate.download.state === WebEngineDownloadItem.DownloadInProgress
                                text: i18n("Continue")
                                icon.name: "media-playback-start"
                                onClicked: _downloadDelegate.download.resume();
                            }

                            ToolButton
                            {
                                icon.name: _downloadDelegate.download.state === WebEngineDownloadItem.DownloadInProgress ? "dialog-cancel" : "list-remove"
                            }

                        }
                    }
                }
            }
        }
    }

    BrowserView
    {
        id: _browserView
        anchors.fill: parent

    }

    function openHistory()
    {
        _sideBarView.sideBar.open()
        _sidebarSwipeView.setCurrentIndex(1)
    }

    function openBookmarks()
    {
        _sideBarView.sideBar.open()
        _sidebarSwipeView.setCurrentIndex(0)
    }

    function openDownloads()
    {
        _sideBarView.sideBar.open()
        _sidebarSwipeView.setCurrentIndex(2)
    }
}


