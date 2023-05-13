/**
    author:mac
    创建日期:2023/5/7
    描述:
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:wy/api/im_api.dart';
import 'package:wy/common/base_controller.dart';
import 'package:get/get.dart';
import 'package:wy/ui/frame/messages/chat/chat_page.dart';
import 'package:wy/utils/index.dart';

enum GroupTypeForUIKit { single, work, chat, meeting, public }

class CreateGroupController extends BasePageController {
  GroupTypeForUIKit convType = GroupTypeForUIKit.public;
  ValueChanged<V2TimConversation>? directToChat;
  final V2TIMManager _sdkInstance = TIMUIKitCore.getSDKInstance();
  List<V2TimFriendInfo> friendList = [];
  TextEditingController teRoomName = TextEditingController();
  TextEditingController teIntrodution = TextEditingController();
  TextEditingController tePwd = TextEditingController();

  @override
  void onInit() {
    Map params = Get.arguments;
    convType = params['convType'];
    directToChat = params['directToChat'];
    _getConversationList();
  }

  void create() {}

  createGroup(BuildContext context) async {
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
    String groupName = teRoomName.text;
    String desc = teIntrodution.text;
    final res = await _sdkInstance.getGroupManager().createGroup(
        groupType: groupType,
        groupName: groupName,
        introduction: desc,
        addOpt: GroupAddOptTypeEnum.V2TIM_GROUP_ADD_ANY);
    // if (res.code == 0) {
    //   var name = teRoomName.text;
    //   var content = teIntrodution.text;
    //   var pwd = tePwd.text;
    //   var result = ImApi.createGroup(Map()
    //     ..['name'] = name
    //     ..['password'] = pwd
    //     ..['content'] = content);
    //    flog('result$result');
    // }
    if (res.code == 0) {
      final groupID = res.data;
      final conversationID = "group_$groupID";
      final convRes = await _sdkInstance
          .getConversationManager()
          .getConversation(conversationID: conversationID);
      final conversation = convRes.data ??
          V2TimConversation(
              conversationID: conversationID,
              type: 2,
              showName: groupName,
              groupType: groupType,
              groupID: groupID);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => ChatPage(selectedConversation: conversation)));
    }
  }

  _getConversationList() async {
    final res = await _sdkInstance.getFriendshipManager().getFriendList();
    if (res.code == 0 && res.data != null) {
      friendList = res.data!;
    }
  }
}
