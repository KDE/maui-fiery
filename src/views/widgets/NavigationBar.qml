import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.3
import org.kde.kirigami 2.7 as Kirigami
import org.mauikit.controls 1.2 as Maui

Rectangle
{
    id: control

    implicitHeight: Maui.Style.rowHeight
//    implicitWidth: 500
    readonly property color m_color : Qt.tint(root.Kirigami.Theme.textColor, Qt.rgba(root.Kirigami.Theme.backgroundColor.r, root.Kirigami.Theme.backgroundColor.g, root.Kirigami.Theme.backgroundColor.b, 0.6))

    radius: Maui.Style.radiusV
    color : editMode ? _entryField.Kirigami.Theme.backgroundColor : Qt.rgba(m_color.r, m_color.g, m_color.b, 0.3)

    border.color: editMode ? control.Kirigami.Theme.highlightColor : "transparent"

    ProgressBar
    {
        id: _progressBar
        anchors.fill: parent
        from : 0
        to : 1
        value: _browserView.currentBrowser.loadProgress
        visible: _browserView.currentBrowser.loading

        background: Rectangle {
                implicitWidth: 200
                implicitHeight: 6
                color: "transparent"
                radius: control.radius
            }

            contentItem: Item {
                implicitWidth: 200
                implicitHeight: 4

                Rectangle {
                    width: _progressBar.visualPosition * parent.width
                    height: parent.height
                    radius: control.radius
                    color: control.Kirigami.Theme.highlightColor
                    opacity: 0.3
                }
            }
    }

    Maui.TextField
    {
        id: _entryField
        visible: editMode
        anchors.fill: parent
        placeholderText: i18n("Search or enter URL")
        text: _browserView.currentTab.url
        onAccepted:
        {
            _browserView.openUrl(text)
            root.editMode = false
        }

        background: null

        actions: Action
        {
            icon.name: "love"
        }
    }

    MouseArea
    {
        visible: !editMode
        anchors.fill: parent
        onClicked:
        {
            editMode = true
            _entryField.forceActiveFocus()
        }

        Maui.ListItemTemplate
        {
            anchors.fill: parent
            label1.text:  _browserView.currentTab.title
            label1.horizontalAlignment: Qt.AlignHCenter
            label2.horizontalAlignment: Qt.AlignHCenter
            label2.font.pointSize: Maui.Style.fontSizes.small
            label2.text:  _browserView.currentTab.url
            imageSource:  _browserView.currentTab.iconName
            imageSizeHint: Maui.Style.iconSizes.medium
        }
    }
}
