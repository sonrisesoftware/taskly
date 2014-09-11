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
import Ubuntu.Components.Popups 1.0
import Ubuntu.Components.ListItems 1.0 as ListItem

import "../model"
import "../components"

Page {
    id: root

    property Task task
    property Project project

    title: task.title

    head.actions: [
        Action {
            iconName: "edit"
            text: "Edit task"

            onTriggered: {
                pageStack.push(Qt.resolvedUrl("AddTaskPage.qml"), {task: task, project: project})
            }
        },

        Action {
            iconName: "delete"
            text: "Delete task"
            onTriggered: {
                task.remove()
                pageStack.pop()
            }
        }
    ]

    Column {
        anchors.fill: parent
        anchors.topMargin: units.gu(2)

        Column {
            anchors {
                left: parent.left
                right: parent.right

                margins: units.gu(2)
            }
            spacing: units.gu(1)

            Label {
                text: task.hasDueDate ? i18n.tr("Due %1").arg(task.dueDateString) : ""
                color: UbuntuColors.midAubergine
            }

            Label {
                width: parent.width
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere

                text: task.description ? task.description : i18n.tr("No description")
                color: task.description ? Theme.palette.selected.backgroundText : Theme.palette.normal.backgroundText
            }
        }
    }
}
