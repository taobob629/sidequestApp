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
              margin: EdgeInsets.only(top: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Visibility(
                    visible: UserController.find.userProfile.vips.isNotEmpty,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(
                        left: 15.w,
                        bottom: 17.h,
                      ),
                      child: Text(
                        'SUBSCRIPTIONS'.tr,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontFamily: FONT_MEDIUM,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: UserController.find.userProfile.vips.isNotEmpty,
                    child: Container(
                      height: 140.h,
                      margin: EdgeInsets.only(left: 16.w),
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (c, i) => _subscriptionItem(
                            UserController.find.userProfile.vips[i], i),
                        separatorBuilder: (c, i) => 12.horizontalSpace,
                        itemCount: UserController.find.userProfile.vips.length,
                      ),
                    ),
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
        width: 124.w,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
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
                height: 33.h,
              ),
              15.verticalSpace,
              Text(
                vipModel.name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                width: 56.w,
                height: 24.h,
                margin: EdgeInsets.only(
                  left: 10,
                  right: 10,
                  top: 10.h,
                ),
                alignment: Alignment.center,
                child: Text(
                  "£${vipModel.price}",
                  style: TextStyle(
                    color: AppColor.yellow,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: FONT_MEDIUM,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
