import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/config/app_pages.dart';
import 'package:wy/ui/controller/user_controller.dart';
import 'package:wy/ui/frame/profile/model/profile_model.dart';
import 'badges_widget.dart';
import 'my_profile_page.dart';
import 'package:wy/ui/profile/events/my_events_page.dart';
import 'package:wy/ui/profile/wallet/new_wallet_page.dart';
import 'package:wy/utils/image_util.dart';

class MyDashboardPage extends StatelessWidget {
  MyDashboardPage({Key? key}) : super(key: key);

  final t = ProfileController.find;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// Subscriptions
        Container(
          width: double.infinity,
          margin: EdgeInsets.only(top: 15.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 15.w),
                child: Text(
                  "Subscriptions".tr,
                  style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.bold),
                ),
              ),
              Obx(() => Container(
                width: Get.width,
                height: 48,
                margin: EdgeInsets.only(top: 10),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: UserController.find.userProfile.vips.asMap().map((index, value) => MapEntry(index, _subscriptionItem(value, index))).values.toList(),
                ),
              ))
            ],
          ),
        ),

        /// Trophies
        ...UserController.find.userProfile.badges.map((badge) => BadgesWidget(badge)).toList()
      ],
    );
  }

  Widget _subscriptionItem(VipModel vipModel, int index) {
    return Container(
      // width: 128.w,
      height: 48,
      margin: EdgeInsets.only(left: 12),
      decoration: BoxDecoration(border: Border.all(color: Color(0xff707070), width: 1.5), borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Image.asset(
              "assets/images/profile/icon_level_${vipModel.level}.webp",
              width: 26,
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            vipModel.name,
            style: TextStyle(color: Colors.white, fontSize: 10.sp, fontWeight: FontWeight.bold),
          ),
          GestureDetector(
            onTap: () {
              // if (vipModel.level > t.vm.value.vipLevel) {
              Get.toNamed(AppPages.VIP_PAGE, arguments: index);
              // }
              // Get.to(VipPage(vipLevel: vipLevel, vipIndex: vipIndex, list: list))
            },
            child: Container(
              width: 50,
              height: 20,
              margin: EdgeInsets.only(left: 10, right: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                gradient: vipModel.level <= UserController.find.userProfile.vipLevel
                    ? LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Color(0xff707070), Color(0xff707070)])
                    : LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Color(0xFF632BDA), Color(0xFF6029D4), Color(0xFF652CDF), Color(0xFF7231DE), Color(0xFF8A39DE), Color(0xFFBE38D0), Color(0xFFDE5D85), Color(0xFFE68887)]),
              ),
              alignment: Alignment.center,
              child: Text(
                "£${vipModel.price}",
                style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }
}
