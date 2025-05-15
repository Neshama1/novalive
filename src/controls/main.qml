import QtQuick
import QtQuick.Controls
import org.mauikit.controls as Maui
import QtMultimedia
import QtQml
import Qt.labs.settings
import org.kde.novalive
import QtQuick.Window

Maui.ApplicationWindow
{
    id: root

    ListModel { id: favoritesModel }
    ListModel { id: notificationsModel }
    ListModel { id: soulfunkModel }
    ListModel { id: searchModel }
    ListModel { id: stationsByGenreModel }
    ListModel { id: stationsByCountryModel }
    ListModel { id: stationsByLanguageModel }
    ListModel { id: youTubeModel }
    ListModel { id: metaDataModel }

    property string baseUrl
    property int genresCurrentIndex
    property int countriesCurrentIndex
    property int languagesCurrentIndex
    property int notificationsCurrentIndex
    property int sideBarWidth: 215
    property string currentStation
    property string currentTitle
    property string playingInfoOnChangedPage
    property string favorites: ""
    property int styleType: Maui.Style.Auto

    Settings {
        property alias favorites: root.favorites
        property alias styleType: root.styleType
    }

    signal titleChanged()

    width: Screen.desktopAvailableWidth - Screen.desktopAvailableWidth * 35 / 100
    height: Screen.desktopAvailableHeight - Screen.desktopAvailableHeight * 15 / 100

    property string apiKeyYouTube: ""

    Settings {
        property alias apiKeyYouTube: root.apiKeyYouTube
    }

    SettingsDialog
    {
        id: settingsDialog
    }

    MpvObject {
        id: mpvPlayer
        anchors.fill: parent
        visible: false
    }

    ThemeManager {
        id: themeManager
    }

    Component.onCompleted: {

        // Theme
        Maui.Style.styleType = styleType === Maui.Style.Auto ? themeManager.styleType : styleType
        Maui.Style.accentColor = "aquamarine"
        Maui.Style.windowControlsTheme = themeManager.windowControlsTheme

        // Favorites
        getFavorites()

        // RadioBrowser server
        getRadioBrowserServer()
    }

    function getFavorites() {
        if (favoritesModel.count == 0) {
            // Leer favoritos de ~/.config/KDE/novalive.conf
            var datamodel = JSON.parse(favorites)
            for (var i = 0; i < datamodel.length; ++i)
            {
                favoritesModel.append(datamodel[i])
            }
        }
    }

    function getRadioBrowserServer() {
        get_radiobrowser_base_url_random()
    }

    function get_radiobrowser_base_url_random() {
        return get_radiobrowser_base_urls().then(hosts => {
            var item = hosts[Math.floor(Math.random() * hosts.length)];
            baseUrl = item.toString()

            getStatus(baseUrl).then(status => {
                console.info("baseUrl: " + baseUrl)
                console.info("status: " + status)
                if (status == 502) {
                    // 502 Bad Gateway. Get another random server
                    get_radiobrowser_base_url_random()
                }
                else if (status == 200) {
                    // OK
                    pushPages()
                }
            });
        });
    }

    function getStatus(server) {
        return new Promise((resolve, reject)=>{
            var xhr = new XMLHttpRequest();
            xhr.open("GET", server);
            xhr.send();

            xhr.onreadystatechange = function() {
                console.log(xhr);
                if (xhr.readyState == 4 && xhr.status == 502) {
                    console.info("Server response not received")
                    var status = 502
                    resolve(status)
                }
                else if (xhr.readyState == 4 && xhr.status == 200) {
                    console.info("Server response received")
                    var status = 200
                    resolve(status)
                }
            };
        });
    }

    function get_radiobrowser_base_urls() {
        return new Promise((resolve, reject)=>{
            var request = new XMLHttpRequest()
            // If you need https, you have to use fixed servers, at best a list for this request
            request.open('GET', 'http://all.api.radio-browser.info/json/servers', true);
            request.onload = function() {
                if (request.status >= 200 && request.status < 300){
                    var items = JSON.parse(request.responseText).map(x=>"https://" + x.name);
                    resolve(items);
                }else{
                    reject(request.statusText);
                }
            }
            request.send();
        });
    }

    // RADIO PLAYER

    MediaPlayer {
        id: player

        audioOutput: AudioOutput {}

        onMetaDataChanged: {

            if (currentTitle != player.metaData.stringValue(MediaMetaData.Title)) {

                // Clear metadata model

                metaDataModel.clear()

                // Read avaliable metadata

                if (player.metaData) {
                    for (var key of player.metaData.keys()) {
                        metaDataModel.append({"key": key,"stringKey": player.metaData.metaDataKeyToString(key), "value": player.metaData.value(key), "stringValue": player.metaData.stringValue(key)})
                    }
                }

                // Print to console

                for (var i = 0; i < metaDataModel.count; i++) {
                    var mdKey = metaDataModel.get(i).mdKey
                    var mdKeyString = metaDataModel.get(i).mdKeyString
                    var mdValue= metaDataModel.get(i).mdValue
                    var mdValueString = metaDataModel.get(i).mdValueString
                    console.info(mdKey, mdKeyString, mdValue, mdValueString)
                }

                // Get time

                var timeString = new Date().toLocaleTimeString(Qt.locale("es_ES"))

                // Add to notifications playlist

                const artistsong = currentTitle.split(" - ");

                notificationsModel.insert(0, {"title": currentTitle, "station": currentStation ,"artist": artistsong[0], "song": artistsong[1], "time": timeString})

                // Info

                playingInfoOnChangedPage = currentStation + " playing " + currentTitle

                // Emit signal

                root.titleChanged()
            }
        }
    }

    // MAIN PAGE

    Maui.SideBarView
    {
        anchors.fill: parent

        sideBar.preferredWidth: sideBarWidth

        Behavior on sideBar.preferredWidth {
            NumberAnimation {
                duration: 250
                easing.type: Easing.OutExpot
            }
        }

        sideBarContent: Maui.Page
        {
            Maui.Theme.colorSet: Maui.Theme.Window
            anchors.fill: parent

            headBar.visible: false

            ListModel {
            id: mainMenuModel
                ListElement { name: "Notifications" ; description: "Recently played" ; icon: "notifications" }
                ListElement { name: "Favorites" ; description: "Listen to your favorite radio station" ; icon: "favorite" }
                ListElement { name: "Soul & Funk" ; description: "Funky and soul melodies with our handpicked radio stations" ; icon: "music-note-16th" }
                ListElement { name: "Search" ; description: "Find a radio station" ; icon: "search" }
                ListElement { name: "Genre" ; description: "Music category" ; icon: "view-media-genre" }
                ListElement { name: "Country" ; description: "Radio stations by country" ; icon: "flag" }
                ListElement { name: "Language" ; description: "Search for a station in any language" ; icon: "languages" }
            }

            Maui.ListBrowser {
                id: menuSideBar

                anchors.fill: parent
                anchors.margins: 5

                horizontalScrollBarPolicy: ScrollBar.AlwaysOff
                verticalScrollBarPolicy: ScrollBar.AlwaysOff

                currentIndex: -1

                spacing: 5

                model: mainMenuModel

                delegate: Maui.ListBrowserDelegate {
                    width: ListView.view.width
                    height: 60
                    label1.text: name
                    label2.text: description

                    template.label1.font.pixelSize: 16
                    template.label2.font.pixelSize: 10

                    iconSource: icon

                    onClicked: {
                        mpvPlayer.setProperty("pause",true)
                        switch (index) {
                            case 0: {
                                menuSideBar.currentIndex = index
                                stackView.push("Notifications.qml")
                                return
                            }
                            case 1: {
                                menuSideBar.currentIndex = index
                                stackView.push("Favorites.qml")
                                return
                            }
                            case 2: {
                                menuSideBar.currentIndex = index
                                stackView.push("SoulFunk.qml")
                                return
                            }
                            case 3: {
                                menuSideBar.currentIndex = index
                                stackView.push("Search.qml")
                                return
                            }
                            case 4: {
                                menuSideBar.currentIndex = index
                                stackView.push("Genres.qml")
                                return
                            }
                            case 5: {
                                menuSideBar.currentIndex = index
                                stackView.push("Country.qml")
                                return
                            }
                            case 6: {
                                menuSideBar.currentIndex = index
                                stackView.push("Language.qml")
                                return
                            }
                        }
                    }
                }
            }
        }

        Maui.Page
        {
            anchors.fill: parent

            headBar.visible: false

            Component.onCompleted: {
                stackView.push("Home.qml")
            }

            StackView {
                id: stackView
                anchors.fill: parent
            }
        }
    }

    function saveFavorites()
    {
        var datamodel = []

        // Guardar favoritos en ~/.config/KDE/novalive.conf
        for (var i = 0; i < favoritesModel.count; i++)
        {
            datamodel.push(favoritesModel.get(i))
        }
        favorites = JSON.stringify(datamodel)
    }
}
