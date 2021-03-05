import QtQuick 2.15
import QtQuick.Window 2.15
import Qt.labs.qmlmodels 1.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.15
import SampleCard 1.0


Frame{
    width: 250
    height: 800
    padding: 5
    background: Rectangle{
        color: 'lightblue'
        border.color: 'black'
        border.width: 2
        radius: 8
    }
    
    property string defaultCard: ""
    
    signal listItemClicked(var index, var cardJson);
    signal reloadCard(var card);
    Column {
        width: parent.width
        spacing: 15
        Row{
            spacing: 10
            Rectangle {
                color: "#8fbc8f"
                anchors.verticalCenter: parent.verticalCenter
                Text {
                    font.weight: Font.DemiBold
                    text: "Select theme:"
                    font.pointSize:  8
                }
                width: childrenRect.width
                height: childrenRect.height
            }
            ComboBox {
                id : comboId
                model: ListModel {
                    id: cbItems
                    ListElement { text: "Light Theme"}
                    ListElement { text: "Dark Theme"}
                }
                onActivated: {
                    _aModel.setTheme(cbItems.get(currentIndex).text)
                    
                }
            }
        }
        ListView{
            id: cardListView
            width: parent.width
            height: parent.parent.height - comboId.height - parent.spacing
            clip: true
            model: _aModel
            
            delegate: cardDelegate
        }
    }
    
    Component{
        id: cardDelegate
        Rectangle{
            color: cardListView.currentIndex === index ? 'yellow' : 'white'
            width: cardListView.width
            implicitHeight: txt.implicitHeight
            radius: 5
            border.width: 1
            border.color: 'black'
            
            Text {
                id: txt
                width: parent.width
                padding: 5
                text: model.CardName
                font.pixelSize: 15
                
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        cardListView.currentIndex = index;
                        listItemClicked(index, model.CardJson);
                        reloadCard(_aModel.generateQml(model.CardJson))
                    }
                }
            }
            Component.onCompleted: {
                if(index === 0)
                    defaultCard = model.CardJson
                listItemClicked(index, defaultCard)
            }
        }
    }
}
