/**
    author:mac
    创建日期:2023/3/21
    描述:
 */
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wy/config/icon_font.dart';
import 'package:wy/res/styles.dart';
var textStyle2 = TextStyle(fontFamily: FONT_MEDIUM, fontSize: 13.sp);
rowLine(var leftText, var rightText) {
  return Padding(
    padding: EdgeInsets.only(top: 8, bottom: 8).h,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$leftText',
          style: TextStyle(color: Color(0xFFB2B9C9), fontSize: 12.sp, fontFamily: FONT_LIGHT),
        ),
        Text('$rightText', style: TextStyle(fontSize: 12.sp, fontFamily: FONT_LIGHT)),
      ],
    ),
  );
}
divider() {
  return Container(
    child: listDivider,
    padding: EdgeInsets.only(top: 15.h, bottom: 20.h),
  );
}
rowLine2(var leftText, Widget rightWidget) {
  return Padding(
    padding: EdgeInsets.only(top: 8, bottom: 8).h,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$leftText',
          style: textStyle2,
        ),
        rightWidget
      ],
    ),
  );
}
Widget innnerBg(Widget view) {
  return Container(
    padding: itemPaddingNormal,
    decoration: itemDecoration(color: Color(0xFF262731), radius: 17.r),
    child: view,
  );
}