import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import linctrl
import "../api"
import "../components"
import "../ExplorerPaths.js" as Paths

ColumnLayout {
    id: root

    property string directory: Paths.root()
    property string addressError: ""
    property var entries: []
    property var selected: null
    property var preview: null
    property string previewTitle: ""
    property var entryInfo: null
    property var securityInfo: null
    readonly property bool busy: listing.busy || directories.busy || files.busy || transfer.busy

    DirectoryListing {
        id: listing
        onLoaded: (path, result) => {
            root.directory = path
            root.entries = result
            root.selectEntry(null)
            addressBar.reset()
        }
    }
    DirectoryClient { id: directories }
    FileClient { id: files }
    FileTransfer { id: transfer; onImported: root.navigate(root.directory) }

    function navigate(path) {
        if (busy)
            return

        const target = Paths.normalize(path)
        addressError = target ? "" : "Укажите адрес, начинающийся с root:\\."
        if (!target)
            return

        directories.error = ""
        files.error = ""
        listing.load(target)
    }

    function selectEntry(entry) {
        if (selected === entry)
            return
        selected = entry
        preview = null
        previewTitle = ""
        entryInfo = null
        securityInfo = null
    }

    function openEntry(entry) {
        selectEntry(entry)
        if (entry.directory)
            navigate(entry.path)
        else
            readText()
    }

    function readText() {
        if (!selected || selected.directory || busy)
            return

        const entry = selected
        entryInfo = null
        files.error = ""
        files.inspect("content", entry.path, data => {
            root.preview = data
            root.previewTitle = entry.name
        })
    }

    function showProperties() {
        if (!selected || busy)
            return

        const entry = selected
        const client = entry.directory ? directories : files
        preview = null
        entryInfo = null
        securityInfo = null
        directories.error = ""
        files.error = ""
        client.inspect("info", entry.path, info => {
            root.entryInfo = info
            client.inspect("security", entry.path, security => root.securityInfo = security)
        })
    }

    function changePath(action, title) {
        if (!selected || busy)
            return

        const entry = selected
        const client = entry.directory ? directories : files
        client.error = ""
        pathDialog.start(action, title, entry.path, entry.directory, directory === Paths.root() ? directory : directory + "\\")
    }

    function editText() {
        if (!selected || selected.directory || busy)
            return

        const path = selected.path
        files.error = ""
        files.inspect("content", path, data => textEditor.start(path, data))
    }

    Component.onCompleted: navigate(directory)

    ExplorerAddressBar {
        id: addressBar
        Layout.fillWidth: true
        path: root.directory
        busy: root.busy
        onNavigate: path => root.navigate(path)
        onGoUp: root.navigate(Paths.parent(root.directory))
        onRefresh: root.navigate(root.directory)
    }

    AppText {
        Layout.fillWidth: true
        visible: text !== ""
        text: root.addressError || transfer.error || directories.error || files.error || listing.error
        color: Theme.palette.accent
        wrapMode: Text.Wrap
    }

    ResizableSplit {
        id: split
        Layout.fillWidth: true
        Layout.fillHeight: true

        EntryList {
            id: entryList
            SplitView.fillWidth: true
            entries: root.entries
            busy: root.busy
            selected: root.selected ? root.selected.path : ""
            emptyText: "В каталоге нет файлов и папок"
            onChosen: entry => root.selectEntry(entry)
            onOpened: entry => root.openEntry(entry)
            onBackgroundContextRequested: (x, y) => {
                if (!AccountSession.administrator)
                    return
                root.selectEntry(null)
                createMenu.directoryPath = root.directory
                createMenu.popup(entryList, x, y)
            }
            onContextRequested: (entry, x, y) => {
                root.selectEntry(entry)
                entryMenu.popup(entryList, x, y)
            }
        }

        Item {
            visible: root.preview !== null || root.entryInfo !== null
            SplitView.minimumWidth: split.minimumPanelWidth
            SplitView.maximumWidth: split.maximumPanelWidth
            SplitView.preferredWidth: Math.min(300, split.maximumPanelWidth)

            DetailsView {
                anchors.fill: parent
                visible: root.preview !== null
                value: root.preview ?? ""
                heading: root.previewTitle
            }

            EntryProperties {
                anchors.fill: parent
                visible: root.entryInfo !== null
                entry: root.selected
                info: root.entryInfo
                security: root.securityInfo
                busy: root.busy
                securityError: root.selected?.directory ? directories.error : files.error
            }
        }
    }

    CreateEntryMenu {
        id: createMenu
        property string directoryPath: Paths.root()

        onImportFile: transfer.importInto(directoryPath)
        onCreateEntry: isDirectory => {
            directories.error = ""
            files.error = ""
            createDialog.start(directoryPath, isDirectory)
        }
    }

    CreateEntryDialog {
        id: createDialog
        busy: root.busy
        serverError: directory ? directories.error : files.error
        onSubmitted: path => {
            const completed = () => {
                createDialog.close()
                root.navigate(root.directory)
            }
            if (createDialog.directory)
                directories.change("create", { path }, completed)
            else
                files.saveText("create", { path }, completed)
        }
    }

    EntryContextMenu {
        id: entryMenu
        entry: root.selected
        busy: root.busy
        administrator: AccountSession.administrator
        onOpenEntry: root.openEntry(root.selected)
        onShowProperties: root.showProperties()
        onChangePath: (action, title) => root.changePath(action, title)
        onEditText: root.editText()
        onExportFile: transfer.exportFile(root.selected.path, root.selected.name)
    }

    PathActionDialog {
        id: pathDialog
        busy: root.busy
        serverError: directory ? directories.error : files.error
        onSubmitted: (mode, body) => {
            const completed = () => {
                pathDialog.close()
                root.navigate(root.directory)
            }
            if (directory)
                directories.change(mode, body, completed)
            else
                files.changePath(mode, body, completed)
        }
    }

    TextEditor {
        id: textEditor
        busy: root.busy
        serverError: files.error
        onSubmitted: (mode, body) => files.saveText(mode, body, () => {
            textEditor.close()
            root.readText()
        })
    }
}
