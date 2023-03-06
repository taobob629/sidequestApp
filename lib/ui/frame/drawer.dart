/*
  drawer
  sidequest_hub_app
  desc:
  Created by chunma on .
  Copyright © sidequest_hub_app. All rights reserved.
*/
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/config/app_pages.dart';
import 'package:wy/config/icon_font.dart';
import 'package:wy/res/styles.dart';
import 'package:wy/ui/common/privacy_check.dart';
import 'package:wy/ui/common/web_page.dart';
import 'package:wy/ui/controller/user_controller.dart';
import 'package:wy/ui/frame/home/view.dart';
import 'package:wy/ui/im/play_detail.dart';
import 'package:wy/ui/profile/balance/balance_page.dart';
import 'package:wy/ui/profile/energy_view.dart';
import 'package:wy/ui/profile/profile_page.dart';
import 'package:wy/ui/profile/vip/vip_page.dart';
import 'package:wy/utils/image_util.dart';
import 'package:wy/utils/navigator_helper.dart';
import 'package:wy/widget/button.dart';
import 'package:wy/widget/lable.dart';
import 'package:wy/widget/stadium_button.dart';

import '../index/Index_page.dart';

List<Map> supports = [
  Map()
    ..['title'] = 'FAQ'
    ..['action'] = () => EasyLoading.showToast('FAQ'),
  Map()
    ..['title'] = 'Help Center'
    ..['action'] = () => EasyLoading.showToast('Help Center'),
  Map()
    ..['title'] = 'Give us feedback'
    ..['action'] = () => EasyLoading.showToast('Give us feedback'),
];
List<Map> legals = [
  Map()
    ..['title'] = 'Terms of use'
    ..['action'] = () => Get.to(WebPage(title: 'Terms of use', url: TermsAndConditionLink)),
  Map()
    ..['title'] = 'Privacy Policy'
    ..['action'] = () => Get.to(WebPage(title: 'Privacy Policy', url: PrivacyPolicyLink)),
];

class HomeDrawer extends StatelessWidget {
  final user = Get.find<UserController>().userInfoModel?.value;
  double drawerWidth = Get.width - 40.w;

  @override
  Widget build(BuildContext context) {
    double total = user?.total.toDouble() ?? 0;
    int remain = user?.remain ?? 1;
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
                    onTap: () => Get.toNamed(AppPages.NOTICE_PAGE),
                    customIcon: ImageUtil.assetImage(
                      'icon_notice',
                      width: 18.w,
                    ),
                  ),
                ),
                header(),
                achievements(),
                remainingTimes(),
                contentPadding(EnergyView(
                  width: drawerWidth - 20 * 2.r,
                  percent: total == 0 ? 0 : remain / total,
                  remaining: user?.remain ?? 0,
                )),
                8.verticalSpace,
                _listItem('My sidequest subscription',
                    onTapMore: () => Get.toNamed(AppPages.VIP_PAGE, arguments: 0)
                        ?.whenComplete(() => UserController.instance().updateInfo())),
                sectionText('Support'.tr),
                10.verticalSpace,
                supportsWidget(supports),
                sectionText('Legal'.tr),
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
            text: 'Remaining game time:',
            style: TextStyle(fontSize: 12.sp, color: Color(0xFFC5C5C5), fontFamily: FONT_MEDIUM)),
        TextSpan(
            text: '${user?.remain}',
            style: TextStyle(fontSize: 12.sp, color: AppColor.textYellow, fontFamily: FONT_MEDIUM))
      ])),
    );
  }

  ListTile header() {
    return ListTile(
      contentPadding: EdgeInsets.only(left: 16, right: 16).r,
      leading: Stack(
        children: [
          ClipRRect(
            child: ImageUtil.networkImage(
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                url:
                    'https://sidequest-1307226287.cos.eu-frankfurt.myqcloud.com/Tundra-Thursdays---Website-main-image.png'),
            borderRadius: BorderRadius.circular(20),
          )
        ],
      ),
      title: Text(
        '${user?.nick}',
        style: PageStyle.ts_FFFFFF_16sp,
      ),
      dense: true,
      onTap: () => Get.to(() => PlayDetail(userId: "${user?.pwuserId}")),
      subtitle: Text(
        'View profile',
        style: TextStyle(fontSize: 12.sp, color: AppColor.textC5C5),
      ),
      trailing: ClickIcon(
        icon: Icons.arrow_forward_ios,
        size: 13.0,
        onTap: () => Get.to(() => PlayDetail(userId: "${user?.pwuserId}")),
      ),
    );
  }

  Widget sectionText(String text) {
    return contentPadding(Text(
      text,
      style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold),
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
        style: TextStyle(color: Colors.white, fontSize: 15.sp, fontFamily: FONT_LIGHT),
      ),
      trailing: ClickIcon(
        icon: Icons.arrow_forward_ios,
        size: 13.0,
        onTap: onTapMore,
      ),
    );
  }

  Widget achievements() {
    return Container(
      margin: EdgeInsets.only(left: 15, right: 15, top: 20).r,
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
          achievementItem(user?.coupons, 'ic_coupons_new'),
          achievementItem(user?.votes, 'diamonds_red'),
          achievementItem(user?.balance, 'ic_corns_new'),
        ],
      ),
    );
  }

  Widget achievementItem(var text, var icon) {
    var textStyle = TextStyle(color: Color(0xFFC5C5C5), fontSize: 12.sp, fontFamily: FONT_MEDIUM);
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
            if (ProfilePageController.instance().online.value)
              Get.toNamed(AppPages.WALLET_PAGE, arguments: Map()..['page'] = 0);
            break;
          case 'ic_coupons_new':
            NavigatorHelper.gotoCouponTabPage(
                whenComplete: () => UserController.instance().updateInfo());
            break;
          case 'diamonds_red':
            ProfilePageController.instance().online.value
                ? Get.toNamed(AppPages.WALLET_PAGE, arguments: Map()..['page'] = 1)
                : null;
            break;
          case 'ic_corns_new':
            if (ProfilePageController.instance().online.value)
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
