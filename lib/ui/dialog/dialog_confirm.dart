import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sq_hub_app/config/icon_font.dart';

import '../../common/colorful_button.dart';
import '../../common/wy_confirm_dialog.dart';
import '../../common/wy_dialog.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String info;
  final bool? cancelable;
  final String? confirmBtn;
  final String? concelBtn;
  final Function? onConfirm;

  ConfirmDialog(
      {required this.title,
      required this.info,
      this.cancelable = true,
      this.confirmBtn = "CONFIRM",
      this.concelBtn,
      this.onConfirm});

  @override
  Widget build(BuildContext context) {
    if (title.contains('Cancel Subscription') || title.contains('取消订阅')) {
      return view2(context);
    } else {
      return view1(context);
    }
  }

  ///可滚动
  Widget view2(BuildContext context) {
    return WyConfirmDialog(
      child: SizedBox(
        height: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.white,
                fontFamily: FONT_MEDIUM,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 20.h),
                  child: Text(
                    "$info",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),
            ),
            Row(
              children: [
                if (concelBtn != null)
                  Expanded(
                    child: InkWell(
                      onTap: () => Navigator.pop(context, true),
                      child: Container(
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 1.w,
                              color: Color(0xFFFFB20E),
                            ),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "$concelBtn",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontFamily: FONT_MEDIUM,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        height: 40.h,
                      ),
                    ),
                  ),
                if (concelBtn != null)
                  Container(
                    width: 16,
                  ),
                Expanded(
                  child: InkWell(
                    onTap: () => onConfirm == null
                        ? Navigator.pop(context, true)
                        : onConfirm!.call(),
                    child: Container(
                      decoration: ShapeDecoration(
                        color: Color(0xFFFFB20E),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "$confirmBtn".tr,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontFamily: FONT_MEDIUM,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      height: 40.h,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  ///不可滚动
  Widget view1(BuildContext context) {
    return WyConfirmDialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.white,
              fontFamily: FONT_MEDIUM,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10.h, bottom: 30.h),
            child: Text(
              "$info",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
              ),
            ),
          ),
          Row(
            children: [
              if (concelBtn != null)
                Expanded(
                  child: InkWell(
                    onTap: () => Navigator.pop(context, true),
                    child: Container(
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 1.w,
                            color: Color(0xFFFFB20E),
                          ),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "$concelBtn",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontFamily: FONT_MEDIUM,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      height: 40.h,
                    ),
                  ),
                ),
              if (concelBtn != null)
                Container(
                  width: 16,
                ),
              Expanded(
                child: InkWell(
                  onTap: () => onConfirm == null
                      ? Navigator.pop(context, true)
                      : onConfirm!.call(),
                  child: Container(
                    decoration: ShapeDecoration(
                      color: Color(0xFFFFB20E),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "$confirmBtn".tr,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontFamily: FONT_MEDIUM,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    height: 40.h,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  static Future<bool?> show(BuildContext context, String title, String info,
      {bool cancelable = true}) async {
    return await showDialog<bool>(
        context: context,
        barrierColor: Colors.black26,
        barrierDismissible: cancelable,
        builder: (BuildContext context) {
          return ConfirmDialog(
              title: title, info: info, cancelable: cancelable);
        });
  }
}
