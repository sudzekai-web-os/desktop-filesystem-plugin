import QtQuick
import QtQuick.Layouts
import linctrl

ColumnLayout {
    id: root

    property var security: null
    property bool busy: false
    property string error: ""
    readonly property string platform: security ? String(security.platform).toLowerCase() : ""
    readonly property bool windows: platform === "windows"
    readonly property bool linux: platform === "linux"

    AppText { text: "Права доступа"; font.bold: true }
    AppText {
        Layout.fillWidth: true
        visible: !root.windows && !root.linux
        textFormat: Text.PlainText
        text: root.busy ? "Загрузка прав…" : root.error || "Сведения о правах недоступны."
    }

    PropertyRow { visible: root.windows; label: "Владелец (SID)"; value: root.security?.ownerSid }
    PropertyRow { visible: root.windows; label: "Группа (SID)"; value: root.security?.groupSid }
    PropertyRow {
        visible: root.windows
        label: "Наследование"
        value: root.security?.isInheritanceProtected ? "Отключено" : "Включено"
    }
    Repeater {
        model: root.windows ? Array.from(root.security.rules || []) : []
        delegate: ColumnLayout {
            required property var modelData

            Rectangle { Layout.fillWidth: true; implicitHeight: 1; color: Theme.palette.line }
            PropertyRow {
                label: modelData.accessType === "Allow" ? "Разрешение" : "Запрет"
                value: modelData.identitySid + (modelData.isInherited ? " (унаследовано)" : "")
            }
            PropertyRow { label: "Права"; value: modelData.rights }
            PropertyRow { label: "Флаги наследования"; value: modelData.inheritanceFlags }
            PropertyRow { label: "Флаги распространения"; value: modelData.propagationFlags }
        }
    }

    PropertyRow { visible: root.linux; label: "Владелец (UID)"; value: root.security?.userId }
    PropertyRow { visible: root.linux; label: "Группа (GID)"; value: root.security?.groupId }
    PropertyRow { visible: root.linux; label: "Режим доступа"; value: root.security?.mode }
    PropertyRow { visible: root.linux; label: "Права владельца"; value: root.security?.ownerPermissions }
    PropertyRow { visible: root.linux; label: "Права группы"; value: root.security?.groupPermissions }
    PropertyRow { visible: root.linux; label: "Права остальных"; value: root.security?.otherPermissions }
}
