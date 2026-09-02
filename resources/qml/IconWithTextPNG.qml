import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import UM 1.5 as UM
import Cura 1.0 as Cura

Item
{
    property alias source: iconPng.source
    property alias iconSize: iconPng.width

    property alias color: labelPng.color
    property alias text: labelPng.text
    property alias font: labelPng.font
    property alias elide: labelPng.elide
    property alias wrapMode: labelPng.wrapMode

    property real margin: UM.Theme.getSize("narrow_margin").width
    property real spacing: UM.Theme.getSize("narrow_margin").width

    property string tooltipText: ""

    readonly property real contentWidth:
        iconPng.width + margin + labelPng.contentWidth

    readonly property real minContentWidth:
        Math.round(iconPng.width + margin + 0.5 * labelPng.contentWidth)

    Layout.minimumWidth: minContentWidth
    Layout.preferredWidth: contentWidth
    Layout.fillHeight: true
    Layout.fillWidth: true

    implicitWidth: iconPng.width + 100
    implicitHeight: iconPng.height

    Image
    {
        id: iconPng

        width: UM.Theme.getSize("section_icon").width
        height: width

        fillMode: Image.PreserveAspectFit
        smooth: true
        mipmap: true

        anchors
        {
            left: parent.left
            verticalCenter: parent.verticalCenter
        }
    }

    UM.Label
    {
        id: labelPng

        elide: Text.ElideRight

        anchors
        {
            left: iconPng.right
            right: parent.right
            top: parent.top
            bottom: parent.bottom

            rightMargin: 0
            leftMargin: spacing
            margins: margin
        }
    }

    MouseArea
    {
        enabled: tooltipText != ""
        anchors.fill: parent
        hoverEnabled: true

        onEntered: base.showTooltip(
            parent,
            Qt.point(-UM.Theme.getSize("thick_margin").width, 0),
            tooltipText
        )

        onExited: base.hideTooltip()
    }

}