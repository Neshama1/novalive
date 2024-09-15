import QtQuick 2.15
import QtQuick.Controls 2.15
import org.mauikit.controls 1.3 as Maui
import Qt.labs.settings 1.0
import QtMultimedia 5.15

Maui.Page {
    id: favoritesPage

    showCSDControls: true

    property int rightStationIndex

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

        playingInfo.text = playingInfoOnChangedPage

        if (favoritesModel.count == 0) {
            // Leer favoritos de ~/.config/KDE/novalive.conf
            var datamodel = JSON.parse(favorites)
            for (var i = 0; i < datamodel.length; ++i)
            {
                favoritesModel.append(datamodel[i])
            }
        }
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
                        player.stop()
                        player.source = favoritesModel.get(grid.currentIndex).url_resolved
                        player.play()
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
        icon.name: player.playbackState == MediaPlayer.StoppedState ? "media-playback-start" : "media-playback-stop"
        onClicked: player.playbackState == MediaPlayer.StoppedState ? player.play() : player.stop()
    }

    Maui.FloatingButton
    {
        id: playingInfo
        anchors.bottom: parent.bottom
        anchors.right: playButton.left
        anchors.margins: 20
        visible: player.playbackState == MediaPlayer.StoppedState ? false : true
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
