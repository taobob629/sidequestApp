import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sq_hub_app/image_utils.dart';

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
                        bottom: 15.h,
                        right: 15.w,
                      ),
                      child: Row(
                        children: [
                          Expanded(
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
                          Image.asset(
                            "assets/images/huizhang_${UserController.find.userProfile.vipLevel}.webp",
                            height: 14.h,
                          ),
                          4.horizontalSpace,
                          Text(
                            t.getMembership(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13.sp,
                              fontFamily: FONT_MEDIUM,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: UserController.find.userProfile.vips.isNotEmpty,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          16.horizontalSpace,
                          ...UserController.find.userProfile.vips
                              .asMap()
                              .entries
                              .map((e) {
                            return _subscriptionItem(e.value, e.key);
                          }).toList(),
                        ],
                      ),
                    ),
                  ),
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
    return Container(
      height: 150.h,
      child: Stack(
        children: [
          Container(
            width: 124.w,
            height: 140.h,
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
            margin: EdgeInsets.only(right: 12.w, top: 10.h),
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
                    margin: EdgeInsets.only(
                      left: 10,
                      right: 10,
                      top: 10.h,
                    ),
                    alignment: Alignment.center,
                    child: vipModel.level !=
                            UserController.find.userProfile.vipLevel
                        ? Text(
                            "£${vipModel.price}",
                            style: TextStyle(
                              color: AppColor.yellow,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              fontFamily: FONT_MEDIUM,
                            ),
                          )
                        : Text(
                            'SUBSCRIBED',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF2CC04D),
                              fontSize: 14.sp,
                              fontFamily: FONT_MEDIUM,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 16.w,
            top: 0,
            child: Visibility(
              visible:
                  vipModel.level == UserController.find.userProfile.vipLevel,
              child: Image.asset(
                ImageUtils.subscriptioned_icon,
                scale: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
