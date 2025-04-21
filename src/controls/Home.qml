import QtQuick
import QtQuick.Controls
import org.mauikit.controls as Maui
import QtQuick.Layouts

Maui.Page {
    id: homePage

    Maui.Controls.showCSD: true

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
        anchors.centerIn: parent

        //Layout.margins: 20

        //anchors.left: parent.left
        //anchors.right: parent.right
        //anchors.margins: 20

        //Layout.alignment: Qt.AlignVCenter
        //width: parent.width - 40

        width: parent.width
        height: 70

        //spacing: 10
        //Layout.minimumHeight: 200
        //Layout.maximumHeight: 300
        //Layout.preferredHeight: 250
        //Layout.fillHeight: true
        //Layout.preferredHeight: parent.height
        //Layout.minimumHeight: parent.height
        //Layout.maximumHeight: parent.height
        //anchors.centerIn: parent

        Label {
            //Layout.alignment: Qt.AlignVCenter
            //anchors.left: parent.left
            //anchors.right: parent.right

            //Layout.alignment: Qt.AlignHCenter

            Layout.leftMargin: 20
            Layout.rightMargin: 20
            Layout.minimumHeight: 0
            Layout.maximumHeight: parent.height
            Layout.preferredHeight: parent.height
            Layout.minimumWidth: 0
            Layout.maximumWidth: parent.width > 600 ? 600 - 40 : parent.width - 40
            Layout.preferredWidth: parent.width

            //width: parent.width
            //height: parent.height

            //Layout.fillHeight: true

            elide: Text.ElideRight
            wrapMode: Text.WordWrap
            font.pixelSize: 25
            text: "Nova Live is an internet radio player based on RadioBrowser"
        }
        RoundButton {
            Layout.leftMargin: 20
            Layout.rightMargin: 20
            text: "Open your favorites to get started"
            onClicked: {
                menuSideBar.currentIndex = 1
                stackView.push("qrc:/org/kde/novalive/controls/Favorites.qml")
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
