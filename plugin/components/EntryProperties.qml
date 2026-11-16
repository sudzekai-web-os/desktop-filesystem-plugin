import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import linctrl

AppCard {
    id: root
    required property var entry
    required property var info
    property var security: null
    property bool busy: false
    property string securityError: ""

    function date(value) {
        return value ? String(value).slice(0, 19).replace("T", " ") + " UTC" : "—"
    }

    ScrollView {
        anchors.fill: parent
        anchors.margins: 12
        contentWidth: availableWidth
        clip: true

        ColumnLayout {
            width: parent.width
            spacing: 9

            AppText {
                Layout.fillWidth: true
                text: "Свойства"
                font.bold: true
            }
            PropertyRow { label: "Имя"; value: root.info?.name }
            PropertyRow { label: "Путь"; value: root.info?.fullName }
            PropertyRow {
                label: "Тип"
                value: root.entry?.directory ? "Папка" : root.info?.extension || "Файл"
            }
            PropertyRow { label: "Размер"; value: (root.info?.length ?? 0) + " Б" }
            PropertyRow { visible: !!root.entry?.directory; label: "Файлов"; value: root.info?.filesCount }
            PropertyRow { visible: !!root.entry?.directory; label: "Папок"; value: root.info?.directoriesCount }
            PropertyRow { label: "Атрибуты"; value: root.info?.attributes }
            PropertyRow { label: "Создан"; value: root.date(root.info?.creationTimeUtc) }
            PropertyRow { label: "Изменён"; value: root.date(root.info?.lastWriteTimeUtc) }
            PropertyRow { label: "Последний доступ"; value: root.date(root.info?.lastAccessTimeUtc) }

            Rectangle { Layout.fillWidth: true; implicitHeight: 1; color: Theme.palette.line }

            AccessProperties {
                Layout.fillWidth: true
                security: root.security
                busy: root.busy
                error: root.securityError
            }
        }
    }
}
