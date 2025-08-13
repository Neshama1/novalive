import QtCore
import QtQml
import QtQuick
import QtQuick.Controls
import org.mauikit.controls as Maui
import org.kde.novalive 1.0
import QtQuick.Window

Maui.ApplicationWindow
{
    id: root

    Maui.Style.styleType: themeManager.styleType
    Maui.Style.accentColor: themeManager.accentColor
    Maui.Style.defaultSpacing: themeManager.spacingSize
    Maui.Style.defaultPadding: themeManager.paddingSize
    Maui.Style.contentMargins: themeManager.marginSize
    Maui.Style.radiusV: themeManager.borderRadius

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
    property string apiKeyYouTube: ""
    property int styleType: Maui.Style.Auto
    property bool stationLoaded: false

    Settings {
        property alias favorites: root.favorites
        property alias apiKeyYouTube: root.apiKeyYouTube
        property alias styleType: root.styleType
    }

    signal titleChanged()

    width: Screen.desktopAvailableWidth - Screen.desktopAvailableWidth * 35 / 100
    height: Screen.desktopAvailableHeight - Screen.desktopAvailableHeight * 15 / 100

    SettingsDialog
    {
        id: settingsDialog
    }

    // MEDIA PLAYER

    MpvItem {
        id: player

        anchors.fill: parent
        visible: false

        onReady: {
            player.pause = true
            player.setProperty("mute", false)
            player.setProperty("volume", 85)
        }

        onFileLoaded: {

            commandAsync(["expand-text", "volume is ${volume}"], MpvItem.ExpandText);
            stationLoaded = true

        }

        onMediaTitleChanged: {

            if (stationLoaded) {

                // Update media title info

                if (currentTitle != player.mediaTitle) {

                    // Clear metadata model

                    metaDataModel.clear()

                    // Print to console

                    console.info(player.mediaTitle)

                    // Get time

                    var timeString = new Date().toLocaleTimeString(Qt.locale("es_ES"))

                    // Add to notifications playlist

                    currentTitle = player.mediaTitle
                    const artistsong = currentTitle.split(" - ");

                    notificationsModel.insert(0, {"title": currentTitle, "station": currentStation ,"artist": artistsong[0], "song": artistsong[1], "time": timeString})

                    // Info

                    playingInfoOnChangedPage = currentStation + " playing " + currentTitle

                    // Emit signal

                    root.titleChanged()
                }
            }
        }
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

            if (favorites) {

                var datamodel = JSON.parse(favorites)

                for (var i = 0; i < datamodel.length; ++i)
                {
                    favoritesModel.append(datamodel[i])
                }
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

    // MAIN PAGE

    Maui.SideBarView
    {
        anchors.fill: parent

        sideBar.width: sideBarWidth
        sideBar.preferredWidth: sideBarWidth

        Behavior on sideBar.width {
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
                        switch (index) {
                            case 0: {
                                menuSideBar.currentIndex = index
                                stackView.push("controls/Notifications.qml")
                                return
                            }
                            case 1: {
                                menuSideBar.currentIndex = index
                                stackView.push("controls/Favorites.qml")
                                return
                            }
                            case 2: {
                                menuSideBar.currentIndex = index
                                stackView.push("controls/SoulFunk.qml")
                                return
                            }
                            case 3: {
                                menuSideBar.currentIndex = index
                                stackView.push("controls/Search.qml")
                                return
                            }
                            case 4: {
                                menuSideBar.currentIndex = index
                                stackView.push("controls/Genres.qml")
                                return
                            }
                            case 5: {
                                menuSideBar.currentIndex = index
                                stackView.push("controls/Country.qml")
                                return
                            }
                            case 6: {
                                menuSideBar.currentIndex = index
                                stackView.push("controls/Language.qml")
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
                stackView.push("controls/Home.qml")
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
