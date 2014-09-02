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

    UbuntuListView {
        id: listView
        anchors.fill: parent

        model: projects
        delegate: SubtitledListItem {
            text: modelData.title
            subText: tasksCount.count == 1 ? "1 task" : "%1 tasks".arg(tasksCount.count)
            onClicked: pageStack.push(Qt.resolvedUrl("TasksPage.qml"), {project: modelData})

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

    Label {
        anchors.centerIn: parent
        text: i18n.tr("No projects")
        fontSize: "large"
        visible: projects.count == 0
    }

    Query {
        id: projects
        type: "Project"
        sortBy: "title"
        _db: database
    }
}
