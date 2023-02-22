/**
    author:mac
    创建日期:2023/2/18
    描述:
 */
import 'package:badges/badges.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/model/game_user_model.dart';
import 'package:wy/res/index.dart';
import 'package:wy/ui/frame/sidekick/controller.dart';
import 'package:wy/utils/index.dart';
import 'package:wy/widget/home/index.dart';

class GameListItemWidget extends GetView<SideKickController> {
  GameUserModel model;

  GameListItemWidget(this.model);

  @override
  Widget build(BuildContext context) {
    var badgeColor = Color(0xFF87EEB6);
    return Container(
      height: 80.h,
      padding: EdgeInsets.only(
        left: 0,
      ).r,
      margin: EdgeInsets.only(top: 10.r),
      decoration: BoxDecoration(
          color: AppColor.itemBg, borderRadius: BorderRadius.all(Radius.circular(16)).w),
      child: ListTile(
        leading: Badge(
          showBadge: model.online == ONLINE,
          badgeColor: badgeColor,
          position: BadgePosition(bottom: 0, end: 10),
          alignment: Alignment.bottomRight,
          child: Container(
            width: 50.h,
            height: 50.h,
            decoration: model.online == ONLINE
                ? BoxDecoration(
                    border: Border.all(color: badgeColor, width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(25.h)))
                : null,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(25)).h,
              child: ImageUtil.networkImage(url: model.thumb, fit: BoxFit.cover),
            ),
          ),
        ),
        title: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              children: [
                Container(
                  child: Text(
                    '${model.name}',
                    maxLines: 1,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: Dimens.normalText,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  constraints: BoxConstraints(maxWidth: 100.w),
                ),
                8.horizontalSpace,
                SexAndAgeWidget(
                  age: model.age,
                  sex: model.sex,
                )
              ],
            ),
            Row(
              children: [
                UnitPriceWidget(
                  price: model.price,
                ),
                15.horizontalSpace,
                StarWidget(
                  star: model.star,
                )
              ],
            ),
          ],
        ),
        trailing: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              LocationWidget(model.distance),
              Text(
                '${model.levelName}',
                style: TextStyle(
                    color: Color(0xFFC3C3C3), fontWeight: FontWeight.bold, fontSize: 10.sp),
              )
            ],
          ),
          width: 80.w,
        ),
      ),
    );
  }
}
