/*
  styles
  sidequest_hub_app
  desc:
  Created by chunma on .
  Copyright © sidequest_hub_app. All rights reserved.
*/
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/config/icon_font.dart';

class PageStyle {
  static var ts_FFFFFF_15sp = TextStyle(
    fontSize: 15.sp,
    color: Color(0xFFFFFFFF),
  );
  static var ts_FFFFFF_16sp = TextStyle(
    fontSize: 16.sp,
    color: Color(0xFFFFFFFF),
  );
  static var labelStyle = TextStyle(
    fontSize: 15.sp,
    fontFamily: FONT_MEDIUM,
    color: Color(0xFFFFFFFF),
  );
  static var btnStyle = TextStyle(
    fontSize: 15.sp,
    fontFamily: FONT_MEDIUM,
    color: Color(0xffFFCB0E),
  );
}

var itemPaddingNormal = EdgeInsets.all(15.r);
var itemPadding10 = EdgeInsets.all(10.r);
var listDivider = Divider(
  color: Color(0xFF2D2E3A),
  height: 1,
);
var listDivider10 = Divider(
  color: Colors.transparent,
  height: 10,
);
inputHint() => TextStyle(color: Color(0xFFB2B9C9), fontSize: 14.sp);
bottomBtnText() => TextStyle(color: Colors.white, fontSize: 15.sp,fontFamily: FONT_BLACK);

BoxDecoration itemDecoration({var color, var radius}) => BoxDecoration(
    color: color ?? AppColor.itemBg, borderRadius: BorderRadius.circular(radius ?? 16.r));

itemPadding({var l, var r, var b, var t}) {
  return EdgeInsets.only(left: l ?? 10, right: r ?? 10, bottom: b ?? 10, top: t ?? 10).r;
}

BoxDecoration listItemDecoration({var radius}) =>
    BoxDecoration(color: AppColor.itemBg2, borderRadius: BorderRadius.circular(radius ?? 10.r));

ShapeDecoration inputDecoration() => ShapeDecoration(
    color: Color(0xFF313033),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10).r));

BoxDecoration pageDecoration() => BoxDecoration(
        gradient: LinearGradient(
      colors: [
        Color(0xFFFA9B83),
        Color(0xFF312D47),
        AppColor.background,
      ],
      stops: [0.1, 0.3, 0.6],
      begin: Alignment(-2, -1),
      end: Alignment(2, 1),
    ));
