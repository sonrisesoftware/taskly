import QtQuick 2.2

import "../udata"

Document {
    id: task
    _type: "Task"

    _properties: ["title", "description", "completed"]

    property string title
    property string description
    property bool completed: false
}
