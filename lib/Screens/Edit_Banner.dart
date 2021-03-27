import 'dart:ffi';
import 'dart:io';

import 'package:bmt_backend/Utility/Banner_Model.dart';
import 'package:bmt_backend/Widgets/Banner_Widget.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EditBanner extends StatefulWidget {
  
    final BannerModel _bannerModel;
    final bool add;
    
  @override
  _EditBannerState createState() => _EditBannerState();
  
  EditBanner(this._bannerModel,this.add);
  
}

class _EditBannerState extends State<EditBanner> {

  PageController pageCon = new PageController(initialPage: 0);
  List<TextEditingController> textCon = List(6);

  final _titleKey = GlobalKey<FormState>();
  final _descKey = GlobalKey<FormState>();
  final _commKey = GlobalKey<FormState>();
  final _dateKey = GlobalKey<FormState>();
  final _cityKey = GlobalKey<FormState>();
  final _linkKey = GlobalKey<FormState>();


  BannerModel editModel = new BannerModel("", null, "", "", "", '', '', '', '');
  String dropDownColor = "orange";

  List<String> colorOptions = [
      "orange",
      "amber",
      "red",
      "cyan",
      "lightBlue",
      "blue",
      "indigo",
      "purple",
      "teal",
      "lightGreen",
      "green"
  ];

  @override
  void initState() {
    super.initState();
    if(widget.add)
        editModel = widget._bannerModel;
    else
        editModel = widget._bannerModel.copy(widget._bannerModel);

    editModel.setColor();
    textCon[0] = new TextEditingController(text: editModel.title);
    textCon[1] = new TextEditingController(text: editModel.description);
    textCon[2] = new TextEditingController(text: editModel.comments);
    textCon[3] = new TextEditingController(text: editModel.date);
    textCon[4] = new TextEditingController(text: editModel.city);
    textCon[5] = new TextEditingController(text: editModel.link);

    dropDownColor = colorOptions[colorOptions.indexOf(editModel.color)];

    Connectivity().onConnectivityChanged.listen((event) {
        getInternet();
    });
  }

  getInternet() async {
      try {
          final result = await InternetAddress.lookup('google.com');
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {

          }
      } on SocketException catch (_) {
          showDialog(
              context: context,
              builder: (_) => AlertDialog(
                  title: Text("Internet connection lost."),
                  content: Text("Changes will not be saved."),
                  actions: [
                      FlatButton(
                          child: Text("Exit"),
                          onPressed: (){
                              Navigator.pop(context);
                              Navigator.pop(context, null);
                          },
                      )
                  ],
              ),
              barrierDismissible: false,
          );
      }
  }

  @override
  Widget build(BuildContext context) {

    ScreenUtil.init(context, width: 360, height: 640, allowFontScaling: true);

    final List<DropdownMenuItem<String>> dropDownItems = List.generate(11, (index) => DropdownMenuItem(
        value: colorOptions[index],
        child: Container(
            //height: ScreenUtil().setHeight(20),
            //width: ScreenUtil().setWidth(20),
            padding: EdgeInsets.fromLTRB(
                ScreenUtil().setWidth(5),
                ScreenUtil().setHeight(5),
                ScreenUtil().setWidth(5),
                ScreenUtil().setHeight(5)
            ),
            decoration: BoxDecoration(gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: widget._bannerModel.getColor(widget._bannerModel.colorOptions[index]),
            ),
                borderRadius: BorderRadius.circular(7),
            ),
            child: Text(
                widget._bannerModel.colorOptions[index],
                style: TextStyle(
                    color: Colors.white,
                ),
            ),
        ),
    ));

