/*
  view
  sidequest_hub_app
  desc:
  Created by chunma on .
  Copyright © sidequest_hub_app. All rights reserved.
*/
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sq_hub_app/common/base_scaffold.dart';
import 'package:sq_hub_app/config/icon_font.dart';

import '../../../../image_utils.dart';
import '../../../../model/order_list_model.dart';
import '../../../../widget/image_util.dart';
import '../detail/view.dart';
import 'controller.dart';

class OrderListPage extends StatelessWidget {
  final ctr = Get.put(OrderListController());

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: "Order list".tr,
      body: Obx(() => ListView.separated(
            itemBuilder: (c, i) => itemWidget(ctr.list[i]),
            separatorBuilder: (c, i) => 12.verticalSpace,
            itemCount: ctr.list.length,
          )),
    );
  }

  Widget itemWidget(OrderListModel model) => InkWell(
        onTap: () =>
            Get.to(() => OrderDetailPage(), arguments: model.id),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          padding: EdgeInsets.symmetric(
            horizontal: 14.w,
            vertical: 16.h,
          ),
          decoration: ShapeDecoration(
            color: Color(0xFF141517),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${model.orderTime}',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 12.sp,
                        fontFamily: FONT_MEDIUM,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Text(
                    '${model.status}',
                    style: TextStyle(
                      color: Color(0xFFFFB20E),
                      fontSize: 14.sp,
                      fontFamily: FONT_MEDIUM,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
              ),
              14.verticalSpace,
              _goodListItemWidget(model),
              Container(
                height: 1.h,
                decoration: BoxDecoration(color: Color(0xFF2F2F2F)),
              ),
              Row(
                children: [
                  Text(
                    '${model.items.length}',
                    style: TextStyle(
                      color: Color(0xFFFFB20E),
                      fontSize: 14.sp,
                      fontFamily: FONT_MEDIUM,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  5.horizontalSpace,
                  Text(
                    'item in total',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 14.sp,
                      fontFamily: FONT_MEDIUM,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  14.horizontalSpace,
                  Expanded(
                    child: Text(
                      '£${model.total}',
                      style: TextStyle(
                        color: Color(0xFFFFB20E),
                        fontSize: 20.sp,
                        fontFamily: FONT_MEDIUM,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    width: 120.w,
                    height: 34.h,
                    margin: EdgeInsets.symmetric(vertical: 14.h),
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 1.w,
                          color: Color(0xFFFFB20E),
                        ),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Detail',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFFFFB20E),
                        fontSize: 14.sp,
                        fontFamily: FONT_LIGHT,
                        fontWeight: FontWeight.w400,
                        letterSpacing: -0.41,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      );

  Widget _goodListItemWidget(OrderListModel model) => Obx(() => SizedBox(
        height:
            model.items.length > 1 ? model.goodsItemTotalHeight.value : 100.h,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (c, i) => Row(
                children: [
                  ImageUtil.networkImage(
                    url: '${model.items[i].picUrl}',
                    width: 65.w,
                    height: 65.w,
                  ),
                  10.horizontalSpace,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${model.items[i].name}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontFamily: FONT_MEDIUM,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        8.verticalSpace,
                        Text(
                          '£${model.items[i].retailPrice}',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 12.sp,
                            fontFamily: FONT_MEDIUM,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'X${model.items[i].num}',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 12.sp,
                      fontFamily: FONT_MEDIUM,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              separatorBuilder: (c, i) => 12.verticalSpace,
              itemCount: model.items.length,
            ),
            Visibility(
              visible: model.items.length > 1,
              child: Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: InkWell(
                  onTap: () => ctr.showOrHideItem(model),
                  child: Container(
                    height: 80.h,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Color(0xff141517)],
                      ),
                    ),
                    child: Image.asset(
                      model.showOrHide.value
                          ? ImageUtils.order_less_icon
                          : ImageUtils.order_more_icon,
                      scale: 1.5,
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: false,
              child: Container(
                height: model.goodsItemTotalHeight.value,
              ),
            ),
          ],
        ),
      ));
}
