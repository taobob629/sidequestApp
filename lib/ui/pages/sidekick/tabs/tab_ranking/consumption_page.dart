import 'package:cached_network_image/cached_network_image.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../../config/icon_font.dart';
import '../../../../../image_utils.dart';
import '../../../../../utils/navigator_helper.dart';
import 'consumption_ctr.dart';

class ConsumptionPage extends StatelessWidget {
  final t = Get.put(ConsumptionCtr());

  @override
  Widget build(BuildContext context) {
    return Obx(() => SmartRefresher(
        controller: t.refreshController,
        onLoading: () => t.loadMore(),
        onRefresh: () => t.onRefresh(),
        enablePullUp: true,
        child: ListView.separated(
          itemCount: t.list.isEmpty || t.list.length > 0 && t.list.length < 4
              ? 1
              : t.list.length - 2,
          itemBuilder: (context, index) =>
              index == 0 ? _headerWidget() : _contentWidget(index),
          separatorBuilder: (c, i) => 8.verticalSpace,
        )));
  }

  Widget _headerWidget() => Container(
        margin: EdgeInsets.symmetric(horizontal: 10.w),
        height: 232.h,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImageUtils.playmate_bg),
            fit: BoxFit.fill,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () => t.list.length > 1
                        ? NavigatorHelper.toOtherProfile(t.list[1].id)
                        : null,
                    child: Stack(
                      children: [
                        Positioned(
                          top: 16.w,
                          left: 16.w,
                          child: ExtendedImage.network(
                            t.list.length > 1 ? '${t.list[1].avatar}' : '',
                            border: Border.all(
                                color: Color(0xffE9C677), width: 1.w),
                            shape: BoxShape.circle,
                            width: 66.w,
                            height: 66.w,
                            fit: BoxFit.cover,
                            loadStateChanged: (ExtendedImageState state) {
                              switch (state.extendedImageLoadState) {
                                case LoadState.failed:
                                  return Container();
                              }
                              return null;
                            },
                          ),
                        ),
                        Image.asset(
                          ImageUtils.playmate_no2,
                          width: 98.w,
                          height: 102.w,
                        ),
                      ],
                    ),
                  ),
                  30.verticalSpace,
                  Container(
                    width: 80.w,
                    alignment: Alignment.center,
                    child: Text(
                      t.list.length > 1 ? t.list[1].nickName : '',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontFamily: FONT_MEDIUM,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    t.list.length > 1 ? '${t.list[1].num}' : '',
                    style: TextStyle(
                      color: Color(0xfff8e287),
                      fontSize: 12.sp,
                      fontFamily: FONT_MEDIUM,
                    ),
                  ),
                  20.verticalSpace,
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () => t.list.length > 0
                        ? NavigatorHelper.toOtherProfile(t.list[0].id)
                        : null,
                    child: Stack(
                      children: [
                        Positioned(
                          top: 16.w,
                          left: 16.w,
                          child: ExtendedImage.network(
                            t.list.length > 0 ? '${t.list[0].avatar}' : '',
                            border: Border.all(
                                color: Color(0xffE9C677), width: 1.w),
                            shape: BoxShape.circle,
                            width: 85.w,
                            height: 85.w,
                            fit: BoxFit.cover,
                            loadStateChanged: (ExtendedImageState state) {
                              switch (state.extendedImageLoadState) {
                                case LoadState.failed:
                                  return Container();
                              }
                              return null;
                            },
                          ),
                        ),
                        Image.asset(
                          ImageUtils.playmate_no1,
                          width: 116.w,
                          height: 128.w,
                        ),
                      ],
                    ),
                  ),
                  40.verticalSpace,
                  Container(
                    width: 130.w,
                    alignment: Alignment.center,
                    child: Text(
                      t.list.length > 0 ? '${t.list[0].nickName}' : '',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontFamily: FONT_MEDIUM,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      t.list.length > 0 ? '${t.list[0].num}' : '',
                      style: TextStyle(
                        color: Color(0xfff8e287),
                        fontSize: 14.sp,
                        fontFamily: FONT_MEDIUM,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () => t.list.length > 2
                        ? NavigatorHelper.toOtherProfile(t.list[2].id)
                        : null,
                    child: Stack(
                      children: [
                        Positioned(
                          top: 16.w,
                          left: 16.w,
                          child: ExtendedImage.network(
                            t.list.length > 2 ? '${t.list[2].avatar}' : '',
                            border: Border.all(
                                color: Color(0xffE9C677), width: 1.w),
                            shape: BoxShape.circle,
                            width: 66.w,
                            height: 66.w,
                            fit: BoxFit.cover,
                            loadStateChanged: (ExtendedImageState state) {
                              switch (state.extendedImageLoadState) {
                                case LoadState.failed:
                                  return Container();
                              }
                              return null;
                            },
                          ),
                        ),
                        Image.asset(
                          ImageUtils.playmate_no3,
                          width: 98.w,
                          height: 102.w,
                        ),
                      ],
                    ),
                  ),
                  30.verticalSpace,
                  Container(
                    width: 80.w,
                    alignment: Alignment.center,
                    child: Text(
                      t.list.length > 2 ? '${t.list[2].nickName}' : '',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontFamily: FONT_MEDIUM,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    t.list.length > 2 ? '${t.list[2].num}' : '',
                    style: TextStyle(
                      color: Color(0xfff8e287),
                      fontSize: 12.sp,
                      fontFamily: FONT_MEDIUM,
                    ),
                  ),
                  20.verticalSpace,
                ],
              ),
            ),
          ],
        ),
      );

  Widget _contentWidget(int index) => Visibility(
        visible: t.list.length > 3,
        child: Container(
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
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () =>
                    NavigatorHelper.toOtherProfile(t.list[index + 2].id),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.r),
                  child: CachedNetworkImage(
                      imageUrl: t.list[index + 2].avatar,
                      width: 40.w,
                      height: 40.w,
                      fit: BoxFit.cover),
                ),
              ),
              15.horizontalSpace,
              Expanded(
                child: Text(
                  t.list[index + 2].nickName,
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
                '${t.list[index + 2].num}',
                style: TextStyle(
                  color: Color(0xffF8E287),
                  fontSize: 16.sp,
                  fontFamily: FONT_MEDIUM,
                ),
              ),
            ],
          ),
        ),
      );
}
