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

    property bool showCompletedTasks: false

    property string predicate: project ? "projectId == '%1'".arg(project._id) : ""

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
                    iconSource: showCompletedTasks ? "image://theme/select" : Qt.resolvedUrl("../icons/unselect.svg")
                    text: "Show completed"
                    visible: allowShowingCompletedTasks
                    onTriggered: {
                        showCompletedTasks = !showCompletedTasks
                    }
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
            name: page.searchQuery ? "search" : noTasksYet ? "add" : "ok"
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

            text: page.searchQuery ? i18n.tr("No matching tasks!") : noTasksYet ? i18n.tr("No tasks yet!") : i18n.tr("Great job!")
            font.bold: true
        }

        Label {
            fontSize: "large"
            anchors.horizontalCenter: parent.horizontalCenter
            opacity: 0.5
            width: page.width - units.gu(6)
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            horizontalAlignment: Text.AlignHCenter

            text: page.searchQuery ? i18n.tr("No tasks match your search query") : noTasksYet ? i18n.tr("Swipe up from the bottom of the screen to add tasks") : i18n.tr("Nothing to do")

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

    property bool noTasksYet: showCompletedTasks && tasks.count == 0

    Query {
        id: tasks
        type: "Task"
        groupBy: "section"
        predicate: {
            var predicate = []

            if (page.predicate)
                predicate.push('(' + page.predicate + ')')

            if (page.searchQuery) {
                var query = page.searchQuery
                query = query.replace('_', '\\_').replace('%', '\\%')
                predicate.push("(UPPER(title) LIKE UPPER('%%1%') ESCAPE '\\')".arg(query))
            }

            if (!showCompletedTasks)
                predicate.push('(completed == 0)')

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
