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

Item {
    property bool upcomingOnly
    property bool showCompletedTasks
    property bool showAllProjects

    property Project project

    property string searchQuery


    TasksListView {
        id: listView

        anchors.fill: parent
        model: tasks
    }

    Column {
        anchors.centerIn: parent
        visible: tasks.count == 0
        spacing: units.gu(0.5)

        Icon {
            name: page.searchQuery ? "search"
                                   : showCompletedTasks ? "ok"
                                                        : noTasksYet ? "add"
                                                                     : upcomingOnly ? "reminder" : "ok"
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
                                   : showCompletedTasks ? i18n.tr("Nothing completed")
                                                        : noTasksYet ? i18n.tr("No tasks yet!")
                                                                     : i18n.tr("Great job!")
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
                                   : showCompletedTasks ? i18n.tr("You haven't finished any tasks yet")
                                                        : noTasksYet ? i18n.tr("Swipe up from the bottom of the screen to add tasks")
                                                                     : i18n.tr("No upcoming tasks")

        }
    }

    Scrollbar {
        flickableItem: listView
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
                predicate.push("dueDate != ''")
            }

            if (!showAllProjects)
                predicate.push("projectId == '%1'".arg(project ? project._id : ''))

            if (page.searchQuery) {
                var query = page.searchQuery
                query = query.replace('_', '\\_').replace('%', '\\%')
                predicate.push("(UPPER(title) LIKE UPPER('%%1%') ESCAPE '\\')".arg(query))
            } else {
                predicate.push('(completed == %1)'.arg(showCompletedTasks ? '1' : '0'))
            }

            print(predicate.join(" AND "))

            return predicate.join(" AND ")
        }
        sortBy: "completed,dueDate,priority,title"
        _db: database
    }

    function formatText(text) {
        var regex = /(\d\d?:\d\d\s*(PM|AM|pm|am))/gi
        text = text.replace(regex, "<font color=\"#3ca83c\">$1</font>")
        if (text.indexOf("!") !== -1)
            text = colorize(/*"<b>%1</b>".arg(*/text/*)*/, "#dd0000")

        return text
    }
}
