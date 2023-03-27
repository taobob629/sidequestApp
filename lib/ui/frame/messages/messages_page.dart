import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/ui/common/home_indicator.dart';
import 'package:wy/ui/frame/messages/fans/fans_list_page.dart';
import 'package:wy/ui/frame/messages/follow/follow_list_page.dart';
import 'package:wy/utils/image_util.dart';
import 'package:wy/widget/tab_widget.dart';

import '../../../common/keep_alive_wrapper.dart';
import 'chat/conversation_list_page.dart';

class MessagesPage extends StatelessWidget {
  final controller = Get.put(MessagesPageController());

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
        removeTop: true,
        context: context,
        child: Stack(
          children: [
            AspectRatio(
              aspectRatio: 750.0 / 365,
              child: Image.asset(
                "assets/images/message/msg_head_bg.webp",
                fit: BoxFit.fitWidth,
                width: Get.width,
              ),
            ),
            Positioned(
              top: kToolbarHeight,
              left: 0,
              right: 0,
              bottom: 0,
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: TabWidget(
                  tabstyle: TAB_STYLE_2,
                  indicator: HomeIndicator(colors: [AppColor.yellow, AppColor.yellow]),
                  alignment: Alignment.centerLeft,
                  tabController: controller.tabController,
                  tabList: [
                    "Message".tr,
                    "Follow".tr,
                    "Fans".tr,
                  ],
                  tabPage: [
                    KeepAliveWrapper(child: ConversationListPage()),
                    FollowListPage(),
                    FansListPage(),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}

class MessagesPageController extends GetxController with GetSingleTickerProviderStateMixin {
  static MessagesPageController get find => Get.find();

  late TabController tabController;

  @override
  void onInit() {
    // TODO: implement onInit
    configIMTheme();
    tabController = TabController(vsync: this, length: 3, initialIndex: 0);

    super.onInit();
  }

  configIMTheme() {
    final CoreServicesImpl _coreInstance = TIMUIKitCore.getInstance();
    _coreInstance.setTheme(
      theme: TUITheme(
          textColor: Colors.white,
          chatBgColor: Colors.transparent,
          conversationItemTitleTextColor: Colors.white,
          conversationItemBorderColor: Colors.transparent,
          conversationItemBgColor: Colors.transparent,
          conversationItemPinedBgColor: Colors.transparent,
          lightPrimaryColor: AppColor.background,
          inputFillColor: AppColor.color3033,
          chatMessageItemFromSelfBgColor: AppColor.color302D,
          chatMessageItemFromOthersBgColor: AppColor.itemBg),
    );
  }

  @override
  void onClose() {
    // TODO: implement onClose
    tabController.dispose();
    super.onClose();
  }
}
