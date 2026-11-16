import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import linctrl

AppCard {
    id: root
    property var entries: []
    property bool busy: false
    property string selected: ""
    property string emptyText: "В каталоге нет файлов и папок"
    readonly property bool showSize: width >= 310
    readonly property bool showModified: width >= 470
    signal chosen(var entry)
    signal opened(var entry)
    signal contextRequested(var entry, real x, real y)
    signal backgroundContextRequested(real x, real y)

    function typeText(entry) {
        return entry.directory ? "Папка" : (entry.extension || "Файл")
    }

    function sizeText(entry) {
        if (entry.directory || typeof entry.size !== "number")
            return ""
        if (entry.size < 1024)
            return entry.size + " Б"
        if (entry.size < 1024 * 1024)
            return (entry.size / 1024).toFixed(1) + " КБ"
        return (entry.size / (1024 * 1024)).toFixed(1) + " МБ"
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 8
        spacing: 3

        RowLayout {
            Layout.fillWidth: true
            Layout.leftMargin: 12
            Layout.rightMargin: 12
            AppText { Layout.fillWidth: true; text: "Имя"; font.bold: true }
            AppText { Layout.preferredWidth: 80; text: "Тип"; font.bold: true }
            AppText { visible: root.showSize; Layout.preferredWidth: 80; text: "Размер"; font.bold: true }
            AppText { visible: root.showModified; Layout.preferredWidth: 154; text: "Изменён (UTC)"; font.bold: true }
        }

        Rectangle { Layout.fillWidth: true; implicitHeight: 1; color: Theme.palette.line }

        ListView {
            id: list
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            model: root.entries
            spacing: 2
            keyNavigationEnabled: true

            Keys.onReturnPressed: if (!root.busy && currentIndex >= 0) root.opened(root.entries[currentIndex])

            delegate: DefaultButton {
                id: row
                required property int index
                required property var modelData
                width: list.width
                text: modelData.name
                selected: modelData.path === root.selected || ListView.isCurrentItem && list.activeFocus
                enabled: !root.busy

                contentItem: RowLayout {
                    BootstrapIcon {
                        Layout.preferredWidth: 16
                        Layout.preferredHeight: 16
                        source: row.modelData.directory ? "../icons/folder-fill.svg" : "../icons/file-earmark.svg"
                        color: row.modelData.directory ? Theme.palette.accent : Theme.palette.muted
                    }
                    AppText { Layout.fillWidth: true; text: row.text; elide: Text.ElideRight }
                    AppText { Layout.preferredWidth: 80; text: root.typeText(row.modelData); elide: Text.ElideRight }
                    AppText { visible: root.showSize; Layout.preferredWidth: 80; text: root.sizeText(row.modelData) }
                    AppText {
                        visible: root.showModified
                        Layout.preferredWidth: 154
                        text: String(row.modelData.modified || "").slice(0, 19).replace("T", " ")
                    }
                }

                onClicked: {
                    list.currentIndex = index
                    root.chosen(modelData)
                }
                onDoubleClicked: root.opened(modelData)

                TapHandler {
                    acceptedButtons: Qt.RightButton
                    onTapped: eventPoint => {
                        list.currentIndex = row.index
                        const position = row.mapToItem(root, eventPoint.position.x, eventPoint.position.y)
                        root.contextRequested(row.modelData, position.x, position.y)
                    }
                }
            }

            TapHandler {
                enabled: !root.busy
                acceptedButtons: Qt.RightButton
                onTapped: eventPoint => {
                    const hit = list.contentItem.mapFromItem(list, eventPoint.position.x, eventPoint.position.y)
                    if (list.indexAt(hit.x, hit.y) >= 0)
                        return
                    const position = list.mapToItem(root, eventPoint.position.x, eventPoint.position.y)
                    root.backgroundContextRequested(position.x, position.y)
                }
            }

            ScrollBar.vertical: ScrollBar {}
        }
    }

    AppText {
        anchors.centerIn: parent
        visible: root.entries.length === 0
        text: root.busy ? "Загрузка…" : root.emptyText
    }
}
