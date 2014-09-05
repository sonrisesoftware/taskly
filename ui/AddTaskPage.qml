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
import QtQuick 2.0
import Ubuntu.Components 1.1
import Ubuntu.Components.Popups 1.0
import Ubuntu.Components.Pickers 1.0
import Ubuntu.Components.ListItems 1.0 as ListItem

import "../model"
import "../qml-extras/dateutils.js" as DateUtils
import "../ubuntu-ui-extras"

Page {
    id: page
    title: "Add Task"

    property Project project
    property date date
    property var checklist

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
                                    projectId: project ? project._id : "",
                                    checklist: checklist
                                }, tasks)
                pageStack.pop()
            }
        }
    ]

    Column {
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            bottom: footer.top
        }

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

            // Always showing at least 5 lines
            property int lines: Math.max(descriptionField.lineCount, 5)

            property int maxHeight: parent.height
                                    - titleField.height
                                    - parent.spacing * (parent.children.length - 1)

            height: Math.min(maxHeight, lines * (descriptionField.font.pixelSize + units.dp(2)) + 2 * descriptionField.__styleInstance.frameSpacing)
        }
    }

    Rectangle {
        anchors.fill: footer
        color: Qt.rgba(0,0,0,0.03)
    }

    Column {
        id: footer

        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }



        ListItem.ThinDivider {
            anchors {
                left: parent.left
                right: parent.right
                leftMargin: units.gu(0)
                rightMargin: units.gu(0)
            }
        }

        ListItem.SingleValue {
            text: checklist ? i18n.tr("Checklist") : i18n.tr("Add checklist")
            value: checklist ? checklist.join(", ") : ""
            progression: true
            showDivider: false

            ListItem.ThinDivider {
                anchors {
                    left: parent.left
                    right: parent.right
                    leftMargin: units.gu(-2)
                    rightMargin: units.gu(-6)
                    bottom: parent.bottom
                }
            }

            onClicked: checklist = [
                           {text: "A", completed: false},
                           {text: "B", completed: true}
                       ]

        }

        ListItem.SingleValue {
            text: DateUtils.isValid(date) ? "Change due date" : "Add due date"
            value: colorize(date.toDateString(), UbuntuColors.midAubergine)

            progression: true
            showDivider: false

            ListItem.ThinDivider {
                anchors {
                    left: parent.left
                    right: parent.right
                    leftMargin: units.gu(-2)
                    rightMargin: units.gu(-6)
                    bottom: parent.bottom
                }
            }

            onClicked: PopupUtils.open(dateDialog)
        }

        ListItem.SingleValue {
            text: i18n.tr("Project")
            value: colorize(projectName, UbuntuColors.midAubergine)
            progression: true

            property string projectName: page.project ? page.project.title: i18n.tr("Inbox")

            onClicked: pageStack.push(selectProjectPage, {selectedProjectId: project ? project._id : ""})

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

    Component {
        id: selectProjectPage

        SelectProjectPage {
            onAccepted: {
                page.project = database.loadById("Project", projectId, page)
            }
        }
    }
}
