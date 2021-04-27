import QtQuick 2.15
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
Rectangle{
id:adaptiveCard
readonly property int margins:12
implicitHeight:adaptiveCardLayout.implicitHeight
Layout.fillWidth:true
readonly property string bgColor:'#FFFFFF'
color:bgColor
signal buttonClicked(var title, var type, var data)
function generateStretchHeight(childrens,minHeight){
var n = childrens.length
var implicitHt = 0;
var stretchCount = 0;
var stretchMinHeight = 0;
for(var i=0;i<childrens.length;i++)
{
if(typeof childrens[i].seperator !== 'undefined')
{
implicitHt += childrens[i].height;
stretchMinHeight += childrens[i].height;
}
else
{
implicitHt += childrens[i].implicitHeight;
if(typeof childrens[i].stretch !== 'undefined')
{
stretchCount++;
}
else
{
stretchMinHeight += childrens[i].implicitHeight;
}
}
}
stretchMinHeight = (minHeight - stretchMinHeight)/stretchCount
for(i=0;(i<childrens.length);i++)
{
if(typeof childrens[i].seperator === 'undefined')
{
if(typeof childrens[i].stretch !== 'undefined' && typeof childrens[i].minHeight !== 'undefined')
{
childrens[i].minHeight = Math.max(childrens[i].minHeight,stretchMinHeight)
}
}
}
if(stretchCount > 0 && implicitHt < minHeight)
{
var stretctHeight = (minHeight - implicitHt)/stretchCount
for(i=0;i<childrens.length;i++)
{
if(typeof childrens[i].seperator === 'undefined')
{
if(typeof childrens[i].stretch !== 'undefined')
{
childrens[i].height = childrens[i].implicitHeight + stretctHeight
}
}
}
}
else
{
for(i=0;i<childrens.length;i++)
{
if(typeof childrens[i].seperator === 'undefined')
{
if(typeof childrens[i].stretch !== 'undefined')
{
childrens[i].height = childrens[i].implicitHeight
}
}
}
}
}
function generateStretchWidth(childrens,width){
var implicitWid = 0
var autoWid = 0
var autoCount = 0
var weightSum = 0
var stretchCount = 0
var weightPresent = 0
for(var i=0;i<childrens.length;i++)
{
if(typeof childrens[i].seperator !== 'undefined')
{
implicitWid += childrens[i].width
}
else
{
if(childrens[i].widthProperty.endsWith("px"))
{
childrens[i].width = parseInt(childrens[i].widthProperty.slice(0,-2))
implicitWid += childrens[i].width
}
else
{
if(childrens[i].widthProperty === "auto")
{
autoCount++
}
else if(childrens[i].widthProperty === "stretch")
{
stretchCount++
implicitWid += 50;
}
else
{
weightPresent = 1
weightSum += parseInt(childrens[i].widthProperty)
}
}
}
}
autoWid = (width - implicitWid)/(weightPresent + autoCount)
var flags = new Array(childrens.length).fill(0)
for(i=0;i<childrens.length;i++)
{
if(typeof childrens[i].seperator === 'undefined')
{
if(childrens[i].widthProperty === "auto")
{
if(childrens[i].minWidth < autoWid)
{
childrens[i].width = childrens[i].minWidth
implicitWid += childrens[i].width
flags[i] = 1;
autoCount--;
autoWid = (width - implicitWid)/(weightPresent + autoCount)
}
}
}
}
for(i=0;i<childrens.length;i++)
{
if(typeof childrens[i].seperator === 'undefined')
{
if(childrens[i].widthProperty === "auto")
{
if(flags[i] === 0)
{
childrens[i].width = autoWid
implicitWid += childrens[i].width
}
}
else if(childrens[i].widthProperty !== "stretch" && !childrens[i].widthProperty.endsWith("px"))
{
if(weightSum !== 0)
{
childrens[i].width = ((parseInt(childrens[i].widthProperty)/weightSum) * autoWid)
implicitWid += childrens[i].width
}
}
}
}
var stretchWidth = (width - implicitWid)/stretchCount
for(i=0;i<childrens.length;i++)
{
if(typeof childrens[i].seperator === 'undefined')
{
if(childrens[i].widthProperty === 'stretch')
{
childrens[i].width = 50+stretchWidth
}
}
}
}
function getMinWidth(childrens){
var min = 0
for(var j =0;j<childrens.length;j++)
{
if(typeof childrens[j].minWidth === 'undefined')
{
min = Math.max(min,Math.ceil(childrens[j].implicitWidth))
}
else
{
min = Math.max(min,Math.ceil(childrens[j].minWidth))
}
}
return min
}
function getMinWidthActionSet(childrens,spacing){
var min = 0
for(var j =0;j<childrens.length;j++)
{
min += Math.ceil(childrens[j].implicitWidth)
}
min += ((childrens.length - 1)*spacing)
return min
}
function getMinWidthFactSet(childrens, spacing){
var min = 0
for(var j=0;j<childrens.length;j+=2)
{
min = Math.max(min,childrens[j].implicitWidth + childrens[j+1].implicitWidth + spacing)
}
return min;
}
ColumnLayout{
id:adaptiveCardLayout
width:parent.width
Rectangle{
id:adaptiveCardRectangle
color:'transparent'
Layout.topMargin:margins
Layout.bottomMargin:margins
Layout.leftMargin:margins
Layout.rightMargin:margins
Layout.fillWidth:true
Layout.preferredHeight:bodyLayout.height
Layout.minimumHeight:1
Column{
id:bodyLayout
width:parent.width
onImplicitHeightChanged:{adaptiveCard.generateStretchHeight(children,-24)}
onImplicitWidthChanged:{adaptiveCard.generateStretchHeight(children,-24)}
Column{
id:choice1
function getSelectedValues(isMultiselect){
var values = "";
for (var i = 0; i < choice1_btngrp.buttons.length; ++i) {
if(i !== 0 && choice1_btngrp.buttons[i].value !== "" && values !== ""){
values += ",";
}
values += choice1_btngrp.buttons[i].value;
}
return values;
}

ButtonGroup{
id:choice1_btngrp
buttons:choice1_checkbox.children
exclusive:false
}
ColumnLayout{
id:choice1_checkbox
CheckBox{
id:choice1_2_0
property string value:checked ? "Choice 1" : ""
Layout.maximumWidth:parent.parent.parent.width
text:"Choice 1"
font.pixelSize:14
checked:true
indicator:Rectangle{
width:parent.font.pixelSize
height:parent.font.pixelSize
y:parent.topPadding + (parent.availableHeight - height) / 2
radius:3
border.color:choice1_2_0.checked ? '#0075FF' : '767676'
color:choice1_2_0.checked ? '#0075FF' : '#ffffff'
Image{
anchors.centerIn:parent
width:parent.width - 3
height:parent.height - 3
visible:choice1_2_0.checked
source:"data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTIiIGhlaWdodD0iMTIiIHZpZXdCb3g9IjAgMCAxMiAxMiIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48dGl0bGU+YWxlcnRzLWFuZC1ub3RpZmljYXRpb25zL2NoZWNrXzEyX3c8L3RpdGxlPjxwYXRoIGQ9Ik00LjUwMjQgOS41Yy0uMTMzIDAtLjI2LS4wNTMtLjM1NC0uMTQ3bC0zLjAwMi0zLjAwN2MtLjE5NS0uMTk2LS4xOTUtLjUxMi4wMDEtLjcwNy4xOTQtLjE5NS41MTEtLjE5Ni43MDcuMDAxbDIuNjQ4IDIuNjUyIDUuNjQyLTUuNjQ2Yy4xOTUtLjE5NS41MTEtLjE5NS43MDcgMCAuMTk1LjE5NS4xOTUuNTEyIDAgLjcwOGwtNS45OTUgNmMtLjA5NC4wOTMtLjIyMS4xNDYtLjM1NC4xNDYiIGZpbGw9IiNGRkYiIGZpbGwtcnVsZT0iZXZlbm9kZCIvPjwvc3ZnPg=="
}
}

contentItem:Text{
text:parent.text
font:parent.font
horizontalAlignment:Text.AlignLeft
verticalAlignment:Text.AlignVCenter
leftPadding:parent.indicator.width + parent.spacing
color:'#171B1F'
elide:Text.ElideRight
}

}
CheckBox{
id:choice1_2_1
property string value:checked ? "Choice 2" : ""
Layout.maximumWidth:parent.parent.parent.width
text:"Choice 2"
font.pixelSize:14
indicator:Rectangle{
width:parent.font.pixelSize
height:parent.font.pixelSize
y:parent.topPadding + (parent.availableHeight - height) / 2
radius:3
border.color:choice1_2_1.checked ? '#0075FF' : '767676'
color:choice1_2_1.checked ? '#0075FF' : '#ffffff'
Image{
anchors.centerIn:parent
width:parent.width - 3
height:parent.height - 3
visible:choice1_2_1.checked
source:"data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTIiIGhlaWdodD0iMTIiIHZpZXdCb3g9IjAgMCAxMiAxMiIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48dGl0bGU+YWxlcnRzLWFuZC1ub3RpZmljYXRpb25zL2NoZWNrXzEyX3c8L3RpdGxlPjxwYXRoIGQ9Ik00LjUwMjQgOS41Yy0uMTMzIDAtLjI2LS4wNTMtLjM1NC0uMTQ3bC0zLjAwMi0zLjAwN2MtLjE5NS0uMTk2LS4xOTUtLjUxMi4wMDEtLjcwNy4xOTQtLjE5NS41MTEtLjE5Ni43MDcuMDAxbDIuNjQ4IDIuNjUyIDUuNjQyLTUuNjQ2Yy4xOTUtLjE5NS41MTEtLjE5NS43MDcgMCAuMTk1LjE5NS4xOTUuNTEyIDAgLjcwOGwtNS45OTUgNmMtLjA5NC4wOTMtLjIyMS4xNDYtLjM1NC4xNDYiIGZpbGw9IiNGRkYiIGZpbGwtcnVsZT0iZXZlbm9kZCIvPjwvc3ZnPg=="
}
}

contentItem:Text{
text:parent.text
font:parent.font
horizontalAlignment:Text.AlignLeft
verticalAlignment:Text.AlignVCenter
leftPadding:parent.indicator.width + parent.spacing
color:'#171B1F'
elide:Text.ElideRight
}

}
CheckBox{
id:choice1_2_2
property string value:checked ? "Choice 3" : ""
Layout.maximumWidth:parent.parent.parent.width
text:"Choice 3"
font.pixelSize:14
indicator:Rectangle{
width:parent.font.pixelSize
height:parent.font.pixelSize
y:parent.topPadding + (parent.availableHeight - height) / 2
radius:3
border.color:choice1_2_2.checked ? '#0075FF' : '767676'
color:choice1_2_2.checked ? '#0075FF' : '#ffffff'
Image{
anchors.centerIn:parent
width:parent.width - 3
height:parent.height - 3
visible:choice1_2_2.checked
source:"data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTIiIGhlaWdodD0iMTIiIHZpZXdCb3g9IjAgMCAxMiAxMiIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48dGl0bGU+YWxlcnRzLWFuZC1ub3RpZmljYXRpb25zL2NoZWNrXzEyX3c8L3RpdGxlPjxwYXRoIGQ9Ik00LjUwMjQgOS41Yy0uMTMzIDAtLjI2LS4wNTMtLjM1NC0uMTQ3bC0zLjAwMi0zLjAwN2MtLjE5NS0uMTk2LS4xOTUtLjUxMi4wMDEtLjcwNy4xOTQtLjE5NS41MTEtLjE5Ni43MDcuMDAxbDIuNjQ4IDIuNjUyIDUuNjQyLTUuNjQ2Yy4xOTUtLjE5NS41MTEtLjE5NS43MDcgMCAuMTk1LjE5NS4xOTUuNTEyIDAgLjcwOGwtNS45OTUgNmMtLjA5NC4wOTMtLjIyMS4xNDYtLjM1NC4xNDYiIGZpbGw9IiNGRkYiIGZpbGwtcnVsZT0iZXZlbm9kZCIvPjwvc3ZnPg=="
}
}

contentItem:Text{
text:parent.text
font:parent.font
horizontalAlignment:Text.AlignLeft
verticalAlignment:Text.AlignVCenter
leftPadding:parent.indicator.width + parent.spacing
color:'#171B1F'
elide:Text.ElideRight
}

}
}
}
Rectangle{
readonly property bool seperator:true
width:parent.width
height:12
color:"transparent"
visible:true
}
Column{
id:choice2
function getSelectedValues(isMultiselect){
var values = "";
for (var i = 0; i < choice2_btngrp.buttons.length; ++i) {
if(choice2_btngrp.buttons[i].value !== ""){
values += choice2_btngrp.buttons[i].value;
break;
}
}
return values;
}

ButtonGroup{
id:choice2_btngrp
buttons:choice2_radio.children
}
ColumnLayout{
id:choice2_radio
RadioButton{
id:choice2_1_0
property string value:checked ? "Choice 1" : ""
Layout.maximumWidth:parent.parent.parent.width
text:"Choice 1"
font.pixelSize:14
checked:true
indicator:Rectangle{
width:parent.font.pixelSize
height:parent.font.pixelSize
y:parent.topPadding + (parent.availableHeight - height) / 2
radius:height/2
border.color:choice2_1_0.checked ? '#0075FF' : '767676'
color:choice2_1_0.checked ? '#0075FF' : '#ffffff'
Rectangle{
width:parent.width/2
height:parent.height/2
x:width/2
y:height/2
radius:height/2
color:choice2_1_0.checked ? '#ffffff' : 'defaultPalette.backgroundColor'
visible:choice2_1_0.checked
}
}

contentItem:Text{
text:parent.text
font:parent.font
horizontalAlignment:Text.AlignLeft
verticalAlignment:Text.AlignVCenter
leftPadding:parent.indicator.width + parent.spacing
color:'#171B1F'
elide:Text.ElideRight
}

}
RadioButton{
id:choice2_1_1
property string value:checked ? "Choice 2" : ""
Layout.maximumWidth:parent.parent.parent.width
text:"Choice 2"
font.pixelSize:14
indicator:Rectangle{
width:parent.font.pixelSize
height:parent.font.pixelSize
y:parent.topPadding + (parent.availableHeight - height) / 2
radius:height/2
border.color:choice2_1_1.checked ? '#0075FF' : '767676'
color:choice2_1_1.checked ? '#0075FF' : '#ffffff'
Rectangle{
width:parent.width/2
height:parent.height/2
x:width/2
y:height/2
radius:height/2
color:choice2_1_1.checked ? '#ffffff' : 'defaultPalette.backgroundColor'
visible:choice2_1_1.checked
}
}

contentItem:Text{
text:parent.text
font:parent.font
horizontalAlignment:Text.AlignLeft
verticalAlignment:Text.AlignVCenter
leftPadding:parent.indicator.width + parent.spacing
color:'#171B1F'
elide:Text.ElideRight
}

}
}
}
Rectangle{
readonly property bool seperator:true
width:parent.width
height:12
color:"transparent"
visible:true
}
ComboBox{
id:choice3
textRole:'text'
valueRole:'value'
width:parent.width
indicator:Image{
source:"data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTIiIGhlaWdodD0iMTIiIHZpZXdCb3g9IjAgMCAxMiAxMiIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48dGl0bGU+bmF2aWdhdGlvbi9hcnJvdy1kb3duXzEyPC90aXRsZT48cGF0aCBkPSJNMS4wMDA0MSAzLjQ5OTc0ODc2NGMwLS4xMzcuMDU2LS4yNzMuMTY1LS4zNzIuMjA2LS4xODUwMDAwMDAxLjUyMi0uMTY4MDAwMDAwMS43MDcuMDM3bDQuMTI4IDQuNTg2OTk5OTk2IDQuMTI4LTQuNTg2OTk5OTk2Yy4xODUtLjIwNTAwMDAwMDEuNTAxLS4yMjIwMDAwMDAxLjcwNy0uMDM3LjIwNC4xODUuMjIxLjUwMS4wMzcuNzA2bC00LjUgNC45OTk5OTk5OTZjLS4wOTYuMTA2LS4yMy4xNjYtLjM3Mi4xNjYtLjE0MiAwLS4yNzYtLjA2LS4zNzItLjE2NmwtNC41LTQuOTk5OTk5OTk2Yy0uMDg2LS4wOTUtLjEyOC0uMjE1LS4xMjgtLjMzNCIgZmlsbD0iIzAwMCIgZmlsbC1ydWxlPSJldmVub2RkIi8+PC9zdmc+"
anchors.right:parent.right
anchors.verticalCenter:parent.verticalCenter
anchors.margins:5
fillMode:Image.PreserveAspectFit
mipmap:true
ColorOverlay{
anchors.fill:parent
source:parent
color:'#171B1F'
}
}

model:[{ value: 'Choice 1', text: 'Choice 1'},
{ value: 'Choice 2', text: 'Choice 2'},
]
background:Rectangle{
radius:5
color:'#FFFFFF'
border.color:'grey'
border.width:1
}

currentIndex:-1
displayText:currentIndex === -1 ? 'Placeholder text' : currentText
delegate:ItemDelegate{
width:parent.width
background:Rectangle{
color:'#FFFFFF'
border.color:'grey'
border.width:1
}

contentItem:Text{
text:modelData.text
font:parent.font
verticalAlignment:Text.AlignVCenter
color:'#171B1F'
elide:Text.ElideRight
}

}

contentItem:Text{
text:parent.displayText
font:parent.font
verticalAlignment:Text.AlignVCenter
padding:12
elide:Text.ElideRight
color:'#171B1F'
}

}
Rectangle{
readonly property bool seperator:true
width:parent.width
height:12
color:"transparent"
visible:true
}
ComboBox{
id:choice4
textRole:'text'
valueRole:'value'
width:parent.width
indicator:Image{
source:"data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTIiIGhlaWdodD0iMTIiIHZpZXdCb3g9IjAgMCAxMiAxMiIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48dGl0bGU+bmF2aWdhdGlvbi9hcnJvdy1kb3duXzEyPC90aXRsZT48cGF0aCBkPSJNMS4wMDA0MSAzLjQ5OTc0ODc2NGMwLS4xMzcuMDU2LS4yNzMuMTY1LS4zNzIuMjA2LS4xODUwMDAwMDAxLjUyMi0uMTY4MDAwMDAwMS43MDcuMDM3bDQuMTI4IDQuNTg2OTk5OTk2IDQuMTI4LTQuNTg2OTk5OTk2Yy4xODUtLjIwNTAwMDAwMDEuNTAxLS4yMjIwMDAwMDAxLjcwNy0uMDM3LjIwNC4xODUuMjIxLjUwMS4wMzcuNzA2bC00LjUgNC45OTk5OTk5OTZjLS4wOTYuMTA2LS4yMy4xNjYtLjM3Mi4xNjYtLjE0MiAwLS4yNzYtLjA2LS4zNzItLjE2NmwtNC41LTQuOTk5OTk5OTk2Yy0uMDg2LS4wOTUtLjEyOC0uMjE1LS4xMjgtLjMzNCIgZmlsbD0iIzAwMCIgZmlsbC1ydWxlPSJldmVub2RkIi8+PC9zdmc+"
anchors.right:parent.right
anchors.verticalCenter:parent.verticalCenter
anchors.margins:5
fillMode:Image.PreserveAspectFit
mipmap:true
ColorOverlay{
anchors.fill:parent
source:parent
color:'#171B1F'
}
}

model:[{ value: 'Choice 1', text: 'Choice 1'},
{ value: 'Choice 2', text: 'Choice 2'},
]
background:Rectangle{
radius:5
color:'#FFFFFF'
border.color:'grey'
border.width:1
}

currentIndex:-1
displayText:currentIndex === -1 ? 'Placeholder text' : currentText
delegate:ItemDelegate{
width:parent.width
background:Rectangle{
color:'#FFFFFF'
border.color:'grey'
border.width:1
}

contentItem:Text{
text:modelData.text
font:parent.font
verticalAlignment:Text.AlignVCenter
color:'#171B1F'
elide:Text.ElideRight
}

}

contentItem:Text{
text:parent.displayText
font:parent.font
verticalAlignment:Text.AlignVCenter
padding:12
elide:Text.ElideRight
color:'#171B1F'
}

}
}
}
}
}
