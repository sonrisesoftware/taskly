import QtQuick 2.2
import Ubuntu.Components 1.1
import Ubuntu.Components.ListItems 1.0 as ListItem

import "../udata"
import "../components"
import "../upstream"

PageWithBottomEdge {
    id: page
    title: "Tasks"

    property bool showCompletedTasks: false

    head.actions: [
        Action {
            iconSource: showCompletedTasks ? "image://theme/select" : Qt.resolvedUrl("../icons/unselect.svg")
            text: "Show completed"
            onTriggered: {
                showCompletedTasks = !showCompletedTasks
            }
        },

        Action {
            iconName: "settings"
            text: "Settings"
        }
    ]

    bottomEdgePageComponent: AddTaskPage {}

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
            text: modelData.title
            subText: modelData.dueDate.toDateString()

            onCheckedChanged: {
                modelData.completed = checked
                if (modelData)
                    checked = Qt.binding(function() { return modelData.completed })
            }
        }
    }

    Column {
        anchors.centerIn: parent
        visible: tasks.count == 0
        spacing: units.gu(0.5)

        Icon {
            name: !hasTasks ? "add" : "ok"
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

            text: !hasTasks ? i18n.tr("No tasks yet!") : i18n.tr("Great job!")
            font.bold: true
        }

        Label {
            fontSize: "large"
            anchors.horizontalCenter: parent.horizontalCenter
            opacity: 0.5
            width: page.width - units.gu(6)
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            horizontalAlignment: Text.AlignHCenter

            text: !hasTasks ? i18n.tr("Swipe up from the bottom of the screen to add tasks") : i18n.tr("Nothing to do")
        }
    }

    Scrollbar {
        flickableItem: listView
    }

    property bool hasTasks: allTasksCount > 0
    property int allTasksCount: database.query("Task").length

    Query {
        id: tasks
        type: "Task"
        groupBy: "section"
        predicate: showCompletedTasks ? "" : "completed==0"
        sortBy: "completed,dueDate,title"
        _db: database
    }
}
