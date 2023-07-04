/**
    author:mac
    创建日期:2023/4/11
    描述:
 */
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/image_utils.dart';

import '../ui/frame/profile/my_profile/badges_widget.dart';

class TipsWidegt extends StatelessWidget {
  String title;
  Widget? custumTitle;
  String tips;
  double? padding;
  bool center;

  TipsWidegt(
      {this.title = '',
      this.tips = '',
      this.padding,
      this.custumTitle,
      this.center = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: padding ?? 20.w),
      child: Row(
        mainAxisAlignment: center ? MainAxisAlignment.center : MainAxisAlignment.start,
        children: [
          custumTitle ??
              Text(
                '$title',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold),
              ),
          if (tips.isNotEmpty)
            GestureDetector(
              onTapDown: (details) {
                print(details.globalPosition);
                Get.dialog(TipsDialog(
                  offset: details.globalPosition,
                  tips: tips,
                ));
              },
              child: Container(
                margin: EdgeInsets.only(left: 6),
                width: 12.w,
                height: 12.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Color(0xffb2b9c9),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Image.asset(
                  ImageUtils.icon_help,
                  width: 10.w,
                  height: 10.w,
                ),
              ),
            )
        ],
      ),
    );
  }
}
