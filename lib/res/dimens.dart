import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/**
    author:mac
    创建日期:2023/2/15
    描述:
 */
class Dimens {
  static double largeText = 19.0.sp; //大
  static double normalText = 14.0.sp;
  static double smallText = 13.0.sp;

  static double buttonText = 17.0.sp;

  static double radiusNormal = 16.0.r;
  static double radiusSmall = 6.0.r;
  static double radius10 = 10.0.r;

  static double dividerNomarl = 16;
  static Widget dVerticalNomarl = 15.verticalSpace;
  static double dividerSmall = 10;
  static Widget dVerticalSmall = 10.verticalSpace;

  static double paddingLarge = 24.w;
  static double paddingNormal_10 = 10;
  static double paddingNormal_14 = 14;
  static double paddingNormal = 16.0;
  static double paddingSmall = 6;
  static double paddingTiny = 4;

  //这里配置btn按钮
  static double btnHeightNormal = 50;
  static double btnHeightSmall = 40;
  static double btnRadius = 6; //按钮的圆角

  static double gap5 = 5;
  static double gap4 = 4;
  static double gap6 = 6;
  static double gap10 = 10;
  static double gap12 = 12;
  static double gap15 = 15;
  static double gap16 = 16;
  static double gap50 = 50;
  static double gap40 = 40;
  static double gap30 = 30;
}
contentPadding({required Widget child,double? width,double? height}){
  return Container(
    width: width,
    height: height,
    padding: EdgeInsets.all(16.w),child: child,);
}