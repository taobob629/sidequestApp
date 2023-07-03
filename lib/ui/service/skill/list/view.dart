/*
  view
  sidequest_hub_app
  desc:
  Created by chunma on .
  Copyright © sidequest_hub_app. All rights reserved.
*/

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:wy/common/page/empty_view.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/config/icon_font.dart';
import 'package:wy/model/skill_item_model.dart';
import 'package:wy/model/skill_model.dart';
import 'package:wy/res/index.dart';
import 'package:wy/ui/common/floating_button.dart';
import 'package:wy/ui/playwith/balance/widget/tips_dialog.dart';
import 'package:wy/ui/service/add/add_game_page.dart';
import 'package:wy/utils/global_key_constants.dart';
import 'package:wy/utils/index.dart';
import 'package:wy/widget/paixs_widget.dart';
import 'package:wy/widget/profile/header_widget.dart';
import 'package:wy/widget/route.dart';
import 'package:wy/widget/scaffold_widget.dart';
import 'package:wy/widget/views.dart';

import 'controller.dart';
import 'widget/service_header.dart';

class SkillListPage extends GetView<SkillListPageController> {
  bool tabWidget = false; //如果是tab内，不需要titilebar

  SkillListPage({this.tabWidget = false});

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      autoPlay: true,
      autoPlayDelay: Duration(seconds: 5),
      onFinish: () => StorageManager.setBoolValue('sideKickAddServiceKey', true),
      builder: Builder(builder: (builder){
        controller.myContext = builder;
        return ScaffoldWidget(
            appBar: tabWidget
                ? null
                : AppBar(
              title: Text('SideKick'.tr),
              elevation: 0,
            ),
            btnBar: Showcase(
              overlayOpacity: 0,
              key: GlobalKeyConstants.sideKickAddServiceKey,
              description: 'Click to apply for companionship'.tr,
              child: FloatingButton(
                onTap: () async {
                  controller.addGame();
                },
                label: 'Add Service'.tr,
              ),
            ),
            body: Container(
              padding: EdgeInsets.all(20),
              child: NestedScrollView(
                  headerSliverBuilder: (context, _) => [
                    SliverToBoxAdapter(
                      child: ProfileHeaderWidget(),
                    ),
                    SliverToBoxAdapter(
                      child: ServiceHeader(),
                    )
                  ],
                  body: Obx(
                        () => controller.pageState == SkillListPageController.INIT
                        ? buildLoad()
                        : controller.list.isEmpty
                        ? EmptyView()
                        : MediaQuery.removePadding(
                        removeTop: true,
                        context: context,
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemBuilder: (context, index) => item(index),
                          separatorBuilder: (context, index) => Container(
                            height: 10.h,
                          ),
                          itemCount: controller.list.length,
                        )),
                  )),
            ));
      }),
    );
  }

  Divider divider = Divider(color: Color(0xFF54555d), height: 1.h);

  Widget item(int index) {
    var data = controller.list[index];
    return Container(
      //  margin: EdgeInsets.all(20).r,
      padding: EdgeInsets.only(left: 10, right: 10, top: 12, bottom: 10).r,
      decoration: itemDecoration(color: Color(0xFF2D2E3C), radius: 15.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ImageUtil.networkImage(
                  url: data.skillThumb ?? '',
                  fit: BoxFit.cover,
                  border: 8.5,
                  width: 50,
                  height: 50),
              10.horizontalSpace,
              Expanded(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    '${data.skillName}',
                    style: TextStyle(fontFamily: FONT_MEDIUM, fontSize: 14.sp),
                  ),
                  Text(
                    '${data.levelName}',
                    style: TextStyle(
                        fontFamily: FONT_MEDIUM,
                        fontSize: 10.sp,
                        color: AppColor.textC3),
                  ),
                ],
              )),
              editStatus(data),
              addStatus(data)
            ],
          ),
          5.verticalSpace,
          divider,
          if (data.status == SkillModel.ONGOING)
            Container(
              padding: EdgeInsets.only(left: 5.w, top: 5).h,
              child: Row(
                children: [
                  ImageUtil.assetImage('ic_under_review',
                      width: 13.w, height: 13.w),
                  4.horizontalSpace,
                  Text(
                    'under review'.tr,
                    style: TextStyle(
                        color: Color(0xFF3F92FF),
                        fontSize: 10.sp,
                        fontFamily: FONT_LIGHT),
                  )
                ],
              ),
            ),
          if (data.status == SkillModel.DENIED)
            Container(
              padding: EdgeInsets.only(left: 5.w, top: 5).h,
              child: Row(
                children: [
                  Visibility(
                    visible: data.status == 2,
                    child: GestureDetector(
                      onTapDown: (details) {
                        print(details.globalPosition);
                        Get.dialog(TipsDialog(
                          offset: details.globalPosition,
                          tips: data.reason ?? "",
                        ));
                      },
                      child: ImageUtil.assetImage('ic_info_red',
                          width: 13.w, height: 13.w),
                    ),
                  ),
                  4.horizontalSpace,
                  Text(
                    'REJECT'.tr,
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 10.sp,
                        fontFamily: FONT_LIGHT),
                  )
                ],
              ),
            ),
          _skill_items(data)
        ],
      ),
    );
  }

  Widget editStatus(SkillModel data) {
    return data.status == SkillModel.PASS || data.status == SkillModel.DENIED
        ? InkWell(
            onTap: () {
              jumpPage(AddGamePage(data.toJson()), callback: (res) {
                flog('Get.ard ${Get.arguments}');
                if (res != null) controller.onRefresh();
              });
            },
            child: Container(
              width: 32.w,
              margin: EdgeInsets.only(right: 15.w),
              height: 32.w,
              padding: EdgeInsets.all(10),
              decoration: itemDecoration(color: AppColor.yellow, radius: 16.w),
              child:
                  ImageUtil.assetImage('ic_edit2', width: 13.w, height: 13.w),
            ),
          )
        : Container();
  }

  Widget addStatus(SkillModel data) {
    return data.status == SkillModel.PASS && data.addServiceItem == 0
        ? InkWell(
            onTap: () => controller.addSkillItem(data),
            child: Container(
              width: 32.w,
              height: 32.w,
              decoration:
                  itemDecoration(color: Color(0xFF54555d), radius: 16.w),
              child: Icon(Icons.add_outlined, size: 20.w, color: Colors.white),
            ),
          )
        : Container();
  }

  _skill_items(SkillModel data) {
    var skillItems = data.childItemVoList;
    if (skillItems.isEmpty) return Container();
    return ListView.separated(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        var item = skillItems[index];
        return skill_item(data, item);
      },
      separatorBuilder: (BuildContext context, int index) => divider,
      itemCount: skillItems.length,
    );
  }

  Widget skill_item(SkillModel data, SkillItemModel? item,
      {bool showAdd = false}) {
    double icon_size = 13;
    return Container(
      padding: EdgeInsets.only(top: 5, bottom: 5).r,
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // PWidget.text('', [], {
          //   'exp': true
          // }, [
          //   PWidget.textIs('${item?.name}', [Colors.white]),
          //   // if (item.enabled == 0) PWidget.textIs('\t\t' + 'Disabled'.tr, [Colors.red]),
          // ]),
          Transform.scale(
            scale: 0.6,
            child: Obx(() => CupertinoSwitch(
                activeColor: Colors.green,
                value: item?.enabled == 1,
                onChanged: (value) {
                  controller.changeServiceStatus(item, value);
                })),
          ),
          Container(
            constraints: BoxConstraints(maxWidth: 150.w),
            child: Text(
              '${item?.name}',
              style: TextStyle(
                  fontSize: 14.sp,
                  fontFamily: FONT_LIGHT,
                  overflow: TextOverflow.ellipsis),
            ),
          ),
          10.horizontalSpace,
          Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (item != null)
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
                          text: '${item?.price?.floor()}',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontFamily: FONT_MEDIUM)),
                      TextSpan(
                          text: '/${item?.unit}',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 8.sp,
                              fontFamily: FONT_MEDIUM)),
                    ])),
                  ],
                ),
              PWidget.boxw(5),
              if (item != null)
                GestureDetector(
                    onTap: () =>
                        controller.addSkillItem(data, skillItemModel: item),
                    child: Container(
                      height: 13.w,
                      width: 13.w,
                      child: ImageUtil.assetImage('ic_edit2',
                          width: 13.w, height: 13.w, color: Color(0xFF6F6F75)),
                    )),
            ],
          ),
        ],
      ),
    );
  }
}
