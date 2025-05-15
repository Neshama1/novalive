import QtQuick
import QtQuick.Controls
import org.mauikit.controls as Maui

Maui.Page {
    id: notificationsPage

    property int rightStationIndex

    Maui.Controls.showCSD: true

    headBar.background: Rectangle {
        anchors.fill: parent
        Maui.Theme.inherit: false
        Maui.Theme.colorSet: Maui.Theme.View
        color: Maui.Theme.backgroundColor
    }

    headBar.rightContent: Maui.ToolButtonMenu
    {
        icon.name: "overflow-menu"
        MenuItem
        {
            text: i18n("Settings")
            icon.name: "settings-configure"
            onTriggered: settingsDialog.open()
        }
        MenuItem
        {
            text: "About"
            icon.name: "documentinfo"
            onTriggered: root.about()
        }
        MenuItem
        {
            text: "Add a radio station"
            icon.name: "radio"
            onTriggered: Qt.openUrlExternally("https://www.radio-browser.info/add")
        }

        MenuSeparator {}

        MenuItem
        {
            text: i18n("Light")
            checkable: true
            autoExclusive: true
            onTriggered: {
                Maui.Style.styleType = Maui.Style.Light
                styleType = Maui.Style.styleType
            }
            checked: Maui.Style.styleType === Maui.Style.Light
        }

        MenuItem
        {
            text: i18n("Dark")
            checkable: true
            autoExclusive: true
            onTriggered: {
                Maui.Style.styleType = Maui.Style.Dark
                styleType = Maui.Style.styleType
            }
            checked: Maui.Style.styleType === Maui.Style.Dark
        }

        MenuItem
        {
            text: i18n("Adaptive")
            checkable: true
            autoExclusive: true
            onTriggered: {
                Maui.Style.styleType = Maui.Style.Adaptive
                styleType = Maui.Style.styleType
            }
            checked: Maui.Style.styleType === Maui.Style.Adaptive
        }

        MenuItem
        {
            text: i18n("Custom")
            checkable: true
            autoExclusive: true
            onTriggered: {
                Maui.Style.styleType = Maui.Style.Auto
                styleType = Maui.Style.styleType
            }
            checked: Maui.Style.styleType === Maui.Style.Auto
        }

        MenuItem
        {
            text: i18n("White")
            checkable: true
            autoExclusive: true
            onTriggered: {
                Maui.Style.styleType = Maui.Style.Inverted
                styleType = Maui.Style.styleType
            }
            checked: Maui.Style.styleType === Maui.Style.Inverted
        }

        MenuItem
        {
            text: i18n("Black")
            checkable: true
            autoExclusive: true
            onTriggered: {
                Maui.Style.styleType = Maui.Style.TrueBlack
                styleType = Maui.Style.styleType
            }
            checked: Maui.Style.styleType === Maui.Style.TrueBlack
        }

        MenuItem
        {
            text: i18n("System")
            checkable: true
            autoExclusive: true
            onTriggered: {
                Maui.Style.styleType = undefined
                styleType = Maui.Style.styleType
            }
            checked: Maui.Style.styleType === undefined
        }
    }

    Component.onCompleted: {
        opacityAnimation.start()
        xAnimation.start()
    }

    PropertyAnimation {
        id: opacityAnimation
        target: notificationsPage
        properties: "opacity"
        from: 0
        to: 1.0
        duration: 250
    }

    PropertyAnimation {
        id: xAnimation
        target: notificationsPage
        properties: "x"
        from: -20
        to: 0
        duration: 500
    }

    // HOLDER

	Maui.Holder
	{
		anchors.fill: parent
		visible: notificationsModel.count == 0 ? true : false
		title: i18n("Notifications")
		body: i18n("Play a radio station, played titles will appear here")
		emoji: "notifications"
		isMask: false
	}

    Maui.ListBrowser {
        id: list
        anchors.fill: parent
        anchors.margins: 20

        horizontalScrollBarPolicy: ScrollBar.AsNeeded
        verticalScrollBarPolicy: ScrollBar.AsNeeded

        Component.onCompleted: {
            scale = 1
            opacity = 1
        }

        spacing: 13

        model: notificationsModel

        delegate: Rectangle {
            color: "transparent"
            width: ListView.view.width
            height: 50
            Maui.SwipeBrowserDelegate
            {
                anchors.fill: parent

                label1.text: station
                label2.text: title + " at " + time

                template.label1.font.pixelSize: 12
                template.label2.font.pixelSize: 11

                //iconSource: favicon
                iconSizeHint: Maui.Style.iconSizes.medium

                Behavior on scale {
                    NumberAnimation {
                        duration: 1000
                        easing.type: Easing.OutExpo
                    }
                }

                Behavior on opacity {
                    NumberAnimation { duration: 1000 }
                }

                scale: 0.80
                opacity: 0

                Component.onCompleted: {
                    scale = 1
                    opacity = 1
                }

                quickActions: [
                    Action
                    {
                        icon.name: "media-playback-start"
                        // text: "Play"
                        onTriggered: {
                            list.currentIndex = index
                            notificationsCurrentIndex = index
                            apiKeyYouTube == "" ? (
                                sideBarWidth = 0,
                                stackView.push("APIKeyYouTube1.qml")) : stackView.push("YouTube.qml")
                        }
                    }
                ]
            }
            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.RightButton
                onClicked: {
                    if (mouse.button == Qt.RightButton)
                    {
                        rightStationIndex = index
                        contextMenu.popup()
                    }
                }
                Menu {
                    id: contextMenu
                    MenuItem {
                        text: "Copy title"
                        icon.name: "edit-copy"
                        onTriggered: {
                            textEdit.text = notificationsModel.get(rightStationIndex).title
                            textEdit.selectAll()
                            textEdit.copy()
                        }
                    }
                }
                TextEdit{
                    // An invisible TextEdit can save the selected text in the clipboard
                    id: textEdit
                    visible: false
                }
            }
        }
    }
}
