import 'package:date_format/date_format.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:wy/common/string_ext.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/image_utils.dart';

class CustomMessageView extends StatelessWidget {
  var type;
  var data;

  double width = Get.width * 0.6;
  double height = Get.width * 191 / 369;
  double iconHeight = Get.width * 191 / 369 * 0.5;

  CustomMessageView({
    required this.type,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case "TopUp_Credit":
        return _topUpCreditWidget();
      case "play_order":
        return _orderWidget();
      case "PostMessage":
        return _postMsgItem();
      default:
        return Text(
          "Unsupported message type, please update your app!",
          style: TextStyle(fontSize: 12, color: Colors.white24),
        );
    }
  }

  Widget _postMsgItem() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(color: AppColor.itemBg2, borderRadius: BorderRadius.circular(10)
          // border: Border(bottom: BorderSide(color: AppColor.itemBg, width: 1)),
          ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                16.verticalSpace,
                Container(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(data["nickname"],
                          style: TextStyle(fontSize: 16.sp, color: Colors.white)),
                      15.horizontalSpace,
                      Text(data["action"],
                          style: TextStyle(fontSize: 14.sp, color: AppColor.yellow)),
                    ],
                  ),
                ),
                7.verticalSpace,
                Text((int.tryParse(data["addtime"].toString()) ?? 0).toDateStr,
                    style: TextStyle(fontSize: 12.sp, color: Color(0xFF808388))),
                8.verticalSpace,
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 13.h),
                  decoration: BoxDecoration(
                      color: AppColor.itemBg, borderRadius: BorderRadius.circular(10.r)),
                  child:
                      Text(data["content"], style: TextStyle(fontSize: 14.sp, color: Colors.white)),
                ),
                15.verticalSpace
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _topUpCreditWidget() => Container(
        width: width,
        // height: height,
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
      width: width,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          image: DecorationImage(image: AssetImage("assets/images/msg_bg.png"), fit: BoxFit.cover)),
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
              Expanded(
                  child: Container(
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
                        style: TextStyle(
                            color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          "assets/images/ic_balance_money.webp",
                          width: 15.w,
                          height: 15.w,
                        ),
                        3.horizontalSpace,
                        Text(
                          "${data['price']}",
                          style: TextStyle(
                              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        6.horizontalSpace,
                        Expanded(
                          child: Text("for ${data['num']} ${data['unit']}",
                              maxLines: 1,
                              style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                color: Colors.white54,
                                fontSize: 12.sp,
                              )),
                        )
                      ],
                    )
                  ],
                ),
              ))
            ],
          ),
          SizedBox(
            height: 15,
          ),
          // Text("${DateFormat('dd/MM/y HH:mm:ss', 'en_GB').format(DateTime.fromMillisecondsSinceEpoch(data['createTime']*1000))}",
          Text(
              "${formatDate(DateTime.fromMillisecondsSinceEpoch(data['createTime'] * 1000), [
                    d,
                    '/',
                    M,
                    '/',
                    yyyy,
                    ' ',
                    HH,
                    ':',
                    nn
                  ])}",

              // Text("${data['addTime']}",
              style: TextStyle(
                color: Colors.white54,
                fontSize: 14,
              )),
        ],
      ));
}
