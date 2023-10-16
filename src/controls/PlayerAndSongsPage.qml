import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.12
import QtMultimedia 5.15
import org.mauikit.controls 1.3 as Maui

Maui.Page {
    id: playerAndSongsPage

    headBar.visible: false

    Maui.Theme.colorSet: Maui.Theme.Window

    background: Rectangle {
        anchors.fill: parent
        color: Maui.Theme.backgroundColor
    }

    // HEADER: PLAYER / RETURN

    header: Maui.Page {

        visible: holder ? false : true
        headBar.visible: false

        background: Rectangle {
            anchors.fill: parent
            Maui.Theme.inherit: false
            Maui.Theme.colorSet: Maui.Theme.Window
            color: Maui.ColorUtils.brightnessForColor(Maui.Theme.backgroundColor) == Maui.ColorUtils.Light ?Qt.darker(Maui.Theme.backgroundColor,1.03) : Qt.darker(Maui.Theme.backgroundColor,1.1)
        }

        width: parent.width
        height: 46

        Button {
            id: backButton
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 10
            flat: true
            icon.name: "media-seek-backward"
            onClicked: {
                if (viewIndex == 0) {
                    if (stationIndex > 0) {
                        stationIndex = stationIndex - 1
                        player.stop()
                        player.source = stationsModel.get(stationIndex).url_resolved
                        radioicon = stationsModel.get(stationIndex).favicon == "" ? "qrc:/assets/pixabay-cc0-mod2-cassette-2672633_640.png" : stationsModel.get(stationIndex).favicon
                        stationName = stationsModel.get(stationIndex).name
                        player.play()
                    }
                }
                if (viewIndex == 1) {
                    if (stationIndex > 0) {
                        stationIndex = stationIndex - 1
                        player.stop()
                        player.source = favoritesModel.get(stationIndex).url_resolved
                        radioicon = favoritesModel.get(stationIndex).favicon == "" ? "qrc:/assets/pixabay-cc0-mod2-cassette-2672633_640.png" : favoritesModel.get(stationIndex).favicon
                        stationName = favoritesModel.get(stationIndex).name
                        player.play()
                    }
                }
                if (viewIndex == 2) {
                    if (stationIndex > 0) {
                        stationIndex = stationIndex - 1
                        player.stop()
                        player.source = soulfunkModel.get(stationIndex).url_resolved
                        radioicon = soulfunkModel.get(stationIndex).favicon == "" ? "qrc:/assets/pixabay-cc0-mod2-cassette-2672633_640.png" : soulfunkModel.get(stationIndex).favicon
                        stationName = soulfunkModel.get(stationIndex).name
                        player.play()
                    }
                }
                if (viewIndex == 3) {
                    if (stationIndex > 0) {
                        stationIndex = stationIndex - 1
                        player.stop()
                        player.source = stationsByGenreModel.get(stationIndex).url_resolved
                        radioicon = stationsByGenreModel.get(stationIndex).favicon == "" ? "qrc:/assets/pixabay-cc0-mod2-cassette-2672633_640.png" : stationsByGenreModel.get(stationIndex).favicon
                        stationName = stationsByGenreModel.get(stationIndex).name
                        player.play()
                    }
                }
                if (viewIndex == 4) {
                    if (stationIndex > 0) {
                        stationIndex = stationIndex - 1
                        player.stop()
                        player.source = stationsByCountryModel.get(stationIndex).url_resolved
                        radioicon = stationsByCountryModel.get(stationIndex).favicon == "" ? "qrc:/assets/pixabay-cc0-mod2-cassette-2672633_640.png" : stationsByCountryModel.get(stationIndex).favicon
                        stationName = stationsByCountryModel.get(stationIndex).name
                        player.play()
                    }
                }
                if (viewIndex == 5) {
                    if (stationIndex > 0) {
                        stationIndex = stationIndex - 1
                        player.stop()
                        player.source = stationsByLanguageModel.get(stationIndex).url_resolved
                        radioicon = stationsByLanguageModel.get(stationIndex).favicon == "" ? "qrc:/assets/pixabay-cc0-mod2-cassette-2672633_640.png" : stationsByLanguageModel.get(stationIndex).favicon
                        stationName = stationsByLanguageModel.get(stationIndex).name
                        player.play()
                    }
                }
                if (viewIndex == 6) {
                    if (stationIndex > 0) {
                        stationIndex = stationIndex - 1
                        player.stop()
                        player.source = stationSearchModel.get(stationIndex).url_resolved
                        radioicon = stationSearchModel.get(stationIndex).favicon == "" ? "qrc:/assets/pixabay-cc0-mod2-cassette-2672633_640.png" : stationSearchModel.get(stationIndex).favicon
                        stationName = stationSearchModel.get(stationIndex).name
                        player.play()
                    }
                }
            }
        }
        Button {
            id: playButton
            anchors.left: backButton.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 10
            flat: true
            icon.name: player.playbackState == MediaPlayer.StoppedState ? "media-playback-start" : "media-playback-stop"
            onClicked: player.playbackState == MediaPlayer.StoppedState ? player.play() : player.stop()
        }
        Button {
            id: nextButton
            anchors.left: playButton.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 10
            flat: true
            icon.name: "media-seek-forward"
            onClicked: {
                if (viewIndex == 0) {
                    if (stationIndex + 1 < stationsModel.count)
                    {
                        stationIndex = stationIndex + 1
                        player.stop()
                        player.source = stationsModel.get(stationIndex).url_resolved
                        radioicon = stationsModel.get(stationIndex).favicon == "" ? "qrc:/assets/pixabay-cc0-mod2-cassette-2672633_640.png" : stationsModel.get(stationIndex).favicon
                        stationName = stationsModel.get(stationIndex).name
                        player.play()
                    }
                }
                if (viewIndex == 1) {
                    if (stationIndex + 1 < favoritesModel.count)
                    {
                        stationIndex = stationIndex + 1
                        player.stop()
                        player.source = favoritesModel.get(stationIndex).url_resolved
                        radioicon = favoritesModel.get(stationIndex).favicon == "" ? "qrc:/assets/pixabay-cc0-mod2-cassette-2672633_640.png" : favoritesModel.get(stationIndex).favicon
                        stationName = favoritesModel.get(stationIndex).name
                        player.play()
                    }
                }
                if (viewIndex == 2) {
                    if (stationIndex + 1 < soulfunkModel.count)
                    {
                        stationIndex = stationIndex + 1
                        player.stop()
                        player.source = soulfunkModel.get(stationIndex).url_resolved
                        radioicon = soulfunkModel.get(stationIndex).favicon == "" ? "qrc:/assets/pixabay-cc0-mod2-cassette-2672633_640.png" : soulfunkModel.get(stationIndex).favicon
                        stationName = soulfunkModel.get(stationIndex).name
                        player.play()
                    }
                }
                if (viewIndex == 3) {
                    if (stationIndex + 1 < stationsByGenreModel.count)
                    {
                        stationIndex = stationIndex + 1
                        player.stop()
                        player.source = stationsByGenreModel.get(stationIndex).url_resolved
                        radioicon = stationsByGenreModel.get(stationIndex).favicon == "" ? "qrc:/assets/pixabay-cc0-mod2-cassette-2672633_640.png" : stationsByGenreModel.get(stationIndex).favicon
                        stationName = stationsByGenreModel.get(stationIndex).name
                        player.play()
                    }
                }
                if (viewIndex == 4) {
                    if (stationIndex + 1 < stationsByCountryModel.count)
                    {
                        stationIndex = stationIndex + 1
                        player.stop()
                        player.source = stationsByCountryModel.get(stationIndex).url_resolved
                        radioicon = stationsByCountryModel.get(stationIndex).favicon == "" ? "qrc:/assets/pixabay-cc0-mod2-cassette-2672633_640.png" : stationsByCountryModel.get(stationIndex).favicon
                        stationName = stationsByCountryModel.get(stationIndex).name
                        player.play()
                    }
                }
                if (viewIndex == 5) {
                    if (stationIndex + 1 < stationsByLanguageModel.count)
                    {
                        stationIndex = stationIndex + 1
                        player.stop()
                        player.source = stationsByLanguageModel.get(stationIndex).url_resolved
                        radioicon = stationsByLanguageModel.get(stationIndex).favicon == "" ? "qrc:/assets/pixabay-cc0-mod2-cassette-2672633_640.png" : stationsByLanguageModel.get(stationIndex).favicon
                        stationName = stationsByLanguageModel.get(stationIndex).name
                        player.play()
                    }
                }
                if (viewIndex == 6) {
                    if (stationIndex + 1 < stationSearchModel.count)
                    {
                        stationIndex = stationIndex + 1
                        player.stop()
                        player.source = stationSearchModel.get(stationIndex).url_resolved
                        radioicon = stationSearchModel.get(stationIndex).favicon == "" ? "qrc:/assets/pixabay-cc0-mod2-cassette-2672633_640.png" : stationSearchModel.get(stationIndex).favicon
                        stationName = stationSearchModel.get(stationIndex).name
                        player.play()
                    }
                }
            }
        }
        Button {
            id: arrowBack
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.rightMargin: 10
            visible: viewIndex == 0 || viewIndex == 1 ? false : true
            flat: true
            icon.name: "draw-arrow-back"
            onClicked: {
                if (viewIndex == 0) {
                    sideBarIndex = 1
                }
                if (viewIndex == 1) {
                    sideBarIndex = 1
                }
                if (viewIndex == 3) {
                    _stackViewSidePanel.pop()
                    sideBarIndex = 3
                }
                if (viewIndex == 4) {
                    _stackViewSidePanel.pop()
                    sideBarIndex = 4
                }
                if (viewIndex == 5) {
                    _stackViewSidePanel.pop()
                    sideBarIndex = 5
                }
            }
        }
    }

    // FOOTER

    footer: Maui.Page {
        visible: holder ? false : true
        headBar.visible: false

        background: Rectangle {
            anchors.fill: parent
            Maui.Theme.inherit: false
            Maui.Theme.colorSet: Maui.Theme.Window
            color: Maui.ColorUtils.brightnessForColor(Maui.Theme.backgroundColor) == Maui.ColorUtils.Light ?Qt.darker(Maui.Theme.backgroundColor,1.01) : Qt.darker(Maui.Theme.backgroundColor,1.04)
            //color: Maui.ColorUtils.brightnessForColor(Maui.Theme.backgroundColor) == Maui.ColorUtils.Light ?Qt.darker(Maui.Theme.backgroundColor,1.04) : Qt.lighter(Maui.Theme.backgroundColor,1.6)
        }

        width: parent.width
        height: 46

        Maui.IconItem
        {
            id: radioLogo
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.rightMargin: 10
            visible: false
            opacity: 0.20
            imageSource: radioicon
            iconSource: "emblem-music-symbolic"
            imageSizeHint: 30
            maskRadius: Maui.Style.radiusV
            fillMode: Image.PreserveAspectCrop
        }
        Label {
            anchors.left: parent.left
            anchors.right: radioLogo.left
            anchors.bottom: parent.bottom
            anchors.leftMargin: 10
            anchors.rightMargin: 10
            anchors.bottomMargin: 10
            opacity: 0.80
            elide: Text.ElideRight
            text: stationName
        }
    }

    // HOLDER

	Maui.Holder
	{
		anchors.fill: parent
		visible: holder
		title: i18n("Songs")
		body: i18n("Play a radio station")
		emoji: "emblem-music-symbolic"
		isMask: false
	}

	// SONGS

    Column
    {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 10

        visible: holder ? false : true

        spacing: 5

        Repeater {
            model: playedSongsModel
            Rectangle {
                height: songLabel.text == "" ? 35 : 50
                anchors.left: parent.left
                anchors.right: parent.right
                radius:4
                color: Maui.ColorUtils.brightnessForColor(Maui.Theme.backgroundColor) == Maui.ColorUtils.Light ? Qt.lighter(Maui.Theme.backgroundColor,1.03) : Qt.lighter(Maui.Theme.backgroundColor,1.3)

                Label {
                    opacity: 0.60
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10
                    anchors.topMargin: 8
                    text: artist
                    elide: Text.ElideRight
                }
                Label {
                    id: songLabel
                    opacity: 0.80
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10
                    anchors.bottomMargin: 8
                    text: song
                    font.pixelSize: 11
                    elide: Text.ElideRight
                }
            }
        }
    }
}