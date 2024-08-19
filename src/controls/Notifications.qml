import QtQuick 2.15
import QtQuick.Controls 2.15
import org.mauikit.controls 1.3 as Maui

Maui.Page {
    id: notificationsPage

    property int rightStationIndex

    showCSDControls: true

    headBar.background: Rectangle {
        anchors.fill: parent
        Maui.Theme.inherit: false
        Maui.Theme.colorSet: Maui.Theme.View
        color: Maui.Theme.backgroundColor
    }

    headBar.leftContent: Maui.ToolButtonMenu
    {
        icon.name: "application-menu"
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

                template.label1.font.pixelSize: 13
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
                        text: "Play"
                        onTriggered: {
                            list.currentIndex = index
                            notificationsCurrentIndex = index
                            apiKeyYouTube == "" ? stackView.push("qrc:/APIKeyYouTube1.qml") : stackView.push("qrc:/YouTube.qml")
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
