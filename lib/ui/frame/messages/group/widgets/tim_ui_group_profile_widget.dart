import 'package:flutter/cupertino.dart';
import 'package:tencent_im_base/tencent_im_base.dart';

import 'index.dart';


class TIMUIKitGroupProfileWidget {
  static Widget detailCard(
      {required V2TimGroupInfo groupInfo,

      /// You can deal with updating group name manually, or UIKIt do it automatically.
      Function(String updateGroupName)? updateGroupName}) {
    return GroupProfileDetailCard(
      groupInfo: groupInfo,
      updateGroupName: updateGroupName,
    );
  }

  static Widget memberTile() {
    return GroupMemberTile();
  }

  static Widget groupNotification() {
    return GroupProfileNotification();
  }

  static Widget groupManage() {
    return GroupProfileGroupManage();
  }

  static Widget searchMessage(Function(V2TimConversation?) onJumpToSearch) {
    return GroupProfileGroupSearch(onJumpToSearch: onJumpToSearch);
  }

  static Widget operationDivider() {
    return const SizedBox(
      height: 10,
    );
  }

  static Widget groupType() {
    return GroupProfileType();
  }

  static Widget groupAddOpt() {
    return GroupProfileAddOpt();
  }

  static Widget nameCard() {
    return GroupProfileNameCard();
  }

  static Widget messageDisturb() {
    return GroupMessageDisturb();
  }

  static Widget pinedConversation() {
    return GroupPinConversation();
  }
}
