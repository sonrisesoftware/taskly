import QtQuick 2.2
import Ubuntu.Components 1.1
import Ubuntu.Components.Popups 1.0
import Ubuntu.Components.ListItems 1.0 as ListItem

import "../model"

Page {
    id: root

    property Task task

    title: task.title

    head.actions: [
        Action {
            iconName: "edit"
            text: "Edit task"

            onTriggered: {
                pageStack.push(Qt.resolvedUrl("EditTaskPage.qml"), {task: task})
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
        anchors.margins: units.gu(2)
        spacing: units.gu(1)

        Label {
            text: task.hasDueDate ? i18n.tr("Due on %1").arg(task.dueDate.toDateString()) : ""
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
