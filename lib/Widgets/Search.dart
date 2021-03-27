import 'dart:io';

import 'package:bmt_backend/Screens/ChatScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';

class Search extends SearchDelegate<String>{

    List<String> email = List();
    AsyncSnapshot snappyTemp;
    bool first = true;
    bool conn = true;
    static StateSetter setResult,setSuggestions;
    //static bool buildRes = false;

    /*static void testM(){
        Connectivity().onConnectivityChanged.listen((event) {
            bool b;
            if(buildRes)
                b = true;
            else
                b = false;
            getInternet(b);
        });
    }*/

    Future getInternet() async {
        try {
            final result = await InternetAddress.lookup('google.com');
            if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                conn = true;
            }
        } on SocketException catch (_) {
            conn = false;
        }

    }

    @override
    String get searchFieldLabel => "Search Chats";

    @override
    List<Widget> buildActions(BuildContext context) {
        return [
            IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                    query = '';
                },
            )
        ];
    }

    @override
    Widget buildLeading(BuildContext context) {
        return IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: (){
                close(context, "");
            },
        );
    }

    @override
    Widget buildResults(BuildContext context) {

        //getInternet(true);
        //buildRes = true;

        return StatefulBuilder(
          builder: (context, setResult) {
            return StreamBuilder(
                    stream: FirebaseFirestore.instance.collection("chat-server")
                            .where('searchArray', arrayContains: query.toLowerCase())
                            .orderBy("lastUserText", descending: true)
                            .snapshots(),
                    builder: (context, snapshot) {
                        /*if(snapshot.hasData){
                        List<String> temp = List();
                        for(int i=0;i<snapshot.data.documents.length ;i++){
                            String s = snapshot.data.documents[i].documentID;
                            temp.add(s);
                        }
                        if(!(temp == email))
                            email = temp;
                    }*/

                        if(first){
                            snappyTemp = snapshot;
                            first = false;
                        }

                        if(snappyTemp != snapshot){
                            List<String> temp = List();
                            FirebaseFirestore.instance.collection("chat-server")
                                    .where('searchArray', arrayContains: query.toLowerCase())
                                    .orderBy("lastUserText", descending: true)
                                    .get().then((snapshot){
                                var x = snapshot.docs;
                                for(int i=0;i<x.length;i++)
                                    temp.add(x[i].id.toString());
                                email = temp;
                            });
                        }


                        /*if(!conn){
                            return Container(
                                width: ScreenUtil().setWidth(360),
                                //color: Colors.blue,
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [

                                        Icon(
                                            Icons.signal_wifi_off,
                                            color: Colors.grey,
                                            size: ScreenUtil().setWidth(35),
                                        ),

                                        Text("No internet!"),

                                    ],
                                ),
                            );
                        } else */if(!snapshot.hasData || snapshot.hasError || snapshot.connectionState == ConnectionState.waiting){
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
                                        itemCount: snapshot.data.documents.length,
                                        itemBuilder: (context, pos){
                                            //var name =  snapshot.data.documents[pos]["Name"];
                                            //var email = snapshot.data.documents[pos].documentID;
                                            /*Stream snappy = Firestore.instance.collection("chat-server")
                                                .document(email).collection("messages").orderBy("time").snapshots();*/
                                            return RaisedButton(
                                                color: Colors.white,
                                                elevation: 0,
                                                onPressed: (){
                                                    getInternet().then((value) {
                                                        if(conn)
                                                            Navigator.push(context,
                                                                    new MaterialPageRoute(builder: (context) => ChatScreen(
                                                                        //name,
                                                                        email[pos],
                                                                        //snappy
                                                                    )
                                                                    )
                                                            );
                                                        else
                                                            close(context, "");
                                                    });
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
                                                                                snapshot.data.documents[pos]["Name"],
                                                                                style: TextStyle(
                                                                                        fontSize: ScreenUtil().setSp(17),
                                                                                        fontWeight: FontWeight.w600
                                                                                ),
                                                                            ),

                                                                            Text(
                                                                                snapshot.data.documents[pos].documentID,
                                                                                style: TextStyle(fontSize: ScreenUtil().setSp(12),
                                                                                        fontWeight: FontWeight.w300
                                                                                ),
                                                                            )

                                                                        ],
                                                                    ),

                                                                    Opacity(
                                                                        opacity: (snapshot.data.documents[pos]['unread']) ? 1 : 0,
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
        );
    }

    @override
    Widget buildSuggestions(BuildContext context) {

        /*getInternet(false);
        buildRes = false;*/

        return StatefulBuilder(
          builder: (context, setSuggestions) {
            return StreamBuilder(
                    stream: FirebaseFirestore.instance.collection("chat-server").where('searchArray', arrayContains: query.toLowerCase())
                            .orderBy("lastUserText", descending: true).snapshots(),
                    builder: (context, snapshot) {
                        /*if(snapshot.hasData){
                        List<String> temp = List();
                        for(int i=0;i<snapshot.data.documents.length ;i++){
                            String s = snapshot.data.documents[i].documentID;
                            temp.add(s);
                        }
                        if(!(temp == email))
                            email = temp;
                    }*/

                        if(first){
                            snappyTemp = snapshot;
                            first = false;
                        }

                        if(snappyTemp != snapshot){
                            List<String> temp = List();
                            Firestore.instance.collection("chat-server")
                                    .where('searchArray', arrayContains: query.toLowerCase())
                                    .orderBy("lastUserText", descending: true)
                                    .get().then((snapshot){
                                var x = snapshot.docs;
                                for(int i=0;i<x.length;i++)
                                    temp.add(x[i].id.toString());
                                email = temp;
                            });
                        }


                        /*if(!conn){
                            return Container(
                                width: ScreenUtil().setWidth(360),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [

                                        SizedBox(
                                            height: ScreenUtil().setHeight(250),
                                        ),

                                        Icon(
                                            Icons.signal_wifi_off,
                                            color: Colors.grey,
                                            size: ScreenUtil().setWidth(35),
                                        ),

                                        Text("No internet!"),

                                    ],
                                ),
                            );
                        } else*/ if(!snapshot.hasData || snapshot.hasError || snapshot.connectionState == ConnectionState.waiting){
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
                                        itemCount: snapshot.data.documents.length,
                                        itemBuilder: (context, pos){
                                            //var name =  snapshot.data.documents[pos]["Name"];
                                            //var email = snapshot.data.documents[pos].documentID;
                                            /*Stream snappy = Firestore.instance.collection("chat-server")
                                                .document(email).collection("messages").orderBy("time").snapshots();*/
                                            return RaisedButton(
                                                color: Colors.white,
                                                elevation: 0,
                                                onPressed: (){
                                                    getInternet().then((value) {
                                                        if(conn)
                                                            Navigator.push(context,
                                                                    new MaterialPageRoute(builder: (context) => ChatScreen(
                                                                        //name,
                                                                        email[pos],
                                                                        //snappy
                                                                    )
                                                                    )
                                                            );
                                                        else
                                                            close(context, "");
                                                    });

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
                                                                                snapshot.data.documents[pos]["Name"],
                                                                                style: TextStyle(
                                                                                        fontSize: ScreenUtil().setSp(17),
                                                                                        fontWeight: FontWeight.w600
                                                                                ),
                                                                            ),

                                                                            Text(
                                                                                snapshot.data.documents[pos].documentID,
                                                                                style: TextStyle(fontSize: ScreenUtil().setSp(12),
                                                                                        fontWeight: FontWeight.w300
                                                                                ),
                                                                            )

                                                                        ],
                                                                    ),

                                                                    Opacity(
                                                                        opacity: (snapshot.data.documents[pos]['unread']) ? 1 : 0,
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
        );
    }

}