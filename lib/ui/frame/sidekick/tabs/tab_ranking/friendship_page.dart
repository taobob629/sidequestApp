import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wy/config/icon_font.dart';
import 'package:wy/image_utils.dart';
import 'package:wy/utils/image_util.dart';

import '../../../../controller/user_controller.dart';
import 'consumption_ctr.dart';
import 'friendship_ctr.dart';

class FriendShipPage extends StatelessWidget {
  final t = Get.put(FriendShipCtr());

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
        controller: t.refreshController,
        onLoading: () => t.loadMore(),
        onRefresh: () => t.onRefresh(),
        enablePullUp: true,
        child: ListView.separated(
          itemCount: 20,
          // itemCount: t.list.length,
          itemBuilder: (context, index) {
            // final model = t.list[index];
            return index == 0 ? _headerWidget() : _contentWidget(index);
          },
          separatorBuilder: (c, i) => 8.verticalSpace,
        ));
  }

  Widget _headerWidget() => Container(
        width: Get.width - 30.w,
        height: 258.h,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(ImageUtils.friendship_bg)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  70.verticalSpace,
                  Stack(
                    children: [
                      Positioned(
                        top: 24.h,
                        left: 15.w,
                        right: 15.w,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ExtendedImage.network(
                              UserController.find.userProfile.avatar,
                              border: Border.all(
                                  color: Color(0xffEB7AF5), width: 1.w),
                              shape: BoxShape.circle,
                              width: 34.w,
                              height: 34.w,
                              fit: BoxFit.cover,
                            ),
                            ExtendedImage.network(
                              UserController.find.userProfile.avatar,
                              border: Border.all(
                                  color: Color(0xffEB7AF5), width: 1.w),
                              shape: BoxShape.circle,
                              width: 34.w,
                              height: 34.w,
                              fit: BoxFit.cover,
                            ),
                          ],
                        ),
                      ),
                      Image.asset(
                        ImageUtils.friendship_no2,
                        width: 98.w,
                        height: 102.h,
                      ),
                    ],
                  ),
                  20.verticalSpace,
                  Container(
                    width: 80.w,
                    child: Text(
                      'Name & Name',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontFamily: FONT_MEDIUM,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    '10K',
                    style: TextStyle(
                      color: Color(0xfff8e287),
                      fontSize: 14.sp,
                      fontFamily: FONT_MEDIUM,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  10.verticalSpace,
                  Stack(
                    children: [
                      Positioned(
                        top: 26.h,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ExtendedImage.network(
                              UserController.find.userProfile.avatar,
                              border: Border.all(
                                  color: Color(0xffE9C677), width: 1.w),
                              shape: BoxShape.circle,
                              width: 50.w,
                              height: 50.w,
                              fit: BoxFit.cover,
                            ),
                            ExtendedImage.network(
                              UserController.find.userProfile.avatar,
                              border: Border.all(
                                  color: Color(0xffE9C677), width: 1.w),
                              shape: BoxShape.circle,
                              width: 50.w,
                              height: 50.w,
                              fit: BoxFit.cover,
                            ),
                          ],
                        ),
                      ),
                      Image.asset(
                        ImageUtils.friendship_no1,
                        width: 130.w,
                        height: 128.h,
                      ),
                    ],
                  ),
                  24.verticalSpace,
                  Container(
                    width: 120.w,
                    alignment: Alignment.center,
                    child: Text(
                      'Name & Name',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontFamily: FONT_MEDIUM,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  6.verticalSpace,
                  Text(
                    '10K',
                    style: TextStyle(
                      color: Color(0xfff8e287),
                      fontSize: 18.sp,
                      fontFamily: FONT_MEDIUM,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  70.verticalSpace,
                  Stack(
                    children: [
                      Positioned(
                        top: 24.h,
                        left: 15.w,
                        right: 15.w,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ExtendedImage.network(
                              UserController.find.userProfile.avatar,
                              border: Border.all(
                                  color: Color(0xff8288F6), width: 1.w),
                              shape: BoxShape.circle,
                              width: 34.w,
                              height: 34.w,
                              fit: BoxFit.cover,
                            ),
                            ExtendedImage.network(
                              UserController.find.userProfile.avatar,
                              border: Border.all(
                                  color: Color(0xff8288F6), width: 1.w),
                              shape: BoxShape.circle,
                              width: 34.w,
                              height: 34.w,
                              fit: BoxFit.cover,
                            ),
                          ],
                        ),
                      ),
                      Image.asset(
                        ImageUtils.friendship_no3,
                        width: 98.w,
                        height: 102.h,
                      ),
                    ],
                  ),
                  20.verticalSpace,
                  Container(
                    width: 80.w,
                    child: Text(
                      'Name & Name',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontFamily: FONT_MEDIUM,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    '10K',
                    style: TextStyle(
                      color: Color(0xfff8e287),
                      fontSize: 14.sp,
                      fontFamily: FONT_MEDIUM,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _contentWidget(int index) => Container(
        height: 64.h,
        margin: EdgeInsets.only(left: 15.w, right: 15.w),
        padding: EdgeInsets.only(left: 15.w, right: 15.w),
        decoration: BoxDecoration(
          color: Color(0xff262731),
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(
            color: Color(0xffA55FEA),
            width: 1.w,
          ),
        ),
        child: Row(
          children: [
            Text(
              '${index + 3}',
              style: TextStyle(
                color: Color(0xffc3c3c3),
                fontSize: 21.sp,
                fontFamily: FONT_MEDIUM,
              ),
            ),
            15.horizontalSpace,
            Stack(
              alignment: Alignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ExtendedImage.network(
                      'https://img2.baidu.com/it/u=2425084553,971201481&fm=253&fmt=auto&app=138&f=JPEG?w=889&h=500',
                      border: Border.all(color: Colors.white, width: 1),
                      shape: BoxShape.circle,
                      width: 40.w,
                      height: 40.w,
                      fit: BoxFit.cover,
                    ),
                    ExtendedImage.network(
                      UserController.find.userProfile.avatar,
                      border: Border.all(color: Colors.white, width: 1),
                      shape: BoxShape.circle,
                      width: 40.w,
                      height: 40.w,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
                Image.asset(
                  ImageUtils.icon_loveship,
                  width: 21.w,
                  height: 21.h,
                )
              ],
            ),
            15.horizontalSpace,
            Expanded(
              child: Text(
                'item ${index + 3}',
                style: TextStyle(
                  color: Color(0xffc3c3c3),
                  fontSize: 14.sp,
                  fontFamily: FONT_MEDIUM,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              '6.2K',
              style: TextStyle(
                color: Color(0xffF8E287),
                fontSize: 16.sp,
                fontFamily: FONT_MEDIUM,
              ),
            ),
          ],
        ),
      );
}
