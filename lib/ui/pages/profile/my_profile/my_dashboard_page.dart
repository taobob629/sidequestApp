import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../config/app_color.dart';
import '../../../../config/icon_font.dart';
import '../../../../controller/user_controller.dart';
import '../../../../model/profile_model.dart';
import '../vip/vip_page.dart';
import 'badges_widget.dart';
import 'my_profile_page.dart';

class MyDashboardPage extends StatelessWidget {
  MyDashboardPage({Key? key}) : super(key: key);

  final t = ProfileController.find;

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
      children: [
        /// Subscriptions
        Container(
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
                      width: 4.w,
                      height: 16.h,
                      margin: EdgeInsets.only(
                        right: 4.w,
                      ),
                      color: hexColor('FFB20E'),
                    ),
                    Text(
                      'SUBSCRIPTIONS'.tr,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontFamily: FONT_MEDIUM,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  12.horizontalSpace,
                  if (UserController.find.userProfile.vips.length > 0)
                    _subscriptionItem(
                        UserController.find.userProfile.vips[0], 0),
                  8.horizontalSpace,
                  if (UserController.find.userProfile.vips.length > 1)
                    _subscriptionItem(
                        UserController.find.userProfile.vips[1], 1),
                  8.horizontalSpace,
                  if (UserController.find.userProfile.vips.length > 2)
                    _subscriptionItem(
                        UserController.find.userProfile.vips[2], 2),
                  8.horizontalSpace,
                  if (UserController.find.userProfile.vips.length > 3)
                    _subscriptionItem(
                        UserController.find.userProfile.vips[3], 3),
                  12.horizontalSpace,
                ],
              ),

              // Obx(() => Container(
              //       width: Get.width,
              //       height: 100.h,
              //       child: ListView(
              //         scrollDirection: Axis.horizontal,
              //         physics: NeverScrollableScrollPhysics(),
              //         children: UserController.find.userProfile.vips
              //             .asMap()
              //             .map((index, value) => MapEntry(
              //                 index,
              //                 InkWell(
              //                   onTap: () => Get.toNamed(AppPages.VIP_PAGE,
              //                       arguments: index),
              //                   child: _subscriptionItem(value, index),
              //                 )))
              //             .values
              //             .toList(),
              //       ),
              //     ))
            ],
          ),
        ),

        /// Trophies
        ...UserController.find.userProfile.badges
            .map((badge) => BadgesWidget(badge))
            .toList(),
      ],
    ));
  }

  Widget _subscriptionItem(VipModel vipModel, int index) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          border: Border.all(
            color: Color(index % 2 == 0
                ? 0xffFFD2B2
                : index % 3 == 0
                ? 0xff94D1FF
                : 0xffD6D6D6),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(15.r),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: index % 2 == 0
                ? [hexColor('262731'), hexColor('604C3B')]
                : index % 3 == 0
                ? [hexColor('262731'), hexColor('3C5365')]
                : [hexColor('262731'), hexColor('494949')],
          ),
        ),
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => Get.to(() => VipPage(), arguments: index),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/huizhang_${vipModel.level}.webp",
                height: 26.h,
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
        ),
      ),
    );
  }
}
