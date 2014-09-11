import QtQuick 2.0
import "../ubuntu-ui-extras"

AboutPage {
    linkColor: colors["blue"]

    appName: i18n.tr("Taskly")
    icon: Qt.resolvedUrl("../taskly.png")
    version: "@APP_VERSION@"

    website: "http://www.sonrisesoftware.com/apps/taskly"
    reportABug: "https://github.com/sonrisesoftware/taskly/issues"

    copyright: i18n.tr("Copyright (c) 2014 Michael Spencer")
    author: "Sonrise Software"
    contactEmail: "sonrisesoftware@gmail.com"
}
