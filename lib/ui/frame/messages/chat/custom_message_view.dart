import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:wy/image_utils.dart';

class CustomMessageView extends StatelessWidget {
  var type;
  var data;
  double iconHeight;
  double width;

  CustomMessageView({
    required this.type,
    required this.data,
    required this.iconHeight,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case "TopUp_Credit":
        return _topUpCreditWidget();
      case "play_order":
        return _orderWidget();
      default:
        return Text(
          "Unsupported message type, please update your app!",
          style: TextStyle(fontSize: 12, color: Colors.white24),
        );
    }
  }

  Widget _topUpCreditWidget() => Container(
        padding: EdgeInsets.all(10.r),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(15.r),
            bottomRight: Radius.circular(15.r),
            bottomLeft: Radius.circular(15.r),
          ),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0099FF),
              Color(0xFFB011FF),
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              right: 0.w,
              bottom: 0.h,
              child: Image.asset(
                ImageUtils.iconZhuansghi,
                width: 38.w,
                height: 38.w,
                color: Color(0x69ffffff),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      ImageUtils.icon_chenggong,
                      width: 16.w,
                      height: 16.w,
                    ),
                    6.horizontalSpace,
                    Expanded(
                      child: Text(
                        data['title'] ?? "Top up successful",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 230.w,
                  height: 1.h,
                  color: Color(0xff54A5FF),
                  margin: EdgeInsets.symmetric(vertical: 10.h),
                ),
                HtmlWidget(
                  data['content'],
                ),
              ],
            ),
          ],
        ),
      );

  Widget _orderWidget() => Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), image: DecorationImage(image: AssetImage("assets/images/msg_bg.png"), fit: BoxFit.cover)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              data['icon'] == null
                  ? Container(
                      width: iconHeight,
                      height: iconHeight,
                    )
                  : Image.network(
                      data['icon'],
                      width: iconHeight,
                      height: iconHeight,
                    ),
              SizedBox(
                width: 5,
              ),
              Container(
                height: iconHeight,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: width - iconHeight - 25,
                      child: Text(
                        "${data['game']}",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Row(
                      children: [
                        Image.asset(
                          "assets/images/ic_balance_money.webp",
                          width: 15,
                          height: 15,
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        Text(
                          "${data['price']}",
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text("for ${data['num']} ${data['unit'] }",
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 14,
                            )),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: 15,
          ),
          // Text("${DateFormat('dd/MM/y HH:mm:ss', 'en_GB').format(DateTime.fromMillisecondsSinceEpoch(data['createTime']*1000))}",
          Text("${formatDate(DateTime.fromMillisecondsSinceEpoch(data['createTime'] * 1000), [d, '/', M, '/', yyyy, ' ', HH, ':', nn])}",

              // Text("${data['addTime']}",
              style: TextStyle(
                color: Colors.white54,
                fontSize: 14,
              )),
        ],
      ));
}
