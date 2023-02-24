/**
    author:mac
    创建日期:2023/2/24
    描述:
 */
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
    return contentPadding(
      height: 200.h,
      child: ImageUtil.networkImage(url: model.image, border: 20.r),
    );
  }
}
