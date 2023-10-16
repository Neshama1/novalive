import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.12
import QtMultimedia 5.15
import org.mauikit.controls 1.3 as Maui
import org.kde.novalive 1.0

Maui.Page {

    headBar.visible: false

    Maui.Theme.inherit: false
    Maui.Theme.colorSet: Maui.Theme.Window

    Component.onCompleted: {
        countries.currentIndex = countriesCurrentIndex
    }

    ListView {
        id: countries
        anchors.fill: parent
        anchors.margins: 10

        spacing: 5

        model: countryNameModel
        delegate: Maui.ListBrowserDelegate
        {
            id: list1
            implicitWidth: parent.width
            implicitHeight: 35
            iconSource: "draw-circle"
            label1.text: modelData

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    countries.currentIndex = index
                    countriesCurrentIndex = index
                    stationsByCountryModel.clear()
                    getStations(CountryBackend.code[index])
                }
            }
        }
    }

    function getStations(code) {
        var xhr = new XMLHttpRequest();
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.HEADERS_RECEIVED) {
                print('HEADERS_RECEIVED')
            } else if(xhr.readyState === XMLHttpRequest.DONE) {
                print('DONE')
                var json = JSON.parse(xhr.responseText.toString())

                for(var i=0; i<json.length; i++) {
                    stationsByCountryModel.append({"changeuuid": json[i].changeuuid,"stationuuid": json[i].stationuuid, "serveruuid": json[i].serveruuid,"name": json[i].name,"url": json[i].url,"url_resolved": json[i].url_resolved,"homepage": json[i].homepage,"favicon": json[i].favicon,"tags": json[i].tags,"country": json[i].country, "countrycode": json[i].countrycode, "iso_3166_2": json[i].iso_3166_2,"state": json[i].state, "language": json[i].language, "languagecodes": json[i].languagecodecs, "votes": json[i].votes,"lastchangetime": json[i].lastchangetime,"lastchangetime_iso8601": json[i].lastchangetime_iso8601,"codec": json[i].codec,"bitrate": json[i].bitrate,"hls": json[i].hls,"lastcheckok": json[i].lastcheckok,"lastchecktime": json[i].lastchecktime,"lastchecktime_iso8601": json[i].lastchecktime_iso8601,"lastcheckoktime": json[i].lastcheckoktime,"lastcheckoktime_iso8601": json[i].lastcheckoktime_iso8601,"lastlocalchecktime": json[i].lastlocalchecktime,"lastlocalchecktime_iso8601": json[i].lastlocalchecktime_iso8601,"clicktimestamp": json[i].clicktimestamp,"clicktimestamp_iso8601": json[i].clicktimestamp_iso8601,"clickcount": json[i].clickcount,"clicktrend": json[i].clicktrend,"ssl_error": json[i].ssl_error,"geo_lat	null": json[i].geo_latnull,"geo_long": json[i].geo_long, "has_extended_info": json[i].has_extended_info})
                }
                stationsByCountryCount = stationsByCountryModel.count
            }
        }
        xhr.open("GET", "https://nl1.api.radio-browser.info/json/stations/search?limit=999&countrycode=" + code + "&hidebroken=true&order=clickcount&reverse=true");
        xhr.send();
    }
}
