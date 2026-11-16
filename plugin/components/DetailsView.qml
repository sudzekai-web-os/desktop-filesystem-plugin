import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import linctrl

AppCard {
    id: root
    property string value: ""
    property string heading: ""

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        AppText { visible: root.heading !== ""; text: root.heading; font.bold: true }
        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            contentWidth: availableWidth
            TextArea {
                readOnly: true
                textFormat: TextEdit.PlainText
                text: root.value
                wrapMode: TextEdit.Wrap
                color: Theme.palette.ink
                background: Item {}
            }
        }
    }
}
