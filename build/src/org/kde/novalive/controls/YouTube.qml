import QtQuick
import QtQuick.Controls
import org.mauikit.controls as Maui
import QtMultimedia

Maui.Page {
    id: youTubePage

    Maui.Controls.showCSD: true

    headBar.background: Rectangle {
        anchors.fill: parent
        Maui.Theme.inherit: false
        Maui.Theme.colorSet: Maui.Theme.View
        color: Maui.Theme.backgroundColor
    }

    headBar.rightContent: Maui.ToolButtonMenu
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

    headBar.leftContent: ToolButton {
        icon.name: "draw-arrow-back"
        onClicked: {
            mpvPlayer.setProperty("pause",true)
            stackView.push("qrc:/Notifications.qml")
        }
    }

    Component.onCompleted: {
        xAnimation.start()
        player.stop()
        youTubeModel.clear()
        search(notificationsModel.get(notificationsCurrentIndex).title)
    }

    Component.onDestruction: {
        mpvPlayer.setProperty("pause",true)
    }

    PropertyAnimation {
        id: xAnimation
        target: youTubePage
        properties: "x"
        from: - parent.width
        to: 0
        duration: 2000
        easing.type: Easing.OutExpo
    }

    function search(query) {
        var xhr = new XMLHttpRequest();
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.HEADERS_RECEIVED) {
                print('HEADERS_RECEIVED')
            } else if(xhr.readyState === XMLHttpRequest.DONE) {
                print('DONE');
                var obj = JSON.parse(xhr.responseText.toString());

                for(var i=0; i<obj.items.length; i++) {
                    youTubeModel.append({"videoId": obj.items[i].id.videoId,"title": obj.items[i].snippet.title,"thumbnailUrl": obj.items[i].snippet.thumbnails.default.url,"description": obj.items[i].snippet.description})
                }
            }
        }
        xhr.open("GET", "https://www.googleapis.com/youtube/v3/search?part=snippet&q=" + query + "&key=" + apiKeyYouTube);
        xhr.send();
    }

    Maui.ListBrowser {
        id: list
        anchors.fill: parent
        anchors.margins: 20

        horizontalScrollBarPolicy: ScrollBar.AsNeeded
        verticalScrollBarPolicy: ScrollBar.AsNeeded

        spacing: 10

        model: youTubeModel

        delegate: Rectangle {
            color: "transparent"
            width: ListView.view.width
            height: 80
            Maui.SwipeBrowserDelegate
            {
                anchors.fill: parent
                label1.text: title
                label2.text: description
                iconSource: thumbnailUrl
                iconSizeHint: Maui.Style.iconSizes.medium

                onClicked: {
                    list.currentIndex = index
                    mpvPlayer.command(["loadfile", "https://www.youtube.com/watch?v=" + videoId])
                    mpvPlayer.setProperty("pause",false)
                    mpvPlayer.setProperty("time-pos", 0)
                    playButton.icon.name = "media-playback-stop"
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
        icon.name: "media-playback-start"
        onClicked: {
            if (mpvPlayer.getProperty("pause") == true) {
                playButton.icon.name = "media-playback-stop"
                mpvPlayer.setProperty("pause",false)
            }
            else {
                playButton.icon.name = "media-playback-start"
                mpvPlayer.setProperty("pause",true)
            }
        }
    }
}
