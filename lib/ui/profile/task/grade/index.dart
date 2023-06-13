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
import 'package:wy/model/user_info_model.dart';
import 'package:wy/utils/index.dart';
import 'package:wy/widget/arc_progressbar_widget.dart';
import 'package:wy/widget/linear_progressbar_widget.dart';
import 'package:wy/widget/paixs_widget.dart';
import 'package:wy/widget/views.dart';
import 'controller.dart';

class GradeTaskPage extends GetView<GradeTaskController> {
  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImageUtil.imageResStr('grade_task_bg')),
            fit: BoxFit.fill, // 完全填充
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: Text('Task'.tr, style: TextStyle(fontSize: 18)),
            centerTitle: true,
            elevation: 0,
          ),
          body: Obx(() => controller.isLoadding
              ? buildLoad()
              : Column(
                  //  shrinkWrap: true,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 180.h,
                              width: Get.width,
                              alignment: Alignment.center,
                              child: Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      image: new DecorationImage(
                                        scale: 3,
                                        fit: BoxFit.scaleDown,
                                        image: AssetImage(controller.centerImg()),
                                      ),
                                    ),
                                    width: 132.w,
                                    child: ArcProgressBar(
                                      progress: 10,
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
                                                  image: AssetImage(controller.curLevelImg()),
                                                  height: 20.h,
                                                )
                                          : Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Spacer(),
                                                Image(
                                                  image: AssetImage(controller.curLevelImg()),
                                                  height: 13.h,
                                                ),
                                                Spacer(),
                                                Image(
                                                  image: AssetImage(controller.nextLevelImg()),
                                                  height: 13.h,
                                                ),
                                                Spacer()
                                              ],
                                            )),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    Center(
                      child: LinearProgressBar(
                        width: 150.w,
                        progress: 80,
                        height: 6.h,
                      ),
                    ),
                    10.verticalSpace,
                    Text.rich(TextSpan(children: [
                      TextSpan(text: 'Almost', style: testStyle1()),
                      TextSpan(text: '48', style: testStyle2()),
                      TextSpan(text: 'points experience to', style: testStyle1()),
                      TextSpan(text: 'VIP2', style: testStyle2()),
                    ])),
                    27.verticalSpace,
                    Container(
                      margin: EdgeInsets.all(15.r),
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFF31273E),
                              Color(0xFF19122E),
                              Color(0xFF1A1534),
                            ],
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(15.r)),
                          border: Border.all(color: Color(0xff6f595b), width: 1)),
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          Container(
                            height: 32.h,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(ImageUtil.imageResStr('grade_task_header')),
                                fit: BoxFit.fitHeight, // 完全填充
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )),
        ),
      );

  TextStyle testStyle1() => TextStyle(fontSize: 12.sp, fontFamily: FONT_BLACK);

  TextStyle testStyle2() =>
      TextStyle(fontSize: 12.sp, fontFamily: FONT_BLACK, color: Color(0xffFFD20E));

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
            PWidget.text('Next Level'.tr, [Colors.white, 18, true], {'ff': 'DIN'})
          ],
        ));
  }
}
