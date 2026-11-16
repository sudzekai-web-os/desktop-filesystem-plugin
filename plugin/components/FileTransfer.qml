import QtQuick
import QtQuick.Dialogs
import linctrl
import "../ExplorerPaths.js" as Paths

Item {
    id: root

    property string error: ""
    readonly property bool busy: request.busy
    signal imported()

    function importInto(directory) {
        error = ""
        openFile.directory = directory
        openFile.open()
    }

    function exportFile(path, name) {
        error = ""
        saveFile.path = path
        saveFile.title = "Экспорт «" + name + "»"
        saveFile.open()
    }

    PluginRequest { id: request }

    FileDialog {
        id: openFile
        property string directory: ""
        title: "Импорт файла"
        fileMode: FileDialog.OpenFile

        onAccepted: {
            const file = DesktopFiles.read(selectedFile)
            if (file.error) {
                root.error = file.error
                return
            }

            const path = Paths.child(directory, file.name)
            if (!path) {
                root.error = "Имя файла невозможно использовать на сервере."
                return
            }

            request.send("POST", "/filesystem/files/import", { path, content: file.content }, () => root.imported())
        }
    }

    FileDialog {
        id: saveFile
        property string path: ""
        fileMode: FileDialog.SaveFile

        onAccepted: {
            const destination = selectedFile
            request.send("GET", "/filesystem/files/export?path=" + encodeURIComponent(path), {},
                content => root.error = DesktopFiles.save(destination, content))
        }
    }

    Connections {
        target: request
        function onErrorChanged() { root.error = request.error }
    }
}
