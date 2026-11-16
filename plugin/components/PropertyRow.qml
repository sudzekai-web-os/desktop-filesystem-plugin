import QtQuick
import QtQuick.Layouts
import linctrl

ColumnLayout {
    id: root
    property string label: ""
    property var value

    spacing: 2
    Layout.fillWidth: true

    AppText { text: root.label; color: Theme.palette.muted }
    AppText {
        Layout.fillWidth: true
        textFormat: Text.PlainText
        text: root.value ?? "—"
        wrapMode: Text.Wrap
    }
}
