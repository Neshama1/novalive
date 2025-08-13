import QtQuick
import QtQuick.Controls
import org.mauikit.controls as Maui
import Qt.labs.settings
import QtMultimedia

Maui.Page {
    id: favoritesPage

    Maui.Controls.showCSD: true

    property int rightStationIndex

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
            text: i18n("System")
            checkable: true
            autoExclusive: true
            onTriggered: {
                Maui.Style.styleType = themeManager.styleType
                styleType = Maui.Style.Auto
            }
            checked: styleType === Maui.Style.Auto
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
    }

    Component.onCompleted: {
        opacityAnimation.start()
        xAnimation.start()

        playingInfo.text = playingInfoOnChangedPage
    }

    PropertyAnimation {
        id: opacityAnimation
        target: favoritesPage
        properties: "opacity"
        from: 0
        to: 1.0
        duration: 250
    }

    PropertyAnimation {
        id: xAnimation
        target: favoritesPage
        properties: "x"
        from: -20
        to: 0
        duration: 500
    }

    // HOLDER

	Maui.Holder
	{
		anchors.fill: parent
		visible: favoritesModel.count == 0 ? true : false
		title: i18n("Favorite")
		body: i18n("Add radio stations to my favorites")
		emoji: "favorite"
		isMask: false
	}

    Maui.GridBrowser {
        id: grid
        anchors.fill: parent
        anchors.margins: 20
        itemSize: 200
        itemHeight: 100
        adaptContent: true
        horizontalScrollBarPolicy: ScrollBar.AsNeeded
        verticalScrollBarPolicy: ScrollBar.AsNeeded

        model: favoritesModel

        delegate: Rectangle {
            color: "transparent"
            width: GridView.view.cellWidth
            height: GridView.view.cellHeight
            Rectangle {
                anchors.fill: parent
                anchors.margins: 10
                radius: 4
                color: Maui.Theme.alternateBackgroundColor

                Label {
                    anchors.centerIn: parent
                    width: parent.width - 20
                    height: parent.height - 20
                    horizontalAlignment: Text.AlignHCenter
                    text: name
                    font.pixelSize: 15
                    elide: Text.ElideRight
                }
            }
            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                onClicked: {
                    if (mouse.button == Qt.LeftButton)
                    {
                        grid.currentIndex = index
                        currentStation = favoritesModel.get(grid.currentIndex).name
                        playingInfo.text = currentStation
                        playingInfoOnChangedPage = playingInfo.text
                        player.pause = true
                        player.loadFile(favoritesModel.get(grid.currentIndex).url_resolved)
                        player.pause = false
                        stationLoaded = false
                    }
                    if (mouse.button == Qt.RightButton)
                    {
                        rightStationIndex = index
                        contextMenu.popup()
                    }
                }
                Menu {
                    id: contextMenu
                    MenuItem {
                        text: "Remove"
                        icon.name: "remove"
                        onTriggered: {
                            favoritesModel.remove(rightStationIndex)
                            saveFavorites()
                        }
                    }
                    MenuItem {
                        text: "Visit website"
                        icon.name: "go-home"
                        onTriggered: {
                            Qt.openUrlExternally(favoritesModel.get(rightStationIndex).homepage)
                        }
                    }
                }
            }
        }
    }

    Maui.FloatingButton
    {
        id: playButton
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.margins: 20
        width: 60
        height: width
        icon.name: player.pause ? "media-playback-start" : "media-playback-stop"
        onClicked: player.pause = !player.pause
    }

    Maui.FloatingButton
    {
        id: playingInfo
        anchors.bottom: parent.bottom
        anchors.right: playButton.left
        anchors.margins: 20
        visible: player.pause ? false : true
        width: 100
        height: 60
        background: Rectangle {
            anchors.fill: parent
            radius: 4
            color: Maui.ColorUtils.brightnessForColor(Maui.Theme.backgroundColor) == Maui.ColorUtils.Light ? "white" : "dimgrey"
        }

        Connections {
            target: root
            onTitleChanged: {
                playingInfo.text = currentStation + " playing " + currentTitle
            }
        }
    }
}
