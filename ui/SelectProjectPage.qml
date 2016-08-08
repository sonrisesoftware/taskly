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
import "../udata"

Page {
    id: page

    title: i18n.tr("Select Project")

    head.backAction: Action {
        iconName: "close"
        text: i18n.tr("Cancel")
        onTriggered: {
            pageStack.pop()
            rejected()
        }
    }

    head.actions: [
        Action {
            iconName: "ok"
            text: i18n.tr("Select project")
            onTriggered: {
                pageStack.pop()
                accepted(selectedProjectId)
            }
        }
    ]

    signal accepted(var projectId)
    signal rejected()

    property string selectedProjectId

    UbuntuListView {
        id: listView
        anchors.fill: parent

        model: projects

        header: Column {
            width: parent.width

            ListItem.Standard {
                id: inboxItem
                text: i18n.tr("Inbox")
                onClicked: selectedProjectId = ""
                selected: selectedProjectId == ""

                Icon {
                    name: "tick"
                    width: units.gu(2.5)
                    height: width
                    visible: inboxItem.selected
                    anchors {
                        rightMargin: units.gu(2)
                        right: parent.right
                        verticalCenter: parent.verticalCenter
                    }
                }
            }

            ListItem.Header {
                text: i18n.tr("Projects")
            }
        }

        delegate: ListItem.Standard {
            id: listItem
            text: modelData.title
            onClicked: selectedProjectId = modelData._id
            selected: selectedProjectId == modelData._id

            Icon {
                name: "tick"
                width: units.gu(2.5)
                height: width
                visible: listItem.selected
                anchors {
                    rightMargin: units.gu(2)
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                }
            }
        }
    }

    Scrollbar {
        flickableItem: listView
    }

    Query {
        id: projects
        type: "Project"
        sortBy: "title"
        _db: database
    }
}
