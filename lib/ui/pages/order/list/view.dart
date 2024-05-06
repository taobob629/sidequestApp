/*
  view
  sidequest_hub_app
  desc:
  Created by chunma on .
  Copyright © sidequest_hub_app. All rights reserved.
*/
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../common/basePage.dart';
import '../../../../common/base_controller.dart';
import '../../../../common/refresh_list.dart';
import '../../../../common/refreshlist_controller.dart';
import '../../../../common/styles.dart';
import '../../../../config/icon_font.dart';
import '../../../../model/service_list_model.dart';
import '../../../../utils/utils.dart';
import 'controller.dart';

class OrderListListPage extends BasePage {
  var type;
  var status;
  OrderListController? controller;

  OrderListListPage(this.type, this.status);

  body(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) {
        var model = controller?.mDatas[index];
        return Container(
          width: Get.width,
          child: InkWell(
            child: item(model!),
            onTap: () => controller?.toDetail(model!),
          ),
        );
      },
      itemCount: controller?.mDatas.length ?? 0,
      separatorBuilder: (BuildContext context, int index) => Divider(
        color: Colors.transparent,
        height: 15.h,
      ),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return biuldSmartRefresh(
        controller?.refreshController,
        controller?.pageState == PageState.sucess
            ? body(context)
            : controller?.buildEmpty(),
        onRefresh: () {
          controller?.onRefresh();
        },
        onLoad: () => controller?.onLoadMore());
  }

  @override
  RefreshListController pageController() {
    if (controller != null) return controller!;
    flog('OrderList_$type');
    controller =
        Get.put(OrderListController(type, status), tag: 'OrderList_$type');
    controller?.refreshController = RefreshController(initialRefresh: false);
    return controller!;
    //  }
  }

  item(ServiceListModel model) {
    return innnerBg(Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
                height: 10.w,
                width: 10.w,
                decoration: ShapeDecoration(
                    shape: StadiumBorder(), color: model.statusColor())),
            10.horizontalSpace,
            Text(
              '${orderStatusMap[model.status]}',
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: FONT_MEDIUM,
                  fontSize: 13.sp),
            ),
            Spacer(),
            Text(
              '${model.time}',
              style: TextStyle(color: Color(0xFFB2B9C9), fontSize: 11.sp),
            )
          ],
        ),
        10.verticalSpace,
        listDivider,
        10.verticalSpace,
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(17.r),
              child: CachedNetworkImage(
                imageUrl: model.icon,
                width: 70.w,
                height: 70.w,
                fit: BoxFit.cover,
              ),
            ),
            10.horizontalSpace,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  '${model.gameName}',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontFamily: FONT_MEDIUM),
                ),
                16.verticalSpace,
                Row(
                  children: [
                    Image(
                      image: AssetImage('assets/images/ic_balance_money.webp'),
                      width: 15,
                      height: 15,
                    ),
                    3.horizontalSpace,
                    Text.rich(TextSpan(children: [
                      TextSpan(
                          text: '${model?.price}',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.sp,
                              fontFamily: FONT_MEDIUM)),
                      TextSpan(
                          text: '/${model.unit}',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.sp,
                              fontFamily: FONT_MEDIUM)),
                    ])),
                    //  Spacer(),
                  ],
                ),
              ],
            ),
            Spacer(),
            Text(
              'X${model.amount}',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.sp,
                  fontFamily: FONT_MEDIUM),
            )
          ],
        )
      ],
    ));
  }

  Widget innnerBg(Widget view) {
    return Container(
      margin: EdgeInsets.only(left: 15, right: 15).r,
      padding: itemPadding10,
      decoration: itemDecoration(color: Color(0xFF262731), radius: 17.r),
      child: view,
    );
  }
}
