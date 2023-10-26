import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.12
import QtQuick.Window 2.2
import org.mauikit.controls 1.3 as Maui
import QtMultimedia 5.15

Maui.ApplicationWindow
{
    id: root
    title: qsTr("Nova Live")

    width: Screen.desktopAvailableWidth - Screen.desktopAvailableWidth * 45 / 100
    height: Screen.desktopAvailableHeight - Screen.desktopAvailableHeight * 25 / 100

    property int stationIndex
    property int rightStationIndex
    property string stationName
    property string title
    property string radioicon
    property bool holder: true
    property int genresCurrentIndex: 0
    property int countriesCurrentIndex: 0
    property int languagesCurrentIndex: 0
    property int stationsByGenreCount
    property int stationsByCountryCount
    property int stationsByLanguageCount
    property int stationSearchCount
    property int viewIndex: 0

    // sideBarIndex
    // 0 :
    // 1 : PlayerAndSongsPage.qml
    // 2 : PlayerAndSongsPage.qml (with Back button)
    // 3 : GenresSideBarPage.qml
    // 4 : CountrySideBarPage.qml

    property int sideBarIndex: 1

    Component.onCompleted: {
        _stackViewSidePanel.push("qrc:/PlayerAndSongsPage.qml")
        _stackViewHome.push("qrc:/HomePage.qml")
        _stackViewGenres.push("qrc:/StationsByGenrePage.qml")
        _stackViewCountry.push("qrc:/StationsByCountryPage.qml")
        _stackViewLanguage.push("qrc:/StationsByLanguagePage.qml")
        _stackViewSearch.push("qrc:/SearchStationsPage.qml")
        _stackViewFavorites.push("qrc:/FavoritesPage.qml")
        _stackViewSoulFunk.push("qrc:/SoulFunkPage.qml")
    }

    ListModel {
    id: playedSongsModel
    }

    ListModel {
        id: stationsModel
    }

    ListModel {
        id: stationsByGenreModel
    }

    ListModel {
        id: stationsByCountryModel
    }

    ListModel {
        id: stationsByLanguageModel
    }

    ListModel {
        id: stationSearchModel
    }

    ListModel {
        id: favoritesModel
    }

    ListModel {
        id: soulfunkModel
    }

    // RADIO PLAYER

    MediaPlayer {
        id: player
        metaData.onMetaDataChanged: {
            if (title != player.metaData.title)
            {
                title = player.metaData.title
                const artistsong = title.split(" - ");
                if ((10*2 + 50*(playedSongsModel.count + 1) + 5*(playedSongsModel.count)) > (root.height - 2 * 46)) {
                    playedSongsModel.clear()
                }
                playedSongsModel.insert(0, {"artist": artistsong[0], "song": artistsong[1]})
            }
        }
        onPlaybackStateChanged: {
            if (viewIndex == 0 || viewIndex == 1 || viewIndex == 2 || viewIndex == 6)
            {
                player.playbackState == MediaPlayer.StoppedState ? holder = true : holder = false
            }
        }
    }

    Loader
    {
        active: true
        asynchronous: true
        sourceComponent: Maui.WindowBlur
        {
            view: root
            geometry: Qt.rect(root.x, root.y, root.width, root.height)
            windowRadius: root.background.radius
            enabled: true
        }
    }

    Maui.SideBarView
    {
        id: _sideBarView
        anchors.fill: parent

        sideBar.opacity: 1 // 0.80
        sideBar.preferredWidth: Maui.Style.units.gridUnit * 15

        sideBarContent: Maui.Page
        {
            anchors.fill: parent
            Maui.Theme.colorSet: Maui.Theme.Window

            background: Rectangle {
                anchors.fill: parent
                color: Maui.Theme.backgroundColor
            }

            headBar.visible: false

            StackView {
                id:_stackViewSidePanel
                anchors.fill: parent
                clip: true
            }
        }

        Maui.Page
        {
            anchors.fill: parent
            //title: _stackView.currentItem.title
            showCSDControls: false
            headBar.background: null
            headBar.visible: false

            headBar.leftContent: [
                ToolButton
                {
                    icon.name: "sidebar-collapse"
                    onClicked: _sideBarView.sideBar.toggle()
                    checked: _sideBarView.sideBar.visible
                }
            ]

            StackView {
                id:_stackView
                anchors.fill: parent
                clip: true

                Maui.AppViews
                {
                    id: _page
                    anchors.fill: parent

                    showCSDControls: true
                    headBar.forceCenterMiddleContent: true

                    onCurrentIndexChanged: {
                        if (currentIndex == 0)
                        {
                            viewIndex = 0
                            stationIndex = 0
                            sideBarIndex = 1
                            arrowBackView.visible = false
                            player.playbackState == MediaPlayer.StoppedState ? holder = true : holder = false
                            _stackViewSidePanel.push("qrc:/PlayerAndSongsPage.qml")
                        }
                        if (currentIndex == 1)
                        {
                            viewIndex = 1
                            stationIndex = 0
                            sideBarIndex = 1
                            arrowBackView.visible = false
                            player.playbackState == MediaPlayer.StoppedState ? holder = true : holder = false
                            _stackViewSidePanel.push("qrc:/PlayerAndSongsPage.qml")
                        }
                        if (currentIndex == 2)
                        {
                            viewIndex = 2
                            stationIndex = 0
                            sideBarIndex = 1
                            arrowBackView.visible = false
                            player.playbackState == MediaPlayer.StoppedState ? holder = true : holder = false
                            _stackViewSidePanel.push("qrc:/PlayerAndSongsPage.qml")
                        }
                        if (currentIndex == 3)
                        {
                            viewIndex = 3
                            stationIndex = 0
                            sideBarIndex = 3
                            //holder = false
                            arrowBackView.visible = false
                            _stackViewSidePanel.push("qrc:/GenresSideBarPage.qml")
                        }
                        if (currentIndex == 4)
                        {
                            viewIndex = 4
                            stationIndex = 0
                            sideBarIndex = 4
                            //holder = false
                            arrowBackView.visible = false
                            _stackViewSidePanel.push("qrc:/CountrySideBarPage.qml")
                        }
                        if (currentIndex == 5)
                        {
                            viewIndex = 5
                            stationIndex = 0
                            sideBarIndex = 5
                            //holder = false
                            arrowBackView.visible = false
                            _stackViewSidePanel.push("qrc:/LanguageSideBarPage.qml")
                        }
                        if (currentIndex == 6)
                        {
                            viewIndex = 6
                            stationIndex = 0
                            sideBarIndex = 1
                            arrowBackView.visible = false
                            player.playbackState == MediaPlayer.StoppedState ? holder = true : holder = false
                            _stackViewSidePanel.push("qrc:/PlayerAndSongsPage.qml")
                        }
                    }

                    headBar.leftContent: [
                        ToolButton
                        {
                            id: arrowBackView
                            icon.name: "draw-arrow-back"
                            onClicked: {
                                stationsModel.clear
                                _stackViewHome.pop()
                            }
                        }
                    ]

                    headBar.background: Rectangle {
                        anchors.fill: parent
                        color: Maui.Theme.backgroundColor
                    }

                    Maui.Page
                    {
                        Maui.AppView.title: "Home"
                        Maui.AppView.iconName: "go-home"
                        headBar.visible: false
                        StackView {
                            id: _stackViewHome
                            anchors.fill: parent
                            clip: true
                        }
                    }
                    Maui.Page
                    {
                        Maui.AppView.title: "Favorites"
                        Maui.AppView.iconName: "favorite"
                        headBar.visible: false
                        StackView {
                            id: _stackViewFavorites
                            anchors.fill: parent
                            clip: true
                        }
                    }

                    Maui.Page
                    {
                        Maui.AppView.title: "Soul & Funk"
                        Maui.AppView.iconName: "folder-music"
                        headBar.visible: false
                        StackView {
                            id: _stackViewSoulFunk
                            anchors.fill: parent
                            clip: true
                        }
                    }

                    Maui.Page
                    {
                        Maui.AppView.title: "Genre"
                        Maui.AppView.iconName: "view-media-genre"
                        Maui.AppView.badgeText: stationsByGenreCount.toString()
                        headBar.visible: false
                        StackView {
                            id: _stackViewGenres
                            anchors.fill: parent
                            clip: true
                        }
                    }
                    Maui.Page
                    {
                        Maui.AppView.title: "Country"
                        Maui.AppView.iconName: "flag"
                        Maui.AppView.badgeText: stationsByCountryCount.toString()
                        headBar.visible: false
                        StackView {
                            id: _stackViewCountry
                            anchors.fill: parent
                            clip: true
                        }
                    }
                    Maui.Page
                    {
                        Maui.AppView.title: "Language"
                        Maui.AppView.iconName: "languages"
                        Maui.AppView.badgeText: stationsByLanguageCount.toString()
                        headBar.visible: false
                        StackView {
                            id: _stackViewLanguage
                            anchors.fill: parent
                            clip: true
                        }
                    }
                    Maui.Page
                    {
                        Maui.AppView.title: "Search"
                        Maui.AppView.iconName: "search"
                        Maui.AppView.badgeText: stationSearchCount.toString()
                        headBar.visible: false
                        StackView {
                            id: _stackViewSearch
                            anchors.fill: parent
                            clip: true
                        }
                    }
                }
            }
        }
    }

}
