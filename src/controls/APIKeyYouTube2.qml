import QtQuick
import QtQuick.Controls
import org.mauikit.controls as Maui
import QtQuick.Layouts

Maui.Page {
    id: apiKeyYouTube2Page

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
        imageSource: "qrc:/assets/stars-pixabay-clouds-7689100_1280.png"
        imageSizeHint: parent.height
        maskRadius: Maui.Style.radiusV
        fillMode: Image.PreserveAspectCrop
        scale: 1.5
    }

    ColumnLayout {
        anchors.centerIn: parent
        width: parent.width - 40
        Label {
            Layout.alignment: Qt.AlignHCenter
            Layout.bottomMargin: 20
            Layout.preferredWidth: parent.width
            Layout.maximumWidth: parent.width - 200
            horizontalAlignment: Qt.AlignHCenter
            elide: Text.ElideRight
            wrapMode: Text.WordWrap
            font.pixelSize: 25
            text: "Provide your own API key, follow the steps indicated and copy the key generated"
        }
        RoundButton {
            Layout.alignment: Qt.AlignHCenter
            text: "Open link in your default browser"
            onClicked: Qt.openUrlExternally("https://docs.themeum.com/tutor-lms/tutorials/get-youtube-api-key")
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
        onClicked: stackView.push("APIKeyYouTube3.qml")
    }
}
