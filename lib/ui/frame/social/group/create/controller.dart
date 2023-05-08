/**
    author:mac
    创建日期:2023/5/7
    描述:
 */
import 'package:flutter/cupertino.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:wy/common/base_controller.dart';
import 'package:get/get.dart';

enum GroupTypeForUIKit { single, work, chat, meeting, public }

class CreateGroupController extends BasePageController {
  GroupTypeForUIKit convType = GroupTypeForUIKit.public;
  ValueChanged<V2TimConversation>? directToChat;
  final V2TIMManager _sdkInstance = TIMUIKitCore.getSDKInstance();
  List<V2TimFriendInfo> friendList = [];

  @override
  void onInit() {
    Map params = Get.arguments;
    convType = params['convType'];
    directToChat = params['directToChat'];
    _getConversationList();
  }

  createGroup() async {
    var groupType;
    switch (convType) {
      case GroupTypeForUIKit.chat:
        groupType = GroupType.AVChatRoom;
        break;
      case GroupTypeForUIKit.meeting:
        groupType = GroupType.Meeting;
        break;
      case GroupTypeForUIKit.work:
        groupType = GroupType.Work;
        break;
      case GroupTypeForUIKit.public:
        groupType = GroupType.Public;
        break;
    }
    String groupName = "test112";
    final res = await _sdkInstance.getGroupManager().createGroup(
          groupType: groupType,
          groupName: groupName,
        );
    if (res.code == 0) {
      final groupID = res.data;
      final conversationID = "group_$groupID";
      if (groupType == "AVChatRoom" && groupID != null) {
        await _sdkInstance.joinGroup(groupID: groupID, message: "Hi");
      }
      final convRes = await _sdkInstance
          .getConversationManager()
          .getConversation(conversationID: conversationID);
      if (convRes.code == 0) {
        final conversation = convRes.data ??
            V2TimConversation(
                conversationID: conversationID,
                type: 2,
                showName: groupName,
                groupType: groupType,
                groupID: groupID);

        if (directToChat != null) {
          directToChat!(conversation);
        } else {
          // Navigator.pushReplacement(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) =>
          //             Chat(selectedConversation: conversation)));
        }
      }
    }
  }

  _getConversationList() async {
    final res = await _sdkInstance.getFriendshipManager().getFriendList();
    if (res.code == 0 && res.data != null) {
      friendList = res.data!;
    }
  }
}
