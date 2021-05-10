/*
Example Usage

DateInput{
	id:sampleUsage_id
	dateFormat:"ddmmyy"  //Allowed Values:"ddmmyy","yymmdd","yyddmm","mmddyy"
	minDate: new Date(1900,0,1)
	maxDate: new Date(2040,0,1)
	defaultDate: new Date(2021,3,29)
	bgrcolor:'white'
	width:200
	//NOTE: Avoid setting the text property, defaultDate can be used to set default value
}
*/
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15

TextField{
	readonly property variant outputDateFormats: {"ddmmyy":"dd\/MMM\/yyyy","yymmdd":"yyyy\/MMM\/dd","yyddmm":"yyyy\/dd\/MMM","mmddyy":"MMM\/dd\/yyyy"}
    readonly property variant regex: {
                                    "ddmmyy":/^([-0123]-|0\d|[12]\d|3[01])\/(---|[JFMASOND]--|Ja-|Jan|Fe-|Feb|Ma-|Mar|Ap-|Apr|May|Ju--|Jun|Jul|Au-|Aug|Se-|Sep|Oc-|Oct|No-|Nov|De-|Dec)\/(-{4}|\d-{3}|\d{2}-{2}|\d{3}-|\d{4})$/,
                                    "yymmdd":/^(-{4}|\d-{3}|\d{2}-{2}|\d{3}-|\d{4})\/(---|[JFMASOND]--|Ja-|Jan|Fe-|Feb|Ma-|Mar|Ap-|Apr|May|Ju--|Jun|Jul|Au-|Aug|Se-|Sep|Oc-|Oct|No-|Nov|De-|Dec)\/([-0123]-|0\d|[12]\d|3[01])$/,
                                    "yyddmm":/^(-{4}|\d-{3}|\d{2}-{2}|\d{3}-|\d{4})\/([-0123]-|0\d|[12]\d|3[01])\/(---|[JFMASOND]--|Ja-|Jan|Fe-|Feb|Ma-|Mar|Ap-|Apr|May|Ju--|Jun|Jul|Au-|Aug|Se-|Sep|Oc-|Oct|No-|Nov|De-|Dec)$/,
                                    "mmddyy":/^(---|[JFMASOND]--|Ja-|Jan|Fe-|Feb|Ma-|Mar|Ap-|Apr|May|Ju--|Jun|Jul|Au-|Aug|Se-|Sep|Oc-|Oct|No-|Nov|De-|Dec)\/([-0123]-|0\d|[12]\d|3[01])\/(-{4}|\d-{3}|\d{2}-{2}|\d{3}-|\d{4})$/
									}
    readonly property variant maskFormat:{
									"ddmmyy":"xx\/>x<xx\/xxxx;-",
									"yymmdd":"xxxx\/>x<xx\/xx;-",
									"yyddmm":"xxxx\/xx\/>x<xx;-",
									"mmddyy":">x<xx\/xx\/xxxx;-"
									}
	property date defaultDate
    property date minDate: new Date(1900,0,1)
    property date maxDate: new Date(2050,0,1)
    property string selectedDate:""
    property string dateFormat:"mmddyy"
    property alias bgrcolor: bgrRectangle.color

    id:textFieldID
    width:200
    font.family:"Segoe UI"
    font.pixelSize:14
    selectByMouse:true
    selectedTextColor:'white'
    color:'#171B1F'

	//Avoid setting text property while using the element
    text: defaultDate.toLocaleString(Qt.locale("en_US"),outputDateFormats[dateFormat])
    
    background:Rectangle{
        id:bgrRectangle
        radius:5
        color:'#FFFFFF'
        border.color:textFieldID.activeFocus? 'black' : 'grey'
        border.width:1
        layer.enabled:textFieldID.activeFocus ? true : false
        layer.effect:Glow{
            samples:25
            color:'skyblue'
        }
    }
    onTextChanged:{textFieldTextChanged(text);setValidDate(text);}
    placeholderText:""
    validator: RegExpValidator{regExp: regex[dateFormat]}
    onFocusChanged:{
        if(focus===true){
            inputMask=textFieldID.maskFormat[textFieldID.dateFormat];
        }
        if(focus === false)
        {
            z=0;
            if(text === "\/\/"){ inputMask = "" ; }
            if( textFieldID_cal_box.visible === true)
            { textFieldID_cal_box.visible=false}
        }
    }
    signal textFieldTextChanged(var dateText)
    //Function to set appropriate date to be recevied by an action
    function setValidDate(dateString){
        var Months = {Jan: 0,Feb: 1,Mar: 2,Apr: 3,May: 4,Jun: 5,July: 6,Aug: 7,Sep: 8,Oct: 9,Nov: 10,Dec: 11};
        var day_month_year_positions={
                                    "ddmmyy":{
                                            "day":{"start":0,"end":2},
                                            "month":{"start":3,"end":6},
                                            "year":{"start":7,"end":11}
                                            },
                                    "yymmdd":{
                                            "day":{"start":9,"end":11},
                                            "month":{"start":5,"end":8},
                                            "year":{"start":0,"end":4}
                                            },
                                    "yyddmm":{
                                            "day":{"start":5,"end":7},
                                            "month":{"start":8,"end":11},
                                            "year":{"start":0,"end":4}
                                            },
                                    "mmddyy":{
                                            "day":{"start":4,"end":6},
                                            "month":{"start":0,"end":3},
                                            "year":{"start":7,"end":11}
                                            }
                                    }
        //Extract the year, month and day based on date format from TextField
        var year_text = getText(day_month_year_positions[textFieldID.dateFormat]["year"]["start"],day_month_year_positions[textFieldID.dateFormat]["year"]["end"])
        var month_text = Months[getText(day_month_year_positions[textFieldID.dateFormat]["month"]["start"],day_month_year_positions[textFieldID.dateFormat]["month"]["end"])]
        var day_text = getText(day_month_year_positions[textFieldID.dateFormat]["day"]["start"],day_month_year_positions[textFieldID.dateFormat]["day"]["end"])
        var dateObject=new Date(year_text, month_text,day_text);
        //Check if the date inputted is a valid date
        if( dateObject.getFullYear() === parseInt(year_text) && dateObject.getMonth()===month_text && dateObject.getDate()===parseInt(day_text))
        {
            selectedDate = dateObject.toLocaleString(Qt.locale("en_US"),"yyyy-MM-dd");
        }
        else{
            selectedDate = ''
        }
    }
    MouseArea{
        height:parent.height
		//Hardocded width to avoid stretching in case height of TextBlock is stretched 
        width:30
        anchors.right:parent.right
        enabled:true
        onClicked:{ parent.forceActiveFocus(); textFieldID_cal_box.visible=!textFieldID_cal_box.visible; parent.z=textFieldID_cal_box.visible?1:0; }
        Image{
            anchors.fill:parent
            anchors.margins:5
            fillMode:Image.PreserveAspectFit
            mipmap:true
            source:"data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMzIiIGhlaWdodD0iMzIiIHZpZXdCb3g9IjAgMCAzMiAzMiIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48dGl0bGU+bWVldGluZ3MvY2FsZW5kYXItZW1wdHlfMzI8L3RpdGxlPjxwYXRoIGQ9Ik0zMCAyM2wwIDEgMCA0LjAwOEMzMCAyOS4xMDUgMjkuMTAzIDMwIDI4IDMwTDQgMzBjLTEuMTA1IDAtMi0uODkzLTItMS45OTJMMiAyNGwwLTFMMiA2Ljk5MkMyIDUuODk1IDIuODk3IDUgNCA1bDI0IDBjMS4xMDUgMCAyIC44OTMgMiAxLjk5MkwzMCAyM3pNMjggNGwtNSAwIDAtMi41MDVjMC0uMjc5LS4yMjQtLjQ5NS0uNS0uNDk1LS4yNjggMC0uNS4yMjItLjUuNDk1TDIyIDQgMTAgNGwwLTIuNTA1QzEwIDEuMjE2IDkuNzc2IDEgOS41IDFjLS4yNjggMC0uNS4yMjItLjUuNDk1TDkgNCA0IDRDMi4zNDcgNCAxIDUuMzQgMSA2Ljk5MmwwIDIxLjAxNkMxIDI5LjY2MSAyLjM0MyAzMSA0IDMxbDI0IDBjMS42NTMgMCAzLTEuMzQgMy0yLjk5MmwwLTIxLjAxNkMzMSA1LjMzOSAyOS42NTcgNCAyOCA0eiIgZmlsbC1ydWxlPSJldmVub2RkIi8+PC9zdmc+"
            ColorOverlay{
                anchors.fill:parent
                source:parent
                color:textFieldID.color
            }
        }
    }
    Rectangle{
        id:textFieldID_cal_box
        visible:false
        anchors.left:parent.left
        anchors.top:parent.bottom
        width:300
        height:300
        Component.onCompleted:{ Qt.createQmlObject(
'import QtQuick.Controls 1.4
import QtQuick 2.15
Calendar{
anchors.fill:parent
minimumDate:textFieldID.minDate
maximumDate:textFieldID.maxDate
Component.onCompleted:{
    textFieldID.textFieldTextChanged.connect(setCalendarDate);
    textFieldID.textFieldTextChanged( textFieldID.text)}
onReleased:{
    parent.visible=false;
    textFieldID.text=selectedDate.toLocaleString(Qt.locale("en_US"),textFieldID.outputDateFormats[textFieldID.dateFormat])
}
function setCalendarDate(dateString){
    var Months = {Jan: 0,Feb: 1,Mar: 2,Apr: 3,May: 4,Jun: 5,July: 6,Aug: 7,Sep: 8,Oct: 9,Nov: 10,Dec: 11};
    var y=dateString.match(/\\d{4}/);
    dateString=dateString.replace(y,"");
    var m=dateString.match(/[a-zA-Z]{3}/);
    var d=dateString.match(/\\d{2}/);
    if (d!==null && m!==null && y!==null)
    {selectedDate=new Date(y[0],Months[m[0]],d[0]) }
	}
}',textFieldID_cal_box,'calendar')}
    }
}