    return WillPopScope(
      onWillPop: (){
          showDialog(
              context: context,
              builder: (_) => AlertDialog(
                  title: Text("Are you sure you want to leave?"),
                  content: Text("Changes will not be saved."),
                  actions: [
                      FlatButton(
                          child: Text("No"),
                          onPressed: (){
                              Navigator.pop(context);
                              return true;
                          },
                      ),
                      FlatButton(
                          child: Text("yes"),
                          onPressed: (){
                              if(widget.add)
                              Navigator.pop(context);
                              Navigator.pop(context,null);
                          },
                      )
                  ],
              ),
              barrierDismissible: false,
          );
          return null;
      },
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
              toolbarHeight: ScreenUtil().setHeight(60),
              leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: (){
                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                              title: Text("Are you sure you want to leave?"),
                              content: Text("Changes will not be saved."),
                              actions: [
                                  FlatButton(
                                      child: Text("No"),
                                      onPressed: (){
                                          Navigator.pop(context);
                                      },
                                  ),
                                  FlatButton(
                                      child: Text("yes"),
                                      onPressed: (){
                                          Navigator.pop(context);
                                          Navigator.pop(context, null);
                                      },
                                  )
                              ],
                          ),
                          barrierDismissible: false,
                      );
                  },
              ),
              title: Text("Edit Banner"),
          ),

          body: Container(
            //width: ScreenUtil().setWidth(360),
            //height: ScreenUtil().setHeight(640),
            child: SafeArea(
              child: Column(
                  children: [

                      Padding(
                          padding: EdgeInsets.fromLTRB(0, ScreenUtil().setHeight(10), 0, ScreenUtil().setHeight(10)),
                          child: BannerWidget(editModel),
                      ),

                      Container(
                          height: 1,
                          color: Colors.grey.withOpacity(0.5),
                      ),

                      Expanded(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(0, ScreenUtil().setHeight(10), 0, ScreenUtil().setHeight(3)),
                          width: ScreenUtil().setWidth(360),
                          height: ScreenUtil().setHeight(410),
                          child: PageView(
                                onPageChanged: (index){
                                    FocusScope.of(context).unfocus();

                                    switch(index){
                                        case 0:
                                            _titleKey.currentState.validate();
                                            break;
                                        case 1:
                                            _descKey.currentState.validate();
                                            break;
                                        case 2:
                                            _commKey.currentState.validate();
                                            break;
                                        case 3:
                                            _dateKey.currentState.validate();
                                            break;
                                        case 4:
                                            _cityKey.currentState.validate();
                                            break;
                                        case 5:
                                            _linkKey.currentState.validate();
                                            break;
                                    }
                                },
                                controller: pageCon,
                                children: [

                                    Container(
                                        width: ScreenUtil().setWidth(360),
                                        height: ScreenUtil().setHeight(410),
                                        padding: EdgeInsets.fromLTRB(
                                                ScreenUtil().setWidth(15),
                                                ScreenUtil().setHeight(15),
                                                ScreenUtil().setWidth(15),
                                                ScreenUtil().setHeight(15)
                                        ),
                                        child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [

                                                Text("Enter the title",
                                                    style: TextStyle(
                                                            fontSize: ScreenUtil().setSp(20),
                                                            fontWeight: FontWeight.w600
                                                    ),
                                                ),

                                                Form(
                                                    key: _titleKey,
                                                    child: TextFormField(
                                                        keyboardType: TextInputType.text,
                                                        controller: textCon[0],
                                                        decoration: InputDecoration(
                                                            suffixIcon: IconButton(
                                                                icon: Icon(
                                                                    Icons.content_paste,
                                                                    color: Colors.black,
                                                                    size: 23,),
                                                                onPressed: () {
                                                                    setClip(0);
                                                                },
                                                            ),
                                                        ),
                                                        onChanged: (title){
                                                            setState(() {
                                                                editModel.title = title;
                                                            });
                                                            _titleKey.currentState.validate();
                                                        },
                                                        validator: (title){
                                                            var tp = TextPainter(
                                                                maxLines: 1,
                                                                textAlign: TextAlign.left,
                                                                textDirection: TextDirection.ltr,
                                                                text: TextSpan(
                                                                        style: TextStyle(color: Colors.white,
                                                                                fontSize: ScreenUtil().setSp(16),
                                                                                fontWeight: FontWeight.w600
                                                                        ),
                                                                        text: title
                                                                ),
                                                            );

                                                            tp.layout(maxWidth: 300);
                                                            var b = tp.didExceedMaxLines;
                                                            if(title == "" || title == null){
                                                                return "Title cannot be empty";
                                                            } else if(b) {
                                                                return "Text is overflowing!";
                                                            } else
                                                                return null;
                                                        },
                                                    ),
                                                ),

                                                /*SizedBox(
                                                    height: ScreenUtil().setHeight(200),
                                                ),

                                                KeyboardAvoider(
                                                    child: Opacity(
                                                        opacity: 1,
                                                        child: TextField(
                                                            enabled: true,
                                                        ),
                                                    ),
                                                ),*/

                                            ],
                                        ),
                                    ),

                                    Form(
                                        key: _descKey,
                                        child: Container(
                                            width: ScreenUtil().setWidth(360),
                                            height: ScreenUtil().setHeight(410),
                                            padding: EdgeInsets.fromLTRB(
                                                    ScreenUtil().setWidth(15),
                                                    ScreenUtil().setHeight(15),
                                                    ScreenUtil().setWidth(15),
                                                    ScreenUtil().setHeight(15)
                                            ),
                                            child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [

                                                    Text("Enter the description",
                                                        style: TextStyle(
                                                                fontSize: ScreenUtil().setSp(20),
                                                                fontWeight: FontWeight.w600
                                                        ),
                                                    ),

                                                    TextFormField(
                                                        controller: textCon[1],
                                                        keyboardType: TextInputType.text,
                                                        decoration: InputDecoration(
                                                            suffixIcon: IconButton(
                                                                icon: Icon(
                                                                    Icons.content_paste,
                                                                    color: Colors.black,
                                                                    size: 23,),
                                                                onPressed: () {
                                                                    setClip(1);
                                                                },
                                                            ),
                                                        ),
                                                        onChanged: (desc){
                                                            setState(() {
                                                                editModel.description = desc;
                                                            });
                                                            _descKey.currentState.validate();
                                                        },
                                                        validator: (desc){
                                                            var tp = TextPainter(
                                                                maxLines: 1,
                                                                textAlign: TextAlign.left,
                                                                textDirection: TextDirection.ltr,
                                                                text: TextSpan(
                                                                        style: TextStyle(color: Colors.white,
                                                                                fontSize: ScreenUtil().setSp(12),
                                                                                fontWeight: FontWeight.w500
                                                                        ),
                                                                        text: desc
                                                                ),
                                                            );

                                                            tp.layout(maxWidth: 300);
                                                            var b = tp.didExceedMaxLines;
                                                            if(desc == "" || desc == null){
                                                                return "Description cannot be empty";
                                                            } else if(b) {
                                                                return "Text is overflowing!";
                                                            } else
                                                                return null;
                                                        },
                                                    ),

                                                ],
                                            ),
                                        ),
                                    ),

                                    Form(
                                        key: _commKey,
                                        child: Container(
                                            width: ScreenUtil().setWidth(360),
                                            height: ScreenUtil().setHeight(410),
                                            padding: EdgeInsets.fromLTRB(
                                                    ScreenUtil().setWidth(15),
                                                    ScreenUtil().setHeight(15),
                                                    ScreenUtil().setWidth(15),
                                                    ScreenUtil().setHeight(15)
                                            ),
                                            child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [

                                                    Text("Enter the comments",
                                                        style: TextStyle(
                                                                fontSize: ScreenUtil().setSp(20),
                                                                fontWeight: FontWeight.w600
                                                        ),
                                                    ),

                                                    TextFormField(
                                                        keyboardType: TextInputType.multiline,
                                                        maxLines: null,
                                                        textInputAction: TextInputAction.newline,
                                                        controller: textCon[2],
                                                        decoration: InputDecoration(
                                                            suffixIcon: IconButton(
                                                                icon: Icon(
                                                                    Icons.content_paste,
                                                                    color: Colors.black,
                                                                    size: 23,),
                                                                onPressed: () {
                                                                    setClip(2);
                                                                },
                                                            ),
                                                        ),
                                                        onChanged: (comm){
                                                            setState(() {
                                                                editModel.comments = comm;
                                                            });
                                                            _commKey.currentState.validate();
                                                        },
                                                        validator: (comm){
                                                            var tp = TextPainter(
                                                                maxLines: comm.contains("\n") ? 2 : 1,
                                                                textAlign: TextAlign.left,
                                                                textDirection: TextDirection.ltr,
                                                                text: TextSpan(
                                                                        style: TextStyle(color: Colors.white,
                                                                            fontSize: ScreenUtil().setSp(10),
                                                                        ),
                                                                        text: comm
                                                                ),
                                                            );

                                                            tp.layout(maxWidth: 95);
                                                            var b = tp.didExceedMaxLines;
                                                            if(comm == "" || comm == null){
                                                                return "Comment cannot be empty";
                                                            } else if(b) {
                                                                return "Text is overflowing!";
                                                            } else
                                                                return null;
                                                        },
                                                    ),

                                                ],
                                            ),
                                        ),
                                    ),

                                    Form(
                                        key: _dateKey,
                                        child: Container(
                                            width: ScreenUtil().setWidth(360),
                                            height: ScreenUtil().setHeight(410),
                                            padding: EdgeInsets.fromLTRB(
                                                    ScreenUtil().setWidth(15),
                                                    ScreenUtil().setHeight(15),
                                                    ScreenUtil().setWidth(15),
                                                    ScreenUtil().setHeight(15)
                                            ),
                                            child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [

                                                    Text("Enter the Dates",
                                                        style: TextStyle(
                                                                fontSize: ScreenUtil().setSp(20),
                                                                fontWeight: FontWeight.w600
                                                        ),
                                                    ),

                                                    TextFormField(
                                                        keyboardType: TextInputType.multiline,
                                                        maxLines: null,
                                                        textInputAction: TextInputAction.newline,
                                                        controller: textCon[3],
                                                        decoration: InputDecoration(
                                                            suffixIcon: IconButton(
                                                                icon: Icon(
                                                                    Icons.content_paste,
                                                                    color: Colors.black,
                                                                    size: 23,),
                                                                onPressed: () {
                                                                    setClip(3);
                                                                },
                                                            ),
                                                        ),
                                                        onChanged: (date){
                                                            setState(() {
                                                                editModel.date = date;
                                                            });
                                                            _dateKey.currentState.validate();
                                                        },
                                                        validator: (date){
                                                            var tp = TextPainter(
                                                                maxLines: date.contains("\n") ? 2 : 1,
                                                                textAlign: TextAlign.left,
                                                                textDirection: TextDirection.ltr,
                                                                text: TextSpan(
                                                                    style: TextStyle(color: Colors.white,
                                                                        fontSize: ScreenUtil().setSp(10),
                                                                    ),
                                                                    text: editModel.date + ' \(' +
                                                                            editModel.city + '\)',
                                                                ),
                                                            );

                                                            tp.layout(maxWidth: 188);
                                                            var b = tp.didExceedMaxLines;
                                                            if(date == "" || date == null){
                                                                return "Date cannot be empty";
                                                            } else if(b) {
                                                                return "Text is overflowing!";
                                                            } else
                                                                return null;
                                                        },
                                                    ),
                                                ],
                                            ),
                                        ),
                                    ),

                                    Form(
                                        key: _cityKey,
                                        child: Container(
                                            width: ScreenUtil().setWidth(360),
                                            height: ScreenUtil().setHeight(410),
                                            padding: EdgeInsets.fromLTRB(
                                                    ScreenUtil().setWidth(15),
                                                    ScreenUtil().setHeight(15),
                                                    ScreenUtil().setWidth(15),
                                                    ScreenUtil().setHeight(15)
                                            ),
                                            child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [

                                                    Text("Enter the city",
                                                        style: TextStyle(
                                                                fontSize: ScreenUtil().setSp(20),
                                                                fontWeight: FontWeight.w600
                                                        ),
                                                    ),

                                                    TextFormField(
                                                        keyboardType: TextInputType.text,
                                                        controller: textCon[4],
                                                        onChanged: (city){
                                                            setState(() {
                                                                editModel.city = city;
                                                            });
                                                            _cityKey.currentState.validate();
                                                        },
                                                        validator: (city){
                                                            var tp = TextPainter(
                                                                maxLines: editModel.date.contains("\n") ? 2 : 1,
                                                                textAlign: TextAlign.left,
                                                                textDirection: TextDirection.ltr,
                                                                text: TextSpan(
                                                                    style: TextStyle(color: Colors.white,
                                                                        fontSize: ScreenUtil().setSp(10),
                                                                    ),
                                                                    text: editModel.date + ' \(' +
                                                                            editModel.city + '\)',
                                                                ),
                                                            );

                                                            tp.layout(maxWidth: 188);
                                                            var b = tp.didExceedMaxLines;
                                                            if(city == "" || city == null){
                                                                return "City cannot be empty";
                                                            } else if(b) {
                                                                return "Text is overflowing!";
                                                            } else
                                                                return null;
                                                        },
                                                    ),
                                                ],
                                            ),
                                        ),
                                    ),

                                    Form(
                                        key: _linkKey,
                                        child: Container(
                                            width: ScreenUtil().setWidth(360),
                                            height: ScreenUtil().setHeight(410),
                                            padding: EdgeInsets.fromLTRB(
                                                    ScreenUtil().setWidth(15),
                                                    ScreenUtil().setHeight(15),
                                                    ScreenUtil().setWidth(15),
                                                    ScreenUtil().setHeight(15)
                                            ),
                                            child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [

                                                    Text("Enter the link",
                                                        style: TextStyle(
                                                                fontSize: ScreenUtil().setSp(20),
                                                                fontWeight: FontWeight.w600
                                                        ),
                                                    ),

                                                    TextFormField(
                                                        keyboardType: TextInputType.text,
                                                        controller: textCon[5],
                                                        decoration: InputDecoration(
                                                            suffixIcon: IconButton(
                                                                icon: Icon(
                                                                    Icons.content_paste,
                                                                    color: Colors.black,
                                                                    size: 23,),
                                                                onPressed: () {
                                                                    setClip(5);
                                                                },
                                                            ),
                                                        ),
                                                        onChanged: (link){
                                                            setState(() {
                                                                editModel.link = link;
                                                            });
                                                            _linkKey.currentState.validate();
                                                        },
                                                        validator: (link){
                                                            if(link == "" || link == null){
                                                                return "Link cannot be empty";
                                                            } else if(link.length >= 7) {
                                                                if(link.substring(0,7) != "http://" && link.substring(0,8) != "https://")
                                                                    return "Link must begin with http:// or https://";
                                                                else
                                                                    return null;
                                                            } else {
                                                                return null;
                                                            }
                                                        },
                                                    ),

                                                    Container(
                                                        width: ScreenUtil().setWidth(360),
                                                        height: ScreenUtil().setHeight(100),
                                                        child: Center(
                                                            child: GestureDetector(
                                                                onTap: (){
                                                                    _urlFunc(textCon[5].text);
                                                                },
                                                                child: Container(
                                                                    decoration: BoxDecoration(
                                                                        border: Border.all(color: Colors.blue),
                                                                        borderRadius: BorderRadius.circular(7),
                                                                    ),
                                                                    padding: EdgeInsets.fromLTRB(
                                                                            ScreenUtil().setWidth(30),
                                                                            ScreenUtil().setHeight(10),
                                                                            ScreenUtil().setWidth(30),
                                                                            ScreenUtil().setHeight(10)
                                                                    ),
                                                                    child: Text("Test link",
                                                                        style: TextStyle(
                                                                            fontSize: ScreenUtil().setSp(15),
                                                                            color: Colors.blue,
                                                                        ),
                                                                    ),

                                                                ),
                                                            ),
                                                        ),
                                                    ),

                                                    SizedBox(
                                                        height: ScreenUtil().setHeight(100),
                                                    ),

                                                    Container(
                                                        width: ScreenUtil().setWidth(360),
                                                        child: Center(
                                                            child: Text("Test the link once before proceeding",
                                                                style: TextStyle(
                                                                        fontSize: ScreenUtil().setSp(15),
                                                                        fontWeight: FontWeight.w500,
                                                                        color: Colors.black.withOpacity(0.75)
                                                                ),
                                                            ),
                                                        ),
                                                    ),

                                                ],
                                            ),
                                        ),
                                    ),

                                    Container(
                                        width: ScreenUtil().setWidth(360),
                                        height: ScreenUtil().setHeight(410),
                                        padding: EdgeInsets.fromLTRB(
                                                ScreenUtil().setWidth(15),
                                                ScreenUtil().setHeight(15),
                                                ScreenUtil().setWidth(15),
                                                ScreenUtil().setHeight(5)
                                        ),
                                        child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [

                                                Container(
                                                    height: ScreenUtil().setHeight(50),
                                                    child: Center(
                                                        child: Text("Select a color",
                                                            style: TextStyle(
                                                                    fontSize: ScreenUtil().setSp(20),
                                                                    fontWeight: FontWeight.w600
                                                            ),
                                                        ),
                                                    ),
                                                ),

                                                SizedBox(
                                                    width: ScreenUtil().setWidth(75),
                                                ),

                                                DropdownButton<String>(
                                                    value: dropDownColor??"orange",
                                                    icon: Icon(Icons.arrow_downward),
                                                    iconSize: 24,
                                                    elevation: 16,
                                                    underline: Container(
                                                        height: 0,
                                                        //color: Colors.blue,
                                                    ),
                                                    onChanged: (String newValue) {
                                                        setState(() {
                                                            editModel.color = newValue;
                                                            editModel.setColor();
                                                            dropDownColor = newValue;
                                                        });
                                                    },
                                                    items: dropDownItems,
                                                ),

                                            ],
                                        ),
                                    ),

                                    Container(
                                        width: ScreenUtil().setWidth(360),
                                        height: ScreenUtil().setHeight(410),
                                        padding: EdgeInsets.fromLTRB(
                                                ScreenUtil().setWidth(15),
                                                ScreenUtil().setHeight(15),
                                                ScreenUtil().setWidth(15),
                                                ScreenUtil().setHeight(15)
                                        ),
                                        child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [

                                                Text("Please take another look at the banner before proceeding",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                            fontSize: ScreenUtil().setSp(20),
                                                            fontWeight: FontWeight.w600
                                                    ),
                                                ),

                                            ],
                                        ),
                                    ),

                                ],
                            ),
                        ),
                      ),

                      Container(
                          height: 1,
                          color: Colors.grey.withOpacity(0.5),
                      ),

                      Container(
                          height: ScreenUtil().setHeight(55),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                  GestureDetector(
                                      onTap: (){
                                          if(pageCon.page == 0){
                                              showDialog(
                                                  context: context,
                                                  builder: (_) => AlertDialog(
                                                      title: Text("Are you sure you want to leave?"),
                                                      content: Text("Changes will not be saved."),
                                                      actions: [
                                                          FlatButton(
                                                              child: Text("No"),
                                                              onPressed: (){
                                                                  Navigator.pop(context);
                                                              },
                                                          ),
                                                          FlatButton(
                                                              child: Text("yes"),
                                                              onPressed: (){
                                                                  Navigator.pop(context);
                                                                  Navigator.pop(context, null);
                                                              },
                                                          )
                                                      ],
                                                  ),
                                                  barrierDismissible: false,
                                              );
                                          } else {
                                              pageCon.previousPage(duration: Duration(milliseconds: 100), curve: Curves.ease);
                                          }
                                      },
                                      child: Container(
                                          height: ScreenUtil().setHeight(55),
                                          width: ScreenUtil().setWidth(75),
                                          child: Center(
                                              child: Text(
                                                  "Back",
                                                  style: TextStyle(
                                                          fontSize: ScreenUtil().setSp(20),
                                                          color: Colors.blue,
                                                          fontWeight: FontWeight.w600
                                                  ),
                                              ),
                                          ),
                                      ),
                                  ),

                                  GestureDetector(
                                      onTap: (){
                                          if(pageCon.page == 7){

                                              bool b = true;
                                              for(int i=0;i<6;i++) {
                                                  if(textCon[i].text == "")
                                                      b = false;
                                              }

                                              if(textCon[5].text.length > 7) {
                                                  if(textCon[5].text.substring(0,7) != "http://" && textCon[5].text.substring(0,8) != "https://")
                                                      b = false;
                                              } else {
                                                  b = false;
                                              }

                                              if(b){
                                                  showDialog(
                                                      context: context,
                                                      builder: (_) => AlertDialog(
                                                          title: Text("Are you sure you want to add/edit this banner?"),
                                                          //content: Text("Changes will not be saved."),
                                                          actions: [
                                                              FlatButton(
                                                                  child: Text("No"),
                                                                  onPressed: (){
                                                                      Navigator.pop(context);
                                                                  },
                                                              ),
                                                              FlatButton(
                                                                  child: Text("yes"),
                                                                  onPressed: (){
                                                                      Navigator.pop(context);
                                                                      Navigator.pop(context, editModel);
                                                                  },
                                                              )
                                                          ],
                                                      ),
                                                      barrierDismissible: false,
                                                  );
                                              } else {
                                                  Fluttertoast.showToast(msg: "One or more fields have incorrect input.",
                                                      textColor: Colors.black,
                                                      fontSize: ScreenUtil().setSp(20),
                                                      toastLength: Toast.LENGTH_LONG,
                                                  );
                                              }

                                          } else {
                                              pageCon.nextPage(duration: Duration(milliseconds: 100), curve: Curves.ease);
                                          }
                                      },
                                      child: Container(
                                          height: ScreenUtil().setHeight(55),
                                          width: ScreenUtil().setWidth(75),
                                          child: Center(
                                              child: Text(
                                                  "Next",
                                                  style: TextStyle(
                                                          fontSize: ScreenUtil().setSp(20),
                                                          color: Colors.blue,
                                                          fontWeight: FontWeight.w600
                                                  ),
                                              ),
                                          ),
                                      ),
                                  ),
                              ],
                          ),
                      ),

                  ],
              ),
            ),
          ),
      ),
    );
  }

  setClip(int i) async {
     ClipboardData data = await Clipboard.getData('text/plain');
     textCon[i].text = data.text;
     setState(() {
         editModel.title = textCon[0].text;
         editModel.description = textCon[1].text;
         editModel.comments = textCon[2].text;
         editModel.date = textCon[3].text;
         editModel.city = textCon[4].text;
         editModel.link = textCon[5].text;
         if (i == 5) {
           _linkKey.currentState.validate();
         }
     });
     //return data;
  }

  _urlFunc(String url) async{

      if(url.length >= 7) {

          if((url != null || url != "") && (url.substring(0,7) == "http://" || url.substring(0,8) == "https://")){
              await launch(url);
          } else {
              Fluttertoast.showToast(msg: "Could not perform action",
                  textColor: Colors.black,
                  fontSize: ScreenUtil().setSp(20),
                  toastLength: Toast.LENGTH_LONG,
              );
          }

      }

  }

}
