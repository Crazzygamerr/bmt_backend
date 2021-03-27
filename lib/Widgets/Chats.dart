import 'dart:io';

import 'package:bmt_backend/Screens/ChatScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';

class Chats extends StatefulWidget {
  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> with AutomaticKeepAliveClientMixin {

    Stream<QuerySnapshot> chats;
    List<String> email = List();
    bool conn = true;
    AsyncSnapshot snappyTemp;
    bool first = true;

    @override
    void initState() {
        getMessages().then((value){
            setState(() {
                chats = value;
            });
        });
        Connectivity().onConnectivityChanged.listen((event) {
            getInternet();
        });
        super.initState();
    }

    getInternet() async {
        try {
            final result = await InternetAddress.lookup('google.com');
            if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                setState(() {
                    conn = true;
                });
            }
        } on SocketException catch (_) {
            setState(() {
                conn = false;
            });
        }
    }

    getMessages() async {
        List<String> temp = List();
        FirebaseFirestore.instance.collection("chat-server")
                .orderBy("unread",descending: true).get().then((snapshot){
                    var x = snapshot.docs;
                    for(int i=0;i<x.length;i++)
                        temp.add(x[i].id.toString());
                    if(!(temp == email))
                        email = temp;
        });
        return FirebaseFirestore.instance.collection("chat-server").orderBy("unread",descending: true).snapshots();
    }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    ScreenUtil.init(context, width: 360, height: 640, allowFontScaling: true);

    return StreamBuilder<QuerySnapshot>(
            stream: chats,
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {

                if(first){
                    snappyTemp = snapshot;
                    first = false;
                }

                if(snappyTemp != snapshot){
                    List<String> temp = List();
                    FirebaseFirestore.instance.collection("chat-server")
                            .orderBy("unread",descending: true).get().then((snapshot){
                        var x = snapshot.docs;
                        for(int i=0;i<x.length;i++)
                            temp.add(x[i].id.toString());
                        email = temp;
                    });
                }

                if(!conn){
                    return Container(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                                Padding(
                                    padding: EdgeInsets.fromLTRB(
                                            ScreenUtil().setWidth(8),
                                            ScreenUtil().setHeight(8),
                                            ScreenUtil().setWidth(8),
                                            ScreenUtil().setHeight(8)
                                    ),
                                    child: Icon(
                                        Icons.signal_wifi_off,
                                        color: Colors.grey,
                                        size: ScreenUtil().setWidth(35),
                                    ),
                                ),

                                Text("No internet!"),

                            ],
                        ),
                    );
                } else if(!snapshot.hasData || snapshot.hasError || snapshot.connectionState == ConnectionState.waiting){
                    return Center(
                        child: Container(
                                width: ScreenUtil().setWidth(20),
                                height: ScreenUtil().setHeight(20),
                                child: CircularProgressIndicator()
                        ),
                    );
                } else {
                    return Container(
                        child: ListView.builder(
                                itemCount: snapshot.data.docs.length,
                                itemBuilder: (context, pos){
                                    //var name =  snapshot.data.documents[pos]["Name"];
                                    //var email = snapshot.data.documents[pos].documentID;
                                    /*Stream snappy = FirebaseFirestore.instance.collection("chat-server")
                                            .document(email).collection("messages").orderBy("time").snapshots();*/
                                    return RaisedButton(
                                      color: Colors.white,
                                      elevation: 0,
                                      onPressed: (){
                                        Navigator.push(context,
                                                new MaterialPageRoute(builder: (context) => ChatScreen(
                                                    email[pos],
                                                ),
                                            ),
                                        );

                                      },
                                      child: Column(
                                          children: [

                                              Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                          ScreenUtil().setWidth(15),
                                                          ScreenUtil().setHeight(15),
                                                          ScreenUtil().setWidth(12),
                                                          ScreenUtil().setHeight(15)
                                                  ),
                                                  child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [

                                                          Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [

                                                                  Text(
                                                                      snapshot.data.docs[pos].data()["Name"],
                                                                      style: TextStyle(
                                                                          fontSize: ScreenUtil().setSp(17),
                                                                          fontWeight: FontWeight.w600
                                                                      ),
                                                                  ),

                                                                  Text(
                                                                      snapshot.data.docs[pos].id.toString(),
                                                                      style: TextStyle(fontSize: ScreenUtil().setSp(12),
                                                                              fontWeight: FontWeight.w300
                                                                      ),
                                                                  )

                                                              ],
                                                          ),

                                                          Opacity(
                                                              opacity: (snapshot.data.docs[pos].data()['unread']) ? 1 : 0,
                                                              child: Icon(
                                                                  Icons.brightness_1,
                                                                  color: Colors.green,
                                                              ),
                                                          ),

                                                      ],
                                                  ),
                                              ),

                                              Container(
                                                  color: Colors.grey.withOpacity(0.4),
                                                  width: ScreenUtil().setHeight(330),
                                                  height: 1,
                                              ),

                                          ],
                                      ),
                                    );
                                }
                        ),
                    );
                }
            }
    );
  }

  @override
  bool get wantKeepAlive => true;
}
