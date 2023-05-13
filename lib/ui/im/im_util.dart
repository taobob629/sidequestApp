import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:wy/utils/index.dart';
import 'package:wy/utils/toast_utils.dart';

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
  static Future<void> joniGroup(BuildContext context,var gid) async {
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
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ChatPage(selectedConversation: conversation)));
        showToast("加入成功");
        //跳转到chatpage
      } else{
        showError(convRes.desc);
      }
    }else{
      showError(joinGroupRes.desc);
    }
  }
}
