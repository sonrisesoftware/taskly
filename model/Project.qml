import QtQuick 2.2

import "../udata"

Document {
    id: project
    _type: "Project"

    _properties: ["title"]

    property string title

    onRemoved: {
        _db.removeWithPredicate('Task', "projectId=='%1'".arg(_id))
    }
}
