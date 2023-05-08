import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/listener_model/tui_group_listener_model.dart';
import 'package:tencent_cloud_chat_uikit/data_services/services_locatar.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

import 'package:tencent_cloud_chat_uikit/ui/utils/screen_utils.dart';
import 'package:wy/ui/common/dialog_confirm.dart';
import 'package:wy/ui/common/floating_button.dart';
import 'package:wy/ui/frame/messages/chat/chat_page.dart';
import 'package:wy/utils/utils.dart';
import 'package:wy/widget/tim_ui/my_tim_uikit_group.dart';

import '../create/create_group_introduction.dart';

class GroupList extends StatelessWidget {
  final sdkInstance = TIMUIKitCore.getSDKInstance();
  final void Function(V2TimGroupInfo groupInfo, V2TimConversation conversation)? onTapItem;

  GroupList({Key? key, this.onTapItem}) : super(key: key);

  _jumpToChatPage(BuildContext context, V2TimGroupInfo groupInfo,
      V2TimConversation conversation) async {
    if (onTapItem != null) {
      onTapItem!(groupInfo, conversation);
    } else {
      final res = await sdkInstance
          .getConversationManager()
          .getConversation(conversationID: "group_${groupInfo.groupID}");
      if (res.code == 0) {
        final conversation = res.data;
        if (conversation != null) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(selectedConversation: conversation),
              ));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    //final theme = Provider.of<DefaultThemeData>(context).theme;

    Widget groupList() {
      return MYTIMUIKitGroup(
        onTapItem: (groupInfo, conversation) {
          _jumpToChatPage(context, groupInfo, conversation);
        },
        onLongPressItem: (groupInfo, conversation) {
          Get.dialog(ConfirmDialog(title: "确定删除", info: "确定删除吗?", onConfirm: () async {
            var result = await TencentImSDKPlugin.v2TIMManager.dismissGroup(
                groupID: groupInfo.groupID);
            if (result.code == 0) {
              final TUIGroupListenerModel _groupListenerModel = serviceLocator<TUIGroupListenerModel>();
              _groupListenerModel.needUpdate=NeedUpdate(groupInfo.groupID, UpdateType.groupInfo);
              Get.back();

            }else{
              flog('222');
            }
          },));
        },
        emptyBuilder: (_) {
          return Center(
            child: Text(TIM_t("暂无群聊")),
          );
        },
        groupCollector: (groupInfo) {
          final groupID = groupInfo?.groupID ?? "";
          return !groupID.contains("im_discuss_");
        },
      );
    }

    return TUIKitScreenUtils.getDeviceWidget(
        desktopWidget: groupList(),
        defaultWidget: Scaffold(
          // appBar: AppBar(
          //     title: Text(
          //       TIM_t("群聊"),
          //       style: const TextStyle(color: Colors.white, fontSize: 17),
          //     ),
          //     shadowColor: Colors.white,
          //     flexibleSpace: Container(
          //       decoration: BoxDecoration(
          //         gradient: LinearGradient(colors: [
          //           CommonColor.lightPrimaryColor,
          //           CommonColor.primaryColor
          //         ]),
          //       ),
          //     ),
          //     iconTheme: const IconThemeData(
          //       color: Colors.white,
          //     )),
          body: groupList(),
          bottomNavigationBar: Padding(
            padding: EdgeInsets.only(left: 80.w, right: 80.w, bottom: 20.h),
            child: FloatingButton(
                label: "+ Create Room".tr,
                colors: [
                  Color(0xFF612AD7),
                  Color(0xFFBE39CC),
                  Color(0xFFE68887),
                ],
                onTap: () =>
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const CreateGroupIntroduction(),
                      ),
                    )),
          ),
        ));
  }
}
