import QtQuick

QtObject {
    id: root

    readonly property bool busy: directories.busy || files.busy
    readonly property string error: directories.error || files.error || _formatError
    signal loaded(string path, var entries)

    property string _path: ""
    property var _directories: null
    property var _files: null
    property string _formatError: ""

    property DirectoryClient directories: DirectoryClient {}
    property DirectoryClient files: DirectoryClient {}

    function load(path) {
        if (busy)
            return

        _path = path
        _directories = null
        _files = null
        _formatError = ""
        files.error = ""

        directories.list(path, data => receive(data, true))
        files.listFiles(path, data => receive(data, false))
    }

    function receive(data, directory) {
        if (!data || typeof data !== "object" || !Number.isInteger(data.length)) {
            _formatError = "Сервер вернул некорректный список."
            return
        }

        if (directory)
            _directories = data
        else
            _files = data

        if (_directories !== null && _files !== null)
            loaded(_path, rows(_directories, true).concat(rows(_files, false)))
    }

    function rows(entries, directory) {
        return Array.from(entries, entry => ({
            name: entry.name || entry.fullName,
            path: entry.fullName,
            modified: entry.lastWriteTimeUtc,
            size: entry.length,
            extension: entry.extension,
            directory: directory
        }))
    }
}
