import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tencent_cloud_chat_uikit/ui/controller/tim_uikit_conversation_controller.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitConversation/tim_uikit_conversation.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/ui/frame/messages/chat/chat_tool.dart';
import 'package:wy/utils/index.dart';

import 'chat_page.dart';

const int type_single_chat = 0;
const int type_group = 1;

class ConversationListPage extends StatelessWidget {
  int type;

  ConversationListPage({Key? key, this.type = type_single_chat}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: TIMUIKitConversation(
          isShowDraft: false,
          conversationCollector: (conversationItem) {
            /// 专用自定义消息渠道，不显示
            return ChatTool.converFilter(conversationItem?.userID, conversationItem?.groupID, type);
          },
          lastMessageBuilder: (lastMsg, groupAtInfoList) {
            if (lastMsg?.customElem?.data != null) {
              var data = jsonDecode(lastMsg!.customElem!.data!);
              return Text(
                data["desc"] ?? "",
                style: TextStyle(color: AppColor.colorB9C9, fontSize: 12),
              );
            }
            return Text(lastMsg?.textElem?.text ?? "",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: AppColor.colorB9C9, fontSize: 12));
          },
          onTapItem: (selectedConv) {
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => ChatPage(
            //         selectedConversation: selectedConv,
            //       ),
            //     ));
            Get.to(() => ChatPage(
                  selectedConversation: selectedConv,
                ));
          }),
    );
  }
}
