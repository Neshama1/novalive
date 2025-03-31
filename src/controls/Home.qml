import QtQuick 2.15
import QtQuick.Controls 2.15
import org.mauikit.controls 1.3 as Maui
import QtQuick.Layouts 1.15

Maui.Page {
    id: homePage

    showCSDControls: true

    headBar.background: Rectangle {
        anchors.fill: parent
        Maui.Theme.inherit: false
        Maui.Theme.colorSet: Maui.Theme.View
        color: Maui.Theme.backgroundColor
    }

    Maui.IconItem
    {
        anchors.fill: parent
        anchors.margins: 0
        imageSource: "qrc:/stars-pixabay-clouds-7689100_1280.png"
        imageSizeHint: parent.height
        maskRadius: Maui.Style.radiusV
        fillMode: Image.PreserveAspectCrop
    }

    ColumnLayout {
        width: parent.width - 40
        anchors.centerIn: parent
        Label {
            Layout.alignment: Qt.AlignCenter
            anchors.left: parent.left
            anchors.right: parent.right
            elide: Text.ElideRight
            wrapMode: Text.WordWrap
            font.pixelSize: 25
            text: "Nova Live is an internet radio player based on RadioBrowser"
        }
        RoundButton {
            text: "Open your favorites to get started"
            onClicked: {
                menuSideBar.currentIndex = 1
                stackView.push("qrc:/Favorites.qml")
            }
        }
    }

    /*
    Maui.FloatingButton
    {
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.margins: 20
        width: 60
        height: width
        icon.name: "go-next"
        onClicked: stackView.push("qrc:/APIKeyYouTube3.qml")
    }
    */
}
