import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart' as test;
import 'package:keyboard_avoider/keyboard_avoider.dart';

class ChatScreen extends StatefulWidget {

  /*final String title;
  final String email;*/
  //final Stream test;
    final String email;

  @override
  _ChatScreenState createState() => _ChatScreenState();

  ChatScreen(this.email
          //this.title,
            // this.email,
             //this.test
             );

}

class _ChatScreenState extends State<ChatScreen> with AutomaticKeepAliveClientMixin {

  TextEditingController textCon = new TextEditingController();
  ScrollController msgCon = new ScrollController();
  Stream<QuerySnapshot> messages;
  bool conn = true;

  @override
  void initState() {
      getMessages().then((value){
          setState(() {
              messages = value;
          });
      });
      Connectivity().onConnectivityChanged.listen((event) {
          getInternet();
      });
      super.initState();
  }

  getMessages() async {
      return FirebaseFirestore.instance.collection("chat-server")
              .doc(widget.email).collection("messages").orderBy("time", descending: true).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    ScreenUtil.init(context, width: 360, height: 640, allowFontScaling: true);

    FirebaseFirestore.instance.collection("chat-server")
            .doc(widget.email)
            .update({"unread": false, "lastUserText": DateTime.now()});

    return WillPopScope(
      onWillPop: () async {
          Navigator.pop(context);
          return false;
      },
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
              leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: (){
                      Navigator.pop(context);
                  },
              ),
              title: Text(widget.email),
          ),
          body: KeyboardAvoider(
              child: Container(
                  padding: EdgeInsets.fromLTRB(
                          ScreenUtil().setWidth(16),
                          ScreenUtil().setHeight(16),
                          ScreenUtil().setWidth(16),
                          ScreenUtil().setHeight(16)
                  ),
                  width: ScreenUtil().setWidth(360),
                  height: ScreenUtil().setHeight(575),
                  child: Column(
                      //crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                              Container(
                                  padding: EdgeInsets.fromLTRB(
                                          ScreenUtil().setWidth(0),
                                          ScreenUtil().setHeight(16),
                                          ScreenUtil().setWidth(16),
                                          ScreenUtil().setHeight(6)
                                  ),
                                  width: ScreenUtil().setWidth(360),
                                  child: Text("CHAT",
                                      style: TextStyle(fontSize: ScreenUtil()
                                              .setSp(16), fontWeight: FontWeight
                                              .w700),
                                      textAlign: TextAlign.start,
                                  ),
                              ),

                              StreamBuilder<QuerySnapshot>(
                                      stream: messages,
                                      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {

                                          if(!snapshot.hasData || snapshot.hasError || snapshot.connectionState == ConnectionState.waiting){
                                              return Expanded(
                                                      child: Center(
                                                          child: Container(
                                                                  width: ScreenUtil().setWidth(20),
                                                                  height: ScreenUtil().setHeight(20),
                                                                  child: CircularProgressIndicator()
                                                          ),
                                                      )
                                              );
                                          } else {
                                              return Expanded(
                                                  child: Container(
                                                      width: ScreenUtil().setWidth(360),
                                                      height: ScreenUtil().setHeight(330),
                                                      child: ListView.builder(
                                                              controller: msgCon,
                                                              padding: EdgeInsets.all(0),
                                                              physics: BouncingScrollPhysics(),
                                                              reverse: true,
                                                              scrollDirection: Axis.vertical,
                                                              itemCount: snapshot.data.documents.length,
                                                              itemBuilder: (context, pos) {
                                                                  
                                                                  var d = DateTime.fromMillisecondsSinceEpoch(snapshot.data.docs[pos].data()['time'].seconds * 1000);
                                                                  var date = DateFormat.yMd().add_jm().format(d);
                                                                  return Padding(
                                                                      padding: EdgeInsets.fromLTRB(
                                                                              ScreenUtil().setWidth(1),
                                                                              ScreenUtil().setHeight(2),
                                                                              ScreenUtil().setWidth(1),
                                                                              ScreenUtil().setHeight(2)
                                                                      ),
                                                                      child: Container(
                                                                          child: Row(
                                                                              mainAxisAlignment: (snapshot.data.docs[pos].data()['sender'] == "bmt") ?
                                                                                MainAxisAlignment.start:MainAxisAlignment.end,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: <Widget>[
                                                                                  (snapshot.data.docs[pos].data()['sender'] == "bmt") ?
                                                                                  Padding(
                                                                                      padding: EdgeInsets.fromLTRB(
                                                                                              ScreenUtil().setWidth(1),
                                                                                              ScreenUtil().setHeight(5),
                                                                                              ScreenUtil().setWidth(10),
                                                                                              ScreenUtil().setHeight(1)
                                                                                      ),
                                                                                      child: CircleAvatar(
                                                                                          child: Image
                                                                                                  .asset("Assets/ChatLogo/drawable-xhdpi/ChatLogo.png",
                                                                                              width: ScreenUtil().setWidth(21),
                                                                                              height: ScreenUtil().setHeight(13),
                                                                                          ),
                                                                                          radius: ScreenUtil().setWidth(20),
                                                                                          backgroundColor: Colors.black,
                                                                                      ),
                                                                                  ) :
                                                                                  SizedBox(
                                                                                      width: ScreenUtil()
                                                                                              .setWidth(10),
                                                                                  ),

                                                                                  Container(
                                                                                    child: Column(
                                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                                        crossAxisAlignment: (snapshot.data.docs[pos].data()['sender'] == "bmt") ?
                                                                                              CrossAxisAlignment.start : CrossAxisAlignment.end,
                                                                                        children: <Widget>[
                                                                                            (snapshot.data.docs[pos].data()['sender'] == "bmt") ? 
                                                                                            Padding(
                                                                                              padding: EdgeInsets.fromLTRB(0, ScreenUtil().setHeight(4), 0, 0),
                                                                                              child: Text("You, $date",
                                                                                                  textAlign: TextAlign.end,
                                                                                                  style: TextStyle(fontSize: ScreenUtil().setSp(11),
                                                                                                          color: Colors.black.withOpacity(0.5)
                                                                                                  ),
                                                                                              ),
                                                                                            ) :
                                                                                            Padding(
                                                                                              padding: EdgeInsets.fromLTRB(0, ScreenUtil().setHeight(4), 0, 0),
                                                                                              child: Text("Bookmytrainings bot, $date",
                                                                                                  style: TextStyle(fontSize: ScreenUtil().setSp(11),
                                                                                                          color: Colors.black.withOpacity(0.5)
                                                                                                  ),
                                                                                              ),
                                                                                            ),

                                                                                            Container(
                                                                                                width: ScreenUtil().setWidth(230),
                                                                                                child: Text(snapshot.data.docs[pos].data()['content'],
                                                                                                    textAlign: (snapshot.data.docs[pos].data()['sender'] == "bmt") ?
                                                                                                    TextAlign.start : TextAlign.end,
                                                                                                    style: TextStyle(fontSize: ScreenUtil().setSp(12)),
                                                                                                ),
                                                                                            ),



                                                                                        ],
                                                                                    ),
                                                                                  ),

                                                                                  (snapshot.data.docs[pos].data()['sender'] != "bmt") ?
                                                                                  Padding(
                                                                                      padding: EdgeInsets.fromLTRB(
                                                                                              ScreenUtil().setWidth(10),
                                                                                              ScreenUtil().setHeight(5),
                                                                                              ScreenUtil().setWidth(1),
                                                                                              ScreenUtil().setHeight(1)
                                                                                      ),
                                                                                      child: Container(
                                                                                          decoration: BoxDecoration(color: Colors.lightBlueAccent,
                                                                                              shape: BoxShape.circle,
                                                                                          ),
                                                                                          padding: EdgeInsets.fromLTRB(
                                                                                                  ScreenUtil().setWidth(2),
                                                                                                  ScreenUtil().setHeight(2),
                                                                                                  ScreenUtil().setWidth(2),
                                                                                                  ScreenUtil().setHeight(2)
                                                                                          ),
                                                                                          child: CircleAvatar(
                                                                                              backgroundColor: Colors.white,
                                                                                              backgroundImage:AssetImage("Assets/User.png"),
                                                                                              radius: ScreenUtil().setWidth(20),
                                                                                          ),
                                                                                      ),
                                                                                  ) :
                                                                                  SizedBox(
                                                                                      width: ScreenUtil().setWidth(10),
                                                                                  ),

                                                                              ],
                                                                          ),
                                                                      ),
                                                                  );
                                                              }
                                                      ),
                                                  ),
                                              );
                                          }
                                      }
                              ),

                              SizedBox(
                                  height: ScreenUtil().setHeight(10),
                              ),

                              TextFormField(
                                  keyboardType: TextInputType.multiline,
                                  minLines: 1,
                                  maxLines: 6,
                                  controller: textCon,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black
                                                  .withOpacity(0.2)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black
                                                  .withOpacity(0.2)),
                                      ),
                                      contentPadding: EdgeInsets.only(
                                              top: 2.0,
                                              left: 13.0,
                                              right: 13.0,
                                              bottom: 2.0),
                                      hintText: "Type a message",
                                      hintStyle: TextStyle(
                                          color: Colors.grey,
                                      ),
                                      suffixIcon: IconButton(
                                          icon: Icon(
                                              Icons.send,
                                              color: Colors.black,
                                              size: 23,),
                                          onPressed: () {

                                              if(textCon.text != "" || textCon.text != null) {
                                                  FirebaseFirestore.instance.collection("chat-server")
                                                          .doc(widget.email).collection("messages")
                                                          .add({"time": DateTime.now(), "sender": "bmt", "content": textCon.text});
                                                  textCon.clear();
                                              }
                                          },
                                      ),
                                  ),
                              ),

                          ]
                  ),
              ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  getInternet() async {
      try {
          final result = await InternetAddress.lookup('google.com');
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {

          }
      } on SocketException catch (_) {
          Navigator.pop(context);
      }
  }

}
