import QtCore
import QtQuick
import QtQuick.Controls
import org.mauikit.controls as Maui
import QtMultimedia

Maui.Page {
    id: searchPage

    Maui.Controls.showCSD: true

    property int results: -1

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

    headBar.middleContent: Maui.SearchField {
        anchors.horizontalCenter: parent.horizontalCenter
        onAccepted: {
            searchModel.clear()
            search(text)
        }
    }

    Component.onCompleted: {
        opacityAnimation.start()
        xAnimation.start()
        playingInfo.text = playingInfoOnChangedPage
    }

    PropertyAnimation {
        id: opacityAnimation
        target: searchPage
        properties: "opacity"
        from: 0
        to: 1.0
        duration: 250
    }

    PropertyAnimation {
        id: xAnimation
        target: searchPage
        properties: "x"
        from: -20
        to: 0
        duration: 500
    }

    // HOLDER

	Maui.Holder
	{
		anchors.fill: parent
		visible: searchModel.count == 0 ? true : false
		title: i18n("Search")
		body: results == -1 ? i18n("Search for a radio station on Radio Brower, you can already choose from more than 43.000 stations") : i18n("There are no results for this search")
		emoji: "search"
		isMask: false
	}

    function search(query) {

        // RADIO BROWSER

        var xhr = new XMLHttpRequest();
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.HEADERS_RECEIVED) {
                print('HEADERS_RECEIVED')
            } else if(xhr.readyState === XMLHttpRequest.DONE) {
                print('DONE');
                var obj = JSON.parse(xhr.responseText.toString());

                results = obj.length

                for(var i=0; i<obj.length; i++) {
                    searchModel.append({"changeuuid": obj[i].changeuuid,"stationuuid": obj[i].stationuuid, "serveruuid": obj[i].serveruuid,"name": obj[i].name,"url": obj[i].url,"url_resolved": obj[i].url_resolved,"homepage": obj[i].homepage,"favicon": obj[i].favicon,"tags": obj[i].tags,"country": obj[i].country, "countrycode": obj[i].countrycode, "iso_3166_2": obj[i].iso_3166_2,"state": obj[i].state, "language": obj[i].language, "languagecodes": obj[i].languagecodecs, "votes": obj[i].votes,"lastchangetime": obj[i].lastchangetime,"lastchangetime_iso8601": obj[i].lastchangetime_iso8601,"codec": obj[i].codec,"bitrate": obj[i].bitrate,"hls": obj[i].hls,"lastcheckok": obj[i].lastcheckok,"lastchecktime": obj[i].lastchecktime,"lastchecktime_iso8601": obj[i].lastchecktime_iso8601,"lastcheckoktime": obj[i].lastcheckoktime,"lastcheckoktime_iso8601": obj[i].lastcheckoktime_iso8601,"lastlocalchecktime": obj[i].lastlocalchecktime,"lastlocalchecktime_iso8601": obj[i].lastlocalchecktime_iso8601,"clicktimestamp": obj[i].clicktimestamp,"clicktimestamp_iso8601": obj[i].clicktimestamp_iso8601,"clickcount": obj[i].clickcount,"clicktrend": obj[i].clicktrend,"ssl_error": obj[i].ssl_error,"geo_lat	null": obj[i].geo_latnull,"geo_long": obj[i].geo_long, "has_extended_info": obj[i].has_extended_info})
                }
            }
        }
        xhr.open("GET", baseUrl + "/json/stations/search?limit=999&name=" + query + "&hidebroken=true&order=clickcount&reverse=true");
        xhr.send();
    }

    Maui.ListBrowser {
        id: list
        anchors.fill: parent
        anchors.margins: 20

        horizontalScrollBarPolicy: ScrollBar.AsNeeded
        verticalScrollBarPolicy: ScrollBar.AsNeeded

        spacing: 10

        model: searchModel

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
                    currentStation = searchModel.get(list.currentIndex).name
                    playingInfo.text = currentStation
                    playingInfoOnChangedPage = playingInfo.text
                    player.pause = true
                    player.loadFile(searchModel.get(list.currentIndex).url_resolved)
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
                                favoritesModel.append(searchModel.get(list.currentIndex))
                                sortModel()
                                saveFavorites()
                            }
                        }
                    },

                    Action
                    {
                        icon.name: "go-home"
                        onTriggered: {
                            Qt.openUrlExternally(searchModel.get(index).homepage)
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
        visible: searchModel.count > 0 ? true : false
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
        visible: player.pause || (!player.pause && searchModel.count == 0) ? false : true
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
            if (searchModel.get(list.currentIndex).stationuuid == favoritesModel.get(i).stationuuid) {
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
