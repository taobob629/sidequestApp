import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:sq_hub_app/common/empty_view.dart';
import 'package:sq_hub_app/config/app_color.dart';
import 'package:sq_hub_app/config/icon_font.dart';
import 'package:sq_hub_app/widget/image_util.dart';
import 'package:badges/badges.dart' as badges;

import '../../../image_utils.dart';
import '../playwith/balance/widget/tips_dialog.dart';
import 'add_friend_ctr.dart';
import 'add_rule_dialog.dart';

class AddFriendPage extends StatelessWidget {
  final ctr = Get.put(AddFriendCtr());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 40.h,
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: hexColor('#141414'),
            borderRadius: BorderRadius.circular(80.r),
          ),
          child: Row(
            children: [
              10.horizontalSpace,
              Expanded(
                child: Container(
                  height: 40.h,
                  alignment: Alignment.centerLeft,
                  child: TextField(
                    controller: ctr.searchCtr,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      isCollapsed: true,
                      hintText: "Search by Name or ID".tr,
                      hintStyle: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 14.sp,
                        fontFamily: FONT_MEDIUM,
                      ),
                    ),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontFamily: FONT_MEDIUM,
                    ),
                  ).paddingOnly(left: 4.w),
                ),
              ),
              InkWell(
                onTap: () => ctr.searchFriend(context),
                child: Container(
                  width: 50.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: Color(0x804f4f4f),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(80.r),
                      bottomRight: Radius.circular(80.r),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        Obx(() => Visibility(
              visible: !ctr.isSearchFriend.value,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => ctr.requestData(),
                    child: Text(
                      'My Friends'.tr,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontFamily: FONT_MEDIUM,
                        color: Colors.white,
                      ),
                    ).paddingOnly(right: 10.w),
                  ),
                  Spacer(),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTapDown: (details) {
                      print(details.globalPosition);
                      Get.dialog(AddRuleDialog(
                        offset: details.globalPosition,
                      ));
                    },
                    child: Container(
                      width: 15.w,
                      height: 15.w,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: hexColor('#FFB20E'),
                          width: 1.2.w,
                        ),
                        borderRadius: BorderRadius.circular(15.w),
                      ),
                      margin: EdgeInsets.only(right: 8.w),
                      alignment: Alignment.center,
                      child: Text(
                        '!',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontFamily: FONT_MEDIUM,
                          color: hexColor('#FFB20E'),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    'Add Rule'.tr,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontFamily: FONT_MEDIUM,
                      color: hexColor('#FFB20E'),
                    ),
                  ),
                ],
              ).marginOnly(left: 16.w, right: 16.w, top: 16.h),
            )),
        Obx(() => GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => ctr.approval(),
              child: Row(
                children: [
                  badges.Badge(
                    showBadge: ctr.friendOutModel.value.approvalNum > 0,
                    badgeContent: Text(
                      '${ctr.friendOutModel.value.approvalNum}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.sp,
                      ),
                    ),
                    badgeColor: Color(0xffFF4848),
                    position: badges.BadgePosition(end: -14.w, top: -6),
                    alignment: Alignment.topRight,
                    child: Text(
                      'Pending Approval'.tr,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontFamily: FONT_LIGHT,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Spacer(),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 16.sp,
                  ),
                ],
              ).marginOnly(left: 22.w, right: 32.w, top: 16.h, bottom: 16.h),
            )),
        Expanded(
          child: Obx(() => ctr.friendList.isNotEmpty
              ? ListView.separated(
                  itemBuilder: (c, i) => Slidable(
                    key: ValueKey(i),
                    enabled: ctr.friendList[i].friendState == 3,
                    endActionPane: ActionPane(
                      extentRatio: 0.3,
                      motion: StretchMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (c) => ctr.cancelFriends(ctr.friendList[i]),
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          label: 'Cancel',
                        ),
                      ],
                    ),
                    child: Container(
                      padding: EdgeInsets.fromLTRB(
                        16.w,
                        4.h,
                        18.w,
                        14.h,
                      ),
                      child: Row(
                        children: [
                          ImageUtil.networkImage(
                            url: '${ctr.friendList[i].memberPhoto}',
                            width: 40.w,
                            height: 40.w,
                            fit: BoxFit.contain,
                            border: 40.w,
                          ).marginOnly(right: 10.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${ctr.friendList[i].nickName}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontFamily: FONT_MEDIUM,
                                    color: Colors.white,
                                  ),
                                ).paddingOnly(bottom: 4.h),
                                Text(
                                  '${ctr.friendList[i].memberCode}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontFamily: FONT_LIGHT,
                                    color: Colors.white.withOpacity(0.6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ctr.getFunByState(ctr.friendList[i]),
                        ],
                      ),
                    ),
                  ),
                  separatorBuilder: (c, i) => Container(
                    margin: EdgeInsets.symmetric(horizontal: 16.w),
                    color: Colors.white10,
                    height: 1.h,
                  ),
                  itemCount: ctr.friendList.length,
                )
              : EmptyView()),
        ),
      ],
    );
  }
}
