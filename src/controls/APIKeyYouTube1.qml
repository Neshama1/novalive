import QtQuick
import QtQuick.Controls
import org.mauikit.controls as Maui
import QtQuick.Layouts

Maui.Page {
    id: apiKeyYouTube1Page

    Maui.Controls.showCSD: true

    headBar.background: Rectangle {
        anchors.fill: parent
        Maui.Theme.inherit: false
        Maui.Theme.colorSet: Maui.Theme.View
        color: Maui.Theme.backgroundColor
    }

    Component.onCompleted: {
        xAnimation.start()
    }

    PropertyAnimation {
        id: xAnimation
        target: apiKeyYouTube1Page
        properties: "x"
        from: - parent.width
        to: 0
        duration: 2000
        easing.type: Easing.OutExpo
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
        width: parent.width - 40
        Maui.IconItem
        {
            Layout.alignment: Qt.AlignCenter
            anchors.left: parent.left
            anchors.right: parent.right
            imageSource: "qrc:/pixabay-cassette-4103530_1280.png"
            imageSizeHint: 270
            maskRadius: Maui.Style.radiusV
            fillMode: Image.PreserveAspectCrop
        }
        Label {
            Layout.alignment: Qt.AlignCenter
            anchors.left: parent.left
            anchors.right: parent.right
            elide: Text.ElideRight
            wrapMode: Text.WordWrap
            font.pixelSize: 28
            text: "Listen to your radio station history on YouTube again"
        }
    }

    Maui.FloatingButton
    {
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.margins: 20
        width: 60
        height: width
        icon.name: "go-next"
        onClicked: stackView.push("qrc:/org/kde/novalive/controls/APIKeyYouTube2.qml")
    }
}
