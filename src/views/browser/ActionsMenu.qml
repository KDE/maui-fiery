import QtQuick
import QtQml
import QtQuick.Controls
import QtQuick.Layouts

import QtWebEngine
import org.mauikit.controls as Maui

Maui.ContextualMenu
{
    id: control
    property ContextMenuRequest request
    property WebEngineView webView

    property bool isValidUrl: request && request.linkUrl != "" // not strict equality
    property bool isAudio: request && request.mediaType === ContextMenuRequest.MediaTypeAudio
    property bool isImage: request && request.mediaType === ContextMenuRequest.MediaTypeImage
    property bool isVideo: request && request.mediaType === ContextMenuRequest.MediaTypeVideo

    Maui.MenuItemActionRow
    {
        Action
        {
            icon.name: "edit-undo"
            enabled:   request.editFlags & ContextMenuRequest.CanUndo
        }

        Action
        {
            icon.name: "edit-redo"
            enabled:   request.editFlags & ContextMenuRequest.CanRedo
        }

        Action
        {
            icon.name: "edit-cut"
            enabled:   request.editFlags & ContextMenuRequest.CanCut
        }
    }

    MenuItem
    {
        text: i18n("Paste")
        height: visible? implicitHeight : 00 - control.spacing
        visible:  request.editFlags & ContextMenuRequest.CanPaste
        onTriggered:
        {
            //            control.close()
            _webView.triggerWebAction(WebEngineView.Paste);
            //            pasteAction.trigger()
        }
    }

    MenuItem
    {
        text: i18n("Translate")
        height: visible? implicitHeight : 00 - control.spacing
        visible:  request.editFlags & ContextMenuRequest.CanTranslate
        onTriggered:
        {
            _webView.triggerWebAction(WebEngineView.Tran);
        }
    }

    MenuItem
    {
        text: i18n("Select All")
        height: visible? implicitHeight : 00 - control.spacing
        visible:  request.editFlags & ContextMenuRequest.CanSelectAll
        onTriggered:
        {
            webView.triggerWebAction(WebEngineView.SelectAll);
        }
    }


    MenuItem
    {
        text: i18n("Copy Text")
        height: visible? implicitHeight : 00 - control.spacing
        visible:  request.editFlags & ContextMenuRequest.CanCopy
        onTriggered:
        {
            Maui.Handy.copyTextToClipboard(control.request.selectedText)
        }
    }

    MenuItem
    {
        text: i18n("Copy Link")
        height: visible? implicitHeight : 00 - control.spacing
        visible: control.isValidUrl
        onTriggered:
        {
            Maui.Handy.copyTextToClipboard(control.request.linkUrl)
        }
    }

    MenuItem
    {
        text: i18n("Open Link")
        height: visible? implicitHeight : 00 - control.spacing
        visible: control.isValidUrl
        onTriggered:
        {
            openTab( control.request.linkUrl);
        }
    }

    MenuItem
    {
        text: i18n("Open Link in Split View")
        height: visible? implicitHeight : 00 - control.spacing
        visible: control.isValidUrl
        onTriggered:
        {
            openSplit( control.request.linkUrl);
        }
    }

    MenuItem
    {
        text: i18n("Open Link in New Window")
        height: visible? implicitHeight : 00 - control.spacing
        visible: control.isValidUrl
        onTriggered:
        {
            newWindow([control.request.linkUrl]);
        }
    }


    MenuItem
    {
        property string fullText: control.request ? control.request.selectedText || control.request.linkText : ""
        property string elidedText: fullText.length > 25 ? fullText.slice(0, 25) + "..." : fullText
        height: visible? implicitHeight : 00 - control.spacing
        visible: control.request && fullText
        text:  i18n('Search for "%1"', elidedText)
        onTriggered:
        {

            openTab(appSettings.searchEnginePage+ fullText);

        }
    }

    MenuItem
    {
        height: visible? implicitHeight : 0 - control.spacing
        visible: control.isVideo
        text: i18n("Save Video")
        onTriggered: webView.triggerWebAction(WebEngineView.DownloadMediaToDisk)
    }

    MenuItem
    {
        height: visible? implicitHeight : 00 - control.spacing
        visible: (control.isAudio || control.isVideo) && control.request.mediaUrl !== url
        text: control.isVideo ? i18n("Open Video") : i18n("Open Audio")
        onTriggered:
        {
            openTab(control.request.mediaUrl)
        }
    }

    MenuItem
    {
        height: visible? implicitHeight : 00 - control.spacing
        visible: control.isImage
        text: i18n("Save Image")
        onTriggered: webView.triggerWebAction(WebEngineView.DownloadImageToDisk)
    }

    MenuItem
    {
        height: visible? implicitHeight : 00 - control.spacing
        visible: control.isImage
        text: i18n("Copy Image")
        onTriggered: webView.triggerWebAction(WebEngineView.CopyImageToClipboard)
    }

    MenuItem
    {
        height: visible? implicitHeight : 00 - control.spacing
        visible: control.isImage && control.request.mediaUrl !== url
        text: i18n("Open Image")
        onTriggered:
        {
            openTab(control.request.mediaUrl)
        }
    }

    MenuItem
    {
        height: visible? implicitHeight : 00 - control.spacing
        visible: control.isAudio || control.isVideo
        text: control.request && control.request.mediaFlags & ContextMenuRequest.MediaPaused
              ? i18n("Play")
              : i18n("Pause")
        onTriggered: webView.triggerWebAction(WebEngineView.ToggleMediaPlayPause)
    }

    MenuItem
    {
        height: visible? implicitHeight : 00 - control.spacing
        visible: control.request && control.request.mediaFlags & ContextMenuRequest.MediaHasAudio
        text:  control.request && control.request.mediaFlags & ContextMenuRequest.MediaMuted
               ? i18n("Unmute")
               : i18n("Mute")
        onTriggered: webView.triggerWebAction(WebEngineView.ToggleMediaMute)
    }

    MenuItem
    {
        height: visible? implicitHeight : 00 - control.spacing
        visible: webView.settings.javascriptEnabled && (control.isAudio || control.isVideo)
        contentItem: RowLayout
        {
            Label
            {
                Layout.fillWidth: true
                text: i18n("Speed")
            }

            SpinBox
            {
                value: control.playbackRate
                from: 25
                to: 1000
                stepSize: 25
                onValueModified: {
                    control.playbackRate = value
                    const point = control.request.x + ', ' + control.request.y
                    const js = 'document.elementFromPoint(' + point + ').playbackRate = ' + control.playbackRate / 100 + ';'
                    webView.runJavaScript(js)
                }
                textFromValue: function(value, locale) {
                    return Number(value / 100).toLocaleString(locale, 'f', 2)
                }
            }
        }
    }

    MenuItem
    {
        height: visible? implicitHeight : 0 - control.spacing
        visible: control.isAudio || control.isVideo
        text: i18n("Loop")
        checked: control.request && control.request.mediaFlags & ContextMenuRequest.MediaLoop
        onTriggered: webView.triggerWebAction(WebEngineView.ToggleMediaLoop)
    }

    MenuItem
    {
        height: visible? implicitHeight : 0 - control.spacing
        visible: webView.settings.javascriptEnabled && control.isVideo
        text: webView.isFullScreen ? i18n("Exit fullscreen") : i18n("Fullscreen")
        onTriggered: {
            const point = control.request.x + ', ' + control.request.y
            const js = webView.isFullScreen
                     ? 'document.exitFullscreen()'
                     : 'document.elementFromPoint(' + point + ').requestFullscreen()'
            webView.runJavaScript(js)
        }
    }

    MenuItem
    {
        height: visible? implicitHeight : 0 - control.spacing
        visible: webView.settings.javascriptEnabled && (control.isAudio || control.isVideo)
        text: control.request && control.request.mediaFlags & ContextMenuRequest.MediaControls
              ? i18n("Hide controls")
              : i18n("Show controls")
        onTriggered: webView.triggerWebAction(WebEngineView.ToggleMediaControls)
    }

}
