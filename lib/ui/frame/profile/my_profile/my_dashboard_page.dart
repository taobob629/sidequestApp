import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/config/app_pages.dart';
import 'package:wy/ui/controller/user_controller.dart';
import 'package:wy/ui/frame/profile/model/profile_model.dart';

import '../../../../config/app_color.dart';
import '../../../../config/icon_font.dart';
import 'badges_widget.dart';
import 'my_profile_page.dart';

class MyDashboardPage extends StatelessWidget {
  MyDashboardPage({Key? key}) : super(key: key);

  final t = ProfileController.find;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// Subscriptions
        Obx(() => Visibility(
            visible: UserController.find.online.value,
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 0.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(
                      left: 15.w,
                      bottom: 10.h,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 6.w,
                          height: 18.h,
                          margin: EdgeInsets.only(right: 4.w,),
                          color: hexColor('FFB20E'),
                        ),
                        Text(
                          'SUBSCRIPTIONS'.tr,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontFamily: FONT_MEDIUM,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Obx(() => Container(
                        width: Get.width,
                        height: 100.h,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: UserController.find.userProfile.vips
                              .asMap()
                              .map((index, value) => MapEntry(
                                  index,
                                  InkWell(
                                    onTap: () => Get.toNamed(AppPages.VIP_PAGE,
                                        arguments: index),
                                    child: _subscriptionItem(value, index),
                                  )))
                              .values
                              .toList(),
                        ),
                      ))
                ],
              ),
            ))),

        /// Trophies
        // ...UserController.find.userProfile.badges
        //     .map((badge) => BadgesWidget(badge))
        //     .toList(),
        if (UserController.find.userProfile.badges.isNotEmpty)
          BadgesWidget(UserController.find.userProfile.badges[0]),
      ],
    );
  }

  Widget _subscriptionItem(VipModel vipModel, int index) {
    return Container(
      width: 90.h,
      margin: EdgeInsets.only(left: 12.w),
      decoration: BoxDecoration(
        border: Border.all(
          color: Color(0xff707070),
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/profile/icon_level_${vipModel.level}.webp",
            width: 26,
          ),
          3.verticalSpace,
          Text(
            vipModel.name,
            style: TextStyle(
                color: Colors.white,
                fontSize: 10.sp,
                fontWeight: FontWeight.bold),
          ),
          Container(
            width: 56.w,
            height: 24.h,
            margin: EdgeInsets.only(
              left: 10,
              right: 10,
              top: 10.h,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              gradient:
                  vipModel.level <= UserController.find.userProfile.vipLevel
                      ? LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [Color(0xff707070), Color(0xff707070)])
                      : LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                              Color(0xFF632BDA),
                              Color(0xFF6029D4),
                              Color(0xFF652CDF),
                              Color(0xFF7231DE),
                              Color(0xFF8A39DE),
                              Color(0xFFBE38D0),
                              Color(0xFFDE5D85),
                              Color(0xFFE68887)
                            ]),
            ),
            alignment: Alignment.center,
            child: Text(
              "£${vipModel.price}",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}
