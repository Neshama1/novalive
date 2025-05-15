import QtQuick
import QtQuick.Controls
import org.mauikit.controls as Maui
import QtQuick.Layouts

Maui.Page {
    id: apiKeyYouTube3Page

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
        target: apiKeyYouTube3Page
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

    Maui.ShadowedRectangle {
        anchors.centerIn: parent

        width: 400
        height: 400
        radius: 0
        color: Qt.lighter(Maui.Theme.alternateBackgroundColor, 1.03)
        border.width: 0
        shadow.size: 10
        shadow.color: Maui.ColorUtils.brightnessForColor(Maui.Theme.backgroundColor) == Maui.ColorUtils.Light ? "#dadada" : "#2c2c2c"
        shadow.xOffset: 0
        shadow.yOffset: 0

        ColumnLayout {
            anchors.centerIn: parent
            width: 250
            Label {
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                Layout.margins: 10
                Layout.preferredWidth: parent.width
                Layout.maximumWidth: parent.width - 50
                horizontalAlignment: Qt.AlignHCenter
                elide: Text.ElideRight
                wrapMode: Text.WordWrap
                font.pixelSize: 25
                text: "Paste the API Key generated"
            }
            TextField {
                id: textField
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                Layout.margins: 10
                Layout.minimumHeight: 40
                height: 40
                onAccepted: apiKeyYouTube = text
                background: Maui.ProgressIndicator {
                    anchors.fill: parent
                }
            }
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
        onClicked: {
            apiKeyYouTube = textField.text
            sideBarWidth = 215
            stackView.push("YouTube.qml")
        }
    }
}
