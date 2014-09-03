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
import "../upstream"
import "../model"

PageWithBottomEdge {
    id: page
    title: project ? project.title : "Tasks"

    property bool upcomingOnly
    property bool showCompletedTasks
    property bool showAllProjects

    property bool allowShowingCompletedTasks: true

    property Project project

    property string searchQuery: state == "default" ? "" : searchField.text

    onStateChanged: {
        if (state == "search") {
            searchField.text = ""
            searchField.forceActiveFocus()
        }
    }

    state: "default"
    states: [
        PageHeadState {
            name: "default"
            head: page.head
            actions: [
                Action {
                    iconName: "search"
                    onTriggered: page.state = "search"
                },

                // This will show as just a black square because of LP #1364572
                Action {
                    iconName: "select"
                    text: "Show completed"
                    visible: allowShowingCompletedTasks && !showCompletedTasks
                    onTriggered: {
                        pageStack.push(Qt.resolvedUrl("TasksPage.qml"), {
                                           upcomingOnly: upcomingOnly,
                                           showAllProjects: showAllProjects,
                                           project: project, showCompletedTasks: true
                                       })
                    }
                },

                Action {
                    iconName: "delete"
                    text: "Delete project"
                    visible: project != null && !showCompletedTasks

                    onTriggered: {
                        project.remove()
                        pageStack.pop()
                    }
                },

                Action {
                    iconName: "edit"
                    text: "Rename project"
                    visible: project != null && !showCompletedTasks
                    onTriggered: PopupUtils.open(renameProjectDialog)
                }
            ]
        },
        PageHeadState {
            id: headerState
            name: "search"
            head: page.head
            actions: Action {
                iconName: "search"
                onTriggered: {
                    searchField.focus = false
                    Qt.inputMethod.hide()
                }
            }
            backAction: Action {
                id: leaveSearchAction
                text: "back"
                iconName: "back"
                onTriggered: page.state = "default"
            }
            contents: TextField {
                id: searchField
                placeholderText: "Search..."
                width: parent ? parent.width/* - units.gu(2)*/ : undefined

                onTriggered: {
                    searchField.focus = false
                    Qt.inputMethod.hide()
                }
            }
        }
    ]

    bottomEdgeEnabled: !showCompletedTasks

    bottomEdgePageComponent: AddTaskPage {
        project: page.project
    }

    bottomEdgeTitle: i18n.tr("Add task")

    flickable: state == "collapsed" ? listView : null

    TasksListView {
        id: listView

        anchors.fill: parent
        model: tasks

        section.property: "section"
        section.delegate: ListItem.Header {
            text: section
        }

        delegate: TaskListItem {
            id: listItem

            checked: modelData.completed
            text: formatText(modelData.title)
            subText: modelData.dueDateString

            onCheckedChanged: {
                modelData.completed = checked
                if (modelData)
                    checked = Qt.binding(function() { return modelData.completed })
            }

            onClicked: {
                pageStack.push(Qt.resolvedUrl("TaskDetailsPage.qml"), {task: modelData})
            }
        }
    }

    Column {
        anchors.centerIn: parent
        visible: tasks.count == 0
        spacing: units.gu(0.5)

        Icon {
            name: page.searchQuery ? "search"
                                   : noTasksYet ? "add" : upcomingOnly ? "reminder" : "ok"
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
            fontSize: "large"
            anchors.horizontalCenter: parent.horizontalCenter
            opacity: 0.5

            text: page.searchQuery ? i18n.tr("No matching tasks")
                                   : noTasksYet ? i18n.tr("No tasks yet!")
                                                : upcomingOnly || !showCompletedTasks ? i18n.tr("Great job!")
                                                                                      : i18n.tr("Nothing completed")
            font.bold: true
        }

        Label {
            fontSize: "large"
            anchors.horizontalCenter: parent.horizontalCenter
            opacity: 0.5
            width: page.width - units.gu(6)
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            horizontalAlignment: Text.AlignHCenter

            text: page.searchQuery ? i18n.tr("No tasks match your search query")
                                   : noTasksYet ? i18n.tr("Swipe up from the bottom of the screen to add tasks")
                                                : upcomingOnly ? i18n.tr("No upcoming tasks")
                                                               : showCompletedTasks ? i18n.tr("You haven't finished any tasks yet")
                                                                                    : i18n.tr("Nothing to do")

        }
    }

    Scrollbar {
        flickableItem: listView
    }



    Component {
        id: renameProjectDialog

        InputDialog {
            id: dialog

            title: "Rename project"
            text: "Edit the name of the project:"
            placeholderText: "Project name"

            value: project.title

            onAccepted: {
                project.title = value
                PopupUtils.close(dialog)
            }
        }
    }

    property bool noTasksYet: allTasks.count == 0

    QueryCount {
        id: allTasks
        _db: database
        enabled: page.active
        type: 'Task'
        predicate: {
            var predicate = []

            if (!showAllProjects)
                predicate.push("projectId == '%1'".arg(project ? project._id : ''))

            print(predicate.join(" AND "))

            return predicate.join(" AND ")
        }
    }

    Query {
        id: tasks
        type: "Task"
        groupBy: "section"
        predicate: {
            var predicate = []

            if (upcomingOnly) {
                predicate.push("dueDate != 'null'")
            }

            if (!showAllProjects)
                predicate.push("projectId == '%1'".arg(project ? project._id : ''))

            if (page.searchQuery) {
                var query = page.searchQuery
                query = query.replace('_', '\\_').replace('%', '\\%')
                predicate.push("(UPPER(title) LIKE UPPER('%%1%') ESCAPE '\\')".arg(query))
            }

            predicate.push('(completed == %1)'.arg(showCompletedTasks ? '1' : '0'))

            print(predicate.join(" AND "))

            return predicate.join(" AND ")
        }
        sortBy: "completed,dueDate,title"
        _db: database
    }

    function formatText(text) {
        var regex = /(\d\d?:\d\d\s*(PM|AM|pm|am))/gi
        text = text.replace(regex, "<font color=\"#3ca83c\">$1</font>")
        return text
    }
}
