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
    property bool showCompletedTasks: head.sections.selectedIndex == 1
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

    head.sections {
        model: allowShowingCompletedTasks && !searchQuery ? [i18n.tr("Upcoming"), i18n.tr("Completed")] : undefined
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

                Action {
                    iconName: "delete"
                    text: "Delete project"
                    visible: project != null

                    onTriggered: {
                        project.remove()
                        pageStack.pop()
                    }
                },

                Action {
                    iconName: "edit"
                    text: "Rename project"
                    visible: project != null
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

    TabView {
        id: tabView

        model: tabs
        currentIndex: showCompletedTasks ? 1 : 0

        anchors.fill: parent
    }

    VisualItemModel {
        id: tabs

        TasksView {
            upcomingOnly: page.upcomingOnly
            showCompletedTasks: false
            showAllProjects: page.showAllProjects
            project: page.project
            searchQuery: page.searchQuery

            width: tabView.width
            height: tabView.height
        }

        TasksView {
            upcomingOnly: page.upcomingOnly
            showCompletedTasks: true
            showAllProjects: page.showAllProjects
            project: page.project
            searchQuery: page.searchQuery

            width: tabView.width
            height: tabView.height
        }
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
}
