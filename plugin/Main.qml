import QtQuick
import QtQuick.Layouts
import linctrl
import "pages"

ColumnLayout {
    anchors.fill: parent
    anchors.margins: 24
    spacing: 10

    SectionHeading {
        Layout.fillWidth: true
        title: "Файловая система"
    }

    AppText {
        visible: !AccountSession.authenticated
        text: "Войдите на сервер, чтобы открыть файловую систему."
    }

    Loader {
        active: AccountSession.authenticated
        Layout.fillWidth: true
        Layout.fillHeight: true
        sourceComponent: Explorer {}
    }
}
