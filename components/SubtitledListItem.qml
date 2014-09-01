import QtQuick 2.2
import Ubuntu.Components 1.1
import Ubuntu.Components.Popups 1.0
import Ubuntu.Components.ListItems 1.0 as ListItem

ListItem.SingleValue {
    id: listItem

    property alias text: titleLabel.text
    property alias subText: subLabel.text

    Column {
        id: labels

        spacing: units.gu(0.1)

        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
            leftMargin: 0
            rightMargin: units.gu(2)
            right: parent.right
        }

        Label {
            id: titleLabel

            width: parent.width
            elide: Text.ElideRight
            maximumLineCount: 1
            color: listItem.selected ? UbuntuColors.orange : UbuntuColors.midAubergine
        }

        Label {
            id: subLabel
            width: parent.width

            //color:  Theme.palette.normal.backgroundText
            maximumLineCount: 1
            font.weight: Font.Light
            fontSize: "small"
            visible: text !== ""
            elide: Text.ElideRight
            color: listItem.selected ? UbuntuColors.orange : Theme.palette.selected.backgroundText
        }
    }
}
