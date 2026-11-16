import QtQuick
import QtQuick.Layouts
import linctrl
import "../ExplorerPaths.js" as Paths

RowLayout {
    id: root
    property string path: Paths.root()
    property bool busy: false

    signal navigate(string path)
    signal goUp()
    signal refresh()

    function reset() {
        address.text = path
    }

    onPathChanged: reset()

    ExplorerIconButton {
        caption: "На уровень выше"
        glyph: "../icons/arrow-left.svg"
        enabled: !root.busy && root.path !== Paths.root()
        onClicked: root.goUp()
    }
    AppField {
        id: address
        Layout.fillWidth: true
        text: root.path
        placeholderText: "Адрес"
        onAccepted: if (!root.busy) root.navigate(text.trim())
    }
    ExplorerIconButton {
        caption: "Перейти по адресу"
        glyph: "../icons/search.svg"
        enabled: !root.busy && address.text.trim() !== ""
        onClicked: root.navigate(address.text.trim())
    }
    ExplorerIconButton {
        caption: "Обновить"
        glyph: "../icons/arrow-clockwise.svg"
        enabled: !root.busy
        onClicked: root.refresh()
    }
}
