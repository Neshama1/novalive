import QtQuick
import QtQml
import QtQuick.Controls
import QtQuick.Layouts
import org.mauikit.controls as Maui
import Qt.labs.settings

Maui.SettingsDialog
{
    headBar.background: Maui.ShadowedRectangle {
        anchors.fill: parent

        Maui.Theme.inherit: false
        Maui.Theme.colorSet: Maui.Theme.View

        border.width: 0
        border.color: Qt.lighter("#dadada",1.08)
        shadow.size: 15
        shadow.color: Maui.ColorUtils.brightnessForColor(Maui.Theme.backgroundColor) == Maui.ColorUtils.Light ? Qt.darker("#dadada",1.1) : "#2c2c2c"
        shadow.xOffset: -1
        shadow.yOffset: 0

        color: Maui.Theme.backgroundColor
        corners.topLeftRadius: 6
        corners.topRightRadius: 6
    }

    background: Maui.ShadowedRectangle {
        anchors.fill: parent

        Maui.Theme.inherit: false
        Maui.Theme.colorSet: Maui.Theme.View

        border.width: 0
        border.color: Qt.lighter("#dadada",1.08)
        shadow.size: 15
        shadow.color: Maui.ColorUtils.brightnessForColor(Maui.Theme.backgroundColor) == Maui.ColorUtils.Light ? Qt.darker("#dadada",1.1) : "#2c2c2c"
        shadow.xOffset: -1
        shadow.yOffset: 0

        color: Maui.Theme.backgroundColor
        corners.topLeftRadius: 6
        corners.topRightRadius: 6
        corners.bottomLeftRadius: 6
        corners.bottomRightRadius: 6
    }

    Maui.SectionGroup
    {
        title: i18n("")
        description: i18n("YouTube")

        Maui.SectionItem
        {
            label1.text:  i18n("YouTube API Key")
            label2.text: i18n("Provides access to YouTube")
            TextField {
                placeholderText: qsTr("Enter YouTube API Key v3")
                text: apiKeyYouTube
                onEditingFinished: {
                    apiKeyYouTube = text
                }
            }
        }
    }
}
