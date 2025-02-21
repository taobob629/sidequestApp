import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sq_hub_app/common/empty_view.dart';

import '../../../../common/base_scaffold.dart';
import '../../../../config/icon_font.dart';
import '../../../../model/integral_list_model.dart';
import '../../../../widget/container_tab_indicator.dart';
import 'ctr/integral_record_ctr.dart';

class IntegralRecordPage extends StatelessWidget {
  final ctr = Get.put(IntegralRecordCtr());

  @override
  Widget build(BuildContext context) => BaseScaffold(
        title: "Points Record".tr,
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Column(
            children: [
              Container(
                alignment: Alignment.bottomCenter,
                child: TabBar(
                  controller: ctr.tabBarController,
                  tabs: ctr.tabsList,
                  isScrollable: true,
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                  unselectedLabelColor: Colors.white.withOpacity(0.6),
                  labelColor: Colors.white,
                  onTap: (index) => ctr.changeData(index),
                  labelStyle: TextStyle(
                    fontSize: 15.sp,
                    fontFamily: FONT_LIGHT,
                  ),
                  // 设置选中状态下文本的大小
                  unselectedLabelStyle: TextStyle(
                    fontSize: 15.sp,
                    fontFamily: FONT_LIGHT,
                  ),
                  indicator: ContainerTabIndicator(
                    height: 3.h,
                    width: 15.w,
                    radius: BorderRadius.circular(2.r),
                    colors: const [Colors.white, Colors.white],
                    padding: EdgeInsets.only(top: 14.h),
                  ),
                ),
              ),
              10.verticalSpace,
              Expanded(
                child: Obx(() => ctr.list.isNotEmpty
                    ? SmartRefresher(
                        controller: ctr.refreshController,
                        onLoading: () => ctr.loadMore(),
                        onRefresh: () => ctr.onRefresh(),
                        enablePullUp: true,
                        enablePullDown: true,
                        child: ListView.separated(
                          itemBuilder: (c, i) => _itemWidget(ctr.list[i]),
                          separatorBuilder: (c, i) => Container(
                            height: 1.h,
                            margin: EdgeInsets.symmetric(vertical: 15.h),
                            decoration: BoxDecoration(color: Color(0xFF45494B)),
                          ),
                          itemCount: ctr.list.length,
                        ),
                      )
                    : EmptyView()),
              ),
            ],
          ),
        ),
      );

  Widget _itemWidget(IntegralListRow model) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${model.detailName}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontFamily: FONT_MEDIUM,
                    ),
                  ),
                  6.verticalSpace,
                  Text(
                    '${model.createTime}',
                    style: TextStyle(
                      color: Color(0xFF9CA3AF),
                      fontSize: 11.sp,
                      fontFamily: 'DIN',
                    ),
                  )
                ],
              ),
            ),
            Text(
              ctr.type == 1 ? '+${model.pointsNum}' : '-${model.pointsNum}',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Color(ctr.type == 1 ? 0xFFF72F2F : 0xFF7BD335),
                fontSize: 20,
                fontFamily: FONT_MEDIUM,
              ),
            )
          ],
        ),
      );
}
