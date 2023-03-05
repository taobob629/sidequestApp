import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitConversation/tim_uikit_conversation.dart';

import '../messages_page.dart';
import 'chat_page.dart';

class ConversationListPage extends StatelessWidget {
  const ConversationListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: TIMUIKitConversation(onTapItem: (selectedConv) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                selectedConversation: selectedConv,
              ),
            ));
      }),
      floatingActionButton: FloatingActionButton(onPressed: () {
        MessagesPageController.find.configIMTheme();
      }),
    );
  }
}
