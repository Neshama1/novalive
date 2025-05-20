import QtQuick
import QtQuick.Controls
import org.mauikit.controls as Maui

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

    headBar.leftContent: ToolButton {
        icon.name: "draw-arrow-back"
        onClicked: {
            player.pause = true
            stackView.push("Notifications.qml")
        }
    }

    Component.onCompleted: {
        xAnimation.start()
        player.pause = true
        youTubeModel.clear()
        search(notificationsModel.get(notificationsCurrentIndex).title)
    }

    Component.onDestruction: {
        player.pause = true
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
            height: 50
            Maui.SwipeBrowserDelegate
            {
                anchors.fill: parent
                label1.text: title
                label2.text: description
                //iconSource: thumbnailUrl
                iconSizeHint: Maui.Style.iconSizes.medium

                onClicked: {
                    list.currentIndex = index

                    var ytVideoUrl = "https://www.youtube.com/watch?v=" + videoId

                    console.info("url", ytVideoUrl)

                    player.pause = true
                    player.loadFile(ytVideoUrl)
                    player.pause = false
                    stationLoaded = false
                    player.position = 0
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
            if (player.pause) {
                playButton.icon.name = "media-playback-stop"
                player.pause = false
            }
            else {
                playButton.icon.name = "media-playback-start"
                player.pause = true
            }
        }
    }
}
