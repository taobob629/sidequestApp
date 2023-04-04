import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_chat_global_model.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:wy/api/im_api.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/config/app_pages.dart';
import 'package:wy/ui/frame/messages/chat/custom_message_view.dart';

import '../../../../model/play_order_detail_model.dart';

class ChatPage extends StatelessWidget {
  final V2TimConversation selectedConversation;
  final String orderSn;

  ChatPage({Key? key, required this.selectedConversation, this.orderSn = ''})
      : super(key: key);

  String? _getConvID() {
    return selectedConversation.type == 1
        ? selectedConversation.userID
        : selectedConversation.groupID;
  }

  PlayOrderDetailModel? playOrderDetailModel;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.6;
    double height = width * 191 / 369;
    double iconHeight = height * 0.5;
    return TIMUIKitChat(
      appBarConfig: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      config: TIMUIKitChatConfig(
        isUseDefaultEmoji: true,
      ),
      morePanelConfig: MorePanelConfig(showFilePickAction: false),
      customStickerPanel: renderCustomStickerPanel,
      conversationID: _getConvID() ?? '',
      // groupID or UserID
      conversationType:
          selectedConversation.type == 1 ? ConvType.c2c : ConvType.group,
      // Conversation type
      conversationShowName: selectedConversation.showName ?? "",
      // Conversation display name
      onTapAvatar: (_) {
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => UserProfile(userID: userID),
        //     ));
      },
      messageItemBuilder: MessageItemBuilder(
          customMessageItemBuilder: (message, isShowJump, clearJump) {
        var data = jsonDecode(message.customElem!.data!);
        var type = data['type'];
        if (type != "play_order" && type != "TopUp_Credit") {
          return Text(
            "Unsupported message type, please update your app!",
            style: TextStyle(fontSize: 12, color: Colors.white24),
          );
        }
        if (data["message"] != null) {
          data = data['message'];
        }
        print(data);
        return GestureDetector(
          onTap: () {
            if (type != "TopUp_Credit") {
              Get.toNamed(AppPages.OrderDetail,
                  arguments: Map()
                    ..['id'] = data['orderId'])
                  ?.whenComplete(() => _getPlayOrder());
            }
          },
          child: Container(
              height: type != "TopUp_Credit" ? height : height + 90.h,
              width: width,
              padding: const EdgeInsets.all(0),
              child: CustomMessageView(
                type: type,
                data: data,
                iconHeight: iconHeight,
                width: width,
              )),
        );
      }),
      conversation:
          selectedConversation, // Callback for the clicking of the message sender profile photo. This callback can be used with `TIMUIKitProfile`.
    );
  }

  _getPlayOrder() {
    ImApi.getCurrentPlayOrderDetail(selectedConversation.userID!, orderSn)
        .then((value) {
      playOrderDetailModel = value;
    });
  }

  Widget renderCustomStickerPanel({
    sendTextMessage,
    sendFaceMessage,
    deleteText,
    addCustomEmojiText,
    addText,
    List<CustomEmojiFaceData> defaultCustomEmojiStickerList = const [],
  }) {
    final defaultEmojiList =
        defaultCustomEmojiStickerList.map((customEmojiPackage) {
      return CustomStickerPackage(
          name: customEmojiPackage.name,
          baseUrl: "assets/custom_face_resource/${customEmojiPackage.name}",
          isEmoji: customEmojiPackage.isEmoji,
          isDefaultEmoji: true,
          stickerList: customEmojiPackage.list
              .asMap()
              .keys
              .map((idx) =>
                  CustomSticker(index: idx, name: customEmojiPackage.list[idx]))
              .toList(),
          menuItem: CustomSticker(
            index: 0,
            name: customEmojiPackage.icon,
          ));
    }).toList();

    return StickerPanel(
      sendTextMsg: sendTextMessage,
      sendFaceMsg: (index, data) =>
          sendFaceMessage(index + 1, (data.split("/")[3]).split("@")[0]),
      deleteText: deleteText,
      addText: addText,
      addCustomEmojiText: addCustomEmojiText,
      backgroundColor: AppColor.itemBg,
      lightPrimaryColor: AppColor.itemBg,
      customStickerPackageList: [...defaultEmojiList],
    );
  }
}
