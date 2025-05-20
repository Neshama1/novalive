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
        imageSource: "qrc:/assets/stars-pixabay-clouds-7689100_1280.png"
        imageSizeHint: parent.height
        maskRadius: Maui.Style.radiusV
        fillMode: Image.PreserveAspectCrop
    }

    ColumnLayout {
        anchors.centerIn: parent

        width: parent.width
        height: 70

        Label {
            Layout.leftMargin: 20
            Layout.rightMargin: 20
            Layout.minimumHeight: 0
            Layout.maximumHeight: parent.height
            Layout.preferredHeight: parent.height
            Layout.minimumWidth: 0
            Layout.maximumWidth: parent.width > 600 ? 600 - 40 : parent.width - 40
            Layout.preferredWidth: parent.width

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
                stackView.push("Favorites.qml")
            }
        }
    }
}
