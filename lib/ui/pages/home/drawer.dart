/*
  drawer
  sidequest_hub_app
  desc:
  Created by chunma on .
  Copyright © sidequest_hub_app. All rights reserved.
*/
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../common/privacy_check.dart';
import '../../../../common/web_page.dart';
import '../../../../config/app_color.dart';
import '../../../../config/icon_font.dart';
import '../../../../controller/user_controller.dart';
import '../../../../image_utils.dart';
import '../../../../utils/navigator_helper.dart';
import '../../../../widget/button.dart';
import '../../../utils/storage_manager.dart';
import '../../dialog/dialog_confirm.dart';
import '../profile/balance/balance_page.dart';
import '../profile/integral/integral_home_page.dart';
import '../profile/task/task_page.dart';
import '../profile/view/energy_view.dart';
import '../profile/vip/vip_page.dart';
import '../setting/settings_page.dart';

List<Map> supports = [
  // Map()
  //   ..['title'] = 'FAQ'
  //   ..['action'] = () => SmartDialog.showToast('FAQ'),
  {}
    ..['title'] = 'Help Centre'.tr
    ..['action'] =
        () => Get.to(WebPage(title: 'Help Centre'.tr, url: HelpCenterLink)),
  {}
    ..['title'] = 'Give us feedback'.tr
    ..['action'] = () => Get.dialog(ConfirmDialog(
        title: 'feedback'.tr,
        info:
            'Please contact us:\nGeneral Enquiries: support@sidequestmeta.com\nEvents and Bookings: event@sidequestmeta.com\nFranchisees: invest@sidequestmeta.com\nShop: shop@sidequestmeta.com'
                .tr)),
];
List<Map> legals = [
  {}
    ..['title'] = 'Terms of use'.tr
    ..['action'] = () =>
        Get.to(WebPage(title: 'Terms of use'.tr, url: TermsAndConditionLink)),
  {}
    ..['title'] = 'Privacy Policy'.tr
    ..['action'] = () =>
        Get.to(WebPage(title: 'Privacy Policy'.tr, url: PrivacyPolicyLink)),
];

class HomeDrawer extends StatelessWidget {
  final user = Get.find<UserController>().userProfile;
  double drawerWidth = Get.width - 40.w;

