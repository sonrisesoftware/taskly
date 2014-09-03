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

import "../udata"
import "../ubuntu-ui-extras"
import "../components"

Page {
    id: page

    title: "Projects"

    head.actions: [
        Action {
            iconName: "add"
            text: "Add project"
            onTriggered: PopupUtils.open(addProjectDialog)
        }
    ]

    Component {
        id: addProjectDialog

        InputDialog {
            id: dialog

            title: "Add project"
            text: "Enter the name of the project:"
            placeholderText: "Project name"

            onAccepted: {
                database.create('Project', {'title': value})
                PopupUtils.close(dialog)
            }
        }
    }

    flickable: projects.count == 0 ? null : listView

    UbuntuListView {
        id: listView
        anchors.fill: parent

        StateSaver.properties: "contentY"

        model: projects
        delegate: SubtitledListItem {
            text: modelData.title
            subText: tasksCount.count == 1 ? "1 task" : "%1 tasks".arg(tasksCount.count)
            onClicked: pageStack.push(Qt.resolvedUrl("TasksPage.qml"), {
                                          project: modelData
                                      })

            QueryCount {
                id: tasksCount

                type: 'Task'
                _db: database
                predicate: "completed==0 AND projectId=='%1'".arg(modelData._id)

                enabled: page.active
            }
        }
    }

    Scrollbar {
        flickableItem: listView
    }

    Column {
        anchors.centerIn: parent
        visible: projects.count == 0
        spacing: units.gu(0.5)

        Icon {
            name: "browser-tabs"
            opacity: 0.5
            width: units.gu(10)
            height: width
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Item {
            width: parent.width
            height: units.gu(2)
        }

        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            text: i18n.tr("No projects")
            opacity: 0.5
            fontSize: "large"
            font.bold: true
        }

        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            text: i18n.tr("Tap the Add icon in the toolbar to add a project")
            width: page.width - units.gu(8)
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            horizontalAlignment: Text.AlignHCenter
            opacity: 0.5
            fontSize: "large"
        }
    }

    Query {
        id: projects
        type: "Project"
        sortBy: "title"
        _db: database
    }
}
