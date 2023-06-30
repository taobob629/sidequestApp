/*
  index
  sidequest_hub_app
  desc:
  Created by chunma on .
  Copyright © sidequest_hub_app. All rights reserved.
*/
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/model/user_info_model.dart';
import 'package:wy/ui/profile/grade/controller.dart';
import 'package:wy/utils/index.dart';
import 'package:wy/widget/arc_progressbar_widget.dart';
import 'package:wy/widget/home/level.dart';
import 'package:wy/widget/paixs_widget.dart';
import 'package:wy/widget/tips_widget.dart';
import 'package:wy/widget/views.dart';

class GradePage extends GetView<GradeController> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Medal'.tr, style: TextStyle(fontSize: 18)),
          centerTitle: true,
          elevation: 0,
        ),
        body: Obx(() => controller.isLoadding
            ? buildLoad()
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 230,
                            width: Get.width,
                            alignment: Alignment.center,
                            child: Stack(
                              fit: StackFit.loose,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    image: new DecorationImage(
                                      scale: controller.isVip() ? 1.8 : 0.6,
                                      fit: BoxFit.scaleDown,
                                      image: AssetImage(controller.centerImg()),
                                    ),
                                  ),
                                  width: 212,
                                  child: ArcProgressBar(
                                    progress: controller.model.percent,
                                  ),
                                ),
                                Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: controller.isTopLevel()
                                        ? controller.isVip()
                                            ? Container()
                                            : UnconstrainedBox(
                                                child: userIcon(
                                                    controller.model.userLevel),
                                              )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Spacer(),
                                              controller.isVip()
                                                  ? Image(
                                                      image: AssetImage(
                                                          controller
                                                              .curLevelImg()),
                                                      height: 23,
                                                    )
                                                  : userIcon(controller
                                                      .model.userLevel),
                                              Spacer(),
                                              controller.isVip()
                                                  ? Image(
                                                      image: AssetImage(
                                                          controller
                                                              .nextLevelImg()),
                                                      height: 23,
                                                    )
                                                  : userIcon(controller
                                                          .model.userLevel +
                                                      1),
                                              Spacer()
                                            ],
                                          )),
                                Positioned(
                                  left: 10,
                                  right: 10,
                                  bottom: 22,
                                  child: Visibility(
                                      visible: controller.isauth == TYPE_VIP,
                                      child: Center(
                                        child: PWidget.text(
                                            '${'LEVEL'.tr}${controller.model.userLevel}',
                                            [Colors.white, 18, true],
                                            {'ff': 'DIN'}),
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  PWidget.boxh(40),
                  TipsWidegt(
                    custumTitle: PWidget.text(
                        '${controller.isTopLevel() ? 'Top level'.tr : 'Current level'.tr}',
                        [Colors.white, 18, true],
                        {'ff': 'DIN'}),
                    tips:
                        '${'Platform fee'.tr}:${controller.model.currentRate}',
                  ),
                  Offstage(
                      offstage: controller.isTopLevel() && controller.isVip(),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: controller.isVip()
                            ? [
                                buildScoreItem('Order Quantity'.tr,
                                    controller.model.levelNum,
                                    showIcon: false)
                              ]
                            : [
                                buildScoreItem(
                                  'Recharge'.tr,
                                  controller.model.levelNum,
                                ),
                                buildScoreItem(
                                    'Consumption'.tr, controller.model.levelNum)
                              ],
                      )),
                  Offstage(
                    offstage: controller.isTopLevel() && controller.isVip(),
                    child: nextLevelButton(),
                  ),
                  Offstage(
                      offstage: controller.isTopLevel(),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: controller.isVip()
                            ? [
                                buildScoreItem('Order Quantity'.tr,
                                    controller.model.nextLevelNum,
                                    showIcon: false)
                              ]
                            : [
                                buildScoreItem('Recharge'.tr,
                                    controller.model.nextLevelNum),
                                buildScoreItem('Consumption'.tr,
                                    controller.model.nextLevelNum)
                              ],
                      ))
                ],
              )),
      );

  buildScoreItem(var title, var value, {var showIcon = true}) {
    return Expanded(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        PWidget.boxh(16),
        PWidget.text('$title', [Color.fromRGBO(255, 255, 255, 0.65), 14, true]),
        PWidget.boxh(8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (showIcon) ImageUtil.assetImage('coin_red', width: 20),
            if (showIcon) 5.horizontalSpace,
            PWidget.text('$value', [Colors.white, 30, true], {'ff': 'DIN'}),
          ],
        ),
        PWidget.boxh(10),
      ],
    ));
  }

  nextLevelButton() {
    return Visibility(
        visible: !controller.isTopLevel(),
        child: Column(
          children: [
            Image(
              image: AssetImage('assets/images/grade/arrow_down.webp'),
              height: 22,
            ),
            PWidget.boxh(22),
            TipsWidegt(
              custumTitle: PWidget.text(
                  'Next Level'.tr, [Colors.white, 18, true], {'ff': 'DIN'}),
              tips: '${'Platform fee'.tr}:${controller.model.nextRate}',
            ),
          ],
        ));
  }
}
