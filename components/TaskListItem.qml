/*
 * Taskly - A simple tasks app for Ubuntu Touch
 *
 * Copyright (C) 2014 Michael Spencer
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */
import QtQuick 2.2
import Ubuntu.Components 1.1
import Ubuntu.Components.ListItems 1.0 as ListItem
import Ubuntu.Components.Themes.Ambiance 1.0
import "../ui"

ListItem.Empty {
    id: listItem

    property alias checked: doneCheckBox.checked
    property alias text: titleLabel.text
    property alias subText: subLabel.text

    clip: true
    opacity: 0

    CheckBox {
        id: doneCheckBox

        height: listItem.height > units.gu(5) ? implicitHeight : listItem.height - units.gu(1)
        width: height

        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
            leftMargin: units.gu(2)
        }
    }

    Column {
        id: labels

        spacing: units.gu(0.1)

        anchors {
            verticalCenter: parent.verticalCenter
            verticalCenterOffset: subText ? -units.dp(2) : 0
            left: doneCheckBox.visible ? doneCheckBox.right : parent.left
            leftMargin: doneCheckBox.visible ? units.gu(1) : units.gu(2)
            rightMargin: units.gu(2)
            right: parent.right
        }

        Label {
            id: titleLabel

            width: parent.width
            elide: Text.ElideRight

            fontSize: "medium"
            color: UbuntuColors.midAubergine
        }

        Label {
            id: subLabel

            width: parent.width
            //height: visible ? implicitHeight : 0
            fontSize: "small"

            visible: text !== ""
            elide: Text.ElideRight
        }
    }

    ListView.onAdd: SequentialAnimation {
        // TODO: Is there any case where this is needed (where a task gets shown before another existing task)?
        //UbuntuNumberAnimation { target: listItem; property: "height"; from: 0; to: listItem.implicitHeight; duration: 200 }
        UbuntuNumberAnimation { target: listItem; property: "opacity"; from: 0; to: 1; duration: 400 }
    }

    ListView.onRemove: SequentialAnimation {
        PropertyAction { target: listItem; property: "ListView.delayRemove"; value: true }
        UbuntuNumberAnimation { target: listItem; property: "opacity"; to: 0; duration: 400 }
        UbuntuNumberAnimation { target: listItem; property: "height"; to: 0; duration: 200 }
        PropertyAction { target: listItem; property: "ListView.delayRemove"; value: false }
    }
}
