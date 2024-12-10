import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../config/icon_font.dart';
import '../../../../widget/image_util.dart';
import '../add_friend_ctr.dart';
import 'approval_ctr.dart';

class ApprovalPage extends StatelessWidget {
  final ctr = Get.put(ApprovalCtr());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pending Approval'.tr,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 18.sp,
            fontFamily: FONT_MEDIUM,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Obx(() => ListView.separated(
        itemBuilder: (c, i) => Container(
          padding: EdgeInsets.fromLTRB(
            16.w,
            14.h,
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
              AddFriendCtr.find.getFunByState(ctr.friendList[i]),
            ],
          ),
        ),
        separatorBuilder: (c, i) => Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          color: Colors.white10,
          height: 1.h,
        ),
        itemCount: ctr.friendList.length,
      )),
    );
  }
}
