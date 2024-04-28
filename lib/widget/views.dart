// ignore_for_file: dead_code, implementation_imports

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../utils/platform_utils.dart';
import 'custom_loading_widget.dart';

///加载框
Widget buildLoad({
  ///大小
  double size = 40,
  double radius = 10,

  ///粗细
  double width = 2,

  ///是否居中
  bool isCenter = true,

  ///颜色
  Color? color,
}) {
  if (isCenter) {
    // return Center(
    //   child: CupertinoActivityIndicator(radius: radius),
    // );
    return Container(
      width: Get.width,
      child: Center(
        child: SizedBox(
          height: size,
          width: size,
          child: Center(
            child: CustomLoadingWidget(
              backgroundColor: Colors.transparent,
              color: Colors.white,
              size: 40.sp,
            ),
            // child: CircularProgressIndicator(
            //   strokeWidth: 2,
            //   valueColor: AlwaysStoppedAnimation<Color>(color ?? Theme.of(context!).primaryColor),
            // ),
          ),
        ),
      ),);
  } else {
    // return CupertinoActivityIndicator(radius: radius);
    return SizedBox(
      height: size,
      width: size,
      child: Center(
        child: CustomLoadingWidget(
          backgroundColor: Colors.transparent,
          color: Colors.white,
          size: 40.sp,
        ),
        // child: CircularProgressIndicator(
        //   strokeWidth: 2,
        //   valueColor: AlwaysStoppedAnimation<Color>(color ?? Theme.of(context!).primaryColor),
        // ),
      ),
    );
  }
}

///底部悬浮菜单
Future<dynamic> showSheet({
  List<Widget> children = const <Widget>[],
  Widget Function(ScrollController?)? builder,
  bool? isScrollControlled,
  bool isDraggableList = !true,
  bool isClose = false,
  Color? barrierColor,
}) {
  FocusScope.of(Get.context!).requestFocus(FocusNode());
  return showModalBottomSheet(
    context: Get.context!,
    isDismissible: !isClose,
    enableDrag: !isClose,
    barrierColor: barrierColor,
    backgroundColor: Colors.transparent,
    isScrollControlled: isScrollControlled ?? true,
    builder: (_) {
      return WillPopScope(
        child: AnimatedPadding(
          duration: Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          // padding: Platform.version.contains('2.13') ? EdgeInsets.zero : MediaQuery.of(context).viewInsets,
          padding: Platform.version.contains('2.13') ? EdgeInsets.zero : EdgeInsets.zero,
          child: builder!(null),
        ),
        onWillPop: () async => !isClose,
      );
    },
  );
}
