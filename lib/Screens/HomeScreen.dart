import 'dart:io';

import 'package:bmt_backend/Utility/SignIn.dart';
import 'package:bmt_backend/Widgets/Banners.dart';
import 'package:bmt_backend/Widgets/Chats.dart';
import 'package:bmt_backend/Widgets/Search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomeScreen extends StatefulWidget {

    @override
    _HomeScreenState createState() => _HomeScreenState();

}

class _HomeScreenState extends State<HomeScreen> {

    @override
  void initState() {
    super.initState();
    SignIn auth = new SignIn();
    auth.userAuth();
  }

    @override
    Widget build(BuildContext context) {
        SystemChrome.setEnabledSystemUIOverlays([]);
        SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
        ]);

        ScreenUtil.init(context, width: 360, height: 640, allowFontScaling: true);

        return DefaultTabController(
          length: 2,
          child: SafeArea(
            child: Scaffold(
                    resizeToAvoidBottomInset: false,
                    appBar: AppBar(
                        toolbarHeight: ScreenUtil().setHeight(100),
                        elevation: 0,
                        title: Text("BMT backend",
                            style: TextStyle(
                                fontSize: ScreenUtil().setSp(20)
                            ),
                        ),
                        actions: [

                            IconButton(
                                icon: Icon(Icons.search),
                                onPressed: (){
                                    getInternet();
                                },
                            ),

                        ],
                        bottom: TabBar(
                            tabs: [

                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[

                                    Text("Chats",
                                        style: TextStyle(
                                            fontSize: ScreenUtil().setSp(20)
                                        ),
                                    ),

                                    SizedBox(
                                        height: ScreenUtil().setHeight(10),
                                    ),

                                  ],
                                ),

                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[

                                    Text("Banners",
                                        style: TextStyle(
                                                fontSize: ScreenUtil().setSp(20)
                                        ),
                                    ),

                                      SizedBox(
                                          height: ScreenUtil().setHeight(10),
                                      ),

                                  ],
                                )
                            ],
                        ),
                    ),

                    body: TabBarView(
                        children: [

                            Chats(),

                            Banners(),

                        ],
                    ),
            ),
          ),
        );
    }

    getInternet() async {
        try {
            final result = await InternetAddress.lookup('google.com');
            if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                showSearch(context: context, delegate: Search());
            }
        } on SocketException catch (_) {
            Fluttertoast.showToast(msg: "You are not connected to the internet!",
                textColor: Colors.black,
                fontSize: ScreenUtil().setSp(20),
                toastLength: Toast.LENGTH_LONG,
            );
        }
    }

}