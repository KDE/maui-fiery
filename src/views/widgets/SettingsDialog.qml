import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.3

import org.mauikit.controls 1.3 as Maui

Maui.SettingsDialog
{
    id: control

    Maui.SectionGroup
    {
        title: i18n("Navigation")
        description: i18n("Configure the app basic navigation features.")

        Maui.SectionItem
        {
            id: _homePageEntry
            label1.text: i18n("Home Page")
            label2.text: i18n("Page to load initially and default.")

            TextField
            {
                width: _homePageEntry.width - _homePageEntry.leftPadding - _homePageEntry.rightPadding
                text: appSettings.homePage
            }
        }

        Maui.SectionItem
        {
            id: _searchEngineEntry
            label1.text: i18n("Search Engine")
            label2.text: i18n("Engine to be use for default searching content.")

            TextField
            {
                width: _searchEngineEntry.width - _searchEngineEntry.leftPadding - _searchEngineEntry.rightPadding
                text: appSettings.searchEnginePage
            }
        }

        Maui.SectionItem
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

        Maui.SectionItem
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


    Maui.SectionItem
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
        id: _featuresComponent
        Maui.SettingsPage
        {
            title: i18n("Features")

            Maui.SectionGroup
            {
                Maui.SectionItem
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

                Maui.SectionItem
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

                Maui.SectionItem
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

    Maui.SectionItem
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
                Maui.SectionItem
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

                Maui.SectionItem
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

                Maui.SectionItem
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

                Maui.SectionItem
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

    Maui.SectionItem
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
                Maui.SectionItem
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

                Maui.SectionItem
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


                Maui.SectionItem
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

                Maui.SectionItem
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

                Maui.SectionItem
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

                Maui.SectionItem
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

                Maui.SectionItem
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
