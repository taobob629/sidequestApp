import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_chat_global_model.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

class ChatPage extends StatelessWidget {
  final V2TimConversation selectedConversation;
  const ChatPage({Key? key, required this.selectedConversation}) : super(key: key);
  String? _getConvID() {
    return selectedConversation.type == 1 ? selectedConversation.userID : selectedConversation.groupID;
  }

  @override
  Widget build(BuildContext context) {
    return TIMUIKitChat(
      conversationID: _getConvID() ?? '', // groupID or UserID
      conversationType: selectedConversation.type == 1 ? ConvType.c2c : ConvType.group, // Conversation type
      conversationShowName: selectedConversation.showName ?? "", // Conversation displa y name
      onTapAvatar: (_) {
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => UserProfile(userID: userID),
        //     ));
      },
      conversation: selectedConversation, // Callback for the clicking of the message sender profile photo. This callback can be used with `TIMUIKitProfile`.
    );
  }
}
