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
import 'package:sq_hub_app/common/string_ext.dart';
import 'package:sq_hub_app/image_utils.dart';

import '../../../common/base_controller.dart';
import '../../../common/refresh_list.dart';
import '../../../common/styles.dart';
import '../../../config/icon_font.dart';
import '../../../model/consum_model.dart';
import '../../../widget/views.dart';
import 'controller.dart';

class StoreConsumDetailPage extends StatelessWidget {
  final controller = Get.put(StoreConsumDetailPageController());

  body(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) {
        var model = controller.mDatas[index];
        return Container(
          width: Get.width,
          child: item(model),
        );
      },
      itemCount: controller.mDatas.length ?? 0,
      separatorBuilder: (BuildContext context, int index) => Divider(
        color: Colors.transparent,
        height: 15.h,
      ),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return Obx(() => biuldSmartRefresh(
        controller.refreshController,
        controller.pageState == PageState.sucess
            ? body(context)
            : controller.pageState == PageState.empty
                ? controller.buildEmpty()
                : buildLoad(),
        onRefresh: () {
          controller.onRefresh();
        },
        onLoad: () => controller.onLoadMore()));
  }

  item(ConsumListBean model) {
    return innnerBg(Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        6.verticalSpace,
        Row(
          children: [
            Image.asset(ImageUtils.ic_store, width: 16, height: 16),
            10.horizontalSpace,
            Text(
              '${model.storeName}',
              style:
                  TextStyle(fontFamily: FONT_MEDIUM, color: Color(0xffB2B9C9)),
            ),
          ],
        ),
        10.verticalSpace,
        listDivider,
        10.verticalSpace,
        Text(
          '${model.gameName}',
          style: TextStyle(fontFamily: FONT_MEDIUM),
        ),
        10.verticalSpace,
        Text(
          '${model.formatGameTime()}',
          style: TextStyle(color: Color(0xffFFCB0E), fontFamily: FONT_MEDIUM),
        ),
        10.verticalSpace,
        Text(
          '${model.start.toDateStr}-${model.end.toDateStr}',
          style: TextStyle(
              color: Color(0xffB2B9C9),
              fontFamily: FONT_MEDIUM,
              fontSize: 12.sp),
        ),
        6.verticalSpace
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${Get.arguments['gameName']}'),
      ),
      body: buildBody(context),
    );
  }
}
