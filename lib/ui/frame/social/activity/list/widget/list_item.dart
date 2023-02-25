/**
    author:mac
    创建日期:2023/2/24
    描述:
 */
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wy/model/activity_list_model.dart';
import 'package:wy/res/dimens.dart';
import 'package:wy/utils/index.dart';

class ActivityListItemWidget extends StatelessWidget {
  late ActivityListModel model;

  ActivityListItemWidget(this.model);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 15, right: 15, top: 10.h).w,
      height: 200.h,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ImageUtil.networkImage(url: model.image, border: 20.r, fit: BoxFit.cover),
          Positioned(
              bottom: 12.h,
              left: 12.5.w,
              right: 12.5.w,
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(20.r)),
                  // make sure we apply clip it properly
                  child: BackdropFilter(
                    //背景滤镜
                    filter: ImageFilter.blur(sigmaX: 15.h, sigmaY: 15.h), //背景模糊化
                    child: Container(
                      height: 80.h,
                      padding: EdgeInsets.only(left: 15.r, right: 15.r),
                      alignment: Alignment.centerLeft,
                      color: Colors.grey.withOpacity(0.1),
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '${model.title}\n',
                              style: TextStyle(fontSize: 14.sp),
                            ),
                            TextSpan(
                                text: '${model.time}',
                                style: TextStyle(color: Colors.white54, fontSize: 12.sp)),
                          ],
                        ),
                        textAlign: TextAlign.start,
                        strutStyle: StrutStyle(height: 1.7),
                      ),
                    ),
                  )))
        ],
      ),
    );
  }
}
