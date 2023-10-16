import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.12
import QtMultimedia 5.15
import org.mauikit.controls 1.3 as Maui

Maui.Page
{
    id: homePage

    Maui.AppView.title: "Home"
    Maui.AppView.iconName: "go-home"

    headBar.visible: false

    Maui.Theme.inherit: false
    Maui.Theme.colorSet: Maui.Theme.Window

    background: Rectangle {
        anchors.fill: parent
        color: Maui.ColorUtils.brightnessForColor(Maui.Theme.backgroundColor) == Maui.ColorUtils.Light ?Qt.lighter(Maui.Theme.backgroundColor,1.04) : Qt.lighter(Maui.Theme.backgroundColor,1.15)
    }

    Component.onCompleted: {
        viewIndex = 0
        stationIndex = 0
        getStations()
    }

    // GET STATIONS FROM RADIO BROWSER

    function getStations() {
        var xhr = new XMLHttpRequest();
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.HEADERS_RECEIVED) {
                print('HEADERS_RECEIVED')
            } else if(xhr.readyState === XMLHttpRequest.DONE) {
                print('DONE')
                var json = JSON.parse(xhr.responseText.toString())
                //popularStationsRepeater.model = json.items

                for(var i=0; i<json.length; i++) {
                    //console.info(json.items[i].title) // title of picture
                    //console.info(json.items[i].media.m) // url of thumbnail
                    //popularStationsModel.append({"title": json.items[i].title,"url": json.items[i].media.m})
                    stationsModel.append({"changeuuid": json[i].changeuuid,"stationuuid": json[i].stationuuid, "serveruuid": json[i].serveruuid,"name": json[i].name,"url": json[i].url,"url_resolved": json[i].url_resolved,"homepage": json[i].homepage,"favicon": json[i].favicon,"tags": json[i].tags,"country": json[i].country, "countrycode": json[i].countrycode, "iso_3166_2": json[i].iso_3166_2,"state": json[i].state, "language": json[i].language, "languagecodes": json[i].languagecodecs, "votes": json[i].votes,"lastchangetime": json[i].lastchangetime,"lastchangetime_iso8601": json[i].lastchangetime_iso8601,"codec": json[i].codec,"bitrate": json[i].bitrate,"hls": json[i].hls,"lastcheckok": json[i].lastcheckok,"lastchecktime": json[i].lastchecktime,"lastchecktime_iso8601": json[i].lastchecktime_iso8601,"lastcheckoktime": json[i].lastcheckoktime,"lastcheckoktime_iso8601": json[i].lastcheckoktime_iso8601,"lastlocalchecktime": json[i].lastlocalchecktime,"lastlocalchecktime_iso8601": json[i].lastlocalchecktime_iso8601,"clicktimestamp": json[i].clicktimestamp,"clicktimestamp_iso8601": json[i].clicktimestamp_iso8601,"clickcount": json[i].clickcount,"clicktrend": json[i].clicktrend,"ssl_error": json[i].ssl_error,"geo_lat	null": json[i].geo_latnull,"geo_long": json[i].geo_long, "has_extended_info": json[i].has_extended_info})
                }
            }
        }
        //xhr.open("GET", "http://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1&tags=munich");
        xhr.open("GET", "https://nl1.api.radio-browser.info/json/stations/search?limit=20&tagList=information&hidebroken=true&order=clickcount&reverse=true");
        xhr.send();
    }

    // CAROUSSEL

    ListModel {
        id: textModel
        ListElement {
            info: "Listen to over 40,000 global radio stations"
            colour: "#a8a8a8"
        }
        ListElement {
            info: "Radio database under public domain"
            colour: "#3daee9"
        }
        ListElement {
            info: "Visit Radio Browser"
            colour: "#41e9ab"
        }
    }

    /*
    Rectangle {
        id: carousselRect

        visible: false

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: stations.top
        anchors.margins: 20

        SwipeView {
            id: caroussel
            clip: true
            anchors.fill: parent
            currentIndex: indicator.currentIndex

            Repeater {
                model: textModel

                anchors.fill: parent

                Rectangle {
                    id: banner
                    color: Maui.ColorUtils.brightnessForColor(Maui.Theme.backgroundColor) == Maui.ColorUtils.Light ? Qt.lighter(colour,1.7) : Qt.darker(colour,2.0)
                    radius: 4
                    Label {
                        anchors.fill: parent
                        anchors.margins: 10
                        text: info
                        font.pixelSize: 30
                        wrapMode: Text.WordWrap
                        elide: Qt.ElideRight
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }
        }
    }

    PageIndicator {
        id: indicator
        visible: false
        count: caroussel.count
        anchors.top: carousselRect.bottom
        x: (parent.width/2) - (width/2)
        currentIndex: caroussel.currentIndex
        transform: Translate {
            y: -50
        }
    }
    */

    // STATIONS (OLDIES)

    GridView {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom // moreRadiosPanel.top
        anchors.margins: 20

        cellWidth: 145 /*110*/; cellHeight: 165 /*135*/

        model: stationsModel
        delegate: Rectangle {
            width: 130 /*100*/; height: 155 /*125*/
            color: row1StationMouse.hovered ? (Maui.ColorUtils.brightnessForColor(Maui.Theme.backgroundColor) == Maui.ColorUtils.Light ? Qt.darker(Maui.Theme.alternateBackgroundColor,1.04) : Qt.lighter(Maui.Theme.alternateBackgroundColor,1.6)) : Qt.lighter(Maui.Theme.backgroundColor,1.04)
            radius: 4
            Rectangle {
                width: parent.width
                height: parent.height - itemLabel.height
                color: "transparent"
                radius: 4
                Maui.IconItem
                {
                    anchors.centerIn: parent
                    anchors.margins: 20
                    imageSource: favicon == "" ? "qrc:/assets/pixabay-cc0-mod2-cassette-2672633_640.png" : favicon
                    iconSource: "emblem-music-symbolic"
                    imageSizeHint: 110 /*80*/
                    maskRadius: Maui.Style.radiusV
                    fillMode: Image.PreserveAspectCrop
                }
            }
            Rectangle {
                id: itemLabel
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                height: 25
                color: "transparent"
                //color: row1StationMouse.hovered ? (Maui.ColorUtils.brightnessForColor(Maui.Theme.backgroundColor) == Maui.ColorUtils.Light ? Qt.lighter(Maui.Theme.highlightColor,1.5) : Qt.lighter(Maui.Theme.backgroundColor,1.4)) : Qt.lighter(Maui.Theme.alternateBackgroundColor,1.01)
                radius: 4
                Label {
                    id: row1Label
                    anchors.fill: parent
                    anchors.margins: 10
                    opacity: 0.75
                    height: 15
                    text: name
                    elide: Qt.ElideRight
                    font.pixelSize: 12
                }
            }
            HoverHandler {
                id: row1StationMouse
            }
            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                onClicked: {
                    if (mouse.button == Qt.LeftButton)
                    {
                        player.stop()
                        player.source = url_resolved
                        stationIndex = index
                        player.play()
                        radioicon = favicon == "" ? "qrc:/assets/pixabay-cc0-mod2-cassette-2672633_640.png" : favicon
                        stationName = name
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
                        onTriggered: {
                            Qt.openUrlExternally(stationsModel.get(rightStationIndex).homepage)
                        }
                    }
                }
            }
        }
    }

    /*
    // MORE BUTTON

    Kirigami.ShadowedRectangle {
        id: moreRadiosPanel

        Kirigami.Theme.colorSet: Kirigami.Theme.View
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.leftMargin: 20
        anchors.bottomMargin: 20
        visible: false // true
        height: 80
        width: 80
        color: Maui.ColorUtils.brightnessForColor(Maui.Theme.backgroundColor) == Maui.ColorUtils.Light ? Kirigami.Theme.backgroundColor : Qt.lighter(Kirigami.Theme.backgroundColor,1.5)
        border.color: Maui.ColorUtils.brightnessForColor(Maui.Theme.backgroundColor) == Maui.ColorUtils.Light ? Kirigami.Theme.backgroundColor : Qt.lighter(Kirigami.Theme.backgroundColor,1.5)
        border.width: 2
        shadow.size: 20
        shadow.color: Maui.ColorUtils.brightnessForColor(Maui.Theme.backgroundColor) == Maui.ColorUtils.Light ? "#dadada" : "#2c2c2c"
        shadow.xOffset: -5
        shadow.yOffset: 5
        radius: 6
        z: 1
        Button {
            anchors.fill: parent
            anchors.margins: 10
            flat: true
            icon.name: "list-add"
            text: "Oldies"
            display: AbstractButton.TextUnderIcon
            onClicked: {
                //sideBarIndex = 1
                _stackViewHome.push("qrc:/MoreStationsPage.qml")
                //_stackViewSidePanel.push("qrc:/PlayerAndSongsPage.qml")
            }
        }
    }
    */
}
