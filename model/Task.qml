import QtQuick 2.2

import "../udata"
import "../qml-extras/dateutils.js" as DateUtils

Document {
    id: task
    _type: "Task"

    _properties: ["title", "description", "completed", "dueDate"]

    property string title
    property string description
    property bool completed: false
    property date dueDate

    property bool hasDueDate: DateUtils.isValid(dueDate)

    property string section: {
        print("Updating sections")
        if (completed)
            return i18n.tr("Completed")
        else if (!hasDueDate)
            return i18n.tr("No Due Date")
        else if (DateUtils.dateIsBefore(dueDate, new Date()))
            return i18n.tr("Overdue")
        else if (DateUtils.isToday(dueDate))
            return i18n.tr("Today")
        else if (DateUtils.isThisWeek(dueDate))
            return i18n.tr("This Week")
        else
            return i18n.tr("Upcoming")
    }
}
