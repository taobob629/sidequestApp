import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/config/app_pages.dart';
import 'package:wy/ui/common/home_indicator.dart';
import 'package:wy/ui/frame/messages/fans/fans_list_page.dart';
import 'package:wy/ui/frame/messages/follow/follow_list_page.dart';
import 'package:wy/ui/frame/social/group/create/controller.dart';
import 'package:wy/utils/image_util.dart';
import 'package:wy/utils/index.dart';
import 'package:wy/utils/toast_utils.dart';
import 'package:wy/widget/tab_widget.dart';

import '../../../common/keep_alive_wrapper.dart';
import 'chat/conversation_list_page.dart';

class MessagesPage extends StatelessWidget {
  final controller = Get.put(MessagesPageController());

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AspectRatio(
          aspectRatio: 750.0 / 365,
          child: Image.asset(
            "assets/images/message/msg_head_bg.webp",
            fit: BoxFit.fitWidth,
            width: Get.width,
          ),
        ),
        Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            actions: [
              Obx(()=>Visibility(
                  visible: controller.showMenu.value,
                  child: PopupMenuButton(
                  color: AppColor.itemBg,
                  onSelected: (item) {
                    if (item == 'Create Room'.tr) {
                      controller.toCreatGoupPage();
                    }
                  },
                  itemBuilder: (context) => <PopupMenuEntry<String>>[
                    ...controller.popMenus.map((e) => PopupMenuItem<String>(
                      value: e,
                      child: Text(
                        '$e'.tr,
                        style: TextStyle(),
                      ),
                    ))
                  ])))
            ],
            flexibleSpace: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Spacer(),
                TabBar(
                  controller: controller.tabController,
                  isScrollable: true,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white,
                  indicator: BoxDecoration(),
                  indicatorColor: Colors.transparent,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorWeight: 3,
                  // indicatorPadding: const EdgeInsets.only(bottom: 0),
                  labelPadding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                  labelStyle: TextStyle(fontSize: 21.sp, fontWeight: FontWeight.bold),
                  unselectedLabelStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.normal),
                  tabs: controller.tabs.map((e) => Text(e)).toList(),
                ).paddingOnly(left: 15),
              ],
            ),
          ),
          backgroundColor: Colors.transparent,
          body: TabBarView(controller: controller.tabController, children: [
            KeepAliveWrapper(
                child: ConversationListPage(
              type: type_single_chat,
            )),
            KeepAliveWrapper(
                child: ConversationListPage(
              type: type_group,
            )),
          ]),
        ),
      ],
    );
  }
}

class MessagesPageController extends GetxController with GetSingleTickerProviderStateMixin {
  static MessagesPageController get find => Get.find();
  var popMenus = ['Scan', 'Create Room', 'Friends', 'Share'];
  var showMenu = false.obs;
  var tabs = [
    "Message".tr,
    "Group".tr,
  ];
  late TabController tabController;

  @override
  void onInit() {
    configIMTheme();
    tabController = TabController(vsync: this, length: tabs.length, initialIndex: 0)
      ..addListener(() {
        var index = tabController.index;
        showMenu.value = (index == 1);
      });

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
          chatMessageTongueBgColor: AppColor.color3033,
          lightPrimaryColor: AppColor.background,
          inputFillColor: AppColor.color3033,
          chatMessageItemFromSelfBgColor: AppColor.color302D,
          chatMessageItemFromOthersBgColor: AppColor.itemBg),
    );
  }

  void toCreatGoupPage() {
    Get.toNamed(AppPages.CreateGroup, arguments: Map()..['convType'] = GroupTypeForUIKit.public);
  }

  @override
  void onClose() {
    // TODO: implement onClose
    tabController.dispose();
    super.onClose();
  }
}