  @override
  Widget build(BuildContext context) {
    double total = user.totalmins.toDouble();
    int remain = user.avamins;
    return Drawer(
      width: drawerWidth,
      backgroundColor: const Color(0xFF262731),
      child: Scaffold(
        body: MediaQuery.removePadding(
            removeTop: true,
            context: context,
            child: ListView(
              children: <Widget>[
                30.verticalSpace,
                ListTile(
                  dense: true,
                  trailing: GestureDetector(
                    onTap: () => Get.to(() => SettingsPage()),
                    child: Image.asset(
                      ImageUtils.profile_setting,
                      scale: 1.8,
                    ),
                  ),
                ),
                header(),
                achievements(),
                remainingTimes(),
                Container(
                  height: 70.h,
                  margin: EdgeInsets.only(
                    left: 15.w,
                    right: 15.w,
                    top: 15.h,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.r),
                    gradient: const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color(0xFF413A62),
                        Color(0xFF591E3A),
                        Color(0xFF413A62),
                      ],
                    ),
                  ),
                  child: EnergyView(
                    width: drawerWidth - 15 * 2.r,
                    percent: total == 0 ? 0 : remain / total,
                    remaining: user.avamins,
                  ),
                ),
                // 8.verticalSpace,
                // _listItem(
                //   'My Subscription'.tr,
                //   onTapMore: () =>
                //       Get.toNamed(AppPages.VIP_PAGE, arguments: 0)
                //           ?.whenComplete(
                //             () => UserController.instance().updateInfo(),
                //       ),
                // ),
                8.verticalSpace,
                _listItem(
                  'Quest'.tr,
                  onTapMore: () => Get.to(() => TaskPage()),
                ),
                // 8.verticalSpace,
                // _listItem(
                //   'Consumption record'.tr,
                //   onTapMore: () => Get.toNamed(AppPages.StoreConsumList),
                // ),
                sectionText('Support'.tr),
                10.verticalSpace,
                supportsWidget(supports),
                sectionText('Policies'.tr),
                10.verticalSpace,
                supportsWidget(legals),
                // Padding(
                //   padding: EdgeInsets.only(top: 30, left: 15, right: 15, bottom: 20),
                //   child: StadiumButton(
                //     'Log out',
                //     onTap: () => UserController.instance().appLogout(),
                //   ),
                // )
              ],
            )),
        // bottomNavigationBar: Padding(
        //   padding: EdgeInsets.only(left: 15, right: 15, bottom: 20),
        //   child: StadiumButton(
        //     'Log out',
        //     onTap: () => UserController.instance().appLogout(),
        //   ),
        // ),
      ),
    );
  }

  Widget supportsWidget(List items) {
    return ListView.separated(
        shrinkWrap: true,
        itemBuilder: (context, index) {
          var item = items[index];
          return _listItem(item['title'], onTapMore: item['action']);
        },
        separatorBuilder: (context, index) => Divider(
              color: AppColor.dividerColor,
            ),
        itemCount: items.length);
  }

  Widget remainingTimes() {
    return Padding(
      padding: const EdgeInsets.only(left: 30, top: 10).r,
      child: Text.rich(TextSpan(children: [
        TextSpan(
            text: 'Remaining game time: '.tr,
            style: TextStyle(
                fontSize: 12.sp,
                color: const Color(0xFFC5C5C5),
                fontFamily: FONT_MEDIUM)),
        TextSpan(
            text: '${user.avamins}' 'mins'.tr,
            style: TextStyle(
                fontSize: 12.sp,
                color: AppColor.textYellow,
                fontFamily: FONT_MEDIUM))
      ])),
    );
  }

  Widget header() {
    var iconSize = 50.w;
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16).r,
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 15).h,
                padding: const EdgeInsets.all(3).r,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                            'assets/images/profile_avatar_border.webp'))),
                child: ExtendedImage.network(
                  user.avatar,
                  width: iconSize,
                  height: iconSize,
                  fit: BoxFit.cover,
                  borderRadius: BorderRadius.circular(iconSize / 2),
                  shape: BoxShape.rectangle,
                ),
              ),
              Obx(() => Visibility(
                    visible: UserController.find.userProfile.vipLevel >= 5 &&
                        UserController.find.userProfile.isAuth == 1,
                    child: Positioned(
                        left: 0,
                        right: 0,
                        bottom: 10.h,
                        child: Image.asset(
                          "assets/images/huizhang_${UserController.find.userProfile.vipLevel == 0 ? 5 : UserController.find.userProfile.vipLevel}.webp",
                          height: iconSize / 2,
                        )),
                  )),
            ],
          ),
          15.horizontalSpace,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    user.nickName,
                    style: TextStyle(fontFamily: FONT_MEDIUM, fontSize: 16.sp),
                  ),
                  6.horizontalSpace,
                  Visibility(
                    visible: user.vipLevel >= 5,
                    child: Image.asset(
                      "assets/images/huizhang_${user.vipLevel == 0 ? 5 : user.vipLevel}.webp",
                      height: 14,
                    ),
                  ),
                  6.horizontalSpace,
                  GestureDetector(
                    onTap: () => Get.to(
                            () => IntegralHomePage()),
                    child: Image.asset(
                      'assets/images/integral_lv${user.lv == 0 ? user.lv + 1 : user.lv}_icon.webp',
                      scale: 11,
                    ),
                  ),
                ],
              ),
              5.verticalSpace,
              Text(
                user.uk,
                style: TextStyle(
                    fontSize: 12.sp,
                    fontFamily: FONT_LIGHT,
                    color: AppColor.textC5C5),
              )
            ],
          ),
          // Spacer(),
          // Expanded(
          //     child: InkWell(
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.end,
          //     children: [
          //       ClickIcon(
          //         icon: Icons.arrow_forward_ios,
          //         size: 13.0,
          //         onTap: () => NavigatorHelper.toOtherProfile(user?.pwId),
          //       )
          //     ],
          //   ),
          //   onTap: () => NavigatorHelper.toOtherProfile(user?.pwId),
          // ))
        ],
      ),
    );
  }

  Widget sectionText(String text) {
    return contentPadding(Text(
      text,
      style: TextStyle(
          color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold),
    ));
  }

  Widget contentPadding(Widget child, {var top, var bootom}) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, top: 15).r,
      child: child,
    );
  }

  Widget _listItem(var label, {Function()? onTapMore}) {
    return ListTile(
      minVerticalPadding: 0,
      // 子项
      dense: true,
      contentPadding: EdgeInsets.only(left: 30, right: 16, top: 0, bottom: 0).r,
      // leading: SizedBox(
      //   width: 30.w,
      // ),
      title: Text(
        '$label',
        style: TextStyle(
            color: Colors.white, fontSize: 15.sp, fontFamily: FONT_LIGHT),
      ),
      trailing: ClickIcon(
        icon: Icons.arrow_forward_ios,
        size: 13.0,
        onTap: onTapMore,
      ),
      onTap: onTapMore,
    );
  }

  Widget achievements() {
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15, top: 10).r,
      padding: const EdgeInsets.all(15).r,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(11),
          gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Color(0xFF292F3F), Color(0x55292F3F)])),
      child: Row(
        children: [
          // achievementItem(user?.coin, 'ic_balance_money'),
          // achievementItem(user?.diamond, 'diamonds_red'),
          achievementItem(
            user.balanceMoney(),
            ImageUtils.ic_corns_new,
            onTap: () {
              if (StorageManager.getOnline()) {
                Get.to(() => BalancePage())?.whenComplete(
                    () => UserController.instance().updateInfo());
              }
            },
          ),
          achievementItem(
            user.coupons,
            ImageUtils.ic_coupons_new,
            onTap: () => NavigatorHelper.gotoCouponTabPage(
                whenComplete: () => UserController.instance().updateInfo()),
          ),
          achievementItem(
            user.checkTotal,
            ImageUtils.ic_coupons_points,
            onTap: () => Get.to(() => IntegralHomePage())
                ?.whenComplete(() => UserController.instance().updateInfo()),
          ),
        ],
      ),
    );
  }

  Widget achievementItem(
    var text,
    var icon, {
    required Function onTap,
  }) {
    var textStyle = TextStyle(
      color: const Color(0xFFC5C5C5),
      fontSize: 12.sp,
      fontFamily: FONT_MEDIUM,
    );
    double width = 18;
    double height = 18;
    switch (icon) {
      case 'ic_balance_money':
        width = 18;
        height = 18;
        break;
      case 'ic_coupons_new':
        width = 22;
        height = 15;
        break;
      case 'diamonds_red':
        width = 18;
        height = 18;
        break;
      case 'ic_corns_new':
        width = 22;
        height = 18;
        break;
    }
    return Expanded(
      child: InkWell(
        onTap: () => onTap.call(),
        child: Column(
          children: [
            Image.asset(icon, width: width, height: height),
            2.verticalSpace,
            Text(
              '$text' ?? '',
              style: textStyle,
            ),
          ],
        ),
      ),
    );
  }
}
