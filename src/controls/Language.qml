import QtQuick
import QtQuick.Controls
import org.mauikit.controls as Maui

Maui.Page {
    id: languagePage

    Maui.Controls.showCSD: true

    headBar.background: Rectangle {
        anchors.fill: parent
        Maui.Theme.inherit: false
        Maui.Theme.colorSet: Maui.Theme.View
        color: Maui.Theme.backgroundColor
    }

    Component.onCompleted: {
        opacityAnimation.start()
        xAnimation.start()
    }

    PropertyAnimation {
        id: opacityAnimation
        target: languagePage
        properties: "opacity"
        from: 0
        to: 1.0
        duration: 250
    }

    PropertyAnimation {
        id: xAnimation
        target: languagePage
        properties: "x"
        from: -20
        to: 0
        duration: 500
    }

    Maui.GridBrowser {
        anchors.fill: parent
        anchors.margins: 20
        itemSize: 200
        itemHeight: 200
        adaptContent: true
        horizontalScrollBarPolicy: ScrollBar.AsNeeded
        verticalScrollBarPolicy: ScrollBar.AsNeeded

        model: languageModel

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
                    text: modelData
                    font.pixelSize: 20
                    elide: Text.ElideRight
                }
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    languagesCurrentIndex = index
                    stationsByLanguageModel.clear()
                    stackView.push("qrc:/org/kde/novalive/controls/StationsByLanguage.qml")
                }
            }
        }
    }
}
