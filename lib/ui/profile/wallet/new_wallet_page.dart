import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/app_pages.dart';
import '../../../utils/navigator_helper.dart';
import '../../../widget/scaffold_widget.dart';
import '../../controller/user_controller.dart';
import '../balance/balance_page.dart';

class NewWalletPage extends StatelessWidget {
  NewWalletPage({Key? key}) : super(key: key);
  final userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      appBar: AppBar(
        title: Text('My Wallet'.tr),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 30, top: 20, bottom: 10),
              alignment: Alignment.centerLeft,
              child: Text(
                "Balance".tr,
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.only(left: 20, right: 15, top: 10, bottom: 10),
              decoration: BoxDecoration(color: Color.fromRGBO(40, 37, 60, 1), borderRadius: BorderRadius.circular(30)),
              child: Column(
                children: [
                  _balanceItem(
                    imgName: "assets/images/coin_red.webp",
                    title: "Coins".tr,
                    subTitle: "These coins are only used for SideKick.".tr,
                    btnTitle: "TOP UP".tr,
                    onTap: () {
                      Get.toNamed(AppPages.WALLET_PAGE);
                    },
                  ),
                  _balanceItem(
                    imgName: "assets/images/diamonds_red.webp",
                    title: "Diamonds".tr,
                    subTitle: "You can withdrwal cash.".tr,
                    btnTitle: "WITHDRAW".tr,
                    onTap: () {
                      Get.toNamed(AppPages.WALLET_PAGE, arguments: Map()..['page'] = 1);
                    },
                  ),
                  _balanceItem(
                    imgName: "assets/images/ic_corns_new.webp",
                    title: "Credits".tr,
                    subTitle: "These Credits are only used for SideQuest Hub.".tr,
                    btnTitle: "TOP UP".tr,
                    onTap: () {
                      userController.checkLogin(() => Get.to(() => BalancePage())?.whenComplete(() => userController.updateInfo()));
                    },
                  ),
                  _balanceItem(
                    imgName: "assets/images/ic_coupons_new.webp",
                    title: (userController.userInfoModel.value.coupons > 0 ? "${userController.userInfoModel.value.coupons} " : "") + "Vouchers".tr,
                    subTitle: "View/add your vouchers".tr,
                    btnTitle: "VIEW".tr,
                    onTap: () {
                      NavigatorHelper.gotoCouponTabPage(whenComplete: () => userController.updateInfo());
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

  Widget _balanceItem({String imgName = "assets/images/coin_red.webp", String title = "", String subTitle = "", String? btnTitle, Function()? onTap}) {
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
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 6,
                ),
                Text(
                  subTitle,
                  style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.normal),
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
                    gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [
                      Color(0xFF841FC3),
                      Color(0xFF841FC3),
                      Color(0xFFFC3C02),
                    ])),
                child: Text(
                  btnTitle,
                  style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ),
            )
        ],
      ),
    );
  }
}
