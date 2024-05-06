import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sq_hub_app/image_utils.dart';

import '../../../../config/app_color.dart';
import '../../../../model/game_user_model.dart';
import '../../../../res/dimens.dart';
import '../../../../utils/navigator_helper.dart';
import '../../../../widget/level.dart';
import '../../../../widget/location_widget.dart';
import '../../../../widget/sex_age_widget.dart';
import '../../../../widget/star_widget.dart';
import 'controller.dart';

class SearchUserPage extends GetView<SearchUserController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 0,
        title: Container(
          height: 40,
          padding: const EdgeInsets.only(left: 15, right: 15).w,
          decoration: ShapeDecoration(color: AppColor.itemBg, shape: StadiumBorder()),
          child: TextField(
            maxLines: 1,
            focusNode: controller.focusNode,
            controller: controller.controller,
            cursorColor: Colors.white70,
            textAlign: TextAlign.start,
            textInputAction: TextInputAction.search,
            style: const TextStyle(color: Colors.white, fontSize: 16),
            onSubmitted: (text) => controller.reload(),
            decoration: InputDecoration(
                hintText: "Input nickname,UK account or email".tr,
                hintStyle: TextStyle(fontSize: 13.sp, color: AppColor.textC5C5),
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(bottom: 12)),
          ),
        ),
        actions: [
          Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: GestureDetector(
                child: Image.asset(ImageUtils.ic_search, width: 23.w, height: 23.w),
                onTap: () => controller.reload(),
              )),
        ],
      ),
      body: Obx(() => ListView.separated(
            itemCount: controller.list.length,
            itemBuilder: (context, index) => InkWell(
              child: _item(controller.list[index]),
              onTap: () => NavigatorHelper.toOtherProfile(controller.list[index]?.id),
            ),
            separatorBuilder: (BuildContext context, int index) => 10.verticalSpace,
          )),
    );
  }

  _item(GameUserModel model) {
    var badgeColor = Color(0xFF87EEB6);
    bool showFold = model.games.length >= 3 ? true : false;
    model.initShowGames();
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 15,
        bottom: 16,
        top: 10,
      ).r,
      margin: EdgeInsets.only(left: 15, right: 15).r,
      decoration: BoxDecoration(color: AppColor.itemBg, borderRadius: BorderRadius.all(Radius.circular(16)).w),
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Badge(
                showBadge: model.online == ONLINE,
                badgeColor: badgeColor,
                position: BadgePosition(bottom: 0, end: 10),
                alignment: Alignment.bottomRight,
                child: Container(
                  width: 50.h,
                  height: 50.h,
                  decoration: model.online == ONLINE ? BoxDecoration(border: Border.all(color: badgeColor, width: 1), borderRadius: BorderRadius.all(Radius.circular(25.h))) : null,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(25)).h,
                    child: CachedNetworkImage(imageUrl: model.thumb, fit: BoxFit.cover),
                  ),
                ),
              ),
              10.horizontalSpace,
              Expanded(
                  child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
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
                      GameLevelWidget(
                        isAuth: model.isAuth,
                        level: model.userLevel,
                        height: 18.h,
                        userId: model.id,
                      ),
                      8.horizontalSpace,
                      SexAndAgeWidget(
                        age: model.age,
                        sex: model.sex,
                      )
                    ],
                  ),
                  5.verticalSpace,
                  Row(
                    children: [
                      StarWidget(
                        star: model.star,
                      )
                    ],
                  ),
                  5.verticalSpace,
                  Stack(
                    children: [
                      Obx(() => Wrap(spacing: 8.w, runSpacing: 8.h, children: model.showGames.map((item) => game_tag(item)).toList())),
                    ],
                  )
                ],
              )),
            ],
          ),
          Positioned(
            child: Visibility(
              child: InkWell(
                onTap: () => model.expand(),
                child: Obx(() => Icon(
                      model.showGames.length <= 3 ? Icons.keyboard_arrow_down_rounded : Icons.keyboard_arrow_up,
                      color: Colors.white,
                    )),
              ),
              visible: showFold,
            ),
            top: 40.h,
            right: 0,
          ),
          Positioned(
              right: 0,
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${model.levelName}',
                      style: TextStyle(color: Color(0xFFC3C3C3), fontWeight: FontWeight.bold, fontSize: 10.sp),
                    ),
                    LocationWidget(model.distance),
                  ],
                ),
                width: 80.w,
              ))
        ],
      ),
    );
  }

  Widget game_tag(SimpleGameInfo item) {
    return Container(
      padding: EdgeInsets.all(4).w,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CachedNetworkImage(imageUrl: item.ico, height: 10.w, width: 10.w),
          Text(
            '${item.name}',
            style: TextStyle(color: Color(0xFFC3C3C3), fontWeight: FontWeight.bold, fontSize: 10.sp),
          )
        ],
      ),
      decoration: ShapeDecoration(shape: StadiumBorder(), color: Color(0xFF3D3E48)),
    );
  }
}
