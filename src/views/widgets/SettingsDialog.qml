import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import org.mauikit.controls as Maui

Maui.SettingsDialog
{
    id: control

    Maui.SectionGroup
    {
        title: i18n("Navigation")
        description: i18n("Configure the app basic navigation features.")


        Maui.FlexSectionItem
        {
            label1.text: i18n("Restore Session")
            label2.text: i18n("Open previous tabs.")

            Switch
            {
                Layout.fillHeight: true
                checkable: true
                checked:  appSettings.restoreSession
                onToggled: appSettings.restoreSession = ! appSettings.restoreSession
            }
        }

        Maui.FlexSectionItem
        {
            label1.text: i18n("Switch to Tab")
            label2.text: i18n("When opening a new link jump to the new tab.")

            Switch
            {
                Layout.fillHeight: true
                checkable: true
                checked:  appSettings.switchToTab
                onToggled: appSettings.switchToTab = ! appSettings.switchToTab
            }
        }

        Maui.FlexSectionItem
        {
            label1.text: i18n("Auto Load Images")
            label2.text: i18n("Automatically loads images on web pages.")

            Switch
            {
                Layout.fillHeight: true
                checkable: true
                checked:  appSettings.autoLoadImages
                onToggled: appSettings.autoLoadImages = ! appSettings.autoLoadImages
            }
        }

        Maui.FlexSectionItem
        {
            label1.text: i18n("Hyperlink Auditing")
            label2.text: i18n("Enables support for the ping attribute for hyperlinks.")

            Switch
            {
                Layout.fillHeight: true
                checkable: true
                checked:  appSettings.hyperlinkAuditingEnabled
                onToggled: appSettings.hyperlinkAuditingEnabled = ! appSettings.hyperlinkAuditingEnabled
            }
        }
    }

    Maui.FlexSectionItem
    {
        label1.text: i18n("General")
        label2.text: i18n("Configure global preferences.")

        ToolButton
        {
            icon.name: "go-next"
            checkable: true
            onToggled: control.addPage(_generalComponent)
        }
    }

    Maui.FlexSectionItem
    {
        label1.text: i18n("Features")
        label2.text: i18n("Configure the browser plugins and features.")

        ToolButton
        {
            icon.name: "go-next"
            checkable: true
            onToggled: control.addPage(_featuresComponent)
        }
    }

    Component
    {
        id: _generalComponent

        Maui.SettingsPage
        {
            title: i18n("General")

            Maui.SectionItem
            {
                label1.text: i18n("Home Page")
                label2.text: i18n("Page to load initially and default.")

                TextField
                {
                    Layout.fillWidth: true
                    text: appSettings.homePage
                }
            }

            Maui.SectionItem
            {
                label1.text: i18n("Search Engine")
                label2.text: i18n("Engine to be use for default searching content.")

                TextField
                {
                    Layout.fillWidth: true
                    text: appSettings.searchEnginePage
                }
            }

            Maui.SectionGroup
            {
                title: i18n("Downloads")

                Maui.SectionItem
                {
                    label1.text: i18n("Downloads Path")
                    label2.text: i18n("Pick a path where files will be saved.")

                    TextField
                    {
                        Layout.fillWidth: true
                        text: appSettings.downloadsPath
                    }
                }

                Maui.FlexSectionItem
                {
                    label1.text: i18n("Auto Save")
                    label2.text: i18n("Download files without asking.")

                    Switch
                    {
                        Layout.fillHeight: true
                        checkable: true
                        checked:  appSettings.autoSave
                        onToggled: appSettings.autoSave = ! appSettings.autoSave
                    }
                }

            }

        }
    }

    Component
    {
        id: _featuresComponent

        Maui.SettingsPage
        {
            title: i18n("Features")

            Maui.SectionGroup
            {
                Maui.FlexSectionItem
                {
                    label1.text: i18n("Accelerated 2D Canvas")
                    label2.text: i18n("Specifies whether the HTML 5 2D canvas should be an OpenGL framebuffer. This makes many painting operations faster, but slows down pixel access.")

                    Switch
                    {
                        Layout.fillHeight: true
                        checkable: true
                        checked:  appSettings.accelerated2dCanvasEnabled
                        onToggled: appSettings.accelerated2dCanvasEnabled = ! appSettings.accelerated2dCanvasEnabled
                    }
                }

                Maui.FlexSectionItem
                {
                    label1.text: i18n("PDF Viewer")
                    label2.text: i18n("PDF documents will be opened in the internal PDF viewer instead of being downloaded.")

                    Switch
                    {
                        Layout.fillHeight: true
                        checkable: true
                        checked:  appSettings.pdfViewerEnabled
                        onToggled: appSettings.pdfViewerEnabled = ! appSettings.pdfViewerEnabled
                    }
                }

                Maui.FlexSectionItem
                {
                    label1.text: i18n("Plugins Enabled")
                    label2.text: i18n("Enables support for Pepper plugins, such as the Flash player.")

                    Switch
                    {
                        Layout.fillHeight: true
                        checkable: true
                        checked:  appSettings.pluginsEnabled
                        onToggled: appSettings.pluginsEnabled = ! appSettings.pluginsEnabled
                    }
                }
            }
        }
    }

    Maui.FlexSectionItem
    {
        label1.text: i18n("JavaScript")
        label2.text: i18n("Configure JavaScript behaviour.")

        ToolButton
        {
            icon.name: "go-next"
            checkable: true
            onToggled: control.addPage(_jsComponent)
        }
    }


    Component
    {
        id: _jsComponent
        Maui.SettingsPage
        {
            title: i18n("JavaScript")

            Maui.SectionGroup
            {
                Maui.FlexSectionItem
                {
                    label1.text: i18n("Javascript Enabled")
                    label2.text: i18n("Enables the running of JavaScript programs.")

                    Switch
                    {
                        Layout.fillHeight: true
                        checkable: true
                        checked:  appSettings.javascriptEnabled
                        onToggled: appSettings.javascriptEnabled = ! appSettings.javascriptEnabled
                    }
                }

                Maui.FlexSectionItem
                {
                    label1.text: i18n("Javascript Can Access Clipboard")
                    label2.text: i18n("Allows JavaScript programs to read from or write to the clipboard.")

                    Switch
                    {
                        Layout.fillHeight: true
                        checkable: true
                        checked:  appSettings.javascriptCanAccessClipboard
                        onToggled: appSettings.javascriptCanAccessClipboard = ! appSettings.javascriptCanAccessClipboard
                    }
                }

                Maui.FlexSectionItem
                {
                    label1.text: i18n("Javascript Can Paste")
                    label2.text: i18n("Enables JavaScript execCommand(paste).")

                    Switch
                    {
                        Layout.fillHeight: true
                        checkable: true
                        checked:  appSettings.javascriptCanPaste
                        onToggled: appSettings.javascriptCanPaste = ! appSettings.javascriptCanPaste
                    }
                }

                Maui.FlexSectionItem
                {
                    label1.text: i18n("Allow Window Activation From JavaScript")
                    label2.text: i18n("Allows the window.focus() method in JavaScript.")

                    Switch
                    {
                        Layout.fillHeight: true
                        checkable: true
                        checked:  appSettings.allowWindowActivationFromJavaScript
                        onToggled: appSettings.allowWindowActivationFromJavaScript = ! appSettings.allowWindowActivationFromJavaScript
                    }
                }

            }
        }
    }

    Maui.FlexSectionItem
    {
        label1.text: i18n("Security & Privacy")
        label2.text: i18n("Configure the look and feel of the editor. The settings are applied globally")

        ToolButton
        {
            icon.name: "go-next"
            checkable: true
            onToggled: control.addPage(_privacyComponent)
        }
    }

    Component
    {
        id: _privacyComponent
        Maui.SettingsPage
        {
            title: i18n("Security & Privacy")

            Maui.SectionGroup
            {
                Maui.FlexSectionItem
                {
                    label1.text: i18n("Allow Geolocation On Insecure Origins")
                    label2.text: i18n("Only secure origins such as HTTPS have been able to request Geolocation features.")

                    Switch
                    {
                        Layout.fillHeight: true
                        checkable: true
                        checked:  appSettings.allowGeolocationOnInsecureOrigins
                        onToggled: appSettings.allowGeolocationOnInsecureOrigins = ! appSettings.allowGeolocationOnInsecureOrigins
                    }
                }

                Maui.FlexSectionItem
                {
                    label1.text: i18n("Allow Running Insecure Content")
                    label2.text: i18n("By default, HTTPS pages cannot run JavaScript, CSS, plugins or web-sockets from HTTP URLs.")

                    Switch
                    {
                        Layout.fillHeight: true
                        checkable: true
                        checked:  appSettings.allowRunningInsecureContent
                        onToggled: appSettings.allowRunningInsecureContent = ! appSettings.allowRunningInsecureContent
                    }
                }


                Maui.FlexSectionItem
                {
                    label1.text: i18n("DNS Prefetch Enabled")
                    label2.text: i18n("Enables speculative prefetching of DNS records for HTML links before they are activated.")

                    Switch
                    {
                        Layout.fillHeight: true
                        checkable: true
                        checked:  appSettings.dnsPrefetchEnabled
                        onToggled: appSettings.dnsPrefetchEnabled = ! appSettings.dnsPrefetchEnabled
                    }
                }

                Maui.FlexSectionItem
                {
                    label1.text: i18n("Local Content Can Access File Urls")
                    label2.text: i18n("Allows locally loaded documents to access other local URLs.")

                    Switch
                    {
                        Layout.fillHeight: true
                        checkable: true
                        checked:  appSettings.localContentCanAccessFileUrls
                        onToggled: appSettings.localContentCanAccessFileUrls = ! appSettings.localContentCanAccessFileUrls
                    }
                }

                Maui.FlexSectionItem
                {
                    label1.text: i18n("Local Content Can Access Remote Urls")
                    label2.text: i18n("Allows locally loaded documents to access remote URLs.")

                    Switch
                    {
                        Layout.fillHeight: true
                        checkable: true
                        checked:  appSettings.localContentCanAccessRemoteUrls
                        onToggled: appSettings.localContentCanAccessRemoteUrls = ! appSettings.localContentCanAccessRemoteUrls
                    }
                }

                Maui.FlexSectionItem
                {
                    label1.text: i18n("Local Storage")
                    label2.text: i18n("Enables support for the HTML 5 local storage feature.")

                    Switch
                    {
                        Layout.fillHeight: true
                        checkable: true
                        checked:  appSettings.localStorageEnabled
                        onToggled: appSettings.localStorageEnabled = ! appSettings.localStorageEnabled
                    }
                }

                Maui.FlexSectionItem
                {
                    label1.text: i18n("WebRTC Public Interfaces Only")
                    label2.text: i18n("Limits WebRTC to public IP addresses only. When disabled WebRTC may also use local network IP addresses, but remote hosts can also see your local network IP address.")

                    Switch
                    {
                        Layout.fillHeight: true
                        checkable: true
                        checked:  appSettings.webRTCPublicInterfacesOnly
                        onToggled: appSettings.webRTCPublicInterfacesOnly = ! appSettings.webRTCPublicInterfacesOnly
                    }
                }
            }
        }
    }
}
