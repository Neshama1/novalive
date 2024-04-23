import QtQuick 2.15
import QtQuick.Controls 2.15
import org.mauikit.controls 1.3 as Maui
import Qt.labs.settings 1.0
import QtMultimedia 5.15

Maui.Page {
    id: soulfunkPage

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

    property string soulfunkRadios: ""

    Settings {
        property alias soulfunkRadios: soulfunkPage.soulfunkRadios
    }

    Component.onCompleted: {
        opacityAnimation.start()
        xAnimation.start()

        playingInfo.text = playingInfoOnChangedPage

        if (true) {
            soulfunkModel.clear()
            fillModel()
            sortModel()
        }
        else
        {
            // Leer radios soul funk de ~/.config/KDE/novalive.conf
            var datamodel = JSON.parse(soulfunkRadios)
            for (var i = 0; i < datamodel.length; ++i)
            {
                soulfunkModel.append(datamodel[i])
            }
        }
    }

    Component.onDestruction: {
        var datamodel = []

        // Guardar radios soul funk en ~/.config/KDE/novalive.conf
        for (var i = 0; i < soulfunkModel.count; ++i)
        {
            datamodel.push(soulfunkModel.get(i))
        }
        soulfunkRadios = JSON.stringify(datamodel)
    }

    PropertyAnimation {
        id: opacityAnimation
        target: soulfunkPage
        properties: "opacity"
        from: 0
        to: 1.0
        duration: 250
    }

    PropertyAnimation {
        id: xAnimation
        target: soulfunkPage
        properties: "x"
        from: -20
        to: 0
        duration: 500
    }

    function fillModel()
    {
        soulfunkModel.append({"changeuuid":"c4d1d89e-4111-4279-b42e-43631c15263a","stationuuid":"a4d441bf-b23d-40b2-b2cd-bb8022e6b033","serveruuid":null,"name":"Brava Radio 103.8 FM Jakarta","url":"http://stream.radiojar.com/5k7t0rq3bnzuv","url_resolved":"http://n07.radiojar.com/5k7t0rq3bnzuv?rj-ttl=5&rj-tok=AAABiy2g4ToAHXClf7mzcMNofA","homepage":"https://bravaradio.com/","favicon":"https://bravaradio.com/favicon.ico","tags":"","country":"Indonesia","countrycode":"ID","iso_3166_2":null,"state":"","language":"bahasa indonesia,indonesian","languagecodes":"","votes":445,"lastchangetime":"2023-07-30 23:44:12","lastchangetime_iso8601":"2023-07-30T23:44:12Z","codec":"AAC","bitrate":0,"hls":0,"lastcheckok":1,"lastchecktime":"2023-10-14 09:56:44","lastchecktime_iso8601":"2023-10-14T09:56:44Z","lastcheckoktime":"2023-10-14 09:56:44","lastcheckoktime_iso8601":"2023-10-14T09:56:44Z","lastlocalchecktime":"","lastlocalchecktime_iso8601":null,"clicktimestamp":"2023-10-14 14:40:02","clicktimestamp_iso8601":"2023-10-14T14:40:02Z","clickcount":67,"clicktrend":-1,"ssl_error":0,"geo_lat":null,"geo_long":null,"has_extended_info":false})

        soulfunkModel.append({"changeuuid":"6f5abd6f-cd27-44d0-a4c7-e2432ffa027a","stationuuid":"afb31087-30b4-44c7-8469-b3526d8f3bb5","serveruuid":null,"name":"Total Soul UK","url":"https://onair7.xdevel.com/proxy/xautocloud_atvn_1069?mp=/;1/","url_resolved":"https://onair7.xdevel.com/proxy/xautocloud_atvn_1069?mp=/;1/","homepage":"https://www.totalsoul.co.uk/","favicon":"https://mmo.aiircdn.com/440/5f5f8e87490e2.png","tags":"80's,disco,soul","country":"The United Kingdom Of Great Britain And Northern Ireland","countrycode":"GB","iso_3166_2":null,"state":"","language":"english","languagecodes":"","votes":12,"lastchangetime":"2023-01-23 03:47:36","lastchangetime_iso8601":"2023-01-23T03:47:36Z","codec":"MP3","bitrate":192,"hls":0,"lastcheckok":1,"lastchecktime":"2023-10-13 22:52:06","lastchecktime_iso8601":"2023-10-13T22:52:06Z","lastcheckoktime":"2023-10-13 22:52:06","lastcheckoktime_iso8601":"2023-10-13T22:52:06Z","lastlocalchecktime":"","lastlocalchecktime_iso8601":null,"clicktimestamp":"2023-10-13 06:51:52","clicktimestamp_iso8601":"2023-10-13T06:51:52Z","clickcount":7,"clicktrend":-1,"ssl_error":0,"geo_lat":null,"geo_long":null,"has_extended_info":false})

        soulfunkModel.append({"changeuuid":"7fd826b9-b7eb-4c6e-955d-1f0198891206","stationuuid":"e6c5d27f-362c-48a9-8eb9-9dcc902b9bfe","serveruuid":null,"name":"Mustbe5 Radio","url":"https://stream.radio.co/sf2ed5928f/listen","url_resolved":"https://stream.radio.co/sf2ed5928f/listen","homepage":"https://mustbe5radio.com/","favicon":"","tags":"afrobeat,electronic,funk,gospel,hip hop,house,jazz,pop,reggae,soul","country":"The United States Of America","countrycode":"US","iso_3166_2":null,"state":"New Jersey","language":"english","languagecodes":"en","votes":2,"lastchangetime":"2023-08-08 05:34:51","lastchangetime_iso8601":"2023-08-08T05:34:51Z","codec":"AAC","bitrate":192,"hls":0,"lastcheckok":1,"lastchecktime":"2023-10-15 08:54:58","lastchecktime_iso8601":"2023-10-15T08:54:58Z","lastcheckoktime":"2023-10-15 08:54:58","lastcheckoktime_iso8601":"2023-10-15T08:54:58Z","lastlocalchecktime":"2023-10-15 07:37:39","lastlocalchecktime_iso8601":"2023-10-15T07:37:39Z","clicktimestamp":"2023-10-13 22:22:47","clicktimestamp_iso8601":"2023-10-13T22:22:47Z","clickcount":7,"clicktrend":-1,"ssl_error":0,"geo_lat":39.929615852676626,"geo_long":-74.21328969882359,"has_extended_info":false})

        soulfunkModel.append({"changeuuid":"205d7cc6-547e-4fc5-94a2-98f9e157d359","stationuuid":"9cd294c5-180a-45c4-bf87-d80e77960d78","serveruuid":"b78d6660-7a5f-4c93-8cbc-0ab9e3833c91","name":"Smooth Jazz Classics by Cloud Jazz","url":"https://stream-57.zeno.fm/w3phtkukfg8uv?zs=90IfdbcARnS99_b8RaX9sQ&acu-uid=736851429618&dyn-uid=&an-uid=0&mm-uid=a42b63d5-b9eb-4f00-9692-60c79195c3a4&triton-uid=cookie%3A7e5c2d9b-9c30-46f6-b8b4-0354fd4dd340&amb-uid=3916839388731891724","url_resolved":"https://stream-151.zeno.fm/w3phtkukfg8uv?zs=ij7iSsNlR123h1A3VJbOnw&acu-uid=736851429618&dyn-uid=&an-uid=0&mm-uid=a42b63d5-b9eb-4f00-9692-60c79195c3a4&triton-uid=cookie%3A7e5c2d9b-9c30-46f6-b8b4-0354fd4dd340&amb-uid=3916839388731891724","homepage":"https://cloud-jazz.com/","favicon":"https://zeno.fm/_next/image/?url=https%3A%2F%2Fimages.zeno.fm%2F-5Dnek9IkY9ayIbGXazWRDiw4jt_V-mmLcnJ540rMN0%2Frs%3Afit%3A320%3A320%2Fg%3Ace%3A0%3A0%2FaHR0cHM6Ly9lZGl0b3IuemVub21lZGlhLmNvbS9yZXNvdXJjZXMvenNfc3RhdGlvbi80OTY2ODEvQ2FyZFdlYnNpdGUvaW1hZ2UucG5n.webp&w=1920&q=75","tags":"smooth jazz,soul","country":"Spain","countrycode":"ES","iso_3166_2":null,"state":"Madrid","language":"spanish","languagecodes":"es","votes":24,"lastchangetime":"2023-07-30 20:21:36","lastchangetime_iso8601":"2023-07-30T20:21:36Z","codec":"MP3","bitrate":0,"hls":0,"lastcheckok":1,"lastchecktime":"2023-10-14 23:39:00","lastchecktime_iso8601":"2023-10-14T23:39:00Z","lastcheckoktime":"2023-10-14 23:39:00","lastcheckoktime_iso8601":"2023-10-14T23:39:00Z","lastlocalchecktime":"2023-10-14 23:39:00","lastlocalchecktime_iso8601":"2023-10-14T23:39:00Z","clicktimestamp":"2023-10-15 06:54:47","clicktimestamp_iso8601":"2023-10-15T06:54:47Z","clickcount":8,"clicktrend":2,"ssl_error":0,"geo_lat":null,"geo_long":null,"has_extended_info":false})

        soulfunkModel.append({"changeuuid":"60601cc0-0b05-4bcb-9fce-34ed64565307","stationuuid":"972a5cd8-3144-4083-996a-f9401be5e6f5","serveruuid":"f37bdaca-40a5-4192-af54-2f8cc9cd4d45","name":"Soulmet Radio","url":"http://radiart.eu:2199/tunein/soulmet.pls","url_resolved":"http://91.121.59.45:10184/stream","homepage":"https://soulmet-radio.wixsite.com/soulmet-radio","favicon":"https://static.wixstatic.com/media/a51df2_1c64505953b64daead89b06067bd9a30.png/v1/fill/w_329,h_329,al_c,q_85,usm_0.66_1.00_0.01,enc_auto/a51df2_1c64505953b64daead89b06067bd9a30.png","tags":"funk,jazz,rap,rnb,soul","country":"France","countrycode":"FR","iso_3166_2":null,"state":"","language":"french","languagecodes":"fr","votes":0,"lastchangetime":"2023-10-15 07:05:48","lastchangetime_iso8601":"2023-10-15T07:05:48Z","codec":"MP3","bitrate":192,"hls":0,"lastcheckok":1,"lastchecktime":"2023-10-15 07:05:50","lastchecktime_iso8601":"2023-10-15T07:05:50Z","lastcheckoktime":"2023-10-15 07:05:50","lastcheckoktime_iso8601":"2023-10-15T07:05:50Z","lastlocalchecktime":"2023-10-15 07:05:50","lastlocalchecktime_iso8601":"2023-10-15T07:05:50Z","clicktimestamp":"2023-10-15 10:40:22","clicktimestamp_iso8601":"2023-10-15T10:40:22Z","clickcount":5,"clicktrend":5,"ssl_error":0,"geo_lat":null,"geo_long":null,"has_extended_info":false})

        soulfunkModel.append({"changeuuid":"182f7bc3-35e0-4f25-babe-870ae2f76235","stationuuid":"47cde367-a91c-4c81-a1f9-03a8e78ebdd1","serveruuid":null,"name":"Crossover Radio Online","url":"https://streams.radio.co/s1317e9f68/listen","url_resolved":"https://streams.radio.co/s1317e9f68/listen","homepage":"https://www.crossoverradioonline.com/","favicon":"https://www.crossoverradioonline.com/uploads/1/3/0/7/130753257/editor/app-store-badge_2.png","tags":"acid jazz,adult contemporary,rhythm and blues,smooth jazz","country":"The Philippines","countrycode":"PH","iso_3166_2":null,"state":"","language":"","languagecodes":"","votes":629,"lastchangetime":"2024-03-18 03:53:00","lastchangetime_iso8601":"2024-03-18T03:53:00Z","codec":"MP3","bitrate":192,"hls":0,"lastcheckok":1,"lastchecktime":"2024-04-22 14:57:12","lastchecktime_iso8601":"2024-04-22T14:57:12Z","lastcheckoktime":"2024-04-22 14:57:12","lastcheckoktime_iso8601":"2024-04-22T14:57:12Z","lastlocalchecktime":"","lastlocalchecktime_iso8601":null,"clicktimestamp":"2024-04-23 00:56:21","clicktimestamp_iso8601":"2024-04-23T00:56:21Z","clickcount":8,"clicktrend":-2,"ssl_error":0,"geo_lat":null,"geo_long":null,"has_extended_info":false})
    }

    function sortModel()
    {
        var n;
        var i;
        for (n=0; n < soulfunkModel.count; n++)
        {
            for (i=n+1; i < soulfunkModel.count; i++)
            {
                if (soulfunkModel.get(n).name > soulfunkModel.get(i).name)
                {
                    soulfunkModel.move(i, n, 1);
                }
            }
        }
    }

    // HOLDER

	Maui.Holder
	{
		anchors.fill: parent
		visible: soulfunkModel.count == 0 ? true : false
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

        model: soulfunkModel

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
                        currentStation = soulfunkModel.get(grid.currentIndex).name
                        playingInfo.text = currentStation
                        playingInfoOnChangedPage = playingInfo.text
                        player.stop()
                        player.source = soulfunkModel.get(grid.currentIndex).url_resolved
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
                        text: "Visit website"
                        icon.name: "go-home"
                        onTriggered: {
                            Qt.openUrlExternally(soulfunkModel.get(rightStationIndex).homepage)
                        }
                    }
                }
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    grid.currentIndex = index
                    currentStation = soulfunkModel.get(grid.currentIndex).name
                    playingInfo.text = currentStation
                    playingInfoOnChangedPage = playingInfo.text
                    player.stop()
                    player.source = soulfunkModel.get(grid.currentIndex).url_resolved
                    player.play()
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
