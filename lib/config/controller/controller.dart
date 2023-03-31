/**
    author:mac
    创建日期:2023/3/30
    描述:
 */
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/config/icon_font.dart';

import '../../utils/index.dart';

class AppController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    initEasyLoadding();
  }

  initEasyLoadding() {
    flog('init---east');
    EasyLoading.instance
      ..contentPadding = EdgeInsets.all(0)
      ..radius=10.r
      ..progressColor = Colors.red
      ..loadingStyle = EasyLoadingStyle.dark
      ..errorWidget = Container(
        padding: EdgeInsets.all(5).r,
          decoration: BoxDecoration(
              color: Color(0xFFFFCB0E),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.r), topRight: Radius.circular(10.r))),
          child: Row(
            children: [
              ImageUtil.assetImage('ic_face_sad', width: 17.w, height: 17.w),
              3.horizontalSpace,
              Text(
                'An error has occurred',
                style: TextStyle(fontFamily: FONT_LIGHT, fontSize: 14.sp),
              )
            ],
          ));
  }
}
