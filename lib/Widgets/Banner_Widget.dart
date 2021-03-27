import 'package:bmt_backend/Utility/Banner_Model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';

class BannerWidget extends StatefulWidget {
    
  final BannerModel model;  
    
  @override
  _BannerWidgetState createState() => _BannerWidgetState();
  
  BannerWidget(this.model);
  
}

class _BannerWidgetState extends State<BannerWidget> {
    
  @override
  Widget build(BuildContext context) {
      
    BannerModel model = widget.model;
    ScreenUtil.init(context, width: 360, height: 640, allowFontScaling: true);
      
    return Stack(
        children: [

            Container(
                decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment
                        .topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                            model.color1,
                            model.color2
                        ]),
                    borderRadius: BorderRadius.circular(7),
                ),
                width: ScreenUtil().setWidth(312),
                height: ScreenUtil().setHeight(96),
                child: Padding(
                    padding: EdgeInsets.fromLTRB(
                            ScreenUtil().setWidth(8),
                            ScreenUtil().setHeight(2),
                            ScreenUtil().setWidth(8),
                            ScreenUtil().setHeight(10)
                    ),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[

                            /*Text(model.title,
                                        style: TextStyle(color: Colors.white,
                                          fontSize: ScreenUtil().setSp(16),
                                          fontWeight: FontWeight.w600
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),*/
                            Container(
                                child: RichText(
                                    overflow: TextOverflow.fade,
                                    maxLines: 2,
                                    text: TextSpan(
                                            style: TextStyle(color: Colors.white,
                                                    fontSize: ScreenUtil().setSp(16),
                                                    fontWeight: FontWeight.w600
                                            ),
                                            text: model.title
                                    ),
                                    softWrap: false,
                                ),
                                width: ScreenUtil().setWidth(300),
                                height: ScreenUtil().setHeight(22),
                            ),

                            /*Text(model.description,
                                        style: TextStyle(color: Colors.white,
                                          fontSize: ScreenUtil().setSp(12),
                                          fontWeight: FontWeight.w500
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),*/

                            Container(
                                child: RichText(
                                    overflow: TextOverflow.fade,
                                    maxLines: 2,
                                    text: TextSpan(
                                            style: TextStyle(color: Colors.white,
                                                    fontSize: ScreenUtil().setSp(12),
                                                    fontWeight: FontWeight.w500
                                            ),
                                            text: model.description
                                    ),
                                    softWrap: false,
                                ),
                                width: ScreenUtil().setWidth(300),
                                height: ScreenUtil().setHeight(17),
                            ),

                            Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[

                                    Container(
                                        child: RichText(
                                            overflow: TextOverflow.fade,
                                            maxLines: 2,
                                            text: TextSpan(
                                                    style: TextStyle(color: Colors.white,
                                                        fontSize: ScreenUtil().setSp(10),
                                                    ),
                                                    text: model.comments
                                            ),
                                            softWrap: false,
                                        ),
                                        width: ScreenUtil().setWidth(95),
                                        height: ScreenUtil().setHeight(24),
                                    ),

                                    SizedBox(
                                        width: ScreenUtil().setWidth(13),
                                    ),

                                    /*Container(
                                            child: Text(model.date + ' \(' +
                                                    model.city + '\)',
                                              style: TextStyle(color: Colors.white,
                                                fontSize: ScreenUtil().setSp(10),
                                              ),
                                              //overflow: TextOverflow.ellipsis,
                                            ),
                                            width: ScreenUtil().setWidth(188),
                                          ),*/

                                    Container(
                                        child: RichText(
                                            overflow: TextOverflow.fade,
                                            maxLines: 2,
                                            text: TextSpan(
                                                style: TextStyle(color: Colors.white,
                                                    fontSize: ScreenUtil().setSp(10),
                                                ),
                                                text: model.date + ' \(' +
                                                        model.city + '\)',
                                            ),
                                            softWrap: false,
                                        ),
                                        width: ScreenUtil().setWidth(188),
                                        height: ScreenUtil().setHeight(24),
                                    ),

                                ],
                            )
                        ],
                    ),
                ),
            ),

            Positioned(
                child: Container(
                    decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(7),
                                    topLeft: Radius.circular(7)
                            ),
                            color: Colors.grey.withOpacity(0.9)
                    ),
                    padding: EdgeInsets.fromLTRB(
                            ScreenUtil().setWidth(4),
                            ScreenUtil().setHeight(2),
                            ScreenUtil().setWidth(3),
                            ScreenUtil().setHeight(1)
                    ),
                    child: Text("Know more",
                        style: TextStyle(
                                fontSize: ScreenUtil().setSp(11),
                                color: Colors.white
                        ),
                    ),
                ),
                bottom: 0,
                right: 0,
            ),

        ],
    );
  }
}
