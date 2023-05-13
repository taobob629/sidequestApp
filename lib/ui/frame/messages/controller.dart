/**
    author:mac
    创建日期:2023/5/13
    描述:
 */
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:wy/common/base_controller.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/config/app_pages.dart';
import 'package:wy/ui/frame/social/group/create/controller.dart';
import 'package:wy/utils/toast_utils.dart';

class MessagesPageController extends BasePageController {
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

  Future<void> testAddGroup() async {
    V2TimCallback joinGroupRes = await TencentImSDKPlugin.v2TIMManager.joinGroup(
        groupID: "@TGS#2Y65HYWLEP", // 需要加入群组 ID
        message: "hello", // 加群申请信息
        groupType: "Public"); // 群类型
    if (joinGroupRes.code == 0) {
      // 加入成功
      showToast("加入成功");

    }
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}
