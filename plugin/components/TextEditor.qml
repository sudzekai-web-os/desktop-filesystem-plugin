import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import linctrl
import "../LineChanges.js" as LineChanges

AppDialog {
    id: root
    preferredWidth: 500
    title: "Изменение текста"

    property string serverError: ""
    property string original: ""
    property string filePath: ""
    signal submitted(string mode, var body)

    function start(name, value) {
        filePath = name
        original = value || ""
        content.text = LineChanges.normalize(original)
        open()
    }

    contentItem: ColumnLayout {
        spacing: 8
        AppText { Layout.fillWidth: true; text: root.filePath; wrapMode: Text.Wrap; textFormat: Text.PlainText }
        ScrollView {
            Layout.fillWidth: true
            Layout.preferredHeight: 210
            TextArea {
                id: content
                placeholderText: "Содержимое"
                wrapMode: TextEdit.Wrap
                color: Theme.palette.ink
                placeholderTextColor: Theme.palette.muted
                background: AppCard {}
            }
        }
        AppText {
            Layout.fillWidth: true
            visible: text !== ""
            text: root.serverError
            wrapMode: Text.Wrap
        }
        RowLayout {
            Layout.alignment: Qt.AlignRight
            DefaultButton { text: "Отмена"; enabled: !root.busy; onClicked: root.close() }
            DefaultButton {
                text: "Сохранить"
                primary: true
                enabled: !root.busy
                onClicked: {
                    const change = LineChanges.plan(root.original, content.text, root.filePath)
                    if (change)
                        root.submitted(change.mode, change.body)
                    else
                        root.close()
                }
            }
        }
    }
}
