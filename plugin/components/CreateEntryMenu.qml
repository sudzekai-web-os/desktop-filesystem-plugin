import QtQuick
import QtQuick.Controls.Basic
import linctrl

Menu {
    id: root

    signal createEntry(bool directory)
    signal importFile()

    width: 210
    padding: 4
    background: AppCard { radius: 8 }

    AppMenuItem { text: "Создать папку…"; onTriggered: root.createEntry(true) }
    AppMenuItem { text: "Создать файл…"; onTriggered: root.createEntry(false) }
    AppMenuItem { text: "Импортировать файл…"; onTriggered: root.importFile() }
}
