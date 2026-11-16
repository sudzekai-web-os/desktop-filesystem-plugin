import QtQuick
import QtQuick.Controls.Basic
import linctrl

Menu {
    id: root

    required property var entry
    property bool administrator: false
    property bool busy: false
    readonly property bool canChange: administrator && entry !== null
    readonly property bool canEditText: canChange && !entry.directory

    signal openEntry()
    signal showProperties()
    signal changePath(string action, string title)
    signal editText()
    signal exportFile()

    width: 215
    padding: 4
    background: AppCard { radius: 8 }

    AppMenuItem {
        text: "Открыть"
        enabled: !root.busy && root.entry !== null
        onTriggered: root.openEntry()
    }
    AppMenuItem {
        text: "Свойства"
        enabled: !root.busy && root.entry !== null
        onTriggered: root.showProperties()
    }

    AppMenuItem {
        text: "Экспортировать файл…"
        visible: root.entry !== null && !root.entry.directory
        height: root.entry !== null && !root.entry.directory ? implicitHeight : 0
        enabled: !root.busy
        onTriggered: root.exportFile()
    }

    MenuSeparator { visible: root.administrator; height: root.administrator ? implicitHeight : 0 }

    AppMenuItem {
        text: "Копировать…"
        visible: root.administrator
        height: root.administrator ? implicitHeight : 0
        enabled: root.canChange && !root.busy
        onTriggered: root.changePath("copy", "Копирование")
    }
    AppMenuItem {
        text: "Переместить…"
        visible: root.administrator
        height: root.administrator ? implicitHeight : 0
        enabled: root.canChange && !root.busy
        onTriggered: root.changePath("move", "Перемещение")
    }
    AppMenuItem {
        text: "Удалить…"
        visible: root.administrator
        height: root.administrator ? implicitHeight : 0
        enabled: root.canChange && !root.busy
        onTriggered: root.changePath("delete", "Удаление")
    }
    AppMenuItem {
        text: "Изменить текст…"
        visible: root.administrator
        height: root.administrator ? implicitHeight : 0
        enabled: root.canEditText && !root.busy
        onTriggered: root.editText()
    }
}
