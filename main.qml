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

    anchorToKeyboard: height > units.gu(120)

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

                    title: i18n.tr("Upcoming")
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
                    title: i18n.tr("Inbox")

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
                page: AboutTasklyPage {}
            }
        }
    }

    property var colors: {
        "green": "#3fb24f",
        "red": "#fc4949",
        "yellow": "#f0ad4e",
        "blue": "#428bca",
        "orange": UbuntuColors.orange,
        "default": Theme.palette.normal.baseText,
        "white": "#F5F5F5",
        "overlay": "#666"
    }

    function colorize(text, color) {
        return "<font color=\"%1\">%2</font>".arg(color).arg(text)
    }

    Database {
        id: database

        version: 1
        name: i18n.tr("taskly")
        description: i18n.tr("Taskly for Ubuntu Touch")
        modelPath: Qt.resolvedUrl("model")
    }
}
