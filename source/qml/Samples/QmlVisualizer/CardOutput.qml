import QtQuick 2.15
import QtQuick.Window 2.15
import Qt.labs.qmlmodels 1.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.15

Rectangle{
    id: cardOutput
    width: 300
    height: 800
    color: 'lightblue'
    border.color: 'black'
    border.width: 2
    radius: 8

    Column{
        id: cardOutputLayout
        anchors.fill: parent
        padding: 5
        spacing: 10

        ScrollView{
            width: 290
            height: cardOutputLayout.height - cardOutputLayout.spacing
            ScrollBar.vertical.interactive:true;

            TextArea{
                id:multilineInputId;
                wrapMode:Text.Wrap;
                font.pixelSize:14;
                selectByMouse: true
                enabled: false
                background:Rectangle{
                    radius:8;
                    color:multilineInputId.hovered ? 'lightgray' : 'white';
                    border.color:multilineInputId.activeFocus? 'black' : 'grey';
                    border.width:1;
                    layer.enabled:multilineInputId.activeFocus ? true : false;

                }

                placeholderText:"Card output window!";
            }
        }
    }

}
