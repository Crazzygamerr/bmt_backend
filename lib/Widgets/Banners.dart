import 'package:bmt_backend/Screens/Edit_Banner.dart';
import 'package:bmt_backend/Utility/Banner_Model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';
import 'Banner_Widget.dart';
import 'package:connectivity/connectivity.dart';

class Banners extends StatefulWidget {
  @override
  _BannersState createState() => _BannersState();
}

class _BannersState extends State<Banners> with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  Stream<QuerySnapshot> banners;
  bool conn = true;
  //bool updating = false;
  CollectionReference collectionReference = FirebaseFirestore.instance.collection("Banners");

  @override
  void initState() {
    banners = getB();
    Connectivity().onConnectivityChanged.listen((event) {
      getInternet();
    });
    super.initState();
    /*pHp dbConn = new pHp();
    dbConn.getBanners();*/
  }

  getB() {
    return collectionReference.orderBy("id").snapshots();
  }

  getInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          //banners = getB();
          conn = true;
        });
      }
    } on SocketException catch (_) {
      setState(() {
        conn = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    ScreenUtil.init(context, width: 360, height: 640, allowFontScaling: true);

    return Container(
            child: StreamBuilder<QuerySnapshot>(
              stream: banners,
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {

                pushEditor(BannerModel model, bool add) async {
                  final BannerModel result = await Navigator.push(
                          context,
                          new MaterialPageRoute(
                                  builder: (context) => EditBanner(
                                          model,
                                          add
                                  )
                          )
                  );
                  if(result != null){
                    if(add){
                      Fluttertoast.showToast(msg: "Adding banner",
                        textColor: Colors.black,
                        fontSize: ScreenUtil().setSp(20),
                        toastLength: Toast.LENGTH_LONG,
                      );
                      DocumentReference ref = await collectionReference.add(result.mapFromModel()).catchError((e){
                        Fluttertoast.showToast(msg: "Could not add banner,"
                                "$e",
                          textColor: Colors.black,
                          fontSize: ScreenUtil().setSp(20),
                          toastLength: Toast.LENGTH_LONG,
                        );
                      });
                      ref.update({"documentId": ref.id});
                    } else {
                      collectionReference.where('id', isEqualTo: result.id).limit(1).get().then((snapshot) {
                        collectionReference.doc(snapshot.docs[0].id).update(result.mapFromModel());
                      });
                    }
                  }
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
                } else if(snapshot.data == null || snapshot.hasError || snapshot.connectionState == ConnectionState.waiting) {
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
                          child: CircularProgressIndicator(),
                        ),

                        Text("Loading banners"),

                      ],
                    ),
                  );
                } else {

                  List bannerModels = new List();

                  for(int i=0;i<snapshot.data.docs.length;i++)
                    bannerModels.add(BannerModel.fromFirestore(snapshot.data.docs[i]));

                  return Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        GestureDetector(
                          onTap: (){
                            pushEditor(
                              new BannerModel(
                                      "",
                                      snapshot.data.docs.length,
                                      "title",
                                      "description",
                                      "comments",
                                      "date",
                                      "city",
                                      "",
                                      "orange"
                              ),
                              true
                            );
                          },
                          child: Container(
                            height: ScreenUtil().setHeight(50),
                            width: ScreenUtil().setWidth(360),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [

                                SizedBox(
                                  width: ScreenUtil().setWidth(10),
                                ),

                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, ScreenUtil().setWidth(12), 0),
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.blue,
                                    size: ScreenUtil().setHeight(25),
                                  ),
                                ),

                                Text("Add new banner",
                                  style: TextStyle(
                                    fontSize: ScreenUtil().setSp(20),
                                    color: Colors.blue,
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ),

                        Container(
                          height: ScreenUtil().setHeight(480),
                          width: ScreenUtil().setWidth(360),
                          child: ListView.builder(
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (context, pos){

                              return Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: (){
                                      pushEditor(bannerModels[pos],false);
                                    },
                                    child: Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                    ScreenUtil().setWidth(6),
                                                    ScreenUtil().setHeight(0),
                                                    ScreenUtil().setWidth(0),
                                                    ScreenUtil().setHeight(10)
                                            ),
                                      child: BannerWidget(bannerModels[pos])
                                    ),
                                  ),

                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [

                                      DropdownButton<int>(
                                        value: pos,
                                        icon: Icon(Icons.arrow_downward),
                                        iconSize: 24,
                                        elevation: 16,
                                        onChanged: (int newValue) {
                                          if(newValue != pos){
                                            var temp = bannerModels[pos];
                                            bannerModels.removeAt(pos);
                                            bannerModels.insert(newValue, temp);
                                            collectionReference.get().then((value) {
                                              for(int i=0;i<bannerModels.length;i++)
                                                collectionReference.doc(bannerModels[i].documentId).update({"id": i});
                                            });
                                          }
                                        },
                                        items: List.generate(
                                          bannerModels.length,
                                          (index){
                                            return DropdownMenuItem(
                                              value: index,
                                              child: Text("$index"),
                                            );
                                          }
                                        ),
                                      ),

                                      SizedBox(
                                        height: ScreenUtil().setHeight(8),
                                      ),

                                      GestureDetector(
                                        onTap: () async {
                                          //updating = true;
                                          /*setState(() {
                                            bannerModels.removeAt(pos);
                                          });*/
                                          //banners.

                                          Future.delayed(Duration(seconds: 1)).then((value) {
                                            collectionReference.where("id", isEqualTo: pos).limit(1).get().then((value) {
                                              collectionReference.get().then((value) {
                                                value.docs.forEach((doc) {
                                                  setState(() {
                                                    if(doc.data()['id'] > pos){
                                                      collectionReference.doc(doc.id).update({"id": FieldValue.increment(-1)});
                                                    }
                                                  });
                                                  //updating = false;
                                                });
                                              });
                                              collectionReference.doc(value.docs[0].id).delete();
                                            });
                                          });
                                          //Future.delayed(Duration(seconds: 1)).then((value) {banners = getB();});
                                        },
                                        child: Container(
                                          width: ScreenUtil().setWidth(40),
                                          child: Icon(
                                            Icons.close,
                                            color: Colors.red,
                                            size: 30,
                                          ),
                                        ),
                                      ),

                                    ],
                                  ),

                                ],
                              );
                            }
                          ),
                        ),
                      ],
                    ),
                  );
                }
              }
            ),
          );
  }

}
