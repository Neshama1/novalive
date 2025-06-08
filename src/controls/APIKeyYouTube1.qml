import QtQuick
import QtQuick.Controls
import org.mauikit.controls as Maui
import QtQuick.Layouts

Maui.Page {
    id: apiKeyYouTube1Page

    Maui.Controls.showCSD: true

    headBar.visible: false

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
        imageSource: "qrc:/assets/stars-pixabay-clouds-7689100_1280.png"
        imageSizeHint: parent.height
        maskRadius: Maui.Style.radiusV
        fillMode: Image.PreserveAspectCrop
        scale: 1.5
    }

    ColumnLayout {
        anchors.centerIn: parent
        width: parent.width - 40

        Maui.IconItem
        {
            id: iconItem

            Layout.alignment: Qt.AlignHCenter
            imageSource: "qrc:/assets/pixabay-cassette-4103530_1280.png"
            imageSizeHint: 270
            maskRadius: Maui.Style.radiusV
            fillMode: Image.PreserveAspectCrop
            scale: 0.8
        }

        Label {
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: parent.width
            Layout.maximumWidth: 600
            horizontalAlignment: Text.AlignHCenter
            elide: Text.ElideRight
            wrapMode: Text.WordWrap
            font.pixelSize: 28
            opacity: 0.8
            text: "Listen to your radio station history on YouTube again"
        }
    }

    Button {
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.margins: 20
        icon.width: 32
        icon.height: 32
        icon.name: "go-next"
        flat: true
        onClicked: stackView.push("APIKeyYouTube2.qml")
    }
}
