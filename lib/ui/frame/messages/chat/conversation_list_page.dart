import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitConversation/tim_uikit_conversation.dart';
import 'package:wy/ui/frame/messages/chat/chat_tool.dart';
import 'package:wy/utils/index.dart';

import 'chat_page.dart';

class ConversationListPage extends StatelessWidget {
  const ConversationListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: TIMUIKitConversation(
          isShowDraft: false,
          conversationCollector: (conversationItem) {
            /// 专用自定义消息渠道，不显示
            return ChatTool.converFilter(conversationItem?.userID);
          },
          onTapItem: (selectedConv) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatPage(
                    selectedConversation: selectedConv,
                  ),
                ));
          }),
    );
  }
}
