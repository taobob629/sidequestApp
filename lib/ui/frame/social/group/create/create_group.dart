import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

import 'package:tencent_cloud_chat_uikit/ui/utils/screen_utils.dart';
import 'package:wy/common/base_controller.dart';
import 'package:wy/config/icon_font.dart';
import 'package:wy/model/price_range_model.dart';
import 'package:wy/res/index.dart';
import 'package:wy/ui/common/floating_button.dart';
import 'package:wy/ui/common/input_view.dart';
import 'package:wy/ui/service/skill/skill_item/view.dart';
import 'package:wy/widget/scaffold_widget.dart';

import 'controller.dart';

class CreateGroupPage extends GetView<CreateGroupController> {
  ValueChanged<V2TimConversation>? directToChat;
  final V2TIMManager _sdkInstance = TIMUIKitCore.getSDKInstance();
  List<V2TimFriendInfo> selectedFriendList = [];

  _createSingleConversation() async {
    final userID = selectedFriendList.first.userID;
    final conversationID = "c2c_$userID";
    final res =
        await _sdkInstance.getConversationManager().getConversation(conversationID: conversationID);

    if (res.code == 0) {
      final conversation = res.data;
      if (directToChat != null && conversation != null) {
        directToChat!(conversation);
      } else {
        //   Navigator.pushReplacement(
        //       context,
        //       MaterialPageRoute(
        //           builder: (context) =>
        //               Chat(selectedConversation: conversation!)));
      }
    }
  }

  _getShowName(V2TimFriendInfo item) {
    final friendRemark = item.friendRemark ?? "";
    final nickName = item.userProfile?.nickName ?? "";
    final userID = item.userID;
    final showName = nickName != "" ? nickName : userID;
    return friendRemark != "" ? friendRemark : showName;
  }

  bool _isValidGroupName(String groupName) {
    final List<int> bytes = utf8.encode(groupName);
    return !(bytes.length > 30);
  }

  String _generateGroupName() {
    String groupName = selectedFriendList.map((e) => _getShowName(e)).join(", ");
    if (_isValidGroupName(groupName)) {
      return groupName;
    }

    final option1 = selectedFriendList.length;
    groupName = _getShowName(selectedFriendList[0]) +
        TIM_t_para(" 等{{option1}}人", " 等$option1人")(option1: option1);
    if (_isValidGroupName(groupName)) {
      return groupName;
    }

    final option2 = selectedFriendList.length + 1;
    groupName = _getShowName(selectedFriendList[0]) +
        TIM_t_para("{{option2}}人群", "$option2人群")(option2: option2);
    if (_isValidGroupName(groupName)) {
      return groupName;
    }

    return TIM_t("新群聊");
  }

  _createGroup(String groupType) async {
    String groupName = "test112";
    final groupMember = selectedFriendList.map((e) {
      final role = e.userProfile!.role!;
      GroupMemberRoleTypeEnum roleEnum = GroupMemberRoleTypeEnum.V2TIM_GROUP_MEMBER_UNDEFINED;
      switch (role) {
        case GroupMemberRoleType.V2TIM_GROUP_MEMBER_ROLE_ADMIN:
          roleEnum = GroupMemberRoleTypeEnum.V2TIM_GROUP_MEMBER_ROLE_ADMIN;
          break;
        case GroupMemberRoleType.V2TIM_GROUP_MEMBER_ROLE_MEMBER:
          roleEnum = GroupMemberRoleTypeEnum.V2TIM_GROUP_MEMBER_ROLE_MEMBER;
          break;
        case GroupMemberRoleType.V2TIM_GROUP_MEMBER_ROLE_OWNER:
          roleEnum = GroupMemberRoleTypeEnum.V2TIM_GROUP_MEMBER_ROLE_OWNER;
          break;
        case GroupMemberRoleType.V2TIM_GROUP_MEMBER_UNDEFINED:
          roleEnum = GroupMemberRoleTypeEnum.V2TIM_GROUP_MEMBER_UNDEFINED;
          break;
      }

      return V2TimGroupMember(role: roleEnum, userID: e.userID);
    }).toList();
    final res = await _sdkInstance.getGroupManager().createGroup(
        groupType: groupType,
        groupName: groupName,
        memberList: groupType != GroupType.AVChatRoom ? groupMember : null);
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

  void onSubmit() {
    controller.createGroup();
    return;
    //  if (selectedFriendList.isNotEmpty) {
    switch (controller.convType) {
      case GroupTypeForUIKit.single:
        _createSingleConversation();
        break;
      case GroupTypeForUIKit.chat:
        _createGroup(GroupType.AVChatRoom);
        break;
      case GroupTypeForUIKit.meeting:
        _createGroup(GroupType.Meeting);
        break;
      case GroupTypeForUIKit.work:
        _createGroup(GroupType.Work);
        break;
      case GroupTypeForUIKit.public:
        _createGroup(GroupType.Public);
        break;
    }
    //}
  }

  @override
  Widget build(BuildContext context) {
    // Widget chooseMembers() {
    //   return ContactList(
    //     bgColor: null,
    //     contactList: friendList,
    //     isCanSelectMemberItem: true,
    //     maxSelectNum: widget.convType == GroupTypeForUIKit.single ? 1 : null,
    //     onSelectedMemberItemChange: (selectedMember) {
    //       selectedFriendList = selectedMember;
    //       setState(() {});
    //     },
    //   );
    // }

    var ts1 = TextStyle(fontSize: 14.sp, color: Color(0xFFC5C3C6), fontFamily: FONT_LIGHT);
    return ScaffoldWidget(
      appBar: AppBar(
        title: Text('Create Room'.tr),
      ),
      body: MediaQuery.removePadding(
          removeTop: true,
          context: context,
          child: ListView(
            children: [
              InputView(label: 'Room Name'.tr, tips: 'Enter room name'.tr),
              InputView(
                label: 'Number Limit'.tr,
                tips: 'Enter room name'.tr,
                customInput: Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Number Limit',
                        style: ts1,
                      ),
                      Expanded(
                          child: Container(
                        child: PriceSlider(
                          min: 10,
                          max: 20,
                          value: 15,
                          index: 0,
                          model: PriceRangeModel(gameCoinMax: 20, gameCoinMin: 10),
                        ),
                        height: 45.h,
                      ))
                    ],
                  ),
                  height: 45.h,
                ),
              ),
              InputView(
                label: 'Game name'.tr,
                tips: '',
                customInput: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Number Limit',
                      style: ts1,
                    ),
                    arrowMore(color: Color(0xFFC5C3C6))
                  ],
                ),
              ),
              InputView(
                label: 'Room introduction'.tr,
                autoHeight: true,
                tips: '',
                customInput: TextField(
                  maxLines: 10,
                  maxLength: 120,
                  cursorColor: Colors.white70,
                  textAlign: TextAlign.start,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  onSubmitted: (text) => {},
                  decoration: InputDecoration(
                    hintText: 'Please enter...',
                    counterText: '',
                    hintStyle: inputHint(),
                    border: InputBorder.none,
                    //  contentPadding: EdgeInsets.only(bottom: 8)
                  ),
                ),
              ),
              30.verticalSpace,
              FloatingButton(
                label: 'Create Room',
                onTap: onSubmit,
              )
            ],
          )),
    );
  }
}
