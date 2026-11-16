import QtQuick
import QtQuick.Controls.Basic
import linctrl

DefaultButton {
    id: root
    required property url glyph
    required property string caption

    implicitWidth: 36
    horizontalPadding: 8
    opacity: enabled ? 1 : 0.48
    Accessible.name: caption
    ToolTip.text: caption
    ToolTip.visible: hovered

    contentItem: Item {
        implicitWidth: 16
        implicitHeight: 16

        BootstrapIcon {
            anchors.centerIn: parent
            width: 16
            height: 16
            source: root.glyph
            color: root.enabled ? Theme.palette.ink : Theme.palette.muted
        }
    }
}
