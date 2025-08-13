import QtQuick
import QtQuick.Controls
import org.mauikit.controls as Maui
import org.kde.novalive 1.0
import QtMultimedia

Maui.Page {
    id: stationsByGenrePage

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

    headBar.leftContent: ToolButton {
        icon.name: "draw-arrow-back"
        onClicked: stackView.pop()
    }

    Component.onCompleted: {
        playingInfo.text = playingInfoOnChangedPage
        getStations(GenresBackend.genres[genresCurrentIndex])
    }

    PropertyAnimation {
        id: opacityAnimation
        target: stationsByGenrePage
        properties: "opacity"
        from: 0
        to: 1.0
        duration: 250
    }

    PropertyAnimation {
        id: xAnimation
        target: stationsByGenrePage
        properties: "x"
        from: -20
        to: 0
        duration: 500
    }

    function getStations(genre) {
        var xhr = new XMLHttpRequest();
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.HEADERS_RECEIVED) {
                print('HEADERS_RECEIVED')
            } else if(xhr.readyState === XMLHttpRequest.DONE) {
                print('DONE')
                var json = JSON.parse(xhr.responseText.toString())

                for(var i=0; i<json.length; i++) {
                    stationsByGenreModel.append({"changeuuid": json[i].changeuuid,"stationuuid": json[i].stationuuid, "serveruuid": json[i].serveruuid,"name": json[i].name,"url": json[i].url,"url_resolved": json[i].url_resolved,"homepage": json[i].homepage,"favicon": json[i].favicon,"tags": json[i].tags,"country": json[i].country, "countrycode": json[i].countrycode, "iso_3166_2": json[i].iso_3166_2,"state": json[i].state, "language": json[i].language, "languagecodes": json[i].languagecodecs, "votes": json[i].votes,"lastchangetime": json[i].lastchangetime,"lastchangetime_iso8601": json[i].lastchangetime_iso8601,"codec": json[i].codec,"bitrate": json[i].bitrate,"hls": json[i].hls,"lastcheckok": json[i].lastcheckok,"lastchecktime": json[i].lastchecktime,"lastchecktime_iso8601": json[i].lastchecktime_iso8601,"lastcheckoktime": json[i].lastcheckoktime,"lastcheckoktime_iso8601": json[i].lastcheckoktime_iso8601,"lastlocalchecktime": json[i].lastlocalchecktime,"lastlocalchecktime_iso8601": json[i].lastlocalchecktime_iso8601,"clicktimestamp": json[i].clicktimestamp,"clicktimestamp_iso8601": json[i].clicktimestamp_iso8601,"clickcount": json[i].clickcount,"clicktrend": json[i].clicktrend,"ssl_error": json[i].ssl_error,"geo_lat	null": json[i].geo_latnull,"geo_long": json[i].geo_long, "has_extended_info": json[i].has_extended_info})
                }
                opacityAnimation.start()
                xAnimation.start()
            }
        }
        xhr.open("GET", baseUrl + "/json/stations/search?limit=999&tagList=" + genre + "&hidebroken=true&order=clickcount&reverse=true");
        xhr.send();
    }

    Maui.ListBrowser {
        id: list
        anchors.fill: parent
        anchors.margins: 20

        horizontalScrollBarPolicy: ScrollBar.AsNeeded
        verticalScrollBarPolicy: ScrollBar.AsNeeded

        spacing: 10

        model: stationsByGenreModel

        delegate: Rectangle {
            color: "transparent"
            width: ListView.view.width
            height: 50
            Maui.SwipeBrowserDelegate
            {
                anchors.fill: parent
                label1.text: name
                label2.text: tags
                //iconSource: favicon
                iconSizeHint: Maui.Style.iconSizes.medium

                onClicked: {
                    list.currentIndex = index
                    currentStation = name
                    playingInfo.text = currentStation
                    playingInfoOnChangedPage = playingInfo.text
                    player.pause = true
                    player.loadFile(url_resolved)
                    player.pause = false
                    stationLoaded = false
                }

                quickActions: [
                    Action
                    {
                        icon.name: "love"
                        onTriggered: {
                            list.currentIndex = index
                            if (!savedStation()) {
                                favoritesModel.append(stationsByGenreModel.get(list.currentIndex))
                                sortModel()
                                saveFavorites()
                            }
                        }
                    },

                    Action
                    {
                        icon.name: "go-home"
                        onTriggered: {
                            Qt.openUrlExternally(stationsByGenreModel.get(index).homepage)
                        }
                    }
                ]
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

    function savedStation() {
        var i
        for (i = 0; i < favoritesModel.count ; i++) {
            if (stationsByGenreModel.get(list.currentIndex).stationuuid == favoritesModel.get(i).stationuuid) {
                return true
            }
        }
        return false
    }

    function sortModel()
    {
        var n;
        var i;
        for (n=0; n < favoritesModel.count; n++)
        {
            for (i=n+1; i < favoritesModel.count; i++)
            {
                if (favoritesModel.get(n).name > favoritesModel.get(i).name)
                {
                    favoritesModel.move(i, n, 1);
                }
            }
        }
    }
}
