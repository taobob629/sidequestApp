import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_class.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

import 'package:tencent_cloud_chat_uikit/ui/widgets/avatar.dart';

class TIMUIKitProfileWidget extends TIMUIKitClass {
  static Widget operationDivider() {
    return const SizedBox(
      height: 10,
    );
  }

  /// Remarks
  static Widget remarkBar(String remark, Function()? handleTap) {
    return InkWell(
      onTap: () {
        if (handleTap != null) {
          handleTap();
        }
      },
      child: TIMUIKitOperationItem(
        operationName: "备注名".tr,
        operationRightWidget: Text(remark),
      ),
    );
  }

  /// add to block list
  static Widget addToBlackListBar(
      bool value, BuildContext context, Function(bool value)? onChanged) {
    return TIMUIKitOperationItem(
      operationName: "加入黑名单".tr,
      type: "switch",
      operationValue: value,
      onSwitchChange: (value) {
        if (onChanged != null) {
          onChanged(value);
        }
      },
    );
  }

  /// pin the conversation to the top
  static Widget pinConversationBar(
      bool value, BuildContext context, Function(bool value)? onChanged) {
    return TIMUIKitOperationItem(
      operationName: "置顶聊天".tr,
      type: "switch",
      operationValue: value,
      onSwitchChange: (value) {
        if (onChanged != null) {
          onChanged(value);
        }
      },
    );
  }

  /// message disturb
  static Widget messageDisturb(
      BuildContext context, bool isDisturb, Function(bool value)? onChanged) {
    return TIMUIKitOperationItem(
      operationName: "消息免打扰".tr,
      type: "switch",
      operationValue: isDisturb,
      onSwitchChange: (value) {
        if (onChanged != null) {
          onChanged(value);
        }
      },
    );
  }

  static Widget operationItem({
    required String operationName,
    required String type,
    bool? operationValue,
    String? operationText,
    void Function(bool newValue)? onSwitchChange,
  }) {
    return TIMUIKitOperationItem(
      operationName: operationName,
      type: type,
      operationRightWidget: Text(operationText ?? ""),
      operationValue: operationValue,
      onSwitchChange: onSwitchChange,
    );
  }

  /// find history message
  static Widget searchBar(BuildContext context, V2TimConversation conversation,
      {Function()? handleTap}) {
    return InkWell(
      onTap: () {
        if (handleTap != null) {
          handleTap();
        }
      },
      child: TIMUIKitOperationItem(
        operationName: "查找聊天内容".tr,
      ),
    );
  }

  /// portrait
  static Widget portraitBar(Widget portraitWidget) {
    return SizedBox(
      child: TIMUIKitOperationItem(
        operationName: "头像".tr,
        operationRightWidget: portraitWidget,
        showArrowRightIcon: false,
      ),
    );
  }

  /// defaultPortraitWidget
  static Widget defaultPortraitWidget(V2TimUserFullInfo? userInfo) {
    return SizedBox(
      width: 48,
      height: 48,
      child: userInfo != null
          ? Avatar(
              faceUrl: userInfo.faceUrl ?? "",
              showName: userInfo.nickName ?? "",
              type: 1,
            )
          : Container(),
    );
  }

  /// nickname
  static Widget nicknameBar(String nickName) {
    return SizedBox(
      child: TIMUIKitOperationItem(
        showArrowRightIcon: false,
        operationName: "Nick Name".tr,
        operationRightWidget: Text(nickName),
      ),
    );
  }

  /// user account
  static Widget userAccountBar(String userNum) {
    return SizedBox(
      child: TIMUIKitOperationItem(
        showArrowRightIcon: false,
        operationName: "账号".tr,
        operationRightWidget: SelectableText(userNum),
      ),
    );
  }

  /// signature
  static Widget signatureBar(String signature) {
    return SizedBox(
      child: TIMUIKitOperationItem(
        showArrowRightIcon: false,
        operationName: "Signature".tr,
        operationRightWidget: Text(signature),
      ),
    );
  }

  /// gender
  static Widget genderBar(int gender) {
    Map genderMap = {
      0: TIM_t("未填写"),
      1: TIM_t("男"),
      2: TIM_t("女"),
    };
    return SizedBox(
      child: TIMUIKitOperationItem(
        showArrowRightIcon: false,
        operationName: TIM_t("性别"),
        operationRightWidget: Text(genderMap[gender]),
      ),
    );
  }

  /// gender
  static Widget genderBarWithArrow(int gender) {
    Map genderMap = {
      0: "未填写".tr,
      1: 'Male'.tr,
      2:'Female'.tr,
    };
    return SizedBox(
      child: TIMUIKitOperationItem(
        operationName: "Gender".tr,
        operationRightWidget: Text(genderMap[gender]),
      ),
    );
  }

  /// birthday
  static Widget birthdayBar(int? birthday) {
    try {
      final date = DateTime.parse(birthday.toString());
      DateFormat formatter = DateFormat('yyyy-MM-dd');
      return InkWell(
        onTap: () {},
        child: TIMUIKitOperationItem(
          showArrowRightIcon: false,
          operationName: 'Birthday'.tr,
          operationRightWidget: Text(formatter.format(date)),
        ),
      );
    } catch (e) {
      return InkWell(
        onTap: () {},
        child: TIMUIKitOperationItem(
          showArrowRightIcon: false,
          operationName: 'Birthday'.tr,
          operationRightWidget: Text("未填写".tr),
        ),
      );
    }
  }

  /// default button area
  static Widget addAndDeleteArea(
    V2TimFriendInfo friendInfo,
    V2TimConversation conversation,
    int friendType,
    bool isDisturb,
    bool isBlocked,
    TUITheme theme,
    VoidCallback handleAddFriend,
    VoidCallback handleDeleteFriend,
  ) {
    _buildDeleteFriend(V2TimConversation conversation, theme) {
      return InkWell(
        onTap: () {
          handleDeleteFriend();
        },
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
              color: Colors.white,
              border:
                  Border(bottom: BorderSide(color: theme.weakDividerColor))),
          child: Text(
            "清除好友".tr,
            style: TextStyle(color: theme.cautionColor, fontSize: 17),
          ),
        ),
      );
    }

    _buildAddOperation() {
      return Container(
        alignment: Alignment.center,
        // padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
                bottom: BorderSide(
                    color: theme.weakDividerColor ??
                        CommonColor.weakDividerColor))),
        child: Row(children: [
          Expanded(
            child: TextButton(
                child: Text("加为好友".tr,
                    style: TextStyle(color: theme.primaryColor, fontSize: 17)),
                onPressed: () {
                  handleAddFriend();
                }),
          )
        ]),
      );
    }

    return Column(
      children: [
        if (friendType != 0) _buildDeleteFriend(conversation, theme),
        if (friendType == 0 && !isBlocked) _buildAddOperation()
      ],
    );
  }
}
