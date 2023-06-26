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
import 'package:wy/config/icon_font.dart';
import 'package:wy/image_utils.dart';
import 'package:wy/model/user_info_model.dart';
import 'package:wy/ui/profile/grade/controller.dart';
import 'package:wy/utils/index.dart';
import 'package:wy/widget/arc_progressbar_widget.dart';
import 'package:wy/widget/paixs_widget.dart';
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
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    image: new DecorationImage(
                                      scale:controller.isVip()?1.8: 0.6,
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
                                            : Image(
                                                image: AssetImage(
                                                    controller.curLevelImg()),
                                                height: 32,
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
                                                  : userIcon(controller.model.levelNum),
                                              Spacer(),
                                              controller.isVip()?Image(
                                                image: AssetImage(
                                                    controller.nextLevelImg()),
                                                height: 23,
                                              ):userIcon(controller.model.nextLevelNum),
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
                  PWidget.text(
                      '${controller.isTopLevel() ? 'Top level'.tr : 'Current level'.tr}',
                      [Colors.white, 18, true],
                      {'ff': 'DIN'}),
                  Offstage(
                      offstage: controller.isTopLevel() && controller.isVip(),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: controller.isVip()
                            ? [
                                buildScoreItem('Order Quantity'.tr,
                                    controller.model.levelNum)
                              ]
                            : [
                                buildScoreItem('Monthly recharge'.tr,
                                    controller.model.levelNum),
                                buildScoreItem('Monthly consumption'.tr,
                                    controller.model.levelNum)
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
                                    controller.model.nextLevelNum)
                              ]
                            : [
                                buildScoreItem('Monthly recharge'.tr,
                                    controller.model.nextLevelNum),
                                buildScoreItem('Monthly consumption'.tr,
                                    controller.model.nextLevelNum)
                              ],
                      ))
                ],
              )),
      );

  /**
   * 普通用户图标
   */
  userIcon(level) {
    return Container(
      height: 24,
      width: 74,
      padding: EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: getColors(level))),
      child: Row(
        children: [
          ImageUtil.assetImage('grade/VIP${level+1}', height: 22, width: 22),
          Spacer(),
          Text(
            'VIP',
            style: TextStyle(fontSize: 11.sp, fontFamily: FONT_MEDIUM),
          ),
        ],
      ),
    );
  }

  getColors(int level) {
    switch (level) {
      case 0:
      case 1:
        return [
          Color(0xffEDFEF6),
          Color(0xff5B6F75),
          // Color(0xffEDFEF6),
        ];
      case 2:
        return [
          Color(0xffF9EDFE),
          Color(0xff8F8AF4),
        ];
      case 3:
      case 4:
        return [
          Color(0xffFEEDFE),
          Color(0xffCD8AF4),
        ];
      case 5:
        return [
          Color(0xffD5EEFF),
          Color(0xff64BEEC),
        ];
      case 6:
      case 7:
      case 8:
        return [
          Color(0xffF8D5FF),
          Color(0xffA197FB),
        ];
      case 9:
      case 10:
      case 11:
      case 12:
        return [
          Color(0xffF5CD63),
          Color(0xffFFCF80),
          Color(0xffFFA1A1),
        ];
      default:
        return [
          Color(0xffF5CD63),
          Color(0xffFFCF80),
          Color(0xffFF6F6F),
        ];
    }
  }

  buildScoreItem(var title, var value) {
    return Expanded(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        PWidget.boxh(16),
        PWidget.text('$title', [Color.fromRGBO(255, 255, 255, 0.65), 14, true]),
        PWidget.boxh(8),
        PWidget.text('$value', [Colors.white, 30, true], {'ff': 'DIN'}),
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
            PWidget.text(
                'Next Level'.tr, [Colors.white, 18, true], {'ff': 'DIN'})
          ],
        ));
  }
}
