import QtQuick
import QtQuick.Controls
import org.mauikit.controls as Maui
import QtQuick.Layouts

Maui.Page {
    id: apiKeyYouTube2Page

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
        target: apiKeyYouTube2Page
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
        Label {
            Layout.alignment: Qt.AlignCenter
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.rightMargin: 80
            elide: Text.ElideRight
            wrapMode: Text.WordWrap
            font.pixelSize: 25
            text: "Provide your own API key, follow the steps indicated and copy the key generated"
        }
        RoundButton {
            text: "Open link in your default browser"
            onClicked: Qt.openUrlExternally("https://github.com/headsetapp/headset-electron/wiki/Get-Youtube-API-Key")
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
        onClicked: stackView.push("qrc:/org/kde/novalive/controls/APIKeyYouTube3.qml")
    }
}
