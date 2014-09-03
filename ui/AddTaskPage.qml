import QtQuick 2.0
import Ubuntu.Components 1.1
import Ubuntu.Components.Popups 1.0
import Ubuntu.Components.Pickers 1.0
import Ubuntu.Components.ListItems 1.0 as ListItem

import "../model"
import "../qml-extras/dateutils.js" as DateUtils
import "../ubuntu-ui-extras"

Page {
    title: "Add Task"

    property Project project
    property date date

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

            // Expand up to 15 lines, always showing at least 5 lines
            property int lines: Math.min(Math.max(descriptionField.lineCount, 5), 15)
            height: lines * (descriptionField.font.pixelSize + units.dp(2)) + 2 * descriptionField.__styleInstance.frameSpacing
        }
    }

    Column {
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        ListItem.ThinDivider {}

        ListItem.SingleValue {
            text: DateUtils.isValid(date) ? "Change due date" : "Add due date"
            value: "<font color=\"%1\">%2</font>".arg(UbuntuColors.midAubergine).arg(date.toDateString())

            progression: true

            onClicked: PopupUtils.open(dateDialog)

            showDivider: false
        }
    }

    Component {
        id: dateDialog

        Dialog {
            id: dialog
            title: DateUtils.isValid(date) ? "Change due date" : "Add due date"
            text: DateUtils.isValid(date) ? i18n.tr("Pick a new due date, or remove the existing one")
                                          : i18n.tr("Pick a date to set as the due date")

            DatePicker {
                id: datePicker
            }

            Button {
                width: parent.width
                text: "Remove due date"
                enabled: DateUtils.isValid(date)
                color: colors["red"]
                onTriggered: {
                    date = new Date("")
                    PopupUtils.close(dialog)
                }
            }

            DialogButtonRow {
                onAccepted: {
                    date = datePicker.date
                    PopupUtils.close(dialog)
                }

                onRejected: {
                    PopupUtils.close(dialog)
                }
            }
        }
    }
}
