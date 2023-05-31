/*
  drawer
  sidequest_hub_app
  desc:
  Created by chunma on .
  Copyright © sidequest_hub_app. All rights reserved.
*/
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/config/app_pages.dart';
import 'package:wy/config/icon_font.dart';
import 'package:wy/ui/common/dialog_confirm.dart';
import 'package:wy/ui/common/privacy_check.dart';
import 'package:wy/ui/common/web_page.dart';
import 'package:wy/ui/controller/user_controller.dart';
import 'package:wy/ui/profile/balance/balance_page.dart';
import 'package:wy/ui/profile/energy_view.dart';
import 'package:wy/utils/index.dart';
import 'package:wy/utils/navigator_helper.dart';
import 'package:wy/widget/button.dart';
import 'package:wy/widget/home/index.dart';

List<Map> supports = [
  // Map()
  //   ..['title'] = 'FAQ'
  //   ..['action'] = () => SmartDialog.showToast('FAQ'),
  Map()
    ..['title'] = 'Help Centre'.tr
    ..['action'] =
        () => Get.to(WebPage(title: 'Help Centre'.tr, url: HelpCenterLink)),
  Map()
    ..['title'] = 'Give us feedback'.tr
    ..['action'] = () => Get.dialog(ConfirmDialog(
        title: 'feedback'.tr,
        info:
            'Please contact us:\nGeneral Enquiries: support@sidequestmeta.com\nEvents and Bookings: event@sidequestmeta.com\nFranchisees: invest@sidequestmeta.com\nShop: shop@sidequestmeta.com'
                .tr)),
];
List<Map> legals = [
  Map()
    ..['title'] = 'Terms of use'.tr
    ..['action'] = () =>
        Get.to(WebPage(title: 'Terms of use'.tr, url: TermsAndConditionLink)),
  Map()
    ..['title'] = 'Privacy Policy'.tr
    ..['action'] = () =>
        Get.to(WebPage(title: 'Privacy Policy'.tr, url: PrivacyPolicyLink)),
];

class HomeDrawer extends StatelessWidget {
  final user = Get.find<UserController>().userProfile;
  double drawerWidth = Get.width - 40.w;

  @override
  Widget build(BuildContext context) {
    double total = user?.totalmins.toDouble() ?? 0;
    int remain = user?.avamins ?? 1;
    return Drawer(
      width: drawerWidth,
      backgroundColor: Color(0xFF262731),
      child: Scaffold(
        body: MediaQuery.removePadding(
            removeTop: true,
            context: context,
            child: ListView(
              children: <Widget>[
                30.verticalSpace,
                ListTile(
                  dense: true,
                  trailing: ClickIcon(
                    onTap: () => Get.toNamed(AppPages.Setting),
                    customIcon: ImageUtil.assetImage(
                      'profile_setting',
                      width: 18.w,
                    ),
                  ),
                ),
                header(),
                Obx(() => Visibility(
                    visible: UserController.find.online.value,
                    child: achievements())),
                remainingTimes(),
                contentPadding(EnergyView(
                  width: drawerWidth - 15 * 2.r,
                  percent: total == 0 ? 0 : remain / total,
                  remaining: user?.avamins ?? 0,
                )),
                8.verticalSpace,
                Visibility(
                  visible: UserController.find.online.value,
                  child: _listItem(
                    'My Subscription'.tr,
                    onTapMore: () =>
                        Get.toNamed(AppPages.VIP_PAGE, arguments: 0)
                            ?.whenComplete(
                      () => UserController.instance().updateInfo(),
                    ),
                  ),
                ),
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
      padding: EdgeInsets.only(left: 30, top: 10).r,
      child: Text.rich(TextSpan(children: [
        TextSpan(
            text: 'Remaining game time: '.tr,
            style: TextStyle(
                fontSize: 12.sp,
                color: Color(0xFFC5C5C5),
                fontFamily: FONT_MEDIUM)),
        TextSpan(
            text: '${user?.avamins}mins',
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
      margin: EdgeInsets.only(left: 16, right: 16).r,
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 15).h,
                padding: EdgeInsets.all(3).r,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                            'assets/images/profile_avatar_border.webp'))),
                child: ImageUtil.networkImage(
                    width: iconSize,
                    height: iconSize,
                    fit: BoxFit.cover,
                    url: '${user?.avatar}',
                    border: iconSize / 2),
              ),
              Obx(() => Visibility(
                    visible: UserController.find.userProfile.vipLevel >= 5 &&
                        UserController.find.userProfile.isAuth == 1,
                    child: Positioned(
                        left: 0,
                        right: 0,
                        bottom: 10.h,
                        child: Image.asset(
                          "assets/images/profile/icon_level_${UserController.find.userProfile.vipLevel == 0 ? 5 : UserController.find.userProfile.vipLevel}.webp",
                          height: iconSize / 2,
                        )),
                  )),
            ],
          ),
          15.horizontalSpace,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${user?.nickName}',
                style: TextStyle(fontFamily: FONT_MEDIUM, fontSize: 16.sp),
              ),
              5.verticalSpace,
              Text(
                '${user?.uk}',
                style: TextStyle(
                    fontSize: 12.sp,
                    fontFamily: FONT_LIGHT,
                    color: AppColor.textC5C5),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 5),
            child: GameLevelWidget(
              level: user.sidekickLevel,
              userId: user.pwId,
            ),
          ),
          Spacer(),
          Expanded(
              child: InkWell(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ClickIcon(
                  icon: Icons.arrow_forward_ios,
                  size: 13.0,
                  onTap: () => NavigatorHelper.toOtherProfile(user?.pwId),
                )
              ],
            ),
            onTap: () => NavigatorHelper.toOtherProfile(user?.pwId),
          ))
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
      padding: EdgeInsets.only(left: 15, top: 15).r,
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
      margin: EdgeInsets.only(left: 15, right: 15, top: 10).r,
      padding: EdgeInsets.all(15).r,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(11),
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Color(0xFF292F3F), Color(0x55292F3F)])),
      child: Row(
        children: [
          achievementItem(user?.coin, 'ic_balance_money'),
          achievementItem(user?.diamond, 'diamonds_red'),
          achievementItem(user?.balanceMoney(), 'ic_corns_new'),
          achievementItem(user?.coupons, 'ic_coupons_new'),
        ],
      ),
    );
  }

  Widget achievementItem(var text, var icon) {
    var textStyle = TextStyle(
        color: Color(0xFFC5C5C5), fontSize: 12.sp, fontFamily: FONT_MEDIUM);
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
      onTap: () {
        switch (icon) {
          case 'ic_balance_money':
            if (StorageManager.getOnline())
              Get.toNamed(AppPages.WALLET_PAGE, arguments: Map()..['page'] = 0);
            break;
          case 'ic_coupons_new':
            NavigatorHelper.gotoCouponTabPage(
                whenComplete: () => UserController.instance().updateInfo());
            break;
          case 'diamonds_red':
            StorageManager.getOnline()
                ? Get.toNamed(AppPages.WALLET_PAGE,
                    arguments: Map()..['page'] = 1)
                : null;
            break;
          case 'ic_corns_new':
            if (StorageManager.getOnline())
              Get.to(() => BalancePage())
                  ?.whenComplete(() => UserController.instance().updateInfo());
            break;
        }
      },
      child: Column(
        children: [
          ImageUtil.assetImage(icon, width: width, height: height),
          2.verticalSpace,
          Text(
            '$text' ?? '',
            style: textStyle,
          ),
        ],
      ),
    ));
  }
}
