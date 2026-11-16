import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import linctrl
import "../ExplorerPaths.js" as Paths

AppDialog {
    id: root
    title: directory ? "Создание папки" : "Создание файла"

    property string serverError: ""
    property string directoryPath: Paths.root()
    property bool directory: false
    readonly property string targetPath: Paths.child(directoryPath, nameField.text.trim())
    signal submitted(string path)

    function start(path, isDirectory) {
        directoryPath = path
        directory = isDirectory
        nameField.clear()
        open()
    }

    onOpened: nameField.forceActiveFocus()

    contentItem: ColumnLayout {
        spacing: 8
        AppText {
            Layout.fillWidth: true
            text: root.directoryPath
            color: Theme.palette.muted
            textFormat: Text.PlainText
            wrapMode: Text.Wrap
        }
        AppField {
            id: nameField
            Layout.fillWidth: true
            placeholderText: "Название"
            onAccepted: if (save.enabled) root.submitted(root.targetPath)
        }
        AppText {
            visible: text !== ""
            Layout.fillWidth: true
            textFormat: Text.PlainText
            text: nameField.text.trim() && !root.targetPath ? "Введите название без компонентов пути." : root.serverError
        }
        RowLayout {
            Layout.alignment: Qt.AlignRight
            DefaultButton { text: "Отмена"; enabled: !root.busy; onClicked: root.close() }
            DefaultButton {
                id: save
                text: "Создать"
                primary: true
                enabled: !root.busy && root.targetPath !== ""
                onClicked: root.submitted(root.targetPath)
            }
        }
    }
}
