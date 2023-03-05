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
      appBarConfig: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      config: TIMUIKitChatConfig(
        isUseDefaultEmoji: true,
      ),
      morePanelConfig: MorePanelConfig(showFilePickAction: false),
      customStickerPanel: renderCustomStickerPanel,
      conversationID: _getConvID() ?? '', // groupID or UserID
      conversationType: selectedConversation.type == 1 ? ConvType.c2c : ConvType.group, // Conversation type
      conversationShowName: selectedConversation.showName ?? "", // Conversation display name
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

  Widget renderCustomStickerPanel({
    sendTextMessage,
    sendFaceMessage,
    deleteText,
    addCustomEmojiText,
    addText,
    List<CustomEmojiFaceData> defaultCustomEmojiStickerList = const [],
  }) {
    final defaultEmojiList = defaultCustomEmojiStickerList.map((customEmojiPackage) {
      return CustomStickerPackage(
          name: customEmojiPackage.name,
          baseUrl: "assets/custom_face_resource/${customEmojiPackage.name}",
          isEmoji: customEmojiPackage.isEmoji,
          isDefaultEmoji: true,
          stickerList: customEmojiPackage.list.asMap().keys.map((idx) => CustomSticker(index: idx, name: customEmojiPackage.list[idx])).toList(),
          menuItem: CustomSticker(
            index: 0,
            name: customEmojiPackage.icon,
          ));
    }).toList();

    return StickerPanel(
      sendTextMsg: sendTextMessage,
      sendFaceMsg: (index, data) => sendFaceMessage(index + 1, (data.split("/")[3]).split("@")[0]),
      deleteText: deleteText,
      addText: addText,
      addCustomEmojiText: addCustomEmojiText,
      customStickerPackageList: [...defaultEmojiList],
    );
  }
}
