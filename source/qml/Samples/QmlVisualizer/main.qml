import QtQuick 2.15
import QtQuick.Window 2.15
import Qt.labs.qmlmodels 1.0

import Card 1.0

Rectangle{
    id: root
    height: 800
    width: 800

    Component{
        id: delegate
        Loader{
            id: loader
            source: "AdaptiveCardItemDelegate.qml"
        }
    }

    ListView{
        id: cardsList
        anchors.fill: parent
        cacheBuffer: 10000
        delegate: delegate
        model: AdaptiveCardsModel {}
        clip: true
    }
}
