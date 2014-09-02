import QtQuick 2.2
import Ubuntu.Components 1.1
import Ubuntu.Components.ListItems 1.0 as ListItem

UbuntuListView {
    id: listView
    clip: true

    StateSaver.properties: "contentY"

    header: ListItem.ThinDivider {
        visible: listView.contentY < units.dp(-5)
    }

    move: Transition {
        UbuntuNumberAnimation { properties: "x,y"; duration: UbuntuAnimation.SlowDuration }
    }

    moveDisplaced: Transition {
        UbuntuNumberAnimation { properties: "x,y"; duration: UbuntuAnimation.SlowDuration }
    }
}
