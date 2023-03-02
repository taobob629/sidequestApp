import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/ui/common/home_indicator.dart';
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
        child: Scaffold(
          appBar: AppBar(),
          body: TabWidget(
            tabstyle: TAB_STYLE_2,
            indicator: HomeIndicator(colors: [AppColor.yellow, AppColor.yellow]),
            alignment: Alignment.centerLeft,
            tabController: controller.tabController,
            tabList: [
              "Message".tr,
              "Follow".tr,
            ],
            tabPage: [
              KeepAliveWrapper(child: ConversationListPage()),
              KeepAliveWrapper(child: ConversationListPage()),
            ],
          ),
        ));
    return Scaffold(
      body: Stack(
        children: [
          ExtendedImage.asset(
            "assets/images/message/msg_head_bg.webp",
            fit: BoxFit.fitWidth,
            cacheWidth: Get.width.toInt(),
          )
        ],
      ),
    );
  }
}

class MessagesPageController extends GetxController with GetSingleTickerProviderStateMixin {
  static MessagesPageController get find => Get.find();

  late TabController tabController;

  @override
  void onInit() {
    // TODO: implement onInit
    configIMTheme();
    tabController = TabController(vsync: this, length: 2, initialIndex: 0);

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
    ));
  }

  @override
  void onClose() {
    // TODO: implement onClose
    tabController.dispose();
    super.onClose();
  }
}
