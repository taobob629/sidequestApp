/*
  view
  sidequest_hub_app
  desc:
  Created by chunma on .
  Copyright © sidequest_hub_app. All rights reserved.
*/
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wy/common/base_controller.dart';
import 'package:wy/common/list/index.dart';
import 'package:wy/common/page/basePage.dart';
import 'package:wy/config/icon_font.dart';
import 'package:wy/model/service_list_model.dart';
import 'package:wy/res/dimens.dart';
import 'package:wy/res/styles.dart';
import 'package:wy/utils/index.dart';
import 'package:wy/widget/refresh_list.dart';

import 'controller.dart';

class OrderListListPage extends BasePage {
  var type;
  OrderListController? controller;

  OrderListListPage(this.type);

  body(BuildContext context) {
    return contentPadding(
        child: ListView.separated(
      itemBuilder: (context, index) {
        var model = pageController().mDatas[index];
        return Container(
          width: Get.width,
          child: InkWell(child: item(model),onTap: ()=>controller?.toDetail(model),),
        );
      },
      itemCount: pageController().mDatas.length,
      separatorBuilder: (BuildContext context, int index) => Divider(color: Colors.transparent,height: 15.h,),
    ));
  }

  @override
  Widget buildBody(BuildContext context) {
    return biuldSmartRefresh(
        pageController().refreshController!!,
        pageController().pageState == PageState.sucess
            ? body(context)
            : pageController().buildEmpty(),
        onRefresh: () {
          pageController().onRefresh();
        },
        onLoad: () => pageController().onLoadMore());
  }

  @override
  RefreshListController pageController() {
    try {
      controller = Get.find<OrderListController>(tag: 'OrderList_$type');
      return controller!;
    } catch (e) {
      flog('$e');
      controller = Get.put(OrderListController(type), tag: 'OrderList_$type');
      controller!.refreshController = RefreshController(initialRefresh: false);
      return controller!;
    }
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
                decoration: ShapeDecoration(shape: StadiumBorder(), color: model.statusColor())),
            10.horizontalSpace,
            Text(
              '${orderStatusMap[model.status]}',
              style: TextStyle(color: Colors.white, fontFamily: FONT_MEDIUM, fontSize: 13.sp),
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
            ImageUtil.networkImage(url: model.icon, border: 17.r, width: 70.w, height: 70.w,fit: BoxFit.cover),
            10.horizontalSpace,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  '${model.gameName}',
                  style: TextStyle(color: Colors.white, fontSize: 14.sp, fontFamily: FONT_MEDIUM),
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
                              color: Colors.white, fontSize: 12.sp, fontFamily: FONT_MEDIUM)),
                      TextSpan(
                          text: '/${model.unit}',
                          style: TextStyle(
                              color: Colors.white, fontSize: 12.sp, fontFamily: FONT_MEDIUM)),
                    ])),
                    //  Spacer(),
                  ],
                ),
              ],
            ),
            Spacer(),
            Text(
              'X${model.amount}',
              style: TextStyle(color: Colors.white, fontSize: 12.sp, fontFamily: FONT_MEDIUM),
            )
          ],
        )
      ],
    ));
  }

  Widget innnerBg(Widget view) {
    return Container(
      padding: itemPadding10,
      decoration: itemDecoration(color: Color(0xFF262731), radius: 17.r),
      child: view,
    );
  }
}
