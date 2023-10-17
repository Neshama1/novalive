import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.12
import QtMultimedia 5.15
import org.mauikit.controls 1.3 as Maui
import Qt.labs.settings 1.0

Maui.Page
{
    id: favoritesPage

    headBar.visible: false

    Maui.Theme.inherit: false
    Maui.Theme.colorSet: Maui.Theme.Window

    background: Rectangle {
        anchors.fill: parent
        color: Maui.ColorUtils.brightnessForColor(Maui.Theme.backgroundColor) == Maui.ColorUtils.Light ?Qt.lighter(Maui.Theme.backgroundColor,1.04) : Qt.lighter(Maui.Theme.backgroundColor,1.15)
    }

    property string favorites: ""

    Settings {
        property alias favorites: favoritesPage.favorites
    }

    Component.onCompleted: {
        if (favorites) {
            favoritesModel.clear()
        }

        // Leer favoritos de ~/.config/KDE/novalive.conf
        var datamodel = JSON.parse(favorites)
        for (var i = 0; i < datamodel.length; ++i)
        {
            favoritesModel.append(datamodel[i])
        }
    }

    Component.onDestruction: {
        var datamodel = []

        // Guardar favoritos en ~/.config/KDE/novalive.conf
        for (var i = 0; i < favoritesModel.count; ++i)
        {
            datamodel.push(favoritesModel.get(i))
        }
        favorites = JSON.stringify(datamodel)
    }

    // HOLDER

	Maui.Holder
	{
		anchors.fill: parent
		visible: favoritesModel.count == 0 ? true : false
		title: i18n("Favorite")
		body: i18n("Add radio stations to my favorites")
		emoji: "favorite"
		isMask: false
	}

    // FAVORITES

    GridView {

        anchors.fill: parent
        anchors.margins: 20

        cellWidth: 145; cellHeight: 165

        model: favoritesModel
        delegate: Rectangle {
            width: 130; height: 155
            color: stationMouse.hovered ? (Maui.ColorUtils.brightnessForColor(Maui.Theme.backgroundColor) == Maui.ColorUtils.Light ? Qt.darker(Maui.Theme.alternateBackgroundColor,1.04) : Qt.lighter(Maui.Theme.alternateBackgroundColor,1.6)) : Qt.lighter(Maui.Theme.backgroundColor,1.04)
            radius: 4
            Rectangle {
                width: parent.width
                height: parent.height - itemLabel.height
                color: "transparent"
                radius: 4
                Maui.IconItem
                {
                    anchors.centerIn: parent
                    anchors.margins: 20
                    imageSource: favicon == "" ? "qrc:/assets/pixabay-cc0-mod2-cassette-2672633_640.png" : favicon
                    iconSource: "emblem-music-symbolic"
                    imageSizeHint: 110
                    maskRadius: Maui.Style.radiusV
                    fillMode: Image.PreserveAspectCrop
                }
            }
            Rectangle {
                id: itemLabel
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                height: 25
                color: "transparent"
                radius: 4
                Label {
                    id: stationLabel
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10
                    anchors.topMargin: 0
                    opacity: 0.75
                    height: 15
                    text: name
                    elide: Qt.ElideRight
                    font.pixelSize: 12
                }
            }
            HoverHandler {
                id: stationMouse
            }
            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                onClicked: {
                    if (mouse.button == Qt.LeftButton)
                    {
                        player.stop()
                        player.source = url_resolved
                        stationIndex = index
                        player.play()
                        radioicon = favicon == "" ? "qrc:/assets/pixabay-cc0-mod2-cassette-2672633_640.png" : favicon
                        stationName = name
                        if (sideBarIndex != 2) {
                            sideBarIndex = 2
                            _stackViewSidePanel.push("qrc:/PlayerAndSongsPage.qml")
                        }
                    }
                    if (mouse.button == Qt.RightButton)
                    {
                        rightStationIndex = index
                        contextMenu.popup()
                    }
                }
                Menu {
                    id: contextMenu
                    MenuItem {
                        text: "Remove"
                        onTriggered: {
                            favoritesModel.remove(rightStationIndex)
                        }
                    }
                    MenuItem {
                        text: "Visit website"
                        onTriggered: {
                            Qt.openUrlExternally(favoritesModel.get(rightStationIndex).homepage)
                        }
                    }
                }
            }
        }
    }
}
