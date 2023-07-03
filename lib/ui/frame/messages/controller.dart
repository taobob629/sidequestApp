/**
    author:mac
    创建日期:2023/5/13
    描述:
 */
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:wy/common/base_controller.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/config/app_pages.dart';
import 'package:wy/ui/im/im_util.dart';
import 'package:wy/ui/scan/scan_page.dart';
import 'package:wy/utils/index.dart';
import 'package:wy/utils/toast_utils.dart';

import 'chat/chat_page.dart';
import 'group/create/controller.dart';

class MessagesPageController extends BasePageController {
  static MessagesPageController get find => Get.find();
  var popMenus = [{'title':'Scan'.tr,'img':'ic_scan'},{'title':'Create Room'.tr,'img':'ic_create_group'}];
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
          primaryColor: AppColor.primary,
          weakBackgroundColor: AppColor.itemBg,
          secondaryColor:AppColor.itemBg ,
          wideBackgroundColor:AppColor.background,
          weakDividerColor:AppColor.dividerColor,
          darkTextColor: Colors.white,
          weakTextColor: Colors.white60,
          chatMessageItemFromOthersBgColor: AppColor.itemBg),
    );
  }

  void toCreatGoupPage() {
    Get.toNamed(AppPages.CreateGroup, arguments: Map()..['convType'] = GroupTypeForUIKit.public);
  }

  /**
   * @TGS#2Y65HYWLEP woshiliaotian
   */
  Future<void> testAddGroup() async {
    var groupId = '@TGS#2Y65HYWLEP';
    V2TimCallback joinGroupRes = await TencentImSDKPlugin.v2TIMManager.joinGroup(
        groupID: "@TGS#2Y65HYWLEP", // 需要加入群组 ID
        message: "hello", // 加群申请信息
        groupType: "Public"); // 群类型
    if (joinGroupRes.code == 0) {
      // 加入成功
      final conversationID = "group_$groupId";
      final convRes = await TIMUIKitCore.getSDKInstance()
          .getConversationManager()
          .getConversation(conversationID: conversationID);
      if (convRes.code == 0) {
        final conversation = convRes.data ??
            V2TimConversation(conversationID: conversationID, type: 2, groupID: groupId);
        Get.to(ChatPage(selectedConversation: conversation));
        showToast("加入成功");
        //跳转到chatpage
      }
    }
  }

  void toScan(BuildContext context) {
    Get.to(() => ScanPage())?.then((value) {
      flog('sanc value $value');
      if (value == null) {
        return;
      }
      String data = value.toString();
      var map = jsonDecode(data);
      if(map is Map){
        if (map['gid'] != null) {
          ImUtils.joniGroup(context, map['gid'],isNeedReplace: false);
        }
      }
    });
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}
