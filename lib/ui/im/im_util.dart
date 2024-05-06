import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tencent_cloud_chat_uikit/data_services/group/group_services.dart';
import 'package:tencent_cloud_chat_uikit/data_services/services_locatar.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

import '../../config/app_color.dart';
import '../../config/icon_font.dart';
import '../../controller/user_controller.dart';
import '../../model/play_item_model.dart';
import '../../utils/toast_utils.dart';
import '../../utils/utils.dart';
import '../pages/messages/chat/chat_page.dart';
import '../pages/messages/fans/fans_list_page.dart';
import '../pages/social/post/release_post_controller.dart';
import '../pages/social/post/release_post_page.dart';

/**
    author:mac
    创建日期:2023/5/13
    描述:
 */
class ImUtils {
  static Future<void> invite(var params) async {
    var nickName = UserController.find.userProfile.nickName;
    V2TimValueCallback<V2TimMsgCreateInfoResult> createCustomMessageRes =
        await TencentImSDKPlugin.v2TIMManager
            .getMessageManager()
            .createCustomMessage(
              data: json.encode(params),
              desc: '',
              extension: '自定义extension',
            );
    if (createCustomMessageRes.code == 0) {
      //发送消息
      String? id = createCustomMessageRes.data?.id;
      V2TimValueCallback<V2TimMessage> sendMessageRes = await TencentImSDKPlugin
          .v2TIMManager
          .getMessageManager()
          .sendMessage(id: id!, receiver: "UK20021778", groupID: "");
      if (sendMessageRes.code == 0) {
        // 发送成功
      } else {
        showToast('邀请失败,错误码${sendMessageRes.code}');
      }
    } else {
      showToast('邀请失败,错误码${createCustomMessageRes.code}');
    }
  }

  /**
   * 加入群聊
   */
  static Future<void> joniGroup(BuildContext context, var gid,
      {bool isNeedReplace = true}) async {
    V2TimCallback joinGroupRes =
        await TencentImSDKPlugin.v2TIMManager.joinGroup(
      groupID: gid, // 需要加入群组 ID
      message: "hello", // 加群申请信息
    ); // 群类型
    flog('申请加群 $gid ${joinGroupRes.code}');
    if (joinGroupRes.code == 0) {
      // 加入成功
      var conversation = await buildConverFromGid(gid);
      goToChatPage(isNeedReplace, context, conversation);
      showToast("加入成功");
    } else {
      //
      if (joinGroupRes.code == 10013) {
        //已经加入群跳转群聊
        var conversation = await buildConverFromGid(gid);
        goToChatPage(isNeedReplace, context, conversation);
      } else {
        showError(joinGroupRes.desc);
      }
    }
  }

  static void goToChatPage(bool isNeedReplace, BuildContext context,
      V2TimConversation conversation) {
    if (isNeedReplace) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ChatPage(selectedConversation: conversation)));
    } else {
      Get.to(() => ChatPage(selectedConversation: conversation));
    }
  }

  static Future<V2TimConversation> buildConverFromGid(var gid) async {
    final conversationID = "group_$gid";
    final convRes = await TIMUIKitCore.getSDKInstance()
        .getConversationManager()
        .getConversation(conversationID: conversationID);
    if (convRes.code == 0) {
      final conversation = convRes.data ??
          V2TimConversation(
              conversationID: conversationID, type: 2, groupID: gid);
      return conversation;
    } else {
      return V2TimConversation(
          conversationID: conversationID, type: 2, groupID: gid);
    }
  }

  static Future<void> sendGroupCustomMsg(var data, {var gid}) async {
    V2TimValueCallback<V2TimMsgCreateInfoResult> createCustomMessageRes =
        await TencentImSDKPlugin.v2TIMManager
            .getMessageManager()
            .createCustomMessage(
              data: jsonEncode(data),
              desc: "asassaasas",
            );
    if (createCustomMessageRes.code == 0) {
      String? id = createCustomMessageRes.data?.id;
      // 发送自定义消息
      V2TimValueCallback<V2TimMessage> sendMessageRes =
          await TencentImSDKPlugin.v2TIMManager.getMessageManager().sendMessage(
              id: id!!,
              receiver: "",
              groupID: gid,
              isExcludedFromLastMessage: false);
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
      "groupType": GroupType.Public,
      "notification": data['desc']
    }));
  }
}

var actions = [
  AcitionModel('', 'Share to User'.tr, 0),
  AcitionModel('', 'Create Post'.tr, 1),
  // AcitionModel('', 'Join Room'.tr, 2),
];

showShareDialog(V2TimConversation conversation, BuildContext context) {
  Get.bottomSheet(
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...actions
              .map(
                (item) => ListTile(
                    title: RawMaterialButton(
                        onPressed: () {
                          switch (item.type) {
                            case 0:
                              Get.back();
                              FansListPage.to(
                                  gid: conversation.groupID,
                                  groupName: conversation.showName);
                              break;
                            case 1:
                              flog(
                                  'conversation.showName ${conversation.showName}');
                              Get.back();
                              toCreatePostPage(conversation);
                              break;
                            case 2:
                              break;
                          }
                        },
                        child: Text(
                          item.name,
                        ))),
              )
              .toList(),
          20.verticalSpace,
          InkWell(
            child: Text('Cancel'),
            onTap: () => Get.back(),
          ),
          20.verticalSpace
        ],
      ),
      backgroundColor: AppColor.primary,
      enableDrag: false);
}

void toCreatePostPage(V2TimConversation conversation) {
  Get.to(() => ReleasePostPage(),
      arguments: {}
        ..['gid'] = conversation.groupID
        ..['group_name'] = conversation.showName
        ..['type'] = TYPE_INVITE);
}

var gidPrefix = 'SiqdequestGid';
RegExp exp = RegExp(r'SiqdequestGid=([^]*?)=');

buildShareGroupText(var content, var gid) {
  return '$content $gidPrefix=$gid=';
}

decodeGroupGid(var content) {
  RegExpMatch? match = exp.firstMatch(content);
  var gid = match?.group(1) ?? '';
  return gid;
}

Widget buildGroupInviteWidget(BuildContext context, var content, String gid) {
  // RegExpMatch? match = exp.firstMatch(content);
  // var gid = match?.group(1) ?? '';
  flog('gid$gid');
  return RichText(
      text: TextSpan(children: [
    TextSpan(
        text: content,
        style: TextStyle(
            color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
    TextSpan(
        text: ' Join Now '.tr,
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            ImUtils.joniGroup(context, gid, isNeedReplace: false);
          },
        style: TextStyle(
            letterSpacing: 2,
            wordSpacing: 1,
            fontFamily: FONT_MEDIUM,
            decoration: TextDecoration.underline,
            // backgroundColor: Colors.red,
            color: Colors.green,
            fontSize: 14,
            fontWeight: FontWeight.bold)),
  ]));
}

buildShareQr(var gid) {}
