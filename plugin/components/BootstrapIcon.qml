import QtQuick
import QtQuick.Controls.Basic

Button {
    id: root
    required property url source
    required property color color

    enabled: false
    focusPolicy: Qt.NoFocus
    display: AbstractButton.IconOnly
    background: null
    padding: 0
    implicitWidth: 16
    implicitHeight: 16

    icon.source: root.source
    icon.color: root.color
    icon.width: width
    icon.height: height
}
