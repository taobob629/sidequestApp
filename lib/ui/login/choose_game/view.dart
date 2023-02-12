import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/model/game_model.dart';
import 'package:wy/widget/stadium_button.dart';

import 'controller.dart';
import 'widget/item.dart';

class ChooseGamesPage extends GetView<ChooseGamePageController> {
  final data = List.generate(128, (i) => Color(0xFFFF00FF - 2 * i));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left: 22.5, right: 22.5).r,
        height: Get.height,
        child: Column(
          children: [
            Container(
                height: Get.height - 70.h,
                child: NestedScrollView(
                    headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                      return [
                        SliverToBoxAdapter(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              40.verticalSpace,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                      onPressed: () => Get.back(),
                                      icon: Icon(
                                        Icons.close,
                                        size: 17.w,
                                        color: AppColor.whiteGray,
                                      )),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Choose games\n you like',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17.sp,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        //
                      ];
                    },
                    body: Obx(()=>GridView.count(
                      padding: EdgeInsets.only(top: 20.h),
                      crossAxisCount: 3,
                    //  mainAxisSpacing: 20.h,
                      crossAxisSpacing: 10.w,
                      childAspectRatio: 52 / 90,
                      children: controller.games.map((item) => _buildItem(item)).toList(),
                    )))),
            Expanded(
                child: Container(
              padding: EdgeInsets.only(bottom: 20.h, top: 10.h),
              child: StadiumButton(
                'Follow 4 games',
                width: Get.width - 44.w,
                onTap: () {},
              ),
            ))
          ],
        ),
      ),
    );
  }

  Widget _buildItem(SimpleGameModel item) => GameWidget(item);
}
