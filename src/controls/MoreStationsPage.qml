import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.12
import org.mauikit.controls 1.3 as Maui

Maui.Page
{
    id: moreStationsPage

    Maui.AppView.title: "Home"
    Maui.AppView.iconName: "go-home"

    headBar.visible: false

    signal stationChanged(string favicon)

    Component.onCompleted: {
        stationIndex = 0
        getMoreStations()
    }

    Maui.Theme.inherit: false
    Maui.Theme.colorSet: Maui.Theme.Window

    background: Rectangle {
        anchors.fill: parent
        color: Maui.ColorUtils.brightnessForColor(Maui.Theme.backgroundColor) == Maui.ColorUtils.Light ?Qt.lighter(Maui.Theme.backgroundColor,1.04) : Qt.lighter(Maui.Theme.backgroundColor,1.15)
    }

    // GET STATIONS FROM RADIO BROWSER

    function getMoreStations() {
        var xhr = new XMLHttpRequest();
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.HEADERS_RECEIVED) {
                print('HEADERS_RECEIVED')
            } else if(xhr.readyState === XMLHttpRequest.DONE) {
                print('DONE')
                var json = JSON.parse(xhr.responseText.toString())

                for(var i=0; i<json.length; i++) {
                    console.info(json[i].name) // title of picture
                    console.info(json[i].favicon) // url of thumbnail
                    stationsModel.append({"changeuuid": json[i].changeuuid,"stationuuid": json[i].stationuuid, "serveruuid": json[i].serveruuid,"name": json[i].name,"url": json[i].url,"url_resolved": json[i].url_resolved,"homepage": json[i].homepage,"favicon": json[i].favicon,"tags": json[i].tags,"country": json[i].country, "countrycode": json[i].countrycode, "iso_3166_2": json[i].iso_3166_2,"state": json[i].state, "language": json[i].language, "languagecodes": json[i].languagecodecs, "votes": json[i].votes,"lastchangetime": json[i].lastchangetime,"lastchangetime_iso8601": json[i].lastchangetime_iso8601,"codec": json[i].codec,"bitrate": json[i].bitrate,"hls": json[i].hls,"lastcheckok": json[i].lastcheckok,"lastchecktime": json[i].lastchecktime,"lastchecktime_iso8601": json[i].lastchecktime_iso8601,"lastcheckoktime": json[i].lastcheckoktime,"lastcheckoktime_iso8601": json[i].lastcheckoktime_iso8601,"lastlocalchecktime": json[i].lastlocalchecktime,"lastlocalchecktime_iso8601": json[i].lastlocalchecktime_iso8601,"clicktimestamp": json[i].clicktimestamp,"clicktimestamp_iso8601": json[i].clicktimestamp_iso8601,"clickcount": json[i].clickcount,"clicktrend": json[i].clicktrend,"ssl_error": json[i].ssl_error,"geo_lat	null": json[i].geo_latnull,"geo_long": json[i].geo_long, "has_extended_info": json[i].has_extended_info})
                }
            }
        }
        xhr.open("GET", "https://at1.api.radio-browser.info/json/stations/search?limit=1000&tagList=50s&hidebroken=true&order=clickcount&reverse=true");
        xhr.send();
    }

    // STATIONS (OLDIES)

    GridView {

        anchors.fill: parent
        anchors.margins: 20

        cellWidth: 145; cellHeight: 165

        model: stationsModel
        delegate: Rectangle {
            Maui.Theme.inherit: false
            Maui.Theme.colorSet: Maui.Theme.View
            width: 130; height: 155
            color: stationMouse.hovered ? (Maui.ColorUtils.brightnessForColor(Maui.Theme.backgroundColor) == Maui.ColorUtils.Light ? Qt.darker(Maui.Theme.alternateBackgroundColor,1.04) : Qt.lighter(Maui.Theme.backgroundColor,1.2)) : Qt.lighter(Maui.Theme.alternateBackgroundColor,1.02)
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
                    imageSizeHint: 110
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
                radius: 4
                Label {
                    id: stationLabel
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10
                    anchors.topMargin: 0
                    opacity: 0.75
                    height: 15
                    text: name
                    elide: Qt.ElideRight
                    font.pixelSize: 12
                }
            }
            HoverHandler {
                id: stationMouse
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    player.stop()
                    player.source = url_resolved
                    stationIndex = index
                    player.play()
                    radioicon = favicon == "" ? "qrc:/assets/pixabay-cc0-mod2-cassette-2672633_640.png" : favicon
                    stationName = name
                }
            }
        }
    }

    // RADIO NAME

    Label {
        id: radioName
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.rightMargin: 20
        anchors.bottomMargin: 20
        text: stationName
    }
}
