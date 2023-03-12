import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/config/app_pages.dart';
import 'package:wy/ui/controller/user_controller.dart';
import 'package:wy/ui/frame/profile/model/profile_model.dart';
import 'package:wy/ui/frame/profile/profile_page.dart';
import 'package:wy/ui/profile/booking/booking_page.dart';
import 'package:wy/ui/profile/events/my_events_page.dart';
import 'package:wy/ui/profile/wallet/new_wallet_page.dart';
import 'package:wy/utils/image_util.dart';

class ProfileDashboardPage extends StatelessWidget {
  ProfileDashboardPage({Key? key}) : super(key: key);

  final t = ProfileController.find;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          /// dashboard
          Container(
            height: 62,
            margin: EdgeInsets.only(left: 30, top: 20, right: 30),
            decoration: BoxDecoration(
              color: Color(0xff313033),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _dashboardLabelItem(
                  "assets/images/profile/icon_wallet.webp",
                  "Wallet",
                  onTap: () {
                    Get.to(() => NewWalletPage());
                  },
                ),
                _dashboardLabelItem(
                  "assets/images/profile/icon_bookings.webp",
                  "Bookings",
                  onTap: () {
                    Get.toNamed(AppPages.BOOKING_PAGE);
                  },
                ),
                _dashboardLabelItem(
                  "assets/images/profile/icon_activities.webp",
                  "Activities",
                  onTap: () {
                    Get.to(() => MyEventsPage());
                  },
                ),
                _dashboardLabelItem(
                  "assets/images/profile/icon_sidekick.webp",
                  "Sidekick",
                  onTap: () {
                    Get.toNamed(AppPages.WALLET_PAGE, arguments: Map()..['page'] = 0);
                  },
                ),
              ],
            ),
          ),

          /// Subscriptions
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 38),
                  child: Text(
                    "Subscriptions",
                    style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.bold),
                  ),
                ),
                Obx(() => Container(
                      width: Get.width,
                      height: 48,
                      margin: EdgeInsets.only(top: 10),
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: UserController.find.userProfile.value.vips.asMap().map((index, value) => MapEntry(index, _subscriptionItem(value, index))).values.toList(),
                      ),
                    ))
              ],
            ),
          ),

          /// Trophies
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 38),
                  child: Text(
                    "Trophies",
                    style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.bold),
                  ),
                ),
                Obx(() => Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 10, left: 30, right: 30, bottom: 20),
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Color(0xff313033),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: GridView.count(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        crossAxisCount: 6,
                        mainAxisSpacing: 15,
                        crossAxisSpacing: 15,
                        padding: EdgeInsets.zero,
                        children: UserController.find.userProfile.value.trophies.map((e) {
                          if (e.lighted) {
                            return ImageUtil.networkImage(
                              url: e.iconImage,
                              width: 36,
                              height: 36,
                              fit: BoxFit.fitHeight,
                            );
                          } else {
                            return ColorFiltered(
                              colorFilter: ColorFilter.mode(Colors.grey.withOpacity(0.5), BlendMode.dstIn),
                              child: ImageUtil.networkImage(
                                url: e.iconImage,
                                width: 36,
                                height: 36,
                              ),
                            );
                          }
                        }).toList(),
                      ),
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _dashboardLabelItem(String imageName, String title, {Function()? onTap}) {
    return GestureDetector(
      onTap: () => onTap?.call(),
      behavior: HitTestBehavior.opaque,
      child: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imageName,
              width: 26,
            ),
            SizedBox(
              height: 3,
            ),
            Text(
              title,
              style: TextStyle(color: Colors.white, fontSize: 10.sp),
            )
          ],
        ),
      ),
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
                gradient: vipModel.level <= UserController.find.userProfile.value.vipLevel
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
