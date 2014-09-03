import QtQuick 2.2
import Ubuntu.Components 1.1
import "ui"

import "qml-extras"
import "udata"

import "model"
import "ubuntu-ui-extras"

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

    // The size of the Nexus 4
    width: units.gu(42)
    height: units.gu(67)

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

            Tab {
                title: page.title
                page: AboutPage {
                    linkColor: colors["blue"]

                    appName: i18n.tr("Taskly")
                    icon: Qt.resolvedUrl("taskly.png")
                    version: "@APP_VERSION@"

                    website: "http://www.sonrisesoftware.com/apps/taskly"
                    reportABug: "https://github.com/sonrisesoftware/taskly/issues"

                    copyright: i18n.tr("Copyright (c) 2014 Michael Spencer")
                    author: "Sonrise Software"
                    contactEmail: "sonrisesoftware@gmail.com"
                }
            }
        }
    }

    property var colors: {
        "green": "#5cb85c",
        "red": "#d9534f",
        "yellow": "#f0ad4e",
        "blue": "#428bca",
        "orange": UbuntuColors.orange,
        "default": Theme.palette.normal.baseText,
        "white": "#F5F5F5",
        "overlay": "#666"
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

