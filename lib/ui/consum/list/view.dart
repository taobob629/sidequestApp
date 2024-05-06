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

import '../../../common/base_controller.dart';
import '../../../common/refresh_list.dart';
import '../../../common/styles.dart';
import '../../../config/icon_font.dart';
import '../../../model/consum_model.dart';
import '../../../widget/views.dart';
import 'controller.dart';

class StoreConsumListPage extends StatelessWidget {

  final controller = Get.put(StoreConsumListPageController());

  body(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) {
        var model = controller.mDatas[index];
        return SizedBox(
          width: Get.width,
          child: InkWell(
            child: item(model),
            onTap: () => controller.toDetail(model),
          ),
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
          enablePullUp: false,
          onRefresh: () {
            controller.onRefresh();
          },
        ));
  }

  item(ConsumListBean model) {
    return innnerBg(Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(17.r),
              child: CachedNetworkImage(
                  imageUrl: model.cover,
                  width: 65.w,
                  height: 65.w,
                  fit: BoxFit.cover),
            ),
            10.horizontalSpace,
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.gameName,
                  style: TextStyle(fontFamily: FONT_MEDIUM),
                ),
                14.verticalSpace,
                Text(
                  '${model.formatGameTime()}',
                  style: TextStyle(
                      color: Color(0xffFFCB0E), fontFamily: FONT_BLACK),
                )
              ],
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'.tr),
      ),
      body: buildBody(context),
    );
  }
}
