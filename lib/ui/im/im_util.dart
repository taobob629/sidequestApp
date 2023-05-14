import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/separate_models/tui_group_profile_model.dart';
import 'package:tencent_cloud_chat_uikit/data_services/group/group_services.dart';
import 'package:tencent_cloud_chat_uikit/data_services/services_locatar.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:wy/utils/index.dart';
import 'package:wy/utils/toast_utils.dart';
import 'package:provider/provider.dart';
import '../frame/messages/chat/chat_page.dart';

/**
    author:mac
    创建日期:2023/5/13
    描述:
 */
class ImUtils {
  /**
   * 加入群聊
   */
  static Future<void> joniGroup(BuildContext context, var gid,{bool isNeedReplace=true}) async {
    V2TimCallback joinGroupRes = await TencentImSDKPlugin.v2TIMManager.joinGroup(
      groupID: gid, // 需要加入群组 ID
      message: "hello", // 加群申请信息
    ); // 群类型
    flog('申请加群 $gid ${joinGroupRes.code}');
    if (joinGroupRes.code == 0) {
      // 加入成功
      final conversationID = "group_$gid";
      final convRes = await TIMUIKitCore.getSDKInstance()
          .getConversationManager()
          .getConversation(conversationID: conversationID);
      flog('获取会话 ${convRes.code}');
      if (convRes.code == 0) {
        final conversation = convRes.data ??
            V2TimConversation(conversationID: conversationID, type: 2, groupID: gid);
        if(isNeedReplace) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(
                  builder: (context) => ChatPage(selectedConversation: conversation)));
        }else{
          flog('isNeedReplace== $isNeedReplace');
          Get.to(ChatPage(selectedConversation: conversation));
        }
        showToast("加入成功");
        //跳转到chatpage
      } else {
        showError(convRes.desc);
      }
    } else {
      showError(joinGroupRes.desc);
    }
  }

  static Future<void> sendGroupCustomMsg(var data, {var gid}) async {
    V2TimValueCallback<V2TimMsgCreateInfoResult> createCustomMessageRes =
        await TencentImSDKPlugin.v2TIMManager.getMessageManager().createCustomMessage(
              data: jsonEncode(data),
              desc: "asassaasas",
            );
    if (createCustomMessageRes.code == 0) {
      String? id = createCustomMessageRes.data?.id;
      // 发送自定义消息
      V2TimValueCallback<V2TimMessage> sendMessageRes = await TencentImSDKPlugin.v2TIMManager
          .getMessageManager()
          .sendMessage(id: id!!, receiver: "", groupID: gid, isExcludedFromLastMessage: false);
      if (sendMessageRes.code == 0) {
        // 发送成功
        showToast('发送成功');
      } else {
        flog('发送失败 ${sendMessageRes.desc}');
      }

    }
  }

  /**
   * 发送群公告
   */
  static void changeNotification(var data, {var gid}) {
    final GroupServices _groupServices = serviceLocator<GroupServices>();
    _groupServices.setGroupInfo(
        info: V2TimGroupInfo.fromJson({
          "groupID": gid,
          "groupType":GroupType.Public,
          "notification": data['desc']
        }));
  }
}
