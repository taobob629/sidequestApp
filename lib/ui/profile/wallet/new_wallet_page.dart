import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../config/app_color.dart';
import '../../../config/app_pages.dart';
import '../../../config/icon_font.dart';
import '../../../utils/image_util.dart';
import '../../../utils/navigator_helper.dart';
import '../../../utils/storage_manager.dart';
import '../../../widget/scaffold_widget.dart';
import '../../controller/user_controller.dart';
import '../balance/balance_page.dart';
import '../energy_view.dart';

class NewWalletPage extends StatelessWidget {
  final user = Get.find<UserController>().userProfile;

  NewWalletPage({Key? key}) : super(key: key);
  final userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    double total = user.totalmins.toDouble();
    int remain = user.avamins;
    double drawerWidth = Get.width - 40.w;

    return ScaffoldWidget(
      appBar: AppBar(
        title: Text('My Wallet'.tr),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            achievements(),
            contentPadding(EnergyView(
              width: drawerWidth - 15 * 2.r,
              percent: total == 0 ? 0 : remain / total,
              remaining: user.avamins,
            )),
            Container(
              padding: EdgeInsets.only(left: 30, top: 20, bottom: 10),
              alignment: Alignment.centerLeft,
              child: Text(
                "Balance".tr,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding:
                  EdgeInsets.only(left: 20, right: 15, top: 10, bottom: 10),
              decoration: BoxDecoration(
                  color: Color.fromRGBO(40, 37, 60, 1),
                  borderRadius: BorderRadius.circular(15.r)),
              child: Column(
                children: [
                  _balanceItem(
                    imgName: "assets/images/coin_red.webp",
                    title: '${userController.userProfile.coin}' + " Coin".tr,
                    subTitle: "These coins are only used for SideKick".tr,
                    btnTitle: "TOP UP".tr,
                    onTap: () {
                      Get.toNamed(AppPages.WALLET_PAGE);
                    },
                  ),
                  _balanceItem(
                    imgName: "assets/images/diamonds_red.webp",
                    title: "${userController.userProfile.diamond} Diamonds".tr,
                    subTitle: "6 Diamonds for £1".tr,
                    btnTitle: "WITHDRAW".tr,
                    onTap: () {
                      Get.toNamed(AppPages.WALLET_PAGE,
                          arguments: Map()..['page'] = 1);
                    },
                  ),
                  _balanceItem(
                    imgName: "assets/images/ic_corns_new.webp",
                    title: "£${userController.userProfile.balance} Credits".tr,
                    subTitle:
                        "These credits are only used for SideQuest Hub".tr,
                    btnTitle: "TOP UP".tr,
                    onTap: () {
                      userController.checkLogin(() =>
                          Get.to(() => BalancePage())?.whenComplete(
                              () => userController.updateInfo()));
                    },
                  ),
                  _balanceItem(
                    imgName: "assets/images/ic_coupons_new.webp",
                    title: (userController.userProfile.coupons > 0
                            ? "${userController.userProfile.coupons} "
                            : "") +
                        "Vouchers".tr,
                    subTitle: "View/Add your vouchers".tr,
                    btnTitle: "VIEW".tr,
                    onTap: () {
                      NavigatorHelper.gotoCouponTabPage(
                          whenComplete: () => userController.updateInfo());
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget contentPadding(Widget child, {var top, var bootom}) => Container(
        margin: EdgeInsets.all(15).r,
        padding: EdgeInsets.all(15).r,
        decoration: BoxDecoration(
          color: Color.fromRGBO(40, 37, 60, 1),
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            remainingTimes(),
            Container(
              height: 1.h,
              color: Color(0xff2D2E3A),
              margin: EdgeInsets.symmetric(vertical: 15.h),
            ),
            child,
          ],
        ),
      );

  Widget remainingTimes() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Remaining game time: '.tr,
              style: TextStyle(
                  fontSize: 12.sp,
                  color: Color(0xFFC5C5C5),
                  fontFamily: FONT_MEDIUM)),
          Text('${user.avamins}mins',
              style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColor.textYellow,
                  fontFamily: FONT_MEDIUM))
        ],
      );

  Widget achievements() => Container(
        margin: EdgeInsets.symmetric(horizontal: 15.w),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  if (StorageManager.getOnline())
                    Get.toNamed(AppPages.WALLET_PAGE,
                        arguments: Map()..['page'] = 0);
                },
                child: Container(
                  height: 88.h,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0xff786728),
                        width: 0.5.w,
                      ),
                      borderRadius: BorderRadius.circular(15.r)),
                  child: achievementItem(user.coin, 'ic_balance_money'),
                ),
              ),
            ),
            6.horizontalSpace,
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  if (StorageManager.getOnline())
                    Get.toNamed(AppPages.WALLET_PAGE,
                        arguments: Map()..['page'] = 1);
                },
                child: Container(
                  height: 88.h,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0xff786728),
                        width: 0.5.w,
                      ),
                      borderRadius: BorderRadius.circular(15.r)),
                  child: achievementItem(user.diamond, 'diamonds_red'),
                ),
              ),
            ),
            6.horizontalSpace,
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  if (StorageManager.getOnline())
                    Get.to(() => BalancePage())?.whenComplete(
                            () => UserController.instance().updateInfo());
                },
                child: Container(
                  height: 88.h,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0xff786728),
                        width: 0.5.w,
                      ),
                      borderRadius: BorderRadius.circular(15.r)),
                  child: achievementItem(user.balanceMoney(), 'ic_corns_new'),
                ),
              ),
            ),
            6.horizontalSpace,
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  NavigatorHelper.gotoCouponTabPage(
                      whenComplete: () =>
                          UserController.instance().updateInfo());
                },
                child: Container(
                  height: 88.h,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0xff786728),
                        width: 0.5.w,
                      ),
                      borderRadius: BorderRadius.circular(15.r)),
                  child: achievementItem(user.coupons, 'ic_coupons_new'),
                ),
              ),
            ),
          ],
        ),
      );

  Widget achievementItem(var text, var icon) {
    var textStyle = TextStyle(
        color: Colors.white,
        fontSize: 14.sp,
        fontWeight: FontWeight.bold,
        fontFamily: FONT_MEDIUM);
    double width = 24.w;
    double height = 24.w;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ImageUtil.assetImage(icon, width: width, height: height),
        17.verticalSpace,
        Text(
          '$text',
          style: textStyle,
        ),
      ],
    );
  }

  Widget _balanceItem(
      {String imgName = "assets/images/coin_red.webp",
      String title = "",
      String subTitle = "",
      String? btnTitle,
      Function()? onTap}) {
    return Container(
      height: 80,
      child: Row(
        children: [
          Image.asset(
            imgName,
            width: 50,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 6,
                ),
                Text(
                  subTitle,
                  style: TextStyle(
                      color: Colors.white70,
                      fontSize: 10,
                      fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ),
          if (btnTitle != null)
            GestureDetector(
              onTap: onTap,
              child: Container(
                width: 100,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF841FC3),
                          Color(0xFF841FC3),
                          Color(0xFFFC3C02),
                        ])),
                child: Text(
                  btnTitle,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold),
                ),
              ),
            )
        ],
      ),
    );
  }
}
