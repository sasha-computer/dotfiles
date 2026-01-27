import QtQuick
import Quickshell.Services.Pipewire
import qs.Common
import qs.Modules.Plugins
import qs.Services
import qs.Widgets

PluginComponent {
    id: root

    property var popoutService: null

    property var nameOverrides: pluginData.nameOverrides || ({})

    function getDisplayName(node) {
        if (!node) return "Unknown"
        if (nameOverrides[node.name]) {
            return nameOverrides[node.name]
        }
        return AudioService.displayName(node)
    }

    popoutWidth: 300
    popoutHeight: Math.min(350, audioList.count * 56 + 60)

    horizontalBarPill: Component {
        Row {
            spacing: Theme.spacingXS

            DankIcon {
                name: {
                    if (!AudioService.sink) return "speaker"
                    const sinkName = AudioService.sink.name || ""
                    if (sinkName.includes("bluez")) return "headset"
                    if (sinkName.includes("hdmi")) return "tv"
                    if (sinkName.includes("usb")) return "headset"
                    return "speaker"
                }
                size: root.iconSize
                color: Theme.widgetIconColor
                anchors.verticalCenter: parent.verticalCenter
            }

            StyledText {
                text: {
                    if (!AudioService.sink) return "No Output"
                    const name = root.getDisplayName(AudioService.sink)
                    return name.length > 15 ? name.substring(0, 12) + "..." : name
                }
                font.pixelSize: Theme.barFontSize(root.barThickness)
                color: Theme.widgetTextColor
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }

    verticalBarPill: Component {
        Column {
            spacing: Theme.spacingXS

            DankIcon {
                name: {
                    if (!AudioService.sink) return "speaker"
                    const sinkName = AudioService.sink.name || ""
                    if (sinkName.includes("bluez")) return "headset"
                    if (sinkName.includes("hdmi")) return "tv"
                    if (sinkName.includes("usb")) return "headset"
                    return "speaker"
                }
                size: root.iconSize
                color: Theme.widgetIconColor
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }

    popoutContent: Component {
        Rectangle {
            id: popoutRect
            color: "transparent"
            implicitHeight: contentColumn.height + Theme.spacingL * 2

            Column {
                id: contentColumn
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.margins: Theme.spacingL
                spacing: Theme.spacingM

                Row {
                    width: parent.width
                    height: 32

                    StyledText {
                        text: "Audio Output"
                        font.pixelSize: Theme.fontSizeLarge
                        color: Theme.surfaceText
                        font.weight: Font.Medium
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                Repeater {
                    id: audioList
                    model: Pipewire.nodes.values.filter(node => node.audio && node.isSink && !node.isStream)

                    delegate: Rectangle {
                        required property var modelData
                        required property int index

                        width: contentColumn.width
                        height: 50
                        radius: Theme.cornerRadius
                        color: deviceMouse.containsMouse ? Qt.rgba(Theme.primary.r, Theme.primary.g, Theme.primary.b, 0.12) : Theme.withAlpha(Theme.surfaceContainerHighest, Theme.popupTransparency)
                        border.color: modelData === AudioService.sink ? Theme.primary : "transparent"
                        border.width: modelData === AudioService.sink ? 2 : 0

                        Row {
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.leftMargin: Theme.spacingM
                            spacing: Theme.spacingS

                            DankIcon {
                                name: {
                                    const n = modelData.name || ""
                                    if (n.includes("bluez")) return "headset"
                                    if (n.includes("hdmi")) return "tv"
                                    if (n.includes("usb")) return "headset"
                                    return "speaker"
                                }
                                size: Theme.iconSize - 4
                                color: modelData === AudioService.sink ? Theme.primary : Theme.surfaceText
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            Column {
                                anchors.verticalCenter: parent.verticalCenter
                                width: contentColumn.width - Theme.iconSize - Theme.spacingM * 3

                                StyledText {
                                    text: root.getDisplayName(modelData)
                                    font.pixelSize: Theme.fontSizeMedium
                                    color: Theme.surfaceText
                                    font.weight: modelData === AudioService.sink ? Font.Medium : Font.Normal
                                    elide: Text.ElideRight
                                    width: parent.width
                                }

                                StyledText {
                                    text: modelData === AudioService.sink ? "Active" : "Available"
                                    font.pixelSize: Theme.fontSizeSmall
                                    color: Theme.surfaceVariantText
                                }
                            }
                        }

                        MouseArea {
                            id: deviceMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                Pipewire.preferredDefaultAudioSink = modelData
                                ToastService.show("Audio: " + root.getDisplayName(modelData))
                            }
                        }
                    }
                }
            }

            PwObjectTracker {
                objects: Pipewire.nodes.values.filter(node => node.audio && !node.isStream)
            }
        }
    }
}
