import QtQuick 2.15
import QtQuick.Window 2.15
import Qt.labs.qmlmodels 1.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.15

Row{
    id: root
    padding: 10
    spacing: 5

    Loader{
        id: cardListViewLoader
        source: "SampleCardListView.qml"
    }

    Loader{
        id: cardEditorLoader
        source: "CardEditor.qml"
    }

    Rectangle{
        id: cardRoot
        height: 800
        width: 700

        ListModel{
            id: cardModel
            Component.onCompleted: {
                append({"CardString": _aQmlCard});
            }
        }

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
            model: cardModel
            clip: true
        }
    }

}
