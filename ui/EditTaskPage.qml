import QtQuick 2.2
import Ubuntu.Components 1.1

import "../model"

Page {
    id: page

    title: "Edit Task"

    property Task task

    head.backAction: Action {
        iconName: "close"
        onTriggered: pageStack.pop()
    }

    head.actions: [
        Action {
            iconName: "ok"
            text: "Save task"
            enabled: titleField.acceptableInput
            onTriggered: {
                task.title = titleField.text
                task.description = descriptionField.text
                task.dueDate = new Date(dateField.text)

                pageStack.pop()
            }
        }
    ]

    Column {
        anchors.fill: parent
        anchors.margins: units.gu(2)

        spacing: units.gu(1)

        TextField {
            id: titleField

            anchors {
                left: parent.left
                right: parent.right
            }

            validator: RegExpValidator {
                regExp: /.+/
            }

            placeholderText: "Title"
            text: task.title

            Keys.onTabPressed: descriptionField.forceActiveFocus()
        }

        TextArea {
            id: descriptionField

            anchors {
                left: parent.left
                right: parent.right
            }

            placeholderText: "Description"
            text: task.description
        }

        TextField {
            id: dateField

            anchors {
                left: parent.left
                right: parent.right
            }

            placeholderText: "Due date"
            text: Qt.formatDate(task.dueDate, 'M/d/yyyy')
        }
    }
}
