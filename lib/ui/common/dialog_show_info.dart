import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

import '../../image_utils.dart';

class DialogShowInfo extends StatelessWidget {

  String content;

  DialogShowInfo(this.content);

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2), () => SmartDialog.dismiss());
    return Center(
      child: Container(
        padding: EdgeInsets.all(10.r),
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                ImageUtils.tip_info_bg,
              ),
              fit: BoxFit.fill),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              ImageUtils.icon_xiaoxi,
              width: 45.w,
              height: 60.h,
            ),
            8.verticalSpace,
            Text(
              content,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }
}