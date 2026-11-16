import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import linctrl
import "../ExplorerPaths.js" as Paths

AppDialog {
    id: root
    preferredWidth: 430
    property string serverError: ""
    property string mode: ""
    property string source: ""
    property bool directory: false
    signal submitted(string mode, var body)

    function start(action, caption, current, isDirectory, destination) {
        mode = action
        title = caption
        source = current
        directory = isDirectory
        path.text = destination || Paths.root()
        path.cursorPosition = path.length
        recursive.checked = false
        open()
    }

    contentItem: ColumnLayout {
        spacing: 8
        AppText {
            Layout.fillWidth: true
            visible: root.source !== ""
            text: root.source
            wrapMode: Text.Wrap
        }
        AppField {
            id: path
            Layout.fillWidth: true
            visible: root.mode !== "delete"
            placeholderText: "Путь назначения в root:"
        }
        CheckBox { id: recursive; visible: root.mode === "delete" && root.directory; text: "Удалить с содержимым" }
        AppText { Layout.fillWidth: true; visible: text !== ""; text: root.mode !== "delete" && !Paths.normalize(path.text.trim()) ? "Укажите путь назначения в root:" : root.serverError; wrapMode: Text.Wrap }
        RowLayout {
            Layout.alignment: Qt.AlignRight
            DefaultButton { text: "Отмена"; enabled: !root.busy; onClicked: root.close() }
            DefaultButton {
                text: root.mode === "delete" ? "Удалить" : "Выполнить"
                primary: true
                enabled: !root.busy && (root.mode === "delete" || Paths.normalize(path.text.trim()) !== "")
                onClicked: {
                    let body
                    if (root.mode === "delete")
                        body = root.directory ? { path: root.source, recursive: recursive.checked } : { path: root.source }
                    else
                        body = { source: root.source, destination: Paths.normalize(path.text.trim()) }
                    root.submitted(root.mode, body)
                }
            }
        }
    }
}
