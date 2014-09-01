import QtQuick 2.0
import Ubuntu.Components 1.1

import "../model"

Page {
    title: "Add Task"

    property Project project

    head.backAction: Action {
        iconName: "close"
        onTriggered: pageStack.pop()
    }

    head.actions: [
        Action {
            iconName: "ok"
            text: "Add task"
            enabled: titleField.acceptableInput
            onTriggered: {
                var date = new Date(dateField.text)
                print(dateField.text, date)

                database.create("Task", {
                                    title: titleField.text,
                                    description: descriptionField.text,
                                    dueDate: date,
                                    projectId: project ? project._id : ""
                                }, tasks)
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

            Keys.onTabPressed: descriptionField.forceActiveFocus()
        }

        TextArea {
            id: descriptionField

            anchors {
                left: parent.left
                right: parent.right
            }

            placeholderText: "Description"
        }

        TextField {
            id: dateField

            anchors {
                left: parent.left
                right: parent.right
            }

            placeholderText: "Due date"
        }
    }
}
