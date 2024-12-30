import QtQuick
import QtQuick.Controls
import org.mauikit.controls as Maui
import QtQuick.Layouts

Maui.Page {
    id: apiKeyYouTube3Page

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
        imageSource: "qrc:/stars-pixabay-clouds-7689100_1280.png"
        imageSizeHint: parent.height
        maskRadius: Maui.Style.radiusV
        fillMode: Image.PreserveAspectCrop
    }

    ColumnLayout {
        anchors.centerIn: parent
        width: parent.width - 180
        Label {
            Layout.alignment: Qt.AlignCenter
            elide: Text.ElideRight
            wrapMode: Text.WordWrap
            font.pixelSize: 25
            text: "Paste the key generated"
        }
        TextField {
            id: textField
            Layout.alignment: Qt.AlignCenter
            onAccepted: apiKeyYouTube = text
        }
    }

    Maui.FloatingButton
    {
        id: backButton
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.margins: 20
        width: 60
        height: width
        icon.name: "go-previous"
        icon.color: Maui.ColorUtils.brightnessForColor(Maui.Theme.backgroundColor) == Maui.ColorUtils.Light ? "black" : "white"
        background: Rectangle {
            anchors.fill: parent
            radius: 4
            color: Maui.ColorUtils.brightnessForColor(Maui.Theme.backgroundColor) == Maui.ColorUtils.Light ? "white" : "dimgrey"
        }
        onClicked: stackView.push("qrc:/org/kde/novalive/controls/APIKeyYouTube2.qml")
    }

    Maui.FloatingButton
    {
        id: nextButton
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.margins: 20
        width: 60
        height: width
        icon.name: "go-next"
        onClicked: {
            apiKeyYouTube = textField.text
            stackView.push("qrc:/org/kde/novalive/controls/YouTube.qml")
        }
    }
}
