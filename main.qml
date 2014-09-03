import QtQuick 2.2
import Ubuntu.Components 1.1
import "ui"

import "qml-extras"
import "udata"

import "model"

MainView {
    id: app

    // objectName for functional testing purposes (autopilot-qt5)
    objectName: "mainView"

    // Note! applicationName needs to match the "name" field of the click manifest
    applicationName: "com.ubuntu.developer.mdspencer.taskly"

    /*
     This property enables the application to change orientation
     when the device is rotated. The default is false.
    */
    automaticOrientation: true

    width: units.gu(45)
    height: units.gu(75)

    useDeprecatedToolbar: false

    PageStack {
        id: pageStack

        Component.onCompleted: pageStack.push(tabs)

        Tabs {
            id: tabs

            StateSaver.properties: "selectedTabIndex"

            Tab {
                id: upcomingTab

                objectName: "upcomingTab"
                title: page.title
                page: TasksPage {
                    id: upcomingPage

                    title: "Upcoming"
                    upcomingOnly: true
                    showAllProjects: true
                    allowShowingCompletedTasks: false
                }
            }

            Tab {
                id: inboxTab

                objectName: "inboxTab"
                title: page.title
                page: TasksPage {
                    id: inboxPage
                    title: "Inbox"

                    // The Inbox page only shows tasks not associated with any project
                    showAllProjects: false
                }
            }

            Tab {
                id: projectsTab

                objectName: "projectsPage"
                title: page.title
                page: ProjectsPage {
                    id: projectsPage
                }
            }
        }
    }

    Database {
        id: database

        version: 2
        name: "taskly"
        description: "Taskly for Ubuntu Touch"
        modelPath: Qt.resolvedUrl("model")

        onUpgrade: {
            if (version < 2) {
                tx.executeSql("ALTER TABLE Task ADD projectId TEXT");
            }
        }
    }
}

