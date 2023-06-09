import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wy/config/icon_font.dart';
import 'package:wy/image_utils.dart';
import 'package:wy/utils/image_util.dart';

import 'consumption_ctr.dart';

class ConsumptionPage extends StatelessWidget {
  final t = Get.put(ConsumptionCtr());

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
        height: 232.h,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(ImageUtils.playmate_bg)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  40.verticalSpace,
                  Image.asset(
                    ImageUtils.playmate_no2,
                    width: 98.w,
                    height: 102.h,
                  ),
                  30.verticalSpace,
                  Text(
                    'Name',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontFamily: FONT_MEDIUM,
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
                  Image.asset(
                    ImageUtils.playmate_no1,
                    width: 116.w,
                    height: 128.h,
                  ),
                  34.verticalSpace,
                  Text(
                    'Name',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontFamily: FONT_MEDIUM,
                    ),
                  ),
                  6.verticalSpace,
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
                  40.verticalSpace,
                  Image.asset(
                    ImageUtils.playmate_no3,
                    width: 98.w,
                    height: 102.h,
                  ),
                  30.verticalSpace,
                  Text(
                    'Name',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontFamily: FONT_MEDIUM,
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
            ClipRRect(
              borderRadius: BorderRadius.circular(20.r),
              child: ImageUtil.networkImage(
                url:
                    'https://img2.baidu.com/it/u=2425084553,971201481&fm=253&fmt=auto&app=138&f=JPEG?w=889&h=500',
                width: 40.w,
                height: 40.w,
                fit: BoxFit.cover
              ),
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
