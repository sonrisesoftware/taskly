import QtQuick 2.2
import Ubuntu.Components 1.1
import Ubuntu.Components.Popups 1.0
import Ubuntu.Components.Pickers 1.0
import Ubuntu.Components.ListItems 1.0 as ListItem

import "../model"
import "../ubuntu-ui-extras"
import "../qml-extras/dateutils.js" as DateUtils

Page {
    id: page

    title: "Edit Task"

    property Task task

    property date date

    head.backAction: Action {
        iconName: "close"
        onTriggered: pageStack.pop()
    }

    Component.onCompleted: date = task.dueDate

    head.actions: [
        Action {
            iconName: "ok"
            text: "Save task"
            enabled: titleField.acceptableInput
            onTriggered: {
                task.title = titleField.text
                task.description = descriptionField.text
                task.dueDate = date

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

            Component.onCompleted: {
                if (DateUtils.isValid(page.date))
                    datePicker.date = page.date
            }

            Button {
                width: parent.width
                text: "Remove due date"
                enabled: DateUtils.isValid(date)
                color: "#d9534f"
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
