import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sq_hub_app/ui/pages/playwith/play_tab_widget.dart';

import '../../../config/app_config.dart';
import '../../../controller/user_controller.dart';
import '../../../widget/scaffold_widget.dart';
import 'balance/my_earnings_page.dart';
import 'balance/play_balance_child.dart';
import 'balance/withdraw/view.dart';

class PlayBalancePage extends StatefulWidget {
  @override
  _PlayBalancePageState createState() => _PlayBalancePageState();
}

class _PlayBalancePageState extends State<PlayBalancePage> {
  //var tabList = ["Balance", "My earnings"];
  UserController userController = Get.find<UserController>();
  final ctr = Get.put(PlayBalanceCtr());

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      body: PlayTabWidget(
        page: Get.arguments?['page'] ?? 0,
        controller: ScrollController(),
        isScrollable: true,
        color: Color(0xff171525),
        rightChild: IconButton(
          onPressed: () => Get.to(() => WithDrawMainPage()),
          icon: Icon(
            Icons.list,
            color: Colors.white,
          ),
        ),
        /*  rightChild: GestureDetector(
          child: PWidget.text('WithDraw record', [Colors.white], {'pd': 8}),
          onTap: () =>  Get.toNamed(AppPages.WithDrawRecord),
        ),*/
        tabList: tabs(),
        tabPage: tabPages(),
      ),
    );
  }

  tabs() {
    return ["My Coin".tr, "My Diamond".tr];
    //return userController.userInfoModel.value.isauth == TYPE_VIP ? ["Balance".tr, "My earnings".tr] : ['Balance'.tr];
  }

  tabPages() {
    return [
      PlayBalanceChild(),
      MyEarningsPage(),
    ];
    // return userController.userInfoModel.value.isauth == TYPE_VIP
    //     ? [
    //         PlayBalanceChild(),
    //         MyEarningsPage(),
    //       ]
    //     : [PlayBalanceChild()];
  }
}

class PlayBalanceCtr extends GetxController {

  var action = AppConfig.ACTION_PW;

  @override
  void onInit() {
    super.onInit();

    AppConfig.init('default', action: action);
  }

  @override
  void onClose() {
    super.onClose();

    AppConfig.init('default', action: AppConfig.ACTION_DEFAULT);
  }
}
